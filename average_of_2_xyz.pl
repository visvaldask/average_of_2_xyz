#!/usr/bin/perl -w
# a script to calculate average structure between two xyz structures given in input
# V. Kairys, Life Sciences Center at  Vilnius University
#

use strict;
use warnings;

die "Usage: $0 file1.xyz file2.xyz\n" if(@ARGV!=2);


print STDERR "input files: ";
foreach my $file ( @ARGV ){
    print STDERR "$file ";
}
print STDERR "\n";
my $outfile="average.xyz";

my $atnum=0;
my @atsym=();
my @atx=();
my @aty=();
my @atz=();
my $line1="NA";
my $line2="NA";
foreach my $file (@ARGV){
    open(MOLF,"<$file") or die "Error while opening $file $!\n";
    while(<MOLF>){
        if($. == 1){
            $line1=$_;
            chomp; my @tmp=split;
            print STDERR "file $file, number of atoms $tmp[0]\n";
            $atnum=0;
            unless(exists $atx[$atnum]){
                $atx[$atnum]=0;
                $aty[$atnum]=0;
                $atz[$atnum]=0;
            }
        }elsif($. == 2){
            print STDERR "comment line: $_";
        }else{
            #process atoms
            chomp; my @tmp=split;
            my $nel=@tmp;
            if($nel != 4){
                print "strange atom line: $_";
            }else{
                $atsym[$atnum]=$tmp[0];
                $atx[$atnum]+=$tmp[1];
                $aty[$atnum]+=$tmp[2];
                $atz[$atnum]+=$tmp[3];
                $atnum++;
            }
        }
    }
    close(MOLF);
}
$line2="average of $ARGV[0] and $ARGV[1]\n";
open(OUTF,">$outfile") or die "Error while opening $outfile $!\n";
print OUTF $line1;
print OUTF $line2;
foreach my $i (0 .. $#atsym){
    my $newx=$atx[$i]/2;
    my $newy=$aty[$i]/2;
    my $newz=$atz[$i]/2;
    print OUTF "$atsym[$i] $newx $newy $newz\n";
}
close(OUTF);
print STDERR "the averaged coordinates are in file $outfile\n";

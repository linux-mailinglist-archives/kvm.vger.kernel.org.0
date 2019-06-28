Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4E59D3F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF1Nxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 09:53:31 -0400
Received: from connect.ultra-secure.de ([88.198.71.201]:64721 "EHLO
        connect.ultra-secure.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfF1Nxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 09:53:31 -0400
Received: (Haraka outbound); Fri, 28 Jun 2019 15:51:14 +0200
Authentication-Results: connect.ultra-secure.de; auth=pass (login); spf=none smtp.mailfrom=ultra-secure.de
Received-SPF: None (connect.ultra-secure.de: domain of ultra-secure.de does not designate 127.0.0.10 as permitted sender) receiver=connect.ultra-secure.de; identity=mailfrom; client-ip=127.0.0.10; helo=connect.ultra-secure.de; envelope-from=<rainer@ultra-secure.de>
Received: from connect.ultra-secure.de (webmail [127.0.0.10])
        by connect.ultra-secure.de (Haraka/2.6.2-toaster) with ESMTPSA id 2268CF70-C6A2-4981-9F26-DB2F0C892FEC.1
        envelope-from <rainer@ultra-secure.de> (authenticated bits=0)
        (version=TLSv1/SSLv3 cipher=AES256-SHA verify=NO);
        Fri, 28 Jun 2019 15:51:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Jun 2019 15:51:04 +0200
From:   rainer@ultra-secure.de
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Question about KVM IO performance with FreeBSD as a guest OS
In-Reply-To: <20190628095340.GE3316@stefanha-x1.localdomain>
References: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
 <20190628095340.GE3316@stefanha-x1.localdomain>
Message-ID: <b76013f0d3ed9c3eec92c885734a6534@ultra-secure.de>
X-Sender: rainer@ultra-secure.de
User-Agent: Roundcube Webmail/1.2.0
X-Haraka-GeoIP: --, , NaNkm
X-Haraka-GeoIP-Received: 
X-Haraka-p0f: os="undefined undefined" link_type="undefined" distance=undefined total_conn=undefined shared_ip=Y
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on spamassassin
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.1
X-Haraka-Karma: score: 6, good: 954, bad: 0, connections: 960, history: 954, pass:all_good, relaying
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 2019-06-28 11:53, schrieb Stefan Hajnoczi:
> On Sun, Jun 23, 2019 at 03:46:29PM +0200, Rainer Duffner wrote:
>> I have huge problems running FreeBSD 12 (amd64) as a KVM guest.
>> 
>> KVM is running on Ubuntu 18 LTS, in an OpenStack setup with dedicated 
>> Ceph-Storage (NVMe SSDs).
>> 
>> The VM „flavor" as such is that IOPs are limited to 2000/s - and I do 
>> get those 2k IOPs when I run e.g. CentOS 7.
>> 
>> But on FreeBSD, I get way less.
>> 
>> E.g. running dc3dd to write zeros to a disk, I get 120 MB/s on CentOS 
>> 7.
>> With FreeBSD, I get 9 MB/s.
>> 
>> 
>> The VMs were created on an OpenSuSE 42.3 host with the commands 
>> described here:
>> 
>> https://docs.openstack.org/image-guide/freebsd-image.html
>> 
>> 
>> This mimics the results we got on XenServer, where also some people 
>> reported the same problems but other people had no problems at all.
>> 
>> Feedback from the FreeBSD community suggests that the problem is not 
>> unheard of, but also not universally reproducible.
>> So, I assume it must be some hypervisor misconfiguration?
>> 
>> I’m NOT the administrator of the KVM hosts. I can ask them tomorrow, 
>> though.
>> 
>> I’d like to get some ideas on what to look for on the hosts directly, 
>> if that makes sense.
> 
> Hi Rainer,
> Maybe it's the benchmark.  Can you share the exact command-line you are
> running on CentOS 7 and FreeBSD?
> 
> The blocksize and amount of parallelism (queue depth or number of
> processes/threads) should be identical on CentOS and FreeBSD.  The
> benchmark should open the file with O_DIRECT.  It should not fsync()
> (flush) after every write request.
> 
> If you are using large blocksizes (>256 KB) then perhaps the guest I/O
> stack is splitting them up differently on FreeBSD and Linux.
> 
> Here is a sequential write benchmark using dd:
> 
>   dd if=/dev/zero of=/dev/vdX oflag=direct bs=4k count=1048576
> 
> Stefan




Hi,


on advice from my coworker, I created the image like this:

openstack image create --file ../freebsd-image/freebsd12_v1.41.qcow2 
--disk-format qcow2 --min-disk 6 --min-ram 512 --private --protected 
--property hw_scsi_model=virtio-scsi --property hw_disk_bus=scsi 
--property hw_qemu_guest_agent=yes --property os_distro=freebsd 
--property os_version="12.0" "FreeBSD 12.0 amd 64 take3"


This time, I got a bit better results:


root@rdu5:~ # fio -filename=/srv/test2.fio_test_file -direct=1 -iodepth 
4 -thread -rw=randrw -ioengine=psync -bs=4k -size 8G -numjobs=4 
-runtime=60 -group_reporting -name=pleasehelpme
pleasehelpme: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 
4096B-4096B, ioengine=psync, iodepth=4
...
fio-3.13
Starting 4 threads
pleasehelpme: Laying out IO file (1 file / 8192MiB)
Jobs: 4 (f=4): [m(4)][100.0%][r=1461KiB/s,w=1409KiB/s][r=365,w=352 
IOPS][eta 00m:00s]
pleasehelpme: (groupid=0, jobs=4): err= 0: pid=100120: Fri Jun 28 
15:44:42 2019
   read: IOPS=368, BW=1473KiB/s (1508kB/s)(86.3MiB/60005msec)
     clat (usec): min=8, max=139540, avg=6534.89, stdev=5761.10
      lat (usec): min=13, max=139548, avg=6542.68, stdev=5761.00
     clat percentiles (usec):
      |  1.00th=[   13],  5.00th=[   17], 10.00th=[   25], 20.00th=[ 
1827],
      | 30.00th=[ 3032], 40.00th=[ 4555], 50.00th=[ 5538], 60.00th=[ 
6718],
      | 70.00th=[ 8160], 80.00th=[10290], 90.00th=[13829], 
95.00th=[17433],
      | 99.00th=[25822], 99.50th=[28967], 99.90th=[37487], 
99.95th=[40633],
      | 99.99th=[51643]
    bw (  KiB/s): min=  972, max= 2135, per=97.21%, avg=1430.93, 
stdev=55.37, samples=476
    iops        : min=  242, max=  532, avg=356.10, stdev=13.86, 
samples=476
   write: IOPS=373, BW=1496KiB/s (1532kB/s)(87.6MiB/60005msec)
     clat (usec): min=13, max=46140, avg=4174.36, stdev=2834.86
      lat (usec): min=19, max=46146, avg=4182.13, stdev=2835.08
     clat percentiles (usec):
      |  1.00th=[   40],  5.00th=[   90], 10.00th=[ 1012], 20.00th=[ 
2008],
      | 30.00th=[ 2474], 40.00th=[ 3097], 50.00th=[ 3949], 60.00th=[ 
4555],
      | 70.00th=[ 5145], 80.00th=[ 6063], 90.00th=[ 7439], 95.00th=[ 
9110],
      | 99.00th=[13435], 99.50th=[15401], 99.90th=[20055], 
99.95th=[22152],
      | 99.99th=[36439]
    bw (  KiB/s): min=  825, max= 2295, per=97.26%, avg=1453.99, 
stdev=66.67, samples=476
    iops        : min=  206, max=  572, avg=361.90, stdev=16.66, 
samples=476
   lat (usec)   : 10=0.03%, 20=4.14%, 50=3.47%, 100=2.29%, 250=2.04%
   lat (usec)   : 500=0.06%, 750=0.51%, 1000=0.71%
   lat (msec)   : 2=7.38%, 4=22.88%, 10=44.07%, 20=10.86%, 50=1.55%
   lat (msec)   : 100=0.01%, 250=0.01%
   cpu          : usr=0.11%, sys=2.08%, ctx=83384, majf=0, minf=0
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=22092,22436,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=4

Run status group 0 (all jobs):
    READ: bw=1473KiB/s (1508kB/s), 1473KiB/s-1473KiB/s 
(1508kB/s-1508kB/s), io=86.3MiB (90.5MB), run=60005-60005msec
   WRITE: bw=1496KiB/s (1532kB/s), 1496KiB/s-1496KiB/s 
(1532kB/s-1532kB/s), io=87.6MiB (91.9MB), run=60005-60005msec



Which is more or less half (or a third) of what I got on CentOS.

Still, that's not acceptable for us.

In any case, the documentation on the OpenStack website is outdated at 
best.



Regards
Rainer







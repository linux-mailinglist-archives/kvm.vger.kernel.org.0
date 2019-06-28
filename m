Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27D9598E0
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 12:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF1K63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 06:58:29 -0400
Received: from connect.ultra-secure.de ([88.198.71.201]:52309 "EHLO
        connect.ultra-secure.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF1K63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 06:58:29 -0400
Received: (Haraka outbound); Fri, 28 Jun 2019 12:56:00 +0200
Authentication-Results: connect.ultra-secure.de; auth=pass (login); spf=none smtp.mailfrom=ultra-secure.de
Received-SPF: None (connect.ultra-secure.de: domain of ultra-secure.de does not designate 127.0.0.10 as permitted sender) receiver=connect.ultra-secure.de; identity=mailfrom; client-ip=127.0.0.10; helo=connect.ultra-secure.de; envelope-from=<rainer@ultra-secure.de>
Received: from connect.ultra-secure.de (webmail [127.0.0.10])
        by connect.ultra-secure.de (Haraka/2.6.2-toaster) with ESMTPSA id D005A89B-62A7-4B2E-9817-746BAB0E3188.1
        envelope-from <rainer@ultra-secure.de> (authenticated bits=0)
        (version=TLSv1/SSLv3 cipher=AES256-SHA verify=NO);
        Fri, 28 Jun 2019 12:55:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Jun 2019 12:55:56 +0200
From:   rainer@ultra-secure.de
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Question about KVM IO performance with FreeBSD as a guest OS
In-Reply-To: <20190628095340.GE3316@stefanha-x1.localdomain>
References: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
 <20190628095340.GE3316@stefanha-x1.localdomain>
Message-ID: <530e518a0a1951c6f4dfb6058b3d1e97@ultra-secure.de>
X-Sender: rainer@ultra-secure.de
User-Agent: Roundcube Webmail/1.2.0
X-Haraka-GeoIP: --, , NaNkm
X-Haraka-GeoIP-Received: 
X-Haraka-p0f: os="undefined undefined" link_type="undefined" distance=undefined total_conn=undefined shared_ip=Y
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on spamassassin
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.1
X-Haraka-Karma: score: 6, good: 953, bad: 0, connections: 959, history: 953, pass:all_good, relaying
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


Hi,

you can read more about it here:

https://forums.freebsd.org/threads/is-kvm-virtio-really-that-slow-on-freebsd.71186/


I used

[root@centos ~]# fio -filename=/mnt/test.fio_test_file -direct=1 
-iodepth 4 -thread -rw=randrw -ioengine=psync -bs=4k -size 8G -numjobs=4 
-runtime=60 -group_reporting -name=pleasehelpme


Also on FreeBSD.


FreeBSD's dd doesn't have the oflag=direct option.


We tried the work-around described here:
https://www.cyberciti.biz/faq/slow-performance-issues-of-openbsd-or-freebsd-kvm-guest-on-linux/

But it doesn't really change anything. Most likely, the fixes hinted in 
the mailing-list have already gone into the kernel at this point.

The compute-nodes are running
  4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29 16:28:13 UTC 2019 x86_64 
x86_64 x86_64 GNU/Linux


We saw similar behavior on XenServer 6.5 and real-world performance 
matched the (abysmal) benchmark-results we got.

The "normal" FreeBSD dd does about 1.1MB/s right now.

On my desktop PC (OpenSuSE Leap 42.3) (some i5 6500) with a cheap-ass 
256GB Samsung desktop OEM SSD, I get 55MB/s using the above dd command.

The servers we use are pretty high end SuperMicro servers, with Mellanox 
40GBit cards etc.pp.




Best Regards
Rainer

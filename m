Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A81EA9BC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 04:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfJaDoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 23:44:12 -0400
Received: from new-01-3.privateemail.com ([198.54.122.47]:2533 "EHLO
        NEW-01-3.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfJaDoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 23:44:11 -0400
Received: from MTA-08-1.privateemail.com (unknown [10.20.147.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by NEW-01.privateemail.com (Postfix) with ESMTPS id 380DB60967;
        Thu, 31 Oct 2019 03:44:11 +0000 (UTC)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id 1FCC360051;
        Wed, 30 Oct 2019 23:44:11 -0400 (EDT)
Received: from zetta.local (unknown [10.20.151.205])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id 5684E6004A;
        Thu, 31 Oct 2019 03:44:10 +0000 (UTC)
From:   Derek Yerger <derek@djy.llc>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Bonzini, Paolo" <pbonzini@redhat.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home> <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com>
 <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
 <20191024173212.GC20633@linux.intel.com>
Message-ID: <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
Date:   Wed, 30 Oct 2019 23:44:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191024173212.GC20633@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/24/19 1:32 PM, Sean Christopherson wrote:
> On Thu, Oct 24, 2019 at 11:18:59AM -0400, Derek Yerger wrote:
>> On 10/22/19 4:28 PM, Sean Christopherson wrote:
>>> On Thu, Oct 17, 2019 at 07:57:35PM -0400, Derek Yerger wrote:
>>> Heh, should've checked from the get go...  It's definitely not the memslot
>>> issue, because the memslot bug is in 5.1.16 as well.  :-)
>> I didn't pick up on that, nice catch. The memslot thread was the closest
>> thing I could find to an educated guess.
>>>> I'm stuck on 5.1.x for now, maybe I'll give up and get a dedicated windows
>>>> machine /s
>>> What hardware are you running on?  I was thinking this was AMD specific,
>>> but then realized you said "AMD Radeon 540 GPU" and not "AMD CPU".
>> Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
>>
>> 07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
>> Lexa PRO [Radeon 540/540X/550/550X / RX 540X/550/550X] (rev c7)
>>          Subsystem: Gigabyte Technology Co., Ltd Device 22fe
>>          Kernel driver in use: vfio-pci
>>          Kernel modules: amdgpu
>> (plus related audio device)
>>
>> I can't think of any other data points that would be helpful to solving
>> system instability in a guest OS.
> Can you bisect starting from v5.2?  Identifying which commit in the kernel
> introduced the regression would help immensely.
On the host, I have to install NVIDIA GPU drivers with each new kernel build. 
During the process I discovered that I can't reproduce the issue on any kernel 
if I skip the *host* GPU drivers and start libvirtd in single mode.

I noticed the following in the host kernel log around the time the guest 
encountered BSOD on 5.2.7:

[  337.841491] WARNING: CPU: 6 PID: 7548 at arch/x86/kvm/x86.c:7963 
kvm_arch_vcpu_ioctl_run+0x19b1/0x1b00 [kvm]

I have the rest of the log available if it's needed.

Otherwise the bisection process is: Build/install/run kernel, install host GPU 
drivers, exit single mode, start virt-manager, and do a few things in the guest 
until a crash occurs.

I swapped between Fedora distribution kernel 5.2.7 and 5.1.16 to be sure my test 
was reliably working between good/bad. I then built from tag v5.2.7 and 
confirmed the issue was present. The test failure is indicated by one of BSOD, 
Firefox crash, or tab crash, and reliably happens on the problem kernel but not 
on the good one.

After about 10 steps into bisecting, my tests became less reliable to the point 
that I'm not sure whether to mark my current point @381dc73f as good or bad. I 
had one crash but have been using the guest otherwise reliably for a few days. 
Considering the time it takes to build, install, and test, I didn't want to go 
too far down the wrong path if my tests are unreliable (even though 5.2.7 is a 
guaranteed and timely failure). I'll probably pick it back up over the weekend.

In any event, here is the bisect log up to now:

git bisect start
# bad: [5697a9d3d55fad99ffc3c1ba5654426ab64df333] Linux 5.2.7
git bisect bad 5697a9d3d55fad99ffc3c1ba5654426ab64df333
# good: [8584aaf1c3262ca17d1e4a614ede9179ef462bb0] Linux 5.1.16
git bisect good 8584aaf1c3262ca17d1e4a614ede9179ef462bb0
# good: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
git bisect good e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
# skip: [a2d635decbfa9c1e4ae15cb05b68b2559f7f827c] Merge tag 
'drm-next-2019-05-09' of git://anongit.freedesktop.org/drm/drm
git bisect skip a2d635decbfa9c1e4ae15cb05b68b2559f7f827c
# good: [ee8146aad87cd8eeb5963856ac0b9a9176392e3a] coresight: 
dynamic-replicator: Clean up error handling
git bisect good ee8146aad87cd8eeb5963856ac0b9a9176392e3a
# good: [2e1f164861e500f4e068a9d909bbd3fcc7841483] net: hns: Fix loopback test 
failed at copper ports
git bisect good 2e1f164861e500f4e068a9d909bbd3fcc7841483
# good: [c884d8ac7ffccc094e9674a3eb3be90d3b296c0a] Merge tag 'spdx-5.2-rc6' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/spdx
git bisect good c884d8ac7ffccc094e9674a3eb3be90d3b296c0a
# bad: [1ba0d730c0ca6825225171b74721bc75f3d12da8] bcache: fix potential deadlock 
in cached_def_free()
git bisect bad 1ba0d730c0ca6825225171b74721bc75f3d12da8
# good: [a5fff14a0c7989fbc8316a43f52aed1804f02ddd] Merge branch 'akpm' (patches 
from Andrew)
git bisect good a5fff14a0c7989fbc8316a43f52aed1804f02ddd
# good: [42db12d5cd081964e1844dad1f5f4088921fd303] ice: Gracefully handle reset 
failure in ice_alloc_vfs()
git bisect good 42db12d5cd081964e1844dad1f5f4088921fd303
# good: [161c926ba6f0bb779c0fb860d3cf390eb314d345] perf/x86/intel: Add more 
Icelake CPUIDs
git bisect good 161c926ba6f0bb779c0fb860d3cf390eb314d345
# good: [9a9ff8f128445688f43b9afc1b837a3de4548586] media: coda: increment 
sequence offset for the last returned frame
git bisect good 9a9ff8f128445688f43b9afc1b837a3de4548586
# good: [381dc73f8216252904d6578d7229282029aa430d] netfilter: ctnetlink: Fix 
regression in conntrack entry deletion
git bisect good 381dc73f8216252904d6578d7229282029aa430d

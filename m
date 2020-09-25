Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D837727927F
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgIYUpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:45:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:47349 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgIYUpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 16:45:04 -0400
IronPort-SDR: xEFUoVTYfMM4It91zDKooVCEQkLUg33ZXOOK7oSoUWvHSgRl2znZ4UnF2pQzUHv8HTXJgvm0mt
 8a9YQQEnqJlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="162520234"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="162520234"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 13:24:03 -0700
IronPort-SDR: oJ65aSLCggoBkbd5GAak9J1jvIjzhtI+iwBPYcyQyHCdFGadjygn4fR66pXXKKfgD7iFGJG3XE
 +i63exGPk15A==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="512372713"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 13:24:03 -0700
Date:   Fri, 25 Sep 2020 13:24:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: Which clocksource does KVM use?
Message-ID: <20200925202401.GG31528@linux.intel.com>
References: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 08:06:44AM +0530, Arnabjyoti Kalita wrote:
> I am running QEMU with KVM using the below command line -
> 
> sudo ./qemu-system-x86_64 -m 1024 -machine pc-i440fx-3.0
> -cpu qemu64,-kvmclock -accel kvm -netdev
> tap,id=tap1,ifname=tap0,script=no,downscript=no
> -device virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00
> -drive file=ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
> -device virtio-blk-pci,drive=img-direct
> 
> 
> I can see that the current_clocksource used by the VM that is spawned
> is reported as "tsc".
> 
> /sys/devices/system/clocksource/clocksource0$ cat current_clocksource
> tsc
> 
> I collect a trace of the guest execution using IntelPT after running
> the below command -
> 
> sudo ./perf kvm --guest --guestkallsyms=guest-kallsyms
> --guestmodules=guest-modules
> record -e intel_pt// -m ,65536
> 
> The IntelPT trace reveals that the function "read_hpet" gets called continuously
> while I expected the function "read_tsc" to be called.
> 
> Does KVM change the clocksource in any way?
 
KVM's paravirt clock affects the clocksource, but that's disable in via
"-kvmclock" in your command line.

> I expect the clocksource to be set at boot time, how and why did the
> clocksource change later? Does KVM not support the tsc clocksource ?

QEMU/KVM exposes TSC to the guest, but the Linux kernel's decision on whether
or not to use the TSC as its clocksource isn't exactly straightforward.

At a minimum, the TSC needs to be constant (count at the same rate regardless
of p-state, i.e. core frequency), which is referred to as invtsc by QEMU.  At
a glance, I don't think "-cpu qemu64" advertises support for invtsc.  This can
be forced via "-cpu qemu64,+invtsc", though that may spit out some warnings if
the host CPU itself doesn't have a constant TSC.  You can also override this
in the guest kernel by adding "tsc=reliable" to your kernel params.

C-states are another possible issu.  The kernel will mark the TSC as unstable
if C2 or deeper is supported (and maybe even C1 with MWAIT?) and the TSC isn't
marked as nonstop.  I don't _think_ this is relevant?  QEMU/KVM doesn't
support advertising a nonstop TSC, but I assume QEMU also doesn't advertise C2
or deeper (I've never actually looked), or MONITOR/MWAIT by default.

If the above are ruled out, the kernel can also mark the TSC as unstable and
switch to the HPET for a variety of other reasons.  You can check for this
by grepping for "Marking TSC unstable due to" in the guest kernel logs.

> Note:
> 
> I am using QEMU version 3.0. The guest runs a 4.4.0-116-generic linux kernel.
> Both my qemu host as well as the target architecture is x86_64. The
> host machine is
> also using "tsc" clocksource.
> 
> Best Regards,
> Arnab

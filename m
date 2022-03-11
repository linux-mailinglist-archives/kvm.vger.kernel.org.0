Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662504D6141
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 13:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiCKMLv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 11 Mar 2022 07:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiCKMLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 07:11:50 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F107109A40
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 04:10:46 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4002175D;
        Fri, 11 Mar 2022 04:10:45 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 419533F99C;
        Fri, 11 Mar 2022 04:10:45 -0800 (PST)
Date:   Fri, 11 Mar 2022 12:10:42 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Dongli Si <sidongli1997@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool] x86: Fixed Unable to execute init process since
 glibc version 2.33
Message-ID: <20220311121042.010bbb30@donnerap.cambridge.arm.com>
In-Reply-To: <20220308173125.13130a28@donnerap.cambridge.arm.com>
References: <20220226060048.3-1-sidongli1997@gmail.com>
        <20220308173125.13130a28@donnerap.cambridge.arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Mar 2022 17:31:25 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

Hi,

I did some digging on this issue, see below:

> On Sat, 26 Feb 2022 14:00:48 +0800
> Dongli Si <sidongli1997@gmail.com> wrote:
> 
> Hi,
> 
> > From: Dongli Si <sidongli1997@gmail.com>
> > 
> > glibc detected invalid CPU Vendor name will cause an error:
> > 
> > [    0.450127] Run /sbin/init as init process
> > /lib64/libc.so.6: CPU ISA level is lower than required
> > [    0.451931] Kernel panic - not syncing: Attempted to kill init!
> > exitcode=0x00007f00 [    0.452117] CPU: 0 PID: 1 Comm: init Not
> > tainted 5.17.0-rc1 #72
> > 
> > Signed-off-by: Dongli Si <sidongli1997@gmail.com>
> > ---
> >  x86/cpuid.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/x86/cpuid.c b/x86/cpuid.c
> > index c3b67d9..d58a027 100644
> > --- a/x86/cpuid.c
> > +++ b/x86/cpuid.c
> > @@ -2,6 +2,7 @@
> >  
> >  #include "kvm/kvm.h"
> >  #include "kvm/util.h"
> > +#include "kvm/cpufeature.h"
> >  
> >  #include <sys/ioctl.h>
> >  #include <stdlib.h>
> > @@ -10,7 +11,7 @@
> >  
> >  static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
> >  {
> > -	unsigned int signature[3];
> > +	struct cpuid_regs regs;
> >  	unsigned int i;
> >  
> >  	/*
> > @@ -22,10 +23,13 @@ static void filter_cpuid(struct kvm_cpuid2
> > *kvm_cpuid) switch (entry->function) {
> >  		case 0:
> >  			/* Vendor name */
> > -			memcpy(signature, "LKVMLKVMLKVM", 12);
> > -			entry->ebx = signature[0];
> > -			entry->ecx = signature[1];
> > -			entry->edx = signature[2];
> > +			regs = (struct cpuid_regs) {
> > +				.eax		= 0x00,
> > +			};
> > +			host_cpuid(&regs);
> > +			entry->ebx = regs.ebx;
> > +			entry->ecx = regs.ecx;
> > +			entry->edx = regs.edx;  
> 
> But that's redundant, isn't it? We already get the host vendor ID in the
> three registers in entry, and the current code is just there to overwrite
> this. So just removing the whole "case 0:" part should do the trick.
> 
> Also please be aware that there was a reason for this fixup, as explained
> in commit bc0b99a2a740 ("kvm tools: Filter out CPU vendor string").
> 
So I had a closer look, this is some background:

1) x86 is in the process of stepping up the minimum requirements for the
ISA level, so older x86-64 CPUs might not be supported anymore by some
distros. As a part of this, glibc allows to set a minimum required CPU,
and has a runtime check to verify compatibility:
https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/x86/cpu-features.c;h=514226b37889;hb=HEAD#l398
This routine first checks the vendor string, and only does very basic
capability checks if an unknown vendor (not AMD/Centaur/Intel) is detected.
The AMD manual (APM Vol. 3, 24594 Rev 3.3), CPUID instruction, states:
===============
For AMD processors, the string is AuthenticAMD. This string informs
software that it should follow the AMD CPUID definition for subsequent
CPUID function calls. If the function returns another vendor’s string,
software must use that vendor’s CPUID definition when interpreting
the results of subsequent CPUID function calls.
===============

So kvmtool using "LKVMLKVMLKVM" as the vendor string will probably end up
as detecting only the minimum CPU ISA level, which means glibc's built to
a higher standard will fail, as reported.
On top of that glibc problem the kernel also does various CPU checks, and
will deny features if an unknown vendor is detected. There are already
warnings in the kernel boot log today because of this.

2) The above mentioned kvmtool commit bc0b99a2a740 switched away from
keeping the host's vendor ID, because certain errata workarounds triggered
when the guest saw the host CPU vendor/family/model/stepping values. This
led to random MSR accesses, which KVM could not deal well with at the
time. KVM has improved since, and has code to deal with #GP injections due
to not-emulated MSR accesses. The particular first issue mentioned in the
above commit for instance is addressed by Linux commit d47cc0db8fd6:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d47cc0db8fd6

In general I remember that using random vendor strings was dismissed as a
good idea years ago, and other VMMs and hypervisors tend to inject either
the host's vendor string or at least a well-known value. So any Linux
guest issues due to certain vendor strings would apply to other VMMs or
HVs as well, and are probably fixed already.


So the problem with glibc is out there, and is there to stay. The
algorithm of checking for the vendor string first is correct by the books,
although arguably technically not strictly needed. But we cannot fix this,
so have to deal with it.

> Alex, did you boot this on an AMD box, to spot if this is still an issue?

I gave it a try on an old AMD box similar to the one in mentioned in the
commit message, and it worked fine with the native vendor string.

So I would suggest to just revert kvmtool commit bc0b99a2a740. I will send
a patch to that effect, unless someone objects now.


Cheers,
Andre

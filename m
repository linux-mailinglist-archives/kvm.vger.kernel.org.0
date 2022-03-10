Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523254D46A6
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241943AbiCJMSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241931AbiCJMSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:18:21 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68A3414864B
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:17:19 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E859D1691;
        Thu, 10 Mar 2022 04:17:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 386523FA27;
        Thu, 10 Mar 2022 04:17:18 -0800 (PST)
Date:   Thu, 10 Mar 2022 12:17:41 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Dongli Si <sidongli1997@gmail.com>, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] x86: Fixed Unable to execute init process since
 glibc version 2.33
Message-ID: <YinsZYqYbxH2Kcbq@monolith.localdoman>
References: <20220226060048.3-1-sidongli1997@gmail.com>
 <20220308173125.13130a28@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308173125.13130a28@donnerap.cambridge.arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Mar 08, 2022 at 05:31:25PM +0000, Andre Przywara wrote:
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
> > [    0.451931] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00
> > [    0.452117] CPU: 0 PID: 1 Comm: init Not tainted 5.17.0-rc1 #72
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
> > @@ -22,10 +23,13 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
> >  		switch (entry->function) {
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
> Alex, did you boot this on an AMD box, to spot if this is still an issue?

I did a boot on an AMD Ryzen 3900x, didn't find any issues. But I don't
think a sample of one CPU is representative, so I'm not sure if the error
will not manifest with other models which exist now, or be released in the
future.

From what I can tell, kvmtool doesn't use KVM_X86_SET_MSR_FILTER, and the
default behaviour for KVM is to try to emulate the accesses to the MSRs in
the kernel instead of reflecting them to userspace. So I guess if the user
is running kvmtool on a very new AMD or Intel CPU (one of the CPUs
mentioned in the commit message for the fix was an engineering sample, for
example) for which KVM doesn't have full support, the error can manifest
again.

I'm not sure adding code to emulate a specific CPU is the right solution
for kvmtool. So I'm thinking either use the host CPU and tolerate the KVM
error messages, the frequency of which depends on how fast new MSRs are
added to KVM (I have no clue about that), or choose a very simple CPU model
that can be emulated by a particular version of KVM.

Thoughts?

Thanks,
Alex

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2720A440
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 19:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405674AbgFYRpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 13:45:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:3760 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405267AbgFYRpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 13:45:39 -0400
IronPort-SDR: KrwDKL/v4h43iAik/gCe/WEfFJVyjGlIN5qaR38XSyWN6pDf8rw7MDexk6C6B33My41laEOmIQ
 wbC9bhd+SqSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="145047064"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="145047064"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:45:37 -0700
IronPort-SDR: bisn9uHgNczvefwLPkn56R4MNC63uy3nFlUvwY4ywU1CiWTK8TIWkVhKHaUHDxGRu4zILG2si1
 akggcaHzIq1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="279885429"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2020 10:45:37 -0700
Date:   Thu, 25 Jun 2020 10:45:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200625174537.GE3437@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625162540.GC3437@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 25, 2020 at 09:25:40AM -0700, Sean Christopherson wrote:
> On Thu, Jun 25, 2020 at 10:09:13AM +0200, Paolo Bonzini wrote:
> > On 25/06/20 08:15, Sean Christopherson wrote:
> > > IMO, kvm_cpuid() is simply buggy.  If KVM attempts to access a non-existent
> > > MSR then it darn well should warn.
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 8a294f9747aa..7ef7283011d6 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -1013,7 +1013,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> > >                 *ebx = entry->ebx;
> > >                 *ecx = entry->ecx;
> > >                 *edx = entry->edx;
> > > -               if (function == 7 && index == 0) {
> > > +               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) &&
> > > +                   (vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR)) {
> > >                         u64 data;
> > >                         if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> > >                             (data & TSX_CTRL_CPUID_CLEAR))
> > > 
> > 
> > That works too, but I disagree that warning is the correct behavior
> > here.  It certainly should warn as long as kvm_get_msr blindly returns
> > zero.  However, for a guest it's fine to access a potentially
> > non-existent MSR if you're ready to trap the #GP, and the point of this
> > series is to let cpuid.c or any other KVM code do the same.
> 
> I get the "what" of the change, and even the "why" to some extent, but I
> dislike the idea of supporting/encouraging blind reads/writes to MSRs.
> Blind writes are just asking for problems, and suppressing warnings on reads
> is almost guaranteed to be suppressing a KVM bug.
> 
> Case in point, looking at the TSX thing again, I actually think the fix
> should be:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5eb618dbf211..64322446e590 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1013,9 +1013,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>                 *ebx = entry->ebx;
>                 *ecx = entry->ecx;
>                 *edx = entry->edx;
> -               if (function == 7 && index == 0) {
> +               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) {
>                         u64 data;
> -                       if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> +                       if (!kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data) &&
>                             (data & TSX_CTRL_CPUID_CLEAR))
>                                 *ebx &= ~(F(RTM) | F(HLE));
>                 }
> 
> 
> On VMX, MSR_IA32_TSX_CTRL will be added to the so called shared MSR array
> regardless of whether or not it is being advertised to userspace (this is
> a bug in its own right).  Using the host_initiated variant means KVM will
> incorrectly bypass VMX's ARCH_CAP_TSX_CTRL_MSR check, i.e. incorrectly
> clear the bits if userspace is being weird and stuffed MSR_IA32_TSX_CTRL
> without advertising it to the guest.

Argh, belatedly realized that MSR_IA32_TSX_CTRL needs to be swapped even
when ARCH_CAP_TSX_CTRL_MSR isn't exposed to the guest, but if and only if
if TSX is disabled in the host _and_ enabled in the guest.  So triggering
setup_msrs() on ARCH_CAP_TSX_CTRL_MSR is insufficient, but I believe we can
and should redo setup_msrs() during vmx_cpuid_update().  I'm pretty sure
that's needed for MSR_TSC_AUX+RDTSCP as well.  I suspect RDTSCP is broken
on 32-bit guests, but no has noticed because Linux only employs RDTSCP on
64-bit kernels, and 32-bit guests are exactly common in the first place.

I'll check the above to confirm and prep some patches if RDTSCP is indeed
busted.

> In short, the whole MSR_IA32_TSX_CTRL implementation seems messy and this
> is just papering over that mess.  The correct fix is to invoke setup_msrs()
> on writes to MSR_IA32_ARCH_CAPABILITIES, filtering MSR_IA32_TSX_CTRL out of
> shared MSRs when it's not advertised, and change kvm_cpuid() to use the
> unpriveleged variant.
> 
> TSC_CTRL aside, if we insist on pointing a gun at our foot at some point,
> this should be a dedicated flavor of MSR access, e.g. msr_data.kvm_initiated,
> so that it at least requires intentionally loading the gun.

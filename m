Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86741293454
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 07:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391697AbgJTFih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 01:38:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:20071 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730259AbgJTFig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 01:38:36 -0400
IronPort-SDR: vT5fld99U33EriXE4KR9kXoTGeCTPAP/kME3SRdWYG577ozuTRKbtICbGuPJkaI4L+8ELY7wD5
 01y4pg6lNXXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="154101442"
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="154101442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 22:38:35 -0700
IronPort-SDR: v9/XfDJIvNtVKseTmZmdab4FJ/Uk5g0Y5B38FCBpmCUitHQtodSIL/NJdeOAkeKA+QEoxZP/bw
 eKruGg5VfwRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="347724680"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 19 Oct 2020 22:38:33 -0700
Message-ID: <364312b2e7effbf50d4327c06c61d6157bc08386.camel@linux.intel.com>
Subject: Re: [RFC PATCH 1/9] KVM:x86: Abstract sub functions from
 kvm_update_cpuid_runtime() and kvm_vcpu_after_set_cpuid()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, robert.hu@intel.com
Date:   Tue, 20 Oct 2020 13:38:32 +0800
In-Reply-To: <20200929045649.GM31514@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
         <1596163347-18574-2-git-send-email-robert.hu@linux.intel.com>
         <20200929045649.GM31514@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-28 at 21:56 -0700, Sean Christopherson wrote:
> I think you want "extract", not "abstract".
> 
> 
> On Fri, Jul 31, 2020 at 10:42:19AM +0800, Robert Hoo wrote:
> > Add below functions, whose aggregation equals
> > kvm_update_cpuid_runtime() and
> > kvm_vcpu_after_set_cpuid().
> > 
> > void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
> > static void kvm_pv_unhalt_update_cpuid(struct kvm_vcpu *vcpu)
> > static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
> > static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
> > 
> > And, for some among the above, avoid double check set or clear
> > inside function
> > body, but provided by caller.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 99
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/cpuid.h |  6 ++++
> >  2 files changed, 105 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 7d92854..efa7182 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -73,6 +73,105 @@ static int kvm_check_cpuid(struct kvm_vcpu
> > *vcpu)
> >  	return 0;
> >  }
> >  
> > +void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> 
> I vote that we opportunistically move away from the "best"
> terminology.  Either
> there's a matching entry or there's not.  Using "e" would probably
> shave a few
> lines of code.
> 
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 1, 0);
> > +
> > +	if (best && boot_cpu_has(X86_FEATURE_XSAVE)) {
> 
> Braces not needed. We should also check boot_cpu_has() first, it's
> constant
> time and maybe even in the cache, whereas finding CPUID entries is
> linear
> time and outright slow.
> 
> Actually, can you add a helper to handle this?  With tht
> boot_cpu_has() check
> outside of the helper?  That'll allow the helper to be used for more
> features,
> and will force checking boot_cpu_has() first.  Hmm, and not all of
> the callers
> will need the boot_cpu_has() check, e.g. toggling PKE from
> kvm_set_cr4()
> doesn't need to be guarded because KVM disallows setting PKE if it's
> not
> supported by the host.

Do you mean because in kvm_set_cr4(), it has kvm_valid_cr4(vcpu, cr4)
check first?

Then how about the other 2 callers of kvm_pke_update_cpuid()?
enter_smm() -- I think it can ommit boot_cpu_has() check as well.
because it unconditionally cleared all CR4 bit before calls
kvm_set_cr4().
__set_sregs() -- looks like it doesn't valid host PKE status before
call kvm_pke_update_cpuid(). Can I ommit boot_cpu_has() as well?

So, I don't think kvm_pke_update_cpuid() can leverage the helper. Am I
right?

> 
> static inline void guest_cpuid_change(struct kvm_vcpu *vcpu, u32
> function,
> 				      u32 index, unsigned int feature,
> bool set)
> {
> 	struct kvm_cpuid_entry2 *e =  kvm_find_cpuid_entry(vcpu,
> function, index);
> 
> 	if (e)
> 		cpuid_entry_change(best, X86_FEATURE_OSXSAVE, set);
> }

Thanks Sean, I'm going to have this helper in v2 and have your signed-
off-by.
> 
> > +		cpuid_entry_change(best, X86_FEATURE_OSXSAVE, set);
> > +	}
> > +}
> > +
> > +void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> > +
> > +	if (best && boot_cpu_has(X86_FEATURE_PKU)) {
> > +		cpuid_entry_change(best, X86_FEATURE_OSPKE, set);
> > +	}
> > +}
> > +
> > +void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *best;a
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
> > +	if (!best) {
> > +		vcpu->arch.guest_supported_xcr0 = 0;
> > +	} else {
> > +		vcpu->arch.guest_supported_xcr0 =
> > +			(best->eax | ((u64)best->edx << 32)) &
> > supported_xcr0;
> > +		best->ebx = xstate_required_size(vcpu->arch.xcr0,
> > false);
> > +	}
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> > +	if (!best)
> > +		return;
> > +	if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> > +				cpuid_entry_has(best,
> > X86_FEATURE_XSAVEC))
> 
> Indentation should be aligned, e.g.
> 
> 	if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 	    cpuid_entry_has(best, X86_FEATURE_XSAVEC))
> 
> 
> > +		best->ebx = xstate_required_size(vcpu->arch.xcr0,
> > true);
> > +}
> > +
> > +static void kvm_pv_unhalt_update_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > +	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > +					(best->eax & (1 <<
> > KVM_FEATURE_PV_UNHALT)))
> > +		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> > +}
> > +
> > +void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
> > +	if (best)
> > +		cpuid_entry_change(best, X86_FEATURE_MWAIT, set);
> > +}
> > +
> > +static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
> > +{
> > +
> > +	/* Note, maxphyaddr must be updated before tdp_level. */
> > +	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> > +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
> > +	kvm_mmu_reset_context(vcpu);
> > +}
> > +
> > +void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 1, 0);
> > +	if (!best)
> > +		return;
> > +
> > +	cpuid_entry_change(best, X86_FEATURE_APIC, set);
> > +}
> > +
> > +static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +	struct kvm_lapic *apic = vcpu->arch.apic;
> > +
> > +	best = kvm_find_cpuid_entry(vcpu, 1, 0);
> > +	if (!best)
> > +		return;
> > +
> > +	if (apic) {
> 
> Check apic before the lookup.
> 
> > +		if (cpuid_entry_has(best,
> > X86_FEATURE_TSC_DEADLINE_TIMER))
> > +			apic->lapic_timer.timer_mode_mask = 3 << 17;
> > +		else
> > +			apic->lapic_timer.timer_mode_mask = 1 << 17;
> > +	}
> > +}
> > +
> >  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> >  {

...
> > -- 
> > 1.8.3.1
> > 


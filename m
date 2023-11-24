Return-Path: <kvm+bounces-2393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 119CC7F6C53
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73121B20D64
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 06:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1D98C18;
	Fri, 24 Nov 2023 06:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/sHiK3S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D9AD6E;
	Thu, 23 Nov 2023 22:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700807717; x=1732343717;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KqgTpFydo+QWkaZJI+x7pUz3D2ua6/nmG4hD68KScWA=;
  b=d/sHiK3S3Uf1L6VoZmBn/7JrEyyxH3VJDRmYBrVHhVKG4H9e6nABtsRf
   BeTBdDwYIqynlgE+aCAXFvONZl78iQc5FUFYNK9aj8vL3Idp0dq9n9b/k
   R83mbPqBIeJ9hoC/yFZ6HkSQlU0TVwUyUfCGvgH9ikrRqvOcQXw9Fra4e
   tsRaq8dNhVfeM+E2INKHCkRj8IJ0CUE4NkVXkZDs7JVBHlqXHoIZzvBlu
   PlZ1cGpkokPsof10XLuS65mkK6/pkPEb2L2TKGorVNgPvIdQEpvwx+45x
   psFs4ONFp9aWJmj/iwSrNkvyrlz+Vm7iGfJmZMeWEUkFsqXyB2GeADRZM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="371728384"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="371728384"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 22:35:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="885186104"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="885186104"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2023 22:35:15 -0800
Date: Fri, 24 Nov 2023 14:33:20 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
Message-ID: <ZWBDsOJpdi7hWaYV@yilunxu-OptiPlex-7050>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-7-seanjc@google.com>
 <4484647425e2dbf92c76a173b7b14e346f60362d.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4484647425e2dbf92c76a173b7b14e346f60362d.camel@redhat.com>

On Sun, Nov 19, 2023 at 07:35:30PM +0200, Maxim Levitsky wrote:
> On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > When updating guest CPUID entries to emulate runtime behavior, e.g. when
> > the guest enables a CR4-based feature that is tied to a CPUID flag, also
> > update the vCPU's cpu_caps accordingly.  This will allow replacing all
> > usage of guest_cpuid_has() with guest_cpu_cap_has().
> > 
> > Take care not to update guest capabilities when KVM is updating CPUID
> > entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
> > bogus CPUID information.  No extra call to update cpu_caps is needed as
> > the cpu_caps are initialized from the incoming guest CPUID, i.e. will
> > automatically get the updated values.
> > 
> > Note, none of the features in question use guest_cpu_cap_has() at this
> > time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
> >  1 file changed, 34 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 36bd04030989..37a991439fe6 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
> >  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> >  }
> >  
> > +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> > +						       struct kvm_cpuid_entry2 *entry,
> > +						       unsigned int x86_feature,
> > +						       bool has_feature)
> > +{
> > +	if (entry)
> > +		cpuid_entry_change(entry, x86_feature, has_feature);
> > +
> > +	if (vcpu)
> > +		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> > +}
> > +
> >  static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> >  				       int nent)
> >  {
> >  	struct kvm_cpuid_entry2 *best;
> > +	struct kvm_vcpu *caps = vcpu;
> > +
> > +	/*
> > +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> > +	 * are coming in from userspace!
> > +	 */
> > +	if (entries != vcpu->arch.cpuid_entries)
> > +		caps = NULL;
> 
> I think that this should be decided by the caller. Just a boolean will suffice.

kvm_set_cpuid() calls this function only to validate/adjust the temporary
"entries" variable. While kvm_update_cpuid_runtime() calls it to do system
level changes.

So I kind of agree to make the caller fully awared, how about adding a
newly named wrapper for kvm_set_cpuid(), like:


  static void kvm_adjust_cpuid_entry(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
				     int nent)

  {
	WARN_ON(entries == vcpu->arch.cpuid_entries);
	__kvm_update_cpuid_runtime(vcpu, entries, nent);
  }

> 
> Or even better: since the userspace CPUID update is really not important in terms of performance,
> why to special case it? 
> 
> Even if these guest caps are later overwritten, I don't see why we
> need to avoid updating them, and in fact introduce a small risk of them not being consistent

IIUC, for kvm_set_cpuid() case, KVM may then fail the userspace cpuid setting,
so we can't change guest caps at this phase.

Thanks,
Yilun

> with the other cpu caps.
> 
> With this we can avoid having the 'cap' variable which is *very* confusing as well.
> 
> 
> >  
> >  	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > -	if (best) {
> > -		/* Update OSXSAVE bit */
> > -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> > -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> > +
> > +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
> >  					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
> >  
> > -		cpuid_entry_change(best, X86_FEATURE_APIC,
> > -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> > +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> > +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> >  
> > -		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> > -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> > -					   vcpu->arch.ia32_misc_enable_msr &
> > -					   MSR_IA32_MISC_ENABLE_MWAIT);
> > -	}
> > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
> > +					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);
> >  
> >  	best = cpuid_entry2_find(entries, nent, 7, 0);
> > -	if (best && boot_cpu_has(X86_FEATURE_PKU))
> > -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> > -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > +	if (boot_cpu_has(X86_FEATURE_PKU))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSPKE,
> > +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> >  
> >  	best = cpuid_entry2_find(entries, nent, 0xD, 0);
> >  	if (best)
> > @@ -353,6 +370,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
> >  	 * honor userspace's definition for features that don't require KVM or
> >  	 * hardware management/support (or that KVM simply doesn't care about).
> > +	 *
> > +	 * Note, KVM has already done runtime updates on guest CPUID, i.e. this
> > +	 * will also correctly set runtime features in guest CPU capabilities.
> >  	 */
> >  	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> >  		const struct cpuid_reg cpuid = reverse_cpuid[i];
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 


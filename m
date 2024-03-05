Return-Path: <kvm+bounces-10885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9358A871849
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AA2F281C67
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6BB4EB31;
	Tue,  5 Mar 2024 08:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NM4rPb8f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6718F4EB22;
	Tue,  5 Mar 2024 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709627728; cv=none; b=fNv4HWuW6lp+FGrOj3bkp3LPVNhc9dCU9akQCAb8fo7jbR8nhmFz755NUz7zip02MHugjc1A2IZm3X2zoih3bKNNJiWtE+qSu20fKWbG3gyHICKKTVaZUCm1AZp7KHe4jKGa+57YvYRqLqQh6PyGGNs0BwO4FZsDGjA6Yi0tv40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709627728; c=relaxed/simple;
	bh=Lvdwo8Wjh4EqdeFBZ0MIjbX4qtOpFjCSFMxxVxnEDZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsqGV/WyTafspWg/Zs3Yv6kmIg/GjAW8j9uswjbpRtaagVyMcoXJqoyAYK5jRe/va8s3Ue5RjSopBOgdZagTVwoDDU1hjnt8mqzO4EbPKCxwfgINyCEtVr8D3RCDhlJ32N9ux0+pswAFc85s2tvEa8GySFtKZuJa0etDKL2QJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NM4rPb8f; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709627726; x=1741163726;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lvdwo8Wjh4EqdeFBZ0MIjbX4qtOpFjCSFMxxVxnEDZA=;
  b=NM4rPb8fUKWbtDcsMC9tI//r4azteHqmiwwTlFDbUh3oaKL5PexERlYa
   3UFCwymGUVfg33m8Wyh7zfPTCIwBdTZRQiAgGdzlOgidMfJk4NIH4WCz0
   MyVKFR4/W4wAM9zi5SnlNP+e2NO332gkL/DBy97oh4R0UcgkcvvFU/Rx7
   Ssh87oySrh9+8EvyIPO35QZj86xanQLhXCzlUb1ctVg7P7CY3hkcPxG+A
   R+60dH1a+sVtJEMnkCdF4jrrgxy5o5wyZzXIiVaXnsQqcDtmadtsWiBL4
   lkjG3DPLyqXbS8J9/+itkyeiEfkXNDiRYMUuC3+E/W6KwFgb1ci9LE7Uw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="14881712"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14881712"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:35:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9414347"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:35:24 -0800
Date: Tue, 5 Mar 2024 00:35:24 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 091/130] KVM: TDX: remove use of struct vcpu_vmx from
 posted_interrupt.c
Message-ID: <20240305083524.GE10568@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
 <3b99cf5d-08c7-4ef1-84dd-ebbf246e601f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3b99cf5d-08c7-4ef1-84dd-ebbf246e601f@linux.intel.com>

On Tue, Feb 27, 2024 at 04:52:01PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > As TDX will use posted_interrupt.c, the use of struct vcpu_vmx is a
> > blocker.  Because the members of
> 
> Extra "of"
> 
> > struct pi_desc pi_desc and struct
> > list_head pi_wakeup_list are only used in posted_interrupt.c, introduce
> > common structure, struct vcpu_pi, make vcpu_vmx and vcpu_tdx has same
> > layout in the top of structure.
> > 
> > To minimize the diff size, avoid code conversion like,
> > vmx->pi_desc => vmx->common->pi_desc.  Instead add compile time check
> > if the layout is expected.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/posted_intr.c | 41 ++++++++++++++++++++++++++--------
> >   arch/x86/kvm/vmx/posted_intr.h | 11 +++++++++
> >   arch/x86/kvm/vmx/tdx.c         |  1 +
> >   arch/x86/kvm/vmx/tdx.h         |  8 +++++++
> >   arch/x86/kvm/vmx/vmx.h         | 14 +++++++-----
> >   5 files changed, 60 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index af662312fd07..b66add9da0f3 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -11,6 +11,7 @@
> >   #include "posted_intr.h"
> >   #include "trace.h"
> >   #include "vmx.h"
> > +#include "tdx.h"
> >   /*
> >    * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
> > @@ -31,9 +32,29 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
> >    */
> >   static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
> > +/*
> > + * The layout of the head of struct vcpu_vmx and struct vcpu_tdx must match with
> > + * struct vcpu_pi.
> > + */
> > +static_assert(offsetof(struct vcpu_pi, pi_desc) ==
> > +	      offsetof(struct vcpu_vmx, pi_desc));
> > +static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
> > +	      offsetof(struct vcpu_vmx, pi_wakeup_list));
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +static_assert(offsetof(struct vcpu_pi, pi_desc) ==
> > +	      offsetof(struct vcpu_tdx, pi_desc));
> > +static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
> > +	      offsetof(struct vcpu_tdx, pi_wakeup_list));
> > +#endif
> > +
> > +static inline struct vcpu_pi *vcpu_to_pi(struct kvm_vcpu *vcpu)
> > +{
> > +	return (struct vcpu_pi *)vcpu;
> > +}
> > +
> >   static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> >   {
> > -	return &(to_vmx(vcpu)->pi_desc);
> > +	return &vcpu_to_pi(vcpu)->pi_desc;
> >   }
> >   static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
> > @@ -52,8 +73,8 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
> >   void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >   {
> > -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
> > +	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
> >   	struct pi_desc old, new;
> >   	unsigned long flags;
> >   	unsigned int dest;
> > @@ -90,7 +111,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >   	 */
> >   	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> >   		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > -		list_del(&vmx->pi_wakeup_list);
> > +		list_del(&vcpu_pi->pi_wakeup_list);
> >   		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> >   	}
> > @@ -145,15 +166,15 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
> >    */
> >   static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
> >   {
> > -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
> > +	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
> >   	struct pi_desc old, new;
> >   	unsigned long flags;
> >   	local_irq_save(flags);
> >   	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > -	list_add_tail(&vmx->pi_wakeup_list,
> > +	list_add_tail(&vcpu_pi->pi_wakeup_list,
> >   		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
> >   	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > @@ -190,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
> >   	 * notification vector is switched to the one that calls
> >   	 * back to the pi_wakeup_handler() function.
> >   	 */
> > -	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
> > +	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
> > +		vmx_can_use_vtd_pi(vcpu->kvm);
> >   }
> >   void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> > @@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> >   	if (!vmx_needs_pi_wakeup(vcpu))
> >   		return;
> > -	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> > +	if (kvm_vcpu_is_blocking(vcpu) &&
> > +	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
> >   		pi_enable_wakeup_handler(vcpu);
> >   	/*
> > diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> > index 26992076552e..2fe8222308b2 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.h
> > +++ b/arch/x86/kvm/vmx/posted_intr.h
> > @@ -94,6 +94,17 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
> >   			(unsigned long *)&pi_desc->control);
> >   }
> > +struct vcpu_pi {
> > +	struct kvm_vcpu	vcpu;
> > +
> > +	/* Posted interrupt descriptor */
> > +	struct pi_desc pi_desc;
> > +
> > +	/* Used if this vCPU is waiting for PI notification wakeup. */
> > +	struct list_head pi_wakeup_list;
> > +	/* Until here common layout betwwn vcpu_vmx and vcpu_tdx. */
> 
> s/betwwn/between
> 
> Also, in pi_wakeup_handler(), it is still using struct vcpu_vmx, but it
> could
> be vcpu_tdx.
> Functionally it is OK, however, since you have added vcpu_pi, should it use
> vcpu_pi instead of vcpu_vmx in pi_wakeup_handler()?

Makes sense.

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index b66add9da0f3..5b71aef931dc 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -243,13 +243,13 @@ void pi_wakeup_handler(void)
        int cpu = smp_processor_id();
        struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
        raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
-       struct vcpu_vmx *vmx;
+       struct vcpu_pi *pi;
 
        raw_spin_lock(spinlock);
-       list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
+       list_for_each_entry(pi, wakeup_list, pi_wakeup_list) {
 
-               if (pi_test_on(&vmx->pi_desc))
-                       kvm_vcpu_wake_up(&vmx->vcpu);
+               if (pi_test_on(&pi->pi_desc))
+                       kvm_vcpu_wake_up(&pi->vcpu);
        }

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>


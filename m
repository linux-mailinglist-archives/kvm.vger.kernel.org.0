Return-Path: <kvm+bounces-42131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D921A73A32
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4B1E188D4FE
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067021B043F;
	Thu, 27 Mar 2025 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I8/r+u3L"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D26335964;
	Thu, 27 Mar 2025 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095616; cv=none; b=bKy+zKFJ/0lYZI4eu1+s7rgbOcudta+NjzatjZ9EYpdMBLY6sjHaj/8t8iQado/QZ+G/ro6UCGt3cp3mgvyuVZSR0B6Ia7/EMbXPQzrq3KO4vFCgmywBsJpqMl9sebLwJVrYrP985YUi5NAw15qmRwXmN8hCBGZmuSX5Ck1lPR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095616; c=relaxed/simple;
	bh=0F5hDRGrtH34ZiFv8FHU4LvUue9UPi9JIQv3kr2M8Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS0SnAXd2PuHwnVrDARKBDuCjQPS469hwG1GuIrZis1GHZD5DDFxco7do+KASnXS3nPrur+P3pxN3VnDMbcAHUexLFOAaij8BffJsdqAoad2hGNreOX2GSYotXlfNhJ3/tZgD0KZ349kXq+yDXBwduRqhtnJMdpRXdZCvF6xXYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I8/r+u3L; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 27 Mar 2025 17:13:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743095610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T4vVy2hfIRDZguybe4291Ps0BWWaT7ji3NBdsRJu5BE=;
	b=I8/r+u3LNiMkvufXflcdlzfC5h8JpimuFTL4sAT60ECX00tBtHwZpzm8McvgYkonkIaZ0L
	ECyJLbvwkjEDlgG+ZDHPdqTsRKH0E1Gyr0Au/4nlKOW3Rse5LHkTIvwC9o0+7X3xtIToXW
	8uhJkc3+b403Gkk72aUrJ7ZMSMwUScc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Manali Shukla <manali.shukla@amd.com>, santosh.shukla@amd.com
Subject: Re: [RFC PATCH 01/24] KVM: VMX: Generalize VPID allocation to be
 vendor-neutral
Message-ID: <Z-WHMZPvCNLsXZ_1@google.com>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-2-yosry.ahmed@linux.dev>
 <855xjun3jc.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855xjun3jc.fsf@amd.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 27, 2025 at 10:58:31AM +0000, Nikunj A Dadhania wrote:
> Yosry Ahmed <yosry.ahmed@linux.dev> writes:
> 
> > Generalize the VMX VPID allocation code and make move it to common
> > code
> 
> s/make//
> 
> > in preparation for sharing with SVM. Create a generic struct
> > kvm_tlb_tags, representing a factory for VPIDs (or ASIDs later), and use
> > one for VPIDs.
> >
> > Most of the functionality remains the same, with the following
> > differences:
> > - The enable_vpid checks are moved to the callers for allocate_vpid()
> >   and free_vpid(), as they are specific to VMX.
> > - The bitmap allocation is now dynamic (which will be required for SVM),
> >   so it is initialized and cleaned up in vmx_hardware_{setup/unsetup}().
> > - The range of valid TLB tags is expressed in terms of min/max instead
> >   of the number of tags to support SVM use cases.
> >
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/vmx/nested.c |  4 +--
> >  arch/x86/kvm/vmx/vmx.c    | 38 +++++--------------------
> >  arch/x86/kvm/vmx/vmx.h    |  4 +--
> >  arch/x86/kvm/x86.c        | 58 +++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.h        | 13 +++++++++
> >  5 files changed, 82 insertions(+), 35 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index d06e50d9c0e79..b017bd2eb2382 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -343,7 +343,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
> >  	vmx->nested.vmxon = false;
> >  	vmx->nested.smm.vmxon = false;
> >  	vmx->nested.vmxon_ptr = INVALID_GPA;
> > -	free_vpid(vmx->nested.vpid02);
> > +	kvm_tlb_tags_free(&vmx_vpids, vmx->nested.vpid02);
> >  	vmx->nested.posted_intr_nv = -1;
> >  	vmx->nested.current_vmptr = INVALID_GPA;
> >  	if (enable_shadow_vmcs) {
> > @@ -5333,7 +5333,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
> >  		     HRTIMER_MODE_ABS_PINNED);
> >  	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
> >  
> > -	vmx->nested.vpid02 = allocate_vpid();
> > +	vmx->nested.vpid02 = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
> >  
> >  	vmx->nested.vmcs02_initialized = false;
> >  	vmx->nested.vmxon = true;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b70ed72c1783d..f7ce75842fa26 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -496,8 +496,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
> >   */
> >  static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> >  
> > -static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
> > -static DEFINE_SPINLOCK(vmx_vpid_lock);
> > +struct kvm_tlb_tags vmx_vpids;
> >  
> >  struct vmcs_config vmcs_config __ro_after_init;
> >  struct vmx_capability vmx_capability __ro_after_init;
> > @@ -3972,31 +3971,6 @@ static void seg_setup(int seg)
> >  	vmcs_write32(sf->ar_bytes, ar);
> >  }
> >  
> > -int allocate_vpid(void)
> > -{
> > -	int vpid;
> > -
> > -	if (!enable_vpid)
> > -		return 0;
> > -	spin_lock(&vmx_vpid_lock);
> > -	vpid = find_first_zero_bit(vmx_vpid_bitmap, VMX_NR_VPIDS);
> > -	if (vpid < VMX_NR_VPIDS)
> > -		__set_bit(vpid, vmx_vpid_bitmap);
> > -	else
> > -		vpid = 0;
> > -	spin_unlock(&vmx_vpid_lock);
> > -	return vpid;
> > -}
> > -
> > -void free_vpid(int vpid)
> > -{
> > -	if (!enable_vpid || vpid == 0)
> > -		return;
> > -	spin_lock(&vmx_vpid_lock);
> > -	__clear_bit(vpid, vmx_vpid_bitmap);
> > -	spin_unlock(&vmx_vpid_lock);
> > -}
> > -
> >  static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
> >  {
> >  	/*
> > @@ -7559,7 +7533,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
> >  
> >  	if (enable_pml)
> >  		vmx_destroy_pml_buffer(vmx);
> > -	free_vpid(vmx->vpid);
> > +	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
> >  	nested_vmx_free_vcpu(vcpu);
> >  	free_loaded_vmcs(vmx->loaded_vmcs);
> >  	free_page((unsigned long)vmx->ve_info);
> > @@ -7578,7 +7552,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
> >  
> >  	err = -ENOMEM;
> >  
> > -	vmx->vpid = allocate_vpid();
> > +	vmx->vpid = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
> >  
> >  	/*
> >  	 * If PML is turned on, failure on enabling PML just results in failure
> > @@ -7681,7 +7655,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
> >  free_pml:
> >  	vmx_destroy_pml_buffer(vmx);
> >  free_vpid:
> > -	free_vpid(vmx->vpid);
> > +	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
> >  	return err;
> >  }
> >  
> > @@ -8373,6 +8347,7 @@ void vmx_hardware_unsetup(void)
> >  		nested_vmx_hardware_unsetup();
> >  
> >  	free_kvm_area();
> > +	kvm_tlb_tags_destroy(&vmx_vpids);
> >  }
> >  
> >  void vmx_vm_destroy(struct kvm *kvm)
> > @@ -8591,7 +8566,8 @@ __init int vmx_hardware_setup(void)
> >  	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
> >  	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
> >  
> > -	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
> > +	/* VPID 0 is reserved for host, so min=1  */
> > +	kvm_tlb_tags_init(&vmx_vpids, 1, VMX_NR_VPIDS - 1);
> 
> This needs to handle errors from kvm_tlb_tags_init().
> 
> >  
> >  	if (enable_ept)
> >  		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 951e44dc9d0ea..9bece3ea63eaa 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -376,10 +376,10 @@ struct kvm_vmx {
> >  	u64 *pid_table;
> >  };
> >  
> > +extern struct kvm_tlb_tags vmx_vpids;
> > +
> >  void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> >  			struct loaded_vmcs *buddy);
> > -int allocate_vpid(void);
> > -void free_vpid(int vpid);
> >  void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
> >  void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> >  void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 69c20a68a3f01..182f18ebc62f3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13992,6 +13992,64 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
> >  
> > +int kvm_tlb_tags_init(struct kvm_tlb_tags *tlb_tags, unsigned int min,
> > +		      unsigned int max)
> > +{
> > +	/*
> > +	 * 0 is assumed to be the host's TLB tag and is returned on failed
> > +	 * allocations.
> > +	 */
> > +	if (WARN_ON_ONCE(min == 0))
> > +		return -1;
> 
> Probably -EINVAL ?

Yeah we can use error codes for clarity, thanks.

> 
> > +
> > +	/*
> > +	 * Allocate enough bits to index the bitmap directly by the tag,
> > +	 * potentially wasting a bit of memory.
> > +	 */
> > +	tlb_tags->bitmap = bitmap_zalloc(max + 1, GFP_KERNEL);
> > +	if (!tlb_tags->bitmap)
> > +		return -1;
> 
> -ENOMEM ?
> 
> > +
> > +	tlb_tags->min = min;
> > +	tlb_tags->max = max;
> > +	spin_lock_init(&tlb_tags->lock);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_tlb_tags_init);
> > +
> > +void kvm_tlb_tags_destroy(struct kvm_tlb_tags *tlb_tags)
> > +{
> > +	bitmap_free(tlb_tags->bitmap);
> 
> Do we need to take tlb_tabs->lock here ?

Hmm we could, but I think it's a bug from the caller if they allow
kvm_tlb_tags_destroy() and any of the other functions (init/alloc/free)
to race. kvm_tlb_tags_destroy() should be called when we are done using
the factory.

> 
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_tlb_tags_destroy);
> > +
> > +unsigned int kvm_tlb_tags_alloc(struct kvm_tlb_tags *tlb_tags)
> > +{
> > +	unsigned int tag;
> > +
> > +	spin_lock(&tlb_tags->lock);
> > +	tag = find_next_zero_bit(tlb_tags->bitmap, tlb_tags->max + 1,
> > +				 tlb_tags->min);
> > +	if (tag <= tlb_tags->max)
> > +		__set_bit(tag, tlb_tags->bitmap);
> > +	else
> > +		tag = 0;
> 
> In the event that the KVM runs out of tags, adding WARN_ON_ONCE() here will
> help debugging.

Yeah I wanted to do that, but we do not currently WARN in VMX if we run
out of VPIDs. I am fine with doing adding it if others are. My main
concern was if there's some existing use case that routinely runs out of
VPIDs (although I cannot imagine one).

> 
> Regards
> Nikunj
> 


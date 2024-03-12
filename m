Return-Path: <kvm+bounces-11621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D37878CED
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204C51F21643
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29849468;
	Tue, 12 Mar 2024 02:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPQ+MPWO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83278BFA;
	Tue, 12 Mar 2024 02:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710209729; cv=none; b=ts46SNKMuK7KyGvo6eHL3Smb6BIfjXC3Y51JkWlrmpGnYAJJ7QEOSepOODR7cWsSe1gkBhz2nuQHtvnegXzmG3LHa1QLd0dhcQqgwPkkPnAP1FeGltGVpr0MrtwIPUZ+7ALEA5B6o0DECUI84i6BYNI8f9GsbHxbf/q/o34WDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710209729; c=relaxed/simple;
	bh=IPdZvO7JnV7qtlzHEGT928JrfUh/uHg+FhFjTB+YvZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgAS1ykrUTzQXiRPPN4l4qyzUhF1RsjEEJaFKRWKO1elkMaTHm8P8O1vADV7eAqoN+9530pFaZqBt1D63TCtsYjXckUtTtw84ugJpDE9cE6dO6f2pzdRJnWts6Zz4HKSYZSSeNWlUPHWfribKE1edDae4Ezp0WgKTOLwc3EQboM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPQ+MPWO; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710209727; x=1741745727;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IPdZvO7JnV7qtlzHEGT928JrfUh/uHg+FhFjTB+YvZw=;
  b=CPQ+MPWO7NoAhjuAmWA3mnPcrQg2W0kz9rQL85Ae43+gZJaENt5nBHUb
   DG3mjp8lz5AE5pN87dVBsyPn7JyGxMNTotv39agEy8nDK6se4VFQOguCr
   yp2HO0w9KzP1PPGiX3pjM5AVt7GtiG5BTaQ4iWOduSD+juuFDb9w3OexF
   Ym1kA43y0EcoQYQuX4nbR8ETS3VRORy6ESDe+XszAdVFRNZywQJ5zkKsF
   1/u+qNbnucbNMToWzFXbg30W4mhtn5jUs7PyQjzl5PuWnbCDaUOieN/+0
   zV7qvH/UOWQtxwkzgYEJQfJj2K1xjPb9dcJeR7tST6oFbzBo6Fdqws4qn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5508044"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5508044"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16065500"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:15:25 -0700
Date: Mon, 11 Mar 2024 19:15:24 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Yin, Fengwei" <fengwei.yin@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20240312021524.GG935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
 <aa5359e5-46a3-48d0-b4af-3b812b4c93ae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aa5359e5-46a3-48d0-b4af-3b812b4c93ae@intel.com>

On Mon, Mar 11, 2024 at 01:32:08PM +0800,
"Yin, Fengwei" <fengwei.yin@intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Currently, KVM VMX module initialization/exit functions are a single
> > function each.  Refactor KVM VMX module initialization functions into KVM
> > common part and VMX part so that TDX specific part can be added cleanly.
> > Opportunistically refactor module exit function as well.
> > 
> > The current module initialization flow is,
> > 0.) Check if VMX is supported,
> > 1.) hyper-v specific initialization,
> > 2.) system-wide x86 specific and vendor specific initialization,
> > 3.) Final VMX specific system-wide initialization,
> > 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> > 5.) report those sizes to the KVM common layer and KVM common
> >      initialization
> > 
> > Refactor the KVM VMX module initialization function into functions with a
> > wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> > among VMX and TDX.  Introduce a wrapper function for vmx_init().
> > 
> > The KVM architecture common layer allocates struct kvm with reported size
> > for architecture-specific code.  The KVM VMX module defines its structure
> > as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> > struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> > TDX specific kvm and vcpu structures.
> > 
> > The current module exit function is also a single function, a combination
> > of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> > logic and KVM common logic.  This is just refactoring to keep the VMX
> > specific logic in vmx.c from main.c.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - Eliminate the unnecessary churn with vmx_hardware_setup() by Xiaoyao
> > 
> > v18:
> > - Move loaded_vmcss_on_cpu initialization to vt_init() before
> >    kvm_x86_vendor_init().
> > - added __init to an empty stub fucntion, hv_init_evmcs().
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
> 
> With one minor comment. See below.
> 
> > ---
> >   arch/x86/kvm/vmx/main.c    | 54 ++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/vmx.c     | 60 +++++---------------------------------
> >   arch/x86/kvm/vmx/x86_ops.h | 14 +++++++++
> >   3 files changed, 75 insertions(+), 53 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index eeb7a43b271d..18cecf12c7c8 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -167,3 +167,57 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
> >   	.runtime_ops = &vt_x86_ops,
> >   	.pmu_ops = &intel_pmu_ops,
> >   };
> > +
> > +static int __init vt_init(void)
> > +{
> > +	unsigned int vcpu_size, vcpu_align;
> > +	int cpu, r;
> > +
> > +	if (!kvm_is_vmx_supported())
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > +	 * to unwind if a later step fails.
> > +	 */
> > +	hv_init_evmcs();
> > +
> > +	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> > +	for_each_possible_cpu(cpu)
> > +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > +
> > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > +	if (r)
> > +		return r;
> > +
> > +	r = vmx_init();
> > +	if (r)
> > +		goto err_vmx_init;
> > +
> > +	/*
> > +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> > +	 * exposed to userspace!
> > +	 */
> > +	vcpu_size = sizeof(struct vcpu_vmx);
> > +	vcpu_align = __alignof__(struct vcpu_vmx);
> > +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> > +	if (r)
> > +		goto err_kvm_init;
> > +
> > +	return 0;
> > +
> > +err_kvm_init:
> > +	vmx_exit();
> > +err_vmx_init:
> > +	kvm_x86_vendor_exit();
> > +	return r;
> > +}
> > +module_init(vt_init);
> > +
> > +static void vt_exit(void)
> > +{
> > +	kvm_exit();
> > +	kvm_x86_vendor_exit();
> > +	vmx_exit();
> > +}
> > +module_exit(vt_exit);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 8af0668e4dca..2fb1cd2e28a2 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
> >    * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
> >    * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
> >    */
> > -static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> > +DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> >   static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
> >   static DEFINE_SPINLOCK(vmx_vpid_lock);
> > @@ -537,7 +537,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
> >   	return 0;
> >   }
> > -static __init void hv_init_evmcs(void)
> > +__init void hv_init_evmcs(void)
> >   {
> >   	int cpu;
> > @@ -573,7 +573,7 @@ static __init void hv_init_evmcs(void)
> >   	}
> >   }
> > -static void hv_reset_evmcs(void)
> > +void hv_reset_evmcs(void)
> >   {
> >   	struct hv_vp_assist_page *vp_ap;
> > @@ -597,10 +597,6 @@ static void hv_reset_evmcs(void)
> >   	vp_ap->current_nested_vmcs = 0;
> >   	vp_ap->enlighten_vmentry = 0;
> >   }
> > -
> > -#else /* IS_ENABLED(CONFIG_HYPERV) */
> > -static void hv_init_evmcs(void) {}
> > -static void hv_reset_evmcs(void) {}
> >   #endif /* IS_ENABLED(CONFIG_HYPERV) */
> >   /*
> > @@ -2743,7 +2739,7 @@ static bool __kvm_is_vmx_supported(void)
> >   	return true;
> >   }
> > -static bool kvm_is_vmx_supported(void)
> > +bool kvm_is_vmx_supported(void)
> >   {
> >   	bool supported;
> > @@ -8508,7 +8504,7 @@ static void vmx_cleanup_l1d_flush(void)
> >   	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
> >   }
> > -static void __vmx_exit(void)
> > +void vmx_exit(void)
> >   {
> >   	allow_smaller_maxphyaddr = false;
> > @@ -8517,36 +8513,10 @@ static void __vmx_exit(void)
> >   	vmx_cleanup_l1d_flush();
> >   }
> > -static void vmx_exit(void)
> > -{
> > -	kvm_exit();
> > -	kvm_x86_vendor_exit();
> > -
> > -	__vmx_exit();
> > -}
> > -module_exit(vmx_exit);
> > -
> > -static int __init vmx_init(void)
> > +int __init vmx_init(void)
> >   {
> >   	int r, cpu;
> > -	if (!kvm_is_vmx_supported())
> > -		return -EOPNOTSUPP;
> > -
> > -	/*
> > -	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > -	 * to unwind if a later step fails.
> > -	 */
> > -	hv_init_evmcs();
> > -
> > -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> > -	for_each_possible_cpu(cpu)
> > -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > -
> > -	r = kvm_x86_vendor_init(&vt_init_ops);
> > -	if (r)
> > -		return r;
> > -
> >   	/*
> >   	 * Must be called after common x86 init so enable_ept is properly set
> >   	 * up. Hand the parameter mitigation value in which was stored in
> I am wondering whether the first sentence of above comment should be
> moved to vt_init()? So vt_init() has whole information about the init
> sequence.

If we do so, we should move the call of "vmx_setup_l1d_flush() to vt_init().
I hesitated to remove static of vmx_setup_l1d_flush().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


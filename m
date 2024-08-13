Return-Path: <kvm+bounces-23949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B71794FF3A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD2331C22581
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905051369B6;
	Tue, 13 Aug 2024 08:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I8mNaG3A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC11A19B;
	Tue, 13 Aug 2024 08:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723536018; cv=none; b=l3b+LdnbKsLiZPsUpn1YHIsA1Kp+8X1bk1vxA4ZZSgbwFxT2Cqr+wLnfCwX9CnHS/xWYVIyCvFtsSuEAW2zFoBSAij4q7Vb3ORVhFUpj241WH1hzIVaT7kpFOFhAKcR6Gbb15583tu8RWPGr+JHuzuRCM1eUMWdmKRrs6B8S+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723536018; c=relaxed/simple;
	bh=Uzk9qW9dPz2SU3l4tHnabgf0WCcKTVF0rU1siZi9thk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pn9JRkGbDEvq90PzmEe/N6nLBc4qsuJ8nzOe4O/7JXJPGERAhJQkptb9jCwklqsmrVtNJJAUGbmCGWEOk07C89ZajO5gQ39RsAVSja1fEp+P1QLln3JMmAFfdc0Fn3IwNLMnbSdytrFq0SydiqnRqselJ+N5exo7YffJgRj1les=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I8mNaG3A; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723536017; x=1755072017;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uzk9qW9dPz2SU3l4tHnabgf0WCcKTVF0rU1siZi9thk=;
  b=I8mNaG3AborR9keHbYmrVGlt8GcH3fKtsLnxttF/nRlN2OWUVIPxW+J0
   FvKbzpZ6nqKSGIf683SF0ApKmDutf4oXrBpDmD/HIveSu5Co8rZ0L1wpi
   JcxNRShISRAiW/fKHOqD7WhOO829+Iwt1t9ZjaKa7sIAuWDMFi8DxXUCb
   bFsiqQc6GEVrmjTcoi6pm04gwOEKLUeD8HetAo5xEB/YGFA01hqUgfKb6
   XgRJmRVxf3OX7kW+k8hkN6E4+3hmT3rPtuzTGxT89ix7kPNvWG+mmntn1
   XSs4sxz614prXfh+M//8cahK0G3s91seiwDb5n3We/lGxdzG23H+iCpyw
   Q==;
X-CSE-ConnectionGUID: 8qbz957JTAGcfT7mJ8z5Sg==
X-CSE-MsgGUID: us9Vf7TAQVWMECk1zjeeDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="39129718"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="39129718"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 01:00:16 -0700
X-CSE-ConnectionGUID: UpUN4OSwSc2xZ2S7cd7paQ==
X-CSE-MsgGUID: 6jKsb5v6QTKURxBKf/ag+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="59331337"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa008.jf.intel.com with ESMTP; 13 Aug 2024 01:00:11 -0700
Date: Tue, 13 Aug 2024 16:00:09 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-19-rick.p.edgecombe@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Aug 12, 2024 at 03:48:13PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TD guest vcpu needs TDX specific initialization before running.  Repurpose
> KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
> KVM_TDX_INIT_VCPU, and implement the callback for it.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>  - Support FEATURES0_TOPOLOGY_ENUM
>  - Update for the wrapper functions for SEAMCALLs. (Sean)
>  - Remove WARN_ON_ONCE() in tdx_vcpu_free().
>    WARN_ON_ONCE(vcpu->cpu != -1), WARN_ON_ONCE(tdx->tdvpx_pa),
>    WARN_ON_ONCE(tdx->tdvpr_pa)
>  - Remove KVM_BUG_ON() in tdx_vcpu_reset().
>  - Remove duplicate "tdx->tdvpr_pa=" lines
>  - Rename tdvpx to tdcx as it is confusing, follow spec change for same
>    reason (Isaku)
>  - Updates from seamcall overhaul (Kai)
>  - Rename error->hw_error
>  - Change using tdx_info to using exported 'tdx_sysinfo' pointer in
>    tdx_td_vcpu_init().
>  - Remove code to the old (non-existing) tdx_module_setup().
>  - Use a new wrapper tdx_sysinfo_nr_tdcx_pages() to replace
>    tdx_info->nr_tdcx_pages.
>  - Combine the two for loops in tdx_td_vcpu_init() (Chao)
>  - Add more line breaks into tdx_td_vcpu_init() for readability (Tony)
>  - Drop Drop local tdcx_pa in tdx_td_vcpu_init() (Rick)
>  - Drop Drop local tdvpr_pa in tdx_td_vcpu_init() (Rick)
>
> v18:
>  - Use tdh_sys_rd() instead of struct tdsysinfo_struct.
>  - Rename tdx_reclaim_td_page() => tdx_reclaim_control_page()
>  - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   1 +
>  arch/x86/include/asm/kvm_host.h    |   1 +
>  arch/x86/include/uapi/asm/kvm.h    |   1 +
>  arch/x86/kvm/vmx/main.c            |   9 ++
>  arch/x86/kvm/vmx/tdx.c             | 193 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h             |   6 +
>  arch/x86/kvm/vmx/tdx_arch.h        |   2 +
>  arch/x86/kvm/vmx/x86_ops.h         |   4 +
>  arch/x86/kvm/x86.c                 |   6 +
>  9 files changed, 221 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 12ee66bc9026..5dd7955376e3 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -126,6 +126,7 @@ KVM_X86_OP(enable_smi_window)
>  #endif
>  KVM_X86_OP_OPTIONAL(dev_get_attr)
>  KVM_X86_OP(mem_enc_ioctl)
> +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 188cd684bffb..e3094c843556 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1829,6 +1829,7 @@ struct kvm_x86_ops {
>
>  	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 95ae2d4a4697..b4f12997052d 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -930,6 +930,7 @@ struct kvm_hyperv_eventfd {
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
>  	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>
>  	KVM_TDX_CMD_NR_MAX,
>  };
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d40de73d2bd3..e34cb476cc78 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -116,6 +116,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	return tdx_vm_ioctl(kvm, argp);
>  }
>
> +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	if (!is_td_vcpu(vcpu))
> +		return -EINVAL;
> +
> +	return tdx_vcpu_ioctl(vcpu, argp);
> +}
> +
>  #define VMX_REQUIRED_APICV_INHIBITS				\
>  	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
>  	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> @@ -268,6 +276,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.get_untagged_addr = vmx_get_untagged_addr,
>
>  	.mem_enc_ioctl = vt_mem_enc_ioctl,
> +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
>  };
>
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 18738cacbc87..ba7b436fae86 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -89,6 +89,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
>  }
>
> +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> +{
> +	return tdx->td_vcpu_created;
> +}
> +
>  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
>  {
>  	return kvm_tdx->tdr_pa;
> @@ -105,6 +110,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
>  	return kvm_tdx->hkid > 0;
>  }
>
> +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->finalized;
> +}
> +
>  static void tdx_clear_page(unsigned long page_pa)
>  {
>  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -293,6 +303,15 @@ static inline u8 tdx_sysinfo_nr_tdcs_pages(void)
>  	return tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
>  }
>
> +static inline u8 tdx_sysinfo_nr_tdcx_pages(void)

tdx_sysinfo_nr_tdcx_pages() is very similar to
tdx_sysinfo_nr_tdcs_pages() which is introduced in patch 13.

It's easy to use either of them in wrong place and hard to
review, these 2 functions have same signature so compiler
has no way to prevent us from using them incorrectly.
TDX 1.5 spec defines these additional pages for TD and vCPU to
"TDCX" pages, so how about we name them like:

u8 tdx_sysinfo_nr_td_tdcx_pages(void);
u8 tdx_sysinfo_nr_vcpu_tdcx_pages(void);

Above name matchs spec more, and easy to distinguish and review.

> +{
> +	/*
> +	 * TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages).
> +	 * -1 for TDVPR.
> +	 */
> +	return tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
> +}
> +
>  void tdx_vm_free(struct kvm *kvm)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -405,7 +424,29 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  {
> -	/* This is stub for now.  More logic will come. */
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int i;
> +
> +	/*
> +	 * This methods can be called when vcpu allocation/initialization
> +	 * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
> +	 * yet.
> +	 */

IIUC leaking tdcx_pa/tdvpr_pa shuold happen only when
failure of freeing hkid. How about change above to real
reason or just remove them ?

> +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> +		return;
> +
> +	if (tdx->tdcx_pa) {
> +		for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> +			if (tdx->tdcx_pa[i])
> +				tdx_reclaim_control_page(tdx->tdcx_pa[i]);
> +		}
> +		kfree(tdx->tdcx_pa);
> +		tdx->tdcx_pa = NULL;
> +	}
> +	if (tdx->tdvpr_pa) {
> +		tdx_reclaim_control_page(tdx->tdvpr_pa);
> +		tdx->tdvpr_pa = 0;
> +	}
>  }
>
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -414,8 +455,13 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	/* Ignore INIT silently because TDX doesn't support INIT event. */
>  	if (init_event)
>  		return;
> +	if (is_td_vcpu_created(to_tdx(vcpu)))
> +		return;
>
> -	/* This is stub for now. More logic will come here. */
> +	/*
> +	 * Don't update mp_state to runnable because more initialization
> +	 * is needed by TDX_VCPU_INIT.
> +	 */
>  }
>
>  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> @@ -884,6 +930,149 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	return r;
>  }
>
> +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> +{
> +	const struct tdx_sysinfo_module_info *modinfo = &tdx_sysinfo->module_info;
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	if (is_td_vcpu_created(tdx))
> +		return -EINVAL;
> +
> +	/*
> +	 * vcpu_free method frees allocated pages.  Avoid partial setup so
> +	 * that the method can't handle it.
> +	 */

This looks not that clear, why vcpu_free can't handle it is not explained.

Looking the whole function, page already added into TD by
SEAMCALL should be cleared before free back to kernel,
tdx_vcpu_free() can handle them. Other pages can be freed
directly and can't be handled by tdx_vcpu_free() because
they're not added into TD. Is this right understanding ?

> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		return -ENOMEM;
> +	tdx->tdvpr_pa = __pa(va);
> +
> +	tdx->tdcx_pa = kcalloc(tdx_sysinfo_nr_tdcx_pages(), sizeof(*tdx->tdcx_pa),
> +			   GFP_KERNEL_ACCOUNT);
> +	if (!tdx->tdcx_pa) {
> +		ret = -ENOMEM;
> +		goto free_tdvpr;
> +	}
> +
> +	err = tdh_vp_create(tdx);
> +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> +		tdx->tdvpr_pa = 0;

This leaks the tdx->tdvpr_pa in case of no VP is created.
Any reason for this ?

> +		ret = -EIO;
> +		pr_tdx_error(TDH_VP_CREATE, err);
> +		goto free_tdvpx;
> +	}
> +
> +	for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va) {
> +			ret = -ENOMEM;
> +			goto free_tdvpx;

It's possible that some pages already added into TD by
tdh_vp_addcx() below and they won't be handled by
tdx_vcpu_free() if goto free_tdvpx here;

> +		}
> +		tdx->tdcx_pa[i] = __pa(va);
> +
> +		err = tdh_vp_addcx(tdx, tdx->tdcx_pa[i]);
> +		if (KVM_BUG_ON(err, vcpu->kvm)) {
> +			pr_tdx_error(TDH_VP_ADDCX, err);
> +			/* vcpu_free method frees TDCX and TDR donated to TDX */
> +			return -EIO;
> +		}
> +	}
> +
> +	if (modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
> +		err = tdh_vp_init_apicid(tdx, vcpu_rcx, vcpu->vcpu_id);

This can cause incorrect topology information to guest
silently:

A user space VMM uses "-smp 8,threads=4,cores=2" but doesn't
pass any 0x1f leaf data to KVM, means no 0x1f value to TDX
module for this TD. The topology TD guest observed is:

Thread(s) per core:                 2
Core(s) per socket:                 4

I suggest to use tdh_vp_init_apicid() only when 0x1f is
valid. This will disable the 0x1f/0xb topology feature per
the spec, but leaf 0x1/0x4 still are available to present
right topology in this example. It presents correct topology
information to guest if user space VMM doesn't use 0x1f for
simple topology and run on TDX module w/ FEATURES0_TOPOLOGY.

> +	else
> +		err = tdh_vp_init(tdx, vcpu_rcx);
> +
> +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> +		pr_tdx_error(TDH_VP_INIT, err);
> +		return -EIO;
> +	}
> +
> +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +	tdx->td_vcpu_created = true;
> +
> +	return 0;
> +
> +free_tdvpx:

How about s/free_tdvpx/free_tdcx

In 1.5 TDX spec these pages are all called TDCX pages, and
the function context already indicates that we're talking about
vcpu's TDCX pages.

> +	for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> +		if (tdx->tdcx_pa[i])
> +			free_page((unsigned long)__va(tdx->tdcx_pa[i]));
> +		tdx->tdcx_pa[i] = 0;
> +	}
> +	kfree(tdx->tdcx_pa);
> +	tdx->tdcx_pa = NULL;
> +
> +free_tdvpr:
> +	if (tdx->tdvpr_pa)
> +		free_page((unsigned long)__va(tdx->tdvpr_pa));
> +	tdx->tdvpr_pa = 0;
> +
> +	return ret;
> +}
> +
> +static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> +{
> +	struct msr_data apic_base_msr;
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int ret;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +	if (tdx->initialized)
> +		return -EINVAL;
> +
> +	/*
> +	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
> +	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
> +	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
> +	 */
> +	apic_base_msr = (struct msr_data) {
> +		.host_initiated = true,
> +		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
> +		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
> +	};
> +	if (kvm_set_apic_base(vcpu, &apic_base_msr))
> +		return -EINVAL;
> +
> +	ret = tdx_td_vcpu_init(vcpu, (u64)cmd->data);
> +	if (ret)
> +		return ret;
> +
> +	tdx->initialized = true;
> +	return 0;
> +}
> +
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct kvm_tdx_cmd cmd;
> +	int ret;
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if (cmd.hw_error)
> +		return -EINVAL;
> +
> +	switch (cmd.id) {
> +	case KVM_TDX_INIT_VCPU:
> +		ret = tdx_vcpu_init(vcpu, &cmd);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  #define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>
>  static int __init setup_kvm_tdx_caps(void)
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca948f26b755..8349b542836e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -22,6 +22,8 @@ struct kvm_tdx {
>  	u64 xfam;
>  	int hkid;
>
> +	bool finalized;
> +
>  	u64 tsc_offset;
>  };
>
> @@ -29,6 +31,10 @@ struct vcpu_tdx {
>  	struct kvm_vcpu	vcpu;
>
>  	unsigned long tdvpr_pa;
> +	unsigned long *tdcx_pa;
> +	bool td_vcpu_created;
> +
> +	bool initialized;
>
>  	/*
>  	 * Dummy to make pmu_intel not corrupt memory.
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 413619dd92ef..d2d7f9cab740 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -155,4 +155,6 @@ struct td_params {
>  #define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
>  #define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
>
> +#define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
> +
>  #endif /* __KVM_X86_TDX_ARCH_H */
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index e1d3276b0f60..55fd17fbfd19 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -129,6 +129,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  #else
>  static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  {
> @@ -143,6 +145,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +
> +static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9cee326f5e7a..3d43fa84c2b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6314,6 +6314,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_DEVICE_ATTR:
>  		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
>  		break;
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -ENOTTY;
> +		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
> +			goto out;
> +		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
> +		break;
>  	default:
>  		r = -EINVAL;
>  	}
> --
> 2.34.1
>
>


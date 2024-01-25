Return-Path: <kvm+bounces-6976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1352183BB11
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD372284BB3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 07:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772EC13FF2;
	Thu, 25 Jan 2024 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7QAj6sA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A7E13AC4;
	Thu, 25 Jan 2024 07:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706169422; cv=none; b=aOy5BUqPRfkL0+3aieboT1YwsHVzys52GrLVPiSfU3pnFp1WhVx14FMN+5EZIZmbcezk2TyJFdRcNk2auSOFLJEns2K9yeqwPhZ6zZHjDYi1cVFTkrNx7Rwn5M+qTf1U+xtmFAtp8EGUZ5mhOFyCJcLrYJ5c4luwu2hPgv8IEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706169422; c=relaxed/simple;
	bh=RdWXXkxT4NiTVaUWxsBw4QjuvILmiGOpex/ku3fC9+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iswNTOW1XlcO/WIokg/pAW01zDLOfVUdOmhwDJVdYMu6H5NsXb3rvC/0BfJaDLta36gMnciLSYLkhojqsbG9nJDrxuEPQUG4fal/TbnC87nbYRdDbp9x4DdfEv7UUo8rpQ0ZHAsv+FKnl3HFbzpqDRCTjGc+G++YS+3oj4+omUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7QAj6sA; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706169421; x=1737705421;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RdWXXkxT4NiTVaUWxsBw4QjuvILmiGOpex/ku3fC9+o=;
  b=l7QAj6sA/W4g74/INgn0s8FvR8jf0iMmmb+LOdHYO6Y07fe0rSLaSqkG
   +aYWFneok+dOnDlrk+bE2CIUIMEILWtqnYl6vcrUKN59KCFZHX9/R3B8g
   +3Q4fczCq7viPWYrZXrcKdI3EYJygqd+fLMCWZVnzMrJiVnvjZjqyJCCC
   yNUIm/OKHf1ULd8FsH3u2Sc/uo39jN96nnODIhYnv5RZott/rw58fM0Qc
   R6XP0lcIoconWhWexB1bNgd+K/m7obOfCDEb4gAcThUGpdmTHaAQ1zY9Q
   ucUyg1F8woPd1KIy4dn8UX4l/t3IgMnIMH+qUn9G1nbVq9WGa8TiVJLKQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9471530"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9471530"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 23:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="959771192"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="959771192"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 23:56:55 -0800
Message-ID: <f3321756-95f1-4532-b1de-42b334b684ba@linux.intel.com>
Date: Thu, 25 Jan 2024 15:56:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 030/121] KVM: TDX: Do TDX specific vcpu initialization
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <9ac6ab3979a477d4a40e0655208248b70bb43ebb.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9ac6ab3979a477d4a40e0655208248b70bb43ebb.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TD guest vcpu needs TDX specific initialization before running.  Repurpose
> KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
> KVM_TDX_INIT_VCPU, and implement the callback for it.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - Use tdh_sys_rd() instead of struct tdsysinfo_struct.
> - Rename tdx_reclaim_td_page() => tdx_reclaim_control_page()
> - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   1 +
>   arch/x86/include/asm/kvm_host.h    |   1 +
>   arch/x86/include/uapi/asm/kvm.h    |   1 +
>   arch/x86/kvm/vmx/main.c            |   9 ++
>   arch/x86/kvm/vmx/tdx.c             | 184 ++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h             |   8 ++
>   arch/x86/kvm/vmx/x86_ops.h         |   4 +
>   arch/x86/kvm/x86.c                 |   6 +
>   8 files changed, 211 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 1b8fe1502bde..cfa505dd7a98 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -129,6 +129,7 @@ KVM_X86_OP(leave_smm)
>   KVM_X86_OP(enable_smi_window)
>   #endif
>   KVM_X86_OP(mem_enc_ioctl)
> +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
>   KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>   KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>   KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ba68f63958db..b54e0bdb77eb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1776,6 +1776,7 @@ struct kvm_x86_ops {
>   #endif
>   
>   	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
>   	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9ac0246bd974..4000a2e087a8 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -571,6 +571,7 @@ struct kvm_pmu_event_filter {
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
>   	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c2f1dc2000c5..de4b6f924a36 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -146,6 +146,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	return tdx_vm_ioctl(kvm, argp);
>   }
>   
> +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	if (!is_td_vcpu(vcpu))
> +		return -EINVAL;
> +
> +	return tdx_vcpu_ioctl(vcpu, argp);
> +}
> +
>   #define VMX_REQUIRED_APICV_INHIBITS				\
>   	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
>   	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> @@ -305,6 +313,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.get_untagged_addr = vmx_get_untagged_addr,
>   
>   	.mem_enc_ioctl = vt_mem_enc_ioctl,
> +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
>   };
>   
>   struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8330f448ab8e..245be29721b4 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -93,6 +93,7 @@ struct tdx_info {
>   	u64 xfam_fixed1;
>   
>   	u8 nr_tdcs_pages;
> +	u8 nr_tdvpx_pages;
>   
>   	u16 num_cpuid_config;
>   	/* This must the last member. */
> @@ -148,6 +149,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>   	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
>   }
>   
> +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> +{
> +	return tdx->td_vcpu_created;
> +}
> +
>   static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
>   {
>   	return kvm_tdx->tdr_pa;
> @@ -165,6 +171,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
>   	return kvm_tdx->hkid > 0;
>   }
>   
> +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->finalized;
> +}
> +
>   static void tdx_clear_page(unsigned long page_pa)
>   {
>   	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -447,7 +458,32 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   {
> -	/* This is stub for now.  More logic will come. */
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int i;
> +
> +	/*
> +	 * This methods can be called when vcpu allocation/initialization
> +	 * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
> +	 * yet.
> +	 */
> +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm))) {
> +		WARN_ON_ONCE(tdx->tdvpx_pa);
> +		WARN_ON_ONCE(tdx->tdvpr_pa);
> +		return;
> +	}
> +
> +	if (tdx->tdvpx_pa) {
> +		for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> +			if (tdx->tdvpx_pa[i])
> +				tdx_reclaim_control_page(tdx->tdvpx_pa[i]);
> +		}
> +		kfree(tdx->tdvpx_pa);
> +		tdx->tdvpx_pa = NULL;
> +	}
> +	if (tdx->tdvpr_pa) {
> +		tdx_reclaim_control_page(tdx->tdvpr_pa);
> +		tdx->tdvpr_pa = 0;
> +	}
>   }
>   
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -456,8 +492,13 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	/* Ignore INIT silently because TDX doesn't support INIT event. */
>   	if (init_event)
>   		return;
> +	if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
> +		return;
>   
> -	/* This is stub for now. More logic will come here. */
> +	/*
> +	 * Don't update mp_state to runnable because more initialization
> +	 * is needed by TDX_VCPU_INIT.
> +	 */
>   }
>   
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> @@ -951,15 +992,147 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	return r;
>   }
>   
> +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	unsigned long *tdvpx_pa = NULL;
> +	unsigned long tdvpr_pa;
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
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		return -ENOMEM;
> +	tdvpr_pa = __pa(va);
> +
> +	tdvpx_pa = kcalloc(tdx_info->nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
> +			   GFP_KERNEL_ACCOUNT);
> +	if (!tdvpx_pa) {
> +		ret = -ENOMEM;
> +		goto free_tdvpr;
> +	}
> +	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va) {
> +			ret = -ENOMEM;
> +			goto free_tdvpx;
> +		}
> +		tdvpx_pa[i] = __pa(va);
> +	}
> +
> +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> +		ret = -EIO;
> +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> +		goto free_tdvpx;
> +	}
> +	tdx->tdvpr_pa = tdvpr_pa;
> +
> +	tdx->tdvpx_pa = tdvpx_pa;
> +	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> +		if (KVM_BUG_ON(err, vcpu->kvm)) {
> +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> +			for (; i < tdx_info->nr_tdvpx_pages; i++) {
> +				free_page((unsigned long)__va(tdvpx_pa[i]));
> +				tdvpx_pa[i] = 0;
> +			}
> +			/* vcpu_free method frees TDVPX and TDR donated to TDX */
vcpu_free() interface is called by two sites.
One is the error handling path of kvm_vm_ioctl_create_vcpu() when vcpu
creation.
The other is during kvm_destroy_vm().

What about the error occurs in KVM_TDX_INIT_VCPU?
Let's assume TDR and some of tdvpx pages are donated to TDX, and the next
call of tdh_vp_addcx() failed. The comment says "vcpu_free method frees 
TDVPX
and TDR donated to TDX", but if it happens, it seems that vcpu_free() would
not be called? Memory leakage?


> +			return -EIO;
> +		}
> +	}
> +
> +	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> +		return -EIO;
> +	}
> +
> +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +	tdx->td_vcpu_created = true;
> +	return 0;
> +
> +free_tdvpx:
> +	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> +		if (tdvpx_pa[i])
> +			free_page((unsigned long)__va(tdvpx_pa[i]));
> +		tdvpx_pa[i] = 0;
> +	}
> +	kfree(tdvpx_pa);
> +	tdx->tdvpx_pa = NULL;
> +free_tdvpr:
> +	if (tdvpr_pa)
> +		free_page((unsigned long)__va(tdvpr_pa));
> +	tdx->tdvpr_pa = 0;
> +
> +	return ret;
> +}
> +
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	struct msr_data apic_base_msr;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct kvm_tdx_cmd cmd;
> +	int ret;
> +
> +	if (tdx->initialized)
> +		return -EINVAL;
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if (cmd.error)
> +		return -EINVAL;
> +
> +	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
> +	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
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
> +	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
> +	if (ret)
> +		return ret;
> +
> +	tdx->initialized = true;
> +	return 0;
> +}
> +
>   static int __init tdx_module_setup(void)
>   {
> -	u16 num_cpuid_config, tdcs_base_size;
> +	u16 num_cpuid_config, tdcs_base_size, tdvps_base_size;
>   	int ret;
>   	u32 i;
>   
>   	struct tdx_md_map mds[] = {
>   		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
>   		TDX_MD_MAP(TDCS_BASE_SIZE, &tdcs_base_size),
> +		TDX_MD_MAP(TDVPS_BASE_SIZE, &tdvps_base_size),
>   	};
>   
>   #define TDX_INFO_MAP(_field_id, _member)			\
> @@ -1015,6 +1188,11 @@ static int __init tdx_module_setup(void)
>   	}
>   
>   	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> +	/*
> +	 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
> +	 * -1 for TDVPR.
> +	 */
> +	tdx_info->nr_tdvpx_pages = tdvps_base_size / PAGE_SIZE - 1;
>   
>   	return 0;
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 173ed19207fb..d3077151252c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,12 +17,20 @@ struct kvm_tdx {
>   	u64 xfam;
>   	int hkid;
>   
> +	bool finalized;
> +
>   	u64 tsc_offset;
>   };
>   
>   struct vcpu_tdx {
>   	struct kvm_vcpu	vcpu;
>   
> +	unsigned long tdvpr_pa;
> +	unsigned long *tdvpx_pa;
> +	bool td_vcpu_created;
> +
> +	bool initialized;
> +
>   	/*
>   	 * Dummy to make pmu_intel not corrupt memory.
>   	 * TODO: Support PMU for TDX.  Future work.
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 1ea532dfaf2a..5f8ee1c93cd1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -150,6 +150,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>   static inline void tdx_hardware_unsetup(void) {}
> @@ -169,6 +171,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>   static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +
> +static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0027134454c..eee63b08f14f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6248,6 +6248,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	case KVM_SET_DEVICE_ATTR:
>   		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
>   		break;
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -ENOTTY;
> +		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
> +			goto out;
> +		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
> +		break;
>   	default:
>   		r = -EINVAL;
>   	}



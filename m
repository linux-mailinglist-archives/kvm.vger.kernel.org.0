Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD966D4FC
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 04:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbjAQDbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 22:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbjAQDbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 22:31:39 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1C722A18;
        Mon, 16 Jan 2023 19:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673926297; x=1705462297;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iNIFRXoIIeigES6/kp8dR8C8hZFjoaliN8kNP9bcdhs=;
  b=HuZiDFeAxvYXNcMVwxBLvUsWb4y68pJ6mzfl1rbIzMKRW8rqE6UsJxeP
   1GsqWIAuSTWpCAWRjcOBPG4LQrY2v52y+wLUNRmvDZvEEXqKM7vmtXjiJ
   6sOelRrtD3zy7QZgqM5LxHAuokTM+ctWsgVtvcTnbpnoAp0dM3SqHsDeP
   iN8dEXAY6Z8YoLvTVksgQo0/hmVsUAkSjua538CJKrLRkBvU7fe1v5TZa
   6Zzm2aIXo34e5wSO4doaPU8Rv8BggtNVMZ7Tiijl0brcI/oWqiYrOh70V
   Dzamrk2GxIfHh7Kpn2fSVq6xNWZypH9EdEgdMEzwaxQ+sCqNsm/9gK1i9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="304289981"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="304289981"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 19:31:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="727652846"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="727652846"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.151]) ([10.249.170.151])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 19:31:34 -0800
Message-ID: <c8d27583-dd29-897a-75b8-5bfbdf05c6d2@linux.intel.com>
Date:   Tue, 17 Jan 2023 11:31:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v11 005/113] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <2184f7c8214f0114e8f77b19554ab4f7722836ac.1673539699.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2184f7c8214f0114e8f77b19554ab4f7722836ac.1673539699.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/2023 12:31 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't allow
> some operations (e.g., memory read/write, register state access, etc).
>
> Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVMs
> already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
> vm_init accepts vm_type.  So follow them.  Further, a different policy can
> be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
> default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
> will be defined as "bool is_td(kvm) { return vm_type == VM_TYPE_TDX; }"
>
> Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> e.g. qemu, to query what VM types are supported by KVM.  This (introduce a
> new capability and add vm_type) is chosen to align with other arch KVMs
> that have VM types already.  Other arch KVMs uses

uses -> use


> different name
name -> names
>   to query
> supported vm types and there is no common name for it, so new name was
> chosen.
>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst        | 21 +++++++++++++++++++++
>   arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>   arch/x86/include/asm/kvm_host.h       |  2 ++
>   arch/x86/include/uapi/asm/kvm.h       |  3 +++
>   arch/x86/kvm/svm/svm.c                |  6 ++++++
>   arch/x86/kvm/vmx/main.c               |  1 +
>   arch/x86/kvm/vmx/tdx.h                |  6 +-----
>   arch/x86/kvm/vmx/vmx.c                |  5 +++++
>   arch/x86/kvm/vmx/x86_ops.h            |  1 +
>   arch/x86/kvm/x86.c                    |  9 ++++++++-
>   include/uapi/linux/kvm.h              |  1 +
>   tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
>   tools/include/uapi/linux/kvm.h        |  1 +
>   13 files changed, 54 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 98459999273c..d2baa05f7c04 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -147,10 +147,31 @@ described as 'basic' will be available.
>   The new VM has no virtual cpus and no memory.
>   You probably want to use 0 as machine type.
>   
> +X86:
> +^^^^
> +
> +Supported vm type can be queried from KVM_CAP_VM_TYPES, which returns the
> +bitmap of supported vm types. The 1-setting of bit @n means vm type with
> +value @n is supported.
> +
> +S390:
> +^^^^^
> +
>   In order to create user controlled virtual machines on S390, check
>   KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL as
>   privileged user (CAP_SYS_ADMIN).
>   
> +MIPS:
> +^^^^^
> +
> +To use hardware assisted virtualization on MIPS (VZ ASE) rather than
> +the default trap & emulate implementation (which changes the virtual
> +memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
> +flag KVM_VM_MIPS_VZ.
> +
> +ARM64:
> +^^^^^^
> +
>   On arm64, the physical address size for a VM (IPA Size limit) is limited
>   to 40bits by default. The limit can be configured if the host supports the
>   extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index dba2909e5ae2..59181b12ad70 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
>   KVM_X86_OP(hardware_unsetup)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP(is_vm_type_supported)
>   KVM_X86_OP(vm_init)
>   KVM_X86_OP_OPTIONAL(vm_destroy)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 60dc8f1631de..c6ccfce7dc9e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1212,6 +1212,7 @@ enum kvm_apicv_inhibit {
>   };
>   
>   struct kvm_arch {
> +	unsigned long vm_type;
>   	unsigned long n_used_mmu_pages;
>   	unsigned long n_requested_mmu_pages;
>   	unsigned long n_max_mmu_pages;
> @@ -1536,6 +1537,7 @@ struct kvm_x86_ops {
>   	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
> +	bool (*is_vm_type_supported)(unsigned long vm_type);
>   	unsigned int vm_size;
>   	int (*vm_init)(struct kvm *kvm);
>   	void (*vm_destroy)(struct kvm *kvm);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index e48deab8901d..a4cca6bc6b06 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -529,4 +529,7 @@ struct kvm_pmu_event_filter {
>   #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>   #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>   
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 799b24801d31..55f2e0a9b0f6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4682,6 +4682,11 @@ static void svm_vm_destroy(struct kvm *kvm)
>   	sev_vm_destroy(kvm);
>   }
>   
> +static bool svm_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM;
> +}
> +
>   static int svm_vm_init(struct kvm *kvm)
>   {
>   	if (!pause_filter_count || !pause_filter_thresh)
> @@ -4710,6 +4715,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_free = svm_vcpu_free,
>   	.vcpu_reset = svm_vcpu_reset,
>   
> +	.is_vm_type_supported = svm_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_svm),
>   	.vm_init = svm_vm_init,
>   	.vm_destroy = svm_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index f5d1166d2718..3b24e32077d6 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -34,6 +34,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.hardware_disable = vmx_hardware_disable,
>   	.has_emulated_msr = vmx_has_emulated_msr,
>   
> +	.is_vm_type_supported = vmx_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_init = vmx_vm_init,
>   	.vm_destroy = vmx_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 060bf48ec3d6..473013265bd8 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -15,11 +15,7 @@ struct vcpu_tdx {
>   
>   static inline bool is_td(struct kvm *kvm)
>   {
> -	/*
> -	 * TDX VM type isn't defined yet.
> -	 * return kvm->arch.vm_type == KVM_X86_TDX_VM;
> -	 */
> -	return false;
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>   }
>   
>   static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5dc7687dcf16..f1dea386d6c2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7501,6 +7501,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return err;
>   }
>   
> +bool vmx_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM;
> +}
> +
>   #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index fbc57fcbdd21..6980126bc32a 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -32,6 +32,7 @@ void vmx_hardware_unsetup(void);
>   int vmx_check_processor_compat(void);
>   int vmx_hardware_enable(void);
>   void vmx_hardware_disable(void);
> +bool vmx_is_vm_type_supported(unsigned long type);
>   int vmx_vm_init(struct kvm *kvm);
>   void vmx_vm_destroy(struct kvm *kvm);
>   int vmx_vcpu_precreate(struct kvm *kvm);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 07e8ab791e37..68bff699096a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4535,6 +4535,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_X86_NOTIFY_VMEXIT:
>   		r = kvm_caps.has_notify_vmexit;
>   		break;
> +	case KVM_CAP_VM_TYPES:
> +		r = BIT(KVM_X86_DEFAULT_VM);
> +		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
> +			r |= BIT(KVM_X86_TDX_VM);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -12126,9 +12131,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	int ret;
>   	unsigned long flags;
>   
> -	if (type)
> +	if (!static_call(kvm_x86_is_vm_type_supported)(type))
>   		return -EINVAL;
>   
> +	kvm->arch.vm_type = type;
> +
>   	ret = kvm_page_track_init(kvm);
>   	if (ret)
>   		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 679d293ece0f..2a47fd0e51fd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1212,6 +1212,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>   #define KVM_CAP_MEMORY_ATTRIBUTES 226
> +#define KVM_CAP_VM_TYPES 227
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 649e50a8f9dd..b67d2d59eb6c 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -524,4 +524,7 @@ struct kvm_pmu_event_filter {
>   #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>   #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>   
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 20522d4ba1e0..792a4889d1f4 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> +#define KVM_CAP_VM_TYPES 227
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   

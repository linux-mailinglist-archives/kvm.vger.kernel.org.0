Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D44D569AB4
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiGGGsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 02:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiGGGsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 02:48:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3931838E;
        Wed,  6 Jul 2022 23:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657176514; x=1688712514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+tXNzHwELuNgAxKMiAIkruQgSOcxxESD9EGqrQMewd4=;
  b=mQRzVTUOWy5vuvimXmk8vB5qz9YexZEKVOCU4k2fPXx1c69NOTWjdkA1
   KCy05ZoKhrQuS3o5q/BhR2djBS6EHblphYhCOQq9SDIaZnF2FbgVpGso8
   Zk1ijtLm//ef01pktkWjbKoDIimg4FsOPwDTiVGyDDF30Hhh0qIDKXv8Z
   bEnJA2P2qVeWRjhlD9dbsjPkZz4WrU189fASOiydA/WGUrmj2tAyxkitC
   7JFD/+FC/UlzkvX+Bkw7TudLc5jgcdWaLasVgx1It0RYMH++sN6nwiShJ
   EQi9Ya9wUisnstG6z/j1Lmfnp4cYBPKCWUBjEvNCZifV1jiGUMlSmXdfr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="285071812"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="285071812"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 23:48:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="683206148"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jul 2022 23:48:31 -0700
Date:   Thu, 7 Jul 2022 14:48:30 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 023/102] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20220707064830.eszinc5psxt4r5xc@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <16f33cfd1095fdba35543c562a417b681351d480.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f33cfd1095fdba35543c562a417b681351d480.1656366338.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:15PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Implement a system-scoped ioctl to get system-wide parameters for TDX.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>  arch/x86/include/asm/kvm_host.h       |  1 +
>  arch/x86/include/uapi/asm/kvm.h       | 48 +++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/main.c               |  2 ++
>  arch/x86/kvm/vmx/tdx.c                | 46 +++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h            |  2 ++
>  arch/x86/kvm/x86.c                    |  6 ++++
>  tools/arch/x86/include/uapi/asm/kvm.h | 48 +++++++++++++++++++++++++++
>  8 files changed, 154 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index fbb2c6746066..3677a5015a4f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -117,6 +117,7 @@ KVM_X86_OP(smi_allowed)
>  KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
> +KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 80df346af117..342decc69649 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1591,6 +1591,7 @@ struct kvm_x86_ops {
>  	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>
> +	int (*dev_mem_enc_ioctl)(void __user *argp);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9792ec1cc317..273c8d82b9c8 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -534,4 +534,52 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_TDX_VM		1
>
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;
> +	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +	__u64 unused;
> +};
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +
> +	__u32 nr_cpuid_configs;
> +	__u32 padding;
> +	struct kvm_tdx_cpuid_config cpuid_configs[0];
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 6a93b19a8b06..7b497ed1f21c 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -212,6 +212,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.complete_emulated_msr = kvm_complete_insn_gp,
>
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +
> +	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>  };
>
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 63f3c7a02cc8..ec4ebba4152a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -392,6 +392,52 @@ int tdx_vm_init(struct kvm *kvm)
>  	return ret;
>  }
>
> +int tdx_dev_ioctl(void __user *argp)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	struct kvm_tdx_capabilities caps;
> +	struct kvm_tdx_cmd cmd;
> +
> +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> +		     sizeof(struct tdx_cpuid_config));
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +	if (cmd.flags || cmd.error || cmd.unused)
> +		return -EINVAL;
> +	/*
> +	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> +	 * mem_enc_ioctl().
> +	 */
> +	if (cmd.id != KVM_TDX_CAPABILITIES)
> +		return -EINVAL;
> +
> +	user_caps = (void __user *)cmd.data;
> +	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> +		return -EFAULT;
> +
> +	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
> +		return -E2BIG;
> +
> +	caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdx_caps.attrs_fixed0,
> +		.attrs_fixed1 = tdx_caps.attrs_fixed1,
> +		.xfam_fixed0 = tdx_caps.xfam_fixed0,
> +		.xfam_fixed1 = tdx_caps.xfam_fixed1,
> +		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, &caps, sizeof(caps)))
> +		return -EFAULT;
> +	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
> +			 tdx_caps.nr_cpuid_configs *
> +			 sizeof(struct tdx_cpuid_config)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 663fd8d4063f..3027d9821fe1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -132,6 +132,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  void tdx_hardware_unsetup(void);
> +int tdx_dev_ioctl(void __user *argp);
>
>  int tdx_vm_init(struct kvm *kvm);
>  void tdx_mmu_release_hkid(struct kvm *kvm);
> @@ -140,6 +141,7 @@ void tdx_vm_free(struct kvm *kvm);
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline void tdx_hardware_unsetup(void) {}
> +static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
>
>  static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>  static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 320f902eaf9e..6037ce93bcb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4565,6 +4565,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  			break;
>  		r = kvm_x86_dev_has_attr(&attr);
>  		break;
> +		case KVM_MEMORY_ENCRYPT_OP:
> +			r = -EINVAL;
> +			if (!kvm_x86_ops.dev_mem_enc_ioctl)
> +				goto out;
> +			r = static_call(kvm_x86_dev_mem_enc_ioctl)(argp);
> +			break;

Incorrect indention and please move it out of
case KVM_HAS_DEVICE_ATTR: {
}

>  	}
>  	default:
>  		r = -EINVAL;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 71a5851475e7..a9ea3573be1b 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -528,4 +528,52 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_TDX_VM		1
>
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;
> +	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +	__u64 unused;
> +};
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +
> +	__u32 nr_cpuid_configs;
> +	__u32 padding;
> +	struct kvm_tdx_cpuid_config cpuid_configs[0];
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> --
> 2.25.1
>

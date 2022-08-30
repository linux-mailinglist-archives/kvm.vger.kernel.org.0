Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB95A5EEC
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 11:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiH3JK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 05:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiH3JKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 05:10:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09597B11;
        Tue, 30 Aug 2022 02:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661850653; x=1693386653;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dZmopdiMcPjPfcsZ0W9MJ5yhsH0VEN58f6Mq1jkLDIE=;
  b=ksZWj1xBTJeMmne83uZXTgsz34IcFQQnhQT88jsVlqGU6pZoDsL081dQ
   7lkDuXbir8IB5c68glvJVUzoZU8m2uz5YS0Et9nCy5IhU8uZ9T2CHmyVF
   tzf45q3cKjqRi5EHqvE0ZFI0wH0LxKSfrHjKq+3gxpGiJ4+pV6D1JKDxl
   CgctL5f3lQ+FekmfTNLspjNgCtQ4JGXMZ6SB9LYcn8PuoOs7EmRuTEftk
   kdj2+Sk1J+XEk7aNC7uAFUUCPflkGxQQAcC6kEPHzS/pM7VfU4WJYIkTD
   4fnfdFxcoZGm9wCMxefjgGUR7N2eScXqfvbHhzxv7XlXyU61gGOapc4Wm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="321253896"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="321253896"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:10:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="641295186"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.100]) ([10.249.172.100])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:10:51 -0700
Message-ID: <55d18e94-c9a5-7425-1ed0-898ad0745928@linux.intel.com>
Date:   Tue, 30 Aug 2022 17:10:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 027/103] KVM: TDX: Do TDX specific vcpu initialization
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <c02d3a975e984fadb02673fe7fc234bd251f858b.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c02d3a975e984fadb02673fe7fc234bd251f858b.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TD guest vcpu need to be configured before ready to run which requests
> addtional information from Device model (e.g. qemu), one 64bit value is
> passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
> to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> additional vcpu configuration.
>
> Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
> add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>   arch/x86/include/asm/kvm_host.h       |  1 +
>   arch/x86/include/uapi/asm/kvm.h       |  1 +
>   arch/x86/kvm/vmx/main.c               |  9 +++++++
>   arch/x86/kvm/vmx/tdx.c                | 36 +++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h                |  4 +++
>   arch/x86/kvm/vmx/x86_ops.h            |  2 ++
>   arch/x86/kvm/x86.c                    |  6 +++++
>   tools/arch/x86/include/uapi/asm/kvm.h |  1 +
>   9 files changed, 61 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index d8d48a8f602c..de392bee9159 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -119,6 +119,7 @@ KVM_X86_OP(leave_smm)
>   KVM_X86_OP(enable_smi_window)
>   KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
>   KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
>   KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>   KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>   KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8131256e69ff..e856abbe80ab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1613,6 +1613,7 @@ struct kvm_x86_ops {
>   
>   	int (*dev_mem_enc_ioctl)(void __user *argp);
>   	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
>   	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 97ce34d746af..3cd723b7e2cf 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -539,6 +539,7 @@ struct kvm_pmu_event_filter {
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
>   	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 4f4ed4ad65a7..ce12cc8276ef 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -113,6 +113,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
>   struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> @@ -255,6 +263,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>   	.mem_enc_ioctl = vt_mem_enc_ioctl,
> +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
>   };
>   
>   struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ee682a65b233..37272fe1e69f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -69,6 +69,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
>   	return kvm_tdx->hkid > 0;
>   }
>   
> +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->finalized;
> +}
> +
>   static void tdx_clear_page(unsigned long page)
>   {
>   	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -784,6 +789,37 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	return r;
>   }
>   
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct kvm_tdx_cmd cmd;
> +	u64 err;
> +
> +	if (tdx->vcpu_initialized)
> +		return -EINVAL;
> +
> +	if (!is_td_initialized(vcpu->kvm) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if (cmd.error || cmd.unused)
> +		return -EINVAL;
> +	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
> +		return -EINVAL;
> +
> +	err = tdh_vp_init(tdx->tdvpr.pa, cmd.data);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> +		return -EIO;
> +	}
> +
> +	tdx->vcpu_initialized = true;
> +	return 0;
> +}
> +
>   int __init tdx_module_setup(void)
>   {
>   	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 3b34dfdbc699..91961d4f4b65 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -25,6 +25,8 @@ struct kvm_tdx {
>   	u64 xfam;
>   	int hkid;
>   
> +	bool finalized;
> +
>   	u64 tsc_offset;
>   };
>   
> @@ -34,6 +36,8 @@ struct vcpu_tdx {
>   	struct tdx_td_page tdvpr;
>   	struct tdx_td_page *tdvpx;
>   
> +	bool vcpu_initialized;
> +
>   	/*
>   	 * Dummy to make pmu_intel not corrupt memory.
>   	 * TODO: Support PMU for TDX.  Future work.
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b98bbcd9ef42..b4ffa1590d41 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -143,6 +143,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> @@ -159,6 +160,7 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> +static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f0784f506a16..702012f56502 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5901,6 +5901,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	case KVM_SET_DEVICE_ATTR:
>   		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
>   		break;
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -ENOTTY;
> +		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
> +			goto out;
> +		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);

In previous 2 added ioctl handing, static_call is used, is this one 
different for a reason?



> +		break;
>   	default:
>   		r = -EINVAL;
>   	}
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 965a1c2e347d..938fcf6bc002 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -533,6 +533,7 @@ struct kvm_pmu_event_filter {
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
>   	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };

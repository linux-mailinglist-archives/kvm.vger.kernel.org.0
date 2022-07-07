Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E92569B50
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 09:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiGGHM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 03:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiGGHMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 03:12:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E12611A;
        Thu,  7 Jul 2022 00:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657177973; x=1688713973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7ebLS8vusPVgs8ypR/gWFiq93VgeyOCRm8GJtPqEUxw=;
  b=PG/yGZvC/ATbLhTRgnqjkAtaaHLzd8JLwxaSAHNDJNkylRgodYp44uMQ
   ZNAgFFvU5l5wkauQAUFsGSns/ejAB3Mf40DQwMHrCqL+IHqnj+jk7q73E
   ns+ExpqgiShFyCADxyeMsNz893S9KrUCGJms/HMG0PTtykZF9i94BKkXp
   rdHEQJCj2ogFLrNDb/M4mekYCIA2jciTOtK6O/f89H8vRGw7z82KvcELk
   IAnqgqI5rX7fXcuHe+69gDMcD6+WtCKN42AAs06y0FRxxfkKjAyVY1jRY
   KE84G1kmsWMvG8RcRTbwhGsenou5ScwbAUrzjL9ca8+mgvU3EyTyQOBdo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="345640116"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="345640116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 00:12:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="651013655"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jul 2022 00:12:51 -0700
Date:   Thu, 7 Jul 2022 15:12:50 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 024/102] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20220707071250.dcp53mspnronpbxg@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <d0438eb959af5984eb4a72c3054085bfecd3b57d.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0438eb959af5984eb4a72c3054085bfecd3b57d.1656366338.git.isaku.yamahata@intel.com>
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

On Mon, Jun 27, 2022 at 02:53:16PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.
>
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
>
> TDX requires VM-scoped, and VCPU-scoped TDX-specific operations for device
> model, for example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization, and TDX-specific vCPU initialization.  Which requires KVM
> vCPU-scoped operations in addition to the existing VM-scoped operations.

Suggest to no need talking about vcpu scope operations here, because
they're not available in this patch, we can talk about them in the
patch which introduces them.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    |  9 +++++++++
>  arch/x86/kvm/vmx/tdx.c     | 26 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>  3 files changed, 39 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7b497ed1f21c..067f5de56c53 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -73,6 +73,14 @@ static void vt_vm_free(struct kvm *kvm)
>  		return tdx_vm_free(kvm);
>  }
>
> +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_ioctl(kvm, argp);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = "kvm_intel",
>
> @@ -214,6 +222,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>
>  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> +	.mem_enc_ioctl = vt_mem_enc_ioctl,
>  };
>
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ec4ebba4152a..2a9dfd54189f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -438,6 +438,32 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> +		return -EFAULT;
> +	if (tdx_cmd.error || tdx_cmd.unused)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	switch (tdx_cmd.id) {
> +	default:
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
> +		r = -EFAULT;
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +
>  int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 3027d9821fe1..ef6115ae0e88 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -137,6 +137,8 @@ int tdx_dev_ioctl(void __user *argp);
>  int tdx_vm_init(struct kvm *kvm);
>  void tdx_mmu_release_hkid(struct kvm *kvm);
>  void tdx_vm_free(struct kvm *kvm);
> +
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> @@ -147,6 +149,8 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>  static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>  static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>  static inline void tdx_vm_free(struct kvm *kvm) {}
> +
> +static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.25.1
>

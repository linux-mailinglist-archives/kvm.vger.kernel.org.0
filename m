Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076B95A73D5
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 04:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiHaCSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 22:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHaCSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 22:18:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF46496FD9;
        Tue, 30 Aug 2022 19:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661912308; x=1693448308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=61P+IO0szUMx//fRCLpfxHfQX38wzvHaIv4kI5y43As=;
  b=NDB3ZyPwf49LaevtFnP0DYNcwqO5e1xBQq/BVlATa/VNAoZdlCWAseOk
   8lrAjAf/rA4N1r4nwN0iEzMfBwsi5KcdI0zC+cP8DKwXEQlGV27QNKX99
   MC37x4RaehmNPBS1hoMml8WeRUoAyDpx1/TvxzZm4/I+rvjRulOror7yu
   cFUvMLDwuzyp/aYlEojjbaxKMK2PDHe0znLdacGjWbux4se8yxMYXOMIj
   OrQDJOd4PVuLBkB1xLzOEKZQURGlHnpBYOb5tXbiPhahvocNGC13jN26m
   XxoDmk/Nad7adUEE2asnJsKjhGmyl2AI5Z8W/4Dy5fB/WCLmPaGEPKkfg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295357769"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="295357769"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:18:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="680267668"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 19:18:26 -0700
Date:   Wed, 31 Aug 2022 10:18:25 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 022/103] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20220831021825.6uevl3xkvwog47ht@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <2d65bd56a7ab8c0776f5c6b7c8481dd45ad96794.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d65bd56a7ab8c0776f5c6b7c8481dd45ad96794.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:07PM -0700, isaku.yamahata@intel.com wrote:
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
> TDX requires VM-scoped TDX-specific operations for device model, for
> example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization.
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
> index 16c6570dbe52..d3b9f653da4b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -424,6 +424,32 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))

Minor: sizeof(tdx_cmd), escape from type change & better readability.

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

Ditto

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
> index 02490515d190..f0fe40c7ac34 100644
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

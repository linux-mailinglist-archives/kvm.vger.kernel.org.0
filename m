Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB25AA8B9
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiIBH1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiIBH1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:27:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDF6B95A3;
        Fri,  2 Sep 2022 00:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662103658; x=1693639658;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U+HT5o9SlPMn4FnNK6nCqWhX5dI+fXK9tMACw5jLoXI=;
  b=NxU7DF1gvjd/GA2PZcPbCxbWbdZWFN+1Rr91oKfFgl8G4f1Wg0QQXUbg
   +bx8mGbzOLJu+jNrxsjoCQAZOdtTXrtoFmfNEi9KmlT897JMxvMJqZSn7
   4bn0NjIVdu3W8WgSNCWRSXY943MoGx+zAp5zpjEM7h74SjzcfP037NV5K
   UU1YnNjJ87MhSzJOktm8FME5wSCufQwY+zdt6Jjz4b09Gu359mmry5po3
   Mfg65xqRbNr8l/74rpUY0z036g4/vRvB7AIYDCS+KQEjw3aD0+1NU1AVM
   /SxhTtmduX2vCx+t4wbF4XnDePmhakfNZkjvSu//E1prJs3nLLPscRkIZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="322075160"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="322075160"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 00:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="608898752"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 02 Sep 2022 00:27:15 -0700
Date:   Fri, 2 Sep 2022 15:27:14 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 050/103] KVM: TDX: Add load_mmu_pgd method for TDX
Message-ID: <20220902072714.polp6y56tgreg4ib@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <7586ef03744bdf529532e1dd1bff59ef8939dc23.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7586ef03744bdf529532e1dd1bff59ef8939dc23.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:35PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> For virtual IO, the guest TD shares guest pages with VMM without
> encryption.  Shared EPT is used to map guest pages in unprotected way.
>
> Add the VMCS field encoding for the shared EPTP, which will be used by
> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> shared GPAs (new shared EPTP).
>
> Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/vmx.h |  1 +
>  arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
>  arch/x86/kvm/vmx/tdx.c     |  5 +++++
>  arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>  4 files changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index f0f8eecf55ac..e169ace97e83 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -234,6 +234,7 @@ enum vmcs_field {
>  	TSC_MULTIPLIER_HIGH             = 0x00002033,
>  	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
>  	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
> +	SHARED_EPT_POINTER		= 0x0000203C,
>  	PID_POINTER_TABLE		= 0x00002042,
>  	PID_POINTER_TABLE_HIGH		= 0x00002043,
>  	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 9f4c3a0bcc12..252b7298b230 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -110,6 +110,15 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	return vmx_vcpu_reset(vcpu, init_event);
>  }
>
> +static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> +			int pgd_level)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +
> +	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -228,7 +237,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.write_tsc_offset = vmx_write_tsc_offset,
>  	.write_tsc_multiplier = vmx_write_tsc_multiplier,
>
> -	.load_mmu_pgd = vmx_load_mmu_pgd,
> +	.load_mmu_pgd = vt_load_mmu_pgd,
>
>  	.check_intercept = vmx_check_intercept,
>  	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 36d2127cb7b7..7a631ae78e59 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -518,6 +518,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vcpu->kvm->vm_bugged = true;
>  }
>
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> +{
> +	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> +}
> +
>  int tdx_dev_ioctl(void __user *argp)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 62f1d1cdd44b..185481ee5f2f 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -145,6 +145,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> +
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> @@ -162,6 +164,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.25.1
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF14F746C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 06:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbiDGERH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 00:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiDGERE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 00:17:04 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227B01C12A;
        Wed,  6 Apr 2022 21:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649304905; x=1680840905;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qAilRQMB2FumWUQlhMQm7RSIEj9Y/ON2VI39QbNtslI=;
  b=NMxGO2db5j0iDMCGaJ9ht2WVHV5UwKSlKJpBjklgYGCNTwAAAIarhQvk
   dyTKVxuEXHyui5NCHu/a0nDzjs9QJWX7EB8NTkWEc+9cojpZeI/PxShWF
   3+0WjX0W2RkU8iCoP6GoUKU79GHG1iFsoSxl+KwjWHa1PqvGG+rA53fMo
   BxuO3Vf/5NRHqHzrcA00+rWHEUoqERMlgOmnX9HUkie7K94pBZN2Grhjv
   xOzh8V0y/4YNfkh0ZyVWbFy9RV5F8ZxHCMrfmmh26oL+UDw64C5aiCXSd
   eux4yeHXqXHsu+apo+PDYw16nDMajOv+wSOPoJcww51C87bgQr5WZ8Et+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="321917214"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="321917214"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 21:15:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="792013286"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 21:15:02 -0700
Message-ID: <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler
 of TDX hypercalls (TDG.VP.VMCALL)
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 16:15:00 +1200
In-Reply-To: <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
> for the guest TD to call hypercall to VMM.  When the guest TD issues
> TDG.VP.VMCALL, the guest TD exits to VMM with a new exit reason of
> TDVMCALL.  The arguments from the guest TD and returned values from the VMM
> are passed in the guest registers.  The guest RCX registers indicates which
> registers are used.
> 
> Define the TDVMCALL exit reason, which is carved out from the VMX exit
> reason namespace as the TDVMCALL exit from TDX guest to TDX-SEAM is really
> just a VM-Exit.  Add a place holder to handle TDVMCALL exit.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/uapi/asm/vmx.h |  4 +++-
>  arch/x86/kvm/vmx/tdx.c          | 27 ++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h          | 13 +++++++++++++
>  3 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 3d9b4598e166..cb0a0565219a 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -92,6 +92,7 @@
>  #define EXIT_REASON_UMWAIT              67
>  #define EXIT_REASON_TPAUSE              68
>  #define EXIT_REASON_BUS_LOCK            74
> +#define EXIT_REASON_TDCALL              77
>  
>  #define VMX_EXIT_REASONS \
>  	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> @@ -154,7 +155,8 @@
>  	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
>  	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
>  	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
> -	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
> +	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
> +	{ EXIT_REASON_TDCALL,                "TDCALL" }
>  
>  #define VMX_EXIT_REASON_FLAGS \
>  	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8695836ce796..86daafd9eec0 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -780,7 +780,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  					struct vcpu_tdx *tdx)
>  {
>  	guest_enter_irqoff();
> -	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
> +	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs,
> +					tdx->tdvmcall.regs_mask);
>  	guest_exit_irqoff();
>  }
>  
> @@ -815,6 +816,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
>  		return EXIT_FASTPATH_NONE;
> +
> +	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
> +		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
> +	else
> +		tdx->tdvmcall.rcx = 0;
>  	return EXIT_FASTPATH_NONE;
>  }
>  
> @@ -859,6 +865,23 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (unlikely(tdx->tdvmcall.xmm_mask))
> +		goto unsupported;

Put a comment explaining this logic?

> +
> +	switch (tdvmcall_exit_reason(vcpu)) {

Could we rename tdxvmcall_exit_reason() to something like tdvmcall_leaf()?

Btw, why couldn't we merge previous patch to this one, so we don't have to look
back and forth to figure out exactly what do those functions do?


> +	default:
> +		break;
> +	}
> +
> +unsupported:
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +	return 1;
> +}
> +
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  {
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> @@ -1187,6 +1210,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  		return tdx_handle_exception(vcpu);
>  	case EXIT_REASON_EXTERNAL_INTERRUPT:
>  		return tdx_handle_external_interrupt(vcpu);
> +	case EXIT_REASON_TDCALL:
> +		return handle_tdvmcall(vcpu);
>  	case EXIT_REASON_EPT_VIOLATION:
>  		return tdx_handle_ept_violation(vcpu);
>  	case EXIT_REASON_EPT_MISCONFIG:
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 7cd81780f3fa..9e8ed9b3119e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -86,6 +86,19 @@ struct vcpu_tdx {
>  	/* Posted interrupt descriptor */
>  	struct pi_desc pi_desc;
>  
> +	union {
> +		struct {
> +			union {
> +				struct {
> +					u16 gpr_mask;
> +					u16 xmm_mask;
> +				};
> +				u32 regs_mask;
> +			};
> +			u32 reserved;
> +		};
> +		u64 rcx;
> +	} tdvmcall;
>  	union tdx_exit_reason exit_reason;
>  
>  	bool initialized;


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494241BAC91
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgD0S0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:26:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:21071 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgD0S0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:26:32 -0400
IronPort-SDR: /agMUFcVb6+Ww6AMlBXvTgJ5A3borKSNLVU2nFb6WZyKAM+7B6DaMUDRJqb9ZaLq6AMRfKREzT
 //sElO4CTE7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:26:32 -0700
IronPort-SDR: QbGgClW/+TE0gVxSFMjZWJg2qAiGhLr3Y9SG+yY6TZycF7vOAUC4Ky3zS+qzehEKuxIGaQA+Cl
 E4K0c4+GnLuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="247482032"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 27 Apr 2020 11:26:31 -0700
Date:   Mon, 27 Apr 2020 11:26:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 1/5] KVM: VMX: Introduce generic fastpath handler
Message-ID: <20200427182631.GM14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587709364-19090-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:22:40PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption 
> timer fastpath etc. In addition, we can't observe benefit from single 
> target IPI fastpath when APICv is disabled, let's just enable IPI and 
> Timer fastpath when APICv is enabled for now.

There are three different changes being squished into a single patch:

  - Refactor code to add helper
  - Change !APICv behavior for WRMSR fastpath
  - Introduce EXIT_FASTPATH_CONT_RUN

I don't think you necessarily need to break this into three separate
patches, but's the !APICv change needs to be a standalone patch, especially
given the shortlog.  E.g. the refactoring could be introduced along with
the second fastpath case, and CONT_RUN could be introduced with its first
usage.

> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 25 ++++++++++++++++++++-----
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f26df2c..6397723 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -188,6 +188,7 @@ enum {
>  enum exit_fastpath_completion {
>  	EXIT_FASTPATH_NONE,
>  	EXIT_FASTPATH_SKIP_EMUL_INS,
> +	EXIT_FASTPATH_CONT_RUN,
>  };
>  
>  struct x86_emulate_ctxt;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 766303b..f1f6638 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6559,6 +6559,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  	}
>  }
>  
> +static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
> +		switch (to_vmx(vcpu)->exit_reason) {
> +		case EXIT_REASON_MSR_WRITE:
> +			return handle_fastpath_set_msr_irqoff(vcpu);
> +		default:
> +			return EXIT_FASTPATH_NONE;
> +		}
> +	}
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  
>  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -6567,6 +6581,7 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
>  
> +cont_run:
>  	/* Record the guest's net vcpu time for enforced NMI injections. */
>  	if (unlikely(!enable_vnmi &&
>  		     vmx->loaded_vmcs->soft_vnmi_blocked))
> @@ -6733,17 +6748,17 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>  		return EXIT_FASTPATH_NONE;
>  
> -	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> -		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
> -	else
> -		exit_fastpath = EXIT_FASTPATH_NONE;
> -
>  	vmx->loaded_vmcs->launched = 1;
>  	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
>  
>  	vmx_recover_nmi_blocking(vmx);
>  	vmx_complete_interrupts(vmx);
>  
> +	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> +	/* static call is better with retpolines */
> +	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> +		goto cont_run;
> +
>  	return exit_fastpath;
>  }
>  
> -- 
> 2.7.4
> 

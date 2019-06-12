Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3713942BA3
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfFLQBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 12:01:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:50366 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbfFLQBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 12:01:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 09:01:23 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 12 Jun 2019 09:01:23 -0700
Date:   Wed, 12 Jun 2019 09:01:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: X86: Dynamic allocate core residency msr
 state
Message-ID: <20190612160123.GH20308@linux.intel.com>
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
 <1560238451-19495-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560238451-19495-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 03:34:07PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Dynamic allocate core residency msr state. MSR_CORE_C1_RES is unreadable 
> except for ATOM platform, so it is ignore here.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  5 +++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 15e973d..bd615ee 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -538,6 +538,15 @@ struct kvm_vcpu_hv {
>  	cpumask_t tlb_flush;
>  };
>  
> +#define NR_CORE_RESIDENCY_MSRS 3
> +
> +struct kvm_residency_msr {
> +	s64 value;
> +	u32 index;
> +	bool delta_from_host;
> +	bool count_with_host;
> +};
> +
>  struct kvm_vcpu_arch {
>  	/*
>  	 * rip and regs accesses must go through
> @@ -785,6 +794,8 @@ struct kvm_vcpu_arch {
>  
>  	/* AMD MSRC001_0015 Hardware Configuration */
>  	u64 msr_hwcr;
> +
> +	struct kvm_residency_msr *core_cstate_msrs;

Why are these in kvm_vcpu_arch?  AFAICT they're only wired up for VMX.

>  };
>  
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0b241f4..4dc2459 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6658,6 +6658,11 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  			goto free_vmcs;
>  	}
>  
> +	vmx->vcpu.arch.core_cstate_msrs = kzalloc(sizeof(struct kvm_residency_msr) *
> +		NR_CORE_RESIDENCY_MSRS, GFP_KERNEL_ACCOUNT);
> +	if (!vmx->vcpu.arch.core_cstate_msrs)
> +		goto free_vmcs;
> +
>  	if (nested)
>  		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
>  					   vmx_capability.ept,
> -- 
> 2.7.4
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0667C1741FF
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgB1W3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:29:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:16822 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB1W3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:29:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:29:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="232670993"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 28 Feb 2020 14:29:13 -0800
Date:   Fri, 28 Feb 2020 14:29:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: x86: Add function to inject guest page fault
 with reserved bits set
Message-ID: <20200228222913.GJ2329@linux.intel.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
 <20200227172306.21426-2-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227172306.21426-2-mgamal@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 07:23:02PM +0200, Mohammed Gamal wrote:
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 ++++++++++++++
>  arch/x86/kvm/x86.h |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 359fcd395132..434c55a8b719 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10494,6 +10494,20 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>  
> +void kvm_inject_rsvd_bits_pf(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +	struct x86_exception fault;
> +
> +	fault.vector = PF_VECTOR;
> +	fault.error_code_valid = true;
> +	fault.error_code = PFERR_RSVD_MASK;

As Jim pointed out, by definition this is PRESENT.  Other bits needs to
be translated from the VMCS.EXIT_QUALIFICATION field and/or manually
calculated for EPT.  I assume NPT is more or less good to go, i.e. just
pass in the error_code?

> +	fault.nested_page_fault = false;
> +	fault.address = gpa;

Taking the GPA is wrong, @address is CR3, a GVA.

> +	kvm_inject_page_fault(vcpu, &fault);

This needs to be

	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);

so that L1 (nested VMX) can intercept the #PF.

> +}
> +EXPORT_SYMBOL_GPL(kvm_inject_rsvd_bits_pf);
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3624665acee4..7d8ab28a6983 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -276,6 +276,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
>  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
>  bool kvm_vector_hashing_enabled(void);
> +void kvm_inject_rsvd_bits_pf(struct kvm_vcpu *vcpu, gpa_t gpa);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> -- 
> 2.21.1
> 

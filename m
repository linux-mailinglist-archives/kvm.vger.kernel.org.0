Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499086F119F
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbjD1GJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345357AbjD1GJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:09:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9ED2735;
        Thu, 27 Apr 2023 23:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682662188; x=1714198188;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZHxkrpzwTBdGO4RoIArFt2sZX/Zj8/L1F9atRiy0s5g=;
  b=AmJ0Orj/pZpDGNZAlRNx/iivFqAu4QLEEg2cTFaAAX53k+LZTDGeRubf
   DY0mv2TC5VQ3LSVtZlE7Bq3uc54MGFVVPaqL7D9aQ/amOTJaibQtJFUro
   4qaTvnS67S/CN8sOJclAKfhQ1KrJnZa4HfPNFnW4583GL6m5E3EP0uz0V
   +Yn3VzpBsRdaBQBSMMb9IcdGFnFhyx6KJ8cSl5oo0miDFEd/yK+q4d0+j
   2WCQ3WNZAYCmw+p2GRQm+2uWmfMbcC2vKxhxz0eikqPhJYSIFZxP15L/e
   Xmp6Nq9uFi565L955fHqguRCehuF5JqqD3FqFwEZ2wA6Ia8wg3YGHSX78
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327281390"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327281390"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:09:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="838740252"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="838740252"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.211.34]) ([10.254.211.34])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:09:45 -0700
Message-ID: <d923f839-7505-21fc-2976-673c9e698b6f@linux.intel.com>
Date:   Fri, 28 Apr 2023 14:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-11-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-11-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/2023 9:46 PM, Yang Weijiang wrote:
> Add handling for Control Protection (#CP) exceptions(vector 21).
> The new vector is introduced for Intel's Control-Flow Enforcement
> Technology (CET) relevant violation cases.
> See Intel's SDM for details.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h |  1 +
>   arch/x86/kvm/vmx/nested.c       |  2 +-
>   arch/x86/kvm/x86.c              | 10 +++++++---
>   arch/x86/kvm/x86.h              | 13 ++++++++++---
>   4 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7f467fe05d42..1c002abe2be8 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -33,6 +33,7 @@
>   #define MC_VECTOR 18
>   #define XM_VECTOR 19
>   #define VE_VECTOR 20
> +#define CP_VECTOR 21
>   
>   /* Select x86 specific features in <linux/kvm.h> */
>   #define __KVM_HAVE_PIT
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 96ede74a6067..7bc62cd72748 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2850,7 +2850,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>   		/* VM-entry interruption-info field: deliver error code */
>   		should_have_error_code =
>   			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> -			x86_exception_has_error_code(vector);
> +			x86_exception_has_error_code(vcpu, vector);
>   		if (CC(has_error_code != should_have_error_code))
>   			return -EINVAL;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7788646bbf1f..a768cbf3fbb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -520,11 +520,15 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
>   #define EXCPT_CONTRIBUTORY	1
>   #define EXCPT_PF		2
>   
> -static int exception_class(int vector)
> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>   {
>   	switch (vector) {
>   	case PF_VECTOR:
>   		return EXCPT_PF;
> +	case CP_VECTOR:
> +		if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
> +			return EXCPT_BENIGN;
> +		return EXCPT_CONTRIBUTORY;
By definition, #CP is Contributory.
Can you explain more about this change here which treats #CP as 
EXCPT_BENIGN when CET is not enabled in guest?

In current KVM code, there is suppose no #CP triggered in guest if CET 
is not enalbed in guest, right?
>   	case DE_VECTOR:
>   	case TS_VECTOR:
>   	case NP_VECTOR:
> @@ -707,8 +711,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   		return;
>   	}
> -	class1 = exception_class(prev_nr);
> -	class2 = exception_class(nr);
> +	class1 = exception_class(vcpu, prev_nr);
> +	class2 = exception_class(vcpu, nr);
>   	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY) ||
>   	    (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
>   		/*
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c544602d07a3..2ba7c7fc4846 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -171,13 +171,20 @@ static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
>   	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
>   }
>   
> -static inline bool x86_exception_has_error_code(unsigned int vector)
> +static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
> +						unsigned int vector)
>   {
>   	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>   			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
>   
> -	return (1U << vector) & exception_has_error_code;
> +	if (!((1U << vector) & exception_has_error_code))
> +		return false;
> +
> +	if (vector == CP_VECTOR)
> +		return !(vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET);
> +
> +	return true;
>   }
>   
>   static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)


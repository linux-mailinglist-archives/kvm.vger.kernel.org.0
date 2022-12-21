Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0E7652DC0
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiLUIPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiLUIO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:14:59 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B0321279
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671610498; x=1703146498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IUJIgJNaQQ6AI4o+AGWZuUhm2EWmT0wBM5cenKACMEk=;
  b=muydZNlLf7WdGY7Wq2uLVGSiT5Y6PZ78DTVSFiw6iyRXtP/t+IVqWVYN
   jd+NlUsgrbLpVfPdiv2z3pUlSZOcS3wFLUIeEXsCvtXbhilYjjyArY3r2
   4BrN/Nn7AB4TKLl4hYlUADsSMKFqYbjOnkyh8KPR4ORiWtDoaiLUOdrRk
   bqllm9VgmwjRTtLFX6A8cJ7ULZ5ZX4A4awlavpRfTu1P53PwN7Hj5rYi8
   /Qc7wK7YVJjBeOQiG+S78Llo+HWdtU8HUlxSqIh3GvGSsxtEfIL25pIkG
   oY8QUl0XufLyZ4M0TiOZfHpvFclZ1TLr1WCw1Sy/VGdv6NgDqZeKAlxRo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299494174"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="299494174"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:14:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681949715"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="681949715"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:14:52 -0800
Date:   Wed, 21 Dec 2022 16:14:39 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221081439.b4da6avrgvydjo3r@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-7-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9985dbb63e7b..16ddd3fcd3cb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    (!msr_info->host_initiated &&
>  		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
>  			return 1;
> +
> +		data = kvm_untagged_addr(data, vcpu);

Do we really need to take pains to trigger the kvm_untagged_addr()
unconditionally? I mean, LAM may not be enabled by the guest or even
not exposed to the guest at all.

> +
>  		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
>  		    (data & MSR_IA32_BNDCFGS_RSVD))
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb1f2c20e19e..0a446b45e3d6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1812,6 +1812,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  	case MSR_KERNEL_GS_BASE:
>  	case MSR_CSTAR:
>  	case MSR_LSTAR:
> +		/*
> +		 * LAM applies only addresses used for data accesses.
> +		 * Tagged address should never reach here.
> +		 * Strict canonical check still applies here.
> +		 */
>  		if (is_noncanonical_address(data, vcpu))
>  			return 1;
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6c1fbe27616f..f5a2a15783c6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -195,11 +195,48 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
>  }
>  
> +static inline u64 get_canonical(u64 la, u8 vaddr_bits)
> +{
> +	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> +}
> +

We already have a __canonical_address() in linux, no need to re-invent
another one. :)

B.R.
Yu

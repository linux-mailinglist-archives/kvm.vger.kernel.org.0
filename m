Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19B46F7C29
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 07:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjEEFB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjEEFBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 01:01:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D54A243;
        Thu,  4 May 2023 22:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683262879; x=1714798879;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B8mm/AWBe1toWRw94YwRkGlKs98008GSz3tN670ck8Y=;
  b=LGIarPeDFRLtH+8vwsv1mUnqyZYQueZJxr0QZesAviVIFf2AjC0GrU0d
   TZXkfvraSKJLv4p/tkNH5qiJ/1gCBTBFLuztidGsKNAnWMcMQlgHOermq
   n0ZzN62HyfsjKLT56bvJZIJMvRGwbLONej9UnwlzSxTnW2wdIMHd9fQl7
   HabG7i1f8CS6bVEFZWY+NPCyHZ4p4fUFJFcrWVty665qDUqimsiT2E490
   fRxMn9NZgtPN7+Ni7hLRWzTq8nc8pO9O/0gu3Apv/BaPJEOSpG9S/QjdK
   CkGwBQu9On5K7JcHiIWUanuLOP1w+CSpbNpxqup4rx5PoUxIoVilcorTJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="412350902"
X-IronPort-AV: E=Sophos;i="5.99,250,1677571200"; 
   d="scan'208";a="412350902"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 22:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="700207347"
X-IronPort-AV: E=Sophos;i="5.99,250,1677571200"; 
   d="scan'208";a="700207347"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.46]) ([10.238.1.46])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 22:01:16 -0700
Message-ID: <272d0366-cdf1-f668-9c20-c8631cd7f5eb@linux.intel.com>
Date:   Fri, 5 May 2023 13:01:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 12/21] KVM:x86: Add fault checks for guest CR4.CET
 setting
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     rick.p.edgecombe@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-13-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/2023 9:46 PM, Yang Weijiang wrote:
> Check potential faults for CR4.CET setting per Intel SDM.
> CR4.CET is the master control bit for CET features (SHSTK and IBT).
> In addition to basic support checks, CET can be enabled if and only
> if CR0.WP==1, i.e. setting CR4.CET=1 faults if CR0.WP==0 and setting
> CR0.WP=0 fails if CR4.CET==1.
>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   arch/x86/kvm/x86.h | 3 +++
>   2 files changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a768cbf3fbb7..7cd7f6755acd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -995,6 +995,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>   	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
>   		return 1;
>   
> +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
You can use kvm_is_cr4_bit_set() instead of kvm_read_cr4_bits()

> +		return 1;
> +
>   	static_call(kvm_x86_set_cr0)(vcpu, cr0);
>   
>   	kvm_post_set_cr0(vcpu, old_cr0, cr0);
> @@ -1210,6 +1213,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   			return 1;
>   	}
>   
> +	if ((cr4 & X86_CR4_CET) && !(kvm_read_cr0(vcpu) & X86_CR0_WP))
You can use kvm_is_cr0_bit_set() to check X86_CR0_WP

> +		return 1;
> +
>   	static_call(kvm_x86_set_cr4)(vcpu, cr4);
>   
>   	kvm_post_set_cr4(vcpu, old_cr4, cr4);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2ba7c7fc4846..daadd5330dae 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -536,6 +536,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   		__reserved_bits |= X86_CR4_VMXE;        \
>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>   		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&	\
> +	    !__cpu_has(__c, X86_FEATURE_IBT))		\
> +		__reserved_bits |= X86_CR4_CET;		\
IMO, it is a bit wired to split this part from the change of 
CR4_RESERVED_BITS.


>   	__reserved_bits;                                \
>   })
>   


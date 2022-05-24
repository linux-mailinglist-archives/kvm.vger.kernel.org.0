Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5B5333DA
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 01:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbiEXXWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242569AbiEXXWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 19:22:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210E82DAA6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 16:21:58 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q4so17106921plr.11
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 16:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M6ibtN+tkzyjMGp3wPL66xycMPufdrhzmfDOY7iX60k=;
        b=kt22Jdr99111DhfjKgHjr/LHKxyH1S9/yFGXXUNma4i2GW79ZUv6vwgVgBAz29Uu8Q
         /uT1GYJittlWhqAVzwcZUwbEQCDnBMYiIOqWEHcPRwYmwM8UR3IuU0F/qwrHrPHqa5IG
         C6/cjEnR4wioV4Wq23KaERGCaQYWw6AT5PmB0zDdNMz/clJa8Da69sanaGPJXQCIe3gY
         HvQNN3E6kk9vrXwJvhLy73lgrBVCG6vk4671pBVvhjAHp23QNuzQABgyVDDZFC51hvqw
         9NPsG0Nlfa5ElmGRIAyEZOgQ7SbcPGivBPa1DFeFzVDjvxNYDNVJduIubjjaYgPwo5pp
         8kUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M6ibtN+tkzyjMGp3wPL66xycMPufdrhzmfDOY7iX60k=;
        b=KeS39/L1pxayMmmMvGOmA+X2FAucpwxNGttSGFQk61HiM7jdajRr5IYCEwrcJdKynb
         Obv5RDDwzJjjGq8qGXDNLu9sx2hP+bsgNyIGiJ19GE+0y9eUPqRPwUz7NG5xL0QERjFf
         D18aFumYe0GXOJI7Zg2OXyaCwTf+1710pDMgAXH6ZjdKziMp1ys1AY/M7A5tBXmQqvDq
         ZWGZ+Ucyegm7qL7d3eOzl7KuChcy6/sKoDjU6X6DqHrGZgQFzxtkc3XpDrOqZ6Z2ZYp5
         1T9VDoaWxCvKhSGcFAsJS3Z8d8FHeD2445uPQf8mkFBJ1JSEY3tFwHNNzbMrQzFPpMJL
         fsmA==
X-Gm-Message-State: AOAM531GvL+7Jn1X/NawMiU15Gwk4nPnZzx4EmPkSV9xTknYa22NP5ZT
        R5Wgmg17FwZNZbyrXG7v3kFeDdJmdXtV7Q==
X-Google-Smtp-Source: ABdhPJzbpLoaUDt61YcqyxApz+8iQD3U4DO9atJPZZabEDleRRRIFHO93GAFnLI0B6ItqQ2t5gfNCQ==
X-Received: by 2002:a17:90b:1b03:b0:1dc:a80b:8004 with SMTP id nu3-20020a17090b1b0300b001dca80b8004mr7044789pjb.182.1653434517536;
        Tue, 24 May 2022 16:21:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902eb4500b0015e8d4eb248sm4819049pli.146.2022.05.24.16.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 16:21:56 -0700 (PDT)
Date:   Tue, 24 May 2022 23:21:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: MMU: Add helper function to get pkr bits
Message-ID: <Yo1okaacf2kbvrxh@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-6-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424101557.134102-6-lei4.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 24, 2022, Lei Wang wrote:
> Extra the PKR stuff to a separate, non-inline helper, which is a

s/Extra/Extract

> preparation to introduce pks support.

Please provide more justification.  The change is justified, by random readers of
this patch/commit will be clueless.

  Extract getting the effective PKR bits to a helper that lives in mmu.c
  in order to keep the is_cr4_*() helpers contained to mmu.c.  Support for
  PKRS (versus just PKRU) will require querying MMU state to see if the
  relevant CR4 bit is enabled because pkr_mask will be non-zero if _either_
  bit is enabled).

  PKR{U,S} are exposed to the guest if and only if TDP is enabled, and
  while permission_fault() is performance critical for ia32 shadow paging,
  it's a rarely used path with TDP is enabled.  I.e. moving the PKR code
  out-of-line is not a performance concern.

> Signed-off-by: Lei Wang <lei4.wang@intel.com>
> ---
>  arch/x86/kvm/mmu.h     | 20 +++++---------------
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++++++++
>  2 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index cb3f07e63778..cea03053a153 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -204,6 +204,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	return vcpu->arch.mmu->page_fault(vcpu, &fault);
>  }
>  
> +u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,

kvm_mmu_get_pkr_bits() so that there's a verb in there.

> +		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec);
> +
>  /*
>   * Check if a given access (described through the I/D, W/R and U/S bits of a
>   * page fault error code pfec) causes a permission fault with the given PTE
> @@ -240,21 +243,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  
>  	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>  	if (unlikely(mmu->pkr_mask)) {
> -		u32 pkr_bits, offset;
> -
> -		/*
> -		* PKRU defines 32 bits, there are 16 domains and 2
> -		* attribute bits per domain in pkru.  pte_pkey is the
> -		* index of the protection domain, so pte_pkey * 2 is
> -		* is the index of the first bit for the domain.
> -		*/
> -		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> -
> -		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
> -		offset = (pfec & ~1) +
> -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
> -
> -		pkr_bits &= mmu->pkr_mask >> offset;
> +		u32 pkr_bits =
> +			kvm_mmu_pkr_bits(vcpu, mmu, pte_access, pte_pkey, pfec);

Nit, I prefer wrapping in the params, that way the first line shows the most
important information, e.g. what variable is being set and how (by a function call).
And then there won't be overflow with the longer helper name:

		u32 pkr_bits = kvm_mmu_get_pkr_bits(vcpu, mmu, pte_access,
						    pte_pkey, pfec);

>  		errcode |= -pkr_bits & PFERR_PK_MASK;
>  		fault |= (pkr_bits != 0);
>  	}
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index de665361548d..6d3276986102 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6477,3 +6477,24 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  	if (kvm->arch.nx_lpage_recovery_thread)
>  		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
>  }
> +
> +u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec)
> +{
> +	u32 pkr_bits, offset;
> +
> +	/*
> +	* PKRU defines 32 bits, there are 16 domains and 2

Comment needs to be aligned, and it can be adjust to wrap at 80 chars (its
indentation has changed).


	/*
	 * PKRU and PKRS both define 32 bits. There are 16 domains and 2
	 * attribute bits per domain in them. pte_key is the index of the
	 * protection domain, so pte_pkey * 2 is the index of the first bit for
	 * the domain. The use of PKRU versus PKRS is selected by the address
	 * type, as determined by the U/S bit in the paging-structure entries.
	 */

> +	* attribute bits per domain in pkru.  pte_pkey is the
> +	* index of the protection domain, so pte_pkey * 2 is
> +	* is the index of the first bit for the domain.
> +	*/
> +	pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +
> +	/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
> +	offset = (pfec & ~1) + ((pte_access & PT_USER_MASK)
> +				<< (PFERR_RSVD_BIT - PT_USER_SHIFT));
> +
> +	pkr_bits &= mmu->pkr_mask >> offset;
> +	return pkr_bits;
> +}
> -- 
> 2.25.1
> 

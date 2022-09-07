Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708E05B0F6C
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 23:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiIGVrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 17:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiIGVrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 17:47:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68516BADA9
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 14:47:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pj10so5395483pjb.2
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 14:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=a0onBmXPphYT3RuqfDE1tfHpBM48udC3uDDfIPbNeqQ=;
        b=qz8qKS17YDB74dB3eVq/ImHb/1panXWt9MKNv77sjzlXj8cL3XwLCX/xz8ZQn9FJSc
         pkuvn/eM3SPKQUCBDgtCZu6rnvnlsgeB696oCeiPN8LzQIFq4odPuYBB/o7hizZaRcRP
         tH7JasNxHZyEVsUyfz0V/dL1r9OPMoCaBwGTkGjH1jd/RD5/uG56v/Pc1g6Dr4EGnH6r
         hr+0E5wBEw/x3ik8lSEvklHAQ6eORvUgxri4N5u/Sr7xvTrdNUpSsXg71MROLD6JhtYd
         nyD3JCmVLfqxQWXd75Tk6Z+u4KPOxj45s6/oI+dRFkvHvvGKtM9qmtSw3qCoO59EWNNk
         GKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=a0onBmXPphYT3RuqfDE1tfHpBM48udC3uDDfIPbNeqQ=;
        b=Xhjx8etBWvkvVxv/yP9qZMe44zD+PuR7lv/5dU/c/oer0mbq8CwxT0Df/Zu+SxHrb/
         9DO264FQr2pypU0CC6q7jExhOM3U00mCllNQK4iMUH1EXmma/iFN+krOrQkJZ5I2Dp3w
         moc8BbAc+lEt/SCPGtxz2l+nUf0amdF9CKLyMZR4oQs3P1cebAOGWDhzNexX/MprFnwM
         gNusb8/qNDktTDTOWp1OSzTjNQSgHWndE6PRQAAS8vt6Auj+wbPfW1Zxb/eZuqY3+PD8
         gE+7kCuWc6ZGACHk3ydMFv4qAsiN65EtUbrj3V7KVyIKX/d9brgmc5YNlFXxOKxNxA1u
         PdNA==
X-Gm-Message-State: ACgBeo1fCgr2SWsM95VbEzGKnKXXJkcyrb1LPTfDgeDi/I2tNV89eKo9
        DFLK3j67pF2HOdAyY5TMIyrlSw==
X-Google-Smtp-Source: AA6agR7u55ulppnpFE92xnBEjpQea4OXXBFThe+B3Pt6YcvMkX+Mwtq2DlhDFlWJGj73EGApy3OVsw==
X-Received: by 2002:a17:902:6b4c:b0:171:38ab:e762 with SMTP id g12-20020a1709026b4c00b0017138abe762mr5635735plt.42.1662587235722;
        Wed, 07 Sep 2022 14:47:15 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902e54600b00173cfaed233sm659052plf.62.2022.09.07.14.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 14:47:14 -0700 (PDT)
Date:   Wed, 7 Sep 2022 14:47:08 -0700
From:   David Matlack <dmatlack@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Message-ID: <YxkRXLsLuhjBNanT@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-9-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:41:26PM +0000, Oliver Upton wrote:
> The use of RCU is necessary to change the paging structures in parallel.
> Acquire and release an RCU read lock when traversing the page tables.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 78fbb7be1af6..7d2de0a98ccb 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>   */
>  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>  
> +#if defined(__KVM_NVHE_HYPERVISOR___)
> +

Future readers will wonder why NVHE stubs out RCU support and how that
is even correct. Some comments here would be useful explain it.

> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +#define kvm_dereference_ptep rcu_dereference_raw

How does NVHE have access rcu_dereference_raw()?

> +
> +#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
> +
> +#define kvm_pgtable_walk_begin	rcu_read_lock
> +#define kvm_pgtable_walk_end	rcu_read_unlock
> +#define kvm_dereference_ptep	rcu_dereference
> +
> +#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
> +
>  static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
> +
> +	return READ_ONCE(*kvm_dereference_ptep(p));

What about all the other places where page table memory is accessed?

If RCU is going to be used to protect page table memory, then all
accesses have to go under an RCU critical section. This means that page
table memory should only be accessed through __rcu annotated pointers
and dereferenced with rcu_dereference().

>  }
>  
>  #endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f911509e6512..215a14c434ed 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -284,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.end	= PAGE_ALIGN(walk_data.addr + size),
>  		.walker	= walker,
>  	};
> +	int r;
>  
> -	return _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_begin();
> +	r = _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_end();
> +
> +	return r;
>  }
>  
>  struct leaf_walk_data {
> -- 
> 2.37.2.672.g94769d06f0-goog
> 

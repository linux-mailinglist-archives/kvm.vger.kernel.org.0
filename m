Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D306053D5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiJSXRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJSXRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:17:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFF61ABEDC
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:17:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so1665874pjs.0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Me73D3UIfDoCysc1MWGMK8EUvSaCv+Air3k0VL/BRN8=;
        b=RmCtH8neEhRNB9EOWZTVkrahvAUVFTRCLPGLyV9Nb3VYKC99nZ2WwGhFzKu2zd6HVj
         0uiDQ0fsRP8/n8QzU7kIqDtbhRIkGoQL/i2SdXmhp8SDWC6ergvgFiSb+W1w4zuFcH2a
         SZWduHd7knWotjL0Mm+L4nTpW9p7iR7JwE0yMzWN95zSotrbo9VjGX9yuDLmvdWRphjX
         +H/H0qojfkImnsy0HIgOG6NIde3/7kIqOsCbLwiptGca8qtknEBtRNZfKvvivPq7IDt2
         3TNIVxbQksE24xTQ6z60h2Xdhr09RmEmeKnumzKlYfhKoC5eBLWNh5BT2+XEE/q2I0Cj
         6aTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Me73D3UIfDoCysc1MWGMK8EUvSaCv+Air3k0VL/BRN8=;
        b=K5KFZXRpFyZyMmGTimrMPwUXY33oEJUic40WJNwXY48M0X67DzSlcIxHOpLNG96908
         VGc/IzrHorziPTzrU0cCdYH2EXRplfaVBYHAG9AQFT6YQXW91sd1qFW/j2WriRD8wILH
         dCQNOumosvTANd1pGSDQaLNRu6E6c1MsfPITUpDqf82jxs2nRNj2Q0JXDEiYzMHeFiRz
         Y6XAy11QMi7vYmvEFaJqD3uSts5BobgYb9kPUwxL1I+mt5gVXX+RxUYDRmKn1U+E46rK
         T+TUZ8INLNGUfYYyjNAZk9wxGspubsV7Rjh2yRxASbhtYVbjZkD/5/0JleAF0I1E0sQO
         Qbdg==
X-Gm-Message-State: ACrzQf388DJe3E3Ngafd71TR71hl3B3HsvY49Amjk+1ISDe8lqIAan31
        5aXKHqEuisBo7RveFrzAeqLlug==
X-Google-Smtp-Source: AMsMyM7BE+rbsUH5R/9cYMnwScFvrtkWbyHC05khyxy3u7jhhyoNaEpU284lTQQEk+0awE2RbPVfvw==
X-Received: by 2002:a17:90a:b28d:b0:20d:6790:19fa with SMTP id c13-20020a17090ab28d00b0020d679019famr47693623pjr.68.1666221468020;
        Wed, 19 Oct 2022 16:17:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902ea0800b00176a579fae8sm6310265plg.210.2022.10.19.16.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:17:47 -0700 (PDT)
Date:   Wed, 19 Oct 2022 23:17:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 07/15] KVM: arm64: Use an opaque type for pteps
Message-ID: <Y1CFl8sLllXm4seK@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-8-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007232818.459650-8-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022, Oliver Upton wrote:
> Use an opaque type for pteps and require visitors explicitly dereference
> the pointer before using. Protecting page table memory with RCU requires
> that KVM dereferences RCU-annotated pointers before using. However, RCU
> is not available for use in the nVHE hypervisor and the opaque type can
> be conditionally annotated with RCU for the stage-2 MMU.
> 
> Call the type a 'pteref' to avoid a naming collision with raw pteps. No
> functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++-----------
>  2 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c33edcf36b5b..beb89eac155c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -25,6 +25,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>  
>  typedef u64 kvm_pte_t;
>  
> +typedef kvm_pte_t *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	return pteref;

Returning the pointer is unsafe (when it becomes RCU-protected).  The full
dereference of the data needs to occur under RCU protection, not just the retrieval
of the pointer.  E.g. this (straw man) would be broken

	bool table = kvm_pte_table(ctx.old, level);

	rcu_read_lock();
	ptep = kvm_dereference_pteref(pteref, flags & KVM_PGTABLE_WALK_SHARED);
	rcu_read_unlock();

	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);

	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
		ctx.old = READ_ONCE(*ptep);
		table = kvm_pte_table(ctx.old, level);
	}

as the read of the entry pointed at by ptep could be to a page table that is freed
in an RCU callback.

The naming collision you are trying to avoid is a symptom of this bad pattern,
as there should never be "raw" pteps floating around, at least not in non-pKVM
contexts that utilize RCU.

> +}
> +
>  #define KVM_PTE_VALID			BIT(0)
>  
>  #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
> @@ -170,7 +177,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>  struct kvm_pgtable {
>  	u32					ia_bits;
>  	u32					start_level;
> -	kvm_pte_t				*pgd;
> +	kvm_pteref_t				pgd;
>  	struct kvm_pgtable_mm_ops		*mm_ops;
>  
>  	/* Stage-2 only */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 02c33fccb178..6b6e1ed7ee2f 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>  }
>  
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
>  
>  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  				      struct kvm_pgtable_mm_ops *mm_ops,
> -				      kvm_pte_t *ptep, u32 level)
> +				      kvm_pteref_t pteref, u32 level)
>  {
>  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> +	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
>  	struct kvm_pgtable_visit_ctx ctx = {
>  		.ptep	= ptep,
>  		.old	= READ_ONCE(*ptep),

This is where you want the protection to kick in, e.g. 

  typedef kvm_pte_t __rcu *kvm_ptep_t;

  static inline kvm_pte_t kvm_read_pte(kvm_ptep_t ptep)
  {
	return READ_ONCE(*rcu_dereference(ptep));
  }

		.old	= kvm_read_pte(ptep),

In other words, the pointer itself isn't that's protected, it's PTE that the
pointer points at that's protected.

rcu_dereference() has no overhead when CONFIG_PROVE_RCU=n, i.e. there's no reason
to "optimize" dereferences.

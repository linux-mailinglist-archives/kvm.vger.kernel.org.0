Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3892F5B7E04
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 02:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiINAx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 20:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiINAxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 20:53:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55965FF5B
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:53:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so13543866ply.2
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=s7D2/n8L9/xlIj+hVN8GIcFvSkrDNM1KPpmGzxvTo/g=;
        b=MjaKzwDN2gr+IBBkEtU4oKISjvr8IhyssXGGoZPdWL2vQ+Kc+kf4lIHFyxRCWZxe/6
         tPIKyV/waFHwFtUW/s0IxrR+yzMbZxhaCYWJUbDrsoCjVHcCT8QPKI5L2jMpyVKpqoLr
         C+lgLIDjYk2a/JgjpmDcGPYLaDXheZQ/5h1PjIB5ZCKPvMRzfJ8fo/CVu5Fhg2mDsWUR
         UX3ZA5bX0+YXd0G5eaOP85mFoLnXoI/CIQvXLbCSUCqTxwx4dyJ1Ml2KvZqi7Zryg82w
         ONSiaucCEFXmPb67TjV6JShvU2ZWb80s5L/8+SL7vNTx5v4zxFiLIiEZ48eG+5CvZ1Ka
         0Kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=s7D2/n8L9/xlIj+hVN8GIcFvSkrDNM1KPpmGzxvTo/g=;
        b=NtMelotZv3DOgU17J9Jn7f9oHwWtr4cR8k+Y3R4/EDKLsCP46t7ANMYqCYdngk0PEm
         kz4WwPIGAKHdIDOsOoNwILu3xFOQgGy9zYhzJtUDm9K3VdJmTKUy1k1vn/3Lys0pww98
         1c/g+KG+rHOarfY0aRV2bgdVSEHSyJfLVBZ/fzg7RidVaaHpyR7AXvXUP/nvdzgjN6aW
         pVpn9YcQ3EisUiVdvx3vPk/N/nz7HGSeaI3ELADRm1OV11gwIcTN5mLlObFcOuCoGWfh
         KGzFoNMTJCIZoffFtSMSH7MvVxWZWkZCieEs/AVlMo94Boszoy/Radl6U5pYDzZQ5ZhZ
         Y6GA==
X-Gm-Message-State: ACgBeo0pHmMtNtLYo7memFfMi7HPgQHaocyX66bOMmhAJ3WJ1oWQ91m8
        67LEj6TqNVzHb3ZqXMSm8tf7aQ==
X-Google-Smtp-Source: AA6agR4y+7kaPNq1wJxvL/FXkrUH4iSFTMmdqNsD7Bn0tcQWSLnAZOkP8N3MaRfk0obT8kJGNMdoFA==
X-Received: by 2002:a17:902:b616:b0:178:2321:8dbb with SMTP id b22-20020a170902b61600b0017823218dbbmr17687773pls.47.1663116801745;
        Tue, 13 Sep 2022 17:53:21 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id 8-20020a621408000000b0053e85a4a2ccsm8532407pfu.26.2022.09.13.17.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 17:53:21 -0700 (PDT)
Date:   Tue, 13 Sep 2022 17:53:17 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] KVM: arm64: Make changes block->table to leaf PTEs
 parallel-aware
Message-ID: <YyEl/UILu+OAP5zA@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830195102.964724-1-oliver.upton@linux.dev>
 <YyElq0c6WD1zh7Lu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyElq0c6WD1zh7Lu@google.com>
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

On Tue, Sep 13, 2022 at 05:51:55PM -0700, Ricardo Koller wrote:
> On Tue, Aug 30, 2022 at 07:51:01PM +0000, Oliver Upton wrote:
> > In order to service stage-2 faults in parallel, stage-2 table walkers
> > must take exclusive ownership of the PTE being worked on. An additional
> > requirement of the architecture is that software must perform a
> > 'break-before-make' operation when changing the block size used for
> > mapping memory.
> > 
> > Roll these two concepts together into helpers for performing a
> > 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> > has been locked by a software walker. Additionally, use an atomic
> > compare-exchange to 'break' the PTE when the stage-2 page tables are
> > possibly shared with another software walker. Elide the DSB + TLBI if
> > the evicted PTE was invalid (and thus not subject to break-before-make).
> > 
> > All of the atomics do nothing for now, as the stage-2 walker isn't fully
> > ready to perform parallel walks.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 87 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 82 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 61a4437c8c16..71ae96608752 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -49,6 +49,12 @@
> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
> >  #define KVM_MAX_OWNER_ID		1
> >  
> > +/*
> > + * Used to indicate a pte for which a 'break-before-make' sequence is in
> > + * progress.
> > + */
> > +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> > +
> >  struct kvm_pgtable_walk_data {
> >  	struct kvm_pgtable		*pgt;
> >  	struct kvm_pgtable_walker	*walker;
> > @@ -586,6 +592,8 @@ struct stage2_map_data {
> >  
> >  	/* Force mappings to page granularity */
> >  	bool				force_pte;
> > +
> > +	bool				shared;
> >  };
> >  
> >  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> > @@ -691,6 +699,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >  	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
> >  }
> >  
> > +static bool stage2_pte_is_locked(kvm_pte_t pte)
> > +{
> > +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> > +}
> > +
> >  static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
> >  {
> >  	if (!shared) {
> > @@ -701,6 +714,69 @@ static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bo
> >  	return cmpxchg(ptep, old, new) == old;
> >  }
> >  
> > +/**
> > + * stage2_try_break_pte() - Invalidates a pte according to the
> > + *			    'break-before-make' requirements of the
> > + *			    architecture.
> > + *
> > + * @ptep: Pointer to the pte to break
> > + * @old: The previously observed value of the pte
> > + * @addr: IPA corresponding to the pte
> > + * @level: Table level of the pte
> > + * @shared: true if the stage-2 page tables could be shared by multiple software
> > + *	    walkers
> > + *
> > + * Returns: true if the pte was successfully broken.
> > + *
> > + * If the removed pte was valid, performs the necessary serialization and TLB
> > + * invalidation for the old value. For counted ptes, drops the reference count
> > + * on the containing table page.
> > + */
> > +static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level,
> > +				 struct stage2_map_data *data)
> > +{
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +
> > +	if (stage2_pte_is_locked(old)) {
> > +		/*
> > +		 * Should never occur if this walker has exclusive access to the
> > +		 * page tables.
> > +		 */
> > +		WARN_ON(!data->shared);
> > +		return false;
> > +	}
> 
> The above check is not needed as the cmpxchg() will return false if the
> old pte is equal to "new" (KVM_INVALID_PTE_LOCKED).
> 
> > +
> > +	if (!stage2_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, data->shared))
> > +		return false;
> > +
> > +	/*
> > +	 * Perform the appropriate TLB invalidation based on the evicted pte
> > +	 * value (if any).
> > +	 */
> > +	if (kvm_pte_table(old, level))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> > +	else if (kvm_pte_valid(old))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> > +
> > +	if (stage2_pte_is_counted(old))
> > +		mm_ops->put_page(ptep);
> > +
> > +	return true;
> > +}
> > +
> > +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new,
> > +			    struct stage2_map_data *data)
> > +{

nit: old is not used

> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +
> > +	WARN_ON(!stage2_pte_is_locked(*ptep));
> > +
> > +	if (stage2_pte_is_counted(new))
> > +		mm_ops->get_page(ptep);
> > +
> > +	smp_store_release(ptep, new);
> > +}
> > +
> >  static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
> >  			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > @@ -836,17 +912,18 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  	if (!childp)
> >  		return -ENOMEM;
> >  
> > +	if (!stage2_try_break_pte(ptep, *old, addr, level, data)) {
> > +		mm_ops->put_page(childp);
> > +		return -EAGAIN;
> > +	}
> > +
> >  	/*
> >  	 * If we've run into an existing block mapping then replace it with
> >  	 * a table. Accesses beyond 'end' that fall within the new table
> >  	 * will be mapped lazily.
> >  	 */
> > -	if (stage2_pte_is_counted(pte))
> > -		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> > -
> >  	new = kvm_init_table_pte(childp, mm_ops);
> > -	mm_ops->get_page(ptep);
> > -	smp_store_release(ptep, new);
> > +	stage2_make_pte(ptep, *old, new, data);
> >  	*old = new;
> >  
> >  	return 0;
> > -- 
> > 2.37.2.672.g94769d06f0-goog
> > 

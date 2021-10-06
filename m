Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E55423C90
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhJFLYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238254AbhJFLYT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jWX5sU8D1+Ly4mm1f35q3sYrq7WIwVRiVd8SgiHRgOs=;
        b=JJozpYtc+lht4K+GR9dJN5iVdGpxBjbKn7W+xoieRxxQ8phKA4tZS2P8GEffRp5wvYpdCU
        SxZhMU+0m/ogneH6G953wzBOFfdZS4zdZbfYmzmV+0y3bbjtJiuxBF6cAZTYXDdA26zSeS
        9AR6TvwvluTsM0a+vcwiYZgNpBinv8g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564--JQ5Lbm6PriJqiKBr6KNXg-1; Wed, 06 Oct 2021 07:22:26 -0400
X-MC-Unique: -JQ5Lbm6PriJqiKBr6KNXg-1
Received: by mail-ed1-f69.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso2317367edw.10
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jWX5sU8D1+Ly4mm1f35q3sYrq7WIwVRiVd8SgiHRgOs=;
        b=wlsWs82+Pp61MdrCh5CIWrwQT1wloUinRojyRAY71D6LcKzN5u2mg6lVvSB/dA/nF4
         ciHZzOmU7o1Q/Eck3cc15fuyk1peNBDjylPUn1dSOy3y8b5nrgO/n0dqImt+27CX4rtJ
         gAyqa2ROkJMHHKgUl/oAqqHQ0rp/S1eaiFDRyobgcR/cQ2uXii2yVkpiWHNWPXeTsR/T
         PO2cyl3128pjewUmf+XpXYQGSc3JgmQaHdoSpfcdsHWwGgsm5IeEBtrlNfUL1P3KGx/B
         y2AztfZUKGgZl0PC7a6uM2S2WOD5BT4Lf9BYTf0wa9+H23A57FwF9X4F+9o1Vjmiyt2c
         ULMw==
X-Gm-Message-State: AOAM5322XJeBr2KvP6DV5idCLQZJj7UbiqnkYUbjfpZOLLWNBmtiupk+
        FddPc0Zmj8du+n0BufoZ8WUx9iH9PdzY/3vc42ahxA1w+Sx5K5qfl2K1Qz+1ToG9y6gOHigMDgn
        IOGYaTKZtV2Ab
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr31730763eju.10.1633519344814;
        Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIBjVZ1NUXsGTtniMInafdYKeFUjjcDRuQOp+LY5ONfLP3y1FH0sVTnhS2J3YnXmmsoLjhGg==
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr31730745eju.10.1633519344572;
        Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id u4sm1158745edj.33.2021.10.06.04.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
Date:   Wed, 6 Oct 2021 13:22:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner
 into kvm_pgtable_stage2_annotate
Message-ID: <20211006112222.ahfhtkhamdi3svm5@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-4-maz@kernel.org>
 <20211006110211.y6kzmjlzgardmwif@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006110211.y6kzmjlzgardmwif@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 06, 2021 at 01:02:11PM +0200, Andrew Jones wrote:
> On Mon, Oct 04, 2021 at 06:48:36PM +0100, Marc Zyngier wrote:
> > kvm_pgtable_stage2_set_owner() could be generalised into a way
> > to store up to 63 bits in the page tables, as long as we don't
> > set bit 0.
> > 
> > Let's just do that.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h          | 12 ++++++-----
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 ++++------
> >  arch/arm64/kvm/hyp/nvhe/setup.c               | 10 +++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c                  | 20 ++++++-------------
> >  5 files changed, 27 insertions(+), 28 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 027783829584..d4d3ae0b5edb 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -329,14 +329,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			   void *mc);
> >  
> >  /**
> > - * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
> > - *				    track ownership.
> > + * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
> > + *				   to track ownership (and more).
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> >   * @addr:	Base intermediate physical address to annotate.
> >   * @size:	Size of the annotated range.
> >   * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> >   *		page-table pages.
> > - * @owner_id:	Unique identifier for the owner of the page.
> > + * @annotation:	A 63 bit value that will be stored in the page tables.
> > + *		@annotation[0] must be 0, and @annotation[63:1] is stored
> > + *		in the page tables.
> >   *
> >   * By default, all page-tables are owned by identifier 0. This function can be
> >   * used to mark portions of the IPA space as owned by other entities. When a
> > @@ -345,8 +347,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >   *
> >   * Return: 0 on success, negative error code on failure.
> >   */
> > -int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > -				 void *mc, u8 owner_id);
> > +int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				void *mc, kvm_pte_t annotation);
> >  
> >  /**
> >   * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index b58c910babaf..9d2ca173ea9a 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -53,7 +53,7 @@ int __pkvm_host_share_hyp(u64 pfn);
> >  
> >  bool addr_is_memory(phys_addr_t phys);
> >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> > -int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
> > +int host_stage2_annotate_locked(phys_addr_t addr, u64 size, kvm_pte_t owner_id);
> >  int kvm_host_prepare_stage2(void *pgt_pool_base);
> >  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index bacd493a4eac..8cd0c3bdb911 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -286,17 +286,14 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
> >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> >  			     enum kvm_pgtable_prot prot)
> >  {
> > -	hyp_assert_lock_held(&host_kvm.lock);
> > -
> >  	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
> >  }
> >  
> > -int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> > +int host_stage2_annotate_locked(phys_addr_t addr, u64 size,
> > +				kvm_pte_t annotation)
> >  {
> > -	hyp_assert_lock_held(&host_kvm.lock);
> 
> Hi Marc,
> 
> Why are the lock asserts getting dropped?

Ah, I see. host_stage2_try already has the same assert.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew


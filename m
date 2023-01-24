Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F327B679F24
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbjAXQrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjAXQrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:47:04 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1087DBC
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:47:03 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id jl3so15277807plb.8
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2vljj7/rdtQykCKsPt9Lrxa/Bdn+0oX4iO+vjCUfhs=;
        b=ANrakzH3C16ULOMIEY/BZEPj1ls68o1YfavF/fITWb8/IFs4PK3beAFyh+RQnPO6/h
         irPZElwWhkUOxWXbQvL9nI5/xlpSSf3TjA762P2/zJD+p9UNrCjA7gEQZ8SP2e6YrcUO
         BgXhphge991wKezRrPsDBRhv9eZr2jjBGekzRShJpOQDwpFxt0jAQWKyK9EAiR5omoOY
         rh/Gm/igDkIUgSsQunqc0nRJDqEtj/bo4YXh0MR4/dwZkYTxt63uAZzC16Sb+tRCArTY
         2Nxnz+3es6F6Km38oJjFUrWuxJAcZN3YHDGDCPYHelWEHH9zzVCOMKIy8I/4dmm0WCYt
         74IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2vljj7/rdtQykCKsPt9Lrxa/Bdn+0oX4iO+vjCUfhs=;
        b=pnsv6+xflEHDbwfO90X5Mp7t74VuoaQoDIoC44O6nofjuuWvpWprJwvbxUiwUIG6Sc
         oxiOhFOM8bMav1ID4l+FFHP9yQ8I/CHAGUtB+l0t2WtHUTqG+w0tx8GxsPUZYlHIDY6J
         W7RTfLgdiGlYwQ1EW3GEknwbGmg2mMmCrgjpZzaGkvEySnwb//K0ijXFoe3V7zDJZJe5
         PjAofDdD7shEzBIeUHz6AkOalxoDXsq0bx+1siiO28TSm3K9KfznCYnqqg5CSGn7dKok
         SNjATW6M99QZ9JySyrTatPTwWQQT2zPl/2ZwhWLO1xCSIabetrdbkV2V7G1K2dquxuQm
         wHkQ==
X-Gm-Message-State: AO0yUKW1fEmfGX6x+RDkJ409BcYCTcsbzdsAjNwMXUOv47gRURkSpj0p
        EPp0EGCyuFa8YRlK9+sDeD8FFA==
X-Google-Smtp-Source: AK7set9dmEzbuvISFTxpA3kBoxr52roVrkQ3u6KEsOYgXSAczuLougmffnVtl9e2K1VoYPjnBUpUGw==
X-Received: by 2002:a17:90a:690e:b0:22b:b82a:8b5f with SMTP id r14-20020a17090a690e00b0022bb82a8b5fmr258530pjj.2.1674578822337;
        Tue, 24 Jan 2023 08:47:02 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a3b0e00b00229962d07bcsm1789692pjc.6.2023.01.24.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:47:01 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:46:58 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9ALgtnd+h9ivn90@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
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

On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
> >  2 files changed, 96 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 8ad78d61af7f..5fbdc1f259fd 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >   */
> >  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *                             to PAGE_SIZE guest pages.
> > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @addr:      Intermediate physical address from which to split.
> > + * @size:      Size of the range.
> > + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> > + *             page-table pages.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an exampe using 1GB
> 
> Nit: example
> 
> > + * huge-pages and 4KB granules.
> > + *
> > + *                          [---input range---]
> > + *                          :                 :
> > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > + *                          :                 :
> > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > + *                          :                 :
> > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > + *                          :                 :
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by the size of the memcache. It
> > + * will fail it wasn't able to break any block.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 0dee13007776..db9d1a28769b 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> >         return 0;
> >  }
> >
> > +struct stage2_split_data {
> > +       struct kvm_s2_mmu               *mmu;
> > +       void                            *memcache;
> > +};
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +                              enum kvm_pgtable_walk_flags visit)
> > +{
> > +       struct stage2_split_data *data = ctx->arg;
> > +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +       kvm_pte_t pte = ctx->old, new, *childp;
> > +       enum kvm_pgtable_prot prot;
> > +       void *mc = data->memcache;
> > +       u32 level = ctx->level;
> > +       u64 phys;
> > +       int ret;
> > +
> > +       /* Nothing to split at the last level */
> 
> Would it be accurate to say:
> /* No huge pages can exist at the root level, so there's nothing to
> split here. */
> 
> I think of "last level" as the lowest/leaf/4k level but
> KVM_PGTABLE_MAX_LEVELS - 1 is 3? 

Right, this is the 4k level.

> Does ARM do the level numbering in
> reverse order to x86?

Yes, it does. Interesting, x86 does

	iter->level--;

while arm does:

	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);

I don't think this numbering scheme is encoded anywhere in the PTEs, so
either architecture could use the other.


> 
> > +       if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +               return 0;
> > +
> ...

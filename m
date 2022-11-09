Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99907623677
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiKIWXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiKIWXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:23:45 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2301838E
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:23:44 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id n18so216360qvt.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T4nhT+5+y72roggfQdrm+izhSoBAQsPwGSdMCJ4k+/s=;
        b=ZRk7+7DpcBDPfssndDH0jCsamFZ4YFaIenBG2tIgkAkWQDqVwmqi3fxsDov3PqIR/i
         skbO0PMGHk6vhDr0gZPT0+F6QhsLM/3CNLNtPocc682fg9VP0+lrtztvKipjBgkAa5Qz
         6yvEY7mPt7wfiEUpxrngFbezvdkNerpDIKyKImWGy0INUfvIyf/zX8UcE62Eexfq+Tms
         dTZb0Ent0XVyDBRC219MOJtGajH9xJJ9n548ytZM26stde3QdXEaWepM/7/cIjGzL8d5
         GhoYEcAjU2lmbn2F6w2G44+XHfcx9H+sem+ZVz8T0qp1xSt7GF3Hf2b3gYHqRUwXFgwc
         8PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4nhT+5+y72roggfQdrm+izhSoBAQsPwGSdMCJ4k+/s=;
        b=rVJQPkEOzEdM5VxjXeNtYM/zv+XBPP1PoexDD9FGIrh2qiqDBD751o9oDaR8koLorS
         n09dczErAT1dT/cG+OzLogbFHcCzbzIWY9SdOhIdyW1yymcyws9XA6QE/YdjD56ZJ67O
         JJceUPeeBancqgwTFNOxfVRoL6ezTcA+Yn1/LViEOQtG2hFlYilT3e8yG8SJDa00SHea
         i1x86GuU9GxcAaDv7sz/I24W/w0DsifAMxNxvkUHOeHijn5NhtTnnWAeB64meIkIk6r9
         2/QDNwsFG7j1eV2rsEM8+w+7InBiTv45y3gEcyaaTkY9a11C7DlIFp+S4MQxm95bbfJj
         hb1Q==
X-Gm-Message-State: ACrzQf1KhkviTEyvYemqTlbps0tPbr5t0vvKel7bNWFehv6zDC28mMqI
        x+9V3rTUwKGsK6+dXPkVZiQaVZF7XPzLM3mPHaFN8BRtg7o=
X-Google-Smtp-Source: AMsMyM5TapTqPRC0kKImkN6kMspQ3TuK1Gmv3b9wyzlFRHK+SpRPTCXYNOg2RgAbIk324w0L82kK6VOq6bWdOqkcmso=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56191873qvc.28.1668032623716; Wed, 09
 Nov 2022 14:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-6-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-6-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:23:33 -0800
Message-ID: <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> A subsequent change to KVM will move the tear down of an unlinked
> stage-2 subtree out of the critical path of the break-before-make
> sequence.
>
> Introduce a new helper for tearing down unlinked stage-2 subtrees.
> Leverage the existing stage-2 free walkers to do so, with a deep call
> into __kvm_pgtable_walk() as the subtree is no longer reachable from the
> root.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index a752793482cb..93b1feeaebab 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   */
>  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>
> +/**
> + * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> + * @mm_ops:    Memory management callbacks.
> + * @pgtable:   Unlinked stage-2 paging structure to be freed.
> + * @level:     Level of the stage-2 paging structure to be freed.
> + *
> + * The page-table is assumed to be unreachable by any hardware walkers prior to
> + * freeing and therefore no TLB invalidation is performed.
> + */
> +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> +
>  /**
>   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 93989b750a26..363a5cce7e1a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>         pgt->pgd = NULL;
>  }
> +
> +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> +{
> +       kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> +       struct kvm_pgtable_walker walker = {
> +               .cb     = stage2_free_walker,
> +               .flags  = KVM_PGTABLE_WALK_LEAF |
> +                         KVM_PGTABLE_WALK_TABLE_POST,
> +       };
> +       struct kvm_pgtable_walk_data data = {
> +               .walker = &walker,
> +
> +               /*
> +                * At this point the IPA really doesn't matter, as the page
> +                * table being traversed has already been removed from the stage
> +                * 2. Set an appropriate range to cover the entire page table.
> +                */
> +               .addr   = 0,
> +               .end    = kvm_granule_size(level),
> +       };
> +
> +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> +}

Will this callback be able to yield? In my experience, if processing a
large teardown (i.e. level >=3 / maps 512G region) it's possible to
hit scheduler tick warnings.


> --
> 2.38.1.431.g37b22c650d-goog
>

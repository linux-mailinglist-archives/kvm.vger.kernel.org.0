Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A299164ACC4
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiLMBGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiLMBGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:06:31 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3801CFF8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:06:30 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-381662c78a9so172003497b3.7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pv4WCEHXWY+FV1YUq8UNcPDkKm6bq2JSRGE//Kj9vf8=;
        b=nHZzxj7Q780CVpKNF5gPN9HC44/Nc5HxGgyb1Juqwj1LdHZaoEfIug7PLPSpIoG2yv
         bmGt6M4gEviMg/4oleu94/zXTiZWfGijEovvaEHGgA7Eev1ScUr3lmzTjd64Mi03kCxs
         PbGxjVHqOnyt6ZPcxJwRG/wcbDAMZUx3Xl4SiOpcV0axmJA2GnEXju4M06z4rBwHhhEb
         yE957qAZ7PBaas2oZC443pTFXpt0xmYGnt5zUCk7Qk2H1quPnvfsIn/n2xF6RlLVxEn/
         7qsqOx/N1UaziUkHy3R+gnhN/7hTYyhLpEA7pfvyzNtgwB54yoGqLe9EO7E5FBPlJUQ0
         OJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pv4WCEHXWY+FV1YUq8UNcPDkKm6bq2JSRGE//Kj9vf8=;
        b=fUYH1DucPQSr6WLvQq1UcviUUmP6G2gCqkzQOxEBGpVgFFB3xM0FHerh+mnx8kDwL1
         NgHmt08iViFRgEwTPcEVVWTZKSIDndVHoL1KU5X/OcyciXrGIaNKeY/sb3CqvCvFnBLV
         JbVhwENF4eVuwh8itek2itfBtxstAd7uNl30WY7JxOKEVwLeCBspt/4lNlzCyxbCqg0W
         NpetgnQ8b3Pzt8Xp3FZol51Cmlai4XzP1SforwVKg0AmbP2J9EsFPwNdIXiB4TXlUjW7
         xiu5loleh5xxftyTA1lcjG0mFEs7gf8TFP0RvQOqM913aAajpli6bXh+Wjg9IL11lp7l
         YBIQ==
X-Gm-Message-State: ANoB5pmJ/zPW2MI5Cy0V5cUTCnLHhTyKoMzk2gV76OEuEmu5x9MGjYBR
        rZkw/T5L49NKf1tTKnKQ9moucMmIDfplCHDqKXru9g==
X-Google-Smtp-Source: AA0mqf6UC/AYrRSJ+MEPYQjgdOAUYa1qq71cF4IZc0dJwhxjGVc2rf3hOO63DAbZlhHX9B51ehBcsSfwU5FzFAQu4JA=
X-Received: by 2002:a81:4d6:0:b0:402:7be6:f265 with SMTP id
 205-20020a8104d6000000b004027be6f265mr4263609ywe.188.1670893589689; Mon, 12
 Dec 2022 17:06:29 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-3-dmatlack@google.com>
 <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
In-Reply-To: <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 12 Dec 2022 17:06:03 -0800
Message-ID: <CALzav=crvFwCo50N5QOFD5FstrR9wJ=FmQAkYDHaKzQuatCNfw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/37] KVM: MMU: Move struct kvm_mmu_page_role into
 common code
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

On Mon, Dec 12, 2022 at 3:11 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > +/*
> > + * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
> > + * also includes TDP pages) to determine whether or not a page can be used in
> > + * the given MMU context.
> > + */
> > +union kvm_mmu_page_role {
> > +     u32 word;
> > +     struct {
> > +             struct {
> > +                     /* The address space ID mapped by the page. */
> > +                     u16 as_id:8;
> > +
> > +                     /* The level of the page in the page table hierarchy. */
> > +                     u16 level:4;
> > +
> > +                     /* Whether the page is invalid, i.e. pending destruction. */
> > +                     u16 invalid:1;
> > +             };
> > +
> > +             /* Architecture-specific properties. */
> > +             struct kvm_mmu_page_role_arch arch;
> > +     };
> > +};
> > +
>
> Have you considered adding a tdp_mmu:1 field to the arch-independent
> part?  I think that as long as _that_ field is the same, there's no need
> to have any overlap between TDP MMU and shadow MMU roles.
>
> I'm not even sure if the x86 TDP MMU needs _any_ other role bit.  It
> needs of course the above three, and it also needs "direct" but it is
> used exactly to mean "is this a TDP MMU page".  So we could have
>
> union {
>         struct {
>                 u32 tdp_mmu:1;
>                 u32 invalid:1;
>                 u32 :6;
>                 u32 level:8;
>                 u32 arch:8;
>                 u32 :8;
>         } tdp;
>         /* the first field must be "u32 tdp_mmu:1;" */
>         struct kvm_mmu_page_role_arch shadow;

We could but then that prevents having common fields between the
Shadow MMU and TDP MMU. For example, make_spte() and
make_huge_page_split_spte() use sp->role.level regardless of TDP or
Shadow MMU, and is_obsolete_sp() uses sp->role.invalid. Plus then you
need the `arch:8` byte for SMM.

It's possible to make it work, but I don't see what the benefit would be.

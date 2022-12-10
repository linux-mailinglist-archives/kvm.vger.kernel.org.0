Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5E648C28
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 02:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiLJBHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 20:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLJBHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 20:07:47 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1117592
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 17:07:45 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-40b40ff39f1so35927827b3.10
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 17:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I2GE1P9MKB5IEXA78EjWjeGIw+fkI4b001mr77BECX4=;
        b=Zz3MbiPPY1SHgc009qCyxMWHtFmspb6G3A0xzYMbttsp31nw0tSX4tppfrsPzNCIF6
         D7iZa+LTmezBYiYDtrAmYb1oC/fxxbCFXDl2x8spANHzzlsqXtea4DYwT5ZwgelbohYZ
         089wInVCX/E1aq3PKr5hxN9tOHp0A9lXSiHrUb2tvZFE38B1gNZClvkVFMpcr2O4jVlr
         9bJlXy7+oFG62lvofRFDdTYYtZ7NVMOdXK6E5CeH1XdzyTgiFtvIInk1zIkAc8vPoxQI
         9f4u+ARi+JH2GcPIweLO4Jw0BwgiylZumo9BqAOOnhTCwihz86Bnx7mwqeF8hZA9e/Yn
         C+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2GE1P9MKB5IEXA78EjWjeGIw+fkI4b001mr77BECX4=;
        b=3Tpv3JCGOirZomPZAyo6Owy+M9X4Q18l++wCuGjXZqtKQMULG+WVzFHheCn6ktAeW5
         8p6XCQWFpjyOo6Z09wXgsPd8ZxqeVwGqB6BM6N814XQdBlJqRgPVyzpXT5NNQUD2dlxq
         2jqkkM4N+oWQqYGDUShCOAYI1Z2sOtJLGlXJa8I33ze2h3JztdM4qg/QmNpGBeXMq7z8
         Abi5DTypB4e1f5FMO4pcOHVfRMdAZnD+FGcqe89zYIm+kiszN5kncgEyWvdBFY65WIce
         koCKVLtMl9Tt4LNs1qlRIZfs4JJ3Gxsfj29/5CK2acdJx2l+lnmlr0BZPSsUUomy5Zv/
         keSQ==
X-Gm-Message-State: ANoB5pmg3L9TIfulTwBsAreza0zBiP+fMmsyGiLb3XT7IO+RuIVycNrN
        Op+vnXlBLfG+EL1X1Htxv9rAoGH9r/J33RfFWhqerw==
X-Google-Smtp-Source: AA0mqf7NPTsewklw8WtJjMQ5b4Z4DLLXvnPd6MTLSGVUxVce2NMxMIFrAkSkhyQdcwqQG9PUK7aUBAXAR0abljqhaUo=
X-Received: by 2002:a81:1401:0:b0:3b0:b9aa:46eb with SMTP id
 1-20020a811401000000b003b0b9aa46ebmr2248873ywu.150.1670634464404; Fri, 09 Dec
 2022 17:07:44 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <Y5OHVzBSHPmAq2FO@google.com>
In-Reply-To: <Y5OHVzBSHPmAq2FO@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 9 Dec 2022 17:07:18 -0800
Message-ID: <CALzav=c328M1jgApAEEnz5B6h_pr5w07VpcMx0kSg0MtJjAf2w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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

On Fri, Dec 9, 2022 at 11:07 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Dec 08, 2022 at 11:38:20AM -0800, David Matlack wrote:
>
> >    Also do we want to keep "TDP" or switch
> >    to something more familiar across architectures (e.g. ARM and RISC-V
> >    both use "Stage-2")?
>
> As it relates to guest memory management I don't see much of an issue
> with it, TBH. It is sufficiently arch-generic and gets the point across.
>
> Beyond that I think it really depends on the scope of the common code.
>
> To replace the arm64 table walkers we will need to use it for stage-1
> tables.

Speaking of, have ARM folks ever discussed deduplicating the KVM/ARM
stage-1 code with the Linux stage-1 table code (<linux/pgtable.h>),
which is already architecture-neutral? It seems backwards for us to
build out an architecture-neutral stage-1 walker in KVM when one
already exists.

For example, arch/arm64/kvm/mmu.c:get_user_mapping_size() looks like
it could be reimplemented using <linux/pgtable.h>, rather than using
KVM code. In fact that's what we do for walking stage-1 page tables in
KVM/x86. Take a look at
arch/x86/kvm/mmu/mmu.c:host_pfn_mapping_level(). I bet we could move
that somewhere in mm/ so that it could be shared across KVM/x86 and
KVM/ARM.

> I'm only hand-waving at the cover letter and need to do more
> reading, but is it possible to accomplish some division:
>
>  - A set of generic table walkers that implement common operations, like
>    map and unmap. Names and types at this layer wouldn't be
>    virt-specific.
>
>  - Memory management for KVM guests that uses the table walker library,
>    which we can probably still call the TDP MMU.
>
> Certainly this doesn't need to be addressed in the first series, as the x86
> surgery is enough on its own. Nonetheless, it is probably worthwhile to
> get the conversation started about how this code can actually be used by
> the other arches.

Yup, we'll need some sort of split like that in order to integrate
with KVM/ARM, since the hyp can't access struct kvm, work_queues, etc.
in tdp_mmu.c. I don't think we'll need that split for KVM/RISC-V
though. So for the sake of incremental progress I'm not planning on
doing any of that refactoring preemptively. Plus it should be possible
to keep the TDP MMU API constant when the internal implementation
eventually gets split up. i.e. I don't forsee it creating a bunch of
churn down the road.

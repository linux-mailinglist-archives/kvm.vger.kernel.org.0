Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774954E498D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 00:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiCVXN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 19:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiCVXN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 19:13:27 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A285E77D
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:11:59 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id k21so15789314lfe.4
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9UcMI48nwlkJwzGQaLCymnATyeWxY7UI+r36M2RtgBY=;
        b=fVxGdQ0lDhy37Z3mtSn9xY39q7OFgGPiLVvBCZBV5MLaL5arrUVY6OErynD8FxEMEL
         NS1gJ05HdIVS+Pgcr24laaY+sIWghTb5+fnguG6H0C9zeaCUmVUu0AZH5JnvoaoTwg59
         POQ+tgNUyLE3ADxAARPe+4ZRRtZ9luy2kpH3uEmq3v6mwFbr/O68sTms15V0djO6aLxo
         x7UieZolXfsNJ3MOIXz2p8XksMfrnmK8cnLCrzklinwkz8wdIGIcrhiD6hMgg5HFHEDf
         4VR2h3LvbLeELpfPj3hMrqJeUDRIM3pFJVNCEwJi8DrM3ercUpht+SSoLebiwnMxmW48
         DLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9UcMI48nwlkJwzGQaLCymnATyeWxY7UI+r36M2RtgBY=;
        b=y/tLWpg0PcJib1FQpisgT63ujdbHYQa5G48IB4BrQgwo033y4KTFhYhFLjAyh2rH7F
         EVtHfoVE/T3OwpedUj4GilQzYn4FdD767rpMU2fd7siegUQCwRhoQJrOISFf5UZjKgSY
         XAbJAY4HwkloJf2KH8sV+7JQ6kUp0DggzsWfDgGv5+7ki4NuvJpgB8nKAWD2rP90ba/P
         wl0Zq4eC7MLo8uJe4uhn/kPIklZI5mYTJO+smqpmOxEJV/kswuCNeMY7erRPElXLG8um
         wAitjs6j/NPxCe46OGBlSepAKsomlRC0fp8a+watbdzw3kncvAfdRCAoFAiuD9aoAk0T
         nCGw==
X-Gm-Message-State: AOAM530qsWUotZbSILYIMCRWqHJEMuN5PPgJlmi4gyFzXlgsRqk/jS3O
        F9bETLhV6HIlotRbPKz0o+jFWVYEwQ/FkEtAhzXeKQ==
X-Google-Smtp-Source: ABdhPJxKDtp0rtSym57kIIsqB7/r1k5Genfjt3dYPaXLz5oTghlutp4K5YtmVdgCQQDgsV2VunXL2dkkNqst+Dj4Qow=
X-Received: by 2002:a05:6512:128e:b0:44a:4067:9ffe with SMTP id
 u14-20020a056512128e00b0044a40679ffemr3096148lfs.64.1647990717672; Tue, 22
 Mar 2022 16:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-19-dmatlack@google.com>
 <YjGkmwBIwe64TjqA@xz-m1.local>
In-Reply-To: <YjGkmwBIwe64TjqA@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 16:11:31 -0700
Message-ID: <CALzav=fpydLJhE5m58od5rFEv0iGLHzkPaM4mN7XHv2WqF8ptg@mail.gmail.com>
Subject: Re: [PATCH v2 18/26] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Mar 16, 2022 at 1:49 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:20AM +0000, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> > in the rmap). This is fine for now KVM never creates intermediate huge
> > pages during dirty logging, i.e. a 1GiB page is never partially split to
> > a 2MiB page.
> >
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting, which can in fact leave behind partially split
> > huge pages. In preparation for that change, change the shadow MMU to
> > iterate over all necessary levels when zapping collapsible SPTEs.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 89a7a8d7a632..2032be3edd71 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6142,18 +6142,30 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >       return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                        const struct kvm_memory_slot *slot)
> > +{
> > +     bool flush;
> > +
> > +     /*
> > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > +      * pages that are already mapped at the maximum possible level.
> > +      */
> > +     flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                               PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > +                               true);
> > +
> > +     if (flush)
> > +             kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +
> > +}
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> IMHO it looks cleaner to write it in the old way (drop the flush var).
> Maybe even unwrap the helper?

Unwrapping the helper and dropping the flush var makes the if
condition quite long and hard to read. But I think a compromise would
to have kvm_rmap_zap_collapsible_sptes() return flush and leave the
flush call in kvm_mmu_zap_collapsible_sptes().

>
> Thanks,
>
> --
> Peter Xu
>

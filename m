Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6CF5538D5
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiFURZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiFURZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:25:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268F62D1EE
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:25:15 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id w20so23485037lfa.11
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QxmNtn8D9Dq51lR45DZiK36aZDbgyY5PoNiGUjl0icA=;
        b=Ld+SXs+fbT42PedNRfBVwRPd4bGGEqJzfB0snipjuJDtE6hrnQapdgsyRXKLSaFLEF
         SeHC6LW/bNPOFZSmvGwC4yAulJod6HrkGlu2Q/HxkdPrvSMwginiMcuAwi+HJb8SrgJm
         Dg6a3LD574NJUNbQRoUEz/Z1/AYz/ywSt/LWvYmn69UESDBDxp/43gcSdd5zuehSKpxe
         5WfN11Dha6FzU37T6JD8yt50/Xsib8ACxxj6Hje3zAyjKUSYqWhA7ZK5VnJqJf5fs9Z0
         Wrc1cadDRYy1qG2WhCErGy19AwynWxr/HW00aYN4nILtBmD3ttCewO3nVp93ciSI0h92
         1qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QxmNtn8D9Dq51lR45DZiK36aZDbgyY5PoNiGUjl0icA=;
        b=SRt/migcSrmn4M6cBmEab6d3mCFcz2BLybP5XeOTv9c96S5AvSvP5jLkGqWUMlDQFs
         /btkFvy4IepaX1SBVC4QTj5mOtJusqDScGPkmGlSOpFSfe+wud8MuDH7hGxtzgbKQm+M
         Ul2DmK6Rb7ZAUaP+pdSmoesngulUEHBWr8/gjG1k/Hu2cEFFF2TFxS7PoHBPe251dHBB
         PHU41lIbS4oVVcHuiM5qLM+kiisR0WTiA3ULtqdDuAug8hMAQ9huoPj9v/Y5JLlkSMwj
         gDHDQlCBBZkRBFQmP/pb12L2nGX/ZD7PigydTelMDSGtS0ZfBgPrGWcBlVO9cYgyJBtM
         a0yw==
X-Gm-Message-State: AJIora9DtCdCNxMivpfo1yZ8bJ6ZxzV9+q0N2mbqVLzFH0Yj2H+aZJ0F
        5lzySoeevYtt0L3Ogwy49j8vXxs//KunSUu8G88row==
X-Google-Smtp-Source: AGRyM1s5cjr8sQNsMbvjgG6SWuG6iDiSvWJI9kOqfmURFLq5B+Ub8Rt52OPf2QusJc1z0mMA44WZn84iXTKx0ZqHfTo=
X-Received: by 2002:a05:6512:4004:b0:479:1d77:4e43 with SMTP id
 br4-20020a056512400400b004791d774e43mr17252143lfb.537.1655832313238; Tue, 21
 Jun 2022 10:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com> <20220516232138.1783324-20-dmatlack@google.com>
 <Yqyzavjp9eS9p4+m@google.com>
In-Reply-To: <Yqyzavjp9eS9p4+m@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 21 Jun 2022 10:24:46 -0700
Message-ID: <CALzav=dG9f2X8GBLjQgR-Lj4yPKX2Adg3C+9_9aC83A7mzmbtw@mail.gmail.com>
Subject: Re: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jun 17, 2022 at 10:01 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 16, 2022, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> > is fine for now since KVM never creates intermediate huge pages during
> > dirty logging. In other words, KVM always replaces 1GiB pages directly
> > with 4KiB pages, so there is no reason to look for collapsible 2MiB
> > pages.
> >
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting. During eager page splitting, each 1GiB is first
> > split into 2MiB pages and then those are split into 4KiB pages. The
> > intermediate 2MiB pages may be left behind if an error condition causes
> > eager page splitting to bail early.
> >
> > No functional change intended.
> >
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f83de72feeac..a5d96d452f42 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6177,18 +6177,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >       return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                        const struct kvm_memory_slot *slot)
> > +{
> > +     /*
> > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > +      * pages that are already mapped at the maximum possible level.
> > +      */
> > +     if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                           PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > +                           true))
>
> No need to wrap, "true" fits easily on the previous line.  That said, I don't see
> any point in adding a helper.  It's highly unlike there will be another caller,
> and IMO it's not any more readable since I have to go look at another function
> when reading kvm_mmu_zap_collapsible_sptes().

I could see an argument for readability either way. Putting it in a
helper function abstracts away the details, which would aid
readability if the reader does not care about the implementation
details of the rmap case.

I also have been thinking about splitting the rmap stuff out of mmu.c
(e.g. into rmap.c or shadow_mmu.c) to mirror the TDP MMU. That way we
can have a more clear split between the TDP MMU and shadow MMU, each
with their own file, and with higher level MMU operations that need to
operate on either or both MMUs living in mmu.c.

>
> With some gentle massaging, the comment can squeeze onto two lines even with the
> extra level of indentation.
>
>                 /*
>                  * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap
>                  * pages that are already mapped at the maximum hugepage level.
>                  */
>                 if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
>                                       PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true)
>                         kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>
> > +             kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +}
> > +
> >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *slot)
> >  {
> >       if (kvm_memslots_have_rmaps(kvm)) {
> >               write_lock(&kvm->mmu_lock);
> > -             /*
> > -              * Zap only 4k SPTEs since the legacy MMU only supports dirty
> > -              * logging at a 4k granularity and never creates collapsible
> > -              * 2m SPTEs during dirty logging.
> > -              */
> > -             if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> > -                     kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +             kvm_rmap_zap_collapsible_sptes(kvm, slot);
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > --
> > 2.36.0.550.gb090851708-goog
> >

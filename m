Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E492C52693E
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383309AbiEMS1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383308AbiEMS06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:26:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703151C13E
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:26:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so8342290pfe.13
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f3nBn1LwcriRtnTdKkMxJqrXvUJa99h1XpX9rIbmPsc=;
        b=RhJ/oVsdfQd/xDIXzKmKW89BkOLc+aB9PbcUuGD8DhE/r1xIp+zmzF5kbvsJgECked
         iIDCEwz4polbRa9Kza2tvUk6jUn+c10xHR6SCkOweNd9d/plenEL5MksTH2Zx6zNGeKz
         VBz7ICQbeCFH4zDwa7cyQ5r9phyax2KPG0XaKgy/L4Fae3lWJOYMoavacX6i60ivO2OH
         Y0H7NAccqvn8wLt+movJmmQXzSIItkXTeqicXrylSCSAfE8CxKsphG4sNpJoRcLavqjo
         5pjxkAIUhwC6CNq/bIGLGGwFkhGx74uXQXnbfxeKgn7oRxrBFscg5wrIvz11H3AXtWFf
         EifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f3nBn1LwcriRtnTdKkMxJqrXvUJa99h1XpX9rIbmPsc=;
        b=qUmn5WC4/Dr3kKJGM+SSOhbdNd1IrndW4rtAktB+4/+1pDxdfU9gKGY89MHnrqy4TC
         9kGZeeeMyzBiDuDR/ZrmNikZrJyKGeiiQdzbEAiJzrjoeVKcPGgD1LOofBW84EOj1GMr
         COgugmiXBIaVCYq/bnxuxqPh/PsbG/No5e4Cd74Rmuqd3qNOO0wFU7zEu3mKekKECHgZ
         6UDfoOw6ZfToe2UsliFTimovkouoK6m5tIYt/vBYGuh2fxC4ekuYyPfOUx8Coe5/F2q3
         sHWifY4pNf8DWlCUMFFD+pUPUI2RR8+dijgzuoZa/T0svD0LR2XPk5+q5hi6ThXBvNtp
         vIVA==
X-Gm-Message-State: AOAM531CPrtntNHT6cQxwCDPRP1pc9OPMWM0ypkozZL6zYxjdk9O/1QV
        xkrBdIw18IITNNSEi6T3Yfb1TA==
X-Google-Smtp-Source: ABdhPJx9wMHQkLxpxX6sjpmk8QGYH6lnHrQ2Dj8+GdFaKMu4dvSUQ4p0vrU3A0yjKp68wJ49odGJsA==
X-Received: by 2002:a63:d747:0:b0:3db:74a9:ff92 with SMTP id w7-20020a63d747000000b003db74a9ff92mr5012769pgi.293.1652466416498;
        Fri, 13 May 2022 11:26:56 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id i12-20020a17090ad34c00b001d96bc27a57sm1896907pjx.54.2022.05.13.11.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:26:55 -0700 (PDT)
Date:   Fri, 13 May 2022 18:26:51 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <Yn6i6yUkIKyzXb+j@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
 <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
 <CAJhGHyDQn=atFmn5o2TREW9cSY5Tv1F1vsSekzor6uYQxDgcfQ@mail.gmail.com>
 <CALzav=e0VnYar=jUr+C=uhVf9O6NDXaHx2rW-+yUocdHVk39Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=e0VnYar=jUr+C=uhVf9O6NDXaHx2rW-+yUocdHVk39Mg@mail.gmail.com>
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

On Thu, May 12, 2022 at 09:10:59AM -0700, David Matlack wrote:
> On Mon, May 9, 2022 at 7:58 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> > On Tue, May 10, 2022 at 5:04 AM David Matlack <dmatlack@google.com> wrote:
> > > On Sat, May 7, 2022 at 1:28 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> > > > On 2022/4/23 05:05, David Matlack wrote:
> > > > > +     /*
> > > > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > > > +      * pre-allocated and assigned a separate quadrant in their role.
> > > >
> > > >
> > > > It is not going to be true in patchset:
> > > > [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
> > > >
> > > > https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
> > > >
> > > > The shadow pages for those 4 page directories are also allocated on demand.
> > >
> > > Ack. I can even just drop this sentence in v5, it's just background information.
> >
> > No, if one-off special shadow pages are used.
> >
> > kvm_mmu_child_role() should be:
> >
> > +       if (role.has_4_byte_gpte) {
> > +               if (role.level == PG_LEVEL_4K)
> > +                       role.quadrant = (sptep - parent_sp->spt) % 2;
> > +               if (role.level == PG_LEVEL_2M)
> > +                       role.quadrant = (sptep - parent_sp->spt) % 4;
> > +       }
> >
> >
> > And if one-off special shadow pages are merged first.  You don't
> > need any calculation in mmu_alloc_root(), you can just directly use
> >     sp = kvm_mmu_get_page(vcpu, gfn, vcpu->arch.mmu->root_role);
> > because vcpu->arch.mmu->root_role is always the real role of the root
> > sp no matter if it is a normall root sp or an one-off special sp.
> >
> > I hope you will pardon me for my touting my patchset and asking
> > people to review them in your threads.
> 
> I see what you mean now. If your series is queued I will rebase on top
> with the appropriate changes. But for now I will continue to code
> against kvm/queue.

Here is what I'm going with for v5:

        /*
         * If the guest has 4-byte PTEs then that means it's using 32-bit,
         * 2-level, non-PAE paging. KVM shadows such guests with PAE paging
         * (i.e. 8-byte PTEs). The difference in PTE size means that
         * KVM must shadow each guest page table with multiple shadow page
         * tables, which requires extra bookkeeping in the role.
         *
         * Specifically, to shadow the guest's page directory (which covers a
         * 4GiB address space), KVM uses 4 PAE page directories, each mapping
         * 1GiB of the address space. @role.quadrant encodes which quarter of
         * the address space each maps.
         *
         * To shadow the guest's page tables (which each map a 4MiB region),
         * KVM uses 2 PAE page tables, each mapping a 2MiB region. For these,
         * @role.quadrant encodes which half of the region they map.
         *
         * Note, the 4 PAE page directories are pre-allocated and the quadrant
         * assigned in mmu_alloc_root(). So only page tables need to be handled
         * here.
         */
        if (role.has_4_byte_gpte) {
                WARN_ON_ONCE(role.level != PG_LEVEL_4K);
                role.quadrant = (sptep - parent_sp->spt) % 2;
        }

Then to make it work with your series we can just apply this diff:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7c4f08e8a69..0e0e2da2f37d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2131,14 +2131,10 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 a
         * To shadow the guest's page tables (which each map a 4MiB region),
         * KVM uses 2 PAE page tables, each mapping a 2MiB region. For these,
         * @role.quadrant encodes which half of the region they map.
-        *
-        * Note, the 4 PAE page directories are pre-allocated and the quadrant
-        * assigned in mmu_alloc_root(). So only page tables need to be handled
-        * here.
         */
        if (role.has_4_byte_gpte) {
-               WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-               role.quadrant = (sptep - parent_sp->spt) % 2;
+               WARN_ON_ONCE(role.level > PG_LEVEL_2M);
+               role.quadrant = (sptep - parent_sp->spt) % (1 << role.level);
        }

        return role;

If your series is queued first, I can resend a v6 with this change or Paolo can
apply it. If mine is queued first then you can include this as part of your
series.

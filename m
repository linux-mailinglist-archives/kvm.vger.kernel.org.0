Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C9736597
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjFTIBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjFTIB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:01:26 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF61E7D
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:01:23 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3fde9bfb3c8so434191cf.0
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687248083; x=1689840083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0soM3eBW17TUN7zlLidBNvK+EaFBcT8rKMwsr5hx58=;
        b=6oEmMLuUKY8JFmpDg5+v8E4MdTfurRjLoX1ABWiD8rzU/LoDjwWm0ElBunYvvTrVA9
         8jootSjhRUZ8mYyleJGBxXK5CcUGV9LC89/FsE1fwM3MFc18DbQLdNMT/KUlg2oXiLnf
         3hYu82RMtbq9gvVpHdRYAhY1c5cul9XOj4lfNfa8XuMmfActB+whqEOf7AttaUfJ7c0C
         3vzpiNwE1EtKzD+/va+/gJE+1XGIbiurMGkbGIv3LXcIiB+WsYskiA7/AEN02+rUbgu0
         NlCzIuWkeu5kq2y4PCTaglIB6hcUeYig1h/77sLoDyWgn/n47w+phuzDHthZW/SS7dfY
         7K6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687248083; x=1689840083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0soM3eBW17TUN7zlLidBNvK+EaFBcT8rKMwsr5hx58=;
        b=aGeCjHpXpjLuyjqjcJDgWY1fIplP+ZiEe06clWjUPcrPD0yy/MNxrQqAVS2W0jMNtw
         ev3yzG+0z9My2RMvuHPi0aTIUbn+uGRdrx2/u7IwWn1Z41pTQt6astt4rPE0pFq/4MmJ
         02++4MO/qq9MPM3ZS6GeMvhtwrIg2Z/SxIYsDwiKIUs5DSZRuuiMGHrUQQD0DhYrdHG0
         c/izxFIhqjKyDyjphIo0G+mpNDNLAIIRQ5hf5jOaqoLVrOwvk7Buqj8cZYzqiXa8BHUi
         i1f+s0tVDAmxIFTy36PqU7u94A56HPlouN8hwuc4UwobJ4ihHawVDVptTYEDvETJ8ybG
         apiw==
X-Gm-Message-State: AC+VfDxag27G7Ndn/b9LI/NjOKSQPpvOGg2F3177sojAnoaygeLzuDmd
        MJZCkdt92l2UZN6CUR10TlUaBz51wQopzAPa7hiSPg==
X-Google-Smtp-Source: ACHHUZ4xBX0RlLFDAXi6zryiB7+5YG80ltFJqS/gHVwlzdVsIwOci9YnZ/I3ji95of7DLw9rWv+GufohPkCcn7y0vzA=
X-Received: by 2002:a05:622a:589:b0:3ed:210b:e698 with SMTP id
 c9-20020a05622a058900b003ed210be698mr1007941qtb.7.1687248082908; Tue, 20 Jun
 2023 01:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-7-yuzhao@google.com>
 <CTH9N6UYDUM2.1974CRL32YFQC@wheely>
In-Reply-To: <CTH9N6UYDUM2.1974CRL32YFQC@wheely>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 20 Jun 2023 02:00:46 -0600
Message-ID: <CAOUHufY8egkNrxQwd6ms4j6ziyUW5uDjD=yhkxHLqAAOGB4Ccw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 06/10] kvm/powerpc: make radix page tables
 RCU safe
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Jun 20, 2023 at 12:33=E2=80=AFAM Nicholas Piggin <npiggin@gmail.com=
> wrote:
>
> On Sat May 27, 2023 at 9:44 AM AEST, Yu Zhao wrote:
> > KVM page tables are currently not RCU safe against remapping, i.e.,
> > kvmppc_unmap_free_pmd_entry_table() et al. The previous
>
> Minor nit but the "page table" is not RCU-safe against something. It
> is RCU-freed, and therefore some algorithm that accesses it can have
> the existence guarantee provided by RCU (usually there still needs
> to be more to it).
>
> > mmu_notifier_ops members rely on kvm->mmu_lock to synchronize with
> > that operation.
> >
> > However, the new mmu_notifier_ops member test_clear_young() provides
> > a fast path that does not take kvm->mmu_lock. To implement
> > kvm_arch_test_clear_young() for that path, orphan page tables need to
> > be freed by RCU.
>
> Short version: clear the referenced bit using RCU instead of MMU lock
> to protect against page table freeing, and there is no problem with
> clearing the bit in a table that has been freed.
>
> Seems reasonable.

Thanks. All above points taken.

> > Unmapping, specifically kvm_unmap_radix(), does not free page tables,
> > hence not a concern.
>
> Not sure if you really need to make the distinction about why the page
> table is freed, we might free them via unmapping. The point is just
> anything that frees them while there can be concurrent access, right?

Correct.

> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/=
book3s_64_mmu_radix.c
> > index 461307b89c3a..3b65b3b11041 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > @@ -1469,13 +1469,15 @@ int kvmppc_radix_init(void)
> >  {
> >       unsigned long size =3D sizeof(void *) << RADIX_PTE_INDEX_SIZE;
> >
> > -     kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size, 0, pte=
_ctor);
> > +     kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size,
> > +                                       SLAB_TYPESAFE_BY_RCU, pte_ctor)=
;
> >       if (!kvm_pte_cache)
> >               return -ENOMEM;
> >
> >       size =3D sizeof(void *) << RADIX_PMD_INDEX_SIZE;
> >
> > -     kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size, 0, pmd=
_ctor);
> > +     kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size,
> > +                                       SLAB_TYPESAFE_BY_RCU, pmd_ctor)=
;
> >       if (!kvm_pmd_cache) {
> >               kmem_cache_destroy(kvm_pte_cache);
> >               return -ENOMEM;
>
> KVM PPC HV radix PUD level page tables use the arch/powerpc allocators
> (for some reason), which are not RCU freed. I think you need them too?

We don't. The use of the arch/powerpc allocator for PUD tables seems
appropriate to me because, unlike PMD/PTE tables, we never free PUD
tables during the lifetime of a VM:
* We don't free PUD/PMD/PTE tables when they become empty, i.e., not
mapping any pages but still attached. (We could in theory, as
x86/aarch64 do.)
* We have to free PMD/PTE tables when we replace them with 1GB/2MB
pages. (Otherwise we'd lose track of detached tables.) And we
currently don't support huge pages at P4D level, so we never detach
and free PUD tables.

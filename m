Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E845019A2
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiDNRKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 13:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbiDNRHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 13:07:16 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A7237D2
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:51:04 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id x17so10107602lfa.10
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qvrUkzVKHcvjwS/dOYL2eAUFrCbo/ujl12UK6CglK68=;
        b=EIgRm51/IetvOo/3Yh3Gl6urcyZJ4z+1xaapljbLxnYp5lt3nSX5xOMs3YZubfLEcG
         qTqt560DVWAauBFHM0umldjq3mssFpTAQHvNUMujLASMc33xty+vXv9n59mX8ypWnR4e
         sqFEb6Yf1HjVrH36IqNy2C+RAeJrqmluUxzTaL46YfKtolRjMbUzhjsaqmCN87qH029g
         NT/eMmFuDtqB7yTkoWcCMpObiYtIBIVXM08BKFseEz9NnebwK0k5TjyqrqYjUpuzlolj
         4/FqwU2sWbRLnvUoi/r+4D1PmIWWY8qOzTCbaC/md3zdu+LEFNU7f7VbrAjMOOzhHRUn
         hAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qvrUkzVKHcvjwS/dOYL2eAUFrCbo/ujl12UK6CglK68=;
        b=oN+cfZuyDbVfC4zekbtWnBZDwj0HCySqT2uiIvXxLgXbuBpaBOx5viIT6S9BncUGuG
         Lwuv4vUy/XMyYtoH9wI5tVGBiWsNuoNOgaIf5dXJQjQDYnhIeynxIf3ICWqYttwwmuQH
         4zRS/MBLfHmqy8jpk3ESkXn4f+AVidwg3sgPeVj0S95NwbjGwyuYdQWZWsd9COyxRZFk
         He9dyw0OvsKWwK/ooSsorBpNmrHoWehqb1JND+wLPO1PUb/H2uPp6q1kY6H877MB7lIP
         Rq1bC3yLuGqkwTagbmMw2wMu/pwm4m9JwIFwU3fDmk8r62MRBNgDL8y+aiqIZlaRjBfb
         RV9w==
X-Gm-Message-State: AOAM533sMDkPgpHTZgNFvsajEkVYEKjRtyUkXzmZxPBpW+YS8dXjXMPH
        md6gvb5CzovvdGnywmu36Y1XWSI0aF9AADnpZ3nqNw==
X-Google-Smtp-Source: ABdhPJwTYmrgq+YiC1OHoIWKUV9qQJWQp/M3+brdX7k3OLjuX1IbMdBoJSptsooaePR2Njmi9uEyoVmsmBC+6Hmzymw=
X-Received: by 2002:a05:6512:1285:b0:46b:a899:1111 with SMTP id
 u5-20020a056512128500b0046ba8991111mr2524770lfs.190.1649955062178; Thu, 14
 Apr 2022 09:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com> <20220401175554.1931568-23-dmatlack@google.com>
 <YlDV27ediz+rBuLd@google.com>
In-Reply-To: <YlDV27ediz+rBuLd@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 14 Apr 2022 09:50:35 -0700
Message-ID: <CALzav=f7wtHtTi6z64Br8P_aKiNqHivMi7zwQDxFfqiPGXpBeA@mail.gmail.com>
Subject: Re: [PATCH v3 22/23] KVM: x86/mmu: Support Eager Page Splitting in
 the shadow MMU
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

On Fri, Apr 8, 2022 at 5:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 01, 2022, David Matlack wrote:
> > Add support for Eager Page Splitting pages that are mapped by the shadow
> > MMU. Walk through the rmap first splitting all 1GiB pages to 2MiB pages,
> > and then splitting all 2MiB pages to 4KiB pages.
> >
> > Splitting huge pages mapped by the shadow MMU requries dealing with some
> > extra complexity beyond that of the TDP MMU:
> >
> > (1) The shadow MMU has a limit on the number of shadow pages that are
> >     allowed to be allocated. So, as a policy, Eager Page Splitting
> >     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
> >     pages available.
> >
> > (2) Huge pages may be mapped by indirect shadow pages which have the
> >     possibility of being unsync. As a policy we opt not to split such
> >     pages as their translation may no longer be valid.
>
> This shouldn't be possible, shadow pages whose role is > 4k are always write-protected
> and not allowed to become unsync.

Ah ok, then the unsync check is unnecessary (or at least could WARN_ON()).

>
> >
> > (3) Splitting a huge page may end up re-using an existing lower level
> >     shadow page tables. This is unlike the TDP MMU which always allocates
> >     new shadow page tables when splitting.
>
> ...
>
> > +static void kvm_mmu_split_huge_page(struct kvm *kvm,
> > +                                 const struct kvm_memory_slot *slot,
> > +                                 u64 *huge_sptep, struct kvm_mmu_page **spp)
> > +
> > +{
> > +     struct kvm_mmu_memory_cache *cache = &kvm->arch.huge_page_split_desc_cache;
> > +     u64 huge_spte = READ_ONCE(*huge_sptep);
> > +     struct kvm_mmu_page *sp;
> > +     bool flush = false;
> > +     u64 *sptep, spte;
> > +     gfn_t gfn;
> > +     int index;
> > +
> > +     sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
> > +
> > +     for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > +             sptep = &sp->spt[index];
> > +             gfn = kvm_mmu_page_get_gfn(sp, index);
> > +
> > +             /*
> > +              * sp may have populated page table entries, e.g. if this huge
> > +              * page is aliased by multiple sptes with the same access
> > +              * permissions. We know the sptes will be mapping the same
> > +              * gfn-to-pfn translation since sp is direct. However, a given
> > +              * spte may point to an even lower level page table. We don't
> > +              * know if that lower level page table is completely filled in,
> > +              * i.e. we may be effectively unmapping a region of memory, so
> > +              * we must flush the TLB.
>
> Random side topic, please avoid "we" and other pronouns in comments and changelogs,
> it gets real easy to lose track of what a pronoun is referring to, especially in
> changelogs where "we" might be KVM, might be the kernel, might be the team that's
> using the patch, might be an author that's prone to illeism, etc...

Agreed. It's a bad habit of mine, and despite conscious effort to
limit use of "we" in my comments and change logs, it inevitably creeps
in. I'll do a pass on this series to get rid of the use of "we"
throughout.

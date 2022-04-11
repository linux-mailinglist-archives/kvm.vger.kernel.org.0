Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC44FC3B7
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiDKR4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 13:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiDKR4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 13:56:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4E52655B
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:54:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y32so28026564lfa.6
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81KqlwJhbv6nQ8ebh7jN8WcTipHmVVl5ghzOeZE9RVQ=;
        b=E1kGCD8WCRRnHn2zbVHKJ/X1yi2Xi3FWW0qvqP8HxKjKFmpFbzh9Ld/SPZwiEw3MAJ
         W4jS2csQ6AJe7kCH64nkcoH+tzzLpOgCgoig7PBIW0But8TsyfchozTKy5jA84AQj2bH
         KpIKdIE0VUAFBu8aELCWJ6JaaiCRMocFKd/rnd049s1xyPamnxhahQUAN3K3yrXNiQ5d
         wVTH+jJNAsxxHSbtvJXy0lgG5bcdazySFK0O+P4IFHojSeyIRVWkZwe4fxVZ8Kerlzaw
         cykiJDnmoyuSIr5/Ri8/tWYsJwxLoJ+u/3F0gi9h7ieb3hm5hlwR8I+abk98hY1R40rJ
         3l+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81KqlwJhbv6nQ8ebh7jN8WcTipHmVVl5ghzOeZE9RVQ=;
        b=hAAGKxRdiMZEKOwYSPxMpF74DYSbkUxTNRqpiELUtQFaZqV1EFKkvqYZ04uVLGnWBz
         6M+gj3cHwTzmL3FMdcHYuKc1IJJPlkgFlyTClmVY6VQKa7InelXMStfeqHc9Dacg4PR8
         zVUaJWiLBoxTuEI5w/w99Gej8kc1O7qChMNPyaVc9pghoJk/dwPKO0madPCfsDfsH+1n
         UpzsSBI7b98zHLbzRv3wHRzakqm+TvLQdpZxszEJLtoeFXoH0OST764vlzuqeah+n34U
         QwaelLVmDwhxT7tFcqKn73L8rcFjhITZ3fWLNf6unLQr2pYg7F4No1FYpJBovHzhH6fr
         u0lg==
X-Gm-Message-State: AOAM531bserltnLyAdentXCWbbPLeTFKc0vRbMg5/MIguuNGq5TSjtBG
        Ha4cep0T/OcflfXeTTjVScvlPPF5ieGcAdOekoO+Sw==
X-Google-Smtp-Source: ABdhPJyxpSS+5LOkGiR0Rztv6fmSU0ZSRggQC8TMDAKLTRhL5Vsc51sydao9se21gy8frto2eZ6c+MPlnxnb7xeYBcI=
X-Received: by 2002:a05:6512:32c2:b0:46b:a5ed:e117 with SMTP id
 f2-20020a05651232c200b0046ba5ede117mr4529073lfg.102.1649699669421; Mon, 11
 Apr 2022 10:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com> <YlRhiF1O71TWQr5r@google.com>
In-Reply-To: <YlRhiF1O71TWQr5r@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Apr 2022 10:54:02 -0700
Message-ID: <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow MMU
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

On Mon, Apr 11, 2022 at 10:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 01, 2022, David Matlack wrote:
> > This series extends KVM's Eager Page Splitting to also split huge pages
> > mapped by the shadow MMU, i.e. huge pages present in the memslot rmaps.
> > This will be useful for configurations that use Nested Virtualization,
> > disable the TDP MMU, or disable/lack TDP hardware support.
> >
> > For background on Eager Page Splitting, see:
> >  - Proposal: https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/
> >  - TDP MMU support: https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
> >
> > Splitting huge pages mapped by the shadow MMU is more complicated than
> > the TDP MMU, but it is also more important for performance as the shadow
> > MMU handles huge page write-protection faults under the write lock.  See
> > the Performance section for more details.
> >
> > The extra complexity of splitting huge pages mapped by the shadow MMU
> > comes from a few places:
>
> I think we should restrict eager page splitting to the TDP MMU being enabled,
> i.e. restrict shadow MMU support to nested MMUs.
>
> A decent chunk of the churn and complexity in this series comes from having to
> deal with the intersection of things no one cares about in practice (!TDP shadow
> paging), and/or things we should be putting into maintenance-only mode (legacy MMU
> with TDP enabled).  I see zero reason to support this for legacy shadow paging
> without a very concrete, very performance sensitive use case, and the legacy MMU
> with TDP should be a hard "no".
>
> With those out of the way, unsync support can also be jettisoned, because barring
> use cases I don't know about, hypervisors don't modify TDP entries in the same way
> that kernels modify native page tables, i.e. don't benefit from allowing SPTEs to
> go unsync.
>
> The other feature that I think we should deprecate (which I'm pretty sure someone on
> our team, maybe even you, is planning on proposing upstream) is support for zapping
> KVM shadow pages for the shrinker.  In hindsight, we should have done that a few
> years ago instead of fixing the bug that made KVM's support meaningful (see commit
> ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU pages when shrinking the slab").  Doing
> that for nested MMUs only (or at least first) should be less controversial.
>
> The other thing we want to do sooner than later is improve the scalability of the
> nested MMU.  A relatively simple way to pick some juicy low hanging fruit, if we
> drop the aforementioned features we don't actually need for nested MMUs, would be
> to turn all of the tracking structures needed for handling a page fault into
> per-root lists/structures, e.g. active_mmu_pages and mmu_page_hash.  Unless L1 is
> doing something funky, there is unlikely to be overlap between nested TDP page
> tables, i.e. per-root tracking shouldn't cause a memory explosion.
>
> At that point, as a first step/stopgap toward a more scalable nested MMU implementation,
> nested TDP page faults, zapping of obsolete pages (memslot updates), and eager page
> splitting (I think) can take mmu_lock for read and then take a per-root spinlock.
>
> At a bare minimum, taking mmu_lock for read would prevent a nested vCPU from blocking
> the TDP MMU, which in itself should be a big win.  Zapping after a memslot updates
> would not interfere at all with re-faulting memory since zapping the obsolete roots
> would never get a lock conflict.  And for use cases that spin up a large number of small
> L2 VMs, per-root locking will allow KVM to handle page faults for each L2 in parallel,
> which could be a huge performance boost for select use cases.
>
> Circling back to eager page splitting, this series could be reworked to take the
> first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
> order to provide the necessary path for reworking nested MMU page faults.  Then it
> can remove unsync and shrinker support for nested MMUs.  With those gone,
> dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
> than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
> some of the complexity/churn.

These sound like useful improvements but I am not really seeing the
value of sequencing them before this series:

 - IMO the "churn" in patches 1-14 are a net improvement to the
existing code. They improve readability by decomposing the shadow page
creation path into smaller functions with better names, reduce the
amount of redundant calculations, and reduce the dependence on struct
kvm_vcpu where it is not needed. Even if eager page splitting is
completely dropped I think they would be useful to merge.

 - Patches 15-21 are necessary complexity to support eager page
splitting, but wouldn't change at all if this splitting was specific
to splitting nested MMUs.

 - Outside of patches 1-14, unsync really doesn't play a role other
than to skip splitting if sp->unsync is true. But as you pointed out
in patch 22, that check can already be dropped since SPs with roles
>4k are never marked unsync.

I'd be fine with limiting eager page splitting to tdp_mmu=Y since
nested is the primary use-case for Google and I agree TDP with the
shadow MMU should be phased out. This would be an artificial
limitation in the short term, but I imagine it would make all those
improvements easier to make down the road.

>
> > Performance
> > -----------
> >
> > To measure the performance impact of Eager Page Splitting I ran
> > dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> > vCPU, and backed by 1GiB HugeTLB memory. The amount of memory that was
> > written to versus read was controlled with the -f option.
> >
> > To measure the imapct of customer performance, we can look at the time
> > it takes all vCPUs to dirty memory after dirty logging has been enabled.
> > Without Eager Page Splitting enabled, such dirtying must take faults to
> > split huge pages and bottleneck on the MMU lock.
> >
> >              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
> >              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
> >              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
> >              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
> >              | Config: ept=N, tdp_mmu=Y, 100% writes                   |
> >              | Config: ept=N, tdp_mmu=Y, 50% writes                    |
> >              | Config: ept=N, tdp_mmu=Y, 5% writes                     |
>
> IMO, to justify this there needs to be performance numbers for ept=Y, tdp_mmu=Y,
> i.e. for the use case we actually care about.  I don't expect the outcome to be
> any different, but it really should be explicitly tested.

That's a fair request I guess. There should be no difference in
performance from the ept=N results but it require a lot more effort to
rig up, which is why I tested this way.

I'll look into collecting some results with nested MMUs. On the plus
side, better selftests support for nested MMUs will be useful as the
various improvements you suggested are implemented.

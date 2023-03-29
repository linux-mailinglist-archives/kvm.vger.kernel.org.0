Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546C36CCEC6
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 02:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjC2A2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjC2A2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 20:28:37 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38E410F2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:28:35 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id b6so8706133vsu.12
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PyqHjtL+rZkr3QGhJXzTG5s8vpvz1mXKLrceNpD1m0E=;
        b=M9D88JPWAMKk/pgNwzzYgI5z1YNJXtj2tHk9EUoYPep6DDDgRuFEYvODeR83uSatIY
         VUUbWLmlC1adBiKBFalomI+msFx3OAwmeW/YUIsmvSfwa5jAsmHm926CnzJ6ZrUFtooX
         6vXPXVDamJUKmhkaqKk6Yj4947AW74g9+PUg1lw1O3zUzjKjObNThCXjKW8wFwEtP9wQ
         tPRCY+PhQKg3iEOx8vMxZEdu6Zqnwp2rdnjC+DRUXrCfaFpP1KUc8REA1Xt+ZKPzq+iP
         g8IquFTs/Gg+iMGbfV+lpSU0yjsU/ZOCUOWgDfXZbvH1xE4Sn0vywyYFGYkg+BRRXypG
         xgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyqHjtL+rZkr3QGhJXzTG5s8vpvz1mXKLrceNpD1m0E=;
        b=qQt6oV3SZSwf8Y8B9AaIm8qBvzHltcV5qHc3mV/S7IcQbwUnQpxdNw6WaUvzktzMXG
         XitTECp+9m5GxXJo7+vKCZUv6Eg2IN3I3JqESrE9kRbtPReRgWzqK9nQ8U0WAVxwYW83
         kNeRJ/B6h62n4EljxRla73/H93VJB83/Nr81yPF0NGMQoUPAR574PbedfGRLMUG8gzSD
         A7WqK2lX5vlYRHHY2CbxivXt8ixDMLV3lKA9+ELka/WeAbW0FVNA+G4dVcYGPXlb/zKA
         EoNmcPvmLaGssIJitHZXNKeP0X3kPleP7S94PX1uC2W7iXyCb97bXLWKOyVSKTRAiN5w
         VVvw==
X-Gm-Message-State: AAQBX9cKt8inK7Pqke0LKGnTJZJ1XuZazlNCXzl94qWo4BLdhqb4hKed
        13r932j+MLDueGkcIbv8tPGZbDey2Z9h5XNqvwp7CpXEC+Fj8JXwu4s=
X-Google-Smtp-Source: AKy350ZOliy/SrIqb9WDpAtZYeUPgOgFxGeA6z3FKouIkdmj0YFGQzv89AfV53KPpPDZOrknJAXuZ0r2dC4w/giA6Pw=
X-Received: by 2002:a67:d994:0:b0:423:e694:7a7d with SMTP id
 u20-20020a67d994000000b00423e6947a7dmr9880934vsj.4.1680049714775; Tue, 28 Mar
 2023 17:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-17-vipinsh@google.com>
 <ZCOEiVT31xEPKZ3H@google.com>
In-Reply-To: <ZCOEiVT31xEPKZ3H@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 28 Mar 2023 17:28:08 -0700
Message-ID: <CALzav=cKY37njK0=jsw7fiUsqLWVw0ir0LEYr6O=R+NPk2nVHw@mail.gmail.com>
Subject: Re: [Patch v4 16/18] KVM: x86/mmu: Allocate numa aware page tables
 during page fault
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 5:21=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Mar 06, 2023 at 02:41:25PM -0800, Vipin Sharma wrote:
> > Allocate page tables on the preferred NUMA node via memory cache during
> > page faults. If memory cache doesn't have a preferred NUMA node (node
> > value is set to NUMA_NO_NODE) then fallback to the default logic where
> > pages are selected based on thread's mempolicy. Also, free NUMA aware
> > page caches, mmu_shadow_page_cache, when memory shrinker is invoked.
> >
> > Allocate root pages based on the current thread's NUMA node as there is
> > no way to know which will be the ideal NUMA node in long run.
> >
> > This commit allocate page tables to be on the same NUMA node as the
> > physical page pointed by them, even if a vCPU causing page fault is on =
a
> > different NUMA node. If memory is not available on the requested NUMA
> > node then the other nearest NUMA node is selected by default. NUMA awar=
e
> > page tables can be beneficial in cases where a thread touches lot of fa=
r
> > memory initially and then divide work among multiple threads. VMs
> > generally take advantage of NUMA architecture for faster memory access
> > by moving threads to the NUMA node of the memory they are accessing.
> > This change will help them in accessing pages faster.
> >
> > Downside of this change is that an experimental workload can be created
> > where a guest threads are always accessing remote memory and not the on=
e
> > local to them. This will cause performance to degrade compared to VMs
> > where numa aware page tables are not enabled. Ideally, these VMs when
> > using non-uniform memory access machine should generally be taking
> > advantage of NUMA architecture to improve their performance in the firs=
t
> > place.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          | 63 ++++++++++++++++++++++++---------
> >  arch/x86/kvm/mmu/mmu_internal.h | 24 ++++++++++++-
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  4 +--
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 14 +++++---
> >  include/linux/kvm_types.h       |  6 ++++
> >  virt/kvm/kvm_main.c             |  2 +-
> >  7 files changed, 88 insertions(+), 27 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 64de083cd6b9..77d3aa368e5e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -787,7 +787,7 @@ struct kvm_vcpu_arch {
> >       struct kvm_mmu *walk_mmu;
> >
> >       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > -     struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > +     struct kvm_mmu_memory_cache mmu_shadow_page_cache[MAX_NUMNODES];
>
> I think we need an abstraction for a NUMA-aware mmu cache, since there
> is more than one by the end of this series.
>
> e.g. A wrapper struct (struct kvm_mmu_numa_memory_cache) or make
> NUMA-awareness an optional feature within kvm_mmu_memory_cache, plus
> common helper functions for operations like initializing, topping-up,
> and freeing.
>
> I have some ideas I want to try but I ran out of time today.
>
> >       struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
> >       struct kvm_mmu_memory_cache mmu_page_header_cache;
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index d96afc849ee8..86f0d74d35ed 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -702,7 +702,7 @@ static void mmu_free_sp_memory_cache(struct kvm_mmu=
_memory_cache *cache)
> >
> >  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_i=
ndirect)
> >  {
> > -     int r;
> > +     int r, nid =3D KVM_MMU_DEFAULT_CACHE_INDEX;
> >
> >       /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
> >       r =3D kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_ca=
che,
> > @@ -710,7 +710,16 @@ static int mmu_topup_memory_caches(struct kvm_vcpu=
 *vcpu, bool maybe_indirect)
> >       if (r)
> >               return r;
> >
> > -     r =3D mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache=
, PT64_ROOT_MAX_LEVEL);
> > +     if (kvm_numa_aware_page_table_enabled(vcpu->kvm)) {
> > +             for_each_online_node(nid) {
>
> Blegh. This is going to potentially waste a lot of memory. Yes the
> shrinker can free it, but the next fault will re-allocate all the online
> node caches.
>
> The reason we have to top-up all nodes is because KVM tops up caches
> before faulting in the PFN, and there is concern that changing this will
> increase the rate of guest page-fault retries [1].
>
> I think we should revisit that concern. Can we do any testing to
> validate that hypothesis? Or can we convince ourselves that re-ordering
> is ok?
>
> [1] https://lore.kernel.org/kvm/CAHVum0cjqsdG2NEjRF3ZRtUY2t2=3DTb9H4OyOz9=
wpmsrN--Sjhg@mail.gmail.com/

Ah I forgot about patch 18 reducing the default cache size. So at the
end of this series, even with topping up every node, the maximum
number of objects per cache will be 4 * num_online_nodes. So only
hosts with more than 10 online NUMA nodes would have larger caches
than today (40). That seems more reasonable to me.

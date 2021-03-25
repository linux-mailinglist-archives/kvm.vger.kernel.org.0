Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEBC349BD0
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 22:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCYVrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 17:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCYVqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 17:46:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38EC06175F
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 14:46:29 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v26so3393262iox.11
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nBrMkW25RTecIM3hEhR4kecTK3fFu6wpCbY5kwZyG4Q=;
        b=JHYJgUhUsYqX55rxamtclZPCfo9DHHOSOIa400JzWWukiP0pWGpCVdS09EUr0vb6Wb
         1H3V94hFDzq/SVSN+Aa2myni0ER19Ozl0oprp5ky29Eu7QL4bqWb71pen/MEIItv/RyT
         fRyxrDfYM7V4EQXKGvCtuVsKA1wBhiw8kEo8hApRIHz8ULhN467IypVPO1lxYL6ZF9qG
         3cMWvcLwQP4nqnpbYuEHsK2OfyiNuuoWxoYkDPUZE0e+ZYae36X6LDwp/fZ47ViU8ve2
         lbC+VWys7LvZhAEdCGlXubP1n4qNnTXa2bMr7mXUUjYG2dIM6PGJqqVFDu2RX6jJRHEK
         8iDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBrMkW25RTecIM3hEhR4kecTK3fFu6wpCbY5kwZyG4Q=;
        b=X762lx0yIfI4VoYyTUwzszcIdER9425rFt24EVa7iF5Ol/bHyumZewR6tpn2q7yI4o
         bYTWM3NObmpREtHpu4Uw3YtP4gTYjs3HiBWr86/xVgZWAKoTdlyYrvxvSjee+uCGnC6v
         hU8yqVPgIEFNCkleSMm8oK68nIbRElcoJ0sJhrZTKZsWfets/bHPg5cvP/HSusTMAdOu
         BmQZG/aJdhtnWN8ZQpiqPpcQ0qrl7TfhksB5Ys1dnnB2jPIrR0W8vD2uywY9/PSVK9dE
         ICT4gXpS8+ycllv4kOGmeRrGgf9zfK+Xz6b92IxY2oD3gfF2i36WG+qGR1XaOPwu/Zvg
         lBtQ==
X-Gm-Message-State: AOAM532Dn1ty+nxeK75f0l6gHaKhe2rlQJSZsWGGLY10vhC3ADoYe+bC
        7NJZBljDkPKXsUUpGdyqjRu/Ed7w4plDhsm09CrlcQ==
X-Google-Smtp-Source: ABdhPJzJ1j4xAYyTbhVWfvYseFDA+FKV9V1JQ8vx8/TCWTP6rrcFtYabFuGm5F1H7XIQgSAa2IkDvb6yNX4Bqb63WNs=
X-Received: by 2002:a05:6638:3049:: with SMTP id u9mr9142192jak.57.1616708788964;
 Thu, 25 Mar 2021 14:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210325200119.1359384-1-seanjc@google.com> <20210325200119.1359384-4-seanjc@google.com>
In-Reply-To: <20210325200119.1359384-4-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 25 Mar 2021 14:46:18 -0700
Message-ID: <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Prevent the TDP MMU from yielding when zapping a gfn range during NX
> page recovery.  If a flush is pending from a previous invocation of the
> zapping helper, either in the TDP MMU or the legacy MMU, but the TDP MMU
> has not accumulated a flush for the current invocation, then yielding
> will release mmu_lock with stale TLB entriesr

Extra r here.

>
> That being said, this isn't technically a bug fix in the current code, as
> the TDP MMU will never yield in this case.  tdp_mmu_iter_cond_resched()
> will yield if and only if it has made forward progress, as defined by the
> current gfn vs. the last yielded (or starting) gfn.  Because zapping a
> single shadow page is guaranteed to (a) find that page and (b) step
> sideways at the level of the shadow page, the TDP iter will break its loop
> before getting a chance to yield.
>
> But that is all very, very subtle, and will break at the slightest sneeze,
> e.g. zapping while holding mmu_lock for read would break as the TDP MMU
> wouldn't be guaranteed to see the present shadow page, and thus could step
> sideways at a lower level.
>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 +---
>  arch/x86/kvm/mmu/tdp_mmu.c |  5 +++--
>  arch/x86/kvm/mmu/tdp_mmu.h | 23 ++++++++++++++++++++++-
>  3 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5a53743b37bc..7a99e59c8c1c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5940,7 +5940,6 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>         unsigned int ratio;
>         LIST_HEAD(invalid_list);
>         bool flush = false;
> -       gfn_t gfn_end;
>         ulong to_zap;
>
>         rcu_idx = srcu_read_lock(&kvm->srcu);
> @@ -5962,8 +5961,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>                                       lpage_disallowed_link);
>                 WARN_ON_ONCE(!sp->lpage_disallowed);
>                 if (is_tdp_mmu_page(sp)) {
> -                       gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> -                       flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end);
> +                       flush = kvm_tdp_mmu_zap_sp(kvm, sp);
>                 } else {
>                         kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>                         WARN_ON_ONCE(sp->lpage_disallowed);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6cf08c3c537f..08667e3cf091 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -709,13 +709,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   * SPTEs have been cleared and a TLB flush is needed before releasing the
>   * MMU lock.
>   */
> -bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
> +bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
> +                                bool can_yield)
>  {
>         struct kvm_mmu_page *root;
>         bool flush = false;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root)
> -               flush = zap_gfn_range(kvm, root, start, end, true, flush);
> +               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
>
>         return flush;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3b761c111bff..715aa4e0196d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -8,7 +8,28 @@
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>  void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
>
> -bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
> +bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
> +                                bool can_yield);
> +static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
> +                                            gfn_t end)
> +{
> +       return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
> +}
> +static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)

I'm a little leary of adding an interface which takes a non-root
struct kvm_mmu_page as an argument to the TDP MMU.
In the TDP MMU, the struct kvm_mmu_pages are protected rather subtly.
I agree this is safe because we hold the MMU lock in write mode here,
but if we ever wanted to convert to holding it in read mode things
could get complicated fast.
Maybe this is more of a concern if the function started to be used
elsewhere since NX recovery is already so dependent on the write lock.
Ideally though, NX reclaim could use MMU read lock +
tdp_mmu_pages_lock to protect the list and do reclaim in parallel with
everything else.
The nice thing about drawing the TDP MMU interface in terms of GFNs
and address space IDs instead of SPs is that it doesn't put
constraints on the implementation of the TDP MMU because those GFNs
are always going to be valid / don't require any shared memory.
This is kind of innocuous because it's immediately converted into that
gfn interface, so I don't know how much it really matters.

In any case this change looks correct and I don't want to hold up
progress with bikeshedding.
WDYT?

> +{
> +       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> +
> +       /*
> +        * Don't allow yielding, as the caller may have a flush pending.  Note,
> +        * if mmu_lock is held for write, zapping will never yield in this case,
> +        * but explicitly disallow it for safety.  The TDP MMU does not yield
> +        * until it has made forward progress (steps sideways), and when zapping
> +        * a single shadow page that it's guaranteed to see (thus the mmu_lock
> +        * requirement), its "step sideways" will always step beyond the bounds
> +        * of the shadow page's gfn range and stop iterating before yielding.
> +        */
> +       return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
> +}
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> --
> 2.31.0.291.g576ba9dcdaf-goog
>

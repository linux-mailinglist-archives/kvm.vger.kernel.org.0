Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A381F29CBC6
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 23:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832214AbgJ0WJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 18:09:23 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36428 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505934AbgJ0WJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 18:09:23 -0400
Received: by mail-il1-f195.google.com with SMTP id p10so2948479ile.3
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 15:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtLd4MZtASQ2zrGtGhpf+MoowsKrVZdCQedmVoJd9Rc=;
        b=SueMScFfjbh8XdzU6F54EIkMXs8/Wtn/eXnJRab8hMwLvr8ZYxl9q4sbIuHjn6xIZM
         gNu7A9DCdnVKmAFaRgH1p8pHuaDP8b31v2ISiN+iH4o/QAohO08LS6eP75LpqUKGbo5t
         0QToa+81/KVB1jd4PH9AFE75XKUJ8pbo8pF/yez9VjMJTaehId5F9mPLuIu+vtA2Frxf
         UPJba55YPJ1EvpCJeA4JnQLXVUo45vtF24vQf0+at8Ha9ehe0+J0AQiwX729a8++U8wU
         cxKwN/occG1uD9K/uClYiEaKCKws1mpNXP4t1R4EivxxlkljqqOM7SvFykOTcSaX1+sJ
         XBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtLd4MZtASQ2zrGtGhpf+MoowsKrVZdCQedmVoJd9Rc=;
        b=rTOCfNFs9jiSM3gW23yr++Rsw3omWOV5o9bPLOaZ4RVAbNF7IQlN/E6GQswkkEte8+
         Nrgp6VKwkF8CBob9VAuuw9Zm/IcqK2SuJuSyloAnJhiLnBImmlm5KvP8HKhBpz98h+4X
         ruEvd8d7Y5JGPtMGyjwAKpEoX2VRpr4ngl6twk76NcMMfee+Xp098GW5Uw1U9vNVh7Mf
         8LWz384D9XkJzVNiB4HlV6828xvnixuifzPPx5iUn2z0yAQXb+pWpJdO3aJK404MMgq3
         NyQMvAbz5o/Y6rEDf2pIcR8Wm4j0Ui3MWQDk2QlxS3qxMrS4Gh3t7yKfhenSZ/PFMvBl
         cwbA==
X-Gm-Message-State: AOAM531Z5lOsh2sGMAUvQqyRNOSG6tRTzRvnK9fa0Il2x57mQt/AqknM
        aeJdlUb4+eRkeXIdqkwlmi/QD5Xxto2R8Dd5NfdrJQ==
X-Google-Smtp-Source: ABdhPJypKDAq1rQjjgvHDQbdQftG1QcR2f98eezxhqgOKx9tvzDnLVPDf+6LM+Ik0DY5aif+/6IHMAGLZz31pkPLlgQ=
X-Received: by 2002:a92:d5c4:: with SMTP id d4mr3228850ilq.154.1603836561979;
 Tue, 27 Oct 2020 15:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201027214300.1342-1-sean.j.christopherson@intel.com> <20201027214300.1342-4-sean.j.christopherson@intel.com>
In-Reply-To: <20201027214300.1342-4-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 27 Oct 2020 15:09:11 -0700
Message-ID: <CANgfPd-cOrEnEbtPkRHgW3yVZQJtpbzr77+nj5+Hq6W2TJys-g@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Use hugepage GFN mask to compute GFN
 offset mask
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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

On Tue, Oct 27, 2020 at 2:43 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use the logical NOT of KVM_HPAGE_GFN_MASK() to compute the GFN offset
> mask instead of open coding the equivalent in a variety of locations.

I don't see a "no functional change expected" note on this patch as
was on the previous one, but I don't think this represents any
functional change.

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c      | 2 +-
>  arch/x86/kvm/mmu/mmutrace.h | 2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c  | 2 +-
>  arch/x86/kvm/x86.c          | 6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3bfc7ee44e51..9fb50c666ec5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2827,7 +2827,7 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
>          * mmu_notifier_retry() was successful and mmu_lock is held, so
>          * the pmd can't be split from under us.
>          */
> -       mask = KVM_PAGES_PER_HPAGE(level) - 1;
> +       mask = ~KVM_HPAGE_GFN_MASK(level);
>         VM_BUG_ON((gfn & mask) != (pfn & mask));
>         *pfnp = pfn & ~mask;
>
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index 213699b27b44..4432ca3c7e4e 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -372,7 +372,7 @@ TRACE_EVENT(
>
>         TP_fast_assign(
>                 __entry->gfn = addr >> PAGE_SHIFT;
> -               __entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
> +               __entry->pfn = pfn | (__entry->gfn & ~KVM_HPAGE_GFN_MASK(level));
>                 __entry->level = level;
>         ),
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27e381c9da6c..681686608c0b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -209,7 +209,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>
>         WARN_ON(level > PT64_ROOT_MAX_LEVEL);
>         WARN_ON(level < PG_LEVEL_4K);
> -       WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
> +       WARN_ON(gfn & ~KVM_HPAGE_GFN_MASK(level));
>
>         /*
>          * If this warning were to trigger it would indicate that there was a
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 397f599b20e5..faf4c4ddde94 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10451,16 +10451,16 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>
>                 slot->arch.lpage_info[i - 1] = linfo;
>
> -               if (slot->base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
> +               if (slot->base_gfn & ~KVM_HPAGE_GFN_MASK(level))
>                         linfo[0].disallow_lpage = 1;
> -               if ((slot->base_gfn + npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
> +               if ((slot->base_gfn + npages) & ~KVM_HPAGE_GFN_MASK(level))
>                         linfo[lpages - 1].disallow_lpage = 1;
>                 ugfn = slot->userspace_addr >> PAGE_SHIFT;
>                 /*
>                  * If the gfn and userspace address are not aligned wrt each
>                  * other, disable large page support for this slot.
>                  */
> -               if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
> +               if ((slot->base_gfn ^ ugfn) & ~KVM_HPAGE_GFN_MASK(level)) {
>                         unsigned long j;
>
>                         for (j = 0; j < lpages; ++j)
> --
> 2.28.0
>

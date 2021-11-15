Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901E6451D79
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347066AbhKPAaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbhKOTap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:30:45 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD273C061226
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:20:38 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id t26so5360108lfk.9
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKu5UPhQdIGWGqSTG7MfkgLRy3JiEmmXHIx1eX/IYhA=;
        b=s0QySkmrrEGyttshq2/3TbHCX5Pf7dD0xWlhvbFlW44PoSbd0mOp5vCfLQ3bsoXTl2
         emCMdcJQB7MjsrrLCCpXtNsMyYWyIuT0djwg5+6Poq1pOFRXvqKqpO09hFqo5+BMvbfQ
         GDIhjw+wUBtd79xG1hf6LDFl6QnVr9JB4Wqb7Y0utEm7NqEniIxfk3c7g2+h+AaSj1Fe
         1VH0v3phB0udEpmkRjH+Ev2HT4Gt+RZrUGVaIVUaMhTKw4GeKnP/Y47N0n/vnFpIEiMO
         FpTbcQ6B6EfVKU1wsWJWI0ocNS4CHMNn7+eypNqRUY9nOULHbzm9jNZe3TdVPRBXtVD5
         QpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKu5UPhQdIGWGqSTG7MfkgLRy3JiEmmXHIx1eX/IYhA=;
        b=d5MUnnH0EhQlN4oNw4v+Ecfw+cKgw/zBfKBIrhwalolo6rfSeklUlQCemiYNWdnSqf
         hzu9Hix7K28+ivDkJ7aMNZVaScQ8myZePIfswy3QE++bXJJWZSj8rzjn8jTTdkG8no8L
         edyXVXtIGXiTysYVwJamlQ8aTrE1DA1GIOFQnyAIg0tCOjWmhmDw6Fo+/+PFGaPzA6WD
         K1SNCAIu6mdIdVviXa2Nale/ezpfoIkzoaTdQSZyBFwr0x1uz2QnuuZbCgKdgj5ktmzz
         U+FbPWgbS+eMtqA6D/p4Morqbm5ZFHduzM9QuebKXL80XlXwHmul+1tgziv9EEHVMR4r
         YXvQ==
X-Gm-Message-State: AOAM531GFO8DMxZ6GvZHE7PFyP+M5CPFPPvh011CNrOmNhuJ6LAIuH8U
        1r144sl2eBDVCjeWyUFjpUcG1OTQIszGpYM12XHplQ==
X-Google-Smtp-Source: ABdhPJwKrGxg1pSzTD3PKubnXRlVbMWvvyQAyXdQenr8vjH12lGbZt0UJhM6TOIwPk0vJCnPvJ97im0ndO6OqYKWUA4=
X-Received: by 2002:ac2:558d:: with SMTP id v13mr1050746lfg.190.1637004036883;
 Mon, 15 Nov 2021 11:20:36 -0800 (PST)
MIME-Version: 1.0
References: <20211111221448.2683827-1-seanjc@google.com>
In-Reply-To: <20211111221448.2683827-1-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 15 Nov 2021 11:20:10 -0800
Message-ID: <CALzav=dpzzKgaNRLrSBy71WBvybWmRJ39eDv4hPXsbU_DSS-fA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021 at 2:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When zapping obsolete pages, update the running count of zapped pages
> regardless of whether or not the list has become unstable due to zapping
> a shadow page with its own child shadow pages.  If the VM is backed by
> mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> the batch count and thus without yielding.  In the worst case scenario,
> this can cause an RCU stall.
>
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
>                                           softirq=15759/15759 fqs=5058
>    (t=21016 jiffies g=66453 q=238577)
>   NMI backtrace for cpu 52
>   Call Trace:
>    ...
>    mark_page_accessed+0x266/0x2f0
>    kvm_set_pfn_accessed+0x31/0x40
>    handle_removed_tdp_mmu_page+0x259/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    zap_gfn_range+0x141/0x3b0
>    kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130

This is a useful patch but I don't see the connection with this stall.
The stall is detected in kvm_tdp_mmu_zap_invalidated_roots, which runs
after kvm_zap_obsolete_pages. How would rescheduling during
kvm_zap_obsolete_pages help?

>    kvm_mmu_zap_all_fast+0x121/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x172/0x4e0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0x49c/0xf80
>
> Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> Reported-by: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
> I haven't actually verified this makes David's RCU stall go away, but I did
> verify that "batch" stays at "0" before and increments as expected after,
> and that KVM does yield as expected after.
>
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 33794379949e..89480fab09c6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5575,6 +5575,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  {
>         struct kvm_mmu_page *sp, *node;
>         int nr_zapped, batch = 0;
> +       bool unstable;

nit: Declare unstable in the body of the loop. (So should nr_zapped
and batch but that's unrelated to your change.)

>
>  restart:
>         list_for_each_entry_safe_reverse(sp, node,
> @@ -5606,11 +5607,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>                         goto restart;
>                 }
>
> -               if (__kvm_mmu_prepare_zap_page(kvm, sp,
> -                               &kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
> -                       batch += nr_zapped;
> +               unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
> +                               &kvm->arch.zapped_obsolete_pages, &nr_zapped);
> +               batch += nr_zapped;
> +
> +               if (unstable)
>                         goto restart;
> -               }
>         }
>
>         /*
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>

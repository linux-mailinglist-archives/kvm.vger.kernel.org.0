Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0704C44DDE5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 23:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhKKWen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 17:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhKKWem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 17:34:42 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EFCC061767
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 14:31:52 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 14so8822052ioe.2
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 14:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9jxsh3Vr1ILkY408znq3RjyZcHNwlIUdMXYI2IYlrGU=;
        b=UnXmAdLi6qJbe3qsi1O8ebNKssghra1ZYBjpXuNSt4FXL1myT3+3jDC7yKjYsY89us
         npmlLnFns9yl8/RwVgoFZpIOK4x/JDpVFl5cgCylyjCVnVfi4AtDW5yXEftsBBvZ+A7J
         uD1Eh7lgaQZLMVN/SmpAhUaEQ6xsrkEmeeu25u+4UNr0NCWhX4hcOZcrqe7/s8iUAmBj
         ZKiVFD/jWd0YCo4Q+qbxUr2Fc8l7szP527e9qbt81DZof4T7SNa+dt7Rpwf7yXWwoGab
         Is1xIvJouNSVXtRHluenSXVohiZHSxzOQTEhdnTgVz3g/H7lEQZ66qxfmnAmyczAQwpj
         we5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9jxsh3Vr1ILkY408znq3RjyZcHNwlIUdMXYI2IYlrGU=;
        b=0RmyPGUHri9HIYCRF66Is+dk59PfeBZzM5yWnkV3NNZcPAhbCfDOSMA17HJTWnzr9v
         0U5kQ2kDb4vcpn5EwwLLfWJBZTOMfbiS6rqdxtQ+YD7r4zRi0gCVHLA8x4Ivvh0p3Iee
         rBaCiE9DXHNjNs05JfUv29olb2gwYnuWSiFZyf/b7eARcohhVLgEgIusgKM/RfTTuFep
         6M2JMxdrZFib5+8JiWv8ktJtAnhot1gIw3smclzLZRA1NW9OksFgO/Wt52BF0C4LNjQa
         zP2HlqwT3RF/rggSoKOe47QOwwJ/FgrooOOR0098gdpUbPGD0JTJ+aTc52inFR9yA3K6
         dQjg==
X-Gm-Message-State: AOAM531elO5leiUmNttrMsmIcRioW24+2v7smuyV3OIdpPuZTPBHjmvZ
        sCceZ1uHKOOdkHme+A5piNPSHJYLqwcPLdi4AqoG+g==
X-Google-Smtp-Source: ABdhPJwCdFxNWnkFb253Hq+786YEWOphPB4Wk8TDadQALvSmrfizAxT//yY0R2GoWmHu7iu/2JNab1RUluf3aWgqwWY=
X-Received: by 2002:a02:624c:: with SMTP id d73mr8145648jac.32.1636669912047;
 Thu, 11 Nov 2021 14:31:52 -0800 (PST)
MIME-Version: 1.0
References: <20211111221448.2683827-1-seanjc@google.com>
In-Reply-To: <20211111221448.2683827-1-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 14:31:41 -0800
Message-ID: <CANgfPd98+K-ELe0eAN0d+eqFjSa6ypOOP3MDb_nSwfrCZzpdCw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Reviewed-by: Ben Gardon <bgardon@google.com>

While I can see this fixing the above stall, there's still a potential
issue where zapped_obsolete_pages can accumulate an arbitrary number
of pages from multiple batches of zaps. If this list gets very large,
we could see a stall after the loop while trying to free the pages.
I'm not aware of this ever happening, but it could be worth yielding
during that freeing process as well.

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

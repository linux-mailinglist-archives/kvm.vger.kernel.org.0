Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CB262E3EF
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbiKQSRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbiKQSQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:16:58 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D43564551
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:16:58 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-369426664f9so26575137b3.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JAtqCREdjsvfQ/TLF/cHIfQmrDX+CtXnIqlulDNOPX8=;
        b=ru06SzHh49Zy5U/2XSX7IpGPvMuoRC5xz+MTxx7J6GxaoOSYk8zyLr7tyThz2gmkF4
         e0O3C2jMPZCopCE9azD/SoqJyBhn9d9CRGvIFzb/ul7bbybihkdy+2tc5pUdc2ZFseUS
         f7HrVtRVV/EbVCjlug6U0HPrcf0tJZPX6ZZtcPiYxX8l4B+PXFnFgxgyDKVJpoKI5K3T
         0Y7wLb0YF/iSRhBrFx5pAUkgANtjRQ0mbiGmW7sQYjRM6uAZMMi0XfmuUqlZy8iC/MN+
         8vbpgfU3J4dTM/RIH7Lw8L43y2+Ghd7VPTyy0plzImDF+e9IoxaGb+qApwYRAQT1IoH4
         /7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JAtqCREdjsvfQ/TLF/cHIfQmrDX+CtXnIqlulDNOPX8=;
        b=ok5A62CFbVA49EZQd6wMp0Ggvj5dg3WiH1VLAPM3jE0YRqfssBBfe9BprPSfllAX8M
         A+MFluKK6vMqbPfxIQ22CYXc5QhLmrUp8/NuWQJnbUjAclfgJ3r+G5sPxW4yYh5EqRql
         T3++jPiWvNdWIlygyU37WeskcuUpgetWcp6PO1Wk5w5ooCpBQT/8CKMTJ6Wx4kGFC+ds
         dtwX6z3ZfhX1MW9yvmNMOYTFwz9R+RjW6vhZEBjeEglm4VnaFQsB9IamPIT0KTzXvWDF
         hAu9muQ9rZsORbwvFKbiqXP1yzJqJd8R8TqAKsl4Q4HWoUpQeyQWNO8scbzTgT+DCI0A
         LipQ==
X-Gm-Message-State: ANoB5pkJbdB4lJ1PgV6fovf6Icf7pQR/bRNZYLwo1mduJ0lbDol55w2T
        /qZGhRoXI5C26dxdaP9UDhrW563jc4AIkwPEUgLKtw==
X-Google-Smtp-Source: AA0mqf6ULha0ubfw+LYNzikBwkkjVj7QQh1CuuNLGXhTKb2vypNvcV1j5oFQxZfRBA0izZh5HV6XA/1V2T0LxfN559M=
X-Received: by 2002:a81:25d8:0:b0:373:4467:e0c6 with SMTP id
 l207-20020a8125d8000000b003734467e0c6mr3149831ywl.340.1668709017257; Thu, 17
 Nov 2022 10:16:57 -0800 (PST)
MIME-Version: 1.0
References: <20221117173109.3126912-1-pbonzini@redhat.com>
In-Reply-To: <20221117173109.3126912-1-pbonzini@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 17 Nov 2022 10:16:30 -0800
Message-ID: <CALzav=ewv2rVp+2HL8-648C1d3_5bCLv1N6SkDWJFU8X7nqJBg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: avoid memslot check in NX hugepage recovery if
 it cannot be true
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 9:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Since gfn_to_memslot() is relatively expensive, it helps to
> skip it if it the memslot cannot possibly have dirty logging
> enabled.  In order to do this, add to struct kvm a counter
> of the number of log-page memslots.  While the correct value
> can only be read with slots_lock taken, the NX recovery thread
> is content with using an approximate value.  Therefore, the
> counter is an atomic_t.

Oo, good idea to use the counter to skip gfn_to_memslot() in the steady state.

FYI I sent an earlier patch to add an equivalent counter in case
you want to use that and apply the change to
kvm_recover_nx_huge_pages() as a separate patch.

https://lore.kernel.org/kvm/20221027200316.2221027-2-dmatlack@google.com/

>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 22 +++++++++++++++++++---
>  include/linux/kvm_host.h |  5 +++++
>  virt/kvm/kvm_main.c      |  5 +++++
>  3 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cfff74685a25..d4ec9491d468 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6878,16 +6878,32 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>                 WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
>                 WARN_ON_ONCE(!sp->role.direct);
>
> -               slot = gfn_to_memslot(kvm, sp->gfn);
> -               WARN_ON_ONCE(!slot);
> -
>                 /*
>                  * Unaccount and do not attempt to recover any NX Huge Pages
>                  * that are being dirty tracked, as they would just be faulted
>                  * back in as 4KiB pages. The NX Huge Pages in this slot will be
>                  * recovered, along with all the other huge pages in the slot,
>                  * when dirty logging is disabled.
> +                *
> +                * Since gfn_to_memslot() is relatively expensive, it helps to
> +                * skip it if it the test cannot possibly return true.  On the
> +                * other hand, if any memslot has logging enabled, chances are
> +                * good that all of them do, in which case unaccount_nx_huge_page()
> +                * is much cheaper than zapping the page.
> +                *
> +                * If a memslot update is in progress, reading an incorrect value
> +                * of kvm->nr_logpage_memslots is not a problem: if it is becoming
> +                * zero, gfn_to_memslot() will be done unnecessarily; if it is
> +                * becoming nonzero, the page will be zapped unnecessarily.
> +                * Either way, this only affects efficiency in racy situations,
> +                * and not correctness.
>                  */
> +               slot = NULL;
> +               if (atomic_read(&kvm->nr_logpage_memslots)) {
> +                       slot = gfn_to_memslot(kvm, sp->gfn);
> +                       WARN_ON_ONCE(!slot);
> +               }
> +
>                 if (slot && kvm_slot_dirty_track_enabled(slot))
>                         unaccount_nx_huge_page(kvm, sp);
>                 else if (is_tdp_mmu_page(sp))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e6e66c5e56f2..b3c2b975e737 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,6 +722,11 @@ struct kvm {
>         /* The current active memslot set for each address space */
>         struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>         struct xarray vcpu_array;
> +       /*
> +        * Protected by slots_lock, but can be read outside if an
> +        * incorrect answer is acceptable.
> +        */
> +       atomic_t nr_logpage_memslots;

Can also be int + READ_ONCE(), but I do like that atomic_t forces the
reader to use atomic_read().

>
>         /* Used to wait for completion of MMU notifiers.  */
>         spinlock_t mn_invalidate_lock;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..7670ebd29bcf 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1627,6 +1627,11 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
>                 }
>         }
>
> +       atomic_set(&kvm->nr_logpage_memslots,
> +                  atomic_read(&kvm->nr_logpage_memslots)
> +                  + !!(new->flags & KVM_MEM_LOG_DIRTY_PAGES)
> +                  - !!(old->flags & KVM_MEM_LOG_DIRTY_PAGES));

@new and @old can be NULL here if creating or destroying a memslot.


> +
>         r = kvm_arch_prepare_memory_region(kvm, old, new, change);
>
>         /* Free the bitmap on failure if it was allocated above. */
> --
> 2.31.1
>

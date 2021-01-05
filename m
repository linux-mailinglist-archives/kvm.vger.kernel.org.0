Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45BE2EB658
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbhAEXjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 18:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAEXjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 18:39:04 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E096C061793
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 15:38:24 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id u12so1430894ilv.3
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 15:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsxI/LAwtO/bx2buEvRVyl52jPyp0BQhf9Sqjo4vgY4=;
        b=LbkNuAxlye2AIUfs3jL8sQPAiMTLjh9g89vq4QTv9XPoEZo8fpl71CdgQ0MWV9Sau1
         YC1lgMUWCuhr5g5b1lONvM5iqEfC+iFtgKzNdte0suDix5oMraeaCA+u/bPK2USTxygB
         Brf/ptbyjfbja1gJ24LSP0kT4hXze5w4fV2h7yEmrK+GKYVWG/adXDSB2krrvqSzFBGM
         lf0goeMMxJuFqNOPNDnpo5AqhiBwtjv8MCtTZIUZbdr2VJzOva18LpB4ALdOXzfZ3WQC
         32LMT/zJQSTKfR4TJbBMgSctb1Ps4Kulf4JDVPF/NKMvTodgN0RKMZN5pTAY6Ms9C65W
         XtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsxI/LAwtO/bx2buEvRVyl52jPyp0BQhf9Sqjo4vgY4=;
        b=NfuecaoqxPNbS423yOW3Ug9YOqN6ycsjHJwMcaaErUlNlQ0SpEf3tGM7MU2MN0sY6r
         3XblfEwscd3YFCbP2dMpStQDVtObNR3m8RQiNf0iHcMSqE3Wi7PYNfPpF7AB3JAMW6Uo
         qVQDR9RgfwS19+5p59jrvUcsD1bpKmJPfrUTLcBZKkKlHhnvRrk/FtYhCWJ7VfvmDlG0
         JX6ZO3Pb8Gq177vVg49/5PZBIJ79qzbPm990Zx4rHKUwojr9V9TUi6/MsV+98PZD/ZPE
         +yuMXPsyBvstvt0yJeoif50ncQhEIyJwFivWWFZmWipRC2pdCfvV7lW3HIB0WDwZpw/X
         MjIQ==
X-Gm-Message-State: AOAM531ps+puM02bcN0/iXxM2hY03kheTZiPSjS/ciVOSZTPpda5xpSA
        fiJCdOrnLs/Ik0PSLy/2o4fRwpvLQ7pFSPyy2jLDhP2mTpjH4w==
X-Google-Smtp-Source: ABdhPJw/+4uGNL1y32X1cAE8EqL2gDZpLyzCMOoGvOlSEaU2KP0Ei/vOb9MIYb4iw8CLjupa5ZZ+vVcHjrT78MbDYDs=
X-Received: by 2002:a05:6e02:f93:: with SMTP id v19mr1908740ilo.154.1609889903542;
 Tue, 05 Jan 2021 15:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20210105233136.2140335-1-bgardon@google.com> <20210105233136.2140335-2-bgardon@google.com>
In-Reply-To: <20210105233136.2140335-2-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 5 Jan 2021 15:38:12 -0800
Message-ID: <CANgfPd8TXa3GG4mQ7MD0wBrUOTdRDeR0z50uDmbcR88rQMn5FQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] kvm: x86/mmu: Ensure TDP MMU roots are freed after yield
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 5, 2021 at 3:31 PM Ben Gardon <bgardon@google.com> wrote:
>
> Many TDP MMU functions which need to perform some action on all TDP MMU
> roots hold a reference on that root so that they can safely drop the MMU
> lock in order to yield to other threads. However, when releasing the
> reference on the root, there is a bug: the root will not be freed even
> if its reference count (root_count) is reduced to 0. Ensure that these
> roots are properly freed.
>
> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
> Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 75db27fda8f3..5ec6fae36e33 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -83,6 +83,12 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
>         kmem_cache_free(mmu_page_header_cache, root);
>  }
>
> +static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +       if (kvm_mmu_put_root(kvm, root))
> +               kvm_tdp_mmu_free_root(kvm, root);
> +}
> +
>  static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
>                                                    int level)
>  {
> @@ -456,7 +462,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
>
>                 flush |= zap_gfn_range(kvm, root, start, end, true);
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>
>         return flush;
> @@ -648,7 +654,7 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
>                                        gfn_end, data);
>                 }
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>
>         return ret;
> @@ -852,7 +858,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
>                 spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
>                              slot->base_gfn + slot->npages, min_level);
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>
>         return spte_set;
> @@ -920,7 +926,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>                 spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
>                                 slot->base_gfn + slot->npages);
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>
>         return spte_set;
> @@ -1043,7 +1049,7 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
>                 spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
>                                 slot->base_gfn + slot->npages);
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>         return spte_set;
>  }
> @@ -1103,7 +1109,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>                 zap_collapsible_spte_range(kvm, root, slot->base_gfn,
>                                            slot->base_gfn + slot->npages);
>
> -               kvm_mmu_put_root(kvm, root);
> +               tdp_mmu_put_root(kvm, root);
>         }
>  }
>
> --
> 2.29.2.729.g45daf8777d-goog
>

+Sean Christopherson, for whom I used a stale email address.
.
I tested this series by running kvm-unit-tests on an Intel Skylake
machine. It did not introduce any new failures. I also ran the
set_memory_region_test, but was unable to reproduce Maciej's problem.
Maciej, if you'd be willing to confirm this series solves the problem
you observed, or provide more details on the setup in which you
observed it, I'd appreciate it.

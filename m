Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F93F7EC4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhHYWud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhHYWub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:50:31 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A34BC061757;
        Wed, 25 Aug 2021 15:49:45 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y18so1176729ioc.1;
        Wed, 25 Aug 2021 15:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w/p+B4dv0CyCyC1iXpu/SN9cRNr5JKKz2KXFmtnvNsA=;
        b=AxShGBOEbIC/CN/lDWJ6s6fQXIsuizSWHQlbsDVKHUAzhXKRd4BrSbWSkzMhV96+Ex
         CGXCbv/c5KFcwxt7smUJtIA0uYtiGkVmgIgJaJhKLSIBR6MPL+BoUhwVgNYoRXPtT/nS
         yeGShCuIKFNL5iJ+6laQYY8J6gY4x51svtfdGJcQTTlRcyABL7lklzLPO3tlS68nxTqI
         PFHg58d9dC1D176512Hb5va9UmXVdYwBf1wEKysdroGrUsmx8kUcraGJsP8uWmCx8hQF
         A9QVBRRodOHcQPD6P0zF3MjkuKblm9ppg2nu5W6UH/hL9kyHZakIFGJ3voMXGhAUcLju
         GcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w/p+B4dv0CyCyC1iXpu/SN9cRNr5JKKz2KXFmtnvNsA=;
        b=imrwHPvi0DVjBtBfOD4mlhypq8QrrhijBaqbLPM10fScT149/Gd7pwTGifgwl1wqbX
         uMGC/WeuFc8MU0ipsEEstH1D2vXRnCsdiWf0Tnc27idmgQ/B8u+4vlbIYNlUSAAVMT5P
         4Os1lxcQurhvb5uiXVrAagusia6ih8wWWKloU5KInTJvjiXz9mFo2ckZOcHKUPJMN1ey
         Hj7hLk/kT3jRj1rdqDGy/VUNvBVwi7T/lFfMHxZkvCu4O+ooJbpIwwFV9Woglgz0LFAo
         qakE4XTGJA72VCKI+aT6GgI7ukqn34C+SiStLHoO/Tlfn2f8xk4LneRuHv2Wf6/BO9jS
         6e4A==
X-Gm-Message-State: AOAM531mfGMq/9HrjF+RxchcF38H22TvDS0vD/JSpVAk2A3KvWttB/Wi
        Ddb7jKRB4JXFQ+A3sapIWxxuwH1UROkIrOrLaYY=
X-Google-Smtp-Source: ABdhPJzspF6001i4b1Mk7KoFdkCTp7BUyJtEZDkVCloCNBOPdoRKJKfLXMUGhq6kuLddelTMdfTNKJA5bGmdEllk6Ow=
X-Received: by 2002:a6b:5819:: with SMTP id m25mr611163iob.105.1629931785070;
 Wed, 25 Aug 2021 15:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210818235615.2047588-1-seanjc@google.com>
In-Reply-To: <20210818235615.2047588-1-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Thu, 26 Aug 2021 06:49:34 +0800
Message-ID: <CAJhGHyDWsti6JpYmLhoDfxtaxWC3wFeWzM3NWubqmd=_4ENc3Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Complete prefetch for trailing SPTEs for
 direct, legacy MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 7:57 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Make a final call to direct_pte_prefetch_many() if there are "trailing"
> SPTEs to prefetch, i.e. SPTEs for GFNs following the faulting GFN.  The
> call to direct_pte_prefetch_many() in the loop only handles the case
> where there are !PRESENT SPTEs preceding a PRESENT SPTE.
>
> E.g. if the faulting GFN is a multiple of 8 (the prefetch size) and all
> SPTEs for the following GFNs are !PRESENT, the loop will terminate with
> "start = sptep+1" and not prefetch any SPTEs.
>
> Prefetching trailing SPTEs as intended can drastically reduce the number
> of guest page faults, e.g. accessing the first byte of every 4kb page in
> a 6gb chunk of virtual memory, in a VM with 8gb of preallocated memory,
> the number of pf_fixed events observed in L0 drops from ~1.75M to <0.27M.
>
> Note, this only affects memory that is backed by 4kb pages as KVM doesn't
> prefetch when installing hugepages.  Shadow paging prefetching is not
> affected as it does not batch the prefetches due to the need to process
> the corresponding guest PTE.  The TDP MMU is not affected because it
> doesn't have prefetching, yet...
>
> Fixes: 957ed9effd80 ("KVM: MMU: prefetch ptes when intercepted guest #PF")
> Cc: Sergey Senozhatsky <senozhatsky@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
> Cc'd Ben as this highlights a potential gap with the TDP MMU, which lacks
> prefetching of any sort.  For large VMs, which are likely backed by
> hugepages anyways, this is a non-issue as the benefits of holding mmu_lock
> for read likely masks the cost of taking more VM-Exits.  But VMs with a
> small number of vCPUs won't benefit as much from parallel page faults,
> e.g. there's no benefit at all if there's a single vCPU.
>
>  arch/x86/kvm/mmu/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..daf7df35f788 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2818,11 +2818,13 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
>                         if (!start)
>                                 continue;
>                         if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
> -                               break;
> +                               return;
>                         start = NULL;
>                 } else if (!start)
>                         start = spte;
>         }
> +       if (start)
> +               direct_pte_prefetch_many(vcpu, sp, start, spte);
>  }


Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

>
>  static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>

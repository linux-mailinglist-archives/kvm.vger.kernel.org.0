Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B353A6DD4
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhFNR65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 13:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhFNR65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 13:58:57 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B683C061574
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:56:54 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id d9so40531840ioo.2
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3a8PqTuiGFn1VlY0iYb08EX+n+fkkpgrPSBR+dD7nPA=;
        b=Sj+B98u7nQlddhEPbMj11sWnKXHPkMNiicOqTKHhsh7kbywnDNROJjvW376nNYs+LX
         FaTkzCJwzdSKfNBiEXGWYzkGU0DMciZS1+avEMskM6YTSj1tv07/AMJT1wHggb1N25tE
         P7ACZ5mkZsBpd/1tebU+XPyscneJzpX7kuXCosJ+3+3nwMRU0+rhTRQdN8DSec4XPjiG
         wocNUtD5ZitOe8ELowIEfv0qwnmUJRWeRyIRDfgEVaxP2fvNTNAH9wxVxNUII0hPZHZq
         Ve06jpbHo/wSoIi/bjIdIOMD/M+06ytvTb7C2+mxSRx2zXu8rz5ktlPi+xfUKLEVfoiC
         8qow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3a8PqTuiGFn1VlY0iYb08EX+n+fkkpgrPSBR+dD7nPA=;
        b=Cl5m6ZeAOys6X3Mo/yx59R8HAVz3XwlCaD8Ji40nFg5ler7sXeRurVJZpXEbRuUZuk
         NFMPY2Pey3Fh1VIhdQsNQCNnjE0jpGm9Wk7rQbkotr+/04zlT4GNm0b53I6tNLPpxDDT
         DwFxCN36q3Q/xwIhnUMw6zTSW7WxkpZm9y2hmph/IclRgFpWN8Wes9peeGGMSnwX9va/
         GQ1+ospnA2CJx0WL+s9YMYPCM4lwicChtDfu6az4LonnttUNWypB3DFxD9EK66t9/Pwh
         XYa5BahMbPEcho/Y7S+EVr0YcWPAJTm4sR5SpQbLWKDmGavDcOaB6V7gQIaQ3omxAC/g
         PuXg==
X-Gm-Message-State: AOAM530MT/M7tCo78ctoZIPXJWx5IOBz/Zu2i4HEVw9p+4ChqUz8q2Im
        fNjrVIJXb0uzYBEcuHJBhT2qWVGOWGGrPTgVXi0x30LsDyE=
X-Google-Smtp-Source: ABdhPJzRNj3EQC/QnqILEa8/ZzpY9GVjYRju5LYo3yWJBiBy6uGqy6fl910/0BSztyFtk7do8tHE3msPKO8HUtkL8Ko=
X-Received: by 2002:a5e:9915:: with SMTP id t21mr15328469ioj.189.1623693413540;
 Mon, 14 Jun 2021 10:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-6-dmatlack@google.com>
In-Reply-To: <20210611235701.3941724-6-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 14 Jun 2021 10:56:42 -0700
Message-ID: <CANgfPd8DVwfBzeaoeFtDQ2U-nR+2Oj9BnmCp_n+cTea4KUz6Gg@mail.gmail.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
>
> In order to use walk_shadow_page_lockless() in fast_page_fault() we need
> to also record the spteps.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 1 +
>  3 files changed, 5 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8140c262f4d3..765f5b01768d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3538,6 +3538,7 @@ static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
>                 spte = mmu_spte_get_lockless(it.sptep);
>                 walk->last_level = it.level;
>                 walk->sptes[it.level] = spte;
> +               walk->spteps[it.level] = it.sptep;
>
>                 if (!is_shadow_present_pte(spte))
>                         break;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 26da6ca30fbf..0fefbd5d6c95 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -178,6 +178,9 @@ struct shadow_page_walk {
>
>         /* The spte value at each level. */
>         u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> +
> +       /* The spte pointers at each level. */
> +       u64 *spteps[PT64_ROOT_MAX_LEVEL + 1];
>  };
>
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 36f4844a5f95..7279d17817a1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1529,6 +1529,7 @@ bool kvm_tdp_mmu_walk_lockless(struct kvm_vcpu *vcpu, u64 addr,
>
>                 walk->last_level = iter.level;
>                 walk->sptes[iter.level] = iter.old_spte;
> +               walk->spteps[iter.level] = iter.sptep;
>         }
>
>         return walk_ok;
> --
> 2.32.0.272.g935e593368-goog
>

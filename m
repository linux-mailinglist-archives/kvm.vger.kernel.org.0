Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28AC373F4A
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhEEQNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbhEEQNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 12:13:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644BDC061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 09:12:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id bf4so2682605edb.11
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aV/2dStAzXa+KSKuOzr4V2KYFoBFUN1TbbN4nok1Zdg=;
        b=r9/DPCed0Kmo4atGaRvE12IpBZYuP+Wo6gWQFrjo7ft6G4mVQaIh6Kr3sNrkBXsRiA
         NVKZlT5Dx56mzE10yz6ZI48azqrAQU3z9g7HKBn5JdUZ2UMHNU1xWEYXpmumFaIDzQg5
         59qo9Kl1aR0HJXsR4VTlQJFZJyrQ0+m8Xkxr0pMM6XPuEFfWUSLe1mysskCAc6YluzhA
         QeyXEPN65Gw0qGb0dEvQCruAHXBS67zEtpWlqR4tURx5eck5lXte51RlwGl8sSD4aVTW
         QdKlqrKGC/R9wmEr3GVNVOspMkNVhEz3Blx4YeOZQnKNJH0Kw9CVNIO+NGaKn6nViMSU
         w3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aV/2dStAzXa+KSKuOzr4V2KYFoBFUN1TbbN4nok1Zdg=;
        b=gMjAO4+UJ6Fxv4fy4iMVsf83wtUkah5q4GPfghOFxrmMvXKfDjVkJnrIP2KoxswcrP
         Srmg6A8uuW8nVUzWod0SjdGQvfnbVv8MAzRuBNSpQkm1lYk9NgTkxFJ/UpomGjbv+snp
         gszuWehnqeIr2ucHCxvXgsclALE8o71JlPkOD2DPDrnk4JpkQwGkqSWCJJgV9GFN52rE
         Otf/dKbSp6nNc4y4h39i4BAzlbynlRMsSGJ0pUA0fBwRVWhDttK3giNCmBS1QMsk/PuP
         lxQLG6nJbUxXSMQ21IcPoxDJ+B5HlwCVsJdPBgABb28TLuedmPkupzUS0E4uz1qG1WHA
         1vxg==
X-Gm-Message-State: AOAM531tpsGL8C5xWW+a76Ak14qQxTLmeHFME29hjwJSOh0hgPoDN6oo
        nuCSaTJ1+cW6tnrV+8CROvehWlkIrHNrbc2dwkyo/g==
X-Google-Smtp-Source: ABdhPJyF5JV56mLu8zQaiKqXpGPEFP0OxMrEM4vxPjke35d1/Zwi/OkeHKZI3xiEegDZQELsvRpQMDueQnvSu3OpoUM=
X-Received: by 2002:aa7:dad1:: with SMTP id x17mr22473946eds.47.1620231125965;
 Wed, 05 May 2021 09:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620200410.git.kai.huang@intel.com> <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
In-Reply-To: <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 5 May 2021 09:11:53 -0700
Message-ID: <CANgfPd-hf-+trgTWe=pjjuWSEyVn8F4WyZ4p5kqaMiqghjseew@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 5, 2021 at 2:38 AM Kai Huang <kai.huang@intel.com> wrote:
>
> Currently pf_fixed is increased even when page fault requires emulation,
> or fault is spurious.  Fix by only increasing it when return value is
> RET_PF_FIXED.

Revisiting __direct_map and mmu_set_spte, there are cases in the
legacy MMU where RET_PF_EMULATE is returned but pf_fixed is still
incremented.
Perhaps it would make more sense to do the increment in the success
case of tdp_mmu_set_spte_atomic as you suggested before. Sorry I
didn't catch that earlier.

It would probably also be worth putting a comment on pf_fixed so that
people in the future know what it's supposed to mean and we don't get
into archeology, reverse engineering the meaning of the stat again.

>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1cad4c9f7c34..debe8c3ec844 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -942,7 +942,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>                                        rcu_dereference(iter->sptep));
>         }
>
> -       if (!prefault)
> +       if (!prefault && ret == RET_PF_FIXED)
>                 vcpu->stat.pf_fixed++;
>
>         return ret;
> --
> 2.31.1
>

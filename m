Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0136EE0C
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhD2QXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2QXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:23:11 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF6C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:22:25 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id x54-20020a05683040b6b02902a527443e2fso10772354ott.1
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CaZsd8nEwfI7SXN/G683mq5xJ239kKgBpHKTfQDNQ4w=;
        b=pDzu2bwbGuUT2ab/ziLXDHDjtOF/DjKDlWP2e8DOsapP95yoXeG73VlfVeeXV9M7km
         4i5/cbd4Uz2V74WfWHlHc7s1Z0K9BDGx9DqJ9JXM0My7sGN3WVF5uAHRpG9tlrgKYBba
         1hX2R7avvnc4KEMX5h5av4LMKK+dxI5fy8mYOtyMv/+6tK1G+rFmcmyWbBhn65vmFo5N
         v7NFxmm/6uIM1kLRI0auKuRz6BRzWUhPjbBfj2k8QjvEary3Iw2yyrU/4o2IyNPxyxCo
         C6GMdbcwCetWt/NMRkOxEk2b9lJXTm4MoVDGKorvSrec14CAuXmzmwrs3+ViYwiEtGSs
         mVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CaZsd8nEwfI7SXN/G683mq5xJ239kKgBpHKTfQDNQ4w=;
        b=imDnGeZ5wF0d4NdjmtkqoGTrnaVwbQspav0LaDRXjtxin0EakTXh12JAcV/GG+zO7Y
         pAxuY43cRpEXTvTaTyV/i/T8kLnoC+dknafPOjnxyVWKe3vJZPsOsl3JZd7MczMQfmKG
         TiiTsTz1qMBoE/b0PNd7r4FFyXjugp2kOxywm6el6Hx1gUJjWsbLtzeBcvKJcbeGF8Vd
         GmRsaJRro5Pl/NeEyIs3pCeBoVV/7A2ivK1ia8ae+WLseMdPMq9gvdczBx3kpQu1+jo5
         cuMNWd0FXojWZfM/ytQL4UnZY9o6CaEB8KHwwcwy5jEUwumzxZTVOTf4At09EX5Ky4+2
         HZFQ==
X-Gm-Message-State: AOAM533oHXKaUssFhBeWH4xVFlr0hNloIHLXyXgibe8L2zGXv+90Mlw5
        FXKWyp2qLIYSZydMMHU697HCnZLWfNQL/emu26kbxw==
X-Google-Smtp-Source: ABdhPJxBUEQhBUCweyfdFoslZYjcLeSMRMlkIyTuW2acmlXQy+c6Izb4A86xoa9xrO3e/6IeTlb3rQ6Hw+kqa1zfqFY=
X-Received: by 2002:a9d:7857:: with SMTP id c23mr180583otm.208.1619713344327;
 Thu, 29 Apr 2021 09:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210429041226.50279-1-kai.huang@intel.com>
In-Reply-To: <20210429041226.50279-1-kai.huang@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 29 Apr 2021 09:22:13 -0700
Message-ID: <CANgfPd_PMO6cKtPoTaEV0R_qWfbm1TgwpT=7Sr_N_5JKMgysVQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Avoid unnecessary page table allocation in kvm_tdp_mmu_map()
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

On Wed, Apr 28, 2021 at 9:12 PM Kai Huang <kai.huang@intel.com> wrote:
>
> In kvm_tdp_mmu_map(), while iterating TDP MMU page table entries, it is
> possible SPTE has already been frozen by another thread but the frozen
> is not done yet, for instance, when another thread is still in middle of
> zapping large page.  In this case, the !is_shadow_present_pte() check
> for old SPTE in tdp_mmu_for_each_pte() may hit true, and in this case
> allocating new page table is unnecessary since tdp_mmu_set_spte_atomic()
> later will return false and page table will need to be freed.  Add
> is_removed_spte() check before allocating new page table to avoid this.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Nice catch!

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 83cbdbe5de5a..84ee1a76a79d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1009,6 +1009,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> +                       /*
> +                        * If SPTE has been forzen by another thread, just

frozen

> +                        * give up and retry, avoiding unnecessary page table
> +                        * allocation and free.
> +                        */
> +                       if (is_removed_spte(iter.old_spte))
> +                               break;
> +
>                         sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
>                         child_pt = sp->spt;
>
> --
> 2.30.2
>

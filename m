Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49A932C6A4
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451050AbhCDA3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240166AbhCCR3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:29:30 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B700DC061760
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 09:28:15 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id k2so21145410ioh.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 09:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ck2w+e5yXkndn1hHoEc40G+HBVTFOBYH8jC+XKOicDs=;
        b=YSXBefMpnQeJLVXH2u/6vizQTN7Ho5xCOwqne2UzKric8QgKjoWznBVtMcKZnJS/l1
         CBnEZvshehyDRI6+CSUort61MlyKAsJWSQX4iNx8LTtWnAx0ZooLoqt9xt9hQQJejuSe
         twEl2M4gyaFVNQ2iP6xie+uaMefYX9aCP80ei1oK/F+tZHUXS5SZ2xli/Rnla2iuH35y
         HQZkHEa7zBKqwz7GkNafuRf42QHtHxEi6u2lUhgTbjam2v8oO0920jY4bUX1JS5JTMx7
         4uM7pMSEYFh1V0twXIR172Ux54s64w07d8DapzsMG53O+pBTaow42w+Euq+zmJW+PWbN
         XOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ck2w+e5yXkndn1hHoEc40G+HBVTFOBYH8jC+XKOicDs=;
        b=tYYlDNh0OUGCio1G1f5BKODOl8ClUNgx3yzv0QZiKTivcH6ba4u+0ME+N//M9J2k/e
         q0rpmeaHKQqBKwtRspoYmunejPCRXxP7w8ZUCrHDM2lnv1XsGZOiMA7o2RyiOX1FC49W
         FS3e93oGKm4KvC/1ZtNQAWV5ijWC0dP3IAw9EItOKtierIjS8gaM31J8okIcbnktFGyS
         R3KcWtq6XZGMSjAnfrCtWvW5sLbIaYyiuQJADwBqYesLahfrBNWZVlvZ6sZTX0z+is7Q
         z7wPYT6mLfKd8bSoqcPxcW+vOzz45Dnh585urHF4Ek35sZz6SaoirKOxz3dZgDq8AhVu
         52eQ==
X-Gm-Message-State: AOAM533Lof4r18umU9tg7fO5q4KquPndyrs9AnNjLw7t1Q+iTwGWlI7Z
        AqWHs0Uk/2emNiGSZLqfsk9oKuAxGfNKnQNwm+OMoA==
X-Google-Smtp-Source: ABdhPJzD8aRdltFXM/NaTn95qOpABgQeAMXTFWz8XzmWvbiOwMUQmg4Z4Z7jc4RFL5cM1+dGliVOWFz6VT9q9Cgnqxg=
X-Received: by 2002:a05:6638:1648:: with SMTP id a8mr25394286jat.25.1614792494837;
 Wed, 03 Mar 2021 09:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com> <20210302184540.2829328-3-seanjc@google.com>
In-Reply-To: <20210302184540.2829328-3-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 3 Mar 2021 09:28:03 -0800
Message-ID: <CANgfPd9n3HjFOR5230i9_W9-CZjKKQSp+wzDB+Eymqrr3F8xeQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] KVM: x86/mmu: Alloc page for PDPTEs when shadowing
 32-bit NPT with 64-bit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 2, 2021 at 10:45 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Allocate the so called pae_root page on-demand, along with the lm_root
> page, when shadowing 32-bit NPT with 64-bit NPT, i.e. when running a
> 32-bit L1.  KVM currently only allocates the page when NPT is disabled,
> or when L0 is 32-bit (using PAE paging).
>
> Note, there is an existing memory leak involving the MMU roots, as KVM
> fails to free the PAE roots on failure.  This will be addressed in a
> future commit.
>
> Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
> Fixes: b6b80c78af83 ("KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 44 ++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0987cc1d53eb..2ed3fac1244e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3187,14 +3187,14 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>                 if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
>                     (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
>                         mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
> -               } else {
> +               } else if (mmu->pae_root) {
>                         for (i = 0; i < 4; ++i)
>                                 if (mmu->pae_root[i] != 0)

I was about to comment on how weird this check is since pae_root can
also be INVALID_PAGE but that case is handled in mmu_free_root_page...
but then I realized that you're already addressing that problem in
patch 7.

>                                         mmu_free_root_page(kvm,
>                                                            &mmu->pae_root[i],
>                                                            &invalid_list);
> -                       mmu->root_hpa = INVALID_PAGE;
>                 }
> +               mmu->root_hpa = INVALID_PAGE;
>                 mmu->root_pgd = 0;
>         }
>
> @@ -3306,9 +3306,23 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>          * the shadow page table may be a PAE or a long mode page table.
>          */
>         pm_mask = PT_PRESENT_MASK;
> -       if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL)
> +       if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
>                 pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
>
> +               /*
> +                * Allocate the page for the PDPTEs when shadowing 32-bit NPT
> +                * with 64-bit only when needed.  Unlike 32-bit NPT, it doesn't
> +                * need to be in low mem.  See also lm_root below.
> +                */
> +               if (!vcpu->arch.mmu->pae_root) {
> +                       WARN_ON_ONCE(!tdp_enabled);
> +
> +                       vcpu->arch.mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +                       if (!vcpu->arch.mmu->pae_root)
> +                               return -ENOMEM;
> +               }
> +       }
> +
>         for (i = 0; i < 4; ++i) {
>                 MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
>                 if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
> @@ -3331,21 +3345,19 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>         vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
>
>         /*
> -        * If we shadow a 32 bit page table with a long mode page
> -        * table we enter this path.
> +        * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
> +        * tables are allocated and initialized at MMU creation as there is no
> +        * equivalent level in the guest's NPT to shadow.  Allocate the tables
> +        * on demand, as running a 32-bit L1 VMM is very rare.  The PDP is
> +        * handled above (to share logic with PAE), deal with the PML4 here.
>          */
>         if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
>                 if (vcpu->arch.mmu->lm_root == NULL) {
> -                       /*
> -                        * The additional page necessary for this is only
> -                        * allocated on demand.
> -                        */
> -
>                         u64 *lm_root;
>
>                         lm_root = (void*)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> -                       if (lm_root == NULL)
> -                               return 1;
> +                       if (!lm_root)
> +                               return -ENOMEM;
>
>                         lm_root[0] = __pa(vcpu->arch.mmu->pae_root) | pm_mask;
>
> @@ -5248,9 +5260,11 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>          * while the PDP table is a per-vCPU construct that's allocated at MMU
>          * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
>          * x86_64.  Therefore we need to allocate the PDP table in the first
> -        * 4GB of memory, which happens to fit the DMA32 zone.  Except for
> -        * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
> -        * skip allocating the PDP table.
> +        * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
> +        * generally doesn't use PAE paging and can skip allocating the PDP
> +        * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
> +        * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
> +        * KVM; that horror is handled on-demand by mmu_alloc_shadow_roots().
>          */
>         if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
>                 return 0;
> --
> 2.30.1.766.gb4fecdf3b7-goog
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD5371E1C
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhECRK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbhECRJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:09:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061BC061763
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 10:08:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n2so8965064ejy.7
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 10:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DFZHyV+rD8Cl6v91LM4AHSnGxXHNPBj2VO39Yi/H88=;
        b=NWzXyzfASMU9w0ob4j3khQXO+kR2xJPzLM+8w7XrOgS855pXKQx80cZ5MJVS4Q1+41
         YFnMJGhfNLPkj5Obciyej2N8OoSjf2tIKJ3aCOsuCVt/hz6RRwap7MSp6n4VjD+K/OZp
         tOv8BvBsjB65A1NSQ1VPwHLv1Tm+D46JOmKKlFi7BetnDc+p8ulIekopeRkJDnszz8uk
         UIDzHNChkTA0zJti1syXvPcAvn5VOuhzp78xQSo++vJdFvyiuj+YBY4To0dxwkCOuIoJ
         Wm/W+yndU2E4yLA6rnCRGWLsOR1g9Am3iYykebE25FE3UOMujKip99Iew0u5fLTUYUHx
         PVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DFZHyV+rD8Cl6v91LM4AHSnGxXHNPBj2VO39Yi/H88=;
        b=rLGnJhN+WJO0creGWt0yrGgglMyYZ0WT8iNUHJGnelLaSZsAkl969emADbqCwzzQj8
         vboNGhd3RVoYvBIZ/WO0VoJlXNzt25A/F5mg64gaJAIrCQGwJfBLHHg9E+Bzao9MsWjU
         050S1ZdntMtyrj1BDKMS/quLPbe8m6N5h8OW88uO4QObhjs6l+BZPeX7kHGI9izBhc7B
         vyXd+9mV9xVByCUpDLiC15J46Nfz3tt3FXpJnFYEcH82e9oCQ9b38bnuMbHkI8hLsX8E
         yrFtNi5VtaWJ04/RzFHD0gAiBxrFojhjSVGbJxZvyWv15rrNomCZq0i6cDZyozDaxuwY
         CNug==
X-Gm-Message-State: AOAM532w8eIrPiKx5jA1oYGprbKLhTQ2Z4OcZZj/Uaq+/VeDXIjPtktQ
        QlJR9Nl86XIOXHmoD3Isqyef3962p5mfnWEwq5S/lg==
X-Google-Smtp-Source: ABdhPJyl3c7WagIBKD7rtqkoypZjyUSEZv+0odLD5eHMoqHzBaZxQnOgXEO2fil6coRJbLRAcgvMilMxdLbKKQ8NDds=
X-Received: by 2002:a17:906:11d4:: with SMTP id o20mr17802929eja.247.1620061688032;
 Mon, 03 May 2021 10:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210430160138.100252-1-kai.huang@intel.com>
In-Reply-To: <20210430160138.100252-1-kai.huang@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 3 May 2021 10:07:57 -0700
Message-ID: <CANgfPd_gWYaKbdD-fkLNwCSaVQhgcQaSKOEoG0a2B90GhB03zg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix some return value error in kvm_tdp_mmu_map()
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

On Fri, Apr 30, 2021 at 9:03 AM Kai Huang <kai.huang@intel.com> wrote:
>
> There are couple of issues in current tdp_mmu_map_handle_target_level()
> regarding to return value which reflects page fault handler's behavior
> -- whether it truely fixed page fault, or fault was suprious, or fault
> requires emulation, etc:
>
> 1) Currently tdp_mmu_map_handle_target_level() return 0, which is
>    RET_PF_RETRY, when page fault is actually fixed.  This makes
>    kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
>    RET_PF_FIXED.

Ooof that was an oversight. Thank you for catching that.

>
> 2) When page fault is spurious, tdp_mmu_map_handle_target_level()
>    currently doesn't return immediately.  This is not correct, since it
>    may, for instance, lead to double emulation for a single instruction.

Could you please add an example of what would be required for this to
happen? What effect would it have?
I don't doubt you're correct on this point, just having a hard time
pinpointing where the issue is.

>
> 3) One case of spurious fault is missing: when iter->old_spte is not
>    REMOVED_SPTE, but still tdp_mmu_set_spte_atomic() fails on atomic
>    exchange. This case means the page fault has already been handled by
>    another thread, and RET_PF_SPURIOUS should be returned. Currently
>    this case is not distinguished with iter->old_spte == REMOVED_SPTE
>    case, and RET_PF_RETRY is returned.

See comment on this point in the code below.

>
> Fix 1) by initializing ret to RET_PF_FIXED at beginning. Fix 2) & 3) by
> explicitly adding is_removed_spte() check at beginning, and return
> RET_PF_RETRY when it is true.  For other two cases (old spte equals to
> new spte, and tdp_mmu_set_spte_atomic() fails), return RET_PF_SPURIOUS
> immediately.
>
> Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 84ee1a76a79d..a4dc7c9a4ebb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -905,9 +905,12 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>                                           kvm_pfn_t pfn, bool prefault)
>  {
>         u64 new_spte;
> -       int ret = 0;
> +       int ret = RET_PF_FIXED;
>         int make_spte_ret = 0;
>
> +       if (is_removed_spte(iter->old_spte))
> +               return RET_PF_RETRY;
> +
>         if (unlikely(is_noslot_pfn(pfn)))
>                 new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>         else
> @@ -916,10 +919,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>                                          map_writable, !shadow_accessed_mask,
>                                          &new_spte);
>
> -       if (new_spte == iter->old_spte)
> -               ret = RET_PF_SPURIOUS;
> -       else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> -               return RET_PF_RETRY;
> +       if (new_spte == iter->old_spte ||
> +                       !tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> +               return RET_PF_SPURIOUS;


I'm not sure this is quite right. In mmu_set_spte, I see the following comment:

/*
* The fault is fully spurious if and only if the new SPTE and old SPTE
* are identical, and emulation is not required.
*/

Based on that comment, I think the existing code is correct. Further,
if the cmpxchg fails, we have no guarantee that the value that was
inserted instead resolved the page fault. For example, if two threads
try to fault in a large page, but one access is a write and the other
an instruction fetch, the thread with the write might lose the race to
install its leaf SPTE to the instruction fetch thread installing a
non-leaf SPTE for NX hugepages. In that case the fault might not be
spurious and a retry could be needed.

We could do what the fast PF handler does and check
is_access_allowed(error_code, spte) with whatever value we lost the
cmpxchg to, but I don't know if that's worth doing or not. There's not
really much control flow difference between the two return values, as
far as I can tell.

It looks like we might also be incorrectly incrementing pf_fixed on a
spurious PF.

It might be more interesting and accurate to introduce a separate
return value for cmpxchg failures, just to see how often vCPUs
actually collide like that.

>
>         /*
>          * If the page fault was caused by a write but the page is write
> --
> 2.30.2
>

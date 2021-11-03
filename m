Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89912444606
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 17:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhKCQjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 12:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhKCQjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 12:39:11 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A55AC061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 09:36:35 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id w10so3135808ilc.13
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 09:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqcBRxOQ9MjURO/c5n7KjP3zUkTopF6FY6YrmNIOe3I=;
        b=cnAmHdOWACGRJzcwjbOOl3C9Bd2t/C5gyWAYtrPEglsqE3Y0Cr57sjVPIrLKXctAkE
         5ze6sOTjq1x7i85bssik+hzPJ7Di2Sg158ut8fqoiNLcc8lJ0BDU7D0d8FrZPRb4h71+
         +a/aWNxxrRtDwjukw9/YQxh4+OJbEErwOu7w3Kpvs1sT2Yi6fk++v010mSvqxNxm9Yce
         vfJakfaGtwGTZLIpDcwdwOauf3GCmO04s6lMqVtn5f8Gt5PQ34q/dOghZIPPlqdjLW0s
         UFKyleCoBwJCPJX5ue12uN1atnUM+lga0v2GwHVTwyl2HH6B4FwY18fLwJ3BaeyyIoC4
         d9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqcBRxOQ9MjURO/c5n7KjP3zUkTopF6FY6YrmNIOe3I=;
        b=XUAL5m0YBcy5ZV1Jj+Oi3DnmK5RYZAp+w5BfMPmjxywqg94CXfo+HQY5MzVCqkLVhS
         gO18W6AvTAjgxCRLIvfbzTFVE6w9tcjiwblsVvtfLd/j1V3dCYMImoKprMiU7A14nJ6g
         dIH4sV0oadOSMgYbkT3/ZnYFeR1TqV46NFY+Rh/mLsgY8NTiAIyEq2cmUv5LJVnrgEsI
         499Z6K8Q0giXCkUIsPkqS38OsIu2Fi/QwJZBTaY3PObZ5fekSlTEwGIgb8EVf6sIiqSa
         pmwIG++0aJn4qJ62fA5sMtmxbiS7B2Fh3Edu12+nO1YPzqSopgJc9N4IZfQRPzNL53Ic
         yMCw==
X-Gm-Message-State: AOAM531pQ6gk3Y/rbB+v3RxGVt5YWEVaVJcRzEAibmIBV72jLO+F0lfd
        UMbVzNmkH/mBnzDxhdwo9+t4TlqJ6+7ugbxYqMJ3BQ==
X-Google-Smtp-Source: ABdhPJwarWrYs67dhHO3W93iyUrOAUtT/O4f5jE/lxzIKtUiy6tmumpoNY+4xpGlX/oFsN+SBbOvLSD3ZrrkIwu2/Wk=
X-Received: by 2002:a05:6e02:15c9:: with SMTP id q9mr31006491ilu.298.1635957394356;
 Wed, 03 Nov 2021 09:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211103161833.3769487-1-seanjc@google.com>
In-Reply-To: <20211103161833.3769487-1-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 3 Nov 2021 09:36:23 -0700
Message-ID: <CANgfPd9VVAdP0umt6Odz_-f+nUmKfsNa0hqvUzuto6=G6b=M+A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Properly dereference rcu-protected TDP MMU
 sptep iterator
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 9:18 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Wrap the read of iter->sptep in tdp_mmu_map_handle_target_level() with
> rcu_dereference().  Shadow pages in the TDP MMU, and thus their SPTEs,
> are protected by rcu.
>
> This fixes a Sparse warning at tdp_mmu.c:900:51:
>   warning: incorrect type in argument 1 (different address spaces)
>   expected unsigned long long [usertype] *sptep
>   got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
>
> Fixes: 7158bee4b475 ("KVM: MMU: pass kvm_mmu_page struct to make_spte")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

This change looks good to me. It also reminds me that the struct
kvm_mmu_pages are also protected by RCU.
I wonder if it would be worth creating something similar to tdp_ptep_t
for the struct kvm_mmu_pages to add RCU annotations to them as well.

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..a54c3491af42 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -897,7 +897,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>                                           struct kvm_page_fault *fault,
>                                           struct tdp_iter *iter)
>  {
> -       struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> +       struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
>         u64 new_spte;
>         int ret = RET_PF_FIXED;
>         bool wrprot = false;
> --
> 2.33.1.1089.g2158813163f-goog
>

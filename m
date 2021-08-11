Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C343E960F
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhHKQeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhHKQed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 12:34:33 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2D8C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 09:34:10 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r6so2458419ilt.13
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 09:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MiyXaKuo5MKFz5xTuKgPxPuaaij2HCFYcE1MAYz0REg=;
        b=qzk/GM33ZCdtZbJZtJAJP/kWtgtTjQwNcsmSSAYqiffShG7oeLVm7tOQVHINHXsoLq
         9yWPnQuRcQvO4IAUfgcxAW7CMdJCXasEmfFWEzHNwNv20ottnoat8QezWCS/nXvvykGE
         Lzb894TfheLpGH5YyB2IzuFezJgPbfyNde+6Zy9U1hbZ1tQppF3RrUnNP80Hfy9/OaDv
         UklNV67dzGuO2Ybv20/Vwq1dXd028bYefpz/bf3O0/w8Cm6VR32Wdp55ZqeS2gpww3Ej
         AuYUAJw/UMgfwC2SmzJho8Y8cEuY9cGqzpv95LK9F8UiBfKgd6ROYTng30Mm2EQ7g+EY
         Xu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MiyXaKuo5MKFz5xTuKgPxPuaaij2HCFYcE1MAYz0REg=;
        b=ARI44heLziWaDxTLC3RAlDJb9NDj/Y0LSMSOgT1EeXMAk1OuT717f/rRjVCD97iUnH
         /oE3xgpF5uy/KQCpJWRq+tz4R8Ay7rF+rSdwlpbdVT+wl57Vzd5BCeXGBMPoeSr8r/VZ
         21zub3P9tlt0qdlyotM8HWK/AEoH7oe0aTzI2/XUHJo6/vGIs2on+yYWysLg7qopEJZs
         JUAL12Lu2ETEtNH0zk5pD7+IRO5kyoMlhlWstLpVVaeLx/FD9ehjmbtRxOCOXoBMLXEk
         gI2Rwq4BRfXHjfLsmq/lEWh2XMCBlwlnzeRnliTpdONZiNlPG55WyAm/iPgVEzAWViTP
         X3+Q==
X-Gm-Message-State: AOAM532V3eL9IUAX2qPADpUsxanP1am8ZJFmomYSb0ktVGIHtMaIATt1
        IRjh7dZvbH5LD75jM5mZH3PWvkL2lKuztPSmUeGmBQ==
X-Google-Smtp-Source: ABdhPJxkZl/Bld6p9S4wH0FuPMsDn/NAUqDQkIWLW5eMNnp6ZjwvJenOZrxV33H7v0n74tA+UpWY12fJfNxFzc8/+QY=
X-Received: by 2002:a05:6e02:15c8:: with SMTP id q8mr612495ilu.285.1628699649398;
 Wed, 11 Aug 2021 09:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210810224554.2978735-1-seanjc@google.com> <20210810224554.2978735-3-seanjc@google.com>
In-Reply-To: <20210810224554.2978735-3-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Aug 2021 09:33:58 -0700
Message-ID: <CANgfPd9MQWjP47-DjOt-dPrTRuV46VdiR7wEWjX9pYefyBfZ1A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Drop 'shared' param from tdp_mmu_link_page()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 3:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop @shared from tdp_mmu_link_page() and hardcode it to work for
> mmu_lock being held for read.  The helper has exactly one caller and
> in all likelihood will only ever have exactly one caller.  Even if KVM
> adds a path to install translations without an initiating page fault,
> odds are very, very good that the path will just be a wrapper to the
> "page fault" handler (both SNP and TDX RFCs propose patches to do
> exactly that).
>
> No functional change intended.
>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Nice cleanup!

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d99e064d366f..c5b901744d15 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -257,26 +257,17 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>   *
>   * @kvm: kvm instance
>   * @sp: the new page
> - * @shared: This operation may not be running under the exclusive use of
> - *         the MMU lock and the operation must synchronize with other
> - *         threads that might be adding or removing pages.
>   * @account_nx: This page replaces a NX large page and should be marked for
>   *             eventual reclaim.
>   */
>  static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -                             bool shared, bool account_nx)
> +                             bool account_nx)
>  {
> -       if (shared)
> -               spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -       else
> -               lockdep_assert_held_write(&kvm->mmu_lock);
> -
> +       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>         list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
>         if (account_nx)
>                 account_huge_nx_page(kvm, sp);
> -
> -       if (shared)
> -               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
>
>  /**
> @@ -1062,7 +1053,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                                                      !shadow_accessed_mask);
>
>                         if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
> -                               tdp_mmu_link_page(vcpu->kvm, sp, true,
> +                               tdp_mmu_link_page(vcpu->kvm, sp,
>                                                   huge_page_disallowed &&
>                                                   req_level >= iter.level);
>
> --
> 2.32.0.605.g8dce9f2422-goog
>

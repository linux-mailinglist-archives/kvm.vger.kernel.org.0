Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6F4561B0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhKRRq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 12:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbhKRRq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 12:46:58 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DC3C06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:43:58 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id c3so9096434iob.6
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmWc7qIUDoaNMJwYkB1mdPXNq1GKCmwNkveJmjIq/nI=;
        b=R0F7nl6l02m98nslLgBmwCrZbMadQE6rGz5kKt+GSzDqAjDbH1NR4MMxMnKMuK7TzF
         HsWapVtmX4NXV8aL/tIDI6hbpht0fU+iGVI7d0+QR6bI/YCM9yVpETXtZKQBM6uCgRGA
         xIbj7wkqx4uy1kUvWPoIRKNPYq1oWwsKk5XKKxKyAufAaXU9RMCtIRiM7HQVmnmWCMWT
         jegAAW2bQe4NA6WoLcJ5fJRuFvzIAKofMwr4z9pq1eNToWiZy/Ov+AZfAY4Ja+p6pAR1
         d7F32BpCo9J4iMoAVideuD2tdb7xytbsEiUBG5zsS3UHkIYBNd0YVta/GhxH24XCrbd2
         Sj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmWc7qIUDoaNMJwYkB1mdPXNq1GKCmwNkveJmjIq/nI=;
        b=hxdJvE0YsVoS8a6YX/O5bRVXcf33jwQ+urS6F8L6WcwMuJ6HHGDOzG01r49OWyA/SC
         95anW68cbtUFMZNJ6bgLTHzKJZUCZr66dICZDr6hQmwOweQpczyFVp0KuQ8tjHCA0oM2
         O73UEngBACRXotNs6WT6VeAhlXvI3G7FdXE/7WRbM/ZaS9D/e+PNCXemiYtMDjdhTmyO
         cnyA3OUlkZDzRvnNOxj5Sh0uTV9BsnsFCHOoYRKx3Xv6MOyd9yHjA+PNNF9O4bMLMvRb
         41YAp+qaL6jHVbkQqDUZE86a8w9M2owYIoQxJ83Iv/QV67S6qejF+cBq64QYAHaBRuPQ
         FWeQ==
X-Gm-Message-State: AOAM533SxVAgF6I1VGq1qKL25TP9vEysOQ2eHP9Awj/eQZwkeODLIvTQ
        NPJvh4iXnLxSIp0zChuq5M0ibEQ2RhX/YK8KHuuSWg==
X-Google-Smtp-Source: ABdhPJy/ex0GEDw34YUwbvewezGGWyJ3Vmks3SCJirwTDPEeVKLHZg8u7glXzPmhRI7m6CtbmqoZ9NM9idVx+dJ5frQ=
X-Received: by 2002:a5d:8049:: with SMTP id b9mr620384ior.41.1637257437596;
 Thu, 18 Nov 2021 09:43:57 -0800 (PST)
MIME-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com> <20211110223010.1392399-8-bgardon@google.com>
 <YZW2i7GnORD+X5NT@google.com>
In-Reply-To: <YZW2i7GnORD+X5NT@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 18 Nov 2021 09:43:46 -0800
Message-ID: <CANgfPd-f+VXQJnz-LPuiy+rTDkSdw3zjUfozaqzgb8n0rv9STA@mail.gmail.com>
Subject: Re: [RFC 07/19] KVM: x86/mmu: Factor wrprot for nested PML out of make_spte
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 6:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 10, 2021, Ben Gardon wrote:
> > When running a nested VM, KVM write protects SPTEs in the EPT/NPT02
> > instead of using PML for dirty tracking. This avoids expensive
> > translation later, when emptying the Page Modification Log. In service
> > of removing the vCPU pointer from make_spte, factor the check for nested
> > PML out of the function.
>
> Aha!  The dependency on @vcpu can be avoided without having to take a flag from
> the caller.  The shadow page has everything we need.  The check is really "is this
> a page for L2 EPT".  The kvm_x86_ops.cpu_dirty_log_size gets us the EPT part, and
> kvm_mmu_page.guest_mode gets us the L2 part.

Haha that's way cleaner than what I was doing! Seems like an obvious
solution in retrospect. I'll include this in the next version of the
series I send out unless Paolo beats me and just merges it directly.
Happy to give this my reviewed-by.

>
> Compile tested only...
>
> From 773414e4fd7010c38ac89221d16089f3dcc57467 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 17 Nov 2021 18:08:42 -0800
> Subject: [PATCH] KVM: x86/mmu: Use shadow page role to detect PML-unfriendly
>  pages for L2
>
> Rework make_spte() to query the shadow page's role, specifically whether
> or not it's a guest_mode page, a.k.a. a page for L2, when determining if
> the SPTE is compatible with PML.  This eliminates a dependency on @vcpu,
> with a future goal of being able to create SPTEs without a specific vCPU.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 7 +++----
>  arch/x86/kvm/mmu/spte.c         | 2 +-
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 8ede43a826af..03882b2624c8 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -109,7 +109,7 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>         return kvm_mmu_role_as_id(sp->role);
>  }
>
> -static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
> +static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>  {
>         /*
>          * When using the EPT page-modification log, the GPAs in the CPU dirty
> @@ -117,10 +117,9 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
>          * on write protection to record dirty pages, which bypasses PML, since
>          * writes now result in a vmexit.  Note, the check on CPU dirty logging
>          * being enabled is mandatory as the bits used to denote WP-only SPTEs
> -        * are reserved for NPT w/ PAE (32-bit KVM).
> +        * are reserved for PAE paging (32-bit KVM).
>          */
> -       return vcpu->arch.mmu == &vcpu->arch.guest_mmu &&
> -              kvm_x86_ops.cpu_dirty_log_size;
> +       return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
>  }
>
>  int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 0c76c45fdb68..84e64dbdd89e 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -101,7 +101,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>
>         if (sp->role.ad_disabled)
>                 spte |= SPTE_TDP_AD_DISABLED_MASK;
> -       else if (kvm_vcpu_ad_need_write_protect(vcpu))
> +       else if (kvm_mmu_page_ad_need_write_protect(sp))
>                 spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
>
>         /*
> --

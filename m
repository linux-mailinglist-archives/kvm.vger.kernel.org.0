Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7A3A6DD6
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhFNR7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 13:59:41 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:41497 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhFNR7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 13:59:40 -0400
Received: by mail-il1-f181.google.com with SMTP id t6so12969683iln.8
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8hwJD3UWQ6lI2sgeCQ36GJevuaMVqWZvq9du12z5FsM=;
        b=K51X6GOFYooWYNV0FMfIyF9OJE21Z8MEoSyZXjnc7xTuPcsdaDKgumyKctDw6QdeOe
         LKILhgsIJub73E9dQjg6k8gSeyBdaJXA5/W8cYk7mOzq7qW3Dz6Be+ILotPpTyrQwe+P
         +hnsfRMEDHPOMrf6y60GWnIHnFA2up/WksRXC4zr8O6IsPDNA/rwsm1NvE7mRSbB7Xv4
         EBwdBmuCSD3IM6ZW/63wxhEOQeBqh2KVCfDRSi8r2UQoc0BArRkUUHxAAL0P9VJUjbg/
         PnaXjEw8qMx443Ocx5axrTycTRFOV8W4KY5w+jTWSG+1UI4TE4xi0aIE1mU+DZhn3ntx
         5PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8hwJD3UWQ6lI2sgeCQ36GJevuaMVqWZvq9du12z5FsM=;
        b=fpL2WbkSjw8VjBU9/aFWZqJLYYsStdk0uWHJXXGqD/RIIe9hKMIT5DxxywzZ7Rig3q
         Di0pBE/7vBlj1O+6QVAHgpqnmh7hHQoQnQrOJ51VxsVjGV8BNPvAgAEpPQ2TjbV5xFOG
         M993gcqV4hCHs2gAamVUmaXGYucHc3MMtcCFncCPGGuHjGwCvUW2S74rLZgRh4eHMOci
         7D62Dn+506QCX0cpoRNT5gAHH8Ihj3P8WzhVQHvCgQCShDT+CtR83zWUPW8s3ibz2A32
         NkSrcfWAQIZaQ32zVSVzvRgyTYED7ugqvKFKTWbSvD5ADHR/4gw0ekrwgsTEa36SlFWC
         JJJA==
X-Gm-Message-State: AOAM533aVSYxthDhybfUDT6mwdD9qRPoALyP7tvW4kcmRRagGZiCgvjx
        uwoLtaQL8bpxkzFW8SspSeMdMNUzBlqDN2K3Nrvj8A==
X-Google-Smtp-Source: ABdhPJzq8f6ek0ktHrrdoNwdYj6I4v4V+vyfQqCQCB8MSuSzt/oIMJiof0W1UrwfAw2Ouf9CrNLzlCOKVyde6HI2zLM=
X-Received: by 2002:a92:b10:: with SMTP id b16mr14832874ilf.154.1623693396587;
 Mon, 14 Jun 2021 10:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-2-dmatlack@google.com>
In-Reply-To: <20210611235701.3941724-2-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 14 Jun 2021 10:56:25 -0700
Message-ID: <CANgfPd86b95ZCOFs89eqbcvmkiNz08WT+yuWdR-jZ-YjSeWArA@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Refactor is_tdp_mmu_root()
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
> Refactor is_tdp_mmu_root() into is_vcpu_using_tdp_mmu() to reduce
> duplicated code at call sites and make the code more readable.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Nice cleanup!

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c     | 10 +++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++---
>  3 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0144c40d09c7..eccd889d20a5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>                 return reserved;
>         }
>
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_vcpu_using_tdp_mmu(vcpu))
>                 leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
>         else
>                 leaf = get_walk(vcpu, addr, sptes, &root);
> @@ -3729,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
>
> -       if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
> +       if (!is_vcpu_using_tdp_mmu(vcpu)) {
>                 r = fast_page_fault(vcpu, gpa, error_code);
>                 if (r != RET_PF_INVALID)
>                         return r;
> @@ -3751,7 +3751,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>
>         r = RET_PF_RETRY;
>
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_vcpu_using_tdp_mmu(vcpu))
>                 read_lock(&vcpu->kvm->mmu_lock);
>         else
>                 write_lock(&vcpu->kvm->mmu_lock);
> @@ -3762,7 +3762,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (r)
>                 goto out_unlock;
>
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_vcpu_using_tdp_mmu(vcpu))
>                 r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
>                                     pfn, prefault);
>         else
> @@ -3770,7 +3770,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                                  prefault, is_tdp);
>
>  out_unlock:
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_vcpu_using_tdp_mmu(vcpu))
>                 read_unlock(&vcpu->kvm->mmu_lock);
>         else
>                 write_unlock(&vcpu->kvm->mmu_lock);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 237317b1eddd..f4cc79dabeae 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -979,7 +979,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>
>         if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
>                 return RET_PF_RETRY;
> -       if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
> +       if (WARN_ON(!is_vcpu_using_tdp_mmu(vcpu)))
>                 return RET_PF_RETRY;
>
>         level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 5fdf63090451..c8cf12809fcf 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -91,16 +91,18 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  #endif
>
> -static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> +static inline bool is_vcpu_using_tdp_mmu(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm *kvm = vcpu->kvm;
>         struct kvm_mmu_page *sp;
> +       hpa_t root_hpa = vcpu->arch.mmu->root_hpa;
>
>         if (!is_tdp_mmu_enabled(kvm))
>                 return false;
> -       if (WARN_ON(!VALID_PAGE(hpa)))
> +       if (WARN_ON(!VALID_PAGE(root_hpa)))
>                 return false;
>
> -       sp = to_shadow_page(hpa);
> +       sp = to_shadow_page(root_hpa);
>         if (WARN_ON(!sp))
>                 return false;
>
> --
> 2.32.0.272.g935e593368-goog
>

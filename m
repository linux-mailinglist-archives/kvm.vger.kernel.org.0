Return-Path: <kvm+bounces-53781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8A3B16D38
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8467B162055
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACFD28D845;
	Thu, 31 Jul 2025 08:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ueZF307k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48B61E1DFE
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949440; cv=none; b=A6efC/xuDYqfPtbdGOlXC2F+sZUkT/aj+2EI6pEuYtNGRdC73yEZXkOPIumEqA0wTWOUB9PmV0BBUSbCtL1FmYD5xweC9WEFF9XUa34GmYXFS0BACK2K6ORQP7zaKYkGCNeUnFkCdt6NtiKtd1qpyEUOhwv1lz4ppXlgMXAEozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949440; c=relaxed/simple;
	bh=iWK7yDuSX/2hBESKsD8OB/il2BtqiLsVYIcUGE0/U7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YGOvq91g9l9BE0XGf+PI+0ZrVe3uJS9cCrftrRrQddr5w0OK11ea9A8A8a8nzh8n7Us22H+mjZshfc1KjLG3UEuwkEFN3Wz0gOB9wFUX+hhTTmGWvX8MHMEuSxEG0ol9OPVViKKF9DeS4I9R2ENIew7GaeK/DnEkD7VSEV2AsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ueZF307k; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4aef56cea5bso61801cf.1
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949437; x=1754554237; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ym+KfsIsiJuhcwUQE9TjvZiMZ2sqbIuEwLQHI4C8Z9k=;
        b=ueZF307kHs1ab8docImWTeitrZS7C9Zo/jlUZOgl0iXadIx77gXaLCY7e0jsORBdHI
         it3tsHVVgav5H04gQoM7a2PqHI9AFvTttal+xrxnNi5SOW/ylBa14GUg8FBpLHjuQBdF
         tk1bmH53fICOY6pqCZW+AYEHGhzUYtFh1t2Qjoyfipuak1rlN5qXUda5jMziosBru55f
         uS12p9ZMnTEKT8HyWuUCPth2cVqjMxlTQ292J9XeRhpQsr8DDiKIqVvAaP04wR69jAi8
         gPOoiHxGnTQk+WcU/Cvvo3mdmVniQxBpU1IhKZEOYNVqIchQqb/Dgp0UUKGD+BRYBXRY
         x8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949437; x=1754554237;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ym+KfsIsiJuhcwUQE9TjvZiMZ2sqbIuEwLQHI4C8Z9k=;
        b=hRnu235fPDLxsn0SuNM0hw+9BnzZ9DfHCpM4LdfrMeXUwEWKFCe1+8RNPiSkSw3T86
         UbX7yn0Tk622bl6Y+b26kLbzVvjlbR2ApUSr2BGXTyMs0U5TfSep9tKwES0LS3zNONX+
         JXv3vyIKTopBYrH8+McSwh+Y1QpWYdTfX0XBgIumC5qfc1cE6MDTOUPflHH7P6hcQ14i
         nzhuL2oOh7QW3YL/DvcyQ4YnuG08QwAOPt2IEcEour+AONkpXIZaNmyB5VwgEH3PuEwg
         I7Wr373/pMOJw/Gs2taWJFCmrPUJuhkPn6YsIITKn6tVFopS9rZGlHwdBxTtlepnaF57
         sc9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbbz/UvQY/M0qiQOHxsfcKH31S5rbZMD7AJnuCFKWKzRkmf2aoqSXMZuOHUWc0sPcFF70=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG7czj7mvuPHzH503KikEr2uYRvTShveTDP08E2iRtpOTQbYa1
	BeCv00ewL3r+emisAeHpalzVzMf5+qUph2YLUyKj/Q2p3KgjmBzqTIVMWuED6R9D0/B4zW+hg6M
	g2xrTKZUN109mhs1tXjbuHiXSwhzDdIbpuCWbSKZ3
X-Gm-Gg: ASbGncsBvjGXLWzWA3dqWCxwsUfzMW3ppnfz+xPMiunFpZNS9oJvtR53kVaEbphwWvN
	bDyKwd68sqskwX0CrC83pIh45OXqde60x32aBEAICPi161PlfIjQacB+uzwJy167d1oCpuSPzK+
	ycw5SIGxGJenKjtIDfxY42OOLGrhKZzZGk8YGfWwYQxErJOqzSu6/qWWpWrOtjiI4REFghXv467
	2xCADo=
X-Google-Smtp-Source: AGHT+IEr614AdjVOstI02RZSVaGE5epiw35pXc2xn/jyt9ydIWXUAOksQA4Mp9/n1z18ca9eQ0yhZiXPM3aYgvD8DAg=
X-Received: by 2002:a05:622a:255:b0:4a9:d263:dbc5 with SMTP id
 d75a77b69052e-4aeeff8921bmr2537351cf.20.1753949437046; Thu, 31 Jul 2025
 01:10:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-15-seanjc@google.com>
In-Reply-To: <20250729225455.670324-15-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:10:00 +0100
X-Gm-Features: Ac12FXwIu2LcfxL6Yt1oELL8kCAb5y4pcRQakHDJXAJPvI-67xBPicQzU3SN_SI
Message-ID: <CA+EHjTxHn-wFH08Z3sV+dq3aGGGmwtinD1qePABSiG6f5xW+WA@mail.gmail.com>
Subject: Re: [PATCH v17 14/24] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Rework kvm_mmu_max_mapping_level() to provide the plumbing to consult
> guest_memfd (and relevant vendor code) when recovering hugepages, e.g.
> after disabling live migration.  The flaw has existed since guest_memfd was
> originally added, but has gone unnoticed due to lack of guest_memfd support
> for hugepages or dirty logging.
>
> Don't actually call into guest_memfd at this time, as it's unclear as to
> what the API should be.  Ideally, KVM would simply use kvm_gmem_get_pfn(),
> but invoking kvm_gmem_get_pfn() would lead to sleeping in atomic context
> if guest_memfd needed to allocate memory (mmu_lock is held).  Luckily,
> the path isn't actually reachable, so just add a TODO and WARN to ensure
> the functionality is added alongisde guest_memfd hugepage support, and
> punt the guest_memfd API design question to the future.

nit: *alongside
>
> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
> of the gfn.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++--------------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  3 files changed, 49 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20dd9f64156e..61eb9f723675 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,31 +3302,54 @@ static u8 kvm_max_level_for_order(int order)
>         return PG_LEVEL_4K;
>  }
>
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -                                       u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +                                       const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -       u8 req_max_level;
> +       u8 max_level, coco_level;
> +       kvm_pfn_t pfn;
>
> -       if (max_level == PG_LEVEL_4K)
> -               return PG_LEVEL_4K;
> +       /* For faults, use the gmem information that was resolved earlier. */
> +       if (fault) {
> +               pfn = fault->pfn;
> +               max_level = fault->max_level;
> +       } else {
> +               /* TODO: Call into guest_memfd once hugepages are supported. */
> +               WARN_ONCE(1, "Get pfn+order from guest_memfd");
> +               pfn = KVM_PFN_ERR_FAULT;
> +               max_level = PG_LEVEL_4K;
> +       }
>
> -       max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>         if (max_level == PG_LEVEL_4K)
> -               return PG_LEVEL_4K;
> +               return max_level;
>
> -       req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -       if (req_max_level)
> -               max_level = min(max_level, req_max_level);
> +       /*
> +        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +        * restrictions.  A return of '0' means "no additional restrictions", to
> +        * allow for using an optional "ret0" static call.
> +        */
> +       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +       if (coco_level)
> +               max_level = min(max_level, coco_level);
>
>         return max_level;
>  }
>
> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> -                                      const struct kvm_memory_slot *slot,
> -                                      gfn_t gfn, int max_level, bool is_private)
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +                             const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
>         struct kvm_lpage_info *linfo;
> -       int host_level;
> +       int host_level, max_level;
> +       bool is_private;
> +
> +       lockdep_assert_held(&kvm->mmu_lock);
> +
> +       if (fault) {
> +               max_level = fault->max_level;
> +               is_private = fault->is_private;
> +       } else {
> +               max_level = PG_LEVEL_NUM;
> +               is_private = kvm_mem_is_private(kvm, gfn);
> +       }
>
>         max_level = min(max_level, max_huge_page_level);
>         for ( ; max_level > PG_LEVEL_4K; max_level--) {
> @@ -3335,25 +3358,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>                         break;
>         }
>
> +       if (max_level == PG_LEVEL_4K)
> +               return PG_LEVEL_4K;
> +
>         if (is_private)
> -               return max_level;
> -
> -       if (max_level == PG_LEVEL_4K)
> -               return PG_LEVEL_4K;
> -
> -       host_level = host_pfn_mapping_level(kvm, gfn, slot);
> +               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       else
> +               host_level = host_pfn_mapping_level(kvm, gfn, slot);
>         return min(host_level, max_level);
>  }
>
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> -                             const struct kvm_memory_slot *slot, gfn_t gfn)
> -{
> -       bool is_private = kvm_slot_has_gmem(slot) &&
> -                         kvm_mem_is_private(kvm, gfn);
> -
> -       return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> -}
> -
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>         struct kvm_memory_slot *slot = fault->slot;
> @@ -3374,9 +3388,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * Enforce the iTLB multihit workaround after capturing the requested
>          * level, which will be used to do precise, accurate accounting.
>          */
> -       fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
> -                                                      fault->gfn, fault->max_level,
> -                                                      fault->is_private);
> +       fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
> +                                                    fault->slot, fault->gfn);
>         if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>                 return;
>
> @@ -4564,8 +4577,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>         }
>
>         fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -       fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
> -                                                        fault->max_level, max_order);
> +       fault->max_level = kvm_max_level_for_order(max_order);
>
>         return RET_PF_CONTINUE;
>  }
> @@ -7165,7 +7177,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>                  * mapping if the indirect sp has level = 1.
>                  */
>                 if (sp->role.direct &&
> -                   sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
> +                   sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
>                         kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>
>                         if (kvm_available_flush_remote_tlbs_range())
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 65f3c89d7c5d..b776be783a2f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>         return r;
>  }
>
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>                               const struct kvm_memory_slot *slot, gfn_t gfn);
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..740cb06accdb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
>                 if (iter.gfn < start || iter.gfn >= end)
>                         continue;
>
> -               max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
> +               max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
>                 if (max_mapping_level < iter.level)
>                         continue;
>
> --
> 2.50.1.552.g942d659e1b-goog
>


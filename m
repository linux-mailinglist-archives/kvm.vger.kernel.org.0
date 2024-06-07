Return-Path: <kvm+bounces-19067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA82990025A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 13:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B74A11C22858
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 11:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B037F19066C;
	Fri,  7 Jun 2024 11:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ur5VKiuW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE6190662
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 11:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717760289; cv=none; b=OC93/NCq+8mYH5vA5dk7De2KAnSrAck5GJBS8XZlUIyTPnGZqryI53V6vrGGcwm4x3OzoUspnD1lZFdsABIKM+X9zwb4sI0yqnvOtPIcH/At0iQmv4QGaCFpP8ASL/T2hIVel2mDhady5Z1xMCMXwkvr+rMps36srF1TBo0cOLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717760289; c=relaxed/simple;
	bh=ZwGz3dMIKiy1SGVc6DmAoKeJjQKPprY0dxrpiRbneyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gf3wvujBlZ+NJrCvGxDoUCaOuvFs4Xp/VgnZu353TneSDCpqUYE8sbtIhcsGjVRnOYxA0gSGJyZJ/5EnffFwuNWOEyu6IgYsvHyOOnuTBZ1F8Iqy/XUC05rGKGtZxmVV9XO5N9vqKKm9/9ZICjG8qT0YImQna3LcWX/r0HmoBFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ur5VKiuW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717760287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pzhopGWO5Z3fLTBer4K8pJwod91YQ/MXu5FiCbmJuWw=;
	b=Ur5VKiuWk8ook8uU3pXXs0+tc8AgjYIttBrQmzTlwlZNsECDJjhU5URThCkToe+tLtFExn
	tvdTCSqzkBwjRSKRWXBcUqkIPvIktP0+upFH4gLjN0ZhXHMBb4nD2xJuKLI59AjmeZSiJy
	A/ohFNpsdqz0x/v8IWEETZBU/vFdWIo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-sjvSlyFiNBSg7Jf9vo7NVQ-1; Fri, 07 Jun 2024 07:38:05 -0400
X-MC-Unique: sjvSlyFiNBSg7Jf9vo7NVQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35f09791466so278948f8f.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 04:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717760285; x=1718365085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pzhopGWO5Z3fLTBer4K8pJwod91YQ/MXu5FiCbmJuWw=;
        b=mXNX5I1U6tQWJlmd495ikwnKQi93OYpnOJEVfT0lECvsv3rNU5IRdrJTgZMKnxAJ4y
         l1934uPFh5Hl0Ay2/TfNxPx6BDInoFiJM8MC6aWZ+SXZ7kAVXlHgSE1NAeUZnTP9QXbU
         GiNQowdlJ9qOs0k4k5Epm9usdg2OBhj4KmiUELNAcl2jK9fgW25zdVqs5XteGjz8S8F7
         D8APHSk7BiEa/oTbkr2fJWPTxednuu9eetzRERj4f4Jh28DRHiQLFHI6/9hMgTrX8AJ/
         71msFa9pllbL8XEeiCjPiABiU8ygOQvu+8IQF0js5V4G3qJTHimcmnuD/aVOtA7WNJz2
         T/Iw==
X-Forwarded-Encrypted: i=1; AJvYcCXiJi13RgJIx0PGha0qjVwYloM0MpY5YtxVuVqO/o1edK+s/XiGvC9g2yK/uk0A4vrVlKvyvCpHs841u7CkHLRUlrq1
X-Gm-Message-State: AOJu0Yykgr4fknvV9hr0Xlp2yx8XFrqQfLAdnr42EcEOngEfUr+PJTEq
	5j239CQBI/PD7wX9AnXzZYNKhZFlMW0Ke+ZMiOQa5rq/p5DVLJ/2vJngIlpMzsq2Usk6Yc1I4IU
	IK4vt5DOHc6PRgkpF5wEJu8sX16/CBNn8CechpG/GtDoReu+vWmwSUEdEdRPrCpXQVwOTzYZwyZ
	WdcGSaUC+QTLYssI3VX8Q0Haov
X-Received: by 2002:adf:f60d:0:b0:35c:1961:899d with SMTP id ffacd0b85a97d-35efed4333emr1673629f8f.27.1717760284660;
        Fri, 07 Jun 2024 04:38:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIZNOxJ1unwke+idF8m4DpHS/yuyn22TObQi6Lae1ZsorkINpomsbaTcQo3FwgGKz4bNKunC3enrDIxmzElrg=
X-Received: by 2002:adf:f60d:0:b0:35c:1961:899d with SMTP id
 ffacd0b85a97d-35efed4333emr1673612f8f.27.1717760284299; Fri, 07 Jun 2024
 04:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-12-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-12-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 13:37:52 +0200
Message-ID: <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    |  8 ++++++
>  arch/x86/kvm/mmu/tdp_mmu.c         | 45 ++++++++++++++++++++++++++++--
>  3 files changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 1877d6a77525..dae06afc6038 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -97,6 +97,8 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP_OPTIONAL(reflect_link_spt)
>  KVM_X86_OP_OPTIONAL(reflect_set_spte)
> +KVM_X86_OP_OPTIONAL(reflect_free_spt)
> +KVM_X86_OP_OPTIONAL(reflect_remove_spte)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 20bb10f22ca6..0df4a31a0df9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1755,6 +1755,14 @@ struct kvm_x86_ops {
>         int (*reflect_set_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>                                 kvm_pfn_t pfn);
>
> +       /* Update mirrored page tables for page table about to be freed */
> +       int (*reflect_free_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +                               void *mirrored_spt);
> +
> +       /* Update mirrored page table from spte getting removed, and flush TLB */
> +       int (*reflect_remove_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +                                  kvm_pfn_t pfn);

Again, maybe free_external_spt and zap_external_spte?

Also, please rename the last argument to pfn_for_gfn. I'm not proud of
it, but it took me over 10 minutes to understand if the pfn referred
to the gfn itself, or to the external SP that holds the spte...
There's a possibility that it isn't just me. :)

(In general, this patch took me a _lot_ to review... there were a
couple of places that left me incomprehensibly puzzled, more on this
below).

>         bool (*has_wbinvd_exit)(void);
>
>         u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 41b1d3f26597..1245f6a48dbe 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -346,6 +346,29 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
>
> +static void reflect_removed_spte(struct kvm *kvm, gfn_t gfn,
> +                                       u64 old_spte, u64 new_spte,
> +                                       int level)

new_spte is not used and can be dropped. Also, tdp_mmu_zap_external_spte?

> +{
> +       bool was_present = is_shadow_present_pte(old_spte);
> +       bool was_leaf = was_present && is_last_spte(old_spte, level);

Just put it below:

if (!is_shadow_present_pte(old_spte))
  return;

/* Here we only care about zapping the external leaf PTEs. */
if (!is_last_spte(old_spte, level))

> +       kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> +       int ret;
> +
> +       /*
> +        * Allow only leaf page to be zapped. Reclaim non-leaf page tables page

This comment left me confused, so I'll try to rephrase and see if I
can explain what happens. Correct me if I'm wrong.

The only paths to handle_removed_pt() are:
- kvm_tdp_mmu_zap_leafs()
- kvm_tdp_mmu_zap_invalidated_roots()

but because kvm_mmu_zap_all_fast() does not operate on mirror roots,
the latter can only happen at VM destruction time.

But it's not clear why it's worth mentioning it here, or even why it
is special at all. Isn't that just what handle_removed_pt() does at
the end? Why does it matter that it's only done at VM destruction
time?

In other words, it seems to me that this comment is TMI. And if I am
wrong (which may well be), the extra information should explain the
"why" in more detail, and it should be around the call to
reflect_free_spt, not here.

> +               return;
> +       /* Zapping leaf spte is allowed only when write lock is held. */
> +       lockdep_assert_held_write(&kvm->mmu_lock);
> +       /* Because write lock is held, operation should success. */
> +       ret = static_call(kvm_x86_reflect_remove_spte)(kvm, gfn, level, old_pfn);
> +       KVM_BUG_ON(ret, kvm);
> +}
> +
>  /**
>   * handle_removed_pt() - handle a page table removed from the TDP structure
>   *
> @@ -441,6 +464,22 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>                 }
>                 handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
>                                     old_spte, REMOVED_SPTE, sp->role, shared);
> +               if (is_mirror_sp(sp)) {
> +                       KVM_BUG_ON(shared, kvm);
> +                       reflect_removed_spte(kvm, gfn, old_spte, REMOVED_SPTE, level);
> +               }
> +       }
> +
> +       if (is_mirror_sp(sp) &&
> +           WARN_ON(static_call(kvm_x86_reflect_free_spt)(kvm, sp->gfn, sp->role.level,
> +                                                         kvm_mmu_mirrored_spt(sp)))) {

Please use base_gfn and level here, instead of fishing them from sp.

> +               /*
> +                * Failed to free page table page in mirror page table and
> +                * there is nothing to do further.
> +                * Intentionally leak the page to prevent the kernel from
> +                * accessing the encrypted page.
> +                */
> +               sp->mirrored_spt = NULL;
>         }
>
>         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> @@ -778,9 +817,11 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>         role.level = level;
>         handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
>
> -       /* Don't support setting for the non-atomic case */
> -       if (is_mirror_sptep(sptep))
> +       if (is_mirror_sptep(sptep)) {
> +               /* Only support zapping for the non-atomic case */

Like for patch 10, this comment should point out why we never get here
for mirror SPs.

Paolo

>                 KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> +               reflect_removed_spte(kvm, gfn, old_spte, REMOVED_SPTE, level);
> +       }
>
>         return old_spte;
>  }
> --
> 2.34.1
>



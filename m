Return-Path: <kvm+bounces-19020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6107C8FF184
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D919E288667
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781E7197A8C;
	Thu,  6 Jun 2024 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8B89E+/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC37196C68
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717689875; cv=none; b=KXyBjOPIorYcs87B5+doAoJraeh4ebpywLWEeSZYoVhv4Bbps18xLSYu7FlODE7pmqDODbqPerLKS0AYzzCYswXmL2dxI38abhWunRwtDfdpWjVDdz3Wfb/vMlxJmN9mniMhTCCbN31RwrrEzPM0GvgVe1c2l68HTgDCoBDKkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717689875; c=relaxed/simple;
	bh=VB4ZT7y7ubhEcNdi+Z6RBcm06BWgu2STwBI8AxU5xtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AUiLndU466QyrGUX5F2djb8wIZdYApXLrY+lIsTOqxc7H/dS7P8kESD25FJofDESxNuXV468e+HlN8eMWoQT+xINZF0oa56O7NfY2Rng9XJJLp3keCMoC+cAEW5pZ4gueO2AOQZfMvcj5EUW1aNDOeFJVwu3HSmmy0uoYhgHbD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8B89E+/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717689872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pfA3Qnw2+eAYJOpoaCDqBDsNQKqj0hc7AnbxZ6IN4PE=;
	b=T8B89E+/d1sFIsn9zjPMN5vMak/J/PK+CWuPgDKgYvohzhwu9xq1BM74L2e006HXd1e58H
	wbSkCZL6552juSFherYEaKN6/BPERFsBGpQT5AIYZsi5VShA3ad3yZXWaaDsEAKaJShojs
	8CtvHXjLKyzJ95G7YYYM8Ko+MN8Dyig=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-rWii4-PjOt2GRVmANHtEZA-1; Thu, 06 Jun 2024 12:04:30 -0400
X-MC-Unique: rWii4-PjOt2GRVmANHtEZA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42155e1f0aaso11308115e9.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 09:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717689869; x=1718294669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfA3Qnw2+eAYJOpoaCDqBDsNQKqj0hc7AnbxZ6IN4PE=;
        b=V3GyQCKxWIO5ueSzUZCUIXZUzvDApv5VXfiPZxQqg2NoRRjCz9HtgeG/KuUPL6JxZu
         e46ZVlGAW/tww8pEhB+jqHRpLPdiGYEkEwX4kSnWkISqQ1pKbrtvJpJrLdqBPRWH1JnB
         DhISw60YcOcnpVFIy2ehJuxMPCa/jajOEXcD9sL0njIxKj6YoBWASRvyniYjqfbC7lgE
         +2QxKUU9CrXlSMSBhx217QwA8uV+IumQeIpBvNUleV8qI/9/I7zAEFR0mXfsSmkg0xk7
         p0hyW66VJGB4NolLpCv2L0PcMFUQ6iMMwE35WSGcuc9YqbO1RHmuhc7DEE2Aqhu+p++x
         zBLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU8brdFt7oYZRGp4vUvp0tZkLCKz9/5Ql7DSX6gz7Htw2IAX/OpPfSqWNNTCFPgBvxglFvareEs5BbTas/FV29AlPG
X-Gm-Message-State: AOJu0YwDM7qXdPY1oV9IT0H+/96aZzupB5CojQU9ica38zQYAfR/Z49W
	DXEHqcS1Qcn9M5bFfg5xPPA+o6k+q2RuFtKb5geuAaMBGzJk1pZ9G2/DOSKCK3pZoInwrsi9IGp
	/TqT3NKsLJcWgKhW5Q0RGGWKHFV3B5dirCX41/JStcUBJVwQtIR7Df4T4eF0th0qNJfElaLWXLa
	USZm9UmEK55Oqur3swtfAN8IX8
X-Received: by 2002:a05:600c:34d5:b0:420:fed7:2903 with SMTP id 5b1f17b1804b1-421649fbfa9mr1534405e9.15.1717689868985;
        Thu, 06 Jun 2024 09:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEtcMoC8e263ZOq7Zpku7n6tvwSu52vSZNIEAlnH04yVgG8by9a1+rNrcAr3RoPs3nnSCahP04ezzjzcdHBHA=
X-Received: by 2002:a05:600c:34d5:b0:420:fed7:2903 with SMTP id
 5b1f17b1804b1-421649fbfa9mr1534125e9.15.1717689868482; Thu, 06 Jun 2024
 09:04:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-4-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-4-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Jun 2024 18:04:17 +0200
Message-ID: <CABgObfYO2FgAOpvp-9jexp5fMh2xoYyE1CNs526z9S7i2Gao_g@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] KVM: x86/mmu: Add a mirrored pointer to struct kvm_mmu_page
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a mirrored pointer to struct kvm_mmu_page for the private page table =
and
> add helper functions to allocate/initialize/free a private page table pag=
e.
> Because KVM TDP MMU doesn't use unsync_children and write_flooding_count,
> pack them to have room for a pointer and use a union to avoid memory
> overhead.
>
> For private GPA, CPU refers to a private page table whose contents are
> encrypted. The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used, and their cost is expensive.
>
> When KVM resolves the KVM page fault, it walks the page tables. To reuse
> the existing KVM MMU code and mitigate the heavy cost of directly walking
> the private page table, allocate one more page for the mirrored page tabl=
e
> for the KVM MMU code to directly walk. Resolve the KVM page fault with
> the existing code, and do additional operations necessary for the private
> page table. To distinguish such cases, the existing KVM page table is
> called a shared page table (i.e., not associated with a private page
> table), and the page table with a private page table is called a mirrored
> page table. The relationship is depicted below.
>
>               KVM page fault                     |
>                      |                           |
>                      V                           |
>         -------------+----------                 |
>         |                      |                 |
>         V                      V                 |
>      shared GPA           private GPA            |
>         |                      |                 |
>         V                      V                 |
>     shared PT root      mirror PT root           |    private PT root
>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT           mirror PT     --propagate-->  private/mirrored P=
T
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT: Page table
> Shared PT: visible to KVM, and the CPU uses it for shared mappings.
> Private/mirrored PT: the CPU uses it, but it is invisible to KVM.  TDX
>                      module updates this table to map private guest pages=
.
> Mirror PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
>              to propagate PT change to the actual private PT.

Which one is the "Mirror" and which one is the "Mirrored" PT is
uncomfortably confusing.

I hate to bikeshed even more, but while I like "Mirror PT" (a lot), I
would stick with "Private" or perhaps "External" for the pages owned
by the TDX module.

> +       /*
> +        * This cache is to allocate private page table. E.g. private EPT=
 used
> +        * by the TDX module.
> +        */
> +       struct kvm_mmu_memory_cache mmu_mirrored_spt_cache;

So this would be "mmu_external_spt_cache".

> -       unsigned int unsync_children;
> +       union {
> +               /* Those two members aren't used for TDP MMU */

s/Those/These/

> +               struct {
> +                       unsigned int unsync_children;
> +                       /*
> +                        * Number of writes since the last time traversal
> +                        * visited this page.
> +                        */
> +                       atomic_t write_flooding_count;
> +               };
> +               /*
> +                * Page table page of private PT.
> +                * Passed to TDX module, not accessed by KVM.
> +                */
> +               void *mirrored_spt;

external_spt

> +static inline void kvm_mmu_alloc_mirrored_spt(struct kvm_vcpu *vcpu, str=
uct kvm_mmu_page *sp)
> +{
> +       /*
> +        * mirrored_spt is allocated for TDX module to hold private EPT m=
appings,
> +        * TDX module will initialize the page by itself.
> +        * Therefore, KVM does not need to initialize or access mirrored_=
spt.
> +        * KVM only interacts with sp->spt for mirrored EPT operations.
> +        */
> +       sp->mirrored_spt =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_m=
irrored_spt_cache);
> +}
> +
> +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, stru=
ct kvm_mmu_page *sp)
> +{
> +       /*
> +        * private_spt is allocated for TDX module to hold private EPT ma=
ppings,
> +        * TDX module will initialize the page by itself.
> +        * Therefore, KVM does not need to initialize or access private_s=
pt.
> +        * KVM only interacts with sp->spt for mirrored EPT operations.
> +        */
> +       sp->mirrored_spt =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_m=
irrored_spt_cache);
> +}

Duplicate function.

Naming aside, looks good.

Paolo

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a mirrored pointer to struct kvm_mmu_page for the private page table =
and
> add helper functions to allocate/initialize/free a private page table pag=
e.
> Because KVM TDP MMU doesn't use unsync_children and write_flooding_count,
> pack them to have room for a pointer and use a union to avoid memory
> overhead.
>
> For private GPA, CPU refers to a private page table whose contents are
> encrypted. The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used, and their cost is expensive.
>
> When KVM resolves the KVM page fault, it walks the page tables. To reuse
> the existing KVM MMU code and mitigate the heavy cost of directly walking
> the private page table, allocate one more page for the mirrored page tabl=
e
> for the KVM MMU code to directly walk. Resolve the KVM page fault with
> the existing code, and do additional operations necessary for the private
> page table. To distinguish such cases, the existing KVM page table is
> called a shared page table (i.e., not associated with a private page
> table), and the page table with a private page table is called a mirrored
> page table. The relationship is depicted below.
>
>               KVM page fault                     |
>                      |                           |
>                      V                           |
>         -------------+----------                 |
>         |                      |                 |
>         V                      V                 |
>      shared GPA           private GPA            |
>         |                      |                 |
>         V                      V                 |
>     shared PT root      mirror PT root           |    private PT root
>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT           mirror PT     --propagate-->  private/mirrored P=
T
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT: Page table
> Shared PT: visible to KVM, and the CPU uses it for shared mappings.
> Private/mirrored PT: the CPU uses it, but it is invisible to KVM.  TDX
>                      module updates this table to map private guest pages=
.
> Mirror PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
>              to propagate PT change to the actual private PT.
>
> Add a helper kvm_has_mirrored_tdp() to trigger this behavior and wire it
> to the TDX vm type.
>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX MMU Prep v2:
>  - Rename private->mirror
>  - Don't trigger off of shared mask
>
> TDX MMU Prep:
> - Rename terminology, dummy PT =3D> mirror PT. and updated the commit mes=
sage
>   By Rick and Kai.
> - Added a comment on union of private_spt by Rick.
> - Don't handle the root case in kvm_mmu_alloc_private_spt(), it will not
>   be needed in future patches. (Rick)
> - Update comments (Yan)
> - Remove kvm_mmu_init_private_spt(), open code it in later patches (Yan)
>
> v19:
> - typo in the comment in kvm_mmu_alloc_private_spt()
> - drop CONFIG_KVM_MMU_PRIVATE
> ---
>  arch/x86/include/asm/kvm_host.h |  5 ++++
>  arch/x86/kvm/mmu.h              |  5 ++++
>  arch/x86/kvm/mmu/mmu.c          |  7 +++++
>  arch/x86/kvm/mmu/mmu_internal.h | 47 ++++++++++++++++++++++++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>  5 files changed, 61 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index aabf1648a56a..250899a0239b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -817,6 +817,11 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>         struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
> +       /*
> +        * This cache is to allocate private page table. E.g. private EPT=
 used
> +        * by the TDX module.
> +        */
> +       struct kvm_mmu_memory_cache mmu_mirrored_spt_cache;
>
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index dc80e72e4848..0c3bf89cf7db 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -318,4 +318,9 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu=
 *vcpu,
>                 return gpa;
>         return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
> +{
> +       return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
> +}
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b97241945596..5070ba7c6e89 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -685,6 +685,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *=
vcpu, bool maybe_indirect)
>                                        1 + PT64_ROOT_MAX_LEVEL + PTE_PREF=
ETCH_NUM);
>         if (r)
>                 return r;
> +       if (kvm_has_mirrored_tdp(vcpu->kvm)) {
> +               r =3D kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_mirrored=
_spt_cache,
> +                                              PT64_ROOT_MAX_LEVEL);
> +               if (r)
> +                       return r;
> +       }
>         r =3D kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cach=
e,
>                                        PT64_ROOT_MAX_LEVEL);
>         if (r)
> @@ -704,6 +710,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *v=
cpu)
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_mirrored_spt_cache);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index 706f0ce8784c..faef40a561f9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -101,7 +101,22 @@ struct kvm_mmu_page {
>                 int root_count;
>                 refcount_t tdp_mmu_root_count;
>         };
> -       unsigned int unsync_children;
> +       union {
> +               /* Those two members aren't used for TDP MMU */
> +               struct {
> +                       unsigned int unsync_children;
> +                       /*
> +                        * Number of writes since the last time traversal
> +                        * visited this page.
> +                        */
> +                       atomic_t write_flooding_count;
> +               };
> +               /*
> +                * Page table page of private PT.
> +                * Passed to TDX module, not accessed by KVM.
> +                */
> +               void *mirrored_spt;
> +       };
>         union {
>                 struct kvm_rmap_head parent_ptes; /* rmap pointers to par=
ent sptes */
>                 tdp_ptep_t ptep;
> @@ -124,9 +139,6 @@ struct kvm_mmu_page {
>         int clear_spte_count;
>  #endif
>
> -       /* Number of writes since the last time traversal visited this pa=
ge.  */
> -       atomic_t write_flooding_count;
> -
>  #ifdef CONFIG_X86_64
>         /* Used for freeing the page asynchronously if it is a TDP MMU pa=
ge. */
>         struct rcu_head rcu_head;
> @@ -145,6 +157,33 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_=
page *sp)
>         return kvm_mmu_role_as_id(sp->role);
>  }
>
> +static inline void *kvm_mmu_mirrored_spt(struct kvm_mmu_page *sp)
> +{
> +       return sp->mirrored_spt;
> +}
> +
> +static inline void kvm_mmu_alloc_mirrored_spt(struct kvm_vcpu *vcpu, str=
uct kvm_mmu_page *sp)
> +{
> +       /*
> +        * mirrored_spt is allocated for TDX module to hold private EPT m=
appings,
> +        * TDX module will initialize the page by itself.
> +        * Therefore, KVM does not need to initialize or access mirrored_=
spt.
> +        * KVM only interacts with sp->spt for mirrored EPT operations.
> +        */
> +       sp->mirrored_spt =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_m=
irrored_spt_cache);
> +}
> +
> +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, stru=
ct kvm_mmu_page *sp)
> +{
> +       /*
> +        * private_spt is allocated for TDX module to hold private EPT ma=
ppings,
> +        * TDX module will initialize the page by itself.
> +        * Therefore, KVM does not need to initialize or access private_s=
pt.
> +        * KVM only interacts with sp->spt for mirrored EPT operations.
> +        */
> +       sp->mirrored_spt =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_m=
irrored_spt_cache);
> +}
> +
>  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_pag=
e *sp)
>  {
>         /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1259dd63defc..e7cd4921afe7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> +       free_page((unsigned long)sp->mirrored_spt);
>         free_page((unsigned long)sp->spt);
>         kmem_cache_free(mmu_page_header_cache, sp);
>  }
> --
> 2.34.1
>



Return-Path: <kvm+bounces-7509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9588431DA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6CCBB24869
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 00:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE1636F;
	Wed, 31 Jan 2024 00:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y4l20u3A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B901365
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660777; cv=none; b=UrnqopiqKf47JMuRbnYiGALK64RYyvX6/pB42l5ArYPajWlEBh6QMVCiKo1KwPlt7TZs9j1Qbnlfn+HUHgn7aFlmIzAPO0I0CsfsVoP6J/ka4nY2nrT04kgtzr+ByjtqJSkldhuMiYflRXCJqCLYx/Cy2idzMM+781ROBmTMb04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660777; c=relaxed/simple;
	bh=5Ft3x7vH92sHC+4mwuIzp2Xups2UZjr2TRAvUS18rxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D2/8quBEi7AvmdwjSavFAf9EW2Zu6mMgZ8l+EijN3/b5y4sTT/DmhGspwaWtOzl0Jeavo82hmISUGYIi6t5WI9+gm4vFMUKa4/2xEvYyHCr6MqoqtHNdITvCaGfr2mfmUZ9U7xonf5Kjp1lES1nNpAxmPNfjblT3aTrLZ5XERQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y4l20u3A; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d8d8bb7628so73855ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706660775; x=1707265575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLCwZ5uA7UJl0ynORHFgZv0xeWqCUgqPDf4wSdy1diY=;
        b=y4l20u3ARxzXL66pHoTK9yNrX6Y9ptT6TH1xnwMh6ghfaANIYrNmy1YxUb/7AZ5grG
         VvLlxYlCU20zXplxBwdDXVXvn1VRX+6NuBbAKLdnK/KXg+0hI3uOeQwLCD7ALpuQJ6a9
         GtO3KXMYZqR5SFwU+l7lefjWLXNUmiD0wS+AnhIiLVOb0HKjSmqdzeXDL8WHLACYEp45
         +TBhovxa5p0RoBWrCkFdWIXNlQOQmqu9H9WcCmumdUR6i+ufVRUHYenKJrN8jIb4T/fc
         Zfk9pEesb11mg5EAhJokmGqjeFMB0XnNTvoY6d8ETVjQ5xv8RngWKinqem9Mx4sM8pDh
         Zshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660775; x=1707265575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLCwZ5uA7UJl0ynORHFgZv0xeWqCUgqPDf4wSdy1diY=;
        b=I9xQDOeQhSeB+XeirAS2ohJvzo2yExsVpJhOQHCoRRjDVUpiGEDCbPteVtu9mxnYG0
         Bl0/duDuT7vvLArvQ/Rl2gT+/NtrQIaGRRiHZjZUJq+ZWmfkCSXjHRdX+BsGUGS+PUHy
         qryoZ6WXVGLOaTfikAEOIoWFTWTPZgdBPG83lvJ5H/3BiylxpEVivtRBSVtgCg0XOwUF
         cSCnZmUSnPzB0rfDjNFixa1+jANtXHG0TqUfZnR8P2pH2CQCQL6x3BmS8XBFUuphxPQ2
         lymT0tvhCEo2xzwEI0IUSfUfI2WwYGmwYYiGydSWzEBJ33cMs0imDPw8lyqisMX8yAIf
         WiOQ==
X-Gm-Message-State: AOJu0YzAyei/sTJQxqpgQQS4BIakKslf62AmtAM2jk+tS35btP6dH2VL
	492621w5+4lAMIv6TGESgNuquM+KciVZ3jEe88ufEN9/hOJa2WOlrnAVSLPSgC05GLQbVRyL3B3
	iyR5SzlgzYepeHFilW3/KK83XmedF40WsBHFdO3fUYx5ZnCYgBrlO
X-Google-Smtp-Source: AGHT+IHxP6Z0zujAuUuW9S+75zfkxpSA4wI0H+TFeR6oSqA0DII19VHDuV9OrFGqKtKEyHsYI280O4WebdmEemERn0c=
X-Received: by 2002:a17:902:db11:b0:1d9:1b3d:6ed4 with SMTP id
 m17-20020a170902db1100b001d91b3d6ed4mr222709plx.28.1706660774314; Tue, 30 Jan
 2024 16:26:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-7-amoorthy@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 30 Jan 2024 16:25:36 -0800
Message-ID: <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Allowing KVM to fault in pages during vcpu-context guest memory accesses
> can be undesirable: during userfaultfd-based postcopy, it can cause
> significant performance issues due to vCPUs contending for
> userfaultfd-internal locks.
>
> Add a new memslot flag (KVM_MEM_EXIT_ON_MISSING) through which userspace
> can indicate that KVM_RUN should exit instead of faulting in pages
> during vcpu-context guest memory accesses. The unfaulted pages are
> reported by the accompanying KVM_EXIT_MEMORY_FAULT_INFO, allowing
> userspace to determine and take appropriate action.
>
> The basic implementation strategy is to check the memslot flag from
> within __gfn_to_pfn_memslot() and override the caller-provided arguments
> accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
> out of this behavior, and do so by passing can_exit_on_missing=3Dfalse.
>
> No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING or
> passes can_exit_on_missing=3Dtrue to __gfn_to_pfn_memslot().
>
> Suggested-by: James Houghton <jthoughton@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  Documentation/virt/kvm/api.rst         | 28 +++++++++++++++++++++++---
>  arch/arm64/kvm/mmu.c                   |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>  arch/x86/kvm/mmu/mmu.c                 |  4 ++--
>  include/linux/kvm_host.h               | 12 ++++++++++-
>  include/uapi/linux/kvm.h               |  2 ++
>  virt/kvm/Kconfig                       |  3 +++
>  virt/kvm/kvm_main.c                    | 25 ++++++++++++++++++-----
>  9 files changed, 66 insertions(+), 14 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index a07964f601de..1457865f6e98 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1365,6 +1365,8 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES      (1UL << 0)
>    #define KVM_MEM_READONLY     (1UL << 1)
> +  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
>
>  This ioctl allows the user to create, modify or delete a guest physical
>  memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> @@ -1395,12 +1397,16 @@ It is recommended that the lower 21 bits of guest=
_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by larg=
e
>  pages in the host.
>
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track o=
f
> +The flags field supports four flags
> +
> +1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>  writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know h=
ow to
> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allow=
s it,
> +use it.
> +2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability all=
ows it,
>  to make a new slot read-only.  In this case, writes to this memory will =
be
>  posted to userspace as KVM_EXIT_MMIO exits.
> +3.  KVM_MEM_GUEST_MEMFD

If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
KVM_SET_USER_MEMORY_REGION2 and explain that using
KVM_SET_USER_MEMORY_REGION with this flag will always fail.

> +4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
>
>  When the KVM_CAP_SYNC_MMU capability is available, changes in the backin=
g of
>  the memory region are automatically reflected into the guest.  For examp=
le, an
> @@ -8059,6 +8065,22 @@ error/annotated fault.
>
>  See KVM_EXIT_MEMORY_FAULT for more information.
>
> +7.35 KVM_CAP_EXIT_ON_MISSING
> +----------------------------
> +
> +:Architectures: None
> +:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> +
> +The presence of this capability indicates that userspace may set the
> +KVM_MEM_EXIT_ON_MISSING flag on memslots. Said flag will cause KVM_RUN t=
o fail
> +(-EFAULT) in response to guest-context memory accesses which would requi=
re KVM
> +to page fault on the userspace mapping.
> +
> +The range of guest physical memory causing the fault is advertised to us=
erspace
> +through KVM_CAP_MEMORY_FAULT_INFO. Userspace should take appropriate act=
ion.
> +This could mean, for instance, checking that the fault is resolvable, fa=
ulting
> +in the relevant userspace mapping, then retrying KVM_RUN.
> +
>  8. Other capabilities.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4e41ceed5468..13066a6fdfff 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1486,7 +1486,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         mmap_read_unlock(current->mm);
>
>         pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> -                                  write_fault, &writable, NULL);
> +                                  write_fault, &writable, false, NULL);
>         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 kvm_send_hwpoison_signal(hva, vma_shift);
>                 return 0;
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3=
s_64_mmu_hv.c
> index efd0ebf70a5e..2ce0e1d3f597 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -613,7 +613,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu=
,
>         } else {
>                 /* Call KVM generic code to do the slow-path check */
>                 pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, =
NULL,
> -                                          writing, &write_ok, NULL);
> +                                          writing, &write_ok, false, NUL=
L);
>                 if (is_error_noslot_pfn(pfn))
>                         return -EFAULT;
>                 page =3D NULL;
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/bo=
ok3s_64_mmu_radix.c
> index 572707858d65..9d40ca02747f 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -847,7 +847,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *v=
cpu,
>
>                 /* Call KVM generic code to do the slow-path check */
>                 pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, =
NULL,
> -                                          writing, upgrade_p, NULL);
> +                                          writing, upgrade_p, false, NUL=
L);
>                 if (is_error_noslot_pfn(pfn))
>                         return -EFAULT;
>                 page =3D NULL;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4de7670d5976..b1e5e42bdeb4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4375,7 +4375,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,=
 struct kvm_page_fault *fault
>         async =3D false;
>         fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, fals=
e, &async,
>                                           fault->write, &fault->map_writa=
ble,
> -                                         &fault->hva);
> +                                         false, &fault->hva);
>         if (!async)
>                 return RET_PF_CONTINUE; /* *pfn has correct page already =
*/
>
> @@ -4397,7 +4397,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,=
 struct kvm_page_fault *fault
>          */
>         fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, true=
, NULL,
>                                           fault->write, &fault->map_writa=
ble,
> -                                         &fault->hva);
> +                                         false, &fault->hva);
>         return RET_PF_CONTINUE;
>  }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5201400358da..e8e30088289e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1219,7 +1219,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memor=
y_slot *slot, gfn_t gfn);
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, =
gfn_t gfn);
>  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t=
 gfn,
>                                bool atomic, bool interruptible, bool *asy=
nc,
> -                              bool write_fault, bool *writable, hva_t *h=
va);
> +                              bool write_fault, bool *writable,
> +                              bool can_exit_on_missing, hva_t *hva);
>
>  void kvm_release_pfn_clean(kvm_pfn_t pfn);
>  void kvm_release_pfn_dirty(kvm_pfn_t pfn);
> @@ -2423,4 +2424,13 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm=
,
>  }
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>
> +/*
> + * Whether vCPUs should exit upon trying to access memory for which the
> + * userspace mappings are missing.
> + */
> +static inline bool kvm_is_slot_exit_on_missing(const struct kvm_memory_s=
lot *slot)
> +{
> +       return slot && slot->flags & KVM_MEM_EXIT_ON_MISSING;
> +}
> +
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index bda5622a9c68..18546cbada61 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -116,6 +116,7 @@ struct kvm_userspace_memory_region2 {
>  #define KVM_MEM_LOG_DIRTY_PAGES        (1UL << 0)
>  #define KVM_MEM_READONLY       (1UL << 1)
>  #define KVM_MEM_GUEST_MEMFD    (1UL << 2)
> +#define KVM_MEM_EXIT_ON_MISSING        (1UL << 3)
>
>  /* for KVM_IRQ_LINE */
>  struct kvm_irq_level {
> @@ -1231,6 +1232,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_MEMORY_ATTRIBUTES 233
>  #define KVM_CAP_GUEST_MEMFD 234
>  #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_EXIT_ON_MISSING 236
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 2c964586aa14..241f524a4e9d 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,3 +109,6 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config HAVE_KVM_EXIT_ON_MISSING
> +       bool
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 725191333c4e..faaccdba179c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1614,7 +1614,7 @@ static void kvm_replace_memslot(struct kvm *kvm,
>   * only allows these.
>   */
>  #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
> -       (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
> +       (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | KVM_MEM_EXIT_ON_MIS=
SING)
>
>  static int check_memory_region_flags(struct kvm *kvm,
>                                      const struct kvm_userspace_memory_re=
gion2 *mem)
> @@ -1632,6 +1632,9 @@ static int check_memory_region_flags(struct kvm *kv=
m,
>         valid_flags |=3D KVM_MEM_READONLY;
>  #endif
>
> +       if (IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING))
> +               valid_flags |=3D KVM_MEM_EXIT_ON_MISSING;
> +
>         if (mem->flags & ~valid_flags)
>                 return -EINVAL;
>
> @@ -3047,7 +3050,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomi=
c, bool interruptible,
>
>  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t=
 gfn,
>                                bool atomic, bool interruptible, bool *asy=
nc,
> -                              bool write_fault, bool *writable, hva_t *h=
va)
> +                              bool write_fault, bool *writable,
> +                              bool can_exit_on_missing, hva_t *hva)
>  {
>         unsigned long addr =3D __gfn_to_hva_many(slot, gfn, NULL, write_f=
ault);
>
> @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_me=
mory_slot *slot, gfn_t gfn,
>                 writable =3D NULL;
>         }
>
> +       if (!atomic && can_exit_on_missing
> +           && kvm_is_slot_exit_on_missing(slot)) {
> +               atomic =3D true;
> +               if (async) {
> +                       *async =3D false;
> +                       async =3D NULL;
> +               }
> +       }
> +

Perhaps we should have a comment for this? Maybe something like: "If
we want to exit-on-missing, we want to bail out if fast GUP fails, and
we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
this."

Thanks!


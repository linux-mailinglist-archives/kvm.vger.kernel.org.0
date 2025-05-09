Return-Path: <kvm+bounces-46090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0377BAB1DC4
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 22:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E7724C6BB6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 20:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5E925F973;
	Fri,  9 May 2025 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3FqXanVb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F1725F793
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 20:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821735; cv=none; b=I3Qh9peKSjaV3BdMlhRGuWbKMbMDQmxOWbjA04JAzYdEl3HCapwKKNghGQ46sRjkfn4Jbn4Odw6a8ayXZkBSV0uWc8GYq7PA7992/Qvs1kTueas/ZOVa2SF6Cw5JNlYutVhJo5qEr5TGS6dD+U80SbxE0kuZTgLUFukkz2nxa0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821735; c=relaxed/simple;
	bh=Kk29Z7S1e2MRqOBLYuuwr0aOMf7cUa7eKTndRlqtwU0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oQzQahT72ruPhPwCBi37Ht0h6fjhH2cVM0vBoAB8Kwa518/cbrJmhWeL8gTSL8G0tbIwzQHKdTL373KxZ03TpodWEj3NQK3wXIsiuwneQ6Pm6pKCECBwWaTXj26QxJ67JGsxRa6ZQgEtt4sPczuba8Ivtvtww127UbXjwl4uVPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3FqXanVb; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-52c46d73350so487742e0c.2
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 13:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746821732; x=1747426532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHvdZShxIAqV01CMuKaaMDNli6sM0ediw7/flXiQIUk=;
        b=3FqXanVbUygEsYsOINvYtGOO8E9nMhQE0gv7+prYexRYOTwPU5imOfJto9xWMS519K
         VLn/zPRpm66/K2EffyJ1SxnjNT1WqoJnlTKDPB/ZyU5r/01d0iRmNLZBBOIZNsRw08Dr
         agCndjJ7HqauY12oOsM0geJsFg/e7ZfT4Q9T/0BKjG+kfX3+r+h73WKJPJdZi6pkml8+
         Er9c4aqvmO4uqUETzZlPJjkJnANNo+G5Oy6vYDUXsF46YqH/nX+5QHM8CthlCUz6zbQI
         MQdhV0Q1OO7KxRRp9hP7afZbXjB94sCLHlh/poKNdblARauu8vFT/Qkbk5ol3jKKbKyg
         Hapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746821732; x=1747426532;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pHvdZShxIAqV01CMuKaaMDNli6sM0ediw7/flXiQIUk=;
        b=unpUmkWlM9TLcZSwH/qIdDP0juYZ1D7UT7mAJ3qFa5jgXeXJrkxitse9MUk5pR5tgh
         KhDB+tfOb+PTBf+/0/a66GzQE6Npe5RbHTrsWaT48T+/aJQjrEZb17uGSNw6574Smp6L
         QoNTnTS73GPGSudABDn7SLfhFSGXD8bMF/7DdwtuUL0vCjndQcn0Ose5YxGi3qYQtfYo
         3tkwSQEy+3uPu5ZkiaMZbsH6ANRQaFjtFotXqLdC30lGWQVqWsXuNoD/upN5XEsXtLwx
         UGEcuSScFe2PUFrYH38Vn2HKE1TmH/5NKySnNbBhxzKPiVv1LUzAHfqNLve5csJFYQWK
         r7Lw==
X-Forwarded-Encrypted: i=1; AJvYcCW67G09YSRCCFgMWsjFVz4yKLJbdsMC84zplKGrsAxDavV0sctmA9CkrskyArV2eabxWMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBQqtWqwvkDcRm5XrCeaQTov8mf2cWvkVCXGRDZaC06bSJbZbZ
	APmIxrBqo7cbM73k6QZJsoqaWp/g2fS8wZsLOzmGVbgdCnqjsEqmdY/J9qTSK8yVyvioZ6P5LG8
	eHGDmP97J57cXpQIZAQ==
X-Google-Smtp-Source: AGHT+IHmo4x8mnDm3HFwy0upkj1U9SngW/N6WYByA7P77kZB7LNS2lsdnOmKyvsZVF0zdVeuUjwRpStzTwy5SgVY
X-Received: from vkz1.prod.google.com ([2002:a05:6122:5301:b0:529:28c4:eb83])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:892:b0:51f:fc9d:875d with SMTP id 71dfb90a1353d-52c53d1dd24mr4307344e0c.8.1746821731709;
 Fri, 09 May 2025 13:15:31 -0700 (PDT)
Date: Fri,  9 May 2025 20:15:28 +0000
In-Reply-To: <20250430165655.605595-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-11-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509201529.3160064-1-jthoughton@google.com>
Subject: Re: [PATCH v8 10/13] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
From: James Houghton <jthoughton@google.com>
To: tabba@google.com
Cc: ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, 
	david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, 
	hughd@google.com, isaku.yamahata@gmail.com, isaku.yamahata@intel.com, 
	james.morse@arm.com, jarkko@kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	jthoughton@google.com, keirf@google.com, kirill.shutemov@linux.intel.com, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, rientjes@google.com, 
	roypat@amazon.co.uk, seanjc@google.com, shuah@kernel.org, 
	steven.price@arm.com, suzuki.poulose@arm.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Add arm64 support for handling guest page faults on guest_memfd
> backed memslots.
>
> For now, the fault granule is restricted to PAGE_SIZE.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> =C2=A0arch/arm64/kvm/mmu.c =C2=A0 =C2=A0 | 65 +++++++++++++++++++++++++++=
-------------
> =C2=A0include/linux/kvm_host.h | =C2=A05 ++++
> =C2=A0virt/kvm/kvm_main.c =C2=A0 =C2=A0 =C2=A0| =C2=A05 ----
> =C2=A03 files changed, 50 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 148a97c129de..d1044c7f78bb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1466,6 +1466,30 @@ static bool kvm_vma_mte_allowed(struct vm_area_str=
uct *vma)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return vma->vm_flags & VM_MTE_ALLOWED;
> =C2=A0}
>
> +static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *sl=
ot,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0gfn_t gfn, bool write_fault, bool *writable,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct page **page, bool is_gmem)
> +{
> + =C2=A0 =C2=A0 =C2=A0 kvm_pfn_t pfn;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!is_gmem)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return __kvm_faultin_p=
fn(slot, gfn, write_fault ? FOLL_WRITE : 0, writable, page);
> +
> + =C2=A0 =C2=A0 =C2=A0 *writable =3D false;
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, pag=
e, NULL);
> + =C2=A0 =C2=A0 =C2=A0 if (!ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *writable =3D !memslot=
_is_readonly(slot);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return pfn;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ret =3D=3D -EHWPOISON)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return KVM_PFN_ERR_HWP=
OISON;
> +
> + =C2=A0 =C2=A0 =C2=A0 return KVM_PFN_ERR_NOSLOT_MASK;
> +}
> +
> =C2=A0static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_=
ipa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct kvm_s2_trans *nested,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1473,19 +1497,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool write_fault, writable;
> - =C2=A0 =C2=A0 =C2=A0 bool exec_fault, mte_allowed;
> + =C2=A0 =C2=A0 =C2=A0 bool exec_fault, mte_allowed =3D false;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool device =3D false, vfio_allow_any_uc =3D =
false;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long mmu_seq;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 phys_addr_t ipa =3D fault_ipa;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm *kvm =3D vcpu->kvm;
> - =C2=A0 =C2=A0 =C2=A0 struct vm_area_struct *vma;
> + =C2=A0 =C2=A0 =C2=A0 struct vm_area_struct *vma =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 short vma_shift;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *memcache;
> - =C2=A0 =C2=A0 =C2=A0 gfn_t gfn;
> + =C2=A0 =C2=A0 =C2=A0 gfn_t gfn =3D ipa >> PAGE_SHIFT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_pfn_t pfn;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool logging_active =3D memslot_is_logging(me=
mslot);
> - =C2=A0 =C2=A0 =C2=A0 bool force_pte =3D logging_active || is_protected_=
kvm_enabled();
> - =C2=A0 =C2=A0 =C2=A0 long vma_pagesize, fault_granule;
> + =C2=A0 =C2=A0 =C2=A0 bool is_gmem =3D kvm_slot_has_gmem(memslot) && kvm=
_mem_from_gmem(kvm, gfn);
> + =C2=A0 =C2=A0 =C2=A0 bool force_pte =3D logging_active || is_gmem || is=
_protected_kvm_enabled();
> + =C2=A0 =C2=A0 =C2=A0 long vma_pagesize, fault_granule =3D PAGE_SIZE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PR=
OT_R;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm_pgtable *pgt;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct page *page;
> @@ -1522,16 +1547,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> + =C2=A0 =C2=A0 =C2=A0 mmap_read_lock(current->mm);

We don't have to take the mmap_lock for gmem faults, right?

I think we should reorganize user_mem_abort() a bit (and I think vma_pagesi=
ze
and maybe vma_shift should be renamed) given the changes we're making here.

Below is a diff that I think might be a little cleaner. Let me know what yo=
u
think.

> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Let's check if we will get back a hug=
e page backed by hugetlbfs, or
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* get block mapping for device MMIO reg=
ion.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 mmap_read_lock(current->mm);
> - =C2=A0 =C2=A0 =C2=A0 vma =3D vma_lookup(current->mm, hva);
> - =C2=A0 =C2=A0 =C2=A0 if (unlikely(!vma)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_err("Failed to fin=
d VMA for hva 0x%lx\n", hva);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmap_read_unlock(curre=
nt->mm);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 if (!is_gmem) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vma =3D vma_lookup(cur=
rent->mm, hva);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!vma)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 mmap_read_unlock(current->mm);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vfio_allow_any_uc =3D =
vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mte_allowed =3D kvm_vm=
a_mte_allowed(vma);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (force_pte)
> @@ -1602,18 +1633,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ipa &=3D ~(vma_pa=
gesize - 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> - =C2=A0 =C2=A0 =C2=A0 gfn =3D ipa >> PAGE_SHIFT;
> - =C2=A0 =C2=A0 =C2=A0 mte_allowed =3D kvm_vma_mte_allowed(vma);
> -
> - =C2=A0 =C2=A0 =C2=A0 vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY=
_UNCACHED;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Don't use the VMA after the unlock -- it m=
ay have vanished */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 vma =3D NULL;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Read mmu_invalidate_seq so that KVM c=
an detect if the results of
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* vma_lookup() or __kvm_faultin_pfn() become=
 stale prior to
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* acquiring kvm->mmu_lock.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* vma_lookup() or faultin_pfn() become stale=
 prior to acquiring
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* kvm->mmu_lock.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Rely on mmap_read_unlock() for an imp=
licit smp_rmb(), which pairs
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* with the smp_wmb() in kvm_mmu_invalid=
ate_end().
> @@ -1621,8 +1647,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmap_read_unlock(current->mm);
>
> - =C2=A0 =C2=A0 =C2=A0 pfn =3D __kvm_faultin_pfn(memslot, gfn, write_faul=
t ? FOLL_WRITE : 0,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &writable, &page);
> + =C2=A0 =C2=A0 =C2=A0 pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault=
, &writable, &page, is_gmem);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {

I think we need to take care to handle HWPOISON properly. I know that it is
(or will most likely be) the case that GUP(hva) --> pfn, but with gmem,
it *might* not be the case. So the following line isn't right.

I think we need to handle HWPOISON for gmem using memory fault exits instea=
d of
sending a SIGBUS to userspace. This would be consistent with how KVM/x86
today handles getting a HWPOISON page back from kvm_gmem_get_pfn(). I'm not
entirely sure how KVM/x86 is meant to handle HWPOISON on shared gmem pages =
yet;
I need to keep reading your series.

The reorganization diff below leaves this unfixed.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_send_hwpoison=
_signal(hva, vma_shift);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3af6bff3232..1b2e4e9a7802 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1882,6 +1882,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_=
t gfn)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return gfn_to_memslot(kvm, gfn)->id;
> =C2=A0}
>
> +static inline bool memslot_is_readonly(const struct kvm_memory_slot *slo=
t)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return slot->flags & KVM_MEM_READONLY;
> +}
> +
> =C2=A0static inline gfn_t
> =C2=A0hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
> =C2=A0{
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c75d8e188eb7..d9bca5ba19dc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2640,11 +2640,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *=
vcpu, gfn_t gfn)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return size;
> =C2=A0}
>
> -static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> -{
> - =C2=A0 =C2=A0 =C2=A0 return slot->flags & KVM_MEM_READONLY;
> -}
> -
> =C2=A0static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot=
 *slot, gfn_t gfn,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gfn_t *nr=
_pages, bool write)
> =C2=A0{
> --
> 2.49.0.901.g37484f566f-goog

Thanks, Fuad! Here's the reorganization/rename diff:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d1044c7f78bba..c9eb72fe9013b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1502,7 +1502,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	unsigned long mmu_seq;
 	phys_addr_t ipa =3D fault_ipa;
 	struct kvm *kvm =3D vcpu->kvm;
-	struct vm_area_struct *vma =3D NULL;
 	short vma_shift;
 	void *memcache;
 	gfn_t gfn =3D ipa >> PAGE_SHIFT;
@@ -1510,7 +1509,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	bool logging_active =3D memslot_is_logging(memslot);
 	bool is_gmem =3D kvm_slot_has_gmem(memslot) && kvm_mem_from_gmem(kvm, gfn=
);
 	bool force_pte =3D logging_active || is_gmem || is_protected_kvm_enabled(=
);
-	long vma_pagesize, fault_granule =3D PAGE_SIZE;
+	long target_size =3D PAGE_SIZE, fault_granule =3D PAGE_SIZE;
 	enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
@@ -1547,13 +1546,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
 			return ret;
 	}
=20
-	mmap_read_lock(current->mm);
-
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
 	if (!is_gmem) {
+		struct vm_area_struct *vma =3D NULL;
+
+		mmap_read_lock(current->mm);
+
 		vma =3D vma_lookup(current->mm, hva);
 		if (unlikely(!vma)) {
 			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
@@ -1563,38 +1564,45 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
=20
 		vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 		mte_allowed =3D kvm_vma_mte_allowed(vma);
-	}
-
-	if (force_pte)
-		vma_shift =3D PAGE_SHIFT;
-	else
-		vma_shift =3D get_vma_page_shift(vma, hva);
+		vma_shift =3D force_pte ? get_vma_page_shift(vma, hva) : PAGE_SHIFT;
=20
-	switch (vma_shift) {
+		switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-			break;
-		fallthrough;
+		case PUD_SHIFT:
+			if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+				break;
+			fallthrough;
 #endif
-	case CONT_PMD_SHIFT:
-		vma_shift =3D PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+		case CONT_PMD_SHIFT:
+			vma_shift =3D PMD_SHIFT;
+			fallthrough;
+		case PMD_SHIFT:
+			if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+				break;
+			fallthrough;
+		case CONT_PTE_SHIFT:
+			vma_shift =3D PAGE_SHIFT;
+			force_pte =3D true;
+			fallthrough;
+		case PAGE_SHIFT:
 			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
-		vma_shift =3D PAGE_SHIFT;
-		force_pte =3D true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
-	}
+		default:
+			WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
+		}
=20
-	vma_pagesize =3D 1UL << vma_shift;
+		/*
+		 * Read mmu_invalidate_seq so that KVM can detect if the results of
+		 * vma_lookup() or faultin_pfn() become stale prior to acquiring
+		 * kvm->mmu_lock.
+		 *
+		 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
+		 * with the smp_wmb() in kvm_mmu_invalidate_end().
+		 */
+		mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
+		mmap_read_unlock(current->mm);
+
+		target_size =3D 1UL << vma_shift;
+	}
=20
 	if (nested) {
 		unsigned long max_map_size;
@@ -1620,7 +1628,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 			max_map_size =3D PAGE_SIZE;
=20
 		force_pte =3D (max_map_size =3D=3D PAGE_SIZE);
-		vma_pagesize =3D min(vma_pagesize, (long)max_map_size);
+		target_size =3D min(target_size, (long)max_map_size);
 	}
=20
 	/*
@@ -1628,27 +1636,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
 	 * ensure we find the right PFN and lay down the mapping in the right
 	 * place.
 	 */
-	if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SIZE) {
-		fault_ipa &=3D ~(vma_pagesize - 1);
-		ipa &=3D ~(vma_pagesize - 1);
+	if (target_size =3D=3D PMD_SIZE || target_size =3D=3D PUD_SIZE) {
+		fault_ipa &=3D ~(target_size - 1);
+		ipa &=3D ~(target_size - 1);
 	}
=20
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma =3D NULL;
-
-	/*
-	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or faultin_pfn() become stale prior to acquiring
-	 * kvm->mmu_lock.
-	 *
-	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
-	 * with the smp_wmb() in kvm_mmu_invalidate_end().
-	 */
-	mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
-	mmap_read_unlock(current->mm);
-
 	pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_=
gmem);
 	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
+		// TODO: Handle gmem properly. vma_shift
+		// intentionally left uninitialized.
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
@@ -1658,9 +1654,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	if (kvm_is_device_pfn(pfn)) {
 		/*
 		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
+		 * the VMA flags, target_size is already representing the
 		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+		 * via __kvm_faultin_pfn(), target_size is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1699,7 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
=20
 	kvm_fault_lock(kvm);
 	pgt =3D vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	if (!is_gmem && mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret =3D -EAGAIN;
 		goto out_unlock;
 	}
@@ -1708,16 +1704,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize =3D=3D PAGE_SIZE && !(force_pte || device)) {
+	if (target_size =3D=3D PAGE_SIZE && !(force_pte || device)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
-			vma_pagesize =3D fault_granule;
-		else
-			vma_pagesize =3D transparent_hugepage_adjust(kvm, memslot,
+			target_size =3D fault_granule;
+		else if (!is_gmem)
+			target_size =3D transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
=20
-		if (vma_pagesize < 0) {
-			ret =3D vma_pagesize;
+		if (target_size < 0) {
+			ret =3D target_size;
 			goto out_unlock;
 		}
 	}
@@ -1725,7 +1721,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
-			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+			sanitise_mte_tags(kvm, pfn, target_size);
 		} else {
 			ret =3D -EFAULT;
 			goto out_unlock;
@@ -1750,10 +1746,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
=20
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
+	 * permissions only if target_size equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_is_perm && vma_pagesize =3D=3D fault_granule) {
+	if (fault_is_perm && target_size =3D=3D fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1761,7 +1757,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 		prot &=3D ~KVM_NV_GUEST_MAP_SZ;
 		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot,=
 flags);
 	} else {
-		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
+		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, target_size,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, flags);
 	}


Return-Path: <kvm+bounces-46546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F520AB77ED
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD02E4C67CC
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198D729673C;
	Wed, 14 May 2025 21:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="znc3Tym8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B7218DB2F
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258018; cv=none; b=QZ2kHEYhOeeuRzAMxnW4ZUglr25ZSYc1lxewJrHhGmkX9oAy4WvHum7c+zjvhLQtCbZB1nXBs00aCXn0wlwQhHCfWOCqdo1Fbz0z9w3W3DGZzLwIMfegXcuVg10qAcVrlTZ4Y96vYzn8nmqd1LQCDenQOEOUTscVhl229mWDZ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258018; c=relaxed/simple;
	bh=CCz8eyJjvmhwum4/6RvX3V//sfubVdRUUatbiZQ44ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKe6mwbflqQwHZP8g27ciMIfBmggn8oydqq8IGkjpDvzubuI7VBJki66kTgZCuSjtKg6BHRWrMgsDdiraqjXS7a8cJi/zsAPGTYST+lesUzualYZq0MIippXDBmc9/AxTk6QxA/krTblF+d4WoeqTk51PI1YVWIs/b3z3PMgElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=znc3Tym8; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-87003ab0511so50509241.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747258014; x=1747862814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQhHQJb7v4lI1G9NW2xdZGalzNE/IBQFZAhE95tIzZg=;
        b=znc3Tym8gRMG6/UmNt0Dqtr8p15NIcZInp1RbibkmsurrMBao9mLwuF53Uh618IgNl
         N5spHQQmqVE0YS3+SlgMMTcE21Y+o+bnlg8huoGp+Z2Y8nyUV26xNYMTjIJsWQ22j1/0
         EsCoJganh6vJ6dA/PFLCqERUiTak2bIy6UKGbOmApDMweMgcoFdd3iykngBdV/8Zoz8Q
         aS7DzfkFj96jSrBlH0xEs+AsSSZZz/EsSGrgHuLFQvOKMvxGOhfIDF0PnaAHjvBTQ6BY
         5aUq/lZCjfVnAc8RUZ0ffhannvPZrHm+DuDZV4RHicuXEN0V3RiLfxtHW6SgcmjpDHdK
         FKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747258014; x=1747862814;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tQhHQJb7v4lI1G9NW2xdZGalzNE/IBQFZAhE95tIzZg=;
        b=MX0vFSI2Zd7ZVZdFmzVrEcoqIm6+IO+KtWNzyXTF7QCyjecJZ0eDBgtPLTSX59SpFA
         om4JmQUxcjrur1pGy7Xap2KJuSRRqjskH2SUntDXshQ5aUjGPNUEidCk+uyyv+6OOVtA
         lvMo8QKxZYhsbCm2FxRDr2J5mMThkJGbSzvm5a6VcaFu9U2oo8S8jpG3EM/zoopW+3cK
         uqkC4PZnYVgZoQ4fCpMcPyeqbtZHzBWJjexHDPVnH0jEhGDzuvQdsiivCPo5aMmvMDCe
         dmN47GEzGk3MlyEEnBTOe5QZj2ZzDYfrumLhbVIUoepl1kvQlm6dUe/ipeHWc0uKSRI/
         7Neg==
X-Forwarded-Encrypted: i=1; AJvYcCUHv0oRW/b0g+T79LNiAEyFUAolls/1uda7u5HlFnYBOEHw3p7xHgULDv5l42kqUJFLSLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJbLnRzFvq5JaqTrFuSncdupFdfVuiBymTzhKNUPtrujBVyCRJ
	tt5pzyM+A+wp+WhSvnTljKipJHWK6FeamGSrWApTBQSul9AKePNyAeQoat841umCFCwUG/3Gbgu
	h4iJSnCp01FX9E9jhcQ==
X-Google-Smtp-Source: AGHT+IFB9tyyu+c7Dt10GfaIsPKvoJ58O1BKGcP/ygQyI/GAX+2pXeX8t9b/mlwY7WN69tKSZcRwYmB5Av8WCxe9
X-Received: from uabje31.prod.google.com ([2002:a05:6130:681f:b0:877:a5c8:f3c8])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3e0c:b0:4df:84d5:543e with SMTP id ada2fe7eead31-4df9541ae27mr65557137.7.1747258014077;
 Wed, 14 May 2025 14:26:54 -0700 (PDT)
Date: Wed, 14 May 2025 21:26:52 +0000
In-Reply-To: <20250513163438.3942405-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-14-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250514212653.1011484-1-jthoughton@google.com>
Subject: Re: [PATCH v9 13/17] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
From: James Houghton <jthoughton@google.com>
To: tabba@google.com
Cc: ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, 
	david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@gmail.com, 
	isaku.yamahata@intel.com, james.morse@arm.com, jarkko@kernel.org, 
	jgg@nvidia.com, jhubbard@nvidia.com, jthoughton@google.com, keirf@google.com, 
	kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, liam.merwick@oracle.com, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, mail@maciej.szmigiero.name, 
	maz@kernel.org, mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
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

On Tue, May 13, 2025 at 9:35=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Add arm64 support for handling guest page faults on guest_memfd
> backed memslots.
>
> For now, the fault granule is restricted to PAGE_SIZE.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> =C2=A0arch/arm64/kvm/mmu.c =C2=A0 =C2=A0 | 94 +++++++++++++++++++++++++--=
-------------
> =C2=A0include/linux/kvm_host.h | =C2=A05 +++
> =C2=A0virt/kvm/kvm_main.c =C2=A0 =C2=A0 =C2=A0| =C2=A05 ---
> =C2=A03 files changed, 64 insertions(+), 40 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d756c2b5913f..9a48ef08491d 100644
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

I don't think the above handling for the `ret !=3D 0` case is correct. I th=
ink
we should just be returning `ret` out to userspace.

The diff I have below is closer to what I think we must do.

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
> - =C2=A0 =C2=A0 =C2=A0 short page_shift;
> + =C2=A0 =C2=A0 =C2=A0 struct vm_area_struct *vma =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 short page_shift =3D PAGE_SHIFT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *memcache;
> - =C2=A0 =C2=A0 =C2=A0 gfn_t gfn;
> + =C2=A0 =C2=A0 =C2=A0 gfn_t gfn =3D ipa >> PAGE_SHIFT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_pfn_t pfn;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool logging_active =3D memslot_is_logging(me=
mslot);
> - =C2=A0 =C2=A0 =C2=A0 bool force_pte =3D logging_active || is_protected_=
kvm_enabled();
> - =C2=A0 =C2=A0 =C2=A0 long page_size, fault_granule;
> + =C2=A0 =C2=A0 =C2=A0 bool is_gmem =3D kvm_slot_has_gmem(memslot);
> + =C2=A0 =C2=A0 =C2=A0 bool force_pte =3D logging_active || is_gmem || is=
_protected_kvm_enabled();
> + =C2=A0 =C2=A0 =C2=A0 long page_size, fault_granule =3D PAGE_SIZE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PR=
OT_R;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm_pgtable *pgt;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct page *page;
> @@ -1529,17 +1554,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
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
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmap_read_lock(current=
->mm);
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
> - =C2=A0 =C2=A0 =C2=A0 if (force_pte)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_shift =3D PAGE_SH=
IFT;
> - =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 if (!force_pte)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_shift =3D ge=
t_vma_page_shift(vma, hva);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (page_shift) {
> @@ -1605,27 +1633,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ipa &=3D ~(page_s=
ize - 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> - =C2=A0 =C2=A0 =C2=A0 gfn =3D ipa >> PAGE_SHIFT;
> - =C2=A0 =C2=A0 =C2=A0 mte_allowed =3D kvm_vma_mte_allowed(vma);
> -
> - =C2=A0 =C2=A0 =C2=A0 vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY=
_UNCACHED;
> -
> - =C2=A0 =C2=A0 =C2=A0 /* Don't use the VMA after the unlock -- it may ha=
ve vanished */
> - =C2=A0 =C2=A0 =C2=A0 vma =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 if (!is_gmem) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Don't use the VMA a=
fter the unlock -- it may have vanished */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vma =3D NULL;

I think we can just move the vma declaration inside the earlier `if (is_gme=
m)`
bit above. It should be really hard to accidentally attempt to use `vma` or
`hva` in the is_gmem case. `vma` we can easily make it impossible; `hva` is
harder.

See below for what I think this should look like.

>
> - =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* Read mmu_invalidate_seq so that KVM can de=
tect if the results of
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* vma_lookup() or __kvm_faultin_pfn() become=
 stale prior to
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* acquiring kvm->mmu_lock.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* Rely on mmap_read_unlock() for an implicit=
 smp_rmb(), which pairs
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* with the smp_wmb() in kvm_mmu_invalidate_e=
nd().
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> - =C2=A0 =C2=A0 =C2=A0 mmap_read_unlock(current->mm);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Read mmu_inval=
idate_seq so that KVM can detect if the results
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* of vma_lookup(=
) or faultin_pfn() become stale prior to
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* acquiring kvm-=
>mmu_lock.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Rely on mmap_r=
ead_unlock() for an implicit smp_rmb(), which
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* pairs with the=
 smp_wmb() in kvm_mmu_invalidate_end().
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmu_seq =3D vcpu->kvm-=
>mmu_invalidate_seq;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mmap_read_unlock(curre=
nt->mm);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> - =C2=A0 =C2=A0 =C2=A0 pfn =3D __kvm_faultin_pfn(memslot, gfn, write_faul=
t ? FOLL_WRITE : 0,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &writable, &page);
> + =C2=A0 =C2=A0 =C2=A0 pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault=
, &writable, &page, is_gmem);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_send_hwpoison=
_signal(hva, page_shift);

`hva` is used here even for the is_gmem case, and that should be slightly
concerning. And indeed it is, this is not the appropriate way to handle
hwpoison for gmem (and it is different than the behavior you have for x86).=
 x86
handles this by returning a KVM_MEMORY_FAULT_EXIT to userspace; we should d=
o
the same.

I've put what I think is more appropriate in the diff below.

And just to be clear, IMO, we *cannot* do what you have written now, especi=
ally
given that we are getting rid of the userspace_addr sanity check (but that
check was best-effort anyway).

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> @@ -1677,7 +1701,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_fault_lock(kvm);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 pgt =3D vcpu->arch.hw_mmu->pgt;
> - =C2=A0 =C2=A0 =C2=A0 if (mmu_invalidate_retry(kvm, mmu_seq)) {
> + =C2=A0 =C2=A0 =C2=A0 if (!is_gmem && mmu_invalidate_retry(kvm, mmu_seq)=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -EAGAIN;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f9bb025327c3..b317392453a5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1884,6 +1884,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_=
t gfn)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return gfn_to_memslot(kvm, gfn)->id;
> =C2=A0}
>
> +static inline bool memslot_is_readonly(const struct kvm_memory_slot *slo=
t)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return slot->flags & KVM_MEM_READONLY;
> +}

I think if you're going to move this helper to include/linux/kvm_host.h, yo=
u
might want to do so in its own patch and change all of the existing places
where we check KVM_MEM_READONLY directly. *shrug*

> +
> =C2=A0static inline gfn_t
> =C2=A0hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
> =C2=A0{
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6289ea1685dd..6261d8638cd2 100644
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
> 2.49.0.1045.g170613ef41-goog
>

Alright, here's the diff I have in mind:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9a48ef08491db..74eae19792373 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,28 +1466,30 @@ static bool kvm_vma_mte_allowed(struct vm_area_stru=
ct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
=20
-static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *slot=
,
-			     gfn_t gfn, bool write_fault, bool *writable,
-			     struct page **page, bool is_gmem)
+static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     bool exec_fault, bool write_fault, bool *writable,
+			     struct page **page, bool is_gmem, kvm_pfn_t *pfn)
 {
-	kvm_pfn_t pfn;
 	int ret;
=20
-	if (!is_gmem)
-		return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writab=
le, page);
+	if (!is_gmem) {
+		*pfn =3D __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writ=
able, page);
+		return 0;
+	}
=20
 	*writable =3D false;
=20
-	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
-	if (!ret) {
-		*writable =3D !memslot_is_readonly(slot);
-		return pfn;
+	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, pfn, page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
+					      PAGE_SIZE, write_fault,
+					      exec_fault, false);
+		return ret;
 	}
=20
-	if (ret =3D=3D -EHWPOISON)
-		return KVM_PFN_ERR_HWPOISON;
-
-	return KVM_PFN_ERR_NOSLOT_MASK;
+	*writable =3D !memslot_is_readonly(slot);
+	return 0;
 }
=20
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1502,7 +1504,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	unsigned long mmu_seq;
 	phys_addr_t ipa =3D fault_ipa;
 	struct kvm *kvm =3D vcpu->kvm;
-	struct vm_area_struct *vma =3D NULL;
 	short page_shift =3D PAGE_SHIFT;
 	void *memcache;
 	gfn_t gfn =3D ipa >> PAGE_SHIFT;
@@ -1555,6 +1556,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	 * get block mapping for device MMIO region.
 	 */
 	if (!is_gmem) {
+		struct vm_area_struct *vma =3D NULL;
+
 		mmap_read_lock(current->mm);
 		vma =3D vma_lookup(current->mm, hva);
 		if (unlikely(!vma)) {
@@ -1565,33 +1568,44 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
=20
 		vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 		mte_allowed =3D kvm_vma_mte_allowed(vma);
-	}
=20
-	if (!force_pte)
-		page_shift =3D get_vma_page_shift(vma, hva);
+		if (!force_pte)
+			page_shift =3D get_vma_page_shift(vma, hva);
+
+		/*
+		 * Read mmu_invalidate_seq so that KVM can detect if the results
+		 * of vma_lookup() or faultin_pfn() become stale prior to
+		 * acquiring kvm->mmu_lock.
+		 *
+		 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which
+		 * pairs with the smp_wmb() in kvm_mmu_invalidate_end().
+		 */
+		mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
+		mmap_read_unlock(current->mm);
=20
-	switch (page_shift) {
+		switch (page_shift) {
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
-		page_shift =3D PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+		case CONT_PMD_SHIFT:
+			page_shift =3D PMD_SHIFT;
+			fallthrough;
+		case PMD_SHIFT:
+			if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+				break;
+			fallthrough;
+		case CONT_PTE_SHIFT:
+			page_shift =3D PAGE_SHIFT;
+			force_pte =3D true;
+			fallthrough;
+		case PAGE_SHIFT:
 			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
-		page_shift =3D PAGE_SHIFT;
-		force_pte =3D true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown page_shift %d", page_shift);
+		default:
+			WARN_ONCE(1, "Unknown page_shift %d", page_shift);
+		}
 	}
=20
 	page_size =3D 1UL << page_shift;
@@ -1633,24 +1647,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
 		ipa &=3D ~(page_size - 1);
 	}
=20
-	if (!is_gmem) {
-		/* Don't use the VMA after the unlock -- it may have vanished */
-		vma =3D NULL;
-
+	ret =3D faultin_pfn(kvm, vcpu, memslot, gfn, exec_fault, write_fault,
+			  &writable, &page, is_gmem, &pfn);
+	if (ret)
+		return ret;
+	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		/*
-		 * Read mmu_invalidate_seq so that KVM can detect if the results
-		 * of vma_lookup() or faultin_pfn() become stale prior to
-		 * acquiring kvm->mmu_lock.
-		 *
-		 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which
-		 * pairs with the smp_wmb() in kvm_mmu_invalidate_end().
+		 * For gmem, hwpoison should be communicated via a memory fault
+		 * exit, not via a SIGBUS.
 		 */
-		mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
-		mmap_read_unlock(current->mm);
-	}
-
-	pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_=
gmem);
-	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
+		WARN_ON_ONCE(is_gmem);
 		kvm_send_hwpoison_signal(hva, page_shift);
 		return 0;
 	}


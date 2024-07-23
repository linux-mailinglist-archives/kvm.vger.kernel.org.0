Return-Path: <kvm+bounces-22130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA3F93A7EC
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 21:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A29CF1C22FC6
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB4C1482EE;
	Tue, 23 Jul 2024 19:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRUA/eY5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5131482E8
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721764613; cv=none; b=avRMJ51P0mDE3AcgCpaseC+xu+gMeEOZSm7c1ROUbd+Q2H+GEK5yNeHFzZyd6oKho1rg0dWA/EAvYJ/z7gtHWrLGf5/8Mry6kVdR/3x9xpCgM+JbX6Ka7Gmou147Du6sHCqbJzIe150YgghKBoXyZJGpoKULObLYmKsSgkO7Hmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721764613; c=relaxed/simple;
	bh=w1yiFjHCdqLJJArQszIJSGLgVCFAk20EVpIzc9McI/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3I8kqUqcJWXK0PQNnOcouKlwE0fTdek/h1pa59vKE4ppEYLd0RPXK7rT2xN4hJCbGw7OuefHQDr5ijjrDsjVXgGZtgwjwHHlq6AlupjDXsYg9fqv2SJoq9Q7/JdkTcIJFStezWiOXsfC00C6ylEx5CjtpwPzfUwJEOe2GZCx4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRUA/eY5; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e04196b7603so5443845276.0
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 12:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721764610; x=1722369410; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ8gVf5B0wPtEoet4zm24rxnx8GgSxUPU5gw6kjX2ns=;
        b=nRUA/eY5cbBr+AFy7FQKi6I/p1dSmogE6vI3BGtScaD5NgwrM/XSmfx0yWoufZiKZj
         SXUteZeuuB8ZsnUuyw6c6Hhll4i1C0ehrcmtl9k5wQVIYdAadNZm4w0AVDIl2NoMItB9
         XjZrCuJ703/hKr4MhJsrm8mT1D84VVUuZKrOGoMxk0Ue7WmhAgpViiR2S4bW0yO3YcQ+
         f/Vm1+BmRr4ubacCXDb0rNTTyKnh8znMKAmQs5GFsR0VsWKXkx7aWBhp6mZLu9U/8fGg
         jwJKQItzxKEoof5GuZRGQkQ+oEulHZPeYjsZ6oNRc8fkt+P5XvcoBNixpQBlew8i2ixy
         UWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721764610; x=1722369410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQ8gVf5B0wPtEoet4zm24rxnx8GgSxUPU5gw6kjX2ns=;
        b=Vt8MP9aOuRaeCS3i54MWI2jHvbRkOsadOwlDXFJ+OBlUzPs87VZPEj3VujTeQ7vjGh
         1y08wob8iDato1RIMSIhYcRq0404zGPHARGnW/wSXJipR9ZfKRL1mw2dK1/Vj6/k4gj7
         94FIykQsr6lrjOyhULNbNoa2KR1C7x9IeaPGcvsaHcid79DERYFl55EpMHmu9N0zJciB
         M/6Jf9lRO7ScHVoDzHKbPsSESTGCdQ/XDZ44vXBBCACNuFP7SIdbuCieeSJVPpvQZBbz
         ovAvNQHJ2/TO7/kI6kDb3tFMvktfP+lC9Duj0/2BALdeqi8Px+bt0d/jPYYPh7Z83mCl
         t1VA==
X-Forwarded-Encrypted: i=1; AJvYcCX4iWiM7hH1rcla0J4w7Bu2omdSxaBnLq93GH3RexbM0o0xe286mth3wjxs37Ll3m114Uu5CuBSaoTAO6rC2P6aOtSz
X-Gm-Message-State: AOJu0YwJJKRtHNPk6thSUNpnqS7SFNqpHM+Z3cDYtlbDl+F0PnTxB2fb
	6gBT3elLGr4ffVFqESt5OvsNXaeuzULsRFM2g15Bv8gXJZHJpn7/FLOySD6S5hWtLRnPJGqb4g1
	Ip3OytCmY7zT1D+cjtWb1wsK1BjHfYUTcriqs
X-Google-Smtp-Source: AGHT+IGDERizmWaRZSYrEeosGY/RVvaTx8fAfVuWpYPQS52G6odr3z9alx6euwKiIoGuRdU+jKSkuTTpA0Br5WZBQTo=
X-Received: by 2002:a05:6902:a07:b0:e05:ae3f:7ae8 with SMTP id
 3f1490d57ef6-e087b9e574emr13923095276.52.1721764610048; Tue, 23 Jul 2024
 12:56:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com> <20231212204647.2170650-2-sagis@google.com>
 <797bfae3-6419-4a7a-991a-1d203691d2cb@intel.com>
In-Reply-To: <797bfae3-6419-4a7a-991a-1d203691d2cb@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 23 Jul 2024 14:56:39 -0500
Message-ID: <CAAhR5DGQDWdzizHHmG9yEQej0i5Ovn=RaXF_QkpdFT6Vragnww@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/29] KVM: selftests: Add function to allow
 one-to-one GVA to GPA mappings
To: "Zhang, Dongsheng X" <dongsheng.x.zhang@intel.com>
Cc: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Roger Wang <runanwang@google.com>, 
	Vipin Sharma <vipinsh@google.com>, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 5:29=E2=80=AFPM Zhang, Dongsheng X
<dongsheng.x.zhang@intel.com> wrote:
>
>
>
> On 12/12/2023 12:46 PM, Sagi Shahar wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > One-to-one GVA to GPA mappings can be used in the guest to set up boot
> > sequences during which paging is enabled, hence requiring a transition
> > from using physical to virtual addresses in consecutive instructions.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ryan Afranji <afranji@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  2 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 63 ++++++++++++++++---
> >  2 files changed, 55 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tool=
s/testing/selftests/kvm/include/kvm_util_base.h
> > index 1426e88ebdc7..c2e5c5f25dfc 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -564,6 +564,8 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t=
 sz, vm_vaddr_t vaddr_min);
> >  vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t v=
addr_min,
> >                           enum kvm_mem_region_type type);
> >  vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vadd=
r_t vaddr_min);
> > +vm_vaddr_t vm_vaddr_alloc_1to1(struct kvm_vm *vm, size_t sz,
> > +                            vm_vaddr_t vaddr_min, uint32_t data_memslo=
t);
> >  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> >  vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
> >                                enum kvm_mem_region_type type);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing=
/selftests/kvm/lib/kvm_util.c
> > index febc63d7a46b..4f1ae0f1eef0 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1388,17 +1388,37 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *v=
m, size_t sz,
> >       return pgidx_start * vm->page_size;
> >  }
> >
> > +/*
> > + * VM Virtual Address Allocate Shared/Encrypted
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   sz - Size in bytes
> > + *   vaddr_min - Minimum starting virtual address
> > + *   paddr_min - Minimum starting physical address
> > + *   data_memslot - memslot number to allocate in
> > + *   encrypt - Whether the region should be handled as encrypted
> > + *
> > + * Output Args: None
> > + *
> > + * Return:
> > + *   Starting guest virtual address
> > + *
> > + * Allocates at least sz bytes within the virtual address space of the=
 vm
> > + * given by vm.  The allocated bytes are mapped to a virtual address >=
=3D
> > + * the address given by vaddr_min.  Note that each allocation uses a
> > + * a unique set of pages, with the minimum real allocation being at le=
ast
> > + * a page.
> > + */
> >  static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
> > -                                  vm_vaddr_t vaddr_min,
> > -                                  enum kvm_mem_region_type type,
> > -                                  bool encrypt)
> > +                                  vm_vaddr_t vaddr_min, vm_paddr_t pad=
dr_min,
> > +                                  uint32_t data_memslot, bool encrypt)
> >  {
> >       uint64_t pages =3D (sz >> vm->page_shift) + ((sz % vm->page_size)=
 !=3D 0);
> >
> >       virt_pgd_alloc(vm);
> > -     vm_paddr_t paddr =3D _vm_phy_pages_alloc(vm, pages,
> > -                                           KVM_UTIL_MIN_PFN * vm->page=
_size,
> > -                                           vm->memslots[type], encrypt=
);
> > +     vm_paddr_t paddr =3D _vm_phy_pages_alloc(vm, pages, paddr_min,
> > +                                            data_memslot, encrypt);
> >
> >       /*
> >        * Find an unused range of virtual page addresses of at least
> > @@ -1408,8 +1428,7 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_v=
m *vm, size_t sz,
> >
> >       /* Map the virtual pages. */
> >       for (vm_vaddr_t vaddr =3D vaddr_start; pages > 0;
> > -             pages--, vaddr +=3D vm->page_size, paddr +=3D vm->page_si=
ze) {
> > -
> > +          pages--, vaddr +=3D vm->page_size, paddr +=3D vm->page_size)=
 {
> >               virt_pg_map(vm, vaddr, paddr);
> >
> >               sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift)=
;
> > @@ -1421,12 +1440,16 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm=
_vm *vm, size_t sz,
> >  vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t v=
addr_min,
> >                           enum kvm_mem_region_type type)
> >  {
> > -     return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, vm->protected)=
;
> > +     return ____vm_vaddr_alloc(vm, sz, vaddr_min,
> > +                               KVM_UTIL_MIN_PFN * vm->page_size,
> > +                               vm->memslots[type], vm->protected);
> >  }
> >
> >  vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vadd=
r_t vaddr_min)
> >  {
> > -     return ____vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA=
, false);
> > +     return ____vm_vaddr_alloc(vm, sz, vaddr_min,
> > +                               KVM_UTIL_MIN_PFN * vm->page_size,
> > +                               vm->memslots[MEM_REGION_TEST_DATA], fal=
se);
> >  }
> >
> >  /*
> > @@ -1453,6 +1476,26 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, siz=
e_t sz, vm_vaddr_t vaddr_min)
> >       return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
> >  }
> >
> > +/**
> > + * Allocate memory in @vm of size @sz in memslot with id @data_memslot=
,
> > + * beginning with the desired address of @vaddr_min.
> > + *
> > + * If there isn't enough memory at @vaddr_min, find the next possible =
address
> > + * that can meet the requested size in the given memslot.
> > + *
> > + * Return the address where the memory is allocated.
> > + */
> > +vm_vaddr_t vm_vaddr_alloc_1to1(struct kvm_vm *vm, size_t sz,
> > +                            vm_vaddr_t vaddr_min, uint32_t data_memslo=
t)
> > +{
> > +     vm_vaddr_t gva =3D ____vm_vaddr_alloc(vm, sz, vaddr_min,
> > +                                         (vm_paddr_t)vaddr_min, data_m=
emslot,
> > +                                         vm->protected);
> > +     TEST_ASSERT_EQ(gva, addr_gva2gpa(vm, gva));
>
> By 1to1, do you mean virtual address=3Dphysical address?, community tends=
 to call this identity mapping.
> Examples (function name):
> create_identity_mapping_pagetables()
> hellcreek_setup_tc_identity_mapping()
> identity_mapping_add()

Thanks for the input. Will switch to vm_vaddr_identity_alloc()
>
> > +
> > +     return gva;
> > +}
> > +
> >  /*
> >   * VM Virtual Address Allocate Pages
> >   *
>


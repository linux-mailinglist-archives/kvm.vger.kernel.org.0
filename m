Return-Path: <kvm+bounces-61005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8C3C05786
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CB79735AF26
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 10:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F9A230E0D2;
	Fri, 24 Oct 2025 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkDYfGaP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16BC2FE047
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761300218; cv=none; b=Rf1YTIX/Btfst96KmmizS3e2E0kC/uXis5Fb3T9tEAZ6PfuifKcyny+QZKmYAV1GC/qps8XRqWJjTW5PFMb6yXBTT60l9wYFC30yRPPt/GPUDT1eKm950bOdU7wgbZ08oD4G6QWOinjc1EaVzPopQM45CfEMxrmVYdD4MnKepu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761300218; c=relaxed/simple;
	bh=OvBlFaevsT1aA4REwFPwyDUpfGwB/p8ycFjHvvBC4PM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJmoWi9uVfyiIsOV50dCp12sImlbcngIFDYkSXBzEQClQD8GRhunmCY+lWap4ohQLbc7NGv7p5AeVoYs8egaJT+RvNPziphYvzN2XVqaJdbzLkM+uFwXZsaVOoAFFD2wA7fvuR/wqcx3Zz1kmBJBgTdwrpa6n0eyY9/U9jwA0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkDYfGaP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57486C113D0
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 10:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761300218;
	bh=OvBlFaevsT1aA4REwFPwyDUpfGwB/p8ycFjHvvBC4PM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UkDYfGaPl3QeT3lzukEEpYg3j7WqD67FkrFiw0qXNJ1OngbZ0ue7Z+oth7PF4a19e
	 6c4wW6rYWMOO3kGSqHqjs0gf2mZW3mpXB+go1zxx94lOAEG4QTcPJfgMqvwsgPaIdK
	 BGuApr7nzn9bW0K8lCpMUfc/MJQgyd8waGbSQlnbRLbpClBx+pBGPF2EJATb4y4zo2
	 5jJ3gXFhhuOnedfLTooQbJGt/cSwqO6xnxDjcnwBlBLjjt8yGJJNIvTqzknmd/Bi1h
	 5GPkIuPtWR7tRkNzHlBzI01FFlc8TU3KeX1lEFwfumePMr6CCvr55zSZdhFui7G3QY
	 Xpx0E3GuJ4KJA==
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ece1102998so1247806f8f.2
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 03:03:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUjh22wnJICRSIxERLq1dOVLjKayNHGZEQHmpXJJJ8G3NfPjXbc/oo2FLUJ87h5eB6P1MI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya4xOHHGUZ0VYgFd31QaXW1ndXzIcnf7524bNpUX3ojCzzKdsO
	o+AB0fB5AdAt9JtgZ8iJSuBoI829adgmg0exnZ69nRie4AQj9QfDlPESNJqKHiB3lDGKx+py9od
	UY5pSvwYvvbQfYDnBueLonU0E5gmBOnI=
X-Google-Smtp-Source: AGHT+IHLVMglfM02a482Z0S013OS339/r6JWMeLQ6qF2S7OgbygGhNbTGwvWCNz8euYcwQmbbn1WPiA92/Bwgk0PmhM=
X-Received: by 2002:a5d:5f93:0:b0:427:4b0:b3f9 with SMTP id
 ffacd0b85a97d-4298a04071bmr4218935f8f.3.1761300216861; Fri, 24 Oct 2025
 03:03:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
 <CAJF2gTRwHJsA7jFvAXbqy-6LyfaVTqfsFXgHfAeOZ8M3JNsikg@mail.gmail.com> <CAAhSdy1j4HZ86V6VsSF80LuNoxB3L3fmYYtvT7LU93fhbgCuug@mail.gmail.com>
In-Reply-To: <CAAhSdy1j4HZ86V6VsSF80LuNoxB3L3fmYYtvT7LU93fhbgCuug@mail.gmail.com>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 24 Oct 2025 03:03:23 -0700
X-Gmail-Original-Message-ID: <CAJF2gTS-qZDgxsqxr7OjZijwxc4GY2MKCabMbE3wvtzx0TDixQ@mail.gmail.com>
X-Gm-Features: AWmQ_blhM55OVCZL-ZLmRVyNahAkanXv0XqjK7NIOuPTDZ21CIGaNvU6roof5hI
Message-ID: <CAJF2gTS-qZDgxsqxr7OjZijwxc4GY2MKCabMbE3wvtzx0TDixQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: Anup Patel <anup@brainfault.org>
Cc: fangyu.yu@linux.alibaba.com, atish.patra@linux.dev, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, pbonzini@redhat.com, 
	jiangyifei@huawei.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, jgg@nvidia.com, 
	alex.williamson@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 12:32=E2=80=AFAM Anup Patel <anup@brainfault.org> w=
rote:
>
> On Tue, Oct 21, 2025 at 8:58=E2=80=AFPM Guo Ren <guoren@kernel.org> wrote=
:
> >
> > On Mon, Oct 20, 2025 at 6:08=E2=80=AFAM <fangyu.yu@linux.alibaba.com> w=
rote:
> > >
> > > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > >
> > > As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> > > vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> > > regions. Using vma->vm_pgoff to derive the HPA here may therefore
> > > produce incorrect mappings.
> > >
> > > Instead, I/O mappings for such regions can be established on-demand
> > > during g-stage page faults, making the upfront ioremap in this path
> > > is unnecessary.
> > >
> > > Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table progra=
mming")
> > The Fixes tag should be 'commit aac6db75a9fc ("vfio/pci: Use
> > unmap_mapping_range()")'.
> >
> > A stable tree necessitates minimizing the "Fixes tag" interference.
> >
> > We also need to
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > For review.
> >
> > > Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > > ---
> > >  arch/riscv/kvm/mmu.c | 20 +-------------------
> > >  1 file changed, 1 insertion(+), 19 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > > index 525fb5a330c0..84c04c8f0892 100644
> > > --- a/arch/riscv/kvm/mmu.c
> > > +++ b/arch/riscv/kvm/mmu.c
> > > @@ -197,8 +197,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
> > >
> > >         /*
> > >          * A memory region could potentially cover multiple VMAs, and
> > > -        * any holes between them, so iterate over all of them to fin=
d
> > > -        * out if we can map any of them right now.
> > > +        * any holes between them, so iterate over all of them.
> > >          *
> > >          *     +--------------------------------------------+
> > >          * +---------------+----------------+   +----------------+
> > > @@ -229,32 +228,15 @@ int kvm_arch_prepare_memory_region(struct kvm *=
kvm,
> > >                 vm_end =3D min(reg_end, vma->vm_end);
> > >
> > >                 if (vma->vm_flags & VM_PFNMAP) {
> > > -                       gpa_t gpa =3D base_gpa + (vm_start - hva);
> > > -                       phys_addr_t pa;
> > > -
> > > -                       pa =3D (phys_addr_t)vma->vm_pgoff << PAGE_SHI=
FT;
> > > -                       pa +=3D vm_start - vma->vm_start;
> > > -
> > >                         /* IO region dirty page logging not allowed *=
/
> > >                         if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > >                                 ret =3D -EINVAL;
> > >                                 goto out;
> > >                         }
> > > -
> > > -                       ret =3D kvm_riscv_mmu_ioremap(kvm, gpa, pa, v=
m_end - vm_start,
> > > -                                                   writable, false);
> > > -                       if (ret)
> > > -                               break;
> > Defering the ioremap to the g-stage page fault looks good to me, as it
> > simplifies the implementation here.
> >
> > Acked-by: Guo Ren <guoren@kernel.org>
>
> I think you meant Reviewed-by and not Acked-by.
Yes,

Reviewed-by: Guo Ren <guoren@kernel.org>

>
> I have updated the Fixes tag at the time of merging.
Okay.

>
> Regards,
> Anup



--=20
Best Regards
 Guo Ren


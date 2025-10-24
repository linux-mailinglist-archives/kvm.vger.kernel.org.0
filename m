Return-Path: <kvm+bounces-60988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 167DCC04BAB
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 140163A68B1
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0B52E5400;
	Fri, 24 Oct 2025 07:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="dzvp6N8g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6C02E2299
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 07:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761291131; cv=none; b=dk/km56kcjZxVT9qukqJxFDdITIGgdjmv4GWmP97gwh1bxxqV5EuoE6DeHhoZwqjSX+9RuoUgVjKanrN1TI0EXK93Fe/gTmZByjPweqbq2vTsxV1NkVSy5NnVDo0BCXja629rX5oBxCrw9dTFOyxoWkaUHWYlcLm46xMN0Smmr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761291131; c=relaxed/simple;
	bh=dL3M7W63/HM9u/PVG56xwZ31tOE19K81D7nMJkjbwLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PI3oOym8xrtD5MxF3BuyVK6wLS2dBnCOAk6K4YiZbCrMy/+3ehKS3DhKiYJWJ930A1oGXuoeUnPPt6aDBavxJpVNQSHfmQo6EmWxIWY4FdAvuLgcczpucKW8Dp9cJYbV0ojYptu55rO1QE1flOdOMVJsEwGH8sNmo978lWlR5hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=dzvp6N8g; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-94107531591so69800539f.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 00:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761291129; x=1761895929; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpBZbjtJGLMlozwkX0b76PHQF1zYhL0A3YtxCDGJbdU=;
        b=dzvp6N8glI5URtBMnlcEkFnoogatxaA2BzWNtPHtFJHHofdpOlbNVtzslnWydeNoj6
         0dM1uaDZu/SuZ6EFCkKl4jc51rw0XX8Cz+1t2U126igU01CVE4ZuAXNcBF4zmyeE95Uq
         7zFys/T9cmrxVurmp+LqhpQ+cygDu3wWvhiAABwb7+WtxWVcz2KLUPBn80YZ16E+vsra
         QfwZyw+6k3AAj7BHqA22fKOF4VATztH4o7T9YJxfLJ+ExZ4EGqGXXGfBjqitBNiZC+1S
         pm3zMBQMnVirLuYpQlkob+5MP1t4AyETAeJcF81O41ZX/bATsR9UDOP4D3D7uvALO9yT
         e6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291129; x=1761895929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpBZbjtJGLMlozwkX0b76PHQF1zYhL0A3YtxCDGJbdU=;
        b=spOQ6kY32M93tOul7D7Ea+VBuDpRuhvM6ttwR0gxJwLl8rFxgUV8Odb+iLOczzOKaQ
         qwU0Z2VmZNc0aYf4qTMNh0cIFxtmRhqVJ7ZXEbY+1zjOxp6oUOZ8nsqhOabubA40daEH
         I/gt/bvE8PTNEIDmZUEPpYhJpHPyJPifyjtD6l+EjJZ4l7mxI9vyNuDjGwYLQKk0fXkS
         BHvA88PMPMmImha8Z7+QEfjt4nqy/Q8eCz+5N4mhy/SJj0npI1uz9Yf2qSfT66vnvh18
         lxTDe+2EWF4oJEQBT1E4BIJKCvN0Rf1KR9vdXxCfpVhK2dHQVZHGqV9cGqNvNMl2tOsJ
         5FAw==
X-Forwarded-Encrypted: i=1; AJvYcCXWqg9yzkjeh5q+DACUaAvrkJHYjCYHYfWih1g7kPipE5QqldxhLFjYWTVbzoaUdlnziCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0AUe4QtXHzBdE9wuv/id7ogHCBPMtNlw6z+OZiZgi3LQzP6CT
	HKupiQ1YevuTiw8rRmdNj/88WvEt6gaBuAP+MIlRfbYWYuP0OgcbkM2qrO9bdvez7weUBRckGGZ
	1GJYLu6ExeB4owEod7NYjEduqBkElyxTVeJFHiWsDq2PRxLfGwJKRUX8=
X-Gm-Gg: ASbGncu9z2J1/RI+Jj9O6ZLYLOUUY6yYDxvZSBh4N7Z/VVYAK+D2j58Zl87Hb/kuNGH
	/XuYYZFIYXFMxE42z5PygRY62X5NCd3HggHbKuRrUqFVwPcXXZ6mBVZMPEMLwuOIc3t91vGDETg
	sA8CCymy+f/4rzzABnP9B+8Ivbmet0N/0Q8JqnpS4jKkeyjCBPB8D23kEaBcet4PPQ4SKph+00h
	pRw2EBdFY18scgrIzO8AWC3HBaz7xT7jvudFhyXQ5j04lpJ+V4mubopyuAld9fUpE6/i6crt0QK
	0jOI3h1X7TwaKQWWvg==
X-Google-Smtp-Source: AGHT+IE8lJniclhto/l+RH48c18UKMSGetx2EifcCSozWch7G7Fgd/VVGLw9VfrEOhdG/fnB1nKrZd3e4LUYvBidL4I=
X-Received: by 2002:a05:6e02:156c:b0:430:ad98:981f with SMTP id
 e9e14a558f8ab-430c524b96bmr356886075ab.4.1761291128790; Fri, 24 Oct 2025
 00:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com> <CAJF2gTRwHJsA7jFvAXbqy-6LyfaVTqfsFXgHfAeOZ8M3JNsikg@mail.gmail.com>
In-Reply-To: <CAJF2gTRwHJsA7jFvAXbqy-6LyfaVTqfsFXgHfAeOZ8M3JNsikg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 24 Oct 2025 13:01:57 +0530
X-Gm-Features: AWmQ_blwhFmtWb2XCxa4JYOc1i2equWNv_ps6eVK8LyUUbV_-WLoCb0ZdIQIWZo
Message-ID: <CAAhSdy1j4HZ86V6VsSF80LuNoxB3L3fmYYtvT7LU93fhbgCuug@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: Guo Ren <guoren@kernel.org>
Cc: fangyu.yu@linux.alibaba.com, atish.patra@linux.dev, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, pbonzini@redhat.com, 
	jiangyifei@huawei.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, jgg@nvidia.com, 
	alex.williamson@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 8:58=E2=80=AFPM Guo Ren <guoren@kernel.org> wrote:
>
> On Mon, Oct 20, 2025 at 6:08=E2=80=AFAM <fangyu.yu@linux.alibaba.com> wro=
te:
> >
> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> > As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> > vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> > regions. Using vma->vm_pgoff to derive the HPA here may therefore
> > produce incorrect mappings.
> >
> > Instead, I/O mappings for such regions can be established on-demand
> > during g-stage page faults, making the upfront ioremap in this path
> > is unnecessary.
> >
> > Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programm=
ing")
> The Fixes tag should be 'commit aac6db75a9fc ("vfio/pci: Use
> unmap_mapping_range()")'.
>
> A stable tree necessitates minimizing the "Fixes tag" interference.
>
> We also need to
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> For review.
>
> > Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > ---
> >  arch/riscv/kvm/mmu.c | 20 +-------------------
> >  1 file changed, 1 insertion(+), 19 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 525fb5a330c0..84c04c8f0892 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -197,8 +197,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >
> >         /*
> >          * A memory region could potentially cover multiple VMAs, and
> > -        * any holes between them, so iterate over all of them to find
> > -        * out if we can map any of them right now.
> > +        * any holes between them, so iterate over all of them.
> >          *
> >          *     +--------------------------------------------+
> >          * +---------------+----------------+   +----------------+
> > @@ -229,32 +228,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
> >                 vm_end =3D min(reg_end, vma->vm_end);
> >
> >                 if (vma->vm_flags & VM_PFNMAP) {
> > -                       gpa_t gpa =3D base_gpa + (vm_start - hva);
> > -                       phys_addr_t pa;
> > -
> > -                       pa =3D (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT=
;
> > -                       pa +=3D vm_start - vma->vm_start;
> > -
> >                         /* IO region dirty page logging not allowed */
> >                         if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >                                 ret =3D -EINVAL;
> >                                 goto out;
> >                         }
> > -
> > -                       ret =3D kvm_riscv_mmu_ioremap(kvm, gpa, pa, vm_=
end - vm_start,
> > -                                                   writable, false);
> > -                       if (ret)
> > -                               break;
> Defering the ioremap to the g-stage page fault looks good to me, as it
> simplifies the implementation here.
>
> Acked-by: Guo Ren <guoren@kernel.org>

I think you meant Reviewed-by and not Acked-by.

I have updated the Fixes tag at the time of merging.

Regards,
Anup


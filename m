Return-Path: <kvm+bounces-46462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A031AB6480
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 278DF1B62BF4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F6956B81;
	Wed, 14 May 2025 07:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hdroa7zU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B01C28E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 07:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747208059; cv=none; b=f4CUpfd/b2vygJKBgUNLuBGPEzLhDEk0iU/gqtwjCx8F3dnX5HqXi1Y41TlsefXxLZI4RSl/N8ehiYWXncK0OZekaiTVXSQCz430rpXbm1fUchHACDx8GWHAuvv8uxkik05zDN1XaoEgYL1ryIsEU/7piBKkvofzA25IcdNzphk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747208059; c=relaxed/simple;
	bh=Zk8AYXc+N9zzRDvLpBlVY2w1heLxebTxSA5YZ2AGjxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H30u4/IY85nj4LdXLciDT8vbAbm/f+XxGXhW7KEz5Q+dlh022qWK9qQ17n2l/3hXLekhVOHvJYexUSIy/V7t6zgWc/3/qfKlSKZO7obtTHvMQCddVZrCNmYQUirKntZnVUfPhRlOnEGMSKlf1H87tM/m8qZYeXMlQBc/WBXKHqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hdroa7zU; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-48b7747f881so172421cf.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747208055; x=1747812855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+K04p3I7lu9J1Ks0C4ES0/2cH0wDYip+VLHtbctoxbA=;
        b=Hdroa7zUN4jPhx/Q/Vn7CmDCVrY6kIB2AvlKzXmD+27FKQh5rxWxKkqn7PXBzAy05y
         uQ2IhNPfsTmwZKk5vXuFYYNbHutdkgVeuSUPM3jxl+Af+ng9immRUvjWm2cxJa7YG0yB
         BJr2oGFD3Za03sY0lBk1OR2//ZsjrojZs4/mqR7Jk78R6ocDhXanjfpUuvWxXqv68N1O
         L3SDR5cPxeVhvCa5w7h4ItMhRfVqn1VzvCDyrxARndXdZvfifnPtAQGoikWTBgqG/b9l
         2P7ew/QlYS75SChVvA4Kqz3vW803OfqfTVwNn8I/8slB1MMeR7xH07GqbDPDWOXwSMvi
         u0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747208055; x=1747812855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+K04p3I7lu9J1Ks0C4ES0/2cH0wDYip+VLHtbctoxbA=;
        b=d5VIXJbfLg29iJtES8onUabFxUAx+yxpRpzkZDJIZzylkxq5tz3MjROqBLz+rsNDM2
         omqFBqFAMivwkBRR5cE83fajRp2CDzVa1tnWzgEPEI5inUD5i8lMIVEdbIrbPlCbRH6a
         GQf3cGaAPD5XhBwSq2Fp2p8XkVbsPbJ8zeSTrKv7l/LCCtRg1XpWTI6gSaNVxAWc/YIE
         htE8f2FcuSQ8AeToIyOReu08MgmcUPU3eR1hYGKJVhOSrY7rcL3Dozbrt9H11zPCvWPW
         pMViBUwSHjtt/l8QvBpPno8A7yKtlAHWINvpEyKY2KpNdXgcR3gNOUACHQoKIKCzLsq+
         TNLw==
X-Gm-Message-State: AOJu0Yx2cz+zc6A91tmRPBi6lfSyXm8Hm9sjh615suumd3pKTwFQpL9U
	jeHYPmc0W9dgl9iJXuOEWSc/4ZZlXFOT2mgy52LKg6CdvRuhYYlws61q6FVTQeSaBTNGiMsCkg2
	rxxExKWGK95SbCxfPn5VcmWcktq0WinkKscxz7Axn
X-Gm-Gg: ASbGncsL+w2WAzxUp9Gb8CmZ0yLXYRJW5ZmC1uDCDvu9dZtv7hwjwtAdf7/lS/y+oQs
	ZhNt+BdQV7PjMS6S6UzqKHN9j7D/IyYC9Iadjk2OCpmfWxwWMeWyEsPEvgzGUiyDyuO7H8Oc//A
	1yG8PL8BgPdS4M9pIDSaPFdWvvcbXNlQqz7w==
X-Google-Smtp-Source: AGHT+IFSOID1ICFA/5WT/TzMHfPgJnDU6FMA0qEBlUg4UzroG9ERy4wAxu21kXkOFoFF7O5R0YHNgip2tFvVC5FLwQQ=
X-Received: by 2002:a05:622a:10a:b0:477:1f86:178c with SMTP id
 d75a77b69052e-49496168dcdmr3009381cf.26.1747208055027; Wed, 14 May 2025
 00:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-9-tabba@google.com>
 <CADrL8HVikf9OK_j4aUk2NZ-BB2sTdavGnDza9244TMeDWjxbCQ@mail.gmail.com>
In-Reply-To: <CADrL8HVikf9OK_j4aUk2NZ-BB2sTdavGnDza9244TMeDWjxbCQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 14 May 2025 08:33:38 +0100
X-Gm-Features: AX0GCFtAIOxW0CKUqlf7YJqpRk8IDw3vPXES_-izSP0Sdin8tzyjcQYf2tlC9j4
Message-ID: <CA+EHjTyWOJA8u3iXS9txF8oDKF-soykjJm8HPPEW+6VpM+uvtg@mail.gmail.com>
Subject: Re: [PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and
 fd+offset refer to same range
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 13 May 2025 at 21:31, James Houghton <jthoughton@google.com> wrote:
>
> On Tue, May 13, 2025 at 9:34=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > On binding of a guest_memfd with a memslot, check that the slot's
> > userspace_addr and the requested fd and offset refer to the same memory
> > range.
> >
> > This check is best-effort: nothing prevents userspace from later mappin=
g
> > other memory to the same provided in slot->userspace_addr and breaking
> > guest operation.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  virt/kvm/guest_memfd.c | 37 ++++++++++++++++++++++++++++++++++---
> >  1 file changed, 34 insertions(+), 3 deletions(-)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 8e6d1866b55e..2f499021df66 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -556,6 +556,32 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_cr=
eate_guest_memfd *args)
> >         return __kvm_gmem_create(kvm, size, flags);
> >  }
> >
> > +static bool kvm_gmem_is_same_range(struct kvm *kvm,
> > +                                  struct kvm_memory_slot *slot,
> > +                                  struct file *file, loff_t offset)
> > +{
> > +       struct mm_struct *mm =3D kvm->mm;
> > +       loff_t userspace_addr_offset;
> > +       struct vm_area_struct *vma;
> > +       bool ret =3D false;
> > +
> > +       mmap_read_lock(mm);
> > +
> > +       vma =3D vma_lookup(mm, slot->userspace_addr);
> > +       if (!vma)
> > +               goto out;
> > +
> > +       if (vma->vm_file !=3D file)
> > +               goto out;
> > +
> > +       userspace_addr_offset =3D slot->userspace_addr - vma->vm_start;
> > +       ret =3D userspace_addr_offset + (vma->vm_pgoff << PAGE_SHIFT) =
=3D=3D offset;
> > +out:
> > +       mmap_read_unlock(mm);
> > +
> > +       return ret;
> > +}
> > +
> >  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                   unsigned int fd, loff_t offset)
> >  {
> > @@ -585,9 +611,14 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memo=
ry_slot *slot,
> >             offset + size > i_size_read(inode))
> >                 goto err;
> >
> > -       if (kvm_gmem_supports_shared(inode) &&
> > -           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > -               goto err;
> > +       if (kvm_gmem_supports_shared(inode)) {
> > +               if (!kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +                       goto err;
> > +
> > +               if (slot->userspace_addr &&
> > +                   !kvm_gmem_is_same_range(kvm, slot, file, offset))
> > +                       goto err;
>
> This is very nit-picky, but I would rather this not be -EINVAL, maybe
> -EIO instead? Or maybe a pr_warn_once() and let the call proceed?
>
> The userspace_addr we got isn't invalid per se, we're just trying to
> give a hint to the user that their VMAs (or the userspace address they
> gave us) are messed up. I don't really like lumping this in with truly
> invalid arguments.

I don't mind changing the return error, but I don't think that we
should have a kernel warning (pr_warn_once) for something userspace
can trigger.

It's not an IO error either. I think that this is an invalid argument
(EINVAL). That said, other than opposing the idea of pr_warn, I am
happy to change it.

Cheers,
/fuad

> > +       }
> >
> >         filemap_invalidate_lock(inode->i_mapping);
> >
> > --
> > 2.49.0.1045.g170613ef41-goog
> >


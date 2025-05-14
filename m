Return-Path: <kvm+bounces-46497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9105AB6CC3
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C50F1B6667B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8E22798E6;
	Wed, 14 May 2025 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4RYQ6u3C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0991322F16E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747229570; cv=none; b=qaQo+wzQ9+6khgDvJZDevc5W1JtYmAi3ALPLgCa8CK5SKlz0Y8Nq3xWOca5OIbCNO5uUVawJUWsr/HCGZPFGzteZK0xn6XB0Hb5WPYaxZbYkh/v73kA6WSOrfo+LbNERwqqgRUZOP8dhgwS0C06lSEl20doOFaZraloQmCajX14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747229570; c=relaxed/simple;
	bh=GyQ/FSZgjTZBU8FMaL9GnY/SAorALYPBq/mbS6aVpY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eYRKEDnPx54wIOmMfpTcTE+aZz+zW6vdpW/YqJnxhO8yAmMRgGoJmd6XtIMW89gmCEqwHFoB8O3E3tqeQzo5q4l4rk6ftDvoFzVie6FTkC8xRwBsxUDfKFJMTh7zw+NcZHcaTn9ZR7bt4ZCH95rcvHm3lu6wcm3JYJlJD5h2HKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4RYQ6u3C; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c54b4007cso3895200a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747229568; x=1747834368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RtedgjrSq1v3wZQaGrNE6v5R8N01W2PT/oJAJN+tLO0=;
        b=4RYQ6u3C7OaqjDJRxbArGDYd9UDCUQUKwByleVgGKS9vYhJ3qZpk61TC3zTdeY6j8E
         RXEq4Dpj0l9ruTIghj+vGMQf0CE39KUSkKxO7AQq3+urLGwY8j5o6YBWUWuA3F4TFvCq
         eCrZ1ohigduMQdCdXMjEffvLCrimdMskh9As3hR85CJbHNa3fpgKlxhJjBx2JOURXNbk
         xslsNZ1S4yrO1tqtijQvwcM5WuBF+26IE0bV7xnJu9vfjle2OKsGhQx6xLkQHIohfB61
         TylvGr6VWm82MS1cqLoe09rhuJXazrMOXfM2wbP7s1iK2Cu8SXmutMh0WgwF6HvSEvEa
         i2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747229568; x=1747834368;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RtedgjrSq1v3wZQaGrNE6v5R8N01W2PT/oJAJN+tLO0=;
        b=Y/JktIi8tvjKfsZPQd7p4EsCpccZZ9/Vvr8m6MkCL10XPdFdlEHy0gl+UCcxcAPy1T
         JheDdBWAHD8cZb8kRb8QROlokR6zEmXE1FjUAjptt01GpbDmAiD5alkVg2vY8wz3G7HD
         sVDWJFKRME3xTtxXocy9xoT5wzgC3/uAhpsJuTYxufWQO5qbo/8QsWNdYSCTWA35lNy6
         /2+WPaFrWFyf46R+eR0oKEyWXc+xgESdS5ZGdQuxltMHie5nZS0VK8OfIqAQg/9X9obt
         Bpa9NZSLWh+NJnxHaG7xYnYN20NCb/WLS0e74EUM6nwkhAOUhechNjN9OQkuMzo31dOj
         Ttxg==
X-Forwarded-Encrypted: i=1; AJvYcCVEY9Hu+zM2ZxeTyQaHrl0eSaa4PHWvC7r+pPF+wp6rQb/F7BLLPngezrWHnnqoTvXp3Ec=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlEMcgD9M45guRZaLyDkDBGv0Bt4fjU20zGBhGQVsxvRxsUB1X
	vCzp985o+lIdvZbmHpOetq0feoumClNrd9SFe16JY29SwPtSUpIgIip3oaHJ4Ew+re/C3UbRlcy
	YXg==
X-Google-Smtp-Source: AGHT+IEBESmhDh1kZA9q3dK9bozi69K8VuHlCLiyf6hF2yMudSAXgRJciMpW68u3/8oFdg4WPhCaXZrhSmQ=
X-Received: from pjbpb18.prod.google.com ([2002:a17:90b:3c12:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58cf:b0:2fa:f8d:65de
 with SMTP id 98e67ed59e1d1-30e2e62a98emr4631512a91.22.1747229568217; Wed, 14
 May 2025 06:32:48 -0700 (PDT)
Date: Wed, 14 May 2025 06:32:46 -0700
In-Reply-To: <CA+EHjTyWOJA8u3iXS9txF8oDKF-soykjJm8HPPEW+6VpM+uvtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-9-tabba@google.com>
 <CADrL8HVikf9OK_j4aUk2NZ-BB2sTdavGnDza9244TMeDWjxbCQ@mail.gmail.com> <CA+EHjTyWOJA8u3iXS9txF8oDKF-soykjJm8HPPEW+6VpM+uvtg@mail.gmail.com>
Message-ID: <aCSbfjoD2_Dj_t6b@google.com>
Subject: Re: [PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and
 fd+offset refer to same range
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025, Fuad Tabba wrote:
> On Tue, 13 May 2025 at 21:31, James Houghton <jthoughton@google.com> wrot=
e:
> >
> > On Tue, May 13, 2025 at 9:34=E2=80=AFAM Fuad Tabba <tabba@google.com> w=
rote:
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index 8e6d1866b55e..2f499021df66 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -556,6 +556,32 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_=
create_guest_memfd *args)
> > >         return __kvm_gmem_create(kvm, size, flags);
> > >  }
> > >
> > > +static bool kvm_gmem_is_same_range(struct kvm *kvm,
> > > +                                  struct kvm_memory_slot *slot,
> > > +                                  struct file *file, loff_t offset)
> > > +{
> > > +       struct mm_struct *mm =3D kvm->mm;
> > > +       loff_t userspace_addr_offset;
> > > +       struct vm_area_struct *vma;
> > > +       bool ret =3D false;
> > > +
> > > +       mmap_read_lock(mm);
> > > +
> > > +       vma =3D vma_lookup(mm, slot->userspace_addr);
> > > +       if (!vma)
> > > +               goto out;
> > > +
> > > +       if (vma->vm_file !=3D file)
> > > +               goto out;
> > > +
> > > +       userspace_addr_offset =3D slot->userspace_addr - vma->vm_star=
t;
> > > +       ret =3D userspace_addr_offset + (vma->vm_pgoff << PAGE_SHIFT)=
 =3D=3D offset;
> > > +out:
> > > +       mmap_read_unlock(mm);
> > > +
> > > +       return ret;
> > > +}
> > > +
> > >  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> > >                   unsigned int fd, loff_t offset)
> > >  {
> > > @@ -585,9 +611,14 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_me=
mory_slot *slot,
> > >             offset + size > i_size_read(inode))
> > >                 goto err;
> > >
> > > -       if (kvm_gmem_supports_shared(inode) &&
> > > -           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > > -               goto err;
> > > +       if (kvm_gmem_supports_shared(inode)) {
> > > +               if (!kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > > +                       goto err;
> > > +
> > > +               if (slot->userspace_addr &&
> > > +                   !kvm_gmem_is_same_range(kvm, slot, file, offset))
> > > +                       goto err;
> >
> > This is very nit-picky, but I would rather this not be -EINVAL, maybe
> > -EIO instead? Or maybe a pr_warn_once() and let the call proceed?

Or just omit the check entirely.  The check isn't binding (ba-dump, ching!)=
,
because the mapping/VMA can change the instant mmap_read_unlock() is called=
.

> > The userspace_addr we got isn't invalid per se, we're just trying to
> > give a hint to the user that their VMAs (or the userspace address they
> > gave us) are messed up. I don't really like lumping this in with truly
> > invalid arguments.
>=20
> I don't mind changing the return error, but I don't think that we
> should have a kernel warning (pr_warn_once) for something userspace
> can trigger.

This isn't a WARN, e.g. won't trip panic_on_warn.  In practice, it's not
meaningfully different than pr_info().  That said, I agree that printing an=
ything
is a bad approach.

> It's not an IO error either. I think that this is an invalid argument
> (EINVAL).

I agree with James, this isn't an invalid argument.  Having the validity of=
 an
input hinge on the ordering between a KVM ioctl() and mmap() is quite odd. =
 I
know KVM arm64 does exactly this for KVM_SET_USER_MEMORY_REGION{,2}, but I =
don't
love the semantics.  And unlike that scenario, where e.g. MTE tags are veri=
fied
again at fault-time, KVM won't re-check the VMA when accessing guest memory=
 via
the userspace mapping, e.g. through uaccess.

Unless I'm forgetting something, I'm leaning toward omitting the check enti=
rely.

> That said, other than opposing the idea of pr_warn, I am happy to change =
it.


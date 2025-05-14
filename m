Return-Path: <kvm+bounces-46499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BA3AB6D33
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20B969A0D79
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2006192580;
	Wed, 14 May 2025 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HlEEiDYL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630FE19BBC
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 13:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230457; cv=none; b=Zd2nWQtVTgG3CdfytsWR9E0RM2DoY09kf0b/NwPyCyPpab93YJz3KEXSSC+TV6bHS+wyo1QN5v72YOFNhjicqggbukfV9EDi9uGfk4k7YiO8H1PlZiHNsgAL8S2XMlaoAE4JqNYRE4kXZJrbLMxt0ojr1WLG/EMDXDwl5hZR62w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230457; c=relaxed/simple;
	bh=nDyduVLgFBFH3gTMueLQbgt/yrdrb7IJ6t26wAPoNcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PphRlUK77AF97mMS7wqIReTwFs+jxSmOfu6U4T5Hpn9HEIIrt9fXepFBLVHOIoNaC3zwel7k3wbtcSq9wsuqdudQa2juEGkKdtR93Az+ao29crk9VnJU8mXZm0Rko+RwdZI79htapI2uh3Y+RxnRUvLFWBQpIwJR0fNeXVRAyyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HlEEiDYL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2075419ff6so3938570a12.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747230454; x=1747835254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NAeeCNPnco32qDMK0805AT1A5LqfUBAlcHGKeMgxKz0=;
        b=HlEEiDYLoaiJXy5DrBzEvc5N6g5s7LQbTh7U42FNP5jelx9OIZYyOPR6fWF+cyrY5U
         TqIeVUxnAvCpFaPRR4zlX+Zd/VdvYFIKVRZQC/sSAwdKusp0atbLfxDMjbloeBH53oTt
         iqZcEuK8Q/PV202gVK+3TYDVD9xptQuMtjZBd0KsIAymAVdR3fDLlU0StYm8/8gH34vZ
         tiGUmAy+7w+aGuCD/eu1RkLvWkGdrHR1wSi9smaZcgxUgbBPRoWxtPjIKBpBaBi7K36Q
         /I2kfLoxQmfQ+8yhMu1qTWX6S3Kwbn//i3eAaSVzvi2/ngrphAal31TBJ42o4QyPLv/+
         lQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747230454; x=1747835254;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NAeeCNPnco32qDMK0805AT1A5LqfUBAlcHGKeMgxKz0=;
        b=v2fBHlzW1dIjBGm02RlDLQTCJid4mzfNdb7UN8z9y5BBqH+BON5Ls4db+bvJH7JITd
         4o6hpnUBxx29ePWRfWBE5rsEYk/WlJWn+wMO580C0PFBStxypL9IGoGQLVrcKecPccSW
         kWkf/C1Y8XKxeplWgQiap624yXmuYpEVyytuf482X0Cw7lpJ4w75C20WuP9a7V5ZFjKE
         nN2iqE+bNQAxtaB/TM9XCkgw3mhc7bkkqTDgIrEgCArI675VNgEGrS/lHsoyrS8AR+fN
         qnxTfxUS/mSThJeKpU1PMytdOTVRVZWclaqMEgV8/UMKHUcXmrpuDhXKct5lWM7ZFuHJ
         s8Ew==
X-Forwarded-Encrypted: i=1; AJvYcCWHWmZZmW+OLApYBw/3rKCHphzoEuAby0F9Y0RIYBXD4g/jTWbcufEEWDJTlgYygJMyBJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCdZNY5YR2xhQk1ce7OG+B6TvvKBbXsxn6KY/+zV1Ysczm79TJ
	7u51f7i0ElT1v43PbjDzA24kUbIF2Ejaab+KXcTC0nbedYC2T5XYBG+Mkg8jBU8wBVLDQrXVjLI
	JVIFBbe2jf+EbbZ8wpiw+Pw==
X-Google-Smtp-Source: AGHT+IFlOuQgyMPVc1YUUtLXJF5y8ehrcWnysunLFjMxE8p4X6GNDVE1Npu94fwETvyfjq0ALu78lCMC+AguGK3AiA==
X-Received: from pjbsy12.prod.google.com ([2002:a17:90b:2d0c:b0:2fc:2b96:2d4b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b85:b0:305:5f25:59a5 with SMTP id 98e67ed59e1d1-30e2e644d22mr5148468a91.35.1747230454332;
 Wed, 14 May 2025 06:47:34 -0700 (PDT)
Date: Wed, 14 May 2025 06:47:33 -0700
In-Reply-To: <aCSbfjoD2_Dj_t6b@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-9-tabba@google.com>
 <CADrL8HVikf9OK_j4aUk2NZ-BB2sTdavGnDza9244TMeDWjxbCQ@mail.gmail.com>
 <CA+EHjTyWOJA8u3iXS9txF8oDKF-soykjJm8HPPEW+6VpM+uvtg@mail.gmail.com> <aCSbfjoD2_Dj_t6b@google.com>
Message-ID: <diqzo6vvpami.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and
 fd+offset refer to same range
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> On Wed, May 14, 2025, Fuad Tabba wrote:
>> On Tue, 13 May 2025 at 21:31, James Houghton <jthoughton@google.com> wro=
te:
>> >
>> > On Tue, May 13, 2025 at 9:34=E2=80=AFAM Fuad Tabba <tabba@google.com> =
wrote:
>> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > > index 8e6d1866b55e..2f499021df66 100644
>> > > --- a/virt/kvm/guest_memfd.c
>> > > +++ b/virt/kvm/guest_memfd.c
>> > > @@ -556,6 +556,32 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm=
_create_guest_memfd *args)
>> > >         return __kvm_gmem_create(kvm, size, flags);
>> > >  }
>> > >
>> > > +static bool kvm_gmem_is_same_range(struct kvm *kvm,
>> > > +                                  struct kvm_memory_slot *slot,
>> > > +                                  struct file *file, loff_t offset)
>> > > +{
>> > > +       struct mm_struct *mm =3D kvm->mm;
>> > > +       loff_t userspace_addr_offset;
>> > > +       struct vm_area_struct *vma;
>> > > +       bool ret =3D false;
>> > > +
>> > > +       mmap_read_lock(mm);
>> > > +
>> > > +       vma =3D vma_lookup(mm, slot->userspace_addr);
>> > > +       if (!vma)
>> > > +               goto out;
>> > > +
>> > > +       if (vma->vm_file !=3D file)
>> > > +               goto out;
>> > > +
>> > > +       userspace_addr_offset =3D slot->userspace_addr - vma->vm_sta=
rt;
>> > > +       ret =3D userspace_addr_offset + (vma->vm_pgoff << PAGE_SHIFT=
) =3D=3D offset;
>> > > +out:
>> > > +       mmap_read_unlock(mm);
>> > > +
>> > > +       return ret;
>> > > +}
>> > > +
>> > >  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>> > >                   unsigned int fd, loff_t offset)
>> > >  {
>> > > @@ -585,9 +611,14 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_m=
emory_slot *slot,
>> > >             offset + size > i_size_read(inode))
>> > >                 goto err;
>> > >
>> > > -       if (kvm_gmem_supports_shared(inode) &&
>> > > -           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
>> > > -               goto err;
>> > > +       if (kvm_gmem_supports_shared(inode)) {
>> > > +               if (!kvm_arch_vm_supports_gmem_shared_mem(kvm))
>> > > +                       goto err;
>> > > +
>> > > +               if (slot->userspace_addr &&
>> > > +                   !kvm_gmem_is_same_range(kvm, slot, file, offset)=
)
>> > > +                       goto err;
>> >
>> > This is very nit-picky, but I would rather this not be -EINVAL, maybe
>> > -EIO instead? Or maybe a pr_warn_once() and let the call proceed?
>
> Or just omit the check entirely.  The check isn't binding (ba-dump, ching=
!),
> because the mapping/VMA can change the instant mmap_read_unlock() is call=
ed.
>
>> > The userspace_addr we got isn't invalid per se, we're just trying to
>> > give a hint to the user that their VMAs (or the userspace address they
>> > gave us) are messed up. I don't really like lumping this in with truly
>> > invalid arguments.
>>=20
>> I don't mind changing the return error, but I don't think that we
>> should have a kernel warning (pr_warn_once) for something userspace
>> can trigger.
>
> This isn't a WARN, e.g. won't trip panic_on_warn.  In practice, it's not
> meaningfully different than pr_info().  That said, I agree that printing =
anything
> is a bad approach.
>
>> It's not an IO error either. I think that this is an invalid argument
>> (EINVAL).
>
> I agree with James, this isn't an invalid argument.  Having the validity =
of an
> input hinge on the ordering between a KVM ioctl() and mmap() is quite odd=
.  I
> know KVM arm64 does exactly this for KVM_SET_USER_MEMORY_REGION{,2}, but =
I don't
> love the semantics.  And unlike that scenario, where e.g. MTE tags are ve=
rified
> again at fault-time, KVM won't re-check the VMA when accessing guest memo=
ry via
> the userspace mapping, e.g. through uaccess.
>
> Unless I'm forgetting something, I'm leaning toward omitting the check en=
tirely.
>

I'm good with dropping this patch. I might have misunderstood the
conclusion of the guest_memfd call.

>> That said, other than opposing the idea of pr_warn, I am happy to change=
 it.


Return-Path: <kvm+bounces-42568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2C3A7A1FD
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3668918981F2
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8052324BD00;
	Thu,  3 Apr 2025 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLT9SW9A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC2124C090
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680002; cv=none; b=b29heLFyaxXlQj5tm8Tbt7yz5v5r1LAbbAJWiF3mjAO14Asu1UVVaTTOi2gabEntaOpELyb9X0i8+LzXyi1BaAqO9jZDEyYXCUZ5KQedHaBDqQBEZu38KicZqNhNEiB2Z5kAvVJQnUXNSF/LOtY0qX420ctWmb60UOZSZHXG09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680002; c=relaxed/simple;
	bh=ENjCOqZlKPp/D7qWHLdDXx/2Hgf7yk6/ptGgwF9MJKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBzV+JVjvV4VLJ563IrnN+c2zZ0TsMVqJReDIaDQ7R3HeXeQfe/EKjbT4Ti3AaFoym2mw3wyctBTZBTdLWqG3fqphdieRaHwv0m5rMSRjCZ6d2jtYnoiJftjBh9466KXoKZFocSxTgxXLfWVG5myfHqWHSjVNAKwy17ze8UrfaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLT9SW9A; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4769e30af66so834271cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743680000; x=1744284800; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gEMObUoyn3JUJ1C/U9ykdrbpQA2uh4Mz7RwOIB0uCd8=;
        b=WLT9SW9AVwnfSziiWjGOmTezf8G0L1CVPVx9TXB7LE9BzL1Fr6Y29XpMNRgjc3DEbz
         kJbcdRUdDi6hhfOOd3ax16T8whbd4RIRGzhT3Rd9Hi77XD2taDmVj7HIZ0KlMIWpcqR/
         +KIfCpQDqFTjd7XnczxdEYBwC551hYTUO5M5dMMLrtqS++kaO2dIx3Uh0OnUP5SgIppj
         SmB90lz/e9ZPhG3/MpHOp4+jvbGgUB8jdoXOSAJInxUwZvcdzGwlUsXfJh4XmoMpfGQI
         MX37PUARDVBX73wVWPSokub98uB8/UAjfa9VolvHxOGzkA/yxl3x9I1KuDGiHXbqnOwJ
         TUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743680000; x=1744284800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEMObUoyn3JUJ1C/U9ykdrbpQA2uh4Mz7RwOIB0uCd8=;
        b=A4DrsL2+3ay7Wj179awCHTUl1d5Z99gysYAGU4YdesmFww5Egduh/IifOeL6OS1uHX
         nIe5r7JNFGrAVMZzQUIHwAolNAhihwZAW59haMQzbqc/6lJ2h94eOqT9m2QP1RWoFSVn
         oleQG4S6nPX81iTDnlWRbwkfjJOLiVh0K4Z6Gc4NoA9izGAj/t526vaGgbiLqcxuQqpe
         PXKUEOPc2SDmPBmG7gTKPq15B3RmrqxKrbtlY7MfW+7c0+QEF/6tPFI01FYsH/qjQ/3d
         U7ojK+U0Pf0p5fcYxvl2eUfi44L5lTHvmyX0bi7Mb7ypL0lskq8/Zs4K/Q8ZnGBish+j
         J0gA==
X-Gm-Message-State: AOJu0YxW3NHzUT/eGZsSasLE7KLpo3GueMxuhmLVcozcVzJr5r5FAo+2
	1ch6aSCCvyAGxSuw20oWjU0JqJJESUqz9gHETPEp/rZmBGfxJUIYIXbT7A7uIJxsSysY6PuTRbW
	fPKuLeqeVLfuB6ZSupv8HP2VXrxoDIcwhliN+
X-Gm-Gg: ASbGncsHl438N0Imgv8TydU3VMcmynGWTdUrVJo4E/sU68kBbErjDeF3LcJ/lYM6Hqi
	j6SLrU72BsA8rM+23l9qYQxVYgjoa0FU2hfsnPEEBF9BUEInUlIuNSJMoOQzl5tq8IpUQrKeCJ5
	deLueV9INnf3ngDMHsEw4u8n9eHA==
X-Google-Smtp-Source: AGHT+IFomZU1HMl8dHzvwzaPBWQoixQ5c08Z91Ow3ggUIuXK//3qzyPh36fz8VwRQ2X3bgMszlZm14KOtw6OkXzulBI=
X-Received: by 2002:ac8:5809:0:b0:477:c4f:ee58 with SMTP id
 d75a77b69052e-4791752498fmr4216301cf.24.1743679999618; Thu, 03 Apr 2025
 04:33:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-8-tabba@google.com> <diqzv7rmmahy.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzv7rmmahy.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 3 Apr 2025 12:32:42 +0100
X-Gm-Features: ATxdqUEPebUlHzj5-92DkCj0iX8Rt4t2SxCxCMdVt6zFFuAFssAocEZowoZO9AY
Message-ID: <CA+EHjTwy7BqWvTLsWMJExrerx6+AMoYaNib61of45v2hAsR--A@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] KVM: guest_memfd: Add a guest_memfd() flag to
 initialize it as shared
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Thu, 3 Apr 2025 at 00:03, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Not all use cases require guest_memfd() to be shared with the host when
> > first created. Add a new flag, GUEST_MEMFD_FLAG_INIT_SHARED, which when
> > set on KVM_CREATE_GUEST_MEMFD initializes the memory as shared with the
> > host, and therefore mappable by it. Otherwise, memory is private until
> > explicitly shared by the guest with the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst                 |  4 ++++
> >  include/uapi/linux/kvm.h                       |  1 +
> >  tools/testing/selftests/kvm/guest_memfd_test.c |  7 +++++--
> >  virt/kvm/guest_memfd.c                         | 12 ++++++++++++
> >  4 files changed, 22 insertions(+), 2 deletions(-)
> >
> > <snip>
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index eec9d5e09f09..32e149478b04 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -1069,6 +1069,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >               goto err_gmem;
> >       }
> >
> > +     if (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&
> > +         (flags & GUEST_MEMFD_FLAG_INIT_SHARED)) {
> > +             err = kvm_gmem_offset_range_set_shared(file_inode(file), 0, size >> PAGE_SHIFT);
>
> I think if GUEST_MEMFD_FLAG_INIT_SHARED is not set, we should call
> kvm_gmem_offset_range_clear_shared(); so that there is always some
> shareability defined for all offsets in a file. Otherwise, when reading
> shareability, we'd have to check against GUEST_MEMFD_FLAG_INIT_SHARED
> to find out what to initialize it to.

Ack.

Thanks!

/fuad

> > +             if (err) {
> > +                     fput(file);
> > +                     goto err_gmem;
> > +             }
> > +     }
> > +
> >       kvm_get_kvm(kvm);
> >       gmem->kvm = kvm;
> >       xa_init(&gmem->bindings);
> > @@ -1090,6 +1099,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
> > +     if (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             valid_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;


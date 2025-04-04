Return-Path: <kvm+bounces-42624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBD3A7B851
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 09:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E334B189B1D0
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 07:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FC81991B6;
	Fri,  4 Apr 2025 07:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mb+ZqfWT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2A7191F95
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 07:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743752438; cv=none; b=sLIttkQdRVvzeRpQ2oSK9bIIIrOsWuW1Xgsnm0C/von6uRCMGU8vWXC9trMbM8IemdDnZzCB8LfMJZ28bF38MPo5g9mwL2OzDb3eeZ6OC9xwIC0B/bFouIMOKy+umVM1Z2Uym8eHFU5GG8KWpmyB36hLsP61SJSoh4bbXADGSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743752438; c=relaxed/simple;
	bh=sjzVQvVa1uqblMttCsVGpLok+Avn0ska1LUiRUgNDE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YznVNeXT9Oad9AV0NzRllyGNkzmzZYvsuxC3KW9ixPpyxnurNkXuO8bKV0a3Y2xOAe5l9yX+Ap7g/iJviPaBPfZvrXVY0ewG47qjP35emVoAu/movN/Knz48IVOr74yqyBdWLYIShb1fEV2Ev0TiMAt89R2QzX2tk0EBn51V5VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mb+ZqfWT; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4769e30af66so177321cf.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 00:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743752435; x=1744357235; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Br9fTXMROs5VR9w4FKT6n7aN+mcJkt+3kBtbpV2Oo8A=;
        b=mb+ZqfWTu88jGz5jQzRn2qWj67XFsB1w97xLicuO7xYYjgzM7z/6q5g2s28NHckpNV
         Wn7B/r7cePY4K7g40JIQRer9q5rpKzLdjYEvaGmD4pSkOwkj+xhPQkKqUid0bLjH9ZP/
         g0jYmQj1d1lnLyyOx8jzJsggwVAgjM1mkWXDhYgc6O3oF6d5bhiQLP9zQrDgMjEYXQZU
         L7BF4sxRG5ViHw6sAWuwEY3aDp8J7pUIdAFg4KawgujgFudIGqaEXp18hxDU7g1Si8gC
         3fToRHQFoknoC0jtVJWNzuI1OM1ERv84ByoDKZVJaSe3wVwpJ69cfiiOWbd58Br1yeAK
         5ivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743752435; x=1744357235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Br9fTXMROs5VR9w4FKT6n7aN+mcJkt+3kBtbpV2Oo8A=;
        b=alexlH7oPEkKTPxzvwIl1mN17JqV16c74O5Hjkin4mVHr69zfsbsbC7Jsjcp3ScKwc
         vinRzYTrhbH8RhZ6TgcikiBQxuEcQ48hdyE1dsNzIs9reor5d+ghZ/mR+MZXuB+1rIgs
         7DYJHxfLbgzKWZSJcTg3U237+4uhoLH4d3whckcQAxD5MgarVFGeZqIGJskCrzAlLh2j
         Q9DrUqdNtnJ1TuK9NOiIq+awziLfK059ZewOgzuW6fSnSp4/l3M3SLfVvctMZBjhzJLd
         Ca28l5+vY1t2uC2SH6JdpDTqLcUcP8DGrUVv2i1xPFY/DXgjj5tZ8+S2k5gzOnd/5Res
         1F1A==
X-Gm-Message-State: AOJu0YwZ5brvsMSdKEe2VGWVYsBtQybqjDNvolTZCfLY6P7WXWag5192
	dOg2Wb0VGIPrCvg66VG7yW/gu3yPaWEqz4KYiIhcUVoARm+we8QdxnvzmgVzUuVYx63u6O5OMTT
	us2Kvfqgsaq9LBmuNwuDxmgLFKfuAi5el88HK
X-Gm-Gg: ASbGncvrioNSKMV7svb/kZuh6WJHiGgctbu5VLyc/Uzp2jxBbhAv1JM3XjvO3Zzun5m
	ElLRlRvhywXSejnq5oceolasfubnv2POUP0I5aWG8ExojStAyWwyNCpFf4BKqzFBpUvfHXfzbC2
	TGLT1JyB1ytHTLg5IQwwVeviIjXw==
X-Google-Smtp-Source: AGHT+IHh8o/6bgfsrn4MOo/LfDZvpVO0g+kpT4fjlgLXJoUO0EWOqh4XIHc3wOChI4rmlnpnV9UyfyMJyIj6psRylco=
X-Received: by 2002:a05:622a:309:b0:476:6232:183f with SMTP id
 d75a77b69052e-479266bfe08mr2230591cf.19.1743752435191; Fri, 04 Apr 2025
 00:40:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-8-tabba@google.com> <diqzy0wimb9c.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzy0wimb9c.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 4 Apr 2025 08:39:58 +0100
X-Gm-Features: ATxdqUES1GQahg7fTolYInex80Nv9poFQfIEx56A1_oFSbplzfZGtv-MWgV4DME
Message-ID: <CA+EHjTz34Rq8q9TDAb0OZYYaMXZATOAEf1_wMwA_sDgAKDwvnQ@mail.gmail.com>
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

On Wed, 2 Apr 2025 at 23:47, Ackerley Tng <ackerleytng@google.com> wrote:
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
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 2b52eb77e29c..a5496d7d323b 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6386,6 +6386,10 @@ most one mapping per page, i.e. binding multiple memory regions to a single
> >  guest_memfd range is not allowed (any number of memory regions can be bound to
> >  a single guest_memfd file, but the bound ranges must not overlap).
> >
> > +If the capability KVM_CAP_GMEM_SHARED_MEM is supported, then the flags field
> > +supports GUEST_MEMFD_FLAG_INIT_SHARED, which initializes the memory as shared
> > +with the host, and thereby, mappable by it.
> > +
> >  See KVM_SET_USER_MEMORY_REGION2 for additional details.
> >
> >  4.143 KVM_PRE_FAULT_MEMORY
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 117937a895da..22d7e33bf09c 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >  #define KVM_CREATE_GUEST_MEMFD       _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_INIT_SHARED         (1UL << 0)
> >
> >  struct kvm_create_guest_memfd {
> >       __u64 size;
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> > index 38c501e49e0e..4a7fcd6aa372 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -159,7 +159,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
> >  static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> >  {
> >       size_t page_size = getpagesize();
> > -     uint64_t flag;
> > +     uint64_t flag = BIT(0);
> >       size_t size;
> >       int fd;
> >
> > @@ -170,7 +170,10 @@ static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> >                           size);
> >       }
> >
> > -     for (flag = BIT(0); flag; flag <<= 1) {
> > +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> > +             flag = GUEST_MEMFD_FLAG_INIT_SHARED << 1;
> > +
> > +     for (; flag; flag <<= 1) {
>
> This would end up shifting the GUEST_MEMFD_FLAG_INIT_SHARED flag for
> each loop.

Yes. That's my intention. This tests whether the flags are invalid.
Without GUEST_MEMFD_FLAG_INIT_SHARED, no flag is valid, so it starts
with bit zero and goes through all the flags.

If KVM_CAP_GMEM_SHARED_MEM is available, then we want to start from
bit 1 (i.e., skip bit 0, which is GUEST_MEMFD_FLAG_INIT_SHARED).

Cheers,
/fuad

> >               fd = __vm_create_guest_memfd(vm, page_size, flag);
> >               TEST_ASSERT(fd == -1 && errno == EINVAL,
> >                           "guest_memfd() with flag '0x%lx' should fail with EINVAL",
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


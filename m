Return-Path: <kvm+bounces-42459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D16A78A67
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22DF31890D2E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836AA19E99C;
	Wed,  2 Apr 2025 08:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GpY8s5eM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E09C1E570D
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 08:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743584225; cv=none; b=hUOcx8Ed/AwE2kDtxyxn3KGRuM4I77iLCsbECTVcJY0H8jRQ+dx43YwXcfmZ74y63wLqBUEzLN6HKC2qhFk0giWd0xWRoyLHFayOoAJxQsPeoqx3lW8LkHNq0fK0b43rl60myq4i/vK6NOtNYYdpq+j2ZxhXl3ysGKqzP6Rb5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743584225; c=relaxed/simple;
	bh=eMocZbfwdDxtWsjHiSzzOZSnuSzJrcfLMsT04Ua/5ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0IxjhVjiiksjLrBFpyYUQqjGsAVQQDNcImJx30BIb1XnFUesyEwrlixiXHs2H/p9cbg7v8FQfyCnebVMlHexQBDkdpHc5z5+MfZDmDuwPLGTD74MF1mdvz1+UIug+rprETmYcbqVqZfMkQqXdJfiT5obwmS1tpLU8OgfTwzLKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GpY8s5eM; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4774611d40bso202461cf.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 01:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743584223; x=1744189023; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m5iA78/yZurmEltRRdW/uf+siD/f5GN0SyOgheLp9+Y=;
        b=GpY8s5eMBnzbNd7nZYE0clEP0jYG9L0N07idIkv8m8avi5gF2m6fXT8kf3vx6V3dak
         zlWbDvOpFOuj8aGlRoeZ7+S3ryXNf39V7P4OecSHygWXNL9QjDCpoD/91Gbb9EhWii1s
         oco03+IYL9fVg3GFVFJ8x8b+3WWa4Vm40BTvK5rLXaGctDcNFSqVgwhGEXODIvQ5ra0a
         VdvZoQWknGN5CXk5wV+N5g3hBXC6rFw3WyGKXpm2qrN+m1Cg/752uc06jm/P9WmIHyMV
         QG9+ibR3nMOSQ333T3b3dZhTYsHGM5PGDfAWec7rF8qwfDFWNrNVfTi9+HmiZBWUrqb1
         GJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743584223; x=1744189023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5iA78/yZurmEltRRdW/uf+siD/f5GN0SyOgheLp9+Y=;
        b=DMvUYMLLl+lKZ74gHDjEUmj7USkqqxty4+IKqpLhT27w2BocJCwJzXLQAMLvPWvyAE
         lFuNFDZmtqoviPNtMdjmMMTtIoMPTvxTFU46inHGeMcJSZYwKpsLcjgDbDABA0vvnQD7
         HbrYaTgIuhGl/Wh7zXFEIs2AfdlwpsJxjkhsW/93CUtEpnF6dGczo774Tu8D/KDmMAns
         xlW+ym+aINr2AT7IGAcXw5ZCol2i2GZI3CHID8CFpwJRxQEeTYuYnI4WwaP1tbEdJ7tC
         UAofGSkinppibUTG7Km26HXg6hnFtVwYQsP6hemh7VR/Od6TWXFsaS8qCgA8/SyMUw6L
         rRag==
X-Gm-Message-State: AOJu0YxJSEPeBy6t7CqkeRV9WksqE7bKt0Yew9rLWXLjzMoldYAgYE5Q
	fnRzL7SwJfo2sERT5iYnk6Bek3kjfW8UAeGxmfNJ24msC28zHyXx9sx0+PaYW61aDeMOAQ+upiJ
	QaY/ksYNWzcVEOFK5nIi3AjL5VPAVa6lSEqSo
X-Gm-Gg: ASbGnctoKX3Xl24oaF+DJWYoAyb/QFEX9vFWzkej73yvMwbnH8C/B6u/Wl1vVp8kEJI
	4jykLDGjUpVqv/YB0o1+3zzg0AeDFaNUuipUOHX/ximfaAG0j1k9x1RCgFfKx36zJOGQYd1T+hi
	xXZQXDN7w/t6qsvNxpRaNGdHDpueYBpW2rsrmr7BJxOrtkSkEJdWCF1g==
X-Google-Smtp-Source: AGHT+IFMTKEuvL6e2xcrh8KaPfFrhCp5Vu61ZzX0pTYvrTSHuSwEWdkkapnTZnUw//F3Ru98j861ZY4zhkBOorh2/Jw=
X-Received: by 2002:ac8:5847:0:b0:476:f4e9:314e with SMTP id
 d75a77b69052e-4790970660cmr2555471cf.25.1743584222699; Wed, 02 Apr 2025
 01:57:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318161823.4005529-10-tabba@google.com> <diqz34er23ql.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz34er23ql.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 2 Apr 2025 09:56:26 +0100
X-Gm-Features: AQ5f1Jr4jnEVAOjFid1RNVBv-AxFH88c8b48xrmOJ-wbYii36QQdgSCZv00f5kw
Message-ID: <CA+EHjTy7CT0k+m30KfEeV5W6fV-nW1VMXsPYGLhaCmrEaKOf7g@mail.gmail.com>
Subject: Re: [PATCH v7 9/9] KVM: guest_memfd: selftests: guest_memfd mmap()
 test when mapping is allowed
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
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Tue, 1 Apr 2025 at 18:25, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Expand the guest_memfd selftests to include testing mapping guest
> > memory for VM types that support it.
> >
> > Also, build the guest_memfd selftest for arm64.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
> >  .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++++++--
> >  2 files changed, 70 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> > index 4277b983cace..c9a3f30e28dd 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -160,6 +160,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
> >  TEST_GEN_PROGS_arm64 += demand_paging_test
> >  TEST_GEN_PROGS_arm64 += dirty_log_test
> >  TEST_GEN_PROGS_arm64 += dirty_log_perf_test
> > +TEST_GEN_PROGS_arm64 += guest_memfd_test
> >  TEST_GEN_PROGS_arm64 += guest_print_test
> >  TEST_GEN_PROGS_arm64 += get-reg-list
> >  TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> > index ce687f8d248f..38c501e49e0e 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -34,12 +34,48 @@ static void test_file_read_write(int fd)
> >                   "pwrite on a guest_mem fd should fail");
> >  }
> >
> > -static void test_mmap(int fd, size_t page_size)
> > +static void test_mmap_allowed(int fd, size_t total_size)
> >  {
> > +     size_t page_size = getpagesize();
> > +     const char val = 0xaa;
> > +     char *mem;
> > +     int ret;
> > +     int i;
>
> Was using this test with hugetlb patches - int i was overflowing and
> causing test failures.  Perhaps use size_t i for this instead?

I need to think big, or rather, huge (sorry :)) . Will fix this.

Cheers,
/fuad

> > +
> > +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> > +     TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
> > +
> > +     memset(mem, val, total_size);
> > +     for (i = 0; i < total_size; i++)
> > +             TEST_ASSERT_EQ(mem[i], val);
> > +
> > +     ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> > +                     page_size);
> > +     TEST_ASSERT(!ret, "fallocate the first page should succeed");
> > +
> > +     for (i = 0; i < page_size; i++)
> > +             TEST_ASSERT_EQ(mem[i], 0x00);
> > +     for (; i < total_size; i++)
> > +             TEST_ASSERT_EQ(mem[i], val);
> > +
> > +     memset(mem, val, total_size);
> > +     for (i = 0; i < total_size; i++)
> > +             TEST_ASSERT_EQ(mem[i], val);
> > +
> > +     ret = munmap(mem, total_size);
> > +     TEST_ASSERT(!ret, "munmap should succeed");
> > +}
> > +
> > +static void test_mmap_denied(int fd, size_t total_size)
> > +{
> > +     size_t page_size = getpagesize();
> >       char *mem;
> >
> >       mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >       TEST_ASSERT_EQ(mem, MAP_FAILED);
> > +
> > +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> > +     TEST_ASSERT_EQ(mem, MAP_FAILED);
> >  }
> >
> >  static void test_file_size(int fd, size_t page_size, size_t total_size)
> > @@ -170,19 +206,27 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> >       close(fd1);
> >  }
> >
> > -int main(int argc, char *argv[])
> > +unsigned long get_shared_type(void)
> >  {
> > -     size_t page_size;
> > +#ifdef __x86_64__
> > +     return KVM_X86_SW_PROTECTED_VM;
> > +#endif
> > +     return 0;
> > +}
> > +
> > +void test_vm_type(unsigned long type, bool is_shared)
> > +{
> > +     struct kvm_vm *vm;
> >       size_t total_size;
> > +     size_t page_size;
> >       int fd;
> > -     struct kvm_vm *vm;
> >
> >       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> >
> >       page_size = getpagesize();
> >       total_size = page_size * 4;
> >
> > -     vm = vm_create_barebones();
> > +     vm = vm_create_barebones_type(type);
> >
> >       test_create_guest_memfd_invalid(vm);
> >       test_create_guest_memfd_multiple(vm);
> > @@ -190,10 +234,29 @@ int main(int argc, char *argv[])
> >       fd = vm_create_guest_memfd(vm, total_size, 0);
> >
> >       test_file_read_write(fd);
> > -     test_mmap(fd, page_size);
> > +
> > +     if (is_shared)
> > +             test_mmap_allowed(fd, total_size);
> > +     else
> > +             test_mmap_denied(fd, total_size);
> > +
> >       test_file_size(fd, page_size, total_size);
> >       test_fallocate(fd, page_size, total_size);
> >       test_invalid_punch_hole(fd, page_size, total_size);
> >
> >       close(fd);
> > +     kvm_vm_release(vm);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +#ifndef __aarch64__
> > +     /* For now, arm64 only supports shared guest memory. */
> > +     test_vm_type(VM_TYPE_DEFAULT, false);
> > +#endif
> > +
> > +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> > +             test_vm_type(get_shared_type(), true);
> > +
> > +     return 0;
> >  }


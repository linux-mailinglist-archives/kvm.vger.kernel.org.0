Return-Path: <kvm+bounces-48385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55641ACDBF3
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 12:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17E6D7AA460
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 10:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631A428DB56;
	Wed,  4 Jun 2025 10:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pCIGbPmp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996DD28D8F0
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 10:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032746; cv=none; b=Dw2VuoVI346tTS9PJYlZnpe1Au84OR/vCjea7Z82DUtUCFZ/I6/G5pC1Ur3zq5i7dnI2xBZo+HBRtVxHpHVKgRiNpe4k6eibp5Bg4namsdUmhGqty+TK3XoTbxJZuZ3+oGoDhgpirLq7E9bSPNx+OWhUQaxn25nG2pUtt2Ds508=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032746; c=relaxed/simple;
	bh=53zu6sB9+Ww4FcaGWaE2erSa3kLqewxHCInOIfEvDus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IlaxLaWJo+aLYpuVNk3hP/MDLu7697nZEIk8de1DqNOYkrqS0QFPyVxJLTYcsjeo5+d2/E1sQrvDMCICjBBDlaYHOOH4j3DYzdeE0E1lbAglMkO245BFQj2TGWUqq7NF27aG0WeYEhnqEfp3+WSW/UmgEcw9EyY/cH84PX5E1+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pCIGbPmp; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47e9fea29easo333661cf.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 03:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749032743; x=1749637543; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bx+zioZGcPa31ofLwFoTS47Ar1db0gsST5uGb0svYrE=;
        b=pCIGbPmpFuwoypY893CtNVDJVS9c+RV5ZgASUTiQnD//zoPIX6cL/TSbHxjmNptb42
         KJ64Tal11EeXUQT0+Q9x/gDwz9WT3uA4xELO3ATS9Tx9EpdxNA4dP9kTpCKp5ITL/tKY
         mZwakqh+PhKsWXSguXcg4xtRFwXxgcBJBUcBDBA6mdMX2r5phR12kPW9UVQeofHVHT5B
         sDGGRTXoY9uBs0dNi4klq6A/qVviPSWyNLy6UfQuArtTuTqMCJBCxCucB+Ba1RY78s2r
         /OaK1HWi/fA8+PwhP8d+r7PfxZ6DeJ6VT14XLP+PGrnGhuxav/fUk1zA+lfsH+8LsP1Z
         HuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032743; x=1749637543;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bx+zioZGcPa31ofLwFoTS47Ar1db0gsST5uGb0svYrE=;
        b=KT9B3mNHUf13B6o97861PrMBOVIARwj7Pk8ZIieWsNCzIowWnaBcdXIXAl8biXoRMh
         bdAT3iuk9AOczyf8+ij8ke5tqAOUYJpeNwAH3Whii4vt/nElf+n38yIFGPRiIgsrNgxW
         UfUUmc95lnCZ4Tpn7imYWm4lyuCTEZH1M0+79tKaf/o9C4MrfD/SNFOQGPb31bKYci2p
         PoXaLU2Au9TjOYkNpJihi8ZQgrlwJX8Zr0+HsPQMfdvB4dOIeaFWdaoP65M1z/Nwec4k
         lSyiNc/RKOyQ+xs/Kdv+ixdG6O5jp0ItiJ+5u9ZPAYNhuc7JEbcZ9U6+yIps7wK85bgJ
         TwGw==
X-Gm-Message-State: AOJu0Yw4A7UgvQkwmgQL+7xZK2vQyUxMvUWkK/3iQd/JDW/k9YeU9n0k
	QiEhjiz+DgbY/cUQI3j+bF92P0FQdQ6UdeD5v8vNevBCMJ3Eemzm02V+x2nHnaPIi58xWioFFy+
	7AsjbOZ9kA8f5TiyS25jafdgx/a1noC5AfQz2dNax
X-Gm-Gg: ASbGncuFDv5Klq7pOYwqCzWqyX+Lh5FPzEVKYGw6K9WbXOih5XrOLIxBbFlxrkvdIMB
	ayXv08pa0ZweeBcNyI1pQhhpqE++X0jPDQ3tYfT7sy/GpecrkFa49sYdmHaOLtL5MT/pgkw0IjL
	j1V9pJatlaFMVHaVOdrig1Xwt8i5at2jXS12YNIg9Uu22qOKlwqKVp8Hq2Hmav7TENEKO3QREaX
	eW4643wHA==
X-Google-Smtp-Source: AGHT+IGTD+z2VDhxWQKuNp7nHIvCmBflEL2GXD3vKmU9zBOsititquGLHBhjmd+Y8sYdpHwVHeiU+YlZnp6EhX5jrRQ=
X-Received: by 2002:a05:622a:5513:b0:477:9a4:d7ea with SMTP id
 d75a77b69052e-4a5a60d620fmr2740811cf.13.1749032742765; Wed, 04 Jun 2025
 03:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-17-tabba@google.com>
 <025ae4ea-822b-44a1-8f78-38afc0e4b07e@redhat.com> <CA+EHjTyfrPw0FEfaiAkmDhyE1N9hm1fXoFwKrbxv3kiPiyZQaA@mail.gmail.com>
 <c4516f68-3451-4bae-ae0e-c69aaa4ad939@redhat.com>
In-Reply-To: <c4516f68-3451-4bae-ae0e-c69aaa4ad939@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 4 Jun 2025 11:25:06 +0100
X-Gm-Features: AX0GCFsjQj8t193ppNK5A8J6zJz7XEfKZShf8qW5ieQH44FDUzy_3f7OTVZ52RI
Message-ID: <CA+EHjTxWeXfY8vSyuVd_gEi_u3SxnHbuauZoNGorwkcEJEQxWw@mail.gmail.com>
Subject: Re: [PATCH v10 16/16] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Gavin Shan <gshan@redhat.com>
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Gavin,

On Wed, 4 Jun 2025 at 11:05, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 6/4/25 7:48 PM, Fuad Tabba wrote:
> > On Wed, 4 Jun 2025 at 10:20, Gavin Shan <gshan@redhat.com> wrote:
> >>
> >> On 5/28/25 4:02 AM, Fuad Tabba wrote:
> >>> Expand the guest_memfd selftests to include testing mapping guest
> >>> memory for VM types that support it.
> >>>
> >>> Also, build the guest_memfd selftest for arm64.
> >>>
> >>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> >>>    .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
> >>>    2 files changed, 142 insertions(+), 21 deletions(-)
> >>>
> >>
> >> The test case fails on 64KB host, and the file size in test_create_guest_memfd_multiple()
> >> would be page_size and (2 * page_size). The fixed size 4096 and 8192 aren't aligned to 64KB.
> >
> > Yes, however, this patch didn't introduce or modify this test. I think
> > it's better to fix it in a separate patch independent of this series.
> >
>
> Yeah, it can be separate patch or a preparatory patch before PATCH[16/16]
> of this series because x86 hasn't 64KB page size. The currently fixed sizes
> (4096 and 8192) are aligned to page size on x86. and 'guest-memfd-test' is
> enabled on arm64 by this series.

You're right. This patch enables support for arm64, so it should be
fixed in conjunction with that. As you suggested, I'll add a seperate
patch before this one that fixes this and enables support for arm64.

Thanks again!
/fuad

> >> # ./guest_memfd_test
> >> Random seed: 0x6b8b4567
> >> ==== Test Assertion Failure ====
> >>     guest_memfd_test.c:178: fd1 != -1
> >>     pid=7565 tid=7565 errno=22 - Invalid argument
> >>        1 0x000000000040252f: test_create_guest_memfd_multiple at guest_memfd_test.c:178
> >>        2  (inlined by) test_with_type at guest_memfd_test.c:231
> >>        3 0x00000000004020c7: main at guest_memfd_test.c:306
> >>        4 0x0000ffff8cec733f: ?? ??:0
> >>        5 0x0000ffff8cec7417: ?? ??:0
> >>        6 0x00000000004021ef: _start at ??:?
> >>     memfd creation should succeed
> >>
> >>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> >>> index f62b0a5aba35..ccf95ed037c3 100644
> >>> --- a/tools/testing/selftests/kvm/Makefile.kvm
> >>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> >>> @@ -163,6 +163,7 @@ TEST_GEN_PROGS_arm64 += access_tracking_perf_test
> >>>    TEST_GEN_PROGS_arm64 += arch_timer
> >>>    TEST_GEN_PROGS_arm64 += coalesced_io_test
> >>>    TEST_GEN_PROGS_arm64 += dirty_log_perf_test
> >>> +TEST_GEN_PROGS_arm64 += guest_memfd_test
> >>>    TEST_GEN_PROGS_arm64 += get-reg-list
> >>>    TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
> >>>    TEST_GEN_PROGS_arm64 += memslot_perf_test
> >>> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> >>> index ce687f8d248f..3d6765bc1f28 100644
> >>> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> >>> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> >>> @@ -34,12 +34,46 @@ static void test_file_read_write(int fd)
> >>>                    "pwrite on a guest_mem fd should fail");
> >>>    }
> >>>
> >>> -static void test_mmap(int fd, size_t page_size)
> >>> +static void test_mmap_allowed(int fd, size_t page_size, size_t total_size)
> >>> +{
> >>> +     const char val = 0xaa;
> >>> +     char *mem;
> >>> +     size_t i;
> >>> +     int ret;
> >>> +
> >>> +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >>> +     TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
> >>> +
> >>
> >> If you agree, I think it would be nice to ensure guest-memfd doesn't support
> >> copy-on-write, more details are provided below.
> >
> > Good idea. I think we can do this without adding much more code. I'll
> > add a check in test_mmap_allowed(), since the idea is, even if mmap()
> > is supported, we still can't COW. I'll rename the functions to make
> > this a bit clearer (i.e., supported instead of allowed).
> >
> > Thank you for this and thank you for the reviews!
> >
>
> Sounds good to me  :)
>
> >
> >>> +     memset(mem, val, total_size);
> >>> +     for (i = 0; i < total_size; i++)
> >>> +             TEST_ASSERT_EQ(mem[i], val);
> >>> +
> >>> +     ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> >>> +                     page_size);
> >>> +     TEST_ASSERT(!ret, "fallocate the first page should succeed");
> >>> +
> >>> +     for (i = 0; i < page_size; i++)
> >>> +             TEST_ASSERT_EQ(mem[i], 0x00);
> >>> +     for (; i < total_size; i++)
> >>> +             TEST_ASSERT_EQ(mem[i], val);
> >>> +
> >>> +     memset(mem, val, page_size);
> >>> +     for (i = 0; i < total_size; i++)
> >>> +             TEST_ASSERT_EQ(mem[i], val);
> >>> +
> >>> +     ret = munmap(mem, total_size);
> >>> +     TEST_ASSERT(!ret, "munmap should succeed");
> >>> +}
> >>> +
> >>> +static void test_mmap_denied(int fd, size_t page_size, size_t total_size)
> >>>    {
> >>>        char *mem;
> >>>
> >>>        mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >>>        TEST_ASSERT_EQ(mem, MAP_FAILED);
> >>> +
> >>> +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >>> +     TEST_ASSERT_EQ(mem, MAP_FAILED);
> >>>    }
> >>
> >> Add one more argument to test_mmap_denied as the flags passed to mmap().
> >>
> >> static void test_mmap_denied(int fd, size_t page_size, size_t total_size, int mmap_flags)
> >> {
> >>          mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, mmap_flags, fd, 0);
> >> }
> >>
> >>>
> >>>    static void test_file_size(int fd, size_t page_size, size_t total_size)
> >>> @@ -120,26 +154,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
> >>>        }
> >>>    }
> >>>
> >>> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> >>> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> >>> +                                               uint64_t guest_memfd_flags,
> >>> +                                               size_t page_size)
> >>>    {
> >>> -     size_t page_size = getpagesize();
> >>> -     uint64_t flag;
> >>>        size_t size;
> >>>        int fd;
> >>>
> >>>        for (size = 1; size < page_size; size++) {
> >>> -             fd = __vm_create_guest_memfd(vm, size, 0);
> >>> -             TEST_ASSERT(fd == -1 && errno == EINVAL,
> >>> +             fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
> >>> +             TEST_ASSERT(fd < 0 && errno == EINVAL,
> >>>                            "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
> >>>                            size);
> >>>        }
> >>> -
> >>> -     for (flag = BIT(0); flag; flag <<= 1) {
> >>> -             fd = __vm_create_guest_memfd(vm, page_size, flag);
> >>> -             TEST_ASSERT(fd == -1 && errno == EINVAL,
> >>> -                         "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> >>> -                         flag);
> >>> -     }
> >>>    }
> >>>
> >>>    static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> >>> @@ -170,30 +197,123 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> >>>        close(fd1);
> >>>    }
> >>>
> >>> -int main(int argc, char *argv[])
> >>> +#define GUEST_MEMFD_TEST_SLOT 10
> >>> +#define GUEST_MEMFD_TEST_GPA 0x100000000
> >>> +
> >>> +static bool check_vm_type(unsigned long vm_type)
> >>>    {
> >>> -     size_t page_size;
> >>> +     /*
> >>> +      * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> >>> +      * support guest_memfd have that support for the default VM type.
> >>> +      */
> >>> +     if (vm_type == VM_TYPE_DEFAULT)
> >>> +             return true;
> >>> +
> >>> +     return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> >>> +}
> >>> +
> >>> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> >>> +                        bool expect_mmap_allowed)
> >>> +{
> >>> +     struct kvm_vm *vm;
> >>>        size_t total_size;
> >>> +     size_t page_size;
> >>>        int fd;
> >>> -     struct kvm_vm *vm;
> >>>
> >>> -     TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> >>> +     if (!check_vm_type(vm_type))
> >>> +             return;
> >>>
> >>>        page_size = getpagesize();
> >>>        total_size = page_size * 4;
> >>>
> >>> -     vm = vm_create_barebones();
> >>> +     vm = vm_create_barebones_type(vm_type);
> >>>
> >>> -     test_create_guest_memfd_invalid(vm);
> >>>        test_create_guest_memfd_multiple(vm);
> >>> +     test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
> >>>
> >>> -     fd = vm_create_guest_memfd(vm, total_size, 0);
> >>> +     fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
> >>>
> >>>        test_file_read_write(fd);
> >>> -     test_mmap(fd, page_size);
> >>> +
> >>> +     if (expect_mmap_allowed)
> >>> +             test_mmap_allowed(fd, page_size, total_size);
> >>> +     else
> >>> +             test_mmap_denied(fd, page_size, total_size);
> >>> +
> >>
> >>          if (expect_mmap_allowed) {
> >>                  test_mmap_denied(fd, page_size, total_size, MAP_PRIVATE);
> >>                  test_mmap_allowed(fd, page_size, total_size);
> >>          } else {
> >>                  test_mmap_denied(fd, page_size, total_size, MAP_SHARED);
> >>          }
> >>
> >>>        test_file_size(fd, page_size, total_size);
> >>>        test_fallocate(fd, page_size, total_size);
> >>>        test_invalid_punch_hole(fd, page_size, total_size);
> >>>
> >>>        close(fd);
> >>> +     kvm_vm_release(vm);
> >>> +}
> >>> +
> >>> +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> >>> +                                         uint64_t expected_valid_flags)
> >>> +{
> >>> +     size_t page_size = getpagesize();
> >>> +     struct kvm_vm *vm;
> >>> +     uint64_t flag = 0;
> >>> +     int fd;
> >>> +
> >>> +     if (!check_vm_type(vm_type))
> >>> +             return;
> >>> +
> >>> +     vm = vm_create_barebones_type(vm_type);
> >>> +
> >>> +     for (flag = BIT(0); flag; flag <<= 1) {
> >>> +             fd = __vm_create_guest_memfd(vm, page_size, flag);
> >>> +
> >>> +             if (flag & expected_valid_flags) {
> >>> +                     TEST_ASSERT(fd >= 0,
> >>> +                                 "guest_memfd() with flag '0x%lx' should be valid",
> >>> +                                 flag);
> >>> +                     close(fd);
> >>> +             } else {
> >>> +                     TEST_ASSERT(fd < 0 && errno == EINVAL,
> >>> +                                 "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> >>> +                                 flag);
> >>> +             }
> >>> +     }
> >>> +
> >>> +     kvm_vm_release(vm);
> >>> +}
> >>> +
> >>> +static void test_gmem_flag_validity(void)
> >>> +{
> >>> +     uint64_t non_coco_vm_valid_flags = 0;
> >>> +
> >>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> >>> +             non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> >>> +
> >>> +     test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> >>> +
> >>> +#ifdef __x86_64__
> >>> +     test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_coco_vm_valid_flags);
> >>> +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> >>> +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> >>> +     test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> >>> +     test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> >>> +#endif
> >>> +}
> >>> +
> >>> +int main(int argc, char *argv[])
> >>> +{
> >>> +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> >>> +
> >>> +     test_gmem_flag_validity();
> >>> +
> >>> +     test_with_type(VM_TYPE_DEFAULT, 0, false);
> >>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> >>> +             test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPORT_SHARED,
> >>> +                            true);
> >>> +     }
> >>> +
> >>> +#ifdef __x86_64__
> >>> +     test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> >>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> >>> +             test_with_type(KVM_X86_SW_PROTECTED_VM,
> >>> +                            GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> >>> +     }
> >>> +#endif
> >>>    }
> >>
>
> Thanks,
> Gavin
>


Return-Path: <kvm+bounces-48610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB82EACF986
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FED8170DCB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB25927FB1E;
	Thu,  5 Jun 2025 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J9lRU4ND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5176027C864
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161278; cv=none; b=OlQfE1NnDf0jyouyrg2ZsrkKwqPQ8Nh1ZKNCStNyNQ1sTJXqnR1wjSgnHCOYF51IEVo1ABu5YIvxVqyXpt0BdXilDQZ9wwcgbT4sVavbApKtadEtnDAGHfz2JeApcXyzWHl8tuJjqQiy65DtK7y1e8BlnnLhxq+Xt1Nz/tbfGeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161278; c=relaxed/simple;
	bh=BqfvgA71iAaL5HIwAymg25RNSBjpWp8+0jyluj1Ilb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLMaE88VJzqfCy7mHGY2K6iitK9uVgWSYDWH8crrisIyIots31AwaZFjeuZqPyzg/vk9XoaOdyJRjv59n47JfeIkzcab7gM4E+461+LCHGJWYlBdZ/pnjY1IaLRRqZt8YSAg4UUOxGIQfai4GzFp8dnIURXgO5dzBaJLpwy/JeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J9lRU4ND; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e7db6aaef22so1247840276.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749161275; x=1749766075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnKZWTFx1r/r3bpI9eHGqslLc1oESYCbSdxu/x7viwQ=;
        b=J9lRU4ND7JthHu+5kGmJcFaCzO2/Oh/P+oH0SyNuaaLrr+xad0ahKezxNVq4W+Waug
         tF768I3W4bA99iaqzPzsDCss6ilAOzEq+FxzHHgWO+rVsBzmkDkTrv/Xib8JziUS7Uz4
         Urznov2RApTWmi3YiS4s8sQzL3WyXfLY088igZyktZyHK2MBYeR6YzwyNPtaCOqPnTQX
         wf9jE72ryG1btkFtMy5V+n32KoMwIrngj8bCZAbBzi/F3dJZ+G2HRwscGfJNsjoxzg0O
         YlafYIa+ZtjsGnunBJy+mx5rHuTAhVm0KJWktcIcHKFzl6AdF1UBI44jl+go+OAiGG7H
         r0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749161275; x=1749766075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnKZWTFx1r/r3bpI9eHGqslLc1oESYCbSdxu/x7viwQ=;
        b=fEK100bgT11TOhis70O+kLT9yu2WZSbK9lI5PwDhyc0pYALDl07ZUg8w6MxqDQybst
         Og7UOyWWoHFv2xdzDlYquG784AfuhwQ1mmi21rR+BzfjqiBCsN7E73LqtUQPm4U0lveM
         tNyu3T1uTW7a0252LA6YkL7BgV2M/FY5cOM8SeBngxzP0hBJC+eBdS1bHWNl5/c0Kd9O
         aAdCe7LHMXKv0P52KMHQrqdx8YHrBE8mmFmEnUYsU11TD9HQg6HI7xieXZMvnjuzmC3V
         jk1uwIDRvNscHo0s2kIxVAsRKq/GOwUCdCC6iZBnBKMhNC+XRfJkFjX10x5VvMyTg2Vx
         /W5g==
X-Gm-Message-State: AOJu0Yy6y2mo8bbELVhoec/+DivJ6WCWy+iXM2L/JCMSG48JL34Rkia6
	8fOqxLsiKeYR5O2gvr7abu/bLyTThDGWfFV1HEd3dxco4We6LFB6tHyhGJ9TNYJkqRkamoSpgfu
	97jhxTeYtavwlsAGau2pUUujzHh9rcm80t9fjzJnM
X-Gm-Gg: ASbGnctYtf4R8a8atWcUT1ymVJhzoHedb8F8BK4g1xL3W4Hd/JJSf1qhK9IGxQ1v3ke
	Xyb4K8PYQ3v0uOTGJfMmQzLW281PG5QDXuZkMb9E+eMHCbFfbrNNBhygDMiKZ73L/mOjczWSbAn
	vcqv9H54j8XQoKH9QBpQDv3yVd0j3iL2jPhUoMupCFFoeliiOtRfTxjL1e5Q82E7XnnZD+Wujk
X-Google-Smtp-Source: AGHT+IGq7lMGRK6rP20ELHAYuEiLr4LmheLkErrPUhfTNANU8S4aRAPfjJb3nPfn3laHUFkxC0Uyfu14q15f8dlPRus=
X-Received: by 2002:a05:6902:220b:b0:e7f:7352:bb30 with SMTP id
 3f1490d57ef6-e81a229b8d4mr2096060276.18.1749161274959; Thu, 05 Jun 2025
 15:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
In-Reply-To: <20250605153800.557144-19-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 15:07:19 -0700
X-Gm-Features: AX0GCFvZGdmOFMM-9Yc-PlTUSLHYGP-h7M0hdxQXdKrebyonS61n3MScTO4Qlao
Message-ID: <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
>
> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
>  1 file changed, 180 insertions(+), 21 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 341ba616cf55..1612d3adcd0d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,8 @@
>
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
> +#include <setjmp.h>
> +#include <signal.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
>                     "pwrite on a guest_mem fd should fail");
>  }
>
> -static void test_mmap(int fd, size_t page_size)
> +static void test_mmap_supported(int fd, size_t page_size, size_t total_s=
ize)
> +{
> +       const char val =3D 0xaa;
> +       char *mem;

This must be `volatile char *` to ensure that the compiler doesn't
elide the accesses you have written.

> +       size_t i;
> +       int ret;
> +
> +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVAT=
E, fd, 0);
> +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed by =
guest_memfd.");
> +
> +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED=
, fd, 0);
> +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memory =
should succeed.");
> +
> +       memset(mem, val, total_size);

Now unfortunately, `memset` and `munmap` will complain about the
volatile qualification. So...

memset((char *)mem, val, total_size);

Eh... wish they just wouldn't complain, but this is a small price to
pay for correctness. :)

> +       for (i =3D 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(mem[i], val);

The compiler is allowed to[1] elide the read of `mem[i]` and just
assume that it is `val`.

[1]: https://godbolt.org/z/Wora54bP6

Feel free to add `volatile` to that snippet to see how the code changes.

> +
> +       ret =3D fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,=
 0,
> +                       page_size);
> +       TEST_ASSERT(!ret, "fallocate the first page should succeed.");
> +
> +       for (i =3D 0; i < page_size; i++)
> +               TEST_ASSERT_EQ(mem[i], 0x00);
> +       for (; i < total_size; i++)
> +               TEST_ASSERT_EQ(mem[i], val);
> +
> +       memset(mem, val, page_size);
> +       for (i =3D 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(mem[i], val);
> +
> +       ret =3D munmap(mem, total_size);
> +       TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static sigjmp_buf jmpbuf;
> +void fault_sigbus_handler(int signum)
> +{
> +       siglongjmp(jmpbuf, 1);
> +}
> +
> +static void test_fault_overflow(int fd, size_t page_size, size_t total_s=
ize)
> +{
> +       struct sigaction sa_old, sa_new =3D {
> +               .sa_handler =3D fault_sigbus_handler,
> +       };
> +       size_t map_size =3D total_size * 4;
> +       const char val =3D 0xaa;
> +       char *mem;

`volatile` here as well.

> +       size_t i;
> +       int ret;
> +
> +       mem =3D mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, =
fd, 0);
> +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memory =
should succeed.");
> +
> +       sigaction(SIGBUS, &sa_new, &sa_old);
> +       if (sigsetjmp(jmpbuf, 1) =3D=3D 0) {
> +               memset(mem, 0xaa, map_size);
> +               TEST_ASSERT(false, "memset() should have triggered SIGBUS=
.");
> +       }
> +       sigaction(SIGBUS, &sa_old, NULL);
> +
> +       for (i =3D 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(mem[i], val);
> +
> +       ret =3D munmap(mem, map_size);
> +       TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static void test_mmap_not_supported(int fd, size_t page_size, size_t tot=
al_size)
>  {
>         char *mem;
>
>         mem =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED,=
 fd, 0);
>         TEST_ASSERT_EQ(mem, MAP_FAILED);
> +
> +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED=
, fd, 0);
> +       TEST_ASSERT_EQ(mem, MAP_FAILED);
>  }
>
>  static void test_file_size(int fd, size_t page_size, size_t total_size)
> @@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t =
page_size, size_t total_size)
>         }
>  }
>
> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> +                                                 uint64_t guest_memfd_fl=
ags,
> +                                                 size_t page_size)
>  {
> -       size_t page_size =3D getpagesize();
> -       uint64_t flag;
>         size_t size;
>         int fd;
>
>         for (size =3D 1; size < page_size; size++) {
> -               fd =3D __vm_create_guest_memfd(vm, size, 0);
> -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> +               fd =3D __vm_create_guest_memfd(vm, size, guest_memfd_flag=
s);
> +               TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
>                             "guest_memfd() with non-page-aligned page siz=
e '0x%lx' should fail with EINVAL",
>                             size);
>         }
> -
> -       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> -               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> -                           "guest_memfd() with flag '0x%lx' should fail =
with EINVAL",
> -                           flag);
> -       }
>  }
>
>  static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> @@ -171,30 +237,123 @@ static void test_create_guest_memfd_multiple(struc=
t kvm_vm *vm)
>         close(fd1);
>  }
>
> -int main(int argc, char *argv[])
> +static bool check_vm_type(unsigned long vm_type)
>  {
> -       size_t page_size;
> +       /*
> +        * Not all architectures support KVM_CAP_VM_TYPES. However, those=
 that
> +        * support guest_memfd have that support for the default VM type.
> +        */
> +       if (vm_type =3D=3D VM_TYPE_DEFAULT)
> +               return true;
> +
> +       return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> +}
> +
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_f=
lags,
> +                          bool expect_mmap_allowed)
> +{
> +       struct kvm_vm *vm;
>         size_t total_size;
> +       size_t page_size;
>         int fd;
> -       struct kvm_vm *vm;
>
> -       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +       if (!check_vm_type(vm_type))
> +               return;
>
>         page_size =3D getpagesize();
>         total_size =3D page_size * 4;
>
> -       vm =3D vm_create_barebones();
> +       vm =3D vm_create_barebones_type(vm_type);
>
> -       test_create_guest_memfd_invalid(vm);
>         test_create_guest_memfd_multiple(vm);
> +       test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page=
_size);
>
> -       fd =3D vm_create_guest_memfd(vm, total_size, 0);
> +       fd =3D vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
>
>         test_file_read_write(fd);
> -       test_mmap(fd, page_size);
> +
> +       if (expect_mmap_allowed) {
> +               test_mmap_supported(fd, page_size, total_size);
> +               test_fault_overflow(fd, page_size, total_size);
> +
> +       } else {
> +               test_mmap_not_supported(fd, page_size, total_size);
> +       }
> +
>         test_file_size(fd, page_size, total_size);
>         test_fallocate(fd, page_size, total_size);
>         test_invalid_punch_hole(fd, page_size, total_size);
>
>         close(fd);
> +       kvm_vm_release(vm);

I think kvm_vm_free() is probably more appropriate?

> +}
> +
> +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> +                                           uint64_t expected_valid_flags=
)
> +{
> +       size_t page_size =3D getpagesize();
> +       struct kvm_vm *vm;
> +       uint64_t flag =3D 0;
> +       int fd;
> +
> +       if (!check_vm_type(vm_type))
> +               return;
> +
> +       vm =3D vm_create_barebones_type(vm_type);
> +
> +       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> +               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> +
> +               if (flag & expected_valid_flags) {
> +                       TEST_ASSERT(fd >=3D 0,
> +                                   "guest_memfd() with flag '0x%lx' shou=
ld be valid",
> +                                   flag);
> +                       close(fd);
> +               } else {
> +                       TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
> +                                   "guest_memfd() with flag '0x%lx' shou=
ld fail with EINVAL",
> +                                   flag);
> +               }
> +       }
> +
> +       kvm_vm_release(vm);

Same here.

> +}
> +
> +static void test_gmem_flag_validity(void)
> +{
> +       uint64_t non_coco_vm_valid_flags =3D 0;
> +
> +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> +               non_coco_vm_valid_flags =3D GUEST_MEMFD_FLAG_SUPPORT_SHAR=
ED;
> +
> +       test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_vali=
d_flags);
> +
> +#ifdef __x86_64__
> +       test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_coco=
_vm_valid_flags);
> +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> +       test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> +       test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> +#endif
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +       test_gmem_flag_validity();
> +
> +       test_with_type(VM_TYPE_DEFAULT, 0, false);
> +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPORT_=
SHARED,
> +                              true);
> +       }
> +
> +#ifdef __x86_64__
> +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +               test_with_type(KVM_X86_SW_PROTECTED_VM,
> +                              GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> +       }
> +#endif
>  }
> --
> 2.49.0.1266.g31b7d2e469-goog
>


Return-Path: <kvm+bounces-48636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA4AACFE11
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44FB33AC817
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 08:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34CA285411;
	Fri,  6 Jun 2025 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CoUgvKLv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046B284B53
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 08:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749197700; cv=none; b=q4IM4Yj5bXoYW0OBH3TVAVRVmZ4E+K2tN+kJgr2N0vPVgtpdqYXQ8DVnw4c8snANh/UnAeUuR50k8udVlCKQm3C0+d58Z+RE/VWad9JfZ56MqoQPKjzbFacw4pbEi6JvBXFzF4/RosKGoYRGeohzIFR2m1PHfUjy6IMDauzYt3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749197700; c=relaxed/simple;
	bh=Sx2kRoA6540IBjmVa8iRjeggrCjDOHKI0hKp9zXnYLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DXflVOezDOEJ1KSK7CCGEWu1G71s3Ouhhblbwx9ExbG8C9slpPv2SrfxeVOtQrNdBL9Pk20c24myQeB3MMk2fMV64X0bgfL2VEz4oiGEi59SjqkyvH81A6C6QCyNaTCjxRilf13KC+l7m0S1R9zYc3tYBbJg2aI2nHRG6oZCNZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CoUgvKLv; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a5ac8fae12so317451cf.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 01:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749197696; x=1749802496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZ2a17s14DiwVXH5n9E8Jz+5/4EfpoYvUq0sk56Onz0=;
        b=CoUgvKLvaJDrid4hzcog15Inv6dR4KKgbchVav54QH5alXYY2JFP7QDbpoX0NG2CDC
         Efe18gUfqagOo/09sz3XHIniWWPi+BXTv020NrMLwdMSG77ZKJwdnNZz0XN0Ys/PLrcU
         kGD2zNsWMyDFYj9arGbVBLAO14b77YD/GfEL2lpDmfi56Jsqh/63dPyhqfEHnNEw+Qp1
         yyFLDwvFBFWi5Vka8yRARIfd4udNaHlUGfaFNkyeHaGqzlrkhWSMg0ZQfymWC3hT2lru
         dXbggYAu2wqcXnq28nOnfc3qlZSOxc+khHkJmXIebCvVQIZYLFGePK73cZ9Y36wIUjsh
         e6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749197696; x=1749802496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ2a17s14DiwVXH5n9E8Jz+5/4EfpoYvUq0sk56Onz0=;
        b=nI/axOW5uNrviKWhdvFLZUhfsefoT51k7/v7/EhcTaR1dthMPN+LGBJoMiUl6g2yQ3
         FtfDuMHEGdxjoSelfFmN8p99TKTE+lsxxjo4ldFLS67g2ROxfxhdR4pE0e7EUevtnt/v
         a0H7MC37SUG6+VQ988VBfR+1KjJt7EeSWCJqncXFAaGSYC8A/wDzgcQzreMz+ins3PQQ
         dtcaXMMxTCHgTAW5S0zMwjfX04f48Liz98QnGR8bUO5OPoQOvDex86Exfxky1NVvRTJY
         N8DR95Q9Jm0djIdXJLEFgxovOyft52TH3QsWU73aX7Mx4vrlu0H39AcFOgB527PloPV5
         o14A==
X-Gm-Message-State: AOJu0Yyi5a5ncg64uIXR7aRWImSCy7tJPgTsDbHKgpT3zJm7kzJ57Hrh
	PNoDF6zX5xp5SZBtsMTCv4Tqot36/5LVbdREX8ljhkLhHF208lG7PzLQn0p2c2jnzQFm61Cmc5P
	+DZLrBL4d7k2uYZ83C14VecnSbQJMRWe9GocC7erCyCpgZ0DmU8Bu0npXKzdn+g==
X-Gm-Gg: ASbGnct6K++ocHmTEQMN58At7m98Ht9Oa5Ib6ljR4O/cXfzGXY7vu3wTjHN/PCQcytD
	J6pJQkyCwisuyjYf9o3/fzdXQSfLEUe/Ti1qGVfUueV8evTl6N57FPTfG+ij1DG7IkCXy1pZG7r
	zbv3moJlhdR3HYKwt1ZIyDZ60KfXtTvchIGHMWdPj2lB0=
X-Google-Smtp-Source: AGHT+IHO3XbI99LEJ3DkrIqbK0UHqQBaguugDetIvvefVbiU0bjl6q1UARSnYMvGmv4Bofkpu6UiMgfxhbQchzD7XrI=
X-Received: by 2002:a05:622a:4d4e:b0:480:1561:837f with SMTP id
 d75a77b69052e-4a5baa64ae4mr3422191cf.8.1749197695571; Fri, 06 Jun 2025
 01:14:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
In-Reply-To: <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 09:14:18 +0100
X-Gm-Features: AX0GCFsF3bQ5ds5aybr1LYz7ilc6jmBKMPt-OX1Muc1KZq58VsL5O8r4L0rcIBQ
Message-ID: <CA+EHjTwHgAoGos+ZBzEPdkNPzLpX9t8nJLQ89YALPUw4LK4QTA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: James Houghton <jthoughton@google.com>
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

Hi James,

On Thu, 5 Jun 2025 at 23:07, James Houghton <jthoughton@google.com> wrote:
>
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> >
> > Expand the guest_memfd selftests to include testing mapping guest
> > memory for VM types that support it.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Feel free to add:
>
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!

> > ---
> >  .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
> >  1 file changed, 180 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/tes=
ting/selftests/kvm/guest_memfd_test.c
> > index 341ba616cf55..1612d3adcd0d 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -13,6 +13,8 @@
> >
> >  #include <linux/bitmap.h>
> >  #include <linux/falloc.h>
> > +#include <setjmp.h>
> > +#include <signal.h>
> >  #include <sys/mman.h>
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> >                     "pwrite on a guest_mem fd should fail");
> >  }
> >
> > -static void test_mmap(int fd, size_t page_size)
> > +static void test_mmap_supported(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       const char val =3D 0xaa;
> > +       char *mem;
>
> This must be `volatile char *` to ensure that the compiler doesn't
> elide the accesses you have written.
>
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIV=
ATE, fd, 0);
> > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed b=
y guest_memfd.");
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       memset(mem, val, total_size);
>
> Now unfortunately, `memset` and `munmap` will complain about the
> volatile qualification. So...
>
> memset((char *)mem, val, total_size);
>
> Eh... wish they just wouldn't complain, but this is a small price to
> pay for correctness. :)
>
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
>
> The compiler is allowed to[1] elide the read of `mem[i]` and just
> assume that it is `val`.
>
> [1]: https://godbolt.org/z/Wora54bP6
>
> Feel free to add `volatile` to that snippet to see how the code changes.

Having tried that and Sean's READ_ONCE() suggestion, I went with the
latter. Like Sean said, they're not optimised out, and avoid the need
to cast.

> > +
> > +       ret =3D fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOL=
E, 0,
> > +                       page_size);
> > +       TEST_ASSERT(!ret, "fallocate the first page should succeed.");
> > +
> > +       for (i =3D 0; i < page_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], 0x00);
> > +       for (; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       memset(mem, val, page_size);
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       ret =3D munmap(mem, total_size);
> > +       TEST_ASSERT(!ret, "munmap() should succeed.");
> > +}
> > +
> > +static sigjmp_buf jmpbuf;
> > +void fault_sigbus_handler(int signum)
> > +{
> > +       siglongjmp(jmpbuf, 1);
> > +}
> > +
> > +static void test_fault_overflow(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       struct sigaction sa_old, sa_new =3D {
> > +               .sa_handler =3D fault_sigbus_handler,
> > +       };
> > +       size_t map_size =3D total_size * 4;
> > +       const char val =3D 0xaa;
> > +       char *mem;
>
> `volatile` here as well.
>
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED=
, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       sigaction(SIGBUS, &sa_new, &sa_old);
> > +       if (sigsetjmp(jmpbuf, 1) =3D=3D 0) {
> > +               memset(mem, 0xaa, map_size);
> > +               TEST_ASSERT(false, "memset() should have triggered SIGB=
US.");
> > +       }
> > +       sigaction(SIGBUS, &sa_old, NULL);
> > +
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
> > +
> > +       ret =3D munmap(mem, map_size);
> > +       TEST_ASSERT(!ret, "munmap() should succeed.");
> > +}
> > +
> > +static void test_mmap_not_supported(int fd, size_t page_size, size_t t=
otal_size)
> >  {
> >         char *mem;
> >
> >         mem =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARE=
D, fd, 0);
> >         TEST_ASSERT_EQ(mem, MAP_FAILED);
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT_EQ(mem, MAP_FAILED);
> >  }
> >
> >  static void test_file_size(int fd, size_t page_size, size_t total_size=
)
> > @@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_=
t page_size, size_t total_size)
> >         }
> >  }
> >
> > -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> > +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> > +                                                 uint64_t guest_memfd_=
flags,
> > +                                                 size_t page_size)
> >  {
> > -       size_t page_size =3D getpagesize();
> > -       uint64_t flag;
> >         size_t size;
> >         int fd;
> >
> >         for (size =3D 1; size < page_size; size++) {
> > -               fd =3D __vm_create_guest_memfd(vm, size, 0);
> > -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> > +               fd =3D __vm_create_guest_memfd(vm, size, guest_memfd_fl=
ags);
> > +               TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
> >                             "guest_memfd() with non-page-aligned page s=
ize '0x%lx' should fail with EINVAL",
> >                             size);
> >         }
> > -
> > -       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> > -               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> > -               TEST_ASSERT(fd =3D=3D -1 && errno =3D=3D EINVAL,
> > -                           "guest_memfd() with flag '0x%lx' should fai=
l with EINVAL",
> > -                           flag);
> > -       }
> >  }
> >
> >  static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> > @@ -171,30 +237,123 @@ static void test_create_guest_memfd_multiple(str=
uct kvm_vm *vm)
> >         close(fd1);
> >  }
> >
> > -int main(int argc, char *argv[])
> > +static bool check_vm_type(unsigned long vm_type)
> >  {
> > -       size_t page_size;
> > +       /*
> > +        * Not all architectures support KVM_CAP_VM_TYPES. However, tho=
se that
> > +        * support guest_memfd have that support for the default VM typ=
e.
> > +        */
> > +       if (vm_type =3D=3D VM_TYPE_DEFAULT)
> > +               return true;
> > +
> > +       return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> > +}
> > +
> > +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd=
_flags,
> > +                          bool expect_mmap_allowed)
> > +{
> > +       struct kvm_vm *vm;
> >         size_t total_size;
> > +       size_t page_size;
> >         int fd;
> > -       struct kvm_vm *vm;
> >
> > -       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +       if (!check_vm_type(vm_type))
> > +               return;
> >
> >         page_size =3D getpagesize();
> >         total_size =3D page_size * 4;
> >
> > -       vm =3D vm_create_barebones();
> > +       vm =3D vm_create_barebones_type(vm_type);
> >
> > -       test_create_guest_memfd_invalid(vm);
> >         test_create_guest_memfd_multiple(vm);
> > +       test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, pa=
ge_size);
> >
> > -       fd =3D vm_create_guest_memfd(vm, total_size, 0);
> > +       fd =3D vm_create_guest_memfd(vm, total_size, guest_memfd_flags)=
;
> >
> >         test_file_read_write(fd);
> > -       test_mmap(fd, page_size);
> > +
> > +       if (expect_mmap_allowed) {
> > +               test_mmap_supported(fd, page_size, total_size);
> > +               test_fault_overflow(fd, page_size, total_size);
> > +
> > +       } else {
> > +               test_mmap_not_supported(fd, page_size, total_size);
> > +       }
> > +
> >         test_file_size(fd, page_size, total_size);
> >         test_fallocate(fd, page_size, total_size);
> >         test_invalid_punch_hole(fd, page_size, total_size);
> >
> >         close(fd);
> > +       kvm_vm_release(vm);
>
> I think kvm_vm_free() is probably more appropriate?

Ack (for both).

Cheers,
/fuad

> > +}
> > +
> > +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> > +                                           uint64_t expected_valid_fla=
gs)
> > +{
> > +       size_t page_size =3D getpagesize();
> > +       struct kvm_vm *vm;
> > +       uint64_t flag =3D 0;
> > +       int fd;
> > +
> > +       if (!check_vm_type(vm_type))
> > +               return;
> > +
> > +       vm =3D vm_create_barebones_type(vm_type);
> > +
> > +       for (flag =3D BIT(0); flag; flag <<=3D 1) {
> > +               fd =3D __vm_create_guest_memfd(vm, page_size, flag);
> > +
> > +               if (flag & expected_valid_flags) {
> > +                       TEST_ASSERT(fd >=3D 0,
> > +                                   "guest_memfd() with flag '0x%lx' sh=
ould be valid",
> > +                                   flag);
> > +                       close(fd);
> > +               } else {
> > +                       TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
> > +                                   "guest_memfd() with flag '0x%lx' sh=
ould fail with EINVAL",
> > +                                   flag);
> > +               }
> > +       }
> > +
> > +       kvm_vm_release(vm);
>
> Same here.
>
> > +}
> > +
> > +static void test_gmem_flag_validity(void)
> > +{
> > +       uint64_t non_coco_vm_valid_flags =3D 0;
> > +
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> > +               non_coco_vm_valid_flags =3D GUEST_MEMFD_FLAG_SUPPORT_SH=
ARED;
> > +
> > +       test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_va=
lid_flags);
> > +
> > +#ifdef __x86_64__
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_co=
co_vm_valid_flags);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> > +       test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> > +#endif
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +
> > +       test_gmem_flag_validity();
> > +
> > +       test_with_type(VM_TYPE_DEFAULT, 0, false);
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> > +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPOR=
T_SHARED,
> > +                              true);
> > +       }
> > +
> > +#ifdef __x86_64__
> > +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> > +       if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> > +               test_with_type(KVM_X86_SW_PROTECTED_VM,
> > +                              GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> > +       }
> > +#endif
> >  }
> > --
> > 2.49.0.1266.g31b7d2e469-goog
> >


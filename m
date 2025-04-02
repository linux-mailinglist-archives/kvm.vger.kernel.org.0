Return-Path: <kvm+bounces-42514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FADBA7974E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 23:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81CD61894750
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFE71F3FF4;
	Wed,  2 Apr 2025 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZWQK9Vr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696AB42A87
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743628263; cv=none; b=dsWmDHXMTJ7jsDpTe8bKuHPdS+1w0aMt15GyICSxKlKmkUY6Yvt8VJbC7xzS0KGeP4hXqRNNulaebVeNRJWDE5qGwUkZNiQWN2RvvPEmFjMObl3vUHSKcO2dHK5/QxNNwIS3yk7i3EbogJLi+5dAZQ5l6f8gClD0pLxWjmytezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743628263; c=relaxed/simple;
	bh=ETyIlupNzGiV9Nk5VRviQjoACogh2cw1bNs1XxsoM3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZRpPEIfjUjKK2kRT35RAyzgUmyQXpu7e3GWL372uVf2YegCRsTV5JcHQuj+nAGiTfge6TsyYMUgD7X7CLDsUQbgijdaekEhYkvVRhj4AlJ3vmr2nbaMfWlE4ZR6+QMEe/SUTAEb6pbozyOKxUnw687wDElUlGFO9RnfaEYhOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZWQK9Vr; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e63504bedd0so207548276.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 14:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743628259; x=1744233059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHlEMV0U9vFR86q2j1+99Qrtz2VZz1COboeDVfMSzm4=;
        b=AZWQK9Vr8cHjaZjBVv6z/Neunk0VsvAerRNka10/JCgvrvVGYMWqESegqKGePOV/DG
         U5ZfAu5O+NfgNI1cLOoMIcZEKpklsS9dsg0Q0X87v30BBNsrOrE/JfmfsNQzkCV2a4eQ
         9GNEY7GRrkNzG/zugB7D/iJA049WiaPDesf8WS6lFdlAWGZ6/JF/bxM4PGtOKDF0rveS
         rK8oIYG6WFSQSO7JiQ7w/flj+xRoBJOZVymi9tNtlZAagNis86ZjgFC3OSFIBJ+h5z/y
         Hnll7VU7nMofC5VBvdIAfHICO7a4v1znP5PH+ycwEsIkOCeNsVR/i+ByHRU+G5Mz0M3C
         QqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743628259; x=1744233059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHlEMV0U9vFR86q2j1+99Qrtz2VZz1COboeDVfMSzm4=;
        b=LNImFU5hv9gdWkE/YiG18fTVIotaxbR3qDFo4kBYdxv4k7Z5LQ3zMicmB5qiUVchat
         gPjeplevgoRWEOZ6sLrDiwQmoVpGcmz1sQNlgW+6BB5BARx0nHwwd1wzPHELto9J4MWo
         h4JrsEFBSV6ZmFgWWYunt11qEayqv1piTY7z0JfmXsJdVHLPRNGFefGeFFqrybldPSW4
         MIRFPvofZbPZ3jpwRB1Jvb5Ac4Bn1hmZgyqbY8qacrPu6/1NWrr7Fc41FzRoH25Sdl0F
         q+bD8vd0obFGNozjW5dgYau/NP36MwMUUuO2A74+KLOmFADez/yTYneOhnKCfWeKg253
         kcbw==
X-Forwarded-Encrypted: i=1; AJvYcCV+9Agz1anW/AZOmPtRxQ4V3wCjCgtz27cuCmu9c9EtNLf/tX37vbxWUGfr2beF7pDfq3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvnl4TjVNwmpgQJ6VOdbDMLbw+gbtySEm1XjxCEC3xqXGDhJzI
	v237uMqZwY/Cv2+v8wWq5la2ZEubSdsLf/LZv9RFl16K8ZQ4lwVT92FsNed1AHi27KoFLP9Tbe1
	WjAjj6Ah37Ai0OiZXWvlAYHVtPrGlZZ7Ia7fz
X-Gm-Gg: ASbGncsTHc7viS+kXw3B9LIS9C/YFRIDDsuABQetWkc/HXEB100dPABD62LU1UGh1Mq
	MjiT1Yd/pFMdMImP0U0jNXrT5Xb59Nkd8yFbmo3QEls45Hg+rDhWmj8gyD9POWIR8PZfYpCqrIo
	vJ2atAhVLmOOKlfYkSSEbu82Ej8qYLG0Zq2Y3MFC2Db2ZeOCm6haX0wu6V8ZpSUJdrRg==
X-Google-Smtp-Source: AGHT+IErG7MiwhU3qRRn1slMSsE9CshkjX1Paa6gShbPemf8jIhSuKCfwVzgM+xEObkQjSGtzZ8Yb+0m8SB916dMXqc=
X-Received: by 2002:a05:690c:6a07:b0:702:591a:6958 with SMTP id
 00721157ae682-703a3ef8605mr132532867b3.22.1743628259110; Wed, 02 Apr 2025
 14:10:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402160721.97596-1-kalyazin@amazon.com> <20250402160721.97596-6-kalyazin@amazon.com>
In-Reply-To: <20250402160721.97596-6-kalyazin@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 2 Apr 2025 14:10:23 -0700
X-Gm-Features: AQ5f1Jo-fVQJh8iuxBPV3y8brIkvlN4bXw45TOiqX1XQbY00SvkGkBQRYA970fY
Message-ID: <CADrL8HXm_UDKvrsNe6Guvo_pPvCN9ZJBKe=p0HM-iYZWufbEfA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: selftests: test userfaultfd minor for guest_memfd
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, ryan.roberts@arm.com, quic_eberman@quicinc.com, 
	peterx@redhat.com, graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, 
	derekmn@amazon.com, nsaenz@amazon.es, xmarcalx@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 9:08=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.com=
> wrote:
>
> The test demonstrates that a minor userfaultfd event in guest_memfd can
> be resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 38c501e49e0e..9b47b796f3aa 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -10,12 +10,16 @@
>  #include <errno.h>
>  #include <stdio.h>
>  #include <fcntl.h>
> +#include <pthread.h>
>
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
> +#include <linux/userfaultfd.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <sys/ioctl.h>
>
>  #include "kvm_util.h"
>  #include "test_util.h"
> @@ -206,6 +210,93 @@ static void test_create_guest_memfd_multiple(struct =
kvm_vm *vm)
>         close(fd1);
>  }
>
> +struct fault_args {
> +       char *addr;
> +       volatile char value;

I think you should/must put volatile on `addr` and not on `value`.

> +};
> +
> +static void *fault_thread_fn(void *arg)
> +{
> +       struct fault_args *args =3D arg;
> +
> +       /* Trigger page fault */
> +       args->value =3D *args->addr;
> +       return NULL;
> +}
> +
> +static void test_uffd_missing(int fd, size_t page_size, size_t total_siz=
e)

test_uffd_minor? :)

> +{
> +       struct uffdio_register uffd_reg;
> +       struct uffdio_continue uffd_cont;
> +       struct uffd_msg msg;
> +       struct fault_args args;
> +       pthread_t fault_thread;
> +       void *mem, *mem_nofault, *buf =3D NULL;
> +       int uffd, ret;
> +       off_t offset =3D page_size;
> +       void *fault_addr;
> +
> +       ret =3D posix_memalign(&buf, page_size, total_size);
> +       TEST_ASSERT_EQ(ret, 0);
> +
> +       uffd =3D syscall(__NR_userfaultfd, O_CLOEXEC);
> +       TEST_ASSERT(uffd !=3D -1, "userfaultfd creation should succeed");
> +
> +       struct uffdio_api uffdio_api =3D {
> +               .api =3D UFFD_API,
> +               .features =3D UFFD_FEATURE_MISSING_SHMEM,

I think you mean UFFD_FEATURE_MINOR_SHMEM...?

And I'm trying to think through what feature we should expose for
guest_memfd; UFFD_FEATURE_MINOR_SHMEM already indicates support for
shmem.

We could have UFFD_FEATURE_MINOR_GUESTMEMFD, perhaps that's enough.

Or we could have UFFD_FEATURE_MINOR_GENERIC (or nothing at all!). Some
VMAs might not support the minor mode, and the user will figure that
out when UFFDIO_REGISTER fails.

> +       };
> +       ret =3D ioctl(uffd, UFFDIO_API, &uffdio_api);
> +       TEST_ASSERT(ret !=3D -1, "ioctl(UFFDIO_API) should succeed");
> +
> +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED=
, fd, 0);
> +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap should succeed");
> +
> +       mem_nofault =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MA=
P_SHARED, fd, 0);
> +       TEST_ASSERT(mem_nofault !=3D MAP_FAILED, "mmap should succeed");
> +
> +       uffd_reg.range.start =3D (unsigned long)mem;
> +       uffd_reg.range.len =3D total_size;
> +       uffd_reg.mode =3D UFFDIO_REGISTER_MODE_MINOR;
> +       ret =3D ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
> +       TEST_ASSERT(ret !=3D -1, "ioctl(UFFDIO_REGISTER) should succeed")=
;
> +
> +       ret =3D fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
> +                       offset, page_size);
> +       TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
> +
> +       fault_addr =3D mem + offset;
> +       args.addr =3D fault_addr;
> +
> +       ret =3D pthread_create(&fault_thread, NULL, fault_thread_fn, &arg=
s);
> +       TEST_ASSERT(ret =3D=3D 0, "pthread_create should succeed");
> +
> +       ret =3D read(uffd, &msg, sizeof(msg));
> +       TEST_ASSERT(ret !=3D -1, "read from userfaultfd should succeed");
> +       TEST_ASSERT(msg.event =3D=3D UFFD_EVENT_PAGEFAULT, "event type sh=
ould be pagefault");
> +       TEST_ASSERT((void *)(msg.arg.pagefault.address & ~(page_size - 1)=
) =3D=3D fault_addr,
> +                   "pagefault should occur at expected address");
> +
> +       memcpy(mem_nofault + offset, buf + offset, page_size);
> +
> +       uffd_cont.range.start =3D (unsigned long)fault_addr;
> +       uffd_cont.range.len =3D page_size;
> +       uffd_cont.mode =3D 0;
> +       ret =3D ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
> +       TEST_ASSERT(ret !=3D -1, "ioctl(UFFDIO_CONTINUE) should succeed")=
;
> +
> +       ret =3D pthread_join(fault_thread, NULL);
> +       TEST_ASSERT(ret =3D=3D 0, "pthread_join should succeed");

And maybe also:

/* Right value? */
TEST_ASSERT(args.value =3D=3D *(char *)mem_nofault));
/* No second fault? */
TEST_ASSERT(args.value =3D=3D *(char *)mem);

> +
> +       ret =3D munmap(mem_nofault, total_size);
> +       TEST_ASSERT(!ret, "munmap should succeed");
> +
> +       ret =3D munmap(mem, total_size);
> +       TEST_ASSERT(!ret, "munmap should succeed");
> +       free(buf);
> +       close(uffd);
> +}
> +
>  unsigned long get_shared_type(void)
>  {
>  #ifdef __x86_64__
> @@ -244,6 +335,9 @@ void test_vm_type(unsigned long type, bool is_shared)
>         test_fallocate(fd, page_size, total_size);
>         test_invalid_punch_hole(fd, page_size, total_size);
>
> +       if (is_shared)
> +               test_uffd_missing(fd, page_size, total_size);
> +
>         close(fd);
>         kvm_vm_release(vm);
>  }
> --
> 2.47.1
>


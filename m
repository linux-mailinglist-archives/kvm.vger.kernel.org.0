Return-Path: <kvm+bounces-58965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F5FBA88B7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31ED81C13D6
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3E2283FF5;
	Mon, 29 Sep 2025 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSZKum3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135B28151E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137210; cv=none; b=KOo1fGdOr1mvqP3OWQ4werA4fJLTefbr9LBWYfced88Mw6bhO3Kw39C1XiIfhS61+HSK0UjXPCZI+gOV47UDvBNqRyTOO9rNLT6t1ngOfXb4KJZnoACZJM4c65LP8nO08YZmvRZp0zt9Z6bV9ax6j0RKCVIaHHvow6xml7Wb4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137210; c=relaxed/simple;
	bh=kfRmMM1BYJ593+fWR1aAK9u6Y4dZysJKSjulrs77UdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F4+zuvnXnTwh/I2WOSD0W7MMZ5KcEOw7W9ekSqpfIvRjsq6YayYzdpxOflbqs5zVLivHhSEiv0WnQxKg/S70rPXQmci67wmn6OVAmbv38GRU1kf6wjyp4YvhFQjITeIRKNfJIkjT7dN5SpPNDcRPccJ4qZEoqUtNN48+//uEP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSZKum3Y; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4dcc9cebfdfso511711cf.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759137207; x=1759742007; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=swhsoDPq756YHoIlnRJ5QQxspl/5XWOYmhcskeue14o=;
        b=nSZKum3Yo/I9vduBv0UhgbIJ0lGlPR+h3YAMQuHHCJfHsRYwQNRY2a+0CLtnNjtMOv
         oBpugyrm8+bTqBmd5aFe0iUFQl0vCTNIPRpzgUokqK5kmntMkA3X2YBweygtT8PUSLwG
         vHKLpshIjktZytEfpMM+7Bp3T2pLy42JLpYdbk9SsyYKMiaKk+zy2ueqqa70I2yIbkSy
         atg/WXkXFTd8nH9lpDMEl+P0w+xaG07hfy11gLjPiMaupPHfr4Vip1znTNrBYrGVLPis
         lYeHjJCmQixdanKFqO+4B/vohGzKZ0s7IZtJVs8EnOqThNlH13ZUrsqc0c/89F11nJ3n
         4cHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137207; x=1759742007;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swhsoDPq756YHoIlnRJ5QQxspl/5XWOYmhcskeue14o=;
        b=TIyNtZBapiptUPPP9d+MROcRnA+xG8KqfDocZ80zxlp0CJGVIXVIMAYMjHwQDNpgfa
         83003h+cSPQgcXD+gVkc9zk3oieizHwkPSQBrrLaHIxOc9/xhBvHQl/bdRI0h6kqnSjN
         MIbJLHnMXiph7AIPqCxt+AKAvLc+JnEkNb9w31d/863EjUoGYv7gCz05EEerwid/ojsM
         vgj9UVYpoQ7Dsq/pcoe5J7WLEIRJe5kQh0y3O+LhZ1/mJO7xzRMofN+INAygg4IeVg4+
         aBI17mXSuniRA5CMWvfjWwvYRsBdzS90JACP+YRvsO4DW+Fg2lKL9xkt0e/FSLHq2yOk
         S9cg==
X-Forwarded-Encrypted: i=1; AJvYcCVHVh0qsNwlF6jzujw+gJNUmDCQ60pCIOY9AYpH7rXvRRpXVeLw4kzl2X55W4KGUk1dJX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP0opEYLAStHhioOlqscb6bMQLet59Cy6pFjsOAN1NgFM4HnHh
	gbI7J/yb+zYJIuLjOheBzXAewi+ZLCE++ogTvxPeCQHm+G+5pCxKxQsc1PAVimtgDU9yOOTzLbb
	xsF5/cD4azLbsVyckpLp21PbG4rl0/AtKJZDFHBY2
X-Gm-Gg: ASbGnctnPSUEvh7z3dFFEso8OImVlh+3vwM8Xk+8ePql01wemQwV+EyIKj/97LJsGEX
	QF4x7l+ZNCzBGv0ZZpWkPH8OerOZ743pQ3Gz8GluHW/Cm0WWssvM3nPT3aoKh0IcTCISXJqvLnH
	9R4MhYpGY29SYrpn/AH8ey9cWJHBRljYjyYRPXNmMzVK7Xdf28U+9hCIqMczbmbjHdsvRvHquz1
	b3haCsTMyQqxTlT+XM6YNvoHw==
X-Google-Smtp-Source: AGHT+IFQwe+CAe0ndx2Viy2wXEeDbjN0wq3Lupw6VWv04BbTp/4nTa+InhdrQfrJNoG4xCYSkPcY/cw20ZMXemhF5pU=
X-Received: by 2002:ac8:5751:0:b0:4cf:dc5c:8c76 with SMTP id
 d75a77b69052e-4e25a26d390mr304531cf.11.1759137207074; Mon, 29 Sep 2025
 02:13:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-3-seanjc@google.com>
In-Reply-To: <20250926163114.2626257-3-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 29 Sep 2025 10:12:50 +0100
X-Gm-Features: AS18NWD58ndYv0_sCqOB9vkJN91S5AuHXUSz23T6U0EHwxhu8kxlC3vuU2B-c-k
Message-ID: <CA+EHjTxbHnWDKW14_DWu5RVPdEpgfwYkN8TEBBNSqv=8zp9uCg@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: selftests: Stash the host page size in a global
 in the guest_memfd test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>
> Use a global variable to track the host page size in the guest_memfd test
> so that the information doesn't need to be constantly passed around.  The
> state is purely a reflection of the underlying system, i.e. can't be set
> by the test and is constant for a given invocation of the test, and thus
> explicitly passing the host page size to individual testcases adds no
> value, e.g. doesn't allow testing different combinations.
>
> Making page_size a global will simplify an upcoming change to create a new
> guest_memfd instance per testcase.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 37 +++++++++----------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 81b11a958c7a..8251d019206a 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -24,6 +24,8 @@
>  #include "test_util.h"
>  #include "ucall_common.h"
>
> +static size_t page_size;
> +
>  static void test_file_read_write(int fd)
>  {
>         char buf[64];
> @@ -38,7 +40,7 @@ static void test_file_read_write(int fd)
>                     "pwrite on a guest_mem fd should fail");
>  }
>
> -static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
> +static void test_mmap_supported(int fd, size_t total_size)
>  {
>         const char val = 0xaa;
>         char *mem;
> @@ -78,7 +80,7 @@ void fault_sigbus_handler(int signum)
>         siglongjmp(jmpbuf, 1);
>  }
>
> -static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
> +static void test_fault_overflow(int fd, size_t total_size)
>  {
>         struct sigaction sa_old, sa_new = {
>                 .sa_handler = fault_sigbus_handler,
> @@ -106,7 +108,7 @@ static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
>         TEST_ASSERT(!ret, "munmap() should succeed.");
>  }
>
> -static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
> +static void test_mmap_not_supported(int fd, size_t total_size)
>  {
>         char *mem;
>
> @@ -117,7 +119,7 @@ static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
>         TEST_ASSERT_EQ(mem, MAP_FAILED);
>  }
>
> -static void test_file_size(int fd, size_t page_size, size_t total_size)
> +static void test_file_size(int fd, size_t total_size)
>  {
>         struct stat sb;
>         int ret;
> @@ -128,7 +130,7 @@ static void test_file_size(int fd, size_t page_size, size_t total_size)
>         TEST_ASSERT_EQ(sb.st_blksize, page_size);
>  }
>
> -static void test_fallocate(int fd, size_t page_size, size_t total_size)
> +static void test_fallocate(int fd, size_t total_size)
>  {
>         int ret;
>
> @@ -165,7 +167,7 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
>         TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
>  }
>
> -static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
> +static void test_invalid_punch_hole(int fd, size_t total_size)
>  {
>         struct {
>                 off_t offset;
> @@ -196,8 +198,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
>  }
>
>  static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> -                                                 uint64_t guest_memfd_flags,
> -                                                 size_t page_size)
> +                                                 uint64_t guest_memfd_flags)
>  {
>         size_t size;
>         int fd;
> @@ -214,7 +215,6 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>  {
>         int fd1, fd2, ret;
>         struct stat st1, st2;
> -       size_t page_size = getpagesize();
>
>         fd1 = __vm_create_guest_memfd(vm, page_size, 0);
>         TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
> @@ -241,7 +241,6 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>
>  static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
>  {
> -       size_t page_size = getpagesize();
>         uint64_t flag;
>         int fd;
>
> @@ -265,10 +264,8 @@ static void test_guest_memfd(unsigned long vm_type)
>         uint64_t flags = 0;
>         struct kvm_vm *vm;
>         size_t total_size;
> -       size_t page_size;
>         int fd;
>
> -       page_size = getpagesize();
>         total_size = page_size * 4;
>
>         vm = vm_create_barebones_type(vm_type);
> @@ -277,22 +274,22 @@ static void test_guest_memfd(unsigned long vm_type)
>                 flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>
>         test_create_guest_memfd_multiple(vm);
> -       test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
> +       test_create_guest_memfd_invalid_sizes(vm, flags);
>
>         fd = vm_create_guest_memfd(vm, total_size, flags);
>
>         test_file_read_write(fd);
>
>         if (flags & GUEST_MEMFD_FLAG_MMAP) {
> -               test_mmap_supported(fd, page_size, total_size);
> -               test_fault_overflow(fd, page_size, total_size);
> +               test_mmap_supported(fd, total_size);
> +               test_fault_overflow(fd, total_size);
>         } else {
> -               test_mmap_not_supported(fd, page_size, total_size);
> +               test_mmap_not_supported(fd, total_size);
>         }
>
> -       test_file_size(fd, page_size, total_size);
> -       test_fallocate(fd, page_size, total_size);
> -       test_invalid_punch_hole(fd, page_size, total_size);
> +       test_file_size(fd, total_size);
> +       test_fallocate(fd, total_size);
> +       test_invalid_punch_hole(fd, total_size);
>
>         test_guest_memfd_flags(vm, flags);
>
> @@ -367,6 +364,8 @@ int main(int argc, char *argv[])
>
>         TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>
> +       page_size = getpagesize();
> +
>         /*
>          * Not all architectures support KVM_CAP_VM_TYPES. However, those that
>          * support guest_memfd have that support for the default VM type.
> --
> 2.51.0.536.g15c5d4f767-goog
>


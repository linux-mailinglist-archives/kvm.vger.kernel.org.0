Return-Path: <kvm+bounces-58972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5343BA89E1
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7C523B538A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE662C234F;
	Mon, 29 Sep 2025 09:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b713UB49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B96A2C21DB
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137914; cv=none; b=Mp7w/afDB53aE2K7PW75ZwFikrN8eP+ofAttrdh2yTU/H3S4XkV2J7RD+HFKVspCVzEnUztV5yPKSZ0B+nABJAQAvD3g5fec1HTc9f2sGkyaKHL9TCY8nlcRwWOoo4n+jY/600zr2M7z3gJf7+IElz+N4v6gnsbetwmnAri5Sf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137914; c=relaxed/simple;
	bh=Mhiwglh83dR/SnDGLaM9PVdMb7cpWmQ01Cx2/nPr060=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nu8JXg/3F7nWD/Zv1V5uVXctTtF9I38Phg4VMbq2a/V0rKAnYQ3I8A0qNPQlSHFWXcXJq/gqk+YXzLv427NHwyzxCUdo0m4R1bBXNdSyXCpHBQiPnyBqGLL0F8jMTycY/2cufdUsnipwSQ3njbbgeqECyX5f/A7VM/slvGwFcns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b713UB49; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4de60f19a57so787711cf.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759137911; x=1759742711; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rGkigfAyqdYVUscR7ZUffIIH2bgyKFFHO2VMToDJdps=;
        b=b713UB49Jkyo1SV9oF2mDKI+w7MN/hwTvWPfVC9NEA85Az0QN0mamTj07+V7+w/Qjd
         hKyW5OBZ8YeeNxv7rRq/SljesJgu7PySMZw3DqgNQuosJ6MUexEYGL+L/vuG/R6f8foo
         np3bPiLr10JMR6TA+A1LC/bAbKETqbGLe3ZtkbWk3gXq/Qu0ez11CDSF3NjYbVA3/Lqk
         3mc1DYHGjms1Qyn0HJXzHGkSDfyOOHB79AZukMNBRnLIL/2pOYPK/USq9pDsyR5N8t5D
         Qklv6mjp8yuDVjP9Jz0Gz9aKApd6rvdd5dlxnMU65mhX3pPzy9E7ennCIEnz26Q06lOE
         1lcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137911; x=1759742711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rGkigfAyqdYVUscR7ZUffIIH2bgyKFFHO2VMToDJdps=;
        b=lmfjPhQvxHrb7FxVfS+zauo/4Is7wBc4mu4seWV7XvDcPpuP5uDOqKASEPy1QCuw6a
         DmYUt/qY1GQsuEPGRE/icFYjIK1sl/sVAdd/7KJn/aEdb2D6J9fZqCaQKHkKAbUsO4tY
         5acGikwKcZKce1+GEKRES9AwpznM30TDD9HIVERtVqSYyUoB8ZhjHv8IGzJZ4QNHlDKB
         W8FxlBMmhkcckqfE6Zlv5CfjcuLFs3o2CGAHWoB+7iyPoLunwy3OA/rx37QLLpRhE+Wt
         Hueq3L4p0lC9Q1Isg4yUW+oAsaldgku0c79pVVEivPJIGw2iTiH1LDedgi8txl7z7IkD
         JRHA==
X-Forwarded-Encrypted: i=1; AJvYcCV/ry3j1Eknb5M+T72Z1u8+xktA/ESQvyHBWRu2WHhPkZV26fDj2mHfUuyI1vz8BWRmAvM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn45Q6B8v64YakCOv8BXwYY+vt11ce+z6hwMwQT9DdwhlQFoNc
	ty9bay8j0qFlKEB5d7oTqUzOPF4N3e/20MBETSQbYFEggcBZeL4DfcxLgEA73WLb2fMQgYCW0PE
	qwgAgZ1dpoXJqr43AMMIsLP3IueVD/7xpuxx6us5r
X-Gm-Gg: ASbGncvUZh0g4JlHfVttdCpOxHZYt8BSo/EpepDHS8tsTIKtfPSoKtyFIvL4JQJAZr7
	53EcdB9UO/s3g2dZCodtl4iTCTUJwFmn1Jv0D2kb1vf5dlu0ji3hmcOxVAWQxbJbcPCDqmkoq48
	eGTiaMvY0u0REC/F7siGJxrdFNh1EOEd/NMqT1qn3mqOU5YoCOvBx8bgQZD8AkbeijHynDeM1C7
	tzCJ2gSzVWRptM=
X-Google-Smtp-Source: AGHT+IFbxIUeeYLmrN/zVl2ZddOZX/P3Bp9UTx658splbU4cSDC0XUgQmjzGs+KPfM901I9gtJY3Az5caBPz0X2fYvA=
X-Received: by 2002:ac8:5a87:0:b0:4b4:9863:5d76 with SMTP id
 d75a77b69052e-4e23233db7fmr1095411cf.8.1759137910878; Mon, 29 Sep 2025
 02:25:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-7-seanjc@google.com>
In-Reply-To: <20250926163114.2626257-7-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 29 Sep 2025 10:24:34 +0100
X-Gm-Features: AS18NWB96gb-U959oFUbLZwg6gqzQV77KikNfN25VVz26r3yCEgPbVVs4-wDqOE
Message-ID: <CA+EHjTxhyPRVbWWK6h86Wfw2oZbOVSekwAjKNxW-Ab=qaOhk3g@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>
> Add a guest_memfd testcase to verify that faulting in private memory gets
> a SIGBUS.  For now, test only the case where memory is private by default
> since KVM doesn't yet support in-place conversion.
>
> Cc: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 62 ++++++++++++++-----
>  1 file changed, 46 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 5dd40b77dc07..b5a631aca933 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -40,17 +40,26 @@ static void test_file_read_write(int fd, size_t total_size)
>                     "pwrite on a guest_mem fd should fail");
>  }
>
> -static void test_mmap_supported(int fd, size_t total_size)
> +static void *test_mmap_common(int fd, size_t size)
>  {
> -       const char val = 0xaa;
> -       char *mem;
> -       size_t i;
> -       int ret;
> +       void *mem;
>
> -       mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
> +       mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
>         TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
>
> -       mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +       mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +
> +       return mem;
> +}
> +
> +static void test_mmap_supported(int fd, size_t total_size)
> +{
> +       const char val = 0xaa;
> +       char *mem;
> +       size_t i;
> +       int ret;
> +
> +       mem = test_mmap_common(fd, total_size);
>
>         memset(mem, val, total_size);
>         for (i = 0; i < total_size; i++)
> @@ -78,31 +87,47 @@ void fault_sigbus_handler(int signum)
>         siglongjmp(jmpbuf, 1);
>  }
>
> -static void test_fault_overflow(int fd, size_t total_size)
> +static void *test_fault_sigbus(int fd, size_t size)
>  {
>         struct sigaction sa_old, sa_new = {
>                 .sa_handler = fault_sigbus_handler,
>         };
> -       size_t map_size = total_size * 4;
> -       const char val = 0xaa;
> -       char *mem;
> -       size_t i;
> +       void *mem;
>
> -       mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +       mem = test_mmap_common(fd, size);
>
>         sigaction(SIGBUS, &sa_new, &sa_old);
>         if (sigsetjmp(jmpbuf, 1) == 0) {
> -               memset(mem, 0xaa, map_size);
> +               memset(mem, 0xaa, size);
>                 TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
>         }
>         sigaction(SIGBUS, &sa_old, NULL);
>
> +       return mem;
> +}
> +
> +static void test_fault_overflow(int fd, size_t total_size)
> +{
> +       size_t map_size = total_size * 4;
> +       const char val = 0xaa;
> +       char *mem;
> +       size_t i;
> +
> +       mem = test_fault_sigbus(fd, map_size);
> +
>         for (i = 0; i < total_size; i++)
>                 TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
>
>         kvm_munmap(mem, map_size);
>  }
>
> +static void test_fault_private(int fd, size_t total_size)
> +{
> +       void *mem = test_fault_sigbus(fd, total_size);
> +
> +       kvm_munmap(mem, total_size);
> +}
> +
>  static void test_mmap_not_supported(int fd, size_t total_size)
>  {
>         char *mem;
> @@ -274,9 +299,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>
>         gmem_test(file_read_write, vm, flags);
>
> -       if (flags & GUEST_MEMFD_FLAG_MMAP) {
> +       if (flags & GUEST_MEMFD_FLAG_MMAP &&
> +           flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
>                 gmem_test(mmap_supported, vm, flags);
>                 gmem_test(fault_overflow, vm, flags);
> +       } else if (flags & GUEST_MEMFD_FLAG_MMAP) {
> +               gmem_test(fault_private, vm, flags);
>         } else {
>                 gmem_test(mmap_not_supported, vm, flags);
>         }
> @@ -294,9 +322,11 @@ static void test_guest_memfd(unsigned long vm_type)
>
>         __test_guest_memfd(vm, 0);
>
> -       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP)) {
> +               __test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
>                 __test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
>                                        GUEST_MEMFD_FLAG_DEFAULT_SHARED);
> +       }
>
>         kvm_vm_free(vm);
>  }
> --
> 2.51.0.536.g15c5d4f767-goog
>


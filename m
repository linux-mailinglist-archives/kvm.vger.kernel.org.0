Return-Path: <kvm+bounces-42394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A04BA78180
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B2583AF7F4
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BAC2116FA;
	Tue,  1 Apr 2025 17:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WeegJ6PT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE420E6E2
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743528342; cv=none; b=hzNR5NPBYEk01RmqaXv7QOTR352VCXvWmV26iZx7TUwXHEU+THZC7k+i24OPT4Tu7BA+u56BRk530swozlIVWBMuga+YgjfCci7b40yP1BWf1okzx517hHAMqRiXM9WprznHaF6zOy2s7JxXAi+sJJDMD5cRdWLOjW6amMsElr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743528342; c=relaxed/simple;
	bh=RaTQU49Ag8RWgpmQ/vDg2wh+diOdiwtKTI4mEOTGTaE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ePAFlXG94HDLyOe07tw/tHCy6v4nJei5RDxDqBeTylbgKDO0S9XRLQP1Ba6i+uOlsAZ81RB0WLXYDoFUN4VSNA8dfXq6RVNwBMQGQK1PF4+MSOgHtSdOFhtCAGMnzmNHwU+cNs0MNHEgn8ldyboDP7PO9OWeWR3I7MEbG8lk5Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WeegJ6PT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225ab228a37so102687995ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743528340; x=1744133140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1QMJUUvJu1JQqCcd3Mla3uHG623BMpb1dtkzY/i1Xgs=;
        b=WeegJ6PTaWM1U8DCON3QC0CB91h780GozHgQjClaoQ4futKg/muakjSbPaaTGbX/M7
         gzRlrN9TMtkSllzzN5+gJf9+AfF3RkDbSKLvuPWweEDGhr/CJ9+dgB5bNPxJcEf2s/bi
         I8+eOyPpZjshbLiD2zIYnw/3CmHGoJFunt7AIDzUPT/Jytx5uER4nbFSw55Uc94ChBGv
         +bNzD5VIvCeMDTneWugrc1fn1w8yUDJ38Xl5PAp82ks+sH16ZJNw1/wYVppOSrQazkmg
         vUISgNd8lDC0gsiPno1+OF8kdDgX/tCUUhjSH0jHEI8BvNxoCLoa4jJiNCa0vuMvgdUw
         UUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743528340; x=1744133140;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QMJUUvJu1JQqCcd3Mla3uHG623BMpb1dtkzY/i1Xgs=;
        b=ebWkJA0mAO1kdUcRSzINImxZXAIt7ya88/FO311lMevW4JfYKeUnbOKQ6VlHmG7I+H
         0X9xpmPeSawWO+SY3JHxvF47Wr6ZpC8vG7qFpyzeZrl8ouICjmhdL1q86GtCBZGRupB9
         YlHzyDbWWYyJDFPuUUauX4TR02+C1QSvUqEl7AIamEpxv3KkQPgrV1/sNxSqPx1aQ4kh
         6r2vDKcv0VTZ/PEWQzomNVUiZSZ9MN3Uc8nGlnaC4rj3NTCckeF0ck33YeSiQfUZWFZb
         zdCxdAbMaatEW8vIzvG1xv513BrSZ68KHqLlPgUzZgViuMCK8WxOdn5oNJ9XQMo7+ggl
         1BDg==
X-Gm-Message-State: AOJu0YwyaUDlDIZBnLdqFB0xyWYwRMT6z9NNod7eZ5Fq+djz2Cj4z0UO
	BtqEaTnY4boE4gwmibyWvNTO5sHUCQIEjZrwKb6CP2XuWfhwsSlAlVuE8VeVERcoy0qeGmZ3fh8
	rbBPCBD5+lfLeh23ya9WW7g==
X-Google-Smtp-Source: AGHT+IEZN5ZhSHxL7/1sM2Ro+mb+dZQJWxiNOpGPaOZkYZnjMSp7uVPfEWvm5ZTBX9uD5kSltHw3tL4PL3mOYv3krg==
X-Received: from pjbsy12.prod.google.com ([2002:a17:90b:2d0c:b0:2e9:ee22:8881])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ecd2:b0:224:c76:5e56 with SMTP id d9443c01a7336-2292f976e6emr208275655ad.27.1743528339957;
 Tue, 01 Apr 2025 10:25:39 -0700 (PDT)
Date: Tue, 01 Apr 2025 10:25:38 -0700
In-Reply-To: <20250318161823.4005529-10-tabba@google.com> (message from Fuad
 Tabba on Tue, 18 Mar 2025 16:18:23 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz34er23ql.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v7 9/9] KVM: guest_memfd: selftests: guest_memfd mmap()
 test when mapping is allowed
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
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
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
>
> Also, build the guest_memfd selftest for arm64.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
>  .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++++++--
>  2 files changed, 70 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 4277b983cace..c9a3f30e28dd 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -160,6 +160,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
>  TEST_GEN_PROGS_arm64 += demand_paging_test
>  TEST_GEN_PROGS_arm64 += dirty_log_test
>  TEST_GEN_PROGS_arm64 += dirty_log_perf_test
> +TEST_GEN_PROGS_arm64 += guest_memfd_test
>  TEST_GEN_PROGS_arm64 += guest_print_test
>  TEST_GEN_PROGS_arm64 += get-reg-list
>  TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index ce687f8d248f..38c501e49e0e 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -34,12 +34,48 @@ static void test_file_read_write(int fd)
>  		    "pwrite on a guest_mem fd should fail");
>  }
>  
> -static void test_mmap(int fd, size_t page_size)
> +static void test_mmap_allowed(int fd, size_t total_size)
>  {
> +	size_t page_size = getpagesize();
> +	const char val = 0xaa;
> +	char *mem;
> +	int ret;
> +	int i;

Was using this test with hugetlb patches - int i was overflowing and
causing test failures.  Perhaps use size_t i for this instead?

> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
> +
> +	memset(mem, val, total_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			page_size);
> +	TEST_ASSERT(!ret, "fallocate the first page should succeed");
> +
> +	for (i = 0; i < page_size; i++)
> +		TEST_ASSERT_EQ(mem[i], 0x00);
> +	for (; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	memset(mem, val, total_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	ret = munmap(mem, total_size);
> +	TEST_ASSERT(!ret, "munmap should succeed");
> +}
> +
> +static void test_mmap_denied(int fd, size_t total_size)
> +{
> +	size_t page_size = getpagesize();
>  	char *mem;
>  
>  	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>  	TEST_ASSERT_EQ(mem, MAP_FAILED);
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT_EQ(mem, MAP_FAILED);
>  }
>  
>  static void test_file_size(int fd, size_t page_size, size_t total_size)
> @@ -170,19 +206,27 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>  	close(fd1);
>  }
>  
> -int main(int argc, char *argv[])
> +unsigned long get_shared_type(void)
>  {
> -	size_t page_size;
> +#ifdef __x86_64__
> +	return KVM_X86_SW_PROTECTED_VM;
> +#endif
> +	return 0;
> +}
> +
> +void test_vm_type(unsigned long type, bool is_shared)
> +{
> +	struct kvm_vm *vm;
>  	size_t total_size;
> +	size_t page_size;
>  	int fd;
> -	struct kvm_vm *vm;
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>  
>  	page_size = getpagesize();
>  	total_size = page_size * 4;
>  
> -	vm = vm_create_barebones();
> +	vm = vm_create_barebones_type(type);
>  
>  	test_create_guest_memfd_invalid(vm);
>  	test_create_guest_memfd_multiple(vm);
> @@ -190,10 +234,29 @@ int main(int argc, char *argv[])
>  	fd = vm_create_guest_memfd(vm, total_size, 0);
>  
>  	test_file_read_write(fd);
> -	test_mmap(fd, page_size);
> +
> +	if (is_shared)
> +		test_mmap_allowed(fd, total_size);
> +	else
> +		test_mmap_denied(fd, total_size);
> +
>  	test_file_size(fd, page_size, total_size);
>  	test_fallocate(fd, page_size, total_size);
>  	test_invalid_punch_hole(fd, page_size, total_size);
>  
>  	close(fd);
> +	kvm_vm_release(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +#ifndef __aarch64__
> +	/* For now, arm64 only supports shared guest memory. */
> +	test_vm_type(VM_TYPE_DEFAULT, false);
> +#endif
> +
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> +		test_vm_type(get_shared_type(), true);
> +
> +	return 0;
>  }


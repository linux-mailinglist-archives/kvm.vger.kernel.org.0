Return-Path: <kvm+bounces-53764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0901EB1691D
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 00:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4398A5683CF
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 22:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290E5235048;
	Wed, 30 Jul 2025 22:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="laJmeKBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8E122FF2D
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753915487; cv=none; b=p9jOb85jFEa8GcuSNuHsem/8uEYcEF8fsoihXi8l048YBDpNrtpGgW/AKpiIYaUfYs2MtYD46dVeWadE21Nw70hRMqmk36FcMgRujXdnuY1lc/k4Vu7PsZlIx1LEUQkgMViuCbHLgLpw2JGr1Rc2sQeVlvUxXUdKy9LGDbL+RJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753915487; c=relaxed/simple;
	bh=plnA5GPYRADuDvOFCrwy5MjhmaBZB11lrvEEaNu+2hE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GMAE5nROHmEqeSKxoidyjSdXxDv5G8RVn6bninB3MeS7IylwwWVks90NIpYxU3DJeycGeivfNsLAyerKGLTa+Hud3ObDhnbxwiFyX3kUrr06UapontZi7EumlsugZomU8NK84+WfV7cBprMHpcLU3tHAmv7cc6fcZGlmtJiDZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=laJmeKBP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ae13e99d6so1061539b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 15:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753915485; x=1754520285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ECWzv5e2xsuSDiY8UbhBmnQ0CYKWUYp4TIAX7WJgUDc=;
        b=laJmeKBP3wGNohGGFhlv/5FtOURHMU50gIp8PIvevwm1QjkO5asRsRxS8XlE8p5rDM
         aQbkh+LEzSsHOYH7WEVAHlgGfV2v6z/jPGveO1iWQ7ndWz1DbGASTjW9kkMmjLKt1EBB
         g+/ntVfgX3NtYbC30kSTwyKSmnKwu3EH2XORHg8SJc6e+p7SlLToCGjCUPY9JAK3eeMx
         4MAm6yE9bBa0K+f241MUjjJbEW4tNMAeIDMujiqDGb3d/dN8G9Y5zppP0RQZv07cBvx3
         H7TLg0fBfB9sAHuc7krZn+3pueFcD9sP3+ILbVXEJiXz0g7a593dSce8tYUJvizGRYiF
         /pBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753915485; x=1754520285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECWzv5e2xsuSDiY8UbhBmnQ0CYKWUYp4TIAX7WJgUDc=;
        b=I//kAZ5FdzioauJykpaaJksfvJyz5iGD0oecujZcQtyvD914GsN0J7SDdYAIFglZpw
         In8kIDLPe2to7j2gxhUxJ6Xz3fPBYxH0Jjt+KCqoO53w2hIL4GSUHb2XV52ekEqnslB0
         oJHFRc2TLagboY/uGFJ2IUkx6wc3vylS2tGqx6qo2Cd3qqoGeYBxPJ6y8nwYvM1iZ2aT
         gGkNJmeUWU6XxPcKG32ARIM96I8V1F66B58jt1YanjlJFi+6ENriSI1dr7wt/l0+uaS3
         kglcSYK2mWtF2mKJ1ZvlpQabTBwLb+3npIztp52AcLNVHFz+2OQk+4kQfUgi1JsdSh8M
         LdWg==
X-Gm-Message-State: AOJu0Yx6K2E9sT0uDKkeJwhGyTbb5W6kv30+5k9t2Co8YHRs1eD1cSL8
	t2+jojC6wCu5KutiO590I0HXD1peMb25vwBUVag466jqVtsftPjYaKlonOV0AWVJgUe2ZQT7OyX
	VUPOpUFDZzxV9iTM3mtbK9N1zqw==
X-Google-Smtp-Source: AGHT+IG2jrN7LcvgIWrJ4pHg8D4X2boCwV7dmSEgcVYsZ4qFvdN8Q5fmxfreX5UVqZROCmx2pQYYvC5DyR2A5cxeKg==
X-Received: from pfoo1.prod.google.com ([2002:a05:6a00:1a01:b0:746:21fd:3f7a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:47c7:b0:23d:c7aa:a6f0 with SMTP id adf61e73a8af0-23dc7aaa79dmr5184186637.22.1753915485016;
 Wed, 30 Jul 2025 15:44:45 -0700 (PDT)
Date: Wed, 30 Jul 2025 15:44:43 -0700
In-Reply-To: <diqzwm7pjrbf.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <diqzwm7pjrbf.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqztt2tjo2s.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>, Jiaqi Yan <jiaqiyan@google.com>, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> Paolo,
>>
>> The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
>> things is a go.  Barring a screwup on my end, this just needs your approval.
>>
>> Assuming everything looks good, it'd be helpful to get this into kvm/next
>> shortly after rc1.  The x86 Kconfig changes in particular create semantic
>> conflicts with in-flight series.
>>
>>
>> Add support for host userspace mapping of guest_memfd-backed memory for VM
>> types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
>> precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
>> no way to detect private vs. shared).
>>
>> mmap() support paves the way for several evolving KVM use cases:
>>
>>  * Allows VMMs like Firecracker to run guests entirely backed by
>>    guest_memfd [1]. This provides a unified memory management model for
>>    both confidential and non-confidential guests, simplifying VMM design.
>>
>>  * Enhanced Security via direct map removal: When combined with Patrick's
>>    series for direct map removal [2], this provides additional hardening
>>    against Spectre-like transient execution attacks by eliminating the
>>    need for host kernel direct maps of guest memory.
>>
>>  * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
>>    memory on CoCo platforms [3] that permit in-place
>>    sharing of guest memory with the host.
>>
>> Based on kvm/queue.
>>
>> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>> [2] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk
>> [3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com
>>
>> [...snip...]
>
> With this version, when guest_memfd memory is mmap-ed() and faulted to
> userspace, when there's a memory failure, the process does not get a
> SIGBUS. Specifically, this selftest fails with "MADV_HWPOISON should
> have triggered SIGBUS."
>
> diff --git i/tools/testing/selftests/kvm/guest_memfd_test.c w/tools/testing/selftests/kvm/guest_memfd_test.c
> index b86bf89a71e04..70ef75a23bb60 100644
> --- i/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ w/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -70,6 +70,10 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
>  
>  	ret = munmap(mem, total_size);
>  	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
>  }
>  
>  static sigjmp_buf jmpbuf;
> @@ -104,6 +108,47 @@ static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
>  
>  	ret = munmap(mem, map_size);
>  	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
> +}
> +
> +static void test_memory_failure(int fd, size_t page_size, size_t total_size)
> +{
> +	struct sigaction sa_old, sa_new = {
> +		.sa_handler = fault_sigbus_handler,
> +	};
> +	void *memory_failure_addr;
> +	char *mem;
> +	int ret;
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
> +
> +	memset(mem, 0xaa, page_size);
> +

My bad. If the above was changed from page_size to total_size, the page
would have been faulted in, and then we get a SIGBUS.

> +	memory_failure_addr = mem + page_size;
> +	sigaction(SIGBUS, &sa_new, &sa_old);
> +	if (sigsetjmp(jmpbuf, 1) == 0) {
> +		madvise(memory_failure_addr, page_size, MADV_HWPOISON);
> +		TEST_ASSERT(false, "MADV_HWPOISON should have triggered SIGBUS.");
> +	}
> +	sigaction(SIGBUS, &sa_old, NULL);
> +
> +	ret = munmap(mem, total_size);
> +	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
>  }
>  
>  static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
> @@ -286,6 +331,7 @@ static void test_guest_memfd(unsigned long vm_type)
>  	if (flags & GUEST_MEMFD_FLAG_MMAP) {
>  		test_mmap_supported(fd, page_size, total_size);
>  		test_fault_overflow(fd, page_size, total_size);
> +		test_memory_failure(fd, page_size, total_size);
>  	} else {
>  		test_mmap_not_supported(fd, page_size, total_size);
>  	}
>
> Is this by design or should some new memory_failure handling be added?


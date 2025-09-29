Return-Path: <kvm+bounces-58989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0C8BA99DD
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9631317482B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 14:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8032F30BBA8;
	Mon, 29 Sep 2025 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MRYfheio"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A82FF677
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759156726; cv=none; b=FSMA40/pMZ2j3to9PXiPiysNDziu0MdZPBAMJo94J7a4TBa+WZnmx06OKmFBnZRLDpMeZ+5+UqazvX/pCQZGFJQL+y2zCFJOsgYxqE37eBQYzkxOG3zvh4BjO3UgiBQgJZChKpQVkVg97LDT9nnBajs90jC3tXAD8rGYYr4sWZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759156726; c=relaxed/simple;
	bh=9WmWL9XdAMqLc1IZQ93b6hptEkCTraIhFiTncrT265k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Opr3n286Ij+p/z1ozXcZORN9bSAtq/A7ABS61llaNR+5R/bxcJh3ezHYu0WQL3H+6VMmnwEEJiSN7r5JNuGcNQ3hBHPANIMXwcQ4XWW1xN+trpNk6/BacAy4/EAFnYVaFWFN8Txldm+quecwikzRpe+Dc1LbcAtqWQPPiSVB+xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MRYfheio; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2697c4e7354so52009205ad.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 07:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759156724; x=1759761524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6OSGtSHxL4eTCbju1lVBxLe38ZjlCTkyXBpsuAxWzs=;
        b=MRYfheio2NqOXnHw8hmAZDNzot5vVxHyzhWgNJ+6prRoTDvogpFMISwjATi3FCSEG9
         jHDFQEGcq/TRZJ2j5dwyrHQUuQS95hiXCqG/Wcte2/gmF6QWzOnXu3eh+NJzJ/W6ur3X
         3Xo0JqZbKJuwdUIGAqnDOZL2Ek/x7a58GegLWaBKmcCxktUaE4L3o9OFow37pYaIzD1K
         K/1v0lyMwQtnYFvjA08cK7cqLWyWuc8YWV5vPkZWPVCeE2c0CPuogUH8i/RGOU1iEHbe
         dH3ZS/1c8UP+wnAXpcQNd05n+lQyhDONLDacOpBGPgyatZgLhMiY31Df68/AT0mgoDRD
         v9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759156724; x=1759761524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6OSGtSHxL4eTCbju1lVBxLe38ZjlCTkyXBpsuAxWzs=;
        b=HBRmVdM+WZYV8ZhOoDVxyMkctmK03TJSKZ9qvp3qwhVBOkAok9J95rqNKvdJl75loI
         Vpj25S/lLflhgiUtXrBX7DKFt9quBF8WEMG85RqlHD83tgXLmz6h+vSoFaGVDuXxIFHA
         G48L4TGsILBUI35nIctm9B3IWeqg1SxlluolIBj8kVW0vhXyU1r/d2/43iIASi+uJwEw
         6Zq59DDWF5r+W2RM8YfYtdvYImz8cwTYancttP2Yp1MWmOuloJPPlcYk2e32JvValUu7
         5thsh84TzwZgGoARZJc+/fh6Mt4+swaJmNMWilVzFJBK2NLYqCfREtQ25b9q3gZeX8bA
         4FHQ==
X-Gm-Message-State: AOJu0Ywu40WZ/6SgYGnYhTCiT9t7VsLhIEccEQFVeeYE1xd72ZfvPxlJ
	kQitSHKjXEmWO51bTqbrBXs3CGIEC2NKj6NaFOHl/I9NbAZQdzmb2gdz4QcH7JLmjTPsTCbMqJj
	zpdnHzPjWiJBN6G7WoYKHq9wcnA==
X-Google-Smtp-Source: AGHT+IE70G65dnXiaauR0ZFChz0iWPzCgGLPRgS62OFKcDUJXdvInt9rFKI+993Dw6ra7VJ4bKCZFZL/Z8OnNBPtLQ==
X-Received: from pgbfq11.prod.google.com ([2002:a05:6a02:298b:b0:b55:139f:ce2a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70f:b0:265:f460:ab26 with SMTP id d9443c01a7336-28d16d725a6mr9019795ad.3.1759156724137;
 Mon, 29 Sep 2025 07:38:44 -0700 (PDT)
Date: Mon, 29 Sep 2025 14:38:43 +0000
In-Reply-To: <20250926163114.2626257-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-7-seanjc@google.com>
Message-ID: <diqzldlx1fyk.fsf@google.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add a guest_memfd testcase to verify that faulting in private memory gets
> a SIGBUS.  For now, test only the case where memory is private by default
> since KVM doesn't yet support in-place conversion.
>
> Cc: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 62 ++++++++++++++-----
>  1 file changed, 46 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 5dd40b77dc07..b5a631aca933 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -40,17 +40,26 @@ static void test_file_read_write(int fd, size_t total_size)
>  		    "pwrite on a guest_mem fd should fail");
>  }
>  

I feel that the tests should be grouped by concepts being tested

+ test_cow_not_supported()
    + mmap() should fail
+ test_mmap_supported()
    + kvm_mmap()
    + regular, successful accesses to offsets within the size of the fd
    + kvm_munmap()
+ test_fault_overflow()
    + kvm_mmap()
    + a helper (perhaps "assert_fault_sigbus(char *mem)"?) that purely
      tries to access beyond the size of the fd and catches SIGBUS
    + regular, successful accesses to offsets within the size of the fd
    + kvm_munmap()
+ test_fault_private()
    + kvm_mmap()
    + a helper (perhaps "assert_fault_sigbus(char *mem)"?) that purely
      tries to access within the size of the fd and catches SIGBUS
    + kvm_munmap()

I think some code duplication in tests is okay if it makes the test flow
more obvious.

> -static void test_mmap_supported(int fd, size_t total_size)
> +static void *test_mmap_common(int fd, size_t size)
>  {
> -	const char val = 0xaa;
> -	char *mem;
> -	size_t i;
> -	int ret;
> +	void *mem;
>  
> -	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
> +	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
>  	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
>

When grouped this way, test_mmap_common() tests that MAP_PRIVATE or COW
is not allowed twice, once in test_mmap_supported() and once in
test_fault_sigbus(). Is that intentional?

> -	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +
> +	return mem;

I feel that returning (and using) the userspace address from a test
(test_mmap_common()) is a little hard to follow.

> +}
> +
> +static void test_mmap_supported(int fd, size_t total_size)
> +{
> +	const char val = 0xaa;
> +	char *mem;
> +	size_t i;
> +	int ret;
> +
> +	mem = test_mmap_common(fd, total_size);
>  
>  	memset(mem, val, total_size);
>  	for (i = 0; i < total_size; i++)
> @@ -78,31 +87,47 @@ void fault_sigbus_handler(int signum)
>  	siglongjmp(jmpbuf, 1);
>  }
>  
> -static void test_fault_overflow(int fd, size_t total_size)
> +static void *test_fault_sigbus(int fd, size_t size)
>  {
>  	struct sigaction sa_old, sa_new = {
>  		.sa_handler = fault_sigbus_handler,
>  	};
> -	size_t map_size = total_size * 4;
> -	const char val = 0xaa;
> -	char *mem;
> -	size_t i;
> +	void *mem;
>  
> -	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +	mem = test_mmap_common(fd, size);
>  
>  	sigaction(SIGBUS, &sa_new, &sa_old);
>  	if (sigsetjmp(jmpbuf, 1) == 0) {
> -		memset(mem, 0xaa, map_size);
> +		memset(mem, 0xaa, size);
>  		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
>  	}
>  	sigaction(SIGBUS, &sa_old, NULL);
>  
> +	return mem;

I think returning the userspace address from a test is a little hard to
follow. This one feels even more unexpected because a valid address is
being returned (and used) from a test that has sigbus in its name.

> +}
> +
> +static void test_fault_overflow(int fd, size_t total_size)
> +{
> +	size_t map_size = total_size * 4;
> +	const char val = 0xaa;
> +	char *mem;
> +	size_t i;
> +
> +	mem = test_fault_sigbus(fd, map_size);
> +
>  	for (i = 0; i < total_size; i++)
>  		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
>  
>  	kvm_munmap(mem, map_size);
>  }
>  
> +static void test_fault_private(int fd, size_t total_size)
> +{
> +	void *mem = test_fault_sigbus(fd, total_size);
> +
> +	kvm_munmap(mem, total_size);
> +}
> +

Testing that faults fail when GUEST_MEMFD_FLAG_DEFAULT_SHARED is not set
is a good idea. Perhaps it could be even clearer if further split up:

+ test_mmap_supported()
    + kvm_mmap()
    + kvm_munmap()
+ test_mmap_supported_fault_supported()
    + kvm_mmap()
    + successful accesses to offsets within the size of the fd
    + kvm_munmap()
+ test_mmap_supported_fault_sigbus()
    + kvm_mmap()
    + expect SIGBUS from accesses to offsets within the size of the fd
    + kvm_munmap()

>  static void test_mmap_not_supported(int fd, size_t total_size)
>  {
>  	char *mem;
> @@ -274,9 +299,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  
>  	gmem_test(file_read_write, vm, flags);
>  
> -	if (flags & GUEST_MEMFD_FLAG_MMAP) {
> +	if (flags & GUEST_MEMFD_FLAG_MMAP &&
> +	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
>  		gmem_test(mmap_supported, vm, flags);
>  		gmem_test(fault_overflow, vm, flags);
> +	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
> +		gmem_test(fault_private, vm, flags);

test_fault_private() makes me think the test is testing for private
faults, but there's nothing private about this fault, and the fault
doesn't even come from the guest.

>  	} else {
>  		gmem_test(mmap_not_supported, vm, flags);
>  	}

If split up as described above, this could be

	if (flags & GUEST_MEMFD_FLAG_MMAP &&
	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
		gmem_test(mmap_supported_fault_supported, vm, flags);
		gmem_test(fault_overflow, vm, flags);
	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
		gmem_test(mmap_supported_fault_sigbus, vm, flags);
	} else {
		gmem_test(mmap_not_supported, vm, flags);
	}

> @@ -294,9 +322,11 @@ static void test_guest_memfd(unsigned long vm_type)
>  
>  	__test_guest_memfd(vm, 0);
>  
> -	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP)) {
> +		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
>  		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
>  				       GUEST_MEMFD_FLAG_DEFAULT_SHARED);
> +	}
>  
>  	kvm_vm_free(vm);
>  }

I could send a revision, if you agree/prefer!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> -- 
> 2.51.0.536.g15c5d4f767-goog


Return-Path: <kvm+bounces-59445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 345BEBB5051
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 21:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EF421899402
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 19:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414C3286D79;
	Thu,  2 Oct 2025 19:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w1MMOPpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA7B255F3F
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433946; cv=none; b=JJ5QCUrBXMTEn6emq4VEged1FLizeVo0SqBujrukez6DrIweR6dAVhKB9jNnCaAxNz1n1/rg9rRMiJJ/ttkC+tmasynGwm6K+yIPjMAhOG7xERUNHXXvWExA19P9PbHI+bXyquggg8uCb0VJYgk+SfXjmD972uoNqklhWhEfJNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433946; c=relaxed/simple;
	bh=fJup3BioERKJDnvhSbfrNVew6XKMGezEKovnX+Mtcjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nd2rPorH7Pb6OEGi3lK89WHN4dKRxZbiO0S85cdpSO1xlJIy/J4f0Zc+5GcCqBteaLkhnBUIF479bUpBZCye/zLvgxWunhZveQtBzSp02QAIC/EMBzUxiDiS8tLchcFfHbQPQ+X5NqX0hkksVH/EyRA3p1SSwtI8GHeb5jrIk1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w1MMOPpT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27eeb9730d9so16560305ad.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 12:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759433943; x=1760038743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aOaMae6ua6f6Csic4uWpmHj0lHLPidbVDMkoA7iFmFA=;
        b=w1MMOPpTOAm/yd25a40qQLS0uoqzCGrEySOjLJmdzhaofelwbSTwE3vxuVAJVsvtuC
         wE5DN3UPGRSJcAIzuFjlGBjYJNgL0xs4SlgENO5VJxrYwNoMXX06Hrnk+VHFuXBG0tF3
         Tkna+dRbKPbZ3FNRoJaukb9F8QLatJnQ7SuykR9IBFsN5TsRGczhSQ9iT1wMxhBSSaCF
         ElWDLnmLW3btW9TN73mU9PxHAoO8EmbjOvhtuVp7j0te9okRs29WvZa59pw7M/gKQXdP
         +7PIIL4YVbVElLoRX6pxhy9wj/Va7cbKtfjkWcVi0zfqbt4nDzaxLbzUX14iFLAf8UhC
         cz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759433943; x=1760038743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOaMae6ua6f6Csic4uWpmHj0lHLPidbVDMkoA7iFmFA=;
        b=oRR0XRXRUjjYYfTkHqWb7Tn+1s76/oB81EPntL2nnCQkaLy0w/+BghQyGqlSKlxf6n
         IrcCk5bSHn4P2XVU5w7J33wQg+K+fjJaDaIowxz4B8+zAUbI8ikaDaDbNzmP+8ZXs3Lz
         Ha3C4myjE24fXrnTQzCvp9qf8fVLUxoA+IsSYHQ4Ra/s/0UX1nOdiN8jE1W8GKSIStjE
         3cagBCTupcV8OAJb6qPIzU7WoWyLNh1FLlbba9UW1jDnLDKHL1eEOUr/vxiiKg8DJKkY
         coLV0Gz+nySl15+J5axGsXhQkcAeOZGfB/c6K5tcaUC2qzIQPiLBcM0H3OPQ4/41vV8x
         Cnxg==
X-Gm-Message-State: AOJu0Yz7oe1qNbvN3tpDe7yw8I2gIY2L9v+1BvCV2q7t5TC30IQ7HwEJ
	OSVJjkg4V9BBKKmQL0d8b4XC5prgT4g6GMIJb6FgIgel++F+f5XkzFY7/S+vxzV+rylFZqpcMMB
	tRY98wA==
X-Google-Smtp-Source: AGHT+IFDYM9J8Cg3KNVuztpXb+iVenM+fDTqcK6w7OttgzwejGesY0GWhNaLErWqTGQvASpGwBeg/0Je1nk=
X-Received: from plps1.prod.google.com ([2002:a17:902:9881:b0:267:d862:5f13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da91:b0:28e:78b9:5780
 with SMTP id d9443c01a7336-28e9a665ce6mr5841635ad.47.1759433943018; Thu, 02
 Oct 2025 12:39:03 -0700 (PDT)
Date: Thu, 2 Oct 2025 12:39:01 -0700
In-Reply-To: <baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com>
Message-ID: <aN7U1ewx8dNOKl1n@google.com>
Subject: Re: [RFC PATCH v2 12/51] KVM: selftests: Test conversion flows for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 14, 2025, Ackerley Tng wrote:
> Add minimal tests for guest_memfd to test that when memory is marked
> shared in a VM, the host can read and write to it via an mmap()ed
> address, and the guest can also read and write to it.
> 
> Tests added in this patch use refcounts taken via GUP (requiring
> CONFIG_GUP_TEST) to simulate unexpected refcounts on guest_memfd
> pages.

This absolutely needs to be split up into multiple patches, one testcase per
patch.  Reviewing megapatches like this is no fun, and trying to debug failures
months or years down the road is even less fun, especially for folks who weren't
involved in the original development, because there's basically zero information
provided for each individual testcase.

> +#define GUEST_MEMFD_SHARING_TEST_SLOT 10
> +/*
> + * Use high GPA above APIC_DEFAULT_PHYS_BASE to avoid clashing with
> + * APIC_DEFAULT_PHYS_BASE.
> + */
> +#define GUEST_MEMFD_SHARING_TEST_GPA 0x100000000ULL
> +#define GUEST_MEMFD_SHARING_TEST_GVA 0x90000000ULL
> +
> +static int gup_test_fd;
> +
> +static void pin_pages(void *vaddr, uint64_t size)
> +{
> +	const struct pin_longterm_test args = {
> +		.addr = (uint64_t)vaddr,
> +		.size = size,
> +		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
> +	};
> +
> +	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
> +	TEST_REQUIRE(gup_test_fd > 0);
> +
> +	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
> +}
> +
> +static void unpin_pages(void)
> +{
> +	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
> +}
> +
> +static void guest_check_mem(uint64_t gva, char expected_read_value, char write_value)
> +{
> +	char *mem = (char *)gva;
> +
> +	if (expected_read_value != 'X')
> +		GUEST_ASSERT_EQ(*mem, expected_read_value);
> +
> +	if (write_value != 'X')
> +		*mem = write_value;
> +
> +	GUEST_DONE();
> +}
> +
> +static int vcpu_run_handle_basic_ucalls(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +	int rc;
> +
> +keep_going:
> +	do {
> +		rc = __vcpu_run(vcpu);
> +	} while (rc == -1 && errno == EINTR);
> +
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_PRINTF:
> +		REPORT_GUEST_PRINTF(uc);
> +		goto keep_going;
> +	case UCALL_ABORT:
> +		REPORT_GUEST_ASSERT(uc);
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * guest_use_memory() - Assert that guest can use memory at @gva.
> + *
> + * @vcpu: the vcpu to run this test on.
> + * @gva: the virtual address in the guest to try to use.
> + * @expected_read_value: the value that is expected at @gva. Set this to 'X' to
> + *                       skip checking current value.
> + * @write_value: value to write to @gva. Set to 'X' to skip writing value to
> + *               @address.
> + * @expected_errno: the expected errno if an error is expected while reading or
> + *                  writing @gva. Set to 0 if no exception is expected,
> + *                  otherwise set it to the expected errno. If @expected_errno
> + *                  is set, 'Z' is used instead of @expected_read_value or
> + *                  @write_value.
> + */

Please don't add kerneldoc comments for selftests, and certainly not for a local
helper in a test.  The fact that documentation is needed is a sign that the behavior
is too magical.

And all of that magic is comipletely unnecessary.  Reads should _never_ be skipped,
because there is _always_ a deterministic, predictable value in memory.  And
passing a magic value to skip writes is silly; just do the bare read.

Similarly, shoving 'Z' into values at this point is absurd, the caller is fully
capable of specifying a garbage value that it knows can't be encountered.  Even
worse, expected_errno is never non-zero, making this even harder to review.

> +static void guest_use_memory(struct kvm_vcpu *vcpu, uint64_t gva,

"use_memory" is far too vague.  This also should be prefaced with run_guest so
that it's obviously a host-side function.  E.g. run_guest_do_rmw() and host_do_rmw()
are short and a bit more descriptive.

> +			     char expected_read_value, char write_value,
> +			     int expected_errno)
> +{
> +	struct kvm_regs original_regs;
> +	int rc;
> +
> +	if (expected_errno > 0) {
> +		expected_read_value = 'Z';
> +		write_value = 'Z';
> +	}
> +
> +	/*
> +	 * Backup and vCPU state from first run so that guest_check_mem can be
> +	 * run again and again.
> +	 */
> +	vcpu_regs_get(vcpu, &original_regs);
> +
> +	vcpu_args_set(vcpu, 3, gva, expected_read_value, write_value);
> +	vcpu_arch_set_entry_point(vcpu, guest_check_mem);

As mentioned in the earlier patch, don't do this, it's too fragile.

> +	rc = vcpu_run_handle_basic_ucalls(vcpu);
> +
> +	if (expected_errno) {
> +		TEST_ASSERT_EQ(rc, -1);
> +		TEST_ASSERT_EQ(errno, expected_errno);
> +
> +		switch (expected_errno) {
> +		case EFAULT:
> +			TEST_ASSERT_EQ(vcpu->run->exit_reason, 0);
> +			break;
> +		case EACCES:
> +			TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MEMORY_FAULT);
> +			break;
> +		}
> +	} else {
> +		struct ucall uc;
> +
> +		TEST_ASSERT_EQ(rc, 0);
> +		TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);
> +
> +		/*
> +		 * UCALL_DONE() uses up one struct ucall slot. To reuse the slot
> +		 * in another run of guest_check_mem, free up that slot.
> +		 */
> +		ucall_free((struct ucall *)uc.hva);
> +	}
> +
> +	vcpu_regs_set(vcpu, &original_regs);
> +}
> +
> +/**
> + * host_use_memory() - Assert that host can fault and use memory at @address.
> + *
> + * @address: the address to be testing.
> + * @expected_read_value: the value expected to be read from @address. Set to 'X'
> + *                       to skip checking current value at @address.
> + * @write_value: the value to write to @address. Set to 'X' to skip writing
> + *               value to @address.
> + */
> +static void host_use_memory(char *address, char expected_read_value,
> +			    char write_value)
> +{
> +	if (expected_read_value != 'X')
> +		TEST_ASSERT_EQ(*address, expected_read_value);
> +
> +	if (write_value != 'X')
> +		*address = write_value;
> +}
> +
> +static void assert_host_cannot_fault(char *address)
> +{
> +	pid_t child_pid;
> +
> +	child_pid = fork();
> +	TEST_ASSERT(child_pid != -1, "fork failed");
> +
> +	if (child_pid == 0) {
> +		*address = 'A';
> +		TEST_FAIL("Child should have exited with a signal");
> +	} else {
> +		int status;
> +
> +		waitpid(child_pid, &status, 0);
> +
> +		TEST_ASSERT(WIFSIGNALED(status),
> +			    "Child should have exited with a signal");
> +		TEST_ASSERT_EQ(WTERMSIG(status), SIGBUS);

This is just TEST_EXPECT_SIGBUS(), right?  But in a rather weird way.  It does
highlight a testcase that's missing: fork() and _then_ convert private to ensure
the new mm_struct's PTEs are also unmapped.

> +static void *add_memslot(struct kvm_vm *vm, size_t memslot_size, int guest_memfd)
> +{
> +	struct userspace_mem_region *region;
> +	void *mem;
> +
> +	TEST_REQUIRE(guest_memfd > 0);
> +
> +	region = vm_mem_region_alloc(vm);
> +
> +	guest_memfd = vm_mem_region_install_guest_memfd(region, guest_memfd);
> +	mem = vm_mem_region_mmap(region, memslot_size, MAP_SHARED, guest_memfd, 0);
> +	vm_mem_region_install_memory(region, memslot_size, PAGE_SIZE);
> +
> +	region->region.slot = GUEST_MEMFD_SHARING_TEST_SLOT;
> +	region->region.flags = KVM_MEM_GUEST_MEMFD;
> +	region->region.guest_phys_addr = GUEST_MEMFD_SHARING_TEST_GPA;
> +	region->region.guest_memfd_offset = 0;
> +
> +	vm_mem_region_add(vm, region);
> +
> +	return mem;
> +}
> +
> +static struct kvm_vm *setup_test(size_t test_page_size, bool init_private,
> +				 struct kvm_vcpu **vcpu, int *guest_memfd,
> +				 char **mem)
> +{
> +	const struct vm_shape shape = {
> +		.mode = VM_MODE_DEFAULT,
> +		.type = KVM_X86_SW_PROTECTED_VM,
> +	};
> +	size_t test_nr_pages;
> +	struct kvm_vm *vm;
> +	uint64_t flags;
> +
> +	test_nr_pages = test_page_size / PAGE_SIZE;
> +	vm = __vm_create_shape_with_one_vcpu(shape, vcpu, test_nr_pages, NULL);
> +
> +	flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +	if (init_private)
> +		flags |= GUEST_MEMFD_FLAG_INIT_PRIVATE;
> +
> +	*guest_memfd = vm_create_guest_memfd(vm, test_page_size, flags);
> +	TEST_ASSERT(*guest_memfd > 0, "guest_memfd creation failed");
> +
> +	*mem = add_memslot(vm, test_page_size, *guest_memfd);
> +
> +	virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, GUEST_MEMFD_SHARING_TEST_GPA,
> +		 test_nr_pages);
> +
> +	return vm;
> +}
> +
> +static void cleanup_test(size_t guest_memfd_size, struct kvm_vm *vm,
> +			 int guest_memfd, char *mem)
> +{
> +	kvm_vm_free(vm);
> +	TEST_ASSERT_EQ(munmap(mem, guest_memfd_size), 0);
> +
> +	if (guest_memfd > -1)
> +		TEST_ASSERT_EQ(close(guest_memfd), 0);
> +}

This is a perfect test to utilize kselftest_harness.h and fixtures.  That'll cut
down on the boilerplate by a lot, and spitting out which test is running is super
useful, e.g. if something completely blows up.

A big bonus with the harness is that it runs each test in a separate process,
and so the gup pinning stuff can do TEST_REQUIRE() and show up as a Skip without
any real effort.

> +static void test_sharing(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int guest_memfd;
> +	char *mem;
> +
> +	vm = setup_test(PAGE_SIZE, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
> +
> +	host_use_memory(mem, 'X', 'A');
> +	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'A', 'B', 0);
> +
> +	/* Toggle private flag of memory attributes and run the test again. */
> +	guest_memfd_convert_private(guest_memfd, 0, PAGE_SIZE);
> +
> +	assert_host_cannot_fault(mem);
> +	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'B', 'C', 0);
> +
> +	guest_memfd_convert_shared(guest_memfd, 0, PAGE_SIZE);
> +
> +	host_use_memory(mem, 'C', 'D');
> +	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'D', 'E', 0);
> +
> +	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);

There is so much boilerplate here that gets in the way of understanding what each
test is actually doing.  There's also quite a bit of easy coverage being left on
the table.  E.g. *every* conversion should check accessibility from both host and
guest.

Using a fixture and a collection of helpers, tests can be distilled down to
exactly what they're testing, e.g.

GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
{
	test_shared(t, 0, 0, 'A', 'B');
	test_convert_to_private(t, 0, 'B', 'C');
	test_convert_to_shared(t, 0, 'C', 'D', 'E');
}

GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
{
	test_private(t, 0, 0, 'A');
	test_convert_to_shared(t, 0, 'A', 'B', 'C');
	test_convert_to_private(t, 0, 'C', 'E');
}

/*
 * Test that even if there are no folios yet, conversion requests are recorded
 * in guest_memfd.
 */
GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation)
{
	test_convert_to_private(t, 0, 0, 'A');
	test_convert_to_shared(t, 0, 'A', 'B', 'C');
}

> +static void test_init_mappable_false(void)

This is a very misleading name.  It's testing that memory is initialized PRIVATE;
the memfd instance is still very much mmap()able.

> +	/*
> +	 * Fault 2 of the pages to test filemap range operations except when
> +	 * page_to_fault == second_page_to_fault.
> +	 */
> +	host_use_memory(mem + page_to_fault * PAGE_SIZE, 'X', 'A');
> +	host_use_memory(mem + second_page_to_fault * PAGE_SIZE, 'X', 'A');
> +
> +	guest_memfd_convert_private(guest_memfd, 0, total_size);
> +
> +	for (i = 0; i < total_nr_pages; ++i) {
> +		bool is_faulted;
> +		char expected;
> +
> +		assert_host_cannot_fault(mem + i * PAGE_SIZE);
> +
> +		is_faulted = i == page_to_fault || i == second_page_to_fault;
> +		expected = is_faulted ? 'A' : 'X';
> +		guest_use_memory(vcpu,
> +				 GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
> +				 expected, 'B', 0);
> +	}
> +
> +	guest_memfd_convert_shared(guest_memfd, 0, total_size);
> +
> +	for (i = 0; i < total_nr_pages; ++i) {
> +		host_use_memory(mem + i * PAGE_SIZE, 'B', 'C');
> +		guest_use_memory(vcpu,
> +				 GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
> +				 'C', 'D', 0);
> +	}

This is where helpers add a _lot_ of clarity.  Piecing together everything that's
going on makes it rather hard to see that the test is verifying that pages that
have been written to the guest.

Which reminds me, when we add conversion support, we also need to add a flag to
control whether or not contents are preserved.

Anyways, with helpers to handle the gory details, the flow of the testcase is
more apparent:

	/*
	 * Fault 2 of the pages to test filemap range operations except when
	 * page_to_fault == second_page_to_fault.
	 */
	host_do_rmw(t->mem, page_to_fault, 0, 'A');
	host_do_rmw(t->mem, second_page_to_fault, 0, 'A');

	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
	for (i = 0; i < nr_pages; ++i) {
		if (i == page_to_fault || i == second_page_to_fault)
			test_private(t, i, 'A', 'B');
		else
			test_private(t, i, 0, 'B');
	}

	for (i = 0; i < nr_pages; ++i)
		test_convert_to_shared(t, i, 'B', 'C', 'D');

> +
> +	cleanup_test(total_size, vm, guest_memfd, mem);
> +}
> +
> +static void test_conversion_if_not_all_folios_allocated(void)
> +{
> +	const int total_nr_pages = 16;
> +	int i;
> +
> +	for (i = 0; i < total_nr_pages; ++i)
> +		__test_conversion_if_not_all_folios_allocated(total_nr_pages, i);
> +}
> +
> +static void test_conversions_should_not_affect_surrounding_pages(void)

C is not Java.  Keep function names short and sweet, and add a comment if it's
not immediately obvious what semantics are being tested.  Something like
"partial_conversions" or just "single_page" conveys the basic gist.  The
"should not affect surrounding pages" is largely stating the obvious.

> +{
> +	struct kvm_vcpu *vcpu;
> +	int page_to_convert;
> +	struct kvm_vm *vm;
> +	size_t total_size;
> +	int guest_memfd;
> +	int nr_pages;
> +	char *mem;
> +	int i;
> +
> +	page_to_convert = 2;
> +	nr_pages = 4;
> +	total_size = PAGE_SIZE * nr_pages;
> +
> +	vm = setup_test(total_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
> +
> +	for (i = 0; i < nr_pages; ++i) {
> +		host_use_memory(mem + i * PAGE_SIZE, 'X', 'A');
> +		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,

Use getpagesize(), not PAGE_SIZE, otherwise this test will be unnecessarily difficult
to port to non-x86 architectures, where PAGE_SIZE isn't a compile-time constant.

> +				 'A', 'B', 0);
> +	}
> +
> +	guest_memfd_convert_private(guest_memfd, PAGE_SIZE * page_to_convert, PAGE_SIZE);
> +
> +
> +	for (i = 0; i < nr_pages; ++i) {
> +		char to_check;
> +
> +		if (i == page_to_convert) {
> +			assert_host_cannot_fault(mem + i * PAGE_SIZE);
> +			to_check = 'B';
> +		} else {
> +			host_use_memory(mem + i * PAGE_SIZE, 'B', 'C');
> +			to_check = 'C';
> +		}
> +
> +		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
> +				 to_check, 'D', 0);
> +	}
> +
> +	guest_memfd_convert_shared(guest_memfd, PAGE_SIZE * page_to_convert, PAGE_SIZE);
> +
> +
> +	for (i = 0; i < nr_pages; ++i) {
> +		host_use_memory(mem + i * PAGE_SIZE, 'D', 'E');
> +		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
> +				 'E', 'F', 0);
> +	}
> +
> +	cleanup_test(total_size, vm, guest_memfd, mem);
> +}

With fixtures and helpers:

GMEM_CONVERSION_TEST_INIT_SHARED_ITERATE(single_page, 4)
{
	int i;

	for (i = 0; i < nr_pages; ++i)
		test_shared(t, i, 0, 'A', 'B');

	for (i = 0; i < nr_pages; ++i) {
		if (i == test_page)
			test_convert_to_private(t, i, 'B', 'D');
		else
			test_shared(t, i, 'B', 'C', 'D');
	}

	for (i = 0; i < nr_pages; ++i) {
		if (i == test_page)
			test_convert_to_shared(t, i, 'D', 'E', 'F');
		else
			test_shared(t, i, 'D', 'E', 'F');
	}

	/* Reset memory back to zero for the next iteration. */
	for (i = 0; i < nr_pages; ++i)
		host_do_rmw(t->mem, i, 'F', 0);
}

> +
> +static void __test_conversions_should_fail_if_memory_has_elevated_refcount(
> +	int nr_pages, int page_to_convert)

Yeah, no :-)

With some hacks to avoid dependencies on "Refactor vm_mem_add to be more flexible",
this is what I have locally (I'll work with you off-list to get all of this into
RFC-worthy series).

Note, there's a lot of "magic" in the fixture framework, but it's "good magic" in
the sense that it takes care of a lot things that aren't at all interesting to
what's being tested, at the cost of making it difficult to understand certain
details.  E.g. where structures and stuff come from, their names, etc.  The big
different to me, versus the magic 'X' behavior, is that understanding the magic
is generally only necessary if you care about the gory, uninteresting things.
Understanding the testcases themselves is (hopefully) easier.

---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/guest_memfd_conversions_test.c        | 441 ++++++++++++++++++
 .../testing/selftests/kvm/guest_memfd_test.c  |  17 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  82 +++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++
 5 files changed, 561 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_conversions_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24b..ddc1bdd51b83 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -141,6 +141,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86 += memslot_perf_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
new file mode 100644
index 000000000000..024795d24521
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -0,0 +1,441 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, Google LLC.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include <linux/align.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "kselftest_harness.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall_common.h"
+#include "../../../../mm/gup_test.h"
+
+FIXTURE(gmem_conversions) {
+	struct kvm_vcpu *vcpu;
+	int gmem_fd;
+	char *mem;
+};
+
+typedef FIXTURE_DATA(gmem_conversions) test_data_t;
+
+FIXTURE_SETUP(gmem_conversions) { }
+
+static uint64_t page_size;
+
+static void guest_do_rmw(void);
+#define GUEST_MEMFD_SHARING_TEST_GVA 0x90000000ULL
+
+/*
+ * Defer setup until the individual test is invoked so that tests can specify
+ * the number of pages and flags for the guest_memfd instance.
+ */
+static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
+				      int gmem_flags)
+{
+	const size_t size = nr_pages * page_size;
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+	/*
+	 * Use high GPA above APIC_DEFAULT_PHYS_BASE to avoid clashing with
+	 * APIC_DEFAULT_PHYS_BASE.
+	 */
+	const uint64_t gpa = SZ_4G;
+	struct userspace_mem_region *region;
+	struct kvm_vm *vm;
+
+	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
+
+	t->gmem_fd = vm_create_guest_memfd(vm, size, gmem_flags);
+	TEST_ASSERT(t->gmem_fd >= 0, "guest_memfd creation failed");
+
+	virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, gpa, nr_pages);
+
+	/* Allocate and initialize new mem region structure. */
+	region = calloc(1, sizeof(*region));
+	TEST_ASSERT(region != NULL, "Insufficient Memory");
+
+	region->unused_phy_pages = sparsebit_alloc();
+	if (vm_arch_has_protected_memory(vm))
+		region->protected_phy_pages = sparsebit_alloc();
+
+	/*
+	 * Install a unique fd for each memslot so that the fd can be closed
+	 * when the region is deleted without needing to track if the fd is
+	 * owned by the framework or by the caller.
+	 */
+	region->region.guest_memfd = dup(t->gmem_fd);
+	TEST_ASSERT(region->region.guest_memfd >= 0,
+		    __KVM_SYSCALL_ERROR("dup()", region->region.guest_memfd));
+
+	t->mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, t->gmem_fd);
+	TEST_ASSERT(IS_ALIGNED((size_t)t->mem, getpagesize()), "unaligned mapping");
+
+	region->fd = -1;
+	region->offset = 0;
+	region->mmap_start = t->mem;
+	region->mmap_size = size;
+
+	region->host_mem = t->mem;
+	region->region.userspace_addr = (uint64_t)region->host_mem;
+	region->region.memory_size = size;
+
+	region->region.slot = 1;
+	region->region.flags = KVM_MEM_GUEST_MEMFD;
+	region->region.guest_phys_addr = gpa;
+	region->region.guest_memfd_offset = 0;
+
+	vm_insert_userspace_mem_region(vm, region);
+}
+
+FIXTURE_TEARDOWN(gmem_conversions)
+{
+	kvm_close(self->gmem_fd);
+	kvm_vm_free(self->vcpu->vm);
+}
+
+#define __GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
+static void __gmem_conversions_##test(test_data_t *t, int nr_pages);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	gmem_conversions_do_setup(self, __nr_pages, flags);			\
+	__gmem_conversions_##test(self, __nr_pages);				\
+}										\
+static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
+
+#define GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
+	__GMEM_CONVERSION_TEST(test, __nr_pages, (flags) | GUEST_MEMFD_FLAG_MMAP)
+
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
+#define __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, 0)
+
+#define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
+	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED_ITERATE(test, __nr_pages)		\
+static void ____gmem_conversions_##test(test_data_t *t, int nr_pages,		\
+					const int test_page);			\
+__GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)				\
+{										\
+	int i;									\
+										\
+	for (i = 0; i < __nr_pages; i++) {					\
+		____gmem_conversions_##test(t, __nr_pages, i);			\
+										\
+		gmem_set_shared(t->gmem_fd, 0, __nr_pages * page_size);		\
+		memset(t->mem, 0, __nr_pages * page_size);			\
+	}									\
+}										\
+static void ____gmem_conversions_##test(test_data_t *t, int nr_pages,		\
+					const int test_page)
+
+static int gup_test_fd;
+
+static void pin_pages(void *vaddr, uint64_t size)
+{
+	const struct pin_longterm_test args = {
+		.addr = (uint64_t)vaddr,
+		.size = size,
+		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
+	};
+
+	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	TEST_REQUIRE(gup_test_fd >= 0);
+
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+}
+
+static void unpin_pages(void)
+{
+	if (gup_test_fd > 0)
+		TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
+}
+
+struct guest_check_data {
+	void *mem;
+	char expected_val;
+	char write_val;
+};
+static struct guest_check_data guest_data;
+
+static void guest_do_rmw(void)
+{
+	for (;;) {
+		char *mem = READ_ONCE(guest_data.mem);
+
+		GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
+		WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
+
+		GUEST_SYNC(0);
+	}
+}
+
+static void __run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
+			       char expected_val, char write_val,
+			       int expected_errno)
+{
+	struct ucall uc;
+	int r;
+
+	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
+	guest_data.expected_val = expected_val;
+	guest_data.write_val = write_val;
+	sync_global_to_guest(vcpu->vm, guest_data);
+
+	for (;;) {
+		r = __vcpu_run(vcpu);
+		if (!r && get_ucall(vcpu, &uc) == UCALL_PRINTF) {
+			REPORT_GUEST_PRINTF(uc);
+			continue;
+		}
+		if (r == -1 && errno == EINTR)
+			continue;
+		break;
+	}
+
+	if (expected_errno) {
+		TEST_ASSERT_EQ(r, -1);
+		TEST_ASSERT_EQ(errno, expected_errno);
+
+		switch (expected_errno) {
+		case EFAULT:
+			TEST_ASSERT_EQ(vcpu->run->exit_reason, 0);
+			break;
+		case EACCES:
+			TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MEMORY_FAULT);
+			break;
+		}
+	} else {
+		TEST_ASSERT_EQ(r, 0);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_SYNC:
+			break;
+		case UCALL_PRINTF:
+		default:
+			TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
+			     char expected_val, char write_val)
+{
+	__run_guest_do_rmw(vcpu, pgoff, expected_val, write_val, 0);
+}
+
+static void host_do_rmw(char *mem, loff_t pgoff, char expected_val,
+			char write_val)
+{
+	TEST_ASSERT_EQ(READ_ONCE(mem[pgoff * page_size]), expected_val);
+	WRITE_ONCE(mem[pgoff * page_size], write_val);
+}
+
+static void test_private(test_data_t *t, loff_t pgoff, char starting_val,
+			 char write_val)
+{
+	TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
+	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
+	TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
+}
+
+static void test_convert_to_private(test_data_t *t, loff_t pgoff,
+				    char starting_val, char write_val)
+{
+	gmem_set_private(t->gmem_fd, pgoff * page_size, page_size);
+	test_private(t, pgoff, starting_val, write_val);
+}
+
+static void test_shared(test_data_t *t, loff_t pgoff, char starting_val,
+			char host_write_val, char write_val)
+{
+	host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
+	TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
+}
+
+static void test_convert_to_shared(test_data_t *t, loff_t pgoff,
+				   char starting_val, char host_write_val,
+				   char write_val)
+{
+	gmem_set_shared(t->gmem_fd, pgoff * page_size, page_size);
+	test_shared(t, pgoff, starting_val, host_write_val, write_val);
+}
+
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
+
+GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
+{
+	test_private(t, 0, 0, 'A');
+	test_convert_to_shared(t, 0, 'A', 'B', 'C');
+	test_convert_to_private(t, 0, 'C', 'E');
+}
+
+/*
+ * Test that even if there are no folios yet, conversion requests are recorded
+ * in guest_memfd.
+ */
+GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation)
+{
+	test_convert_to_private(t, 0, 0, 'A');
+	test_convert_to_shared(t, 0, 'A', 'B', 'C');
+}
+
+__GMEM_CONVERSION_TEST_INIT_SHARED(unallocated_folios, 16)
+{
+	const int page_to_fault = 1;
+	const int second_page_to_fault = 8;
+	int i;
+
+	/*
+	 * Fault 2 of the pages to test filemap range operations except when
+	 * page_to_fault == second_page_to_fault.
+	 */
+	host_do_rmw(t->mem, page_to_fault, 0, 'A');
+	host_do_rmw(t->mem, second_page_to_fault, 0, 'A');
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == page_to_fault || i == second_page_to_fault)
+			test_private(t, i, 'A', 'B');
+		else
+			test_private(t, i, 0, 'B');
+	}
+
+	for (i = 0; i < nr_pages; ++i)
+		test_convert_to_shared(t, i, 'B', 'C', 'D');
+}
+
+GMEM_CONVERSION_TEST_INIT_SHARED_ITERATE(single_page, 4)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; ++i)
+		test_shared(t, i, 0, 'A', 'B');
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_private(t, i, 'B', 'D');
+		else
+			test_shared(t, i, 'B', 'C', 'D');
+	}
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_shared(t, i, 'D', 'E', 'F');
+		else
+			test_shared(t, i, 'D', 'E', 'F');
+	}
+}
+
+/*
+ * This test depends on CONFIG_GUP_TEST to provide a kernel module that exposes
+ * pin_user_pages() to userspace.
+ */
+GMEM_CONVERSION_TEST_INIT_SHARED_ITERATE(elevated_refcount, 4)
+{
+	loff_t offset = test_page * page_size;
+	int ret, i;
+
+	pin_pages(t->mem + test_page * page_size, page_size);
+
+	for (i = 0; i < nr_pages; i++)
+		test_shared(t, i, 0, 'A', 'B');
+
+	ret = __gmem_set_private(t->gmem_fd, &offset, page_size);
+	TEST_ASSERT(ret == -1 && errno == EAGAIN,
+		    "Wanted EAGAIN on page %u, got %d (ret = %d)",
+		    test_page, errno, ret);
+	TEST_ASSERT_EQ(offset, test_page * page_size);
+
+	unpin_pages();
+
+	for (i = 0; i < nr_pages; i++) {
+		if (i == test_page)
+			test_convert_to_private(t, i, 'B', 'D');
+		else
+			test_shared(t, i, 'B', 'C', 'D');
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		if (i == test_page)
+			test_convert_to_shared(t, i, 'D', 'E', 'F');
+		else
+			test_shared(t, i, 'D', 'E', 'F');
+	}
+}
+
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
+__GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses, 2)
+{
+	pid_t child_pid;
+
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		WRITE_ONCE(t->mem[0], 'A');
+		while (READ_ONCE(t->mem[0]) != 'C')
+			cpu_relax();
+		TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[page_size], 'D'));
+
+		WRITE_ONCE(t->mem[0], 'D');
+		exit(0);
+	}
+
+	while (READ_ONCE(t->mem[0]) != 'A')
+		cpu_relax();
+
+	test_shared(t, 1, 0, 'A', 'B');
+	test_convert_to_private(t, 1, 'B', 'C');
+
+	test_shared(t, 0, 'A', 'B', 'C');
+
+	while (READ_ONCE(t->mem[0]) != 'D')
+		cpu_relax();
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) &
+		     KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	page_size = getpagesize();
+
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 26a650442671..7faf7b758980 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -489,28 +489,15 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
-static void report_unexpected_sigbus(int signum)
-{
-	TEST_FAIL("Unexpected SIGBUS(%d)\n", signum);
-}
-
 int main(int argc, char *argv[])
 {
-	struct sigaction sa_old, sa_new = {
-		.sa_handler = report_unexpected_sigbus,
-	};
+
 	unsigned long vm_types, vm_type;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
 	page_size = getpagesize();
 
-	/*
-	 * Register a SIGBUS handler so that unexpected SIGBUS errors, e.g. due
-	 * to test or KVM bugs, are reported as failures with backtraces.
-	 */
-	sigaction(SIGBUS, &sa_new, &sa_old);
-
 	/*
 	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
 	 * support guest_memfd have that support for the default VM type.
@@ -523,6 +510,4 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
-
-	sigaction(SIGBUS, &sa_old, NULL);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c610169933ef..c3d6db3d0eac 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -310,6 +310,16 @@ static inline bool kvm_has_cap(long cap)
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
+#define __gmem_ioctl(gmem_fd, cmd, arg)				\
+	kvm_do_ioctl(gmem_fd, cmd, arg)
+
+#define gmem_ioctl(gmem_fd, cmd, arg)				\
+({								\
+	int ret = __gmem_ioctl(gmem_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
+
 static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 
 #define __vm_ioctl(vm, cmd, arg)				\
@@ -394,6 +404,15 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+
+/*
+ * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows need
+ * significant enhancements to support multiple attributes.
+ */
+#define TEST_ASSERT_SUPPORTED_ATTRIBUTES(attr)					\
+	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,	\
+		    "Update me to support multiple attributes!");
+
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
@@ -404,12 +423,7 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 		.flags = 0,
 	};
 
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
 
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
@@ -427,6 +441,60 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, loff_t *offset,
+					       uint64_t size,
+					       uint64_t attributes)
+{
+	struct kvm_memory_attributes attr = {
+		.attributes = attributes,
+		.offset = *offset,
+		.size = size,
+		.flags = 0,
+	};
+	int r;
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	r = __gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+	*offset = attr.offset;
+	return r;
+}
+
+static inline int __gmem_set_private(int fd, loff_t *offset, uint64_t size)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline int __gmem_set_shared(int fd, loff_t *offset, uint64_t size)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0);
+}
+
+static inline void gmem_set_memory_attributes(int fd, loff_t offset,
+					      uint64_t size, uint64_t attributes)
+{
+	struct kvm_memory_attributes attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
+	};
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+}
+
+static inline void gmem_set_private(int fd, loff_t offset, uint64_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void gmem_set_shared(int fd, loff_t offset, uint64_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 
@@ -676,6 +744,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 	uint32_t flags);
+void vm_insert_userspace_mem_region(struct kvm_vm *vm,
+				    struct userspace_mem_region *region);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2a40d9620572..9fef20144682 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1124,6 +1124,23 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	vm_mem_add(vm, src_type, guest_paddr, slot, npages, flags, -1, 0);
 }
 
+void vm_insert_userspace_mem_region(struct kvm_vm *vm,
+				    struct userspace_mem_region *region)
+{
+	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
+
+	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	sparsebit_set_num(region->unused_phy_pages,
+			  region->region.guest_phys_addr >> vm->page_shift,
+			  region->region.memory_size / vm->page_size);
+
+	/* Add to quick lookup data structures */
+	vm_userspace_mem_region_gpa_insert(&vm->regions.gpa_tree, region);
+	vm_userspace_mem_region_hva_insert(&vm->regions.hva_tree, region);
+	hash_add(vm->regions.slot_hash, &region->slot_node, region->region.slot);
+}
+
 /*
  * Memslot to region
  *
@@ -2291,8 +2308,25 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
+static void report_unexpected_sigbus(int signum)
+{
+	TEST_FAIL("Unexpected SIGBUS(%d)\n", signum);
+}
+
+static void report_unexpected_sigsegv(int signum)
+{
+	TEST_FAIL("Unexpected SIGSEGV(%d)\n", signum);
+}
+
 void __attribute((constructor)) kvm_selftest_init(void)
 {
+	struct sigaction sigbus_sa = {
+		.sa_handler = report_unexpected_sigbus,
+	};
+	struct sigaction sigsegv_sa = {
+		.sa_handler = report_unexpected_sigsegv,
+	};
+
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
@@ -2300,6 +2334,14 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
 	kvm_selftest_arch_init();
+
+	/*
+	 * Register SIGBUS and SIGSEGV handlers so that unexpected errors, e.g.
+	 * due to test or KVM bugs, are reported as failures with backtraces.
+	 */
+	sigaction(SIGBUS, &sigbus_sa, NULL);
+	sigaction(SIGSEGV, &sigsegv_sa, NULL);
+
 }
 
 bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)

base-commit: f582f3cc5c93dff1260fcaa39f96f8bc8cdd0dbb
--



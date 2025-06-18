Return-Path: <kvm+bounces-49802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE2FADE27D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4525189CE1A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B181F417E;
	Wed, 18 Jun 2025 04:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b6NgWyPC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60921C187
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220686; cv=none; b=G/JYIFrLGrTXjcsU2qE0+LXAmUYKZOev5htBgR3BQRd9z9OA4h2SrifHwAl833t+nRHPod/n1VUhQ37iqPuP3ZCPM29jvNmHDeabLfRVXvm1GTTkMr8NTCumLUUTZF2+o5o46Esj52ylIVoi80NkCHBItSG5TsDaTs9459GW/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220686; c=relaxed/simple;
	bh=2Jqtawu84Q9SrYBX4lA8ZiNewBmhCKbdKZCBOzSNvpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iuhYPDXUlBF4NSpE2NP05ggGOxlsILXil9c7nTq0SjYlsK1xwVJ6oRLUdwQw4YB+4/P1lKqvoRAOgZCPuaBZFWyQdyssZjvZgKJjqhvLFZl+3fGul55tSvOjH5m1Fs0WHgUper9I4neHvyzsvoY2q5nj/Z6XA+4/fkTfV7KGkTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b6NgWyPC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7394772635dso4730109b3a.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220684; x=1750825484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WoxhG1S8O1qCut4arFiLH4UBmX2+J3LQcOUx3bB9Ok0=;
        b=b6NgWyPCtF+z62oZ+h9H2fsHxP49liOwfRPBp9J8DAPjEGZImx8FwC3bqXqk048Tts
         GSE3Sc5Rd/PX6M7bvXzyMG/RQMfKUnUaOsN8/ect7IY6xsWGMvFEqNy8oxACoEt8mpO2
         cFTcRqE/0HsxyLz6vXut2uCNoWBZ6e5IV0kEp7CPNkuYvgxRoR0dW+AkPOtHEaT6Ofw7
         vGkHzpoNZl42aEjFD0bEMMhWApNyda66jnM34up9p6+Zf8irOZu/L30oC1bhL+8LKuyJ
         14607rDmPXu0VQ/liyiu7W6ySbH1Aa0LS6hb9D7ZcNXfJUlC0FHwP12ZgjyrZNNLLxdC
         Ydmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220684; x=1750825484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoxhG1S8O1qCut4arFiLH4UBmX2+J3LQcOUx3bB9Ok0=;
        b=n19TLDmXXmfom1tYF62YkZsujtay2V+Yx6sTbFjhNcHioxYLq+RBu/s1zuCAEuTo1t
         mm8w5UmcLJcMo/fZSFCmdR8De6ZKBWPxuSGb2JqD0XOcsnjUCV+vqfPQBduPC6JLwMKy
         LoT5TatKxeNmwa58bklcUc98Dc6yJMb6wFpv1sBLyUQIIaFkCC4SqDwjV8LgHQ94cWgd
         KaSQz0ZkK3gLxvtQMaX1NrTj7AadRfgpKAemtJ8G4cogAQYv1M+ttXSuxhBT+oNXlVHe
         cVfF+UDuEtZ+QAsaBtoJ9FaoCtq79uOWLD8Suq63kt1CBYzVhCXvZ26WfAH1qct7J2Eb
         o7Lg==
X-Forwarded-Encrypted: i=1; AJvYcCW3hQ8hLtFq64mVYB0lcE/5GpIBgwYYIJQqIpIqXIG2Ho7EmZRGiIWshh2XtWyL06exJ+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzANLmK4MSpnb2l5JPCQXOELzKz6vA19nRcN42klP8/jNC1OhSU
	HXm88eg3P7tv7TXBRXjiE8JbTpEMtbGlph7omv82rPBYBJOOGtigwLQ3/oj/J0fuau+mIyNC4eJ
	PLZXoaPcdv2y//MSxLXm+Ng==
X-Google-Smtp-Source: AGHT+IGRxlGskSElixeUhJSmb5ty4gtUfs1We31V1IESMwh3sYJDl1lv5tpJbIlFfs6HerHhqMbCgDwzxe3q1rwB
X-Received: from pfbko19.prod.google.com ([2002:a05:6a00:4613:b0:746:18ec:d11a])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e02:b0:740:a52f:a126 with SMTP id d2e1a72fcca58-7489cf72a4fmr18059367b3a.9.1750220683719;
 Tue, 17 Jun 2025 21:24:43 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:20 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-12-jthoughton@google.com>
Subject: [PATCH v3 11/15] KVM: selftests: Add KVM Userfault mode to demand_paging_test
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add a way for the KVM_RUN loop to handle EFAULT exits when they are for
KVM_MEMORY_EXIT_FLAG_USERFAULT. In this case, preemptively handle the
UFFDIO_COPY or UFFDIO_CONTINUE if userfaultfd is also in use. This saves
the trip through the userfaultfd poll/read/WAKE loop.

When preemptively handling UFFDIO_COPY/CONTINUE, do so with
MODE_DONTWAKE, as there will not be a thread to wake. If a thread *does*
take the userfaultfd slow path, we will get a regular userfault, and we
will call handle_uffd_page_request() which will do a full wake-up. In
the EEXIST case, a wake-up will not occur. Make sure to call UFFDIO_WAKE
explicitly in this case.

When handling KVM userfaults, make sure to set the bitmap with
memory_order_release. Although it wouldn't affect the functionality of
the test (because memstress doesn't actually require any particular
guest memory contents), it is what userspace normally needs to do.

Add `-k` to set the test to use KVM Userfault.

Add the vm_mem_region_set_flags_userfault() helper for setting
`userfault_bitmap` and KVM_MEM_USERFAULT at the same time.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 139 +++++++++++++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  40 ++++-
 3 files changed, 176 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 315f5c9037b40..183c707310933 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -12,7 +12,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <linux/bitmap.h>
 #include <sys/syscall.h>
+#include <stdatomic.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -24,11 +26,21 @@
 #ifdef __NR_userfaultfd
 
 static int nr_vcpus = 1;
+static int num_uffds;
 static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static size_t demand_paging_size;
+static size_t host_page_size;
 static char *guest_data_prototype;
 
+static struct {
+	bool enabled;
+	int uffd_mode; /* set if userfaultfd is also in use */
+	struct uffd_desc **uffd_descs;
+} kvm_userfault_data;
+
+static void resolve_kvm_userfault(u64 gpa, u64 size);
+
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
@@ -41,8 +53,22 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	/* Let the guest access its memory */
+restart:
 	ret = _vcpu_run(vcpu);
-	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+	if (ret < 0 && errno == EFAULT && kvm_userfault_data.enabled) {
+		/* Check for userfault. */
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+			    "Got invalid exit reason: %x", run->exit_reason);
+		TEST_ASSERT(run->memory_fault.flags ==
+			    KVM_MEMORY_EXIT_FLAG_USERFAULT,
+			    "Got invalid memory fault exit: %llx",
+			    run->memory_fault.flags);
+		resolve_kvm_userfault(run->memory_fault.gpa,
+				      run->memory_fault.size);
+		goto restart;
+	} else
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+
 	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
 		TEST_ASSERT(false,
 			    "Invalid guest sync status: exit_reason=%s",
@@ -54,11 +80,10 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 }
 
-static int handle_uffd_page_request(int uffd_mode, int uffd,
-		struct uffd_msg *msg)
+static int resolve_uffd_page_request(int uffd_mode, int uffd, uint64_t addr,
+				     bool wake)
 {
 	pid_t tid = syscall(__NR_gettid);
-	uint64_t addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
 	int r;
@@ -71,7 +96,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		copy.src = (uint64_t)guest_data_prototype;
 		copy.dst = addr;
 		copy.len = demand_paging_size;
-		copy.mode = 0;
+		copy.mode = wake ? 0 : UFFDIO_COPY_MODE_DONTWAKE;
 
 		r = ioctl(uffd, UFFDIO_COPY, &copy);
 		/*
@@ -96,6 +121,7 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 
 		cont.range.start = addr;
 		cont.range.len = demand_paging_size;
+		cont.mode = wake ? 0 : UFFDIO_CONTINUE_MODE_DONTWAKE;
 
 		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
 		/*
@@ -119,6 +145,20 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 		TEST_FAIL("Invalid uffd mode %d", uffd_mode);
 	}
 
+	if (r < 0 && wake) {
+		/*
+		 * No wake-up occurs when UFFDIO_COPY/CONTINUE fails, but we
+		 * have a thread waiting. Wake it up.
+		 */
+		struct uffdio_range range = {0};
+
+		range.start = addr;
+		range.len = demand_paging_size;
+
+		TEST_ASSERT(ioctl(uffd, UFFDIO_WAKE, &range) == 0,
+			    "UFFDIO_WAKE failed: 0x%lx", addr);
+	}
+
 	ts_diff = timespec_elapsed(start);
 
 	PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
@@ -129,6 +169,58 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
 	return 0;
 }
 
+static int handle_uffd_page_request(int uffd_mode, int uffd,
+				    struct uffd_msg *msg)
+{
+	uint64_t addr = msg->arg.pagefault.address;
+
+	return resolve_uffd_page_request(uffd_mode, uffd, addr, true);
+}
+
+static void resolve_kvm_userfault(u64 gpa, u64 size)
+{
+	struct kvm_vm *vm = memstress_args.vm;
+	struct userspace_mem_region *region;
+	unsigned long *bitmap_chunk;
+	u64 page, gpa_offset;
+
+	region = (struct userspace_mem_region *) userspace_mem_region_find(
+		vm, gpa, (gpa + size - 1));
+
+	if (kvm_userfault_data.uffd_mode) {
+		/*
+		 * Resolve userfaults early, without needing to read them
+		 * off the userfaultfd.
+		 */
+		uint64_t hva = (uint64_t)addr_gpa2hva(vm, gpa);
+		struct uffd_desc **descs = kvm_userfault_data.uffd_descs;
+		int i, fd;
+
+		for (i = 0; i < num_uffds; ++i)
+			if (hva >= (uint64_t)descs[i]->va_start &&
+			    hva < (uint64_t)descs[i]->va_end)
+				break;
+
+		TEST_ASSERT(i < num_uffds,
+			    "Did not find userfaultfd for hva: %lx", hva);
+
+		fd = kvm_userfault_data.uffd_descs[i]->uffd;
+		resolve_uffd_page_request(kvm_userfault_data.uffd_mode, fd,
+					  hva, false);
+	} else {
+		uint64_t hva = (uint64_t)addr_gpa2hva(vm, gpa);
+
+		memcpy((char *)hva, guest_data_prototype, demand_paging_size);
+	}
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	page = gpa_offset / host_page_size;
+	bitmap_chunk = (unsigned long *)region->region.userfault_bitmap +
+		       page / BITS_PER_LONG;
+	atomic_fetch_and_explicit((_Atomic unsigned long *)bitmap_chunk,
+			~(1ul << (page % BITS_PER_LONG)), memory_order_release);
+}
+
 struct test_params {
 	int uffd_mode;
 	bool single_uffd;
@@ -136,6 +228,7 @@ struct test_params {
 	int readers_per_uffd;
 	enum vm_mem_backing_src_type src_type;
 	bool partition_vcpu_memory_access;
+	bool kvm_userfault;
 };
 
 static void prefault_mem(void *alias, uint64_t len)
@@ -149,6 +242,25 @@ static void prefault_mem(void *alias, uint64_t len)
 	}
 }
 
+static void enable_userfault(struct kvm_vm *vm, int slots)
+{
+	for (int i = 0; i < slots; ++i) {
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
+		struct userspace_mem_region *region;
+		unsigned long *userfault_bitmap;
+		int flags = KVM_MEM_USERFAULT;
+
+		region = memslot2region(vm, slot);
+		userfault_bitmap = bitmap_zalloc(region->mmap_size /
+						 host_page_size);
+		/* everything is userfault initially */
+		memset(userfault_bitmap, -1, region->mmap_size / host_page_size / CHAR_BIT);
+		printf("Setting bitmap: %p\n", userfault_bitmap);
+		vm_mem_region_set_flags_userfault(vm, slot, flags,
+						  userfault_bitmap);
+	}
+}
+
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct memstress_vcpu_args *vcpu_args;
@@ -159,12 +271,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	double vcpu_paging_rate;
 	struct kvm_vm *vm;
-	int i, num_uffds = 0;
+	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
+	host_page_size = getpagesize();
 
 	guest_data_prototype = malloc(demand_paging_size);
 	TEST_ASSERT(guest_data_prototype,
@@ -208,6 +321,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
+	if (p->kvm_userfault) {
+		TEST_REQUIRE(kvm_has_cap(KVM_CAP_USERFAULT));
+		kvm_userfault_data.enabled = true;
+		kvm_userfault_data.uffd_mode = p->uffd_mode;
+		kvm_userfault_data.uffd_descs = uffd_descs;
+		enable_userfault(vm, 1);
+	}
+
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -265,6 +386,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -k: Use KVM Userfault\n");
 	puts("");
 	exit(0);
 }
@@ -283,7 +405,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:c:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ahokm:u:d:b:s:v:c:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -326,6 +448,9 @@ int main(int argc, char *argv[])
 				    "Invalid number of readers per uffd %d: must be >=1",
 				    p.readers_per_uffd);
 			break;
+		case 'k':
+			p.kvm_userfault = true;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bee65ca087217..5642d075900f0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -630,6 +630,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
+struct userspace_mem_region *
+userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -639,6 +641,9 @@ static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
 #endif
 
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_mem_region_set_flags_userfault(struct kvm_vm *vm, uint32_t slot,
+				       uint32_t flags,
+				       unsigned long *userfault_bitmap);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ca1aa1699f8aa..3c215df1d2d84 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -694,7 +694,7 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
  * of the regions is returned.  Null is returned only when no overlapping
  * region exists.
  */
-static struct userspace_mem_region *
+struct userspace_mem_region *
 userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 {
 	struct rb_node *node;
@@ -1225,6 +1225,44 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 		ret, errno, slot, flags);
 }
 
+/*
+ * VM Memory Region Flags Set with a userfault bitmap
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   flags - Flags for the memslot
+ *   userfault_bitmap - The bitmap to use for KVM_MEM_USERFAULT
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the flags of the memory region specified by the value of slot,
+ * to the values given by flags. This helper adds a way to provide a
+ * userfault_bitmap.
+ */
+void vm_mem_region_set_flags_userfault(struct kvm_vm *vm, uint32_t slot,
+				       uint32_t flags,
+				       unsigned long *userfault_bitmap)
+{
+	int ret;
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, slot);
+
+	TEST_ASSERT(!userfault_bitmap ^ (flags & KVM_MEM_USERFAULT),
+		    "KVM_MEM_USERFAULT must be specified with a bitmap");
+
+	region->region.flags = flags;
+	region->region.userfault_bitmap = (__u64)userfault_bitmap;
+
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
+		"  rc: %i errno: %i slot: %u flags: 0x%x",
+		ret, errno, slot, flags);
+}
+
 /*
  * VM Memory Region Move
  *
-- 
2.50.0.rc2.692.g299adb8693-goog



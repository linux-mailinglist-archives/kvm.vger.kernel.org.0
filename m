Return-Path: <kvm+bounces-59485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E146BB8640
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1308C347662
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815A62DFF13;
	Fri,  3 Oct 2025 23:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COnD2lko"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DAF2DF12C
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533990; cv=none; b=t+5HPc6SsLFPzBlGE2BnveX2K4UrAK3doB78LG0JKyqIxnmYnnssbME5u82zbvHw3+Cppda2qmp6HfG98xRe5jhoCqOL2gikXSyUr+12U7wN0f1vBdJCFzRj5SqyWJ4FBsvUXamDrwyrgKSGRbsSbrGHFUMaLC2Pzt23bOrOA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533990; c=relaxed/simple;
	bh=6A3rm7M0SNfn/DEmaJmZ8IQYVrrLiungr00EjqUjHk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N+5tPiAc5+2bQ4BD5hmbdYd3jFQJ82Xvb4sp+fjEve+kHkaDnpLvTaCpP3e2loH+tiHXkgmGxokCIVL2sNoiUoYegzEsWioG5EHND1/ImsOsiAIRRk2EvGEspeTxjOnqhcWexhJUIA59CgAVJtv74MerJhQyv5gAHG6UjIGQ3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COnD2lko; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befb83so3193921a91.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533988; x=1760138788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oWL2l0x7QCaxAl9nbpgRZwNGP+fn2GN1l9LXkO0Ve1g=;
        b=COnD2lkoyYsSsZCfwPv5+pNhDTJBAIW3j9nOnhl8IaTyFIItBQIogwmmhQSZrScvXB
         OJeLwW0XM8DJwaObXScixN1o95eNJ2BwWm74MIuduFYGP0v3zZJzJL2auGon2lC3XIK+
         E2MFFaACpbvlir97nIr3imtbvsB5qnP1pZEoYRd8iDUiM2m5hSeUzuCQBTVnfTOP9MIN
         /b21VUJ5SkSscz1++qL/t2EaY/k3pGtxKjA+SD9zfD43b9i7ui4aFGD5tTgqDkZxiGMr
         KpsIipLDmt0Y87PKDVV/8RGGz5aKqSrWw8zIJdUfSlVq4Bex20pP7qjdSO2rIGXtT9oT
         NAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533988; x=1760138788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWL2l0x7QCaxAl9nbpgRZwNGP+fn2GN1l9LXkO0Ve1g=;
        b=OIUCXEwdCVS+teX6gOZQzOe6hnqUolk1sTiwzTpfRS7sVTP8UKVaEzwaa6mw99EpuQ
         FiT6Nr4BCvHMwtuLZyIeUYjYqv9PZRyK6/JrUguLY+lcWX5Yyw98Mp6gi1smuOV8WMK3
         pmswpIK5KIFxqlfdvF5uWxwiwvEHz7B5VVgW0ZRDcTbDFnSFbO4NSfcEi30uexvoJlrx
         EY38BIh+V+qt15E/q0yVm/1XEXIKkHiedQ7e+rxFPru8CzuyUbCakL8uAl+QfHn6g4uP
         5MLrG2OaZ88oItLTjjlYqEKldprNxcZ2ArG/e138jRWPocHY81zEZdz/InAXHlKn9EFE
         ev4Q==
X-Gm-Message-State: AOJu0YxBf1+bgmTuW8zubEnJgMmqOFkT+xvQFG1kK9QtU05dhD3ls9xe
	mX/ktFqvcoJLlUfZrrFAggvkSKJO8b+yVHS+nY83XNABgo2AquOllitgUbNLPRSH1BfdMw/W7ZZ
	8US4MCw==
X-Google-Smtp-Source: AGHT+IG6jhNH5LLVuE/VonOGTqxAkXKOoCKJ+ViZFBmtyFsLnGr4P81Fp/FlqkwNWy4JKdDWCIbTFL0NooA=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:338:3770:a496])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b07:b0:32b:cb15:5fdc
 with SMTP id 98e67ed59e1d1-339c27af443mr5341457a91.30.1759533987905; Fri, 03
 Oct 2025 16:26:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:26:02 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-10-seanjc@google.com>
Subject: [PATCH v2 09/13] KVM: selftests: Add wrappers for mmap() and munmap()
 to assert success
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add and use wrappers for mmap() and munmap() that assert success to reduce
a significant amount of boilerplate code, to ensure all tests assert on
failure, and to provide consistent error messages on failure.

No functional change intended.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 21 +++------
 .../testing/selftests/kvm/include/kvm_util.h  | 25 +++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 44 +++++++------------
 tools/testing/selftests/kvm/mmu_stress_test.c |  5 +--
 .../selftests/kvm/s390/ucontrol_test.c        | 16 +++----
 .../selftests/kvm/set_memory_region_test.c    | 17 ++++---
 6 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 9f98a067ab51..319fda4f5d53 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -50,8 +50,7 @@ static void test_mmap_supported(int fd, size_t total_size)
 	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
 
-	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	memset(mem, val, total_size);
 	for (i = 0; i < total_size; i++)
@@ -70,8 +69,7 @@ static void test_mmap_supported(int fd, size_t total_size)
 	for (i = 0; i < total_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
 
-	ret = munmap(mem, total_size);
-	TEST_ASSERT(!ret, "munmap() should succeed.");
+	kvm_munmap(mem, total_size);
 }
 
 static sigjmp_buf jmpbuf;
@@ -89,10 +87,8 @@ static void test_fault_overflow(int fd, size_t total_size)
 	const char val = 0xaa;
 	char *mem;
 	size_t i;
-	int ret;
 
-	mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	sigaction(SIGBUS, &sa_new, &sa_old);
 	if (sigsetjmp(jmpbuf, 1) == 0) {
@@ -104,8 +100,7 @@ static void test_fault_overflow(int fd, size_t total_size)
 	for (i = 0; i < total_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
 
-	ret = munmap(mem, map_size);
-	TEST_ASSERT(!ret, "munmap() should succeed.");
+	kvm_munmap(mem, map_size);
 }
 
 static void test_mmap_not_supported(int fd, size_t total_size)
@@ -351,10 +346,9 @@ static void test_guest_memfd_guest(void)
 					     GUEST_MEMFD_FLAG_INIT_SHARED);
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
 
-	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
+	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 	memset(mem, 0xaa, size);
-	munmap(mem, size);
+	kvm_munmap(mem, size);
 
 	virt_pg_map(vm, gpa, gpa);
 	vcpu_args_set(vcpu, 2, gpa, size);
@@ -362,8 +356,7 @@ static void test_guest_memfd_guest(void)
 
 	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 
-	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
+	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 	for (i = 0; i < size; i++)
 		TEST_ASSERT_EQ(mem[i], 0xff);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 26cc30290e76..ee60dbf5208a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -286,6 +286,31 @@ static inline bool kvm_has_cap(long cap)
 #define __KVM_SYSCALL_ERROR(_name, _ret) \
 	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
 
+static inline void *__kvm_mmap(size_t size, int prot, int flags, int fd,
+			       off_t offset)
+{
+	void *mem;
+
+	mem = mmap(NULL, size, prot, flags, fd, offset);
+	TEST_ASSERT(mem != MAP_FAILED, __KVM_SYSCALL_ERROR("mmap()",
+		    (int)(unsigned long)MAP_FAILED));
+
+	return mem;
+}
+
+static inline void *kvm_mmap(size_t size, int prot, int flags, int fd)
+{
+	return __kvm_mmap(size, prot, flags, fd, 0);
+}
+
+static inline void kvm_munmap(void *mem, size_t size)
+{
+	int ret;
+
+	ret = munmap(mem, size);
+	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+}
+
 /*
  * Use the "inner", double-underscore macro when reporting errors from within
  * other macros so that the name of ioctl() and not its literal numeric value
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6743fbd9bd67..83a721be7ec5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -741,13 +741,11 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	int ret;
 
 	if (vcpu->dirty_gfns) {
-		ret = munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
-		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		kvm_munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->run, vcpu_mmap_sz());
-	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	kvm_munmap(vcpu->run, vcpu_mmap_sz());
 
 	ret = close(vcpu->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
@@ -783,20 +781,16 @@ void kvm_vm_release(struct kvm_vm *vmp)
 static void __vm_mem_region_delete(struct kvm_vm *vm,
 				   struct userspace_mem_region *region)
 {
-	int ret;
-
 	rb_erase(&region->gpa_node, &vm->regions.gpa_tree);
 	rb_erase(&region->hva_node, &vm->regions.hva_tree);
 	hash_del(&region->slot_node);
 
 	sparsebit_free(&region->unused_phy_pages);
 	sparsebit_free(&region->protected_phy_pages);
-	ret = munmap(region->mmap_start, region->mmap_size);
-	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	kvm_munmap(region->mmap_start, region->mmap_size);
 	if (region->fd >= 0) {
 		/* There's an extra map when using shared memory. */
-		ret = munmap(region->mmap_alias, region->mmap_size);
-		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		kvm_munmap(region->mmap_alias, region->mmap_size);
 		close(region->fd);
 	}
 	if (region->region.guest_memfd >= 0)
@@ -1053,12 +1047,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
-	region->mmap_start = mmap(NULL, region->mmap_size,
-				  PROT_READ | PROT_WRITE,
-				  vm_mem_backing_src_alias(src_type)->flag,
-				  region->fd, 0);
-	TEST_ASSERT(region->mmap_start != MAP_FAILED,
-		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
+	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
+				      vm_mem_backing_src_alias(src_type)->flag,
+				      region->fd);
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -1129,12 +1120,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
-		region->mmap_alias = mmap(NULL, region->mmap_size,
-					  PROT_READ | PROT_WRITE,
-					  vm_mem_backing_src_alias(src_type)->flag,
-					  region->fd, 0);
-		TEST_ASSERT(region->mmap_alias != MAP_FAILED,
-			    __KVM_SYSCALL_ERROR("mmap()",  (int)(unsigned long)MAP_FAILED));
+		region->mmap_alias = kvm_mmap(region->mmap_size,
+					      PROT_READ | PROT_WRITE,
+					      vm_mem_backing_src_alias(src_type)->flag,
+					      region->fd);
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
@@ -1344,10 +1333,8 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %zi expected_min: %zi",
 		vcpu_mmap_sz(), sizeof(*vcpu->run));
-	vcpu->run = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
-		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
-	TEST_ASSERT(vcpu->run != MAP_FAILED,
-		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
+	vcpu->run = kvm_mmap(vcpu_mmap_sz(), PROT_READ | PROT_WRITE,
+			     MAP_SHARED, vcpu->fd);
 
 	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
 		vcpu->stats.fd = vcpu_get_stats_fd(vcpu);
@@ -1794,9 +1781,8 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 			    page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
 		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped exec");
 
-		addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd,
-			    page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
-		TEST_ASSERT(addr != MAP_FAILED, "Dirty ring map failed");
+		addr = __kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd,
+				  page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
 
 		vcpu->dirty_gfns = addr;
 		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 6a437d2be9fa..37b7e6524533 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -339,8 +339,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
 
 	fd = kvm_memfd_alloc(slot_size, hugepages);
-	mem = mmap(NULL, slot_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "mmap() failed");
+	mem = kvm_mmap(slot_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	TEST_ASSERT(!madvise(mem, slot_size, MADV_NOHUGEPAGE), "madvise() failed");
 
@@ -413,7 +412,7 @@ int main(int argc, char *argv[])
 	for (slot = (slot - 1) & ~1ull; slot >= first_slot; slot -= 2)
 		vm_set_user_memory_region(vm, slot, 0, 0, 0, NULL);
 
-	munmap(mem, slot_size / 2);
+	kvm_munmap(mem, slot_size / 2);
 
 	/* Sanity check that the vCPUs actually ran. */
 	for (i = 0; i < nr_vcpus; i++)
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index d265b34c54be..50bc1c38225a 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -142,19 +142,17 @@ FIXTURE_SETUP(uc_kvm)
 	self->kvm_run_size = ioctl(self->kvm_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	ASSERT_GE(self->kvm_run_size, sizeof(struct kvm_run))
 		  TH_LOG(KVM_IOCTL_ERROR(KVM_GET_VCPU_MMAP_SIZE, self->kvm_run_size));
-	self->run = (struct kvm_run *)mmap(NULL, self->kvm_run_size,
-		    PROT_READ | PROT_WRITE, MAP_SHARED, self->vcpu_fd, 0);
-	ASSERT_NE(self->run, MAP_FAILED);
+	self->run = kvm_mmap(self->kvm_run_size, PROT_READ | PROT_WRITE,
+			     MAP_SHARED, self->vcpu_fd);
 	/**
 	 * For virtual cpus that have been created with S390 user controlled
 	 * virtual machines, the resulting vcpu fd can be memory mapped at page
 	 * offset KVM_S390_SIE_PAGE_OFFSET in order to obtain a memory map of
 	 * the virtual cpu's hardware control block.
 	 */
-	self->sie_block = (struct kvm_s390_sie_block *)mmap(NULL, PAGE_SIZE,
-			  PROT_READ | PROT_WRITE, MAP_SHARED,
-			  self->vcpu_fd, KVM_S390_SIE_PAGE_OFFSET << PAGE_SHIFT);
-	ASSERT_NE(self->sie_block, MAP_FAILED);
+	self->sie_block = __kvm_mmap(PAGE_SIZE, PROT_READ | PROT_WRITE,
+				     MAP_SHARED, self->vcpu_fd,
+				     KVM_S390_SIE_PAGE_OFFSET << PAGE_SHIFT);
 
 	TH_LOG("VM created %p %p", self->run, self->sie_block);
 
@@ -186,8 +184,8 @@ FIXTURE_SETUP(uc_kvm)
 
 FIXTURE_TEARDOWN(uc_kvm)
 {
-	munmap(self->sie_block, PAGE_SIZE);
-	munmap(self->run, self->kvm_run_size);
+	kvm_munmap(self->sie_block, PAGE_SIZE);
+	kvm_munmap(self->run, self->kvm_run_size);
 	close(self->vcpu_fd);
 	close(self->vm_fd);
 	close(self->kvm_fd);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ce3ac0fd6dfb..7fe427ff9b38 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -433,10 +433,10 @@ static void test_add_max_memory_regions(void)
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
 		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
 
-	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
-		   PROT_READ | PROT_WRITE,
-		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
+
+	mem = kvm_mmap((size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
+		       PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1);
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
 
 	for (slot = 0; slot < max_mem_slots; slot++)
@@ -446,9 +446,8 @@ static void test_add_max_memory_regions(void)
 					  mem_aligned + (uint64_t)slot * MEM_REGION_SIZE);
 
 	/* Check it cannot be added memory slots beyond the limit */
-	mem_extra = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
-			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	TEST_ASSERT(mem_extra != MAP_FAILED, "Failed to mmap() host");
+	mem_extra = kvm_mmap(MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
+			     MAP_PRIVATE | MAP_ANONYMOUS, -1);
 
 	ret = __vm_set_user_memory_region(vm, max_mem_slots, 0,
 					  (uint64_t)max_mem_slots * MEM_REGION_SIZE,
@@ -456,8 +455,8 @@ static void test_add_max_memory_regions(void)
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Adding one more memory slot should fail with EINVAL");
 
-	munmap(mem, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment);
-	munmap(mem_extra, MEM_REGION_SIZE);
+	kvm_munmap(mem, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment);
+	kvm_munmap(mem_extra, MEM_REGION_SIZE);
 	kvm_vm_free(vm);
 }
 
-- 
2.51.0.618.g983fd99d29-goog



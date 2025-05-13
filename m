Return-Path: <kvm+bounces-46371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3BBAB5A30
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5558F189363B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121FD2C086F;
	Tue, 13 May 2025 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tdsg+LwT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ADF2C0853
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154119; cv=none; b=ZOEHYSdqzK70raWZH+pFCv/Omrzf0gxCiUs0mB4zdpEtsZwcEWtL/FB9F1CcX+QREKSHLAHxvRVRGSpOQceD9dQFqIKHrFHrtaYWQfNP9xl7XaXqBGhNUJL1Z7+DqOIcUXMMcxWS2s9AfycuhQ1sIg3/IVZ7u3Kf6XbNnsu+SaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154119; c=relaxed/simple;
	bh=CC8kgOADI8RYHbWzLpyG2qMY6iKytGYMhxvjjgFTexU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W5hzrdfWzNqn40qsf14xGG6C0S8O22B40V+xaW3TyGb4zoUcb5jATgK0qMDfQCnbDNQUKhuPDVYMJwLgBw6N0yLi+KRaEiQdRXma2CuIvsHw3pSIG9HcgvG1RKdKsnjBNM2xahGKdF8ZAv3wZpfX0Ti+LXY3HJqUZEsb24L9AGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tdsg+LwT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442d472cf84so27251935e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154116; x=1747758916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTV9f3tL7yhwej+ROnqRZnQFKCSKbjeemsj3pSC/+aM=;
        b=tdsg+LwTiZEOiK33fa/D2HodzB/zEKELFwL4AIya3GOdkDynB2GbZ/2mbE0kRtd0CG
         ux9t7WjnnZyHnY8rvGZbaij8PVULgmHiCpNPzDdr0REdIwUr/uF6kGpT6eIHchfUW5SX
         4aWoPchrjSIzhUFDpQvpfm6wnWmYbvXXf+rsDloO3L4UMaVzVbkDonElhZstJdYdForP
         N3Z183EtO5WLHHmDfjbmVb6bg+ulUh021q6MYOy4OEHdBcIlNqS213zyljVoGSZorHk9
         /PzjZUBf6NA4CbgltJkUDoq0uNf6jAtavylx/sC66u2YKBfTdwgnjU7T7rWQdjMQn6VG
         oobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154116; x=1747758916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTV9f3tL7yhwej+ROnqRZnQFKCSKbjeemsj3pSC/+aM=;
        b=q/FZl8djSRvQOjQV+gSFa34YM3ly6qvmOaKBkDj0145tSaVvmVowQZENhQOyr6qvW8
         4AHHybjrjVkRbqfymeyHihqTaothSmFquI94ufrZccbffbNmlla+VeIm4i+8BxusQk3g
         6iPFUTrfhvJfGsVOiLGVBBoyu93cTKUkjVglmPp/5U/G7m7LL04ZBBp+vwlsGVqTxOe7
         kv/E/c63P95aIbiItxq31okwbFI4QxOmBzuvMAg3lsYEGLjWfYUBOMgIzKS4FS6BxwUU
         ib1zZRnNXvm8boCETcpt4yiMJxxIxtzBmC+8j+vnqsxZU3i6zfU0wSZD7oKljeZSbQR5
         Hb7g==
X-Gm-Message-State: AOJu0Yxk18nj/nBZqSv7K0/F093rHFBjEwoarVI2wQAEayEVjx9vDYRz
	iUQ+s4g5NMNAQ3WNCEqTZGHJRFSgMNsbCM3Tf9KZP383l8t8vNEF8kCWurWTc796caScqZIC7P2
	gpWzlj7f24Ae3tAhbIesrrQLovx1Z3uKjD9rJeNJT5axJKCL2VnnLhc2PdZsU2+kUVYawCxUE+k
	r8+vrbgENRLa5nX5BCzQTxzo4=
X-Google-Smtp-Source: AGHT+IF3CKWr5dNaEltZziFd3JjzPKtbdKkHc+WfmpUsuWTg9V5wBHK5NPq3RbL6OwinlprEvGRdG11d/w==
X-Received: from wmbbd22.prod.google.com ([2002:a05:600c:1f16:b0:43b:b74b:9350])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3511:b0:43d:ed:acd5
 with SMTP id 5b1f17b1804b1-442f20d5d72mr168515e9.10.1747154115630; Tue, 13
 May 2025 09:35:15 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:38 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-18-tabba@google.com>
Subject: [PATCH v9 17/17] KVM: selftests: Test guest_memfd same-range validation
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Add some selftests for guest_memfd same-range validation, which check
that the slot userspace_addr covers the same range as the memory in
guest_memfd:

+ When slot->userspace_addr is set to 0, there should be no range
  match validation on guest_memfd binding.
+ guest_memfd binding should fail if
    + slot->userspace_addr is not from guest_memfd
    + slot->userspace_addr is mmap()ed from some other file
    + slot->userspace_addr is mmap()ed from some other guest_memfd
    + slot->userspace_addr is mmap()ed from a different range in the
      same guest_memfd
+ guest_memfd binding should succeed if slot->userspace_addr is
  mmap()ed from the same range in the same guest_memfd provided in
  slot->guest_memfd

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 168 ++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 443c49185543..60aaba5808a5 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -197,6 +197,173 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
+#define GUEST_MEMFD_TEST_SLOT 10
+#define GUEST_MEMFD_TEST_GPA 0x100000000
+
+static void
+test_bind_guest_memfd_disabling_range_match_validation(struct kvm_vm *vm,
+						       int fd)
+{
+	size_t page_size = getpagesize();
+	int ret;
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size, 0,
+					   fd, 0);
+	TEST_ASSERT(!ret,
+		    "setting slot->userspace_addr to 0 should disable validation");
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, 0, 0,
+					   fd, 0);
+	TEST_ASSERT(!ret, "Deleting memslot should work");
+}
+
+static void
+test_bind_guest_memfd_anon_memory_in_userspace_addr(struct kvm_vm *vm, int fd)
+{
+	size_t page_size = getpagesize();
+	void *userspace_addr;
+	int ret;
+
+	userspace_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size,
+					   userspace_addr, fd, 0);
+	TEST_ASSERT(ret == -1,
+		    "slot->userspace_addr is not from the guest_memfd and should fail");
+}
+
+static void test_bind_guest_memfd_shared_memory_other_file_in_userspace_addr(
+	struct kvm_vm *vm, int fd)
+{
+	size_t page_size = getpagesize();
+	void *userspace_addr;
+	int other_fd;
+	int ret;
+
+	other_fd = memfd_create("shared_memory_other_file", 0);
+	TEST_ASSERT(other_fd > 0, "Creating other file should succeed");
+
+	userspace_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			      MAP_SHARED, other_fd, 0);
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size,
+					   userspace_addr, fd, 0);
+	TEST_ASSERT(ret == -1,
+		    "slot->userspace_addr is not from the guest_memfd and should fail");
+
+	TEST_ASSERT(!munmap(userspace_addr, page_size),
+		    "munmap() to cleanup should succeed");
+
+	close(other_fd);
+}
+
+static void
+test_bind_guest_memfd_other_guest_memfd_in_userspace_addr(struct kvm_vm *vm,
+							  int fd)
+{
+	size_t page_size = getpagesize();
+	void *userspace_addr;
+	int other_fd;
+	int ret;
+
+	other_fd = vm_create_guest_memfd(vm, page_size * 2,
+					 GUEST_MEMFD_FLAG_SUPPORT_SHARED);
+	TEST_ASSERT(other_fd > 0, "Creating other file should succeed");
+
+	userspace_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			      MAP_SHARED, other_fd, 0);
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size,
+					   userspace_addr, fd, 0);
+	TEST_ASSERT(ret == -1,
+		    "slot->userspace_addr is not from the guest_memfd and should fail");
+
+	TEST_ASSERT(!munmap(userspace_addr, page_size),
+		    "munmap() to cleanup should succeed");
+
+	close(other_fd);
+}
+
+static void
+test_bind_guest_memfd_other_range_in_userspace_addr(struct kvm_vm *vm, int fd)
+{
+	size_t page_size = getpagesize();
+	void *userspace_addr;
+	int ret;
+
+	userspace_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			      MAP_SHARED, fd, page_size);
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size,
+					   userspace_addr, fd, 0);
+	TEST_ASSERT(ret == -1,
+		    "slot->userspace_addr is not from the same range and should fail");
+
+	TEST_ASSERT(!munmap(userspace_addr, page_size),
+		    "munmap() to cleanup should succeed");
+}
+
+static void
+test_bind_guest_memfd_same_range_in_userspace_addr(struct kvm_vm *vm, int fd)
+{
+	size_t page_size = getpagesize();
+	void *userspace_addr;
+	int ret;
+
+	userspace_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			      MAP_SHARED, fd, page_size);
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, page_size,
+					   userspace_addr, fd, page_size);
+	TEST_ASSERT(!ret,
+		    "slot->userspace_addr is the same range and should succeed");
+
+	TEST_ASSERT(!munmap(userspace_addr, page_size),
+		    "munmap() to cleanup should succeed");
+
+	ret = __vm_set_user_memory_region2(vm, GUEST_MEMFD_TEST_SLOT,
+					   KVM_MEM_GUEST_MEMFD,
+					   GUEST_MEMFD_TEST_GPA, 0, 0,
+					   fd, 0);
+	TEST_ASSERT(!ret, "Deleting memslot should work");
+}
+
+static void test_bind_guest_memfd_wrt_userspace_addr(struct kvm_vm *vm)
+{
+	size_t page_size = getpagesize();
+	int fd;
+
+	if (!vm_check_cap(vm, KVM_CAP_GUEST_MEMFD) ||
+	    !vm_check_cap(vm, KVM_CAP_GMEM_SHARED_MEM))
+		return;
+
+	fd = vm_create_guest_memfd(vm, page_size * 2,
+				   GUEST_MEMFD_FLAG_SUPPORT_SHARED);
+
+	test_bind_guest_memfd_disabling_range_match_validation(vm, fd);
+	test_bind_guest_memfd_anon_memory_in_userspace_addr(vm, fd);
+	test_bind_guest_memfd_shared_memory_other_file_in_userspace_addr(vm, fd);
+	test_bind_guest_memfd_other_guest_memfd_in_userspace_addr(vm, fd);
+	test_bind_guest_memfd_other_range_in_userspace_addr(vm, fd);
+	test_bind_guest_memfd_same_range_in_userspace_addr(vm, fd);
+
+	close(fd);
+}
+
 static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
 			   bool expect_mmap_allowed)
 {
@@ -214,6 +381,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
 	vm = vm_create_barebones_type(vm_type);
 
 	test_create_guest_memfd_multiple(vm);
+	test_bind_guest_memfd_wrt_userspace_addr(vm);
 	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
 
 	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
-- 
2.49.0.1045.g170613ef41-goog



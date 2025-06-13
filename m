Return-Path: <kvm+bounces-49521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D78DDAD9636
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B40E3BAC64
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C09C25C80D;
	Fri, 13 Jun 2025 20:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HowZR+AQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851EF2580F9
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846205; cv=none; b=eEdTX5KTqT52TQ1Sbd/PGJtIpajfPZbjVERowBqRc4xxrm94XE6CwYr+IDMeqHFLNxSgg96JHt9vFIgOGVzohuMx4LRzGAtHg+l7fb3LfEBILis7nfL0iJrZ0Sz4OYN4qbrIpJ05B1KgtO5fjFgHuE1qokfPiucZXZ5mZvR+FJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846205; c=relaxed/simple;
	bh=+s8lvbpZhDXFyoRYKQSELvQ/5Jjwi3zyAM0kvEh6Tr0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YfITuepQDrYYrTtzTlbpuaQLOl2KAPs5vKYTA/SCo7nomZiX6POFhWC1HbxuDb07ZtcTORX1bG5VmGX2ofXLSJ2nTdJO7hPBgWXpTNNItgW7A8prSkPgj8bIIhKY3p97CmSUgLkE7PR/JJFFgdF6ITkba52JdINqzkEQnM8GBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HowZR+AQ; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4c58bbe00ebso335378137.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846202; x=1750451002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/oowTaT8IxzGDIxA/j6dpdZSttz1x30GttJGhE7+OY=;
        b=HowZR+AQXmir7gyWFLwFjEzu92K6BO/AIrGudW1imxRYom1JoZ2OotZZLV7/ci3l33
         DSthoYBNJhOH1YtJE/71ZX5GwGvPDhsswhB1BiS4y5aYYhSqEx46vjM1t72zYEqXvOMY
         AypcflsEv1BVmoYDVtNzBTVrCktI/qoqDTH/EmR4NZOiHzZe0yhZSW8trRI5WH2CzSGm
         +K8M2Pv62bZfEO7a9z4FsLSQUkbkRNU5ynn1XgcmjE8J/n65VW9P9WIN7J8HRfMfb6tj
         riPJV9zr7KF+jTQ1jx6c5E9CTgcCQr8DuHlAuW7C+1Uvovy/A5UQk3Dl0N43FtX5vts5
         Aaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846202; x=1750451002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/oowTaT8IxzGDIxA/j6dpdZSttz1x30GttJGhE7+OY=;
        b=Js40HaWDEFzPLX5Z4Sq3/C6aq3BAqINe7bRz/tY8rn4nJ2T08XZxKdcfYlaKHum00V
         50e9N5F7kzqCx7YwksrKyeMOzMqdRBou2jW+DVG+v/EOP1ENeVlKL8ZXU7HSBr+Fk0U4
         iveH9G1Bs8xnasQPXVBTmmag0fBp1nEHcDaFGPdfYFMpzNkQ8UeuRP0Sx4YnD6nT5tJL
         sBY9tZTQpXo5YNuFxG1xmrrq5zaEfRmX/M4FxSLgINk4xDKWB6HRqOSzbAhDk//QK9yk
         aEXN5jB9/p543VXn3VQMu1DpjM6z/3PKL2FeiUKK2O8NTg2JY0NSwDoSy7FsLJrBnwph
         7IgA==
X-Forwarded-Encrypted: i=1; AJvYcCW+VLd1fLufoZhXj38Je4vXPoxp8eXJtc9TecljZxhUH+V+8omCcJ0d4ZTDUz0WEvoPQAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhuDY71M490nlkP4a/fw1DKSv/zbWgXQewZnTYrUAU3MfCCt6j
	w5HxTK5sKrOvBC1DMQHsdQlvHR0Fz8hD0vipJSy+NMkIGvZ7COQBkas8ph12p9nTJfFuYXx8eLA
	FjFVOOWR1SAmhD0iqtEko5Q==
X-Google-Smtp-Source: AGHT+IHxaKiolznpwfnLRBcEVi+lYGI/Z4PCpjRHhhoRTcmajk2100XtSvVcUG2JLprcINDG3bQcwoT+FIF1sCOC
X-Received: from vsvc32.prod.google.com ([2002:a05:6102:3ca0:b0:4c5:802e:f808])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:8015:b0:4e2:a235:2483 with SMTP id ada2fe7eead31-4e7f621d421mr1415743137.19.1749846202537;
 Fri, 13 Jun 2025 13:23:22 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:13 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-7-jthoughton@google.com>
Subject: [PATCH v4 6/7] KVM: selftests: Provide extra mmap flags in vm_mem_add()
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The immediate application here is to allow selftests to pass
MAP_POPULATE (to time fault time without having to allocate guest
memory).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    |  3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 +++++++++------
 .../kvm/x86/private_mem_conversions_test.c        |  2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bee65ca087217..4aafd5bf786e2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -629,7 +629,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	uint32_t flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
+		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset,
+		int extra_mmap_flags);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf75..8157a0fd7f8b3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -977,13 +977,15 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-		uint32_t flags, int guest_memfd, uint64_t guest_memfd_offset)
+		uint32_t flags, int guest_memfd, uint64_t guest_memfd_offset,
+		int extra_mmap_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
 	size_t mem_size = npages * vm->page_size;
 	size_t alignment;
+	int mmap_flags;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
 
@@ -1066,9 +1068,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
+	mmap_flags = vm_mem_backing_src_alias(src_type)->flag |
+		     extra_mmap_flags;
+
 	region->mmap_start = mmap(NULL, region->mmap_size,
-				  PROT_READ | PROT_WRITE,
-				  vm_mem_backing_src_alias(src_type)->flag,
+				  PROT_READ | PROT_WRITE, mmap_flags,
 				  region->fd, 0);
 	TEST_ASSERT(region->mmap_start != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
@@ -1143,8 +1147,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
 		region->mmap_alias = mmap(NULL, region->mmap_size,
-					  PROT_READ | PROT_WRITE,
-					  vm_mem_backing_src_alias(src_type)->flag,
+					  PROT_READ | PROT_WRITE, mmap_flags,
 					  region->fd, 0);
 		TEST_ASSERT(region->mmap_alias != MAP_FAILED,
 			    __KVM_SYSCALL_ERROR("mmap()",  (int)(unsigned long)MAP_FAILED));
@@ -1159,7 +1162,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint64_t guest_paddr, uint32_t slot,
 				 uint64_t npages, uint32_t flags)
 {
-	vm_mem_add(vm, src_type, guest_paddr, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, guest_paddr, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 82a8d88b5338e..637e9e57fce46 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
-- 
2.50.0.rc2.692.g299adb8693-goog



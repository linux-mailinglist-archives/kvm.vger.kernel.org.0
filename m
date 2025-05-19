Return-Path: <kvm+bounces-46947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62567ABB36A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 04:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 025683B302E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 02:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2931DE2DC;
	Mon, 19 May 2025 02:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPVaCCM3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F431C9DC6;
	Mon, 19 May 2025 02:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747622423; cv=none; b=P1i3KNevQvY7L8EABT09PjCSJWQhOSXcuzZOHCfzagwY90OQCkWcPh51ZwFi5ALe5A1BHs20GTeE+Y/gWfqo5g/jdKVO3EP30FfvyXkv9WpYeLt6cV8dbQLlhw2tqStJlabwRznLzHPpyYw7+LjENcc9Wz8jReM/KVhZ04cFyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747622423; c=relaxed/simple;
	bh=ePRNQ6U3OVkGRddknbUFGYPgzi3krex/eUxPMOk4TLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lin4OpvN1QKcONlrfpnjjidhvDPHGtl9yuwEMUbr3V7GDB5hCfN5aNA/yCSX+7wOPiGZb6lc2BrrS6GEG5ELGARlIHbZhAQaTXQ2yaEjoKkgs5PK60LQ8VCFDjPmnpW9Air8cTakENaGJ6nmQuTd51ZwXZR7qIOHDPAqPfFjfUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPVaCCM3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747622421; x=1779158421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ePRNQ6U3OVkGRddknbUFGYPgzi3krex/eUxPMOk4TLg=;
  b=QPVaCCM3QJzY5XNLku5AQ+r3/pPXaA5QSrvzx+Y6X7kIuJNfgXKrARSX
   NO7fSFS5M/8jj8QMlTl/ZUYkUIon/ifmsBngE5JY4peqU6YG9/Ra2RVkh
   WnNlgjhdi7BVk9aaPF2GurMiFruOLGGlvWewowqEosCYgqfJVQRO0/wh9
   C381h0EWR7vspH23d+09FJKLtFUeuqUc/lPKJmNN2rHQgINkFKuchmsxw
   ZHR1KqgHE/4r9x7E3P20SxGl7oE1EgKZXOF9dB7KedVXpVk0UXgDPdqFc
   pwC+kEfSer73a0bGcnfOKdGRSesnno+LAIqULEXnGdNA8wYGH1vsGhJeK
   Q==;
X-CSE-ConnectionGUID: 5tHhmLMUS3aACoe8NSkA4g==
X-CSE-MsgGUID: c5F+PrPuQo6hBf08sD9zkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="53183550"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="53183550"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:40:19 -0700
X-CSE-ConnectionGUID: Hley6XJfTauLnyjDbBl/wA==
X-CSE-MsgGUID: pcG+fH3wSt+Xhb5am6bYkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139732973"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 19:40:17 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/2] KVM: selftests: Test prefault memory with concurrent memslot removal
Date: Mon, 19 May 2025 10:38:15 +0800
Message-ID: <20250519023815.30384-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250519023613.30329-1-yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new test case in pre_fault_memory_test to run vm_mem_region_delete()
concurrently with ioctl KVM_PRE_FAULT_MEMORY. Both of them should complete.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 82 +++++++++++++++----
 1 file changed, 67 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..c82dfc033a7b 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -10,12 +10,16 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <pthread.h>
 
 /* Arbitrarily chosen values */
 #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
 #define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
 #define TEST_SLOT		10
 
+static bool prefault_ready;
+static bool delete_thread_ready;
+
 static void guest_code(uint64_t base_gpa)
 {
 	volatile uint64_t val __used;
@@ -30,16 +34,41 @@ static void guest_code(uint64_t base_gpa)
 	GUEST_DONE();
 }
 
-static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
-			     u64 left)
+static void *remove_slot_worker(void *data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	WRITE_ONCE(delete_thread_ready, true);
+
+	while (!READ_ONCE(prefault_ready))
+		cpu_relax();
+
+	vm_mem_region_delete(vcpu->vm, TEST_SLOT);
+
+	WRITE_ONCE(delete_thread_ready, false);
+	return NULL;
+}
+
+static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
+			     u64 size, u64 left, bool private, bool remove_slot)
 {
 	struct kvm_pre_fault_memory range = {
-		.gpa = gpa,
+		.gpa = base_gpa + offset,
 		.size = size,
 		.flags = 0,
 	};
 	u64 prev;
 	int ret, save_errno;
+	pthread_t remove_thread;
+
+	if (remove_slot) {
+		pthread_create(&remove_thread, NULL, remove_slot_worker, vcpu);
+
+		while (!READ_ONCE(delete_thread_ready))
+			cpu_relax();
+
+		WRITE_ONCE(prefault_ready, true);
+	}
 
 	do {
 		prev = range.size;
@@ -51,16 +80,35 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
 			    ret < 0 ? "failure" : "success");
 	} while (ret >= 0 ? range.size : save_errno == EINTR);
 
-	TEST_ASSERT(range.size == left,
-		    "Completed with %lld bytes left, expected %" PRId64,
-		    range.size, left);
-
-	if (left == 0)
-		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
-	else
-		/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
-		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+	if (remove_slot) {
+		/*
+		 * ENOENT is expected if slot removal is performed earlier or
+		 * during KVM_PRE_FAULT_MEMORY;
+		 * On rare condition, ret could be 0 if KVM_PRE_FAULT_MEMORY
+		 * completes earlier than slot removal.
+		 */
+		__TEST_ASSERT_VM_VCPU_IOCTL((ret && save_errno == ENOENT) || !ret,
 					    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+
+		pthread_join(remove_thread, NULL);
+		WRITE_ONCE(prefault_ready, false);
+
+		vm_userspace_mem_region_add(vcpu->vm, VM_MEM_SRC_ANONYMOUS,
+					    base_gpa, TEST_SLOT, TEST_NPAGES,
+					    private ? KVM_MEM_GUEST_MEMFD : 0);
+	} else {
+		TEST_ASSERT(range.size == left,
+			    "Completed with %lld bytes left, expected %" PRId64,
+			    range.size, left);
+
+		if (left == 0)
+			__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY",
+						    ret, vcpu->vm);
+		else
+			/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
+			__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+						    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+	}
 }
 
 static void __test_pre_fault_memory(unsigned long vm_type, bool private)
@@ -97,9 +145,13 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
 	if (private)
 		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, 0);
-	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
+
+	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private, true);
+	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private, false);
+	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE,
+			 private, false);
+	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE,
+			 private, false);
 
 	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
 	vcpu_run(vcpu);
-- 
2.43.2



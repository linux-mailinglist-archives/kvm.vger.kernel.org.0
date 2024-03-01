Return-Path: <kvm+bounces-10666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1185D86E74A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 338D31C20381
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315F23B297;
	Fri,  1 Mar 2024 17:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IYC3RqoO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B04536AFB;
	Fri,  1 Mar 2024 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314190; cv=none; b=Mh7t7V2cb/Y9ZzBpnRl/ByuFlChKez8ok95m/Bku5pKAYzrnmMu0j+aShI/luESiGVKCVb0vugtbM0OoTFtt18qhjhMfgMSVZVIFt0lJrly/jVCJ93FOBSfuwWMSeD22LT/mgdKT3xzjdoakGvhmy5rI6j/S0Z9VMqN1ws0AtAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314190; c=relaxed/simple;
	bh=rMeKnysEBRBdToHOhbnPZufVGaLePQDq21ml1Kh/8Fs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jkxssSTpwCRlyAWBbgk4Vpl5jbRGY10U7MHVrpE6dv2BJOXGNqErlkgPWaiUW8uMT+khlLOO2XpB+If0U0NR20llLMxJyVBjc1cTUp2UQZmutZWmaicPbaGXrmCoGfsyNr+8csX+31OzbJIB5/j7McF11vmQQSXCD3UeZ08shqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IYC3RqoO; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314188; x=1740850188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rMeKnysEBRBdToHOhbnPZufVGaLePQDq21ml1Kh/8Fs=;
  b=IYC3RqoO49+1+97YU4jBP4dMVGVG8wj1CLQc/acS/HxGMvsSQplllj6S
   Wc/RH1t7cuxQD+zyzP9BD/8pyrJfAMqrn7x9khiH/hcfSk574swY3yO6X
   8cRMZncXOc/D/1lQR/nOeUsMOIeCsj6QdRrH2LxR03QI0Gc6IhNlFPrjM
   wlzYDSTG7rgKFr6fHSX6uVY1Z983qDuZudGfObKkw9LjkuXOrWeqJlBsL
   gdCOdvnVf+SX5N7epYbReDqYXx4ngCwrquEdgN8uGxi92z4V8jBBONf8f
   VqEMW1oQIB4q1Y9BjFa2REIY6MI7zs0CrhU6FXgzeCpEVUiJJzB8AX8Bm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812448"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812448"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946588"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:27 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 8/8] KVM: selftests: x86: Add test for KVM_MAP_MEMORY
Date: Fri,  1 Mar 2024 09:28:50 -0800
Message-Id: <ff83f599fc364276f4fd9a262770f88efdac4af4.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to exercise KVM_MAP_MEMORY and run the guest to access
pre-populated area. It tests KVM_MAP_MEMORY ioctl for KVM_X86_DEFAULT_VM
and KVM_X86_SW_PROTECTED_VM.  The other VM type is just for future place
hodler.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/include/uapi/linux/kvm.h                |  14 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/map_memory_test.c    | 136 ++++++++++++++++++
 3 files changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/map_memory_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..ea8d3cf840ab 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -2227,4 +2227,18 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
+
+#define KVM_MEMORY_MAPPING_FLAG_WRITE	_BITULL(0)
+#define KVM_MEMORY_MAPPING_FLAG_EXEC	_BITULL(1)
+#define KVM_MEMORY_MAPPING_FLAG_USER	_BITULL(2)
+#define KVM_MEMORY_MAPPING_FLAG_PRIVATE _BITULL(3)
+
+struct kvm_memory_mapping {
+	__u64 base_gfn;
+	__u64 nr_pages;
+	__u64 flags;
+	__u64 source;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index da20e6bb43ed..baef461ed38a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -142,6 +142,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += x86_64/map_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/x86_64/map_memory_test.c b/tools/testing/selftests/kvm/x86_64/map_memory_test.c
new file mode 100644
index 000000000000..9480c6c89226
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/map_memory_test.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 202r, Intel, Inc
+ *
+ * Author:
+ * Isaku Yamahata <isaku.yamahata at gmail.com>
+ */
+#include <linux/sizes.h>
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+/* Arbitrarily chosen value. Pick 3G */
+#define TEST_GVA		0xc0000000
+#define TEST_GPA		TEST_GVA
+#define TEST_SIZE		(SZ_2M + PAGE_SIZE)
+#define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
+#define TEST_SLOT		10
+
+static void guest_code(uint64_t base_gpa)
+{
+	volatile uint64_t val __used;
+	int i;
+
+	for (i = 0; i < TEST_NPAGES; i++) {
+		uint64_t *src = (uint64_t *)(base_gpa + i * PAGE_SIZE);
+
+		val = *src;
+	}
+
+	GUEST_DONE();
+}
+
+static void map_memory(struct kvm_vcpu *vcpu, u64 base_gfn, u64 nr_pages,
+		       u64 source, bool should_success)
+{
+	struct kvm_memory_mapping mapping = {
+		.base_gfn = base_gfn,
+		.nr_pages = nr_pages,
+		.flags = KVM_MEMORY_MAPPING_FLAG_WRITE,
+		.source = source,
+	};
+	int ret;
+
+	do {
+		ret = __vcpu_ioctl(vcpu, KVM_MAP_MEMORY, &mapping);
+	} while (ret && errno == EAGAIN);
+
+	if (should_success) {
+		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_MAP_MEMORY", ret, vcpu->vm);
+	} else {
+		__TEST_ASSERT_VM_VCPU_IOCTL(ret && errno == EFAULT,
+					    "KVM_MAP_MEMORY", ret, vcpu->vm);
+	}
+}
+
+static void __test_map_memory(unsigned long vm_type, bool private, bool use_source)
+{
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = vm_type,
+	};
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	u64 source;
+
+	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TEST_GPA, TEST_SLOT, TEST_NPAGES,
+				    private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, TEST_GVA, TEST_GPA, TEST_NPAGES);
+
+	if (private)
+		vm_mem_set_private(vm, TEST_GPA, TEST_SIZE);
+
+	source = use_source ? TEST_GVA: 0;
+	map_memory(vcpu, TEST_GPA / PAGE_SIZE, SZ_2M / PAGE_SIZE, source, true);
+	source = use_source ? TEST_GVA + SZ_2M: 0;
+	map_memory(vcpu, (TEST_GPA + SZ_2M) / PAGE_SIZE, 1, source, true);
+
+	source = use_source ? TEST_GVA + TEST_SIZE : 0;
+	map_memory(vcpu, (TEST_GPA + TEST_SIZE) / PAGE_SIZE, 1, source, false);
+
+	vcpu_args_set(vcpu, 1, TEST_GVA);
+	vcpu_run(vcpu);
+
+	run = vcpu->run;
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Wanted KVM_EXIT_IO, got exit reason: %u (%s)",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		break;
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_map_memory(unsigned long vm_type, bool use_source)
+{
+	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
+		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
+		return;
+	}
+
+	__test_map_memory(vm_type, false, use_source);
+	__test_map_memory(vm_type, true, use_source);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_MAP_MEMORY));
+
+	__test_map_memory(KVM_X86_DEFAULT_VM, false, false);
+	test_map_memory(KVM_X86_SW_PROTECTED_VM, false);
+#ifdef KVM_X86_SEV_VM
+	test_map_memory(KVM_X86_SEV_VM, false);
+#endif
+#ifdef KVM_X86_SEV_ES_VM
+	test_map_memory(KVM_X86_SEV_ES_VM, false);
+#endif
+#ifdef KVM_X86_TDX_VM
+	test_map_memory(KVM_X86_TDX_VM, true);
+#endif
+	return 0;
+}
-- 
2.25.1



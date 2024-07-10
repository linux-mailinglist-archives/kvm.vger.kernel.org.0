Return-Path: <kvm+bounces-21333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 378D892D7A3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E344F283A09
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA288198E6E;
	Wed, 10 Jul 2024 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ihMTIGOH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72605198852
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633248; cv=none; b=THZZwGOLDjL4StN6X6Tc9KDCWu+Bo2ZWd3KeXi09EF6vIut62Vl8eJGZQ4BfaitCwTvBFDaHKZ2OPT1bMAKT5d78iW0j22WHz4xyzw/DJt4L3N95gsFGbgE8yBgVA/ISc53TanThYO2sfqaxnIL3HoNCUuCwplke80xTgcB4C8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633248; c=relaxed/simple;
	bh=ZgDl7YevSAzG+4Ni1PpIylyYulQgnff78KyPOVSZVKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwIxMPPQMJKM1U5jbA61xG2xfZfWZwrD6qPY1UrlTb7pW1H6acB60Xb6hKjP1t81BT6D825l55BuudpfIS7iFl2Tcvebj8v6588vZBQ02jmXn7DR36L8c/I5IxE0p30JafJn+RhBMEPIMrg0ds8ZCnXHtT1roFu/tPARMJemvAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ihMTIGOH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720633245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IE+dzYp4sXVBM5yyZbzNy1entkQF8F7u9bJAf533tOY=;
	b=ihMTIGOHQ6X0BFzZUdCLoJ6yZPUqhZvDpNuXT7cyDNSCiv1N59IVE4XzVX4TDdTqsm7PIS
	jKp72mmEg+FChcpwiYIr73P/lKWpRTKyGoG8j6ZPmpDcLyjZHbChnypq+WhvkexVDVHHp8
	wB9gWozT+GXhiNNLv86P6fdEcuSlINs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-DkIJ2QHxOoSW4wLbLSNfPQ-1; Wed,
 10 Jul 2024 13:40:41 -0400
X-MC-Unique: DkIJ2QHxOoSW4wLbLSNfPQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C86611955F3B;
	Wed, 10 Jul 2024 17:40:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF46D195421C;
	Wed, 10 Jul 2024 17:40:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	seanjc@google.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v5 7/7] KVM: selftests: x86: Add test for KVM_PRE_FAULT_MEMORY
Date: Wed, 10 Jul 2024 13:40:31 -0400
Message-ID: <20240710174031.312055-8-pbonzini@redhat.com>
In-Reply-To: <20240710174031.312055-1-pbonzini@redhat.com>
References: <20240710174031.312055-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to exercise KVM_PRE_FAULT_MEMORY and run the guest to access the
pre-populated area.  It tests KVM_PRE_FAULT_MEMORY ioctl for KVM_X86_DEFAULT_VM
and KVM_X86_SW_PROTECTED_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <32427791ef42e5efaafb05d2ac37fa4372715f47.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/include/uapi/linux/kvm.h                |  14 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 146 ++++++++++++++++++
 3 files changed, 159 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index ea32b101b999..e5af8c692dc0 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_PRE_FAULT_MEMORY 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1221,9 +1222,9 @@ struct kvm_vfio_spapr_tce {
 /* Available with KVM_CAP_SPAPR_RESIZE_HPT */
 #define KVM_PPC_RESIZE_HPT_PREPARE _IOR(KVMIO, 0xad, struct kvm_ppc_resize_hpt)
 #define KVM_PPC_RESIZE_HPT_COMMIT  _IOR(KVMIO, 0xae, struct kvm_ppc_resize_hpt)
-/* Available with KVM_CAP_PPC_RADIX_MMU or KVM_CAP_PPC_MMU_HASH_V3 */
+/* Available with KVM_CAP_PPC_MMU_RADIX or KVM_CAP_PPC_MMU_HASH_V3 */
 #define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
-/* Available with KVM_CAP_PPC_RADIX_MMU */
+/* Available with KVM_CAP_PPC_MMU_RADIX */
 #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
@@ -1548,4 +1549,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
+
+struct kvm_pre_fault_memory {
+	__u64 gpa;
+	__u64 size;
+	__u64 flags;
+	__u64 padding[5];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce8ff8e8ce3a..e915d4ae1793 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -145,6 +145,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
new file mode 100644
index 000000000000..0350a8896a2f
--- /dev/null
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024, Intel, Inc
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
+/* Arbitrarily chosen values */
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
+static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
+			     u64 left)
+{
+	struct kvm_pre_fault_memory range = {
+		.gpa = gpa,
+		.size = size,
+		.flags = 0,
+	};
+	u64 prev;
+	int ret, save_errno;
+
+	do {
+		prev = range.size;
+		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
+		save_errno = errno;
+		TEST_ASSERT((range.size < prev) ^ (ret < 0),
+			    "%sexpecting range.size to change on %s",
+			    ret < 0 ? "not " : "",
+			    ret < 0 ? "failure" : "success");
+	} while (ret >= 0 ? range.size : save_errno == EINTR);
+
+	TEST_ASSERT(range.size == left,
+		    "Completed with %lld bytes left, expected %" PRId64,
+		    range.size, left);
+
+	if (left == 0)
+		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+	else
+		/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
+		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+					    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+}
+
+static void __test_pre_fault_memory(unsigned long vm_type, bool private)
+{
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = vm_type,
+	};
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	uint64_t guest_test_phys_mem;
+	uint64_t guest_test_virt_mem;
+	uint64_t alignment, guest_page_size;
+
+	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
+
+	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
+	guest_test_phys_mem = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
+#ifdef __s390x__
+	alignment = max(0x100000UL, guest_page_size);
+#else
+	alignment = SZ_2M;
+#endif
+	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
+	guest_test_virt_mem = guest_test_phys_mem & ((1ULL << (vm->va_bits - 1)) - 1);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
+				    private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);
+
+	if (private)
+		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
+	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, 0);
+	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
+	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
+
+	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
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
+static void test_pre_fault_memory(unsigned long vm_type, bool private)
+{
+	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
+		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
+		return;
+	}
+
+	__test_pre_fault_memory(vm_type, private);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
+
+	test_pre_fault_memory(0, false);
+#ifdef __x86_64__
+	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, false);
+	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, true);
+#endif
+	return 0;
+}
-- 
2.43.0



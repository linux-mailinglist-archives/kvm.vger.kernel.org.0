Return-Path: <kvm+bounces-14983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D028C8A87C3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CE23B261B7
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD515B980;
	Wed, 17 Apr 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKLHA6y5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57A1482F1
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368100; cv=none; b=DR12zUkQViUDdSmI1l2K3O/tPXVCHWYMrt0QZoQ0mTOojpbJN3N6gs50WzIITd8M3FedpkjroWP2b8iQ8NTEQMi9GLuR91v28UQVlkE4efLOiRY7ebzTVH0/PCymAkXPRBZPpzKF5yj4x79Vj/P9B4By/pY2LcEx/8jcNZm6934=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368100; c=relaxed/simple;
	bh=2OBq+23pCM3PkNKzgJeo539rzBtPFjT7bbLCv5kFpa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAn7+C5+5+j1NRbGKTaZi29kqA9tbS0tltHhtxt5ArbmLWHP3sWI37R0wd1iX9+dxn9ZUIOMwx+mpxYQ3kYQn0hZTZvLKS/0DfUpKiy+W4EcFNy3T/9nmIcbVhqElKHPS9bcwQstCj/h0coLEAw99uMEwHxo4q2QlVq/X7COGRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZKLHA6y5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOJHbzxI/eRU/siHQ5cJPVsyiTsUtZ2Sjfr3m4DsPPE=;
	b=ZKLHA6y5Em9jIkI007jwLsufIX5asPuJex3nfWPJDOcgY2h2Xar7FPpm83xYamxxIxefCI
	nZ4NP4pBAALjvOSzajRTp5ACyicvefPQAtlwfxIEtFhtLH1hqrrmoEZSd/h5kzTHpMSVHr
	VrBfYF9yaEnjDEK2XJeMPOHJyNz4yYI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-Xm1epxzaN_Oi-9_nzuTWtw-1; Wed, 17 Apr 2024 11:34:53 -0400
X-MC-Unique: Xm1epxzaN_Oi-9_nzuTWtw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E31B49C2F24;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2EC8581CD;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 7/7] KVM: selftests: x86: Add test for KVM_MAP_MEMORY
Date: Wed, 17 Apr 2024 11:34:50 -0400
Message-ID: <20240417153450.3608097-8-pbonzini@redhat.com>
In-Reply-To: <20240417153450.3608097-1-pbonzini@redhat.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to exercise KVM_MAP_MEMORY and run the guest to access the
pre-populated area.  It tests KVM_MAP_MEMORY ioctl for KVM_X86_DEFAULT_VM
and KVM_X86_SW_PROTECTED_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <32427791ef42e5efaafb05d2ac37fa4372715f47.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/include/uapi/linux/kvm.h                |   8 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/map_memory_test.c | 135 ++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/map_memory_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..69a43c5ae33c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -2227,4 +2227,12 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_map_memory)
+
+struct kvm_map_memory {
+	__u64 base_address;
+	__u64 size;
+	__u64 flags;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 871e2de3eb05..41def90f7dfb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += map_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/map_memory_test.c b/tools/testing/selftests/kvm/map_memory_test.c
new file mode 100644
index 000000000000..e52e33145f01
--- /dev/null
+++ b/tools/testing/selftests/kvm/map_memory_test.c
@@ -0,0 +1,135 @@
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
+static void map_memory(struct kvm_vcpu *vcpu, u64 base_address, u64 size,
+		       bool should_succeed)
+{
+	struct kvm_map_memory mapping = {
+		.base_address = base_address,
+		.size = size,
+		.flags = 0,
+	};
+	int ret;
+
+	do {
+		ret = __vcpu_ioctl(vcpu, KVM_MAP_MEMORY, &mapping);
+	} while (ret >= 0 && mapping.size);
+
+	if (should_succeed)
+		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_MAP_MEMORY", ret, vcpu->vm);
+	else
+		/* No memory slot causes RET_PF_EMULATE. it results in -EINVAL. */
+		__TEST_ASSERT_VM_VCPU_IOCTL(ret && errno == EINVAL,
+					    "KVM_MAP_MEMORY", ret, vcpu->vm);
+}
+
+static void __test_map_memory(unsigned long vm_type, bool private)
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
+	guest_test_virt_mem = guest_test_phys_mem;
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
+				    private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);
+
+	if (private)
+		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
+	map_memory(vcpu, guest_test_phys_mem, SZ_2M, true);
+	map_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE, true);
+	map_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, false);
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
+static void test_map_memory(unsigned long vm_type, bool private)
+{
+	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
+		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
+		return;
+	}
+
+	__test_map_memory(vm_type, private);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_MAP_MEMORY));
+
+	test_map_memory(0, false);
+#ifdef __x86_64__
+	test_map_memory(KVM_X86_SW_PROTECTED_VM, false);
+	test_map_memory(KVM_X86_SW_PROTECTED_VM, true);
+#endif
+	return 0;
+}
-- 
2.43.0



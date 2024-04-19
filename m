Return-Path: <kvm+bounces-15218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D038A8AAB13
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480EF1F21DDD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B817FBC0;
	Fri, 19 Apr 2024 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgnvDkPD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6667D08A
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517178; cv=none; b=ZDo7waaQOlGorADBZxVTHCw4FXHVIO117KWiPMTobN935StVyGbFqUBcDDdgBRC6MP5RrraD7NwkPycf7pyiBE3pYAjPhgqCHLqBuwF9V5eZLp1LynxPaTPFtsUHKTvtEq3hdgHWMpix7VHxCEnOhAuIEWY8Eehma7UIVbriNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517178; c=relaxed/simple;
	bh=2gm7deFzurYTAyrCh7iT1lNdC3GO1PyHSZi0isL2Ru8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fqqr6CpbkaAiSBhQmP7mDPpmOfjp6PS+u6Ey2BU9C8IXfAQpoF9qCHdkqcV0YJ9rDwPkzwwf7owt+rvkYs1N3/8vOeISPZ9CSHLIJz75tJVSiJcAY+W89/avIdw931AJfoIMNvRny6a3GnC6Qg7c+XqvGlGqY2HdWjoolg9voFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgnvDkPD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713517175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52y2schAwBprTYBvvMf3LjB6dQ9sxUly4DKTEx6UkQs=;
	b=bgnvDkPD+CN0IUJ2HT1AdEWaj2ogVj5yOBCLb+CTNDJPcYwHDpRtk8+i6GWL8gqqstQaB0
	pKaS7spL7A6TCIuAQ0Hx8fNLd/vRwnl3of+ean4SUIAQvARgKdGEmAo74Okf0dI8Ebntt1
	mybolgEGye5f0N6VacwqpYHln2YPB2o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-wGI1dtL0P9GJaIuPnMU1Vg-1; Fri,
 19 Apr 2024 04:59:30 -0400
X-MC-Unique: wGI1dtL0P9GJaIuPnMU1Vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDADD3811717;
	Fri, 19 Apr 2024 08:59:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACEB0203689B;
	Fri, 19 Apr 2024 08:59:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 6/6] KVM: selftests: x86: Add test for KVM_PRE_FAULT_MEMORY
Date: Fri, 19 Apr 2024 04:59:27 -0400
Message-ID: <20240419085927.3648704-7-pbonzini@redhat.com>
In-Reply-To: <20240419085927.3648704-1-pbonzini@redhat.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to exercise KVM_PRE_FAULT_MEMORY and run the guest to access the
pre-populated area.  It tests KVM_PRE_FAULT_MEMORY ioctl for KVM_X86_DEFAULT_VM
and KVM_X86_SW_PROTECTED_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <32427791ef42e5efaafb05d2ac37fa4372715f47.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/include/uapi/linux/kvm.h                |   8 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 146 ++++++++++++++++++
 3 files changed, 155 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..4d66d8afdcd1 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -2227,4 +2227,12 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
+
+struct kvm_pre_fault_memory {
+	__u64 gpa;
+	__u64 size;
+	__u64 flags;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 871e2de3eb05..61d581a4bab4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
new file mode 100644
index 000000000000..e56eed2c1f05
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
+	guest_test_virt_mem = guest_test_phys_mem;
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



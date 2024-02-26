Return-Path: <kvm+bounces-9980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF5D86806D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BECEF1C2410B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ACE132C0F;
	Mon, 26 Feb 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7nmAlnt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50B7130E3A
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974237; cv=none; b=GScWxYtyrY6EvMJ6+FYNEXB/sIx7ph+w4E+WUzsoRdEsVnxbRDWaCLwI6WCJT2QEdAn5r7B4vJkEYT4aDjmCgArOaWy5pJTO3CuKMVZQe7dj5tm3zZVQoJJYEacmaaxPVFXofMAaSGuth1ukCGYc3iEojq4F4tvDHXgaC52YrfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974237; c=relaxed/simple;
	bh=fRD1BrfJdyJvoSX8LcEovjuv85U/j/us3h7M0LsekaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljuSiCRQLfJ7FMMHRBBkyfqCTo3L3QGBrisacdhqpEMr5chFHl9jm7KRMyuLlsspcmdtUr4/CoG9WGsmPb8Gf05itVwV1ZwI0oERhLuck7IreyF9g9jWwnuaS1/Q5XzspsTV+tYrZzX3/rYLFye01rEdvB808bjtoktJDCkhhzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7nmAlnt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kIUqLwVlszgu1F/Gb9vCyE20JYmeyxZIjsEbTHT5iwg=;
	b=R7nmAlnttf7mveGK6rao4yjHw2mDC/HM07171iYsaQrajmhGGkSLYrVxGOPUpiMov91I2N
	ltg7oRoMHEFNSihA4S0v0tPgaYE8dNkqn99YKksPayLcYOYfGZkpCBE8XzfjaWP8kT+IVj
	JLZDLWpB5MDalR2zLoX7YVnCOiZM1bY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-DSZVxTk_N1yc-hMYEE-zCQ-1; Mon, 26 Feb 2024 14:03:49 -0500
X-MC-Unique: DSZVxTk_N1yc-hMYEE-zCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B75128F7765;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 917B0401A77C;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 15/15] selftests: kvm: add tests for KVM_SEV_INIT2
Date: Mon, 26 Feb 2024 14:03:44 -0500
Message-Id: <20240226190344.787149-16-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   6 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 149 ++++++++++++++++++
 4 files changed, 156 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce58098d80fd..0dcefabeae0c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -118,6 +118,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_init2_tests
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 070f250036fc..bb813cc9dcac 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -850,17 +850,15 @@ static inline struct kvm_vm *vm_create_barebones(void)
 	return ____vm_create(VM_SHAPE_DEFAULT);
 }
 
-#ifdef __x86_64__
-static inline struct kvm_vm *vm_create_barebones_protected_vm(void)
+static inline struct kvm_vm *vm_create_barebones_type(unsigned long type)
 {
 	const struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
-		.type = KVM_X86_SW_PROTECTED_VM,
+		.type = type,
 	};
 
 	return ____vm_create(shape);
 }
-#endif
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 {
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 06b43ed23580..904d58793fc6 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -339,7 +339,7 @@ static void test_invalid_memory_region_flags(void)
 
 #ifdef __x86_64__
 	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
-		vm = vm_create_barebones_protected_vm();
+		vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 	else
 #endif
 		vm = vm_create_barebones();
@@ -462,7 +462,7 @@ static void test_add_private_memory_region(void)
 
 	pr_info("Testing ADD of KVM_MEM_GUEST_MEMFD memory regions\n");
 
-	vm = vm_create_barebones_protected_vm();
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 
 	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
 	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
@@ -471,7 +471,7 @@ static void test_add_private_memory_region(void)
 	test_invalid_guest_memfd(vm, memfd, 0, "Regular memfd() should fail");
 	close(memfd);
 
-	vm2 = vm_create_barebones_protected_vm();
+	vm2 = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 	memfd = vm_create_guest_memfd(vm2, MEM_REGION_SIZE, 0);
 	test_invalid_guest_memfd(vm, memfd, 0, "Other VM's guest_memfd() should fail");
 
@@ -499,7 +499,7 @@ static void test_add_overlapping_private_memory_regions(void)
 
 	pr_info("Testing ADD of overlapping KVM_MEM_GUEST_MEMFD memory regions\n");
 
-	vm = vm_create_barebones_protected_vm();
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 
 	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE * 4, 0);
 
diff --git a/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
new file mode 100644
index 000000000000..fe55aa5a1b04
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kvm.h>
+#include <linux/psp-sev.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <pthread.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "kselftest.h"
+
+#define SVM_SEV_FEAT_DEBUG_SWAP 32u
+
+/*
+ * Some features may have hidden dependencies, or may only work
+ * for certain VM types.  Err on the side of safety and don't
+ * expect that all supported features can be passed one by one
+ * to KVM_SEV_INIT2.
+ *
+ * (Well, right now there's only one...)
+ */
+#define KNOWN_FEATURES SVM_SEV_FEAT_DEBUG_SWAP
+
+int kvm_fd;
+u64 supported_vmsa_features;
+bool have_sev_es;
+
+static int __sev_ioctl(int vm_fd, int cmd_id, void *data)
+{
+	struct kvm_sev_cmd cmd = {
+		.id = cmd_id,
+		.data = (uint64_t)data,
+		.sev_fd = open_sev_dev_path_or_exit(),
+	};
+	int ret;
+
+	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
+	TEST_ASSERT(ret < 0 || cmd.error == SEV_RET_SUCCESS,
+		    "%d failed: fw error: %d\n",
+		    cmd_id, cmd.error);
+
+	return ret;
+}
+
+static void test_init2(unsigned long vm_type, struct kvm_sev_init *init)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create_barebones_type(vm_type);
+	ret = __sev_ioctl(vm->fd, KVM_SEV_INIT2, init);
+	TEST_ASSERT(ret == 0,
+		    "KVM_SEV_INIT2 return code is %d (expected 0), errno: %d",
+		    ret, errno);
+	kvm_vm_free(vm);
+}
+
+static void test_init2_invalid(unsigned long vm_type, struct kvm_sev_init *init, const char *msg)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create_barebones_type(vm_type);
+	ret = __sev_ioctl(vm->fd, KVM_SEV_INIT2, init);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "KVM_SEV_INIT2 should fail, %s.",
+		    msg);
+	kvm_vm_free(vm);
+}
+
+void test_vm_types(void)
+{
+	test_init2(KVM_X86_SEV_VM, &(struct kvm_sev_init){});
+
+	/*
+	 * TODO: check that unsupported types cannot be created.  Probably
+	 * a separate selftest.
+	 */
+	if (have_sev_es)
+		test_init2(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});
+
+	test_init2_invalid(0, &(struct kvm_sev_init){},
+			   "VM type is KVM_X86_DEFAULT_VM");
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
+		test_init2_invalid(KVM_X86_SW_PROTECTED_VM, &(struct kvm_sev_init){},
+				   "VM type is KVM_X86_SW_PROTECTED_VM");
+}
+
+void test_flags(uint32_t vm_type)
+{
+	int i;
+
+	for (i = 0; i < 32; i++)
+		test_init2_invalid(vm_type,
+			&(struct kvm_sev_init){ .flags = BIT(i) },
+			"invalid flag");
+}
+
+void test_features(uint32_t vm_type, uint64_t supported_features)
+{
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		if (!(supported_features & (1u << i)))
+			test_init2_invalid(vm_type,
+				&(struct kvm_sev_init){ .vmsa_features = BIT_ULL(i) },
+				"unknown feature");
+		else if (KNOWN_FEATURES & (1u << i))
+			test_init2(vm_type,
+				&(struct kvm_sev_init){ .vmsa_features = BIT_ULL(i) });
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int kvm_fd = open_kvm_dev_path_or_exit();
+	bool have_sev;
+
+	TEST_REQUIRE(__kvm_has_device_attr(kvm_fd, 0, KVM_X86_SEV_VMSA_FEATURES) == 0);
+	kvm_device_attr_get(kvm_fd, 0, KVM_X86_SEV_VMSA_FEATURES, &supported_vmsa_features);
+
+	have_sev = kvm_cpu_has(X86_FEATURE_SEV);
+	TEST_ASSERT(have_sev == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_VM)),
+		    "sev: KVM_CAP_VM_TYPES (%x) does not match cpuid (checking %x)",
+		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_VM);
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_VM));
+	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
+
+	TEST_ASSERT(have_sev_es == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM)),
+		    "sev-es: KVM_CAP_VM_TYPES (%x) does not match cpuid (checking %x)",
+		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_ES_VM);
+
+	test_vm_types();
+
+	test_flags(KVM_X86_SEV_VM);
+	if (have_sev_es)
+		test_flags(KVM_X86_SEV_ES_VM);
+
+	test_features(KVM_X86_SEV_VM, 0);
+	if (have_sev_es)
+		test_features(KVM_X86_SEV_ES_VM, supported_vmsa_features);
+
+	return 0;
+}
-- 
2.39.1



Return-Path: <kvm+bounces-12059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E9887F420
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 394841C21226
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BB160DCC;
	Mon, 18 Mar 2024 23:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ce2wOZZU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1D604D4
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804846; cv=none; b=NVh7GgPiozVJWxb1d4H2VqeL/s14GOook6EDAmysktw+eBXidXNjYXlZhhRCwuGT7UiX9grr3EeOjVCY/Cf5JK/1B1OgkC3K959/+F86lmk3mzJrTXqQpnCTH6A2dSKGuMlClYbW9ZIi4kuptTKQoZRVzKnwkwPhi9epr5I0Uuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804846; c=relaxed/simple;
	bh=yvPRXzIIKDAIfgevV8qF3eGwbbk94yX5qOmDDJLLpbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfifKRgXDKLMg2HFEspsDN8liNFnupUSvQ1iMn0LBxLFZnSSr3RyzmBdhguYhqtUwVv7YjT3RaiUNRu4HcfAGHx+zwpfRlYK1BnkfbDGJFrbsBWDEYShn+H9PkrFl+pO28XSGzYMaT1RAMmSnXcYVm7ITzcOLqb+UJI3tAO4ZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ce2wOZZU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nCN1VFqRBOaII0g8pJNxNRo8ssZe/H2Y1D/pGPO3lwk=;
	b=Ce2wOZZUx1HI0/f3iaAUoZL4RydDARvS1dprYAJoROcI0SAoeLhaTuxxRp5D0NVnBJGWsF
	ZkZNwvWFXs/EXSudvn2gfYcgHCxGd4UU4HRn6NoDKRPUPjHk+tV08LMMafUwvdMqVVFukE
	O9H+H1wmVH0/a/+qKtzXJmYSibvv1vo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-4t9h6jgkPzSNAEaEQsLyzQ-1; Mon, 18 Mar 2024 19:33:57 -0400
X-MC-Unique: 4t9h6jgkPzSNAEaEQsLyzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF77101A56C;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8594C1C060A4;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 14/15] selftests: kvm: add tests for KVM_SEV_INIT2
Date: Mon, 18 Mar 2024 19:33:51 -0400
Message-ID: <20240318233352.2728327-15-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   6 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 149 ++++++++++++++++++
 4 files changed, 156 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..871e2de3eb05 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -120,6 +120,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_init2_tests
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/sev_smoke_test
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3e0db283a46a..7c06ceb36643 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -890,17 +890,15 @@ static inline struct kvm_vm *vm_create_barebones(void)
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
2.43.0




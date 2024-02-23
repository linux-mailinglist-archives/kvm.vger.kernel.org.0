Return-Path: <kvm+bounces-9517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C31860FB0
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE2801F2123A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061DE7F7CD;
	Fri, 23 Feb 2024 10:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFQJzgu3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B967AE75
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684821; cv=none; b=osWbQEbfsWnE3bR/p1fgEJPMiOgEjVb5gugG8blTp/pCVhmruCNQwwOpJTBoFgbciLIgINXIdAFFaHNG4+oyeZmnZWfq4BABqwP40aWArgdafVjv8A0QsZWZmH9B2NAC/GyV+sJcR22S4RSyX1ka7W5QpRAIVU00GLo0ciDtY14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684821; c=relaxed/simple;
	bh=MxHen5gZ4mUabNWwbFOU550bpEpTeJP+x6FtutXKCWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvJiqmtGH8FvU+neXv7TGt6nX29Ev52EBcrDjOTjh0JfmMXzm+WF8dFrTt2t+MCe25KpXuAqlPSgvPSEHscCT+aWtB8zxxiwD3J53P2dHRExt29vsILWfxm4L7nPYu5ytFKdg3o3ekISrLE+wV+efLSv3xmtHOzLLb+NhsLbbfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFQJzgu3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1kbnyH9FICEHgN6ZoJfgIOpveSUVH1COmtrpN3QbUA=;
	b=UFQJzgu38DtxO6h9+FE+JcV6/tGyi0UOlj2caV8Wd/PdFy2txCiFa5FdLbLwXISdXrNiqe
	al3SpYqKC4BKU7+Hh98zmesD4HV3rVsCf7fBcibx+JQf8MhqHnPtcpoAhZB2WgCipQWQW2
	AJTFV+eCc23aAl/HSIB4lGl71InXb2M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-9M76F_CEM-qdjABZYmJWLw-1; Fri,
 23 Feb 2024 05:40:13 -0500
X-MC-Unique: 9M76F_CEM-qdjABZYmJWLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7D1A3806723;
	Fri, 23 Feb 2024 10:40:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80E6A8CE8;
	Fri, 23 Feb 2024 10:40:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 11/11] selftests: kvm: add tests for KVM_SEV_INIT2
Date: Fri, 23 Feb 2024 05:40:09 -0500
Message-Id: <20240223104009.632194-12-pbonzini@redhat.com>
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
References: <20240223104009.632194-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-11-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   6 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 146 ++++++++++++++++++
 4 files changed, 153 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 492e937fab00..a81a89b1dc2a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_init2_tests
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9e5afc472c14..44b6ea56a205 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -846,17 +846,15 @@ static inline struct kvm_vm *vm_create_barebones(void)
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
index 075b80dbe237..0ac6c21d7251 100644
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
@@ -452,7 +452,7 @@ static void test_add_private_memory_region(void)
 
 	pr_info("Testing ADD of KVM_MEM_GUEST_MEMFD memory regions\n");
 
-	vm = vm_create_barebones_protected_vm();
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 
 	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
 	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
@@ -461,7 +461,7 @@ static void test_add_private_memory_region(void)
 	test_invalid_guest_memfd(vm, memfd, 0, "Regular memfd() should fail");
 	close(memfd);
 
-	vm2 = vm_create_barebones_protected_vm();
+	vm2 = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 	memfd = vm_create_guest_memfd(vm2, MEM_REGION_SIZE, 0);
 	test_invalid_guest_memfd(vm, memfd, 0, "Other VM's guest_memfd() should fail");
 
@@ -489,7 +489,7 @@ static void test_add_overlapping_private_memory_regions(void)
 
 	pr_info("Testing ADD of overlapping KVM_MEM_GUEST_MEMFD memory regions\n");
 
-	vm = vm_create_barebones_protected_vm();
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
 
 	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE * 4, 0);
 
diff --git a/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
new file mode 100644
index 000000000000..644fd5757041
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
@@ -0,0 +1,146 @@
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
+static void test_init2_invalid(unsigned long vm_type, struct kvm_sev_init *init)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create_barebones_type(vm_type);
+	ret = __sev_ioctl(vm->fd, KVM_SEV_INIT2, init);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "KVM_SEV_INIT2 return code %d, errno: %d (expected EINVAL)",
+		    ret, errno);
+	kvm_vm_free(vm);
+}
+
+void test_vm_types(void)
+{
+	test_init2(KVM_X86_SEV_VM, &(struct kvm_sev_init){});
+
+	if (have_sev_es)
+		test_init2(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});
+	else
+		test_init2_invalid(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});
+
+	test_init2_invalid(0, &(struct kvm_sev_init){});
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
+		test_init2_invalid(KVM_X86_SW_PROTECTED_VM, &(struct kvm_sev_init){});
+}
+
+void test_flags(uint32_t vm_type)
+{
+	int i;
+
+	for (i = 0; i < 32; i++)
+		test_init2_invalid(vm_type, &(struct kvm_sev_init){
+			.flags = 1u << i,
+		});
+}
+
+void test_features(uint32_t vm_type, uint64_t supported_features)
+{
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		if (!(supported_features & (1u << i)))
+			test_init2_invalid(vm_type, &(struct kvm_sev_init){
+				.vmsa_features = 1u << i,
+			});
+		else if (KNOWN_FEATURES & (1u << i))
+			test_init2(vm_type, &(struct kvm_sev_init){
+				.vmsa_features = 1u << i,
+			});
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



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8284A9D4A
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfIEIkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731641AbfIEIkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:41 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858bbmT032807
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:39 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2usu18k53p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:38 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:36 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:33 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eWQh10289270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 752AFA405B;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24811A406D;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 1/8] KVM: selftests: Split ucall.c into architecture specific files
Date:   Thu,  5 Sep 2019 10:40:02 +0200
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190905084009.26106-1-frankja@linux.ibm.com>
References: <20190905084009.26106-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-0016-0000-0000-000002A6FD90
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-0017-0000-0000-000033076EFF
Message-Id: <20190905084009.26106-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The way we exit from a guest to userspace is very specific to the
architecture: On x86, we use PIO, on aarch64 we are using MMIO and on
s390x we're going to use an instruction instead. The possibility to
select a type via the ucall_type_t enum is currently also completely
unused, so the code in ucall.c currently looks more complex than
required. Let's split this up into architecture specific ucall.c
files instead, so we can get rid of the #ifdefs and the unnecessary
ucall_type_t handling.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20190731151525.17156-2-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |   6 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   8 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 112 +++++++++++++
 tools/testing/selftests/kvm/lib/ucall.c       | 157 ------------------
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  56 +++++++
 6 files changed, 173 insertions(+), 168 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/ucall.c
 delete mode 100644 tools/testing/selftests/kvm/lib/ucall.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/ucall.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ba7849751989..a51e3b83df40 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -7,9 +7,9 @@ top_srcdir = ../../../..
 KSFT_KHDR_INSTALL := 1
 UNAME_M := $(shell uname -m)
 
-LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebit.c
-LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
-LIBKVM_aarch64 = lib/aarch64/processor.c
+LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
+LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/ucall.c
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x = lib/s390x/processor.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ceb52b952637..5d5ae1be4984 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -337,7 +337,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 #endif
 #ifdef __aarch64__
-	ucall_init(vm, UCALL_MMIO, NULL);
+	ucall_init(vm, NULL);
 #endif
 
 	/* Export the shared variables to the guest */
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e0e66b115ef2..5463b7896a0a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -165,12 +165,6 @@ int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
-/* ucall implementation types */
-typedef enum {
-	UCALL_PIO,
-	UCALL_MMIO,
-} ucall_type_t;
-
 /* Common ucalls */
 enum {
 	UCALL_NONE,
@@ -186,7 +180,7 @@ struct ucall {
 	uint64_t args[UCALL_MAX_ARGS];
 };
 
-void ucall_init(struct kvm_vm *vm, ucall_type_t type, void *arg);
+void ucall_init(struct kvm_vm *vm, void *arg);
 void ucall_uninit(struct kvm_vm *vm);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
new file mode 100644
index 000000000000..6cd91970fbad
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to userspace".
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ */
+#include "kvm_util.h"
+#include "../kvm_util_internal.h"
+
+static vm_vaddr_t *ucall_exit_mmio_addr;
+
+static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
+		return false;
+
+	virt_pg_map(vm, gpa, gpa, 0);
+
+	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
+	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+
+	return true;
+}
+
+void ucall_init(struct kvm_vm *vm, void *arg)
+{
+	vm_paddr_t gpa, start, end, step, offset;
+	unsigned int bits;
+	bool ret;
+
+	if (arg) {
+		gpa = (vm_paddr_t)arg;
+		ret = ucall_mmio_init(vm, gpa);
+		TEST_ASSERT(ret, "Can't set ucall mmio address to %lx", gpa);
+		return;
+	}
+
+	/*
+	 * Find an address within the allowed physical and virtual address
+	 * spaces, that does _not_ have a KVM memory region associated with
+	 * it. Identity mapping an address like this allows the guest to
+	 * access it, but as KVM doesn't know what to do with it, it
+	 * will assume it's something userspace handles and exit with
+	 * KVM_EXIT_MMIO. Well, at least that's how it works for AArch64.
+	 * Here we start with a guess that the addresses around 5/8th
+	 * of the allowed space are unmapped and then work both down and
+	 * up from there in 1/16th allowed space sized steps.
+	 *
+	 * Note, we need to use VA-bits - 1 when calculating the allowed
+	 * virtual address space for an identity mapping because the upper
+	 * half of the virtual address space is the two's complement of the
+	 * lower and won't match physical addresses.
+	 */
+	bits = vm->va_bits - 1;
+	bits = vm->pa_bits < bits ? vm->pa_bits : bits;
+	end = 1ul << bits;
+	start = end * 5 / 8;
+	step = end / 16;
+	for (offset = 0; offset < end - start; offset += step) {
+		if (ucall_mmio_init(vm, start - offset))
+			return;
+		if (ucall_mmio_init(vm, start + offset))
+			return;
+	}
+	TEST_ASSERT(false, "Can't find a ucall mmio address");
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+	ucall_exit_mmio_addr = 0;
+	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+}
+
+void ucall(uint64_t cmd, int nargs, ...)
+{
+	struct ucall uc = {
+		.cmd = cmd,
+	};
+	va_list va;
+	int i;
+
+	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
+
+	va_start(va, nargs);
+	for (i = 0; i < nargs; ++i)
+		uc.args[i] = va_arg(va, uint64_t);
+	va_end(va);
+
+	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+}
+
+uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+{
+	struct kvm_run *run = vcpu_state(vm, vcpu_id);
+	struct ucall ucall = {};
+
+	if (run->exit_reason == KVM_EXIT_MMIO &&
+	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+		vm_vaddr_t gva;
+
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
+			    "Unexpected ucall exit mmio address access");
+		memcpy(&gva, run->mmio.data, sizeof(gva));
+		memcpy(&ucall, addr_gva2hva(vm, gva), sizeof(ucall));
+
+		vcpu_run_complete_io(vm, vcpu_id);
+		if (uc)
+			memcpy(uc, &ucall, sizeof(ucall));
+	}
+
+	return ucall.cmd;
+}
diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
deleted file mode 100644
index dd9a66700f96..000000000000
--- a/tools/testing/selftests/kvm/lib/ucall.c
+++ /dev/null
@@ -1,157 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * ucall support. A ucall is a "hypercall to userspace".
- *
- * Copyright (C) 2018, Red Hat, Inc.
- */
-#include "kvm_util.h"
-#include "kvm_util_internal.h"
-
-#define UCALL_PIO_PORT ((uint16_t)0x1000)
-
-static ucall_type_t ucall_type;
-static vm_vaddr_t *ucall_exit_mmio_addr;
-
-static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
-{
-	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
-		return false;
-
-	virt_pg_map(vm, gpa, gpa, 0);
-
-	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
-
-	return true;
-}
-
-void ucall_init(struct kvm_vm *vm, ucall_type_t type, void *arg)
-{
-	ucall_type = type;
-	sync_global_to_guest(vm, ucall_type);
-
-	if (type == UCALL_PIO)
-		return;
-
-	if (type == UCALL_MMIO) {
-		vm_paddr_t gpa, start, end, step, offset;
-		unsigned bits;
-		bool ret;
-
-		if (arg) {
-			gpa = (vm_paddr_t)arg;
-			ret = ucall_mmio_init(vm, gpa);
-			TEST_ASSERT(ret, "Can't set ucall mmio address to %lx", gpa);
-			return;
-		}
-
-		/*
-		 * Find an address within the allowed physical and virtual address
-		 * spaces, that does _not_ have a KVM memory region associated with
-		 * it. Identity mapping an address like this allows the guest to
-		 * access it, but as KVM doesn't know what to do with it, it
-		 * will assume it's something userspace handles and exit with
-		 * KVM_EXIT_MMIO. Well, at least that's how it works for AArch64.
-		 * Here we start with a guess that the addresses around 5/8th
-		 * of the allowed space are unmapped and then work both down and
-		 * up from there in 1/16th allowed space sized steps.
-		 *
-		 * Note, we need to use VA-bits - 1 when calculating the allowed
-		 * virtual address space for an identity mapping because the upper
-		 * half of the virtual address space is the two's complement of the
-		 * lower and won't match physical addresses.
-		 */
-		bits = vm->va_bits - 1;
-		bits = vm->pa_bits < bits ? vm->pa_bits : bits;
-		end = 1ul << bits;
-		start = end * 5 / 8;
-		step = end / 16;
-		for (offset = 0; offset < end - start; offset += step) {
-			if (ucall_mmio_init(vm, start - offset))
-				return;
-			if (ucall_mmio_init(vm, start + offset))
-				return;
-		}
-		TEST_ASSERT(false, "Can't find a ucall mmio address");
-	}
-}
-
-void ucall_uninit(struct kvm_vm *vm)
-{
-	ucall_type = 0;
-	sync_global_to_guest(vm, ucall_type);
-	ucall_exit_mmio_addr = 0;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
-}
-
-static void ucall_pio_exit(struct ucall *uc)
-{
-#ifdef __x86_64__
-	asm volatile("in %[port], %%al"
-		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax");
-#endif
-}
-
-static void ucall_mmio_exit(struct ucall *uc)
-{
-	*ucall_exit_mmio_addr = (vm_vaddr_t)uc;
-}
-
-void ucall(uint64_t cmd, int nargs, ...)
-{
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
-	switch (ucall_type) {
-	case UCALL_PIO:
-		ucall_pio_exit(&uc);
-		break;
-	case UCALL_MMIO:
-		ucall_mmio_exit(&uc);
-		break;
-	};
-}
-
-uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
-{
-	struct kvm_run *run = vcpu_state(vm, vcpu_id);
-	struct ucall ucall = {};
-	bool got_ucall = false;
-
-#ifdef __x86_64__
-	if (ucall_type == UCALL_PIO && run->exit_reason == KVM_EXIT_IO &&
-	    run->io.port == UCALL_PIO_PORT) {
-		struct kvm_regs regs;
-		vcpu_regs_get(vm, vcpu_id, &regs);
-		memcpy(&ucall, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(ucall));
-		got_ucall = true;
-	}
-#endif
-	if (ucall_type == UCALL_MMIO && run->exit_reason == KVM_EXIT_MMIO &&
-	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
-		vm_vaddr_t gva;
-		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
-			    "Unexpected ucall exit mmio address access");
-		memcpy(&gva, run->mmio.data, sizeof(gva));
-		memcpy(&ucall, addr_gva2hva(vm, gva), sizeof(ucall));
-		got_ucall = true;
-	}
-
-	if (got_ucall) {
-		vcpu_run_complete_io(vm, vcpu_id);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
-	}
-
-	return ucall.cmd;
-}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
new file mode 100644
index 000000000000..4bfc9a90b1de
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to userspace".
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ */
+#include "kvm_util.h"
+
+#define UCALL_PIO_PORT ((uint16_t)0x1000)
+
+void ucall_init(struct kvm_vm *vm, void *arg)
+{
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+}
+
+void ucall(uint64_t cmd, int nargs, ...)
+{
+	struct ucall uc = {
+		.cmd = cmd,
+	};
+	va_list va;
+	int i;
+
+	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
+
+	va_start(va, nargs);
+	for (i = 0; i < nargs; ++i)
+		uc.args[i] = va_arg(va, uint64_t);
+	va_end(va);
+
+	asm volatile("in %[port], %%al"
+		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax");
+}
+
+uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+{
+	struct kvm_run *run = vcpu_state(vm, vcpu_id);
+	struct ucall ucall = {};
+
+	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
+		struct kvm_regs regs;
+
+		vcpu_regs_get(vm, vcpu_id, &regs);
+		memcpy(&ucall, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi),
+		       sizeof(ucall));
+
+		vcpu_run_complete_io(vm, vcpu_id);
+		if (uc)
+			memcpy(uc, &ucall, sizeof(ucall));
+	}
+
+	return ucall.cmd;
+}
-- 
2.20.1


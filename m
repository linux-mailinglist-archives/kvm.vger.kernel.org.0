Return-Path: <kvm+bounces-2892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 075197FEDE9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 12:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3847C1C2100D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F8B3D3B8;
	Thu, 30 Nov 2023 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F328198E;
	Thu, 30 Nov 2023 03:31:04 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Dxl+h2cmhlBug9AA--.21699S3;
	Thu, 30 Nov 2023 19:31:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxG9xycmhlNblQAA--.47327S5;
	Thu, 30 Nov 2023 19:31:01 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: Shuah Khan <shuah@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Vipin Sharma <vipinsh@google.com>,
	maobibo@loongson.cn,
	zhaotianrui@loongson.cn
Subject: [PATCH v5 3/4] KVM: selftests: Add ucall test support for LoongArch
Date: Thu, 30 Nov 2023 19:18:03 +0800
Message-Id: <20231130111804.2227570-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxG9xycmhlNblQAA--.47327S5
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add ucall test support for LoongArch. A ucall is a "hypercall to
userspace".

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 .../selftests/kvm/include/loongarch/ucall.h   | 28 ++++++++++++++
 .../selftests/kvm/lib/loongarch/ucall.c       | 38 +++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c

diff --git a/tools/testing/selftests/kvm/include/loongarch/ucall.h b/tools/testing/selftests/kvm/include/loongarch/ucall.h
new file mode 100644
index 00000000000..e9033ea6fbf
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/loongarch/ucall.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+#define UCALL_EXIT_REASON       KVM_EXIT_MMIO
+
+/*
+ * Default base address for application loading is 0x120000000,
+ * DEFAULT_GUEST_TEST_MEM should be larger than app loading address,
+ * so that PER_VCPU_MEM_SIZE can be large enough, and kvm selftests
+ * app size is smaller than 256M in generic
+ */
+#define DEFAULT_GUEST_TEST_MEM	0x130000000
+
+/*
+ * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
+ * VM), it must not be accessed from host code.
+ */
+extern vm_vaddr_t *ucall_exit_mmio_addr;
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
new file mode 100644
index 00000000000..fc6cbb50573
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to userspace".
+ *
+ */
+#include "kvm_util.h"
+
+/*
+ * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
+ * VM), it must not be accessed from host code.
+ */
+vm_vaddr_t *ucall_exit_mmio_addr;
+
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
+
+	virt_map(vm, mmio_gva, mmio_gpa, 1);
+
+	vm->ucall_mmio_addr = mmio_gpa;
+
+	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
+}
+
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	if (run->exit_reason == KVM_EXIT_MMIO &&
+	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
+			    "Unexpected ucall exit mmio address access");
+
+		return (void *)(*((uint64_t *)run->mmio.data));
+	}
+
+	return NULL;
+}
-- 
2.39.1



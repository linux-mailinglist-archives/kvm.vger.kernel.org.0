Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110DF7BD230
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbjJICzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjJICzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:55:15 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB623AB;
        Sun,  8 Oct 2023 19:55:12 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxPOuOayNlEC4wAA--.21567S3;
        Mon, 09 Oct 2023 10:55:11 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx7y+NayNlRvEbAA--.58139S5;
        Mon, 09 Oct 2023 10:55:10 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH v3 3/4] KVM: selftests: Add ucall test support for LoongArch
Date:   Mon,  9 Oct 2023 10:55:09 +0800
Message-Id: <20231009025510.342681-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231009025510.342681-1-zhaotianrui@loongson.cn>
References: <20231009025510.342681-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx7y+NayNlRvEbAA--.58139S5
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ucall test support for LoongArch. A ucall is a "hypercall to
userspace".

Based-on: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 .../selftests/kvm/include/loongarch/ucall.h   | 20 ++++++++++
 .../selftests/kvm/lib/loongarch/ucall.c       | 38 +++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c

diff --git a/tools/testing/selftests/kvm/include/loongarch/ucall.h b/tools/testing/selftests/kvm/include/loongarch/ucall.h
new file mode 100644
index 0000000000..4b68f37efd
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/loongarch/ucall.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+#define UCALL_EXIT_REASON       KVM_EXIT_MMIO
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
index 0000000000..fc6cbb5057
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


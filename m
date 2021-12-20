Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9047AA28
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhLTNJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:09:43 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33879 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhLTNJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:09:43 -0500
Received: from kwepemi100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHg0H2Zwkzcc0B;
        Mon, 20 Dec 2021 21:09:19 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100004.china.huawei.com (7.221.188.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:09:40 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 21:09:39 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>
Subject: [PATCH v3 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
Date:   Mon, 20 Dec 2021 21:09:15 +0800
Message-ID: <20211220130919.413-9-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211220130919.413-1-jiangyifei@huawei.com>
References: <20211220130919.413-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use char-fe to handle console sbi call, which implement early
console io while apply 'earlycon=sbi' into kernel parameters.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
---
 target/riscv/kvm.c                 | 43 +++++++++++++++++-
 target/riscv/sbi_ecall_interface.h | 72 ++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 1 deletion(-)
 create mode 100644 target/riscv/sbi_ecall_interface.h

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 0027f11f45..4d08669c81 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -38,6 +38,9 @@
 #include "qemu/log.h"
 #include "hw/loader.h"
 #include "kvm_riscv.h"
+#include "sbi_ecall_interface.h"
+#include "chardev/char-fe.h"
+#include "semihosting/console.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
 {
@@ -365,9 +368,47 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
     return true;
 }
 
+static int kvm_riscv_handle_sbi(CPUState *cs, struct kvm_run *run)
+{
+    int ret = 0;
+    unsigned char ch;
+    switch (run->riscv_sbi.extension_id) {
+    case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+        ch = run->riscv_sbi.args[0];
+        qemu_semihosting_log_out((const char *)&ch, sizeof(ch));
+        break;
+    case SBI_EXT_0_1_CONSOLE_GETCHAR:
+        ret = qemu_chr_fe_read_all(serial_hd(0)->be, &ch, sizeof(ch));
+        if (ret == sizeof(ch)) {
+            run->riscv_sbi.args[0] = ch;
+        } else {
+            run->riscv_sbi.args[0] = -1;
+        }
+        break;
+    default:
+        qemu_log_mask(LOG_UNIMP,
+                      "%s: un-handled SBI EXIT, specific reasons is %lu\n",
+                      __func__, run->riscv_sbi.extension_id);
+        ret = -1;
+        break;
+    }
+    return ret;
+}
+
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
-    return 0;
+    int ret = 0;
+    switch (run->exit_reason) {
+    case KVM_EXIT_RISCV_SBI:
+        ret = kvm_riscv_handle_sbi(cs, run);
+        break;
+    default:
+        qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
+                      __func__, run->exit_reason);
+        ret = -1;
+        break;
+    }
+    return ret;
 }
 
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
diff --git a/target/riscv/sbi_ecall_interface.h b/target/riscv/sbi_ecall_interface.h
new file mode 100644
index 0000000000..fb1a3fa8f2
--- /dev/null
+++ b/target/riscv/sbi_ecall_interface.h
@@ -0,0 +1,72 @@
+/*
+ * SPDX-License-Identifier: BSD-2-Clause
+ *
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *   Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __SBI_ECALL_INTERFACE_H__
+#define __SBI_ECALL_INTERFACE_H__
+
+/* clang-format off */
+
+/* SBI Extension IDs */
+#define SBI_EXT_0_1_SET_TIMER           0x0
+#define SBI_EXT_0_1_CONSOLE_PUTCHAR     0x1
+#define SBI_EXT_0_1_CONSOLE_GETCHAR     0x2
+#define SBI_EXT_0_1_CLEAR_IPI           0x3
+#define SBI_EXT_0_1_SEND_IPI            0x4
+#define SBI_EXT_0_1_REMOTE_FENCE_I      0x5
+#define SBI_EXT_0_1_REMOTE_SFENCE_VMA   0x6
+#define SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID 0x7
+#define SBI_EXT_0_1_SHUTDOWN            0x8
+#define SBI_EXT_BASE                    0x10
+#define SBI_EXT_TIME                    0x54494D45
+#define SBI_EXT_IPI                     0x735049
+#define SBI_EXT_RFENCE                  0x52464E43
+#define SBI_EXT_HSM                     0x48534D
+
+/* SBI function IDs for BASE extension*/
+#define SBI_EXT_BASE_GET_SPEC_VERSION   0x0
+#define SBI_EXT_BASE_GET_IMP_ID         0x1
+#define SBI_EXT_BASE_GET_IMP_VERSION    0x2
+#define SBI_EXT_BASE_PROBE_EXT          0x3
+#define SBI_EXT_BASE_GET_MVENDORID      0x4
+#define SBI_EXT_BASE_GET_MARCHID        0x5
+#define SBI_EXT_BASE_GET_MIMPID         0x6
+
+/* SBI function IDs for TIME extension*/
+#define SBI_EXT_TIME_SET_TIMER          0x0
+
+/* SBI function IDs for IPI extension*/
+#define SBI_EXT_IPI_SEND_IPI            0x0
+
+/* SBI function IDs for RFENCE extension*/
+#define SBI_EXT_RFENCE_REMOTE_FENCE_I       0x0
+#define SBI_EXT_RFENCE_REMOTE_SFENCE_VMA    0x1
+#define SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID  0x2
+#define SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA   0x3
+#define SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID 0x4
+#define SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA   0x5
+#define SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID 0x6
+
+/* SBI function IDs for HSM extension */
+#define SBI_EXT_HSM_HART_START          0x0
+#define SBI_EXT_HSM_HART_STOP           0x1
+#define SBI_EXT_HSM_HART_GET_STATUS     0x2
+
+#define SBI_HSM_HART_STATUS_STARTED     0x0
+#define SBI_HSM_HART_STATUS_STOPPED     0x1
+#define SBI_HSM_HART_STATUS_START_PENDING   0x2
+#define SBI_HSM_HART_STATUS_STOP_PENDING    0x3
+
+#define SBI_SPEC_VERSION_MAJOR_OFFSET   24
+#define SBI_SPEC_VERSION_MAJOR_MASK     0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK     0xffffff
+#define SBI_EXT_VENDOR_START            0x09000000
+#define SBI_EXT_VENDOR_END              0x09FFFFFF
+/* clang-format on */
+
+#endif
-- 
2.19.1


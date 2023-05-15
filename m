Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F70702184
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 04:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbjEOCQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 May 2023 22:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbjEOCPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 May 2023 22:15:39 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A2C91BC7;
        Sun, 14 May 2023 19:15:37 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxJunIlWFk+q8IAA--.14842S3;
        Mon, 15 May 2023 10:15:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxn7O6lWFk0KJeAA--.33838S22;
        Mon, 15 May 2023 10:15:34 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v10 20/30] LoongArch: KVM: Implement handle csr excption
Date:   Mon, 15 May 2023 10:15:12 +0800
Message-Id: <20230515021522.2445551-21-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dxn7O6lWFk0KJeAA--.33838S22
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxKryDWr4kur4rZF1kJFWfuFg_yoW7Xr1fpF
        WkC3W5Zw40qw1Skas3trs0vrs8X3ykGr12qFy2q34Iv3W2yF95XFWvgryDXF98Ga9aqFWa
        qay5trs5ur4UtaUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm handle LoongArch vcpu exit caused by reading and
writing csr. Using csr structure to emulate the registers.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_csr.h | 57 ++++++++++++++++
 arch/loongarch/kvm/exit.c            | 98 ++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_csr.h
 create mode 100644 arch/loongarch/kvm/exit.c

diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
new file mode 100644
index 000000000000..2c572a332d53
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_csr.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_LOONGARCH_KVM_CSR_H__
+#define __ASM_LOONGARCH_KVM_CSR_H__
+#include <asm/loongarch.h>
+#include <asm/kvm_vcpu.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+
+#define kvm_read_hw_gcsr(id)		gcsr_read(id)
+#define kvm_write_hw_gcsr(csr, id, val)	gcsr_write(val, id)
+
+int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v);
+int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 v);
+
+int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu);
+
+static __always_inline void kvm_save_hw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	csr->csrs[gid] = gcsr_read(gid);
+}
+
+static __always_inline void kvm_restore_hw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	gcsr_write(csr->csrs[gid], gid);
+}
+
+static __always_inline unsigned long kvm_read_sw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	return csr->csrs[gid];
+}
+
+static __always_inline void kvm_write_sw_gcsr(struct loongarch_csrs *csr,
+					      int gid, unsigned long val)
+{
+	csr->csrs[gid] = val;
+}
+
+static __always_inline void kvm_set_sw_gcsr(struct loongarch_csrs *csr,
+					    int gid, unsigned long val)
+{
+	csr->csrs[gid] |= val;
+}
+
+static __always_inline void kvm_change_sw_gcsr(struct loongarch_csrs *csr,
+					       int gid, unsigned long mask,
+					       unsigned long val)
+{
+	unsigned long _mask = mask;
+
+	csr->csrs[gid] &= ~_mask;
+	csr->csrs[gid] |= val & _mask;
+}
+#endif	/* __ASM_LOONGARCH_KVM_CSR_H__ */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
new file mode 100644
index 000000000000..508cbce31aa5
--- /dev/null
+++ b/arch/loongarch/kvm/exit.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/vmalloc.h>
+#include <asm/fpu.h>
+#include <asm/inst.h>
+#include <asm/time.h>
+#include <asm/tlb.h>
+#include <asm/loongarch.h>
+#include <asm/numa.h>
+#include <asm/kvm_vcpu.h>
+#include <asm/kvm_csr.h>
+#include <linux/kvm_host.h>
+#include <asm/mmzone.h>
+#include "trace.h"
+
+static unsigned long _kvm_emu_read_csr(struct kvm_vcpu *vcpu, int csrid)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	unsigned long val = 0;
+
+	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
+		val = kvm_read_sw_gcsr(csr, csrid);
+	else
+		pr_warn_once("Unsupport csrread 0x%x with pc %lx\n",
+			csrid, vcpu->arch.pc);
+	return val;
+}
+
+static void _kvm_emu_write_csr(struct kvm_vcpu *vcpu, int csrid,
+	unsigned long val)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
+		kvm_write_sw_gcsr(csr, csrid, val);
+	else
+		pr_warn_once("Unsupport csrwrite 0x%x with pc %lx\n",
+				csrid, vcpu->arch.pc);
+}
+
+static void _kvm_emu_xchg_csr(struct kvm_vcpu *vcpu, int csrid,
+	unsigned long csr_mask, unsigned long val)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR)) {
+		unsigned long orig;
+
+		orig = kvm_read_sw_gcsr(csr, csrid);
+		orig &= ~csr_mask;
+		orig |= val & csr_mask;
+		kvm_write_sw_gcsr(csr, csrid, orig);
+	} else
+		pr_warn_once("Unsupport csrxchg 0x%x with pc %lx\n",
+				csrid, vcpu->arch.pc);
+}
+
+static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
+{
+	unsigned int rd, rj, csrid;
+	unsigned long csr_mask;
+	unsigned long val = 0;
+
+	/*
+	 * CSR value mask imm
+	 * rj = 0 means csrrd
+	 * rj = 1 means csrwr
+	 * rj != 0,1 means csrxchg
+	 */
+	rd = inst.reg2csr_format.rd;
+	rj = inst.reg2csr_format.rj;
+	csrid = inst.reg2csr_format.csr;
+
+	/* Process CSR ops */
+	if (rj == 0) {
+		/* process csrrd */
+		val = _kvm_emu_read_csr(vcpu, csrid);
+		vcpu->arch.gprs[rd] = val;
+	} else if (rj == 1) {
+		/* process csrwr */
+		val = vcpu->arch.gprs[rd];
+		_kvm_emu_write_csr(vcpu, csrid, val);
+	} else {
+		/* process csrxchg */
+		val = vcpu->arch.gprs[rd];
+		csr_mask = vcpu->arch.gprs[rj];
+		_kvm_emu_xchg_csr(vcpu, csrid, csr_mask, val);
+	}
+
+	return EMULATE_DONE;
+}
-- 
2.31.1


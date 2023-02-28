Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7736A536F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 08:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjB1HBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 02:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjB1HBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 02:01:08 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F34C525BA0;
        Mon, 27 Feb 2023 23:01:05 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxldiwpv1j92AGAA--.11648S3;
        Tue, 28 Feb 2023 15:01:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxc+Wppv1jPG9AAA--.15462S22;
        Tue, 28 Feb 2023 15:01:03 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v3 20/29] LoongArch: KVM: Implement handle csr excption
Date:   Tue, 28 Feb 2023 15:00:47 +0800
Message-Id: <20230228070057.3687180-21-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230228070057.3687180-1-zhaotianrui@loongson.cn>
References: <20230228070057.3687180-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxc+Wppv1jPG9AAA--.15462S22
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3Ar1ktryxJF1fKF1DAFW5Wrg_yoW7Zr13pF
        WUCa15Zw40q3W7Kas3JFs0vrZ8X3ykGw17tFy7t34SvFnFyFn5XFWvgryDXF98ta93WFWa
        qay5trn5Cr1DtaUanT9S1TB71UUUUb7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bx8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVWxJr0_GcWln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        tVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07Ur73kUUUUU=
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm handle loongarch vcpu exit caused by reading and
writing csr. Using loongarch_csr structure to emulate the registers.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_csr.h |  89 +++++++++++++++++++++++
 arch/loongarch/kvm/exit.c            | 101 +++++++++++++++++++++++++++
 2 files changed, 190 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_csr.h
 create mode 100644 arch/loongarch/kvm/exit.c

diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
new file mode 100644
index 000000000000..44fcd724c380
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_csr.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_LOONGARCH_KVM_CSR_H__
+#define __ASM_LOONGARCH_KVM_CSR_H__
+#include <asm/loongarch.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm_vcpu.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+
+#define kvm_read_hw_gcsr(id)		gcsr_read(id)
+#define kvm_write_hw_gcsr(csr, id, val)	gcsr_write(val, id)
+
+int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v, int force);
+int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v, int force);
+
+int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu);
+
+static inline void kvm_save_hw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	csr->csrs[gid] = gcsr_read(gid);
+}
+
+static inline void kvm_restore_hw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	gcsr_write(csr->csrs[gid], gid);
+}
+
+static inline unsigned long kvm_read_sw_gcsr(struct loongarch_csrs *csr, int gid)
+{
+	return csr->csrs[gid];
+}
+
+static inline void kvm_write_sw_gcsr(struct loongarch_csrs *csr, int gid, unsigned long val)
+{
+	csr->csrs[gid] = val;
+}
+
+static inline void kvm_set_sw_gcsr(struct loongarch_csrs *csr, int gid, unsigned long val)
+{
+	csr->csrs[gid] |= val;
+}
+
+static inline void kvm_change_sw_gcsr(struct loongarch_csrs *csr, int gid, unsigned long mask,
+	unsigned long val)
+{
+	unsigned long _mask = mask;
+
+	csr->csrs[gid] &= ~_mask;
+	csr->csrs[gid] |= val & _mask;
+}
+
+
+#define GET_HW_GCSR(id, csrid, v)				\
+	do {							\
+		if (csrid == id) {				\
+			*v = (long)kvm_read_hw_gcsr(csrid);	\
+			return 0;				\
+		}						\
+	} while (0)
+
+#define GET_SW_GCSR(csr, id, csrid, v)				\
+	do {							\
+		if (csrid == id) {				\
+			*v = kvm_read_sw_gcsr(csr, id);		\
+			return 0;				\
+		}						\
+	} while (0)
+
+#define SET_HW_GCSR(csr, id, csrid, v)				\
+	do {							\
+		if (csrid == id) {				\
+			kvm_write_hw_gcsr(csr, csrid, *v);	\
+			return 0;				\
+		}						\
+	} while (0)
+
+#define SET_SW_GCSR(csr, id, csrid, v)				\
+	do {							\
+		if (csrid == id) {				\
+			kvm_write_sw_gcsr(csr, csrid, *v);	\
+			return 0;				\
+		}						\
+	} while (0)
+
+#endif	/* __ASM_LOONGARCH_KVM_CSR_H__ */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
new file mode 100644
index 000000000000..dc37827d9bcb
--- /dev/null
+++ b/arch/loongarch/kvm/exit.c
@@ -0,0 +1,101 @@
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
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+static unsigned long _kvm_emu_read_csr(struct kvm_vcpu *vcpu, int csrid)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	unsigned long val = 0;
+
+	val = 0;
+	if (csrid < 4096)
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
+	if (csrid < 4096)
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
+	if (csrid < 4096) {
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


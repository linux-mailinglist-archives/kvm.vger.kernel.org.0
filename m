Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A696D6CBF47
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjC1MhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjC1MhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:37:10 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 150B326B6;
        Tue, 28 Mar 2023 05:36:43 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxJ_Ad3iJkchkTAA--.29212S3;
        Tue, 28 Mar 2023 20:31:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S22;
        Tue, 28 Mar 2023 20:31:24 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 20/29] LoongArch: KVM: Implement handle csr excption
Date:   Tue, 28 Mar 2023 20:31:10 +0800
Message-Id: <20230328123119.3649361-21-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S22
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3Ar1ktry7uryUAF13XryxKrg_yoW7Xr18pF
        Z7Ca15Xw40qw12kas3JFs0vrZ8X3ykGr17tFy7t34SvF12yF1rXFWvgryDXF98Ja9YqFW2
        qay5trn5ur4UtaUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm handle loongarch vcpu exit caused by reading and
writing csr. Using loongarch_csr structure to emulate the registers.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_csr.h |  55 +++++++++++++++
 arch/loongarch/kvm/exit.c            | 100 +++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_csr.h
 create mode 100644 arch/loongarch/kvm/exit.c

diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
new file mode 100644
index 000000000..18052d0ad
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_csr.h
@@ -0,0 +1,55 @@
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
+int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v);
+int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 v);
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
+#endif	/* __ASM_LOONGARCH_KVM_CSR_H__ */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
new file mode 100644
index 000000000..dcb8eb815
--- /dev/null
+++ b/arch/loongarch/kvm/exit.c
@@ -0,0 +1,100 @@
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


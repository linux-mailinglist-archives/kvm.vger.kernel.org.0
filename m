Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982E67AF8FD
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjI0EEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjI0ECx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:02:53 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2591F1B8;
        Tue, 26 Sep 2023 20:10:12 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxuOgPnRNlXBctAA--.50486S3;
        Wed, 27 Sep 2023 11:10:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S17;
        Wed, 27 Sep 2023 11:10:06 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 15/25] LoongArch: KVM: Implement handle csr exception
Date:   Wed, 27 Sep 2023 11:09:49 +0800
Message-Id: <20230927030959.3629941-16-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S17
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

Implement kvm handle LoongArch vcpu exit caused by reading, writing and
exchanging csr. Use kvm_vcpu_arch::csr structure to emulate the software
registers.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 105 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 arch/loongarch/kvm/exit.c

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
new file mode 100644
index 0000000000..37bc8a4209
--- /dev/null
+++ b/arch/loongarch/kvm/exit.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/vmalloc.h>
+#include <asm/fpu.h>
+#include <asm/inst.h>
+#include <asm/loongarch.h>
+#include <asm/mmzone.h>
+#include <asm/numa.h>
+#include <asm/time.h>
+#include <asm/tlb.h>
+#include <asm/kvm_csr.h>
+#include <asm/kvm_vcpu.h>
+#include "trace.h"
+
+static unsigned long kvm_emu_read_csr(struct kvm_vcpu *vcpu, int csrid)
+{
+	unsigned long val = 0;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	/*
+	 * From LoongArch Reference Manual Volume 1 Chapter 4.2.1
+	 * For undefined CSR id, return value is 0
+	 */
+	if (get_gcsr_flag(csrid) & SW_GCSR)
+		val = kvm_read_sw_gcsr(csr, csrid);
+	else
+		pr_warn_once("Unsupported csrrd 0x%x with pc %lx\n", csrid, vcpu->arch.pc);
+
+	return val;
+}
+
+static unsigned long kvm_emu_write_csr(struct kvm_vcpu *vcpu, int csrid, unsigned long val)
+{
+	unsigned long old = 0;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (get_gcsr_flag(csrid) & SW_GCSR) {
+		old = kvm_read_sw_gcsr(csr, csrid);
+		kvm_write_sw_gcsr(csr, csrid, val);
+	} else
+		pr_warn_once("Unsupported csrwr 0x%x with pc %lx\n", csrid, vcpu->arch.pc);
+
+	return old;
+}
+
+static unsigned long kvm_emu_xchg_csr(struct kvm_vcpu *vcpu, int csrid,
+				unsigned long csr_mask, unsigned long val)
+{
+	unsigned long old = 0;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (get_gcsr_flag(csrid) & SW_GCSR) {
+		old = kvm_read_sw_gcsr(csr, csrid);
+		val = (old & ~csr_mask) | (val & csr_mask);
+		kvm_write_sw_gcsr(csr, csrid, val);
+		old = old & csr_mask;
+	} else
+		pr_warn_once("Unsupported csrxchg 0x%x with pc %lx\n", csrid, vcpu->arch.pc);
+
+	return old;
+}
+
+static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
+{
+	unsigned int rd, rj, csrid;
+	unsigned long csr_mask, val = 0;
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
+	switch (rj) {
+	case 0: /* process csrrd */
+		val = kvm_emu_read_csr(vcpu, csrid);
+		vcpu->arch.gprs[rd] = val;
+		break;
+	case 1: /* process csrwr */
+		val = vcpu->arch.gprs[rd];
+		val = kvm_emu_write_csr(vcpu, csrid, val);
+		vcpu->arch.gprs[rd] = val;
+		break;
+	default: /* process csrxchg */
+		val = vcpu->arch.gprs[rd];
+		csr_mask = vcpu->arch.gprs[rj];
+		val = kvm_emu_xchg_csr(vcpu, csrid, csr_mask, val);
+		vcpu->arch.gprs[rd] = val;
+	}
+
+	return EMULATE_DONE;
+}
-- 
2.39.3


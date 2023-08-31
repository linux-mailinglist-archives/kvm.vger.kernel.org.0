Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5831478E83D
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344502AbjHaIbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 04:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243408AbjHaIbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 04:31:20 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADD2BE71;
        Thu, 31 Aug 2023 01:30:42 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cx5_GsT_BkpV4dAA--.60025S3;
        Thu, 31 Aug 2023 16:30:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax3c6gT_BkOPVnAA--.55892S22;
        Thu, 31 Aug 2023 16:30:35 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v20 20/30] LoongArch: KVM: Implement handle csr excption
Date:   Thu, 31 Aug 2023 16:30:10 +0800
Message-Id: <20230831083020.2187109-21-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Ax3c6gT_BkOPVnAA--.55892S22
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

Implement kvm handle LoongArch vcpu exit caused by reading and
writing csr. Using csr structure to emulate the registers.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 98 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 arch/loongarch/kvm/exit.c

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
new file mode 100644
index 0000000000..18635333fc
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
+	if (get_gcsr_flag(csrid) & SW_GCSR)
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
+	if (get_gcsr_flag(csrid) & SW_GCSR)
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
+	if (get_gcsr_flag(csrid) & SW_GCSR) {
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
2.27.0


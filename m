Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3525968D350
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjBGJ4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjBGJ4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:56:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7287EC7A
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:56:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o16-20020a17090ad25000b00230759a8c06so11358064pjw.2
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKlW5q6yjuU3XeXevn1T+f+MrCmphziSra4SvghaxAg=;
        b=TEnaVT7PYxs4JyVGUW6aY4WTRKeyCKV8ouUmBA2lK0Wh+OV9/pKI3c6QgalkAP9Xh3
         nW+gy6DwMm6B3tZ9tz2nRkuX6ty+qBeE6OVOA/vQrmmY122FxcaZzzSNyIwhUu/7p8Gq
         QE84NMjs0x7xKhxQXO6UWhQ/7tBjt0Uhkxog8S9JJGHeGr/4cRDR5QPRZivUCwS+1C1F
         A3Le5MZ4Yfh/x1wMnMZogTqRJ/b9yidFBuW0Orh33akhAvYA4pF6CGNwD4LHxjZQrEVa
         ClgnMuK0Z9FvHUf4+27bpLhrb1EE3NWL8Y4pGVeGwvVVw0A+IxxSHQr99llwYnK++f1b
         t8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKlW5q6yjuU3XeXevn1T+f+MrCmphziSra4SvghaxAg=;
        b=6c1qtCKycjBHXCNDmz9st5YdlxiyEX5H6L/eTsqXcXnUqCsBncEMvKH7z0I7VG62AT
         Fnl/mzpFpU5pdH+EuxzhbiuOoFuanwSKJv76gD3WHn03GCmEeYTkeaWHvRB6CZuHIaBl
         3Uzmn2JnalgLxgd7jTeXbFt+50EBG9xygIqSOTe+vEClckJbP6tqa/i/8gXHKENNCOev
         leYc/2H3rs4QMK/gIgDrHAZWclYkHuisINMnpRhjPFEFmphkxMw2RqYuDYedu0Q6faIt
         PLUC3Dz4IJntNQlNqZ/svW824Rgro1cSys//izl1/kWGPgqL0ZCbkw8y53IxBfLYfn7Z
         v/sg==
X-Gm-Message-State: AO0yUKU24LGdaSID0+kS1b1KWVToxDGsY+UlwMgbXZm2+CPEWPilYiNt
        7Ym8r8J5jv459NMFYSGTE9mnaw==
X-Google-Smtp-Source: AK7set+90CMMp0x7RiSYU1Hdnxx79pQK8RCRBSydQXwsuooxNy600xIHu64/eDHl1N4YOnE1i7R8lg==
X-Received: by 2002:a17:902:d294:b0:198:fd67:ba33 with SMTP id t20-20020a170902d29400b00198fd67ba33mr1879753plc.19.1675763789262;
        Tue, 07 Feb 2023 01:56:29 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm4030598pll.175.2023.02.07.01.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 01:56:28 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v6 1/8] RISC-V: KVM: Add skeleton support for perf
Date:   Tue,  7 Feb 2023 01:55:22 -0800
Message-Id: <20230207095529.1787260-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207095529.1787260-1-atishp@rivosinc.com>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch only adds barebone structure of perf implementation. Most of
the function returns zero at this point and will be implemented
fully in the future.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h     |   4 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  75 ++++++++++++++
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/vcpu.c                 |   7 ++
 arch/riscv/kvm/vcpu_pmu.c             | 138 ++++++++++++++++++++++++++
 5 files changed, 225 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
 create mode 100644 arch/riscv/kvm/vcpu_pmu.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 93f43a3..b90be9a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -18,6 +18,7 @@
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 
 #define KVM_MAX_VCPUS			1024
 
@@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
+
+	/* Performance monitoring context */
+	struct kvm_pmu pmu_context;
 };
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
new file mode 100644
index 0000000..0b86a47
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2023 Rivos Inc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_PMU_H
+#define __KVM_VCPU_RISCV_PMU_H
+
+#include <linux/perf/riscv_pmu.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_RISCV_PMU_SBI
+#define RISCV_KVM_MAX_FW_CTRS	32
+#define RISCV_KVM_MAX_HW_CTRS	32
+#define RISCV_KVM_MAX_COUNTERS	(RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
+static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
+
+/* Per virtual pmu counter data */
+struct kvm_pmc {
+	u8 idx;
+	struct perf_event *perf_event;
+	u64 counter_val;
+	union sbi_pmu_ctr_info cinfo;
+	/* Event monitoring status */
+	bool started;
+};
+
+/* PMU data structure per vcpu */
+struct kvm_pmu {
+	struct kvm_pmc pmc[RISCV_KVM_MAX_COUNTERS];
+	/* Number of the virtual firmware counters available */
+	int num_fw_ctrs;
+	/* Number of the virtual hardware counters available */
+	int num_hw_ctrs;
+	/* A flag to indicate that pmu initialization is done */
+	bool init_done;
+	/* Bit map of all the virtual counter used */
+	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
+};
+
+#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
+#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
+
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flags, u64 ival,
+				 struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				unsigned long ctr_mask, unsigned long flags,
+				struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flags,
+				     unsigned long eidx, u64 evtdata,
+				     struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_return *retdata);
+void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
+
+#else
+struct kvm_pmu {
+};
+
+static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
+static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
+#endif /* CONFIG_RISCV_PMU_SBI */
+#endif /* !__KVM_VCPU_RISCV_PMU_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 019df920..5de1053 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_timer.o
+kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7c08567..7d010b0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -138,6 +138,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 
+	kvm_riscv_vcpu_pmu_reset(vcpu);
+
 	vcpu->arch.hfence_head = 0;
 	vcpu->arch.hfence_tail = 0;
 	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
@@ -194,6 +196,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 
+	/* setup performance monitoring */
+	kvm_riscv_vcpu_pmu_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -216,6 +221,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	/* Cleanup VCPU timer */
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
+	kvm_riscv_vcpu_pmu_deinit(vcpu);
+
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
new file mode 100644
index 0000000..e79721b
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Rivos Inc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/perf/riscv_pmu.h>
+#include <asm/csr.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_pmu.h>
+#include <linux/kvm_host.h>
+
+#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
+
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	retdata->out_val = kvm_pmu_num_counters(kvpmu);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_return *retdata)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	if (cidx > RISCV_KVM_MAX_COUNTERS || cidx == 1) {
+		retdata->err_val = SBI_ERR_INVALID_PARAM;
+		return 0;
+	}
+
+	retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flags, u64 ival,
+				 struct kvm_vcpu_sbi_return *retdata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				unsigned long ctr_mask, unsigned long flags,
+				struct kvm_vcpu_sbi_return *retdata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flags,
+				     unsigned long eidx, u64 evtdata,
+				     struct kvm_vcpu_sbi_return *retdata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_return *retdata)
+{
+	/* TODO */
+	return 0;
+}
+
+void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
+{
+	int i = 0, ret, num_hw_ctrs = 0, hpm_width = 0;
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+
+	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
+	if (ret < 0 || !hpm_width || !num_hw_ctrs)
+		return;
+	/*
+	 * Increase the number of hardware counters to offset the time counter.
+	 */
+	kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
+	kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
+
+	if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
+		pr_warn("Limiting the hardware counters to 32 as specified by the ISA");
+		kvpmu->num_hw_ctrs = RISCV_KVM_MAX_HW_CTRS;
+	}
+	/*
+	 * There is no correlation between the logical hardware counter and virtual counters.
+	 * However, we need to encode a hpmcounter CSR in the counter info field so that
+	 * KVM can trap n emulate the read. This works well in the migration use case as
+	 * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
+	 */
+	for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
+		/* TIME CSR shouldn't be read from perf interface */
+		if (i == 1)
+			continue;
+		pmc = &kvpmu->pmc[i];
+		pmc->idx = i;
+		if (i < kvpmu->num_hw_ctrs) {
+			pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
+			if (i < 3)
+				/* CY, IR counters */
+				pmc->cinfo.width = 63;
+			else
+				pmc->cinfo.width = hpm_width;
+			/*
+			 * The CSR number doesn't have any relation with the logical
+			 * hardware counters. The CSR numbers are encoded sequentially
+			 * to avoid maintaining a map between the virtual counter
+			 * and CSR number.
+			 */
+			pmc->cinfo.csr = CSR_CYCLE + i;
+		} else {
+			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
+			pmc->cinfo.width = BITS_PER_LONG - 1;
+		}
+	}
+
+	kvpmu->init_done = true;
+}
+
+void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
+{
+	/* TODO */
+}
+
+void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
+{
+	kvm_riscv_vcpu_pmu_deinit(vcpu);
+}
-- 
2.25.1


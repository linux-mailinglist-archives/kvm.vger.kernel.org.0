Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0716967ED6A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbjA0S03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjA0S0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:22 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E8F84952
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o13so5376482pjg.2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngz4BJEkYwj1EhZHcesEeRsl9PBRoQJPRxlLhAhdcSk=;
        b=u6oB7dWx2nvfeKTmg127o8Z3ghvpoM1bbYLH05DhRneKdCwOmcMQjV+vs0BmoOFFMD
         FVNEpwEHKcdqtb5ibldK24GhPd3+1OQN7KBbcGwfMJaazEFkMlgxV1U2bsGqANViR6JN
         8Y4LZJRP8L5WkwhwASxPgzpSA6Up7PgeQCbLknH30pmTUTJTms+xJx52r1sY63x8MlT7
         JeBF+z9A9QNKEcGJbg9gDr+mKRr/0piNHBnonZ/MPyXgqyiZGgL5idGzTiyi/7/3vdi0
         6KWv/gT2SOBwQ6Ng4eTG4/xTFMEqd92IamzpE+9JqFY/T5wA2Fo8DUUlzi47HzyoOVVc
         3nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngz4BJEkYwj1EhZHcesEeRsl9PBRoQJPRxlLhAhdcSk=;
        b=YQJ9fzCgDvTrcHdz0EMuvGx1BUrGJAGuSuustm83n/pvGhYj4ZGmW6Cp5n6njDw0Dk
         0qB9FWDYJWmAI2F0bHYDlOJT04onhGGI/N/EEu5W7jY0w+jcRZSwwd1du/umhvSc3Scc
         YlkMhQJiL47kmx3EUQoePdhJYQVSmAYK9czv+5vffRhdli4p8BMQS++OxH68UNhQXvEt
         mx53ULtnVoO3lBjcOzlAJRg9UPWzw52P5k3/WdHrhls5cjCKWvTXHszfHY//X/I/kmJT
         m23VIbH9xEntEX5MgJLHSYW8xAmiSInDpvGg5TvEKyPynhdyWcgLG5pZ1Pyp65+aMdUZ
         MEcA==
X-Gm-Message-State: AFqh2kqi4agg5pdZegTiprauOkq1Q9+LffMYeZPi1V3t7gjHsYW3YftF
        u3JzAO6yPU5rGzxSFpuBTMl2bQ==
X-Google-Smtp-Source: AMrXdXtdjdo0tE1xQKNC5NB4CrUU3NDMkUw/61I8Pze5GN2zEWwseCJ7KzZWrqTaXmBy3/5RwxOXQQ==
X-Received: by 2002:a17:902:f546:b0:194:d9d7:88c4 with SMTP id h6-20020a170902f54600b00194d9d788c4mr38308129plf.49.1674843980061;
        Fri, 27 Jan 2023 10:26:20 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:19 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 07/14] RISC-V: KVM: Add skeleton support for perf
Date:   Fri, 27 Jan 2023 10:25:51 -0800
Message-Id: <20230127182558.2416400-8-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
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

This patch only adds barebore structure of perf implementation. Most of
the function returns zero at this point and will be implemented
fully in the future.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h     |   3 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  76 ++++++++++++++
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/vcpu.c                 |   5 +
 arch/riscv/kvm/vcpu_pmu.c             | 145 ++++++++++++++++++++++++++
 5 files changed, 230 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
 create mode 100644 arch/riscv/kvm/vcpu_pmu.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 93f43a3..f9874b4 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -18,6 +18,7 @@
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 
 #define KVM_MAX_VCPUS			1024
 
@@ -228,6 +229,8 @@ struct kvm_vcpu_arch {
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
+
+	struct kvm_pmu pmu;
 };
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
new file mode 100644
index 0000000..3f43a43
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -0,0 +1,76 @@
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
+#define RISCV_KVM_MAX_FW_CTRS 32
+#define RISCV_MAX_COUNTERS      64
+
+/* Per virtual pmu counter data */
+struct kvm_pmc {
+	u8 idx;
+	struct perf_event *perf_event;
+	uint64_t counter_val;
+	union sbi_pmu_ctr_info cinfo;
+	/* Event monitoring status */
+	bool started;
+};
+
+/* PMU data structure per vcpu */
+struct kvm_pmu {
+	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
+	/* Number of the virtual firmware counters available */
+	int num_fw_ctrs;
+	/* Number of the virtual hardware counters available */
+	int num_hw_ctrs;
+	/* A flag to indicate that pmu initialization is done */
+	bool init_done;
+	/* Bit map of all the virtual counter used */
+	DECLARE_BITMAP(pmc_in_use, RISCV_MAX_COUNTERS);
+};
+
+#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
+#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
+
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
+				 struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				unsigned long ctr_mask, unsigned long flag,
+				struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flag,
+				     unsigned long eidx, uint64_t evtdata,
+				     struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_ext_data *edata);
+int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
+
+#else
+struct kvm_pmu {
+};
+
+static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
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
index 7c08567..b746f21 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -137,6 +137,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	kvm_riscv_vcpu_pmu_reset(vcpu);
 
 	vcpu->arch.hfence_head = 0;
 	vcpu->arch.hfence_tail = 0;
@@ -194,6 +195,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 
+	/* setup performance monitoring */
+	kvm_riscv_vcpu_pmu_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -216,6 +220,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	/* Cleanup VCPU timer */
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
+	kvm_riscv_vcpu_pmu_deinit(vcpu);
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
new file mode 100644
index 0000000..d3fd551
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -0,0 +1,145 @@
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
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	edata->out_val = kvm_pmu_num_counters(kvpmu);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_ext_data *edata)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	if (cidx > RISCV_MAX_COUNTERS || cidx == 1) {
+		edata->err_val = SBI_ERR_INVALID_PARAM;
+		return 0;
+	}
+
+	edata->out_val = kvpmu->pmc[cidx].cinfo.value;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
+				 struct kvm_vcpu_sbi_ext_data *edata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				unsigned long ctr_mask, unsigned long flag,
+				struct kvm_vcpu_sbi_ext_data *edata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flag,
+				     unsigned long eidx, uint64_t evtdata,
+				     struct kvm_vcpu_sbi_ext_data *edata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_ext_data *edata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
+{
+	int i = 0, num_fw_ctrs, ret, num_hw_ctrs = 0, hpm_width = 0;
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+
+	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
+	if (ret < 0)
+		return ret;
+
+	if (!hpm_width || !num_hw_ctrs) {
+		pr_err("Cannot initialize VCPU with NULL hpmcounter width or number of counters\n");
+		return -EINVAL;
+	}
+
+	if ((num_hw_ctrs + RISCV_KVM_MAX_FW_CTRS) > RISCV_MAX_COUNTERS) {
+		pr_warn("Limiting fw counters as hw & fw counters exceed maximum counters\n");
+		num_fw_ctrs = RISCV_MAX_COUNTERS - num_hw_ctrs;
+	} else
+		num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
+
+	kvpmu->num_hw_ctrs = num_hw_ctrs;
+	kvpmu->num_fw_ctrs = num_fw_ctrs;
+
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
+			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
+			if (i < 3)
+				/* CY, IR counters */
+				kvpmu->pmc[i].cinfo.width = 63;
+			else
+				kvpmu->pmc[i].cinfo.width = hpm_width;
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
+
+	return 0;
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


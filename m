Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E476578811
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiGRRGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiGRRF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457B92C121
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 5so9580149plk.9
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g0GXt84vLJgSh96R08zPlPoGq5zRKrVm2Ojh33nPRNc=;
        b=HgvjExTpPKlEjTRtSNLbdzm9LKmieF9qEs4xJP2LurrKxwYLXTas/D1PhqWPwMtd17
         uXNpptix6gFoMRy6B5gqVQdxRTc4tB8ag+7kUYjb4odhRT9dPaA5Lc2kvgVSzyf5meKI
         W/tfu4dz7K9rPUjRI4dHd+CRVB8u+x8nEqgRSaK+YgC5zDoy41GtLW5AMij16DZqhZBD
         UN7HC11UkbvvCvj1rgEwWpDwaeva3Ou9kmA11c49GJg83V2o0TpHm2tHQ3EgVIL40njI
         ny3LFt5kRDkD+YLUDrZyeMC0Pn9/wYDY8mosBvrqoaUEhGWWf7jYhMliDxX1ZNq9sryw
         vAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0GXt84vLJgSh96R08zPlPoGq5zRKrVm2Ojh33nPRNc=;
        b=u+XhT12fghqZlHoIIa6S7C0kZ1Y7KF4j0h7lDmm5R4IiB4dWsL+sOdTpjUF4wXsXty
         V2d/fLHqdesmItv3p/nwJ4XcYH9J3EiikxJPOgdf0f7VC0i/0s6C7BqRDMK67KeSt+pq
         OnipFt8fkH5kFhXOTHr6huiTM1BW2bJbKQ+YDfldgFeOBTrCVZZ6UksixdSlflaNqmBS
         TRjVI9XVkCG0K4ihzHKqCExG1qSXh3qhp7qt6eT+/N/ZZamkiIFpWZJuxP8WeIZFBtRB
         oNwYgU/RMGkM0jcAsGVMJ9FXkOwtSbXXbxyrqnux9HsdDLRXFIgPTE8smlwwxhQZcUuu
         SmRg==
X-Gm-Message-State: AJIora8b/FAwg8RIA50ffgh4PADF4DkyfW8Pi7MHur0kvCwNJ/Wbi7sM
        JTU4ydh62CEm5ZsxITPQLWfbSA==
X-Google-Smtp-Source: AGRyM1tS6zC84MRMFbRJz9tvWCxV+RPsnhP4oYyrw87iUd3saJSSLC62JLntxczMfiMlDUf7vVWivA==
X-Received: by 2002:a17:90b:33ce:b0:1ef:e5f4:f8e2 with SMTP id lk14-20020a17090b33ce00b001efe5f4f8e2mr41166287pjb.70.1658163949636;
        Mon, 18 Jul 2022 10:05:49 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:49 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC  5/9] RISC-V: KVM: Add skeleton support for perf
Date:   Mon, 18 Jul 2022 10:02:01 -0700
Message-Id: <20220718170205.2972215-6-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718170205.2972215-1-atishp@rivosinc.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  70 +++++++++++++
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/main.c                 |   3 +-
 arch/riscv/kvm/vcpu.c                 |   5 +
 arch/riscv/kvm/vcpu_insn.c            |   3 +-
 arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
 7 files changed, 219 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
 create mode 100644 arch/riscv/kvm/vcpu_pmu.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 59a0cf2ca7b9..5d2312828bb2 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -18,6 +18,7 @@
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 
 #define KVM_MAX_VCPUS			1024
 
@@ -226,6 +227,8 @@ struct kvm_vcpu_arch {
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
+
+	struct kvm_pmu pmu;
 };
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
new file mode 100644
index 000000000000..bffee052f2ae
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Rivos Inc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#ifndef _KVM_VCPU_RISCV_PMU_H
+#define _KVM_VCPU_RISCV_PMU_H
+
+#include <linux/perf/riscv_pmu.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_RISCV_PMU_SBI
+#define RISCV_KVM_MAX_FW_CTRS 32
+
+/* Per virtual pmu counter data */
+struct kvm_pmc {
+	u8 idx;
+	struct kvm_vcpu *vcpu;
+	struct perf_event *perf_event;
+	uint64_t counter_val;
+	union sbi_pmu_ctr_info cinfo;
+};
+
+/* PMU data structure per vcpu */
+struct kvm_pmu {
+	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
+	/* Number of the virtual firmware counters available */
+	int num_fw_ctrs;
+	/* Number of the virtual hardware counters available */
+	int num_hw_ctrs;
+	/* Bit map of all the virtual counter used */
+	DECLARE_BITMAP(used_pmc, RISCV_MAX_COUNTERS);
+};
+
+#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
+#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
+#define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
+
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val);
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				unsigned long *ctr_info);
+
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag, uint64_t ival);
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag);
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flag,
+				     unsigned long eidx, uint64_t edata);
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				unsigned long *out_val);
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
+#endif
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 019df9208bdd..342d7199e89d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_timer.o
+kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_sbi_pmu.o vcpu_pmu.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 1549205fe5fe..d41ab6d1987d 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -49,7 +49,8 @@ int kvm_arch_hardware_enable(void)
 	hideleg |= (1UL << IRQ_VS_EXT);
 	csr_write(CSR_HIDELEG, hideleg);
 
-	csr_write(CSR_HCOUNTEREN, -1UL);
+	/* VS should access only TM bit. Everything else should trap */
+	csr_write(CSR_HCOUNTEREN, 0x02);
 
 	csr_write(CSR_HVIP, 0);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3c95924d38c7..4cc964aaf2ad 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -122,6 +122,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	kvm_riscv_vcpu_pmu_reset(vcpu);
 
 	vcpu->arch.hfence_head = 0;
 	vcpu->arch.hfence_tail = 0;
@@ -174,6 +175,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 
+	/* setup performance monitoring */
+	kvm_riscv_vcpu_pmu_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -196,6 +200,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	/* Cleanup VCPU timer */
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
+	kvm_riscv_vcpu_pmu_deinit(vcpu);
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7eb90a47b571..0aa334f853c8 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -214,7 +214,8 @@ struct csr_func {
 		    unsigned long wr_mask);
 };
 
-static const struct csr_func csr_funcs[] = { };
+static const struct csr_func csr_funcs[] = {
+};
 
 /**
  * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
new file mode 100644
index 000000000000..3168ed740bdd
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Rivos Inc
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
+#include <asm/kvm_vcpu_pmu.h>
+#include <linux/kvm_host.h>
+
+int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	if (!kvpmu)
+		return -EINVAL;
+
+	*out_val = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
+				unsigned long *ctr_info)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	if (!kvpmu || (cidx > RISCV_MAX_COUNTERS) || (cidx == 1))
+		return -EINVAL;
+
+	*ctr_info = kvpmu->pmc[cidx].cinfo.value;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag, uint64_t ival)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				 unsigned long ctr_mask, unsigned long flag)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
+				     unsigned long ctr_mask, unsigned long flag,
+				     unsigned long eidx, uint64_t edata)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				unsigned long *out_val)
+{
+	/* TODO */
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
+{
+	int i = 0, num_hw_ctrs, num_fw_ctrs, hpm_width;
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+
+	if (!kvpmu)
+		return -EINVAL;
+
+	num_hw_ctrs = riscv_pmu_sbi_get_num_hw_ctrs();
+	if ((num_hw_ctrs + RISCV_KVM_MAX_FW_CTRS) > RISCV_MAX_COUNTERS)
+		num_fw_ctrs = RISCV_MAX_COUNTERS - num_hw_ctrs;
+	else
+		num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
+
+	hpm_width = riscv_pmu_sbi_hpmc_width();
+	if (hpm_width <= 0) {
+		pr_err("Can not initialize PMU for vcpu as hpmcounter width is not available\n");
+		return -EINVAL;
+	}
+
+	kvpmu->num_hw_ctrs = num_hw_ctrs;
+	kvpmu->num_fw_ctrs = num_fw_ctrs;
+	/*
+	 * There is no corelation betwen the logical hardware counter and virtual counters.
+	 * However, we need to encode a hpmcounter CSR in the counter info field so that
+	 * KVM can trap n emulate the read. This works well in the migraiton usecase as well
+	 * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
+	 */
+	for (i = 0; i < num_hw_ctrs + num_fw_ctrs; i++) {
+		/* TIME CSR shouldn't be read from perf interface */
+		if (i == 1)
+			continue;
+		kvpmu->pmc[i].idx = i;
+		kvpmu->pmc[i].vcpu = vcpu;
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
+			kvpmu->pmc[i].cinfo.csr = CSR_CYCLE + i;
+		} else {
+			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_FW;
+			kvpmu->pmc[i].cinfo.width = BITS_PER_LONG - 1;
+		}
+	}
+
+	return 0;
+}
+
+void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
+{
+	/* TODO */
+}
+
+void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
+{
+	/* TODO */
+}
+
-- 
2.25.1


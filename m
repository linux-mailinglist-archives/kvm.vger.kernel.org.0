Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2308B578813
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiGRRGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiGRRF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:58 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA152C130
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h132so11122254pgc.10
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5MMCsELdRAdJh5aLmNFcZOyRr/D0RiLtBOcd/jSRJiU=;
        b=SZ6A4CByNWqPAfqTGaz70lPNVZuptERZ0n0u8v6E97djjISARvexx57xy8GGUdpF+7
         r/wz4gME1iPiN5m7T/2MCqyMwwdb3xeM41QcjwrrZmA5tMKBIkMLySe/imOL/raWFmnG
         xKa2mhJFZi0teVbY57hPs2+Bzzc0QSh8qG7kXumoXK9+hpWi6PD4chu1ayhJkh+miktd
         kXl5bOQIqIO/rE0/ExIZcBvmUHepnI2gs3SEIrxc3DXGAcDopac/yjWfOFX1XQdiPV6v
         0OgNbjia5UFMdtMEtdDpfKRXrszArD3bfhiVSlVxJie93lXnVZuvy7mPDqFJzLTsWe0j
         j/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5MMCsELdRAdJh5aLmNFcZOyRr/D0RiLtBOcd/jSRJiU=;
        b=Fu525V9uOC5lwaIjMJZXcOD8ZwnjlcsnbN+2Gu0idwyA6BdbYdq2VeW1rRMCSKJs4S
         g759tl3aoI1Kfm3hiBDABJI0ZTt7mH5EdkHhnWm+52/ovxxVEjwYc9peQDIb9eQ6t+SX
         BL+VwPiMkjT/XSm+cjGM3HRIi6geKDdz5MJFpgUTa6I3wdYIAOdOfYGykj4sJYYiAEpq
         GAC6XcI6Wy0wPvrns8fdjz1yGOZlvHkIoAMtzqKNJFrS/a0oPOTHFHpVePLaTJRUSnbA
         AjcHtUMb0eD8aonTK3t5+fa8dUk/Jm81vD8u4mS4RABl3KkRtozQIrdqNd6vGEB8B13B
         5J1g==
X-Gm-Message-State: AJIora9q1avBgJH4bKu4BOvPFFflwDWveq1yzQDz0OOMbQsppPdTqg/w
        X5Wt1Xp+0+z8dSwK2sbRcThUIw==
X-Google-Smtp-Source: AGRyM1vVmhagOiYrnqGiFf5EZMjik6HESCVupUtRm1lG/F6JRUTWiEEbCeHwm6Al2hYOL7mbJoR4Ng==
X-Received: by 2002:a63:6bc1:0:b0:40d:ffa8:2605 with SMTP id g184-20020a636bc1000000b0040dffa82605mr26252146pgc.299.1658163952186;
        Mon, 18 Jul 2022 10:05:52 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:51 -0700 (PDT)
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
Subject: [RFC  7/9] RISC-V: KVM: Implement trap & emulate for hpmcounters
Date:   Mon, 18 Jul 2022 10:02:03 -0700
Message-Id: <20220718170205.2972215-8-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718170205.2972215-1-atishp@rivosinc.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
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

As the KVM guests only see the virtual PMU counters, all hpmcounter
access should trap and KVM emulates the read access on behalf of guests.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 +++++++++
 arch/riscv/kvm/vcpu_insn.c            |  1 +
 arch/riscv/kvm/vcpu_pmu.c             | 47 +++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index bffee052f2ae..5410236b62a8 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -39,6 +39,19 @@ struct kvm_pmu {
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
 
+#if defined(CONFIG_32BIT)
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{ .base = CSR_CYCLEH,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
+{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
+#else
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
+#endif
+
+int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
+				unsigned long *val, unsigned long new_val,
+				unsigned long wr_mask);
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val);
 int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 				unsigned long *ctr_info);
@@ -59,6 +72,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{ .base = 0,      .count = 0, .func = NULL },
+
 
 static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 0aa334f853c8..7c2a4b1a69f7 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -215,6 +215,7 @@ struct csr_func {
 };
 
 static const struct csr_func csr_funcs[] = {
+	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
 };
 
 /**
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 3168ed740bdd..5434051f495d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -14,6 +14,46 @@
 #include <asm/kvm_vcpu_pmu.h>
 #include <linux/kvm_host.h>
 
+int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+				unsigned long *out_val)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u64 enabled, running;
+
+	if (!kvpmu)
+		return -EINVAL;
+
+	pmc = &kvpmu->pmc[cidx];
+	if (!pmc->perf_event)
+		return -EINVAL;
+
+	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
+	*out_val = pmc->counter_val;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
+				unsigned long *val, unsigned long new_val,
+				unsigned long wr_mask)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	int cidx, ret = KVM_INSN_CONTINUE_NEXT_SEPC;
+
+	if (!kvpmu)
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+	//TODO: Should we check if vcpu pmu is initialized or not!
+	if (wr_mask)
+		return KVM_INSN_ILLEGAL_TRAP;
+	cidx = csr_num - CSR_CYCLE;
+
+	if (kvm_riscv_vcpu_pmu_ctr_read(vcpu, cidx, val) < 0)
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	return ret;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
@@ -60,13 +100,6 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 	return 0;
 }
 
-int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
-				unsigned long *out_val)
-{
-	/* TODO */
-	return 0;
-}
-
 int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 {
 	int i = 0, num_hw_ctrs, num_fw_ctrs, hpm_width;
-- 
2.25.1


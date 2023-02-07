Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53E68D353
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjBGJ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjBGJ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:56:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA53C303E5
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:56:32 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b5so15105545plz.5
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E7BAkWfqdBTUxQj0K6lnix41P2O8NAVb+CIBpMCn0RU=;
        b=r/pxSzwFt3rSFhL9SlF2NTmmpfBhXdNppDOyxZKm/BSjdeXPVxIbyKmsDPR/QdNRFl
         +ccPnEwalFo4+cgEyzKywSQX/e5rYh435mp7loDiyetbQdGkP81QSoKxkSt8+VsMjrf/
         6zCVykyzHeChRXwEBMpUzIC1QLUc/da/HpVKPASmCNzsMcTrE1t8UjHD+urL6V29SJik
         zLpOu2s6Va0E5UYdQcn6IIkD+DOTiKmU/gkP9oRN8Uu7rsPevaizXnZ872GK8tJ4P4kx
         pHGWTBTT+Yd9EemxxDYEW+F+11jG2YiWMHI7+DgQmJrejig9JxhSGlR5eYXH4FtVOjzx
         Db8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E7BAkWfqdBTUxQj0K6lnix41P2O8NAVb+CIBpMCn0RU=;
        b=ZAeLU7PwNLPcGyS2Q6INr+R6lq4VSLGV86o5vMgTQvmKvOL9mtJ7cgKUmpeeCA6vHS
         6nxmOmT9jCHloAaG5v1EaAZGAIC3DT9ZIg7TIAYl7jJlj5vexXOFW28poKzwWNGWhewY
         vq85+CMdxpx51RpfVLgDcD939B2YZl0vShI7Jrjn/4v9q4q2utguWKNoM8mOqrACVjNa
         f+oUC/RxNrmyLt+Gr0viZ8ZmH+Fn43ylFh5RIAVkwdkDYpbSww2hPHwLkSTv5mF8exhB
         xNrw1RPupzIhb6tKEAthBIgnfLyriOyBZ+wNW0C6oRqLQHnbekjidF10LXM4V4WcPQs+
         Q/dg==
X-Gm-Message-State: AO0yUKXtGaFh6S4YeWSijR4RyHGzDaFXN3Xp9QybdgxmXCOcDL1NA6T+
        rNzEet3GcMWe/sXLuWNKTPT7vw==
X-Google-Smtp-Source: AK7set/KiNwvCDsB2jHSC1iBRbVtSSUeEB+XSFx7WsAj9uN9aXriHH6Laqe053+EYk5hSHnzd57K0A==
X-Received: by 2002:a17:902:e38a:b0:198:fd58:ee43 with SMTP id g10-20020a170902e38a00b00198fd58ee43mr1718482ple.12.1675763792316;
        Tue, 07 Feb 2023 01:56:32 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm4030598pll.175.2023.02.07.01.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 01:56:32 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v6 5/8] RISC-V: KVM: Implement trap & emulate for hpmcounters
Date:   Tue,  7 Feb 2023 01:55:26 -0800
Message-Id: <20230207095529.1787260-6-atishp@rivosinc.com>
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

As the KVM guests only see the virtual PMU counters, all hpmcounter
access should trap and KVM emulates the read access on behalf of guests.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++
 arch/riscv/kvm/vcpu_insn.c            |  4 +-
 arch/riscv/kvm/vcpu_pmu.c             | 59 ++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 0b86a47..4bc774c 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -45,6 +45,19 @@ struct kvm_pmu {
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
 
+#if defined(CONFIG_32BIT)
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{.base = CSR_CYCLEH,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm }, \
+{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+#else
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+#endif
+
+int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
+				unsigned long *val, unsigned long new_val,
+				unsigned long wr_mask);
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
 int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
@@ -68,6 +81,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{.base = 0,	.count = 0,	.func = NULL },
+
 static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 0bb5276..f689337 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -213,7 +213,9 @@ struct csr_func {
 		    unsigned long wr_mask);
 };
 
-static const struct csr_func csr_funcs[] = { };
+static const struct csr_func csr_funcs[] = {
+	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
+};
 
 /**
  * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 6c1f073..51a0237 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -17,6 +17,58 @@
 
 #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
 
+static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+			unsigned long *out_val)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u64 enabled, running;
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
+	if (!kvpmu || !kvpmu->init_done) {
+		/*
+		 * In absence of sscofpmf in the platform, the guest OS may use
+		 * the legacy PMU driver to read cycle/instret. In that case,
+		 * just return 0 to avoid any illegal trap. However, any other
+		 * hpmcounter access should result in illegal trap as they must
+		 * be access through SBI PMU only.
+		 */
+		if (csr_num == CSR_CYCLE || csr_num == CSR_INSTRET) {
+			*val = 0;
+			return ret;
+		} else {
+			return KVM_INSN_ILLEGAL_TRAP;
+		}
+	}
+
+	/* The counter CSR are read only. Thus, any write should result in illegal traps */
+	if (wr_mask)
+		return KVM_INSN_ILLEGAL_TRAP;
+
+	cidx = csr_num - CSR_CYCLE;
+
+	if (pmu_ctr_read(vcpu, cidx, val) < 0)
+		return KVM_INSN_ILLEGAL_TRAP;
+
+	return ret;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
@@ -69,7 +121,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata)
 {
-	/* TODO */
+	int ret;
+
+	ret = pmu_ctr_read(vcpu, cidx, &retdata->out_val);
+	if (ret == -EINVAL)
+		retdata->err_val = SBI_ERR_INVALID_PARAM;
+
 	return 0;
 }
 
-- 
2.25.1


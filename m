Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBF567ED75
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbjA0S0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbjA0S03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:29 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B35E84FBD
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lp10so5357614pjb.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eB56PlxVYYG9BW+idfsAIH60JlcBASeIP8IcBFqjbQ=;
        b=6tHALczfMbO8hse+3nrl1EO2mLFyq7flzJfTD3DpnSn2HXfxrnmud2b1bJLig7zxsC
         nbMCPzVzxWzfujxyIf3eM9MR3OpgNMIjwoO8ZOmLNNhMHi3n91saw1z16D3JdgLOR/4Z
         hl4TwdItUXrD6ixIe9gzHpd+70KjkqhLApicV8ke19vKhGbW7RtqcaqBgU4vRhojWRBH
         tfPbkA/cS2eonmVQKajbTs9Y40yZ5rJgSiq7h9X3lF7eKKpYieg0se7+8xtyI7UQk59Q
         9KQWR7a3SMnndznUFFGX8jqJDkQS3sqrVaKWKImVrHp7RCW3k6MjZBqg/+bPCaHemItz
         NiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eB56PlxVYYG9BW+idfsAIH60JlcBASeIP8IcBFqjbQ=;
        b=Tm5hPBcLCyCkQ8HxGt8TYA4udB36xaFc+0Z/obofiQ/8vhJj2TsrATg0qwAt8/Nfnf
         InRGN5LPdswfLRecBRCeqAOSzOXnE8pdPoP3IeEmqdBJfeuJW3hn6IJMLJInm1TgKmWC
         xRfRhIFcQMtlR1hlQHjUX4NKl8a8gTgWrNcIBd17gR8vwgTLbCEMcdNLyeYIqN2Kynhg
         XTd8T4eUcLQjA9uJEyIiGrpPOXT9Ho2jFNdFF11SbA/vKXTfrl+LdzFi9JKSobxHEEEg
         3VSHSZoer6GIybfsa9PsbledOiqRQreCWs8xP8MV8kuls3kPX02BF2XvNAskz1noGv4q
         dUtA==
X-Gm-Message-State: AO0yUKW76oxHpBT0K1eiMfREDYyEVE4rCmTT8p87IxnIcv0yebGoI0K0
        w/Q/rgKQWp/bPHx5J/H9TTD7BQ==
X-Google-Smtp-Source: AK7set+oYbUUwtd4EAD6XiA8CIBGPbEJJpjDsAhrh7noLsI76uIOCbGORCnptpGlJUW1uUZsqmEGgA==
X-Received: by 2002:a17:902:d4c8:b0:196:357f:9398 with SMTP id o8-20020a170902d4c800b00196357f9398mr10667341plg.34.1674843983718;
        Fri, 27 Jan 2023 10:26:23 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:23 -0800 (PST)
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
Subject: [PATCH v3 11/14] RISC-V: KVM: Implement trap & emulate for hpmcounters
Date:   Fri, 27 Jan 2023 10:25:55 -0800
Message-Id: <20230127182558.2416400-12-atishp@rivosinc.com>
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

As the KVM guests only see the virtual PMU counters, all hpmcounter
access should trap and KVM emulates the read access on behalf of guests.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++++
 arch/riscv/kvm/vcpu_insn.c            |  4 ++-
 arch/riscv/kvm/vcpu_pmu.c             | 45 ++++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 3f43a43..022d45d 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -43,6 +43,19 @@ struct kvm_pmu {
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 
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
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
 int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_ext_data *edata);
@@ -65,6 +78,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
+#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
+{ .base = 0,      .count = 0, .func = NULL },
+
 
 static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 {
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
index 7713927..894053a 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -17,6 +17,44 @@
 
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
+	if (!kvpmu || !kvpmu->init_done)
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	if (wr_mask)
+		return KVM_INSN_ILLEGAL_TRAP;
+
+	cidx = csr_num - CSR_CYCLE;
+
+	if (pmu_ctr_read(vcpu, cidx, val) < 0)
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	return ret;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
@@ -69,7 +107,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_ext_data *edata)
 {
-	/* TODO */
+	int ret;
+
+	ret = pmu_ctr_read(vcpu, cidx, &edata->out_val);
+	if (ret == -EINVAL)
+		edata->err_val = SBI_ERR_INVALID_PARAM;
+
 	return 0;
 }
 
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0599D67ED61
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjA0S0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbjA0S0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9FF7BBEA
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m2so864992plg.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGqgvezQ/AlpTuqgVROWAp2lac08ioX9ghbgFT6R5zs=;
        b=IoRffA7eaBKD5TnGEAMzpERUl+R39LOxAlgfDLhDNga+rN9SbFYLfdz9WFRgJCTeRN
         9Updpbd1OZtc//enWU826k0AachdF3yKioeNtgxkt9/kIfGqMeggP3NJkMHCVrn38zEt
         o0ySxQgMwR7DstBzrONN9sUSnnkIYSCZmjlPUaPZycJTqTBIKNAj0Y+IKQKTWXZUV/g1
         Hbr1Yw2D00RYz6wcO9p7KP1dPScebiMdJ1Wz7lqeW/m8MLImzr1r9OBpSxBUtGPDMeaU
         EKmOy6JcaGBPxAZXqtqvKGClyDQ4IZH3V1Pgrky1d4NUmTsNJDKgHZ/O9226Ve6thdSn
         TZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGqgvezQ/AlpTuqgVROWAp2lac08ioX9ghbgFT6R5zs=;
        b=qwFkeNHeXKRpBByH9haFyTlOC/7VhlHVrTJfrrZL3ykRH3G8V6kNAKMYtb6FIxR1ev
         eSEE/VYyVCdXjrgbtMyfmqdxH0V1Md4u2By6hpKHG6MxCEanwZXxFiZmKnaopR8idDxe
         XtjnPec5nBaTKCYZzE1mW3csuOfjx8GhM/6phJ8hSHeYT1ZoI3PoXxeIB6gG60Gpl/so
         tdTj5BetqL/zExdPBUnsI2RZ8rYRieu5NQJ3PoZaoWcG8XM6I/w3/YE6lZKbJ9xQRLHm
         8mVhU8u4o2FAmw2HbnuQOpvPKSsOxy8HnmbIG1FeVw6Swxk3svuX/TCbklnlq5+Pe5+3
         46dw==
X-Gm-Message-State: AO0yUKWRXHTdFUPzEcXu0tYZ9r3w7Iu83s0J2qvOEvLBqNPvvwICpFCf
        5uGitykYbIrvOaoOrJLKh1t/aJDRBOHxOyKX
X-Google-Smtp-Source: AK7set+cnIlp7JbMlNK7BW+W2Y23IVQIWZv8DFzQh9nYmsI7NrsZq7emEqdZjMsHA/iQQGK1DvKKNA==
X-Received: by 2002:a17:902:f54c:b0:196:f82:14c9 with SMTP id h12-20020a170902f54c00b001960f8214c9mr17447443plf.57.1674843974605;
        Fri, 27 Jan 2023 10:26:14 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:14 -0800 (PST)
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
Subject: [PATCH v3 01/14] perf: RISC-V: Define helper functions expose hpm counter width and count
Date:   Fri, 27 Jan 2023 10:25:45 -0800
Message-Id: <20230127182558.2416400-2-atishp@rivosinc.com>
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

KVM module needs to know how many hardware counters and the counter
width that the platform supports. Otherwise, it will not be able to show
optimal value of virtual counters to the guest. The virtual hardware
counters also need to have the same width as the logical hardware
counters for simplicity. However, there shouldn't be mapping between
virtual hardware counters and logical hardware counters. As we don't
support hetergeneous harts or counters with different width as of now,
the implementation relies on the counter width of the first available
programmable counter.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 37 ++++++++++++++++++++++++++++++++--
 include/linux/perf/riscv_pmu.h |  3 +++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index f6507ef..6b53adc 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -44,7 +44,7 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
 };
 
 /*
- * RISC-V doesn't have hetergenous harts yet. This need to be part of
+ * RISC-V doesn't have heterogeneous harts yet. This need to be part of
  * per_cpu in case of harts with different pmu counters
  */
 static union sbi_pmu_ctr_info *pmu_ctr_list;
@@ -52,6 +52,9 @@ static bool riscv_pmu_use_irq;
 static unsigned int riscv_pmu_irq_num;
 static unsigned int riscv_pmu_irq;
 
+/* Cache the available counters in a bitmask */
+static unsigned long cmask;
+
 struct sbi_pmu_event_data {
 	union {
 		union {
@@ -267,6 +270,37 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
 	return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
 }
 
+/*
+ * Returns the counter width of a programmable counter and number of hardware
+ * counters. As we don't support heterogeneous CPUs yet, it is okay to just
+ * return the counter width of the first programmable counter.
+ */
+int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
+{
+	int i;
+	union sbi_pmu_ctr_info *info;
+	u32 hpm_width = 0, hpm_count = 0;
+
+	if (!cmask)
+		return -EINVAL;
+
+	for_each_set_bit(i, &cmask, RISCV_MAX_COUNTERS) {
+		info = &pmu_ctr_list[i];
+		if (!info)
+			continue;
+		if (!hpm_width && info->csr != CSR_CYCLE && info->csr != CSR_INSTRET)
+			hpm_width = info->width;
+		if (info->type == SBI_PMU_CTR_TYPE_HW)
+			hpm_count++;
+	}
+
+	*hw_ctr_width = hpm_width;
+	*num_hw_ctr = hpm_count;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(riscv_pmu_get_hpm_info);
+
 static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -812,7 +846,6 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 static int pmu_sbi_device_probe(struct platform_device *pdev)
 {
 	struct riscv_pmu *pmu = NULL;
-	unsigned long cmask = 0;
 	int ret = -ENODEV;
 	int num_counters;
 
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index e17e86a..a1c3f77 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -73,6 +73,9 @@ void riscv_pmu_legacy_skip_init(void);
 static inline void riscv_pmu_legacy_skip_init(void) {};
 #endif
 struct riscv_pmu *riscv_pmu_alloc(void);
+#ifdef CONFIG_RISCV_PMU_SBI
+int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
+#endif
 
 #endif /* CONFIG_RISCV_PMU */
 
-- 
2.25.1


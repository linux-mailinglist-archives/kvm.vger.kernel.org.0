Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB3C6871A1
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjBAXM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjBAXMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:12:55 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459CC6DFD4
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:12:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so124901pjb.5
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onmGdXrnry2vzffi8Nhu5Xp1RppTFZNrejjmetcLTEs=;
        b=mwaH9OwJ6npnyit++cTrdcB7gWWmafNtH0mV16h6tJ9HLeouQJLd2FzqMcs04z5/8/
         pEs99izSSLF03rf2tVL6ghwFMiP0RsH9AylohFlJZJ5VHvaV/BrCbVotfozeKfaEEQrV
         hJe0/LIvqVwKCSxb6kiUNLeOUpggEzMrXYmMZ3asoKVqSXRXL+Ouu1uSklM4rlvwUFWN
         VJKB3Y780Ur9bjNwCjDDQD9ubKiFOermULTKn+kGdN+p57Bc0QA3lb45NtAgS+ICsw93
         wug/Wu+IEwWeDBD13IFMh3qzaS4y83QLZifn7LWKEq1nl6m5NkcKyc68fkSvA1Cy4kPV
         lW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onmGdXrnry2vzffi8Nhu5Xp1RppTFZNrejjmetcLTEs=;
        b=i86mr/204tZ2ZH7t31kUVbNS4IzxjmHAJAIAa11QqUjFDS1g8lgnMobkTqKGqBgSk3
         RXENPgGEKMAOabB60/pUmhSJTqWCnt5MrvTmwDus34VBHtC61aiy5dylJJxhEYofeoh+
         So2K+ZIxrVasXNguEG0Yao76aDMGIxhhSEsOXDRT7+cx3UtF79h0TFYXGaZofS36LpDm
         nBIZNZ11KU22/9zPKPal0fCh57mEGjhZZpQWc/S2WBfwTs89BIryB0x8H5xkv9xjvLdA
         qewKuyb2/7U1OngmviIJZ1fAV1li68FWyOD8phdcUmhfLM7jDxZxqbDEyhfnAZBpcJTN
         MzPQ==
X-Gm-Message-State: AO0yUKUGN1AaCpjqC4Emk0Zen8MYMeCWGcyK7KfAeSkNh6SIBGkQIzxi
        Ik1nTEU2hT2g/llHmbENEWng0A==
X-Google-Smtp-Source: AK7set+jo5+wHuuLA5aFbnELNbEvc0p590K2fazE0b1l14XbgxMtPKXok8+umitAQcALi0t1abpc7w==
X-Received: by 2002:a17:90a:312:b0:225:d450:2ccc with SMTP id 18-20020a17090a031200b00225d4502cccmr3995336pje.30.1675293173726;
        Wed, 01 Feb 2023 15:12:53 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:12:53 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 01/14] perf: RISC-V: Define helper functions expose hpm counter width and count
Date:   Wed,  1 Feb 2023 15:12:37 -0800
Message-Id: <20230201231250.3806412-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201231250.3806412-1-atishp@rivosinc.com>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
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

Reviewed-by: Anup Patel <anup@brainfault.org>
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


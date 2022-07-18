Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78261578809
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiGRRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbiGRRFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:46 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504662BB12
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:45 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h132so11121945pgc.10
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8D/oi8qgxVglaE+KkXtnFYaHMrc21lTodlCKwN8q0IQ=;
        b=6NTHNWDkGfN7I+U3W+qmMcN0LlUVIhzQVfmatvueYDhm8xc3F4XrNe3HMFoK47IaeP
         wezuL4aRYBbBQbfcTX6JLbwTLYCb6mq25SW67gKOZRSMVOOn9ugx9Du/yLIya1jEXiGa
         VaLqwovf483nx9vII+fm0YIOZKj3Je/TzzINbqEZBo+KvLTzAQ79d3DtpvrydepRM+i5
         YsD2Eidv3FO5D50/wsetAe86PBnZdrehL4o2bdHfVEgSmy+pVZKLQ4n4yt4wPXyejx2Q
         yZkNzkd/0jDcSycMCWUv6lNEvloqo4BB9asMOgTq7RRA5XOLGZGz8j+W2LKSmBcQCAU9
         k4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8D/oi8qgxVglaE+KkXtnFYaHMrc21lTodlCKwN8q0IQ=;
        b=GLRWuwAFFsxugaCMTIiPTBJ3Jmtd4MYu0jDTUgskz86fur2VZHzt3mz6buSlNru2ue
         91FGDJUbAvuX3cV1/eBAY9VyqN3oUA0ylZgQcgqLJFzBzJkE7qGLwxzgwWdkBv61T4qU
         wKCwkpDC/hh85Mhu6lI4cgmw0DjSfTtMUeCPwwgF7IQ76tKw6LyurqYexQPo29EBgap3
         +4bdV+3bbZGCXtICIguwbLuV9NXZrNASrBpTK43ypNnNzFITnc0NXraq8cRee9LQ9DdX
         1xLqzGAa6T2p7VZIsTx+vmBAk+e+mr3Wb5nBCDlaz0LS1ds/Qz9S/cysVnz4syFUmuMU
         s/vQ==
X-Gm-Message-State: AJIora+KDjsasLnJwQtLPutXfTixjEV7KuvwZFbHnLszeyQnxlvvGwmP
        MrDNwb538WvXkv8GNZ/jTysSVw==
X-Google-Smtp-Source: AGRyM1vFaRliljxiyhBObWT8RV5lv8cN9afUQtCB8wCNEDbktpQqD63FFaGhCAEBugkoEzCPluKhgw==
X-Received: by 2002:a63:ec15:0:b0:412:6fb4:88fb with SMTP id j21-20020a63ec15000000b004126fb488fbmr24847293pgh.49.1658163944724;
        Mon, 18 Jul 2022 10:05:44 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:44 -0700 (PDT)
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
Subject: [RFC  1/9] RISC-V: Define a helper function to probe number of hardware counters
Date:   Mon, 18 Jul 2022 10:01:57 -0700
Message-Id: <20220718170205.2972215-2-atishp@rivosinc.com>
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

KVM module needs to know how many hardware counters the platform supports.
Otherwise, it will not be able to show optimal value of virtual
counters to the guest.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 23 +++++++++++++++++------
 include/linux/perf/riscv_pmu.h |  4 ++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 24124546844c..1723af68ffa1 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -27,6 +27,7 @@
  */
 static union sbi_pmu_ctr_info *pmu_ctr_list;
 static unsigned int riscv_pmu_irq;
+static struct riscv_pmu *rvpmu;
 
 struct sbi_pmu_event_data {
 	union {
@@ -227,6 +228,12 @@ static const struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_M
 	},
 };
 
+int riscv_pmu_sbi_get_num_hw_ctrs(void)
+{
+	return rvpmu ? rvpmu->num_hw_counters : 0;
+}
+EXPORT_SYMBOL(riscv_pmu_sbi_get_num_hw_ctrs);
+
 static int pmu_sbi_ctr_get_width(int idx)
 {
 	return pmu_ctr_list[idx].width;
@@ -443,7 +450,7 @@ static int pmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int pmu_sbi_get_ctrinfo(int nctr)
+static int pmu_sbi_get_ctrinfo(int nctr, int *num_hw_ctrs)
 {
 	struct sbiret ret;
 	int i, num_hw_ctr = 0, num_fw_ctr = 0;
@@ -453,7 +460,7 @@ static int pmu_sbi_get_ctrinfo(int nctr)
 	if (!pmu_ctr_list)
 		return -ENOMEM;
 
-	for (i = 0; i <= nctr; i++) {
+	for (i = 0; i < nctr; i++) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i, 0, 0, 0, 0, 0);
 		if (ret.error)
 			/* The logical counter ids are not expected to be contiguous */
@@ -466,6 +473,7 @@ static int pmu_sbi_get_ctrinfo(int nctr)
 		pmu_ctr_list[i].value = cinfo.value;
 	}
 
+	*num_hw_ctrs = num_hw_ctr;
 	pr_info("%d firmware and %d hardware counters\n", num_fw_ctr, num_hw_ctr);
 
 	return 0;
@@ -698,7 +706,7 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 static int pmu_sbi_device_probe(struct platform_device *pdev)
 {
 	struct riscv_pmu *pmu = NULL;
-	int num_counters;
+	int num_counters, num_hw_ctrs = 0;
 	int ret = -ENODEV;
 
 	pr_info("SBI PMU extension is available\n");
@@ -713,7 +721,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	}
 
 	/* cache all the information about counters now */
-	if (pmu_sbi_get_ctrinfo(num_counters))
+	if (pmu_sbi_get_ctrinfo(num_counters, &num_hw_ctrs))
 		goto out_free;
 
 	ret = pmu_sbi_setup_irqs(pmu, pdev);
@@ -723,6 +731,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 	}
 	pmu->num_counters = num_counters;
+	pmu->num_hw_counters = num_hw_ctrs;
 	pmu->ctr_start = pmu_sbi_ctr_start;
 	pmu->ctr_stop = pmu_sbi_ctr_stop;
 	pmu->event_map = pmu_sbi_event_map;
@@ -733,14 +742,16 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
 	ret = cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	ret = perf_pmu_register(&pmu->pmu, "cpu", PERF_TYPE_RAW);
 	if (ret) {
 		cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
-		return ret;
+		goto out_free;
 	}
 
+	rvpmu = pmu;
+
 	return 0;
 
 out_free:
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 46f9b6fe306e..fc47167e000c 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -46,6 +46,7 @@ struct riscv_pmu {
 	irqreturn_t	(*handle_irq)(int irq_num, void *dev);
 
 	int		num_counters;
+	int		num_hw_counters;
 	u64		(*ctr_read)(struct perf_event *event);
 	int		(*ctr_get_idx)(struct perf_event *event);
 	int		(*ctr_get_width)(int idx);
@@ -69,6 +70,9 @@ void riscv_pmu_legacy_skip_init(void);
 static inline void riscv_pmu_legacy_skip_init(void) {};
 #endif
 struct riscv_pmu *riscv_pmu_alloc(void);
+#ifdef CONFIG_RISCV_PMU_SBI
+int riscv_pmu_sbi_get_num_hw_ctrs(void);
+#endif
 
 #endif /* CONFIG_RISCV_PMU */
 
-- 
2.25.1


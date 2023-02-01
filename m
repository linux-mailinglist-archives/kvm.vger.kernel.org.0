Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53FC6871A7
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjBAXM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBAXM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:12:56 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4286DFC8
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:12:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so133245pjb.3
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPkrRraxSxPO8Bas1c93CWcZiwYxt6lnwNFP5o7eW+0=;
        b=GDjRVrlMr6DII4aIgdnPYMJ41hWW5uh72aFtABpePmoexFkHPHvcA/3dfDQAMWzoo8
         OPiap6WUXigqdbr/QtNfCF0eN6nzgZDx/l1VlPRWMFRjBo8sOwqp5MkZAd6RaUnpj0UJ
         JVu0nq2lkaGj+yVQR8LACwjzqaL8koEXohUSTYpwqTI54GSaIWVaeJp73qWyybkxjvhC
         NyvKhAlZwgqKDEov8r5C65xjF9YhGzKxvlL37uWjR5JKo0U4WrmCX3e5Rno8wn0dSxiM
         aK1SGbzvyzZv3k8+6BPMo7aJnrtNisqjOerXpTjd52qu8NQblBu0CN7xwO0Rgt+gwuc8
         6cOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPkrRraxSxPO8Bas1c93CWcZiwYxt6lnwNFP5o7eW+0=;
        b=R4bqjFJtqea069fbCLeI3FpgD+oVT9zxggs7mEjjSRbg6UIyF4y0wzDoM+/lZqlDrn
         c/a8Y0XDYPW9E1CmUACNGzQJ4b15mbB/tGoFRBYXAyparLhB84xYR491l8cz4ikiq3d8
         NA2xSQuOMrizy5t2lvIOzQiR0JMmNMDkCn1kNe1xyKFUUu+RzDUFjOgPh3kpE+0nHGP8
         hE4WlPbkqPPUmqA/BdWhTA6/M8UEQBApjnVYSeTbEqPre1kWi98eAX85GEemCFcjw9OX
         c9elzXh3vY0DeCiDIpb4LwiMTD/nEIVV982q75GNAS9T4U0nE00uPM4h2s8H6Icx6xFE
         6sFA==
X-Gm-Message-State: AO0yUKUfQPVgLEyMNMfBRF/SbD6U3od7QjHIY2ZzXBV8+WkNCnKtccCi
        txs4gfobHgwaLXK9fwNSYuv+fQ==
X-Google-Smtp-Source: AK7set/j7/SK7FHXfvxWEEeu+5cvX72ttD9RDrBgPJ0RWp+yvVFZgAlWnrRL+B+Q10v76F+KGFhiOw==
X-Received: by 2002:a17:90a:1955:b0:22b:fcb6:c7cc with SMTP id 21-20020a17090a195500b0022bfcb6c7ccmr4186306pjh.29.1675293174658;
        Wed, 01 Feb 2023 15:12:54 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:12:54 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 02/14] perf: RISC-V: Improve privilege mode filtering for perf
Date:   Wed,  1 Feb 2023 15:12:38 -0800
Message-Id: <20230201231250.3806412-3-atishp@rivosinc.com>
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

Currently, the host driver doesn't have any method to identify if the
requested perf event is from kvm or bare metal. As KVM runs in HS
mode, there are no separate hypervisor privilege mode to distinguish
between the attributes for guest/host.

Improve the privilege mode filtering by using the event specific
config1 field.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 27 ++++++++++++++++++++++-----
 include/linux/perf/riscv_pmu.h |  2 ++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 6b53adc..71174fa 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -301,6 +301,27 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
 }
 EXPORT_SYMBOL_GPL(riscv_pmu_get_hpm_info);
 
+static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
+{
+	unsigned long cflags = 0;
+	bool guest_events = false;
+
+	if (event->attr.config1 & RISCV_PMU_CONFIG1_GUEST_EVENTS)
+		guest_events = true;
+	if (event->attr.exclude_kernel)
+		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_user)
+		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FLAG_SET_UINH;
+	if (guest_events && event->attr.exclude_hv)
+		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_host)
+		cflags |= SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_guest)
+		cflags |= SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
+
+	return cflags;
+}
+
 static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -311,11 +332,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	uint64_t cbase = 0;
 	unsigned long cflags = 0;
 
-	if (event->attr.exclude_kernel)
-		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
-	if (event->attr.exclude_user)
-		cflags |= SBI_PMU_CFG_FLAG_SET_UINH;
-
+	cflags = pmu_sbi_get_filter_flags(event);
 	/* retrieve the available counter index */
 #if defined(CONFIG_32BIT)
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index a1c3f77..43fc892 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -26,6 +26,8 @@
 
 #define RISCV_PMU_STOP_FLAG_RESET 1
 
+#define RISCV_PMU_CONFIG1_GUEST_EVENTS 0x1
+
 struct cpu_hw_events {
 	/* currently enabled events */
 	int			n_events;
-- 
2.25.1


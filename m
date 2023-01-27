Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A5067ED64
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbjA0S0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjA0S0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A97B78B
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b10so5377084pjo.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cn2VkKN/WuIcEOyjejqwRSpO25aVX0itAsGTfYH0Pbw=;
        b=DAAXxtYjkQddNCj7UM7En6mqUmf3J2gzYsFadRPtlJg6aTcQ7YLch8H//JxlEijKk7
         5uxQ73XFulPZlp1QmIf6vQrIzjaSZg+PKSPJ3UkME9YpCFWvyWYP/k4BMD7A2aXG0iOr
         je+nSeC+7pEg35a+Jn4PQsXJfTRp5WdUJb2DW73Yn+WSuExXhf/39l5UMQta2v5BYmLX
         eHi9cQY4mXQ1MAatncFFmUs7n1voCzvRxMfNIgfWNoKB2Yt+UJ8yX8cBUxEdezG4CNU+
         BfL31EsqTfc+KOhOQi0xZ4vhH735HWHaTQ3Rtpsn7fIxeyWHSsET1qCBmGo3xlclDkCW
         /gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cn2VkKN/WuIcEOyjejqwRSpO25aVX0itAsGTfYH0Pbw=;
        b=cNnQZE9Ac261v9C7AIu/3tJjN0eBaW/qf5XTCIsUbeeFgsSQ+mG4AGGSxbUb4om5FP
         oLGU9lbcBwBFV4NddzsiXrE69zS/RguZByHCeVXaN0RluqiHcqGttL4jMU5e+Nfst9xR
         zh6ZlOwOD4qshDHiAlGsGCMKnlyeF/jCubU5fylr202MwXKP2jnn2bsn1ooBmg3MmvmK
         Q9bqbYztKMY86R3CVMQYbTlBUVqed539jngK0H9SGhgoa5Zdj6VmID2OPq4MvnWgFBDw
         O3zTlzdTdSZmDJn7GTzpGVV1CrTP2nikt9ldVXb/FHgdzn1Nz569T7Qn/ojMGbRamkPM
         EOLg==
X-Gm-Message-State: AO0yUKWFz8oMuJyYjqKUeppMIRcoeS2RqVG+ASPLn7imkzVypwq8/t3D
        tmXH9RgBRsWsQnjqVGqXPG50uKB8smJZZiOR
X-Google-Smtp-Source: AK7set8r6nl3JNPXU8sjoTzHFKmJTI+gWSEYIL1CwiWtyssd72a/N86A2G/VJ1879ufSaeoYEoYbAg==
X-Received: by 2002:a17:902:db0d:b0:196:32fa:69a9 with SMTP id m13-20020a170902db0d00b0019632fa69a9mr6206312plx.51.1674843976411;
        Fri, 27 Jan 2023 10:26:16 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:16 -0800 (PST)
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
Subject: [PATCH v3 03/14] RISC-V: Improve SBI PMU extension related definitions
Date:   Fri, 27 Jan 2023 10:25:47 -0800
Message-Id: <20230127182558.2416400-4-atishp@rivosinc.com>
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

This patch fixes/improve few minor things in SBI PMU extension
definition.

1. Align all the firmware event names.
2. Add macros for bit positions in cache event ID & ops.

The changes were small enough to combine them together instead
of creating 1 liner patches.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 4ca7fba..f21c026 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -171,7 +171,7 @@ enum sbi_pmu_fw_generic_events_t {
 	SBI_PMU_FW_IPI_SENT		= 6,
 	SBI_PMU_FW_IPI_RECVD		= 7,
 	SBI_PMU_FW_FENCE_I_SENT		= 8,
-	SBI_PMU_FW_FENCE_I_RECVD	= 9,
+	SBI_PMU_FW_FENCE_I_RCVD		= 9,
 	SBI_PMU_FW_SFENCE_VMA_SENT	= 10,
 	SBI_PMU_FW_SFENCE_VMA_RCVD	= 11,
 	SBI_PMU_FW_SFENCE_VMA_ASID_SENT	= 12,
@@ -215,6 +215,9 @@ enum sbi_pmu_ctr_type {
 #define SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK 0x06
 #define SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK 0x01
 
+#define SBI_PMU_EVENT_CACHE_ID_SHIFT 3
+#define SBI_PMU_EVENT_CACHE_OP_SHIFT 1
+
 #define SBI_PMU_EVENT_IDX_INVALID 0xFFFFFFFF
 
 /* Flags defined for config matching function */
-- 
2.25.1


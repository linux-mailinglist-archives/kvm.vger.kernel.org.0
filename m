Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE356871A3
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBAXNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjBAXM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:12:57 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1428D69B1A
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:12:56 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ha3-20020a17090af3c300b00230222051a6so149338pjb.2
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Swsmclp46MJMZpiJNbVkRXfXbIV9+a/sdi6Y4jP8Qv8=;
        b=OJbXUBOr/ZlbJi7vQRyGb87sk7661p12dXbqByJt3JiFMJPd5GDWQu6i0CGaYXFJVw
         gqSpEQmlvRYM5k+7UEA5Acq29fe4BmqSKqBgJwCY6BwMZKcQmNwDylgmwk9rJ1NwnHhm
         BakwRqHpr77iAPFGS2XevYsZUhcpvTzk80E1GFspOTZriMbbfL8OKI63RYOlYhcqgDL3
         95ZYAdVWl0Bu+CNjm9gG5/NDsCdoMtj0I2Yj1y5pB9vwolZoGjbS7cTJqI2cZAydchne
         pKZQ83gPDuYtrOmk0UyUhSk9/6zfn0qVOD+2p3oJ6/BCH2Co+ERnrrTVEEBFyY5mwA7A
         KXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Swsmclp46MJMZpiJNbVkRXfXbIV9+a/sdi6Y4jP8Qv8=;
        b=gLg8GlK5OUajioGZgDTg2gEJAhalEspSjPBoiE8Ly5yLoYsipmLZctpyWaxh57bwfi
         BFLMsPlUgfyt12pzgafsNX7ojX47WGxjpSFbrv3hwUN74++slYUSBbtPj1cDzBtbxxOT
         hjBtH0ZSwKdtdjW66mdADY4RkRwQbsK6cxWWoWJW3Ok45/eFH+JZTVowqoz7aM+qLuRR
         RxhK3/QCwKVou0rlqmyByFueNADsnGr70f+eHZS8xM+Go7XjqwtzTS9qCJruzK1U2dgE
         XdUXwmUZCEjnI+iVZJNLhuTxRTDIv9wWZzL0pRKWr2/MfUNKTbssJ6cquc9o7P3dKoDY
         C/MQ==
X-Gm-Message-State: AO0yUKVDBBpO7QbA16+mrjZik8x6PPDse4WhEb9acy3aeTXHfWP8+LwJ
        R50dLH33ln4/w6ZbFnMHnZ+s9A==
X-Google-Smtp-Source: AK7set9yHunZIISJKCkgU5VKiMMbq92U0RM5RvdeJ6AGpEJExx4sxV6qe6tRixhTqggVjicyO0Ao7g==
X-Received: by 2002:a17:90a:3dc5:b0:22c:816e:d67d with SMTP id i63-20020a17090a3dc500b0022c816ed67dmr4309913pjc.24.1675293175608;
        Wed, 01 Feb 2023 15:12:55 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:12:55 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 03/14] RISC-V: Improve SBI PMU extension related definitions
Date:   Wed,  1 Feb 2023 15:12:39 -0800
Message-Id: <20230201231250.3806412-4-atishp@rivosinc.com>
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

This patch fixes/improve few minor things in SBI PMU extension
definition.

1. Align all the firmware event names.
2. Add macros for bit positions in cache event ID & ops.

The changes were small enough to combine them together instead
of creating 1 liner patches.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 4ca7fba..945b7be 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -169,9 +169,9 @@ enum sbi_pmu_fw_generic_events_t {
 	SBI_PMU_FW_ILLEGAL_INSN		= 4,
 	SBI_PMU_FW_SET_TIMER		= 5,
 	SBI_PMU_FW_IPI_SENT		= 6,
-	SBI_PMU_FW_IPI_RECVD		= 7,
+	SBI_PMU_FW_IPI_RCVD		= 7,
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


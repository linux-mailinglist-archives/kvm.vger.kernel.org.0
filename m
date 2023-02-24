Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3356A202F
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjBXRCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBXRCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:02:15 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0714E6C187
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so1133781pjp.2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NUxvG1XG6bOZdb2vYKQcTDKK4B2zTq/9lRnOgI0kuro=;
        b=G0iOZJZU7g0E+B7ftGmEs4i8CQpL/Z0a/Aep9Cro6JqfVmeywMvkv+84OYPhgWTAT7
         c2p2zdzp6vyBY92oth6ReHpW3TbslG2tSkC6VH6t9Z3CjuSJCLw/KLG2XckV0LJ6/Fyx
         i7Tlxs8TMGPmCPV1cw8f6C0NRhSRFwNXz26Huf55J11yozjRu133bYWrhf0qrG+fnfBS
         4maHfEVg80sB7J9tyvL1nuBmW4qHULVT+V9y2imf7P9jQkJuyLrcaW6D9CGs5o57yEVT
         rJEreQYHlG1gmEjkdOpcVTB6Lg0x+oBvIru137QoeIkQs+nQCFBgeu4bDOHDJWT0GjP2
         NwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUxvG1XG6bOZdb2vYKQcTDKK4B2zTq/9lRnOgI0kuro=;
        b=4fTl7JL63uCVuYUyNQOGQugJMDk4D79EuMTc44cQLcN84SwsilG4bIex1NbcM+fEm3
         pFUlm2txPSyVnR4/barV84fm0rIULd6JT26v0rDvBz8WRBkpQzkcBN05HNmwY/cS8izn
         NXCV6AvivE+GMEVQee1WXNhsuepUzuOh7x1Q/sN4oEM9eBOGEuMLR8Ypc/BVSgxJ0WLU
         NOXMlitY1MLh+KxhQ1EzZBQ25+DCi6+z8iHlgPjJqTJGDdDDNl4CG0SRcYHV31SDxxqC
         C0ROrOPdRhXULXTVgTPAj0NQyMKjh/Ao8fXiotT47zR326cIQ4Nno0nJviMRdF/G8JSX
         rLhg==
X-Gm-Message-State: AO0yUKWhmo2nbIgRSUU4wbngxHLd0tlxFp8d3SuoTlwOWNViBnx7yL/r
        mBn5WyEoQHwRnEvfQzRHSmRwig==
X-Google-Smtp-Source: AK7set8PG3CgJDVTtyOMQ2Hcj3pVUAvU3+qxMsC1I6XUdc2RpmwQZtCO2jyHZbw+gZEpuPNqFUGVjw==
X-Received: by 2002:a17:902:e545:b0:198:ec2c:d4e6 with SMTP id n5-20020a170902e54500b00198ec2cd4e6mr20124361plf.38.1677258122140;
        Fri, 24 Feb 2023 09:02:02 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:02:01 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v14 05/19] riscv: Disable Vector Instructions for kernel itself
Date:   Fri, 24 Feb 2023 17:01:04 +0000
Message-Id: <20230224170118.16766-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

Disable vector instructions execution for kernel mode at its entrances.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
[vineetg: split off vecreg file clearing]
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/entry.S |  6 +++---
 arch/riscv/kernel/head.S  | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 99d38fdf8b18..e38676d9a0d6 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -77,10 +77,10 @@ _save_context:
 	 * Disable user-mode memory access as it should only be set in the
 	 * actual user copy routines.
 	 *
-	 * Disable the FPU to detect illegal usage of floating point in kernel
-	 * space.
+	 * Disable the FPU/Vector to detect illegal usage of floating point
+	 * or vector in kernel space.
 	 */
-	li t0, SR_SUM | SR_FS
+	li t0, SR_SUM | SR_FS_VS
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 3fd6a4bd9c3e..e16bb2185d55 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -140,10 +140,10 @@ secondary_start_sbi:
 	.option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS_VS
 	csrc CSR_STATUS, t0
 
 	/* Set trap vector to spin forever to help debug */
@@ -234,10 +234,10 @@ pmp_done:
 .option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS_VS
 	csrc CSR_STATUS, t0
 
 #ifdef CONFIG_RISCV_BOOT_SPINWAIT
-- 
2.17.1


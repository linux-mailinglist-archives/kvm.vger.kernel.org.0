Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5049A7085E1
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjERQVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjERQVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:21:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D46A130
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d18d772bdso1023765b3a.3
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426844; x=1687018844;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FRXZE7cUr4vJpRYfnGIy+KdEpJQsKyQubDyjJds5WmA=;
        b=K0sq07ep0xgW47SiAQZ3mrkYd3ihUXW1o5X2dmqk+KHaUmfcKz7iDdZbdlGDrN2YTp
         5DeGUsMaYYBoNo7OPUrnB1o1Aduw2SsRWM4a4jUKNvE7hnIYIdFSEZfMIqChaZplAtkn
         VaGio+9asUumTMS4/QJbogfBlyh/ynUvshblsUweW1qZ1wrYI97TOIuwXgaQlBlO97Mt
         ZdnsUeMXWkIpdDHxMNdj1cUTf4lmv6Tgd8b0dMHDDbJe7XKCfQb5bLiyeQuJ8lfutKH6
         uVJWnniozsnYEgHJhkcF8L0OIw9sYYEN63jl+nKGMnkPaVbrz/a/jQbWk+w8RRlPxY7D
         jZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426844; x=1687018844;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRXZE7cUr4vJpRYfnGIy+KdEpJQsKyQubDyjJds5WmA=;
        b=AUz88+7GOaOeJfCM1/IB/JLKW7N6qPYcMbvfVTQQBS8I3kzbYS7YXBOk3ZtlvzEM42
         AHAlhhACP4RGF8BsEN5GaRQ+E0BR4z+yP/bkV2N45qgektRaprAiPy/OiiXmWt5MkdIN
         mGAxnFbtaGp7ac3D24UXm7F1ZT2BCjLKCmfWmeRd+QCZZaxcBRfrk0SnzwTtHE/ZlufZ
         tzly4WX/q0ij4y8DuLlPlmi/1cBk43+Xs912Y0k2ndsChJNyZLzo4mQITNXNxhj+yKFM
         SdVdEp4IiyRLoe9gdrmBjHR7OAdGUcYzSSe0G5UNhAE+Fjz+OApKLYg4OpWpSp95PgwZ
         BHBg==
X-Gm-Message-State: AC+VfDwXE42+2NGHP/8f1ZrsZCxapCjIyHMixm4f8g9qRwLUxnGiAFFD
        eHD+1okqLYAGn48v12qtT9c1/w==
X-Google-Smtp-Source: ACHHUZ5FXgh1BaQAiszAq3zIK5JJX/Mc9ezgyx9aawTK/ZyCwI2FrNTtaURsYq3P2rJD9AlJKANUsw==
X-Received: by 2002:a05:6a20:4321:b0:104:3c82:38c0 with SMTP id h33-20020a056a20432100b001043c8238c0mr206284pzk.41.1684426844233;
        Thu, 18 May 2023 09:20:44 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:43 -0700 (PDT)
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
        Jisheng Zhang <jszhang@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH -next v20 06/26] riscv: Disable Vector Instructions for kernel itself
Date:   Thu, 18 May 2023 16:19:29 +0000
Message-Id: <20230518161949.11203-7-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

Disable vector instructions execution for kernel mode at its entrances.
This helps find illegal uses of vector in the kernel space, which is
similar to the fpu.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
Changelog V19:
 - Add description in commit msg (Heiko's suggestion on v17)
---
 arch/riscv/kernel/entry.S |  6 +++---
 arch/riscv/kernel/head.S  | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 3fbb100bc9e4..e9ae284a55c1 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -48,10 +48,10 @@ _save_context:
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


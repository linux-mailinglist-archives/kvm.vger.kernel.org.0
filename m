Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A936D6BE84D
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCQLha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCQLhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFCCE1912
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d13so4811746pjh.0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053006;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q2CeCkoiCmH3/ws0KZkp+HQfm92M4kXVwNFV93ZjvNY=;
        b=B4MOa9IepBe7fu/GGyQMpi02t840NVUsF1YMHv1IHWQgDBAY8KAE0VLig75obbBRAN
         D97f7SkMS7O887HHAA9b4Roq1/r79WMLcP9T7gh7HJZsnpRtJRvsQk9UvRXcGc58yKao
         tF0KteeSLzOAngaNz/1+UR0VzpVA/A8qbNC1/NU+NDPz3eShXQ9A2lI3Aiw4Sb5pt33V
         4aGUeGm80Mb6VR5j1+lkO0MFTB/+N3/T6sRpl80mzcb4Y3B+vLbgm1LzEj3952Ge7FmN
         nIluRiTK6Qe2SZevotJVVFwSUQzOvvqA6UfL68RDPdyX8al/OlTgBP7fPPyIHMhvWUWi
         JXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053006;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q2CeCkoiCmH3/ws0KZkp+HQfm92M4kXVwNFV93ZjvNY=;
        b=DmbIpPVU/rf8pOgfCRfP3zIOofPaVkxco47fwf12LiVL/rRv9APxnWmiX3ysDm4HQy
         L3/4cLIaTUaix5pzbSpHOuK/WJatKIjR7lhQbL3CiBvwqqkWXImVYITuSXo4wuKZ7aBT
         MXVKrYlKct/ZF0W+3mahNGhjzf7MHVlDAqbArUed6mYzm033/lL4u+AAzZ9d/Ouh1Ah3
         n0yqsfNmC8dLekQAiNupTjXxz7S5yX1bgMiPaxbo8Z+7dAmRSKFSBLEaoX0Jujj4GIvz
         cVYAgC48p4NQM3W9cWHYcIr6V2/EuKJn3DT4kEgS/ebiQa30Y3YWxCaRMq2+i2ZQ1ZFA
         khqw==
X-Gm-Message-State: AO0yUKV7v0WuECYiEpqkt3pTLSDPSS6KKLbY+Ac8GhxFj/57xfl9kzfj
        OCEhzSLOVI6/dzrpplamEsNpLQ==
X-Google-Smtp-Source: AK7set/jJt9RpQRdgFNr/nwnCHvluLee730CaOiZ9z5NnZShDPmF2cgAcce7IEv3RBA0ymK3/kp/eQ==
X-Received: by 2002:a17:90b:3a87:b0:23f:ef7:7897 with SMTP id om7-20020a17090b3a8700b0023f0ef77897mr7686906pjb.49.1679053005719;
        Fri, 17 Mar 2023 04:36:45 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:45 -0700 (PDT)
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
        Andrew Bresticker <abrestic@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH -next v15 05/19] riscv: Disable Vector Instructions for kernel itself
Date:   Fri, 17 Mar 2023 11:35:24 +0000
Message-Id: <20230317113538.10878-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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


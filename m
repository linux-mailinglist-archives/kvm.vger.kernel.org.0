Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BD6FC3E7
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbjEIKb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjEIKbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:53 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A93119
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64115eef620so41327764b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628305; x=1686220305;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OMViiC6TRgUBy+1t9x/tkF3qbB8zyqTk5+4zqct9RAc=;
        b=H2H87NzV+z4a95p/WDxeVW9lVOiGG3MSpJcPfFkIIbEFcdgH1iXqaTbeCOJcldkmgZ
         QHzCfmsREI1BjPcHxgpky6/suqYvVCrBU2VKm8ciawCSYnisvkIn4xLZEE6dcskpACU/
         8Z5gKCJoAjDk1pf5n+3cyj2NYeY80YiqmRFiKBumv78pSA5HpqnCi4cuhxXHZvEasMeI
         HvStYT06za8kCu6usOo4fFwHI/HF8U0+oaCx74xK8NeKVqLickCbRYZ24zOkqx9x+zLc
         TLvD5yKb5/qul3mGcfNl//kzaRDsysx/EZ2zWQ8z4TFqxt1K85yWgR5K80C9mdDxED35
         5AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628305; x=1686220305;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMViiC6TRgUBy+1t9x/tkF3qbB8zyqTk5+4zqct9RAc=;
        b=lYZMgaVC01lND2gFyRykMJiFGTuX6PkKtA5wIHAyOfKwKoxAQAWHEkyloNntRP4cal
         6Khjyan6gbxeXjCCO/t/odUF0d/wZRoNCToF3XsNH5xoehW0mCY1GQsvNoiK0oWMzgHC
         87u7LDIW+REnyI0bZcCaCVYtYdpSHY+8xsJiyqtqG8R9j9vyubANwXv0k5c1fzTBqSeL
         SQzWwrMY3kXp3ruSBcvd3fD91rc7aZiKe9XVsw2Ungk20+8h+Mc9bs6TgTON/HMXU/aQ
         IHvi52AMliqjTNXpV82hHsgMinHpytIfpyZaZ+7XG4u8oFbotoWuVcpzRLE5pNew8dkR
         fssQ==
X-Gm-Message-State: AC+VfDwG+qeMBJl91scQrZeYXRuygc6cAXJeYLmu6iFtAopO/lye/LAC
        XLpIIRqKCOjOcuMecVQ+b2TEXQ==
X-Google-Smtp-Source: ACHHUZ77LjVJMMtiEt2KLQzAUBVsb9v7+qxLpSGV6oaLIZ1n//HV6AEtIF0juAPI98sE1sXMla/j7A==
X-Received: by 2002:a17:902:da8b:b0:1ac:7e95:74bf with SMTP id j11-20020a170902da8b00b001ac7e9574bfmr6630959plx.6.1683628304718;
        Tue, 09 May 2023 03:31:44 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:44 -0700 (PDT)
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
        Jisheng Zhang <jszhang@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH -next v19 06/24] riscv: Disable Vector Instructions for kernel itself
Date:   Tue,  9 May 2023 10:30:15 +0000
Message-Id: <20230509103033.11285-7-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
---
Changelog V19:
 - Add description in commit msg (Heiko's suggestion on v17)

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


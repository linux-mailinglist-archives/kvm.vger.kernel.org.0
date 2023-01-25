Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A367B42B
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbjAYOVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbjAYOVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:34 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4159555
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z13so17998109plg.6
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B1Vewq27MsVDR6LunkBJ1YYTsHlWhswm4JoWp73ftL8=;
        b=GPbXzRcSrgSqa0YF13mndutz70nGngxPrYDySfXm5gMEpNnvF18gNQZBJbiT0gohr9
         qYFEv8kXo9FKZAp9BcOVlAZmbWDVKiQxZmFWe2MxYGKfVGon/DUnpQpXVna4FHB2kqdw
         Vx0FCEWf7SaBWZ/gZXebGal5JpWcMCLyVgFNW1iEW4MYkV/oHktDgEWBcNQioTdrw8d4
         PMNiLph4ie0ulAUddetmY/ZsWbpjYs1/FgYtXC4tda0f10PR/s5d9Yz0N5kL7ZWszm8a
         NCt/sm3Yr8apfIOUnfw0aR+SjAIZsrk6I0SIoBAmozyt1qYFOmdTXqQ99q8pjxUuLrhz
         6sAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1Vewq27MsVDR6LunkBJ1YYTsHlWhswm4JoWp73ftL8=;
        b=Ky2dDB68nf/QkFKpsG2Z4YVLSYFFghyCn+rSLQ/NvakTtNd5AxMJjDshx6UI9d+fGn
         zdGUBSHUTIjjH4RsFTIYhE3xoQTHGQfMKCgHM/yGmUR8EhRjaAUvGernAmRgyAhhL1t3
         reTnrNQsJeSjbB7eBsMcOSyxxUDLHmkYWRXAbC2iss+IWXWvDnTXtvMzj4EdSHj/7BKO
         EG5ZzlGoFoR0Mi3DNUR/+B3UemhWLBCHtUrzJCkhQd4UY41Vc/jTNqjSEe7qiJA1wB9R
         rPocuFSu7JRgjSJm9/1ATv0AseHhBjUlvNfr6Z93+rdn5bADiXzZGJ3eZsLYoC5iS9r5
         4tfg==
X-Gm-Message-State: AFqh2kopVUr7Y7ywP56fOW4cB29AjXcyhlFzPlusBP28IUTzZr8waRjT
        mBHL1ZvTfnCv1QDJxK/aiTToMw==
X-Google-Smtp-Source: AMrXdXvU/TE++7j3AkRLf/KOYTXcYiiY22xpSTc/h/DXT5PHgkrbF0bU3ho8hu0dP/cS19JeRjs+Sw==
X-Received: by 2002:a17:90a:a895:b0:229:d400:11c1 with SMTP id h21-20020a17090aa89500b00229d40011c1mr27005675pjq.10.1674656488157;
        Wed, 25 Jan 2023 06:21:28 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:27 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Myrtle Shah <gatecat@ds0.me>
Subject: [PATCH -next v13 05/19] riscv: Disable Vector Instructions for kernel itself
Date:   Wed, 25 Jan 2023 14:20:42 +0000
Message-Id: <20230125142056.18356-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index ea803c96eeff..7cc975ce619d 100644
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


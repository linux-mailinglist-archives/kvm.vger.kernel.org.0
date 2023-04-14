Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492FA6E27CE
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjDNP71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjDNP7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619CCB453
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:22 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i8so9741409plt.10
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487962; x=1684079962;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PRENwq6Q5h6bJkuLEU9y2ZlvRnSbbBagGQhAGvyqbY8=;
        b=eV93yDj+Cvno/AR2Kqbp7T2X+jNoQ0r1Gm5oWicJqdZQBTQoW8zQMKqcIu2ZK8qm57
         YoSs3FvjzFcpICELt84PzxQLl7L6iEzZDv2cSCM1UpETOR3hDXewrSMOXeN/pvUS7+vt
         az6AEvDKtT2we5KD8H70GqYRlIflTmBjlxHUXJzxoAtBAGccGgMeu3RHIPxnJ2mhY2gh
         sJEyNWIXhgUDw6a5s9dhisff3Oly8G524Sc9mjCiJo/+5D1d0oE1rb4ks4yexgrIPG/h
         yRf8TxjynIs9s7HbwQiOJKJTCT6LCUkJ160ZyoZhNugeH1DsgnQtMaoRp2StX6kS/Xxc
         07bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487962; x=1684079962;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PRENwq6Q5h6bJkuLEU9y2ZlvRnSbbBagGQhAGvyqbY8=;
        b=Ecx7uIgXFiCo4fWfKHqd5A4Iq4DspNrXZ8w2xJQfDVg5P1lAbQmmtPXPnO6nfJPNly
         ZqP41he4xCuwmPWyZU0WRgb8PHY4CJKRtWveS0HVyN8Fpis2hcit2CzrG4W6mCKXzE49
         7aaEb7rdqkRS2J2AAyFl8P2I+w7a2jMYSAA85yGB9QiEjWU3p4pRXnQUYG49HTVCrLEm
         wGAAbZy85OzHie5icRGrt0r7Lmzvk1+FV+NIzFChikKEc1n3LY/z/GdjYmmKVtCaadcp
         f6fwAVW0qy/wNZQhJK1RfDWpWiPiNkActbKHrCxoepReIHXfC5bJHIXlpBn0zg0dPn0A
         GujA==
X-Gm-Message-State: AAQBX9fwYnIjTugBWh51jnOjvIO49GMyoJCrMIv2HUkbrsCMtfJ4u8YX
        IVFAKviIBujZsoJbG9zAItrOww==
X-Google-Smtp-Source: AKy350YHJaKAhtMi3NPY+rjWgsiPejyppDLmmbC6OaSfsoWJPScFQLerfIgZudmYoZqZM1BdigvDvA==
X-Received: by 2002:a17:90b:1e0a:b0:246:ac68:d4e9 with SMTP id pg10-20020a17090b1e0a00b00246ac68d4e9mr6316947pjb.6.1681487961697;
        Fri, 14 Apr 2023 08:59:21 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:59:21 -0700 (PDT)
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
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v18 05/20] riscv: Disable Vector Instructions for kernel itself
Date:   Fri, 14 Apr 2023 15:58:28 +0000
Message-Id: <20230414155843.12963-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
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


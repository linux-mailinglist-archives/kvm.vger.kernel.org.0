Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170CF722B66
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbjFEPkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjFEPkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:40:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF8118E
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:40:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b01dac1a82so24970465ad.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979607; x=1688571607;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=peA7uNBICYxq78TCCLilok9fr+B5gTYL7MG+xHpLNFU=;
        b=RFh4xAkvYh3f6QR+0XxnxTmnNZRh6PgSSh0DDSPDE2PjLKjQokrhAYmYM5dILHmT2u
         tdSPgkHZiI8CmClOVVxAULvfDeIbjr8jgO3uD4jLNGrSufutHHAziJXxKCQW8OGX7KgC
         svpNkOdKQImWBoYlOc3uNdgyZ/4OLsAEbwZrctVF05JaMmLTw2JLLE07biXaKWdXU9gG
         An2uwwe+AI9eY2IGufvCqOqVCE/LGcBcImLt0r98qPSBE0hxN3jF0/aOitmiaV+pSGuw
         RaoxlggCBAIczXH9A0UCHRR9xRBTQ480h6WZt9E5JZHTfdbHdYiLfUQLShQlwcIHlgYU
         lemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979607; x=1688571607;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=peA7uNBICYxq78TCCLilok9fr+B5gTYL7MG+xHpLNFU=;
        b=aS6+zcZ2WA/lfhRSz94nw+muzlLwJ3x5DzDcatKA2UWky+p5sJ3UINTrbIu6D2fT6v
         Qa/i0Th2Svsvsn8rJwfyo2XX3NPJkDQWArQA789joZUidhmA58E86fehIj4hP2u4eXNW
         Tv5hLDzs+ITiIIykNbkrP6zRC0o3ukB9mhiMs0URFJ/2pph9ND6Y9EjR7U6issW4kzGW
         H0SnZoeAyh6eZZzMwURFKoyH8dGqw+3xV7+Ib7ESoBz2N8OTEWWNyA3mmBPBnwzxnu3b
         97vZMUXIdLXI7qU/ueVeH0TGR6cmw1vSVnqQjlhYd7erOIMbPucILl0HxpFUJhlD2e2U
         784Q==
X-Gm-Message-State: AC+VfDxOI8l1i5LUiBjbQkrd9y0FDx6Auxg64UfXGRTW8UrJz/+e0bNz
        sOFC8+eGv5N6sAIJ4C56TwChMg==
X-Google-Smtp-Source: ACHHUZ7gYODQ3SKlK35nN9OhEisobMlQaL3fKtJqvAH701pPC6rDPo6Jb5H+GX2b1PvrbT1TdvrUXQ==
X-Received: by 2002:a17:902:fe01:b0:1b0:307c:e6fe with SMTP id g1-20020a170902fe0100b001b0307ce6femr3421831plj.10.1685979607093;
        Mon, 05 Jun 2023 08:40:07 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:40:06 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v21 05/27] riscv: Clear vector regfile on bootup
Date:   Mon,  5 Jun 2023 11:07:02 +0000
Message-Id: <20230605110724.21391-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/kernel/head.S | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4bf6c449d78b..3fd6a4bd9c3e 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -392,7 +392,7 @@ ENTRY(reset_regs)
 #ifdef CONFIG_FPU
 	csrr	t0, CSR_MISA
 	andi	t0, t0, (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D)
-	beqz	t0, .Lreset_regs_done
+	beqz	t0, .Lreset_regs_done_fpu
 
 	li	t1, SR_FS
 	csrs	CSR_STATUS, t1
@@ -430,8 +430,31 @@ ENTRY(reset_regs)
 	fmv.s.x	f31, zero
 	csrw	fcsr, 0
 	/* note that the caller must clear SR_FS */
+.Lreset_regs_done_fpu:
 #endif /* CONFIG_FPU */
-.Lreset_regs_done:
+
+#ifdef CONFIG_RISCV_ISA_V
+	csrr	t0, CSR_MISA
+	li	t1, COMPAT_HWCAP_ISA_V
+	and	t0, t0, t1
+	beqz	t0, .Lreset_regs_done_vector
+
+	/*
+	 * Clear vector registers and reset vcsr
+	 * VLMAX has a defined value, VLEN is a constant,
+	 * and this form of vsetvli is defined to set vl to VLMAX.
+	 */
+	li	t1, SR_VS
+	csrs	CSR_STATUS, t1
+	csrs	CSR_VCSR, x0
+	vsetvli t1, x0, e8, m8, ta, ma
+	vmv.v.i v0, 0
+	vmv.v.i v8, 0
+	vmv.v.i v16, 0
+	vmv.v.i v24, 0
+	/* note that the caller must clear SR_VS */
+.Lreset_regs_done_vector:
+#endif /* CONFIG_RISCV_ISA_V */
 	ret
 END(reset_regs)
 #endif /* CONFIG_RISCV_M_MODE */
-- 
2.17.1


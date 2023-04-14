Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37E6E27CD
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjDNP7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjDNP7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E06901B
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o2so18708040plg.4
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487955; x=1684079955;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PG+A+9/fIV/ExGi75FEqrU6haa3ykbx364k88CAqjOs=;
        b=lW6sKwqv250H+JhncZB1/5up+cPCDVhfDdFEnJx82B2J7+X3EDGqkRH3OeGbo9A7RU
         wqdPLC9tYRNdwC1VKGmSIS3MalDjZlcBriuY4Kg40NAk8RJMXu5xSwRiZOmJs9Bi7l+9
         45XFQVjCJbhtscU+nXnkABmI/QqOmhh7l9a4PZaLEVEuJEqxtiWIm8Ecq/YidukMx0Lh
         bvg4ZjnNfxrCte/kK2kFJMQqQD68BqsH2OSL6XpIx+vJdO2Fuo+xk4tzAUVfAs/A7UHA
         chfX++Clu4JUyzynqNI4J2TZWafxbAS0FtnwcVPYZa9EDFjgLKrwjTIfhTBb2XfNp+bw
         zcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487955; x=1684079955;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PG+A+9/fIV/ExGi75FEqrU6haa3ykbx364k88CAqjOs=;
        b=AL7uuZ8FWMSrVw4a+5TlllEdG82O94hOziQXVMlfjpjG42Y/IvI1a2d9mHijALJF6y
         wXNvuBuztwnZ4gYcyM0SedcO1ULNDDfzVlWkOyUlDusJR6aHP7zqc0YuM+jFELdbXqb6
         usZ548SGbnKot1eteaeIjqrzD64WYTwlTsSmfztRiMfI1X57j53l91COjvNZky0PiElH
         r4s87RxhN7454x6l9Rh5wiLaNbiAiY4rDEt1NE2mf5GuSTEs3PvZevSfI6t52SCLnGJP
         GYZf9xXlsxGEZhLvWrb0ene9PjSaZ8r/wRaxfsWEJgFXW2e1HknuqoQfxB9LMNTDXYWs
         gdKQ==
X-Gm-Message-State: AAQBX9cruSy4AobZN2/CIS3S8X1xpGFUvhukCgjDnViD113Sj4opvjRf
        K/Wv5dz7H1sAk9TvYrvgzIHtpQ==
X-Google-Smtp-Source: AKy350aE0CypeJZKaZSx8L/smNEoI0EeS58SnlbMlAl+92nAEaS9HyCM6GRm4Kom+iZm45DgD9y9eA==
X-Received: by 2002:a17:90b:3649:b0:247:4adc:ef4b with SMTP id nh9-20020a17090b364900b002474adcef4bmr1277319pjb.47.1681487955712;
        Fri, 14 Apr 2023 08:59:15 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:59:15 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH -next v18 04/20] riscv: Clear vector regfile on bootup
Date:   Fri, 14 Apr 2023 15:58:27 +0000
Message-Id: <20230414155843.12963-5-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
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


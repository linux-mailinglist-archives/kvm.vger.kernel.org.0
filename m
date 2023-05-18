Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C890D7085E0
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjERQUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjERQUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:20:51 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAC1171C
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso637708b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426838; x=1687018838;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=peA7uNBICYxq78TCCLilok9fr+B5gTYL7MG+xHpLNFU=;
        b=e/Cx4vjZipW38IBRBhUU8aPV0WQ9CDgtfZvd9+SXlt/oc76sjLdLw5K70UY3tOULvQ
         Uo75q6vV/vSwRTYT52hqBU4Qo0xGiFYv/bSmD02LXYS5IUu+ULXNazVfHjLoBc9p4Liq
         fmcbqts6++pNaHxtj++N4bKR61wnEPDpjKXniaxs0OZqL0JWm9isHY7z3n6rwKC9vbFk
         iU/dZG5sehiRUg9heZN+R/XkqC0f10nDGhyqVSgy23w0V5bOs9MdYSsM+pSqvvWef+5R
         2j/s3iCLJRzL0Njc1G8wnZoViBzLBV0/EoxVNNNJ1l8IV0YN/C9XFGV2dwmkynCe3Iw8
         L53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426838; x=1687018838;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=peA7uNBICYxq78TCCLilok9fr+B5gTYL7MG+xHpLNFU=;
        b=f2ptcwmi5YdxlMS1JpjCxJHtKqzuxTFjhIqgNiovbtHQvzRToZfdutdjI8BNBiQkcd
         S3Z7fs+62Lfy/iXVD47WmzJ2k7+oN3yW0CbAl1XNDLJxGGEf2KGj4fHR6jsmqtdkpH7G
         nT9KR6bUdYyxmRnEP6Gg26qZc9ljjoTqC4CCM4mHrzX++ljtltUqkqxKWajls9RaIsGO
         q+klcgeLmVsu5PxtRhRRchIbXTmZaKbExAh6xOxJlT2vl0elo0OOI9zvrfgU3VqXmhYp
         PA4ACuZK0/XHakKCavr+piob/iujxgCSqrJtfS5AZApuVfFpNuVzAZPzgbWH/d4tY+nE
         4Q7g==
X-Gm-Message-State: AC+VfDwtYuW2vPRKxDAUQMP93S5xqqOr9W0mTNKPfK+vXraw0WxDGpCX
        thvenb0sKSrCE6RBKupTAwFGcA==
X-Google-Smtp-Source: ACHHUZ6GXeuq6ac3dk1QjIBXlTMLesMB0FjJ96RzZemGCdDJ9H4Rc4dGccTHPTd/M9zRn4/iLuk+DQ==
X-Received: by 2002:a05:6a00:1908:b0:646:59e4:9514 with SMTP id y8-20020a056a00190800b0064659e49514mr5466238pfi.7.1684426838150;
        Thu, 18 May 2023 09:20:38 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:37 -0700 (PDT)
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
        Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH -next v20 05/26] riscv: Clear vector regfile on bootup
Date:   Thu, 18 May 2023 16:19:28 +0000
Message-Id: <20230518161949.11203-6-andy.chiu@sifive.com>
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


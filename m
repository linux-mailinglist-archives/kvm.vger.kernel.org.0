Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537DA6BE846
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCQLh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCQLhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61E4C643D
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u5so4982008plq.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679052995;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PnQ1gM/aEBoZbxhfb57ZLXc6ZOM+cLTwn6NQvrPI9A8=;
        b=Oy0CBErd4SmI31PHtxi9+waaP9FQhw9+CaIYpNH94FK34PKLdxB0iZ5u/kDsG4lJ1Y
         kFh0irvGf9AMbckUc+h6vhTx4SbzYd98yLwxix7KAIRdLbYzOWedOPW4UwJPqbiiMDA1
         qz1C+k9lKc+QRbQLROmph7RPt223+eAQvf9OwUJJj7qCVUZvZ/6e0+udzz5yfVT5iiss
         TuObLDNLvDu/B1jeMjJ1A82DRESJAPZkfazwNsFGMh0VYOAv4o+y3/rnlPAg2V+xPWJU
         HzZ2jVyMIPgWrmXeZtd0lpWd+oIk0+MKQb1t45oMY2AeOhRmjawRDj0P3w9njxqe7hYI
         MReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052995;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnQ1gM/aEBoZbxhfb57ZLXc6ZOM+cLTwn6NQvrPI9A8=;
        b=zuk2su2xho0ZMx1muRfjMEiU4riEf9D87aDDi/9ROqValUB54vsohhn/ypW1e/wMPf
         oAQEf6sr8W9Qbl2WH79mlGbHQoGphe+46fTfGwI2h6XWOud1ripaHBEAlYS+oOrzvQGB
         vLitqildyqXG36TtZimOicuBcS/H7spKa5gJjq5PvVFL5QJeRKYtSe+xfi2c2tchF2pT
         CyOey2VsEgTbuqSoKmOYkXoKnVHIeAz0YXNYqWGQ2Rw9Cec28TFhZa4uCQA/alFeYX7w
         fJXyhPbhm4Gq7WCrI247qaTnAeg8r2W5l/9d3f+y/cx8J3e3jpfnlgsNWswn8zrFFOBC
         n+UQ==
X-Gm-Message-State: AO0yUKW8kjSasSjcew6g3eSUuMtTBm9F7jyWcRf46BWBAH5cFFxWKDEH
        f1oY5NOv8YOVlUnW5UjADRt/tg==
X-Google-Smtp-Source: AK7set+IzWeKlVX+ExN48ut2Ryq1FxwrvcKWiE3E4NBI1pqmruGfj1KSQA1Uv7cOUsDMh86Sv32tkQ==
X-Received: by 2002:a17:90b:2242:b0:23d:4242:a7a5 with SMTP id hk2-20020a17090b224200b0023d4242a7a5mr7716456pjb.47.1679052995600;
        Fri, 17 Mar 2023 04:36:35 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:35 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH -next v15 03/19] riscv: Add new csr defines related to vector extension
Date:   Fri, 17 Mar 2023 11:35:22 +0000
Message-Id: <20230317113538.10878-4-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

Follow the riscv vector spec to add new csr numbers.

Acked-by: Guo Ren <guoren@kernel.org>
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 0e571f6483d9..c3b87a7d1241 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -24,16 +24,24 @@
 #define SR_FS_CLEAN	_AC(0x00004000, UL)
 #define SR_FS_DIRTY	_AC(0x00006000, UL)
 
+#define SR_VS		_AC(0x00000600, UL) /* Vector Status */
+#define SR_VS_OFF	_AC(0x00000000, UL)
+#define SR_VS_INITIAL	_AC(0x00000200, UL)
+#define SR_VS_CLEAN	_AC(0x00000400, UL)
+#define SR_VS_DIRTY	_AC(0x00000600, UL)
+
 #define SR_XS		_AC(0x00018000, UL) /* Extension Status */
 #define SR_XS_OFF	_AC(0x00000000, UL)
 #define SR_XS_INITIAL	_AC(0x00008000, UL)
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
 
+#define SR_FS_VS	(SR_FS | SR_VS) /* Vector and Floating-Point Unit */
+
 #ifndef CONFIG_64BIT
-#define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
+#define SR_SD		_AC(0x80000000, UL) /* FS/VS/XS dirty */
 #else
-#define SR_SD		_AC(0x8000000000000000, UL) /* FS/XS dirty */
+#define SR_SD		_AC(0x8000000000000000, UL) /* FS/VS/XS dirty */
 #endif
 
 #ifdef CONFIG_64BIT
@@ -297,6 +305,12 @@
 #define CSR_MIMPID		0xf13
 #define CSR_MHARTID		0xf14
 
+#define CSR_VSTART		0x8
+#define CSR_VCSR		0xf
+#define CSR_VL			0xc20
+#define CSR_VTYPE		0xc21
+#define CSR_VLENB		0xc22
+
 #ifdef CONFIG_RISCV_M_MODE
 # define CSR_STATUS	CSR_MSTATUS
 # define CSR_IE		CSR_MIE
-- 
2.17.1


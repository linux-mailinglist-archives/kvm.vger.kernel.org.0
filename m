Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8532F6FC3E5
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbjEIKbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjEIKbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0253BDC7E
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaf706768cso43296805ad.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628294; x=1686220294;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=h5dBiJ8UgfnD5JORoVfPqn6nTI4sms8Kr2jL1vgMN3Q9h3oPFPPmL2ab9qZATEL1Si
         0Ay/aPr9YKsXB9WRz0LeqDqQbfCc6Q8ToZENURfwIMqercpcHeJ6aq4QVIVjEc89B3ns
         9aHcEYW3QGl4sHJrf3XZlSIkRq8mB6/AiYldXdL4Bd1fatPmM8M3y/GoqFhGPhgpWNOb
         j5d42CFUr2e0AenKtIz0rdXpA9uGJ/8U9xgbGSzZdNcQWuyaQDZGBx6Xw3i4+dF9bE7T
         Qy1+pcDmMIQ4lIdLrOFCA/xZOvLvpCPvTl1b8Ijv/hU+kbmAgi23RJbkL49I+TlYGWE8
         3AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628294; x=1686220294;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=lPgXNtmnZXbytGP3PKStdkFIJ0PUUOEejf9jeyW7YBIrt7IIvQgurDQwMuts2fQG2N
         8nYvuKeB52pjeSuol8ThN7Vq1HYL5cOlW1LQj2ZXH8FY5ZrzOM4pdmDqHwXODpuOi3+A
         VOX0EYR0yLiqDnEZXX6jIbGPUP3CyDbJBWW7RZieM99o92F0vw2GiuKCDqVmKvDsbt/Z
         DYwvwbmHt9IUgtNUh9obVTiLRH3PEv5POvtwM+PX3oSIdjuvS7NjnuZMNauGP6CdOblC
         ZZl/mYENd9h73h/YLug75eh4gc/kKQOkmGcYUr5wXCDJlwmhVBh12sXu1A0Gt8glSYTx
         lYcQ==
X-Gm-Message-State: AC+VfDxKoDhmwvEuGOzs6Xyd2NpUNGa+JB15EwDW1Nqg9Ic9oNCJdvZ+
        vaq8Gy/Zh7EcHl5T0kOvPqDg8Q==
X-Google-Smtp-Source: ACHHUZ4qMeeZ2GYD3WyxVZJAhNSVOzTJFNxDda0VTV7c0dzyVvQQU0d7TOmaiGsDSfh2vGTJ6Aga6Q==
X-Received: by 2002:a17:902:ce8d:b0:1ac:2c8b:a0da with SMTP id f13-20020a170902ce8d00b001ac2c8ba0damr16876004plg.51.1683628294269;
        Tue, 09 May 2023 03:31:34 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:33 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v19 04/24] riscv: Add new csr defines related to vector extension
Date:   Tue,  9 May 2023 10:30:13 +0000
Message-Id: <20230509103033.11285-5-andy.chiu@sifive.com>
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
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index b6acb7ed115f..b98b3b6c9da2 100644
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
@@ -375,6 +383,12 @@
 #define CSR_MVIPH		0x319
 #define CSR_MIPH		0x354
 
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


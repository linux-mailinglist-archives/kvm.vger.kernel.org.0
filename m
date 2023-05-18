Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552047085DF
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjERQUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjERQUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:20:40 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9B5171F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:34 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d247a023aso477500b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426834; x=1687018834;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=j/lNhEwTb7JEJPIuoeqzcOoNlaE9EqVE/MZI6+2DWzQNO6XCErcOE2TDOSR7eIsYwX
         nuo+9r/OqRnGOX5t07Sxq0Q8Vzs4aWyTIxF+ZXQYje5CTeltNr00p47KJsH1aSEVqs2U
         brOJOywB1UfvF7mHrkMp+tc5M1tR5tMy/k0eV1Td+kCt7ThlX/IFBLXM8A1YMn2ZovuO
         dWuUezKtPO4fvLtFmXbmPhIW2DheeIb2VUF4qT0ApoFG36ruAHlBM4fQBy12OVhR+o5w
         E4pw3Sr507bSIqgvvz/+/0ft9ai4MCLwdiyFsKlcD6a1nD0wITeZxQDUSUzetmMfeTVo
         QaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426834; x=1687018834;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=e2SV9JfbWs+qzzYIlFFcUgkUG+oKytJJcQwrR02tCHST8G/1QCuHzJ1SAMMsZUWbmI
         t0mPKosYcw8ODo/U5o8LP5yqINS304IHYifZDPmRODfJm7cHGT1u0z4rrl+4seFal1Iu
         Kev1Ma0Az2d6jP7NfcukbRXERmqENzgfMw/9b35ZQIZ0qWX169iL0DdgfVUNzfgBeOtD
         mTIiPLJRq0JOcxqS+90rwCbs3Niq2LovPHgk8IMDqjsNValr6BSRj8Av7i1OPfjw7nls
         cCrTlXZw5JgkCOOBjYCKJAvEYnZ/i+2KZJ03ZQaKYrLcnSEcVxlOellZ0BIwdoCoHEEu
         QjhA==
X-Gm-Message-State: AC+VfDzv4WOyAus6jtafNtYtJ+FMV5Q4rwHx+y+C/gh89EV8bP2Ort10
        nQHKuGwOcrJ8c2u1wwgXxcCkzA==
X-Google-Smtp-Source: ACHHUZ5PIN2Byi+riolmbgeoMB+vCD0zudt7ZJVUoMZ3UWR2Wl5reYAaZjZzQ8xTchHoGIInJ8gAzA==
X-Received: by 2002:a05:6a21:3701:b0:100:cb5f:5b91 with SMTP id yl1-20020a056a21370100b00100cb5f5b91mr196914pzb.25.1684426833823;
        Thu, 18 May 2023 09:20:33 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:33 -0700 (PDT)
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
        Guo Ren <guoren@kernel.org>, Atish Patra <atishp@rivosinc.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH -next v20 04/26] riscv: Add new csr defines related to vector extension
Date:   Thu, 18 May 2023 16:19:27 +0000
Message-Id: <20230518161949.11203-5-andy.chiu@sifive.com>
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


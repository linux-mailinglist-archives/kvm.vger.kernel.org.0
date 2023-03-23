Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427636C6BB3
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCWO7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCWO7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:59:53 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C051D93C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id kq3so10154979plb.13
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583591;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PnQ1gM/aEBoZbxhfb57ZLXc6ZOM+cLTwn6NQvrPI9A8=;
        b=in9L72Bq1wyyyCu5Us/d2fWoyH5i9lIDbJZuj0vsYeySOsINiL7P0D/RCfG5TfBXmj
         S1OLjKNr+cT37kDSBYmYW4HtRGIr123Fm6izH4Cl6/LbPiuvZIDdoHAkhscgqRy6SIv4
         FmEb3HsM5N2OVUfSrnPgRTsG3eE/JmLmgHehgDKxIT81xZc3eHOTLcYXzhCs8LLT833U
         /YxuN07sT+10IrOGVr8Vchp9kmYDgXNIfTOeXmIfqoSdpSJUOky270eCw8KvkcN9Wf9Y
         1kz8IDzvOmksd7cwqYAEzXcPwuld+70QohDxInOBcVHCv0LI5hxHaBw2SJnaOSeGTo0a
         jQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583591;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnQ1gM/aEBoZbxhfb57ZLXc6ZOM+cLTwn6NQvrPI9A8=;
        b=NBHs0kpqHQpQPX3L6pKyRcv+39CXCvb4Bp8oQdNNzV3MJKt9s4FHyaUAQvzVeecUZ1
         fVBe8yl46AALDWLdlA/8v3aoTS6q7TIdwf7NleBLnvj3oSha5+GFfxqx6dqA4IT3rq/L
         CW7VAyCCWKVGz51SfbvCWL44AQ9IWpeDSXpXOsnSYwbtwljXtdo+vUqq1qqnW58Cs1zW
         op64GAWQ2U/gUr0itY1GiWvVf50j+MVQrO1wxPmUaYtRr91dV6Z9QG0OZiiiFYBqFupa
         zBG5Okmr6gY0LRlGF8juS6EewmvkSSXUBVYtmzOytH0EBY0HzwhcuG1rgfhWPNuoR4mT
         qhnA==
X-Gm-Message-State: AO0yUKV9M8XPgbMFYiP/xxT9nxJ0g0MBjozpb8gfneOVsB6sYWw9RHSz
        gK7QXDuetZR17e7XoAOfJyxiNrCBAYYqze210lE=
X-Google-Smtp-Source: AK7set/F8IoD8xsNa6gXIltPvxqTiGdqc94EgYvU4CAtCYhWyJCGJeZQfhZAwa4DW9aCaz6SjLNrCQ==
X-Received: by 2002:a17:902:d1d1:b0:1a0:48c6:3b43 with SMTP id g17-20020a170902d1d100b001a048c63b43mr5334195plb.37.1679583591224;
        Thu, 23 Mar 2023 07:59:51 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.07.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 07:59:50 -0700 (PDT)
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
Subject: [PATCH -next v16 03/20] riscv: Add new csr defines related to vector extension
Date:   Thu, 23 Mar 2023 14:59:07 +0000
Message-Id: <20230323145924.4194-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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


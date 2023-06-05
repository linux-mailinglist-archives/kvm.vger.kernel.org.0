Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2047A722B64
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbjFEPkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbjFEPkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:40:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F3E10A
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:40:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b0236ee816so35850765ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979602; x=1688571602;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=hLdQHV3mhu7NrU7gLSA+e3puQfnjTRlWFg2kePX+RJDYCD5Px3f1yC+TretEeMOzG/
         fhkMPKSl5gybiIwJpnXwM8y3zWz7VFwZuDNsgaOxpNHniTlB7qJt6O7T5cfZhANKOBWJ
         iyX829rvWPljpKWsazgogJqwIuq/gyS+ShhCbN0NFRaDfS2EAUSOtLXX+pT5GHIKYJqL
         8TQg37t6ZBGfO6N639D+ixjv/4keIoxVNMitaVNIHVTDYuap4A2IidHFeNHdwfQgk8qQ
         3/K7QMtF/Xtq/ouXJkBY7GyyZw88mqinRofO0i24tkRdD/8xFFONMXThaFS4Skezd+Cq
         UxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979603; x=1688571603;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1t0mcJTBhtsZBYqWTjUk/5U+5ffoYMHXYjoCjqrD1Y=;
        b=HSCHdq4haL2BuG3WaogusJEYaf9e+RrOsjoNQjno8HNstA/8PiTzjZBkhs2h4iFSRV
         lHXqt1qDntglAmLGY1ivTgZLTHQBLJiUrAV2ZhbMyjhDF6RRAUHi6e/hODAEhS//r5tB
         qNSDO7q8agzBaSsf9Hmryf/3qB7FYbYLIbH07CDSNflItOkKMwmNeJVK2zwsiPpUDz8A
         NZAmJtCHPZIdUN94JfXlTcCiGSZsODJXcwWVjv8qp0byY1QJfrrZMKpOYowa96y5gOk7
         RsHT9gmN7IZfpF5iw2zW884oVnzkuPjl0thdOcDzSZktlObMWuUyHQYFAHZWeMVjrmsj
         dDCQ==
X-Gm-Message-State: AC+VfDzPnkPSDDqGExCMc2T3Kpsbg5xveyxmFxrW4wKBuiRw4NuhLoRd
        58+ufyMI/HgVpNtHuQKg1EmEjw==
X-Google-Smtp-Source: ACHHUZ4biNRG8kD3a9Fs8sx7VC+IQ8g8hB5i4oIU0XWsT6nRq3hDin/sLuRVSx2ZBcuwL9/OkWm9jA==
X-Received: by 2002:a17:903:189:b0:1b1:76c2:2966 with SMTP id z9-20020a170903018900b001b176c22966mr8471125plg.20.1685979602723;
        Mon, 05 Jun 2023 08:40:02 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:40:02 -0700 (PDT)
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
Subject: [PATCH -next v21 04/27] riscv: Add new csr defines related to vector extension
Date:   Mon,  5 Jun 2023 11:07:01 +0000
Message-Id: <20230605110724.21391-5-andy.chiu@sifive.com>
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


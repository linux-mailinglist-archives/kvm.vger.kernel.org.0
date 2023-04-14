Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72DF6E27CC
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDNP7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjDNP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46F0AD2D
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id hg14-20020a17090b300e00b002471efa7a8fso5407623pjb.0
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487951; x=1684079951;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q1Z9F1WWwWuoKVJ9t2cYpsn8ieMzUKF7G5wAxvaa99I=;
        b=lJSZ+Yo8VhC9W/LYpyoV2wpRLacsn0bF9TUYh/9nkCO4lhjkZByNRGRG1LeA39hSvi
         5H5NFhDBuDEqmFhZE4pDGeGmjHCRPfF98HaFcpIVG0osVtXBXGQGy+Ej8jqiez1WROlH
         tIfqMHPgjJ0754QswUVwTlRNMUn11dBiyXxYj4kWv+/feLZWqoUa/vQt7Xiv9o1i9nQq
         CyltCcy/feV6x6S8e/+A/58IXp7zImBDmp/8MZwS+4AmX6Vk1PSxd+uibr4KfzLJLrio
         anXne7kv4KJbFwqUjpxxgDhlu1InzmZLou8i5GIzXGaIMu8JUEFxa80CK0tPgQBuQPLO
         uDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487951; x=1684079951;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1Z9F1WWwWuoKVJ9t2cYpsn8ieMzUKF7G5wAxvaa99I=;
        b=eLhI1fTGqpb5mDShKjanCq3ljJn0h1DZNNJ3PHZLgFIdg6Q3wXm9+qS+Of7WqY+9py
         NlCTG/N1TGop7Dpq33HhssvFh/2MSKfVh81uToqGW0LMFNeVcdIHRZk+L91rqgxW8W4W
         BVyH6JQHaZGI27x2NpqBzEDKEZwh2uYQklMl41SMcoy2r09HAbFNtrytQyxsiiPMb0Sg
         1WZotdQ/KiuXcEKF3bpkD85UELmWSIRog3JbF+aBpZSAd0rH3Q8kXw6WTgKqTeIp5hr1
         5LjRpnQMD+O/sc25m5aeRXZmYIG51CdbXT/J0kcWxutyVYWq2/YX9J92hyZb4CKaOFd3
         wksg==
X-Gm-Message-State: AAQBX9eDgGxrCxm14bnLjjCiMGKUSwwfjzOXW6Ll+lJn+ft/ArVaia8E
        2ITfVsHdNL+huUxrlcIoKcdQEg==
X-Google-Smtp-Source: AKy350bprE0+W3CBUSvvYObjUvXLMYFHaBAzhudwABw1qf28V38FrSV2m24wt8iLQdpiZ/P8N9+bZg==
X-Received: by 2002:a17:90b:70a:b0:240:9ccf:41ff with SMTP id s10-20020a17090b070a00b002409ccf41ffmr5501300pjz.49.1681487951281;
        Fri, 14 Apr 2023 08:59:11 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:59:10 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH -next v18 03/20] riscv: Add new csr defines related to vector extension
Date:   Fri, 14 Apr 2023 15:58:26 +0000
Message-Id: <20230414155843.12963-4-andy.chiu@sifive.com>
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
index 7c2b8cdb7b77..39f3fde69ee5 100644
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
@@ -296,6 +304,12 @@
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


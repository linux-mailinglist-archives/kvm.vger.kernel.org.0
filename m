Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ED96661A6
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbjAKRVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbjAKRU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:20:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5319636C;
        Wed, 11 Jan 2023 09:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F8E161D9E;
        Wed, 11 Jan 2023 17:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CB5C433D2;
        Wed, 11 Jan 2023 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457656;
        bh=dAysKavLBgtoJS8P4lvmpl+vDfyTE4+Ks8sj1E2vbYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOf6vUeScpKNvgQpXtmSRX8BqAsT4NdMIcRbdgsmCDpNXtYAkAs6PMN+71a6+xFL6
         YMY99c2+oBl4B2RLUWT7XsPmj6lldWpTuHoB6uFU9AgtxgA8SfyxTQm3D/zI8c9i8v
         w9VVfYyka84foBQChriHCMRAJ09sci0CQbga1/XeNpxGKwRaJ+Oy9j5XWjCPNZ1cjc
         wfFYC0Pj6Z+4u/NZnNZ0gTGlnNgQtQl0dC3KY9eNDVFFuJdghhY3sWpxYGmMKAnZVf
         vMfXrpnEUGACa/dCOWjXSYTaKYMDVEOgjLuxiwkRTKroCmJJQtS/pMbqKlHimRxNJj
         YU1g2InMipajA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 04/13] riscv: hwcap: make ISA extension ids can be used in asm
Date:   Thu, 12 Jan 2023 01:10:18 +0800
Message-Id: <20230111171027.2392-5-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230111171027.2392-1-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will make use of ISA extension in asm files, so make the multi-letter

RISC-V ISA extension IDs macros rather than enums and move them and
those base ISA extension IDs to suitable place.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/hwcap.h | 45 ++++++++++++++++------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 86328e3acb02..09a7767723f6 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -12,20 +12,6 @@
 #include <linux/bits.h>
 #include <uapi/asm/hwcap.h>
 
-#ifndef __ASSEMBLY__
-#include <linux/jump_label.h>
-/*
- * This yields a mask that user programs can use to figure out what
- * instruction set this cpu supports.
- */
-#define ELF_HWCAP		(elf_hwcap)
-
-enum {
-	CAP_HWCAP = 1,
-};
-
-extern unsigned long elf_hwcap;
-
 #define RISCV_ISA_EXT_a		('a' - 'a')
 #define RISCV_ISA_EXT_c		('c' - 'a')
 #define RISCV_ISA_EXT_d		('d' - 'a')
@@ -46,22 +32,33 @@ extern unsigned long elf_hwcap;
 #define RISCV_ISA_EXT_BASE 26
 
 /*
- * This enum represent the logical ID for each multi-letter RISC-V ISA extension.
+ * These macros represent the logical ID for each multi-letter RISC-V ISA extension.
  * The logical ID should start from RISCV_ISA_EXT_BASE and must not exceed
  * RISCV_ISA_EXT_MAX. 0-25 range is reserved for single letter
  * extensions while all the multi-letter extensions should define the next
  * available logical extension id.
  */
-enum riscv_isa_ext_id {
-	RISCV_ISA_EXT_SSCOFPMF = RISCV_ISA_EXT_BASE,
-	RISCV_ISA_EXT_SVPBMT,
-	RISCV_ISA_EXT_ZICBOM,
-	RISCV_ISA_EXT_ZIHINTPAUSE,
-	RISCV_ISA_EXT_SSTC,
-	RISCV_ISA_EXT_SVINVAL,
-	RISCV_ISA_EXT_ID_MAX
+#define RISCV_ISA_EXT_SSCOFPMF		26
+#define RISCV_ISA_EXT_SVPBMT		27
+#define RISCV_ISA_EXT_ZICBOM		28
+#define RISCV_ISA_EXT_ZIHINTPAUSE	29
+#define RISCV_ISA_EXT_SSTC		30
+#define RISCV_ISA_EXT_SVINVAL		31
+
+#ifndef __ASSEMBLY__
+#include <linux/jump_label.h>
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP		(elf_hwcap)
+
+enum {
+	CAP_HWCAP = 1,
 };
-static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
+
+extern unsigned long elf_hwcap;
+
 
 /*
  * This enum represents the logical ID for each RISC-V ISA extension static
-- 
2.38.1


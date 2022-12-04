Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88C641E68
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLDR46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiLDR4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E9E140D0;
        Sun,  4 Dec 2022 09:56:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B6CB80B90;
        Sun,  4 Dec 2022 17:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C6BC433B5;
        Sun,  4 Dec 2022 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176599;
        bh=+82c7E1Z8qHqC9x9JM3yoEqsJXegTt0yFTfCQeuX89M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAQNck9r06+DRPso3mnuLKa8mStE6Onk3Lk6qYLdZLTLOkJ0QKOwJo9NRKKiPsj7a
         TtlGqU7TGsQw3km5k0JgX22Uy90iI/3djHZuXX/H2FjmkDItfVIVNpqy8AaSip2jYo
         mcnvYeB80pPXCSI6UjidNoj2TITjqZHAyt03rXLJ2fWsF0vH8phDqvMHlIrmOPzK62
         2gNKFJJwK1pos5bQ8rVT9wg6nxiKA3IGmYLEhWwVcJrfAHWecjJc88GG71fSLWsVMg
         vc9vMsFKfVNH/fCXJC9hKSCp52HmZSS69Lk/334O3mFWvyudiRHW4FXLaKSwMzWqUg
         liy1fmXMazp7g==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 04/13] riscv: hwcap: make ISA extension ids can be used in asm
Date:   Mon,  5 Dec 2022 01:46:23 +0800
Message-Id: <20221204174632.3677-5-jszhang@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221204174632.3677-1-jszhang@kernel.org>
References: <20221204174632.3677-1-jszhang@kernel.org>
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
 arch/riscv/include/asm/hwcap.h | 43 ++++++++++++++++------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index b22525290073..996884986fea 100644
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
-	RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
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
 
+extern unsigned long elf_hwcap;
+
 /*
  * This enum represents the logical ID for each RISC-V ISA extension static
  * keys. We can use static key to optimize code path if some ISA extensions
-- 
2.37.2


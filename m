Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487076661AF
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjAKRVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbjAKRVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EACD164B7;
        Wed, 11 Jan 2023 09:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E387761D7C;
        Wed, 11 Jan 2023 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAA1C433F2;
        Wed, 11 Jan 2023 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457673;
        bh=QXCl9/YRGYDijYF1P0JxIQVW7KGO4TZ6w3gbD/nga80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYo4JFB4doghBAFFM+7KRWpmdPSTOW7aijVSBCtkqv4opIq/EBx92+5Q64DqjqDOx
         Tu9T+ts4HBkqEd9Tyj4+VnEoMes4Bz4iTX5uAlyS7w+eLfrTuTDtrCuzBOSI2CMqt9
         nAaVGFLaVjjjL9h7Dw/bDFPsNMM9nBGsK8TOatmcd9oDTYkbehG3CwdCzCbwMhGwp7
         kIHQWSddJUAKpddWPJhGNxnFiZ1oA//vOiBdKHTRnvyqE/n9XvVb931ePpuYGNhlGu
         BadmOPhJpe2dImcTdAYgO9MJC3q5mD3Vau3zYMe45HK/Z7yHjgmcpXNGpjCpieVzGL
         NO9uQETcM0lPQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v3 09/13] riscv: switch to relative alternative entries
Date:   Thu, 12 Jan 2023 01:10:23 +0800
Message-Id: <20230111171027.2392-10-jszhang@kernel.org>
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

Instead of using absolute addresses for both the old instrucions and
the alternative instructions, use offsets relative to the alt_entry
values. So this not only cuts the size of the alternative entry, but
also meets the prerequisite for patching alternatives in the vDSO,
since absolute alternative entries are subject to dynamic relocation,
which is incompatible with the vDSO building.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/errata/sifive/errata.c           |  4 +++-
 arch/riscv/errata/thead/errata.c            | 11 ++++++++---
 arch/riscv/include/asm/alternative-macros.h | 20 ++++++++++----------
 arch/riscv/include/asm/alternative.h        | 12 ++++++------
 arch/riscv/kernel/cpufeature.c              |  8 +++++---
 5 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 1031038423e7..0e537cdfd324 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -107,7 +107,9 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
-			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			patch_text_nosync((void *)&alt->old_offset + alt->old_offset,
+					  (void *)&alt->alt_offset + alt->alt_offset,
+					  alt->alt_len);
 			cpu_apply_errata |= tmp;
 		}
 	}
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index fac5742d1c1e..d56d76a529b5 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -87,6 +87,7 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
 	struct alt_entry *alt;
 	u32 cpu_req_errata = thead_errata_probe(stage, archid, impid);
 	u32 tmp;
+	void *oldptr, *altptr;
 
 	for (alt = begin; alt < end; alt++) {
 		if (alt->vendor_id != THEAD_VENDOR_ID)
@@ -96,12 +97,16 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
+			oldptr = (void *)&alt->old_offset + alt->old_offset;
+			altptr = (void *)&alt->alt_offset + alt->alt_offset;
+
 			/* On vm-alternatives, the mmu isn't running yet */
 			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
-				memcpy((void *)__pa_symbol(alt->old_ptr),
-				       (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
+				memcpy((void *)__pa_symbol(oldptr),
+				       (void *)__pa_symbol(altptr),
+				       alt->alt_len);
 			else
-				patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+				patch_text_nosync(oldptr, altptr, alt->alt_len);
 		}
 	}
 
diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
index 7226e2462584..3c3ca65e521b 100644
--- a/arch/riscv/include/asm/alternative-macros.h
+++ b/arch/riscv/include/asm/alternative-macros.h
@@ -7,11 +7,11 @@
 #ifdef __ASSEMBLY__
 
 .macro ALT_ENTRY oldptr newptr vendor_id errata_id new_len
-	RISCV_PTR \oldptr
-	RISCV_PTR \newptr
-	REG_ASM \vendor_id
-	REG_ASM \new_len
-	.word	\errata_id
+	.long \oldptr - .
+	.long \newptr - .
+	.short \vendor_id
+	.short \new_len
+	.long \errata_id
 .endm
 
 .macro ALT_NEW_CONTENT vendor_id, errata_id, enable = 1, new_c : vararg
@@ -59,11 +59,11 @@
 #include <linux/stringify.h>
 
 #define ALT_ENTRY(oldptr, newptr, vendor_id, errata_id, newlen)		\
-	RISCV_PTR " " oldptr "\n"					\
-	RISCV_PTR " " newptr "\n"					\
-	REG_ASM " " vendor_id "\n"					\
-	REG_ASM " " newlen "\n"						\
-	".word " errata_id "\n"
+	".long	((" oldptr ") - .) \n"					\
+	".long	((" newptr ") - .) \n"					\
+	".short	" vendor_id "\n"					\
+	".short	" newlen "\n"						\
+	".long	" errata_id "\n"
 
 #define ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)		\
 	".if " __stringify(enable) " == 1\n"				\
diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
index 1bd4027d34ca..b6050a235f50 100644
--- a/arch/riscv/include/asm/alternative.h
+++ b/arch/riscv/include/asm/alternative.h
@@ -31,12 +31,12 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 				   int patch_offset);
 
 struct alt_entry {
-	void *old_ptr;		 /* address of original instruciton or data  */
-	void *alt_ptr;		 /* address of replacement instruction or data */
-	unsigned long vendor_id; /* cpu vendor id */
-	unsigned long alt_len;   /* The replacement size */
-	unsigned int errata_id;  /* The errata id */
-} __packed;
+	s32 old_offset;		/* offset relative to original instruciton or data  */
+	s32 alt_offset;		/* offset relative to replacement instruction or data */
+	u16 vendor_id;		/* cpu vendor id */
+	u16 alt_len;		/* The replacement size */
+	u32 errata_id;		/* The errata id */
+};
 
 struct errata_checkfunc_id {
 	unsigned long vendor_id;
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 6db8b31d9149..c394cde2560b 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -280,6 +280,7 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 						  unsigned int stage)
 {
 	struct alt_entry *alt;
+	void *oldptr, *altptr;
 
 	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
 		return;
@@ -293,12 +294,13 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 			continue;
 		}
 
+		oldptr = (void *)&alt->old_offset + alt->old_offset;
+		altptr = (void *)&alt->alt_offset + alt->alt_offset;
 		if (!__riscv_isa_extension_available(NULL, alt->errata_id))
 			continue;
 
-		patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
-		riscv_alternative_fix_offsets(alt->old_ptr, alt->alt_len,
-					      alt->old_ptr - alt->alt_ptr);
+		patch_text_nosync(oldptr, altptr, alt->alt_len);
+		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
 	}
 }
 #endif
-- 
2.38.1


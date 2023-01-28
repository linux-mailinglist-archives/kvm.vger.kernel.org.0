Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56E67FA08
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 18:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjA1Rk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 12:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbjA1Rkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 12:40:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9AF2C674;
        Sat, 28 Jan 2023 09:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AEBBB80B84;
        Sat, 28 Jan 2023 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF8C433D2;
        Sat, 28 Jan 2023 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674927590;
        bh=z8/AvCzWD8j3/AewPzC9HFHxsotm2IYSW/Hr076TD5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPIvAFktiW/YEoqiSA/Lcz+xOYPQ0O5KyIILrpQzOj7TGkug5vYjPvZXbYaQnOZ1W
         Oibf94Sh1328o1Bl9enWXXU8D248Gr5k+6OTD1bgaRyFEe+nsfzeyQz6NhMQ6+82HI
         QJ4543hTlA6oFT8pQExSbETju8OmX3bAq6pM1oV7A0pgtjpimkfJU69Wa50TQS4LlM
         PPT5Np+0jcBSGLHE8snWl+xtma8ElG3CTgoEryKsOjK1TKWOacIcGe6Z5QsA4wbRH2
         3aCFRJDOaO849zs5Lt9k+tMvhn9VdHQw62VLTghvJ4YJ4L+KlgU5FAbRQJjomsKp15
         3D4jl5c0PHTKQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v5 09/13] riscv: switch to relative alternative entries
Date:   Sun, 29 Jan 2023 01:28:52 +0800
Message-Id: <20230128172856.3814-10-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230128172856.3814-1-jszhang@kernel.org>
References: <20230128172856.3814-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/errata/sifive/errata.c           |  3 ++-
 arch/riscv/errata/thead/errata.c            | 11 ++++++++---
 arch/riscv/include/asm/alternative-macros.h | 20 ++++++++++----------
 arch/riscv/include/asm/alternative.h        | 17 +++++++++++------
 arch/riscv/kernel/cpufeature.c              |  8 +++++---
 5 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 1031038423e7..ef9a4eec0dba 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -107,7 +107,8 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
 
 		tmp = (1U << alt->errata_id);
 		if (cpu_req_errata & tmp) {
-			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
+			patch_text_nosync(ALT_OLD_PTR(alt), ALT_ALT_PTR(alt),
+					  alt->alt_len);
 			cpu_apply_errata |= tmp;
 		}
 	}
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index fac5742d1c1e..c0bea5c94128 100644
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
+			oldptr = ALT_OLD_PTR(alt);
+			altptr = ALT_ALT_PTR(alt);
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
index 7226e2462584..cc6a81c00f2f 100644
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
+	.4byte \oldptr - .
+	.4byte \newptr - .
+	.2byte \vendor_id
+	.2byte \new_len
+	.4byte \errata_id
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
+	".4byte	((" oldptr ") - .) \n"					\
+	".4byte	((" newptr ") - .) \n"					\
+	".2byte	" vendor_id "\n"					\
+	".2byte " newlen "\n"						\
+	".4byte	" errata_id "\n"
 
 #define ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)		\
 	".if " __stringify(enable) " == 1\n"				\
diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
index 1bd4027d34ca..b8648d4f2ac1 100644
--- a/arch/riscv/include/asm/alternative.h
+++ b/arch/riscv/include/asm/alternative.h
@@ -23,6 +23,11 @@
 #define RISCV_ALTERNATIVES_MODULE	1 /* alternatives applied during module-init */
 #define RISCV_ALTERNATIVES_EARLY_BOOT	2 /* alternatives applied before mmu start */
 
+/* add the relative offset to the address of the offset to get the absolute address */
+#define __ALT_PTR(a, f)			((void *)&(a)->f + (a)->f)
+#define ALT_OLD_PTR(a)			__ALT_PTR(a, old_offset)
+#define ALT_ALT_PTR(a)			__ALT_PTR(a, alt_offset)
+
 void __init apply_boot_alternatives(void);
 void __init apply_early_boot_alternatives(void);
 void apply_module_alternatives(void *start, size_t length);
@@ -31,12 +36,12 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 				   int patch_offset);
 
 struct alt_entry {
-	void *old_ptr;		 /* address of original instruciton or data  */
-	void *alt_ptr;		 /* address of replacement instruction or data */
-	unsigned long vendor_id; /* cpu vendor id */
-	unsigned long alt_len;   /* The replacement size */
-	unsigned int errata_id;  /* The errata id */
-} __packed;
+	s32 old_offset;		/* offset relative to original instruction or data  */
+	s32 alt_offset;		/* offset relative to replacement instruction or data */
+	u16 vendor_id;		/* cpu vendor id */
+	u16 alt_len;		/* The replacement size */
+	u32 errata_id;		/* The errata id */
+};
 
 struct errata_checkfunc_id {
 	unsigned long vendor_id;
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 6193f401f0c5..18ea518f9e68 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -281,6 +281,7 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 						  unsigned int stage)
 {
 	struct alt_entry *alt;
+	void *oldptr, *altptr;
 
 	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
 		return;
@@ -297,9 +298,10 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 		if (!__riscv_isa_extension_available(NULL, alt->errata_id))
 			continue;
 
-		patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
-		riscv_alternative_fix_offsets(alt->old_ptr, alt->alt_len,
-					      alt->old_ptr - alt->alt_ptr);
+		oldptr = ALT_OLD_PTR(alt);
+		altptr = ALT_ALT_PTR(alt);
+		patch_text_nosync(oldptr, altptr, alt->alt_len);
+		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
 	}
 }
 #endif
-- 
2.38.1


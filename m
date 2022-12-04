Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461EB641E5F
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLDR4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiLDR4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB2D140D0;
        Sun,  4 Dec 2022 09:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9E9560DEB;
        Sun,  4 Dec 2022 17:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5FAC433B5;
        Sun,  4 Dec 2022 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176591;
        bh=ARTuhir6BWBSEl/m8Qedtx8F7YcogAViI/5PbaogT2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2m7mLIl9zDz4yS97Bx4+LiNE125jD/8nAhNnA79/8kLWV4e+09fZmc4kezNjbblX
         KYX4fVdqDVSMIL2GodZR2WGaDxaNjRW75DSnBKVqbIBCFV26C/lUbPvW/DRjG3IOrW
         e+w+a/c5BOyvOHSNA5q96o9dEJzV19Sq+7OZl8lTUu/lg6XiLQ6Ge0zwlRlYqN5dEe
         DzoTurRKNzaV363DscDaDc+te4Cor1/POsc7P6fi0XDLJh7hi1DTiUxC36qOfdGEAF
         lc6a1r4OMGIOYuoriEWSJ5nmIvXDFMrBOw+7nI5FPdyCts7RmBTYlE1IO3A9MSTu/P
         eAEuxTAUqkRAg==
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
Subject: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Date:   Mon,  5 Dec 2022 01:46:20 +0800
Message-Id: <20221204174632.3677-2-jszhang@kernel.org>
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

Alternatives live in a different section, so offsets used by jal
instruction will point to wrong locations after the patch got applied.

Similar to arm64, adjust the location to consider that offset.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/alternative.h |  2 ++
 arch/riscv/kernel/alternative.c      | 38 ++++++++++++++++++++++++++++
 arch/riscv/kernel/cpufeature.c       |  3 +++
 3 files changed, 43 insertions(+)

diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
index c58ec3cc4bc3..33eae9541684 100644
--- a/arch/riscv/include/asm/alternative.h
+++ b/arch/riscv/include/asm/alternative.h
@@ -29,6 +29,8 @@ void apply_module_alternatives(void *start, size_t length);
 
 void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
 				      int patch_offset);
+void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
+			       int patch_offset);
 
 struct alt_entry {
 	void *old_ptr;		 /* address of original instruciton or data  */
diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 292cc42dc3be..9d88375624b5 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -125,6 +125,44 @@ void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
 	}
 }
 
+#define to_jal_imm(value)						\
+	(((value & (RV_J_IMM_10_1_MASK << RV_J_IMM_10_1_OFF)) << RV_I_IMM_11_0_OPOFF) | \
+	 ((value & (RV_J_IMM_11_MASK << RV_J_IMM_11_OFF)) << RV_J_IMM_11_OPOFF) | \
+	 ((value & (RV_J_IMM_19_12_OPOFF << RV_J_IMM_19_12_OFF)) << RV_J_IMM_19_12_OPOFF) | \
+	 ((value & (1 << RV_J_IMM_SIGN_OFF)) << RV_J_IMM_SIGN_OPOFF))
+
+void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
+			       int patch_offset)
+{
+	int num_instr = len / sizeof(u32);
+	unsigned int call;
+	int i;
+	int imm;
+
+	for (i = 0; i < num_instr; i++) {
+		u32 inst = riscv_instruction_at(alt_ptr, i);
+
+		if (!riscv_insn_is_jal(inst))
+			continue;
+
+		/* get and adjust new target address */
+		imm = RV_EXTRACT_JTYPE_IMM(inst);
+		imm -= patch_offset;
+
+		/* pick the original jal */
+		call = inst;
+
+		/* drop the old IMMs, all jal imm bits sit at 31:12 */
+		call &= ~GENMASK(31, 12);
+
+		/* add the adapted IMMs */
+		call |= to_jal_imm(imm);
+
+		/* patch the call place again */
+		patch_text_nosync(alt_ptr + i * sizeof(u32), &call, 4);
+	}
+}
+
 /*
  * This is called very early in the boot process (directly after we run
  * a feature detect on the boot CPU). No need to worry about other CPUs
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index ba62a4ff5ccd..c743f0adc794 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -324,6 +324,9 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 			riscv_alternative_fix_auipc_jalr(alt->old_ptr,
 							 alt->alt_len,
 							 alt->old_ptr - alt->alt_ptr);
+			riscv_alternative_fix_jal(alt->old_ptr,
+						  alt->alt_len,
+						  alt->old_ptr - alt->alt_ptr);
 		}
 	}
 }
-- 
2.37.2


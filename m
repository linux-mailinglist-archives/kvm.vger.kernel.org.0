Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9197166619F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbjAKRVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbjAKRUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8E23057E;
        Wed, 11 Jan 2023 09:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 856EBB81C8A;
        Wed, 11 Jan 2023 17:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28B5C433EF;
        Wed, 11 Jan 2023 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457647;
        bh=KRbUD/DoZCTDQnpByHlFlnPMc8QCP2Jn97CVBSFQEdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA9Tw53YhdOGsvk3g+hlq8uCbsDTYI6F7Vkf1KEVye3JmHxcYO3VNbvGpSW/ZrGfI
         fX28RfMxvvX3tyEPeChS/dDgFTCRjYT/hrx5SrTxlmWmS3XKZy+xoH8rvYkMtxyvbs
         gjZY9M2awgxNvZE0iJy2zngMzz5Np0pWUEUW63DKEi7jORdf6jFLY7Ke74G+SqiPVR
         WBmwKgn3mj2+ONqvOKgvJqCrP6tt0psl+8Qpw1DPkmpXvRQ97wYiIXXeRfzEJddNvI
         YSHK8yZCGOKatTi7ly3InyB3Lv1bKa7jHyRe9YIyknwmQ7CFMABeU/jPKIuuVFqDXI
         xebX0eOKIQoBA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH v3 01/13] riscv: fix jal offsets in patched alternatives
Date:   Thu, 12 Jan 2023 01:10:15 +0800
Message-Id: <20230111171027.2392-2-jszhang@kernel.org>
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

Alternatives live in a different section, so offsets used by jal
instruction will point to wrong locations after the patch got applied.

Similar to arm64, adjust the location to consider that offset.

Co-developed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/insn.h   | 27 +++++++++++++++++++++++++++
 arch/riscv/kernel/alternative.c | 27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 98453535324a..1d2df245d0bd 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -291,6 +291,33 @@ static __always_inline bool riscv_insn_is_branch(u32 code)
 	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
 
+/*
+ * Get the immediate from a J-type instruction.
+ *
+ * @insn: instruction to process
+ * Return: immediate
+ */
+static inline s32 riscv_insn_extract_jtype_imm(u32 insn)
+{
+	return RV_EXTRACT_JTYPE_IMM(insn);
+}
+
+/*
+ * Update a J-type instruction with an immediate value.
+ *
+ * @insn: pointer to the jtype instruction
+ * @imm: the immediate to insert into the instruction
+ */
+static inline void riscv_insn_insert_jtype_imm(u32 *insn, s32 imm)
+{
+	/* drop the old IMMs, all jal IMM bits sit at 31:12 */
+	*insn &= ~GENMASK(31, 12);
+	*insn |= (RV_X(imm, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) |
+		 (RV_X(imm, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) |
+		 (RV_X(imm, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) |
+		 (RV_X(imm, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF);
+}
+
 /*
  * Put together one immediate from a U-type and I-type instruction pair.
  *
diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 6212ea0eed72..3d4f1f32c7f6 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -79,6 +79,21 @@ static void riscv_alternative_fix_auipc_jalr(void *ptr, u32 auipc_insn,
 	patch_text_nosync(ptr, call, sizeof(u32) * 2);
 }
 
+static void riscv_alternative_fix_jal(void *ptr, u32 jal_insn, int patch_offset)
+{
+	s32 imm;
+
+	/* get and adjust new target address */
+	imm = riscv_insn_extract_jtype_imm(jal_insn);
+	imm -= patch_offset;
+
+	/* update instruction */
+	riscv_insn_insert_jtype_imm(&jal_insn, imm);
+
+	/* patch the call place again */
+	patch_text_nosync(ptr, &jal_insn, sizeof(u32));
+}
+
 void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 				      int patch_offset)
 {
@@ -106,6 +121,18 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 			riscv_alternative_fix_auipc_jalr(alt_ptr + i * sizeof(u32),
 							 insn, insn2, patch_offset);
 		}
+
+		if (riscv_insn_is_jal(insn)) {
+			s32 imm = riscv_insn_extract_jtype_imm(insn);
+
+			/* Don't modify jumps inside the alternative block */
+			if ((alt_ptr + i * sizeof(u32) + imm) >= alt_ptr &&
+			    (alt_ptr + i * sizeof(u32) + imm) < (alt_ptr + len))
+				continue;
+
+			riscv_alternative_fix_jal(alt_ptr + i * sizeof(u32),
+						  insn, patch_offset);
+		}
 	}
 }
 
-- 
2.38.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D7C6B4BFA
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCJQGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCJQFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:53 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552793876
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:02 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDi-00H4ad-Dp; Fri, 10 Mar 2023 16:03:50 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 05/45] target/riscv: Add vclmul.vx decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:06 +0000
Message-Id: <20230310160346.1193597-6-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk>
References: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  1 +
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc | 48 ++++++++++++++++++++++
 target/riscv/vcrypto_helper.c              |  2 +
 4 files changed, 52 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 33060c3e2f..352921ead6 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1145,3 +1145,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 
 /* Vector crypto functions */
 DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 03a0057d71..6b8466424d 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -911,3 +911,4 @@ czero_nez   0000111  ..... ..... 111 ..... 0110011 @r
 
 # *** RV64 Zvkb vector crypto extension ***
 vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
+vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 7cd920e76d..76efade1b6 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -38,3 +38,51 @@ static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
 }
 
 GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
+
+#define GEN_VX_MASKED_TRANS(NAME, CHECK)                                \
+static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                  \
+{                                                                       \
+    if (CHECK(s, a)) {                                                  \
+        TCGv_ptr rd_v, v0_v, rs2_v;                                     \
+        TCGv rs1;                                                       \
+        TCGv_i32 desc;                                                  \
+        uint32_t data = 0;                                              \
+                                                                        \
+        TCGLabel *over = gen_new_label();                               \
+        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);      \
+                                                                        \
+        data = FIELD_DP32(data, VDATA, VM, a->vm);                      \
+        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                  \
+        data = FIELD_DP32(data, VDATA, VTA, s->vta);                    \
+        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);  \
+        data = FIELD_DP32(data, VDATA, VMA, s->vma);                    \
+                                                                        \
+        rd_v = tcg_temp_new_ptr();                                      \
+        v0_v = tcg_temp_new_ptr();                                      \
+        rs1 = get_gpr(s, a->rs1, EXT_ZERO);                             \
+        rs2_v = tcg_temp_new_ptr();                                     \
+        desc = tcg_constant_i32(simd_desc(s->cfg_ptr->vlen / 8,         \
+                                          s->cfg_ptr->vlen / 8, data)); \
+        tcg_gen_addi_ptr(rd_v, cpu_env, vreg_ofs(s, a->rd));            \
+        tcg_gen_addi_ptr(v0_v, cpu_env, vreg_ofs(s, 0));                \
+        tcg_gen_addi_ptr(rs2_v, cpu_env, vreg_ofs(s, a->rs2));          \
+        gen_helper_##NAME(rd_v, v0_v, rs1, rs2_v, cpu_env, desc);       \
+                                                                        \
+        mark_vs_dirty(s);                                               \
+        gen_set_label(over);                                            \
+        return true;                                                    \
+    }                                                                   \
+    return false;                                                       \
+}
+
+static bool zvkb_vx_check(DisasContext *s, arg_rmrr *a)
+{
+    return opivx_check(s, a) && s->cfg_ptr->ext_zvkb == true;
+}
+
+static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
+{
+    return zvkb_vx_check(s, a) && s->sew == MO_64;
+}
+
+GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index b4983886bd..749a9cb30b 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -40,3 +40,5 @@ static uint64_t clmul64(uint64_t y, uint64_t x)
 
 RVVCALL(OPIVV2, vclmul_vv, OP_UUU_D, H8, H8, H8, clmul64)
 GEN_VEXT_VV(vclmul_vv, 8)
+RVVCALL(OPIVX2, vclmul_vx, OP_UUU_D, H8, H8, clmul64)
+GEN_VEXT_VX(vclmul_vx, 8)
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76E6B4C02
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCJQGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCJQFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:55 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D417359CB
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:05 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDk-00H4ad-Sk; Fri, 10 Mar 2023 16:03:52 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 14/45] target/riscv: Add vandn.[vv,vx] decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:15 +0000
Message-Id: <20230310160346.1193597-15-lawrence.hunter@codethink.co.uk>
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

From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 accel/tcg/tcg-runtime-gvec.c               | 11 +++++++
 accel/tcg/tcg-runtime.h                    |  1 +
 target/riscv/helper.h                      |  9 ++++++
 target/riscv/insn32.decode                 |  2 ++
 target/riscv/insn_trans/trans_rvzvkb.c.inc | 34 ++++++++++++++++++++++
 target/riscv/vcrypto_helper.c              | 19 ++++++++++++
 6 files changed, 76 insertions(+)

diff --git a/accel/tcg/tcg-runtime-gvec.c b/accel/tcg/tcg-runtime-gvec.c
index ac7d28c251..322dcc0687 100644
--- a/accel/tcg/tcg-runtime-gvec.c
+++ b/accel/tcg/tcg-runtime-gvec.c
@@ -550,6 +550,17 @@ void HELPER(gvec_ands)(void *d, void *a, uint64_t b, uint32_t desc)
     clear_high(d, oprsz, desc);
 }
 
+void HELPER(gvec_andsc)(void *d, void *a, uint64_t b, uint32_t desc)
+{
+    intptr_t oprsz = simd_oprsz(desc);
+    intptr_t i;
+
+    for (i = 0; i < oprsz; i += sizeof(uint64_t)) {
+        *(uint64_t *)(d + i) = *(uint64_t *)(a + i) & ~b;
+    }
+    clear_high(d, oprsz, desc);
+}
+
 void HELPER(gvec_xors)(void *d, void *a, uint64_t b, uint32_t desc)
 {
     intptr_t oprsz = simd_oprsz(desc);
diff --git a/accel/tcg/tcg-runtime.h b/accel/tcg/tcg-runtime.h
index e141a6ab24..d086200483 100644
--- a/accel/tcg/tcg-runtime.h
+++ b/accel/tcg/tcg-runtime.h
@@ -217,6 +217,7 @@ DEF_HELPER_FLAGS_4(gvec_nor, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
 DEF_HELPER_FLAGS_4(gvec_eqv, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
 
 DEF_HELPER_FLAGS_4(gvec_ands, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
+DEF_HELPER_FLAGS_4(gvec_andsc, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 DEF_HELPER_FLAGS_4(gvec_xors, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 DEF_HELPER_FLAGS_4(gvec_ors, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 
diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index b4baa22692..1bc10ca5be 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1177,3 +1177,12 @@ DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_6(vandn_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index bdefcd3fa2..bbf128e4dc 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -923,3 +923,5 @@ vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
 vror_vi         01010. . ..... ..... 011 ..... 1010111 @r2_zimm6
 vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
 vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
+vandn_vv        000001 . ..... ..... 000 ..... 1010111 @r_vm
+vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 77ba8bc713..a9a820ec0a 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -146,6 +146,40 @@ GEN_OPIVV_GVEC_TRANS_CHECK(vror_vv, rotrv, zvkb_vv_check)
 GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(vror_vx, rotrs, zvkb_vx_check)
 GEN_OPIVI_GVEC_TRANS_CHECK(vror_vi, IMM_ZIMM6, vror_vx, rotri, zvkb_vx_check)
 
+
+static void tcg_gen_gvec_andsc(unsigned vece, uint32_t dofs, uint32_t aofs,
+                               TCGv_i64 c, uint32_t oprsz, uint32_t maxsz)
+{
+    static GVecGen2s g = {
+        .fni8 = tcg_gen_andc_i64,
+        .fniv = tcg_gen_andc_vec,
+        .fno = gen_helper_gvec_andsc,
+        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
+    };
+
+    g.vece = vece;
+
+    tcg_gen_dup_i64(vece, c, c);
+    tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, c, &g);
+}
+
+#define GEN_OPIVX_GVEC_TRANS_CHECK(NAME, SUF, CHECK)                 \
+static bool trans_##NAME(DisasContext *s, arg_rmrr *a)               \
+{                                                                    \
+    if (CHECK(s, a)) {                                               \
+        static gen_helper_opivx * const fns[4] = {                   \
+            gen_helper_##NAME##_b, gen_helper_##NAME##_h,            \
+            gen_helper_##NAME##_w, gen_helper_##NAME##_d,            \
+        };                                                           \
+        return do_opivx_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew]); \
+    }                                                                \
+    return false;                                                    \
+}
+
+/* vandn.v[vx] */
+GEN_OPIVV_GVEC_TRANS_CHECK(vandn_vv, andc, zvkb_vv_check)
+GEN_OPIVX_GVEC_TRANS_CHECK(vandn_vx, andsc, zvkb_vx_check)
+
 #define GEN_OPIV_TRANS(NAME, CHECK)                                    \
 static bool trans_##NAME(DisasContext *s, arg_rmr * a)                 \
 {                                                                      \
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index ecf21c50f8..7d2a355418 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -125,3 +125,22 @@ GEN_VEXT_V(vrev8_v_b, 1)
 GEN_VEXT_V(vrev8_v_h, 2)
 GEN_VEXT_V(vrev8_v_w, 4)
 GEN_VEXT_V(vrev8_v_d, 8)
+
+#define DO_ANDN(a, b) ((a) & ~(b))
+RVVCALL(OPIVV2, vandn_vv_b, OP_UUU_B, H1, H1, H1, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_h, OP_UUU_H, H2, H2, H2, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_w, OP_UUU_W, H4, H4, H4, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_d, OP_UUU_D, H8, H8, H8, DO_ANDN)
+GEN_VEXT_VV(vandn_vv_b, 1)
+GEN_VEXT_VV(vandn_vv_h, 2)
+GEN_VEXT_VV(vandn_vv_w, 4)
+GEN_VEXT_VV(vandn_vv_d, 8)
+
+RVVCALL(OPIVX2, vandn_vx_b, OP_UUU_B, H1, H1, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_h, OP_UUU_H, H2, H2, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_w, OP_UUU_W, H4, H4, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_d, OP_UUU_D, H8, H8, DO_ANDN)
+GEN_VEXT_VX(vandn_vx_b, 1)
+GEN_VEXT_VX(vandn_vx_h, 2)
+GEN_VEXT_VX(vandn_vx_w, 4)
+GEN_VEXT_VX(vandn_vx_d, 8)
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A346B4BF9
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCJQGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCJQFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:53 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB0093E38
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:03 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDj-00H4ad-82; Fri, 10 Mar 2023 16:03:51 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 08/45] target/riscv: Refactor some of the generic vector functionality
Date:   Fri, 10 Mar 2023 16:03:09 +0000
Message-Id: <20230310160346.1193597-9-lawrence.hunter@codethink.co.uk>
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

Moves the checks out of `do_opiv{v,x,i}_gvec{,_shift}` functions
and into the corresponding macros. This enables the functions to be
reused in proceeding commit without check duplication.

Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 target/riscv/insn_trans/trans_rvv.c.inc | 28 +++++++++++--------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index 4106bd6994..bb5e2c5407 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -1187,9 +1187,6 @@ do_opivv_gvec(DisasContext *s, arg_rmrr *a, GVecGen3Fn *gvec_fn,
               gen_helper_gvec_4_ptr *fn)
 {
     TCGLabel *over = gen_new_label();
-    if (!opivv_check(s, a)) {
-        return false;
-    }
 
     tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
     tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
@@ -1223,6 +1220,9 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
         gen_helper_##NAME##_b, gen_helper_##NAME##_h,              \
         gen_helper_##NAME##_w, gen_helper_##NAME##_d,              \
     };                                                             \
+    if (!opivv_check(s, a)) {                                      \
+        return false;                                              \
+    }                                                              \
     return do_opivv_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew]);   \
 }
 
@@ -1282,10 +1282,6 @@ static inline bool
 do_opivx_gvec(DisasContext *s, arg_rmrr *a, GVecGen2sFn *gvec_fn,
               gen_helper_opivx *fn)
 {
-    if (!opivx_check(s, a)) {
-        return false;
-    }
-
     if (a->vm && s->vl_eq_vlmax && !(s->vta && s->lmul < 0)) {
         TCGv_i64 src1 = tcg_temp_new_i64();
 
@@ -1307,6 +1303,9 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
         gen_helper_##NAME##_b, gen_helper_##NAME##_h,              \
         gen_helper_##NAME##_w, gen_helper_##NAME##_d,              \
     };                                                             \
+    if (!opivx_check(s, a)) {                                      \
+        return false;                                              \
+    }                                                              \
     return do_opivx_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew]);   \
 }
 
@@ -1439,10 +1438,6 @@ static inline bool
 do_opivi_gvec(DisasContext *s, arg_rmrr *a, GVecGen2iFn *gvec_fn,
               gen_helper_opivx *fn, imm_mode_t imm_mode)
 {
-    if (!opivx_check(s, a)) {
-        return false;
-    }
-
     if (a->vm && s->vl_eq_vlmax && !(s->vta && s->lmul < 0)) {
         gvec_fn(s->sew, vreg_ofs(s, a->rd), vreg_ofs(s, a->rs2),
                 extract_imm(s, a->rs1, imm_mode), MAXSZ(s), MAXSZ(s));
@@ -1460,6 +1455,9 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
         gen_helper_##OPIVX##_b, gen_helper_##OPIVX##_h,            \
         gen_helper_##OPIVX##_w, gen_helper_##OPIVX##_d,            \
     };                                                             \
+    if (!opivx_check(s, a)) {                                      \
+        return false;                                              \
+    }                                                              \
     return do_opivi_gvec(s, a, tcg_gen_gvec_##SUF,                 \
                          fns[s->sew], IMM_MODE);                   \
 }
@@ -1785,10 +1783,6 @@ static inline bool
 do_opivx_gvec_shift(DisasContext *s, arg_rmrr *a, GVecGen2sFn32 *gvec_fn,
                     gen_helper_opivx *fn)
 {
-    if (!opivx_check(s, a)) {
-        return false;
-    }
-
     if (a->vm && s->vl_eq_vlmax && !(s->vta && s->lmul < 0)) {
         TCGv_i32 src1 = tcg_temp_new_i32();
 
@@ -1810,7 +1804,9 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                    \
         gen_helper_##NAME##_b, gen_helper_##NAME##_h,                     \
         gen_helper_##NAME##_w, gen_helper_##NAME##_d,                     \
     };                                                                    \
-                                                                          \
+    if (!opivx_check(s, a)) {                                             \
+        return false;                                                     \
+    }                                                                     \
     return do_opivx_gvec_shift(s, a, tcg_gen_gvec_##SUF, fns[s->sew]);    \
 }
 
-- 
2.39.2


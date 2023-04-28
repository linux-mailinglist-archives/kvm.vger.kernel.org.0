Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7F56F1B95
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346080AbjD1Paw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346167AbjD1Pas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:30:48 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6F1FED
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:30:44 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPOL-005zz5-Bq; Fri, 28 Apr 2023 15:48:09 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
Subject: [PATCH v3 06/19] target/riscv: Refactor translation of vector-widening instruction
Date:   Fri, 28 Apr 2023 15:47:44 +0100
Message-Id: <20230428144757.57530-7-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dickon Hood <dickon.hood@codethink.co.uk>

Zvbb (implemented in later commit) has a widening instruction, which
requires an extra check on the enabled extensions.  Refactor
GEN_OPIVX_WIDEN_TRANS() to take a check function to avoid reimplementing
it.

Signed-off-by: Dickon Hood <dickon.hood@codethink.co.uk>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/riscv/insn_trans/trans_rvv.c.inc | 52 +++++++++++--------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index 21731b784ec..2c2a097b76d 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -1526,30 +1526,24 @@ static bool opivx_widen_check(DisasContext *s, arg_rmrr *a)
            vext_check_ds(s, a->rd, a->rs2, a->vm);
 }
 
-static bool do_opivx_widen(DisasContext *s, arg_rmrr *a,
-                           gen_helper_opivx *fn)
-{
-    if (opivx_widen_check(s, a)) {
-        return opivx_trans(a->rd, a->rs1, a->rs2, a->vm, fn, s);
-    }
-    return false;
+#define GEN_OPIVX_WIDEN_TRANS(NAME, CHECK) \
+static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                    \
+{                                                                         \
+    if (CHECK(s, a)) {                                                    \
+        static gen_helper_opivx * const fns[3] = {                        \
+            gen_helper_##NAME##_b,                                        \
+            gen_helper_##NAME##_h,                                        \
+            gen_helper_##NAME##_w                                         \
+        };                                                                \
+        return opivx_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s); \
+    }                                                                     \
+    return false;                                                         \
 }
 
-#define GEN_OPIVX_WIDEN_TRANS(NAME) \
-static bool trans_##NAME(DisasContext *s, arg_rmrr *a)       \
-{                                                            \
-    static gen_helper_opivx * const fns[3] = {               \
-        gen_helper_##NAME##_b,                               \
-        gen_helper_##NAME##_h,                               \
-        gen_helper_##NAME##_w                                \
-    };                                                       \
-    return do_opivx_widen(s, a, fns[s->sew]);                \
-}
-
-GEN_OPIVX_WIDEN_TRANS(vwaddu_vx)
-GEN_OPIVX_WIDEN_TRANS(vwadd_vx)
-GEN_OPIVX_WIDEN_TRANS(vwsubu_vx)
-GEN_OPIVX_WIDEN_TRANS(vwsub_vx)
+GEN_OPIVX_WIDEN_TRANS(vwaddu_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwadd_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwsubu_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwsub_vx, opivx_widen_check)
 
 /* WIDEN OPIVV with WIDEN */
 static bool opiwv_widen_check(DisasContext *s, arg_rmrr *a)
@@ -1997,9 +1991,9 @@ GEN_OPIVX_TRANS(vrem_vx, opivx_check)
 GEN_OPIVV_WIDEN_TRANS(vwmul_vv, opivv_widen_check)
 GEN_OPIVV_WIDEN_TRANS(vwmulu_vv, opivv_widen_check)
 GEN_OPIVV_WIDEN_TRANS(vwmulsu_vv, opivv_widen_check)
-GEN_OPIVX_WIDEN_TRANS(vwmul_vx)
-GEN_OPIVX_WIDEN_TRANS(vwmulu_vx)
-GEN_OPIVX_WIDEN_TRANS(vwmulsu_vx)
+GEN_OPIVX_WIDEN_TRANS(vwmul_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwmulu_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwmulsu_vx, opivx_widen_check)
 
 /* Vector Single-Width Integer Multiply-Add Instructions */
 GEN_OPIVV_TRANS(vmacc_vv, opivv_check)
@@ -2015,10 +2009,10 @@ GEN_OPIVX_TRANS(vnmsub_vx, opivx_check)
 GEN_OPIVV_WIDEN_TRANS(vwmaccu_vv, opivv_widen_check)
 GEN_OPIVV_WIDEN_TRANS(vwmacc_vv, opivv_widen_check)
 GEN_OPIVV_WIDEN_TRANS(vwmaccsu_vv, opivv_widen_check)
-GEN_OPIVX_WIDEN_TRANS(vwmaccu_vx)
-GEN_OPIVX_WIDEN_TRANS(vwmacc_vx)
-GEN_OPIVX_WIDEN_TRANS(vwmaccsu_vx)
-GEN_OPIVX_WIDEN_TRANS(vwmaccus_vx)
+GEN_OPIVX_WIDEN_TRANS(vwmaccu_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwmacc_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwmaccsu_vx, opivx_widen_check)
+GEN_OPIVX_WIDEN_TRANS(vwmaccus_vx, opivx_widen_check)
 
 /* Vector Integer Merge and Move Instructions */
 static bool trans_vmv_v_v(DisasContext *s, arg_vmv_v_v *a)
-- 
2.40.1


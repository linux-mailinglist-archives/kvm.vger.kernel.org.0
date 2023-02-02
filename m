Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38612687DAD
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBBMoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjBBMoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:25 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EE38B7FD
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:43:57 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvE-004Q6t-1a; Thu, 02 Feb 2023 12:42:36 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 03/39] target/riscv: Add vclmul.vx decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:41:54 +0000
Message-Id: <20230202124230.295997-4-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  1 +
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc | 54 ++++++++++++++++++++++
 target/riscv/vcrypto_helper.c              | 12 +++++
 target/riscv/vector_helper.c               | 36 ---------------
 target/riscv/vector_internals.c            | 24 ++++++++++
 target/riscv/vector_internals.h            | 16 +++++++
 7 files changed, 108 insertions(+), 36 deletions(-)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index e9127c9ccb..6c786ef6f3 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1139,3 +1139,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 
 /* Vector crypto functions */
 DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 5ddee69d60..4a7421354d 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -893,3 +893,4 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
 
 # *** RV64 Zvkb vector crypto extension ***
 vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
+vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index fb1995f737..6e8b81136c 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -39,3 +39,57 @@ static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
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
+        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);               \
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
+        tcg_temp_free_ptr(rd_v);                                        \
+        tcg_temp_free_ptr(v0_v);                                        \
+        tcg_temp_free_ptr(rs2_v);                                       \
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
+    return opivx_check(s, a) &&
+           s->cfg_ptr->ext_zvkb == true;
+}
+
+static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
+{
+    return zvkb_vx_check(s, a) &&
+           s->sew == MO_64;
+}
+
+GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 8a11e56754..c453d348ad 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -20,4 +20,16 @@ static void do_vclmul_vv(void *vd, void *vs1, void *vs2, int i)
     ((uint64_t *)vd)[i] = result;
 }
 
+static void do_vclmul_vx(void *vd, target_long rs1, void *vs2, int i)
+{
+    uint64_t result = 0;
+    for (int j = 63; j >= 0; j--) {
+        if ((rs1 >> j) & 1) {
+            result ^= (((uint64_t *)vs2)[i] << j);
+        }
+    }
+    ((uint64_t *)vd)[i] = result;
+}
+
 GEN_VEXT_VV(vclmul_vv, 8)
+GEN_VEXT_VX(vclmul_vx, 8)
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index def1b21414..ab470092f6 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -747,8 +747,6 @@ GEN_VEXT_VV(vsub_vv_h, 2)
 GEN_VEXT_VV(vsub_vv_w, 4)
 GEN_VEXT_VV(vsub_vv_d, 8)
 
-typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
-
 /*
  * (T1)s1 gives the real operator type.
  * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
@@ -773,40 +771,6 @@ RVVCALL(OPIVX2, vrsub_vx_h, OP_SSS_H, H2, H2, DO_RSUB)
 RVVCALL(OPIVX2, vrsub_vx_w, OP_SSS_W, H4, H4, DO_RSUB)
 RVVCALL(OPIVX2, vrsub_vx_d, OP_SSS_D, H8, H8, DO_RSUB)
 
-static void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
-                       CPURISCVState *env, uint32_t desc,
-                       opivx2_fn fn, uint32_t esz)
-{
-    uint32_t vm = vext_vm(desc);
-    uint32_t vl = env->vl;
-    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
-    uint32_t vta = vext_vta(desc);
-    uint32_t vma = vext_vma(desc);
-    uint32_t i;
-
-    for (i = env->vstart; i < vl; i++) {
-        if (!vm && !vext_elem_mask(v0, i)) {
-            /* set masked-off elements to 1s */
-            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
-            continue;
-        }
-        fn(vd, s1, vs2, i);
-    }
-    env->vstart = 0;
-    /* set tail elements to 1s */
-    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
-}
-
-/* generate the helpers for OPIVX */
-#define GEN_VEXT_VX(NAME, ESZ)                            \
-void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
-                  void *vs2, CPURISCVState *env,          \
-                  uint32_t desc)                          \
-{                                                         \
-    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
-               do_##NAME, ESZ);                           \
-}
-
 GEN_VEXT_VX(vadd_vx_b, 1)
 GEN_VEXT_VX(vadd_vx_h, 2)
 GEN_VEXT_VX(vadd_vx_w, 4)
diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_internals.c
index a264797882..b23fa4dd74 100644
--- a/target/riscv/vector_internals.c
+++ b/target/riscv/vector_internals.c
@@ -37,3 +37,27 @@ void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
     /* set tail elements to 1s */
     vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
 }
+
+void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivx2_fn fn, uint32_t esz)
+{
+    uint32_t vm = vext_vm(desc);
+    uint32_t vl = env->vl;
+    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
+    uint32_t vta = vext_vta(desc);
+    uint32_t vma = vext_vma(desc);
+    uint32_t i;
+
+    for (i = env->vstart; i < vl; i++) {
+        if (!vm && !vext_elem_mask(v0, i)) {
+            /* set masked-off elements to 1s */
+            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
+            continue;
+        }
+        fn(vd, s1, vs2, i);
+    }
+    env->vstart = 0;
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
+}
diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
index f61803acc0..49529d2379 100644
--- a/target/riscv/vector_internals.h
+++ b/target/riscv/vector_internals.h
@@ -113,4 +113,20 @@ void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
                do_##NAME, ESZ);                           \
 }
 
+typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
+
+void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivx2_fn fn, uint32_t esz);
+
+/* generate the helpers for OPIVX */
+#define GEN_VEXT_VX(NAME, ESZ)                            \
+void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
+                  void *vs2, CPURISCVState *env,          \
+                  uint32_t desc)                          \
+{                                                         \
+    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
+               do_##NAME, ESZ);                           \
+}
+
 #endif /* TARGET_RISCV_VECTOR_INTERNAL_H */
-- 
2.39.1


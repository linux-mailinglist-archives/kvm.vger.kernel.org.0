Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE106B4C04
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjCJQGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCJQF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:56 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E27A6159
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:05 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDh-00H4ad-Hd; Fri, 10 Mar 2023 16:03:49 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 02/45] target/riscv: Refactor some of the generic vector functionality
Date:   Fri, 10 Mar 2023 16:03:03 +0000
Message-Id: <20230310160346.1193597-3-lawrence.hunter@codethink.co.uk>
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

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

Summary of refactoring:

* take some functions/macros out of `vector_helper` and put them in a
new module called `vector_internals`

* factor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
function `opivv_trans` (similar to `opivi_trans`)

All this refactoring ensures more functions/macros can be used by both
vector and vector-crypto helpers (latter implemented in proceeding
commit).

Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/insn_trans/trans_rvv.c.inc |  62 +++++-----
 target/riscv/meson.build                |   1 +
 target/riscv/vector_helper.c            | 155 +-----------------------
 target/riscv/vector_internals.c         |  57 +++++++++
 target/riscv/vector_internals.h         | 155 ++++++++++++++++++++++++
 5 files changed, 246 insertions(+), 184 deletions(-)
 create mode 100644 target/riscv/vector_internals.c
 create mode 100644 target/riscv/vector_internals.h

diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index f2e3d38515..4106bd6994 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -1643,38 +1643,40 @@ GEN_OPIWX_WIDEN_TRANS(vwadd_wx)
 GEN_OPIWX_WIDEN_TRANS(vwsubu_wx)
 GEN_OPIWX_WIDEN_TRANS(vwsub_wx)
 
+static bool opivv_trans(uint32_t vd, uint32_t vs1, uint32_t vs2, uint32_t vm,
+                        gen_helper_gvec_4_ptr *fn, DisasContext *s)
+{
+    uint32_t data = 0;
+    TCGLabel *over = gen_new_label();
+    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
+    tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
+
+    data = FIELD_DP32(data, VDATA, VM, vm);
+    data = FIELD_DP32(data, VDATA, LMUL, s->lmul);
+    data = FIELD_DP32(data, VDATA, VTA, s->vta);
+    data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);
+    data = FIELD_DP32(data, VDATA, VMA, s->vma);
+    tcg_gen_gvec_4_ptr(vreg_ofs(s, vd), vreg_ofs(s, 0), vreg_ofs(s, vs1),
+                       vreg_ofs(s, vs2), cpu_env, s->cfg_ptr->vlen / 8,
+                       s->cfg_ptr->vlen / 8, data, fn);
+    mark_vs_dirty(s);
+    gen_set_label(over);
+    return true;
+}
+
 /* Vector Integer Add-with-Carry / Subtract-with-Borrow Instructions */
 /* OPIVV without GVEC IR */
-#define GEN_OPIVV_TRANS(NAME, CHECK)                               \
-static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
-{                                                                  \
-    if (CHECK(s, a)) {                                             \
-        uint32_t data = 0;                                         \
-        static gen_helper_gvec_4_ptr * const fns[4] = {            \
-            gen_helper_##NAME##_b, gen_helper_##NAME##_h,          \
-            gen_helper_##NAME##_w, gen_helper_##NAME##_d,          \
-        };                                                         \
-        TCGLabel *over = gen_new_label();                          \
-        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
-        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
-                                                                   \
-        data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
-        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);             \
-        data = FIELD_DP32(data, VDATA, VTA, s->vta);               \
-        data =                                                     \
-            FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);\
-        data = FIELD_DP32(data, VDATA, VMA, s->vma);               \
-        tcg_gen_gvec_4_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),     \
-                           vreg_ofs(s, a->rs1),                    \
-                           vreg_ofs(s, a->rs2), cpu_env,           \
-                           s->cfg_ptr->vlen / 8,                   \
-                           s->cfg_ptr->vlen / 8, data,             \
-                           fns[s->sew]);                           \
-        mark_vs_dirty(s);                                          \
-        gen_set_label(over);                                       \
-        return true;                                               \
-    }                                                              \
-    return false;                                                  \
+#define GEN_OPIVV_TRANS(NAME, CHECK)                                     \
+static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                   \
+{                                                                        \
+    if (CHECK(s, a)) {                                                   \
+        static gen_helper_gvec_4_ptr * const fns[4] = {                  \
+            gen_helper_##NAME##_b, gen_helper_##NAME##_h,                \
+            gen_helper_##NAME##_w, gen_helper_##NAME##_d,                \
+        };                                                               \
+        return opivv_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s);\
+    }                                                                    \
+    return false;                                                        \
 }
 
 /*
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index 5dee37a242..a94fc3f598 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -16,6 +16,7 @@ riscv_ss.add(files(
   'gdbstub.c',
   'op_helper.c',
   'vector_helper.c',
+  'vector_internals.c',
   'bitmanip_helper.c',
   'translate.c',
   'm128_helper.c',
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index 2423affe37..f0e8ceff80 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -26,6 +26,7 @@
 #include "fpu/softfloat.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "internals.h"
+#include "vector_internals.h"
 #include <math.h>
 
 target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
@@ -75,68 +76,6 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
     return vl;
 }
 
-/*
- * Note that vector data is stored in host-endian 64-bit chunks,
- * so addressing units smaller than that needs a host-endian fixup.
- */
-#if HOST_BIG_ENDIAN
-#define H1(x)   ((x) ^ 7)
-#define H1_2(x) ((x) ^ 6)
-#define H1_4(x) ((x) ^ 4)
-#define H2(x)   ((x) ^ 3)
-#define H4(x)   ((x) ^ 1)
-#define H8(x)   ((x))
-#else
-#define H1(x)   (x)
-#define H1_2(x) (x)
-#define H1_4(x) (x)
-#define H2(x)   (x)
-#define H4(x)   (x)
-#define H8(x)   (x)
-#endif
-
-static inline uint32_t vext_nf(uint32_t desc)
-{
-    return FIELD_EX32(simd_data(desc), VDATA, NF);
-}
-
-static inline uint32_t vext_vm(uint32_t desc)
-{
-    return FIELD_EX32(simd_data(desc), VDATA, VM);
-}
-
-/*
- * Encode LMUL to lmul as following:
- *     LMUL    vlmul    lmul
- *      1       000       0
- *      2       001       1
- *      4       010       2
- *      8       011       3
- *      -       100       -
- *     1/8      101      -3
- *     1/4      110      -2
- *     1/2      111      -1
- */
-static inline int32_t vext_lmul(uint32_t desc)
-{
-    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
-}
-
-static inline uint32_t vext_vta(uint32_t desc)
-{
-    return FIELD_EX32(simd_data(desc), VDATA, VTA);
-}
-
-static inline uint32_t vext_vma(uint32_t desc)
-{
-    return FIELD_EX32(simd_data(desc), VDATA, VMA);
-}
-
-static inline uint32_t vext_vta_all_1s(uint32_t desc)
-{
-    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
-}
-
 /*
  * Get the maximum number of elements can be operated.
  *
@@ -155,21 +94,6 @@ static inline uint32_t vext_max_elems(uint32_t desc, uint32_t log2_esz)
     return scale < 0 ? vlenb >> -scale : vlenb << scale;
 }
 
-/*
- * Get number of total elements, including prestart, body and tail elements.
- * Note that when LMUL < 1, the tail includes the elements past VLMAX that
- * are held in the same vector register.
- */
-static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t desc,
-                                            uint32_t esz)
-{
-    uint32_t vlenb = simd_maxsz(desc);
-    uint32_t sew = 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
-    int8_t emul = ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
-                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
-    return (vlenb << emul) / esz;
-}
-
 static inline target_ulong adjust_addr(CPURISCVState *env, target_ulong addr)
 {
     return (addr & env->cur_pmmask) | env->cur_pmbase;
@@ -202,20 +126,6 @@ static void probe_pages(CPURISCVState *env, target_ulong addr,
     }
 }
 
-/* set agnostic elements to 1s */
-static void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
-                              uint32_t tot)
-{
-    if (is_agnostic == 0) {
-        /* policy undisturbed */
-        return;
-    }
-    if (tot - cnt == 0) {
-        return;
-    }
-    memset(base + cnt, -1, tot - cnt);
-}
-
 static inline void vext_set_elem_mask(void *v0, int index,
                                       uint8_t value)
 {
@@ -225,18 +135,6 @@ static inline void vext_set_elem_mask(void *v0, int index,
     ((uint64_t *)v0)[idx] = deposit64(old, pos, 1, value);
 }
 
-/*
- * Earlier designs (pre-0.9) had a varying number of bits
- * per mask value (MLEN). In the 0.9 design, MLEN=1.
- * (Section 4.5)
- */
-static inline int vext_elem_mask(void *v0, int index)
-{
-    int idx = index / 64;
-    int pos = index  % 64;
-    return (((uint64_t *)v0)[idx] >> pos) & 1;
-}
-
 /* elements operations for load and store */
 typedef void vext_ldst_elem_fn(CPURISCVState *env, target_ulong addr,
                                uint32_t idx, void *vd, uintptr_t retaddr);
@@ -739,18 +637,11 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
  *** Vector Integer Arithmetic Instructions
  */
 
-/* expand macro args before macro */
-#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
-
 /* (TD, T1, T2, TX1, TX2) */
 #define OP_SSS_B int8_t, int8_t, int8_t, int8_t, int8_t
 #define OP_SSS_H int16_t, int16_t, int16_t, int16_t, int16_t
 #define OP_SSS_W int32_t, int32_t, int32_t, int32_t, int32_t
 #define OP_SSS_D int64_t, int64_t, int64_t, int64_t, int64_t
-#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
-#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
-#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
-#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
 #define OP_SUS_B int8_t, uint8_t, int8_t, uint8_t, int8_t
 #define OP_SUS_H int16_t, uint16_t, int16_t, uint16_t, int16_t
 #define OP_SUS_W int32_t, uint32_t, int32_t, uint32_t, int32_t
@@ -774,16 +665,6 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
 #define NOP_UUU_H uint16_t, uint16_t, uint32_t, uint16_t, uint32_t
 #define NOP_UUU_W uint32_t, uint32_t, uint64_t, uint32_t, uint64_t
 
-/* operation of two vector elements */
-typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
-
-#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
-static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
-{                                                               \
-    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
-    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
-    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
-}
 #define DO_SUB(N, M) (N - M)
 #define DO_RSUB(N, M) (M - N)
 
@@ -796,40 +677,6 @@ RVVCALL(OPIVV2, vsub_vv_h, OP_SSS_H, H2, H2, H2, DO_SUB)
 RVVCALL(OPIVV2, vsub_vv_w, OP_SSS_W, H4, H4, H4, DO_SUB)
 RVVCALL(OPIVV2, vsub_vv_d, OP_SSS_D, H8, H8, H8, DO_SUB)
 
-static void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
-                       CPURISCVState *env, uint32_t desc,
-                       opivv2_fn *fn, uint32_t esz)
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
-        fn(vd, vs1, vs2, i);
-    }
-    env->vstart = 0;
-    /* set tail elements to 1s */
-    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
-}
-
-/* generate the helpers for OPIVV */
-#define GEN_VEXT_VV(NAME, ESZ)                            \
-void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
-                  void *vs2, CPURISCVState *env,          \
-                  uint32_t desc)                          \
-{                                                         \
-    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
-               do_##NAME, ESZ);                           \
-}
-
 GEN_VEXT_VV(vadd_vv_b, 1)
 GEN_VEXT_VV(vadd_vv_h, 2)
 GEN_VEXT_VV(vadd_vv_w, 4)
diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_internals.c
new file mode 100644
index 0000000000..95efaa79cb
--- /dev/null
+++ b/target/riscv/vector_internals.c
@@ -0,0 +1,57 @@
+/*
+ * RISC-V Vector Extension Internals
+ *
+ * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "vector_internals.h"
+
+/* set agnostic elements to 1s */
+void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
+                       uint32_t tot)
+{
+    if (is_agnostic == 0) {
+        /* policy undisturbed */
+        return;
+    }
+    if (tot - cnt == 0) {
+        return ;
+    }
+    memset(base + cnt, -1, tot - cnt);
+}
+
+void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivv2_fn *fn, uint32_t esz)
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
+        fn(vd, vs1, vs2, i);
+    }
+    env->vstart = 0;
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
+}
diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
new file mode 100644
index 0000000000..a04b7321fb
--- /dev/null
+++ b/target/riscv/vector_internals.h
@@ -0,0 +1,155 @@
+/*
+ * RISC-V Vector Extension Internals
+ *
+ * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef TARGET_RISCV_VECTOR_INTERNALS_H
+#define TARGET_RISCV_VECTOR_INTERNALS_H
+
+#include "qemu/osdep.h"
+#include "qemu/bitops.h"
+#include "cpu.h"
+#include "tcg/tcg-gvec-desc.h"
+#include "internals.h"
+
+static inline uint32_t vext_nf(uint32_t desc)
+{
+    return FIELD_EX32(simd_data(desc), VDATA, NF);
+}
+
+/*
+ * Note that vector data is stored in host-endian 64-bit chunks,
+ * so addressing units smaller than that needs a host-endian fixup.
+ */
+#if HOST_BIG_ENDIAN
+#define H1(x)   ((x) ^ 7)
+#define H1_2(x) ((x) ^ 6)
+#define H1_4(x) ((x) ^ 4)
+#define H2(x)   ((x) ^ 3)
+#define H4(x)   ((x) ^ 1)
+#define H8(x)   ((x))
+#else
+#define H1(x)   (x)
+#define H1_2(x) (x)
+#define H1_4(x) (x)
+#define H2(x)   (x)
+#define H4(x)   (x)
+#define H8(x)   (x)
+#endif
+
+/*
+ * Encode LMUL to lmul as following:
+ *     LMUL    vlmul    lmul
+ *      1       000       0
+ *      2       001       1
+ *      4       010       2
+ *      8       011       3
+ *      -       100       -
+ *     1/8      101      -3
+ *     1/4      110      -2
+ *     1/2      111      -1
+ */
+static inline int32_t vext_lmul(uint32_t desc)
+{
+    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
+}
+
+static inline uint32_t vext_vm(uint32_t desc)
+{
+    return FIELD_EX32(simd_data(desc), VDATA, VM);
+}
+
+static inline uint32_t vext_vma(uint32_t desc)
+{
+    return FIELD_EX32(simd_data(desc), VDATA, VMA);
+}
+
+static inline uint32_t vext_vta(uint32_t desc)
+{
+    return FIELD_EX32(simd_data(desc), VDATA, VTA);
+}
+
+static inline uint32_t vext_vta_all_1s(uint32_t desc)
+{
+    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
+}
+
+/*
+ * Earlier designs (pre-0.9) had a varying number of bits
+ * per mask value (MLEN). In the 0.9 design, MLEN=1.
+ * (Section 4.5)
+ */
+static inline int vext_elem_mask(void *v0, int index)
+{
+    int idx = index / 64;
+    int pos = index  % 64;
+    return (((uint64_t *)v0)[idx] >> pos) & 1;
+}
+
+/*
+ * Get number of total elements, including prestart, body and tail elements.
+ * Note that when LMUL < 1, the tail includes the elements past VLMAX that
+ * are held in the same vector register.
+ */
+static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t desc,
+                                            uint32_t esz)
+{
+    uint32_t vlenb = simd_maxsz(desc);
+    uint32_t sew = 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
+    int8_t emul = ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
+                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
+    return (vlenb << emul) / esz;
+}
+
+/* set agnostic elements to 1s */
+void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
+                       uint32_t tot);
+
+/* expand macro args before macro */
+#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
+
+/* (TD, T1, T2, TX1, TX2) */
+#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
+#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
+#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
+#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
+
+/* operation of two vector elements */
+typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
+
+#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
+static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
+{                                                               \
+    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
+    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
+    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
+}
+
+void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivv2_fn *fn, uint32_t esz);
+
+/* generate the helpers for OPIVV */
+#define GEN_VEXT_VV(NAME, ESZ)                            \
+void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
+                  void *vs2, CPURISCVState *env,          \
+                  uint32_t desc)                          \
+{                                                         \
+    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
+               do_##NAME, ESZ);                           \
+}
+
+#endif /* TARGET_RISCV_VECTOR_INTERNALS_H */
-- 
2.39.2


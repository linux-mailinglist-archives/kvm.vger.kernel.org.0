Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF28E687E7A
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBBNUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjBBNUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:20:04 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1358F24C
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:20:01 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvF-004Q6t-1v; Thu, 02 Feb 2023 12:42:37 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        William Salmon <will.salmon@codethink.co.uk>
Subject: [PATCH 07/39] target/riscv: Add vbrev8.v decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:41:58 +0000
Message-Id: <20230202124230.295997-8-lawrence.hunter@codethink.co.uk>
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

From: William Salmon <will.salmon@codethink.co.uk>

Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
---
 include/qemu/bitops.h                      | 32 +++++++++++++++++
 target/riscv/helper.h                      |  5 +++
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc | 39 ++++++++++++++++++++
 target/riscv/vcrypto_helper.c              | 10 ++++++
 target/riscv/vector_helper.c               | 41 ---------------------
 target/riscv/vector_internals.h            | 42 ++++++++++++++++++++++
 7 files changed, 129 insertions(+), 41 deletions(-)

diff --git a/include/qemu/bitops.h b/include/qemu/bitops.h
index 03213ce952..dfce1cb10c 100644
--- a/include/qemu/bitops.h
+++ b/include/qemu/bitops.h
@@ -618,4 +618,36 @@ static inline uint64_t half_unshuffle64(uint64_t x)
     return x;
 }
 
+static inline uint8_t reverse_bits_byte(uint8_t x)
+{
+    x = (((x & 0b10101010) >> 1) | ((x & 0b01010101) << 1));
+    x = (((x & 0b11001100) >> 2) | ((x & 0b00110011) << 2));
+    return ((x & 0b11110000) >> 4) | ((x & 0b00001111) << 4);
+}
+
+static inline uint16_t reverse_bits_byte_2(uint16_t x)
+{
+    return (uint16_t)reverse_bits_byte(x & 0xFF) | \
+       (uint16_t)reverse_bits_byte((x >> 8) & 0xFF) << 8;
+}
+
+static inline uint32_t reverse_bits_byte_4(uint32_t x)
+{
+    return (uint32_t)reverse_bits_byte(x & 0xFF) | \
+       (uint32_t)reverse_bits_byte((x >> 8) & 0xFF) << 8 | \
+       (uint32_t)reverse_bits_byte((x >> 16) & 0xFF) << 16 | \
+       (uint32_t)reverse_bits_byte((x >> 24) & 0xFF) << 24;
+}
+
+static inline uint64_t reverse_bits_byte_8(uint64_t x)
+{
+    return (uint64_t)reverse_bits_byte(x & 0xFF) | \
+       (uint64_t)reverse_bits_byte((x >> 8) & 0xFF) << 8 | \
+       (uint64_t)reverse_bits_byte((x >> 16) & 0xFF) << 16 | \
+       (uint64_t)reverse_bits_byte((x >> 24) & 0xFF) << 24 | \
+       (uint64_t)reverse_bits_byte((x >> 32) & 0xFF) << 32 | \
+       (uint64_t)reverse_bits_byte((x >> 40) & 0xFF) << 40 | \
+       (uint64_t)reverse_bits_byte((x >> 48) & 0xFF) << 48 | \
+       (uint64_t)reverse_bits_byte((x >> 56) & 0xFF) << 56;
+}
 #endif
diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index e5b6b3360f..c94627d8a4 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1162,3 +1162,8 @@ DEF_HELPER_6(vrol_vx_b, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 725f907ad1..782632a165 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -902,3 +902,4 @@ vror_vv         010100 . ..... ..... 000 ..... 1010111 @r_vm
 vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
 vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
 vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
+vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index d2a7a92d42..591980459a 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -115,3 +115,42 @@ static bool trans_vror_vi2(DisasContext *s, arg_rmrr *a)
     a->rs1 += 32;
     return trans_vror_vi(s, a);
 }
+
+#define GEN_OPIV_TRANS(NAME, CHECK)                                    \
+static bool trans_##NAME(DisasContext *s, arg_rmr * a)                 \
+{                                                                      \
+    if (CHECK(s, a)) {                                                 \
+        uint32_t data = 0;                                             \
+        static gen_helper_gvec_3_ptr * const fns[4] = {                \
+            gen_helper_##NAME##_b,                                     \
+            gen_helper_##NAME##_h,                                     \
+            gen_helper_##NAME##_w,                                     \
+            gen_helper_##NAME##_d,                                     \
+        };                                                             \
+        TCGLabel *over = gen_new_label();                              \
+        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);              \
+        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
+                                                                       \
+        data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
+        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
+        data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
+        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
+        data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
+        tcg_gen_gvec_3_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),         \
+                           vreg_ofs(s, a->rs2), cpu_env,               \
+                           s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, \
+                           data, fns[s->sew]);                         \
+        mark_vs_dirty(s);                                              \
+        gen_set_label(over);                                           \
+        return true;                                                   \
+    }                                                                  \
+    return false;                                                      \
+}
+
+static bool vxrev8_check(DisasContext *s, arg_rmr *a)
+{
+    return s->cfg_ptr->ext_zvkb == true && vext_check_isa_ill(s) &&
+           vext_check_ss(s, a->rd, a->rs2, a->vm);
+}
+
+GEN_OPIV_TRANS(vbrev8_v, vxrev8_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 7ec75c5589..303a656141 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -1,6 +1,7 @@
 #include "qemu/osdep.h"
 #include "qemu/host-utils.h"
 #include "qemu/bitops.h"
+#include "qemu/bswap.h"
 #include "cpu.h"
 #include "exec/memop.h"
 #include "exec/exec-all.h"
@@ -115,3 +116,12 @@ GEN_VEXT_VX(vrol_vx_b, 1)
 GEN_VEXT_VX(vrol_vx_h, 2)
 GEN_VEXT_VX(vrol_vx_w, 4)
 GEN_VEXT_VX(vrol_vx_d, 8)
+
+RVVCALL(OPIVV1, vbrev8_v_b, OP_UU_B, H1, H1, reverse_bits_byte)
+RVVCALL(OPIVV1, vbrev8_v_h, OP_UU_H, H2, H2, reverse_bits_byte_2)
+RVVCALL(OPIVV1, vbrev8_v_w, OP_UU_W, H4, H4, reverse_bits_byte_4)
+RVVCALL(OPIVV1, vbrev8_v_d, OP_UU_D, H8, H8, reverse_bits_byte_8)
+GEN_VEXT_V(vbrev8_v_b, 1)
+GEN_VEXT_V(vbrev8_v_h, 2)
+GEN_VEXT_V(vbrev8_v_w, 4)
+GEN_VEXT_V(vbrev8_v_d, 8)
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index ff7b03cbe3..07da4b5e16 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -3437,12 +3437,6 @@ RVVCALL(OPFVF3, vfwnmsac_vf_w, WOP_UUU_W, H8, H4, fwnmsac32)
 GEN_VEXT_VF(vfwnmsac_vf_h, 4)
 GEN_VEXT_VF(vfwnmsac_vf_w, 8)
 
-/* Vector Floating-Point Square-Root Instruction */
-/* (TD, T2, TX2) */
-#define OP_UU_H uint16_t, uint16_t, uint16_t
-#define OP_UU_W uint32_t, uint32_t, uint32_t
-#define OP_UU_D uint64_t, uint64_t, uint64_t
-
 #define OPFVV1(NAME, TD, T2, TX2, HD, HS2, OP)        \
 static void do_##NAME(void *vd, void *vs2, int i,      \
         CPURISCVState *env)                            \
@@ -4134,41 +4128,6 @@ GEN_VEXT_CMP_VF(vmfge_vf_h, uint16_t, H2, vmfge16)
 GEN_VEXT_CMP_VF(vmfge_vf_w, uint32_t, H4, vmfge32)
 GEN_VEXT_CMP_VF(vmfge_vf_d, uint64_t, H8, vmfge64)
 
-/* Vector Floating-Point Classify Instruction */
-#define OPIVV1(NAME, TD, T2, TX2, HD, HS2, OP)         \
-static void do_##NAME(void *vd, void *vs2, int i)      \
-{                                                      \
-    TX2 s2 = *((T2 *)vs2 + HS2(i));                    \
-    *((TD *)vd + HD(i)) = OP(s2);                      \
-}
-
-#define GEN_VEXT_V(NAME, ESZ)                          \
-void HELPER(NAME)(void *vd, void *v0, void *vs2,       \
-                  CPURISCVState *env, uint32_t desc)   \
-{                                                      \
-    uint32_t vm = vext_vm(desc);                       \
-    uint32_t vl = env->vl;                             \
-    uint32_t total_elems =                             \
-        vext_get_total_elems(env, desc, ESZ);          \
-    uint32_t vta = vext_vta(desc);                     \
-    uint32_t vma = vext_vma(desc);                     \
-    uint32_t i;                                        \
-                                                       \
-    for (i = env->vstart; i < vl; i++) {               \
-        if (!vm && !vext_elem_mask(v0, i)) {           \
-            /* set masked-off elements to 1s */        \
-            vext_set_elems_1s(vd, vma, i * ESZ,        \
-                              (i + 1) * ESZ);          \
-            continue;                                  \
-        }                                              \
-        do_##NAME(vd, vs2, i);                         \
-    }                                                  \
-    env->vstart = 0;                                   \
-    /* set tail elements to 1s */                      \
-    vext_set_elems_1s(vd, vta, vl * ESZ,               \
-                      total_elems * ESZ);              \
-}
-
 target_ulong fclass_h(uint64_t frs1)
 {
     float16 f = frs1;
diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
index a0fbac7bf3..f1f16453dc 100644
--- a/target/riscv/vector_internals.h
+++ b/target/riscv/vector_internals.h
@@ -123,12 +123,54 @@ void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
 /* expand macro args before macro */
 #define RVVCALL(macro, ...)  macro(__VA_ARGS__)
 
+/* Vector Floating-Point Square-Root Instruction */
+/* (TD, T2, TX2) */
+#define OP_UU_B uint8_t, uint8_t, uint8_t
+#define OP_UU_H uint16_t, uint16_t, uint16_t
+#define OP_UU_W uint32_t, uint32_t, uint32_t
+#define OP_UU_D uint64_t, uint64_t, uint64_t
+
 /* (TD, T1, T2, TX1, TX2) */
 #define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
 #define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
 #define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
 #define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
 
+/* Vector Floating-Point Classify Instruction */
+#define OPIVV1(NAME, TD, T2, TX2, HD, HS2, OP)         \
+static void do_##NAME(void *vd, void *vs2, int i)      \
+{                                                      \
+    TX2 s2 = *((T2 *)vs2 + HS2(i));                    \
+    *((TD *)vd + HD(i)) = OP(s2);                      \
+}
+
+#define GEN_VEXT_V(NAME, ESZ)                          \
+void HELPER(NAME)(void *vd, void *v0, void *vs2,       \
+                  CPURISCVState *env, uint32_t desc)   \
+{                                                      \
+    uint32_t vm = vext_vm(desc);                       \
+    uint32_t vl = env->vl;                             \
+    uint32_t total_elems =                             \
+        vext_get_total_elems(env, desc, ESZ);          \
+    uint32_t vta = vext_vta(desc);                     \
+    uint32_t vma = vext_vma(desc);                     \
+    uint32_t i;                                        \
+                                                       \
+    for (i = env->vstart; i < vl; i++) {               \
+        if (!vm && !vext_elem_mask(v0, i)) {           \
+            /* set masked-off elements to 1s */        \
+            vext_set_elems_1s(vd, vma, i * ESZ,        \
+                              (i + 1) * ESZ);          \
+            continue;                                  \
+        }                                              \
+        do_##NAME(vd, vs2, i);                         \
+    }                                                  \
+    env->vstart = 0;                                   \
+    /* set tail elements to 1s */                      \
+    vext_set_elems_1s(vd, vta, vl * ESZ,               \
+                      total_elems * ESZ);              \
+}
+
 /* operation of two vector elements */
 typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
 
-- 
2.39.1


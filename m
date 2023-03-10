Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738326B4C00
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCJQGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjCJQFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:55 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814D3A676B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:05 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDl-00H4ad-Ng; Fri, 10 Mar 2023 16:03:53 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 17/45] target/riscv: Add vaesef.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:18 +0000
Message-Id: <20230310160346.1193597-18-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                        |  3 +
 target/riscv/insn32.decode                   |  4 ++
 target/riscv/insn_trans/trans_rvzvkned.c.inc | 72 +++++++++++++++++++
 target/riscv/op_helper.c                     |  5 ++
 target/riscv/translate.c                     |  1 +
 target/riscv/vcrypto_helper.c                | 73 ++++++++++++++++++++
 6 files changed, 158 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkned.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 1bc10ca5be..a402bb5d40 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1,5 +1,6 @@
 /* Exceptions */
 DEF_HELPER_2(raise_exception, noreturn, env, i32)
+DEF_HELPER_2(restore_cpu_and_raise_exception, noreturn, env, i32)
 
 /* Floating Point - rounding mode */
 DEF_HELPER_FLAGS_2(set_rounding_mode, TCG_CALL_NO_WG, void, env, i32)
@@ -1186,3 +1187,5 @@ DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index bbf128e4dc..f68025755a 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -75,6 +75,7 @@
 @r_rm    .......   ..... ..... ... ..... ....... %rs2 %rs1 %rm %rd
 @r2_rm   .......   ..... ..... ... ..... ....... %rs1 %rm %rd
 @r2      .......   ..... ..... ... ..... ....... &r2 %rs1 %rd
+@r2_vm_1 ...... . ..... ..... ... ..... ....... &rmr vm=1 %rs2 %rd
 @r2_nfvm ... ... vm:1 ..... ..... ... ..... ....... &r2nfvm %nf %rs1 %rd
 @r2_vm   ...... vm:1 ..... ..... ... ..... ....... &rmr %rs2 %rd
 @r1_vm   ...... vm:1 ..... ..... ... ..... ....... %rd
@@ -925,3 +926,6 @@ vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
 vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
 vandn_vv        000001 . ..... ..... 000 ..... 1010111 @r_vm
 vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
+
+# *** RV64 Zvkned vector crypto extension ***
+vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkned.c.inc b/target/riscv/insn_trans/trans_rvzvkned.c.inc
new file mode 100644
index 0000000000..6f3d62bef1
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvkned.c.inc
@@ -0,0 +1,72 @@
+/*
+ * RISC-V translation routines for the Zvkned Extension.
+ *
+ * Copyright (C) 2023 SiFive, Inc.
+ * Written by Codethink Ltd and SiFive.
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
+#define GEN_V_UNMASKED_TRANS(NAME, CHECK)                                 \
+static bool trans_##NAME(DisasContext *s, arg_##NAME * a)                 \
+{                                                                         \
+    if (CHECK(s, a)) {                                                    \
+        TCGv_ptr rd_v, rs2_v;                                             \
+        TCGv_i32 desc;                                                    \
+        uint32_t data = 0;                                                \
+        TCGLabel *over = gen_new_label();                                 \
+        TCGLabel *vl_ok = gen_new_label();                                \
+        TCGv_i32 tmp = tcg_temp_new_i32();                                \
+                                                                          \
+        /* save opcode for unwinding in case we throw an exception */     \
+        decode_save_opc(s);                                               \
+                                                                          \
+        /* check (vl % 4 == 0) */                                         \
+        tcg_gen_trunc_tl_i32(tmp, cpu_vl);                                \
+        tcg_gen_andi_i32(tmp, tmp, 0b11);                                 \
+        tcg_gen_brcondi_i32(TCG_COND_EQ, tmp, 0, vl_ok);                  \
+        gen_helper_restore_cpu_and_raise_exception(cpu_env,               \
+            tcg_constant_i32(RISCV_EXCP_ILLEGAL_INST));                   \
+        gen_set_label(vl_ok);                                             \
+                                                                          \
+        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);        \
+        data = FIELD_DP32(data, VDATA, VM, a->vm);                        \
+        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                    \
+        data = FIELD_DP32(data, VDATA, VTA, s->vta);                      \
+        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);    \
+        data = FIELD_DP32(data, VDATA, VMA, s->vma);                      \
+        rd_v = tcg_temp_new_ptr();                                        \
+        rs2_v = tcg_temp_new_ptr();                                       \
+        desc = tcg_constant_i32(simd_desc(s->cfg_ptr->vlen / 8,           \
+                                          s->cfg_ptr->vlen / 8, data));   \
+        tcg_gen_addi_ptr(rd_v, cpu_env, vreg_ofs(s, a->rd));              \
+        tcg_gen_addi_ptr(rs2_v, cpu_env, vreg_ofs(s, a->rs2));            \
+        gen_helper_##NAME(rd_v, rs2_v, cpu_env, desc);                    \
+        mark_vs_dirty(s);                                                 \
+        gen_set_label(over);                                              \
+        return true;                                                      \
+    }                                                                     \
+    return false;                                                         \
+}
+
+
+static bool vaes_check_vv(DisasContext *s, arg_rmr *a)
+{
+    return s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           MAXSZ(s) >= (128 / 8) && /* EGW in bytes */
+           require_align(a->rd, s->lmul) &&
+           require_align(a->rs2, s->lmul) &&
+           s->vstart % 4 == 0 && s->sew == MO_32;
+}
+GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
diff --git a/target/riscv/op_helper.c b/target/riscv/op_helper.c
index 84ee018f7d..f26c6396a5 100644
--- a/target/riscv/op_helper.c
+++ b/target/riscv/op_helper.c
@@ -38,6 +38,11 @@ void helper_raise_exception(CPURISCVState *env, uint32_t exception)
     riscv_raise_exception(env, exception, 0);
 }
 
+void helper_restore_cpu_and_raise_exception(CPURISCVState *env, uint32_t exception)
+{
+    riscv_raise_exception(env, exception, GETPC());
+}
+
 target_ulong helper_csrr(CPURISCVState *env, int csr)
 {
     /*
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 939f5aeb1c..e3561b0bbd 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1084,6 +1084,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzfh.c.inc"
 #include "insn_trans/trans_rvk.c.inc"
 #include "insn_trans/trans_rvzvkb.c.inc"
+#include "insn_trans/trans_rvzvkned.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "decode-xthead.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 7d2a355418..bb5ce5b50a 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -22,6 +22,7 @@
 #include "qemu/bitops.h"
 #include "qemu/bswap.h"
 #include "cpu.h"
+#include "crypto/aes.h"
 #include "exec/memop.h"
 #include "exec/exec-all.h"
 #include "exec/helper-proto.h"
@@ -144,3 +145,75 @@ GEN_VEXT_VX(vandn_vx_b, 1)
 GEN_VEXT_VX(vandn_vx_h, 2)
 GEN_VEXT_VX(vandn_vx_w, 4)
 GEN_VEXT_VX(vandn_vx_d, 8)
+
+static inline void aes_sub_bytes(uint8_t round_state[4][4])
+{
+    for (int j = 0; j < 16; j++) {
+        round_state[j / 4][j % 4] = AES_sbox[round_state[j / 4][j % 4]];
+    }
+}
+
+static inline void aes_shift_bytes(uint8_t round_state[4][4])
+{
+    uint8_t temp;
+    temp = round_state[0][1];
+    round_state[0][1] = round_state[1][1];
+    round_state[1][1] = round_state[2][1];
+    round_state[2][1] = round_state[3][1];
+    round_state[3][1] = temp;
+    temp = round_state[0][2];
+    round_state[0][2] = round_state[2][2];
+    round_state[2][2] = temp;
+    temp = round_state[1][2];
+    round_state[1][2] = round_state[3][2];
+    round_state[3][2] = temp;
+    temp = round_state[0][3];
+    round_state[0][3] = round_state[3][3];
+    round_state[3][3] = round_state[2][3];
+    round_state[2][3] = round_state[1][3];
+    round_state[1][3] = temp;
+}
+
+static inline void xor_round_key(uint8_t round_state[4][4], uint8_t *round_key)
+{
+    for (int j = 0; j < 16; j++) {
+        round_state[j / 4][j % 4] = round_state[j / 4][j % 4] ^ (round_key)[j];
+    }
+}
+
+#define GEN_ZVKNED_HELPER_VV(NAME, ...)                                   \
+void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,      \
+                  uint32_t desc)                                          \
+{                                                                         \
+    uint64_t *vd = vd_vptr;                                               \
+    uint64_t *vs2 = vs2_vptr;                                             \
+    uint32_t vl = env->vl;                                                \
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);            \
+    uint32_t vta = vext_vta(desc);                                        \
+                                                                          \
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {            \
+        uint64_t round_key[2] = {                                         \
+            cpu_to_le64(vs2[i * 2 + 0]),                                  \
+            cpu_to_le64(vs2[i * 2 + 1]),                                  \
+        };                                                                \
+        uint8_t round_state[4][4];                                        \
+        cpu_to_le64s(vd + i * 2 + 0);                                     \
+        cpu_to_le64s(vd + i * 2 + 1);                                     \
+        for (int j = 0; j < 16; j++) {                                    \
+            round_state[j / 4][j % 4] = ((uint8_t *)(vd + i * 2))[j];     \
+        }                                                                 \
+        __VA_ARGS__;                                                      \
+        for (int j = 0; j < 16; j++) {                                    \
+            ((uint8_t *)(vd + i * 2))[j] = round_state[j / 4][j % 4];     \
+        }                                                                 \
+        le64_to_cpus(vd + i * 2 + 0);                                     \
+        le64_to_cpus(vd + i * 2 + 1);                                     \
+    }                                                                     \
+    env->vstart = 0;                                                      \
+    /* set tail elements to 1s */                                         \
+    vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);                  \
+}
+
+GEN_ZVKNED_HELPER_VV(vaesef_vv, aes_sub_bytes(round_state);
+                    aes_shift_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
-- 
2.39.2


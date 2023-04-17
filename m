Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BF6E4A74
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjDQN7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjDQN7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:59:06 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0CA7D8B
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:58:55 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1poPNP-0034ER-Ag; Mon, 17 Apr 2023 14:58:39 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        William Salmon <will.salmon@codethink.co.uk>
Subject: [PATCH v2 10/17] target/riscv: Add Zvkned ISA extension support
Date:   Mon, 17 Apr 2023 14:58:14 +0100
Message-Id: <20230417135821.609964-11-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

This commit adds support for the Zvkned vector-crypto extension, which
consists of the following instructions:

* vaesef.[vv,vs]
* vaesdf.[vv,vs]
* vaesdm.[vv,vs]
* vaesz.vs
* vaesem.[vv,vs]
* vaeskf1.vi
* vaeskf2.vi

Translation functions are defined in
`target/riscv/insn_trans/trans_rvvk.c.inc` and helpers are defined in
`target/riscv/vcrypto_helper.c`.

Co-authored-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Co-authored-by: William Salmon <will.salmon@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 target/riscv/cpu.c                       |   6 +-
 target/riscv/cpu.h                       |   1 +
 target/riscv/helper.h                    |  13 +
 target/riscv/insn32.decode               |  14 ++
 target/riscv/insn_trans/trans_rvvk.c.inc | 163 ++++++++++++
 target/riscv/op_helper.c                 |   6 +
 target/riscv/vcrypto_helper.c            | 308 +++++++++++++++++++++++
 7 files changed, 509 insertions(+), 2 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index b1f37898d62..54d27301bce 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -111,6 +111,7 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zvfhmin, true, PRIV_VERSION_1_12_0, ext_zvfhmin),
     ISA_EXT_DATA_ENTRY(zvbb, true, PRIV_VERSION_1_12_0, ext_zvbb),
     ISA_EXT_DATA_ENTRY(zvbc, true, PRIV_VERSION_1_12_0, ext_zvbc),
+    ISA_EXT_DATA_ENTRY(zvkned, true, PRIV_VERSION_1_12_0, ext_zvkned),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
     ISA_EXT_DATA_ENTRY(smaia, true, PRIV_VERSION_1_12_0, ext_smaia),
@@ -1217,8 +1218,9 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
      * In principle Zve*x would also suffice here, were they supported
      * in qemu
      */
-    if (cpu->cfg.ext_zvbb && !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f ||
-                               cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
+    if ((cpu->cfg.ext_zvbb || cpu->cfg.ext_zvkned) &&
+        !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d ||
+          cpu->cfg.ext_v)) {
         error_setg(errp,
                    "Vector crypto extensions require V or Zve* extensions");
         return;
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index e173ca8d86b..0d6c216572e 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -472,6 +472,7 @@ struct RISCVCPUConfig {
     bool ext_zve64d;
     bool ext_zvbb;
     bool ext_zvbc;
+    bool ext_zvkned;
     bool ext_zmmul;
     bool ext_zvfh;
     bool ext_zvfhmin;
diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 27767075232..db629cf6a89 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1,5 +1,6 @@
 /* Exceptions */
 DEF_HELPER_2(raise_exception, noreturn, env, i32)
+DEF_HELPER_2(restore_cpu_and_raise_exception, noreturn, env, i32)
 
 /* Floating Point - rounding mode */
 DEF_HELPER_FLAGS_2(set_rounding_mode, TCG_CALL_NO_WG, void, env, i32)
@@ -1210,3 +1211,15 @@ DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesem_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesem_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_5(vaeskf1_vi, void, ptr, ptr, i32, env, i32)
+DEF_HELPER_5(vaeskf2_vi, void, ptr, ptr, i32, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index aa6d3185a20..7e0295d4935 100644
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
@@ -934,3 +935,16 @@ vcpop_v     010010 . ..... 01110 010 ..... 1010111 @r2_vm
 vwsll_vv    110101 . ..... ..... 000 ..... 1010111 @r_vm
 vwsll_vx    110101 . ..... ..... 100 ..... 1010111 @r_vm
 vwsll_vi    110101 . ..... ..... 011 ..... 1010111 @r_vm
+
+# *** Zvkned vector crypto extension ***
+vaesef_vv   101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
+vaesef_vs   101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
+vaesdf_vv   101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
+vaesdf_vs   101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
+vaesem_vv   101000 1 ..... 00010 010 ..... 1110111 @r2_vm_1
+vaesem_vs   101001 1 ..... 00010 010 ..... 1110111 @r2_vm_1
+vaesdm_vv   101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
+vaesdm_vs   101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
+vaesz_vs    101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
+vaeskf1_vi  100010 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vaeskf2_vi  101010 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvvk.c.inc b/target/riscv/insn_trans/trans_rvvk.c.inc
index d54c21c5f7e..9a36a731e5e 100644
--- a/target/riscv/insn_trans/trans_rvvk.c.inc
+++ b/target/riscv/insn_trans/trans_rvvk.c.inc
@@ -274,3 +274,166 @@ static bool vwsll_vx_check(DisasContext *s, arg_rmrr *a)
 GEN_OPIVV_WIDEN_TRANS(vwsll_vv, vwsll_vv_check)
 GEN_OPIVX_WIDEN_TRANS(vwsll_vx, vwsll_vx_check)
 GEN_OPIVI_WIDEN_TRANS(vwsll_vi, IMM_ZX, vwsll_vx, vwsll_vx_check)
+
+/*
+ * Zvkned
+ */
+
+#define ZVKNED_EGS 4
+
+#define GEN_V_UNMASKED_TRANS(NAME, CHECK)                                     \
+    static bool trans_##NAME(DisasContext *s, arg_##NAME *a)                  \
+    {                                                                         \
+        if (CHECK(s, a)) {                                                    \
+            TCGv_ptr rd_v, rs2_v;                                             \
+            TCGv_i32 desc;                                                    \
+            uint32_t data = 0;                                                \
+            TCGLabel *over = gen_new_label();                                 \
+            TCGLabel *vl_ok = gen_new_label();                                \
+            TCGv_i32 tmp = tcg_temp_new_i32();                                \
+                                                                              \
+            /* save opcode for unwinding in case we throw an exception */     \
+            decode_save_opc(s);                                               \
+                                                                              \
+            /* check (vl % 4 == 0) */                                         \
+            tcg_gen_trunc_tl_i32(tmp, cpu_vl);                                \
+            tcg_gen_andi_i32(tmp, tmp, 0b11);                                 \
+            tcg_gen_brcondi_i32(TCG_COND_EQ, tmp, 0, vl_ok);                  \
+            gen_helper_restore_cpu_and_raise_exception(                       \
+                cpu_env, tcg_constant_i32(RISCV_EXCP_ILLEGAL_INST));          \
+            gen_set_label(vl_ok);                                             \
+                                                                              \
+            tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);        \
+            data = FIELD_DP32(data, VDATA, VM, a->vm);                        \
+            data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                    \
+            data = FIELD_DP32(data, VDATA, VTA, s->vta);                      \
+            data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);    \
+            data = FIELD_DP32(data, VDATA, VMA, s->vma);                      \
+            rd_v = tcg_temp_new_ptr();                                        \
+            rs2_v = tcg_temp_new_ptr();                                       \
+            desc = tcg_constant_i32(                                          \
+                simd_desc(s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, data)); \
+            tcg_gen_addi_ptr(rd_v, cpu_env, vreg_ofs(s, a->rd));              \
+            tcg_gen_addi_ptr(rs2_v, cpu_env, vreg_ofs(s, a->rs2));            \
+            gen_helper_##NAME(rd_v, rs2_v, cpu_env, desc);                    \
+            mark_vs_dirty(s);                                                 \
+            gen_set_label(over);                                              \
+            return true;                                                      \
+        }                                                                     \
+        return false;                                                         \
+    }
+
+static bool vaes_check_vv(DisasContext *s, arg_rmr *a)
+{
+    int egw_bytes = ZVKNED_EGS << s->sew;
+    return s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           MAXSZ(s) >= egw_bytes &&
+           require_align(a->rd, s->lmul) &&
+           require_align(a->rs2, s->lmul) &&
+           s->vstart % ZVKNED_EGS == 0 &&
+           s->sew == MO_32;
+}
+
+static bool vaes_check_overlap(DisasContext *s, int vd, int vs2)
+{
+    int8_t op_size = s->lmul <= 0 ? 1 : 1 << s->lmul;
+    return !is_overlapped(vd, op_size, vs2, 1);
+}
+
+static bool vaes_check_vs(DisasContext *s, arg_rmr *a)
+{
+    int egw_bytes = ZVKNED_EGS << s->sew;
+    return vaes_check_overlap(s, a->rd, a->rs2) &&
+           MAXSZ(s) >= egw_bytes &&
+           s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           require_align(a->rd, s->lmul) &&
+           s->vstart % ZVKNED_EGS == 0 &&
+           s->sew == MO_32;
+}
+
+GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesef_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesdf_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesdm_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesz_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesem_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesem_vs, vaes_check_vs)
+
+#define GEN_VI_UNMASKED_TRANS(NAME, CHECK, VL_MULTIPLE)                       \
+    static bool trans_##NAME(DisasContext *s, arg_##NAME *a)                  \
+    {                                                                         \
+        if (CHECK(s, a)) {                                                    \
+            TCGv_ptr rd_v, rs2_v;                                             \
+            TCGv_i32 uimm_v, desc;                                            \
+            uint32_t data = 0;                                                \
+            TCGLabel *over = gen_new_label();                                 \
+            TCGLabel *vl_ok = gen_new_label();                                \
+            TCGv_i32 tmp = tcg_temp_new_i32();                                \
+                                                                              \
+            /* save opcode for unwinding in case we throw an exception */     \
+            decode_save_opc(s);                                               \
+                                                                              \
+            /* check (vl % VL_MULTIPLE == 0) assuming it's power of 2 */      \
+            tcg_gen_trunc_tl_i32(tmp, cpu_vl);                                \
+            tcg_gen_andi_i32(tmp, tmp, VL_MULTIPLE - 1);                      \
+            tcg_gen_brcondi_i32(TCG_COND_EQ, tmp, 0, vl_ok);                  \
+            gen_helper_restore_cpu_and_raise_exception(                       \
+                cpu_env, tcg_constant_i32(RISCV_EXCP_ILLEGAL_INST));          \
+            gen_set_label(vl_ok);                                             \
+                                                                              \
+            tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);        \
+            data = FIELD_DP32(data, VDATA, VM, a->vm);                        \
+            data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                    \
+            data = FIELD_DP32(data, VDATA, VTA, s->vta);                      \
+            data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);    \
+            data = FIELD_DP32(data, VDATA, VMA, s->vma);                      \
+                                                                              \
+            rd_v = tcg_temp_new_ptr();                                        \
+            rs2_v = tcg_temp_new_ptr();                                       \
+            uimm_v = tcg_constant_i32(a->rs1);                                \
+            desc = tcg_constant_i32(                                          \
+                simd_desc(s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, data)); \
+            tcg_gen_addi_ptr(rd_v, cpu_env, vreg_ofs(s, a->rd));              \
+            tcg_gen_addi_ptr(rs2_v, cpu_env, vreg_ofs(s, a->rs2));            \
+            gen_helper_##NAME(rd_v, rs2_v, uimm_v, cpu_env, desc);            \
+            mark_vs_dirty(s);                                                 \
+            gen_set_label(over);                                              \
+            return true;                                                      \
+        }                                                                     \
+        return false;                                                         \
+    }
+
+static bool vaeskf1_check(DisasContext *s, arg_vaeskf1_vi *a)
+{
+    int egw_bytes = ZVKNED_EGS << s->sew;
+    return s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           MAXSZ(s) >= egw_bytes &&
+           s->vstart % ZVKNED_EGS == 0 &&
+           s->sew == MO_32 &&
+           require_align(a->rd, s->lmul) &&
+           require_align(a->rs2, s->lmul);
+}
+
+static bool vaeskf2_check(DisasContext *s, arg_vaeskf2_vi *a)
+{
+    int egw_bytes = ZVKNED_EGS << s->sew;
+    return s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           MAXSZ(s) >= egw_bytes &&
+           s->vstart % ZVKNED_EGS == 0 &&
+           s->sew == MO_32 &&
+           require_align(a->rd, s->lmul) &&
+           require_align(a->rs2, s->lmul);
+}
+
+GEN_VI_UNMASKED_TRANS(vaeskf1_vi, vaeskf1_check, ZVKNED_EGS)
+GEN_VI_UNMASKED_TRANS(vaeskf2_vi, vaeskf2_check, ZVKNED_EGS)
diff --git a/target/riscv/op_helper.c b/target/riscv/op_helper.c
index 84ee018f7d1..0c94490fb46 100644
--- a/target/riscv/op_helper.c
+++ b/target/riscv/op_helper.c
@@ -38,6 +38,12 @@ void helper_raise_exception(CPURISCVState *env, uint32_t exception)
     riscv_raise_exception(env, exception, 0);
 }
 
+void helper_restore_cpu_and_raise_exception(CPURISCVState *env,
+                                            uint32_t exception)
+{
+    riscv_raise_exception(env, exception, GETPC());
+}
+
 target_ulong helper_csrr(CPURISCVState *env, int csr)
 {
     /*
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 11239b59d6f..0988eb74c81 100644
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
@@ -195,3 +196,310 @@ RVVCALL(OPIVX2, vwsll_vx_w, WOP_UUU_W, H8, H4, DO_SLL)
 GEN_VEXT_VX(vwsll_vx_b, 2)
 GEN_VEXT_VX(vwsll_vx_h, 4)
 GEN_VEXT_VX(vwsll_vx_w, 8)
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
+static inline void aes_inv_sub_bytes(uint8_t round_state[4][4])
+{
+    for (int j = 0; j < 16; j++) {
+        round_state[j / 4][j % 4] = AES_isbox[round_state[j / 4][j % 4]];
+    }
+}
+
+static inline void aes_inv_shift_bytes(uint8_t round_state[4][4])
+{
+    uint8_t temp;
+    temp = round_state[3][1];
+    round_state[3][1] = round_state[2][1];
+    round_state[2][1] = round_state[1][1];
+    round_state[1][1] = round_state[0][1];
+    round_state[0][1] = temp;
+    temp = round_state[0][2];
+    round_state[0][2] = round_state[2][2];
+    round_state[2][2] = temp;
+    temp = round_state[1][2];
+    round_state[1][2] = round_state[3][2];
+    round_state[3][2] = temp;
+    temp = round_state[0][3];
+    round_state[0][3] = round_state[1][3];
+    round_state[1][3] = round_state[2][3];
+    round_state[2][3] = round_state[3][3];
+    round_state[3][3] = temp;
+}
+
+static inline uint8_t xtime(uint8_t x)
+{
+    return (x << 1) ^ (((x >> 7) & 1) * 0x1b);
+}
+
+static inline uint8_t multiply(uint8_t x, uint8_t y)
+{
+    return (((y & 1) * x) ^ ((y >> 1 & 1) * xtime(x)) ^
+            ((y >> 2 & 1) * xtime(xtime(x))) ^
+            ((y >> 3 & 1) * xtime(xtime(xtime(x)))) ^
+            ((y >> 4 & 1) * xtime(xtime(xtime(xtime(x))))));
+}
+
+static inline void aes_inv_mix_cols(uint8_t round_state[4][4])
+{
+    uint8_t a, b, c, d;
+    for (int j = 0; j < 4; ++j) {
+        a = round_state[j][0];
+        b = round_state[j][1];
+        c = round_state[j][2];
+        d = round_state[j][3];
+        round_state[j][0] = multiply(a, 0x0e) ^ multiply(b, 0x0b) ^
+                            multiply(c, 0x0d) ^ multiply(d, 0x09);
+        round_state[j][1] = multiply(a, 0x09) ^ multiply(b, 0x0e) ^
+                            multiply(c, 0x0b) ^ multiply(d, 0x0d);
+        round_state[j][2] = multiply(a, 0x0d) ^ multiply(b, 0x09) ^
+                            multiply(c, 0x0e) ^ multiply(d, 0x0b);
+        round_state[j][3] = multiply(a, 0x0b) ^ multiply(b, 0x0d) ^
+                            multiply(c, 0x09) ^ multiply(d, 0x0e);
+    }
+}
+
+static inline void aes_mix_cols(uint8_t round_state[4][4])
+{
+    uint8_t a, b;
+    for (int j = 0; j < 4; ++j) {
+        a = round_state[j][0];
+        b = round_state[j][0] ^ round_state[j][1] ^ round_state[j][2] ^
+            round_state[j][3];
+        round_state[j][0] ^= xtime(round_state[j][0] ^ round_state[j][1]) ^ b;
+        round_state[j][1] ^= xtime(round_state[j][1] ^ round_state[j][2]) ^ b;
+        round_state[j][2] ^= xtime(round_state[j][2] ^ round_state[j][3]) ^ b;
+        round_state[j][3] ^= xtime(round_state[j][3] ^ a) ^ b;
+    }
+}
+
+#define GEN_ZVKNED_HELPER_VV(NAME, ...)                                   \
+    void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,  \
+                      uint32_t desc)                                      \
+    {                                                                     \
+        uint64_t *vd = vd_vptr;                                           \
+        uint64_t *vs2 = vs2_vptr;                                         \
+        uint32_t vl = env->vl;                                            \
+        uint32_t total_elems = vext_get_total_elems(env, desc, 4);        \
+        uint32_t vta = vext_vta(desc);                                    \
+                                                                          \
+        for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {        \
+            uint64_t round_key[2] = {                                     \
+                cpu_to_le64(vs2[i * 2 + 0]),                              \
+                cpu_to_le64(vs2[i * 2 + 1]),                              \
+            };                                                            \
+            uint8_t round_state[4][4];                                    \
+            cpu_to_le64s(vd + i * 2 + 0);                                 \
+            cpu_to_le64s(vd + i * 2 + 1);                                 \
+            for (int j = 0; j < 16; j++) {                                \
+                round_state[j / 4][j % 4] = ((uint8_t *)(vd + i * 2))[j]; \
+            }                                                             \
+            __VA_ARGS__;                                                  \
+            for (int j = 0; j < 16; j++) {                                \
+                ((uint8_t *)(vd + i * 2))[j] = round_state[j / 4][j % 4]; \
+            }                                                             \
+            le64_to_cpus(vd + i * 2 + 0);                                 \
+            le64_to_cpus(vd + i * 2 + 1);                                 \
+        }                                                                 \
+        env->vstart = 0;                                                  \
+        /* set tail elements to 1s */                                     \
+        vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);              \
+    }
+
+#define GEN_ZVKNED_HELPER_VS(NAME, ...)                                   \
+    void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,  \
+                      uint32_t desc)                                      \
+    {                                                                     \
+        uint64_t *vd = vd_vptr;                                           \
+        uint64_t *vs2 = vs2_vptr;                                         \
+        uint32_t vl = env->vl;                                            \
+        uint32_t total_elems = vext_get_total_elems(env, desc, 4);        \
+        uint32_t vta = vext_vta(desc);                                    \
+                                                                          \
+        for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {        \
+            uint64_t round_key[2] = {                                     \
+                cpu_to_le64(vs2[0]),                                      \
+                cpu_to_le64(vs2[1]),                                      \
+            };                                                            \
+            uint8_t round_state[4][4];                                    \
+            cpu_to_le64s(vd + i * 2 + 0);                                 \
+            cpu_to_le64s(vd + i * 2 + 1);                                 \
+            for (int j = 0; j < 16; j++) {                                \
+                round_state[j / 4][j % 4] = ((uint8_t *)(vd + i * 2))[j]; \
+            }                                                             \
+            __VA_ARGS__;                                                  \
+            for (int j = 0; j < 16; j++) {                                \
+                ((uint8_t *)(vd + i * 2))[j] = round_state[j / 4][j % 4]; \
+            }                                                             \
+            le64_to_cpus(vd + i * 2 + 0);                                 \
+            le64_to_cpus(vd + i * 2 + 1);                                 \
+        }                                                                 \
+        env->vstart = 0;                                                  \
+        /* set tail elements to 1s */                                     \
+        vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);              \
+    }
+
+GEN_ZVKNED_HELPER_VV(vaesef_vv, aes_sub_bytes(round_state);
+                     aes_shift_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VS(vaesef_vs, aes_sub_bytes(round_state);
+                     aes_shift_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VV(vaesdf_vv, aes_inv_shift_bytes(round_state);
+                     aes_inv_sub_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VS(vaesdf_vs, aes_inv_shift_bytes(round_state);
+                     aes_inv_sub_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VV(vaesem_vv, aes_shift_bytes(round_state);
+                     aes_sub_bytes(round_state); aes_mix_cols(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VS(vaesem_vs, aes_shift_bytes(round_state);
+                     aes_sub_bytes(round_state); aes_mix_cols(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VV(vaesdm_vv, aes_inv_shift_bytes(round_state);
+                     aes_inv_sub_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);
+                     aes_inv_mix_cols(round_state);)
+GEN_ZVKNED_HELPER_VS(vaesdm_vs, aes_inv_shift_bytes(round_state);
+                     aes_inv_sub_bytes(round_state);
+                     xor_round_key(round_state, (uint8_t *)round_key);
+                     aes_inv_mix_cols(round_state);)
+GEN_ZVKNED_HELPER_VS(vaesz_vs,
+                     xor_round_key(round_state, (uint8_t *)round_key);)
+
+void HELPER(vaeskf1_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
+                        CPURISCVState *env, uint32_t desc)
+{
+    uint32_t *vd = vd_vptr;
+    uint32_t *vs2 = vs2_vptr;
+    uint32_t vl = env->vl;
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);
+    uint32_t vta = vext_vta(desc);
+
+    uimm &= 0b1111;
+    if (uimm > 10 || uimm == 0) {
+        uimm ^= 0b1000;
+    }
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        uint32_t rk[8];
+        static const uint32_t rcon[] = {
+            0x01000000, 0x02000000, 0x04000000, 0x08000000, 0x10000000,
+            0x20000000, 0x40000000, 0x80000000, 0x1B000000, 0x36000000,
+        };
+
+        rk[0] = bswap32(vs2[i * 4 + H4(0)]);
+        rk[1] = bswap32(vs2[i * 4 + H4(1)]);
+        rk[2] = bswap32(vs2[i * 4 + H4(2)]);
+        rk[3] = bswap32(vs2[i * 4 + H4(3)]);
+
+        rk[4] = rk[0] ^ (AES_Te4[(rk[3] >> 16) & 0xff] & 0xff000000) ^
+                (AES_Te4[(rk[3] >> 8) & 0xff] & 0x00ff0000) ^
+                (AES_Te4[(rk[3] >> 0) & 0xff] & 0x0000ff00) ^
+                (AES_Te4[(rk[3] >> 24) & 0xff] & 0x000000ff) ^ rcon[uimm - 1];
+        rk[5] = rk[1] ^ rk[4];
+        rk[6] = rk[2] ^ rk[5];
+        rk[7] = rk[3] ^ rk[6];
+
+        vd[i * 4 + H4(0)] = bswap32(rk[4]);
+        vd[i * 4 + H4(1)] = bswap32(rk[5]);
+        vd[i * 4 + H4(2)] = bswap32(rk[6]);
+        vd[i * 4 + H4(3)] = bswap32(rk[7]);
+    }
+    env->vstart = 0;
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);
+}
+
+void HELPER(vaeskf2_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
+                        CPURISCVState *env, uint32_t desc)
+{
+    uint32_t *vd = vd_vptr;
+    uint32_t *vs2 = vs2_vptr;
+    uint32_t vl = env->vl;
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);
+    uint32_t vta = vext_vta(desc);
+
+    uimm &= 0b1111;
+    if (uimm > 14 || uimm < 2) {
+        uimm ^= 0b1000;
+    }
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        uint32_t rk[12];
+        static const uint32_t rcon[] = {
+            0x01000000, 0x02000000, 0x04000000, 0x08000000, 0x10000000,
+            0x20000000, 0x40000000, 0x80000000, 0x1B000000, 0x36000000,
+        };
+
+        rk[0] = bswap32(vd[i * 4 + H4(0)]);
+        rk[1] = bswap32(vd[i * 4 + H4(1)]);
+        rk[2] = bswap32(vd[i * 4 + H4(2)]);
+        rk[3] = bswap32(vd[i * 4 + H4(3)]);
+        rk[4] = bswap32(vs2[i * 4 + H4(0)]);
+        rk[5] = bswap32(vs2[i * 4 + H4(1)]);
+        rk[6] = bswap32(vs2[i * 4 + H4(2)]);
+        rk[7] = bswap32(vs2[i * 4 + H4(3)]);
+
+        if (uimm % 2 == 0) {
+            rk[8] = rk[0] ^ (AES_Te4[(rk[7] >> 16) & 0xff] & 0xff000000) ^
+                    (AES_Te4[(rk[7] >> 8) & 0xff] & 0x00ff0000) ^
+                    (AES_Te4[(rk[7] >> 0) & 0xff] & 0x0000ff00) ^
+                    (AES_Te4[(rk[7] >> 24) & 0xff] & 0x000000ff) ^
+                    rcon[(uimm - 1) / 2];
+            rk[9] = rk[1] ^ rk[8];
+            rk[10] = rk[2] ^ rk[9];
+            rk[11] = rk[3] ^ rk[10];
+        } else {
+            rk[8] = rk[0] ^ (AES_Te4[(rk[7] >> 24) & 0xff] & 0xff000000) ^
+                    (AES_Te4[(rk[7] >> 16) & 0xff] & 0x00ff0000) ^
+                    (AES_Te4[(rk[7] >> 8) & 0xff] & 0x0000ff00) ^
+                    (AES_Te4[(rk[7] >> 0) & 0xff] & 0x000000ff);
+            rk[9] = rk[1] ^ rk[8];
+            rk[10] = rk[2] ^ rk[9];
+            rk[11] = rk[3] ^ rk[10];
+        }
+
+        vd[i * 4 + H4(0)] = bswap32(rk[8]);
+        vd[i * 4 + H4(1)] = bswap32(rk[9]);
+        vd[i * 4 + H4(2)] = bswap32(rk[10]);
+        vd[i * 4 + H4(3)] = bswap32(rk[11]);
+    }
+    env->vstart = 0;
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);
+}
-- 
2.40.0


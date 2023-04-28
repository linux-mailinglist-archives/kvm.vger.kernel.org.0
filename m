Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329F36F1B7E
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbjD1P1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346414AbjD1P1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:27:13 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F81FFF
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:27:00 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPOO-005zz5-Gh; Fri, 28 Apr 2023 15:48:12 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org,
        William Salmon <will.salmon@codethink.co.uk>
Subject: [PATCH v3 11/19] target/riscv: Add Zvbb ISA extension support
Date:   Fri, 28 Apr 2023 15:47:49 +0100
Message-Id: <20230428144757.57530-12-lawrence.hunter@codethink.co.uk>
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

This commit adds support for the Zvbb vector-crypto extension, which
consists of the following instructions:

* vrol.[vv,vx]
* vror.[vv,vx,vi]
* vbrev8.v
* vrev8.v
* vandn.[vv,vx]
* vbrev.v
* vclz.v
* vctz.v
* vcpop.v
* vwsll.[vv,vx,vi]

Translation functions are defined in
`target/riscv/insn_trans/trans_rvvk.c.inc` and helpers are defined in
`target/riscv/vcrypto_helper.c`.

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Co-authored-by: William Salmon <will.salmon@codethink.co.uk>
Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: Dickon Hood <dickon.hood@codethink.co.uk>
---
 target/riscv/cpu.c                       |  12 ++
 target/riscv/cpu.h                       |   1 +
 target/riscv/helper.h                    |  62 +++++++++
 target/riscv/insn32.decode               |  20 +++
 target/riscv/insn_trans/trans_rvv.c.inc  |   3 +
 target/riscv/insn_trans/trans_rvvk.c.inc | 164 +++++++++++++++++++++++
 target/riscv/vcrypto_helper.c            | 138 +++++++++++++++++++
 7 files changed, 400 insertions(+)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 9f935d944db..b1f37898d62 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -109,6 +109,7 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zve64d, true, PRIV_VERSION_1_12_0, ext_zve64d),
     ISA_EXT_DATA_ENTRY(zvfh, true, PRIV_VERSION_1_12_0, ext_zvfh),
     ISA_EXT_DATA_ENTRY(zvfhmin, true, PRIV_VERSION_1_12_0, ext_zvfhmin),
+    ISA_EXT_DATA_ENTRY(zvbb, true, PRIV_VERSION_1_12_0, ext_zvbb),
     ISA_EXT_DATA_ENTRY(zvbc, true, PRIV_VERSION_1_12_0, ext_zvbc),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
@@ -1212,6 +1213,17 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    /*
+     * In principle Zve*x would also suffice here, were they supported
+     * in qemu
+     */
+    if (cpu->cfg.ext_zvbb && !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f ||
+                               cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
+        error_setg(errp,
+                   "Vector crypto extensions require V or Zve* extensions");
+        return;
+    }
+
     if (cpu->cfg.ext_zvbc &&
         !(cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
         error_setg(errp, "Zvbc extension requires V or Zve64{f,d} extensions");
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index d4915626110..e173ca8d86b 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -470,6 +470,7 @@ struct RISCVCPUConfig {
     bool ext_zve32f;
     bool ext_zve64f;
     bool ext_zve64d;
+    bool ext_zvbb;
     bool ext_zvbc;
     bool ext_zmmul;
     bool ext_zvfh;
diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 37f2e162f6a..27767075232 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1148,3 +1148,65 @@ DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
 DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
 DEF_HELPER_6(vclmulh_vx, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_6(vror_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vror_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vror_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vror_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_6(vror_vx_b, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vror_vx_h, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vror_vx_w, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vror_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_6(vrol_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vrol_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vrol_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vrol_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_6(vrol_vx_b, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_5(vrev8_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_d, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vbrev_v_d, void, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_5(vclz_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vclz_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vclz_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vclz_v_d, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vctz_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vctz_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vctz_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vctz_v_d, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vcpop_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vcpop_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vcpop_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vcpop_v_d, void, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_6(vwsll_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vwsll_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vwsll_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vwsll_vx_b, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vwsll_vx_h, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vwsll_vx_w, void, ptr, ptr, tl, ptr, env, i32)
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
index 52cd92e262e..aa6d3185a20 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -37,6 +37,7 @@
 %imm_u    12:s20                 !function=ex_shift_12
 %imm_bs   30:2                   !function=ex_shift_3
 %imm_rnum 20:4
+%imm_z6   26:1 15:5
 
 # Argument sets:
 &empty
@@ -82,6 +83,7 @@
 @r_vm    ...... vm:1 ..... ..... ... ..... ....... &rmrr %rs2 %rs1 %rd
 @r_vm_1  ...... . ..... ..... ... ..... .......    &rmrr vm=1 %rs2 %rs1 %rd
 @r_vm_0  ...... . ..... ..... ... ..... .......    &rmrr vm=0 %rs2 %rs1 %rd
+@r2_zimm6  ..... . vm:1 ..... ..... ... ..... .......  &rmrr %rs2 rs1=%imm_z6 %rd
 @r2_zimm11 . zimm:11  ..... ... ..... ....... %rs1 %rd
 @r2_zimm10 .. zimm:10  ..... ... ..... ....... %rs1 %rd
 @r2_s    .......   ..... ..... ... ..... ....... %rs2 %rs1
@@ -914,3 +916,21 @@ vclmul_vv   001100 . ..... ..... 010 ..... 1010111 @r_vm
 vclmul_vx   001100 . ..... ..... 110 ..... 1010111 @r_vm
 vclmulh_vv  001101 . ..... ..... 010 ..... 1010111 @r_vm
 vclmulh_vx  001101 . ..... ..... 110 ..... 1010111 @r_vm
+
+# *** Zvbb vector crypto extension ***
+vrol_vv     010101 . ..... ..... 000 ..... 1010111 @r_vm
+vrol_vx     010101 . ..... ..... 100 ..... 1010111 @r_vm
+vror_vv     010100 . ..... ..... 000 ..... 1010111 @r_vm
+vror_vx     010100 . ..... ..... 100 ..... 1010111 @r_vm
+vror_vi     01010. . ..... ..... 011 ..... 1010111 @r2_zimm6
+vbrev8_v    010010 . ..... 01000 010 ..... 1010111 @r2_vm
+vrev8_v     010010 . ..... 01001 010 ..... 1010111 @r2_vm
+vandn_vv    000001 . ..... ..... 000 ..... 1010111 @r_vm
+vandn_vx    000001 . ..... ..... 100 ..... 1010111 @r_vm
+vbrev_v     010010 . ..... 01010 010 ..... 1010111 @r2_vm
+vclz_v      010010 . ..... 01100 010 ..... 1010111 @r2_vm
+vctz_v      010010 . ..... 01101 010 ..... 1010111 @r2_vm
+vcpop_v     010010 . ..... 01110 010 ..... 1010111 @r2_vm
+vwsll_vv    110101 . ..... ..... 000 ..... 1010111 @r_vm
+vwsll_vx    110101 . ..... ..... 100 ..... 1010111 @r_vm
+vwsll_vi    110101 . ..... ..... 011 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index 2c2a097b76d..329a2d9ab73 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -1368,6 +1368,7 @@ GEN_OPIVX_GVEC_TRANS(vrsub_vx, rsubs)
 typedef enum {
     IMM_ZX,         /* Zero-extended */
     IMM_SX,         /* Sign-extended */
+    IMM_ZIMM6,      /* Truncate to 6 bits */
     IMM_TRUNC_SEW,  /* Truncate to log(SEW) bits */
     IMM_TRUNC_2SEW, /* Truncate to log(2*SEW) bits */
 } imm_mode_t;
@@ -1383,6 +1384,8 @@ static int64_t extract_imm(DisasContext *s, uint32_t imm, imm_mode_t imm_mode)
         return extract64(imm, 0, s->sew + 3);
     case IMM_TRUNC_2SEW:
         return extract64(imm, 0, s->sew + 4);
+    case IMM_ZIMM6:
+        return extract64(imm, 0, 6);
     default:
         g_assert_not_reached();
     }
diff --git a/target/riscv/insn_trans/trans_rvvk.c.inc b/target/riscv/insn_trans/trans_rvvk.c.inc
index 0dcf4d21305..261a4c412d2 100644
--- a/target/riscv/insn_trans/trans_rvvk.c.inc
+++ b/target/riscv/insn_trans/trans_rvvk.c.inc
@@ -86,3 +86,167 @@ static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
 
 GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
 GEN_VX_MASKED_TRANS(vclmulh_vx, vclmul_vx_check)
+
+/*
+ * Zvbb
+ */
+
+#define GEN_OPIVI_GVEC_TRANS_CHECK(NAME, IMM_MODE, OPIVX, SUF, CHECK)   \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)              \
+    {                                                                   \
+        if (CHECK(s, a)) {                                              \
+            static gen_helper_opivx *const fns[4] = {                   \
+                gen_helper_##OPIVX##_b,                                 \
+                gen_helper_##OPIVX##_h,                                 \
+                gen_helper_##OPIVX##_w,                                 \
+                gen_helper_##OPIVX##_d,                                 \
+            };                                                          \
+            return do_opivi_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew], \
+                                 IMM_MODE);                             \
+        }                                                               \
+        return false;                                                   \
+    }
+
+#define GEN_OPIVV_GVEC_TRANS_CHECK(NAME, SUF, CHECK)                     \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)               \
+    {                                                                    \
+        if (CHECK(s, a)) {                                               \
+            static gen_helper_gvec_4_ptr *const fns[4] = {               \
+                gen_helper_##NAME##_b,                                   \
+                gen_helper_##NAME##_h,                                   \
+                gen_helper_##NAME##_w,                                   \
+                gen_helper_##NAME##_d,                                   \
+            };                                                           \
+            return do_opivv_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew]); \
+        }                                                                \
+        return false;                                                    \
+    }
+
+#define GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(NAME, SUF, CHECK)       \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)       \
+    {                                                            \
+        if (CHECK(s, a)) {                                       \
+            static gen_helper_opivx *const fns[4] = {            \
+                gen_helper_##NAME##_b,                           \
+                gen_helper_##NAME##_h,                           \
+                gen_helper_##NAME##_w,                           \
+                gen_helper_##NAME##_d,                           \
+            };                                                   \
+            return do_opivx_gvec_shift(s, a, tcg_gen_gvec_##SUF, \
+                                       fns[s->sew]);             \
+        }                                                        \
+        return false;                                            \
+    }
+
+static bool zvbb_vv_check(DisasContext *s, arg_rmrr *a)
+{
+    return opivv_check(s, a) && s->cfg_ptr->ext_zvbb == true;
+}
+
+static bool zvbb_vx_check(DisasContext *s, arg_rmrr *a)
+{
+    return opivx_check(s, a) && s->cfg_ptr->ext_zvbb == true;
+}
+
+/* vrol.v[vx] */
+GEN_OPIVV_GVEC_TRANS_CHECK(vrol_vv, rotlv, zvbb_vv_check)
+GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(vrol_vx, rotls, zvbb_vx_check)
+
+/* vror.v[vxi] */
+GEN_OPIVV_GVEC_TRANS_CHECK(vror_vv, rotrv, zvbb_vv_check)
+GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(vror_vx, rotrs, zvbb_vx_check)
+GEN_OPIVI_GVEC_TRANS_CHECK(vror_vi, IMM_ZIMM6, vror_vx, rotri, zvbb_vx_check)
+
+#define GEN_OPIVX_GVEC_TRANS_CHECK(NAME, SUF, CHECK)                     \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)               \
+    {                                                                    \
+        if (CHECK(s, a)) {                                               \
+            static gen_helper_opivx *const fns[4] = {                    \
+                gen_helper_##NAME##_b,                                   \
+                gen_helper_##NAME##_h,                                   \
+                gen_helper_##NAME##_w,                                   \
+                gen_helper_##NAME##_d,                                   \
+            };                                                           \
+            return do_opivx_gvec(s, a, tcg_gen_gvec_##SUF, fns[s->sew]); \
+        }                                                                \
+        return false;                                                    \
+    }
+
+/* vandn.v[vx] */
+GEN_OPIVV_GVEC_TRANS_CHECK(vandn_vv, andc, zvbb_vv_check)
+GEN_OPIVX_GVEC_TRANS_CHECK(vandn_vx, andcs, zvbb_vx_check)
+
+#define GEN_OPIV_TRANS(NAME, CHECK)                                        \
+    static bool trans_##NAME(DisasContext *s, arg_rmr *a)                  \
+    {                                                                      \
+        if (CHECK(s, a)) {                                                 \
+            uint32_t data = 0;                                             \
+            static gen_helper_gvec_3_ptr *const fns[4] = {                 \
+                gen_helper_##NAME##_b,                                     \
+                gen_helper_##NAME##_h,                                     \
+                gen_helper_##NAME##_w,                                     \
+                gen_helper_##NAME##_d,                                     \
+            };                                                             \
+            TCGLabel *over = gen_new_label();                              \
+            tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
+                                                                           \
+            data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
+            data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
+            data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
+            data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
+            data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
+            tcg_gen_gvec_3_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),         \
+                               vreg_ofs(s, a->rs2), cpu_env,               \
+                               s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, \
+                               data, fns[s->sew]);                         \
+            mark_vs_dirty(s);                                              \
+            gen_set_label(over);                                           \
+            return true;                                                   \
+        }                                                                  \
+        return false;                                                      \
+    }
+
+static bool zvbb_opiv_check(DisasContext *s, arg_rmr *a)
+{
+    return s->cfg_ptr->ext_zvbb == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           vext_check_ss(s, a->rd, a->rs2, a->vm);
+}
+
+GEN_OPIV_TRANS(vbrev8_v, zvbb_opiv_check)
+GEN_OPIV_TRANS(vrev8_v, zvbb_opiv_check)
+GEN_OPIV_TRANS(vbrev_v, zvbb_opiv_check)
+GEN_OPIV_TRANS(vclz_v, zvbb_opiv_check)
+GEN_OPIV_TRANS(vctz_v, zvbb_opiv_check)
+GEN_OPIV_TRANS(vcpop_v, zvbb_opiv_check)
+
+static bool vwsll_vv_check(DisasContext *s, arg_rmrr *a)
+{
+    return s->cfg_ptr->ext_zvbb && opivv_widen_check(s, a);
+}
+
+static bool vwsll_vx_check(DisasContext *s, arg_rmrr *a)
+{
+    return s->cfg_ptr->ext_zvbb && opivx_widen_check(s, a);
+}
+
+/* OPIVI without GVEC IR */
+#define GEN_OPIVI_WIDEN_TRANS(NAME, IMM_MODE, OPIVX, CHECK)                  \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                   \
+    {                                                                        \
+        if (CHECK(s, a)) {                                                   \
+            static gen_helper_opivx *const fns[3] = {                        \
+                gen_helper_##OPIVX##_b,                                      \
+                gen_helper_##OPIVX##_h,                                      \
+                gen_helper_##OPIVX##_w,                                      \
+            };                                                               \
+            return opivi_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s, \
+                               IMM_MODE);                                    \
+        }                                                                    \
+        return false;                                                        \
+    }
+
+GEN_OPIVV_WIDEN_TRANS(vwsll_vv, vwsll_vv_check)
+GEN_OPIVX_WIDEN_TRANS(vwsll_vx, vwsll_vx_check)
+GEN_OPIVI_WIDEN_TRANS(vwsll_vi, IMM_ZX, vwsll_vx, vwsll_vx_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 8b7c63d4997..11239b59d6f 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/host-utils.h"
 #include "qemu/bitops.h"
+#include "qemu/bswap.h"
 #include "cpu.h"
 #include "exec/memop.h"
 #include "exec/exec-all.h"
@@ -57,3 +58,140 @@ RVVCALL(OPIVV2, vclmulh_vv, OP_UUU_D, H8, H8, H8, clmulh64)
 GEN_VEXT_VV(vclmulh_vv, 8)
 RVVCALL(OPIVX2, vclmulh_vx, OP_UUU_D, H8, H8, clmulh64)
 GEN_VEXT_VX(vclmulh_vx, 8)
+
+RVVCALL(OPIVV2, vror_vv_b, OP_UUU_B, H1, H1, H1, ror8)
+RVVCALL(OPIVV2, vror_vv_h, OP_UUU_H, H2, H2, H2, ror16)
+RVVCALL(OPIVV2, vror_vv_w, OP_UUU_W, H4, H4, H4, ror32)
+RVVCALL(OPIVV2, vror_vv_d, OP_UUU_D, H8, H8, H8, ror64)
+GEN_VEXT_VV(vror_vv_b, 1)
+GEN_VEXT_VV(vror_vv_h, 2)
+GEN_VEXT_VV(vror_vv_w, 4)
+GEN_VEXT_VV(vror_vv_d, 8)
+
+RVVCALL(OPIVX2, vror_vx_b, OP_UUU_B, H1, H1, ror8)
+RVVCALL(OPIVX2, vror_vx_h, OP_UUU_H, H2, H2, ror16)
+RVVCALL(OPIVX2, vror_vx_w, OP_UUU_W, H4, H4, ror32)
+RVVCALL(OPIVX2, vror_vx_d, OP_UUU_D, H8, H8, ror64)
+GEN_VEXT_VX(vror_vx_b, 1)
+GEN_VEXT_VX(vror_vx_h, 2)
+GEN_VEXT_VX(vror_vx_w, 4)
+GEN_VEXT_VX(vror_vx_d, 8)
+
+RVVCALL(OPIVV2, vrol_vv_b, OP_UUU_B, H1, H1, H1, rol8)
+RVVCALL(OPIVV2, vrol_vv_h, OP_UUU_H, H2, H2, H2, rol16)
+RVVCALL(OPIVV2, vrol_vv_w, OP_UUU_W, H4, H4, H4, rol32)
+RVVCALL(OPIVV2, vrol_vv_d, OP_UUU_D, H8, H8, H8, rol64)
+GEN_VEXT_VV(vrol_vv_b, 1)
+GEN_VEXT_VV(vrol_vv_h, 2)
+GEN_VEXT_VV(vrol_vv_w, 4)
+GEN_VEXT_VV(vrol_vv_d, 8)
+
+RVVCALL(OPIVX2, vrol_vx_b, OP_UUU_B, H1, H1, rol8)
+RVVCALL(OPIVX2, vrol_vx_h, OP_UUU_H, H2, H2, rol16)
+RVVCALL(OPIVX2, vrol_vx_w, OP_UUU_W, H4, H4, rol32)
+RVVCALL(OPIVX2, vrol_vx_d, OP_UUU_D, H8, H8, rol64)
+GEN_VEXT_VX(vrol_vx_b, 1)
+GEN_VEXT_VX(vrol_vx_h, 2)
+GEN_VEXT_VX(vrol_vx_w, 4)
+GEN_VEXT_VX(vrol_vx_d, 8)
+
+static uint64_t brev8(uint64_t val)
+{
+    val = ((val & 0x5555555555555555ull) << 1) |
+          ((val & 0xAAAAAAAAAAAAAAAAull) >> 1);
+    val = ((val & 0x3333333333333333ull) << 2) |
+          ((val & 0xCCCCCCCCCCCCCCCCull) >> 2);
+    val = ((val & 0x0F0F0F0F0F0F0F0Full) << 4) |
+          ((val & 0xF0F0F0F0F0F0F0F0ull) >> 4);
+
+    return val;
+}
+
+RVVCALL(OPIVV1, vbrev8_v_b, OP_UU_B, H1, H1, brev8)
+RVVCALL(OPIVV1, vbrev8_v_h, OP_UU_H, H2, H2, brev8)
+RVVCALL(OPIVV1, vbrev8_v_w, OP_UU_W, H4, H4, brev8)
+RVVCALL(OPIVV1, vbrev8_v_d, OP_UU_D, H8, H8, brev8)
+GEN_VEXT_V(vbrev8_v_b, 1)
+GEN_VEXT_V(vbrev8_v_h, 2)
+GEN_VEXT_V(vbrev8_v_w, 4)
+GEN_VEXT_V(vbrev8_v_d, 8)
+
+#define DO_IDENTITY(a) (a)
+RVVCALL(OPIVV1, vrev8_v_b, OP_UU_B, H1, H1, DO_IDENTITY)
+RVVCALL(OPIVV1, vrev8_v_h, OP_UU_H, H2, H2, bswap16)
+RVVCALL(OPIVV1, vrev8_v_w, OP_UU_W, H4, H4, bswap32)
+RVVCALL(OPIVV1, vrev8_v_d, OP_UU_D, H8, H8, bswap64)
+GEN_VEXT_V(vrev8_v_b, 1)
+GEN_VEXT_V(vrev8_v_h, 2)
+GEN_VEXT_V(vrev8_v_w, 4)
+GEN_VEXT_V(vrev8_v_d, 8)
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
+
+RVVCALL(OPIVV1, vbrev_v_b, OP_UU_B, H1, H1, revbit8)
+RVVCALL(OPIVV1, vbrev_v_h, OP_UU_H, H2, H2, revbit16)
+RVVCALL(OPIVV1, vbrev_v_w, OP_UU_W, H4, H4, revbit32)
+RVVCALL(OPIVV1, vbrev_v_d, OP_UU_D, H8, H8, revbit64)
+GEN_VEXT_V(vbrev_v_b, 1)
+GEN_VEXT_V(vbrev_v_h, 2)
+GEN_VEXT_V(vbrev_v_w, 4)
+GEN_VEXT_V(vbrev_v_d, 8)
+
+RVVCALL(OPIVV1, vclz_v_b, OP_UU_B, H1, H1, clz8)
+RVVCALL(OPIVV1, vclz_v_h, OP_UU_H, H2, H2, clz16)
+RVVCALL(OPIVV1, vclz_v_w, OP_UU_W, H4, H4, clz32)
+RVVCALL(OPIVV1, vclz_v_d, OP_UU_D, H8, H8, clz64)
+GEN_VEXT_V(vclz_v_b, 1)
+GEN_VEXT_V(vclz_v_h, 2)
+GEN_VEXT_V(vclz_v_w, 4)
+GEN_VEXT_V(vclz_v_d, 8)
+
+RVVCALL(OPIVV1, vctz_v_b, OP_UU_B, H1, H1, ctz8)
+RVVCALL(OPIVV1, vctz_v_h, OP_UU_H, H2, H2, ctz16)
+RVVCALL(OPIVV1, vctz_v_w, OP_UU_W, H4, H4, ctz32)
+RVVCALL(OPIVV1, vctz_v_d, OP_UU_D, H8, H8, ctz64)
+GEN_VEXT_V(vctz_v_b, 1)
+GEN_VEXT_V(vctz_v_h, 2)
+GEN_VEXT_V(vctz_v_w, 4)
+GEN_VEXT_V(vctz_v_d, 8)
+
+RVVCALL(OPIVV1, vcpop_v_b, OP_UU_B, H1, H1, ctpop8)
+RVVCALL(OPIVV1, vcpop_v_h, OP_UU_H, H2, H2, ctpop16)
+RVVCALL(OPIVV1, vcpop_v_w, OP_UU_W, H4, H4, ctpop32)
+RVVCALL(OPIVV1, vcpop_v_d, OP_UU_D, H8, H8, ctpop64)
+GEN_VEXT_V(vcpop_v_b, 1)
+GEN_VEXT_V(vcpop_v_h, 2)
+GEN_VEXT_V(vcpop_v_w, 4)
+GEN_VEXT_V(vcpop_v_d, 8)
+
+#define DO_SLL(N, M) (N << (M & (sizeof(N) * 8 - 1)))
+RVVCALL(OPIVV2, vwsll_vv_b, WOP_UUU_B, H2, H1, H1, DO_SLL)
+RVVCALL(OPIVV2, vwsll_vv_h, WOP_UUU_H, H4, H2, H2, DO_SLL)
+RVVCALL(OPIVV2, vwsll_vv_w, WOP_UUU_W, H8, H4, H4, DO_SLL)
+GEN_VEXT_VV(vwsll_vv_b, 2)
+GEN_VEXT_VV(vwsll_vv_h, 4)
+GEN_VEXT_VV(vwsll_vv_w, 8)
+
+RVVCALL(OPIVX2, vwsll_vx_b, WOP_UUU_B, H2, H1, DO_SLL)
+RVVCALL(OPIVX2, vwsll_vx_h, WOP_UUU_H, H4, H2, DO_SLL)
+RVVCALL(OPIVX2, vwsll_vx_w, WOP_UUU_W, H8, H4, DO_SLL)
+GEN_VEXT_VX(vwsll_vx_b, 2)
+GEN_VEXT_VX(vwsll_vx_h, 4)
+GEN_VEXT_VX(vwsll_vx_w, 8)
-- 
2.40.1


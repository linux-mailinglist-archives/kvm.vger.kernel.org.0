Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FE26E4A71
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjDQN7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjDQN7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:59:02 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A308576A5
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:58:54 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1poPNP-0034ER-J7; Mon, 17 Apr 2023 14:58:39 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH v2 11/17] target/riscv: Add Zvknh ISA extension support
Date:   Mon, 17 Apr 2023 14:58:15 +0100
Message-Id: <20230417135821.609964-12-lawrence.hunter@codethink.co.uk>
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

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

This commit adds support for the Zvknh vector-crypto extension, which
consists of the following instructions:

* vsha2ms.vv
* vsha2c[hl].vv

Translation functions are defined in
`target/riscv/insn_trans/trans_rvvk.c.inc` and helpers are defined in
`target/riscv/vcrypto_helper.c`.

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Co-authored-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/cpu.c                       |  10 +-
 target/riscv/cpu.h                       |   2 +
 target/riscv/helper.h                    |   4 +
 target/riscv/insn32.decode               |   5 +
 target/riscv/insn_trans/trans_rvvk.c.inc |  70 ++++++++
 target/riscv/vcrypto_helper.c            | 214 +++++++++++++++++++++++
 6 files changed, 302 insertions(+), 3 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 54d27301bce..dd8573bb02f 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -112,6 +112,8 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zvbb, true, PRIV_VERSION_1_12_0, ext_zvbb),
     ISA_EXT_DATA_ENTRY(zvbc, true, PRIV_VERSION_1_12_0, ext_zvbc),
     ISA_EXT_DATA_ENTRY(zvkned, true, PRIV_VERSION_1_12_0, ext_zvkned),
+    ISA_EXT_DATA_ENTRY(zvknha, true, PRIV_VERSION_1_12_0, ext_zvknha),
+    ISA_EXT_DATA_ENTRY(zvknhb, true, PRIV_VERSION_1_12_0, ext_zvknhb),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
     ISA_EXT_DATA_ENTRY(smaia, true, PRIV_VERSION_1_12_0, ext_smaia),
@@ -1218,7 +1220,7 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
      * In principle Zve*x would also suffice here, were they supported
      * in qemu
      */
-    if ((cpu->cfg.ext_zvbb || cpu->cfg.ext_zvkned) &&
+    if ((cpu->cfg.ext_zvbb || cpu->cfg.ext_zvkned || cpu->cfg.ext_zvknha) &&
         !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d ||
           cpu->cfg.ext_v)) {
         error_setg(errp,
@@ -1226,9 +1228,11 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (cpu->cfg.ext_zvbc &&
+    if ((cpu->cfg.ext_zvbc || cpu->cfg.ext_zvknhb) &&
         !(cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
-        error_setg(errp, "Zvbc extension requires V or Zve64{f,d} extensions");
+        error_setg(
+            errp,
+            "Zvbc and Zvknhb extensions require V or Zve64{f,d} extensions");
         return;
     }
 
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 0d6c216572e..4c44088c28b 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -473,6 +473,8 @@ struct RISCVCPUConfig {
     bool ext_zvbb;
     bool ext_zvbc;
     bool ext_zvkned;
+    bool ext_zvknha;
+    bool ext_zvknhb;
     bool ext_zmmul;
     bool ext_zvfh;
     bool ext_zvfhmin;
diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index db629cf6a89..a60129983be 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1223,3 +1223,7 @@ DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_5(vaeskf1_vi, void, ptr, ptr, i32, env, i32)
 DEF_HELPER_5(vaeskf2_vi, void, ptr, ptr, i32, env, i32)
+
+DEF_HELPER_5(vsha2ms_vv, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vsha2ch_vv, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 7e0295d4935..d2cfb2729c2 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -948,3 +948,8 @@ vaesdm_vs   101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesz_vs    101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
 vaeskf1_vi  100010 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vaeskf2_vi  101010 1 ..... ..... 010 ..... 1110111 @r_vm_1
+
+# *** Zvknh vector crypto extension ***
+vsha2ms_vv  101101 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vsha2ch_vv  101110 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vsha2cl_vv  101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvvk.c.inc b/target/riscv/insn_trans/trans_rvvk.c.inc
index 9a36a731e5e..fd4e498b838 100644
--- a/target/riscv/insn_trans/trans_rvvk.c.inc
+++ b/target/riscv/insn_trans/trans_rvvk.c.inc
@@ -437,3 +437,73 @@ static bool vaeskf2_check(DisasContext *s, arg_vaeskf2_vi *a)
 
 GEN_VI_UNMASKED_TRANS(vaeskf1_vi, vaeskf1_check, ZVKNED_EGS)
 GEN_VI_UNMASKED_TRANS(vaeskf2_vi, vaeskf2_check, ZVKNED_EGS)
+
+/*
+ * Zvknh
+ */
+
+#define ZVKNH_EGS 4
+
+#define GEN_VV_UNMASKED_TRANS(NAME, CHECK, VL_MULTIPLE)                    \
+    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                 \
+    {                                                                      \
+        if (CHECK(s, a)) {                                                 \
+            uint32_t data = 0;                                             \
+            TCGLabel *over = gen_new_label();                              \
+            TCGLabel *vl_ok = gen_new_label();                             \
+            TCGv_i32 tmp = tcg_temp_new_i32();                             \
+                                                                           \
+            /* save opcode for unwinding in case we throw an exception */  \
+            decode_save_opc(s);                                            \
+                                                                           \
+            /* check (vl % VL_MULTIPLE == 0) assuming it's power of 2 */   \
+            tcg_gen_trunc_tl_i32(tmp, cpu_vl);                             \
+            tcg_gen_andi_i32(tmp, tmp, VL_MULTIPLE - 1);                   \
+            tcg_gen_brcondi_i32(TCG_COND_EQ, tmp, 0, vl_ok);               \
+            gen_helper_restore_cpu_and_raise_exception(                    \
+                cpu_env, tcg_constant_i32(RISCV_EXCP_ILLEGAL_INST));       \
+            gen_set_label(vl_ok);                                          \
+                                                                           \
+            tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
+                                                                           \
+            data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
+            data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
+            data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
+            data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
+            data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
+                                                                           \
+            tcg_gen_gvec_3_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, a->rs1),    \
+                               vreg_ofs(s, a->rs2), cpu_env,               \
+                               s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, \
+                               data, gen_helper_##NAME);                   \
+                                                                           \
+            mark_vs_dirty(s);                                              \
+            gen_set_label(over);                                           \
+            return true;                                                   \
+        }                                                                  \
+        return false;                                                      \
+    }
+
+static bool vsha_check_sew(DisasContext *s)
+{
+    return (s->cfg_ptr->ext_zvknha == true && s->sew == MO_32) ||
+           (s->cfg_ptr->ext_zvknhb == true &&
+            (s->sew == MO_32 || s->sew == MO_64));
+}
+
+static bool vsha_check(DisasContext *s, arg_rmrr *a)
+{
+    int egw_bytes = ZVKNH_EGS << s->sew;
+    int mult = 1 << MAX(s->lmul, 0);
+    return opivv_check(s, a) &&
+           vsha_check_sew(s) &&
+           MAXSZ(s) >= egw_bytes &&
+           !is_overlapped(a->rd, mult, a->rs1, mult) &&
+           !is_overlapped(a->rd, mult, a->rs2, mult) &&
+           s->vstart % ZVKNH_EGS == 0 &&
+           s->lmul >= 0;
+}
+
+GEN_VV_UNMASKED_TRANS(vsha2ms_vv, vsha_check, ZVKNH_EGS)
+GEN_VV_UNMASKED_TRANS(vsha2cl_vv, vsha_check, ZVKNH_EGS)
+GEN_VV_UNMASKED_TRANS(vsha2ch_vv, vsha_check, ZVKNH_EGS)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 0988eb74c81..ca09062c6c1 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -503,3 +503,217 @@ void HELPER(vaeskf2_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
     /* set tail elements to 1s */
     vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);
 }
+
+static inline uint32_t sig0_sha256(uint32_t x)
+{
+    return ror32(x, 7) ^ ror32(x, 18) ^ (x >> 3);
+}
+
+static inline uint32_t sig1_sha256(uint32_t x)
+{
+    return ror32(x, 17) ^ ror32(x, 19) ^ (x >> 10);
+}
+
+static inline uint64_t sig0_sha512(uint64_t x)
+{
+    return ror64(x, 1) ^ ror64(x, 8) ^ (x >> 7);
+}
+
+static inline uint64_t sig1_sha512(uint64_t x)
+{
+    return ror64(x, 19) ^ ror64(x, 61) ^ (x >> 6);
+}
+
+static inline void vsha2ms_e32(uint32_t *vd, uint32_t *vs1, uint32_t *vs2)
+{
+    uint32_t res[4];
+    res[0] = sig1_sha256(vs1[H4(2)]) + vs2[H4(1)] + sig0_sha256(vd[H4(1)]) +
+             vd[H4(0)];
+    res[1] = sig1_sha256(vs1[H4(3)]) + vs2[H4(2)] + sig0_sha256(vd[H4(2)]) +
+             vd[H4(1)];
+    res[2] =
+        sig1_sha256(res[0]) + vs2[H4(3)] + sig0_sha256(vd[H4(3)]) + vd[H4(2)];
+    res[3] =
+        sig1_sha256(res[1]) + vs1[H4(0)] + sig0_sha256(vs2[H4(0)]) + vd[H4(3)];
+    vd[H4(3)] = res[3];
+    vd[H4(2)] = res[2];
+    vd[H4(1)] = res[1];
+    vd[H4(0)] = res[0];
+}
+
+static inline void vsha2ms_e64(uint64_t *vd, uint64_t *vs1, uint64_t *vs2)
+{
+    uint64_t res[4];
+    res[0] = sig1_sha512(vs1[2]) + vs2[1] + sig0_sha512(vd[1]) + vd[0];
+    res[1] = sig1_sha512(vs1[3]) + vs2[2] + sig0_sha512(vd[2]) + vd[1];
+    res[2] = sig1_sha512(res[0]) + vs2[3] + sig0_sha512(vd[3]) + vd[2];
+    res[3] = sig1_sha512(res[1]) + vs1[0] + sig0_sha512(vs2[0]) + vd[3];
+    vd[3] = res[3];
+    vd[2] = res[2];
+    vd[1] = res[1];
+    vd[0] = res[0];
+}
+
+void HELPER(vsha2ms_vv)(void *vd, void *vs1, void *vs2, CPURISCVState *env,
+                        uint32_t desc)
+{
+    uint32_t sew = FIELD_EX64(env->vtype, VTYPE, VSEW);
+    uint32_t esz = sew == MO_32 ? 4 : 8;
+    uint32_t total_elems;
+    uint32_t vta = vext_vta(desc);
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        if (sew == MO_32) {
+            vsha2ms_e32(((uint32_t *)vd) + i * 4, ((uint32_t *)vs1) + i * 4,
+                        ((uint32_t *)vs2) + i * 4);
+        } else {
+            /* If not 32 then SEW should be 64 */
+            vsha2ms_e64(((uint64_t *)vd) + i * 4, ((uint64_t *)vs1) + i * 4,
+                        ((uint64_t *)vs2) + i * 4);
+        }
+    }
+    /* set tail elements to 1s */
+    total_elems = vext_get_total_elems(env, desc, esz);
+    vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
+
+static inline uint64_t sum0_64(uint64_t x)
+{
+    return ror64(x, 28) ^ ror64(x, 34) ^ ror64(x, 39);
+}
+
+static inline uint32_t sum0_32(uint32_t x)
+{
+    return ror32(x, 2) ^ ror32(x, 13) ^ ror32(x, 22);
+}
+
+static inline uint64_t sum1_64(uint64_t x)
+{
+    return ror64(x, 14) ^ ror64(x, 18) ^ ror64(x, 41);
+}
+
+static inline uint32_t sum1_32(uint32_t x)
+{
+    return ror32(x, 6) ^ ror32(x, 11) ^ ror32(x, 25);
+}
+
+#define ch(x, y, z) ((x & y) ^ ((~x) & z))
+
+#define maj(x, y, z) ((x & y) ^ (x & z) ^ (y & z))
+
+static void vsha2c_64(uint64_t *vs2, uint64_t *vd, uint64_t *vs1)
+{
+    uint64_t a = vs2[3], b = vs2[2], e = vs2[1], f = vs2[0];
+    uint64_t c = vd[3], d = vd[2], g = vd[1], h = vd[0];
+    uint64_t W0 = vs1[0], W1 = vs1[1];
+    uint64_t T1 = h + sum1_64(e) + ch(e, f, g) + W0;
+    uint64_t T2 = sum0_64(a) + maj(a, b, c);
+
+    h = g;
+    g = f;
+    f = e;
+    e = d + T1;
+    d = c;
+    c = b;
+    b = a;
+    a = T1 + T2;
+
+    T1 = h + sum1_64(e) + ch(e, f, g) + W1;
+    T2 = sum0_64(a) + maj(a, b, c);
+    h = g;
+    g = f;
+    f = e;
+    e = d + T1;
+    d = c;
+    c = b;
+    b = a;
+    a = T1 + T2;
+
+    vd[0] = f;
+    vd[1] = e;
+    vd[2] = b;
+    vd[3] = a;
+}
+
+static void vsha2c_32(uint32_t *vs2, uint32_t *vd, uint32_t *vs1)
+{
+    uint32_t a = vs2[H4(3)], b = vs2[H4(2)], e = vs2[H4(1)], f = vs2[H4(0)];
+    uint32_t c = vd[H4(3)], d = vd[H4(2)], g = vd[H4(1)], h = vd[H4(0)];
+    uint32_t W0 = vs1[H4(0)], W1 = vs1[H4(1)];
+    uint32_t T1 = h + sum1_32(e) + ch(e, f, g) + W0;
+    uint32_t T2 = sum0_32(a) + maj(a, b, c);
+
+    h = g;
+    g = f;
+    f = e;
+    e = d + T1;
+    d = c;
+    c = b;
+    b = a;
+    a = T1 + T2;
+
+    T1 = h + sum1_32(e) + ch(e, f, g) + W1;
+    T2 = sum0_32(a) + maj(a, b, c);
+    h = g;
+    g = f;
+    f = e;
+    e = d + T1;
+    d = c;
+    c = b;
+    b = a;
+    a = T1 + T2;
+
+    vd[H4(0)] = f;
+    vd[H4(1)] = e;
+    vd[H4(2)] = b;
+    vd[H4(3)] = a;
+}
+
+void HELPER(vsha2ch_vv)(void *vd, void *vs1, void *vs2, CPURISCVState *env,
+                        uint32_t desc)
+{
+    uint32_t sew = FIELD_EX64(env->vtype, VTYPE, VSEW);
+    uint32_t esz = sew == MO_64 ? 8 : 4;
+    uint32_t total_elems;
+    uint32_t vta = vext_vta(desc);
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        if (sew == MO_64) {
+            vsha2c_64(((uint64_t *)vs2) + 4 * i, ((uint64_t *)vd) + 4 * i,
+                      ((uint64_t *)vs1) + 4 * i + 2);
+        } else {
+            vsha2c_32(((uint32_t *)vs2) + 4 * i, ((uint32_t *)vd) + 4 * i,
+                      ((uint32_t *)vs1) + 4 * i + 2);
+        }
+    }
+
+    /* set tail elements to 1s */
+    total_elems = vext_get_total_elems(env, desc, esz);
+    vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
+
+void HELPER(vsha2cl_vv)(void *vd, void *vs1, void *vs2, CPURISCVState *env,
+                        uint32_t desc)
+{
+    uint32_t sew = FIELD_EX64(env->vtype, VTYPE, VSEW);
+    uint32_t esz = sew == MO_64 ? 8 : 4;
+    uint32_t total_elems;
+    uint32_t vta = vext_vta(desc);
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        if (sew == MO_64) {
+            vsha2c_64(((uint64_t *)vs2) + 4 * i, ((uint64_t *)vd) + 4 * i,
+                      (((uint64_t *)vs1) + 4 * i));
+        } else {
+            vsha2c_32(((uint32_t *)vs2) + 4 * i, ((uint32_t *)vd) + 4 * i,
+                      (((uint32_t *)vs1) + 4 * i));
+        }
+    }
+
+    /* set tail elements to 1s */
+    total_elems = vext_get_total_elems(env, desc, esz);
+    vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
-- 
2.40.0


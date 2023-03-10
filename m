Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A7F6B4CB0
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjCJQVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjCJQUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:20:39 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCA612B66D
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:16:14 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDp-00H4ad-Bg; Fri, 10 Mar 2023 16:03:57 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 30/45] target/riscv: Add vsha2ms.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:31 +0000
Message-Id: <20230310160346.1193597-31-lawrence.hunter@codethink.co.uk>
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

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/helper.h                       |  2 +
 target/riscv/insn32.decode                  |  3 +
 target/riscv/insn_trans/trans_rvzvknh.c.inc | 82 +++++++++++++++++++++
 target/riscv/translate.c                    |  1 +
 target/riscv/vcrypto_helper.c               | 74 +++++++++++++++++++
 5 files changed, 162 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index f07f261b7b..76ea2ff49b 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1199,3 +1199,5 @@ DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_5(vaeskf1_vi, void, ptr, ptr, i32, env, i32)
 DEF_HELPER_5(vaeskf2_vi, void, ptr, ptr, i32, env, i32)
+
+DEF_HELPER_5(vsha2ms_vv, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 43dfd63e0d..aef4d0b476 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -939,3 +939,6 @@ vaesdm_vs       101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesz_vs        101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
 vaeskf1_vi      100010 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vaeskf2_vi      101010 1 ..... ..... 010 ..... 1110111 @r_vm_1
+
+# *** RV64 Zvknh vector crypto extension ***
+vsha2ms_vv      101101 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvknh.c.inc b/target/riscv/insn_trans/trans_rvzvknh.c.inc
new file mode 100644
index 0000000000..97bdf4d72f
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvknh.c.inc
@@ -0,0 +1,82 @@
+/*
+ * RISC-V translation routines for the Zvknh Extension.
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
+
+#define GEN_VV_UNMASKED_TRANS(NAME, CHECK, VL_MULTIPLE)                \
+static bool trans_##NAME(DisasContext *s, arg_rmrr * a)                \
+{                                                                      \
+    if (CHECK(s, a)) {                                                 \
+        uint32_t data = 0;                                             \
+        TCGLabel *over = gen_new_label();                              \
+        TCGLabel *vl_ok = gen_new_label();                             \
+        TCGv_i32 tmp = tcg_temp_new_i32();                             \
+                                                                       \
+        /* save opcode for unwinding in case we throw an exception */  \
+        decode_save_opc(s);                                            \
+                                                                       \
+        /* check (vl % VL_MULTIPLE == 0) assuming it's power of 2 */   \
+        tcg_gen_trunc_tl_i32(tmp, cpu_vl);                             \
+        tcg_gen_andi_i32(tmp, tmp, VL_MULTIPLE - 1);                   \
+        tcg_gen_brcondi_i32(TCG_COND_EQ, tmp, 0, vl_ok);               \
+        gen_helper_restore_cpu_and_raise_exception(cpu_env,            \
+            tcg_constant_i32(RISCV_EXCP_ILLEGAL_INST));                \
+        gen_set_label(vl_ok);                                          \
+                                                                       \
+        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
+                                                                       \
+        data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
+        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
+        data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
+        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
+        data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
+                                                                       \
+        tcg_gen_gvec_3_ptr(vreg_ofs(s, a->rd),                         \
+                           vreg_ofs(s, a->rs1),                        \
+                           vreg_ofs(s, a->rs2), cpu_env,               \
+                           s->cfg_ptr->vlen / 8,                       \
+                           s->cfg_ptr->vlen / 8, data,                 \
+                           gen_helper_##NAME);                         \
+                                                                       \
+        mark_vs_dirty(s);                                              \
+        gen_set_label(over);                                           \
+        return true;                                                   \
+    }                                                                  \
+    return false;                                                      \
+}
+
+static bool vsha_check_sew(DisasContext *s)
+{
+    return (s->cfg_ptr->ext_zvknha == true && s->sew == MO_32) ||
+           (s->cfg_ptr->ext_zvknhb == true &&
+               (s->sew == MO_32 || s->sew == MO_64));
+}
+
+static bool vsha_check(DisasContext *s, arg_rmrr *a)
+{
+    int egw_bytes = 4 << s->sew;
+    int mult = 1 << MAX(s->lmul, 0);
+    return opivv_check(s, a) &&
+           vsha_check_sew(s) &&
+           MAXSZ(s) >= egw_bytes &&
+           !is_overlapped(a->rd, mult, a->rs1, mult) &&
+           !is_overlapped(a->rd, mult, a->rs2, mult) &&
+           s->vstart % 4 == 0 &&
+           s->lmul >= 0;
+}
+
+GEN_VV_UNMASKED_TRANS(vsha2ms_vv, vsha_check, 4)
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index e3561b0bbd..1c1e36c10a 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1085,6 +1085,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvk.c.inc"
 #include "insn_trans/trans_rvzvkb.c.inc"
 #include "insn_trans/trans_rvzvkned.c.inc"
+#include "insn_trans/trans_rvzvknh.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "decode-xthead.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 4a50178676..ae253b3357 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -452,3 +452,77 @@ void HELPER(vaeskf2_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
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
+        vd[H4(0)];
+    res[1] = sig1_sha256(vs1[H4(3)]) + vs2[H4(2)] + sig0_sha256(vd[H4(2)]) +
+        vd[H4(1)];
+    res[2] = sig1_sha256(res[0]) + vs2[H4(3)] + sig0_sha256(vd[H4(3)]) +
+        vd[H4(2)];
+    res[3] = sig1_sha256(res[1]) + vs1[H4(0)] + sig0_sha256(vs2[H4(0)]) +
+        vd[H4(3)];
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
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79626687DAC
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjBBMoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjBBMoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:24 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F189FA4
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:43:53 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvG-004Q6t-8W; Thu, 02 Feb 2023 12:42:39 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 12/39] target/riscv: Add vaesef.vv decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:03 +0000
Message-Id: <20230202124230.295997-13-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                       |  2 +
 target/riscv/insn32.decode                  |  4 ++
 target/riscv/insn_trans/trans_rvzvkns.c.inc | 40 +++++++++++
 target/riscv/translate.c                    |  1 +
 target/riscv/vcrypto_helper.c               | 75 +++++++++++++++++++++
 5 files changed, 122 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkns.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 5de615ea78..bdfa63302e 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1180,3 +1180,5 @@ DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
+
+DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index d6f5e4d198..fdaab9a189 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -74,6 +74,7 @@
 @r_rm    .......   ..... ..... ... ..... ....... %rs2 %rs1 %rm %rd
 @r2_rm   .......   ..... ..... ... ..... ....... %rs1 %rm %rd
 @r2      .......   ..... ..... ... ..... ....... &r2 %rs1 %rd
+@r2_vm_1 ...... . ..... ..... ... ..... ....... &rmr vm=1 %rs2 %rd
 @r2_nfvm ... ... vm:1 ..... ..... ... ..... ....... &r2nfvm %nf %rs1 %rd
 @r2_vm   ...... vm:1 ..... ..... ... ..... ....... &rmr %rs2 %rd
 @r1_vm   ...... vm:1 ..... ..... ... ..... ....... %rd
@@ -907,3 +908,6 @@ vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
 vandn_vi        000001 . ..... ..... 011 ..... 1010111 @r_vm
 vandn_vv        000001 . ..... ..... 000 ..... 1010111 @r_vm
 vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
+
+# *** RV64 Zvkns vector crypto extension ***
+vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkns.c.inc b/target/riscv/insn_trans/trans_rvzvkns.c.inc
new file mode 100644
index 0000000000..16e2c58001
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvkns.c.inc
@@ -0,0 +1,40 @@
+#define GEN_V_UNMASKED_TRANS(NAME, CHECK)                                 \
+static bool trans_##NAME(DisasContext *s, arg_##NAME * a)                 \
+{                                                                         \
+    if (CHECK(s, a)) {                                                    \
+        TCGv_ptr rd_v, rs2_v;                                             \
+        TCGv_i32 desc;                                                    \
+        uint32_t data = 0;                                                \
+                                                                          \
+        TCGLabel *over = gen_new_label();                                 \
+        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);                 \
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
+        tcg_temp_free_ptr(rd_v);                                          \
+        tcg_temp_free_ptr(rs2_v);                                         \
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
+    return s->cfg_ptr->ext_zvkns == true && vext_check_isa_ill(s) &&
+           require_align(a->rd, s->lmul) && require_align(a->rs2, s->lmul) &&
+           s->vstart % 4 == 0 && s->sew == MO_32;
+}
+GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 71684c10f3..8d39743de2 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1064,6 +1064,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzfh.c.inc"
 #include "insn_trans/trans_rvk.c.inc"
 #include "insn_trans/trans_rvzvkb.c.inc"
+#include "insn_trans/trans_rvzvkns.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "insn_trans/trans_xventanacondops.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 900e68dfb0..59d7d32a05 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -3,6 +3,7 @@
 #include "qemu/bitops.h"
 #include "qemu/bswap.h"
 #include "cpu.h"
+#include "crypto/aes.h"
 #include "exec/memop.h"
 #include "exec/exec-all.h"
 #include "exec/helper-proto.h"
@@ -154,3 +155,77 @@ GEN_VEXT_VX(vandn_vx_b, 1)
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
+#define GEN_ZVKNS_HELPER_VV(NAME, ...)                                    \
+void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,      \
+                  uint32_t desc)                                          \
+{                                                                         \
+    uint64_t *vd = vd_vptr;                                               \
+    uint64_t *vs2 = vs2_vptr;                                             \
+    uint32_t vl = env->vl;                                                \
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);            \
+    uint32_t vta = vext_vta(desc);                                        \
+    if (env->vl % 4 != 0) {                                               \
+        riscv_raise_exception(env, RISCV_EXCP_ILLEGAL_INST, GETPC());     \
+    }                                                                     \
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
+GEN_ZVKNS_HELPER_VV(vaesef_vv, aes_sub_bytes(round_state);
+                    aes_shift_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
-- 
2.39.1


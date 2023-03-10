Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC36B3A25
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjCJJRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCJJQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:16:48 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEA210A2BB
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:12:46 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYnc-00GpVx-9n; Fri, 10 Mar 2023 09:12:28 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 18/45] target/riscv: Add vaesef.vs decoding, translation and execution support
Date:   Fri, 10 Mar 2023 09:11:48 +0000
Message-Id: <20230310091215.931644-19-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                        |  1 +
 target/riscv/insn32.decode                   |  1 +
 target/riscv/insn_trans/trans_rvzvkned.c.inc | 20 +++++++++++
 target/riscv/vcrypto_helper.c                | 36 ++++++++++++++++++++
 4 files changed, 58 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index a402bb5d40..fb30b4d13e 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1189,3 +1189,4 @@ DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
 
 DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index f68025755a..5d1bb6ccc6 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -929,3 +929,4 @@ vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
 
 # *** RV64 Zvkned vector crypto extension ***
 vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
+vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkned.c.inc b/target/riscv/insn_trans/trans_rvzvkned.c.inc
index 6f3d62bef1..69bf7f9fee 100644
--- a/target/riscv/insn_trans/trans_rvzvkned.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkned.c.inc
@@ -69,4 +69,24 @@ static bool vaes_check_vv(DisasContext *s, arg_rmr *a)
            require_align(a->rs2, s->lmul) &&
            s->vstart % 4 == 0 && s->sew == MO_32;
 }
+
+static bool vaes_check_overlap(DisasContext *s, int vd, int vs2)
+{
+    int8_t op_size = s->lmul <= 0 ? 1 : 1 << s->lmul;
+    return !is_overlapped(vd, op_size, vs2, 1);
+}
+
+static bool vaes_check_vs(DisasContext *s, arg_rmr *a)
+{
+    return vaes_check_overlap(s, a->rd, a->rs2) &&
+           MAXSZ(s) >= (128 / 8) && /* EGW in bytes */
+           s->cfg_ptr->ext_zvkned == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           require_align(a->rd, s->lmul) &&
+           s->vstart % 4 == 0 &&
+           s->sew == MO_32;
+}
+
 GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesef_vs, vaes_check_vs)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index bb5ce5b50a..b079b543c7 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -214,6 +214,42 @@ void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,      \
     vext_set_elems_1s(vd, vta, vl * 4, total_elems * 4);                  \
 }
 
+#define GEN_ZVKNED_HELPER_VS(NAME, ...)                                   \
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
+            cpu_to_le64(vs2[0]),                                          \
+            cpu_to_le64(vs2[1]),                                          \
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
 GEN_ZVKNED_HELPER_VV(vaesef_vv, aes_sub_bytes(round_state);
                     aes_shift_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VS(vaesef_vs, aes_sub_bytes(round_state);
+                    aes_shift_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
-- 
2.39.2


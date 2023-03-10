Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E93A6B4DC0
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjCJQ5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjCJQ5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:57:16 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92AB11E9A
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:55:01 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDq-00H4ad-Ff; Fri, 10 Mar 2023 16:03:58 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 34/45]  target/riscv: Add vsm3me.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:35 +0000
Message-Id: <20230310160346.1193597-35-lawrence.hunter@codethink.co.uk>
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

Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/helper.h                       |  2 ++
 target/riscv/insn32.decode                  |  3 ++
 target/riscv/insn_trans/trans_rvzvksh.c.inc | 37 +++++++++++++++++++
 target/riscv/translate.c                    |  1 +
 target/riscv/vcrypto_helper.c               | 39 +++++++++++++++++++++
 5 files changed, 82 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 77bbd9db56..d8f67b924e 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1203,3 +1203,5 @@ DEF_HELPER_5(vaeskf2_vi, void, ptr, ptr, i32, env, i32)
 DEF_HELPER_5(vsha2ms_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsha2ch_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_5(vsm3me_vv, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index c95886040b..588907dd4d 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -944,3 +944,6 @@ vaeskf2_vi      101010 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsha2ms_vv      101101 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsha2ch_vv      101110 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsha2cl_vv      101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
+
+# *** RV64 Zvksh vector crypto extension ***
+vsm3me_vv       100000 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvksh.c.inc b/target/riscv/insn_trans/trans_rvzvksh.c.inc
new file mode 100644
index 0000000000..a0b3de1b21
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvksh.c.inc
@@ -0,0 +1,37 @@
+/*
+ * RISC-V translation routines for the Zvksh Extension.
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
+static inline bool vsm3_check(DisasContext *s, arg_rmrr *a)
+{
+    int mult = 1 << MAX(s->lmul, 0);
+    return s->cfg_ptr->ext_zvksh == true &&
+           require_rvv(s) &&
+           vext_check_isa_ill(s) &&
+           !is_overlapped(a->rd, mult, a->rs2, mult) &&
+           MAXSZ(s) >= (256 / 8) && /* EGW in bytes */
+           s->vstart % 8 == 0 &&
+           s->sew == MO_32;
+}
+
+static inline bool vsm3me_check(DisasContext *s, arg_rmrr *a)
+{
+    return vsm3_check(s, a) && vext_check_sss(s, a->rd, a->rs1, a->rs2, a->vm);
+}
+
+GEN_VV_UNMASKED_TRANS(vsm3me_vv, vsm3me_check, 8)
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 1c1e36c10a..256872ec28 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1086,6 +1086,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzvkb.c.inc"
 #include "insn_trans/trans_rvzvkned.c.inc"
 #include "insn_trans/trans_rvzvknh.c.inc"
+#include "insn_trans/trans_rvzvksh.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "decode-xthead.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index bf0455f8e0..20c4ed8c4a 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -666,3 +666,42 @@ void HELPER(vsha2cl_vv)(void *vd, void *vs1, void *vs2, CPURISCVState *env,
     vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
     env->vstart = 0;
 }
+
+static inline uint32_t p1(uint32_t x)
+{
+    return x ^ rol32(x, 15) ^ rol32(x, 23);
+}
+
+static inline uint32_t zvksh_w(uint32_t m16, uint32_t m9, uint32_t m3,
+                               uint32_t m13, uint32_t m6)
+{
+    return p1(m16 ^ m9 ^ rol32(m3, 15)) ^ rol32(m13, 7) ^ m6;
+}
+
+void HELPER(vsm3me_vv)(void *vd_vptr, void *vs1_vptr, void *vs2_vptr,
+                       CPURISCVState *env, uint32_t desc)
+{
+    uint32_t esz = memop_size(FIELD_EX64(env->vtype, VTYPE, VSEW));
+    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
+    uint32_t vta = vext_vta(desc);
+    uint32_t *vd = vd_vptr;
+    uint32_t *vs1 = vs1_vptr;
+    uint32_t *vs2 = vs2_vptr;
+
+    for (int i = env->vstart / 8; i < env->vl / 8; i++) {
+        uint32_t w[24];
+        for (int j = 0; j < 8; j++) {
+            w[j] = bswap32(vs1[H4((i * 8) + j)]);
+            w[j + 8] = bswap32(vs2[H4((i * 8) + j)]);
+        }
+        for (int j = 0; j < 8; j++) {
+            w[j + 16] =
+                zvksh_w(w[j], w[j + 7], w[j + 13], w[j + 3], w[j + 10]);
+        }
+        for (int j = 0; j < 8; j++) {
+            vd[(i * 8) + j] = bswap32(w[H4(j + 16)]);
+        }
+    }
+    vext_set_elems_1s(vd_vptr, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
-- 
2.39.2


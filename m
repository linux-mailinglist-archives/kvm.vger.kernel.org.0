Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB006B3B29
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjCJJpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjCJJpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:45:18 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280665C5B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:44:52 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYnh-00GpVx-5Q; Fri, 10 Mar 2023 09:12:33 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 38/45] target/riscv: Add vgmul.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 09:12:08 +0000
Message-Id: <20230310091215.931644-39-lawrence.hunter@codethink.co.uk>
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

Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  2 ++
 target/riscv/insn32.decode                 |  3 ++
 target/riscv/insn_trans/trans_rvzvkg.c.inc | 30 +++++++++++++++++++
 target/riscv/translate.c                   |  1 +
 target/riscv/vcrypto_helper.c              | 34 ++++++++++++++++++++++
 5 files changed, 70 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 494ebf8cda..680f695e75 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1206,3 +1206,5 @@ DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
 
 DEF_HELPER_5(vsm3me_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsm3c_vi, void, ptr, ptr, i32, env, i32)
+
+DEF_HELPER_4(vgmul_vv, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 76802f37db..fdb535906f 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -948,3 +948,6 @@ vsha2cl_vv      101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
 # *** RV64 Zvksh vector crypto extension ***
 vsm3me_vv       100000 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsm3c_vi        101011 1 ..... ..... 010 ..... 1110111 @r_vm_1
+
+# *** RV64 Zvkg vector crypto extension ***
+vgmul_vv        101000 1 ..... 10001 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkg.c.inc b/target/riscv/insn_trans/trans_rvzvkg.c.inc
new file mode 100644
index 0000000000..f1e4ea1381
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvkg.c.inc
@@ -0,0 +1,30 @@
+/*
+ * RISC-V translation routines for the Zvkg Extension.
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
+static bool vgmul_check(DisasContext *s, arg_rmr *a)
+{
+    return s->cfg_ptr->ext_zvkg == true &&
+            vext_check_isa_ill(s) &&
+            require_rvv(s) &&
+            MAXSZ(s) >= (128 / 8) && /* EGW in bytes */
+            vext_check_ss(s, a->rd, a->rs2, a->vm) &&
+            s->vstart % 4 == 0 && s->sew == MO_32;
+}
+
+GEN_V_UNMASKED_TRANS(vgmul_vv, vgmul_check)
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 256872ec28..fdb5c3364e 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1087,6 +1087,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzvkned.c.inc"
 #include "insn_trans/trans_rvzvknh.c.inc"
 #include "insn_trans/trans_rvzvksh.c.inc"
+#include "insn_trans/trans_rvzvkg.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "decode-xthead.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 2d8db45740..eb70e2e26c 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -800,3 +800,37 @@ void HELPER(vsm3c_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
     vext_set_elems_1s(vd_vptr, vta, env->vl * esz, total_elems * esz);
     env->vstart = 0;
 }
+
+void HELPER(vgmul_vv)(void *vd_vptr, void *vs2_vptr,
+                       CPURISCVState *env, uint32_t desc)
+{
+    uint64_t *vd = vd_vptr;
+    uint64_t *vs2 = vs2_vptr;
+    uint32_t vta = vext_vta(desc);
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        uint64_t Y[2] = {brev8(vd[i * 2 + 0]), brev8(vd[i * 2 + 1])};
+        uint64_t H[2] = {brev8(vs2[i * 2 + 0]), brev8(vs2[i * 2 + 1])};
+        uint64_t Z[2] = {0, 0};
+
+        for (uint j = 0; j < 128; j++) {
+            if ((Y[j / 64] >> (j % 64)) & 1) {
+                Z[0] ^= H[0];
+                Z[1] ^= H[1];
+            }
+            bool reduce = ((H[1] >> 63) & 1);
+            H[1] = H[1] << 1 | H[0] >> 63;
+            H[0] = H[0] << 1;
+            if (reduce) {
+                H[0] ^= 0x87;
+            }
+        }
+
+        vd[i * 2 + 0] = brev8(Z[0]);
+        vd[i * 2 + 1] = brev8(Z[1]);
+    }
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, env->vl * 4, total_elems * 4);
+    env->vstart = 0;
+}
-- 
2.39.2


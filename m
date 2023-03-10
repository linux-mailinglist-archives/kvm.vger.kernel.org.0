Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057586B4BFF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCJQGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjCJQFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:05:54 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EC89BA7C
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:04 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDh-00H4ad-SA; Fri, 10 Mar 2023 16:03:49 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        Max Chou <max.chou@sifive.com>
Subject: [PATCH 03/45] target/riscv: Add vclmul.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:04 +0000
Message-Id: <20230310160346.1193597-4-lawrence.hunter@codethink.co.uk>
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
Co-authored-by: Max Chou <max.chou@sifive.com>
Signed-off-by: Max Chou <max.chou@sifive.com>
Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  3 ++
 target/riscv/insn32.decode                 |  3 ++
 target/riscv/insn_trans/trans_rvzvkb.c.inc | 40 +++++++++++++++++++++
 target/riscv/meson.build                   |  3 +-
 target/riscv/translate.c                   |  1 +
 target/riscv/vcrypto_helper.c              | 42 ++++++++++++++++++++++
 6 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
 create mode 100644 target/riscv/vcrypto_helper.c

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 37b54e0991..33060c3e2f 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1142,3 +1142,6 @@ DEF_HELPER_FLAGS_1(aes64im, TCG_CALL_NO_RWG_SE, tl, tl)
 
 DEF_HELPER_FLAGS_3(sm4ed, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
+
+/* Vector crypto functions */
+DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 73d5d1b045..03a0057d71 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -908,3 +908,6 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
 # *** RV32 Zicond Standard Extension ***
 czero_eqz   0000111  ..... ..... 101 ..... 0110011 @r
 czero_nez   0000111  ..... ..... 111 ..... 0110011 @r
+
+# *** RV64 Zvkb vector crypto extension ***
+vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
new file mode 100644
index 0000000000..7cd920e76d
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -0,0 +1,40 @@
+/*
+ * RISC-V translation routines for the Zvkb Extension.
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
+#define GEN_VV_MASKED_TRANS(NAME, CHECK)                 \
+static bool trans_##NAME(DisasContext *s, arg_rmrr *a)   \
+{                                                        \
+    if (CHECK(s, a)) {                                   \
+        return opivv_trans(a->rd, a->rs1, a->rs2, a->vm, \
+                           gen_helper_##NAME, s);        \
+    }                                                    \
+    return false;                                        \
+}
+
+static bool zvkb_vv_check(DisasContext *s, arg_rmrr *a)
+{
+    return opivv_check(s, a) && s->cfg_ptr->ext_zvkb == true;
+}
+
+static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
+{
+    return zvkb_vv_check(s, a) && s->sew == MO_64;
+}
+
+GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index a94fc3f598..52a61dd66e 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -20,7 +20,8 @@ riscv_ss.add(files(
   'bitmanip_helper.c',
   'translate.c',
   'm128_helper.c',
-  'crypto_helper.c'
+  'crypto_helper.c',
+  'vcrypto_helper.c'
 ))
 riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
 
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 0ee8ee147d..939f5aeb1c 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1083,6 +1083,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzicbo.c.inc"
 #include "insn_trans/trans_rvzfh.c.inc"
 #include "insn_trans/trans_rvk.c.inc"
+#include "insn_trans/trans_rvzvkb.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "decode-xthead.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
new file mode 100644
index 0000000000..b4983886bd
--- /dev/null
+++ b/target/riscv/vcrypto_helper.c
@@ -0,0 +1,42 @@
+/*
+ * RISC-V Vector Crypto Extension Helpers for QEMU.
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
+#include "qemu/osdep.h"
+#include "qemu/host-utils.h"
+#include "qemu/bitops.h"
+#include "cpu.h"
+#include "exec/memop.h"
+#include "exec/exec-all.h"
+#include "exec/helper-proto.h"
+#include "internals.h"
+#include "vector_internals.h"
+
+static uint64_t clmul64(uint64_t y, uint64_t x)
+{
+    uint64_t result = 0;
+    for (int j = 63; j >= 0; j--) {
+        if ((y >> j) & 1) {
+            result ^= (x << j);
+        }
+    }
+    return result;
+}
+
+RVVCALL(OPIVV2, vclmul_vv, OP_UUU_D, H8, H8, H8, clmul64)
+GEN_VEXT_VV(vclmul_vv, 8)
-- 
2.39.2


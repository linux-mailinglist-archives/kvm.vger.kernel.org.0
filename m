Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B389687E6E
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBBNTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjBBNTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:19:48 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE20C6E433
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:19:46 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvM-004Q6t-2g; Thu, 02 Feb 2023 12:42:44 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 33/39] target/riscv: Add vghmac.vv decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:24 +0000
Message-Id: <20230202124230.295997-34-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                      |  2 +
 target/riscv/insn32.decode                 |  3 ++
 target/riscv/insn_trans/trans_rvzvkg.c.inc |  9 +++++
 target/riscv/translate.c                   |  1 +
 target/riscv/vcrypto_helper.c              | 45 ++++++++++++++++++++++
 5 files changed, 60 insertions(+)
 create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index a82103ead9..6272294d50 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1199,3 +1199,5 @@ DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
 
 DEF_HELPER_5(vsm3me_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsm3c_vi, void, ptr, ptr, i32, env, i32)
+
+DEF_HELPER_5(vghmac_vv, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 4a50114e92..ff044f8288 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -930,3 +930,6 @@ vsha2cl_vv      101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
 # *** RV64 Zvksh vector crypto extensions ***
 vsm3me_vv       100000 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsm3c_vi        101011 1 ..... ..... 010 ..... 1110111 @r_vm_1
+
+# *** RV64 Zvkg vector crypto extension ***
+vghmac_vv       101100 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkg.c.inc b/target/riscv/insn_trans/trans_rvzvkg.c.inc
new file mode 100644
index 0000000000..aa2004fb44
--- /dev/null
+++ b/target/riscv/insn_trans/trans_rvzvkg.c.inc
@@ -0,0 +1,9 @@
+static bool vghmac_check(DisasContext *s, arg_rmrr *a)
+{
+    return opivv_check(s, a) &&
+           s->cfg_ptr->ext_zvkg == true &&
+           s->vstart % 4 == 0 &&
+           s->sew == MO_32;
+}
+
+GEN_VV_UNMASKED_TRANS(vghmac_vv, vghmac_check)
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 9ca2cec23a..0bc1c9db65 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1067,6 +1067,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 #include "insn_trans/trans_rvzvkns.c.inc"
 #include "insn_trans/trans_rvzvknh.c.inc"
 #include "insn_trans/trans_rvzvksh.c.inc"
+#include "insn_trans/trans_rvzvkg.c.inc"
 #include "insn_trans/trans_privileged.c.inc"
 #include "insn_trans/trans_svinval.c.inc"
 #include "insn_trans/trans_xventanacondops.c.inc"
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 478e652c9b..a309ac3f03 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -827,3 +827,48 @@ void HELPER(vsm3c_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
     vext_set_elems_1s(vd_vptr, vta, env->vl * esz, total_elems * esz);
     env->vstart = 0;
 }
+
+void HELPER(vghmac_vv)(void *vd_vptr, void *vs1_vptr, void *vs2_vptr,
+                       CPURISCVState *env, uint32_t desc)
+{
+    uint64_t *vd = vd_vptr;
+    uint64_t *vs1 = vs1_vptr;
+    uint64_t *vs2 = vs2_vptr;
+    uint32_t vta = vext_vta(desc);
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);
+
+    if (env->vl % 4 != 0) {
+        riscv_raise_exception(env, RISCV_EXCP_ILLEGAL_INST, GETPC());
+    }
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        __uint128_t Y = reverse_bits_byte_8(vd[i * 2 + 0]) |
+                        ((__uint128_t)reverse_bits_byte_8(vd[i * 2 + 1]) << 64);
+        __uint128_t H = reverse_bits_byte_8(vs1[i * 2 + 0]) |
+                        ((__uint128_t)reverse_bits_byte_8(vs1[i * 2 + 1]) << 64);
+        __uint128_t X = vs2[i * 2 + 0] | ((__uint128_t)vs2[i * 2 + 1] << 64);
+        __uint128_t Z = 0;
+
+        for (uint j = 0; j < 128; j++) {
+            if ((Y >> j) & 1) {
+                Z ^= H;
+            }
+            bool reduce = ((H >> 127) & 1);
+            H = H << 1;
+            if (reduce) {
+                H ^= 0x87;
+            }
+        }
+
+        Z = reverse_bits_byte_8(Z & UINT64_MAX) |
+            ((__uint128_t)reverse_bits_byte_8((Z >> 64) & UINT64_MAX) << 64);
+
+        Z = Z ^ X;
+
+        vd[i * 2 + 0] = Z & UINT64_MAX;
+        vd[i * 2 + 1] = (Z >> 64) & UINT64_MAX;
+    }
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, env->vl * 4, total_elems * 4);
+    env->vstart = 0;
+}
-- 
2.39.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5E6B4DBC
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCJQ50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCJQ5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:57:02 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF07135B1D
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:54:51 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDr-00H4ad-TC; Fri, 10 Mar 2023 16:03:59 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 39/45] target/riscv: Add vghsh.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:40 +0000
Message-Id: <20230310160346.1193597-40-lawrence.hunter@codethink.co.uk>
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

Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  1 +
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkg.c.inc | 10 ++++++
 target/riscv/vcrypto_helper.c              | 38 ++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 680f695e75..3c4aa4b5df 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1207,4 +1207,5 @@ DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsm3me_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsm3c_vi, void, ptr, ptr, i32, env, i32)
 
+DEF_HELPER_5(vghsh_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_4(vgmul_vv, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index fdb535906f..856e088bad 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -950,4 +950,5 @@ vsm3me_vv       100000 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vsm3c_vi        101011 1 ..... ..... 010 ..... 1110111 @r_vm_1
 
 # *** RV64 Zvkg vector crypto extension ***
+vghsh_vv        101100 1 ..... ..... 010 ..... 1110111 @r_vm_1
 vgmul_vv        101000 1 ..... 10001 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkg.c.inc b/target/riscv/insn_trans/trans_rvzvkg.c.inc
index f1e4ea1381..9280300ce0 100644
--- a/target/riscv/insn_trans/trans_rvzvkg.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkg.c.inc
@@ -28,3 +28,13 @@ static bool vgmul_check(DisasContext *s, arg_rmr *a)
 }
 
 GEN_V_UNMASKED_TRANS(vgmul_vv, vgmul_check)
+
+static bool vghsh_check(DisasContext *s, arg_rmrr *a)
+{
+    return s->cfg_ptr->ext_zvkg == true &&
+            opivv_check(s, a) &&
+            MAXSZ(s) >= (128 / 8) && /* EGW in bytes */
+            s->vstart % 4 == 0 && s->sew == MO_32;
+}
+
+GEN_VV_UNMASKED_TRANS(vghsh_vv, vghsh_check, 4)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index eb70e2e26c..fe9b05253d 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -801,6 +801,44 @@ void HELPER(vsm3c_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
     env->vstart = 0;
 }
 
+void HELPER(vghsh_vv)(void *vd_vptr, void *vs1_vptr, void *vs2_vptr,
+                       CPURISCVState *env, uint32_t desc)
+{
+    uint64_t *vd = vd_vptr;
+    uint64_t *vs1 = vs1_vptr;
+    uint64_t *vs2 = vs2_vptr;
+    uint32_t vta = vext_vta(desc);
+    uint32_t total_elems = vext_get_total_elems(env, desc, 4);
+
+    for (uint32_t i = env->vstart / 4; i < env->vl / 4; i++) {
+        uint64_t Y[2] = {vd[i * 2 + 0], vd[i * 2 + 1]};
+        uint64_t H[2] = {brev8(vs2[i * 2 + 0]), brev8(vs2[i * 2 + 1])};
+        uint64_t X[2] = {vs1[i * 2 + 0], vs1[i * 2 + 1]};
+        uint64_t Z[2] = {0, 0};
+
+        uint64_t S[2] = {brev8(Y[0] ^ X[0]), brev8(Y[1] ^ X[1])};
+
+        for (uint j = 0; j < 128; j++) {
+            if ((S[j / 64] >> (j % 64)) & 1) {
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
+
 void HELPER(vgmul_vv)(void *vd_vptr, void *vs2_vptr,
                        CPURISCVState *env, uint32_t desc)
 {
-- 
2.39.2


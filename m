Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA876B3AEE
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCJJlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjCJJkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:40:17 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0972313D7B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:40:08 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYng-00GpVx-Dw; Fri, 10 Mar 2023 09:12:32 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 35/45] target/riscv: Add vsm3c.vi decoding, translation and execution support
Date:   Fri, 10 Mar 2023 09:12:05 +0000
Message-Id: <20230310091215.931644-36-lawrence.hunter@codethink.co.uk>
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

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/helper.h                       |  1 +
 target/riscv/insn32.decode                  |  1 +
 target/riscv/insn_trans/trans_rvzvksh.c.inc |  6 ++
 target/riscv/vcrypto_helper.c               | 95 +++++++++++++++++++++
 4 files changed, 103 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index d8f67b924e..494ebf8cda 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1205,3 +1205,4 @@ DEF_HELPER_5(vsha2ch_vv, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
 
 DEF_HELPER_5(vsm3me_vv, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vsm3c_vi, void, ptr, ptr, i32, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 588907dd4d..76802f37db 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -947,3 +947,4 @@ vsha2cl_vv      101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
 
 # *** RV64 Zvksh vector crypto extension ***
 vsm3me_vv       100000 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vsm3c_vi        101011 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvksh.c.inc b/target/riscv/insn_trans/trans_rvzvksh.c.inc
index a0b3de1b21..e15cb828b7 100644
--- a/target/riscv/insn_trans/trans_rvzvksh.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvksh.c.inc
@@ -34,4 +34,10 @@ static inline bool vsm3me_check(DisasContext *s, arg_rmrr *a)
     return vsm3_check(s, a) && vext_check_sss(s, a->rd, a->rs1, a->rs2, a->vm);
 }
 
+static inline bool vsm3c_check(DisasContext *s, arg_rmrr *a)
+{
+    return vsm3_check(s, a) && vext_check_ss(s, a->rd, a->rs2, a->vm);
+}
+
 GEN_VV_UNMASKED_TRANS(vsm3me_vv, vsm3me_check, 8)
+GEN_VI_UNMASKED_TRANS(vsm3c_vi, vsm3c_check, 8)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 20c4ed8c4a..2d8db45740 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -705,3 +705,98 @@ void HELPER(vsm3me_vv)(void *vd_vptr, void *vs1_vptr, void *vs2_vptr,
     vext_set_elems_1s(vd_vptr, vta, env->vl * esz, total_elems * esz);
     env->vstart = 0;
 }
+
+static inline uint32_t ff1(uint32_t x, uint32_t y, uint32_t z)
+{
+    return x ^ y ^ z;
+}
+
+static inline uint32_t ff2(uint32_t x, uint32_t y, uint32_t z)
+{
+    return (x & y) | (x & z) | (y & z);
+}
+
+static inline uint32_t ff_j(uint32_t x, uint32_t y, uint32_t z, uint32_t j)
+{
+    return (j <= 15) ? ff1(x, y, z) : ff2(x, y, z);
+}
+
+static inline uint32_t gg1(uint32_t x, uint32_t y, uint32_t z)
+{
+    return x ^ y ^ z;
+}
+
+static inline uint32_t gg2(uint32_t x, uint32_t y, uint32_t z)
+{
+    return (x & y) | (~x & z);
+}
+
+static inline uint32_t gg_j(uint32_t x, uint32_t y, uint32_t z, uint32_t j)
+{
+    return (j <= 15) ? gg1(x, y, z) : gg2(x, y, z);
+}
+
+static inline uint32_t t_j(uint32_t j)
+{
+    return (j <= 15) ? 0x79cc4519 : 0x7a879d8a;
+}
+
+static inline uint32_t p_0(uint32_t x)
+{
+    return x ^ rol32(x, 9) ^ rol32(x, 17);
+}
+
+static void sm3c(uint32_t *vd, uint32_t *vs1, uint32_t *vs2, uint32_t uimm)
+{
+    uint32_t x0, x1;
+    uint32_t j;
+    uint32_t ss1, ss2, tt1, tt2;
+    x0 = vs2[0] ^ vs2[4];
+    x1 = vs2[1] ^ vs2[5];
+    j = 2 * uimm;
+    ss1 = rol32(rol32(vs1[0], 12) + vs1[4] + rol32(t_j(j), j % 32), 7);
+    ss2 = ss1 ^ rol32(vs1[0], 12);
+    tt1 = ff_j(vs1[0], vs1[1], vs1[2], j) + vs1[3] + ss2 + x0;
+    tt2 = gg_j(vs1[4], vs1[5], vs1[6], j) + vs1[7] + ss1 + vs2[0];
+    vs1[3] = vs1[2];
+    vd[3] = rol32(vs1[1], 9);
+    vs1[1] = vs1[0];
+    vd[1] = tt1;
+    vs1[7] = vs1[6];
+    vd[7] = rol32(vs1[5], 19);
+    vs1[5] = vs1[4];
+    vd[5] = p_0(tt2);
+    j = 2 * uimm + 1;
+    ss1 = rol32(rol32(vd[1], 12) + vd[5] + rol32(t_j(j), j % 32), 7);
+    ss2 = ss1 ^ rol32(vd[1], 12);
+    tt1 = ff_j(vd[1], vs1[1], vd[3], j) + vs1[3] + ss2 + x1;
+    tt2 = gg_j(vd[5], vs1[5], vd[7], j) + vs1[7] + ss1 + vs2[1];
+    vd[2] = rol32(vs1[1], 9);
+    vd[0] = tt1;
+    vd[6] = rol32(vs1[5], 19);
+    vd[4] = p_0(tt2);
+}
+
+void HELPER(vsm3c_vi)(void *vd_vptr, void *vs2_vptr, uint32_t uimm,
+                      CPURISCVState *env, uint32_t desc)
+{
+    uint32_t esz = memop_size(FIELD_EX64(env->vtype, VTYPE, VSEW));
+    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
+    uint32_t vta = vext_vta(desc);
+    uint32_t *vd = vd_vptr;
+    uint32_t *vs2 = vs2_vptr;
+    uint32_t v1[8], v2[8], v3[8];
+
+    for (int i = env->vstart / 8; i < env->vl / 8; i++) {
+        for (int k = 0; k < 8; k++) {
+            v2[k] = bswap32(vd[H4(i * 8 + k)]);
+            v3[k] = bswap32(vs2[H4(i * 8 + k)]);
+        }
+        sm3c(v1, v2, v3, uimm);
+        for (int k = 0; k < 8; k++) {
+            vd[i * 8 + k] = bswap32(v1[H4(k)]);
+        }
+    }
+    vext_set_elems_1s(vd_vptr, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
-- 
2.39.2


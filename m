Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578506B3AED
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCJJlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCJJkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:40:15 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B75A1517D
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:39:57 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYnf-00GpVx-F2; Fri, 10 Mar 2023 09:12:31 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 31/45] target/riscv: Add vsha2c[hl].vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 09:12:01 +0000
Message-Id: <20230310091215.931644-32-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                       |   2 +
 target/riscv/insn32.decode                  |   2 +
 target/riscv/insn_trans/trans_rvzvknh.c.inc |   2 +
 target/riscv/vcrypto_helper.c               | 140 ++++++++++++++++++++
 4 files changed, 146 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 76ea2ff49b..77bbd9db56 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1201,3 +1201,5 @@ DEF_HELPER_5(vaeskf1_vi, void, ptr, ptr, i32, env, i32)
 DEF_HELPER_5(vaeskf2_vi, void, ptr, ptr, i32, env, i32)
 
 DEF_HELPER_5(vsha2ms_vv, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vsha2ch_vv, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vsha2cl_vv, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index aef4d0b476..c95886040b 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -942,3 +942,5 @@ vaeskf2_vi      101010 1 ..... ..... 010 ..... 1110111 @r_vm_1
 
 # *** RV64 Zvknh vector crypto extension ***
 vsha2ms_vv      101101 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vsha2ch_vv      101110 1 ..... ..... 010 ..... 1110111 @r_vm_1
+vsha2cl_vv      101111 1 ..... ..... 010 ..... 1110111 @r_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvknh.c.inc b/target/riscv/insn_trans/trans_rvzvknh.c.inc
index 97bdf4d72f..3cf3ceaf3a 100644
--- a/target/riscv/insn_trans/trans_rvzvknh.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvknh.c.inc
@@ -80,3 +80,5 @@ static bool vsha_check(DisasContext *s, arg_rmrr *a)
 }
 
 GEN_VV_UNMASKED_TRANS(vsha2ms_vv, vsha_check, 4)
+GEN_VV_UNMASKED_TRANS(vsha2cl_vv, vsha_check, 4)
+GEN_VV_UNMASKED_TRANS(vsha2ch_vv, vsha_check, 4)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index ae253b3357..bf0455f8e0 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -526,3 +526,143 @@ void HELPER(vsha2ms_vv)(void *vd, void *vs1, void *vs2, CPURISCVState *env,
     vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
     env->vstart = 0;
 }
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
+                        ((uint64_t *)vs1) + 4 * i + 2);
+        } else {
+            vsha2c_32(((uint32_t *)vs2) + 4 * i, ((uint32_t *)vd) + 4 * i,
+                        ((uint32_t *)vs1) + 4 * i + 2);
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
+                        (((uint64_t *)vs1) + 4 * i));
+        } else {
+            vsha2c_32(((uint32_t *)vs2) + 4 * i, ((uint32_t *)vd) + 4 * i,
+                        (((uint32_t *)vs1) + 4 * i));
+        }
+    }
+
+    /* set tail elements to 1s */
+    total_elems = vext_get_total_elems(env, desc, esz);
+    vext_set_elems_1s(vd, vta, env->vl * esz, total_elems * esz);
+    env->vstart = 0;
+}
-- 
2.39.2


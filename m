Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6696B4C1E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjCJQHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjCJQGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:06:11 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FF3F249B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:12 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDm-00H4ad-Rq; Fri, 10 Mar 2023 16:03:54 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 21/45] target/riscv: Add vaesdm.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:22 +0000
Message-Id: <20230310160346.1193597-22-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                        |  1 +
 target/riscv/insn32.decode                   |  1 +
 target/riscv/insn_trans/trans_rvzvkned.c.inc |  1 +
 target/riscv/vcrypto_helper.c                | 36 ++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 059d63b0ea..9b04f90240 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1192,3 +1192,4 @@ DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index df1ae7425d..cdaa320f19 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -932,3 +932,4 @@ vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
+vaesdm_vv       101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkned.c.inc b/target/riscv/insn_trans/trans_rvzvkned.c.inc
index 7a14c33e01..4f1105ce1d 100644
--- a/target/riscv/insn_trans/trans_rvzvkned.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkned.c.inc
@@ -92,3 +92,4 @@ GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesef_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdf_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 69e0843ae4..f3b9070768 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -209,6 +209,38 @@ static inline void aes_inv_shift_bytes(uint8_t round_state[4][4])
     round_state[3][3] = temp;
 }
 
+static inline uint8_t xtime(uint8_t x)
+{
+    return (x << 1) ^ (((x >> 7) & 1) * 0x1b);
+}
+
+static inline uint8_t multiply(uint8_t x, uint8_t y)
+{
+    return (((y & 1) * x) ^ ((y >> 1 & 1) * xtime(x)) ^
+            ((y >> 2 & 1) * xtime(xtime(x))) ^
+            ((y >> 3 & 1) * xtime(xtime(xtime(x)))) ^
+            ((y >> 4 & 1) * xtime(xtime(xtime(xtime(x))))));
+}
+
+static inline void aes_inv_mix_cols(uint8_t round_state[4][4])
+{
+    uint8_t a, b, c, d;
+    for (int j = 0; j < 4; ++j) {
+        a = round_state[j][0];
+        b = round_state[j][1];
+        c = round_state[j][2];
+        d = round_state[j][3];
+        round_state[j][0] = multiply(a, 0x0e) ^ multiply(b, 0x0b) ^
+                            multiply(c, 0x0d) ^ multiply(d, 0x09);
+        round_state[j][1] = multiply(a, 0x09) ^ multiply(b, 0x0e) ^
+                            multiply(c, 0x0b) ^ multiply(d, 0x0d);
+        round_state[j][2] = multiply(a, 0x0d) ^ multiply(b, 0x09) ^
+                            multiply(c, 0x0e) ^ multiply(d, 0x0b);
+        round_state[j][3] = multiply(a, 0x0b) ^ multiply(b, 0x0d) ^
+                            multiply(c, 0x09) ^ multiply(d, 0x0e);
+    }
+}
+
 #define GEN_ZVKNED_HELPER_VV(NAME, ...)                                   \
 void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,      \
                   uint32_t desc)                                          \
@@ -287,3 +319,7 @@ GEN_ZVKNED_HELPER_VV(vaesdf_vv, aes_inv_shift_bytes(round_state);
 GEN_ZVKNED_HELPER_VS(vaesdf_vs, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VV(vaesdm_vv, aes_inv_shift_bytes(round_state);
+                    aes_inv_sub_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);
+                    aes_inv_mix_cols(round_state);)
-- 
2.39.2


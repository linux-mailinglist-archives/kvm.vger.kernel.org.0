Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544BB687DB0
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjBBMoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjBBMo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:26 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208D38BDE6
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:43:59 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvI-004Q6t-1X; Thu, 02 Feb 2023 12:42:40 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        William Salmon <will.salmon@codethink.co.uk>
Subject: [PATCH 19/39] target/riscv: Add vaesem.vv decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:10 +0000
Message-Id: <20230202124230.295997-20-lawrence.hunter@codethink.co.uk>
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

From: William Salmon <will.salmon@codethink.co.uk>

Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
---
 target/riscv/helper.h                       |  1 +
 target/riscv/insn32.decode                  |  1 +
 target/riscv/insn_trans/trans_rvzvkns.c.inc |  1 +
 target/riscv/vcrypto_helper.c               | 17 +++++++++++++++++
 4 files changed, 20 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index def126a59b..4bfc9a3387 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1185,6 +1185,7 @@ DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesem_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index b4ddc2586c..f31414f72c 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -914,6 +914,7 @@ vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
+vaesem_vv       101000 1 ..... 00010 010 ..... 1110111 @r2_vm_1
 vaesdm_vv       101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesdm_vs       101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesz_vs        101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkns.c.inc b/target/riscv/insn_trans/trans_rvzvkns.c.inc
index 022fdeec00..e9080c61d2 100644
--- a/target/riscv/insn_trans/trans_rvzvkns.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkns.c.inc
@@ -61,3 +61,4 @@ GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdm_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesz_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesem_vv, vaes_check_vv)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 39e2498b7d..a1d66a64aa 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -251,6 +251,20 @@ static inline void aes_inv_mix_cols(uint8_t round_state[4][4])
     }
 }
 
+static inline void aes_mix_cols(uint8_t round_state[4][4])
+{
+    uint8_t a, b;
+    for (int j = 0; j < 4; ++j) {
+        a = round_state[j][0];
+        b = round_state[j][0] ^ round_state[j][1] ^ round_state[j][2] ^
+            round_state[j][3];
+        round_state[j][0] ^= xtime(round_state[j][0] ^ round_state[j][1]) ^ b;
+        round_state[j][1] ^= xtime(round_state[j][1] ^ round_state[j][2]) ^ b;
+        round_state[j][2] ^= xtime(round_state[j][2] ^ round_state[j][3]) ^ b;
+        round_state[j][3] ^= xtime(round_state[j][3] ^ a) ^ b;
+    }
+}
+
 #define GEN_ZVKNS_HELPER_VV(NAME, ...)                                    \
 void HELPER(NAME)(void *vd_vptr, void *vs2_vptr, CPURISCVState *env,      \
                   uint32_t desc)                                          \
@@ -333,6 +347,9 @@ GEN_ZVKNS_HELPER_VV(vaesdf_vv, aes_inv_shift_bytes(round_state);
 GEN_ZVKNS_HELPER_VS(vaesdf_vs, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNS_HELPER_VV(vaesem_vv, aes_shift_bytes(round_state);
+                    aes_sub_bytes(round_state); aes_mix_cols(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
 GEN_ZVKNS_HELPER_VV(vaesdm_vv, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);
-- 
2.39.1


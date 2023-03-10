Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F056B4C1C
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjCJQHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCJQGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:06:08 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F5E4C73
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:11 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDo-00H4ad-0H; Fri, 10 Mar 2023 16:03:56 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        William Salmon <will.salmon@codethink.co.uk>
Subject: [PATCH 25/45] target/riscv: Add vaesem.vs decoding, translation and execution support
Date:   Fri, 10 Mar 2023 16:03:26 +0000
Message-Id: <20230310160346.1193597-26-lawrence.hunter@codethink.co.uk>
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

From: William Salmon <will.salmon@codethink.co.uk>

Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
---
 target/riscv/helper.h                        | 1 +
 target/riscv/insn32.decode                   | 1 +
 target/riscv/insn_trans/trans_rvzvkned.c.inc | 1 +
 target/riscv/vcrypto_helper.c                | 3 +++
 4 files changed, 6 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index c55d59dc5e..946ae8c51d 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1193,6 +1193,7 @@ DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesem_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesem_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index f03b41f9e2..3187c5cc64 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -933,6 +933,7 @@ vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesem_vv       101000 1 ..... 00010 010 ..... 1110111 @r2_vm_1
+vaesem_vs       101001 1 ..... 00010 010 ..... 1110111 @r2_vm_1
 vaesdm_vv       101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesdm_vs       101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesz_vs        101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkned.c.inc b/target/riscv/insn_trans/trans_rvzvkned.c.inc
index 0b54d6e9d3..028f04a4d7 100644
--- a/target/riscv/insn_trans/trans_rvzvkned.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkned.c.inc
@@ -96,3 +96,4 @@ GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdm_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesz_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesem_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesem_vs, vaes_check_vs)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index beef7699db..600069adb1 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -336,6 +336,9 @@ GEN_ZVKNED_HELPER_VS(vaesdf_vs, aes_inv_shift_bytes(round_state);
 GEN_ZVKNED_HELPER_VV(vaesem_vv, aes_shift_bytes(round_state);
                     aes_sub_bytes(round_state); aes_mix_cols(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNED_HELPER_VS(vaesem_vs, aes_shift_bytes(round_state);
+                    aes_sub_bytes(round_state); aes_mix_cols(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
 GEN_ZVKNED_HELPER_VV(vaesdm_vv, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957F4687E74
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjBBNT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBBNTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:19:55 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3059784969
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:19:53 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvH-004Q6t-Gv; Thu, 02 Feb 2023 12:42:40 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 17/39] target/riscv: Add vaesdm.vs decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:08 +0000
Message-Id: <20230202124230.295997-18-lawrence.hunter@codethink.co.uk>
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

Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                       | 1 +
 target/riscv/insn32.decode                  | 1 +
 target/riscv/insn_trans/trans_rvzvkns.c.inc | 1 +
 target/riscv/vcrypto_helper.c               | 4 ++++
 4 files changed, 7 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 328a026039..9895bf5712 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1186,3 +1186,4 @@ DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index e5f3af999d..753039e954 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -915,3 +915,4 @@ vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdm_vv       101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
+vaesdm_vs       101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkns.c.inc b/target/riscv/insn_trans/trans_rvzvkns.c.inc
index 6cb25d0d88..1459cb6d26 100644
--- a/target/riscv/insn_trans/trans_rvzvkns.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkns.c.inc
@@ -57,3 +57,4 @@ GEN_V_UNMASKED_TRANS(vaesef_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdf_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesdm_vs, vaes_check_vs)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index bac21b5623..699bf25bbd 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -337,3 +337,7 @@ GEN_ZVKNS_HELPER_VV(vaesdm_vv, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);
                     aes_inv_mix_cols(round_state);)
+GEN_ZVKNS_HELPER_VS(vaesdm_vs, aes_inv_shift_bytes(round_state);
+                    aes_inv_sub_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);
+                    aes_inv_mix_cols(round_state);)
-- 
2.39.1


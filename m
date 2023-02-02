Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB92687E77
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjBBNUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjBBNT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:19:57 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9308E058
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:19:56 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvH-004Q6t-0K; Thu, 02 Feb 2023 12:42:39 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 15/39] target/riscv: Add vaesdf.vs decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:06 +0000
Message-Id: <20230202124230.295997-16-lawrence.hunter@codethink.co.uk>
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
 target/riscv/vcrypto_helper.c               | 3 +++
 4 files changed, 6 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index b7696cb6c4..020b9861cf 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1184,3 +1184,4 @@ DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_4(vaesef_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesef_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index ca907dac85..33e5883937 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -913,3 +913,4 @@ vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
 vaesef_vv       101000 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesef_vs       101001 1 ..... 00011 010 ..... 1110111 @r2_vm_1
 vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
+vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkns.c.inc b/target/riscv/insn_trans/trans_rvzvkns.c.inc
index 2e09deeb84..2d6a92c153 100644
--- a/target/riscv/insn_trans/trans_rvzvkns.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkns.c.inc
@@ -55,3 +55,4 @@ static bool vaes_check_vs(DisasContext *s, arg_rmr *a)
 GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesef_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdf_vv, vaes_check_vv)
+GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 24b5336fa7..d3ba5e9cb8 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -298,3 +298,6 @@ GEN_ZVKNS_HELPER_VS(vaesef_vs, aes_sub_bytes(round_state);
 GEN_ZVKNS_HELPER_VV(vaesdf_vv, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);)
+GEN_ZVKNS_HELPER_VS(vaesdf_vs, aes_inv_shift_bytes(round_state);
+                    aes_inv_sub_bytes(round_state);
+                    xor_round_key(round_state, (uint8_t *)round_key);)
-- 
2.39.1


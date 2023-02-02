Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E87687DBC
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjBBMpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjBBMou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:50 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72C88B360
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:28 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvH-004Q6t-PN; Thu, 02 Feb 2023 12:42:40 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 18/39] target/riscv: Add vaesz.vs decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:09 +0000
Message-Id: <20230202124230.295997-19-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                       |  1 +
 target/riscv/insn32.decode                  |  1 +
 target/riscv/insn_trans/trans_rvzvkns.c.inc | 13 ++++++++-----
 target/riscv/vcrypto_helper.c               |  2 ++
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 9895bf5712..def126a59b 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1187,3 +1187,4 @@ DEF_HELPER_4(vaesdf_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdf_vs, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vv, void, ptr, ptr, env, i32)
 DEF_HELPER_4(vaesdm_vs, void, ptr, ptr, env, i32)
+DEF_HELPER_4(vaesz_vs, void, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 753039e954..b4ddc2586c 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -916,3 +916,4 @@ vaesdf_vv       101000 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdf_vs       101001 1 ..... 00001 010 ..... 1110111 @r2_vm_1
 vaesdm_vv       101000 1 ..... 00000 010 ..... 1110111 @r2_vm_1
 vaesdm_vs       101001 1 ..... 00000 010 ..... 1110111 @r2_vm_1
+vaesz_vs        101001 1 ..... 00111 010 ..... 1110111 @r2_vm_1
diff --git a/target/riscv/insn_trans/trans_rvzvkns.c.inc b/target/riscv/insn_trans/trans_rvzvkns.c.inc
index 1459cb6d26..022fdeec00 100644
--- a/target/riscv/insn_trans/trans_rvzvkns.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkns.c.inc
@@ -41,15 +41,17 @@ static bool vaes_check_vv(DisasContext *s, arg_rmr *a)
 static bool vaes_check_overlap(DisasContext *s, int vd, int vs2)
 {
     int8_t op_size = s->lmul <= 0 ? 1 : 1 << s->lmul;
-    return !is_overlapped(vd, op_size, vs2, op_size);
+    return !is_overlapped(vd, op_size, vs2, 1);
 }
 
 static bool vaes_check_vs(DisasContext *s, arg_rmr *a)
 {
-    return vaes_check_overlap(s, a->rd, a->rs2) &&
-           s->cfg_ptr->ext_zvkns == true && vext_check_isa_ill(s) &&
-           require_align(a->rd, s->lmul) && s->vstart % 4 == 0 &&
-           s->sew == MO_32;
+    return require_rvv(s) &&
+           vaes_check_overlap(s, a->rd, a->rs2) &&
+           s->cfg_ptr->ext_zvkns == true &&
+           vext_check_isa_ill(s) &&
+           require_align(a->rd, s->lmul) &&
+           s->vstart % 4 == 0 && s->sew == MO_32;
 }
 
 GEN_V_UNMASKED_TRANS(vaesef_vv, vaes_check_vv)
@@ -58,3 +60,4 @@ GEN_V_UNMASKED_TRANS(vaesdf_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdf_vs, vaes_check_vs)
 GEN_V_UNMASKED_TRANS(vaesdm_vv, vaes_check_vv)
 GEN_V_UNMASKED_TRANS(vaesdm_vs, vaes_check_vs)
+GEN_V_UNMASKED_TRANS(vaesz_vs, vaes_check_vs)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 699bf25bbd..39e2498b7d 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -341,3 +341,5 @@ GEN_ZVKNS_HELPER_VS(vaesdm_vs, aes_inv_shift_bytes(round_state);
                     aes_inv_sub_bytes(round_state);
                     xor_round_key(round_state, (uint8_t *)round_key);
                     aes_inv_mix_cols(round_state);)
+GEN_ZVKNS_HELPER_VS(vaesz_vs,
+                    xor_round_key(round_state, (uint8_t *)round_key);)
-- 
2.39.1


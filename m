Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E4687DBE
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbjBBMpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjBBMov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:51 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9628D621
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:29 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvF-004Q6t-H4; Thu, 02 Feb 2023 12:42:38 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 09/39] target/riscv: Add vandn.[vv,vx,vi] decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:42:00 +0000
Message-Id: <20230202124230.295997-10-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 target/riscv/helper.h                      |  9 +++++++++
 target/riscv/insn32.decode                 |  3 +++
 target/riscv/insn_trans/trans_rvzvkb.c.inc |  5 +++++
 target/riscv/vcrypto_helper.c              | 19 +++++++++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index c980d52828..5de615ea78 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1171,3 +1171,12 @@ DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
+
+DEF_HELPER_6(vandn_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 342199abc0..d6f5e4d198 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -904,3 +904,6 @@ vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
 vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
 vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
 vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
+vandn_vi        000001 . ..... ..... 011 ..... 1010111 @r_vm
+vandn_vv        000001 . ..... ..... 000 ..... 1010111 @r_vm
+vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 18b362db92..a973b27bdd 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -147,6 +147,11 @@ static bool trans_##NAME(DisasContext *s, arg_rmr * a)                 \
     return false;                                                      \
 }
 
+
+GEN_OPIVV_TRANS(vandn_vv, zvkb_vv_check)
+GEN_OPIVX_TRANS(vandn_vx, zvkb_vx_check)
+GEN_OPIVI_TRANS(vandn_vi, IMM_SX, vandn_vx, zvkb_vx_check)
+
 static bool vxrev8_check(DisasContext *s, arg_rmr *a)
 {
     return s->cfg_ptr->ext_zvkb == true && vext_check_isa_ill(s) &&
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index b09fe5fa2a..900e68dfb0 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -135,3 +135,22 @@ GEN_VEXT_V(vrev8_v_b, 1)
 GEN_VEXT_V(vrev8_v_h, 2)
 GEN_VEXT_V(vrev8_v_w, 4)
 GEN_VEXT_V(vrev8_v_d, 8)
+
+#define DO_ANDN(a, b) ((b) & ~(a))
+RVVCALL(OPIVV2, vandn_vv_b, OP_UUU_B, H1, H1, H1, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_h, OP_UUU_H, H2, H2, H2, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_w, OP_UUU_W, H4, H4, H4, DO_ANDN)
+RVVCALL(OPIVV2, vandn_vv_d, OP_UUU_D, H8, H8, H8, DO_ANDN)
+GEN_VEXT_VV(vandn_vv_b, 1)
+GEN_VEXT_VV(vandn_vv_h, 2)
+GEN_VEXT_VV(vandn_vv_w, 4)
+GEN_VEXT_VV(vandn_vv_d, 8)
+
+RVVCALL(OPIVX2, vandn_vx_b, OP_UUU_B, H1, H1, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_h, OP_UUU_H, H2, H2, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_w, OP_UUU_W, H4, H4, DO_ANDN)
+RVVCALL(OPIVX2, vandn_vx_d, OP_UUU_D, H8, H8, DO_ANDN)
+GEN_VEXT_VX(vandn_vx_b, 1)
+GEN_VEXT_VX(vandn_vx_h, 2)
+GEN_VEXT_VX(vandn_vx_w, 4)
+GEN_VEXT_VX(vandn_vx_d, 8)
-- 
2.39.1


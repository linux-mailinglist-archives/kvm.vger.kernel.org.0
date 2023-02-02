Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07349687DBA
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjBBMpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjBBMox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:53 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5778DAE4
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:29 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvF-004Q6t-9B; Thu, 02 Feb 2023 12:42:38 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 08/39] target/riscv: Add vrev8.v decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:41:59 +0000
Message-Id: <20230202124230.295997-9-lawrence.hunter@codethink.co.uk>
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
 target/riscv/helper.h                      |  4 ++++
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc |  1 +
 target/riscv/vcrypto_helper.c              | 10 ++++++++++
 4 files changed, 16 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index c94627d8a4..c980d52828 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1163,6 +1163,10 @@ DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
 
+DEF_HELPER_5(vrev8_v_b, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_h, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_w, void, ptr, ptr, ptr, env, i32)
+DEF_HELPER_5(vrev8_v_d, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
 DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 782632a165..342199abc0 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -903,3 +903,4 @@ vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
 vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
 vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
 vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
+vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 591980459a..18b362db92 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -154,3 +154,4 @@ static bool vxrev8_check(DisasContext *s, arg_rmr *a)
 }
 
 GEN_OPIV_TRANS(vbrev8_v, vxrev8_check)
+GEN_OPIV_TRANS(vrev8_v, vxrev8_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 303a656141..b09fe5fa2a 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -125,3 +125,13 @@ GEN_VEXT_V(vbrev8_v_b, 1)
 GEN_VEXT_V(vbrev8_v_h, 2)
 GEN_VEXT_V(vbrev8_v_w, 4)
 GEN_VEXT_V(vbrev8_v_d, 8)
+
+#define DO_VREV8_B(a) (a)
+RVVCALL(OPIVV1, vrev8_v_b, OP_UU_B, H1, H1, DO_VREV8_B)
+RVVCALL(OPIVV1, vrev8_v_h, OP_UU_H, H2, H2, bswap16)
+RVVCALL(OPIVV1, vrev8_v_w, OP_UU_W, H4, H4, bswap32)
+RVVCALL(OPIVV1, vrev8_v_d, OP_UU_D, H8, H8, bswap64)
+GEN_VEXT_V(vrev8_v_b, 1)
+GEN_VEXT_V(vrev8_v_h, 2)
+GEN_VEXT_V(vrev8_v_w, 4)
+GEN_VEXT_V(vrev8_v_d, 8)
-- 
2.39.1


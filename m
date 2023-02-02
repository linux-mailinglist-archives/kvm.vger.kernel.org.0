Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5D687DBB
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjBBMpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjBBMo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:57 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106188B7CA
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:33 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvE-004Q6t-IG; Thu, 02 Feb 2023 12:42:37 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 05/39] target/riscv: Add vclmulh.vx decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:41:56 +0000
Message-Id: <20230202124230.295997-6-lawrence.hunter@codethink.co.uk>
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

Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  1 +
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc |  1 +
 target/riscv/vcrypto_helper.c              | 12 ++++++++++++
 4 files changed, 15 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index a155272701..32f1179e29 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1141,3 +1141,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
 DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
 DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
+DEF_HELPER_6(vclmulh_vx, void, ptr, ptr, tl, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index e26ea1df08..b4d88dd1cb 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -895,3 +895,4 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
 vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
 vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
 vclmulh_vv      001101 . ..... ..... 010 ..... 1010111 @r_vm
+vclmulh_vx      001101 . ..... ..... 110 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 19ce4c7431..533141e559 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -94,3 +94,4 @@ static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
 }
 
 GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
+GEN_VX_MASKED_TRANS(vclmulh_vx, vclmul_vx_check)
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 022b941131..46e2e510c5 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -42,6 +42,18 @@ static void do_vclmulh_vv(void *vd, void *vs1, void *vs2, int i)
     ((uint64_t *)vd)[i] = (result >> 64);
 }
 
+static void do_vclmulh_vx(void *vd, target_long rs1, void *vs2, int i)
+{
+    __uint128_t result = 0;
+    for (int j = 63; j >= 0; j--) {
+        if ((rs1 >> j) & 1) {
+            result ^= (((__uint128_t)(((uint64_t *)vs2)[i])) << j);
+        }
+    }
+    ((uint64_t *)vd)[i] = (result >> 64);
+}
+
 GEN_VEXT_VV(vclmul_vv, 8)
 GEN_VEXT_VX(vclmul_vx, 8)
 GEN_VEXT_VV(vclmulh_vv, 8)
+GEN_VEXT_VX(vclmulh_vx, 8)
-- 
2.39.1


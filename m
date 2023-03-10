Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE106B3A2E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjCJJRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCJJQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:16:55 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAA2149BE
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:13:01 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYnZ-00GpVx-D4; Fri, 10 Mar 2023 09:12:25 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 06/45] target/riscv: Add vclmulh.vv decoding, translation and execution support
Date:   Fri, 10 Mar 2023 09:11:36 +0000
Message-Id: <20230310091215.931644-7-lawrence.hunter@codethink.co.uk>
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

Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
---
 target/riscv/helper.h                      |  1 +
 target/riscv/insn32.decode                 |  1 +
 target/riscv/insn_trans/trans_rvzvkb.c.inc |  1 +
 target/riscv/vcrypto_helper.c              | 13 +++++++++++++
 4 files changed, 16 insertions(+)

diff --git a/target/riscv/helper.h b/target/riscv/helper.h
index 352921ead6..1c69c34a78 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1146,3 +1146,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 /* Vector crypto functions */
 DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
 DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 6b8466424d..3ad8e2055b 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -912,3 +912,4 @@ czero_nez   0000111  ..... ..... 111 ..... 0110011 @r
 # *** RV64 Zvkb vector crypto extension ***
 vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
 vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
+vclmulh_vv      001101 . ..... ..... 010 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 76efade1b6..63a8778acc 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -38,6 +38,7 @@ static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
 }
 
 GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
+GEN_VV_MASKED_TRANS(vclmulh_vv, vclmul_vv_check)
 
 #define GEN_VX_MASKED_TRANS(NAME, CHECK)                                \
 static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                  \
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index 749a9cb30b..1891c29767 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -38,7 +38,20 @@ static uint64_t clmul64(uint64_t y, uint64_t x)
     return result;
 }
 
+static uint64_t clmulh64(uint64_t y, uint64_t x)
+{
+    uint64_t result = 0;
+    for (int j = 63; j >= 1; j--) {
+        if ((y >> j) & 1) {
+            result ^= (x >> (64 - j));
+        }
+    }
+    return result;
+}
+
 RVVCALL(OPIVV2, vclmul_vv, OP_UUU_D, H8, H8, H8, clmul64)
 GEN_VEXT_VV(vclmul_vv, 8)
 RVVCALL(OPIVX2, vclmul_vx, OP_UUU_D, H8, H8, clmul64)
 GEN_VEXT_VX(vclmul_vx, 8)
+RVVCALL(OPIVV2, vclmulh_vv, OP_UUU_D, H8, H8, H8, clmulh64)
+GEN_VEXT_VV(vclmulh_vv, 8)
-- 
2.39.2


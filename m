Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0236F687DBD
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBBMpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjBBMoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:46 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E9F88F0E
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:44:26 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvE-004Q6t-A8; Thu, 02 Feb 2023 12:42:37 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH 04/39] target/riscv: Add vclmulh.vv decoding, translation and execution support
Date:   Thu,  2 Feb 2023 12:41:55 +0000
Message-Id: <20230202124230.295997-5-lawrence.hunter@codethink.co.uk>
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
index 6c786ef6f3..a155272701 100644
--- a/target/riscv/helper.h
+++ b/target/riscv/helper.h
@@ -1140,3 +1140,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
 /* Vector crypto functions */
 DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
 DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
+DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
index 4a7421354d..e26ea1df08 100644
--- a/target/riscv/insn32.decode
+++ b/target/riscv/insn32.decode
@@ -894,3 +894,4 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
 # *** RV64 Zvkb vector crypto extension ***
 vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
 vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
+vclmulh_vv      001101 . ..... ..... 010 ..... 1010111 @r_vm
diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
index 6e8b81136c..19ce4c7431 100644
--- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
+++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
@@ -39,6 +39,7 @@ static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
 }
 
 GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
+GEN_VV_MASKED_TRANS(vclmulh_vv, vclmul_vv_check)
 
 #define GEN_VX_MASKED_TRANS(NAME, CHECK)                                \
 static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                  \
diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
index c453d348ad..022b941131 100644
--- a/target/riscv/vcrypto_helper.c
+++ b/target/riscv/vcrypto_helper.c
@@ -31,5 +31,17 @@ static void do_vclmul_vx(void *vd, target_long rs1, void *vs2, int i)
     ((uint64_t *)vd)[i] = result;
 }
 
+static void do_vclmulh_vv(void *vd, void *vs1, void *vs2, int i)
+{
+    __uint128_t result = 0;
+    for (int j = 63; j >= 0; j--) {
+        if ((((uint64_t *)vs1)[i] >> j) & 1) {
+            result ^= (((__uint128_t)(((uint64_t *)vs2)[i])) << j);
+        }
+    }
+    ((uint64_t *)vd)[i] = (result >> 64);
+}
+
 GEN_VEXT_VV(vclmul_vv, 8)
 GEN_VEXT_VX(vclmul_vx, 8)
+GEN_VEXT_VV(vclmulh_vv, 8)
-- 
2.39.1


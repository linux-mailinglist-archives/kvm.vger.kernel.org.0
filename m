Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AA96F1B91
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjD1PaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjD1PaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:30:07 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D611BF0
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:30:05 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPON-005zz5-7h; Fri, 28 Apr 2023 15:48:11 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
Subject: [PATCH v3 09/19] tcg: Add andcs and rotrs tcg gvec ops
Date:   Fri, 28 Apr 2023 15:47:47 +0100
Message-Id: <20230428144757.57530-10-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

This commit adds helper functions and tcg operation definitions for the andcs and rotrs instructions

Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 accel/tcg/tcg-runtime-gvec.c | 11 +++++++++++
 accel/tcg/tcg-runtime.h      |  1 +
 include/tcg/tcg-op-gvec.h    |  4 ++++
 tcg/tcg-op-gvec.c            | 23 +++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/accel/tcg/tcg-runtime-gvec.c b/accel/tcg/tcg-runtime-gvec.c
index ac7d28c251e..97399493d54 100644
--- a/accel/tcg/tcg-runtime-gvec.c
+++ b/accel/tcg/tcg-runtime-gvec.c
@@ -550,6 +550,17 @@ void HELPER(gvec_ands)(void *d, void *a, uint64_t b, uint32_t desc)
     clear_high(d, oprsz, desc);
 }
 
+void HELPER(gvec_andcs)(void *d, void *a, uint64_t b, uint32_t desc)
+{
+    intptr_t oprsz = simd_oprsz(desc);
+    intptr_t i;
+
+    for (i = 0; i < oprsz; i += sizeof(uint64_t)) {
+        *(uint64_t *)(d + i) = *(uint64_t *)(a + i) & ~b;
+    }
+    clear_high(d, oprsz, desc);
+}
+
 void HELPER(gvec_xors)(void *d, void *a, uint64_t b, uint32_t desc)
 {
     intptr_t oprsz = simd_oprsz(desc);
diff --git a/accel/tcg/tcg-runtime.h b/accel/tcg/tcg-runtime.h
index e141a6ab242..b8e6421c8ac 100644
--- a/accel/tcg/tcg-runtime.h
+++ b/accel/tcg/tcg-runtime.h
@@ -217,6 +217,7 @@ DEF_HELPER_FLAGS_4(gvec_nor, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
 DEF_HELPER_FLAGS_4(gvec_eqv, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
 
 DEF_HELPER_FLAGS_4(gvec_ands, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
+DEF_HELPER_FLAGS_4(gvec_andcs, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 DEF_HELPER_FLAGS_4(gvec_xors, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 DEF_HELPER_FLAGS_4(gvec_ors, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
 
diff --git a/include/tcg/tcg-op-gvec.h b/include/tcg/tcg-op-gvec.h
index 28cafbcc5ce..a8183bfeabe 100644
--- a/include/tcg/tcg-op-gvec.h
+++ b/include/tcg/tcg-op-gvec.h
@@ -330,6 +330,8 @@ void tcg_gen_gvec_ori(unsigned vece, uint32_t dofs, uint32_t aofs,
 
 void tcg_gen_gvec_ands(unsigned vece, uint32_t dofs, uint32_t aofs,
                        TCGv_i64 c, uint32_t oprsz, uint32_t maxsz);
+void tcg_gen_gvec_andcs(unsigned vece, uint32_t dofs, uint32_t aofs,
+                        TCGv_i64 c, uint32_t oprsz, uint32_t maxsz);
 void tcg_gen_gvec_xors(unsigned vece, uint32_t dofs, uint32_t aofs,
                        TCGv_i64 c, uint32_t oprsz, uint32_t maxsz);
 void tcg_gen_gvec_ors(unsigned vece, uint32_t dofs, uint32_t aofs,
@@ -369,6 +371,8 @@ void tcg_gen_gvec_sars(unsigned vece, uint32_t dofs, uint32_t aofs,
                        TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz);
 void tcg_gen_gvec_rotls(unsigned vece, uint32_t dofs, uint32_t aofs,
                         TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz);
+void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
+                        TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz);
 
 /*
  * Perform vector shift by vector element, modulo the element size.
diff --git a/tcg/tcg-op-gvec.c b/tcg/tcg-op-gvec.c
index 047a832f44a..3bbc9573e0b 100644
--- a/tcg/tcg-op-gvec.c
+++ b/tcg/tcg-op-gvec.c
@@ -2761,6 +2761,21 @@ void tcg_gen_gvec_andi(unsigned vece, uint32_t dofs, uint32_t aofs,
     tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, tmp, &gop_ands);
 }
 
+void tcg_gen_gvec_andcs(unsigned vece, uint32_t dofs, uint32_t aofs,
+                        TCGv_i64 c, uint32_t oprsz, uint32_t maxsz)
+{
+    static GVecGen2s g = {
+        .fni8 = tcg_gen_andc_i64,
+        .fniv = tcg_gen_andc_vec,
+        .fno = gen_helper_gvec_andcs,
+        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
+        .vece = MO_64
+    };
+
+    tcg_gen_dup_i64(vece, c, c);
+    tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, c, &g);
+}
+
 static const GVecGen2s gop_xors = {
     .fni8 = tcg_gen_xor_i64,
     .fniv = tcg_gen_xor_vec,
@@ -3336,6 +3351,14 @@ void tcg_gen_gvec_rotls(unsigned vece, uint32_t dofs, uint32_t aofs,
     do_gvec_shifts(vece, dofs, aofs, shift, oprsz, maxsz, &g);
 }
 
+void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
+                        TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
+{
+    TCGv_i32 tmp = tcg_temp_new_i32();
+    tcg_gen_sub_i32(tmp, tcg_constant_i32(1 << (vece + 3)), shift);
+    tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
+}
+
 /*
  * Expand D = A << (B % element bits)
  *
-- 
2.40.1


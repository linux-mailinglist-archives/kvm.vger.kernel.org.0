Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E506B4C0E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCJQG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCJQGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:06:05 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A26DB862C
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:04:10 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pafDi-00H4ad-4o; Fri, 10 Mar 2023 16:03:50 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 04/45] target/riscv: Refactor some of the generic vector functionality
Date:   Fri, 10 Mar 2023 16:03:05 +0000
Message-Id: <20230310160346.1193597-5-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk>
References: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

This refactoring ensures these functions/macros can be used by both
vector and vector-crypto helpers (latter implemented in proceeding
commit).

Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
---
 target/riscv/vector_helper.c    | 46 ---------------------------------
 target/riscv/vector_internals.c | 24 +++++++++++++++++
 target/riscv/vector_internals.h | 27 +++++++++++++++++++
 3 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index f0e8ceff80..27fefef10e 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -686,18 +686,6 @@ GEN_VEXT_VV(vsub_vv_h, 2)
 GEN_VEXT_VV(vsub_vv_w, 4)
 GEN_VEXT_VV(vsub_vv_d, 8)
 
-typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
-
-/*
- * (T1)s1 gives the real operator type.
- * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
- */
-#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
-static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
-{                                                                   \
-    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
-    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
-}
 
 RVVCALL(OPIVX2, vadd_vx_b, OP_SSS_B, H1, H1, DO_ADD)
 RVVCALL(OPIVX2, vadd_vx_h, OP_SSS_H, H2, H2, DO_ADD)
@@ -712,40 +700,6 @@ RVVCALL(OPIVX2, vrsub_vx_h, OP_SSS_H, H2, H2, DO_RSUB)
 RVVCALL(OPIVX2, vrsub_vx_w, OP_SSS_W, H4, H4, DO_RSUB)
 RVVCALL(OPIVX2, vrsub_vx_d, OP_SSS_D, H8, H8, DO_RSUB)
 
-static void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
-                       CPURISCVState *env, uint32_t desc,
-                       opivx2_fn fn, uint32_t esz)
-{
-    uint32_t vm = vext_vm(desc);
-    uint32_t vl = env->vl;
-    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
-    uint32_t vta = vext_vta(desc);
-    uint32_t vma = vext_vma(desc);
-    uint32_t i;
-
-    for (i = env->vstart; i < vl; i++) {
-        if (!vm && !vext_elem_mask(v0, i)) {
-            /* set masked-off elements to 1s */
-            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
-            continue;
-        }
-        fn(vd, s1, vs2, i);
-    }
-    env->vstart = 0;
-    /* set tail elements to 1s */
-    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
-}
-
-/* generate the helpers for OPIVX */
-#define GEN_VEXT_VX(NAME, ESZ)                            \
-void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
-                  void *vs2, CPURISCVState *env,          \
-                  uint32_t desc)                          \
-{                                                         \
-    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
-               do_##NAME, ESZ);                           \
-}
-
 GEN_VEXT_VX(vadd_vx_b, 1)
 GEN_VEXT_VX(vadd_vx_h, 2)
 GEN_VEXT_VX(vadd_vx_w, 4)
diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_internals.c
index 95efaa79cb..9cf5c17cde 100644
--- a/target/riscv/vector_internals.c
+++ b/target/riscv/vector_internals.c
@@ -55,3 +55,27 @@ void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
     /* set tail elements to 1s */
     vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
 }
+
+void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivx2_fn fn, uint32_t esz)
+{
+    uint32_t vm = vext_vm(desc);
+    uint32_t vl = env->vl;
+    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
+    uint32_t vta = vext_vta(desc);
+    uint32_t vma = vext_vma(desc);
+    uint32_t i;
+
+    for (i = env->vstart; i < vl; i++) {
+        if (!vm && !vext_elem_mask(v0, i)) {
+            /* set masked-off elements to 1s */
+            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
+            continue;
+        }
+        fn(vd, s1, vs2, i);
+    }
+    env->vstart = 0;
+    /* set tail elements to 1s */
+    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
+}
diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
index a04b7321fb..749d138beb 100644
--- a/target/riscv/vector_internals.h
+++ b/target/riscv/vector_internals.h
@@ -152,4 +152,31 @@ void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
                do_##NAME, ESZ);                           \
 }
 
+typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
+
+/*
+ * (T1)s1 gives the real operator type.
+ * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
+ */
+#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
+static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
+{                                                                   \
+    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
+    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
+}
+
+void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
+                CPURISCVState *env, uint32_t desc,
+                opivx2_fn fn, uint32_t esz);
+
+/* generate the helpers for OPIVX */
+#define GEN_VEXT_VX(NAME, ESZ)                            \
+void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
+                  void *vs2, CPURISCVState *env,          \
+                  uint32_t desc)                          \
+{                                                         \
+    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
+               do_##NAME, ESZ);                           \
+}
+
 #endif /* TARGET_RISCV_VECTOR_INTERNALS_H */
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454E952F2E0
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 20:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348929AbiETSdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 14:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbiETSdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 14:33:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642719321E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:33:05 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ns7Qs-0008MU-2p; Fri, 20 May 2022 20:33:02 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH] target/i386/kvm: Fix disabling MPX on "-cpu host" with MPX-capable host
Date:   Fri, 20 May 2022 20:32:56 +0200
Message-Id: <be14c1e895a2f452047451f050d269217dcee6d9.1653071510.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Since KVM commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
it is not possible to disable MPX on a "-cpu host" just by adding "-mpx"
there if the host CPU does indeed support MPX.
QEMU will fail to set MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS MSRs in this case
and so trigger an assertion failure.

Instead, besides "-mpx" one has to explicitly add also
"-vmx-exit-clear-bndcfgs" and "-vmx-entry-load-bndcfgs" to QEMU command
line to make it work, which is a bit convoluted.

Sanitize MPX-related bits in MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS after
setting the vCPU CPUID instead so such workarounds are no longer necessary.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 target/i386/kvm/kvm.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a9ee8eebd7..435cb18753 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2934,6 +2934,17 @@ static uint64_t make_vmx_msr_value(uint32_t index, uint32_t features)
     return must_be_one | (((uint64_t)can_be_one) << 32);
 }
 
+static void kvm_msr_entry_add_if_supported(X86CPU *cpu, uint32_t msr,
+                                           uint32_t mask, uint32_t features,
+                                           uint64_t value_or)
+{
+    uint32_t supported =
+        kvm_arch_get_supported_msr_feature(kvm_state, msr) >> 32;
+    uint32_t feat_eff = features & (~mask | (mask & supported));
+
+    kvm_msr_entry_add(cpu, msr, make_vmx_msr_value(msr, feat_eff) | value_or);
+}
+
 static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
 {
     uint64_t kvm_vmx_basic =
@@ -2996,12 +3007,23 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_TRUE_PINBASED_CTLS,
                       make_vmx_msr_value(MSR_IA32_VMX_TRUE_PINBASED_CTLS,
                                          f[FEAT_VMX_PINBASED_CTLS]));
-    kvm_msr_entry_add(cpu, MSR_IA32_VMX_TRUE_EXIT_CTLS,
-                      make_vmx_msr_value(MSR_IA32_VMX_TRUE_EXIT_CTLS,
-                                         f[FEAT_VMX_EXIT_CTLS]) | fixed_vmx_exit);
-    kvm_msr_entry_add(cpu, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
-                      make_vmx_msr_value(MSR_IA32_VMX_TRUE_ENTRY_CTLS,
-                                         f[FEAT_VMX_ENTRY_CTLS]));
+
+    /*
+     * When disabling MPX on a host that supports this function it is not
+     * enough to clear the relevant CPUID bit, MPX-related bits in
+     * MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS have to be cleared, too.
+     *
+     * Otherwise setting these MSRs will fail.
+     */
+    kvm_msr_entry_add_if_supported(cpu, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+                                   VMX_VM_EXIT_CLEAR_BNDCFGS,
+                                   f[FEAT_VMX_EXIT_CTLS],
+                                   fixed_vmx_exit);
+    kvm_msr_entry_add_if_supported(cpu, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+                                   VMX_VM_ENTRY_LOAD_BNDCFGS,
+                                   f[FEAT_VMX_ENTRY_CTLS],
+                                   0);
+
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_PROCBASED_CTLS2,
                       make_vmx_msr_value(MSR_IA32_VMX_PROCBASED_CTLS2,
                                          f[FEAT_VMX_SECONDARY_CTLS]));

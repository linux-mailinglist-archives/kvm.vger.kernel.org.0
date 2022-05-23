Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374A353178D
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiEWQ1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbiEWQ1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:27:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C815E62CCA
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:27:08 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ntAtc-0007jX-GQ; Mon, 23 May 2022 18:27:04 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v2] target/i386/kvm: Fix disabling MPX on "-cpu host" with MPX-capable host
Date:   Mon, 23 May 2022 18:26:58 +0200
Message-Id: <51aa2125c76363204cc23c27165e778097c33f0b.1653323077.git.maciej.szmigiero@oracle.com>
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

Make the MPX-related bits in FEAT_VMX_{EXIT,ENTRY}_CTLS dependent on MPX
being actually enabled so such workarounds are no longer necessary.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---

Changes from v1:
    Use feature_dependencies instead of sanitizing MPX-related bits in
    MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS when setting them.

 target/i386/cpu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 35c3475e6c..385691458f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1355,6 +1355,14 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_INVPCID },
         .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_ENABLE_INVPCID },
     },
+    {
+        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_MPX },
+        .to = { FEAT_VMX_EXIT_CTLS,         VMX_VM_EXIT_CLEAR_BNDCFGS },
+    },
+    {
+        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_MPX },
+        .to = { FEAT_VMX_ENTRY_CTLS,        VMX_VM_ENTRY_LOAD_BNDCFGS },
+    },
     {
         .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_RDSEED },
         .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_RDSEED_EXITING },

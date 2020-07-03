Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7B21314D
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 04:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGCCTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 22:19:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:38213 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgGCCTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 22:19:04 -0400
IronPort-SDR: LQBAsIk+obZKU+etHK71/pUeCIbwTwtL4Hndhx2r/0TJKzyDoXP3mVrhyZndv1Cpqaheage2Ie
 JRVVNnrAoenA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="127160652"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="127160652"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:19:03 -0700
IronPort-SDR: rwiD6hnAhVwsbGcB0bSNGT0DXLgXfOkYL3SwozKBFASykmpt2/EzZWjR+d2tRRQsBWGGFRYXZ0
 CG+D4k0pEbAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="387503145"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 02 Jul 2020 19:19:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: access: Add test for illegal toggling of CR4.LA57 in 64-bit mode
Date:   Thu,  2 Jul 2020 19:19:03 -0700
Message-Id: <20200703021903.5683-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test to verify that KVM correctly injects a #GP if the guest
attempts to toggle CR4.LA57 while 64-bit mode is active.  Use two
versions of the toggling, one to toggle only LA57 and a second to toggle
PSE in addition to LA57.  KVM doesn't intercept LA57, i.e. toggling only
LA57 effectively tests the CPU, not KVM.  Use PSE as the whipping boy as
it will not trigger a #GP on its own, is universally available, is
ignored in 64-bit mode, and most importantly is trapped by KVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/processor.h |  1 +
 x86/access.c        | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6e0811e..74a2498 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -44,6 +44,7 @@
 #define X86_CR4_PGE    0x00000080
 #define X86_CR4_PCE    0x00000100
 #define X86_CR4_UMIP   0x00000800
+#define X86_CR4_LA57   0x00001000
 #define X86_CR4_VMXE   0x00002000
 #define X86_CR4_PCIDE  0x00020000
 #define X86_CR4_SMEP   0x00100000
diff --git a/x86/access.c b/x86/access.c
index ac879c3..7dc9eb6 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1004,6 +1004,18 @@ static int ac_test_run(void)
 	}
     }
 
+    /* Toggling LA57 in 64-bit mode (guaranteed for this test) is illegal. */
+    if (this_cpu_has(X86_FEATURE_LA57)) {
+        tests++;
+        if (write_cr4_checking(shadow_cr4 ^ X86_CR4_LA57) == GP_VECTOR)
+            successes++;
+
+        /* Force a VM-Exit on KVM, which doesn't intercept LA57 itself. */
+        tests++;
+        if (write_cr4_checking(shadow_cr4 ^ (X86_CR4_LA57 | X86_CR4_PSE)) == GP_VECTOR)
+            successes++;
+    }
+
     ac_env_int(&pool);
     ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
     do {
-- 
2.26.0


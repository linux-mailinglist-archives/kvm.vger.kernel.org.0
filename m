Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AC317EF78
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 04:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgCJDye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 23:54:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29917 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCJDye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 23:54:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 20:54:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,535,1574150400"; 
   d="scan'208";a="242182623"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2020 20:54:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: access: Shadow CR0, CR4 and EFER to avoid unnecessary VM-Exits
Date:   Mon,  9 Mar 2020 20:54:32 -0700
Message-Id: <20200310035432.3447-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the last known CR0, CR4, and EFER values in the access test to
avoid taking a VM-Exit on every. single. test.  The EFER VM-Exits in
particular absolutely tank performance when running the test in L1.

Opportunistically tweak the 5-level test to print that it's starting
before configuring 5-level page tables, e.g. in case enabling 5-level
paging runs into issues.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/access.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 7303fc3..86d8a72 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -169,29 +169,33 @@ typedef struct {
 
 static void ac_test_show(ac_test_t *at);
 
+static unsigned long shadow_cr0;
+static unsigned long shadow_cr4;
+static unsigned long long shadow_efer;
+
 static void set_cr0_wp(int wp)
 {
-    unsigned long cr0 = read_cr0();
-    unsigned long old_cr0 = cr0;
+    unsigned long cr0 = shadow_cr0;
 
     cr0 &= ~CR0_WP_MASK;
     if (wp)
 	cr0 |= CR0_WP_MASK;
-    if (old_cr0 != cr0)
+    if (cr0 != shadow_cr0) {
         write_cr0(cr0);
+        shadow_cr0 = cr0;
+    }
 }
 
 static unsigned set_cr4_smep(int smep)
 {
-    unsigned long cr4 = read_cr4();
-    unsigned long old_cr4 = cr4;
+    unsigned long cr4 = shadow_cr4;
     extern u64 ptl2[];
     unsigned r;
 
     cr4 &= ~CR4_SMEP_MASK;
     if (smep)
 	cr4 |= CR4_SMEP_MASK;
-    if (old_cr4 == cr4)
+    if (cr4 == shadow_cr4)
         return 0;
 
     if (smep)
@@ -199,37 +203,39 @@ static unsigned set_cr4_smep(int smep)
     r = write_cr4_checking(cr4);
     if (r || !smep)
         ptl2[2] |= PT_USER_MASK;
+    if (!r)
+        shadow_cr4 = cr4;
     return r;
 }
 
 static void set_cr4_pke(int pke)
 {
-    unsigned long cr4 = read_cr4();
-    unsigned long old_cr4 = cr4;
+    unsigned long cr4 = shadow_cr4;
 
     cr4 &= ~X86_CR4_PKE;
     if (pke)
 	cr4 |= X86_CR4_PKE;
-    if (old_cr4 == cr4)
+    if (cr4 == shadow_cr4)
         return;
 
     /* Check that protection keys do not affect accesses when CR4.PKE=0.  */
-    if ((read_cr4() & X86_CR4_PKE) && !pke) {
+    if ((shadow_cr4 & X86_CR4_PKE) && !pke)
         write_pkru(0xfffffffc);
-    }
     write_cr4(cr4);
+    shadow_cr4 = cr4;
 }
 
 static void set_efer_nx(int nx)
 {
-    unsigned long long efer = rdmsr(MSR_EFER);
-    unsigned long long old_efer = efer;
+    unsigned long long efer = shadow_efer;
 
     efer &= ~EFER_NX_MASK;
     if (nx)
 	efer |= EFER_NX_MASK;
-    if (old_efer != efer)
+    if (efer != shadow_efer) {
         wrmsr(MSR_EFER, efer);
+        shadow_efer = efer;
+    }
 }
 
 static void ac_env_int(ac_pool_t *pool)
@@ -245,7 +251,7 @@ static void ac_env_int(ac_pool_t *pool)
 
 static void ac_test_init(ac_test_t *at, void *virt)
 {
-    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
+    set_efer_nx(1);
     set_cr0_wp(1);
     at->flags = 0;
     at->virt = virt;
@@ -935,14 +941,17 @@ static int ac_test_run(void)
     printf("run\n");
     tests = successes = 0;
 
+    shadow_cr0 = read_cr0();
+    shadow_cr4 = read_cr4();
+    shadow_efer = rdmsr(MSR_EFER);
+
     if (this_cpu_has(X86_FEATURE_PKU)) {
         set_cr4_pke(1);
         set_cr4_pke(0);
         /* Now PKRU = 0xFFFFFFFF.  */
     } else {
-	unsigned long cr4 = read_cr4();
 	tests++;
-	if (write_cr4_checking(cr4 | X86_CR4_PKE) == GP_VECTOR) {
+	if (write_cr4_checking(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
             successes++;
             invalid_mask |= AC_PKU_AD_MASK;
             invalid_mask |= AC_PKU_WD_MASK;
@@ -996,8 +1005,8 @@ int main(void)
 
     if (this_cpu_has(X86_FEATURE_LA57)) {
         page_table_levels = 5;
-        setup_5level_page_table();
         printf("starting 5-level paging test.\n\n");
+        setup_5level_page_table();
         r = ac_test_run();
     }
 
-- 
2.24.1


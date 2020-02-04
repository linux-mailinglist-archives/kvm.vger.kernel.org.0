Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE6152005
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 18:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBDRug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 12:50:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:49214 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbgBDRug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 12:50:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 09:50:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="225579763"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Feb 2020 09:50:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Fix the name for the SMEP CPUID bit
Date:   Tue,  4 Feb 2020 09:50:34 -0800
Message-Id: <20200204175034.18201-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the X86_FEATURE_* name for SMEP, which is incorrectly named
X86_FEATURE_INVPCID_SINGLE and is a wee bit confusing when looking at
the SMEP unit tests.

Note, there is no INVPCID_SINGLE CPUID bit, the bogus name likely came
from the Linux kernel, which has a synthetic feature flag for
INVPCID_SINGLE in word 7, bit 7 (CPUID 0x7.EBX is stored in word 9).

Fixes: 6ddcc29 ("kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed functions")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/processor.h | 2 +-
 x86/access.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 7057180..03fdf64 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -138,7 +138,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
 #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
 #define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
-#define	X86_FEATURE_INVPCID_SINGLE	(CPUID(0x7, 0, EBX, 7))
+#define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
 #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
 #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
diff --git a/x86/access.c b/x86/access.c
index 5233713..7303fc3 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -860,7 +860,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
 	ac_test_t at1;
 	int err_prepare_andnot_wp, err_smep_andnot_wp;
 
-	if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+	if (!this_cpu_has(X86_FEATURE_SMEP)) {
 	    return 1;
 	}
 
@@ -955,7 +955,7 @@ static int ac_test_run(void)
 	}
     }
 
-    if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+    if (!this_cpu_has(X86_FEATURE_SMEP)) {
 	tests++;
 	if (set_cr4_smep(1) == GP_VECTOR) {
             successes++;
-- 
2.24.1


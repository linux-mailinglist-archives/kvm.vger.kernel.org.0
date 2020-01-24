Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35A149221
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 00:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgAXXqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 18:46:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:55675 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgAXXqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 18:46:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 15:46:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="251443288"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2020 15:46:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH] x86: nVMX: Print more (accurate) info if RDTSC diff test fails
Date:   Fri, 24 Jan 2020 15:46:08 -0800
Message-Id: <20200124234608.10754-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the delta of the last run and display it in the report if the
test fails.  Abort the run loop as soon as the threshold is reached so
that the displayed delta is guaranteed to a failed delta.  Displaying
the delta helps triage failures, e.g. is my system completely broken or
did I get unlucky, and aborting the loop early saves 99900 runs when
the system is indeed broken.

Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b31c360..4049dec 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9204,6 +9204,7 @@ static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
 
 static void rdtsc_vmexit_diff_test(void)
 {
+	unsigned long long delta;
 	int fail = 0;
 	int i;
 
@@ -9226,17 +9227,17 @@ static void rdtsc_vmexit_diff_test(void)
 	vmcs_write(EXI_MSR_ST_CNT, 1);
 	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
 
-	for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
-		if (rdtsc_vmexit_diff_test_iteration() >=
-		    HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
+	for (i = 0; i < RDTSC_DIFF_ITERS && fail < RDTSC_DIFF_FAILS; i++) {
+		delta = rdtsc_vmexit_diff_test_iteration();
+		if (delta >= HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
 			fail++;
 	}
 
 	enter_guest();
 
 	report(fail < RDTSC_DIFF_FAILS,
-	       "RDTSC to VM-exit delta too high in %d of %d iterations",
-	       fail, RDTSC_DIFF_ITERS);
+	       "RDTSC to VM-exit delta too high in %d of %d iterations, last = %llu",
+	       fail, i, delta);
 }
 
 static int invalid_msr_init(struct vmcs *vmcs)
-- 
2.24.1


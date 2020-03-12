Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5961F183D52
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCLX1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgCLX1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705933"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/8] nVMX: Consolidate non-canonical code in test_canonical()
Date:   Thu, 12 Mar 2020 16:27:40 -0700
Message-Id: <20200312232745.884-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor test_canonical() to provide a single flow for the non-canonical
path.  Practically speaking, its extremely unlikely the field being
tested already has a non-canonical address, and even less likely that
it's anything other than NONCANONICAL.  I.e. the added complexity
doesn't come with added coverage.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c4077b1..ac02b9d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7411,6 +7411,11 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 {
 	u64 addr_saved = vmcs_read(field);
 
+	/*
+	 * Use the existing value if possible.  Writing a random canonical
+	 * value is not an option as doing so would corrupt the field being
+	 * tested and likely hose the test.
+	 */
 	if (is_canonical(addr_saved)) {
 		if (host) {
 			report_prefix_pushf("%s %lx", field_name, addr_saved);
@@ -7422,33 +7427,22 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 						VMX_VMCALL, addr_saved,
 						field_name);
 		}
+	}
 
-		vmcs_write(field, NONCANONICAL);
+	vmcs_write(field, NONCANONICAL);
 
-		if (host) {
-			report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-			report_prefix_pop();
-		} else {
-			enter_guest_with_invalid_guest_state();
-			report_guest_state_test("Test canonical address",
-					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-					        NONCANONICAL, field_name);
-		}
-
-		vmcs_write(field, addr_saved);
+	if (host) {
+		report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		report_prefix_pop();
 	} else {
-		if (host) {
-			report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-			report_prefix_pop();
-		} else {
-			enter_guest_with_invalid_guest_state();
-			report_guest_state_test("Test canonical address",
-					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-					        NONCANONICAL, field_name);
-		}
+		enter_guest_with_invalid_guest_state();
+		report_guest_state_test("Test non-canonical address",
+					VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+					NONCANONICAL, field_name);
 	}
+
+	vmcs_write(field, addr_saved);
 }
 
 #define TEST_RPL_TI_FLAGS(reg, name)				\
-- 
2.24.1


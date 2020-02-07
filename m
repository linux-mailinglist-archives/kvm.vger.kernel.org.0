Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA3155D10
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgBGRmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:42:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:13003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgBGRmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="312095673"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2020 09:42:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/4] nVMX: Extend EPTP test to allow 5-level EPT
Date:   Fri,  7 Feb 2020 09:42:41 -0800
Message-Id: <20200207174244.6590-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207174244.6590-1-sean.j.christopherson@intel.com>
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the EPTP test to expect success when the EPTP is configured for
5-level page walks and 5-level walks are enumerated as supported by the
EPT capabilities MSR.  KVM is in the process of gaining support for
5-level nested EPT[*].

[*] https://lkml.kernel.org/r/20200206220836.22743-1-sean.j.christopherson@intel.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.h       |  1 +
 x86/vmx_tests.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 6214400..e8035fc 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -581,6 +581,7 @@ enum vm_instruction_error_number {
 
 #define EPT_CAP_WT		1ull
 #define EPT_CAP_PWL4		(1ull << 6)
+#define EPT_CAP_PWL5		(1ull << 7)
 #define EPT_CAP_UC		(1ull << 8)
 #define EPT_CAP_WB		(1ull << 14)
 #define EPT_CAP_2M_PAGE		(1ull << 16)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b31c360..bae1496 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4669,8 +4669,8 @@ static void test_eptp_ad_bit(u64 eptp, bool ctrl)
  *
  *     - The EPT memory type (bits 2:0) must be a value supported by the
  *	 processor as indicated in the IA32_VMX_EPT_VPID_CAP MSR.
- *     - Bits 5:3 (1 less than the EPT page-walk length) must be 3,
- *	 indicating an EPT page-walk length of 4.
+ *     - Bits 5:3 (1 less than the EPT page-walk length) must indicate a
+ *	 supported EPT page-walk length.
  *     - Bit 6 (enable bit for accessed and dirty flags for EPT) must be
  *	 0 if bit 21 of the IA32_VMX_EPT_VPID_CAP MSR is read as 0,
  *	 indicating that the processor does not support accessed and dirty
@@ -4710,6 +4710,9 @@ static void test_ept_eptp(void)
 	if (msr & EPT_CAP_WB)
 		wr_bk = true;
 
+	/* Support for 4-level EPT is mandatory. */
+	report(msr & EPT_CAP_PWL4, "4-level EPT support check");
+
 	primary |= CPU_SECONDARY;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 	secondary |= CPU_EPT;
@@ -4751,12 +4754,13 @@ static void test_ept_eptp(void)
 	eptp = (eptp & ~EPT_MEM_TYPE_MASK) | 6ul;
 
 	/*
-	 * Page walk length (bits 5:3)
+	 * Page walk length (bits 5:3).  Note, the value in VMCS.EPTP "is 1
+	 * less than the EPT page-walk length".
 	 */
 	for (i = 0; i < 8; i++) {
 		eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
 		    (i << EPTP_PG_WALK_LEN_SHIFT);
-		if (i == 3)
+		if (i == 3 || (i == 4 && (msr & EPT_CAP_PWL5)))
 			ctrl = true;
 		else
 			ctrl = false;
-- 
2.24.1


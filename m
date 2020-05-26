Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3569B1B7D1D
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgDXRk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:40:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:23370 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgDXRk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:40:27 -0400
IronPort-SDR: xD0q9w9DnjUbofb9vRRGt4tQJ7nAMiFiCbRYb1fkLBfBYqirpDHjs9rr3TBIhp8cD1PkOguJ4a
 kQJ+aN3l320w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 10:40:27 -0700
IronPort-SDR: GOeV/tdjEBx6hImgR2esH83Sn2tQx8ViXHQflHKpyHcrspy0GE57b+/qwdbsN1L2YDmiC9GDFz
 nXduDFMiNTnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="291651846"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 24 Apr 2020 10:40:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] nVMX: Check EXIT_QUALIFICATION on VM-Enter failures due to bad guest state
Date:   Fri, 24 Apr 2020 10:40:25 -0700
Message-Id: <20200424174025.1379-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that vmcs.EXIT_QUALIFICATION contains the correct failure code on
failed VM-Enter due to invalid guest state.  Hardcode the expected code
to the default code, '0', rather than passing in the expected code to
minimize churn and boilerplate code, which works for all existing tests.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.h       | 7 +++++++
 x86/vmx_tests.c | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 2e28ecb..08b354d 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -521,6 +521,13 @@ enum vm_instruction_error_number {
 	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
 };
 
+enum vm_entry_failure_code {
+	ENTRY_FAIL_DEFAULT		= 0,
+	ENTRY_FAIL_PDPTE		= 2,
+	ENTRY_FAIL_NMI			= 3,
+	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
+};
+
 #define SAVE_GPR				\
 	"xchg %rax, regs\n\t"			\
 	"xchg %rcx, regs+0x8\n\t"		\
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4a3c56b..f5a646f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5255,7 +5255,8 @@ static void test_guest_state(const char *test, bool xfail, u64 field,
 
 	report(result.exit_reason.failed_vmentry == xfail &&
 	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
-	        (!xfail && result.exit_reason.basic == VMX_VMCALL)),
+	        (!xfail && result.exit_reason.basic == VMX_VMCALL)) &&
+		(!xfail || vmcs_read(EXI_QUALIFICATION) == ENTRY_FAIL_DEFAULT),
 	        "%s, %s %lx", test, field_name, field);
 
 	if (!result.exit_reason.failed_vmentry)
-- 
2.26.0


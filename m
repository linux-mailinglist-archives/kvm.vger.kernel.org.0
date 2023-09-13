Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9779F87F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbjINCzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjINCzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 22:55:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BA1170E
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 19:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694660102; x=1726196102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOEuAhmMdNIAwtCfmY7m7ILIqg+em7Nde6Rt5q1NqzE=;
  b=Djn9oz8KhnNOOlBKX7imthBQujCajejDacspNPGfTIP56G+QmZ38gUG2
   4joX9xEm1fldqXlrEyE5RpNWlQsW/lHECzwDfvB2b6ywg3mTw/Teg4lp+
   PCZbjTtapRYq8vYhbmyy+lH/Gfo0ls7IAYbLR2f8RuZLm6BBBgZpzia4Q
   KLrdvCY0Fk1GBTj4nCtqQ8ycdMKpCPGsO3ejkKozb276A/EbPWp3dSqpZ
   2jZRQjTxBvrWVjjzxav25BoWjO9CVn2p/jbxFohrC19JpxFL/j2lkOLzj
   8eK+aFqQG4eVG1v/o33d1lMUHLfs6K7YnBr6Nzt+bdkISnuDMXToxNHPB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="442869335"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="442869335"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="694070843"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="694070843"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 3/3] x86:VMX: Introduce new vmx_basic MSR feature bit for vmx tests
Date:   Wed, 13 Sep 2023 19:50:06 -0400
Message-Id: <20230913235006.74172-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230913235006.74172-1-weijiang.yang@intel.com>
References: <20230913235006.74172-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce IA32_VMX_BASIC[bit56] support, i.e., skipping HW consistency
check for event error code if the bit is supported..

CET KVM enabling series introduces the vmx_basic_msr feature bit and it
causes some of the original test cases expecting a VM entry failure end
up with a successful result and the selftests report test failures. Now
checks the VM launch status conditionally against the bit support status
so as to make test results consistent with the change enforced by KVM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx.h       |  3 ++-
 x86/vmx_tests.c | 21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index d280f104..34e6b949 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -167,7 +167,8 @@ union vmx_basic_msr {
 			type:4,
 			insouts:1,
 			ctrl:1,
-			reserved2:8;
+			no_hw_errcode_cc:1,
+			reserved2:7;
 	};
 };
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f598496e..96848f4f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls();
+	if (basic_msr.no_hw_errcode_cc)
+		test_vmx_valid_controls();
+	else
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
@@ -4206,7 +4209,10 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save | X86_CR0_PE);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls();
+	if (basic_msr.no_hw_errcode_cc)
+		test_vmx_valid_controls();
+	else
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary_save);
@@ -4228,7 +4234,11 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [-]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_invalid_controls();
+		if (exception_type_mask == INTR_TYPE_HARD_EXCEPTION &&
+		    basic_msr.no_hw_errcode_cc)
+			test_vmx_valid_controls();
+		else
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 	report_prefix_pop();
@@ -4265,7 +4275,10 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [-]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_invalid_controls();
+		if (basic_msr.no_hw_errcode_cc)
+			test_vmx_valid_controls();
+		else
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 
 		/* Positive case */
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC20875B1F4
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 17:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjGTPD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 11:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjGTPD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 11:03:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF86DBB
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 08:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689865404; x=1721401404;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dETD1u4mQ/S2L9Dv5jikhdVYHfCbY9s6jHNnKy1SQVQ=;
  b=JBYBSw1qY1eChpuaQhqs9FgR6pwb2EI/YGTSRxpAwV0XwdsfaKm1Djg5
   rQ4UKSbFvfFo+iH4F2aFTUryZv59HiB7UndcRMsYr8/iCcDQDHAlKG26i
   lQGEUQWnq+RtKouwkPhg9zsIfGWW4H/fCK57wznvLP4wS05KmSWsCozdI
   vFGWwi9rI+lqYVBsUupUAdL7/wzguCoTgz0OHcdxBcCE+LaM1gZMCL8mb
   /fX/CsnfbD3pF6Y4ASGzchQILMA8enyISJocY57MqrE9GFxg9wyozCZ3s
   0VYhE72VuEtZK5UiTyFUnUJbT/BlNHD96VlduauBUiSrwZk0L4gW1Cf5j
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="366795492"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="366795492"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 08:03:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="754088627"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="754088627"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 08:03:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
Date:   Thu, 20 Jul 2023 07:58:10 -0400
Message-Id: <20230720115810.104890-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET KVM enabling patch series introduces extra constraints
on CR0.WP and CR4.CET bits, i.e., setting CR4.CET=1 faults if
CR0.WP==0. Simply skip CR4.CET bit test to avoid setting it in
flexible_cr4 and finally triggering a #GP when write the CR4
with CET bit set while CR0.WP is cleared.

The enable series also introduces IA32_VMX_BASIC[56 bit] check before
inject exception to VM, per SDM(Vol 3D, A-1):
"If bit 56 is read as 1, software can use VM entry to deliver a hardware
exception with or without an error code, regardless of vector."

With the change, some test cases expected VM entry failure  will
end up with successful results which causes reporting failures. Now
checks the VM launch status conditionally against the bit support
to get consistent results with the change enforced by KVM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx.c       |  2 +-
 x86/vmx.h       |  3 ++-
 x86/vmx_tests.c | 21 +++++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 12e42b0..1c27850 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1430,7 +1430,7 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
 		 */
 		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
 		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP ||
-					bit == X86_CR4_SMEP)))
+					bit == X86_CR4_SMEP || bit == X86_CR4_CET)))
 			continue;
 
 		if (!(bit & required1) && !(bit & disallowed1)) {
diff --git a/x86/vmx.h b/x86/vmx.h
index 604c78f..e53f600 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -167,7 +167,8 @@ union vmx_basic {
 			type:4,
 			insouts:1,
 			ctrl:1,
-			reserved2:8;
+			errcode:1,
+			reserved2:7;
 	};
 };
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7952ccb..b6d4982 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls();
+	if (basic.errcode)
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
+	if (basic.errcode)
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
+		    basic.errcode)
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
+		if (basic.errcode)
+			test_vmx_valid_controls();
+		else
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 
 		/* Positive case */
-- 
2.27.0


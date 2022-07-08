Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A156B441
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiGHINT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 04:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiGHINQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 04:13:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219137E034
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 01:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657267996; x=1688803996;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oHzGfLdLkf49FqjEgkADVrB04hWeD3gvzGWXPFrUzc4=;
  b=WIAsl3ljUkcvaxe2T68QR3X+IddcsJ6ACgNoXoVwbJxOZEFSXIhmmmLM
   8ExI1Tymzo37fU2ixz+5nlAjkOnab1dCaIHYjMpDeoRo49u2zgy+EVtTY
   rCy1jM8xgwDxZatcMtimpHrPgGrXb6sDjbFkATRH3/91/2CNX6mhuCra1
   VJIsmePj40x0MCP09J72UUvjgPUt2FXwJWOO7z49VUe2qxhQUSlx2hYXm
   N/HQ3+JSC0KkgUveQvTNPWGufaqn6LGMm58nE+J6QinkEUvWdpS1akHsy
   21untJ+/cBOywh1ex8C+x4CY3SJecSU+nv9+HEZteYdwqIrK9RT8dfUtX
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264640242"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="264640242"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="651478976"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v5 1/3] x86: Use report_skip to log messages when tests are skipped
Date:   Fri,  8 Jul 2022 01:11:17 -0400
Message-Id: <20220708051119.124100-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

report_skip() prints message with "SKIP:" prefix to explictly
tell which test is skipped, making the report screening easier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx_tests.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..27ab5ed 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4107,7 +4107,7 @@ static void test_vpid(void)
 	int i;
 
 	if (!is_vpid_supported()) {
-		printf("Secondary controls and/or VPID not supported\n");
+		report_skip("Secondary controls and/or VPID not supported\n");
 		return;
 	}
 
@@ -4614,7 +4614,7 @@ static void test_nmi_ctrls(void)
 
 	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
 	    (PIN_NMI | PIN_VIRT_NMI)) {
-		printf("NMI exiting and Virtual NMIs are not supported !\n");
+		report_skip("NMI exiting and Virtual NMIs are not supported !\n");
 		return;
 	}
 
@@ -4724,7 +4724,7 @@ static void test_ept_eptp(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
-		printf("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
+		report_skip("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
 		return;
 	}
 
@@ -4884,7 +4884,7 @@ static void test_pml(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
-		printf("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
+		report_skip("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
 		return;
 	}
 
@@ -4936,7 +4936,7 @@ static void test_vmx_preemption_timer(void)
 
 	if (!((ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) ||
 	    (ctrl_pin_rev.clr & PIN_PREEMPT))) {
-		printf("\"Save-VMX-preemption-timer\" control and/or \"Enable-VMX-preemption-timer\" control is not supported\n");
+		report_skip("\"Save-VMX-preemption-timer\" control and/or \"Enable-VMX-preemption-timer\" control is not supported\n");
 		return;
 	}
 
@@ -5060,7 +5060,7 @@ static void vmx_mtf_test(void)
 	handler old_gp, old_db;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
-		printf("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
+		report_skip("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
 		return;
 	}
 
@@ -5163,12 +5163,12 @@ static void vmx_mtf_pdpte_test(void)
 		return;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
-		printf("CPU does not support 'monitor trap flag.'\n");
+		report_skip("CPU does not support 'monitor trap flag.'\n");
 		return;
 	}
 
 	if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
-		printf("CPU does not support 'unrestricted guest.'\n");
+		report_skip("CPU does not support 'unrestricted guest.'\n");
 		return;
 	}
 
@@ -7175,7 +7175,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 		efer_reserved_bits &= ~EFER_NX;
 
 	if (!ctrl_bit1) {
-		printf("\"Load-IA32-EFER\" exit control not supported\n");
+		report_skip("\"Load-IA32-EFER\" exit control not supported\n");
 		goto test_entry_exit_mode;
 	}
 
@@ -7258,7 +7258,7 @@ static void test_host_efer(void)
 static void test_guest_efer(void)
 {
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER)) {
-		printf("\"Load-IA32-EFER\" entry control not supported\n");
+		report_skip("\"Load-IA32-EFER\" entry control not supported\n");
 		return;
 	}
 
@@ -7349,7 +7349,7 @@ static void test_load_host_pat(void)
 	 * "load IA32_PAT" VM-exit control
 	 */
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" exit control not supported\n");
+		report_skip("\"Load-IA32-PAT\" exit control not supported\n");
 		return;
 	}
 
@@ -7491,7 +7491,7 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 static void test_load_host_perf_global_ctrl(void)
 {
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
+		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
 		return;
 	}
 
@@ -7503,7 +7503,7 @@ static void test_load_host_perf_global_ctrl(void)
 static void test_load_guest_perf_global_ctrl(void)
 {
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
+		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
 		return;
 	}
 
@@ -7809,7 +7809,7 @@ static void test_load_guest_pat(void)
 	 * "load IA32_PAT" VM-entry control
 	 */
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" entry control not supported\n");
+		report_skip("\"Load-IA32-PAT\" entry control not supported\n");
 		return;
 	}
 
@@ -7833,7 +7833,7 @@ static void test_load_guest_bndcfgs(void)
 	u64 bndcfgs;
 
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
-		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
+		report_skip("\"Load-IA32-BNDCFGS\" entry control not supported\n");
 		return;
 	}
 
@@ -9970,7 +9970,7 @@ static void sipi_test_ap_thread(void *data)
 static void vmx_sipi_signal_test(void)
 {
 	if (!(rdmsr(MSR_IA32_VMX_MISC) & MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI)) {
-		printf("\tACTIVITY_WAIT_SIPI state is not supported.\n");
+		report_skip("\tACTIVITY_WAIT_SIPI state is not supported.\n");
 		return;
 	}
 
@@ -10271,18 +10271,18 @@ static void vmx_vmcs_shadow_test(void)
 	struct vmcs *shadow;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY)) {
-		printf("\t'Activate secondary controls' not supported.\n");
+		report_skip("\t'Activate secondary controls' not supported.\n");
 		return;
 	}
 
 	if (!(ctrl_cpu_rev[1].clr & CPU_SHADOW_VMCS)) {
-		printf("\t'VMCS shadowing' not supported.\n");
+		report_skip("\t'VMCS shadowing' not supported.\n");
 		return;
 	}
 
 	if (!(rdmsr(MSR_IA32_VMX_MISC) &
 	      MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS)) {
-		printf("\tVMWRITE can't modify VM-exit information fields.\n");
+		report_skip("\tVMWRITE can't modify VM-exit information fields.\n");
 		return;
 	}
 

base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d
-- 
2.31.1


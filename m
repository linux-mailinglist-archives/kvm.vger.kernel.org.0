Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9870C4CB7A7
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiCCH2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiCCH2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4690916C4C1
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292442; x=1677828442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JnGB8u57LksBwRNfjYZMEXUeN/HS+eeDw+eaG5RTyKk=;
  b=WhpZY/fxeHALOqqzLB2l3zIn33bNxHI0FAgLp7waSh/9CyR2egZYcH+k
   DVeuVnixmm3RAj6cW+YWTVnMXNOFArPW7Evq0e1b7n54HKJ5SzfNCQSCI
   asNc2/Mxufobde1pHq0Bgc507Qfy+gpsnXr9KPZSAr/jrQH+h2Bjfa2A6
   FeJnf53NxJg+80O06MTORZLbWKWIcPLNozmNfUYNrgo2+NZdMDwhuhHIB
   omlJzNZEOSEwdWuHHwpck/3+Lz/8OemPwvnrzEp5a4EzEk+GvTHcmDcMD
   P/COYifjE5hGDUuta2RvYI/Cn57wdOYBOybomz9UzIVgqMHghsfa0aAbC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176938"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176938"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631491"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:19 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 02/17] x86 TDX: Add #VE handler
Date:   Thu,  3 Mar 2022 15:18:52 +0800
Message-Id: <20220303071907.650203-3-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some instructions execution trigger #VE and are simulated in #VE
handler.

Add such a handler, currently support simulation of IO and MSR
read/write, cpuid and hlt instructions.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/desc.c      |  3 ++
 lib/x86/processor.h |  1 +
 lib/x86/tdx.c       | 87 +++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h       | 17 +++++++++
 4 files changed, 108 insertions(+)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index c2eb16e91fa1..b35274e44a8d 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -112,6 +112,7 @@ const char* exception_mnemonic(int vector)
 	case 17: return "#AC";
 	case 18: return "#MC";
 	case 19: return "#XM";
+	case 20: return "#VE";
 	default: return "#??";
 	}
 }
@@ -227,6 +228,7 @@ EX(mf, 16);
 EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
+EX(ve, 20);
 EX_E(cp, 21);
 
 asm (".pushsection .text \n\t"
@@ -273,6 +275,7 @@ static void *idt_handlers[32] = {
 	[17] = &ac_fault,
 	[18] = &mc_fault,
 	[19] = &xm_fault,
+	[20] = &ve_fault,
 	[21] = &cp_fault,
 };
 
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 117032a4895c..865269fd3857 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -28,6 +28,7 @@
 #define GP_VECTOR 13
 #define PF_VECTOR 14
 #define AC_VECTOR 17
+#define VE_VECTOR 20
 #define CP_VECTOR 21
 
 #define X86_CR0_PE	0x00000001
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 8308480105d6..42ab25f47e57 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -267,10 +267,97 @@ static bool tdx_handle_io(struct ex_regs *regs, u32 exit_qual)
 	return ret ? false : true;
 }
 
+static bool tdx_get_ve_info(struct ve_info *ve)
+{
+	struct tdx_module_output out;
+	u64 ret;
+
+	if (!ve)
+		return false;
+
+	/*
+	 * NMIs and machine checks are suppressed. Before this point any
+	 * #VE is fatal. After this point (TDGETVEINFO call), NMIs and
+	 * additional #VEs are permitted (but it is expected not to
+	 * happen unless kernel panics).
+	 */
+	ret = __tdx_module_call(TDX_GET_VEINFO, 0, 0, 0, 0, &out);
+	if (ret)
+		return false;
+
+	ve->exit_reason = out.rcx;
+	ve->exit_qual	= out.rdx;
+	ve->gla		= out.r8;
+	ve->gpa		= out.r9;
+	ve->instr_len	= out.r10 & UINT_MAX;
+	ve->instr_info	= out.r10 >> 32;
+
+	return true;
+}
+
+static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
+		struct ve_info *ve)
+{
+	bool ret = true;
+	u64 val = ~0ULL;
+	bool do_sti;
+
+	switch (ve->exit_reason) {
+	case EXIT_REASON_HLT:
+		do_sti = !!(regs->rflags & X86_EFLAGS_IF);
+		/* Bypass failed hlt is better than hang */
+		if (!_tdx_halt(!do_sti, do_sti))
+			tdx_printf("HLT instruction emulation failed\n");
+		break;
+	case EXIT_REASON_MSR_READ:
+		ret = tdx_read_msr(regs->rcx, &val);
+		if (ret) {
+			regs->rax = (u32)val;
+			regs->rdx = val >> 32;
+		}
+		break;
+	case EXIT_REASON_MSR_WRITE:
+		ret = tdx_write_msr(regs->rcx, regs->rax, regs->rdx);
+		break;
+	case EXIT_REASON_CPUID:
+		ret = tdx_handle_cpuid(regs);
+		break;
+	case EXIT_REASON_IO_INSTRUCTION:
+		ret = tdx_handle_io(regs, ve->exit_qual);
+		break;
+	default:
+		tdx_printf("Unexpected #VE: %ld\n", ve->exit_reason);
+		return false;
+	}
+
+	/* After successful #VE handling, move the IP */
+	if (ret)
+		regs->rip += ve->instr_len;
+
+	return ret;
+}
+
+/* #VE exception handler. */
+static void tdx_handle_ve(struct ex_regs *regs)
+{
+	struct ve_info ve;
+
+	if (!tdx_get_ve_info(&ve)) {
+		tdx_printf("tdx_get_ve_info failed\n");
+		return;
+	}
+
+	tdx_handle_virtualization_exception(regs, &ve);
+}
+
 efi_status_t setup_tdx(void)
 {
 	if (!is_tdx_guest())
 		return EFI_UNSUPPORTED;
 
+	handle_exception(20, tdx_handle_ve);
+
+	printf("Initialized TDX.\n");
+
 	return EFI_SUCCESS;
 }
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index 92ae5277b04d..68ddc136d1d9 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -29,6 +29,9 @@
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 
+/* TDX Module call Leaf IDs */
+#define TDX_GET_VEINFO			3
+
 /*
  * Used in __tdx_module_call() helper function to gather the
  * output registers' values of TDCALL instruction when requesting
@@ -59,6 +62,20 @@ struct tdx_hypercall_output {
 	u64 r15;
 };
 
+/*
+ * Used by #VE exception handler to gather the #VE exception
+ * info from the TDX module. This is software only structure
+ * and not related to TDX module/VMM.
+ */
+struct ve_info {
+	u64 exit_reason;
+	u64 exit_qual;
+	u64 gla;	/* Guest Linear (virtual) Address */
+	u64 gpa;	/* Guest Physical (virtual) Address */
+	u32 instr_len;
+	u32 instr_info;
+};
+
 bool is_tdx_guest(void);
 efi_status_t setup_tdx(void);
 
-- 
2.25.1


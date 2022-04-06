Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B22B4F645A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbiDFQGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiDFQGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:06:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DDF44E594;
        Tue,  5 Apr 2022 21:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220606; x=1680756606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjePiKLWyAZTDiIs2MHRUMC+Vn/D8Qwc+vrle+rDM7o=;
  b=Ih/kESGu+lj70HkdPPE/CwasWTQSa9o4NGMrAqTn5yKxKxkmcBpBV46l
   VGpyPTOB0+TZUKD46M2Vu9M05rMcrXmsXZhyx7rFnFTM3ITzBRR06/Oyv
   4yXvrXU6fm9xYoaJ6jlbdgd8u35CVQ+iQaREriVwjkBRs72/I+0Vk/iW7
   UxOOyJL55sDuSq4AyhPO0hfGeYKgH+ARaE8G1HeO8XPMdkMLvluJFR2Ba
   Jq7Z4nPCMST20JQQU0omgpQ6jvbuSgWJq0VKayibrXTJJ14zx2Xdk7uUa
   tmQRCXQi3a6yrI9ZZnpgbgReM/V0Tw58d35CP0gRh4mM/n7/l93XzX8ZV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089796"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089796"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302169"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:01 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 05/21] x86/virt/tdx: Detect P-SEAMLDR and TDX module
Date:   Wed,  6 Apr 2022 16:49:17 +1200
Message-Id: <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The P-SEAMLDR (persistent SEAM loader) is the first software module that
runs in SEAM VMX root, responsible for loading and updating the TDX
module.  Both the P-SEAMLDR and the TDX module are expected to be loaded
before host kernel boots.

There is no CPUID or MSR to detect whether the P-SEAMLDR or the TDX
module has been loaded.  SEAMCALL instruction fails with VMfailInvalid
when the target SEAM software module is not loaded, so SEAMCALL can be
used to detect whether the P-SEAMLDR and the TDX module are loaded.

Detect the P-SEAMLDR and the TDX module by calling SEAMLDR.INFO SEAMCALL
to get the P-SEAMLDR information.  If the SEAMCALL succeeds, the
P-SEAMLDR information further tells whether the TDX module is loaded or
not.

Also add a wrapper of __seamcall() to make SEAMCALL to the P-SEAMLDR and
the TDX module with additional defensive check on SEAMRR and CR4.VMXE,
since both detecting and initializing TDX module require the caller of
TDX to handle VMXON.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 175 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  31 +++++++
 2 files changed, 205 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 53093d4ad458..674867bccc14 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,7 +15,9 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
+#include <asm/virtext.h>
 #include <asm/tdx.h>
+#include "tdx.h"
 
 /* Support Intel Secure Arbitration Mode Range Registers (SEAMRR) */
 #define MTRR_CAP_SEAMRR			BIT(15)
@@ -74,6 +76,8 @@ static enum tdx_module_status_t tdx_module_status;
 /* Prevent concurrent attempts on TDX detection and initialization */
 static DEFINE_MUTEX(tdx_module_lock);
 
+static struct p_seamldr_info p_seamldr_info;
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -229,6 +233,160 @@ static bool tdx_keyid_sufficient(void)
 	return tdx_keyid_num >= 2;
 }
 
+/*
+ * All error codes of both the P-SEAMLDR and the TDX module SEAMCALLs
+ * have bit 63 set if SEAMCALL fails.
+ */
+#define SEAMCALL_LEAF_ERROR(_ret)	((_ret) & BIT_ULL(63))
+
+/**
+ * seamcall - make SEAMCALL to the P-SEAMLDR or the TDX module with
+ *	      additional check on SEAMRR and CR4.VMXE
+ *
+ * @fn:			SEAMCALL leaf number.
+ * @rcx:		Input operand RCX.
+ * @rdx:		Input operand RDX.
+ * @r8:			Input operand R8.
+ * @r9:			Input operand R9.
+ * @seamcall_ret:	SEAMCALL completion status (can be NULL).
+ * @out:		Additional output operands (can be NULL).
+ *
+ * Wrapper of __seamcall() to make SEAMCALL to the P-SEAMLDR or the TDX
+ * module with additional defensive check on SEAMRR and CR4.VMXE.  Caller
+ * to make sure SEAMRR is enabled and CPU is already in VMX operation
+ * before calling this function.
+ *
+ * Unlike __seamcall(), it returns kernel error code instead of SEAMCALL
+ * completion status, which is returned via @seamcall_ret if desired.
+ *
+ * Return:
+ *
+ * * -ENODEV:	SEAMCALL failed with VMfailInvalid, or SEAMRR is not enabled.
+ * * -EPERM:	CR4.VMXE is not enabled
+ * * -EFAULT:	SEAMCALL failed
+ * * -0:	SEAMCALL succeeded
+ */
+static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		    u64 *seamcall_ret, struct tdx_module_output *out)
+{
+	u64 ret;
+
+	if (WARN_ON_ONCE(!seamrr_enabled()))
+		return -ENODEV;
+
+	/*
+	 * SEAMCALL instruction requires CPU being already in VMX
+	 * operation (VMXON has been done), otherwise it causes #UD.
+	 * Sanity check whether CR4.VMXE has been enabled.
+	 *
+	 * Note VMX being enabled in CR4 doesn't mean CPU is already
+	 * in VMX operation, but unfortunately there's no way to do
+	 * such check.  However in practice enabling CR4.VMXE and
+	 * doing VMXON are done together (for now) so in practice it
+	 * checks whether VMXON has been done.
+	 *
+	 * Preemption is disabled during the CR4.VMXE check and the
+	 * actual SEAMCALL so VMX doesn't get disabled by other threads
+	 * due to scheduling.
+	 */
+	preempt_disable();
+	if (WARN_ON_ONCE(!cpu_vmx_enabled())) {
+		preempt_enable_no_resched();
+		return -EPERM;
+	}
+
+	ret = __seamcall(fn, rcx, rdx, r8, r9, out);
+
+	preempt_enable_no_resched();
+
+	/*
+	 * Convert SEAMCALL error code to kernel error code:
+	 *  - -ENODEV:	VMfailInvalid
+	 *  - -EFAULT:	SEAMCALL failed
+	 *  - 0:	SEAMCALL was successful
+	 */
+	if (ret == TDX_SEAMCALL_VMFAILINVALID)
+		return -ENODEV;
+
+	/* Save the completion status if caller wants to use it */
+	if (seamcall_ret)
+		*seamcall_ret = ret;
+
+	/*
+	 * TDX module SEAMCALLs may also return non-zero completion
+	 * status codes but w/o bit 63 set.  Those codes are treated
+	 * as additional information/warning while the SEAMCALL is
+	 * treated as completed successfully.  Return 0 in this case.
+	 * Caller can use @seamcall_ret to get the additional code
+	 * when it is desired.
+	 */
+	if (SEAMCALL_LEAF_ERROR(ret)) {
+		pr_err("SEAMCALL leaf %llu failed: 0x%llx\n", fn, ret);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static inline bool p_seamldr_ready(void)
+{
+	return !!p_seamldr_info.p_seamldr_ready;
+}
+
+static inline bool tdx_module_ready(void)
+{
+	/*
+	 * SEAMLDR_INFO.SEAM_READY indicates whether TDX module
+	 * is (loaded and) ready for SEAMCALL.
+	 */
+	return p_seamldr_ready() && !!p_seamldr_info.seam_ready;
+}
+
+/*
+ * Detect whether the P-SEAMLDR has been loaded by calling SEAMLDR.INFO
+ * SEAMCALL to get the P-SEAMLDR information, which further tells whether
+ * the TDX module has been loaded and ready for SEAMCALL.  Caller to make
+ * sure only calling this function when CPU is already in VMX operation.
+ */
+static int detect_p_seamldr(void)
+{
+	int ret;
+
+	/*
+	 * SEAMCALL fails with VMfailInvalid when SEAM software is not
+	 * loaded, in which case seamcall() returns -ENODEV.  Use this
+	 * to detect the P-SEAMLDR.
+	 *
+	 * Note the P-SEAMLDR SEAMCALL also fails with VMfailInvalid when
+	 * the P-SEAMLDR is already busy with another SEAMCALL.  But this
+	 * won't happen here as this function is only called once.
+	 */
+	ret = seamcall(P_SEAMCALL_SEAMLDR_INFO, __pa(&p_seamldr_info),
+			0, 0, 0, NULL, NULL);
+	if (ret) {
+		if (ret == -ENODEV)
+			pr_info("P-SEAMLDR is not loaded.\n");
+		else
+			pr_info("Failed to detect P-SEAMLDR.\n");
+
+		return ret;
+	}
+
+	/*
+	 * If SEAMLDR.INFO was successful, it must be ready for SEAMCALL.
+	 * Otherwise it's either kernel or firmware bug.
+	 */
+	if (WARN_ON_ONCE(!p_seamldr_ready()))
+		return -ENODEV;
+
+	pr_info("P-SEAMLDR: version 0x%x, vendor_id: 0x%x, build_date: %u, build_num %u, major %u, minor %u\n",
+		p_seamldr_info.version, p_seamldr_info.vendor_id,
+		p_seamldr_info.build_date, p_seamldr_info.build_num,
+		p_seamldr_info.major, p_seamldr_info.minor);
+
+	return 0;
+}
+
 static int __tdx_detect(void)
 {
 	/* The TDX module is not loaded if SEAMRR is disabled */
@@ -247,7 +405,22 @@ static int __tdx_detect(void)
 		goto no_tdx_module;
 	}
 
-	/* Return -ENODEV until the TDX module is detected */
+	/*
+	 * For simplicity any error during detect_p_seamldr() marks
+	 * TDX module as not loaded.
+	 */
+	if (detect_p_seamldr())
+		goto no_tdx_module;
+
+	if (!tdx_module_ready()) {
+		pr_info("TDX module is not loaded.\n");
+		goto no_tdx_module;
+	}
+
+	pr_info("TDX module detected.\n");
+	tdx_module_status = TDX_MODULE_LOADED;
+	return 0;
+
 no_tdx_module:
 	tdx_module_status = TDX_MODULE_NONE;
 	return -ENODEV;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9d5b6f554c20..6990c93198b3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -3,6 +3,37 @@
 #define _X86_VIRT_TDX_H
 
 #include <linux/types.h>
+#include <linux/compiler.h>
+
+/*
+ * TDX architectural data structures
+ */
+
+#define P_SEAMLDR_INFO_ALIGNMENT	256
+
+struct p_seamldr_info {
+	u32	version;
+	u32	attributes;
+	u32	vendor_id;
+	u32	build_date;
+	u16	build_num;
+	u16	minor;
+	u16	major;
+	u8	reserved0[2];
+	u32	acm_x2apicid;
+	u8	reserved1[4];
+	u8	seaminfo[128];
+	u8	seam_ready;
+	u8	seam_debug;
+	u8	p_seamldr_ready;
+	u8	reserved2[88];
+} __packed __aligned(P_SEAMLDR_INFO_ALIGNMENT);
+
+/*
+ * P-SEAMLDR SEAMCALL leaf function
+ */
+#define P_SEAMLDR_SEAMCALL_BASE		BIT_ULL(63)
+#define P_SEAMCALL_SEAMLDR_INFO		(P_SEAMLDR_SEAMCALL_BASE | 0x0)
 
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-- 
2.35.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7785C4C60E1
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiB1CO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiB1COs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:48 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CE952B1E;
        Sun, 27 Feb 2022 18:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014444; x=1677550444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2jNeZuUU4l1x431jNTMzx1ocNPIwEk9Y/Euu1K/218=;
  b=Uzsquzy+N+5Bpi7wynl64PFwEmIS5kagn4JFsHCjk3dGKWB7o403kkCV
   dcr4EVtDFJ1kFy3qXwjMqYPs7aN/Vv2srkudRg/7nMcbxgocdMfxAlxI6
   jqL53t0m0X2cW87fijB8WL+uYj0lufNvwkAJiyEh5vnv+oxfWUvg9UVyF
   vu++NB4p+vni+CvumpVtSYG1WYX4ERxoAkYAMoEnrpSEeLReZCwWhvII0
   rcJUp32iU6bL0n6NrDpNRpABfYUBK63znUmkWcm/mSlkCWxNdir3DSd0P
   ozv5IiWSGDOWRCqgsXh5ko45qdmlBN/g3t/WTV9KbRnAcx1PBkZy2ODKF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191887"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191887"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936863"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:59 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 05/21] x86/virt/tdx: Detect P-SEAMLDR and TDX module
Date:   Mon, 28 Feb 2022 15:12:53 +1300
Message-Id: <21867aa05eb7e270f4cdcc1407951b8a9201f7e6.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

P-SEAMLDR (persistent SEAM loader) is the first software module that
runs in SEAM VMX root, responsible for loading and updating the TDX
module.  Both P-SEAMLDR and TDX module are expected to be loaded before
host kernel boots.

Detect P-SEAMLDR and TDX module by calling SEAMLDR.INFO SEAMCALL to get
the P-SEAMLDR information.  If the SEAMCALL fails with VMfailInvalid,
both of them are not loaded.  Otherwise, if the SEAMCALL succeeds, the
P-SEAMLDR information further tells whether the TDX module is loaded.

Also implement a wrapper of __seamcall() to make SEAMCALL to P-SEAMLDR
and TDX module with additional defensive check on SEAMRR and CR4.VMXE,
since both detecting and initializing TDX module require the caller of
TDX to handle VMXON.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 180 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx.h |  31 +++++++
 2 files changed, 208 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index a85bc52c4690..35116eaa0c1a 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
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
@@ -229,6 +233,161 @@ static bool tdx_keyid_sufficient(void)
 	return tdx_keyid_num >= 2;
 }
 
+/*
+ * All error codes of both P-SEAMLDR and TDX module SEAMCALLs
+ * have bit 63 set if SEAMCALL fails.
+ */
+#define SEAMCALL_LEAF_ERROR(_ret)	((_ret) & BIT_ULL(63))
+
+/**
+ * seamcall - make SEAMCALL to P-SEAMLDR or TDX module with additional
+ *	      check on SEAMRR and CR4.VMXE
+ *
+ * @fn:			SEAMCALL leaf number.
+ * @rcx:		Input operand RCX.
+ * @rdx:		Input operand RDX.
+ * @r8:			Input operand R8.
+ * @r9:			Input operand R9.
+ * @seamcall_ret:	SEAMCALL completion status (can be NULL).
+ * @out:		Additional output operands (can be NULL).
+ *
+ * Wrapper of __seamcall() to make SEAMCALL to TDX module or P-SEAMLDR
+ * with additional defensive check on SEAMRR and CR4.VMXE.  Caller to
+ * make sure SEAMRR is enabled and CPU is already in VMX operation before
+ * calling this function.
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
+ * Detect whether P-SEAMLDR has been loaded by calling SEAMLDR.INFO
+ * SEAMCALL to P-SEAMLDR information, which also contains whether
+ * the TDX module has been loaded and ready for SEAMCALL.  Caller to
+ * make sure only calling this function when CPU is already in VMX
+ * operation.
+ */
+static int detect_p_seamldr(void)
+{
+	int ret;
+
+	/*
+	 * SEAMCALL fails with VMfailInvalid when SEAM software is not
+	 * loaded, in which case seamcall() returns -ENODEV.  Use this
+	 * to detect P-SEAMLDR.
+	 *
+	 * Note P-SEAMLDR SEAMCALL also fails with VMfailInvalid when
+	 * P-SEAMLDR is already busy with another SEAMCALL.  But this
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
 	/*
@@ -247,7 +406,22 @@ static int __tdx_detect(void)
 		goto no_tdx_module;
 	}
 
-	/* Return -ENODEV until TDX module is detected */
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
@@ -308,8 +482,8 @@ static int __tdx_init(void)
  * tdx_detect - Detect whether the TDX module has been loaded
  *
  * Detect whether the TDX module has been loaded and ready for
- * initialization.  Only call this function when CPU is already
- * in VMX operation.
+ * initialization.  Only call this function when all cpus are
+ * already in VMX operation.
  *
  * This function can be called in parallel by multiple callers.
  *
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index 9d5b6f554c20..6990c93198b3 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
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
2.33.1


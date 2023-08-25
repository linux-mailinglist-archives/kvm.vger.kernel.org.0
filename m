Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791417886F8
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244638AbjHYMS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244676AbjHYMR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:17:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEB32D69;
        Fri, 25 Aug 2023 05:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965842; x=1724501842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZLvZrYH9mEO49R3hoScxLr0s/JmvSaz+w6YlL4wBoUA=;
  b=aryQyzs0BMx0l0tm+tTGdiHWi7kdBc190DO5JDd+Vt0iqg8eErItc47I
   qLFUrtEGTkK4EWtt3LCWPvpOgPNhSnwgFoi6jeXCDL/f0/T5LB46hyzdY
   fqt4sV8krZZzd3+SQZsoR1bLX4rAQObxsskVW70/LCL9/i2vVG/2fwu2e
   H4zeq8yFM70R9CuDVjgvisg9cdTVuFIRflYFxGZVL3ZOMJNVrpMk7tPDc
   oTx+uN48AhLwtcXuOdlX5FQrkajft3DMTw+kfiSuy4futBY39UVRFV3JY
   e/IQTdAFQjFvJjKYQdDfNRCj+eM5LHZ99LkKE72+V3we1ZOUH0u9VKghd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639496"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639496"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158928"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:54 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 21/22] x86/mce: Improve error log of kernel space TDX #MC due to erratum
Date:   Sat, 26 Aug 2023 00:14:40 +1200
Message-ID: <9f7bcd70ed4c665fe53df3aee24722af6064d476.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first few generations of TDX hardware have an erratum.  Triggering
it in Linux requires some kind of kernel bug involving relatively exotic
memory writes to TDX private memory and will manifest via
spurious-looking machine checks when reading the affected memory.

== Background ==

Virtually all kernel memory accesses operations happen in full
cachelines.  In practice, writing a "byte" of memory usually reads a 64
byte cacheline of memory, modifies it, then writes the whole line back.
Those operations do not trigger this problem.

This problem is triggered by "partial" writes where a write transaction
of less than cacheline lands at the memory controller.  The CPU does
these via non-temporal write instructions (like MOVNTI), or through
UC/WC memory mappings.  The issue can also be triggered away from the
CPU by devices doing partial writes via DMA.

== Problem ==

A partial write to a TDX private memory cacheline will silently "poison"
the line.  Subsequent reads will consume the poison and generate a
machine check.  According to the TDX hardware spec, neither of these
things should have happened.

To add insult to injury, the Linux machine code will present these as a
literal "Hardware error" when they were, in fact, a software-triggered
issue.

== Solution ==

In the end, this issue is hard to trigger.  Rather than do something
rash (and incomplete) like unmap TDX private memory from the direct map,
improve the machine check handler.

Currently, the #MC handler doesn't distinguish whether the memory is
TDX private memory or not but just dump, for instance, below message:

 [...] mce: [Hardware Error]: CPU 147: Machine Check Exception: f Bank 1: bd80000000100134
 [...] mce: [Hardware Error]: RIP 10:<ffffffffadb69870> {__tlb_remove_page_size+0x10/0xa0}
 	...
 [...] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
 [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
 [...] Kernel panic - not syncing: Fatal local machine check

Which says "Hardware Error" and "Data load in unrecoverable area of
kernel".

Ideally, it's better for the log to say "software bug around TDX private
memory" instead of "Hardware Error".  But in reality the real hardware
memory error can happen, and sadly such software-triggered #MC cannot be
distinguished from the real hardware error.  Also, the error message is
used by userspace tool 'mcelog' to parse, so changing the output may
break userspace.

So keep the "Hardware Error".  The "Data load in unrecoverable area of
kernel" is also helpful, so keep it too.

Instead of modifying above error log, improve the error log by printing
additional TDX related message to make the log like:

  ...
 [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
 [...] mce: [Hardware Error]: Machine Check: TDX private memory error. Possible kernel bug.

Adding this additional message requires determination of whether the
memory page is TDX private memory.  There is no existing infrastructure
to do that.  Add an interface to query the TDX module to fill this gap.

== Impact ==

This issue requires some kind of kernel bug to trigger.

TDX private memory should never be mapped UC/WC.  A partial write
originating from these mappings would require *two* bugs, first mapping
the wrong page, then writing the wrong memory.  It would also be
detectable using traditional memory corruption techniques like
DEBUG_PAGEALLOC.

MOVNTI (and friends) could cause this issue with something like a simple
buffer overrun or use-after-free on the direct map.  It should also be
detectable with normal debug techniques.

The one place where this might get nasty would be if the CPU read data
then wrote back the same data.  That would trigger this problem but
would not, for instance, set off mechanisms like slab redzoning because
it doesn't actually corrupt data.

With an IOMMU at least, the DMA exposure is similar to the UC/WC issue.
TDX private memory would first need to be incorrectly mapped into the
I/O space and then a later DMA to that mapping would actually cause the
poisoning event.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v12 -> v13:
 - Added Kirill and Yuan's tag.

v11 -> v12:
 - Simplified #MC message (Dave/Kirill)
 - Slightly improved some comments.

v10 -> v11:
 - New patch


---
 arch/x86/include/asm/tdx.h     |   2 +
 arch/x86/kernel/cpu/mce/core.c |  33 +++++++++++
 arch/x86/virt/vmx/tdx/tdx.c    | 103 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h    |   5 ++
 4 files changed, 143 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 97a68ced69dc..5a9609ca5270 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -114,11 +114,13 @@ bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 void tdx_reset_memory(void);
+bool tdx_is_private_mem(unsigned long phys);
 #else
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
 static inline void tdx_reset_memory(void) { }
+static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 89e2aab5d34d..6dc9ea9a8136 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/reboot.h>
+#include <asm/tdx.h>
 
 #include "internal.h"
 
@@ -228,11 +229,34 @@ static void wait_for_panic(void)
 	panic("Panicing machine check CPU died");
 }
 
+static const char *mce_memory_info(struct mce *m)
+{
+	if (!m || !mce_is_memory_error(m) || !mce_usable_address(m))
+		return NULL;
+
+	/*
+	 * Certain initial generations of TDX-capable CPUs have an
+	 * erratum.  A kernel non-temporal partial write to TDX private
+	 * memory poisons that memory, and a subsequent read of that
+	 * memory triggers #MC.
+	 *
+	 * However such #MC caused by software cannot be distinguished
+	 * from the real hardware #MC.  Just print additional message
+	 * to show such #MC may be result of the CPU erratum.
+	 */
+	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		return NULL;
+
+	return !tdx_is_private_mem(m->addr) ? NULL :
+		"TDX private memory error. Possible kernel bug.";
+}
+
 static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 {
 	struct llist_node *pending;
 	struct mce_evt_llist *l;
 	int apei_err = 0;
+	const char *memmsg;
 
 	/*
 	 * Allow instrumentation around external facilities usage. Not that it
@@ -283,6 +307,15 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 	}
 	if (exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
+	/*
+	 * Confidential computing platforms such as TDX platforms
+	 * may occur MCE due to incorrect access to confidential
+	 * memory.  Print additional information for such error.
+	 */
+	memmsg = mce_memory_info(final);
+	if (memmsg)
+		pr_emerg(HW_ERR "Machine check: %s\n", memmsg);
+
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mca_cfg.panic_timeout;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 41c6a5acddc2..04b3c81b35e5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1348,6 +1348,109 @@ void tdx_reset_memory(void)
 	tdmrs_reset_pamt_all(&tdx_tdmr_list);
 }
 
+static bool is_pamt_page(unsigned long phys)
+{
+	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
+	int i;
+
+	/*
+	 * This function is called from #MC handler, and theoretically
+	 * it could run in parallel with the TDX module initialization
+	 * on other logical cpus.  But it's not OK to hold mutex here
+	 * so just blindly check module status to make sure PAMTs/TDMRs
+	 * are stable to access.
+	 *
+	 * This may return inaccurate result in rare cases, e.g., when
+	 * #MC happens on a PAMT page during module initialization, but
+	 * this is fine as #MC handler doesn't need a 100% accurate
+	 * result.
+	 */
+	if (tdx_module_status != TDX_MODULE_INITIALIZED)
+		return false;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		unsigned long base, size;
+
+		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &base, &size);
+
+		if (phys >= base && phys < (base + size))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Return whether the memory page at the given physical address is TDX
+ * private memory or not.  Called from #MC handler do_machine_check().
+ *
+ * Note this function may not return an accurate result in rare cases.
+ * This is fine as the #MC handler doesn't need a 100% accurate result,
+ * because it cannot distinguish #MC between software bug and real
+ * hardware error anyway.
+ */
+bool tdx_is_private_mem(unsigned long phys)
+{
+	struct tdx_module_args args = {
+		.rcx = phys & PAGE_MASK,
+	};
+	u64 sret;
+
+	if (!platform_tdx_enabled())
+		return false;
+
+	/* Get page type from the TDX module */
+	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
+	/*
+	 * Handle the case that CPU isn't in VMX operation.
+	 *
+	 * KVM guarantees no VM is running (thus no TDX guest)
+	 * when there's any online CPU isn't in VMX operation.
+	 * This means there will be no TDX guest private memory
+	 * and Secure-EPT pages.  However the TDX module may have
+	 * been initialized and the memory page could be PAMT.
+	 */
+	if (sret == TDX_SEAMCALL_UD)
+		return is_pamt_page(phys);
+
+	/*
+	 * Any other failure means:
+	 *
+	 * 1) TDX module not loaded; or
+	 * 2) Memory page isn't managed by the TDX module.
+	 *
+	 * In either case, the memory page cannot be a TDX
+	 * private page.
+	 */
+	if (sret)
+		return false;
+
+	/*
+	 * SEAMCALL was successful -- read page type (via RCX):
+	 *
+	 *  - PT_NDA:	Page is not used by the TDX module
+	 *  - PT_RSVD:	Reserved for Non-TDX use
+	 *  - Others:	Page is used by the TDX module
+	 *
+	 * Note PAMT pages are marked as PT_RSVD but they are also TDX
+	 * private memory.
+	 *
+	 * Note: Even page type is PT_NDA, the memory page could still
+	 * be associated with TDX private KeyID if the kernel hasn't
+	 * explicitly used MOVDIR64B to clear the page.  Assume KVM
+	 * always does that after reclaiming any private page from TDX
+	 * gusets.
+	 */
+	switch (args.rcx) {
+	case PT_NDA:
+		return false;
+	case PT_RSVD:
+		return is_pamt_page(phys);
+	default:
+		return true;
+	}
+}
+
 static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 					    u32 *nr_tdx_keyids)
 {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 6e41b0731e48..5bcbfc2fc466 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,6 +16,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_PHYMEM_PAGE_RDMD	24
 #define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
@@ -23,6 +24,10 @@
 #define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
+/* TDX page types */
+#define	PT_NDA		0x0
+#define	PT_RSVD		0x1
+
 struct cmr_info {
 	u64	base;
 	u64	size;
-- 
2.41.0


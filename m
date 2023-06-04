Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2D7217C3
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjFDOa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjFDOam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF55E1B8;
        Sun,  4 Jun 2023 07:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889035; x=1717425035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FaVM6SLOSHqfwOzsrSInUMJZns3IWGAfasrKkA6dHGQ=;
  b=gNNk92Eb2j/TX3O8c/hxZ2G7t7K9G0IYqZVXvjL/zx5AYiU0vOugr9Bt
   Li1BWDE27JME/GwDAcC2L2o9YKF1pJlWuHy1ZUsJnflZ0ocBgljgiwE2C
   A95dRbhXeryRukhyOr6OY3FivTo8Yi7heHIYsfH5MrFhlrrWPSYcKwJlR
   idzrDGBHR1SMRqFbnEF6qMAbZuBiZGOSRBLXkoAGgptDwaqulK3/EaaVM
   n6H2ftQR6v9/u18O/Ipvw2sqonwCOrmF49/ApqZaTXEVA1y3rrbOlEqvg
   dGvj1n12R16m+BhDsvE378PD9QN8x9uOBox/CSYoj1uXVLu7CevaR685i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683710"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683710"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501221"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501221"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX #MC due to erratum
Date:   Mon,  5 Jun 2023 02:27:32 +1200
Message-Id: <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 [...] mce: [Hardware Error]: Machine Check: Memory error from TDX private memory. May be result of CPU erratum.

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
---

v10 -> v11:
 - New patch

---
 arch/x86/include/asm/tdx.h     |   2 +
 arch/x86/kernel/cpu/mce/core.c |  33 +++++++++++
 arch/x86/virt/vmx/tdx/tdx.c    | 100 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h    |   6 ++
 4 files changed, 141 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 03f74851608f..a20d9ca99e31 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -104,10 +104,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
+bool tdx_is_private_mem(unsigned long phys);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
+static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2eec60f50057..5ad7b563632f 100644
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
+		"Memory error from TDX private memory. May be result of CPU erratum.";
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
index 0aa413b712e8..4aa41352edfc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1250,6 +1250,106 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_enable);
 
+static bool is_pamt_page(unsigned long phys)
+{
+	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
+	unsigned long pfn;
+	int i;
+
+	/*
+	 * This function is called from #MC handler, and theoretically
+	 * it could run in parallel with the TDX module initialization
+	 * on other logical cpus.  But it's not OK to hold mutex here
+	 * so just blindly check module status.  This should work most
+	 * of the time.
+	 */
+	if (tdx_module_status != TDX_MODULE_INITIALIZED)
+		return false;
+
+	pfn = phys >> PAGE_SHIFT;
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		unsigned long pamt_pfn, npages;
+
+		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &pamt_pfn, &npages);
+
+		if (pfn >= pamt_pfn && pfn < (pamt_pfn + npages))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Return whether the memory page at the given physical address is
+ * TDX private memory or not.  This function is called from #MC
+ * handler do_machine_check() with IRQ disabled.
+ *
+ * Note this function may not return accurate result in rare cases, but
+ * this is fine as the #MC handler doesn't need a 100% accurate result
+ * because it cannot distinguish #MC between software bug and real
+ * hardware error anyway.
+ */
+bool tdx_is_private_mem(unsigned long phys)
+{
+	struct tdx_module_output out;
+	u64 sret;
+
+	if (!platform_tdx_enabled())
+		return false;
+
+	/* Get page type via TDH.PHYMEM.PAGE.RDMD SEAMCALL. */
+	sret = __seamcall(TDH_PHYMEM_PAGE_RDMD, phys & PAGE_MASK,
+			0, 0, 0, &out);
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
+	switch (out.rcx) {
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
index 012153067440..93fbef634ac9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -28,6 +28,12 @@
 #define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_TDMR_INIT	36
 
+#define TDH_PHYMEM_PAGE_RDMD	24
+
+/* TDX page types */
+#define	PT_NDA		0x0
+#define	PT_RSVD		0x1
+
 struct cmr_info {
 	u64	base;
 	u64	size;
-- 
2.40.1


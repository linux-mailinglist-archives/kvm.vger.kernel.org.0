Return-Path: <kvm+bounces-1341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381257E6A21
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E7B22816DD
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37241DA35;
	Thu,  9 Nov 2023 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ct9BqkZN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03E31DA26
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:58:34 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6C52D7C;
	Thu,  9 Nov 2023 03:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531114; x=1731067114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+I46LmtF7AAg2DjI+b7nCLfanyrPmwoj8gVT38v1+A=;
  b=ct9BqkZN9XVGDan/DXyL+q0QjaZXNEgGOUenoGUcBuIhepCrUt0BoKJ+
   OuPfFusZB6HyNv87iyIqPe9dWOS1PqHZMcvQ0+KJtnz+o1AYbGmcJ9aSK
   PlFAWdu4qhSrOPrEHkYlQMAiegRUyWP8Z76r8EPo2LBa9Pv5vYMiInTfG
   Wi8gTb2ft5IwgtKVz6rOWemxJMcxZoddHMg9oybV19tePMcm5RcH7lZsv
   /6mFaTohRjGdwHUCWqYi1DW5FgX+qzF2Y5a5rGrODU/aLuMsG5fgovxEU
   qf0kXYnggYAk4bDnWdwrWSAfGxDhljv+lzdISQaNBtLoeHScS5VvrjPOq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936815"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936815"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766977078"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766977078"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:27 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX #MC due to erratum
Date: Fri, 10 Nov 2023 00:55:59 +1300
Message-ID: <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

v14 -> v15:
 - No change

v13 -> v14:
 - No change

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
index caca139e7022..a621721f63dd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -115,11 +115,13 @@ bool platform_tdx_enabled(void);
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
index 7b397370b4d6..e33537cfc507 100644
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
index cc21a0f25bee..1b84dcdf63cb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1288,6 +1288,109 @@ void tdx_reset_memory(void)
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
index c0610f0bb88c..b701f69485d3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -14,6 +14,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_PHYMEM_PAGE_RDMD	24
 #define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INIT		33
 #define TDH_SYS_RD		34
@@ -21,6 +22,10 @@
 #define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
+/* TDX page types */
+#define	PT_NDA		0x0
+#define	PT_RSVD		0x1
+
 /*
  * Global scope metadata field ID.
  *
-- 
2.41.0



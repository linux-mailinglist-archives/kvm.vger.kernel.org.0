Return-Path: <kvm+bounces-1327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70EB47E6A08
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C102C281300
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B5C1DDCF;
	Thu,  9 Nov 2023 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MdPC5mHc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003E1DDC3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9B03246;
	Thu,  9 Nov 2023 03:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531027; x=1731067027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7tanhltcHHrughD4k+4esqb7GTG2rA/ev2XoX79zhuE=;
  b=MdPC5mHcqA5CN72kzUyWnC1N4D5SbkboCdz6k2QOvRoJq54R3YEEJtM8
   r8xPix5ZzUOQvCZXAP+5bScP/5w+gG9C6iXJ1Ox0n5eLvcxyY117iN+tj
   kX5dUVxUX3aJ/C5W0CHBxoC3I6Jw9F5jx1/F1MdB3CCsA4tugN8DQfWcK
   rPZFPsUMfetIv8/LuHmewu+2Vkc+M9qM0ebusMGubQEdifiuylXyk6Yon
   znEOyZaBUsGfZP8RsLi5DxORkUaoOHBtzxlxFAuOg8Nsya6zmgtwR13xU
   70wg1iVuUpxJIMFkRGZ+VHCsQi+9uca7WkVKM8iXQcWmjDQY74WVPTQDu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936467"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936467"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976715"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976715"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:59 -0800
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
Subject: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when initializing TDX module as TDX memory
Date: Fri, 10 Nov 2023 00:55:45 +1300
Message-ID: <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>
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

Start to transit out the "multi-steps" to initialize the TDX module.

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, TDX introduced the concept of a "Convertible Memory Region"
(CMR).  During boot, the firmware builds a list of all of the memory
ranges which can provide the TDX security guarantees.  The list of these
ranges is available to the kernel by querying the TDX module.

CMRs tell the kernel which memory is TDX compatible.  The kernel needs
to build a list of memory regions (out of CMRs) as "TDX-usable" memory
and pass them to the TDX module.  Once this is done, those "TDX-usable"
memory regions are fixed during module's lifetime.

To keep things simple, assume that all TDX-protected memory will come
from the page allocator.  Make sure all pages in the page allocator
*are* TDX-usable memory.

As TDX-usable memory is a fixed configuration, take a snapshot of the
memory configuration from memblocks at the time of module initialization
(memblocks are modified on memory hotplug).  This snapshot is used to
enable TDX support for *this* memory configuration only.  Use a memory
hotplug notifier to ensure that no other RAM can be added outside of
this configuration.

This approach requires all memblock memory regions at the time of module
initialization to be TDX convertible memory to work, otherwise module
initialization will fail in a later SEAMCALL when passing those regions
to the module.  This approach works when all boot-time "system RAM" is
TDX convertible memory, and no non-TDX-convertible memory is hot-added
to the core-mm before module initialization.

For instance, on the first generation of TDX machines, both CXL memory
and NVDIMM are not TDX convertible memory.  Using kmem driver to hot-add
any CXL memory or NVDIMM to the core-mm before module initialization
will result in failure to initialize the module.  The SEAMCALL error
code will be available in the dmesg to help user to understand the
failure.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v14 -> v15:
 - Rebase due to removal of TDH.SYS.INFO patch.

v13 -> v14:
 - Added Kirill's tag.

v12 -> v13:
 - Allocate TDSYSINFO and CMR array separately. (Kirill)
 - Added comment around TDH.SYS.INFO. (Peter)

v11 -> v12:
 - Changed to use dynamic allocation for TDSYSINFO_STRUCT and CMR array
   (Kirill).
 - Keep SEAMCALL leaf macro definitions in order (Kirill)
 - Removed is_cmr_empty() but open code directly (David)
 - 'atribute' -> 'attribute' (David)

v10 -> v11:
 - No change.

v9 -> v10:
 - Added back "start to transit out..." as now per-cpu init has been
   moved out from tdx_enable().

v8 -> v9:
 - Removed "start to trransit out ..." part in changelog since this patch
   is no longer the first step anymore.
 - Changed to declare 'tdsysinfo' and 'cmr_array' as local static, and
   changed changelog accordingly (Dave).
 - Improved changelog to explain why to declare  'tdsysinfo_struct' in
   full but only use a few members of them (Dave).

v7 -> v8: (Dave)
 - Improved changelog to tell this is the first patch to transit out the
   "multi-steps" init_tdx_module().
 - Removed all CMR check/trim code but to depend on later SEAMCALL.
 - Variable 'vertical alignment' in print TDX module information.
 - Added DECLARE_PADDED_STRUCT() for padded structure.
 - Made tdx_sysinfo and tdx_cmr_array[] to be function local variable
   (and rename them accordingly), and added -Wframe-larger-than=4096 flag
   to silence the build warning.

 ...

---
 arch/x86/Kconfig            |   1 +
 arch/x86/kernel/setup.c     |   2 +
 arch/x86/virt/vmx/tdx/tdx.c | 167 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |   6 ++
 4 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb6e63956d51..2c69ef844805 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1971,6 +1971,7 @@ config INTEL_TDX_HOST
 	depends on X86_64
 	depends on KVM_INTEL
 	depends on X86_X2APIC
+	select ARCH_KEEP_MEMBLOCK
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1526747bedf2..9597c002b3c4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1033,6 +1033,8 @@ void __init setup_arch(char **cmdline_p)
 	 *
 	 * Moreover, on machines with SandyBridge graphics or in setups that use
 	 * crashkernel the entire 1M is reserved anyway.
+	 *
+	 * Note the host kernel TDX also requires the first 1MB being reserved.
 	 */
 	x86_platform.realmode_reserve();
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e7739e15d47a..d1affb30f74d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -16,6 +16,12 @@
 #include <linux/spinlock.h>
 #include <linux/percpu-defs.h>
 #include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
+#include <linux/memory.h>
+#include <linux/minmax.h>
+#include <linux/sizes.h>
+#include <linux/pfn.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
@@ -30,6 +36,9 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 static enum tdx_module_status_t tdx_module_status;
 static DEFINE_MUTEX(tdx_module_lock);
 
+/* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
+static LIST_HEAD(tdx_memlist);
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -153,12 +162,102 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
+/*
+ * Add a memory region as a TDX memory block.  The caller must make sure
+ * all memory regions are added in address ascending order and don't
+ * overlap.
+ */
+static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
+			    unsigned long end_pfn)
+{
+	struct tdx_memblock *tmb;
+
+	tmb = kmalloc(sizeof(*tmb), GFP_KERNEL);
+	if (!tmb)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&tmb->list);
+	tmb->start_pfn = start_pfn;
+	tmb->end_pfn = end_pfn;
+
+	/* @tmb_list is protected by mem_hotplug_lock */
+	list_add_tail(&tmb->list, tmb_list);
+	return 0;
+}
+
+static void free_tdx_memlist(struct list_head *tmb_list)
+{
+	/* @tmb_list is protected by mem_hotplug_lock */
+	while (!list_empty(tmb_list)) {
+		struct tdx_memblock *tmb = list_first_entry(tmb_list,
+				struct tdx_memblock, list);
+
+		list_del(&tmb->list);
+		kfree(tmb);
+	}
+}
+
+/*
+ * Ensure that all memblock memory regions are convertible to TDX
+ * memory.  Once this has been established, stash the memblock
+ * ranges off in a secondary structure because memblock is modified
+ * in memory hotplug while TDX memory regions are fixed.
+ */
+static int build_tdx_memlist(struct list_head *tmb_list)
+{
+	unsigned long start_pfn, end_pfn;
+	int i, ret;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		/*
+		 * The first 1MB is not reported as TDX convertible memory.
+		 * Although the first 1MB is always reserved and won't end up
+		 * to the page allocator, it is still in memblock's memory
+		 * regions.  Skip them manually to exclude them as TDX memory.
+		 */
+		start_pfn = max(start_pfn, PHYS_PFN(SZ_1M));
+		if (start_pfn >= end_pfn)
+			continue;
+
+		/*
+		 * Add the memory regions as TDX memory.  The regions in
+		 * memblock has already guaranteed they are in address
+		 * ascending order and don't overlap.
+		 */
+		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	free_tdx_memlist(tmb_list);
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
+	int ret;
+
+	/*
+	 * To keep things simple, assume that all TDX-protected memory
+	 * will come from the page allocator.  Make sure all pages in the
+	 * page allocator are TDX-usable memory.
+	 *
+	 * Build the list of "TDX-usable" memory regions which cover all
+	 * pages in the page allocator to guarantee that.  Do it while
+	 * holding mem_hotplug_lock read-lock as the memory hotplug code
+	 * path reads the @tdx_memlist to reject any new memory.
+	 */
+	get_online_mems();
+
+	ret = build_tdx_memlist(&tdx_memlist);
+	if (ret)
+		goto out_put_tdxmem;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Build the list of TDX-usable memory regions.
 	 *  - Get TDX module "TD Memory Region" (TDMR) global metadata.
 	 *  - Construct a list of TDMRs to cover all TDX-usable memory
 	 *    regions.
@@ -168,7 +267,14 @@ static int init_tdx_module(void)
 	 *
 	 *  Return error before all steps are done.
 	 */
-	return -EINVAL;
+	ret = -EINVAL;
+out_put_tdxmem:
+	/*
+	 * @tdx_memlist is written here and read at memory hotplug time.
+	 * Lock out memory hotplug code while building it.
+	 */
+	put_online_mems();
+	return ret;
 }
 
 static int __tdx_enable(void)
@@ -258,6 +364,56 @@ static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 	return 0;
 }
 
+static bool is_tdx_memory(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct tdx_memblock *tmb;
+
+	/*
+	 * This check assumes that the start_pfn<->end_pfn range does not
+	 * cross multiple @tdx_memlist entries.  A single memory online
+	 * event across multiple memblocks (from which @tdx_memlist
+	 * entries are derived at the time of module initialization) is
+	 * not possible.  This is because memory offline/online is done
+	 * on granularity of 'struct memory_block', and the hotpluggable
+	 * memory region (one memblock) must be multiple of memory_block.
+	 */
+	list_for_each_entry(tmb, &tdx_memlist, list) {
+		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
+			return true;
+	}
+	return false;
+}
+
+static int tdx_memory_notifier(struct notifier_block *nb, unsigned long action,
+			       void *v)
+{
+	struct memory_notify *mn = v;
+
+	if (action != MEM_GOING_ONLINE)
+		return NOTIFY_OK;
+
+	/*
+	 * Empty list means TDX isn't enabled.  Allow any memory
+	 * to go online.
+	 */
+	if (list_empty(&tdx_memlist))
+		return NOTIFY_OK;
+
+	/*
+	 * The TDX memory configuration is static and can not be
+	 * changed.  Reject onlining any memory which is outside of
+	 * the static configuration whether it supports TDX or not.
+	 */
+	if (is_tdx_memory(mn->start_pfn, mn->start_pfn + mn->nr_pages))
+		return NOTIFY_OK;
+
+	return NOTIFY_BAD;
+}
+
+static struct notifier_block tdx_memory_nb = {
+	.notifier_call = tdx_memory_notifier,
+};
+
 static int __init tdx_init(void)
 {
 	u32 tdx_keyid_start, nr_tdx_keyids;
@@ -281,6 +437,13 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+	err = register_memory_notifier(&tdx_memory_nb);
+	if (err) {
+		pr_err("initialization failed: register_memory_notifier() failed (%d)\n",
+				err);
+		return -ENODEV;
+	}
+
 	/*
 	 * Just use the first TDX KeyID as the 'global KeyID' and
 	 * leave the rest for TDX guests.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a3c52270df5b..c11e0a7ca664 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -27,4 +27,10 @@ enum tdx_module_status_t {
 	TDX_MODULE_ERROR
 };
 
+struct tdx_memblock {
+	struct list_head list;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+};
+
 #endif
-- 
2.41.0



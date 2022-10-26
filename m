Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256C560EC1B
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiJZXRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiJZXRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C86ACF4C;
        Wed, 26 Oct 2022 16:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826237; x=1698362237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IHMLQmjQ4gcgAdlSybq18M2Wmr9JF9lc1h1rOhUxgwE=;
  b=eav7zZCT/zBs7Vma95/V1QRZHzCZIqTJQVBuwYnAPBYZYKFwzeKgnbIA
   6sEPHSz6XVHRD14l/MmCMvWN6Zsv+IVxoxsXjeq2Dxi+XP6z0p2zFBB/Y
   3V0OtAjnNoS9Tu9zWqqv/b1MWTNJsOoh8AxwCuG+PGF2wyWvpnyP5k25b
   vziAhrr0u7yJTlDjlQal7/dmTzm3g/2bbGIY1QtiGEZHV2voO33Sn53CM
   VFhcMpd12B3QuJmuDbz71P1hovW0B9JhfP80piQOzBgFNrt5xHj49TQxZ
   kz80MfNGLP1maCnfaT96CKYny1UUNRIF8vIl90x77Hcz6b3xPAdGzD18j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306814217"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306814217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446270"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446270"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:13 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 04/21] x86/virt/tdx: Use all boot-time system memory as TDX memory
Date:   Thu, 27 Oct 2022 12:16:03 +1300
Message-Id: <2697e1aa3bf9463f09635de264380e1b35f596cf.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, the TDX introduced the concept of a "Convertible Memory
Region" (CMR).  During boot, the BIOS builds a list of all of the memory
regions which can provide the TDX security guarantees.  The list of CMRs
is available to the kernel by querying the TDX module or its loader.

However those TDX-capable memory regions are not automatically usable to
the TDX module.  The kernel needs to choose the memory regions that will
be used as TDX memory and pass those memory regions to the TDX module
when initializing it.  Once passed to the TDX module, those TDX-usable
memory regions are fixed during the module's lifetime.  The TDX module
doesn't support adding new TDX-usable memory after it gets initialized.

To keep things simple, this initial implementation chooses to use all
boot-time present memory managed by the page allocator as TDX memory.
This requires all boot-time present memory to be TDX convertible memory,
which is true in practice.  If there's any boot-time memory which isn't
TDX convertible memory (which is allowed from TDX architecture's point
of view), it will be caught later during TDX module initialization and
the initialization will fail.

However one machine may support both TDX and non-TDX memory both at
machine boot time and runtime.  For example, any memory hot-added at
runtime cannot be TDX memory.  Also, for now NVDIMM and CXL memory are
not TDX memory, no matter whether they are present at machine boot time
or not.

This raises a problem that, if any non-TDX memory is hot-added to the
system-wide memory allocation pool, a non-TDX page may be allocated to a
TDX guest, which will result in failing to create the TDX guest, or
killing it at runtime.

The current implementation doesn't explicitly prevent adding any non-TDX
memory to system-wide memory pool, but depends on the machine owner to
make sure such operation won't happen.  For example, the machine owner
should never plug any NVDIMM or CXL memory into the machine, or use kmem
driver to hot-add any to the core-mm.

This will be enhanced in the future.  One solution is the kernel can be
enforced to always guarantee all pages in the page allocator are TDX
memory (i.e. by rejecting non-TDX memory in memory hotplug).  Another
option is the kernel may support different memory capabilities on basis
of NUMA node.  For example, the kernel can have both TDX-compatible NUMA
node and non-TDX-compatible memory NUMA node, and the userspace needs to
explicitly bind TDX guests to those TDX-compatible memory NUMA nodes.

Use memblock to get all memory regions as it is the source from where
the memory pages are freed to the page allocator.  This saves the
metadata that is needed to be allocated and given to the TDX module when
initializing it in case like 'memmap' kernel command is used.

Also, don't use memblock directly when initializing the TDX module, but
make a snapshot of all memory regions in the memblock during kernel
boot.  This is because:

1) Memblock is discarded after kernel boots if CONFIG_ARCH_KEEP_MEMBLOCK
   is not enabled.
2) Memblock can be changed by memory hotplug (i.e. memory removal of
   boot-time present memory) at runtime if it is kept.
3) The first 1MB may not be enumerated as CMR on some platforms, so the
   first 1MB cannot be included as TDX memory.  Looping over all TDX
   memory blocks will be done couple of times when initializing the TDX
   module.  Instead of using memblock directly and manually excluding
   the first 1MB for each loop, just do a snapshot to exclude the first
   1MB once.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 141 ++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8d943bdc8335..c5d260e27cad 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -10,15 +10,27 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/printk.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
+struct tdx_memblock {
+	struct list_head list;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	int nid;
+};
+
 static u32 tdx_keyid_start __ro_after_init;
 static u32 tdx_keyid_num __ro_after_init;
 
+/* All TDX-usable memory regions */
+static LIST_HEAD(tdx_memlist);
+
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
  * BIOS.  Both initializing the TDX module and running TDX guest require
@@ -66,6 +78,125 @@ static void __init clear_tdx(void)
 	tdx_keyid_start = tdx_keyid_num = 0;
 }
 
+static void __init tdx_memory_destroy(void)
+{
+	while (!list_empty(&tdx_memlist)) {
+		struct tdx_memblock *tmb = list_first_entry(&tdx_memlist,
+				struct tdx_memblock, list);
+
+		list_del(&tmb->list);
+		kfree(tmb);
+	}
+}
+
+/* Add one TDX memory block after all existing TDX memory blocks */
+static int __init tdx_memory_add_block(unsigned long start_pfn,
+				       unsigned long end_pfn,
+				       int nid)
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
+	tmb->nid = nid;
+
+	list_add_tail(&tmb->list, &tdx_memlist);
+
+	return 0;
+}
+
+/*
+ * TDX reports a list of "Convertible Memory Regions" (CMR) to indicate
+ * all memory regions that _can_ be used by TDX, but the kernel needs to
+ * choose the _actual_ regions that TDX can use and pass those regions
+ * to the TDX module when initializing it.  After the TDX module gets
+ * initialized, no more TDX-usable memory can be hot-added to the TDX
+ * module.
+ *
+ * TDX convertible memory must be physically present during machine boot.
+ * To keep things simple, the current implementation simply chooses to
+ * use all boot-time present memory regions as TDX memory so that all
+ * pages allocated via the page allocator are TDX memory.
+ *
+ * Build all boot-time memory regions managed by memblock as TDX-usable
+ * memory regions by making a snapshot of memblock memory regions during
+ * kernel boot.  Memblock is discarded when CONFIG_ARCH_KEEP_MEMBLOCK is
+ * not enabled after kernel boots.  Also, memblock can be changed due to
+ * memory hotplug (i.e. memory removal from core-mm) even if it is kept.
+ *
+ * Those regions will be verified when CMRs become available when the TDX
+ * module gets initialized.  At this stage, it's not possible to get CMRs
+ * during kernel boot as the core-kernel doesn't support VMXON.
+ *
+ * Note: this means the current implementation _requires_ all boot-time
+ * present memory regions are TDX convertible memory to enable TDX.  This
+ * is true in practice.  Also, this can be enhanced in the future when
+ * the core-kernel gets VMXON support.
+ *
+ * Important note:
+ *
+ * TDX doesn't work with physical memory hotplug, as all hot-added memory
+ * are not convertible memory.
+ *
+ * Also to keep things simple, the current implementation doesn't handle
+ * memory hotplug at all for TDX.  To use TDX, it is the machine owner's
+ * responsibility to not do any operation that will hot-add any non-TDX
+ * memory to the page allocator.  For example, the machine owner should
+ * not plug any non-CMR memory (such as NVDIMM and CXL memory) to the
+ * machine, or should not use kmem driver to plug any NVDIMM or CXL
+ * memory to the core-mm.
+ *
+ * This will be enhanced in the future.
+ *
+ * Note: tdx_init() is called before acpi_init(), which will scan the
+ * entire ACPI namespace and hot-add all ACPI memory devices if there
+ * are any.  This belongs to the memory hotplug category as mentioned
+ * above.
+ */
+static int __init build_tdx_memory(void)
+{
+	unsigned long start_pfn, end_pfn;
+	int i, nid, ret;
+
+	/*
+	 * Cannot use for_each_free_mem_range() here as some reserved
+	 * memory (i.e. initrd image) will be freed to the page allocator
+	 * at the late phase of kernel boot.
+	 */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/*
+		 * The first 1MB is not reported as TDX convertible
+		 * memory on some platforms.  Manually exclude them as
+		 * TDX memory.  This is fine as the first 1MB is already
+		 * reserved in reserve_real_mode() and won't end up to
+		 * ZONE_DMA as free page anyway.
+		 */
+		if (start_pfn < (SZ_1M >> PAGE_SHIFT))
+			start_pfn = (SZ_1M >> PAGE_SHIFT);
+		if (start_pfn >= end_pfn)
+			continue;
+
+		/*
+		 * All TDX memory blocks must be in address ascending
+		 * order when initializing the TDX module.  Memblock
+		 * already guarantees that.
+		 */
+		ret = tdx_memory_add_block(start_pfn, end_pfn, nid);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	tdx_memory_destroy();
+	return ret;
+}
+
 static int __init tdx_init(void)
 {
 	if (detect_tdx())
@@ -92,6 +223,16 @@ static int __init tdx_init(void)
 		goto no_tdx;
 	}
 
+	/*
+	 * Build all boot-time system memory managed in memblock as
+	 * TDX-usable memory.  As part of initializing the TDX module,
+	 * those regions will be passed to the TDX module.
+	 */
+	if (build_tdx_memory()) {
+		pr_err("Build TDX-usable memory regions failed. Disable TDX.\n");
+		goto no_tdx;
+	}
+
 	return 0;
 no_tdx:
 	clear_tdx();
-- 
2.37.3


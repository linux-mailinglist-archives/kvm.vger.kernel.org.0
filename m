Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61A65547E8
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357288AbiFVLQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357187AbiFVLQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:16:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A018B3BFBC;
        Wed, 22 Jun 2022 04:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896592; x=1687432592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B8lOyV+NN2DHameRBeRw32eUf0Rp3UclgjoKHzIwykM=;
  b=DSNsWYHTH9Ojh3t8NGX+dBgFtPQFV8/1sZ92J2yjg9nNcMKcGUTTbowJ
   CfszV0gjQhz9j1SEWFmTV3cmFEk5Rpt/tEwvxWEZGX3sj2CghdreTib80
   8YG28UNaA0P1ahPDShP/+XC0QB+jqCMlXN/V+3VMy2jc37ZVdxDzukJbD
   GYHTgecvo11V1H7uaWhRD1pHgs1rXo5W3hbNRbDYcXVWINCjQ17NfYoaI
   4U5zZOOi93ajvJzAEGkAN/6uxLgEmIfg6APIH9WH4goxmCd8tpfdhSngF
   pSFiyFSkHHdtaVoGu9D0VoJ5xLeUBO2iFyDuzNA4XAkRvSPce08tjszJm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="260820294"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="260820294"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="585679747"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:28 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org,
        kai.huang@intel.com
Subject: [PATCH v5 05/22] x86/virt/tdx: Prevent hot-add driver managed memory
Date:   Wed, 22 Jun 2022 23:16:19 +1200
Message-Id: <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Region" (CMR).  During boot, the firmware builds a list of all of the
memory ranges which can provide the TDX security guarantees.  The list
of these ranges is available to the kernel by querying the TDX module.

However those TDX-capable memory regions are not automatically usable to
the TDX module.  The kernel needs to choose which convertible memory
regions to be the TDX-usable memory and pass those regions to the TDX
module when initializing the module.  Once those ranges are passed to
the TDX module, the TDX-usable memory regions are fixed during module's
lifetime.

To avoid having to modify the page allocator to distinguish TDX and
non-TDX memory allocation, this implementation guarantees all pages
managed by the page allocator are TDX memory.  This means any hot-added
memory to the page allocator will break such guarantee thus should be
prevented.

There are basically two memory hot-add cases that need to be prevented:
ACPI memory hot-add and driver managed memory hot-add.  However, adding
new memory to ZONE_DEVICE should not be prevented as those pages are not
managed by the page allocator.  Therefore memremap_pages() variants
should be allowed although they internally also use memory hotplug
functions.

ACPI memory hotplug is already prevented.  To prevent driver managed
memory and still allow memremap_pages() variants to work, add a __weak
hook to do arch-specific check in add_memory_resource().  Implement the
x86 version to prevent new memory region from being added when TDX is
enabled by BIOS.

The __weak arch-specific hook is used instead of a new CC_ATTR similar
to disable software CPU hotplug.  It is because some driver managed
memory resources may actually be TDX-capable (such as legacy PMEM, which
is underneath indeed RAM), and the arch-specific hook can be further
enhanced to allow those when needed.

Note arch-specific hook for __remove_memory() is not required.  Both
ACPI hot-removal and driver managed memory removal cannot reach it.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/mm/init_64.c          | 21 +++++++++++++++++++++
 include/linux/memory_hotplug.h |  2 ++
 mm/memory_hotplug.c            | 15 +++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 96d34ebb20a9..ce89cf88a818 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -55,6 +55,7 @@
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
 #include <asm/ftrace.h>
+#include <asm/tdx.h>
 
 #include "mm_internal.h"
 
@@ -972,6 +973,26 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
+int arch_memory_add_precheck(int nid, u64 start, u64 size, mhp_t mhp_flags)
+{
+	if (!platform_tdx_enabled())
+		return 0;
+
+	/*
+	 * TDX needs to guarantee all pages managed by the page allocator
+	 * are TDX memory in order to not have to distinguish TDX and
+	 * non-TDX memory allocation.  The kernel needs to pass the
+	 * TDX-usable memory regions to the TDX module when it gets
+	 * initialized.  After that, the TDX-usable memory regions are
+	 * fixed.  This means any memory hot-add to the page allocator
+	 * will break above guarantee thus should be prevented.
+	 */
+	pr_err("Unable to add memory [0x%llx, 0x%llx) on TDX enabled platform.\n",
+			start, start + size);
+
+	return -EINVAL;
+}
+
 static void __meminit free_pagetable(struct page *page, int order)
 {
 	unsigned long magic;
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 1ce6f8044f1e..306ef4ceb419 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -325,6 +325,8 @@ extern int add_memory_resource(int nid, struct resource *resource,
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
+extern int arch_memory_add_precheck(int nid, u64 start, u64 size,
+				    mhp_t mhp_flags);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 416b38ca8def..2ad4b2603c7c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1296,6 +1296,17 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
 	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
 }
 
+/*
+ * Pre-check whether hot-add memory is allowed before arch_add_memory().
+ *
+ * Arch to provide replacement version if required.
+ */
+int __weak arch_memory_add_precheck(int nid, u64 start, u64 size,
+				    mhp_t mhp_flags)
+{
+	return 0;
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1319,6 +1330,10 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (ret)
 		return ret;
 
+	ret = arch_memory_add_precheck(nid, start, size, mhp_flags);
+	if (ret)
+		return ret;
+
 	if (mhp_flags & MHP_NID_IS_MGID) {
 		group = memory_group_find_by_id(nid);
 		if (!group)
-- 
2.36.1


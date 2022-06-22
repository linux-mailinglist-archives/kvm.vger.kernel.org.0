Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ADB5548A5
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357168AbiFVLSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357100AbiFVLSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:18:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DA43CFD0;
        Wed, 22 Jun 2022 04:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896654; x=1687432654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BAEQTxUOrf8ypGAob3v0GI3Jlfen8aKkWY6XM2y0KF4=;
  b=lXvVsXE9Qgjkt5GOf7IS7G5KQbzSbhMzjvwxVDsc6t7bNqeqLDsXquqg
   NidlroIoepNour62ofWIPf/UgtsgwFRbM2JX1IaqLIEKJFKi1hmmYBFdQ
   DljajjqXUYKfmMNJwL/mmhE4pWoCXBJmZ5tF5dIh6dULw+MnUO19tHwiU
   oPi5AaGoJrmj6GuSJL8/5F0DRI2U05sY+pyAj9UCl+HlSZDWleYXELSxd
   HC20unLFOgGBubSsO6sou3nHZ33POYXnBJuEarVA9Aku2esusTa4/22l/
   UY9Zd/PBz2NplSKYPFgweXDW9CdIUAWd29rQlmJcg8o+mB9Ae/VZZsuQZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305841077"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305841077"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302266"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:26 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 13/22] x86/virt/tdx: Add placeholder to construct TDMRs based on memblock
Date:   Wed, 22 Jun 2022 23:17:02 +1200
Message-Id: <3f2fd2a4d09c146184fb45ed56326420b8097474.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

The TDX architecture needs additional metadata to record things like
which TD guest "owns" a given page of memory.  This metadata essentially
serves as the 'struct page' for the TDX module.  The space for this
metadata is not reserved by the hardware up front and must be allocated
by the kernel and given to the TDX module.

Since this metadata consumes space, the VMM can choose whether or not to
allocate it for a given area of convertible memory.  If it chooses not
to, the memory cannot receive TDX protections and can not be used by TDX
guests as private memory.

For every memory region that the VMM wants to use as TDX memory, it sets
up a "TD Memory Region" (TDMR).  Each TDMR represents a physically
contiguous convertible range and must also have its own physically
contiguous metadata table, referred to as a Physical Address Metadata
Table (PAMT), to track status for each page in the TDMR range.

Unlike a CMR, each TDMR requires 1G granularity and alignment.  To
support physical RAM areas that don't meet those strict requirements,
each TDMR permits a number of internal "reserved areas" which can be
placed over memory holes.  If PAMT metadata is placed within a TDMR it
must be covered by one of these reserved areas.

Let's summarize the concepts:

 CMR - Firmware-enumerated physical ranges that support TDX.  CMRs are
       4K aligned.
TDMR - Physical address range which is chosen by the kernel to support
       TDX.  1G granularity and alignment required.  Each TDMR has
       reserved areas where TDX memory holes and overlapping PAMTs can
       be put into.
PAMT - Physically contiguous TDX metadata.  One table for each page size
       per TDMR.  Roughly 1/256th of TDMR in size.  256G TDMR = ~1G
       PAMT.

As one step of initializing the TDX module, the kernel configures
TDX-usable memory by passing an array of TDMRs to the TDX module.

Constructing the array of TDMRs consists below steps:

1) Create TDMRs to cover all memory regions that TDX module can use;
2) Allocate and set up PAMT for each TDMR;
3) Set up reserved areas for each TDMR.

Add a placeholder to construct TDMRs to do the above steps after all
memblock memory regions are verified to be convertible.  Always free
TDMRs at the end of the initialization (no matter successful or not)
as TDMRs are only used during the initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v5 (no feedback on v4):
 - Moved calculating TDMR size to this patch.
 - Changed to use alloc_pages_exact() to allocate buffer for all TDMRs
   once, instead of allocating each TDMR individually.
 - Removed "crypto protection" in the changelog.
 - -EFAULT -> -EINVAL in couple of places.

---
 arch/x86/virt/vmx/tdx/tdx.c | 73 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 23 ++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2b20d4a7a62b..645addb1bea2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -17,6 +17,8 @@
 #include <linux/atomic.h>
 #include <linux/sizes.h>
 #include <linux/memblock.h>
+#include <linux/gfp.h>
+#include <linux/align.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
@@ -425,6 +427,55 @@ static int check_memblock_tdx_convertible(void)
 	return 0;
 }
 
+/* Calculate the actual TDMR_INFO size */
+static inline int cal_tdmr_size(void)
+{
+	int tdmr_sz;
+
+	/*
+	 * The actual size of TDMR_INFO depends on the maximum number
+	 * of reserved areas.
+	 */
+	tdmr_sz = sizeof(struct tdmr_info);
+	tdmr_sz += sizeof(struct tdmr_reserved_area) *
+		   tdx_sysinfo.max_reserved_per_tdmr;
+
+	/*
+	 * TDX requires each TDMR_INFO to be 512-byte aligned.  Always
+	 * round up TDMR_INFO size to the 512-byte boundary.
+	 */
+	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
+}
+
+static struct tdmr_info *alloc_tdmr_array(int *array_sz)
+{
+	/*
+	 * TDX requires each TDMR_INFO to be 512-byte aligned.
+	 * Use alloc_pages_exact() to allocate all TDMRs at once.
+	 * Each TDMR_INFO will still be 512-byte aligned since
+	 * cal_tdmr_size() always return 512-byte aligned size.
+	 */
+	*array_sz = cal_tdmr_size() * tdx_sysinfo.max_tdmrs;
+
+	/*
+	 * Zero the buffer so 'struct tdmr_info::size' can be
+	 * used to determine whether a TDMR is valid.
+	 */
+	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
+}
+
+/*
+ * Construct an array of TDMRs to cover all memory regions in memblock.
+ * This makes sure all pages managed by the page allocator are TDX
+ * memory.  The actual number of TDMRs is kept to @tdmr_num.
+ */
+static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
+				     int *tdmr_num)
+{
+	/* Return -EINVAL until constructing TDMRs is done */
+	return -EINVAL;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -434,6 +485,9 @@ static int check_memblock_tdx_convertible(void)
  */
 static int init_tdx_module(void)
 {
+	struct tdmr_info *tdmr_array;
+	int tdmr_array_sz;
+	int tdmr_num;
 	int ret;
 
 	/*
@@ -471,11 +525,30 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Prepare enough space to construct TDMRs */
+	tdmr_array = alloc_tdmr_array(&tdmr_array_sz);
+	if (!tdmr_array) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Construct TDMRs to cover all memory regions in memblock */
+	ret = construct_tdmrs_memeblock(tdmr_array, &tdmr_num);
+	if (ret)
+		goto out_free_tdmrs;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
+out_free_tdmrs:
+	/*
+	 * The array of TDMRs is freed no matter the initialization is
+	 * successful or not.  They are not needed anymore after the
+	 * module initialization.
+	 */
+	free_pages_exact(tdmr_array, tdmr_array_sz);
 out:
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 63b1edd11660..55d6c69ab900 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -114,6 +114,29 @@ struct tdsysinfo_struct {
 	};
 } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
 
+struct tdmr_reserved_area {
+	u64 offset;
+	u64 size;
+} __packed;
+
+#define TDMR_INFO_ALIGNMENT	512
+
+struct tdmr_info {
+	u64 base;
+	u64 size;
+	u64 pamt_1g_base;
+	u64 pamt_1g_size;
+	u64 pamt_2m_base;
+	u64 pamt_2m_size;
+	u64 pamt_4k_base;
+	u64 pamt_4k_size;
+	/*
+	 * Actual number of reserved areas depends on
+	 * 'struct tdsysinfo_struct'::max_reserved_per_tdmr.
+	 */
+	struct tdmr_reserved_area reserved_areas[0];
+} __packed __aligned(TDMR_INFO_ALIGNMENT);
+
 /*
  * Do not put any hardware-defined TDX structure representations below this
  * comment!
-- 
2.36.1


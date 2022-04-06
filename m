Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CBD4F5DC5
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 14:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiDFMXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 08:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiDFMWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 08:22:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E0451D4F;
        Tue,  5 Apr 2022 21:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220625; x=1680756625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t7sxXTOzuUv8n2P6tB8DEK22QX54Lj6/5SNi7pG8i1M=;
  b=epB/Ezl4Z9WPuaQ9CqnBIFPwQyNBBvPeKxTOMzkqd2ZNrDpLIRFIMIwG
   ghWm5TV9lw84ECAN8s0zJPpa4Z+Hd1WinnabA7eImR63KHRK4C5rFYEbj
   HnRxnLppum8p2mY3Z+948EYNwduPXUVMrhJ+bd/bbfXqAiGzmcKsjvfPB
   wfmpNY4MwA/vYCVtZGlMF3mzK+510QXt/HFU2fc0/g/0iY+prv1TMqPRM
   EcsSE7nWMh/M3EIxNTT1Ld9T+H6oWCLPqc7QAZ5XapTjjU2fqQJJpAXAl
   pg1mOLhsCSni7VlNz+LtePb28nhU/0mmyPR6R8hj2FrmJwMR0zJ7Xno03
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089837"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089837"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:24 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302334"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:20 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all system RAM as TDX memory
Date:   Wed,  6 Apr 2022 16:49:22 +1200
Message-Id: <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
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

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, TDX introduced the concept of a "Convertible Memory Region"
(CMR).  During boot, the firmware builds a list of all of the memory
ranges which can provide the TDX security guarantees.  The list of these
ranges, along with TDX module information, is available to the kernel by
querying the TDX module.

In order to provide crypto protection to TD guests, the TDX architecture
also needs additional metadata to record things like which TD guest
"owns" a given page of memory.  This metadata essentially serves as the
'struct page' for the TDX module.  The space for this metadata is not
reserved by the hardware upfront and must be allocated by the kernel
and given to the TDX module.

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

As one step of initializing the TDX module, the memory regions that TDX
module can use must be configured to the TDX module via an array of
TDMRs.

Constructing TDMRs to build the TDX memory consists below steps:

1) Create TDMRs to cover all memory regions that TDX module can use;
2) Allocate and set up PAMT for each TDMR;
3) Set up reserved areas for each TDMR.

Add a placeholder right after getting TDX module and CMRs information to
construct TDMRs to do the above steps, as the preparation to configure
the TDX module.  Always free TDMRs at the end of the initialization (no
matter successful or not), as TDMRs are only used during the
initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 23 ++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 482e6d858181..ec27350d53c1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -594,8 +595,29 @@ static int tdx_get_sysinfo(void)
 	return sanitize_cmrs(tdx_cmr_array, cmr_num);
 }
 
+static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
+{
+	int i;
+
+	for (i = 0; i < tdmr_num; i++) {
+		struct tdmr_info *tdmr = tdmr_array[i];
+
+		/* kfree() works with NULL */
+		kfree(tdmr);
+		tdmr_array[i] = NULL;
+	}
+}
+
+static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
+{
+	/* Return -EFAULT until constructing TDMRs is done */
+	return -EFAULT;
+}
+
 static int init_tdx_module(void)
 {
+	struct tdmr_info **tdmr_array;
+	int tdmr_num;
 	int ret;
 
 	/* TDX module global initialization */
@@ -613,11 +635,36 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * Prepare enough space to hold pointers of TDMRs (TDMR_INFO).
+	 * TDX requires TDMR_INFO being 512 aligned.  Each TDMR is
+	 * allocated individually within construct_tdmrs() to meet
+	 * this requirement.
+	 */
+	tdmr_array = kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tdmr_info *),
+			GFP_KERNEL);
+	if (!tdmr_array) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Construct TDMRs to build TDX memory */
+	ret = construct_tdmrs(tdmr_array, &tdmr_num);
+	if (ret)
+		goto out_free_tdmrs;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
 	 */
 	ret = -EFAULT;
+out_free_tdmrs:
+	/*
+	 * TDMRs are only used during initializing TDX module.  Always
+	 * free them no matter the initialization was successful or not.
+	 */
+	free_tdmrs(tdmr_array, tdmr_num);
+	kfree(tdmr_array);
 out:
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 2f21c45df6ac..05bf9fe6bd00 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -89,6 +89,29 @@ struct tdsysinfo_struct {
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
  * P-SEAMLDR SEAMCALL leaf function
  */
-- 
2.35.1


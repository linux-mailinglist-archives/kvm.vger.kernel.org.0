Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750094C60FA
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiB1CPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiB1CPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:33 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D3A52B39;
        Sun, 27 Feb 2022 18:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014495; x=1677550495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wq3egMJKoAmqTPVIbSfkf2lj+Zld4Y217+pv0qFmm9A=;
  b=dYWROYlkme/S8+/nZaUmPxF89T+K2iyyM/M/OQSXKrRWnW7X3eB+iQRp
   5W1L+ERQ1lvpcGOmqukv/5bC9m2Pn48vkQHpwuC5AruriBCv+c89H2Pjq
   g2tV/AiPY33ad8cu49y6rDOpFS1EV7oLH5y//2t/4sG/ZgTQ4FEqu2K4p
   xU3UQqk48lTsX7zwqfqpv3sF0QY06TNJ0qHBq8XT7GpJSp588fJ9N5eXZ
   Ah2logRwRxx663xlq+5UAhQDkilIXAuMcFJOzh6m1KIdU9OtDt58ckhJ8
   vrnv0EqdYMKBcrnt4k8MiUhkaT/Z76qK1D3mjn7UVbAlq5/1KkvrHrA2F
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191933"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191933"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:26 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936934"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:21 -0800
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
Subject: [RFC PATCH 10/21] x86/virt/tdx: Add placeholder to coveret all system RAM as TDX memory
Date:   Mon, 28 Feb 2022 15:12:58 +1300
Message-Id: <55bdfd91c81fe702b55d74ea3ade8334bf148732.1646007267.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx.h | 23 ++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index ca873b4373fd..cd7c09a57235 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -13,6 +13,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -591,8 +592,29 @@ static int tdx_get_sysinfo(void)
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
@@ -610,11 +632,36 @@ static int init_tdx_module(void)
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
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index 2f21c45df6ac..05bf9fe6bd00 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
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
2.33.1


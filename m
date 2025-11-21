Return-Path: <kvm+bounces-64033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B1350C76CF8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 308EC35D871
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7438B28DF2D;
	Fri, 21 Nov 2025 00:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfK0/2YQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9802C27B50F;
	Fri, 21 Nov 2025 00:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686307; cv=none; b=rrfKXG+8B6tRX6HYTUThUl290CTxgfKxS+3rkLvehEUo3jcgs87xWfDyde5vhHyj/kBOcA11lCmyvM/DSevWwQofJFa3eTCm5+91wpl1B6SRLjfENS0iJKhjKYv9ZBYk8hw/uH2JVCSB+7JQJxULhapnIpUmAjmH/v2g5HwcK24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686307; c=relaxed/simple;
	bh=BsX+SCTmcC++2gbaoYUUpdhFang7y75ccMkgg/HXGH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HplYeExtJiYbzQ0/1N5zw6Le4bJaFhwQeOqyFZfkIf0W8jyuN4Uh0Qx1xFSxrD6Ppb4fwvCb72wknA/QUzG9Ochg0s24fpUuib4Afh33IUFp0T6VBOvMyOzcu2LZ+yMS6w42YxfpoGU9b92i6w5wpDwbHzboQBfeydttdv85RNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfK0/2YQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686306; x=1795222306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BsX+SCTmcC++2gbaoYUUpdhFang7y75ccMkgg/HXGH8=;
  b=IfK0/2YQh7ufyYi0usQwFI5MxLoU+OcqZTqmd2P0/x/MP6Moy+AHTMkp
   5uXvfJgW+oLeWJktPL/jMUTmNYyT8vehj54/UXnFZP/CXJjJnfHK7lC2n
   0CFcaidbddtV3A4PcHyIBc7r/Vw6fJ8QbsIJt2+repSGGhaaGNUSc7j/i
   mYCKCdJlCH+qFkpsTAqqbwgWr0z+LM4pNOqxbu1o/vJRZxnVhszITqPO+
   +qwFDMj9gNYQ8PpfvlRGB3hHg83WquOiU4TcQLeTzLk3TuKNu7wz/BkLb
   6l8uIF/+aHSc4EPEr8ew6FGg6iN5G5+okYgiBbcbrThbJVB6ZEPnVzy6O
   A==;
X-CSE-ConnectionGUID: 0fBCAH3QS0mJwlKtk4JUtw==
X-CSE-MsgGUID: Y5qKjAolRmOsv3znP9L92Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780752"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780752"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:43 -0800
X-CSE-ConnectionGUID: BsIpQr/SRcmg51fZh9g1bQ==
X-CSE-MsgGUID: go2GuK2uSGyDxsgp7qrBxQ==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:43 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 05/16] x86/virt/tdx: Allocate reference counters for PAMT memory
Date: Thu, 20 Nov 2025 16:51:14 -0800
Message-ID: <20251121005125.417831-6-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The PAMT memory holds metadata for TDX protected memory. With Dynamic
PAMT, the 4KB range of PAMT is allocated on demand. The kernel supplies
the TDX module with a page pair that covers 2MB of host physical memory.

The kernel must provide this page pair before using pages from the range
for TDX. If this is not done, any SEAMCALL that attempts to use the memory
will fail.

Allocate reference counters for every 2MB range to track PAMT memory usage.
This is necessary to accurately determine when PAMT memory needs to be
allocated and when it can be freed.

This allocation will currently consume 2 MB for every 1 TB of address
space from 0 to max_pfn (highest pfn of RAM). The allocation size will
depend on how the ram is physically laid out. In a worse case scenario
where the entire 52 bit address space is covered this would be 8GB. Then
the DPAMT refcount allocations could hypothetically exceed the savings
from Dynamic PAMT, which is 4GB per TB. This is probably unlikely.

However, future changes will reduce this refcount overhead to make DPAMT
always a net win.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Log typo (Binbin)
 - round correctly when computing PAMT refcount size (Binbin)
 - Zero refcount vmalloc allocation (Note: This got replaced in
   optimization patch with a zero-ed allocation, but this showed up in
   testing with the optimization patches removed. Since it's fixed
   before this code is exercised, it's not a bisectability issue, but fix
   it anyway.)

v3:
 - Split out lazily populate optimization to next patch (Dave)
 - Add comment around pamt_refcounts (Dave)
 - Improve log
---
 arch/x86/virt/vmx/tdx/tdx.c | 47 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6c522db71265..c28d4d11736c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -29,6 +29,7 @@
 #include <linux/acpi.h>
 #include <linux/suspend.h>
 #include <linux/idr.h>
+#include <linux/vmalloc.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -50,6 +51,16 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
+/*
+ * On a machine with Dynamic PAMT, the kernel maintains a reference counter
+ * for every 2M range. The counter indicates how many users there are for
+ * the PAMT memory of the 2M range.
+ *
+ * The kernel allocates PAMT memory when the first user arrives and
+ * frees it when the last user has left.
+ */
+static atomic_t *pamt_refcounts;
+
 static enum tdx_module_status_t tdx_module_status;
 static DEFINE_MUTEX(tdx_module_lock);
 
@@ -183,6 +194,34 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
+/*
+ * Allocate PAMT reference counters for all physical memory.
+ *
+ * It consumes 2MiB for every 1TiB of physical memory.
+ */
+static int init_pamt_metadata(void)
+{
+	size_t size = DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	pamt_refcounts = __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
+	if (!pamt_refcounts)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void free_pamt_metadata(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	vfree(pamt_refcounts);
+	pamt_refcounts = NULL;
+}
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1082,10 +1121,14 @@ static int init_tdx_module(void)
 	 */
 	get_online_mems();
 
-	ret = build_tdx_memlist(&tdx_memlist);
+	ret = init_pamt_metadata();
 	if (ret)
 		goto out_put_tdxmem;
 
+	ret = build_tdx_memlist(&tdx_memlist);
+	if (ret)
+		goto err_free_pamt_metadata;
+
 	/* Allocate enough space for constructing TDMRs */
 	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
@@ -1135,6 +1178,8 @@ static int init_tdx_module(void)
 	free_tdmr_list(&tdx_tdmr_list);
 err_free_tdxmem:
 	free_tdx_memlist(&tdx_memlist);
+err_free_pamt_metadata:
+	free_pamt_metadata();
 	goto out_put_tdxmem;
 }
 
-- 
2.51.2



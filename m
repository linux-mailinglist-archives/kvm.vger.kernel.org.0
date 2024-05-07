Return-Path: <kvm+bounces-16794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2469E8BDB46
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E0B41F229AC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC41070CC8;
	Tue,  7 May 2024 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NfEaoMON"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF106F065;
	Tue,  7 May 2024 06:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062890; cv=none; b=hL/wdo372+Mk/R1g+ecJdsrfSRcKH1R8WjgObFYcspD1ixJqyb1CeCYEvsEX+SdTUxj9vghPZJ2gCrYVO7vxY6fZKdgj79bYrbz4dZBMnWkqy2D47sq9tIHaUkAOEkGsYGmpdbqswn99r06WkUAjQlkpo0LVvvpMyRIZJ0O5Hh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062890; c=relaxed/simple;
	bh=eqXBY8IV3KlWfbVSlPRhINiga95k0gcj6FAROJ4ib1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=PHRBooXP4zCIvlaFMRoF5s3uMKRDgYH9V6mG95obfI3CcT44k9PxxNWHTlsvJoDKkuU8pcECNRtXB8EW2isfEgvwJ23Ky7eM8FWNFjWbueYe0Ax7riE+J+bembFLwreN7Vow5KuEP6qtbMWMryAyTFTjQG7+RcW0J1amTQoWN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NfEaoMON; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715062887; x=1746598887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=eqXBY8IV3KlWfbVSlPRhINiga95k0gcj6FAROJ4ib1c=;
  b=NfEaoMONorl2SLX/A2n++n1pZp93LhiYbwiKzA8lU+Z0wPKy6UOgQ5nL
   EpYGPrMH8dUqqpt5k5MMqbtlAhKjcsm7Un75/tc2x4WlgSSDDz/1Db4gU
   HZMH5Y/8vNxrDnpqEwn3N7O7oULrp+z7Ggpimw0Yb9H0rMyhMdHVC+T43
   pfX8lmLfjQa4hoEe4b4Y80KMtxs/0pxnKB4oA4p1NRuw7UsrkuyzlmS1F
   UivKR5pEJKCZys5nyezzE9eYVwKyVzMzYVkvd/wjTD2H5His8IWbz/KRZ
   zWEPisxuBdUe5rZdIreIC4w40/EnckyYGTk08XWR4lIzpVy/HpkumS2d6
   w==;
X-CSE-ConnectionGUID: vf5zfy9MSu6ptg0LHGtdJg==
X-CSE-MsgGUID: SFaJdRBLT5ychgDAjdXpBQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10766338"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10766338"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:21:27 -0700
X-CSE-ConnectionGUID: emaow2PKROCtfMXVpYkOpg==
X-CSE-MsgGUID: kqG27CMdQ2iU743KBOFTBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="59261388"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:21:21 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: iommu@lists.linux.dev,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	corbet@lwn.net,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	baolu.lu@linux.intel.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 3/5] x86/mm: Introduce and export interface arch_clean_nonsnoop_dma()
Date: Tue,  7 May 2024 14:20:44 +0800
Message-Id: <20240507062044.20399-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240507061802.20184-1-yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Introduce and export interface arch_clean_nonsnoop_dma() to flush CPU
caches for memory involved in non-coherent DMAs (DMAs that lack CPU cache
snooping).

When IOMMU does not enforce cache coherency, devices are allowed to perform
non-coherent DMAs. This scenario poses a risk of information leakage when
the device is assigned into a VM. Specifically, a malicious guest could
potentially retrieve stale host data through non-coherent DMA reads to
physical memory, with data initialized by host (e.g., zeros) still residing
in the cache.

Additionally, host kernel (e.g. by a ksm kthread) is possible to read
inconsistent data from CPU cache/memory (left by a malicious guest) after
a page is unpinned for non-coherent DMA but before it's freed.

Therefore, VFIO/IOMMUFD must initiate a CPU cache flush for pages involved
in non-coherent DMAs prior to or following their mapping or unmapping to or
from the IOMMU.

Introduce and export an interface accepting a contiguous physical address
range as input to help flush CPU caches in architecture specific way for
VFIO/IOMMUFD. (Currently, x86 only).

Given CLFLUSH on MMIOs in x86 is generally undesired and sometimes will
cause MCE on certain platforms (e.g. executing CLFLUSH on VGA ranges
0xA0000-0xBFFFF causes MCE on some platforms). Meanwhile, some MMIOs are
cacheable and demands CLFLUSH (e.g. certain MMIOs for PMEM). Hence, a
method of checking host PAT/MTRR for uncacheable memory is adopted.

This implementation always performs CLFLUSH on "pfn_valid() && !reserved"
pages (since they are not possible to be MMIOs).
For the reserved or !pfn_valid() cases, check host PAT/MTRR to bypass
uncacheable physical ranges in host and do CFLUSH on the rest cacheable
ranges.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/cacheflush.h |  3 ++
 arch/x86/mm/pat/set_memory.c      | 88 +++++++++++++++++++++++++++++++
 include/linux/cacheflush.h        |  6 +++
 3 files changed, 97 insertions(+)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index b192d917a6d0..b63607994285 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -10,4 +10,7 @@
 
 void clflush_cache_range(void *addr, unsigned int size);
 
+void arch_clean_nonsnoop_dma(phys_addr_t phys, size_t length);
+#define arch_clean_nonsnoop_dma arch_clean_nonsnoop_dma
+
 #endif /* _ASM_X86_CACHEFLUSH_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 80c9037ffadf..7ff08ad20369 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -34,6 +34,7 @@
 #include <asm/memtype.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
+#include <asm/mtrr.h>
 
 #include "../mm_internal.h"
 
@@ -349,6 +350,93 @@ void arch_invalidate_pmem(void *addr, size_t size)
 EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
 #endif
 
+/*
+ * Flush pfn_valid() and !PageReserved() page
+ */
+static void clflush_page(struct page *page)
+{
+	const int size = boot_cpu_data.x86_clflush_size;
+	unsigned int i;
+	void *va;
+
+	va = kmap_local_page(page);
+
+	/* CLFLUSHOPT is unordered and requires full memory barrier */
+	mb();
+	for (i = 0; i < PAGE_SIZE; i += size)
+		clflushopt(va + i);
+	/* CLFLUSHOPT is unordered and requires full memory barrier */
+	mb();
+
+	kunmap_local(va);
+}
+
+/*
+ * Flush a reserved page or !pfn_valid() PFN.
+ * Flush is not performed if the PFN is accessed in uncacheable type. i.e.
+ * - PAT type is UC/UC-/WC when PAT is enabled
+ * - MTRR type is UC/WC/WT/WP when PAT is not enabled.
+ *   (no need to do CLFLUSH though WT/WP is cacheable).
+ */
+static void clflush_reserved_or_invalid_pfn(unsigned long pfn)
+{
+	const int size = boot_cpu_data.x86_clflush_size;
+	unsigned int i;
+	void *va;
+
+	if (!pat_enabled()) {
+		u64 start = PFN_PHYS(pfn), end = start + PAGE_SIZE;
+		u8 mtrr_type, uniform;
+
+		mtrr_type = mtrr_type_lookup(start, end, &uniform);
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return;
+	} else if (pat_pfn_immune_to_uc_mtrr(pfn)) {
+		return;
+	}
+
+	va = memremap(pfn << PAGE_SHIFT, PAGE_SIZE, MEMREMAP_WB);
+	if (!va)
+		return;
+
+	/* CLFLUSHOPT is unordered and requires full memory barrier */
+	mb();
+	for (i = 0; i < PAGE_SIZE; i += size)
+		clflushopt(va + i);
+	/* CLFLUSHOPT is unordered and requires full memory barrier */
+	mb();
+
+	memunmap(va);
+}
+
+static inline void clflush_pfn(unsigned long pfn)
+{
+	if (pfn_valid(pfn) &&
+	    (!PageReserved(pfn_to_page(pfn)) || is_zero_pfn(pfn)))
+		return clflush_page(pfn_to_page(pfn));
+
+	clflush_reserved_or_invalid_pfn(pfn);
+}
+
+/**
+ * arch_clean_nonsnoop_dma - flush a cache range for non-coherent DMAs
+ *                           (DMAs that lack CPU cache snooping).
+ * @phys_addr:	physical address start
+ * @length:	number of bytes to flush
+ */
+void arch_clean_nonsnoop_dma(phys_addr_t phys_addr, size_t length)
+{
+	unsigned long nrpages, pfn;
+	unsigned long i;
+
+	pfn = PHYS_PFN(phys_addr);
+	nrpages = PAGE_ALIGN((phys_addr & ~PAGE_MASK) + length) >> PAGE_SHIFT;
+
+	for (i = 0; i < nrpages; i++, pfn++)
+		clflush_pfn(pfn);
+}
+EXPORT_SYMBOL_GPL(arch_clean_nonsnoop_dma);
+
 #ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 bool cpu_cache_has_invalidate_memregion(void)
 {
diff --git a/include/linux/cacheflush.h b/include/linux/cacheflush.h
index 55f297b2c23f..0bfc6551c6d3 100644
--- a/include/linux/cacheflush.h
+++ b/include/linux/cacheflush.h
@@ -26,4 +26,10 @@ static inline void flush_icache_pages(struct vm_area_struct *vma,
 
 #define flush_icache_page(vma, page)	flush_icache_pages(vma, page, 1)
 
+#ifndef arch_clean_nonsnoop_dma
+static inline void arch_clean_nonsnoop_dma(phys_addr_t phys, size_t length)
+{
+}
+#endif
+
 #endif /* _LINUX_CACHEFLUSH_H */
-- 
2.17.1



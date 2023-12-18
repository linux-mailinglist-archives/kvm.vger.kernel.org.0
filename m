Return-Path: <kvm+bounces-4675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4195A816713
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBF6D28465D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34AE101EB;
	Mon, 18 Dec 2023 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYQojeCy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22A1101D3
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883436; x=1734419436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+kwAhn5WryY9fN9Y2vDoItlznXN1nEPMqJX9dcwY2k=;
  b=eYQojeCyAQ8acs8jyIHTqNAxuIZWfsmI3G+2f5Gqm4ZTZhW5jeK0ZyAf
   W3MZ6lD8JSJLDPLstXHUwkwN6lPcuiPY7EcReSH6MazJqcWekWY1dV1W1
   /eU6wIcqGE8P//+ODxfeiPyLShQZOP+dSicw07OSpiJyGo3EPnCZ8KAKP
   Djy7CqVXpy5qlw6/s8O7sZRMYRGeOrqG7govkUI3rMnmpHxYnGaRCBcDA
   1nNijAnLnmKKk7+kpv2t2xFClX42KSgyGsGTI419INyCZPB1QYh/iCRPR
   ZFzIo+E5BdLvFRhy5NHmHhdXhRCsq1+SpXNfjF7PTNALIAn7dUzKK6mpC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667913"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667913"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824709"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824709"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:32 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 09/18] x86 TDX: Add support for memory accept
Date: Mon, 18 Dec 2023 15:22:38 +0800
Message-Id: <20231218072247.2573516-10-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

TDVF supports partial memory acceptance to optimize boot time and leaves
remaining memory acceptance to OS.

Accept remaining memory of type EFI_UNACCEPTED_MEMORY at bootup. Try 1G
page accept first even though hugepage memory isn't used in qemu command
line currently.

Export below functions so they can be used by TDX specific sub-test in
the future.

	tdx_shared_mask()
	tdx_accept_memory()
	tdx_enc_status_changed()

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-9-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/asm-generic/page.h |   7 +-
 lib/linux/efi.h        |  23 ++++-
 lib/x86/asm/page.h     |  19 ++++
 lib/x86/setup.c        |   6 +-
 lib/x86/tdx.c          | 201 ++++++++++++++++++++++++++++++++++++++++-
 lib/x86/tdx.h          |  18 +++-
 6 files changed, 268 insertions(+), 6 deletions(-)

diff --git a/lib/asm-generic/page.h b/lib/asm-generic/page.h
index 5ed08612..56f539ac 100644
--- a/lib/asm-generic/page.h
+++ b/lib/asm-generic/page.h
@@ -12,8 +12,11 @@
 #include <linux/const.h>
 
 #define PAGE_SHIFT		12
-#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK		(~(PAGE_SIZE-1))
+#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK		(~(PAGE_SIZE - 1))
+#define PMD_SHIFT		21
+#define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE - 1))
 
 #ifndef __ASSEMBLY__
 
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 410f0b1a..6d8eec17 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -104,7 +104,8 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
 #define EFI_PERSISTENT_MEMORY		14
-#define EFI_MAX_MEMORY_TYPE		15
+#define EFI_UNACCEPTED_MEMORY		15
+#define EFI_MAX_MEMORY_TYPE		16
 
 /* Attribute values: */
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
@@ -542,6 +543,26 @@ typedef struct {
 	efi_char16_t	file_name[1];
 } efi_file_info_t;
 
+/*
+ * efi_memdesc_ptr - get the n-th EFI memmap descriptor
+ * @map: the start of efi memmap
+ * @desc_size: the size of space for each EFI memmap descriptor
+ * @n: the index of efi memmap descriptor
+ *
+ * EFI boot service provides the GetMemoryMap() function to get a copy of the
+ * current memory map which is an array of memory descriptors, each of
+ * which describes a contiguous block of memory. It also gets the size of the
+ * map, and the size of each descriptor, etc.
+ *
+ * Note that per section 6.2 of UEFI Spec 2.6 Errata A, the returned size of
+ * each descriptor might not be equal to sizeof(efi_memory_memdesc_t),
+ * since efi_memory_memdesc_t may be extended in the future. Thus the OS
+ * MUST use the returned size of the descriptor to find the start of each
+ * efi_memory_memdesc_t in the memory map array.
+ */
+#define efi_memdesc_ptr(map, desc_size, n)			\
+	((efi_memory_desc_t *)((void *)(map) + ((n) * (desc_size))))
+
 #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
 #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
 
diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 298e7e8e..d57ad6ea 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -79,5 +79,24 @@ extern unsigned long long get_amd_sev_addr_upperbound(void);
 #define PGDIR_BITS(lvl)        (((lvl) - 1) * PGDIR_WIDTH + PAGE_SHIFT)
 #define PGDIR_OFFSET(va, lvl)  (((va) >> PGDIR_BITS(lvl)) & PGDIR_MASK)
 
+enum pg_level {
+	PG_LEVEL_NONE,
+	PG_LEVEL_4K,
+	PG_LEVEL_2M,
+	PG_LEVEL_1G,
+	PG_LEVEL_512G,
+	PG_LEVEL_NUM
+};
+
+#define PTE_SHIFT 9
+static inline int page_level_shift(enum pg_level level)
+{
+	return (PAGE_SHIFT - PTE_SHIFT) + level * PTE_SHIFT;
+}
+static inline unsigned long page_level_size(enum pg_level level)
+{
+	return 1UL << page_level_shift(level);
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 8ff8ce4f..20807700 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -309,7 +309,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	efi_status_t status;
 	const char *phase;
 
-	status = setup_tdx();
+	/*
+	 * TDVF support partial memory accept, accept remaining memory
+	 * early so memory allocator can use it.
+	 */
+	status = setup_tdx(efi_bootinfo);
 	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
 		printf("INTEL TDX setup failed, error = 0x%lx\n", status);
 		return status;
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index dc722653..68c12e30 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -11,10 +11,12 @@
  */
 
 #include "tdx.h"
+#include "errno.h"
 #include "bitops.h"
 #include "errno.h"
 #include "x86/processor.h"
 #include "x86/smp.h"
+#include "asm/page.h"
 
 /* Port I/O direction */
 #define PORT_READ	0
@@ -294,6 +296,41 @@ static int handle_io(struct ex_regs *regs, struct ve_info *ve)
 	return ve_instr_len(ve);
 }
 
+static struct {
+	unsigned int gpa_width;
+	unsigned long attributes;
+} td_info;
+
+/* The highest bit of a guest physical address is the "sharing" bit */
+phys_addr_t tdx_shared_mask(void)
+{
+	return 1ULL << (td_info.gpa_width - 1);
+}
+
+static void tdx_get_info(void)
+{
+	struct tdx_module_args args = {};
+	u64 ret;
+
+	/*
+	 * TDINFO TDX module call is used to get the TD execution environment
+	 * information like GPA width, number of available vcpus, debug mode
+	 * information, etc. More details about the ABI can be found in TDX
+	 * Guest-Host-Communication Interface (GHCI), section 2.4.2 TDCALL
+	 * [TDG.VP.INFO].
+	 */
+	ret = __tdcall_ret(TDG_VP_INFO, &args);
+
+	/*
+	 * Non zero return means buggy TDX module (which is
+	 * fatal). So raise a BUG().
+	 */
+	BUG_ON(ret);
+
+	td_info.gpa_width = args.rcx & GENMASK(5, 0);
+	td_info.attributes = args.rdx;
+}
+
 bool is_tdx_guest(void)
 {
 	static int tdx_guest = -1;
@@ -421,11 +458,173 @@ static void tdx_handle_ve(struct ex_regs *regs)
 	tdx_handle_virt_exception(regs, &ve);
 }
 
-efi_status_t setup_tdx(void)
+static unsigned long try_accept_one(phys_addr_t start, unsigned long len,
+				    enum pg_level pg_level)
+{
+	unsigned long accept_size = page_level_size(pg_level);
+	struct tdx_module_args args = {};
+	u8 page_size;
+
+	if (!IS_ALIGNED(start, accept_size))
+		return 0;
+
+	if (len < accept_size)
+		return 0;
+
+	/*
+	 * Pass the page physical address to the TDX module to accept the
+	 * pending, private page.
+	 *
+	 * Bits 2:0 of RCX encode page size: 0 - 4K, 1 - 2M, 2 - 1G.
+	 */
+	switch (pg_level) {
+	case PG_LEVEL_4K:
+		page_size = TDX_PS_4K;
+		break;
+	case PG_LEVEL_2M:
+		page_size = TDX_PS_2M;
+		break;
+	case PG_LEVEL_1G:
+		page_size = TDX_PS_1G;
+		break;
+	default:
+		return 0;
+	}
+
+	args.rcx = start | page_size;
+	if (__tdcall(TDG_MEM_PAGE_ACCEPT, &args))
+		return 0;
+
+	return accept_size;
+}
+
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/*
+	 * For shared->private conversion, accept the page using
+	 * TDG_MEM_PAGE_ACCEPT TDX module call.
+	 */
+	while (start < end) {
+		unsigned long len = end - start;
+		unsigned long accept_size;
+
+		/*
+		 * Try larger accepts first. It gives chance to VMM to keep
+		 * 1G/2M Secure EPT entries where possible and speeds up
+		 * process by cutting number of hypercalls (if successful).
+		 */
+
+		accept_size = try_accept_one(start, len, PG_LEVEL_1G);
+		if (!accept_size)
+			accept_size = try_accept_one(start, len, PG_LEVEL_2M);
+		if (!accept_size)
+			accept_size = try_accept_one(start, len, PG_LEVEL_4K);
+		if (!accept_size)
+			return false;
+		start += accept_size;
+	}
+
+	return true;
+}
+
+/*
+ * Notify the VMM about page mapping conversion. More info about ABI
+ * can be found in TDX Guest-Host-Communication Interface (GHCI),
+ * section "TDG.VP.VMCALL<MapGPA>".
+ */
+static bool tdx_map_gpa(phys_addr_t start, phys_addr_t end, bool enc)
+{
+	/* Retrying the hypercall a second time should succeed; use 3 just in case */
+	const int max_retries_per_page = 3;
+	int retry_count = 0;
+
+	if (!enc) {
+		/* Set the shared (decrypted) bits: */
+		start |= tdx_shared_mask();
+		end   |= tdx_shared_mask();
+	}
+
+	while (retry_count < max_retries_per_page) {
+		struct tdx_module_args args = {
+			.r10 = TDX_HYPERCALL_STANDARD,
+			.r11 = TDVMCALL_MAP_GPA,
+			.r12 = start,
+			.r13 = end - start };
+
+		u64 map_fail_paddr;
+		u64 ret = __tdx_hypercall(&args);
+
+		if (ret != TDVMCALL_STATUS_RETRY)
+			return !ret;
+		/*
+		 * The guest must retry the operation for the pages in the
+		 * region starting at the GPA specified in R11. R11 comes
+		 * from the untrusted VMM. Sanity check it.
+		 */
+		map_fail_paddr = args.r11;
+		if (map_fail_paddr < start || map_fail_paddr >= end)
+			return false;
+
+		/* "Consume" a retry without forward progress */
+		if (map_fail_paddr == start) {
+			retry_count++;
+			continue;
+		}
+
+		start = map_fail_paddr;
+		retry_count = 0;
+	}
+
+	return false;
+}
+
+bool tdx_enc_status_changed(phys_addr_t start, phys_addr_t end, bool enc)
+{
+	if (!tdx_map_gpa(start, end, enc))
+		return false;
+
+	/* shared->private conversion requires memory to be accepted before use */
+	if (enc)
+		return tdx_accept_memory(start, end);
+
+	return true;
+}
+
+static bool tdx_accept_memory_regions(struct efi_boot_memmap *mem_map)
+{
+	unsigned long i, nr_desc = *mem_map->map_size / *mem_map->desc_size;
+	efi_memory_desc_t *d;
+
+	for (i = 0; i < nr_desc; i++) {
+		d = efi_memdesc_ptr(*mem_map->map, *mem_map->desc_size, i);
+
+		if (d->type == EFI_UNACCEPTED_MEMORY) {
+			if (d->phys_addr & ~PAGE_MASK) {
+				printf("WARNING: EFI: unaligned base %lx\n",
+					   d->phys_addr);
+				d->phys_addr &= PAGE_MASK;
+			}
+			if (!tdx_enc_status_changed(d->phys_addr, d->phys_addr +
+					       PAGE_SIZE * d->num_pages, true)) {
+				printf("Accepting memory failed\n");
+				return false;
+			}
+
+			d->type = EFI_CONVENTIONAL_MEMORY;
+		}
+	}
+	return true;
+}
+
+efi_status_t setup_tdx(efi_bootinfo_t *efi_bootinfo)
 {
 	if (!is_tdx_guest())
 		return EFI_UNSUPPORTED;
 
+	tdx_get_info();
+	if (!tdx_accept_memory_regions(&efi_bootinfo->mem_map))
+		return EFI_OUT_OF_RESOURCES;
+
 	handle_exception(20, tdx_handle_ve);
 
 	/* The printf can work here. Since TDVF default exception handler
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index fe0a4d81..a37b21a3 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -26,7 +26,14 @@
 
 /* TDX module Call Leaf IDs */
 #define TDG_VP_VMCALL			0
+#define TDG_VP_INFO			1
 #define TDG_VP_VEINFO_GET		3
+#define TDG_MEM_PAGE_ACCEPT		6
+
+/* TDX hypercall Leaf IDs */
+#define TDVMCALL_MAP_GPA		0x10001
+
+#define TDVMCALL_STATUS_RETRY		1
 
 /*
  * Bitmasks of exposed registers (with VMM).
@@ -57,6 +64,12 @@
 
 #define BUG_ON(condition) do { if (condition) abort(); } while (0)
 
+/* TDX supported page sizes from the TDX module ABI. */
+#define TDX_PS_4K	0
+#define TDX_PS_2M	1
+#define TDX_PS_1G	2
+#define TDX_PS_NR	(TDX_PS_1G + 1)
+
 #define EXIT_REASON_CPUID               10
 #define EXIT_REASON_HLT                 12
 #define EXIT_REASON_IO_INSTRUCTION      30
@@ -141,7 +154,10 @@ struct ve_info {
 };
 
 bool is_tdx_guest(void);
-efi_status_t setup_tdx(void);
+phys_addr_t tdx_shared_mask(void);
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end);
+bool tdx_enc_status_changed(phys_addr_t start, phys_addr_t end, bool enc);
+efi_status_t setup_tdx(efi_bootinfo_t *efi_bootinfo);
 
 #else
 inline bool is_tdx_guest(void) { return false; }
-- 
2.25.1



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C864CB7CA
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiCCH3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiCCH2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E196DFAC
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292461; x=1677828461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KcBiSiPAAMPxH979tDl3bCMRDnlV7SSRwfe7lwKEt24=;
  b=X6dzEqFMJELJEkcuTvkp2inytkSG8NGBRzr3EhH7Q9K5QMBaLElv5gbq
   oJjvGYWWwogRK9/3uO28JycOWC+g0ZlgM6vR7iIx3dm/56++H1YJ9Aj3h
   pct2ufiXACz0Sem6zb0lR9RbR6/G0FCfWth5A20RlG2Xr0AdGALr/NVpt
   RSqZknroG4EixEFAJ8yKQAgfMfRQHJHAdSvglPVSl+1HQXvYj+4Hwmnwc
   u0Ewm1Q+bUmA4+q/mQe199oKLb+L82Q1MqC+vx7KeYDkrY23CsVuGZBM6
   SNnGiZ5bQezeflPLtaKpqy7JeNYcxl2mY7FVBmR/0qzuKwVEvOb+etTvP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176977"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176977"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:38 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631636"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:36 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 08/17] x86 TDX: Add support for memory accept
Date:   Thu,  3 Mar 2022 15:18:58 +0800
Message-Id: <20220303071907.650203-9-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDVF supports partial memory accept to optimize boot time and
leaves remaining memory accept to OS.

Accept remaining memory of EFI_UNACCEPTED_MEMORY type at bootup.
Try 2M page accept first even though hugepage memory isn't used
in qemu command line currently.

Export below functions so they can be used by TDX specific
sub-test in the future.

	tdx_shared_mask()
	tdx_hcall_gpa_intent()
	tdx_accept_memory()

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/asm-generic/page.h |   7 ++-
 lib/linux/efi.h        |  23 ++++++-
 lib/x86/setup.c        |   2 +-
 lib/x86/tdx.c          | 139 ++++++++++++++++++++++++++++++++++++++++-
 lib/x86/tdx.h          |  20 +++++-
 5 files changed, 185 insertions(+), 6 deletions(-)

diff --git a/lib/asm-generic/page.h b/lib/asm-generic/page.h
index 5ed086129657..56f539ac45eb 100644
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
index 455625aa155d..df9fa7974d87 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -96,7 +96,8 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
 #define EFI_PERSISTENT_MEMORY		14
-#define EFI_MAX_MEMORY_TYPE		15
+#define EFI_UNACCEPTED_MEMORY		15
+#define EFI_MAX_MEMORY_TYPE		16
 
 /* Attribute values: */
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
@@ -416,6 +417,26 @@ struct efi_boot_memmap {
 	unsigned long           *buff_size;
 };
 
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
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index e834fdfd290c..29202478ae0d 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -288,7 +288,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	 * TDVF support partial memory accept, accept remaining memory
 	 * early so memory allocator can use it.
 	 */
-	status = setup_tdx();
+	status = setup_tdx(efi_bootinfo);
 	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
 		printf("INTEL TDX setup failed, error = 0x%lx\n", status);
 		return status;
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 2b2e3164be33..b74c697353d9 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -10,9 +10,11 @@
  */
 
 #include "tdx.h"
+#include "errno.h"
 #include "bitops.h"
 #include "x86/processor.h"
 #include "x86/smp.h"
+#include "asm/page.h"
 
 #define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
 #define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
@@ -124,6 +126,42 @@ done:
 	return !!tdx_guest;
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
+	struct tdx_module_output out;
+	u64 ret;
+
+	/*
+	 * TDINFO TDX Module call is used to get the TD
+	 * execution environment information like GPA
+	 * width, number of available vcpus, debug mode
+	 * information, etc. More details about the ABI
+	 * can be found in TDX Guest-Host-Communication
+	 * Interface (GHCI), sec 2.4.2 TDCALL [TDG.VP.INFO].
+	 */
+	ret = __tdx_module_call(TDX_GET_INFO, 0, 0, 0, 0, &out);
+
+	/*
+	 * Non zero return means buggy TDX module (which is
+	 * fatal). So raise a BUG().
+	 */
+	BUG_ON(ret);
+
+	td_info.gpa_width = out.rcx & GENMASK(5, 0);
+	td_info.attributes = out.rdx;
+}
+
 /*
  * Wrapper for standard use of __tdx_hypercall with BUG_ON() check
  * for TDCALL error.
@@ -393,11 +431,110 @@ static void tdx_handle_ve(struct ex_regs *regs)
 	tdx_handle_virtualization_exception(regs, &ve);
 }
 
-efi_status_t setup_tdx(void)
+static u64 tdx_accept_page(phys_addr_t gpa, bool page_2mb)
+{
+	/*
+	 * Pass the page physical address and size (4KB|2MB) to the
+	 * TDX module to accept the pending, private page. More info
+	 * about ABI can be found in TDX Guest-Host-Communication
+	 * Interface (GHCI), sec 2.4.7.
+	 */
+
+	if (page_2mb)
+		gpa |= 1;
+
+	return __tdx_module_call(TDX_ACCEPT_PAGE, gpa, 0, 0, 0, NULL);
+}
+
+/*
+ * Inform the VMM of the guest's intent for this physical page:
+ * shared with the VMM or private to the guest.  The VMM is
+ * expected to change its mapping of the page in response.
+ */
+int tdx_hcall_gpa_intent(phys_addr_t start, phys_addr_t end,
+			 enum tdx_map_type map_type)
+{
+	u64 ret = 0;
+
+	if (map_type == TDX_MAP_SHARED) {
+		start |= tdx_shared_mask();
+		end |= tdx_shared_mask();
+	}
+
+	/*
+	 * Notify VMM about page mapping conversion. More info
+	 * about ABI can be found in TDX Guest-Host-Communication
+	 * Interface (GHCI), sec 3.2.
+	 */
+	ret = _tdx_hypercall(TDVMCALL_MAP_GPA, start, end - start, 0, 0,
+			     NULL);
+	if (ret)
+		ret = -EIO;
+
+	if (ret || map_type == TDX_MAP_SHARED)
+		return ret;
+	/*
+	 * For shared->private conversion, accept the page using
+	 * TDX_ACCEPT_PAGE TDX module call.
+	 */
+	while (start < end) {
+		/* Try 2M page accept first if possible */
+		if (!(start & ~PMD_MASK) && end - start >= PMD_SIZE &&
+				!tdx_accept_page(start, true)) {
+			start += PMD_SIZE;
+			continue;
+		}
+
+		if (tdx_accept_page(start, false))
+			return -EIO;
+		start += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	if (tdx_hcall_gpa_intent(start, end, TDX_MAP_PRIVATE)) {
+		tdx_printf("Accepting memory failed\n");
+		return false;
+	}
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
+				tdx_printf("WARN: EFI: unaligned base %lx\n",
+					   d->phys_addr);
+				d->phys_addr &= PAGE_MASK;
+			}
+			if (!tdx_accept_memory(d->phys_addr, d->phys_addr +
+					       PAGE_SIZE * d->num_pages))
+				return false;
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
 
 	printf("Initialized TDX.\n");
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index 68ddc136d1d9..2f938038dc45 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -30,7 +30,12 @@
 #define EXIT_REASON_MSR_WRITE           32
 
 /* TDX Module call Leaf IDs */
+#define TDX_GET_INFO			1
 #define TDX_GET_VEINFO			3
+#define TDX_ACCEPT_PAGE			6
+
+/* TDX hypercall Leaf IDs */
+#define TDVMCALL_MAP_GPA		0x10001
 
 /*
  * Used in __tdx_module_call() helper function to gather the
@@ -76,8 +81,21 @@ struct ve_info {
 	u32 instr_info;
 };
 
+/*
+ * Page mapping type enum. This is software construct not
+ * part of any hardware or VMM ABI.
+ */
+enum tdx_map_type {
+	TDX_MAP_PRIVATE,
+	TDX_MAP_SHARED,
+};
+
 bool is_tdx_guest(void);
-efi_status_t setup_tdx(void);
+phys_addr_t tdx_shared_mask(void);
+int tdx_hcall_gpa_intent(phys_addr_t start, phys_addr_t end,
+			 enum tdx_map_type map_type);
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end);
+efi_status_t setup_tdx(efi_bootinfo_t *efi_bootinfo);
 
 /* Helper function used to communicate with the TDX module */
 u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-- 
2.25.1


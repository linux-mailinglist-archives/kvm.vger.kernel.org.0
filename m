Return-Path: <kvm+bounces-45222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2D0AA72E9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7F757B38ED
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A2C2561AC;
	Fri,  2 May 2025 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bf5D+MRl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE42550D0;
	Fri,  2 May 2025 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191325; cv=none; b=jS2EBbUxtB0FVAAYG7GbMS46RqJdMTAjPntRTYMxec1HsWghGadW0f30OMFB1XWFeX179adiwOmMSXM9rdtZx81ghzu/K9qJdO20+tiZgpC11kSmK8Fzqvu0N5WD0BppQd6l4g73XQvqsIosxnXVSgqWc17FqRXh5AmxU3z0pGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191325; c=relaxed/simple;
	bh=EqV3ExI1VOsG9HGpNc51/naP8y50Je1jebPzL5aK9WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khA9lRHZIGtKEFhXwg4VRSrkNagUwtsZ8GzlRz0Hp+tczrppU8LHDeHpLWjImswjJU68ths2nSzV8uyVF7gRszchwa2/JjMS/IaWd6LED+1S+jDnRdquM0MqfMIQAGdPknzdgcu+NM9kHCfdbqnEAzGSQR0qJe1kD/gQ7SnjPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bf5D+MRl; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191323; x=1777727323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EqV3ExI1VOsG9HGpNc51/naP8y50Je1jebPzL5aK9WQ=;
  b=bf5D+MRleu/1eJZfMObDEDin+TSA2OBJH+IhkDqhTZkfkgyccVIrc3UL
   EX6q9ba3THtlkOYMp1Rw32oGaTOkNj2GabwZbvLIkRiM+g6+aDFwHVoVm
   jjm7AvCldicvvndxTmHRHpFiH6vmV8vzALx92dM3UdwssVs9NkGATltWy
   FjmfGWx7aX9cBCAp9xGabmPrOMtV8PEcV/fibS2uoHfGxN0rxKGrfQ0bC
   sU3l8VXE/TK6j0Ah1Fc2sJSuy2Rk0b0oKiKK44QSzr0FXAtEE8p/Io9Y1
   bo+R1SS+SdItVMF5v9scNgUm5G/cytbDg+VzQ1cgZcDIrsbOMw47wCNpw
   Q==;
X-CSE-ConnectionGUID: FmSb/EtsRDyt8tv3JSW5fA==
X-CSE-MsgGUID: Nha+lH50QX+Jtt7ActaY+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012959"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012959"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:40 -0700
X-CSE-ConnectionGUID: Vw+bkxLgTUeNsFvPjSwu6w==
X-CSE-MsgGUID: N3uxSHj2RuKGuH9iHRnRTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871065"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 3AB451D2; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 04/12] x86/virt/tdx: Account PAMT memory and print if in /proc/meminfo
Date: Fri,  2 May 2025 16:08:20 +0300
Message-ID: <20250502130828.4071412-5-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PAMT memory can add up to substantial portion of system memory.

Account these pages and print them into /proc/meminfo as TDX.

When no TD running PAMT memory consumption suppose to be zero.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/include/asm/tdx.h        |  2 ++
 arch/x86/mm/Makefile              |  2 ++
 arch/x86/mm/meminfo.c             | 11 +++++++++++
 arch/x86/mm/pat/set_memory.c      |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c       | 26 ++++++++++++++++++++++++--
 6 files changed, 42 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/mm/meminfo.c

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 8d9f1c9aaa4c..e729e9f86e67 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -90,6 +90,8 @@ int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
+void direct_pages_meminfo(struct seq_file *m);
+
 extern int kernel_set_to_readonly;
 
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a134cf3ecd17..8091bf5b43cc 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -205,6 +205,7 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages);
 u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages);
 
+void tdx_meminfo(struct seq_file *m);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
@@ -213,6 +214,7 @@ static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 static inline int tdx_nr_pamt_pages(const struct tdx_sys_info *sysinfo) { return 0; }
+static inline void tdx_meminfo(struct seq_file *m) {}
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 32035d5be5a0..311d60801871 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -38,6 +38,8 @@ CFLAGS_fault.o := -I $(src)/../include/asm/trace
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
+obj-$(CONFIG_PROC_FS)		+= meminfo.o
+
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
diff --git a/arch/x86/mm/meminfo.c b/arch/x86/mm/meminfo.c
new file mode 100644
index 000000000000..7bdb5df014de
--- /dev/null
+++ b/arch/x86/mm/meminfo.c
@@ -0,0 +1,11 @@
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+#include <asm/set_memory.h>
+#include <asm/tdx.h>
+
+void arch_report_meminfo(struct seq_file *m)
+{
+	direct_pages_meminfo(m);
+	tdx_meminfo(m);
+}
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index def3d9284254..59432b92e80e 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -118,7 +118,7 @@ static void collapse_page_count(int level)
 	direct_pages_count[level - 1] -= PTRS_PER_PTE;
 }
 
-void arch_report_meminfo(struct seq_file *m)
+void direct_pages_meminfo(struct seq_file *m)
 {
 	seq_printf(m, "DirectMap4k:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_4K] << 2);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 29defdb7f6bc..74bd81acef7b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2000,13 +2000,28 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
+static atomic_long_t tdx_pamt_count = ATOMIC_LONG_INIT(0);
+
+void tdx_meminfo(struct seq_file *m)
+{
+	unsigned long usage;
+
+	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM))
+		return;
+
+	usage = atomic_long_read(&tdx_pamt_count) *
+		tdx_nr_pamt_pages(&tdx_sysinfo) * PAGE_SIZE / SZ_1K;
+
+	seq_printf(m, "TDX:		%8lu kB\n", usage);
+}
+
 u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages)
 {
 	struct tdx_module_args args = {
 		.rcx = hpa,
 	};
 	struct page *page;
-	u64 *p;
+	u64 *p, ret;
 
 	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
 
@@ -2016,7 +2031,12 @@ u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages)
 		p++;
 	}
 
-	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+	ret = seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+
+	if (!ret)
+		atomic_long_inc(&tdx_pamt_count);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_pamt_add);
 
@@ -2034,6 +2054,8 @@ u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages)
 	if (ret)
 		return ret;
 
+	atomic_long_dec(&tdx_pamt_count);
+
 	p = &args.rdx;
 	for (int i = 0; i < tdx_nr_pamt_pages(&tdx_sysinfo); i++) {
 		page = phys_to_page(*p);
-- 
2.47.2



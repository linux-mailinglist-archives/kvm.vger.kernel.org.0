Return-Path: <kvm+bounces-1320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F347E69FB
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A632812BA
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CDE1DA20;
	Thu,  9 Nov 2023 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHe/HqTI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D841C68D
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:56:25 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9AC2584;
	Thu,  9 Nov 2023 03:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699530985; x=1731066985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bda+YPq4TLWIWWUT++b7YXKwKugox2HQ5WrvdKmFdxg=;
  b=aHe/HqTI+A+D+mzQzq8EP2yplRldCS62RC5Xu5qHo9Y5RVTb70qmNGV2
   r1mMWKt5FEK/qaCWtnCOpRYF9sDUpzRkQAoBEccwe3cPr+xlOAm5w5lPW
   4HVIAa3XJ247uA2ifBz4swEmbPhF0sZrhkntM9izxxCi+h9FBUH+DiaFA
   GWxS59rr+WM1dkqqIaJClks2wSN0YwjcTLqQE2jCmQOjUNHbX+3vzNrTj
   ADpP7IkTJkXZL3uRBOhvQ4CXFu6F/tuv+FAtDtUvSk6rFqKB9tSAFeJWs
   UORE3vhAu1buLn+TytpAKVQE1kfjbSPXrHeSIap1pkx/iE7OxLLAV1Hh9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936248"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936248"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976581"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976581"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:15 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 01/23] x86/virt/tdx: Detect TDX during kernel boot
Date: Fri, 10 Nov 2023 00:55:38 +1300
Message-ID: <527b59c3cc61ca2f65cea7131505b8039a73576d.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  A CPU-attested software module
called 'the TDX module' runs inside a new isolated memory range as a
trusted hypervisor to manage and run protected VMs.

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto-protection to VMs.  The
BIOS is responsible for partitioning the "KeyID" space between legacy
MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
KeyIDs' or 'TDX KeyIDs' for short.

During machine boot, TDX microcode verifies that the BIOS programmed TDX
private KeyIDs consistently and correctly programmed across all CPU
packages.  The MSRs are locked in this state after verification.  This
is why MSR_IA32_MKTME_KEYID_PARTITIONING gets used for TDX enumeration:
it indicates not just that the hardware supports TDX, but that all the
boot-time security checks passed.

The TDX module is expected to be loaded by the BIOS when it enables TDX,
but the kernel needs to properly initialize it before it can be used to
create and run any TDX guests.  The TDX module will be initialized by
the KVM subsystem when KVM wants to use TDX.

Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
private KeyIDs.  Also add a function to report whether TDX is enabled by
the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
cache flush is needed.

The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
own protection.  Just use the first TDX KeyID as the global KeyID and
leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
disable TDX as initializing the TDX module alone is useless.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---

v14 -> v15:
 - Add Sathy's tag

v13 -> v14:
 - "tdx:" -> "virt/tdx:" (internal)
 - Add Dave's tag
 
---
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/tdx.h       |  4 ++
 arch/x86/virt/vmx/tdx/Makefile   |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c      | 90 ++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d51e1850ed0..66c12d4efa31 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -536,6 +536,9 @@
 #define MSR_RELOAD_PMC0			0x000014c1
 #define MSR_RELOAD_FIXED_CTR0		0x00001309
 
+/* KeyID partitioning between MKTME and TDX */
+#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
+
 /*
  * AMD64 MSRs. Not complete. See the architecture manual for a more
  * complete list.
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f3d5305a60fc..ea9a0320b1f8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -83,6 +83,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 u64 __seamcall(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
+
+bool platform_tdx_enabled(void);
+#else
+static inline bool platform_tdx_enabled(void) { return false; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 46ef8f73aebb..90da47eb85ee 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y += seamcall.o
+obj-y += seamcall.o tdx.o
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
new file mode 100644
index 000000000000..13d22ea2e2d9
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2023 Intel Corporation.
+ *
+ * Intel Trusted Domain Extensions (TDX) support
+ */
+
+#define pr_fmt(fmt)	"virt/tdx: " fmt
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/printk.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/tdx.h>
+
+static u32 tdx_global_keyid __ro_after_init;
+static u32 tdx_guest_keyid_start __ro_after_init;
+static u32 tdx_nr_guest_keyids __ro_after_init;
+
+static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
+					    u32 *nr_tdx_keyids)
+{
+	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
+	int ret;
+
+	/*
+	 * IA32_MKTME_KEYID_PARTIONING:
+	 *   Bit [31:0]:	Number of MKTME KeyIDs.
+	 *   Bit [63:32]:	Number of TDX private KeyIDs.
+	 */
+	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
+			&_nr_tdx_keyids);
+	if (ret)
+		return -ENODEV;
+
+	if (!_nr_tdx_keyids)
+		return -ENODEV;
+
+	/* TDX KeyIDs start after the last MKTME KeyID. */
+	_tdx_keyid_start = _nr_mktme_keyids + 1;
+
+	*tdx_keyid_start = _tdx_keyid_start;
+	*nr_tdx_keyids = _nr_tdx_keyids;
+
+	return 0;
+}
+
+static int __init tdx_init(void)
+{
+	u32 tdx_keyid_start, nr_tdx_keyids;
+	int err;
+
+	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
+	if (err)
+		return err;
+
+	pr_info("BIOS enabled: private KeyID range [%u, %u)\n",
+			tdx_keyid_start, tdx_keyid_start + nr_tdx_keyids);
+
+	/*
+	 * The TDX module itself requires one 'global KeyID' to protect
+	 * its metadata.  If there's only one TDX KeyID, there won't be
+	 * any left for TDX guests thus there's no point to enable TDX
+	 * at all.
+	 */
+	if (nr_tdx_keyids < 2) {
+		pr_err("initialization failed: too few private KeyIDs available.\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Just use the first TDX KeyID as the 'global KeyID' and
+	 * leave the rest for TDX guests.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+	tdx_guest_keyid_start = tdx_keyid_start + 1;
+	tdx_nr_guest_keyids = nr_tdx_keyids - 1;
+
+	return 0;
+}
+early_initcall(tdx_init);
+
+/* Return whether the BIOS has enabled TDX */
+bool platform_tdx_enabled(void)
+{
+	return !!tdx_global_keyid;
+}
-- 
2.41.0



Return-Path: <kvm+bounces-4668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEF081670C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 558D11F214C2
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713B179FD;
	Mon, 18 Dec 2023 07:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EbYIwwgQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC779D2
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883412; x=1734419412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R54LxMsKB+OEBZzKzomutHM7mihyKcx+lbYDJJqKEr8=;
  b=EbYIwwgQHj45CFd4sW/2puM+HSw99N2p9pZPnxPcu4CwV41NhfReOHH9
   +TMkXiOQn6gwQsEIorVgibKKGIpRHGg/teWfAbsJ7VI+tf99Vryqn0zXF
   b3dUDaw7p1D/Pvs9XXT2376yrnTPaX9KVE4EI6krM9nVld9DUbLKydr84
   63mzpqkjZHu+RLupI98lkYNlZBFMittv18571b5bHC5qdTNSkbWNQ9X3T
   I+FRLiWlb0vHIJame9iEtIGJknkxKBXuM0UBR9o1zx5rvaqD7HksRF7YO
   UJav3oPAk5CqoaQXRLAmSRrNVSxZWasVLONSiWurSjiY1sl6dvjfcq3vF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667821"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667821"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824644"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824644"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:08 -0800
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
Subject: [kvm-unit-tests RFC v2 02/18] x86 TDX: Add support functions for TDX framework
Date: Mon, 18 Dec 2023 15:22:31 +0800
Message-Id: <20231218072247.2573516-3-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Detect TDX during at start of efi setup. And define a dummy is_tdx_guest()
if CONFIG_EFI is undefined as this function will be used globally in the
future.

In addition, it is fine to use the print function even before the #VE
handler of the unit test has complete configuration.

TDVF provides the default #VE exception handler, which will convert some
of the forbidden instructions to TDCALL [TDG.VP.VMCALL] <INSTRUCTION>,
e.g., IO => TDCALL [TDG.VP.VMCALL] <Instruction.IO> (see “10 Exception
Handling” in TDVF spec [1]).

[1] TDVF spec: https://cdrdv2.intel.com/v1/dl/getContent/733585

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-2-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/asm/setup.h |  1 +
 lib/x86/setup.c     |  6 ++++++
 lib/x86/tdx.c       | 39 +++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h       |  9 +++++++++
 4 files changed, 55 insertions(+)

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 458eac85..1deed1cd 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -15,6 +15,7 @@ unsigned long setup_tss(u8 *stacktop);
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
 #endif /* CONFIG_EFI */
+#include "x86/tdx.h"
 
 void save_id(void);
 void bsp_rest_init(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d509a248..97d9e896 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -308,6 +308,12 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	efi_status_t status;
 	const char *phase;
 
+	status = setup_tdx();
+	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
+		printf("INTEL TDX setup failed, error = 0x%lx\n", status);
+		return status;
+	}
+
 	status = setup_memory_allocator(efi_bootinfo);
 	if (status != EFI_SUCCESS) {
 		printf("Failed to set up memory allocator: ");
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 1f1abeff..a01bfcbb 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -276,3 +276,42 @@ static int handle_io(struct ex_regs *regs, struct ve_info *ve)
 
 	return ve_instr_len(ve);
 }
+
+bool is_tdx_guest(void)
+{
+	static int tdx_guest = -1;
+	struct cpuid c;
+	u32 sig[3];
+
+	if (tdx_guest >= 0)
+		goto done;
+
+	if (cpuid(0).a < TDX_CPUID_LEAF_ID) {
+		tdx_guest = 0;
+		goto done;
+	}
+
+	c = cpuid(TDX_CPUID_LEAF_ID);
+	sig[0] = c.b;
+	sig[1] = c.d;
+	sig[2] = c.c;
+
+	tdx_guest = !memcmp(TDX_IDENT, sig, sizeof(sig));
+
+done:
+	return !!tdx_guest;
+}
+
+efi_status_t setup_tdx(void)
+{
+	if (!is_tdx_guest())
+		return EFI_UNSUPPORTED;
+
+	/* The printf can work here. Since TDVF default exception handler
+	 * can handle the #VE caused by IO read/write during printf() before
+	 * finalizing configuration of the unit test's #VE handler.
+	 */
+	printf("Initialized TDX.\n");
+
+	return EFI_SUCCESS;
+}
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index cf0fc917..45350b70 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -21,6 +21,9 @@
 
 #define TDX_HYPERCALL_STANDARD		0
 
+#define TDX_CPUID_LEAF_ID	0x21
+#define TDX_IDENT		"IntelTDX    "
+
 /* TDX module Call Leaf IDs */
 #define TDG_VP_VMCALL			0
 
@@ -136,6 +139,12 @@ struct ve_info {
 	u32 instr_info;
 };
 
+bool is_tdx_guest(void);
+efi_status_t setup_tdx(void);
+
+#else
+inline bool is_tdx_guest(void) { return false; }
+
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_TDX_H */
-- 
2.25.1



Return-Path: <kvm+bounces-54520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D355B226CE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 14:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74947623D6B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744C4242D74;
	Tue, 12 Aug 2025 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRpJIciM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D722069F;
	Tue, 12 Aug 2025 12:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755001776; cv=none; b=K/fC9XnILa6clImqYvSoDQ5cJhbLrYb/FDyLJb5S+CnakHUKu9e26ZtOTrEP1liaYAXLIvn5/1MSnvafJ5Rq5RP/PP3ld1ob+Og6lRYs6Lpoz+WPsx5xP+hNfJ1jA8jeMrYj+3AiHKYj8BdOR3ymgCAre4pnlGMg5yr1q/Vq7yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755001776; c=relaxed/simple;
	bh=4nZspt6FQtmPeOr0pILI5mDZRC1ewkBGJrubtoDgCuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXFdZMf+ezwam+mqZ1itZb7H8fFVcu43H+JLsy6/R9n2z60TyNmTNbtR0VpG2XdHjW1qGzFEzcJnX1CANzXQOE79jcv+2VnoNcUE+zpsYz5iNJvSMJOexCWSJsXw1NRzgEoM2+pGjJhcx6iig1M+qTwUVw0ujF/AVuAmCD2qbtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lRpJIciM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755001775; x=1786537775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4nZspt6FQtmPeOr0pILI5mDZRC1ewkBGJrubtoDgCuE=;
  b=lRpJIciMkotcoOepDIaRPxRepbQvRFA69LYyMWdhKxHXZXCrvFOsG6Ud
   ZVIubnT6Ay6ZBEAdrafvmsKw/0JvyXmuIIbPaS5epW4hgFJCGyHiRJNxX
   MZc8sqX14e0YGjthn8bk6Z6UcLIV3juLMTgicCpMPYgOFIOSKRGyRV57P
   mIIxRddCnlmf8csjKQbE+UT5B4Uulr1hXAFmbxCY1NvWRBGyszwihFAtR
   4XJzk180GnepBL1HgeSFU7C69viV0hFUHxXGfugbzDmbMPcZksQRsV/f6
   fwTUJEyTVwq5Ywrs3eSN7iKJkhJc9eedUNevNx2fSwHo0thYnuPlso8a4
   w==;
X-CSE-ConnectionGUID: 6vIfpjn2SUCcFjxzFIWSSQ==
X-CSE-MsgGUID: Po7xv8LuRUyENKhBwnF80Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68648860"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="68648860"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 05:29:34 -0700
X-CSE-ConnectionGUID: dZ8itZ3HQDu6aAMfA0L/Aw==
X-CSE-MsgGUID: gxv7xIJuSu604uixNwit/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166548380"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 05:29:28 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 2/2] x86/mce: Remove MCI_ADDR_PHYSADDR
Date: Tue, 12 Aug 2025 15:28:59 +0300
Message-ID: <20250812122859.70911-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250812122859.70911-1-adrian.hunter@intel.com>
References: <20250812122859.70911-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Now that the address is masked when it is read from the machine check bank
address register (refer patch "x86/mce: Fix missing address mask in
recovery for errors in TDX/SEAM non-root mode"), the MCI_ADDR_PHYSADDR
macro is no longer needed.  Remove it.

Note MCE address information also enters the kernel from APEI via the
Common Platform Error Record (CPER) Memory Error Section "Physical Address"
field (struct cper_sec_mem_err physical_addr), refer the UEFI
specification.  It is assumed that field contains only the physical
address.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

      New patch


 arch/x86/include/asm/mce.h     | 3 ---
 arch/x86/kernel/cpu/mce/core.c | 6 +++---
 drivers/cxl/core/mce.c         | 2 +-
 drivers/edac/skx_common.c      | 2 +-
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6c77c03139f7..0cf8017dcae9 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -91,9 +91,6 @@
 #define  MCI_MISC_ADDR_MEM	3	/* memory address */
 #define  MCI_MISC_ADDR_GENERIC	7	/* generic */
 
-/* MCi_ADDR register defines */
-#define MCI_ADDR_PHYSADDR	GENMASK_ULL(boot_cpu_data.x86_phys_bits - 1, 0)
-
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		BIT_ULL(30)
 #define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index deb47463a75d..80e06d6728a7 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -642,7 +642,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 	    mce->severity != MCE_DEFERRED_SEVERITY)
 		return NOTIFY_DONE;
 
-	pfn = (mce->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = mce->addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0)) {
 		set_mce_nospec(pfn);
 		mce->kflags |= MCE_HANDLED_UC;
@@ -1415,7 +1415,7 @@ static void kill_me_maybe(struct callback_head *cb)
 	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
-	pfn = (p->mce_addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = p->mce_addr >> PAGE_SHIFT;
 	ret = memory_failure(pfn, flags);
 	if (!ret) {
 		set_mce_nospec(pfn);
@@ -1444,7 +1444,7 @@ static void kill_me_never(struct callback_head *cb)
 
 	p->mce_count = 0;
 	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
-	pfn = (p->mce_addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = p->mce_addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0))
 		set_mce_nospec(pfn);
 }
diff --git a/drivers/cxl/core/mce.c b/drivers/cxl/core/mce.c
index ff8d078c6ca1..4ba8b7ae3de7 100644
--- a/drivers/cxl/core/mce.c
+++ b/drivers/cxl/core/mce.c
@@ -24,7 +24,7 @@ static int cxl_handle_mce(struct notifier_block *nb, unsigned long val,
 	if (!endpoint)
 		return NOTIFY_DONE;
 
-	spa = mce->addr & MCI_ADDR_PHYSADDR;
+	spa = mce->addr;
 
 	pfn = spa >> PAGE_SHIFT;
 	if (!pfn_valid(pfn))
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 39c733dbc5b9..2de675958560 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -732,7 +732,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 
 	memset(&res, 0, sizeof(res));
 	res.mce  = mce;
-	res.addr = mce->addr & MCI_ADDR_PHYSADDR;
+	res.addr = mce->addr;
 	if (!pfn_to_online_page(res.addr >> PAGE_SHIFT) && !arch_is_platform_page(res.addr)) {
 		pr_err("Invalid address 0x%llx in IA32_MC%d_ADDR\n", mce->addr, mce->bank);
 		return NOTIFY_DONE;
-- 
2.48.1



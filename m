Return-Path: <kvm+bounces-31587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8859C4FD3
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6366B282BBC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E451121503F;
	Tue, 12 Nov 2024 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5noO6F9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDA720B7EB;
	Tue, 12 Nov 2024 07:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397303; cv=none; b=DWNbUK6yawuI99NbMHXzXFRfx72Mjl1KxVd0UUfQdKWhIH1BdZoZr8I683+whvZTaRRTay8BGfMqykM4VJxeQxlbrem1NZu9tLaUvylHhcWJArw0JtMtC8g+WtIpde1X1unYFH+1FX3ciJn/INI7ZqOO4NmfL+7P8FQd9R28yog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397303; c=relaxed/simple;
	bh=hSJ6BEYyUGCyEcY/U+BKLm7dTIH/L848thDKTcyA8Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJOlWINLMeioc5xzZiOmM8efxm5gdlssw2jvNWiG0aGpvbc9qOdT3LXok7+hWIeR7fFVGJKn+4wP/vbfFabicIkHcEtsGbHT4fNihKaRAhI+Qj0ZzsVT1b01QadO0ksHMuUbnKdmQsZO/6xL+twPN0zfop5Dphd+jd+/PyYzD+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5noO6F9; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397301; x=1762933301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hSJ6BEYyUGCyEcY/U+BKLm7dTIH/L848thDKTcyA8Xg=;
  b=d5noO6F9wG/YrECAoUAXCtQOrZzmEbAr6uRYhkdn1nsZI61iDNNHaE6g
   jXoK+QTmFhN6SxpuO2QreDZwf3H5qo6Vv7JsWl16W63UIDnTIHesHVARE
   HrfHqbAqRQJnWpSFj+pLQ8AtmmPUQXelYQOG9F90dSnFQw7SdgS8biy6M
   gV/WqCdm4/TyAFeyEBgNbgJo0L2EBmozzyc5yvzi663fiN/DJ6GRX7Q5l
   j6wG/pbvsc+WAmUqlsCI0I83uKCXQb3C5yEfjUrtBO12p2jkj2BgbGlqC
   gpKF1qcKI1EpJvw+b74eXjCMcSptGpTFrH9+4tttKkoX+vS0EFUXUUCso
   g==;
X-CSE-ConnectionGUID: xPd20s7eSzGx+WfioRESqA==
X-CSE-MsgGUID: qG7rL3TBR9aQ73gZXpFosA==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090942"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090942"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:41 -0800
X-CSE-ConnectionGUID: TtLWdoWQQdmpQSpiSx+ODg==
X-CSE-MsgGUID: v5QTDcqTQfyb5cCPTOPVZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92089776"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:37 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 24/24] [HACK] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date: Tue, 12 Nov 2024 15:39:09 +0800
Message-ID: <20241112073909.22326-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yuan Yao <yuan.yao@intel.com>

Temporary retry in SEAMCALL wrappers when the TDX module returns
TDX_OPERAND_BUSY with operand SEPT.

The TDX module has many internal locks to protect its resources. To avoid
staying in SEAM mode for too long, SEAMCALLs will return a TDX_OPERAND_BUSY
error code to the kernel instead of spinning on the locks.

Usually, callers of the SEAMCALL wrappers can avoid contentions by
implementing proper locks on their side. For example, KVM can efficiently
avoid the TDX module's lock contentions for resources like TDR, TDCS, KOT,
and TDVPR by taking locks within KVM or making a resource per-thread.

However, for performance reasons, callers like KVM may not want to use
exclusive locks to avoid internal contentions on the SEPT tree within the
TDX module. For instance, KVM allows TDH.VP.ENTER to run concurrently with
TDH.MEM.SEPT.ADD, TDH.MEM.PAGE.AUG, and TDH.MEM.PAGE.REMOVE.

Resources       SHARED users               EXCLUSIVE users
------------------------------------------------------------------------
SEPT tree       TDH.MEM.SEPT.ADD           TDH.VP.ENTER
                TDH.MEM.PAGE.AUG           TDH.MEM.SEPT.REMOVE
                TDH.MEM.PAGE.REMOVE        TDH.MEM.RANGE.BLOCK

Inside the TDX module, although TDH.VP.ENTER only acquires an exclusive
lock on the SEPT tree when zero-step mitigation is triggered, it is still
possible to encounter TDX_OPERAND_BUSY with operand SEPT in KVM. Retry in
the SEAMCALL wrappers temporarily until KVM either retries on the caller
side or finds a way to avoid the contentions.

Note:
The wrappers only retry for 16 times for the TDX_OPERAND_BUSY with operand
SEPT. Retries exceeding 16 times are rare.
SEAMCALLs TDH.MEM.* can also contend with TDCALL TDG.MEM.PAGE.ACCEPT,
returning TDX_OPERAND_BUSY without operand SEPT. Do not retry in the
SEAMCALL wrappers for such rare errors.
Let the callers handle these rare errors.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - Updates the patch log. (Yan)

TDX MMU part 2 v1:
 - Updates from seamcall overhaul (Kai)

v19:
 - fix typo TDG.VP.ENTER => TDH.VP.ENTER,
   TDX_OPRRAN_BUSY => TDX_OPERAND_BUSY
 - drop the description on TDH.VP.ENTER as this patch doesn't touch
   TDH.VP.ENTER
---
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7e0574facfb0..04cb2f1d6deb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1563,6 +1563,43 @@ void tdx_guest_keyid_free(unsigned int keyid)
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
+/*
+ * TDX module acquires its internal lock for resources.  It doesn't spin to get
+ * locks because of its restrictions of allowed execution time.  Instead, it
+ * returns TDX_OPERAND_BUSY with an operand id.
+ *
+ * Multiple VCPUs can operate on SEPT.  Also with zero-step attack mitigation,
+ * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
+ * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
+ * with TDH.MEM.* operation.  Note: TDH.MEM.TRACK is an exception.
+ *
+ * Because TDP MMU uses read lock for scalability, spin lock around SEAMCALL
+ * spoils TDP MMU effort.  Retry several times with the assumption that SEPT
+ * lock contention is rare.  But don't loop forever to avoid lockup.  Let TDP
+ * MMU retry.
+ */
+#define TDX_OPERAND_BUSY			0x8000020000000000ULL
+#define TDX_OPERAND_ID_SEPT			0x92
+
+#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
+
+static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
+{
+#define SEAMCALL_RETRY_MAX     16
+	struct tdx_module_args args_in;
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		args_in = *in;
+		ret = seamcall_ret(op, in);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+
+	*in = args_in;
+
+	return ret;
+}
+
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
 {
 	struct tdx_module_args args = {
@@ -1586,7 +1623,7 @@ u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx)
 	u64 ret;
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &args);
 
 	*rcx = args.rcx;
 	*rdx = args.rdx;
@@ -1605,7 +1642,7 @@ u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
 	u64 ret;
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);
+	ret = tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &args);
 
 	*rcx = args.rcx;
 	*rdx = args.rdx;
@@ -1636,7 +1673,7 @@ u64 tdh_mem_page_aug(u64 tdr, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
 	u64 ret;
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &args);
 
 	*rcx = args.rcx;
 	*rdx = args.rdx;
@@ -1653,7 +1690,7 @@ u64 tdh_mem_range_block(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &args);
+	ret = tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &args);
 
 	*rcx = args.rcx;
 	*rdx = args.rdx;
@@ -1882,7 +1919,7 @@ u64 tdh_mem_page_remove(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &args);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &args);
 
 	*rcx = args.rcx;
 	*rdx = args.rdx;
-- 
2.43.2



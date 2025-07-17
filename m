Return-Path: <kvm+bounces-52801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 285A6B0967E
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1000166D7D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9029424169A;
	Thu, 17 Jul 2025 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GcTbqSgt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE382376F7;
	Thu, 17 Jul 2025 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788849; cv=none; b=mLZ8XwCBT4e6geHdCMHGfhOlNKTrhJZ6K/iWpudTAuYBbTDEHS2+OnZYhdq87NMvuHP/hMhqn5mQnh2WT+MtojwFMQnOr/Q+EETKvA+j88vdOJn3Yx30rGKQvd6Aj0BTgS6pMzmaWMgYT+fhio9HUVMvaj/liUxIrwyp4sfXVR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788849; c=relaxed/simple;
	bh=+PwtPim6EcQu6LdZI9yxX3QTrbnlCb887UVhj7KOKfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdUfLajc0W72F//94BmY8mhpW5AziAf7tD3JH3+wleQNFPqSDxgMh4hU0OsB2NlcDnCzxTLN21otqKedivrOFPP4/2T/JxlwgOCRBejY+GexmUpNNudbb+xfCEBd1eM5N87uHKOtUBTiiQCAQCHhNGh30B29L3McHl0t+e1v2Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GcTbqSgt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752788848; x=1784324848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+PwtPim6EcQu6LdZI9yxX3QTrbnlCb887UVhj7KOKfM=;
  b=GcTbqSgtVQdxjQpKv+B4hqmwRUfo4DAn5ejVS+KOhB04VCaVprT7pZ/e
   Miud9d6yxPcoCW8DVL/hCdrLjIJ8qmYxWF/WV2SmPiigrCTRGrsGn0Nao
   c4h5CDLhqruqvbjgYzC+Jo1LGlbcsMTHz5ipDVQHTnDgXHkxHIy/PFvy6
   gbDmEgeOcYWJoLC8uzzm7Gwi/E7a3237t5dU3r6u5FfBqAUfx48DDONd1
   rdVulz8N21If3XnaA5fZ5PjIwyZMRrDBqlsHIRtAltaWC0QNuglNbVv+C
   KJOtAlb5Vb93VCOkKlSS96ymb/1pZCnvRGFQISr3ou24e5EfWrbCzMO8j
   g==;
X-CSE-ConnectionGUID: 9E8K4wORQ9WRd/XXZS+hSw==
X-CSE-MsgGUID: yI+tAVExTxiyBKExyYouJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66527774"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66527774"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:28 -0700
X-CSE-ConnectionGUID: Lyq2GhnyRvWB4pwOYjJVlg==
X-CSE-MsgGUID: lJCRZYkjTCWr/BIUfnhJdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="157295527"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:22 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v4 3/7] x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
Date: Fri, 18 Jul 2025 09:46:40 +1200
Message-ID: <ac704fa28a814b8ef5cca14296045c14b1fdd5d5.1752730040.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752730040.git.kai.huang@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On TDX platforms, dirty cacheline aliases with and without encryption
bits can coexist, and the cpu can flush them back to memory in random
order.  During kexec, the caches must be flushed before jumping to the
new kernel otherwise the dirty cachelines could silently corrupt the
memory used by the new kernel due to different encryption property.

A percpu boolean is used to mark whether the cache of a given CPU may be
in an incoherent state, and the kexec performs WBINVD on the CPUs with
that boolean turned on.

For TDX, only the TDX module or the TDX guests can generate dirty
cachelines of TDX private memory, i.e., they are only generated when the
kernel does a SEAMCALL.

Set that boolean when the kernel does SEAMCALL so that kexec can flush
the cache correctly.

The kernel provides both the __seamcall*() assembly functions and the
seamcall*() wrapper ones which additionally handle running out of
entropy error in a loop.  Most of the SEAMCALLs are called using the
seamcall*(), except TDH.VP.ENTER and TDH.PHYMEM.PAGE.RDMD which are
called using __seamcall*() variant directly.

To cover the two special cases, add a new helper do_seamcall() which
only sets the percpu boolean and then calls the __seamcall*(), and
change the special cases to use do_seamcall().  To cover all other
SEAMCALLs, change seamcall*() to call do_seamcall().

For the SEAMCALLs invoked via seamcall*(), they can be made from both
task context and IRQ disabled context.  Given SEAMCALL is just a lengthy
instruction (e.g., thousands of cycles) from kernel's point of view and
preempt_{disable|enable}() is cheap compared to it, just unconditionally
disable preemption during setting the boolean and making SEAMCALL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---

v3 -> v4:
 - Set the boolean for TDH.VP.ENTER and TDH.PHYMEM.PAGE.RDMD. -Rick
 - Update the first paragraph to make it shorter -- Rick
 - Update changelog to mention the two special cases.

---
 arch/x86/include/asm/tdx.h  | 29 ++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c |  4 ++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..6865f62436ad 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,10 +102,35 @@ u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 void tdx_init(void);
 
+#include <linux/preempt.h>
 #include <asm/archrandom.h>
+#include <asm/processor.h>
 
 typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
 
+static __always_inline u64 do_seamcall(sc_func_t func, u64 fn,
+				       struct tdx_module_args *args)
+{
+	u64 ret;
+
+	lockdep_assert_preemption_disabled();
+
+	/*
+	 * SEAMCALLs are made to the TDX module and can generate dirty
+	 * cachelines of TDX private memory.  Mark cache state incoherent
+	 * so that the cache can be flushed during kexec.
+	 *
+	 * This needs to be done before actually making the SEAMCALL,
+	 * because kexec-ing CPU could send NMI to stop remote CPUs,
+	 * in which case even disabling IRQ won't help here.
+	 */
+	this_cpu_write(cache_state_incoherent, true);
+
+	ret = func(fn, args);
+
+	return ret;
+}
+
 static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
@@ -113,7 +138,9 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 	u64 ret;
 
 	do {
-		ret = func(fn, args);
+		preempt_disable();
+		ret = do_seamcall(func, fn, args);
+		preempt_enable();
 	} while (ret == TDX_RND_NO_ENTROPY && --retry);
 
 	return ret;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..d6ee4e5a75d2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1266,7 +1266,7 @@ static bool paddr_is_tdx_private(unsigned long phys)
 		return false;
 
 	/* Get page type from the TDX module */
-	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
+	sret = do_seamcall(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD, &args);
 
 	/*
 	 * The SEAMCALL will not return success unless there is a
@@ -1522,7 +1522,7 @@ noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *ar
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+	return do_seamcall(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_enter);
 
-- 
2.50.0



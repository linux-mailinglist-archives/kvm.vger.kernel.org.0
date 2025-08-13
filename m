Return-Path: <kvm+bounces-54622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26202B257F9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 567439A824E
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20851311C23;
	Wed, 13 Aug 2025 23:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O6XYL/m8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343030E843;
	Wed, 13 Aug 2025 23:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129582; cv=none; b=YChiXisrY6wr5iy82ujk4EXCF6J1qfODffrct9lwaZIlqDKTZ74UFAaMnjos23QOqdnFs2W5fQs/yXEStK9BXkI6IVGe1maCxBqyghRjG4535nx2oLlOAAlXMz/RVCbt0KxlVg0ac+MDfb71yEiBAIbO/bpR1oEmwmefGk1te7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129582; c=relaxed/simple;
	bh=lUqC8zojlWU4IFgAKylmtSUAEphxDB3Fvu0nMQcZYzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqTLGlzyWGtVQevtgTepShgrPZ2i6+e1erjMRfiuzeUcRnsYzAhiopR8GUhp3RVrzvIMTWdOip6d9gwGec8gWTKyAWhADowdrBN5mpjJPxeWvtvX1si1r8hh51iBNOakiduycWg48Z9lKgPzfQ47khfXTcHIXgJ7sTmanhUDNZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O6XYL/m8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129580; x=1786665580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lUqC8zojlWU4IFgAKylmtSUAEphxDB3Fvu0nMQcZYzc=;
  b=O6XYL/m87U6vVwagSZIMA+joB3lnHq2R0onJwfAvR7axTNI6lTstdOlC
   vWqb6c7Wf5MfG719qMLDWpqZwgLpYco1FMGh+KR+h88cJ8X3E5dlsUaXA
   mun6V1FLr0RRp4dIPqCSS85LVroSC4TPtzIZLCMR2YQEzRxdzIFSHpHyA
   DO4i4xtG5JLDNpW0zBsSfTC+H8TM5IkOnFq0rjAMIqyuUu4ZVJ/GfqXCA
   QdQd7zjUkxHnpng/nkpHT530vHPe6OB5bK2wToLdX53923c0PYRs9H60d
   Zx5B6hapevr1qe4JJHAlL3ggla9KpBZx1Znr+8wpxu5h/YvfwdrBDMDtk
   Q==;
X-CSE-ConnectionGUID: oCiPNEkrTuuwG2mIvHBvjg==
X-CSE-MsgGUID: wicG4GnfTzuIarhnXz53Qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014682"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014682"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:40 -0700
X-CSE-ConnectionGUID: KaUgeCNjShycIhY7m9ZPNw==
X-CSE-MsgGUID: 1+MOUIA2QhyyLmpDm75eDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105085"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:35 -0700
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
	farrah.chen@intel.com
Subject: [PATCH v6 3/7] x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
Date: Thu, 14 Aug 2025 11:59:03 +1200
Message-ID: <9b1fc0cf2f7b4df5bca77affbf770664d9c5e251.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755126788.git.kai.huang@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
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

To cover the two special cases, add a new __seamcall_dirty_cache()
helper which only sets the percpu boolean and calls the __seamcall*(),
and change the special cases to use the new helper.  To cover all other
SEAMCALLs, change seamcall*() to call the new helper.

For the SEAMCALLs invoked via seamcall*(), they can be made from both
task context and IRQ disabled context.  Given SEAMCALL is just a lengthy
instruction (e.g., thousands of cycles) from kernel's point of view and
preempt_{disable|enable}() is cheap compared to it, just unconditionally
disable preemption during setting the boolean and making SEAMCALL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---

v5 -> v6:
 - Rename do_seamcall() to __seamcall_dirty_cache() - Rick.
 - Add Rick and Chao's RB.

v4 -> v5:
 - Remove unneeded 'ret' local variable in do_seamcall() - Chao.

v3 -> v4:
 - Set the boolean for TDH.VP.ENTER and TDH.PHYMEM.PAGE.RDMD. -Rick
 - Update the first paragraph to make it shorter -- Rick
 - Update changelog to mention the two special cases.


---
 arch/x86/include/asm/tdx.h  | 25 ++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c |  4 ++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..0922265c6bdc 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,10 +102,31 @@ u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 void tdx_init(void);
 
+#include <linux/preempt.h>
 #include <asm/archrandom.h>
+#include <asm/processor.h>
 
 typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
 
+static __always_inline u64 __seamcall_dirty_cache(sc_func_t func, u64 fn,
+						  struct tdx_module_args *args)
+{
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
+	return func(fn, args);
+}
+
 static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
@@ -113,7 +134,9 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 	u64 ret;
 
 	do {
-		ret = func(fn, args);
+		preempt_disable();
+		ret = __seamcall_dirty_cache(func, fn, args);
+		preempt_enable();
 	} while (ret == TDX_RND_NO_ENTROPY && --retry);
 
 	return ret;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..3ea6f587c81a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1266,7 +1266,7 @@ static bool paddr_is_tdx_private(unsigned long phys)
 		return false;
 
 	/* Get page type from the TDX module */
-	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
+	sret = __seamcall_dirty_cache(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD, &args);
 
 	/*
 	 * The SEAMCALL will not return success unless there is a
@@ -1522,7 +1522,7 @@ noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *ar
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_enter);
 
-- 
2.50.1



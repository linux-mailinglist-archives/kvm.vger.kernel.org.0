Return-Path: <kvm+bounces-50822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90239AE9BCC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F5EB1C42251
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BEC25A2A4;
	Thu, 26 Jun 2025 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiZSVILG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9471264A9D;
	Thu, 26 Jun 2025 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934977; cv=none; b=iUUf+eY06osVqqnlFXnvgt5KLt1TaplKZkWOPBNeXM5XC6/1x1O/TW9g5v2kTIH+pg6bpiwefFjId2x4/bYXg8AVAIxooxh2qKT9RINzmI8f85kj+bLoYVP7/mceM8pXtxV0/QMFxyrKiyGzyn7AhwxW88CebGKCkxkzkDTpBnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934977; c=relaxed/simple;
	bh=+HXLQAJX9DTjZknajjUDMLpMXRCl1eOZ8k2i7r/I67w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUSUKgymsJkWQL0pGMaj6a/OWR1VIm4Hs7ErdeKfVHhoj4HcF/8zcNV6/jZzkyeKFRSSxmNabHDQaxdPXDqrHFtwcdk7LOb4cYKMeC+om/iyHCSyUK5Qdvij3EH8LJbtdN9xUS9xeqt0ELSjLdQaL1RiEJUznRLM/r9EA3vvplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiZSVILG; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934976; x=1782470976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+HXLQAJX9DTjZknajjUDMLpMXRCl1eOZ8k2i7r/I67w=;
  b=TiZSVILGkTGQqv/yQ3Xi2q0idZRfyUFXjAJQa+YQnNkLuYePhGxnMhff
   QPBxCd3Lmo5lRvqu/bDYt3gjcFnpPfYiDOwx4zeburVNzvvwh0UJeMAMY
   5EL8roYK/4Qn53/ph3l9VEb674HWy+EJnRh/OM8NigHVpICXHx6JXaAFG
   Hf2UeZAcF8LbD4b1gRpZ0rnZJWtgDoKjcWIf08nnjrGDiql/r3jEqFBCl
   SycM9DsWEYQAfZwpaoyV3TsBgjuSd/ljGRwlkdWA8/3ei1NIrk+zGy9sH
   SDfO+ZJXcw7WoxK/UeMTQx0WdbJOG0f82nfzlD4mOmQRzAdTwMMPdKFQz
   g==;
X-CSE-ConnectionGUID: sSaYbx/dTMe1Re+Yb5Sdgg==
X-CSE-MsgGUID: 2NPFicVqS8KvAzkFYxTntA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655778"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655778"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:36 -0700
X-CSE-ConnectionGUID: 87d83ssURb6c9K/6a/AB/A==
X-CSE-MsgGUID: sbOihw75RpONzoRTwFJD1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784322"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:30 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
Date: Thu, 26 Jun 2025 22:48:48 +1200
Message-ID: <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750934177.git.kai.huang@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On TDX platforms, at hardware level dirty cachelines with and without
TDX keyID can coexist, and CPU can flush them back to memory in random
order.  During kexec, the caches must be flushed before jumping to the
new kernel to avoid silent memory corruption when a cacheline with a
different encryption property is written back over whatever encryption
properties the new kernel is using.

A percpu boolean is used to mark whether the cache of a given CPU may be
in an incoherent state, and the kexec performs WBINVD on the CPUs with
that boolean turned on.

For TDX, only the TDX module or the TDX guests can generate dirty
cachelines of TDX private memory, i.e., they are only generated when the
kernel does SEAMCALL.

Turn on that boolean when the kernel does SEAMCALL so that kexec can
correctly flush cache.

SEAMCALL can be made from both task context and IRQ disabled context.
Given SEAMCALL is just a lengthy instruction (e.g., thousands of cycles)
from kernel's point of view and preempt_{disable|enable}() is cheap
compared to it, simply unconditionally disable preemption during setting
the percpu boolean and making SEAMCALL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---

v2 -> v3:
 - Change to use __always_inline for do_seamcall() to avoid indirect
   call instructions of making SEAMCALL.
 - Remove the senstence "not all SEAMCALLs generate dirty cachelines of
   TDX private memory but just treat all of them do." in changelog and
   the code comment. -- Dave

---
 arch/x86/include/asm/tdx.h | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..d4c624c69d7f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,10 +102,37 @@ u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
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
+	preempt_disable();
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
+	preempt_enable();
+
+	return ret;
+}
+
 static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
@@ -113,7 +140,7 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 	u64 ret;
 
 	do {
-		ret = func(fn, args);
+		ret = do_seamcall(func, fn, args);
 	} while (ret == TDX_RND_NO_ENTROPY && --retry);
 
 	return ret;
-- 
2.49.0



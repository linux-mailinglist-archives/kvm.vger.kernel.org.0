Return-Path: <kvm+bounces-1336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8967E6A19
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC7E62815DA
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245771DA35;
	Thu,  9 Nov 2023 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MYBcAylT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799EC1DA20
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:58:03 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A20A3854;
	Thu,  9 Nov 2023 03:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531083; x=1731067083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uzvyFdcU84vjTdasbf3z2K55iYAdyq4I6rEJQets2zI=;
  b=MYBcAylTQAva2hbsHrJzycJfUe6PbeKbkz5glJ54jsxRsnRv2oF2LJVR
   LrXiOn+j4Kiod9YF7Ek3kAoksO0IoEvEevOr4XXC2OAeXo3texfg1sNgp
   G73gtJIalYChHQlSxMoxddV/dvk5nJ23mETeljFxrh19fIgT5VahEBxMF
   DQgunbPCVncNOw36FcwjtuWLmeR3QFTkw6l78xq7YeZUdztIv4Tlx8nsf
   f3ix84B4QG15u2zMzR0ZU6UfV7Z//cXHbn951htxhv4cT7H9rnc6grWFK
   f3kRyYTdUoEDWD+AztA/cKR9uuMW9X+pZMTLw9f5lMoNZ4BbCifAQaPla
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936695"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936695"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976839"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976839"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:56 -0800
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
Subject: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Date: Fri, 10 Nov 2023 00:55:54 +1300
Message-ID: <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
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

There are two problems in terms of using kexec() to boot to a new kernel
when the old kernel has enabled TDX: 1) Part of the memory pages are
still TDX private pages; 2) There might be dirty cachelines associated
with TDX private pages.

The first problem doesn't matter on the platforms w/o the "partial write
machine check" erratum.  KeyID 0 doesn't have integrity check.  If the
new kernel wants to use any non-zero KeyID, it needs to convert the
memory to that KeyID and such conversion would work from any KeyID.

However the old kernel needs to guarantee there's no dirty cacheline
left behind before booting to the new kernel to avoid silent corruption
from later cacheline writeback (Intel hardware doesn't guarantee cache
coherency across different KeyIDs).

There are two things that the old kernel needs to do to achieve that:

1) Stop accessing TDX private memory mappings:
   a. Stop making TDX module SEAMCALLs (TDX global KeyID);
   b. Stop TDX guests from running (per-guest TDX KeyID).
2) Flush any cachelines from previous TDX private KeyID writes.

For 2), use wbinvd() to flush cache in stop_this_cpu(), following SME
support.  And in this way 1) happens for free as there's no TDX activity
between wbinvd() and the native_halt().

Flushing cache in stop_this_cpu() only flushes cache on remote cpus.  On
the rebooting cpu which does kexec(), unlike SME which does the cache
flush in relocate_kernel(), flush the cache right after stopping remote
cpus in machine_shutdown().

There are two reasons to do so: 1) For TDX there's no need to defer
cache flush to relocate_kernel() because all TDX activities have been
stopped.  2) On the platforms with the above erratum the kernel must
convert all TDX private pages back to normal before booting to the new
kernel in kexec(), and flushing cache early allows the kernel to convert
memory early rather than having to muck with the relocate_kernel()
assembly.

Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by the BIOS instead to flush cache.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v14 -> v15:
 - No change

v13 -> v14:
 - No change


---
 arch/x86/kernel/process.c |  8 +++++++-
 arch/x86/kernel/reboot.c  | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b6f4e8399fca..8e3cf0f8d7f9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -823,8 +823,14 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * The TDX module or guests might have left dirty cachelines
+	 * behind.  Flush them to avoid corruption from later writeback.
+	 * Note that this flushes on all systems where TDX is possible,
+	 * but does not actually check that TDX was in use.
 	 */
-	if (c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+	if ((c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+			|| platform_tdx_enabled())
 		native_wbinvd();
 
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 830425e6d38e..e1a4fa8de11d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -31,6 +31,7 @@
 #include <asm/realmode.h>
 #include <asm/x86_init.h>
 #include <asm/efi.h>
+#include <asm/tdx.h>
 
 /*
  * Power off function, if any
@@ -741,6 +742,20 @@ void native_machine_shutdown(void)
 	local_irq_disable();
 	stop_other_cpus();
 #endif
+	/*
+	 * stop_other_cpus() has flushed all dirty cachelines of TDX
+	 * private memory on remote cpus.  Unlike SME, which does the
+	 * cache flush on _this_ cpu in the relocate_kernel(), flush
+	 * the cache for _this_ cpu here.  This is because on the
+	 * platforms with "partial write machine check" erratum the
+	 * kernel needs to convert all TDX private pages back to normal
+	 * before booting to the new kernel in kexec(), and the cache
+	 * flush must be done before that.  If the kernel took SME's way,
+	 * it would have to muck with the relocate_kernel() assembly to
+	 * do memory conversion.
+	 */
+	if (platform_tdx_enabled())
+		native_wbinvd();
 
 	lapic_shutdown();
 	restore_boot_irq_mode();
-- 
2.41.0



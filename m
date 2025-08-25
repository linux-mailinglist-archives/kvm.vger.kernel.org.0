Return-Path: <kvm+bounces-55706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DE5B34F78
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 01:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C29872A6BA2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7371D2D46AF;
	Mon, 25 Aug 2025 22:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jvXQ4Vta"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD52C0F78;
	Mon, 25 Aug 2025 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162780; cv=none; b=nl7udKY4Z9K1+FlDiTOk4hBMoBcdGjZIZQaYBlqp8S1Dqef1aNNk0K5065rdF3Sne7DUlk3ZktMnpZ7Zq6blkOq5nZ6a65iYFerz6+WznmK754tA8ejaV8JJHaZPvR8y9zsIeYcvCN1N4vNpnVPygriOa6ZAsDvLtfh7G3P9juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162780; c=relaxed/simple;
	bh=Vwviwn3ZG+UNUDH9BSmq4tg9aRmCxgkbakEMYRulqjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oze427zz0q/e8zach4gISXb5WbAmOGonJ0RQrEWLXDFWJPTCQbmmyV43YmEhDCCLHOIWI5N+Cx4fqJL2zgGcw0BIu/K8r2td1ILGbrh0N1oLbynXcOcfDh4I48bm6MiYHoBon3v161p8LZ48tx5U/4Lp+veO59YORg7o6OEKdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jvXQ4Vta; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756162779; x=1787698779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vwviwn3ZG+UNUDH9BSmq4tg9aRmCxgkbakEMYRulqjA=;
  b=jvXQ4VtaT+0ne2RVDLL8hsN8UzUeg7D9gCK9PYhZSD0XbzBW53A95Xv/
   9sj23sFV11lv0M7WUy3awhruWK/j9lCM0FEWhWCeqmMesGriq5UAK85my
   fnha/+CENnGUGwqlJNcvXGhQGWlD5JMxWUGhI2YGF17h3w8bsFP9q/v7g
   iA9GJkW4/SJIz5BtOlD6X1so+ueRJBPqZ/8OK+R/XDwRd7PKsIrZmzEJa
   WRf2Qkjugpid+9lCffGl8sZ7ukGal/KYfwSfOGQyHXTzu3AM9B0TP+wYh
   iPMv9vTaeCyaS4XghekLOGMj9XWPkdiO9eUsEGGgI8JzhG4qCwvbmzTuf
   w==;
X-CSE-ConnectionGUID: DvK42V29TWOPrzSI6oAEAg==
X-CSE-MsgGUID: dy+Zxq+FQTqJHpKRPgGdWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58533433"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58533433"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:39 -0700
X-CSE-ConnectionGUID: nryLhhB5QIuUgmwqB+wK1A==
X-CSE-MsgGUID: YkoJN9z3RyK2HD5aYfaF2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200308475"
Received: from ldmartin-desk2.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.59])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:32 -0700
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
	farrah.chen@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v7 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
Date: Tue, 26 Aug 2025 10:58:42 +1200
Message-ID: <14f91fcb323fbd80158aadb4b9f240fad9f9487e.1756161460.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756161460.git.kai.huang@intel.com>
References: <cover.1756161460.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On TDX platforms, during kexec, the kernel needs to make sure there are
no dirty cachelines of TDX private memory before booting to the new
kernel to avoid silent memory corruption to the new kernel.

During kexec, the kexec-ing CPU firstly invokes native_stop_other_cpus()
to stop all remote CPUs before booting to the new kernel.  The remote
CPUs will then execute stop_this_cpu() to stop themselves.

The kernel has a percpu boolean to indicate whether the cache of a CPU
may be in incoherent state.  In stop_this_cpu(), the kernel does WBINVD
if that percpu boolean is true.

TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL.
This makes sure the caches will be flushed during kexec.

However, the native_stop_other_cpus() and stop_this_cpu() have a
"race"[1] which is extremely rare to happen but could cause the system
to hang.  Doing WBINVD in stop_this_cpu() could increase the chance of
the race happening.

Explicitly flush cache in tdx_disable_virtualization_cpu() after which
no more TDX activity can happen on this cpu.  This moves the WBINVD to
an earlier stage than stop_this_cpus(), avoiding a possibly lengthy
operation at a time where it could cause this race.

Link: https://lore.kernel.org/kvm/b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---

v6 -> v7:
 - Remove the tdx_cpu_flush_cache() stub.  -- Sean
 - Rename tdx_cpu_flush_cache() to tdx_cpu_flush_cache_for_kexec(). -- Paolo
 - Trim down changelog a little bit. -- Sean.

v5 -> v6:
 - Add Chao's RB.

v4 -> v5:
 - No change

v3 -> v4:
 - Change doing wbinvd() from rebooting notifier to
   tdx_disable_virtualization_cpu() to cover the case where more
   SEAMCALL can be made after cache flush, i.e., doing kexec when
   there's TD alive.  - Chao.
 - Add check to skip wbinvd if the boolean is false. -- Chao
 - Fix typo in the comment -- Binbin.


---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/kvm/vmx/tdx.c      | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c178360c1fb1..0b3555be1fa3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -219,6 +219,7 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+void tdx_cpu_flush_cache_for_kexec(void);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f457b2e578b2..e181e1e4b3cc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -423,6 +423,18 @@ void tdx_disable_virtualization_cpu(void)
 		tdx_flush_vp(&arg);
 	}
 	local_irq_restore(flags);
+
+	/*
+	 * No more TDX activity on this CPU from here.  Flush cache to
+	 * avoid having to do WBINVD in stop_this_cpu() during kexec.
+	 *
+	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
+	 * before booting to new kernel, but that code has a "race"
+	 * when the normal REBOOT IPI times out and NMIs are sent to
+	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
+	 * could potentially increase the possibility of the "race".
+	 */
+	tdx_cpu_flush_cache_for_kexec();
 }
 
 #define TDX_SEAMCALL_RETRIES 10000
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2abf53ed59c8..f8f74e213f0d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1872,3 +1872,15 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+void tdx_cpu_flush_cache_for_kexec(void)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (!this_cpu_read(cache_state_incoherent))
+		return;
+
+	wbinvd();
+	this_cpu_write(cache_state_incoherent, false);
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);
-- 
2.50.1



Return-Path: <kvm+bounces-50826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66786AE9BDF
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 915FC5A4205
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8345027280F;
	Thu, 26 Jun 2025 10:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HATVd+IQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285622727E3;
	Thu, 26 Jun 2025 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934997; cv=none; b=MLhXLIof4TIToyqeE8T8Zscmh4hPcDZAA9oaIVGk9LlbU4bLlA/BdIz2iUXCZizUncnU/vBtPoeBELP3QFcL8EyUfPYTjXIsO17Y7mtiVp/SjVshypSYpmz4NPp6n3F59uB5yUzijfswfBzIt9j4iDR9lJ5EMWW5yhrwBdLC2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934997; c=relaxed/simple;
	bh=av0qF2y3/F3Q6t4QKOydohkA/mWlyY9WC1aCIBFt4/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ9fKOsWRsLnmi1Wc6hvk3seaTSDJDhh3YuuqJslnosp4VnRgWsB4M/n7k3DSfa5Ek+BEevKowe92MYJ6MIwyARvD5ABYFCmXEML74ZnKMPAY+a2r6rWKV57rVfZCN4IEtrnl/jI2wEhZMHG4RTeGvCceg8i0oKXxBrEbBMlynk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HATVd+IQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934997; x=1782470997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=av0qF2y3/F3Q6t4QKOydohkA/mWlyY9WC1aCIBFt4/c=;
  b=HATVd+IQGzyL+0DM3vAoXwz+NMvkH1rLFkvV7ESw4l6LIC/MNmrxiOoe
   Q7V8QflgqvI0Aso8yelgh503zq5iAM2j0OUY+rDtS15nrsSmT2lL5rkvy
   C+VjWq3qiRAGkclIWIYPqRQM8BzitbRE1g0I9utgSVtAJuW3q/D2d5mOh
   wTg/LTP9RC2CGYNCGtCffJVh89QmwVPGDVEhEj88l6cimCVcNq6wBp5p1
   fS/l+exH+15BgdAL+Jd5/H55S9suyc4qDZ1Gl79sHYfU45CiQaQai53he
   9gu0FKORaMuACPT7cjx7FXhuhmnj/aRkpTzMv6WlLP2ieaR59MMNBryVR
   Q==;
X-CSE-ConnectionGUID: tSAE6eo+RomdjjRnpOZVkQ==
X-CSE-MsgGUID: TItKl8rXQCeALlgU2MJ/wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655837"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655837"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:56 -0700
X-CSE-ConnectionGUID: 2zxX7Yd4RbOxJDLLG/wM/g==
X-CSE-MsgGUID: 2/hAtZtYQrGCP1hjegGR8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784361"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:51 -0700
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
Subject: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot notifier
Date: Thu, 26 Jun 2025 22:48:52 +1200
Message-ID: <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
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

On TDX platforms, during kexec, the kernel needs to make sure there's no
dirty cachelines of TDX private memory before booting to the new kernel
to avoid silent memory corruption to the new kernel.

During kexec, the kexec-ing CPU firstly invokes native_stop_other_cpus()
to stop all remote CPUs before booting to the new kernel.  The remote
CPUs will then execute stop_this_cpu() to stop themselves.

The kernel has a percpu boolean to indicate whether the cache of a CPU
may be in incoherent state.  In stop_this_cpu(), the kernel does WBINVD
if that percpu boolean is true.

TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL.
This makes sure the caches will be flushed during kexec.

However, the native_stop_other_cpus() and stop_this_cpu() have a "race"
which is extremely rare to happen but could cause system to hang.

Specifically, the native_stop_other_cpus() firstly sends normal reboot
IPI to remote CPUs and wait one second for them to stop.  If that times
out, native_stop_other_cpus() then sends NMIs to remote CPUs to stop
them.

The aforementioned race happens when NMIs are sent.  Doing WBINVD in
stop_this_cpu() makes each CPU take longer time to stop and increases
the chance of the race to happen.

Register reboot notifier in KVM to explicitly flush caches upon
receiving reboot notifier (e.g., during kexec) for TDX.  This moves the
WBINVD to an earlier stage than stop_this_cpus(), avoiding a possibly
lengthy operation at a time where it could cause this race.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---

v2 -> v3:
 - Update changelog to address Paolo's comments and Add Paolo's Ack:
   https://lore.kernel.org/lkml/3a7c0856-6e7b-4d3d-b966-6f17f1aca42e@redhat.com/

---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/kvm/vmx/tdx.c      | 45 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c |  9 ++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d4c624c69d7f..e6b11982c6c6 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -221,6 +221,8 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+
+void tdx_cpu_flush_cache(void);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
@@ -228,6 +230,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline void tdx_cpu_flush_cache(void) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1ad20c273f3b..c567a64a6cb0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,7 +5,9 @@
 #include <asm/fpu/xcr.h>
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
+#include <linux/reboot.h>
 #include <asm/tdx.h>
+#include <asm/processor.h>
 #include "capabilities.h"
 #include "mmu.h"
 #include "x86_ops.h"
@@ -3347,6 +3349,33 @@ static int tdx_offline_cpu(unsigned int cpu)
 	return -EBUSY;
 }
 
+static void smp_func_cpu_flush_cache(void *unused)
+{
+	tdx_cpu_flush_cache();
+}
+
+static int tdx_reboot_notify(struct notifier_block *nb, unsigned long code,
+			     void *unused)
+{
+	/*
+	 * Flush cache for all CPUs upon the reboot notifier.  This
+	 * avoids having to do WBINVD in stop_this_cpu() during kexec.
+	 *
+	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
+	 * before booting to new kernel, but that code has a "race"
+	 * when the normal REBOOT IPI timesout and NMIs are sent to
+	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
+	 * could potentially increase the posibility of the "race".
+	 */
+	if (code == SYS_RESTART)
+		on_each_cpu(smp_func_cpu_flush_cache, NULL, 1);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block tdx_reboot_nb = {
+	.notifier_call = tdx_reboot_notify,
+};
+
 static void __do_tdx_cleanup(void)
 {
 	/*
@@ -3504,6 +3533,11 @@ void tdx_cleanup(void)
 {
 	if (enable_tdx) {
 		misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
+		/*
+		 * Ignore the return value.  See the comment in
+		 * tdx_bringup().
+		 */
+		unregister_reboot_notifier(&tdx_reboot_nb);
 		__tdx_cleanup();
 		kvm_disable_virtualization();
 	}
@@ -3587,6 +3621,17 @@ int __init tdx_bringup(void)
 		enable_tdx = 0;
 	}
 
+	if (enable_tdx)
+		/*
+		 * Ignore the return value.  @tdx_reboot_nb is used to flush
+		 * cache for all CPUs upon rebooting to avoid having to do
+		 * WBINVD in kexec while the kexec-ing CPU stops all remote
+		 * CPUs.  Failure to register isn't fatal, because if KVM
+		 * doesn't flush cache explicitly upon rebooting the kexec
+		 * will do it anyway.
+		 */
+		register_reboot_notifier(&tdx_reboot_nb);
+
 	return r;
 
 success_disable_tdx:
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..73425e9bee39 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1870,3 +1870,12 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+void tdx_cpu_flush_cache(void)
+{
+	lockdep_assert_preemption_disabled();
+
+	wbinvd();
+	this_cpu_write(cache_state_incoherent, false);
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache);
-- 
2.49.0



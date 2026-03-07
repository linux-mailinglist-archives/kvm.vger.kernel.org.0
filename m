Return-Path: <kvm+bounces-73195-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE+JOa55q2nsdQEAu9opvQ
	(envelope-from <kvm+bounces-73195-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:04:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6069022938E
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0EAFE30612A5
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743DB2D781E;
	Sat,  7 Mar 2026 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxmL/SI6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46A286412;
	Sat,  7 Mar 2026 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845454; cv=none; b=GqyZUHE+EdIFnV6MDPCiuU2pa+m3p9SdEMedQqUCrBy18JmAPek0gTCKN5GPa6FHZmLtx5ZMHFk4My32pRg84hK+JmH6ew9RQQF/oisiTyoMcUyt9kbcvWzlCoeWnlrHYjwFu9ymtjQHbECjfeiJrUuVmeimCkV0vmc5adD+6t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845454; c=relaxed/simple;
	bh=oTLfhSSlOmM92LJkqNFBzQ2K3fHxLneuG0MsPSGtmy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHGEGKrXUbqLj5zZWk4A50rT0sWoUfF4NgRT6Tl5pZQuEu/u2NHUQFVtDftsUT5+fVxFZRFZHwO+o8R07yhxOOMMC3BqjhU8BT+AyLOLZr9msd5fRyCshpt1BSFyNUNWydgs81sD+lGYujIR5zPej3hullRwT7uPEkZiy47gD5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxmL/SI6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772845452; x=1804381452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oTLfhSSlOmM92LJkqNFBzQ2K3fHxLneuG0MsPSGtmy0=;
  b=gxmL/SI6b32xMC1EdZSj5DWNmfK/qK2dWtDa8CN3zeEYc7IZKV3kYurA
   hrDmKd68mi3P1PV4MO1lqvWjbefR+b8MhkbjkXgcUmpe0l2F3OPS34OyC
   pqP+TmUXT2oN/Tmsg53r6s2+e2KUTkL0/7gSA1OX+Q99uunD/Iv6GqfiM
   pvr+1s18XP1Sx5sD8sVdqq4aLkgjJRdYjklaWZx49kNGLvsDvomgk1wLT
   ACQJxWAolrFUDsfJl4jUJJQZDAuA9gx7xNF5bEm39h0Rao3WVSqLh6u7r
   GG4lMk109tSQo8nS6k9U2DrzSsyrPzxEJcy6PbOKzso4l0kV9TNlKHqjN
   g==;
X-CSE-ConnectionGUID: VUhxL4GKRUGX6VFw9ygfMA==
X-CSE-MsgGUID: MBip9xhpTBWsmIYs2O26hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="76565944"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="76565944"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
X-CSE-ConnectionGUID: +yrCuu/GSI6QofSK7FcTIw==
X-CSE-MsgGUID: tmPMvj9KQfmWXtAEsa0ZTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="218329622"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	dave.hansen@intel.com,
	hpa@zytor.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@kernel.org,
	x86@kernel.org,
	chao.gao@intel.com,
	kai.huang@intel.com,
	ackerleytng@google.com
Cc: rick.p.edgecombe@intel.com,
	vishal.l.verma@intel.com
Subject: [PATCH 2/4] x86/virt/tdx: Pull kexec cache flush logic into arch/x86
Date: Fri,  6 Mar 2026 17:03:56 -0800
Message-ID: <20260307010358.819645-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6069022938E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73195-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

KVM tries to take care of some required cache flushing earlier in the
kexec path in order to be kind to some long standing races that can occur
later in the operation. Until recently, VMXOFF was handled within KVM.
Since VMX being enabled is required to make a SEAMCALL, it had the best
per-cpu scoped operation to plug the flushing into.

This early kexec cache flushing in KVM happens via a syscore shutdown 
callback. Now that VMX enablement control has moved to arch/x86, which has 
grown its own syscore shutdown callback, it no longer make sense for it to 
live in KVM. It fits better with the TDX enablement managing code.

In addition, future changes will add a SEAMCALL that happens immediately
before VMXOFF, which means the cache flush in KVM will be too late to be
helpful. So move it to the newly added TDX arch/x86 syscore shutdown
handler.

Since tdx_cpu_flush_cache_for_kexec() is no longer needed by KVM, make it 
static and remove the export. Since it is also not part of an operation 
spread across disparate components, remove the redundant comments and 
verbose naming.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/tdx.h  |  6 ------
 arch/x86/kvm/vmx/tdx.c      | 10 ----------
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++------------------
 3 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0c1ae4954f17..f0826b0a512a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -206,11 +206,5 @@ static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
-#ifdef CONFIG_KEXEC_CORE
-void tdx_cpu_flush_cache_for_kexec(void);
-#else
-static inline void tdx_cpu_flush_cache_for_kexec(void) { }
-#endif
-
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASM_X86_TDX_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b7264b533feb..50a5cfdbd33e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -440,16 +440,6 @@ void tdx_disable_virtualization_cpu(void)
 		tdx_flush_vp(&arg);
 	}
 	local_irq_restore(flags);
-
-	/*
-	 * Flush cache now if kexec is possible: this is necessary to avoid
-	 * having dirty private memory cachelines when the new kernel boots,
-	 * but WBINVD is a relatively expensive operation and doing it during
-	 * kexec can exacerbate races in native_stop_other_cpus().  Do it
-	 * now, since this is a safe moment and there is going to be no more
-	 * TDX activity on this CPU from this point on.
-	 */
-	tdx_cpu_flush_cache_for_kexec();
 }
 
 #define TDX_SEAMCALL_RETRIES 10000
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cb9b3210ab71..0802d0fd18a4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -224,8 +224,28 @@ static int tdx_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+static void tdx_cpu_flush_cache(void)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (!this_cpu_read(cache_state_incoherent))
+		return;
+
+	wbinvd();
+	this_cpu_write(cache_state_incoherent, false);
+}
+
 static void tdx_shutdown_cpu(void *ign)
 {
+	/*
+	 * Flush cache now if kexec is possible: this is necessary to avoid
+	 * having dirty private memory cachelines when the new kernel boots,
+	 * but WBINVD is a relatively expensive operation and doing it during
+	 * kexec can exacerbate races in native_stop_other_cpus().  Do it
+	 * now, since this is a safe moment and there is going to be no more
+	 * TDX activity on this CPU from this point on.
+	 */
+	tdx_cpu_flush_cache();
 	x86_virt_put_ref(X86_FEATURE_VMX);
 }
 
@@ -1920,22 +1940,3 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
-
-#ifdef CONFIG_KEXEC_CORE
-void tdx_cpu_flush_cache_for_kexec(void)
-{
-	lockdep_assert_preemption_disabled();
-
-	if (!this_cpu_read(cache_state_incoherent))
-		return;
-
-	/*
-	 * Private memory cachelines need to be clean at the time of
-	 * kexec.  Write them back now, as the caller promises that
-	 * there should be no more SEAMCALLs on this CPU.
-	 */
-	wbinvd();
-	this_cpu_write(cache_state_incoherent, false);
-}
-EXPORT_SYMBOL_FOR_KVM(tdx_cpu_flush_cache_for_kexec);
-#endif
-- 
2.53.0



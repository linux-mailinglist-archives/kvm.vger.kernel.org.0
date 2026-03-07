Return-Path: <kvm+bounces-73197-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAZrODJ6q2kSdgEAu9opvQ
	(envelope-from <kvm+bounces-73197-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:06:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 885572293CC
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 976CE315CBFA
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0124C2DCC1C;
	Sat,  7 Mar 2026 01:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aPwR+Nn2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE7328851F;
	Sat,  7 Mar 2026 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845458; cv=none; b=YP6UwELAqeKRtCFsTkfntR45X4htztgWfFEUBMbPkQXkaYmYq/t/HGVqtaOeu5DGDLCt/fNC+9sBjs+TuI+7wU3oOC1Erk9Ep104kc9xP+ErNZ9hPumdIbPJfJV3uj4qKwx6ZSGRSrzgtj251zeF+zCYn0ayNaf1u9TZ2IZy1Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845458; c=relaxed/simple;
	bh=Ib4A2dLqs3t1llyi121mdd/5hQlAcyxmpeDuX6pTBgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtftTb+eUsK9UA8jYHNVrg+RalqnRkgpz9YV0YCdcNmKfSyvKCLxzkxKG/nBbPwlA4RB5lbxEsRSSFsszD9ThJHLOjgl7JIRqRrU7rfvhK5j8gfN5YqsVsv+onUCuwJk+YNHarcKc8TEGEYyQ1eEr0FlKtjaR8xJf4ZFaMAdU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aPwR+Nn2; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772845456; x=1804381456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ib4A2dLqs3t1llyi121mdd/5hQlAcyxmpeDuX6pTBgM=;
  b=aPwR+Nn2gyZqWRTnI+hGzlr4sqMc8aERkS7r1pbshZXIqjHTmMYBq5kn
   u5zx17cb4W/JleA1tDylKfzmfb4wPhLGwg4maDbKUwjP3SKl3TeqOf6VB
   4ySB3yCqqcdoJL/eEXZeF7p2/cWnmhHqkUlXvrhSLyQtSMMPUzjbODxI3
   JftMkB4UabhmNeG6jj/OhhL2rFxWbFqo/stss2qyCWef08EgecABrM2Lr
   /3YaB7B+46+WUnHZ/9jHdNFowoesRWzsAtchb2wlCBU05Tun+JjJt2rzd
   dapMYmaEyzoumbmvMrvxqxN1Tyf+U8lpx3tHwxVKavMk81bnYNXSccr3h
   g==;
X-CSE-ConnectionGUID: nKMn6jmsR0iVC5jAvfgu3g==
X-CSE-MsgGUID: BcqkT5oMQS+0D3K2DdyD2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="76565951"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="76565951"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
X-CSE-ConnectionGUID: z6oddU4cTMajb1kLg7sgzg==
X-CSE-MsgGUID: FKN6yTkOSg2ojlhEfXf0bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="218329625"
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
Subject: [PATCH 3/4] x86/virt/tdx: Add SEAMCALL wrapper for TDH.SYS.DISABLE
Date: Fri,  6 Mar 2026 17:03:57 -0800
Message-ID: <20260307010358.819645-4-rick.p.edgecombe@intel.com>
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
X-Rspamd-Queue-Id: 885572293CC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73197-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Vishal Verma <vishal.l.verma@intel.com>

Some early TDX-capable platforms have an erratum where a partial write
to TDX private memory can cause a machine check on a subsequent read.
On these platforms, kexec and kdump have been disabled in these cases,
because the old kernel cannot safely hand off TDX state to the new
kernel. Later TDX modules support the TDH.SYS.DISABLE SEAMCALL, which
provides a way to cleanly disable TDX and allow kexec to proceed.

This can be a long running operation, and the time needed largely
depends on the amount of memory that has been allocated to TDs. If all
TDs have been destroyed prior to the sys_disable call, then it is fast,
with only needing to override the TDX module memory.

After the SEAMCALL completes, the TDX module is disabled and all memory
resources allocated to TDX are freed and reset. The next kernel can then
re-initialize the TDX module from scratch via the normal TDX bring-up
sequence.

The SEAMCALL may be interrupted by an interrupt. In this case, it
returns TDX_INTERRUPTED_RESUMABLE, and it must be retried in a loop
until the operation completes successfully.

Add a tdx_sys_disable() helper, which implements the retry loop around
the SEAMCALL to provide this functionality.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 18 ++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f0826b0a512a..baaf43a09e99 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -173,6 +173,8 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
         return level - 1;
 }
 
+void tdx_sys_disable(void);
+
 u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
@@ -204,6 +206,7 @@ static inline void tdx_init(void) { }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline void tdx_sys_disable(void) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0802d0fd18a4..68bd2618dde4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -37,6 +37,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
+#include <asm/shared/tdx_errno.h>
 #include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
@@ -1940,3 +1941,20 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
+
+void tdx_sys_disable(void)
+{
+	struct tdx_module_args args = {};
+
+	/*
+	 * SEAMCALLs that can return TDX_INTERRUPTED_RESUMABLE are guaranteed
+	 * to make forward progress between interrupts, so it is safe to loop
+	 * unconditionally here.
+	 *
+	 * This is a 'destructive' SEAMCALL, in that no other SEAMCALL can be
+	 * run after this until a full reinitialization is done.
+	 */
+	while (seamcall(TDH_SYS_DISABLE, &args) == TDX_INTERRUPTED_RESUMABLE)
+		;
+}
+
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index dde219c823b4..e2cf2dd48755 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_SYS_DISABLE			69
 
 /*
  * SEAMCALL leaf:
-- 
2.53.0



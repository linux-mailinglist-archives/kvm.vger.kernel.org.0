Return-Path: <kvm+bounces-6706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE760837BB4
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59F3B28DD0E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEA91509B5;
	Tue, 23 Jan 2024 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OrJK0lf3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926FB1509BA;
	Tue, 23 Jan 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969367; cv=none; b=hUoNrXU/Y7tMJerok3CoZigONc6EihZksiAF9jFf5NgPIfsLxVVl7hj9hMlIPx5iGLJ/MW/MqKBdWLLeJAxvpBTr/H/EcLLQneTcGr0UIe+8oDhF2R1os2GqBBQeg1+NYKRicYpMGJ6A351P3Jo4iUhXNkQ18UXKDlyoJevrjCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969367; c=relaxed/simple;
	bh=RlU8JoF2lJVCiCoA2T+BoaCaWes3i9Y4CE5OV12pJso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HEJLx9ebiYnA9d0yTx0H7P3ELszlEU8uowwjr8G5b7VFBtp27FE2Lbl7MKCqC0qh/aEll7dBo4nt3m/oWSXBtp55j8mZ1Do7bXMJxgUP25Ba2QGi1VHYaZ9qd9+M9guysVBXcuPxb0WGTOOjvD1EDvgjwBygdGJ6p5oPMAXs1RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OrJK0lf3; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969365; x=1737505365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RlU8JoF2lJVCiCoA2T+BoaCaWes3i9Y4CE5OV12pJso=;
  b=OrJK0lf3KF0efLzKxIZVAO7Uq1ot3wiHD1Amg/kP6PSz2uilEIbz+l/6
   mCNky5m28yc3nxtxUtJ87Qb45Rw19qQmDDSQGx8D7ecMukJoRnLUV2bH/
   IIumGZGE/bQv/UQRgloSO0U7792PnFQumCoythTES0ChWPEmZoD74Mx2c
   ipI6JkReVbPEXZuulGA6ipcTp8QFeekMJYsf63BMFilj6K88YhmLeKooX
   RqT8QHIub4w5NOO7ukjDmudWtB/HTcgGOTOn0h9SV+kSJgtJ5/oXDDc6H
   FqUwjv6nfR3jztV/OZbKrfVwe8yyNhJdXrR9Y5SUKH1uApDaxHNoh+8ia
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125699"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125699"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825663"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v7 11/13] KVM: TDX: Implement merge pages into a large page
Date: Mon, 22 Jan 2024 16:22:26 -0800
Message-Id: <4eac53599fb87c41aee14577b66d0a832e6c836b.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement merge_private_stp callback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v7:
- Fix subject, x86/tdp_mmu => TDX
- comment: use ulink instead of free for clarity

v6:
- repeat TDH.MEM.PAGE.PROMOTE() on TDX_INTERRUPTED_RESTARTABLE
---
 arch/x86/kvm/vmx/tdx.c       | 74 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h  |  1 +
 arch/x86/kvm/vmx/tdx_errno.h |  2 +
 arch/x86/kvm/vmx/tdx_ops.h   | 11 ++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 10dbe4a4db7a..f26caa496d1b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1742,6 +1742,51 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_merge_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_args out;
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	do {
+		err = tdh_mem_page_promote(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+	} while (err == TDX_INTERRUPTED_RESTARTABLE);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (unlikely(err == (TDX_EPT_INVALID_PROMOTE_CONDITIONS |
+			     TDX_OPERAND_ID_RCX)))
+		/*
+		 * Some pages are accepted, some pending.  Need to wait for TD
+		 * to accept all pages.  Tell it the caller.
+		 */
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_PROMOTE, err, &out);
+		return -EIO;
+	}
+	WARN_ON_ONCE(out.rcx != __pa(private_spt));
+
+	/*
+	 * TDH.MEM.PAGE.PROMOTE unlinks the Secure-EPT page for the lower level.
+	 * Flush cache for reuse.
+	 */
+	do {
+		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(__pa(private_spt),
+							     to_kvm_tdx(kvm)->hkid));
+	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return -EIO;
+	}
+
+	tdx_clear_page(__pa(private_spt), PAGE_SIZE);
+	return 0;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level)
 {
@@ -1816,6 +1861,33 @@ static void tdx_track(struct kvm *kvm)
 
 }
 
+static int tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	struct tdx_module_args out;
+	u64 err;
+
+	do {
+		err = tdh_mem_range_unblock(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+
+		/*
+		 * tdh_mem_range_block() is accompanied with tdx_track() via kvm
+		 * remote tlb flush.  Wait for the caller of
+		 * tdh_mem_range_block() to complete TDX track.
+		 */
+	} while (err == (TDX_TLB_TRACKING_NOT_DONE | TDX_OPERAND_ID_SEPT));
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_RANGE_UNBLOCK, err, &out);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
@@ -3309,9 +3381,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
 	x86_ops->split_private_spt = tdx_sept_split_private_spt;
+	x86_ops->merge_private_spt = tdx_sept_merge_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+	x86_ops->unzap_private_spte = tdx_sept_unzap_private_spte;
 
 	return 0;
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index e663abaa3aa0..aef6103c6515 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -29,6 +29,7 @@
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
+#define TDH_MEM_PAGE_PROMOTE		23
 #define TDH_MEM_SEPT_RD			25
 #define TDH_VP_RD			26
 #define TDH_MNG_KEY_RECLAIMID		27
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index d08b4d14e57b..4142487f987e 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -24,6 +24,8 @@
 #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
 #define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
 #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
 
 /*
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 772e2e7d61e7..e2b9f1c3d67f 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -262,6 +262,17 @@ static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t pag
 	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, &in, out);
 }
 
+static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
+				       struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall_sept(TDH_MEM_PAGE_PROMOTE, &in, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_args *out)
 {
-- 
2.25.1



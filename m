Return-Path: <kvm+bounces-54235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB6AB1D512
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1F6064E24B1
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55162641FC;
	Thu,  7 Aug 2025 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddIcsKk/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9725C6F1;
	Thu,  7 Aug 2025 09:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559851; cv=none; b=jvJ6ib6G+FVkmy7fDofPcgbwJewuLZowRH4jaNrI+ifh4oievHiQYsKAOjbZK7zi/ILqbnXNZBuYdFvxx9ld/Wuwh3YmOJE58c0MIUNDitJJQJcf9ACWtNWZWXHyBNId86OdQnSjbs7VtkfNi4WuDDIGtvgbGKVyHc3llZja7k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559851; c=relaxed/simple;
	bh=H7ViE+M6iHzywESveDWdG6sSLjQnmWxYp3t1pYK4KlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXe3h/u5HheqAdE6xbkNu4ENj6qdAIDXPRtUjSnAmzPZ7gpP+8PImPx1CFTrj5/2juq2PFTRFdumakNKat0rfv97qZvx0o2K2w6gfGJGfVVWtbsOjuv3Ql81UoKQMhCvuB9db5zF0UYa69Dx1JAF+/oUO5pFl+pvzxjxmTYi4Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddIcsKk/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559851; x=1786095851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H7ViE+M6iHzywESveDWdG6sSLjQnmWxYp3t1pYK4KlQ=;
  b=ddIcsKk/R3JUOKt5mhrRS4ezBYqGyh4RmebRslOjPR4d/keCgyAYpjwP
   6JBobN9AbDmgGd1JXnOyW5nhcs2pi+IqpDAF6YN43VwIpggNRwSIpjS4F
   pXunkniYMykl4Q05KRJy0J1Akf6b/3xYDHmB1mibT+XESrmF9bhG3kBeE
   e/Mrkg9G0FCY4mlg9lCGLdwrVl9btUvvQ+eqCCFxlmOp7PdqaI1cOYAXN
   Cl4RZGCs7yZCTJ0G4LYrXdeIvKHU8Hb7qljob9vVbCTdYzXF3DIKpoRKI
   ozmMWMcr6zznoKGw7qzFeF9XOE8CBJMcZj7ejBxhSD3DUhxTlnEiQcjPz
   A==;
X-CSE-ConnectionGUID: IdrCMDitSdOfikwSRULYOA==
X-CSE-MsgGUID: UhLe8iAERx6cAAsqKJVKjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="79435877"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="79435877"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:09 -0700
X-CSE-ConnectionGUID: BEaDLIHdQRevEqD2nlOUHg==
X-CSE-MsgGUID: N/JVjEljQXuCFhhNXuLwhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164263172"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:04 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under write kvm->mmu_lock
Date: Thu,  7 Aug 2025 17:43:33 +0800
Message-ID: <20250807094333.4579-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the split_external_spt hook to enable huge page splitting for
TDX when kvm->mmu_lock is held for writing.

Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
tdh_mem_page_demote() in sequence. All operations are performed under
kvm->mmu_lock held for writing, similar to those in page removal.

Even with kvm->mmu_lock held for writing, tdh_mem_page_demote() may still
contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
operations. Therefore, kick off other vCPUs and prevent tdh_vp_enter()
from being called on them to ensure success on the second attempt. Use
KVM_BUG_ON() for any other unexpected errors.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Split out the code to handle the error TDX_INTERRUPTED_RESTARTABLE.
- Rebased to 6.16.0-rc6 (the way of defining TDX hook changes).

RFC v1:
- Split patch for exclusive mmu_lock only,
- Invoke tdx_sept_zap_private_spte() and tdx_track() for splitting.
- Handled busy error of tdh_mem_page_demote() by kicking off vCPUs.
---
 arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 376287a2ddf4..8a60ba5b6595 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1915,6 +1915,50 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, struct page *page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+
+	err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
+				  &entry, &level_state);
+
+	if (unlikely(tdx_operand_busy(err))) {
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
+					  &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				      void *private_spt)
+{
+	struct page *page = virt_to_page(private_spt);
+	int ret;
+
+	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE ||
+		       level != PG_LEVEL_2M, kvm))
+		return -EINVAL;
+
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
+	if (ret <= 0)
+		return ret;
+
+	tdx_track(kvm);
+
+	return tdx_spte_demote_private_spte(kvm, gfn, level, page);
+}
+
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
@@ -3668,5 +3712,6 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	vt_x86_ops.split_external_spt = tdx_sept_split_private_spt;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 }
-- 
2.43.2



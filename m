Return-Path: <kvm+bounces-54244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AACB1D533
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D0BD1AA2DDE
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7446326B77A;
	Thu,  7 Aug 2025 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tus8b5wd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3007E156228;
	Thu,  7 Aug 2025 09:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559974; cv=none; b=fXX8/59cf8v+p4Im4Bdr7mM8j5QbZ45RNBV0wv5UZKguzvfilsKgflQEVtNZ1+/UVFbj2LsWgflOnA6zQhvrtHK4vdLdXE67GHJ8AiVNk9rCZAGKF616QGDFsPnV/RCFZkrixhWCRB6syRrOXEZ+JC0nk12tHz8QUmaPIyUW080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559974; c=relaxed/simple;
	bh=S/CculJCrXcuW5NwxvaQduSDXKwK6ZPtvK/nDp/PEAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4ICKcC6diLY73hTyW/JV2YIA+W3BnzZQ37caUxQhkmkL3brYLQVmHLls18lIGvIE6AxJToGkRAvvYqFwy7Cc1k3t+8H+mukIoXah/htENEpp45RAEMw+jAA+jn1GWynWN8qy+JICtO/QAOrkctHtaJQ5jolDWg9piTnGcFjGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tus8b5wd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559973; x=1786095973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S/CculJCrXcuW5NwxvaQduSDXKwK6ZPtvK/nDp/PEAI=;
  b=Tus8b5wdlgua9OP1UyiQsSbMar88rZN1MNDl5RTRu++JrVyKo4KPVa8r
   5zjKyKm8BvwdknhFi/nifbJ0vf7LjUig6KjVY1KhZ0ehJzETwu0AjbKum
   IcKnM16UooHIIxd4zxaUqCp2k/FgLoBuw4JbeOd8BkYh1ZoIdHA8SVoFK
   3YjD+Qtjdyv74ZOnrqEDT2Q6s+QqmwFmZDYq/hEB5pfPwIHskAInVFxCO
   P5Tlh4ZvD25meQ3W7ZXo0Qu5FbztnSBJFQkZsSlNhm2IFSLb5Nd2/ibNv
   xzQCW8ki3Mr0avpd0HMSOll/ZDXXY2rrYaEmXw9XFiJjEMcJkippmmeCt
   A==;
X-CSE-ConnectionGUID: XT8P/Ys4TRCumzGEh60Ujw==
X-CSE-MsgGUID: HyZm/Mc/Qd6sHLePI6VpkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57028966"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="57028966"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:12 -0700
X-CSE-ConnectionGUID: C+AeIeRwTT6kRbCYiZ6tlQ==
X-CSE-MsgGUID: 0hwEyXKQQ7y1VbUr8M5MXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202196544"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:07 -0700
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
Subject: [RFC PATCH v2 19/23] KVM: TDX: Pass down pfn to split_external_spt()
Date: Thu,  7 Aug 2025 17:45:37 +0800
Message-ID: <20250807094537.4732-1-yan.y.zhao@intel.com>
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

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Pass down pfn to kvm_x86_ops::split_external_spt(). It is required for
handling Dynamic PAMT in tdx_sept_split_private_spt().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Pulled from
  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
- Rebased on top of TDX huge page RFC v2 (Yan)
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 6 +++++-
 arch/x86/kvm/vmx/tdx.c          | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cb5b422dd1d..6b6c46c27390 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1841,7 +1841,8 @@ struct kvm_x86_ops {
 
 	/* Split the external page table into smaller page tables */
 	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				  void *external_spt, bool mmu_lock_shared);
+				  kvm_pfn_t pfn_for_gfn, void *external_spt,
+				  bool mmu_lock_shared);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 62a09a9655c3..eb758aaa4374 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -389,11 +389,15 @@ static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 			      u64 new_spte, int level, bool shared)
 {
 	void *external_spt = get_external_spt(gfn, new_spte, level);
+	kvm_pfn_t pfn_for_gfn = spte_to_pfn(old_spte);
 	int ret;
 
 	KVM_BUG_ON(!external_spt, kvm);
 
-	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt, shared);
+	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level,
+					       pfn_for_gfn, external_spt,
+					       shared);
+
 	return ret;
 }
 /**
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 71115058e5e6..24aa9aaad6d8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1941,7 +1941,8 @@ static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
 }
 
 static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				      void *private_spt, bool mmu_lock_shared)
+				      kvm_pfn_t pfn_for_gfn, void *private_spt,
+				      bool mmu_lock_shared)
 {
 	struct page *page = virt_to_page(private_spt);
 	int ret;
-- 
2.43.2



Return-Path: <kvm+bounces-44035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43769A99F41
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FFEA441427
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D81F1AC458;
	Thu, 24 Apr 2025 03:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nN18KjYB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D619D07A;
	Thu, 24 Apr 2025 03:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464032; cv=none; b=auLIHYNyyC6FeLZUZ+tOiojKvcm5dHhHu0Pkqv+xvljFJK29LaqApZA7f4rHjdE1Rfy/J5yIT+IXetIt4ht7IO3/7LSjG4FhXYGAv8L/Z+w7BxlqRcQ9/rIW+ecyIsoyve7xlf1xCkqsBS5I+JhgUIX9UQQNrnH68BOSG9nbbUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464032; c=relaxed/simple;
	bh=FJnK14NKuDP3CeUZrm2nUQjQSe9lo4jUpBZV0Ikd4eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KczTtKnj5WTEczJPwEUQ6R6raVrDRaR6nKxtnL4C3llk9HI6RmTpXXElntbRrO+ywE1XgbAK2MQ53oN3+FaHMWpefcwJwWg5S6p7B649Zrg/6bL8WfxEB0BbsYvMklYfDaIn3S/ZTWdKeBGkj2TXFnD2F4217Zlk25mxDOZuujs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nN18KjYB; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464031; x=1777000031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJnK14NKuDP3CeUZrm2nUQjQSe9lo4jUpBZV0Ikd4eE=;
  b=nN18KjYBlpb0zsOrrernWL0rV2NCI7V1TLlqOshp5cS+l5ggkaJ5YhmM
   a7ahW+KANLfT/byYqoflk7A4s9yD4oRWwZjROFIqhA6ScMDadWOLZxdSp
   yyq8Kv2oAJaSdvwA8IZ+YTHezrrbavuh00FwRl17QjNHjbc3eL28M4D1E
   prYuFwS3TjpMCjE1+cz+P+nWxBM9JLTjjyPmgbWTJLgA7G3NzmNg0eBMa
   3XqbYTyNqovWsUXJtyHy6Dpci/GeV/Yamq4gDvUciQgEr7Z4Tp2BxNlpm
   /qQPpeJkA1yRNvNcZDoDRjwOttnFnQtgFrBHRmybUdQKko0NbxEk2iviQ
   w==;
X-CSE-ConnectionGUID: PcZC+8XcT6uHnxZoC45naw==
X-CSE-MsgGUID: ngyVHycsTLC2xg5j2cSubA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="49744087"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="49744087"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:09 -0700
X-CSE-ConnectionGUID: jqraRcHrQBeea9vyODkr7g==
X-CSE-MsgGUID: 9H12f0u2S36jKWCxhlmU+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132374442"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:03 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 05/21] KVM: TDX: Enhance tdx_clear_page() to support huge pages
Date: Thu, 24 Apr 2025 11:05:16 +0800
Message-ID: <20250424030516.32740-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

KVM invokes tdx_clear_page() to zero pages using movdir64b().
Include level information to enable tdx_clear_page() to zero a huge page.

[Yan: split out, let tdx_clear_page() accept level]

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 03885cb2869b..1186085795ac 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -276,7 +276,7 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void tdx_clear_page(struct page *page)
+static void __tdx_clear_page(struct page *page)
 {
 	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
 	void *dest = page_to_virt(page);
@@ -295,6 +295,15 @@ static void tdx_clear_page(struct page *page)
 	__mb();
 }
 
+static void tdx_clear_page(struct page *page, int level)
+{
+	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
+	unsigned long idx = 0;
+
+	while (nr--)
+		__tdx_clear_page(nth_page(page, idx++));
+}
+
 static void tdx_no_vcpus_enter_start(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -340,11 +349,10 @@ static int tdx_reclaim_page(struct page *page)
 
 	r = __tdx_reclaim_page(page);
 	if (!r)
-		tdx_clear_page(page);
+		tdx_clear_page(page, PG_LEVEL_4K);
 	return r;
 }
 
-
 /*
  * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
  * private KeyID.  Assume the cache associated with the TDX private KeyID has
@@ -588,7 +596,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->td.tdr_page);
+	tdx_clear_page(kvm_tdx->td.tdr_page, PG_LEVEL_4K);
 
 	__free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1621,7 +1629,8 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
 	}
-	tdx_clear_page(page);
+
+	tdx_clear_page(page, level);
 	tdx_unpin(kvm, page);
 	return 0;
 }
-- 
2.43.2



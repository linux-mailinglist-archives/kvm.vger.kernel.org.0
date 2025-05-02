Return-Path: <kvm+bounces-45223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA38AA72ED
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B05E982246
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5CF7256C69;
	Fri,  2 May 2025 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNDvKZ0D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED0D255E37;
	Fri,  2 May 2025 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191326; cv=none; b=Ay+t/lNyW2L9nZFxxYOCn1Cq5avkS7Z0zQvsLoppmu3MeLMaznMY6X1pUyTyjLqjZJLWeObv6xCqgW0S+1jb0d8TVTf87AYWDGC47XH2eq68zIIn/kmhW+9iQgzRL0OLUz70qGF0ahpYvNewIcEfL/K6Ib84kwvEPJnR3GezMC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191326; c=relaxed/simple;
	bh=5YulLqzYaPRFiDwv0UiD8Q1U8nJJ4tt2rc8wqBnQCTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZYiXJWdyiNeCa5W9MjUHsE6rKFphrj3DlnyUvXZDBekqebGgHsw6vgTaWAg+xU74dRRVCLftcsPVD5wVyI1CQ1GUdle6nchVeoPJROA/Xs7zDB2kNIPd8dy/76b+02YLAWytyGZGpIt63Q/vi5evun3M/Qjgnr1mMlppRUN0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNDvKZ0D; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191325; x=1777727325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5YulLqzYaPRFiDwv0UiD8Q1U8nJJ4tt2rc8wqBnQCTA=;
  b=bNDvKZ0DMHP8yN1tf2GXWQiWprFvXYDnqj5DVy58LfFGJNl19/JpdnHF
   HYviKuvSmHUPzMMbGLxMnlzqFCl6ORkZ7QJuFvCpXHyW4I9dDFdxADi2Z
   +kLvCgJqVU3gXbtB9bjMYvgnqMtCkXpPN/7T8bJ0DaC+Sl1zEsWNq09dy
   nLZr0qr2gLtBopLuhJKvXoNZ7QTiEIduDO9IxKbp1zOVP0fTQE0LMeIC+
   PDENXgSzVVIcL+FirakUrkqj+lyajRz57CsVxF/i2vHsCHnuJ6zE64JI/
   ZcjzHJ0qHzzsL5NBLnOKkvx3SOveA5BXis0v0DQZiVbSAAten4cyrphl6
   Q==;
X-CSE-ConnectionGUID: WzwgLAyYS4O/cIiS8SAQ6w==
X-CSE-MsgGUID: jQAMGxmZQPy4mwfWgQAd5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012973"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012973"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:44 -0700
X-CSE-ConnectionGUID: sdojZYYiQNKO+f/l5nWG9Q==
X-CSE-MsgGUID: IfHdJ5QqSX2fqonxzhahQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871082"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 8F02D3EA; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 11/12] KVM: TDX: Reclaim PAMT memory
Date: Fri,  2 May 2025 16:08:27 +0300
Message-ID: <20250502130828.4071412-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PAMT memory holds metadata for TDX-protected memory. With Dynamic
PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
with a few pages that cover 2M of host physical memory.

PAMT memory can be reclaimed when the last user is gone. It can happen
in a few code paths:

- On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
  tdx_reclaim_page().

- On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().

- In tdx_sept_zap_private_spte() for pages that were in the queue to be
  added with TDH.MEM.PAGE.ADD, but it never happened due to an error.

Add tdx_pamt_put() in these code paths.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0f06ae7ff6b9..352f7b41f611 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -487,8 +487,11 @@ static int tdx_reclaim_page(struct page *page)
 	int r;
 
 	r = __tdx_reclaim_page(page);
-	if (!r)
+	if (!r) {
 		tdx_clear_page(page);
+		tdx_pamt_put(page);
+	}
+
 	return r;
 }
 
@@ -737,6 +740,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 		return;
 	}
 	tdx_clear_page(kvm_tdx->td.tdr_page);
+	tdx_pamt_put(kvm_tdx->td.tdr_page);
 
 	__free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1768,6 +1772,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 	tdx_clear_page(page);
+	tdx_pamt_put(page);
 	tdx_unpin(kvm, page);
 	return 0;
 }
@@ -1848,6 +1853,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
+		tdx_pamt_put(page);
 		tdx_unpin(kvm, page);
 		return 0;
 	}
-- 
2.47.2



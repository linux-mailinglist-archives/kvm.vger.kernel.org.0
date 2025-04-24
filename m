Return-Path: <kvm+bounces-44037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF9BA99F4A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE436442FEA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9511AC458;
	Thu, 24 Apr 2025 03:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4Hn9NCT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB0F1990D8;
	Thu, 24 Apr 2025 03:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464064; cv=none; b=pMx//PZfnASQ55QjRG2J0N+Y8DCFjlXrplkZB3ElxSiVC+4fzakCCjcFw5iSLkUh+r2cFdJL3te+tIta914wY+vASMLon/GTjP1rcS7d1xyf7Fh1e8QsSJ/K7HiG5zDSM95OT2Mt2BfA/P6VtEIQvH0Flsi/D4YLD//HaQzwQ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464064; c=relaxed/simple;
	bh=+TU6VJeQC6TltCIOY1v9uQGCKkI59WgTKNbvK/Sq5xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSWIDqEhXglwOxEj3SSr54apC0qRMvuX/sH/8Ftv2nGS/78ZYw4hLiwkGy3Qo27z9Kv5jvx8mNuLMoBanWXoecFuhB2CtqHKLcu3vi1rUj/MLk47aNeZJH4wqTTijybfMO+KtRC5ING6i2kcb1J5zOn6P+MGiohHlH2Rz90YqZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4Hn9NCT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464063; x=1777000063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+TU6VJeQC6TltCIOY1v9uQGCKkI59WgTKNbvK/Sq5xc=;
  b=e4Hn9NCTS7J0DaFils1PH5XKSZ7xFYj0gbGWNbjoB4vXSwm/LkKjYp62
   R9j587P1ZzZl/IzG7BCgnmtSwJj2WQ88hJQZwB37GD9y8Nor+0g8MtoLh
   Oz5BasA/xC4WdiDOPH2mvVJ5xK2MLxE3P7dE6jNwW5Q/8buI3AEoALxdI
   nYQQwymuzXkkdCOnTaNoisUS8X0JekfOTMyB2s5XiRZmH6VUzyWSAA4or
   qV1w9mOzr386y1tG7zPp0D09+R3qZts/bJ8NSSusgO5t1Mdw31u7iq8J8
   wiRMa9bfnGWsUZ1xQ7PVr2I+rWcQO9YCGZrl90wxXYecgirlHWu1tfZLv
   w==;
X-CSE-ConnectionGUID: Aa0TISx0TaGNsRPaYBNR+g==
X-CSE-MsgGUID: ce/Sq42ASPyE7oF1BBsZFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64491311"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="64491311"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:41 -0700
X-CSE-ConnectionGUID: bLRInpVpT8SDVBtslMZ/bw==
X-CSE-MsgGUID: S957K9OqQM6P1QDg7yQWvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="136564864"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:35 -0700
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
Subject: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge pages with TD's keyID
Date: Thu, 24 Apr 2025 11:05:49 +0800
Message-ID: <20250424030549.305-1-yan.y.zhao@intel.com>
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

After a guest page is removed from the S-EPT, KVM calls
tdh_phymem_page_wbinvd_hkid() to execute WBINVD on the page using the TD's
keyID.

Add a helper function that takes level information to perform WBINVD on a
huge page.

[Yan: split patch, added a helper, rebased to use struct page]
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 69f3140928b5..355b21fc169f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1586,6 +1586,23 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_mem_page_record_premap_cnt(kvm, level);
 }
 
+static inline u64 tdx_wbinvd_page(struct kvm *kvm, u64 hkid, struct page *page, int level)
+{
+	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
+	unsigned long idx = 0;
+	u64 err;
+
+	while (nr--) {
+		err = tdh_phymem_page_wbinvd_hkid(hkid, nth_page(page, idx++));
+
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+			return err;
+		}
+	}
+	return err;
+}
+
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level, struct page *page)
 {
@@ -1625,12 +1642,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+	err = tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level);
+	if (err)
 		return -EIO;
-	}
 
 	tdx_clear_page(page, level);
 	tdx_unpin(kvm, page);
-- 
2.43.2



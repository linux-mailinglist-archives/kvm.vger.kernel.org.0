Return-Path: <kvm+bounces-48758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFE4AD267F
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 423D7189280E
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5EB21FF5B;
	Mon,  9 Jun 2025 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYvCXm/i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A922129F;
	Mon,  9 Jun 2025 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496442; cv=none; b=h/+rdAg5CDv5ZMVqfiSo99nHyBeqs0lfa2nz7T6ts3r/WbZZ+aDIZMWZZlw8+TeidSDEY+FeciG787nktOhU/KlbbGehWr74U7yJzLM3qbUmQhh659+Mr5RGrWxpHJLHFPgwmyvWODZ0SK9PpBFNOv1woVYWLFAoeXzdbIoAB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496442; c=relaxed/simple;
	bh=dVq8AG2GF42RqiqDTCSC9v7X/gPCjXZk8mRsFAhmeB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcVZNR5YFU+aKeSDOVEHYScSNLyoLnXEdYyFwDcoHksnFya+hq8EtEBwarMBTv3YN7aSxmZOq1h+3230qZXXBm7KnkzSTw2HyQx3GPST2pKXoL+Iu59YnDiuQrwCnOYadB0OcqevoBMruxU7sPtdUagU7cLtNijZgWMJYp8Pvqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYvCXm/i; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496441; x=1781032441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dVq8AG2GF42RqiqDTCSC9v7X/gPCjXZk8mRsFAhmeB8=;
  b=eYvCXm/iR6NWIhMo9A/sc5yToFrmz9iDMjVOaSqYemWyJVuZR85obrXd
   op2wueGn8Cjb7jsp4g1xbcnQy8P0C/HCGmZrFHhUfLgSGpl5wEmMoUzDu
   ZgY4DIcqxEpMWEg7ZcD5XBAgPJ4B9hvtRYIf2DFHgcgr2qnDc1Ettqq/O
   9cHU+U7cCJvRf4whng3O5KI4VFM5K3TxE97rzgs6GqtJ2gZszXIkRDpg+
   RgXpo+JhEgdAvqTkhcdBzbkePhHOASpUdQiuKlkhcBnn7WdSVh4QfOBVT
   XAjDBjY1vgnV3eyua0Eh6bX1ZYh+WaZIp84Cgh2Tpx7GXKMN7EZTzsogs
   w==;
X-CSE-ConnectionGUID: YkSzl6J6SOmcK1+S5VQ5BA==
X-CSE-MsgGUID: T8KLbCdXQ0uOVxS8Q1nBVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51467269"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51467269"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:14:00 -0700
X-CSE-ConnectionGUID: faca+Ut5Sq6LPIhDdQSKQA==
X-CSE-MsgGUID: 65UctnRYRdmz/ldkTwnKVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147562194"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 461716AD; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 06/12] KVM: TDX: Allocate PAMT memory in tdx_td_vcpu_init()
Date: Mon,  9 Jun 2025 22:13:34 +0300
Message-ID: <20250609191340.2051741-7-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate PAMT memory for TDH.VP.CREATE and TDH.VP.ADDCX.

PAMT memory that is associated with pages successfully added to the TD
with TDH.VP.ADDCX will be removed in tdx_reclaim_page() on
tdx_reclaim_control_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 13796b9a4bc5..36c3c9f8a62c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2829,7 +2829,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = tdx_alloc_page();
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2842,7 +2842,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = tdx_alloc_page();
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
@@ -2866,7 +2866,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 			 * method, but the rest are freed here.
 			 */
 			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-				__free_page(tdx->vp.tdcx_pages[i]);
+				tdx_free_page(tdx->vp.tdcx_pages[i]);
 				tdx->vp.tdcx_pages[i] = NULL;
 			}
 			return -EIO;
@@ -2885,16 +2885,15 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 
 free_tdcx:
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		if (tdx->vp.tdcx_pages[i])
-			__free_page(tdx->vp.tdcx_pages[i]);
+		tdx_free_page(tdx->vp.tdcx_pages[i]);
 		tdx->vp.tdcx_pages[i] = NULL;
 	}
 	kfree(tdx->vp.tdcx_pages);
 	tdx->vp.tdcx_pages = NULL;
 
 free_tdvpr:
-	if (tdx->vp.tdvpr_page)
-		__free_page(tdx->vp.tdvpr_page);
+	tdx_free_page(tdx->vp.tdvpr_page);
+
 	tdx->vp.tdvpr_page = 0;
 
 	return ret;
-- 
2.47.2



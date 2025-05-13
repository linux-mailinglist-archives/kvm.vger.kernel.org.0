Return-Path: <kvm+bounces-46292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E210AB4C9D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480BB1B4108E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208321F03EF;
	Tue, 13 May 2025 07:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dyyl8Q+a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C411E9B18
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120986; cv=none; b=CykNd7GqXgiaOeNFXMrzVgVjEL0RNItCKVCgABOXIJ+vb/oPFxVaNx8v6zEDFYnlKlxgDm4ALKzIRLPAk2F6EoIcAEZ1roN85eusi4e3ilkKazRCmAbymRPiMNA6wG0kMN1v/ZxxoaSLrXHFFaaQKOoSTZ7DbuzelVwXtU20F6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120986; c=relaxed/simple;
	bh=hL8fRSJ9HSXqEoADDAxOXe+Vs127NzDFSkeaizFcLr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsCgcXAkPtVETF/0tN5I8T+4ju/Vt6M8oVfb0Av0jNBtfCPRv+AFPaYrlTEm7XXQ+HeQxDyX2u23+529G0zQIKAb7if+e1A4sR8PZMQVuBWG4Be18+dlo+v5YhIby1BQmh4WPkugrX0UUKgrsvFAd0i+ZoZiIzD8dDThJXsYQok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dyyl8Q+a; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120984; x=1778656984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hL8fRSJ9HSXqEoADDAxOXe+Vs127NzDFSkeaizFcLr4=;
  b=Dyyl8Q+a695UdyAbZSdJzng3dHE19Wc/TyMnPqUYTRdtF3/jJ/Hteczd
   g/mYTQkI9FngoHkGsSJLRi2clUpbSMByK0KZA+QyNjltkosI4SvGOA14L
   3fxDn2kx3AHiMRGRLz8pV0qoocBYAmOs10sxBGYqwLq1aGx9PHgKUpuoe
   pN3gG57oP2q+3kRYueQSjbpjhD56ANaWwBasgPQ/Pyx8f4LlOTJ+2pOq+
   ZBAmeudhCuh+roHeUCwnEr1GIDvZDshkx0p5pzdIUD1qbx+ddhf2U3HMq
   6UGWy7sGci/sRmGHtv+ufehvHWcvx9czACwWVL66cwQhOCTov/wogQaSD
   A==;
X-CSE-ConnectionGUID: JhWX+fZmTN+yok65zoMzMQ==
X-CSE-MsgGUID: 1A5t2usKQeOgcxdFGlKjCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941000"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941000"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: lvF8IzWHSm2zm7U7pURaag==
X-CSE-MsgGUID: fKr2DtobS72yNPHlxAYGrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740604"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 2/8] x86: cet: Remove unnecessary memory zeroing for shadow stack
Date: Tue, 13 May 2025 00:22:44 -0700
Message-ID: <20250513072250.568180-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip mapping the shadow stack as a writable page and the redundant memory
zeroing.

Currently, the shadow stack is allocated using alloc_page(), then mapped as
a writable page, zeroed, and finally mapped as a shadow stack page. The
memory zeroing is redundant as alloc_page() already does that.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 51a54a50..214976f9 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -67,7 +67,6 @@ int main(int ac, char **av)
 {
 	char *shstk_virt;
 	unsigned long shstk_phys;
-	unsigned long *ptep;
 	pteval_t pte = 0;
 	bool rvc;
 
@@ -90,14 +89,8 @@ int main(int ac, char **av)
 	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
 
 	/* Install the new page. */
-	pte = shstk_phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	pte = shstk_phys | PT_PRESENT_MASK | PT_USER_MASK | PT_DIRTY_MASK;
 	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
-	memset(shstk_virt, 0x0, PAGE_SIZE);
-
-	/* Mark it as shadow-stack page. */
-	ptep = get_pte_level(current_page_table(), shstk_virt, 1);
-	*ptep &= ~PT_WRITABLE_MASK;
-	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
 	invlpg((void *)shstk_virt);
-- 
2.47.1



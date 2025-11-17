Return-Path: <kvm+bounces-63305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81428C6219A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1665635C067
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCADE25FA3B;
	Mon, 17 Nov 2025 02:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLv3kaWs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F2624EAB1;
	Mon, 17 Nov 2025 02:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347095; cv=none; b=a/TkRtoz3nzjRc8spwsPj2NLXlKzaxuYvnviRaPzSQ9e29Fv6GDR3aZJ0WKS3Z7WAvrIRo6jVpD+N8TdzOE+PyXfxdYbocdpkNCZyGDOK7hWLYAG9+E71tuDLImtRp1Ug8ToYCQelYllB/MfjejdU5EKjqreM9PWkj1HzPDnPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347095; c=relaxed/simple;
	bh=uL7WBJBsTP9ZJVgW/nJTV4pB4Gmgmj7c1OL/U+ejANM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MB/hRFj37KST/vELMb6PBQ6XQnvoEmKwHOlQOuBpgRm7k2I7LzvBEleR4ZPt1VqUsMDg6F9TO64N+IhLArhMHUq11jNASaXsl2LmXQyZ5w1AOFXuTRYO2k71wrhK1gii6Kkr3LbIF/ZtQW/r8ejZ0/ejUewe34392BhcaN8ZONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FLv3kaWs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347094; x=1794883094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uL7WBJBsTP9ZJVgW/nJTV4pB4Gmgmj7c1OL/U+ejANM=;
  b=FLv3kaWsZjWhuWYaMO5sH3G/3evRXxCRRVsT3oRGp43K65w+bcprcw9V
   ZS9wHB0h54h4ON6gjn4wsdL5u3o2X3VxJjeMXL9lERbHIE5ywh2RyXDyR
   7mDW6mdu8fgtz4NanF1bnN0ghUnCTmvueIwkkw79d2ZbRnozIwzy18fV3
   R8WbFtQKZTZuu5gKY5AaI+UDbX5aUMU/ADvQGPNuCYuRwGRYp0KTpODrP
   3N9WOwFywfYtBqnrRGLbN366zfGfFHVizCCnRwjHVNgUDbdPCbSfc8soE
   Y81USHaUTVhfZU16EzR5r/9VuJi7HahP9PkY7X3GvNlrWCtu8bHdbPhga
   g==;
X-CSE-ConnectionGUID: oMNa07Q2Q2e4zQIyyJyzHg==
X-CSE-MsgGUID: 8KOKf3yXQeG1aK56CUAQDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729510"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729510"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:14 -0800
X-CSE-ConnectionGUID: 0vv0/tYKS7OWuFg7DRX1kQ==
X-CSE-MsgGUID: 0W7AfeSWRJWhNT5m0PlQVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658200"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:10 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 05/26] mm: Add __free() support for __free_page()
Date: Mon, 17 Nov 2025 10:22:49 +0800
Message-Id: <20251117022311.2443900-6-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for the declaration of struct page * variables that trigger
__free_page() when they go out of scope.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 include/linux/gfp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..dc61fa63a3b9 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -383,6 +383,7 @@ extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
+DEFINE_FREE(__free_page, struct page *, if (_T) __free_page(_T))
 #define free_page(addr) free_pages((addr), 0)
 
 void page_alloc_init_cpuhp(void);
-- 
2.25.1



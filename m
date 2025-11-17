Return-Path: <kvm+bounces-63326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B3437C6221B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3716C4E76DA
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681B227F747;
	Mon, 17 Nov 2025 02:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFdxbHjl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B5727E05F;
	Mon, 17 Nov 2025 02:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347171; cv=none; b=sENhfrrS+weGfJ8iUOnrtTpWTy89lHLiH36TwElaGq3CBnLKg4MSdHeVbJ1S86QLGoP1YIWRZRCIu5oqkitaMyTqMqtRN+qpN+U0XSsrCQLG2I+rSh39e3c8ZzZtv/jHoMkjamCMr6h0A360+F11/F4PboOM7+PKBCXrj2voMqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347171; c=relaxed/simple;
	bh=rXScII9er1iRGZXNNqYS6o0YjelZ8hdCoPtxn3zisMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mA91Uc7gkBvCJLpoDOOq9+iuuu3juqWd3XwDc6fdkcaUd+QzeTHJjggPePJr+MOGQtisrzq9c2+RMKuOqSbnVZvlKmM7fopQAZHYuBaHA0IciZ8Fgs58E9U00Q+aiksNAuWV6HP56MWk8J5wAhA+lRvuhqscQ7l38GgH39pPTmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFdxbHjl; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347170; x=1794883170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rXScII9er1iRGZXNNqYS6o0YjelZ8hdCoPtxn3zisMI=;
  b=kFdxbHjl3lzzWtMtj/K5p19vfyA7Hoh9ap2TyA2l1gx4sLL/GT6cUnVA
   jB5prqlWO5VHtF01GVLyG/8ntuVvwMADf2aOe4I8gleuNmHWiGCCCaE6g
   1+pgaE/4HZWo0ZuXesUmN2m+yvxfJwriPB50sQSC2YfwrwWYygDHFjxBM
   cI2gDdKygHDDox0cpFdP5x6qISI1LR0RvhUDBFP//UxXqQANRSTqYAQwi
   Vh+VOflUaE3gZLPegf6YvDSaiMf1XRp1X4AEYYoSxjaJ22pwhRgx4vOwM
   b/oBtjAGVISByt+CeU6992BhonbFMZnjMh+yORn3GlNVtENCXQRL0NAko
   A==;
X-CSE-ConnectionGUID: KJWsqLmhSgqC5ksqT4rvTg==
X-CSE-MsgGUID: ao8p+wQTQSuYx/dPtGN15Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729639"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729639"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:30 -0800
X-CSE-ConnectionGUID: kd0YV+4EQXupkqe2ppiz6g==
X-CSE-MsgGUID: U0j2srXpR9GlZojKT13Q2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658539"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:25 -0800
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
Subject: [PATCH v1 26/26] coco/tdx-host: Finally enable SPDM session and IDE Establishment
Date: Mon, 17 Nov 2025 10:23:10 +0800
Message-Id: <20251117022311.2443900-27-yilun.xu@linux.intel.com>
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

The basic SPDM session and IDE functionalities are all implemented,
enable them.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/virt/coco/tdx-host/tdx-host.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 7f3c00f17ec7..b809f8f77206 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -885,7 +885,7 @@ static int tdx_iommu_enable_all(void)
 	return ret;
 }
 
-static int __maybe_unused tdx_connect_init(struct device *dev)
+static int tdx_connect_init(struct device *dev)
 {
 	struct tsm_dev *link;
 	int ret;
@@ -934,12 +934,8 @@ static int __maybe_unused tdx_connect_init(struct device *dev)
 
 static int tdx_host_probe(struct faux_device *fdev)
 {
-	/*
-	 * Only support TDX Connect now. More TDX features could be added here.
-	 *
-	 * TODO: do tdx_connect_init() when it is fully implemented.
-	 */
-	return 0;
+	/* Only support TDX Connect now. More TDX features could be added here. */
+	return tdx_connect_init(&fdev->dev);
 }
 
 static struct faux_device_ops tdx_host_ops = {
-- 
2.25.1



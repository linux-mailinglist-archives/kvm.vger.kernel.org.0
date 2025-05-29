Return-Path: <kvm+bounces-47956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E73D0AC7857
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C1716A5FB
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43C02566E6;
	Thu, 29 May 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n4Z9S1xb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8C525C810;
	Thu, 29 May 2025 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497462; cv=none; b=QyU5lFXINSHRWJzaLmTFlj1WYpPHIG5gb22aqjbOVGHgr1ssK8y/d3C3L0yWrCURDbgIYpaPbTchphZs5HQLP3WxboE4JXZAPLSFU7QUKjfJNjbjcPM8xC/eoVkdiMgYOdAN7F2A9KCPbs4lFe7G8tatgubx71rJvTHDpFMXQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497462; c=relaxed/simple;
	bh=GNv2RKvyaLb/r2umwW27kcjDvWo5+4A29CNU15DNhN4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oeICpq2wbIqFF51Q1pfFJgM3APuqA5TYoHt4huiBUl0Fg3aR3OtibriScf9aZ+RN6Bz4Tvfx2eW+Cnp3Jv0oOk/zs5OBdEmT3CBdPcm04IIfIn9fNbaXfEiXFqXtKxR5ZxkCK26a65BBxSg5zYfzqDKJYe75bzweJ64gnZZ4D4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n4Z9S1xb; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497461; x=1780033461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GNv2RKvyaLb/r2umwW27kcjDvWo5+4A29CNU15DNhN4=;
  b=n4Z9S1xbC5UVNafwcIjCmTurEZmBmQT9Q2KpiDnelP543rTul9o6SylZ
   FnLF2QJ4XRiXMB1K417aQKMWkOnI7vwAicjq5q2NgFTEavIpZqN4xoX7H
   OYPNDs3NeyQXeOpGM+azGzNwxVUDxwKIpz9s/1jeZks0S/aDeORioJMLQ
   OUuLxXe7sHwU62X4HNCG/NYi6hp+IXjo4UA/KSmfvoRP4RcPkwHNFowMN
   TN9/+fbh7IEtO8Hp3Zz2KkqURNBWEl/FHhhSII60dAw3lRzV4ImX5suie
   8seai7On5v3s4fmNRqtVqPrjpQgdu3J0uaPY3iyy6DB0/F79DaSvbf7I/
   A==;
X-CSE-ConnectionGUID: Wsrj88lLTDOtKTqJq0JFTg==
X-CSE-MsgGUID: IvKLWjUcQLSiraKepPJ3LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963396"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963396"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:44:21 -0700
X-CSE-ConnectionGUID: uG+vLF2RRoeXmzPQgvbfyA==
X-CSE-MsgGUID: r//6m1aFQ+ylGKPz+nsRXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443620"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:44:14 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 25/30] coco/tdx_tsm: Add connect()/disconnect() handlers prototype
Date: Thu, 29 May 2025 13:35:08 +0800
Message-Id: <20250529053513.1592088-26-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wu Hao <hao.wu@intel.com>

Add basic skeleton for connect()/disconnect() handlers. The major steps
are SPDM setup first and then IDE selective stream setup.

No detailed TDX Connect implementation.

Signed-off-by: Wu Hao <hao.wu@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/virt/coco/host/tdx_tsm.c | 55 +++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/host/tdx_tsm.c b/drivers/virt/coco/host/tdx_tsm.c
index 72f3705fe7bb..d1a8384d8339 100644
--- a/drivers/virt/coco/host/tdx_tsm.c
+++ b/drivers/virt/coco/host/tdx_tsm.c
@@ -79,13 +79,66 @@ static int tdx_tsm_guest_req(struct pci_dev *pdev,
 	return -ENXIO;
 }
 
+static int tdx_tsm_spdm_session_setup(struct tdx_tsm *ttsm)
+{
+	return 0;
+}
+
+static int tdx_tsm_spdm_session_teardown(struct tdx_tsm *ttsm)
+{
+	return 0;
+}
+
+static int tdx_tsm_ide_stream_setup(struct tdx_tsm *ttsm)
+{
+	return 0;
+}
+
+static int tdx_tsm_ide_stream_teardown(struct tdx_tsm *ttsm)
+{
+	return 0;
+}
+
 static int tdx_tsm_connect(struct pci_dev *pdev)
 {
-	return -ENXIO;
+	struct tdx_tsm *ttsm = to_tdx_tsm(pdev->tsm);
+	int ret;
+
+	ret = tdx_tsm_spdm_session_setup(ttsm);
+	if (ret) {
+		pci_err(pdev, "fail to setup spdm session\n");
+		return ret;
+	}
+
+	ret = tdx_tsm_ide_stream_setup(ttsm);
+	if (ret) {
+		pci_err(pdev, "fail to setup ide stream\n");
+		tdx_tsm_spdm_session_teardown(ttsm);
+		return ret;
+	}
+
+	pci_dbg(pdev, "%s complete\n", __func__);
+	return ret;
 }
 
 static void tdx_tsm_disconnect(struct pci_dev *pdev)
 {
+	struct tdx_tsm *ttsm = to_tdx_tsm(pdev->tsm);
+	int ret;
+
+	ret = tdx_tsm_ide_stream_teardown(ttsm);
+	if (ret) {
+		pci_err(pdev, "fail to teardown ide stream\n");
+		return;
+	}
+
+	ret = tdx_tsm_spdm_session_teardown(ttsm);
+	if (ret) {
+		pci_err(pdev, "fail to teadown spdm session\n");
+		return;
+	}
+
+	pci_dbg(pdev, "%s complete\n", __func__);
 }
 
 static struct pci_tsm *tdx_tsm_pci_probe(struct pci_dev *pdev)
-- 
2.25.1



Return-Path: <kvm+bounces-47957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8037AC7861
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB6681C07495
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BEA26D4CF;
	Thu, 29 May 2025 05:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbQYNb4j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767622566E7;
	Thu, 29 May 2025 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497468; cv=none; b=XaEgJeyrQAt0n8cRzFGmE+/3ZbztfggpbgE5EaiIy03PGVUBEFbB2Lz8/g4BBAU+KvlCJtDnnYGXzsml7Wj33Gn3jxLuL9AE3uamfC7tj8I1iYBbuhCI0uUQS00yU3zQ3FMiBlTzo+9Rm2GTQu8TLz/TcOc16OdOhConL5r3RNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497468; c=relaxed/simple;
	bh=s+Og/7//HP2ImpOPljrHL/2A9Bv5uMTbEhhPjy/aPyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZoKb5CPtGzjWIFWGqmsW9rU+5Z1N4W5C77D8Tk8z37b5eRF79FFLIDLnwvvIt6k6m0KZW6Tbd5zRMtqAqAj49kVnjRI/CIu7ue9Nk76OReiOrQpFeUdeJIrgTQa5/L21M7Il0EW/lJrXKwqnOrRo6OmCH8pS8ablhewK3qbQ/wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbQYNb4j; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497468; x=1780033468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s+Og/7//HP2ImpOPljrHL/2A9Bv5uMTbEhhPjy/aPyo=;
  b=lbQYNb4jC1txl8eXLp75ILHeE5A7bgdTFv1u2Kxxli/sS7piieZxh2kX
   rbvgyQgkvxq7OP2pB0OM4wLJn/kPacnOP+g9cpJg153VWN/MknTM/o5bO
   V9rvwijMiXJ9clXKWRpRNqKAnfg0jreU9pGlZl4TAWdiC/EzQKqUqGkkB
   MPp1Zt3V+ZzJ7ZXkA54hoMGonOOsucgXxDSkamARKeKqpjM6OQ1afFpNE
   jx1H91q47a22HVBjSTk8XfRDpxGxNNxrXKbtUokH8yjIJKkjxnW2LPVD7
   +JZwx3woGFWsQqWjpwCisIZb0lx9+WnnIb3cBWYdjW1tmOoO8mg5EwVSC
   w==;
X-CSE-ConnectionGUID: 5QKp1vZ6ReSqabGTt8veWQ==
X-CSE-MsgGUID: m8ZkUyFNT7GRNsrp30ByKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963417"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963417"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:44:27 -0700
X-CSE-ConnectionGUID: Qm3Lbc/QRMGZMhshJ4HxFA==
X-CSE-MsgGUID: pJCuEKEIR1+XYLHUM/QRBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443629"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:44:20 -0700
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
Subject: [RFC PATCH 26/30] coco/tdx_tsm: Add bind()/unbind()/guest_req() handlers prototype
Date: Thu, 29 May 2025 13:35:09 +0800
Message-Id: <20250529053513.1592088-27-yilun.xu@linux.intel.com>
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

Add basic skeleton for bind()/unbind()/guest_req() handlers.

Specifically, tdx_tdi_devifmt/devif_create() declare the TDI ownership
to TD. tdx_tdi_mmiomt_create() declares the MMIO ownership to TD.
tdx_tdi_request(TDX_TDI_REQ_BIND) locks the TDI.

No detailed TDX Connect implementation.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/virt/coco/host/tdx_tsm.c | 83 ++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/coco/host/tdx_tsm.c b/drivers/virt/coco/host/tdx_tsm.c
index d1a8384d8339..beb65f45b478 100644
--- a/drivers/virt/coco/host/tdx_tsm.c
+++ b/drivers/virt/coco/host/tdx_tsm.c
@@ -44,10 +44,49 @@ static struct tdx_tdi *to_tdx_tdi(struct pci_tdi *tdi)
 	return container_of(tdi, struct tdx_tdi, tdi);
 }
 
+static int tdx_tdi_devifmt_create(struct tdx_tdi *ttdi)
+{
+	return 0;
+}
+
+static void tdx_tdi_devifmt_free(struct tdx_tdi *ttdi)
+{
+}
+
+static int tdx_tdi_mmiomt_create(struct tdx_tdi *ttdi)
+{
+	return 0;
+}
+
+static void tdx_tdi_mmiomt_free(struct tdx_tdi *ttdi)
+{
+}
+
+static int tdx_tdi_devif_create(struct tdx_tdi *ttdi)
+{
+	return 0;
+}
+
+static void tdx_tdi_devif_free(struct tdx_tdi *ttdi)
+{
+}
+
+#define TDX_TDI_REQ_BIND	1
+#define TDX_TDI_REQ_START	2
+#define TDX_TDI_REQ_GET_STATE	3
+#define TDX_TDI_REQ_STOP	4
+
+static int tdx_tdi_request(struct tdx_tdi *ttdi, unsigned int req)
+{
+	return 0;
+}
+
 static struct pci_tdi *tdx_tsm_bind(struct pci_dev *pdev,
 				    struct pci_dev *dsm_dev,
 				    struct kvm *kvm, u64 tdi_id)
 {
+	int ret;
+
 	struct tdx_tdi *ttdi __free(kfree) =
 		kzalloc(sizeof(*ttdi), GFP_KERNEL);
 	if (!ttdi)
@@ -58,17 +97,55 @@ static struct pci_tdi *tdx_tsm_bind(struct pci_dev *pdev,
 	ttdi->tdi.dsm_dev = pci_dev_get(dsm_dev);
 	ttdi->tdi.kvm = kvm;
 
-	/*TODO: TDX Module required operations */
+	ret = tdx_tdi_devifmt_create(ttdi);
+	if (ret) {
+		pci_err(pdev, "fail to init devifmt\n");
+		goto put_dsm_dev;
+	}
+
+	ret = tdx_tdi_devif_create(ttdi);
+	if (ret) {
+		pci_err(pdev, "%s fail to init devif\n", __func__);
+		goto devifmt_free;
+	}
+
+	ret = tdx_tdi_mmiomt_create(ttdi);
+	if (ret) {
+		pci_err(pdev, "%s fail to create mmiomt\n", __func__);
+		goto devif_free;
+	}
+
+	ret = tdx_tdi_request(ttdi, TDX_TDI_REQ_BIND);
+	if (ret) {
+		pci_err(pdev, "%s fial to request bind\n", __func__);
+		goto mmiomt_free;
+	}
 
 	return &no_free_ptr(ttdi)->tdi;
+
+mmiomt_free:
+	tdx_tdi_mmiomt_free(ttdi);
+devif_free:
+	tdx_tdi_devif_free(ttdi);
+devifmt_free:
+	tdx_tdi_devifmt_free(ttdi);
+put_dsm_dev:
+	pci_dev_put(dsm_dev);
+	return NULL;
 }
 
 static void tdx_tsm_unbind(struct pci_tdi *tdi)
 {
 	struct tdx_tdi *ttdi = to_tdx_tdi(tdi);
 
-	/*TODO: TDX Module required operations */
-
+	/*
+	 * TODO: In fact devif cannot be freed before TDI's private MMIOs and
+	 * private DMA are unmapped. Will handle this restriction later.
+	 */
+	tdx_tdi_request(ttdi, TDX_TDI_REQ_STOP);
+	tdx_tdi_mmiomt_free(ttdi);
+	tdx_tdi_devif_free(ttdi);
+	tdx_tdi_devifmt_free(ttdi);
 	pci_dev_put(ttdi->tdi.dsm_dev);
 	kfree(ttdi);
 }
-- 
2.25.1



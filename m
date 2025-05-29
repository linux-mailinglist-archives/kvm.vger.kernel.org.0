Return-Path: <kvm+bounces-47961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6557DAC7872
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C91E1C22F4D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D97A25CC6E;
	Thu, 29 May 2025 05:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IYcaHTjF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB425CC72;
	Thu, 29 May 2025 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497494; cv=none; b=ie2QsBDi19K/kcN3OcmHcw7bG6sU+xGXyeYgwsfYObjCQWWQNzGKRUrNEPFdzWUjg+hu0hI2aAG3NKSekBkpHZrxZ3s/PI8TulcwndhAnGZKim/TxF1LF/SvUrIrMy6/rMu42kk3EZ2I2zi8un+jETVn2RlJlgrMAjLZiOks+xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497494; c=relaxed/simple;
	bh=JfSkXN7VFQD0j241YOoerWnrQ3UAC5/O1OD0Wg9yzYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=me0yBMz4fFfmOplXQoK3IcDoHR8zZnfVt1kLh1NwMga40z+BWAn/DeT9XhcArkx3/d2z848EY0W+WNHf3o1ZOI6nG7LU66ntXsjxVxWfiCeh3fs1nGtUFTJphEcjljbDbEAojUdls4hd7oL6wWTgz6MN1cTCFNZeTor/39wngtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IYcaHTjF; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497493; x=1780033493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JfSkXN7VFQD0j241YOoerWnrQ3UAC5/O1OD0Wg9yzYc=;
  b=IYcaHTjFZV2uxjMVwYXZ5cWhaJdl3ZM4xwOaYUMZMdA+FTpAgc/3rIEr
   w8/p2EV4MdzqiUo0X9bg+jZyKjnZI4L/3DOIRjuBhTBEf9bv7Hee1kNe2
   l62zcpNIc5dT5g5VapXycq7aYDoKc9avZFhLTa5VsdPDqdEizkWP4cBTm
   zCVaseZMGf5VYZGZoEj2VH6g1Um3oaLBeYYuvGPMCXzxg/iIPF1X2EcC7
   YTtI62GleFp1iv2Oi6q5t9iYZPv7HAeWQ/kTjHp5FCldpX4rhBrV7+8DL
   igyDdGwoX86wLDw3oKY+qUkcaOAOhkgGl4MVF5Zxtc8sR+C9wGBDI32uX
   w==;
X-CSE-ConnectionGUID: PcBxA5VXS4mZ4qHUrZvi8w==
X-CSE-MsgGUID: 1VeWn4CeT5GikANEUk//3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963526"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963526"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:44:53 -0700
X-CSE-ConnectionGUID: VpISARUySKWDHRrKuSvNOg==
X-CSE-MsgGUID: opx6ComdRiCGYPBNIKpm/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443716"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:44:46 -0700
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
Subject: [RFC PATCH 30/30] coco/tdx_tsm: Manage TDX Module enforced operation sequences for Unbind
Date: Thu, 29 May 2025 13:35:13 +0800
Message-Id: <20250529053513.1592088-31-yilun.xu@linux.intel.com>
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

Implement TDX Connect enforced sequences for TSM unbind. The enforced
sequences are:

  1. STOP TDI via TDISP message STOP_INTERFACE
  2. Private MMIO unmap from Secure EPT
  3. Trusted Device Context Table cleanup for the TDI
  4. TDI ownership reclaim and metadata free

Step 2 is the responsibility of KVM, step 3 is for IOMMU driver. So
TDX TSM driver needs to invoke TSM handlers for external collaboration.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/virt/coco/host/tdx_tsm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/host/tdx_tsm.c b/drivers/virt/coco/host/tdx_tsm.c
index beb65f45b478..66d6019812ca 100644
--- a/drivers/virt/coco/host/tdx_tsm.c
+++ b/drivers/virt/coco/host/tdx_tsm.c
@@ -87,6 +87,15 @@ static struct pci_tdi *tdx_tsm_bind(struct pci_dev *pdev,
 {
 	int ret;
 
+	if (!pdev->trusted_dma_owner ||
+	    !pdev->driver->tsm_handler ||
+	    !pdev->driver->tsm_handler->disable_mmio ||
+	    !pdev->driver->tsm_handler->recover_mmio ||
+	    !pdev->driver->tsm_handler->disable_trusted_dma) {
+		pci_err(pdev, "%s no driver or driver not support bind\n", __func__);
+		return NULL;
+	}
+
 	struct tdx_tdi *ttdi __free(kfree) =
 		kzalloc(sizeof(*ttdi), GFP_KERNEL);
 	if (!ttdi)
@@ -137,15 +146,15 @@ static struct pci_tdi *tdx_tsm_bind(struct pci_dev *pdev,
 static void tdx_tsm_unbind(struct pci_tdi *tdi)
 {
 	struct tdx_tdi *ttdi = to_tdx_tdi(tdi);
+	struct pci_dev *pdev = tdi->pdev;
 
-	/*
-	 * TODO: In fact devif cannot be freed before TDI's private MMIOs and
-	 * private DMA are unmapped. Will handle this restriction later.
-	 */
 	tdx_tdi_request(ttdi, TDX_TDI_REQ_STOP);
+	pdev->driver->tsm_handler->disable_mmio(pdev);
+	pdev->driver->tsm_handler->disable_trusted_dma(pdev);
 	tdx_tdi_mmiomt_free(ttdi);
 	tdx_tdi_devif_free(ttdi);
 	tdx_tdi_devifmt_free(ttdi);
+	pdev->driver->tsm_handler->recover_mmio(pdev);
 	pci_dev_put(ttdi->tdi.dsm_dev);
 	kfree(ttdi);
 }
-- 
2.25.1



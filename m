Return-Path: <kvm+bounces-63312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C4922C621CD
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 643E535C014
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A8026F289;
	Mon, 17 Nov 2025 02:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Id5s7XlG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ADB26E6F6;
	Mon, 17 Nov 2025 02:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347120; cv=none; b=DqgwdWalzLRS0qOLjgHk+gx99Y4fR4x1eHO0h3WBi/wGUtGXp1ge2Ps3/5vKAQtn0Dl1ARyH/ftusDvZQzhOHQKNEb9ryVPxRNLviQfN31fery8IuTHlw+1otfUMgHI+qtuua9Wv1rmgohSufKWXl5Xyfx3/L/cFcWwbzqPMDJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347120; c=relaxed/simple;
	bh=Ukvo5fXxaMmqG2S/FiToJVlF+feB7VsXyz40jCz8Fq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1ETFFBtSDrcYJIFzQlBXZmdmf4rOZtUTfbZCM7ZITgkgRbzuolwIv9VDl8vg773fnhvwmyeTNta1lHvpcbRpqhKAA+d/QtbQBUxJRNZh6F+BkXJiRXIgRgOsgQHxDYX9+SBG1kGVIuCoT4FurrkNlS6QaECZ7AR1ZDCd2MDQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Id5s7XlG; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347120; x=1794883120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ukvo5fXxaMmqG2S/FiToJVlF+feB7VsXyz40jCz8Fq0=;
  b=Id5s7XlGizbV7fEGRrwvdMbaiCcwIMR2nyIScsZ3XhSxl+NVFiiPT4Fu
   pd+bHnPVrmgqnigeTFkNb3nR4D0dTnnvIOEtigBQZgqNZFcjxSd+r4JCu
   TgwIrdLghAjU3K/mdyo5zX7ycnDk2GFJV0ykhayqUogOFzUfWhmdlfW8t
   yrmd1ynyULevnMs/zdxQ8zOCSmm0qPaDZIm+p0wu2tqTk2gy2phf1gMbX
   fW6bEDhxIxKqDXyTeuNkfTMvRoH+PTFEd58RtKf3lFMP7FbPDJLcaWNIi
   2QFKmhT8xHzffFteKQ95XhstffiF32i6xZ+LtH9wbvNBkt1zSijdlMUOG
   g==;
X-CSE-ConnectionGUID: 7dr7AX3iSy+USz3CUAJxjg==
X-CSE-MsgGUID: 8UcpqADiSXCXYxdPhM0Fhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729544"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729544"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:39 -0800
X-CSE-ConnectionGUID: PKdhenjrQaO/RjR88jPYqQ==
X-CSE-MsgGUID: wPHz3SLXTdig6IFG82WY1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658292"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:35 -0800
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
Subject: [PATCH v1 12/26] iommu/vt-d: Reserve the MSB domain ID bit for the TDX module
Date: Mon, 17 Nov 2025 10:22:56 +0800
Message-Id: <20251117022311.2443900-13-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

The Intel TDX Connect Architecture Specification defines some enhancements
for the VT-d architecture to introduce IOMMU support for TEE-IO requests.
Section 2.2, 'Trusted DMA' states that:

"I/O TLB and DID Isolation – When IOMMU is enabled to support TDX
Connect, the IOMMU restricts the VMM’s DID setting, reserving the MSB bit
for the TDX module. The TDX module always sets this reserved bit on the
trusted DMA table. IOMMU tags IOTLB, PASID cache, and context entries to
indicate whether they were created from TEE-IO transactions, ensuring
isolation between TEE and non-TEE requests in translation caches."

Reserve the MSB in the domain ID for the TDX module's use if the
enhancement is required, which is detected if the ECAP.TDXCS bit in the
VT-d extended capability register is set and the TVM Usable field of the
ACPI KEYP table is set.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.h |  1 +
 drivers/iommu/intel/dmar.c  | 52 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 66c3aa549fd4..836777d7645d 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -192,6 +192,7 @@
  */
 
 #define ecap_pms(e)		(((e) >> 51) & 0x1)
+#define ecap_tdxc(e)		(((e) >> 50) & 0x1)
 #define ecap_rps(e)		(((e) >> 49) & 0x1)
 #define ecap_smpwc(e)		(((e) >> 48) & 0x1)
 #define ecap_flts(e)		(((e) >> 47) & 0x1)
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index a54934c0536f..e9d65b26ad64 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1033,6 +1033,56 @@ static int map_iommu(struct intel_iommu *iommu, struct dmar_drhd_unit *drhd)
 	return err;
 }
 
+static int keyp_config_unit_tvm_usable(union acpi_subtable_headers *header,
+				       void *arg, const unsigned long end)
+{
+	struct acpi_keyp_config_unit *acpi_cu =
+		(struct acpi_keyp_config_unit *)&header->keyp;
+	int *tvm_usable = arg;
+
+	if (acpi_cu->flags & ACPI_KEYP_F_TVM_USABLE)
+		*tvm_usable = true;
+
+	return 0;
+}
+
+static bool platform_is_tdxc_enhanced(void)
+{
+	static int tvm_usable = -1;
+	int ret;
+
+	/* only need to parse once */
+	if (tvm_usable != -1)
+		return tvm_usable;
+
+	tvm_usable = false;
+	ret = acpi_table_parse_keyp(ACPI_KEYP_TYPE_CONFIG_UNIT,
+				    keyp_config_unit_tvm_usable, &tvm_usable);
+	if (ret < 0)
+		tvm_usable = false;
+
+	return tvm_usable;
+}
+
+static unsigned long iommu_max_domain_id(struct intel_iommu *iommu)
+{
+	unsigned long ndoms = cap_ndoms(iommu->cap);
+
+	/*
+	 * Intel TDX Connect Architecture Specification, Section 2.2 Trusted DMA
+	 *
+	 * When IOMMU is enabled to support TDX Connect, the IOMMU restricts
+	 * the VMM’s DID setting, reserving the MSB bit for the TDX module. The
+	 * TDX module always sets this reserved bit on the trusted DMA table.
+	 */
+	if (ecap_tdxc(iommu->ecap) && platform_is_tdxc_enhanced()) {
+		pr_info_once("Most Significant Bit of domain ID reserved.\n");
+		return ndoms >> 1;
+	}
+
+	return ndoms;
+}
+
 static int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
@@ -1099,7 +1149,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	spin_lock_init(&iommu->lock);
 	ida_init(&iommu->domain_ida);
 	mutex_init(&iommu->did_lock);
-	iommu->max_domain_id = cap_ndoms(iommu->cap);
+	iommu->max_domain_id = iommu_max_domain_id(iommu);
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
 	pr_info("%s: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
-- 
2.25.1



Return-Path: <kvm+bounces-65566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6A4CB0A43
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5FAE2302AF16
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0C432E68E;
	Tue,  9 Dec 2025 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZPM/3mJh"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3968732AAA9;
	Tue,  9 Dec 2025 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299142; cv=fail; b=lDDKU2Hgx9Y8jEKwgLOkJLIJzrDiQxypLuI2KOURBkEX+c2+NNxFsmihg2jUX22JBrSHvZyrLmrMK0m9FgOn1NzYqzfnV1vuG/5ITeaSV8fk5tGdrshuumAbxaj9HaRIlkbkP3A4sfLYnw0KJ4vwh4A1EkNnH05B2fPNC/k8pPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299142; c=relaxed/simple;
	bh=V01VIXclixPpIeGfeixd8RCXc5VjsPNTX2zIGtE9Br0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=twincC+886pHvoVZA1k9Si6jYjOajNUJINzbVBkq/L9o5V90yPa0GwchCrNA1QFmjoSYHsAV/9Z4TJyacJ7wlx7nR5KvuuWaowz3WSI1/6MD22yzZEYVk5sjqqIy4YR4O1NaASLUrnXsXLOLnC1F+QOkJ0zonzuli9hxsaEdmQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZPM/3mJh; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHsI1W5JAQX2sWk9e3/ZTzWFXehvU9UTJhAObURMB8GAoc03VvsjEYhNMwTQXE34AKzIK2HTPxbJMIaxtpjIrYrtXjNjXfhuhAUn1nLfyDGfyxpBu1BXke2qONUdxLP6gL0mhAjeKBRTxPECdirOdzpZ720iV5FsfePsCByiT5YjBDAiFoaTSw3MHensVhodqzvp2gg6Rqs/YjYkJ/occt9YR8pmFTFoVETekQqUf6J9r8VQVTsK9ypMD/M3BNFN8vRMHdooUw8O5dnORWyOfvcYJUpVMmUxkvBaaaDnLALj+7N0zKlukO6VePl8PEX8jKOyMNhJnPtfHGZ8g/ZSlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+9gIC2Cm69KDeJdD63DRf5hoLwQO/+SRZhfxBse9gI=;
 b=FWoJ/+k9xopPuafNDQE+omiEBniYmUGqFnBrY/RxAJ4kV1gRWZzpr/GnTHeDkaBryUZlqbSYsDdsRGVw1fRIahGaKRyuPisABAYKvNvD2LDG9ct80i7HVyyfPR+Qq4M22oJt+IpNv29yrkGHOEiQw6bpeWlDhlMZvrJQ5QkGtcNrMC/HHaXAYOBz52w8a0QHoZcg/qFLHmAs5IyANtzvKp4obHE1kSXSi1BqWpmmadcZP/9TkwpngRXzRre3rIexu7mFc8aDU6ZUoNBAU+jSci+Eeth0InB8oi0vOq0ow8f6h+AEI+dCZSwsON3En0H9OJdfHaj9nOb4sI+wubW4vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+9gIC2Cm69KDeJdD63DRf5hoLwQO/+SRZhfxBse9gI=;
 b=ZPM/3mJh+q7ZrNRQts7+UlI863Z3IG0oAKSJWZlay7Fm9ovVUSE02fdJB4CeYpAHNIc8s2CLA0U1tLZSj1avjmiELABWLwFFz8/lTmSJaOfID/bfXvmV6KU6O3uzC6fupzvRCNcP3qdOdCbp+7UlpvgiZ6V1CMLoqUreIlEtcI6arCiGv9wC5txIvuE69k0QeTEp72/xLajKmuX1Y91dmtyCbbWbU31XRs3AMI1Hd75IK/O6e7+G2db0Yu56guBUqSaiQNhPhykNx90tX3SLKG9+A6fbvVhMMWTADw8GjcxkllUdy5obGo7k49bS5lZDctIQZdgGwKdtn9awBi0VgQ==
Received: from BN0PR08CA0016.namprd08.prod.outlook.com (2603:10b6:408:142::35)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 16:52:15 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::33) by BN0PR08CA0016.outlook.office365.com
 (2603:10b6:408:142::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.7 via Frontend Transport; Tue, 9
 Dec 2025 16:52:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:50 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:49 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:42 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 08/15] vfio/cxl: discover precommitted CXL region
Date: Tue, 9 Dec 2025 22:20:12 +0530
Message-ID: <20251209165019.2643142-9-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: a66f9e66-b26d-46b4-8963-08de37434ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Kwu0DCdfZaHk2xKVmIetWPTQQm4W/HdgtU6nf9L+yjkp9HKIGmIiZM7TnDe?=
 =?us-ascii?Q?XFfW0k3u/p7hnKmmDBOStHW6aGBEZZ7wHRaSlM+OLlp4ouWpAHYcgY3MladO?=
 =?us-ascii?Q?+4tAU3bXWh6mEZcyhPu/EZQyYNOfPMHfUtUGz/vMZApivlvh9Qj3ye1dLYiY?=
 =?us-ascii?Q?4hkp7RG917MRk9R7YenEljPlphd+5HJe1hnFj7luxTv0v/L0IXdw909K4q4L?=
 =?us-ascii?Q?K0BfKt1m0eqq+jwgIYk145Wl4rgsGUQtiaXQYJlJ9vGTpPneQ64X3bmtxAd/?=
 =?us-ascii?Q?5qRSMDgb++yJ9zSlaYorQro067JcuCbMtyJWX5YO0IR0rU50Xwzjj/lrv4Xh?=
 =?us-ascii?Q?blznRiDrPM3tovu/9a5Iu0bRukwpzIDz+FISjvUo4UnhpiZrQJ9oSaPTcsS1?=
 =?us-ascii?Q?t2Y9Csy3f3kg45dM35BKrTVvGxS7+OkDsc8l5Kt9oZYGqPDnaEAqBnp0ZQeW?=
 =?us-ascii?Q?hGH3PDJUY6kTWsYbmNIWhayaY9ZR5M5hN5DEZYxiWyI41ubu0W/L9HDoCc3N?=
 =?us-ascii?Q?NsUY2zQTHJjG3g13S4b3a+tqsOnwsxlFFovmpFg7Uj9DEO8zUjbaFgr7ygpA?=
 =?us-ascii?Q?0zlgny9H+jqSwzIvbjyDIFlkpX3vytAeJiyHyH6MYs+c6OKgAuh3ZlA4eM7z?=
 =?us-ascii?Q?WqvmQQ7RZgZ55+TXVwVg0iWdnnr8cK2wJEmX6Y83Lx4NMo2d1hUEpNQDa3kp?=
 =?us-ascii?Q?/3Pj+tTD+tEfOxP8CvDbSAHIbTzBZfPXuvC9+ksE5p7txuUI1nXRQfjRbPcJ?=
 =?us-ascii?Q?wTt8hqV8ZmxWMornmttpt1OJ/YC6WMGvxZY74GxfgqtJb0J1FOgHDOt9mVmD?=
 =?us-ascii?Q?7AoptR6UjjZ+oz5FfXJO3xCt53wzWC5wWT64FdIm9Ky6LtD/3tgsIlb6UPGr?=
 =?us-ascii?Q?dJJjn69qgGsvwfYG53L6dcGsFkdC59j1nyBZ2JEnJ7ofNlfncH6rON19SaRo?=
 =?us-ascii?Q?gErF9sHq0F3i2VXFvE7/0EojnZWKhIRkkoAHbwwttvxyGkusijx2uo6mEIzj?=
 =?us-ascii?Q?aS8dC0dPdyTCVtK/ukDnyOrXAIO+hqs3N/Fgw+bdvUgP6C9+/R96b7Xmgdyz?=
 =?us-ascii?Q?26jFiOgTUJAppUkpmN38BV07xFZB1cZmqPQDla3CDn739c6Od/c1bWmJWKYZ?=
 =?us-ascii?Q?Gq+bzNajUrglK02GoZviYwJ3m6o0tkSaClVTeTIKKPi1b+a7paPaCWcopKeB?=
 =?us-ascii?Q?YJPXpbSfk/rEMQGwuvdSWzkn0CRFaJZU9iGbmbd6r3Dl9fx+qguY8/nVBbyi?=
 =?us-ascii?Q?6+Axuw2ecMD9IrJCB+agqiLA1zbntIeGx+zf9NMsOOfCaajnfVwahLnNulOa?=
 =?us-ascii?Q?T80gv5FAfYze3VQQlVxwaaGcNegLSoKwW/uLJwc+e480dEhNvGHwmKBsq8yb?=
 =?us-ascii?Q?WoxUHrVV/IgP+ZExKaVYu3TCYi6THYB6rQNv/kkzjL1W6N1XXI9z0mLUUvzU?=
 =?us-ascii?Q?mmd6IXM08m9NGzUKngYRjRVM7rft+DpqGtMzfh238kwzl9Rn6K3rzDxOBZVL?=
 =?us-ascii?Q?ndUp1JhXUldM3538bluBjiFc8LQQ9NNenG9MCFjjGoq4kjklj5xC6CRuqQqY?=
 =?us-ascii?Q?g7ORGoFeSMOi4bwYPcC6TWwYmo7quLTkI2IrTGlq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:15.2810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a66f9e66-b26d-46b4-8963-08de37434ea0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

From: Zhi Wang <zhiw@nvidia.com>

A type-2 device can have precommitted CXL region that is configured by
BIOS. Before letting a VFIO CXL variant driver create a new CXL region,
the VFIO CXL core first needs to discover the precommited CXL region.

Discover the precommited CXL region when enabling CXL devices.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 29 +++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index 35d95de47fa8..099d35866a39 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -82,11 +82,16 @@ static void disable_cxl(struct vfio_cxl_core_device *cxl)
 {
 	struct vfio_cxl *cxl_core = cxl->cxl_core;
 
-	WARN_ON(cxl_core->region.region);
-
 	if (!cxl->hdm_count)
 		return;
 
+	if (cxl_core->region.precommitted) {
+		kfree(cxl_core->region.region);
+		cxl_core->region.region = NULL;
+	}
+
+	WARN_ON(cxl_core->region.region);
+
 	if (cxl_core->cxled) {
 		cxl_decoder_detach(NULL, cxl_core->cxled, 0, DETACH_INVALIDATE);
 		cxl_dpa_free(cxl_core->cxled);
@@ -96,6 +101,24 @@ static void disable_cxl(struct vfio_cxl_core_device *cxl)
 		cxl_put_root_decoder(cxl_core->cxlrd);
 }
 
+static void discover_precommitted_region(struct vfio_cxl_core_device *cxl)
+{
+	struct cxl_region **cxlrs = NULL;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+	int num, ret;
+
+	ret = cxl_get_committed_regions(cxl_core->cxlmd, &cxlrs, &num);
+	if (ret || !cxlrs) {
+		kfree(cxlrs);
+		return;
+	}
+
+	WARN_ON(num > 1);
+
+	cxl_core->region.region = cxlrs[0];
+	cxl_core->region.precommitted = true;
+}
+
 int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 			 struct vfio_cxl_dev_info *info)
 {
@@ -126,6 +149,8 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 	if (ret)
 		goto err;
 
+	discover_precommitted_region(cxl);
+
 	return 0;
 
 err:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3474835f5d65..7237fcaecbb6 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -104,6 +104,7 @@ struct vfio_cxl_region {
 	u64 addr;
 	void *vaddr;
 	bool noncached;
+	bool precommitted;
 };
 
 struct vfio_cxl {
-- 
2.25.1



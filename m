Return-Path: <kvm+bounces-64274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF8EC7C243
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 03:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 069003608DC
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27AD2DECC5;
	Sat, 22 Nov 2025 01:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QLfNHyy/"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCEE2DAFB9;
	Sat, 22 Nov 2025 01:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776687; cv=fail; b=AsmP+KTpbVm5fURKX9Z9Cop8rxpgbQDI0u4dcJKwuGAg0zBYuY7qWMtWnJZwjJYf+KsfDkMDPMhlUwfVX6bKM6wD4oLLl2WOle/oT6WKtm77lzm1e+SQEQ28nnd0iguVuFk+X3nITj6dEa0Bl1TNE/Bnc65eN4X7pkT9u6vAanQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776687; c=relaxed/simple;
	bh=4wuHw2kyqu5XLIFw4TgRWDEpTPxvIn6sQRSJlDN/d/I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YpBMcDL/Hl1aPtpCjqE16yd2BZavxWRrYPQJVMpMPJVJ+nDxkSVJqca8cH6JKfe2fqzWYc96iOu4pLWWYn1p6zHqz1VbVNNNdQaFE+ObsREdVQE8C726U24zvpPKimtGRbKYLRTd8llTuLchlMMUMjpw1BvR33NoB7JGWydIc98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QLfNHyy/; arc=fail smtp.client-ip=52.101.61.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rd5V7oEpaPbClFfB4q3gN5lQX5pkUhTBLLeT5re25gJUOyI1CrJqp4+50K4NgiMf3WWo2hKqGECYcByz6ks8qBw+NYsAz/wj+DDRHeLq4Ia2hFyPEfhoAviKZPxTJV1kdzQVknAfPa9UvjDCTTeVwHQrGwet+j4RsZiYOa+1DXQBawvSw+h0gpoXj5OXUGju1ORyOrMdRLx0O9UAl5FDs76T6W5u5k6ioosb/D3Y037OSZ2DHW7hBtC3OY6UykMHJQxWybYB20YhWeUodLVI++LI2d5Q+WNtMqdFSceTx2btHQNaBTmOXBK6cFJ7nkm20yMjeMzBGVu8BAUGllXoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRoOiK9onYNU01HzF9z8mdfTYC7CpXYN3EiE/3I8Upw=;
 b=MiEdxWlrMCeqpKi5Flvz9ilPsJOcf0vKMr88a3HqC7ui/AyMXpb40BPr7oTLKxByEV/Z2DSilxOO3xvuwla4znn2WIpTW+qn2kJacoT3G4Np8uaV0Cnn8AvrixUUVzpqs97F9GojK3uq9IxFNJKRNl4PyWdCN1zyFVS7MyJIspDG0I67fRS8ovWq3felFND9Y1xG7ijw1QJcuTZrArPml3VRVYnut7VeQRf0JFQUNraDMWT+/DNXQPD0F5lFCnNCKAYiDz7viEfoK08+UCukgYhs6RVDeplbJKkBioiNE2IcZkSO2S3Yux2rEGEtFdS9ht9VCW65JaVKFTP8B54VMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRoOiK9onYNU01HzF9z8mdfTYC7CpXYN3EiE/3I8Upw=;
 b=QLfNHyy/+6WdIXOQJeu/iUdshlJklAqh+ImB7nhJ+Muovj4LNIiFWX9dk/x3iRVfr3CcadsoHLfna8up954a911Hner7DnIzHJbqoqCOx4haBCAeGNu9fWYSMc4rlNZux04zjJiXyr4qnqjQCOURel61M5Ht2akRzY9sy6VAFnx+utFIfSQb2SWr5ug9tJfCfuMjZOG/W5/0FzJmY3hm8nlp39zsVQkFUwuz46OVZdz/UqqjaJRJ4lf/ms/78Aiz5KlLIHPxDURGrucJgldmBtBIf1C8JxnvbGgdAUlJQNdP0Pu5Tno+DgV63V1pY0tY8oiCM7Ft8v+O4i7nIYX4Sw==
Received: from BLAPR03CA0081.namprd03.prod.outlook.com (2603:10b6:208:329::26)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 01:57:57 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:329:cafe::4c) by BLAPR03CA0081.outlook.office365.com
 (2603:10b6:208:329::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Sat,
 22 Nov 2025 01:57:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:57:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:49 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:48 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v7 4/5] iommu: Introduce pci_dev_reset_iommu_prepare/done()
Date: Fri, 21 Nov 2025 17:57:31 -0800
Message-ID: <31486e8017284e547b04d2be5110522a777d8379.1763775108.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|MW3PR12MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c84a73-576c-4830-c3f2-08de296a8ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6cUlPzKVtTbGPQoH7v6sVaXB6+iB308VhmKs282SpuNOGo1Dna4ycD8mbmLa?=
 =?us-ascii?Q?iR/YSXaNIcDOI9pBtE8YGpWeWvciFod1dFjWwgOda2GlSPgiqKQfZVkGNfIC?=
 =?us-ascii?Q?vp6JyalCggSt+NH9XSkOLHdAo4wSNIoEJgEHSDWjTOZ6Q0+T/rbKaFWBoh0A?=
 =?us-ascii?Q?3rRNm4M5fcfrf0o43zOzR3glUpzxCtKJ27FVGDj4fWAhP6jmkc3bNl+sedf1?=
 =?us-ascii?Q?9mj9sFCtIQ3RvUfVS/kwCtW6jHaoym8S6I15SsNA4+7nRdBrCWp2pgZBl6Uv?=
 =?us-ascii?Q?1lasmHloyIOA5WPgBCzi8qIG2PlhZTyke43Ge1HGAHrJhb8TmgOZDiastjJ3?=
 =?us-ascii?Q?GL2JY8+h7ea2Ghfvm45r5+DR/kyqJN6zvhD4V22HJGg6uP77tYT7DLnH4+zR?=
 =?us-ascii?Q?MiYyedz/ngTlRfBpYP3BrKGaQX6nOQHbpPo0xo9uqGFgkEe/PerJMP2z8Kd7?=
 =?us-ascii?Q?FtStI2qqFv4QzKxNISn41bRH2HxJCFG4LfieQiKZBOj4kjpmxSu9cwL2SPkq?=
 =?us-ascii?Q?qW0Aaja7zrGd0VXRqaFitreYA5hJ2OONHEBYjHO4nzDopjvOcqhhgVLfwTJk?=
 =?us-ascii?Q?JjW7q8qq0cbys6hj3IDQneT0yldd55q+DfWO5gWRho6Gac2nJl9loNJIWnRa?=
 =?us-ascii?Q?vA65/ljdZEdRnFVjJ422ukYsGh86ntYjINJe9m1HvTjlCplEYvwucWD+81V9?=
 =?us-ascii?Q?hblIidSNbqFTH0oscUAdIs2Y+243TaTJwTsVZezOvJDtOSPXFJQEmPM9Dgk9?=
 =?us-ascii?Q?cMbXtxxRaI954sQBfNTZLAPo1OEBzSnMusGDIC7qCth407+7IpfgU4Czr6xj?=
 =?us-ascii?Q?FgtRAdcRO0Vm6E83+Fvc2hWz/478XO+OdkosYD+Q9th4Q+w8x08rj9HpwxY/?=
 =?us-ascii?Q?pv5t6iI+ysJ4+aiRueF6IlGErFv54dXmlXpaIYffk4k4t97ke2ySI7MOdH3J?=
 =?us-ascii?Q?DojD+aw6oiPYCY8ru2mDISu7Z6ey/jZszxD00XJpXw0rJZJ91Dm/Kgk6zsDk?=
 =?us-ascii?Q?tQ8NN8ULjVuek/Okye8cGw0QeeidGkEh1jffiki34naVv46zDFTb5f3nB5VN?=
 =?us-ascii?Q?6VsIA6OYEVTwUrOXqNoyuPmcaNHZvxC/197xR7prRMZRVpUnpJBecw6srkEn?=
 =?us-ascii?Q?900+gS1GkHalQXmOrq3DApYJ7iNCDrehUOsuWfJsONhquEV49s3kgj0Ro+f8?=
 =?us-ascii?Q?4nMlyAbRRRlQZzda+z+/HZzrC5vPNquvnbRDYt0F3lRRhPyROhCQ/X3/cCxY?=
 =?us-ascii?Q?tvtJIBlR1hfE1MEJNUTZLi2W2SgY8tdLpfMF5b2FvAC8KnQmbX56zp/LDkY+?=
 =?us-ascii?Q?PBEG6HfQ9eJ1zuhgwSmarJpeBe3E/IwT5dH++sqkinwGsaE1VzoxQRTffjQq?=
 =?us-ascii?Q?kvhAB/hpeEB3nwA0x8gjmE6wom0CUlwcsuJ30iFyjyZdYrgE0V4Bt+DYpZQw?=
 =?us-ascii?Q?qJnAPp/yAC95yOEKBQvBQLDjBBSehXayDFarokqKHLPd3Juch2sZJ93yuOtu?=
 =?us-ascii?Q?c1EeXwn4msU7ekkI04zH1gqH2V6fgMUoPIB2sQysIbgHgCDeBHLWoHhX33xz?=
 =?us-ascii?Q?I1f5wEWAHEw0WgRgIlM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:57:57.2129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c84a73-576c-4830-c3f2-08de296a8ee4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491

PCIe permits a device to ignore ATS invalidation TLPs while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out. E.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The OS should do something to mitigate this as we do not want production
systems to be reporting critical ATS failures, especially in a hypervisor
environment. Broadly, OS could arrange to ignore the timeouts, block page
table mutations to prevent invalidations, or disable and block ATS.

The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Provide a callback from the PCI subsystem that will enclose the reset and
have the iommu core temporarily change all the attached RID/PASID domains
group->blocking_domain so that the IOMMU hardware would fence any incoming
ATS queries. And IOMMU drivers should also synchronously stop issuing new
ATS invalidations and wait for all ATS invalidations to complete. This can
avoid any ATS invaliation timeouts.

However, if there is a domain attachment/replacement happening during an
ongoing reset, ATS routines may be re-activated between the two function
calls. So, introduce a new resetting_domain in the iommu_group structure
to reject any concurrent attach_dev/set_dev_pasid call during a reset for
a concern of compatibility failure. Since this changes the behavior of an
attach operation, update the uAPI accordingly.

Note that there are two corner cases:
 1. Devices in the same iommu_group
    Since an attachment is always per iommu_group, this means that any
    sibling devices in the iommu_group cannot change domain, to prevent
    race conditions.
 2. An SR-IOV PF that is being reset while its VF is not
    In such case, the VF itself is already broken. So, there is no point
    in preventing PF from going through the iommu reset.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h     |  13 +++
 include/uapi/linux/vfio.h |   4 +
 drivers/iommu/iommu.c     | 173 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a42a2d1d7a0b7..3e10fce05b7e3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1186,6 +1186,10 @@ void iommu_detach_device_pasid(struct iommu_domain *domain,
 			       struct device *dev, ioasid_t pasid);
 ioasid_t iommu_alloc_global_pasid(struct device *dev);
 void iommu_free_global_pasid(ioasid_t pasid);
+
+/* PCI device reset functions */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev);
+void pci_dev_reset_iommu_done(struct pci_dev *pdev);
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1509,6 +1513,15 @@ static inline ioasid_t iommu_alloc_global_pasid(struct device *dev)
 }
 
 static inline void iommu_free_global_pasid(ioasid_t pasid) {}
+
+static inline int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
+{
+	return 0;
+}
+
+static inline void pci_dev_reset_iommu_done(struct pci_dev *pdev)
+{
+}
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009baf..4aee2af1b6cbe 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -963,6 +963,10 @@ struct vfio_device_bind_iommufd {
  * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
+ *
+ * When a device is resetting, -EBUSY will be returned to reject any concurrent
+ * attachment to the resetting device itself or any sibling device in the IOMMU
+ * group having the resetting device.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 672597100e9a0..0665dedd91b2d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -61,6 +61,11 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
+	/*
+	 * During a group device reset, @resetting_domain points to the physical
+	 * domain, while @domain points to the attached domain before the reset.
+	 */
+	struct iommu_domain *resetting_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
 	unsigned int owner_cnt;
@@ -2195,6 +2200,15 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 
 	guard(mutex)(&dev->iommu_group->mutex);
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 *
+	 * Note that this might fail the iommu_dma_map(). But there's nothing
+	 * more we can do here.
+	 */
+	if (dev->iommu_group->resetting_domain)
+		return -EBUSY;
 	return __iommu_attach_device(domain, dev, NULL);
 }
 
@@ -2253,6 +2267,17 @@ struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
 
 	lockdep_assert_held(&group->mutex);
 
+	/*
+	 * Driver handles the low-level __iommu_attach_device(), including the
+	 * one invoked by pci_dev_reset_iommu_done() re-attaching the device to
+	 * the cached group->domain. In this case, the driver must get the old
+	 * domain from group->resetting_domain rather than group->domain. This
+	 * prevents it from re-attaching the device from group->domain (old) to
+	 * group->domain (new).
+	 */
+	if (group->resetting_domain)
+		return group->resetting_domain;
+
 	return group->domain;
 }
 EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
@@ -2409,6 +2434,13 @@ static int __iommu_group_set_domain_internal(struct iommu_group *group,
 	if (WARN_ON(!new_domain))
 		return -EINVAL;
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain)
+		return -EBUSY;
+
 	/*
 	 * Changing the domain is done by calling attach_dev() on the new
 	 * domain. This switch does not have to be atomic and DMA can be
@@ -3527,6 +3559,16 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	for_each_group_device(group, device) {
 		/*
 		 * Skip PASID validation for devices without PASID support
@@ -3610,6 +3652,16 @@ int iommu_replace_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	entry = iommu_make_pasid_array_entry(domain, handle);
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL,
 			  XA_ZERO_ENTRY, GFP_KERNEL);
@@ -3867,6 +3919,127 @@ int iommu_replace_group_handle(struct iommu_group *group,
 }
 EXPORT_SYMBOL_NS_GPL(iommu_replace_group_handle, "IOMMUFD_INTERNAL");
 
+/**
+ * pci_dev_reset_iommu_prepare() - Block IOMMU to prepare for a PCI device reset
+ * @pdev: PCI device that is going to enter a reset routine
+ *
+ * The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and block
+ * ATS before initiating a reset. This means that a PCIe device during the reset
+ * routine wants to block any IOMMU activity: translation and ATS invalidation.
+ *
+ * This function attaches the device's RID/PASID(s) the group->blocking_domain,
+ * setting the group->resetting_domain. This allows the IOMMU driver pausing any
+ * IOMMU activity while leaving the group->domain pointer intact. Later when the
+ * reset is finished, pci_dev_reset_iommu_done() can restore everything.
+ *
+ * Caller must use pci_dev_reset_iommu_prepare() with pci_dev_reset_iommu_done()
+ * before/after the core-level reset routine, to unset the resetting_domain.
+ *
+ * Return: 0 on success or negative error code if the preparation failed.
+ *
+ * These two functions are designed to be used by PCI reset functions that would
+ * not invoke any racy iommu_release_device(), since PCI sysfs node gets removed
+ * before it notifies with a BUS_NOTIFY_REMOVED_DEVICE. When using them in other
+ * case, callers must ensure there will be no racy iommu_release_device() call,
+ * which otherwise would UAF the dev->iommu_group pointer.
+ */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+	int ret;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return 0;
+
+	guard(mutex)(&group->mutex);
+
+	/* Re-entry is not allowed */
+	if (WARN_ON(group->resetting_domain))
+		return -EBUSY;
+
+	ret = __iommu_group_alloc_blocking_domain(group);
+	if (ret)
+		return ret;
+
+	/* Stage RID domain at blocking_domain while retaining group->domain */
+	if (group->domain != group->blocking_domain) {
+		ret = __iommu_attach_device(group->blocking_domain, &pdev->dev,
+					    group->domain);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Stage PASID domains at blocking_domain while retaining pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		iommu_remove_dev_pasid(&pdev->dev, pasid,
+				       pasid_array_entry_to_domain(entry));
+
+	group->resetting_domain = group->blocking_domain;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_prepare);
+
+/**
+ * pci_dev_reset_iommu_done() - Restore IOMMU after a PCI device reset is done
+ * @pdev: PCI device that has finished a reset routine
+ *
+ * After a PCIe device finishes a reset routine, it wants to restore its IOMMU
+ * IOMMU activity, including new translation as well as cache invalidation, by
+ * re-attaching all RID/PASID of the device's back to the domains retained in
+ * the core-level structure.
+ *
+ * Caller must pair it with a successful pci_dev_reset_iommu_prepare().
+ *
+ * Note that, although unlikely, there is a risk that re-attaching domains might
+ * fail due to some unexpected happening like OOM.
+ */
+void pci_dev_reset_iommu_done(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return;
+
+	guard(mutex)(&group->mutex);
+
+	/* pci_dev_reset_iommu_prepare() was bypassed for the device */
+	if (!group->resetting_domain)
+		return;
+
+	/* pci_dev_reset_iommu_prepare() was not successfully called */
+	if (WARN_ON(!group->blocking_domain))
+		return;
+
+	/* Re-attach RID domain back to group->domain */
+	if (group->domain != group->blocking_domain) {
+		WARN_ON(__iommu_attach_device(group->domain, &pdev->dev,
+					      group->blocking_domain));
+	}
+
+	/*
+	 * Re-attach PASID domains back to the domains retained in pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		WARN_ON(__iommu_set_group_pasid(
+			pasid_array_entry_to_domain(entry), group, pasid,
+			group->blocking_domain));
+
+	group->resetting_domain = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_done);
+
 #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 /**
  * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
-- 
2.43.0



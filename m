Return-Path: <kvm+bounces-39396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C43A0A46C29
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA14616E020
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBE42755F8;
	Wed, 26 Feb 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sa3Q+Tnk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8475C2755E6;
	Wed, 26 Feb 2025 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601010; cv=fail; b=Vp/Qz2N37bb06AxtjpMJiJ8M2Xa2QxFhxVgJyDfdngA+S74sL3izb5KYFqm5vKVh4N2BS2SVt990y1ADdefi7roTeEIdHlKOM1jUwDp0TZFMqbFrx31uBTX61feQYVzLoFIjpgQ5OePi8NCrgJcPGImE6YvLonRrVsmijqdgUik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601010; c=relaxed/simple;
	bh=v0dEiL9W4EHUy6SsqACpJ7hGGdNzh5gnM69LTM2V9BM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QescsNeXvXrr//my9uua41OGNQR8LI97o/i90PNiZPM3EEOWKXSpDGWwU0+Xt7prOanUWgIRy3iIszWKQuyo1nK3+K+XyWoxy8WGIb36Cb2qczwIa+IIh+ClGdL3fVWnIaPKZVzpbv/a5uEnZdG8FCiLhk8LZIEraI1uan0UnWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sa3Q+Tnk; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F1v2mnr3hv5K8azYey/iooS74CqdmXfidcYzqFKyD3uWDZLG6ruLuWh+XQJAjNVH3KMxOPBQ3PIsPivQDe0/V4fz8BzOk07dooks+3/1q71RFejP8JAiHqNlwaT2iP2JezchZsTiXZAPX7mH4Y36nNlvNY2AWRoNI9hQRgXfo8JBoIRY9A6Uzx7COrJMIau7H9ezFkWDqFo5cBnLXrP8/Zn3ne/K0cxNnN5dauGaG7rxGkxsyWdtQd5vTBCbA3tJIhUGWkbn0LlNVyk1mzepj6qiuA4/jQklhpkeCYYrCyBGV/jyg4a+id6M4g/x6oEQfw2APrOHEPHF8OuDFKm52w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MngNtYssMATfkV/OMS1fcH+ZW3izS1pOJC9F9pCueG0=;
 b=tg//GG839dlxoRfexQOC6oKU7AgBFvN9YNNPih9BqWclALg08oGVFHdBreCt1AU/I1tPWQBbLTYGMh623izKxkiku9TofvebmNiIcX8y9xpOPgi8CXQrW4WK4IuXGtH3/SFrh7q6ChTMbDpVTa59G/bnHHzF93kJV6Gygq6/sJdTRSrshA+NFTg+BYvAV8dRC3PWvxypQ6tCKMtGYVHqHqSZH2+6I/DRJeBnw8cK8JpfoHSj7UncCJTLWHk5qe80urEbgmx6zXvHwQz15WPbAK3zeo1fJotV0CqcDdGMcTdJ96SqXz5xk/Y03we+fhHkBkMT2aYV7gGmD7OtIcJ2Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MngNtYssMATfkV/OMS1fcH+ZW3izS1pOJC9F9pCueG0=;
 b=sa3Q+TnkG0kwc2lrjw3JuVt9WOzGap7tuvCH89JRUx/hH6WgaZdLPkaggYlGVxd1oELFQEeFuFi4O7e/47MZDO4AD1WySkA2tbNNXZ4R3q2AZy1Q9UxPwAHm25voT1ZmBEFB/dzFCPZlpdOVSV3d4ezU1W2ka2OB/rzGMeJgew+1xu4OAAScS0Y/Q07w4wQmgesBIfkY+ZsjmcZRCBV8nizmEFc92Bx2mY1VIs/EJjiDadonXPzOU8FdDNE7GUo0rXTBhscyDafRX3R5TiQOwJonbZJINvkCvD990GdZYV+LyAwA0h2Ja2+EPivqUzRIuVy7wQoFa9SQBIvfX0Juag==
Received: from PH7P221CA0084.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::35)
 by SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Wed, 26 Feb
 2025 20:16:45 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:510:328:cafe::e5) by PH7P221CA0084.outlook.office365.com
 (2603:10b6:510:328::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 20:16:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 20:16:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Feb
 2025 12:16:28 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 12:16:27 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Feb 2025 12:16:27 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v1 1/4] iommu: Define iommu_get/put_msi_cookie() under CONFIG_IRQ_MSI_IOMMU
Date: Wed, 26 Feb 2025 12:16:04 -0800
Message-ID: <b5ec70595b63017598a256db71af8feff28c6733.1740600272.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1740600272.git.nicolinc@nvidia.com>
References: <cover.1740600272.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: 67559465-dcd9-488d-1f93-08dd56a27d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FIp1jHwodSpdxg8jiFKzwjerSVxoTQFI7zP9Pb2/9C+LhH8TYMuiRXgLqyoN?=
 =?us-ascii?Q?3RUI2yCUhIn42szM0KvPg1kmbtYJ/RrorwM6a8+z1Klncj1H/ZGtw5YKeb2S?=
 =?us-ascii?Q?SHUc+zBFnb0C5F6gyD8SW7nLc8LbtfCtXumr9oWP0vaOKGX2niZsFXDxIRIG?=
 =?us-ascii?Q?B5LRO1LPk6N7LF8PUvhp/KWSgYJqDU3oAJzgD5Tri/2VwQI0EY1OLCJSwtxR?=
 =?us-ascii?Q?nTUldP3dMuHW8H3K6l4dpMUh4ACx4Az8TFHY06rdkVktqQvI8MK7qxsjlkMs?=
 =?us-ascii?Q?fmPbdSSDwa4P2QgcsDxPy0EssOt85h9pqvOBRQWWMagPj3ALAylioAm4AA5F?=
 =?us-ascii?Q?0TjvlX+y3I+bx+9cekaeEe2HyFSvyodJXImACk2cneHfAmc6AzZtZdtN/ZNT?=
 =?us-ascii?Q?/7p9rtItXve3QpA4N8Z4JUi/WbzmwUUh9QvmxpF+SCmiInblAmDWgx+ru4eL?=
 =?us-ascii?Q?kF2u00BYIQizBMJrRVJTCkOa1qKAoeS3j4kE/nqHgLRuNS+hTTCkm65DPQ2y?=
 =?us-ascii?Q?XEquQOVeVHmb1NQSzAKMnP67evcHdNyn/8iZijF22YyllqJri/TGoPq66iEZ?=
 =?us-ascii?Q?oQWUl1DL3foIYQLX95J94mJaZtuoveXFNVjbL+4BU9kwVOdb5t2TGVD32K/5?=
 =?us-ascii?Q?aGErbZZsjwB+7XIKLdfQxzE2Mr979Aae9a9PFmdvf05dJxQ1WNmebuXdNiOl?=
 =?us-ascii?Q?lOwqRQNAnPfVJolbSeRCsx1rudu0+e6XcvORBG21ucuc8p/XZ/wQ4zsyCQEE?=
 =?us-ascii?Q?WJKSnt7rh+3qRRMLrL6+C0yzJBoeB4NLHMpC+mre27YUVB33SdpTVDswwWhI?=
 =?us-ascii?Q?jk+ItVNRw3SRoy6SZeMrFitKZ6+aFuLGIS8v7TIBYHEyWekpXpmUt2rxVTCR?=
 =?us-ascii?Q?KBPPPBmDanE+Ej+tfZfz43QHniKbmWMKsxD2a7u9Baj4+rCAlqtJ6Rs/N7Le?=
 =?us-ascii?Q?/7RD0M6Z9h+aBd3opOKDtJwoVaNHzIJWBZWUifaT6WKQrx1HyirF9A8D2bvr?=
 =?us-ascii?Q?zrc9tz6/aTp84CSyMhrPUE9+8QmOrtT9HapJ/IAYNV7B6nZ1tktljy3lUr/b?=
 =?us-ascii?Q?giA5sYC6fvcOk8788rQXB7ltd9Q83oVj0UNokWJAFUYErpb2tz2jIIJt8OLE?=
 =?us-ascii?Q?LqlD4BcAJJ9VZg4UvD1Dlvr+CkQi7M/bctaSm6zje5WC0BZxGhMwv68yT7gq?=
 =?us-ascii?Q?rVtrwjjt3Hpnzp+jFpYpEL+X2EgEL2bDSV8cN50s5O8chpp9QnHUz1ew9jtW?=
 =?us-ascii?Q?pKGbl7p1pjaf9j96jkN9X6fArEEk2P29bRN07Bk4q/OvwnjixQ6X8qDeU7Za?=
 =?us-ascii?Q?s6zhtqpOxoe3KQXx3Y3MzGCylabirxEqXfvey9SOB0TZEi7ukORAY9xV2IXx?=
 =?us-ascii?Q?Ms/lve3lxPKS4+EoiAk5s1ZId15B7oeB9jmeBZE0MXMGVWgOPYhMxCPvP0wJ?=
 =?us-ascii?Q?d2tTreSBzAJJaeWOyyPRLGooxD+AkMCd45lTYuHBTvvqjxiZj2WaH+egrEZV?=
 =?us-ascii?Q?maXm9CnKGaJ3RS0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 20:16:44.5820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67559465-dcd9-488d-1f93-08dd56a27d83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200

Not all domain owners call iommu_get_dma/msi_cookie(), e.g. iommufd has
its sw_msi implementation without using the domain->iova_cookie but the
domain->iommufd_hwpt.

To isolate the unused iova_cookie from the iommufd, iommu_domain_free()
will no longer call iommu_put_dma_cookie().

Add iommu_put_msi_cookie() to pair with iommu_put_dma_cookie() for VFIO
that is the only caller to explicitly put the MSI cookie.

Move iommufd_get/put_msi_cookie() inside "ifdef CONFIG_IRQ_MSI_IOMMU".

Note that the iommufd_get_msi_cookie now returns a 0 for NOP in case of:
 *) !CONFIG_IOMMU_DMA - the caller in VFIO would have returned prior to
                        reaching to this function.
 *) !CONFIG_IRQ_MSI_IOMMU - in a system without an irqchip driver, vfio
                            or iommufd shouldn't fail if an IOMMU driver
                            still reports SW_MSI reserved regions.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h     | 10 +++++++---
 drivers/iommu/dma-iommu.c | 12 ++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e93d2e918599..6f66980e0c86 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1534,12 +1534,16 @@ void iommu_debugfs_setup(void);
 static inline void iommu_debugfs_setup(void) {}
 #endif
 
-#ifdef CONFIG_IOMMU_DMA
+#if defined(CONFIG_IOMMU_DMA) && IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
-#else /* CONFIG_IOMMU_DMA */
+void iommu_put_msi_cookie(struct iommu_domain *domain);
+#else /* CONFIG_IOMMU_DMA && CONFIG_IRQ_MSI_IOMMU */
 static inline int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
-	return -ENODEV;
+	return 0;
+}
+static inline void iommu_put_msi_cookie(struct iommu_domain *domain)
+{
 }
 #endif	/* CONFIG_IOMMU_DMA */
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 94263ed2c564..228524c81b72 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -418,6 +418,7 @@ int iommu_get_dma_cookie(struct iommu_domain *domain)
  * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
  * used by the devices attached to @domain.
  */
+#if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
 	struct iommu_dma_cookie *cookie;
@@ -439,6 +440,17 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 }
 EXPORT_SYMBOL(iommu_get_msi_cookie);
 
+/**
+ * iommu_put_msi_cookie - Release a domain's MSI remapping resources
+ * @domain: IOMMU domain previously prepared by iommu_get_msi_cookie()
+ */
+void iommu_put_msi_cookie(struct iommu_domain *domain)
+{
+	iommu_put_dma_cookie(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_put_msi_cookie);
+#endif
+
 /**
  * iommu_put_dma_cookie - Release a domain's DMA mapping resources
  * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie() or
-- 
2.43.0



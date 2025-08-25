Return-Path: <kvm+bounces-55590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6446B3350D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 06:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9D4D189C0BD
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 04:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E1823FC49;
	Mon, 25 Aug 2025 04:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XcG5VVrl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719F1D5CF2;
	Mon, 25 Aug 2025 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756096300; cv=fail; b=Njj2hFthi5RFhLSlDjRJ9kO7LyOpm+TDG16qgiKvahJ4Aj+7y/YHMXVU28CNljbvuPj1l/MMJBEVpicZreR99kaWbhCUur3SjOHj6/IaoWbNAOwzHMu8h3nEYnAZpEKDWuqj/E4VL6Gj4giv0ZfIMbMky5/bExYD933w7WJEQ+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756096300; c=relaxed/simple;
	bh=lGK5HaYSPCWT19tCdRgJzygK1iiJ8sXOiP6rMgU2uN8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XofeiLO/NaAXilYOy59dYeyvaH47HZ718QHCBS8psBDGoyqZ4f/9UonCNd1E9r6tBYn2BDvMW/Z1A/OHcEcADLRpFVCEJuXPCNLvzvCVNzolNo68OofikeqSVghB3U0xZnrsuH7BDpdoXNZDHZBIofLFQYm//+F5BSOnICbDJXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XcG5VVrl; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=puf257Yr3fl0dTdevtTjngIfDTCt8HuYExw8fEWLAtQuKyTyEUpfYEVHwJcSMgoDLGj08Q9Yo1iML/zSwT4FgAti2hEWyUO71X4BTkFfiIuqLJ0aX+BiUUd2pWIIe7+UeKuX+VEoijeF6+0VTIbrd4+Vsd+aY3FAN+0X23CDLkwG+5UR0nHvzZTPG7r/Y1frR9DHaokm6joFLgh/1TDQE2R1BabLHxlUTMX3blLmdhpqq/Uz3xd5qnXW9iy2PF651kbGJ7CMe/CkaYONwtu7Q6imbVE9Fn7Yb0bCOF+itwrgViVfRV36yxx9ediVDgYoArtPvmOgt8YEaPtMHEohNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpLBjgU6CR2jq1ZR0/me1toR8BwOxJNwEZfIy9KTeFs=;
 b=gajA1Zg14G5fr5MLRoW1BNPE9o6JhbFsmst4f9UvHMMg3wHg2HOtCJg53nsro8Hc1jsaQ1K77QSeNhFGVlZf66dCeRRv6ORbUYaUs7aBtAxm2kx7SV/E0pwC2CnBZCRAHadrStQp4Oj3EiyO6M0kfbaP8r6aKIpQSLC62fxNIE8eiB6ZqMjD0liGNYCm8zHyarfXAUmpuJ6P3YstPgZRob/vaz/PfP1rhjTDRho+aNPobvlmUkINsEau+jMTDPJxmzI0UKRGz1X6XnapoP97V+sxbB4k06oAF8CFB2hLJrtifZr3eePzAfsJs45+nAsvygT+Z7w7bRdoJg9o5W7+SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arndb.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpLBjgU6CR2jq1ZR0/me1toR8BwOxJNwEZfIy9KTeFs=;
 b=XcG5VVrlNZITQYFoVVUfXh5ughW9UpGjkb9fK14BeQntT7djUFa5xRCnVQN20hbLKzgNQnjmNDZiDrUz7A9KZitdYGeg3FWmPjNP4kEhRAakpNwDd8lx/iUV+ng6DcV3MahZ+u7eDgxs3lHaabCZwCyII92pQEsV/nwILKbp7/M=
Received: from BY5PR13CA0020.namprd13.prod.outlook.com (2603:10b6:a03:180::33)
 by MW3PR12MB4457.namprd12.prod.outlook.com (2603:10b6:303:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 04:31:33 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:a03:180:cafe::b2) by BY5PR13CA0020.outlook.office365.com
 (2603:10b6:a03:180::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 04:31:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 04:31:32 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 24 Aug
 2025 23:31:32 -0500
Received: from xhdnipung41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 24 Aug 2025 23:31:27 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
	<alex.williamson@redhat.com>, <nikhil.agarwal@amd.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, <robin.murphy@arm.com>, <krzk@kernel.org>,
	<tglx@linutronix.de>, <maz@kernel.org>, <linux@weissschuh.net>,
	<chenqiuji666@gmail.com>, <peterz@infradead.org>, <robh@kernel.org>,
	<abhijit.gangurde@amd.com>, <nathan@kernel.org>, Nipun Gupta
	<nipun.gupta@amd.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v3 1/2] cdx: don't select CONFIG_GENERIC_MSI_IRQ
Date: Mon, 25 Aug 2025 10:01:21 +0530
Message-ID: <20250825043122.2126859-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: nipun.gupta@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|MW3PR12MB4457:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f484808-44ad-4910-5ce8-08dde39044f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SoAiVI7M+ra53W2ixeBwSwv5Ckak0dV+zJqnx1PsujPeFWCg9YJEqecN78lx?=
 =?us-ascii?Q?+613tbHenOjkA0Ckc+CRw9HCe7Cx61lFW2NzGFy8GA7Qc55iEqwv2Ntma4Es?=
 =?us-ascii?Q?PdS8+CETR2IwHicf/tZIFN25kbGekXhAx6qsxfYKmCH/0PG4hT09IjvNi0RR?=
 =?us-ascii?Q?vC1NoBgLQ5+kLe2tTbFwhG5R2V4pkkU7XrDoST2NgQXWx/PsgPL2h5GRNDfu?=
 =?us-ascii?Q?Vj/l/estjQyOQpDGJkENSAjq3dbHPSXPSbEuksyw92dUAOu3Lf+vFD9ugc4B?=
 =?us-ascii?Q?fa9Cqp88xlnKiNBz/4Q7OMPtP+5wZTm3FI5S6A9GJSbXsO/R1Mn13gn+H7Hv?=
 =?us-ascii?Q?LI3bDmXQP1uomYAxk2/P6vKHLXrpNLA2ZLa1hX9YO5HTeakWtlIyh/xgdNeQ?=
 =?us-ascii?Q?Wuq2px0jYS1YNq8GztHOoodDnTXEkx+tN1Z8swrRjebFYJpXiBzACmLNvsLi?=
 =?us-ascii?Q?dTNKmek/A9kfWO3J6knMr1hzYWeyap2r1TPk4zdoW+yATk03kDTjcT75VA6e?=
 =?us-ascii?Q?DDC8xZCJTN/onlsocR947bY/je+K3K6XADBbS/orXJQMzBu42Tf8eYMg09S9?=
 =?us-ascii?Q?Uk+D99dvLuVR1NTISbgI0UeVW3piMXjB7NypEJiEhZ28sLvlQpzpW75DQRov?=
 =?us-ascii?Q?Aejhpwv/I1jFCGiywjUGCFUkmTjViAMUizGmR/LsrzDV1Pio8o3dXADLt4G2?=
 =?us-ascii?Q?c+HibdHhaxqOFo77zr6fk1vUuI3wb8vLTbyoXl0TBFbnjuKbGZtWHm6kgLaP?=
 =?us-ascii?Q?7HwoGo73aplEOerHIxE6pK6mLOQlcWkvmrVwWmvIjCP3quLU73yjFwuhG0Lf?=
 =?us-ascii?Q?q8TqnWgMV/BNmvZsNEOYK+Ahwx6XbihpkMXhWyJ03Ae4F7RRSmwGVfT53b7v?=
 =?us-ascii?Q?Phgr5mO5gbCuRBu82wkKeUQEBMMyNo+w8OeVUUjdw4qH6heX1qy6KUivEilL?=
 =?us-ascii?Q?Mo2EeFA6/emRdBzxR17B6SH5s016F+WODykk21ef3wmihOjcgMGwpbZNM2lZ?=
 =?us-ascii?Q?yZa0GD11By+SsCEubcHrarqcLXXwPrJ1Z4PnkPBxc1TZx7Gzkd/nR519VZlF?=
 =?us-ascii?Q?hoCCYLA5Wsaxi6tDs//snk3FrabmH60nyE6xbwUb3BVQMI8991z1+t50Hnnf?=
 =?us-ascii?Q?py3Qeua8H89ILRf4vTfZeGITOomqgEuAs94gn/kta8bin9w7LUjfJMM/NhiD?=
 =?us-ascii?Q?2U0oQUe8e/9ou2Un+1RIzoegJhhiQCZoAjjhLAFwxZ/0AKCglEZ9FkFx+BWW?=
 =?us-ascii?Q?Ut8gLf5b4WA3Tyn4mQc45VAxs7A7nOUAzGIsaZr1hG/Feml9jFpolgeajtU4?=
 =?us-ascii?Q?wPx4BbPvdSQ7fcrgPURe7y3/HweJppzCkiO1asoguvFT0JK/L5A6boWd5aNY?=
 =?us-ascii?Q?tJOUmgzB2tvcap3GQp9ijcBggvWoON0pQiiu+GXNTJkjN2eBozYHvSGyNzA3?=
 =?us-ascii?Q?5OWpo88AYe0gME9vtvOSrt/FiM4EQYVnty9F4kZ5Ec3qPbZ8TvtTjBd0liAc?=
 =?us-ascii?Q?yFmnDin6AChXNzr7MIp60Kpc/rdgQAzdqnCk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 04:31:32.7471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f484808-44ad-4910-5ce8-08dde39044f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4457

x86 does not use CONFIG_GENERIC_MSI_IRQ, and trying to enable it anyway
results in a build failure:

In file included from include/linux/ssb/ssb.h:10,
                 from drivers/ssb/pcihost_wrapper.c:18:
include/linux/gpio/driver.h:41:33: error: field 'msiinfo' has incomplete type
   41 |         msi_alloc_info_t        msiinfo;
      |                                 ^~~~~~~
In file included from include/linux/kvm_host.h:19,
                 from arch/x86/events/intel/core.c:17:
include/linux/msi.h:528:33: error: field 'alloc_info' has incomplete type
  528 |         msi_alloc_info_t        alloc_info;

Change the driver to actually build without this symbol and remove the
incorrect 'select' statements.

Fixes: e8b18c11731d ("cdx: Fix missing GENERIC_MSI_IRQ on compile test")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Changes v1->v2:
- No change
Changes v2->v3:
- add CONFIG_GENERIC_MSI_IRQ while assigning num_msi and setting msi domain

 drivers/cdx/Kconfig                     | 1 -
 drivers/cdx/cdx.c                       | 4 ++--
 drivers/cdx/controller/Kconfig          | 1 -
 drivers/cdx/controller/cdx_controller.c | 3 ++-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cdx/Kconfig b/drivers/cdx/Kconfig
index 3af41f51cf38..1f1e360507d7 100644
--- a/drivers/cdx/Kconfig
+++ b/drivers/cdx/Kconfig
@@ -8,7 +8,6 @@
 config CDX_BUS
 	bool "CDX Bus driver"
 	depends on OF && ARM64 || COMPILE_TEST
-	select GENERIC_MSI_IRQ
 	help
 	  Driver to enable Composable DMA Transfer(CDX) Bus. CDX bus
 	  exposes Fabric devices which uses composable DMA IP to the
diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index 092306ca2541..3d50f8cd9c0b 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -310,7 +310,7 @@ static int cdx_probe(struct device *dev)
 	 * Setup MSI device data so that generic MSI alloc/free can
 	 * be used by the device driver.
 	 */
-	if (cdx->msi_domain) {
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ) && cdx->msi_domain) {
 		error = msi_setup_device_data(&cdx_dev->dev);
 		if (error)
 			return error;
@@ -833,7 +833,7 @@ int cdx_device_add(struct cdx_dev_params *dev_params)
 		     ((cdx->id << CDX_CONTROLLER_ID_SHIFT) | (cdx_dev->bus_num & CDX_BUS_NUM_MASK)),
 		     cdx_dev->dev_num);
 
-	if (cdx->msi_domain) {
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ) && cdx->msi_domain) {
 		cdx_dev->num_msi = dev_params->num_msi;
 		dev_set_msi_domain(&cdx_dev->dev, cdx->msi_domain);
 	}
diff --git a/drivers/cdx/controller/Kconfig b/drivers/cdx/controller/Kconfig
index 0641a4c21e66..a480b62cbd1f 100644
--- a/drivers/cdx/controller/Kconfig
+++ b/drivers/cdx/controller/Kconfig
@@ -10,7 +10,6 @@ if CDX_BUS
 config CDX_CONTROLLER
 	tristate "CDX bus controller"
 	depends on HAS_DMA
-	select GENERIC_MSI_IRQ
 	select REMOTEPROC
 	select RPMSG
 	help
diff --git a/drivers/cdx/controller/cdx_controller.c b/drivers/cdx/controller/cdx_controller.c
index fca83141e3e6..5e3fd89b6b56 100644
--- a/drivers/cdx/controller/cdx_controller.c
+++ b/drivers/cdx/controller/cdx_controller.c
@@ -193,7 +193,8 @@ static int xlnx_cdx_probe(struct platform_device *pdev)
 	cdx->ops = &cdx_ops;
 
 	/* Create MSI domain */
-	cdx->msi_domain = cdx_msi_domain_init(&pdev->dev);
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ))
+		cdx->msi_domain = cdx_msi_domain_init(&pdev->dev);
 	if (!cdx->msi_domain) {
 		ret = dev_err_probe(&pdev->dev, -ENODEV, "cdx_msi_domain_init() failed");
 		goto cdx_msi_fail;
-- 
2.34.1



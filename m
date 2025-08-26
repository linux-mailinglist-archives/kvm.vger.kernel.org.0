Return-Path: <kvm+bounces-55722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C58B352C8
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64EA8683791
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 04:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C6E2DFA3A;
	Tue, 26 Aug 2025 04:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gjeuAwTz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFEF2D23B6;
	Tue, 26 Aug 2025 04:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756183155; cv=fail; b=jqYYqPyZxvAnXq16I/5S/NBDEAXP0RJlCZD7BmaWGiuaCZxAt7EwQul9IESlstfqQBfmVD2bdPDK6tZh0XSFsFRjIl01atpSSJXgFVNa9yYLZDEr4/f8Q+9dDeqVxsx9XtDzuE3kHQ682gQ4VxnWTQRlNIoZopcVc9w+yzNjoDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756183155; c=relaxed/simple;
	bh=UlaH+k2FXm4PYk3xIFfqjDc5FKciZaip5q9RKdbqyOA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tSJRl5QZbwGtdus99GdgTj/GpysMKv98X9PYlZD1vHGI8Pert9sb9GBmzAFWrtO/5cyP4OaKS01K5EblvCFjQ8t5AQ0umN6w5GJX99tn1lx3yRd+B4o9Voy/UJxXHoP+JeAQiXElDLM5+Q+44Zy8L/82PlUSqVC0IbU63tWy7zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gjeuAwTz; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLr9JDWvsjR2y+6p+i4SB5FM8AJKjG8FJA8ncU5fUmhYZxrpBArZay86jkhO22L9TQJ5XuKgPcHG8DyKMJv4M/8YD45VQEPTCXJ85Lhm02EZQEmA7xbWLhDs3hqMY+THcQDQNLYfH+shvBoPjR79NFHUDBfWzPYcVK+eYMcZisnfR71H5SDazikFU7VD451S1c/aXsuX7tWXq4hvlYLS+HDs1ZuIR1/4ze2SNvBKOjvwXHQRDH18MJkJ0XZ/QMAyCTjh+QwZ0PbLi5UfwW9ecrBBB7edlKz6SEC0nVclmC2bwcHaP/aGLnRtjuzFa4idOvdebPP9i9a54KTyg8idng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8BqBCUXsqAqtN6aKE2b3++ajuiIBm18SPTet2ijIGQ=;
 b=Bx6KT/F905kh+Nt0zlNvXuIwLuOdYoEV+0iAWJMDEr9V6qRiwddx6UaEDBZxQUCZMnadXsAmTyTBQRHW4DPLWLc+TAcwdtMxrSY+2OVQXJFBP3NxGhl1oZi3DRbaxHe7QraT+EwyPN0dkrub/qQc45nd4bhEvgh6f4twQLDtn5zNzxjeGC+yW/ls5jEdzuPLCOIfR/RtVrEbQxX3r85g15RF3BP5p8JHjghfgm8nEq6aUfkl0dvxQw+4FucNcd7DGt8wJ4bpzrqmMPzqwYUV6KAMG8Dx9uCbl3mxWscoTQjNlDVLBygDSWEcIRn4iB5ZhX5fPYdNyvZepE2KV3+iwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arndb.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8BqBCUXsqAqtN6aKE2b3++ajuiIBm18SPTet2ijIGQ=;
 b=gjeuAwTz4y5QkafkN7TFu5yQ0zuHqKHM4sE2obSXkY3XhwxiPmwr5ZHEtLm8GgRWqFBKqxX7aw2VoKEyOCcA7NkOlDLQZqQEN2vGxqfpe3kuu0u+DeF+qC9Pz7vju2uHq6vjfKTBvBo2rQgbUx85bpghY84hpjCHT58a5HVmN0Y=
Received: from BYAPR08CA0007.namprd08.prod.outlook.com (2603:10b6:a03:100::20)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Tue, 26 Aug
 2025 04:39:08 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:100:cafe::4c) by BYAPR08CA0007.outlook.office365.com
 (2603:10b6:a03:100::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.22 via Frontend Transport; Tue,
 26 Aug 2025 04:39:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Tue, 26 Aug 2025 04:39:07 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 23:39:02 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 23:39:02 -0500
Received: from xhdnipung41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 23:38:57 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
	<alex.williamson@redhat.com>, <nikhil.agarwal@amd.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, <robin.murphy@arm.com>, <krzk@kernel.org>,
	<tglx@linutronix.de>, <maz@kernel.org>, <linux@weissschuh.net>,
	<chenqiuji666@gmail.com>, <peterz@infradead.org>, <robh@kernel.org>,
	<abhijit.gangurde@amd.com>, <nathan@kernel.org>, Nipun Gupta
	<nipun.gupta@amd.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v4 1/2] cdx: don't select CONFIG_GENERIC_MSI_IRQ
Date: Tue, 26 Aug 2025 10:08:51 +0530
Message-ID: <20250826043852.2206008-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: nipun.gupta@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b482f1-8b97-4a6a-0af8-08dde45a7ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?schMZ+Znq0lK//8myuDjlHXof7uQC5HW6KA/+2s+yQDcpjVeCg0QxXgao06+?=
 =?us-ascii?Q?3j+rLIwiaT3umcN3Ch35IuNDZmTWDeAVGJQtxg6ftuzhq9y2SfVNZBNpcfUX?=
 =?us-ascii?Q?sRuVqVMXP0LhfRsig9WfC0n9xNdyemTht2GxILQ8J/BcwLd8PHDxodOdcJ8L?=
 =?us-ascii?Q?BRelY4d0gYf7zBqqMgCLCPK1JvxO346kFL3uv3pgpKMtc7Ot/ZTDhYeRQ/M4?=
 =?us-ascii?Q?Hrg97OKLpPqTEfg/XCBDzhoIOTtFlj2zXbjzUBhFxTSqkPNLkKsPoTrZYznG?=
 =?us-ascii?Q?90QEAVDQxOOA9Qk95lY+ohb/bcGlFdb74ZB/1FxPRYt7ODxE70Lwxs7cLhlJ?=
 =?us-ascii?Q?xjnq0aBYZy3i31/j0ErEjwcNjZkmqgo+sjcDt54UCvbp2OFg7GcB0feA/u+8?=
 =?us-ascii?Q?Z4WkWn/p4oefdePCyCV3RDRLLrHPV5HPEIf0jdsY500oKt650UZEmkxhRqyT?=
 =?us-ascii?Q?kK/qddnmS5+UJFUnUKLfnE7Tj9VHHEutVrTl7DFiz0pS7kx7yZOpf2NcDU6T?=
 =?us-ascii?Q?jpSCmGhhtYd1gQHr1YUix7lwBBdzJPfIdNTWmtKkCBakcNY/8vdwjbbv3fCW?=
 =?us-ascii?Q?dVOz3fS2G3FS2fq5sxZA6pD5rZmFhw2m+sNcbG3gLu+n4S9L7FJsm057ymj8?=
 =?us-ascii?Q?LHL9nPfeE8lWdTT5cvFiNTgSNjlkRGfDuvUBzDMWzNNN9TEUF1eiM8XaBW5o?=
 =?us-ascii?Q?Ltm/NoBqkM67LWdU8w9H6dLRMUawpAquqBy1TG3EaYEo+nBCb7uch/+2mwmX?=
 =?us-ascii?Q?7hssrN0TpRXGo1SYRsWpVRPh0u7CQY6PItxwBRC/9PbkZtcDrnxYBXhtFBUh?=
 =?us-ascii?Q?CrGl9CTchcI/OKWvtee19oGKWuVgS3vfz85gPJlxlFZ/hLY7rWgQlauOLku/?=
 =?us-ascii?Q?ReBlkJAUMAV6cvPdXUxBichOTx+20sVMF9cOQPwB8fJpUUSQNHei2rLMgXag?=
 =?us-ascii?Q?ZEUwYQEswotV2Ov6lMy3fAegIgC24wy8VC42j0nomedsLo97GWvsUmiAv5fR?=
 =?us-ascii?Q?5H2xVph6pPZ0ELTtFBxyFaf55JPzgNCb0BDnycWiD2L5qxEcZijMA+JwQW26?=
 =?us-ascii?Q?V/hye29i74ECCqDPmBRV1VyITl0uIIahwQlxxW3Eais0Km8c699nUYuWknvs?=
 =?us-ascii?Q?Pi0QNkILC9spfmYuX9reGwbIx+7d4rFcFxKfRhFbrEyZdW2O04GhXzHCfjdb?=
 =?us-ascii?Q?n3R3h7umbbnXIC14gKEeiTXufLbcdVEymR9GjwgGSViI116awOcwgSwWBgjf?=
 =?us-ascii?Q?JOd1jvfjm5S2U3e1Y7s/r3Svc9X416kI2dghjwXTUvAVcwoinn2QcsAwlJUh?=
 =?us-ascii?Q?EUqDiS9hrUfQAQQEnDBgpQdQ1owAhv0Am9haiTTrZj6gUYeiRu5kCOdg22yp?=
 =?us-ascii?Q?Apypl0IGs9dHZZIyRjm5YDhtTFiRpWpiKwHpFQ3NxTt8ZSZtu6tnVLnVtxTZ?=
 =?us-ascii?Q?miV1+v//7aX91T29TzOoTh8O8fAEWBAwYFjCckOE+MnVeVCEN41db2UHvJlr?=
 =?us-ascii?Q?FAks1bZ3ivj9lCCAZReRDjz7/buYT650J7gu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 04:39:07.7876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b482f1-8b97-4a6a-0af8-08dde45a7ea2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233

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
Changes v3->v4:
- No change

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



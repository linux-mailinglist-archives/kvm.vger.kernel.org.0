Return-Path: <kvm+bounces-16520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D0C8BAF40
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250831C22327
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B785747F7F;
	Fri,  3 May 2024 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S1EYUgso"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019266FC7
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714747959; cv=fail; b=Z0WaFpJ+UpgkHx40RT61mH/S6foQdB9H7001PQ8DHdzbjdVaM+vg7zEwltW+cONcrKTI8fSPlgGpc57nQlNpFSpOI4CQ/FYz75t/UQy7zA+ykcOSQu1RUoeEYSldL5VYUNcg2f2QSc+uuMGNT3pIOEijpu95jGDCre1yH7H4X+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714747959; c=relaxed/simple;
	bh=6WAo2tEvXZnlnL80oZalckzk+SyBNQ0aplklL1v3C5c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h7M3WLMMkyxRQnhCcubmJ12+78PYERxKkjjj0JHifRFQG+Z6a0qoXzj/fkYbs7AN23VXiUOoT9EbE78kzZOyMs/8yoakkdfi8uKya77qXSqf2O7657tJpka77nke2QV+Bk8FucyfEha+YG2676UHGkT9D5pfHuNApZ2gCLdIfiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S1EYUgso; arc=fail smtp.client-ip=40.107.212.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLU9o8mJ2gAtdTKd7AL10B1Eq51rZmsVHc3Xrr4hf15AwdzJ6qcFXDSu/e9UwFPa99JG2lYaElm8a/9QBqIbDS8x2qhlRB8I8FjMJtVoCWts9PFcGNh1N9v28E+WOHcihXj2cFgX8DFCEr9yhqubdNBUxvd63HmCSP2/Ak4dnnq5Ez09PoNVFAFxEm532ZwSOdmWvHftHl3MoSVcJGp7+6dxH1uCeLvr4ltexHmxeCsfYwo2br8pjxV8j8ayb9Xe4mMdSVYMn2LrPOONKn7K0rJphGdknO5w0qN+wcOrOSP+JDC1NwXBFYpvVvk2+vtoHFUkG7unCyVlMvUeZ2TRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLJYcyAAeFEG64XhQP6rm7KTbxNIi98O91QY5f93ktI=;
 b=RFaTyzrtttbl3GmA0zCqCL3+piztgeL+AKUXk2+CBt/9nDO8FnrBpkad2U9MRXusjM+jLzLB+6x4VEjwtVxTxjw+chUTZ23tby5e0wk+uDaR9rHrkFYsNuatg1EAx7fpPSBJtKmos9sVSRMZEELtIEI2BrcZOd4b7Mch+j7KoQLBlMWiEFDVUYrHb08hUgbUt5GI29yQRnn0Ack/+sAL2S3IMONZWsSZ4lIttXt3BKGafl/GWWAC9zZwT1pa4MSiLtlPJ5BZIUzK1Wj41TXJSEgHRVzhnhb3dRMjk8rBbiAxuYoVIqQbSGZHfz0DPcn4rAG+vkd1vk29Yno8XCLJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=nongnu.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLJYcyAAeFEG64XhQP6rm7KTbxNIi98O91QY5f93ktI=;
 b=S1EYUgsoN+tAzmuGJkdvIEyBzYOGSTfMGMnrlT4qcDlo05VpltxTvRHZovK9D6OF2G5wU4AHLhXQ1JmsvphSd4xgywG6kaHbrAcuIgwcvZr9HwXlrjl1nyb1sgtVNh5jiuN6oCGJbRwLfMUzVNvURcnBKk9lJ5K4pyuUa/L8faU2sIXt7/Qg/ilXRacXXgHPiOM6PMc1Dw41LSb/Hp+t10Y8NfEUjLhIcWc2jazGxq99fkGHzqTAXuMI/ChDnZyCkueKsp70VQk+2Oux4PnkCB3P88jpj3Vl137Vbcpeajrn0i3PQd6fRKQdHq1ujM83PTQJfe4CKzKq4w2S179b/g==
Received: from SA1P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::34)
 by SJ0PR12MB7081.namprd12.prod.outlook.com (2603:10b6:a03:4ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.32; Fri, 3 May
 2024 14:52:31 +0000
Received: from SA2PEPF0000150A.namprd04.prod.outlook.com
 (2603:10b6:806:22c:cafe::21) by SA1P222CA0001.outlook.office365.com
 (2603:10b6:806:22c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34 via Frontend
 Transport; Fri, 3 May 2024 14:52:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF0000150A.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Fri, 3 May 2024 14:52:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 3 May 2024
 07:52:13 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 3 May 2024 07:52:13 -0700
Received: from vkale-dev-linux.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 3 May 2024 07:52:10 -0700
From: Vinayak Kale <vkale@nvidia.com>
To: <qemu-devel@nongnu.org>
CC: <alex.williamson@redhat.com>, <mst@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <clg@redhat.com>, <avihaih@nvidia.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <zhiw@nvidia.com>,
	<targupta@nvidia.com>, <kvm@vger.kernel.org>, Vinayak Kale <vkale@nvidia.com>
Subject: [PATCH v4] vfio/pci: migration: Skip config space check for Vendor Specific Information in VSC during restore/load
Date: Fri, 3 May 2024 20:21:42 +0530
Message-ID: <20240503145142.2806030-1-vkale@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150A:EE_|SJ0PR12MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: f8fd8696-31e0-4133-9587-08dc6b80a8ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzZzamw5SXdWWW5VSm5TbG9qZWVaNURXRHZqdHBOVTNham11KzJ3UjlrNVAz?=
 =?utf-8?B?ZDhYT3NqQ3Ayeks0ZlJwcE9sZ1Z0aHh3Uys4c1RJNUhpVlNvTEpiZTFoZmlR?=
 =?utf-8?B?TmNCRmh5WkIzVlVLQXpnSnpFL1RNSVQxSktsd1hNbTcxVW1jS204YTZQN0Vw?=
 =?utf-8?B?cEorRDBsY0J2OHJaMk8yQm8vS0ljSTVnTHA1ZEJidjFKZnVUR0R6RkNBenBI?=
 =?utf-8?B?dTdlakNlVlNPZzV3ZVNxQkNVZ052WkJsWjJpcUY3bkNyNGpHWHN2UTl5MGF3?=
 =?utf-8?B?Mm9EVEZOa2JvNXBDZTVvenJhdVlxU1NZRlZCYzBpaDRBazRiais3QmJLNUNX?=
 =?utf-8?B?dkpaV3d5bzc2V2RHTzg1ZlNjd3RYWkVsRm5COGVGZzEzWi9NWXFES1FOZklU?=
 =?utf-8?B?VGxQM0taT3N3eUxaL3ZrcjJhZFEwVlRYNUxOeDJZYUUrcVVoa2VkMUI2dXEv?=
 =?utf-8?B?L3ZiWUZHb0lyemY3WnZxMitSa3FqNmJaTy9HY0gvNndaU0ozV3FSQlF1RWtw?=
 =?utf-8?B?QXFMbG9Vd1o2SXFSVExrM2ZCZFl5SXN4b2hBazhZU1BNWHlob0xacFdmc2o2?=
 =?utf-8?B?VTlFcVFSZG9qME1EUk9rMWtrblRaekJ4cXpOVDNIMDVTR3RlTG53MnhEWTVZ?=
 =?utf-8?B?TjNUR0dwemRzSkVyUmZyOVNSc3JTdnFLVmRJbzY1SHZ3WTRZa1NINk9Bb3JE?=
 =?utf-8?B?YVJFNmttNkFtYloxZ0pCY2ptNHJ4dWQ5bG15MHVPOXB3ejhXNXFRV0k2TlRO?=
 =?utf-8?B?a2owT1p5QUYwUFNIdVN2TnFhYjl4MDVqMVJxaDhrTXhWbUFZcmRabno1SnY4?=
 =?utf-8?B?YWZjSXRFSTlncTZhUklQS3o1TmpYZFZGMHg0RVVEeC96V1phRDRUTW5ZZTFn?=
 =?utf-8?B?WTZ1Um1xdkl3cC9BeENGYnNVV2xJWjlQK2IrSTZJOGtRNkwwYmw0UnlHaDk1?=
 =?utf-8?B?TlFOdDlyUUkyU1dBbUk3SHFUK2hycTg0aFYrUytkNjFuY3pTU0R5SWc4NWk3?=
 =?utf-8?B?WXloKzlkMmlEbHgybG05cENXYmEvT1NPM1IrWnh5elNGTGt0MDhEdTBOcmxt?=
 =?utf-8?B?WVZsTGxYdG5sRlRMV1JCWU1VaytOUTRVNGZ2ZmdoYmRoQVV3WDhkMDhnV2d5?=
 =?utf-8?B?U1JhR3VsWHMvNEg2NDMrQVhiN3RSRmlvNEE4QkhMSnlUZmVlb1ZjTjhjUFBl?=
 =?utf-8?B?N0o4b25pYU9HeUpEN1dnRmY0ckZDdFJLV1Ird0xiek9lTGZGZ2hDdC9ieVI2?=
 =?utf-8?B?NHpZdy9hc2Q5NVh3S3pqTEZ5WGlWN2ZXY3hrVXhTK2FiQkR3Q28wV3FoRk15?=
 =?utf-8?B?VUdRY1h2aVN1djZvalJLT09lQ1JqY2szVUVLWHVGWWRtSUFOUzRDTURqTTd3?=
 =?utf-8?B?dlJoMlZCOGR4bjg3SWJnUXJPWE1YTHlqVmhnVnZGcjFKTDhkVFFHM3VGR1lM?=
 =?utf-8?B?MFlUS3VZRDJPYmZiRkY0dENkUCsrck9GNVcvbnVoamFLWk9lTG0yZzhUL3Qr?=
 =?utf-8?B?ZDZXMVN0NUg1Mmx0dUFSd3NXV013N2czcTlCVnQ1OEp0Zi9xUmFQYlpLY2ls?=
 =?utf-8?B?Y3NWRXVOWUxpRjNTS3ZVM2t2eVBUMUQ0Q1N2SjhCbHJ5TFY5eS9HYjJUcVNk?=
 =?utf-8?B?YjZNUWNISEFOLzlwVktRTTVCSDNPdlZVazdUVElRVXdFWU45eFhJd1JxeGFK?=
 =?utf-8?B?YjFUUUl1U2Q2a1dOQUd1QktubXNVZWxJdXBySml5QldWSGdtcnFLVHkyRXRN?=
 =?utf-8?B?ZGliRUw0S0twb0pVWmk2S1hVZTZ2bDhzWU9haXNhT05XUWFyVzk1VWpTaHhB?=
 =?utf-8?B?WnhuTys1L3dVQ1g0ZEV5N051YUdlTmVCUlB2NDRXRFc4SGwxbSt4YmdwQkVZ?=
 =?utf-8?Q?9D0X2offmyx3O?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 14:52:30.8361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fd8696-31e0-4133-9587-08dc6b80a8ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7081

In case of migration, during restore operation, qemu checks config space of the
pci device with the config space in the migration stream captured during save
operation. In case of config space data mismatch, restore operation is failed.

config space check is done in function get_pci_config_device(). By default VSC
(vendor-specific-capability) in config space is checked.

Due to qemu's config space check for VSC, live migration is broken across NVIDIA
vGPU devices in situation where source and destination host driver is different.
In this situation, Vendor Specific Information in VSC varies on the destination
to ensure vGPU feature capabilities exposed to the guest driver are compatible
with destination host.

If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
volatile Vendor Specific Info in VSC then qemu should exempt config space check
for Vendor Specific Info. It is vendor driver's responsibility to ensure that
VSC is consistent across migration. Here consistency could mean that VSC format
should be same on source and destination, however actual Vendor Specific Info
may not be byte-to-byte identical.

This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
device by clearing pdev->cmask[] offsets. Config space check is still enforced
for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
config space check for that offset.

VSC check is skipped for machine types >= 9.1. The check would be enforced on
older machine types (<= 9.0).

Signed-off-by: Vinayak Kale <vkale@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Cédric Le Goater <clg@redhat.com>
---
Version History
v3->v4:
    - VSC check is skipped for machine types >= 9.1. The check would be enforced
      on older machine types (<= 9.0).
v2->v3:
    - Config space check skipped only for Vendor Specific Info in VSC, check is
      still enforced for 3 byte VSC header.
    - Updated commit description with live migration failure scenario.
v1->v2:
    - Limited scope of change to vfio-pci devices instead of all pci devices.

 hw/core/machine.c |  1 +
 hw/vfio/pci.c     | 26 ++++++++++++++++++++++++++
 hw/vfio/pci.h     |  1 +
 3 files changed, 28 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 4ff60911e7..fc3eb5115f 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -35,6 +35,7 @@
 
 GlobalProperty hw_compat_9_0[] = {
     {"arm-cpu", "backcompat-cntfrq", "true" },
+    {"vfio-pci", "skip-vsc-check", "false" },
 };
 const size_t hw_compat_9_0_len = G_N_ELEMENTS(hw_compat_9_0);
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 64780d1b79..2ece9407cc 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2134,6 +2134,28 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
     }
 }
 
+static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
+                                        uint8_t size, Error **errp)
+{
+    PCIDevice *pdev = &vdev->pdev;
+
+    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
+    if (pos < 0) {
+        return pos;
+    }
+
+    /*
+     * Exempt config space check for Vendor Specific Information during
+     * restore/load.
+     * Config space check is still enforced for 3 byte VSC header.
+     */
+    if (vdev->skip_vsc_check && size > 3) {
+        memset(pdev->cmask + pos + 3, 0, size - 3);
+    }
+
+    return pos;
+}
+
 static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
 {
     ERRP_GUARD();
@@ -2202,6 +2224,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
         vfio_check_af_flr(vdev, pos);
         ret = pci_add_capability(pdev, cap_id, pos, size, errp);
         break;
+    case PCI_CAP_ID_VNDR:
+        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
+        break;
     default:
         ret = pci_add_capability(pdev, cap_id, pos, size, errp);
         break;
@@ -3390,6 +3415,7 @@ static Property vfio_pci_dev_properties[] = {
     DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
                      TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
 #endif
+    DEFINE_PROP_BOOL("skip-vsc-check", VFIOPCIDevice, skip_vsc_check, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index 6e64a2654e..92cd62d115 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -177,6 +177,7 @@ struct VFIOPCIDevice {
     OnOffAuto ramfb_migrate;
     bool defer_kvm_irq_routing;
     bool clear_parent_atomics_on_exit;
+    bool skip_vsc_check;
     VFIODisplay *dpy;
     Notifier irqchip_change_notifier;
 };
-- 
2.34.1



Return-Path: <kvm+bounces-63534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C57C68C4E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 09BA32AA5E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CB933F360;
	Tue, 18 Nov 2025 10:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M6965gZc"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9E13594F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763461045; cv=fail; b=qK+8AycyphuNcTr5lo29ZxreNim/rfNFp03axmLWLYbRaggYp3V73rST7TuVorAeOD42+aVI1PjfqDFU28eF6vAlgaBy42hlNjMynYnjq+Ic673h5UsScDWFkVvRY5pXpqQ3zr2s4YeUrOVrDRiIgTTcBvmjbJJI6rLy4+VKteA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763461045; c=relaxed/simple;
	bh=/zOcja7NbyRWudRbl8/Abehya+scgeplNcq1ZeNEep8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBwsMfEI7fJSYFTZ3Ve4/aASxwptlkOPbjPmq9rp/HZEweh41ZaPX7ipNwFzB9W1eKo9ETwambMDYsCxWkQ/GRwtzIXcGI0O2ygin+zuJA6nuytHMu5XJFo5Q2jHjiJCfuiGLzejprW5nKu3UENAV7u4qkJGwjcWr0/St7yRSWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M6965gZc; arc=fail smtp.client-ip=40.93.194.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HkFVcsjw1Eb5z80aT3vcPhy+oJQYCDmckNdDVpyRwCIrtAhGsZRETUfrjHmRmwDOd1OEkgD+Q3eZSsCTJ2Vnoz2xSe+kokIKByTCBjn7N/JxSx83OstGMZrFOzZ/SGLHg6ExBUCZN7x8EARxW+nKiL+Kps8/ARXamk2hGqb9q9SUC3U9O8HpuVTrdHDHsDZ9cN9ja0Do8QxyvTcwsrS3uI4x4DNjtC1LzfgFO9bOaWrlclibBKy+P0kTEJ+OyL36qUefjWK/lk2fc69VEBDNjB5zNQs1ZtguCIYcmSdxfFhzkVrIKgWk5TtvqgyE8gLOPGI1396qEFL/In2OZbo6Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiNzlgvnvlDcQCcELpmPi9+HKXd8ggJUv8Hy4Y7i5dQ=;
 b=swFbHlpOJ7lMaO3K5iwDTZsh3jpMZzMYo4tPXvi6iXQlvn3iFwzFKpv3WZhjR0pXyJymB+a90pJgvSQ6bfnTYEFPMm8nztY20Vsn5ld4sJUwju7ob7FKLWsU2EXmrSMPtK2/lRuK5wNYo15wzFS3RoDvt6fxtR/ZHis0L+3M8CLHP6f2fmOx1u3g3UvRc3dj3mm+tQoBdyal37Jqu/3v+la8N4BbU/ShUynk/icD+da3D+048b6fWhOk03r74lflREwqXGrAl00b0QPCQWkTouAZof4QFsNtTlJNZad0bUgOY5M3PM2d0l4k84WgQmLs9YVneZ5FN2fEOlE5ZsHYvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiNzlgvnvlDcQCcELpmPi9+HKXd8ggJUv8Hy4Y7i5dQ=;
 b=M6965gZcWMInl9H8dWZ7mxTXIJPlvZYK2UepFL20x3UDufE5vLfFRNN11npWv+fVmutVuqFw8F5IIkqymFdzi0bH6/quAWzYg3PinIL14sbM3SakVRc7WJS6XvQKnLGt5rT5Ssv1aT3hFzW7oYDqrUr3DvpD/DwJ06RXP7J3bJI=
Received: from SJ0PR05CA0129.namprd05.prod.outlook.com (2603:10b6:a03:33d::14)
 by IA4PR12MB9835.namprd12.prod.outlook.com (2603:10b6:208:54f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 10:17:15 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::c7) by SJ0PR05CA0129.outlook.office365.com
 (2603:10b6:a03:33d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 10:17:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 10:17:14 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 02:17:08 -0800
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<alejandro.j.jimenez@oracle.com>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>, Sairaj Kodilkar <sarunkod@amd.com>
Subject: [RFC PATCH RESEND 4/5] amd_iommu: Add support for extended feature register 2
Date: Tue, 18 Nov 2025 15:45:31 +0530
Message-ID: <20251118101532.4315-5-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118101532.4315-1-sarunkod@amd.com>
References: <20251118101532.4315-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|IA4PR12MB9835:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fe54769-7abc-4847-609f-08de268ba4ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MiVe/NlygGrFJRMskfSL7KzGhoiFpBA393ECVE7eQDPqvRDI+Ycc2PKYXi50?=
 =?us-ascii?Q?9McGICrp3tkcteHYI6W31MTfxTilQrMMd0ML//E4Py9CaZBAbJkKDa1pn05i?=
 =?us-ascii?Q?Kj6bm5NMa+LRvaJ3UeFcMB8Xs9/D3T89UIHm1kJ8Y5xVHxh6TrNY+ItBxjXw?=
 =?us-ascii?Q?ZDsm+2s6XGYIA0Jg06uBrOBqMoXO+SzdwYtYUYYXwzWzip1yB51X2Mq5qC+f?=
 =?us-ascii?Q?91WeG1rqA7xtupMuHaSwO9X6Rt5B9sPtrFlDWBGhP6C7xsjDBQn08DdxarBR?=
 =?us-ascii?Q?1GXH2QRr1P8M/r6fz+UPwZiJjAzm69hKsl4jgUiwYsYkmn3n9DAuTWJEPoXP?=
 =?us-ascii?Q?r0gEws7d12B0kOPaiz1TWephZmEPKulcyOEy6DQZwhfDSpgqomgfF/G0c/LX?=
 =?us-ascii?Q?ZyZ8b1CUcrTq5+4yMj42Mj3SZegH4YCpbPdfo1/EjGWLnfaIJqc6E0XTqG4t?=
 =?us-ascii?Q?xXU7aH7MbApMrmfttH4NWajrVlPCPoq7afRsr1j/3xNqHkRBi/aL4AGvik2X?=
 =?us-ascii?Q?zgjzCwueXyKomMoHejEdqSXHT9ZBCHxpFvUiYI6Dub7+tSlnkO6ilYfKVG9K?=
 =?us-ascii?Q?sd7wIKWVy3zB3FzNGnzUSChQ83AKrwZrf2RSYYNKkp7eFyuLyz6a+PPGAL9J?=
 =?us-ascii?Q?NhkZSFrVuy6l6MpRDOgLq5uZmnAR+wBsU/SBt1WlGBzXrAWcBkm6Xc1h2zCO?=
 =?us-ascii?Q?RluZgNZ+4D60adSD3/gJ4aE/mG1aduJJYTS/s+FgrzjvMGiGLeQOVHdo2dqY?=
 =?us-ascii?Q?FRvFXrjjl7ae6EfYnVcmk6+FeUi3cd1u4TVa3VdTAicn75IMIWS4ADL8kSGL?=
 =?us-ascii?Q?mopjl8dcfGDj3n+MjnYI8q14fw1Sfk0Lhv6O39Y8H4LWYk69xm8s+rfXYaN0?=
 =?us-ascii?Q?sc62eEEgnIwXuQf/F3Uc9gfvYfK8JZKxOxH0jbXzVP6ycwOw0iyRnCP2LR/q?=
 =?us-ascii?Q?dguZ8rzk9C5TEtoyOZerVnE8kOXo3FOwcL+yYpj+v7tq/jWboKNwV/A2zzZW?=
 =?us-ascii?Q?tN7SjRE4fpQRzpqOLARjoZTDs5vw6ysdWCySZUKvvW1zceYh5K9T/Zi5Vc2f?=
 =?us-ascii?Q?jy9bHHEgLlp72jFVLHrPLmnGPpB2FDTJBA1nNADEXaGkcB2tznaWvZXrreAS?=
 =?us-ascii?Q?ZP8M+E5YxmfPqTWU3nAAO06zRn0ZJLXrYn01nX95YAa5wC7k93PmPQF/nYyF?=
 =?us-ascii?Q?lMH5DhaulFJ/g53R7BcuHjCWjbqcsxhEBaycegljAfQ/FuVvfGWekG13LTKl?=
 =?us-ascii?Q?ZXCa7kje6jjYT6SykUt3G5r9jUQi+TSEIl8ZDGwfujPGAX2UXhunVM/I9OOF?=
 =?us-ascii?Q?Ss/yW++RsrLnVQ9+66ZcV8Dl3oryhSbHt/R4zK9HI0VeUPY06TKwENcVzRZG?=
 =?us-ascii?Q?JFfbhYUDDKoKq+stptyXclFz12dYKvMA03jqJPtbS28YyuFDGkGUMu+VDQpO?=
 =?us-ascii?Q?crmJdoY2ng64mUVmdhBZDwEquxnIycxltUbLuAZE4yhSRDfZCZws/5A7lLw5?=
 =?us-ascii?Q?I9YInKfVExZzoyJHo4G7Sr+vAjyCVNGlFj82wzCIFgF6spGq2IFRGTKa0SrX?=
 =?us-ascii?Q?KiNL7AIKECh974zWilc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:17:14.2929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe54769-7abc-4847-609f-08de268ba4ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9835

Extended feature register 2 (EFR2) exposes newer IOMMU features such as
NUM_INT_REMAP_SUP. Set MMIO offset 0x01A0 and ACPI table entry to EFR2.

Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
---
 hw/i386/acpi-build.c     |  4 +++-
 hw/i386/amd_iommu-stub.c |  5 +++++
 hw/i386/amd_iommu.c      | 20 +++++++++++++++++---
 hw/i386/amd_iommu.h      |  4 ++++
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 9446a9f862ca..1d4fd064e9a5 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -1873,7 +1873,9 @@ build_amd_iommu(GArray *table_data, BIOSLinker *linker, const char *oem_id,
                               amdvi_extended_feature_register(s),
                               8);
     /* EFR Register Image 2 */
-    build_append_int_noprefix(table_data, 0, 8);
+    build_append_int_noprefix(table_data,
+                              amdvi_extended_feature_register2(s),
+                              8);
 
     /* IVHD entries as found above */
     g_array_append_vals(table_data, ivhd_blob->data, ivhd_blob->len);
diff --git a/hw/i386/amd_iommu-stub.c b/hw/i386/amd_iommu-stub.c
index d62a3732e60f..39b1afc0c751 100644
--- a/hw/i386/amd_iommu-stub.c
+++ b/hw/i386/amd_iommu-stub.c
@@ -24,3 +24,8 @@ uint64_t amdvi_extended_feature_register(AMDVIState *s)
 {
     return AMDVI_DEFAULT_EXT_FEATURES;
 }
+
+uint64_t amdvi_extended_feature_register2(AMDVIState *s)
+{
+    return AMDVI_DEFAULT_EXT_FEATURES2;
+}
diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 8b146f4d33d2..3221bf5a0303 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -114,6 +114,11 @@ uint64_t amdvi_extended_feature_register(AMDVIState *s)
     return feature;
 }
 
+uint64_t amdvi_extended_feature_register2(AMDVIState *s)
+{
+    return AMDVI_DEFAULT_EXT_FEATURES2;
+}
+
 /* configure MMIO registers at startup/reset */
 static void amdvi_set_quad(AMDVIState *s, hwaddr addr, uint64_t val,
                            uint64_t romask, uint64_t w1cmask)
@@ -123,6 +128,16 @@ static void amdvi_set_quad(AMDVIState *s, hwaddr addr, uint64_t val,
     stq_le_p(&s->w1cmask[addr], w1cmask);
 }
 
+static void amdvi_refresh_efrs(struct AMDVIState *s)
+{
+    amdvi_set_quad(s, AMDVI_MMIO_EXT_FEATURES,
+                   amdvi_extended_feature_register(s),
+                   0xffffffffffffffef, 0);
+    amdvi_set_quad(s, AMDVI_MMIO_EXT_FEATURES2,
+                   amdvi_extended_feature_register2(s),
+                   0xffffffffffffffff, 0);
+}
+
 static uint16_t amdvi_readw(AMDVIState *s, hwaddr addr)
 {
     return lduw_le_p(&s->mmior[addr]);
@@ -2307,6 +2322,7 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu_as[devfn]->as;
 }
 
+
 static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
                                    HostIOMMUDevice *hiod, Error **errp)
 {
@@ -2434,9 +2450,7 @@ static void amdvi_init(AMDVIState *s)
 
     /* reset MMIO */
     memset(s->mmior, 0, AMDVI_MMIO_SIZE);
-    amdvi_set_quad(s, AMDVI_MMIO_EXT_FEATURES,
-                   amdvi_extended_feature_register(s),
-                   0xffffffffffffffef, 0);
+    amdvi_refresh_efrs(s);
     amdvi_set_quad(s, AMDVI_MMIO_STATUS, 0, 0x98, 0x67);
 }
 
diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
index e6f6902fe06d..c8eaf229b50e 100644
--- a/hw/i386/amd_iommu.h
+++ b/hw/i386/amd_iommu.h
@@ -57,6 +57,7 @@
 #define AMDVI_MMIO_EXCL_BASE          0x0020
 #define AMDVI_MMIO_EXCL_LIMIT         0x0028
 #define AMDVI_MMIO_EXT_FEATURES       0x0030
+#define AMDVI_MMIO_EXT_FEATURES2      0x01A0
 #define AMDVI_MMIO_COMMAND_HEAD       0x2000
 #define AMDVI_MMIO_COMMAND_TAIL       0x2008
 #define AMDVI_MMIO_EVENT_HEAD         0x2010
@@ -229,6 +230,8 @@
         AMDVI_FEATURE_IA | AMDVI_FEATURE_GT | AMDVI_FEATURE_HE | \
         AMDVI_GATS_MODE | AMDVI_HATS_MODE | AMDVI_FEATURE_GA)
 
+#define AMDVI_DEFAULT_EXT_FEATURES2 (0)
+
 /* capabilities header */
 #define AMDVI_CAPAB_FEATURES (AMDVI_CAPAB_FLAT_EXT | \
         AMDVI_CAPAB_FLAG_NPCACHE | AMDVI_CAPAB_FLAG_IOTLBSUP \
@@ -433,5 +436,6 @@ struct AMDVIState {
 };
 
 uint64_t amdvi_extended_feature_register(AMDVIState *s);
+uint64_t amdvi_extended_feature_register2(AMDVIState *s);
 
 #endif
-- 
2.34.1



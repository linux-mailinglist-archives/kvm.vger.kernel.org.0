Return-Path: <kvm+bounces-63535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 181ECC68CC3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A13BB4F3CBC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7C03431F6;
	Tue, 18 Nov 2025 10:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xot9CMIW"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B433BBC2
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763461069; cv=fail; b=uVqoQSj5OktoEDsL2RVOKecqwgy+EB4l8WwmS9K9VS9fqXlFut1zQ8JlXpZ0pqgswO1NYR5NhSnY/s3ex60ObyKMF8wwAFqZ76GeS8h2THnYEVy58SRmrQr97VtgtP1bkZllq20yS1gA6sLeolwoNPnPsu2Fn8eK68MGoRcVKHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763461069; c=relaxed/simple;
	bh=Bz4ArQ3paThbfmkvbBPjo8fxCdefTaiprRY1c0c3VFw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJ1+4c2UBP2RayW/QW1WoX2a6ls7kXXfcTZcbSCY2S3mxZMLN+OARLBifkCMH3St3qG/fs6br++oCpBLf7CIOOypIiH/jBzSzDeL391q23RwU4mRh0T0WdneePcisAMHa4Py98h9EFGo2YWHb3TvJMQioX+K8J9ovH3wd6H/SPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xot9CMIW; arc=fail smtp.client-ip=52.101.46.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZURxreZ08+GMO2ebQXghEcDNcX1NTniJx5TyBVdpuzr1HzvMj1GSTpMBsuCGxV2WXjlPAn+0rkz9zHEUd+1/Y1Q1JmhfK7AUbXcXp3+q5hVRzcFXVftz4f/FKm6iWzdPsXhpyoEXka4Q8/UwXDAQcWpoeZKgKfaGxCNsnqQzJNCuSvzTo9sqBBPYgtBVBGxhKXCQZAwZWImN8k/lrgAUNa3ZbrG1cmRZAzrZjGnXYarvdmU5pgloQLRzT4VZZjyL/C5GhJoiWFuThyYHYY1s4UcxiTIH93VsWL+GBZB6XP76I47tMxHev4Y6mj8EJfjelV1rx0Hb/LoyOAUGNGX9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPb247kXyTQssEsEAwV+kA348DcMDvVmkdA9UCQknc8=;
 b=KGbh98iGUSo1oUQ7zJHfmLLoYQkSn8J+btI39m1HjgEVdTKjZaFFHHcXkavJLdY08ZAPqviOBLaVK6imgotwWVd/jlUK3rLU7u2v6ErGLRWkio5zafvUjWghNF0/gI9BWeo69463bqZ+5DZR2SKszuuE4WlfgwmShsbZDJY++PWrCPcpRwW+7u1SI30klKRLmmfzK7FdlFMum9sdolGbe1r426LqXehZ1998oXsXMO09VjWVMXkk3Eq1ngiE5SPxYLN4cxQs8smRZVVwWVCzeICS7aSml+4Sq8LZHYlkITLPA7CvXFC714cT3eLLVfMlnFkV4/KR06eBgVkKEfUgeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPb247kXyTQssEsEAwV+kA348DcMDvVmkdA9UCQknc8=;
 b=Xot9CMIWu0yXgzMIk4c6U8ha5g4OeWCb9ZSSXWfNxZXIC2uzRwUJe6Jpw9xxIgkugTN3qbICPYS0Je3dpfPSFdF63cfeIwhsfvW6xXlBe7YfnPkiP0vSXtFar2XRY3SWZzk9Pr5WR2nw4ibY/LpyVHUK102b9k1k6q0ye95wGU8=
Received: from SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::6)
 by SA1PR12MB7444.namprd12.prod.outlook.com (2603:10b6:806:2b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 10:17:38 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:41b:cafe::df) by SJ0P220CA0030.outlook.office365.com
 (2603:10b6:a03:41b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Tue,
 18 Nov 2025 10:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 10:17:38 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 02:17:27 -0800
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
Subject: [RFC PATCH RESEND 5/5] amd_iommu: Add support for upto 2048 interrupts per IRT
Date: Tue, 18 Nov 2025 15:45:32 +0530
Message-ID: <20251118101532.4315-6-sarunkod@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|SA1PR12MB7444:EE_
X-MS-Office365-Filtering-Correlation-Id: 161ebdf9-0cf4-4260-c9e2-08de268bb36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FFcKYz0FPX9qnMt80mWHvoA+nhPIYAhnanyopf9goDS4/kYHwZQ3LWQoQD4w?=
 =?us-ascii?Q?NhJgyEzFhs/c4db+676aQM1MPDTwlrCN1A+L8rrF/okI3kvRl73D1sm5zJE5?=
 =?us-ascii?Q?sqt5Klf8Kkrra6NQZl7g50tD/zE6z4PhY2GVEoPcdYQtVtiw5J8bDxadWsZk?=
 =?us-ascii?Q?pf5qoTLrjh/jxQUaH7Rlj0mbofsugAH4sZu2C+NMo6pIOUlUUl0eT0eFNWiE?=
 =?us-ascii?Q?qOwn3TRGsQGv5S5iiiMuN5l01bYv7OsVtBm43a4B8lEvTuVsM3fViyTSRN9K?=
 =?us-ascii?Q?3Rsd3jLZEE2/mNP4uGtFTi+VaYfYQKfVFhhUDEfr91o+GWxl2bhRRXAkeSwq?=
 =?us-ascii?Q?wWQqmbczFBdirDwAiKB2CdN6+Iw+dO84l6GFwqp6hjiQx43O6bd8EZ9fJHKr?=
 =?us-ascii?Q?1e0rqShAhHBFPQ0daqjHZd7ZMaDTJd9pf3o/HhCYYVPHxOQjm1xAANAAFO3b?=
 =?us-ascii?Q?TlKk/ibAXoZuUQEMNSTLStPoiMHL4VZFodj5Xc+Em53SBjp6NYjpGoQ6as19?=
 =?us-ascii?Q?0fD0F2v85AuUBBm4Qi79WNM3MlCh4Z/wlpaCgrYiZ1ELfXf885iQuZjiJ0Cb?=
 =?us-ascii?Q?asElfgMYuExSzaOqswo8asniE3/JD9dt6uZFAI6WIMmzcqyV+081h1cWvMbX?=
 =?us-ascii?Q?2oVbwSzs9KKwkFDPCfm4MxMGUbwgsfyhyqkGx+vtgFlYRVXBqOZQgzCLGd1d?=
 =?us-ascii?Q?B5Zqe6ILw/ycVY1YE8vdXivinELMjI/jPlLR3y6NT+2nZjBDbMg8Pn/FQJEc?=
 =?us-ascii?Q?1KYZTbxoCVEZGxhfiafFXCNGadVUF8jj6t29bVIvDWxxD+S1OOR9TV8KmvC0?=
 =?us-ascii?Q?Ueky09ssSDYAyhP59CzR9Ra1atsMfTWXGKZnSBDKYVvENQGfxpXtAhaxYMrd?=
 =?us-ascii?Q?mT4bHSei9mtPJe7QsflcJcJotYf56S9ismHfC+U85lOZy7ZfqosNIapzgwdz?=
 =?us-ascii?Q?PrjR5ZODs7pobrJbIouhJe/XaBXSPZAySwmovlNsPT2mwIpXtWAGHLTHp73Q?=
 =?us-ascii?Q?iqTnIRK5s0aEFo3BnDjfXhYBIKtwPiWu6j36Ejh2RYF5PORlx75Zn6JPEG7J?=
 =?us-ascii?Q?mpzbrnZEgCnBegLF266WdckGcVYS7CrszH83MJdkClMWeuyR8qZdS2J+C1Wc?=
 =?us-ascii?Q?EZKHM76WYoWcvmXTo7HUY65dMl5LDfJ3sZDCSZAXmU7aSMCsdzOuDj7j5+Cb?=
 =?us-ascii?Q?ChkQTUCquqpg4OwIkbo4O2so8y5cUEtbaemgRhnl4/xoDPqGw69nrSu05MVs?=
 =?us-ascii?Q?/w12GGBrb8x4m1U14UXNob/DwWkF0pPhKlme7zoq7rgPCAhq/ZTC8K1h5OHH?=
 =?us-ascii?Q?vPc0UzCQVrA+iln97GVIL7M6DPkTfIOXY22+R3s2WXiIMDWvsk8QNV18qdZY?=
 =?us-ascii?Q?AZlSzbuYGRJreVoOqlGraqh30NKleVsZFNliblBOOAtH5UIwsFMTLnogFvHx?=
 =?us-ascii?Q?FOYjt3yeMZ9udBe6CN4zQhdbXom7bAMkWyXn4tW52ZqzbmChYsn2NrNsbtc0?=
 =?us-ascii?Q?Iq48K7EAJK/gxA0RLyQQfj/3dxXZHwMiKjrX+aal+QDzaVGKkwyYV8juSugh?=
 =?us-ascii?Q?w4NMySF2S8RR9ubFytc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:17:38.4311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 161ebdf9-0cf4-4260-c9e2-08de268bb36b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7444

AMD IOMMU supports upto 2048 MSIs for a single device function
when NUM_INT_REMAP_SUP Extended-Feature-Register-2 bit is set to one.
Software can enable this feature by writing one to NUM_INT_REMAP_MODE
in the control register. MSI address destination mode (DM) bit decides
how many MSI data bits are used by IOMMU to index into IRT. When DM = 0,
IOMMU uses bits 8:0 (max 512) for the index, otherwise (DM = 1)
IOMMU uses bits 10:0 (max 2048) for IRT index.

This feature can be enabled with flag `numint2k=on`. In case of
passhthrough devices viommu uses control register provided by vendor
capabilites to determine if host IOMMU has enabled 2048 MSIs. If host
IOMMU has not enabled it then the guest feature is disabled.

example command line
'''
-object iommufd,id=fd0 \
-device amd_iommu,dma-remap=on,numint2k=on \
-device vfio-host,host=<DEVID>,iommufd=fd0 \
'''

NOTE: In case of legacy VFIO container the guest will always fall back
to 512 MSIs.

Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
---
 hw/i386/amd_iommu.c | 74 ++++++++++++++++++++++++++++++++++++++++-----
 hw/i386/amd_iommu.h | 12 ++++++++
 2 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 3221bf5a0303..4f62c4ee3671 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -116,7 +116,12 @@ uint64_t amdvi_extended_feature_register(AMDVIState *s)
 
 uint64_t amdvi_extended_feature_register2(AMDVIState *s)
 {
-    return AMDVI_DEFAULT_EXT_FEATURES2;
+    uint64_t feature = AMDVI_DEFAULT_EXT_FEATURES2;
+    if (s->num_int_sup_2k) {
+        feature |= AMDVI_FEATURE_NUM_INT_REMAP_SUP;
+    }
+
+    return feature;
 }
 
 /* configure MMIO registers at startup/reset */
@@ -1538,6 +1543,9 @@ static void amdvi_handle_control_write(AMDVIState *s)
                         AMDVI_MMIO_CONTROL_CMDBUFLEN);
     s->ga_enabled = !!(control & AMDVI_MMIO_CONTROL_GAEN);
 
+    s->num_int_enabled = (control >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT) &
+                         AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK;
+
     /* update the flags depending on the control register */
     if (s->cmdbuf_enabled) {
         amdvi_assign_orq(s, AMDVI_MMIO_STATUS, AMDVI_MMIO_STATUS_CMDBUF_RUN);
@@ -2119,6 +2127,25 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
      * (page 5)
      */
     delivery_mode = (origin->data >> MSI_DATA_DELIVERY_MODE_SHIFT) & 7;
+    /*
+     * The MSI address register bit[2] is used to get the destination
+     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
+     * and when IOMMU supports upto 2048 interrupts.
+     */
+    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
+
+    if (dest_mode &&
+        iommu->num_int_enabled == AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K) {
+
+        trace_amdvi_ir_delivery_mode("2K interrupt mode");
+        ret = __amdvi_int_remap_msi(iommu, origin, translated, dte, &irq, sid);
+        if (ret < 0) {
+            goto remap_fail;
+        }
+        /* Translate IRQ to MSI messages */
+        x86_iommu_irq_to_msi_message(&irq, translated);
+        goto out;
+    }
 
     switch (delivery_mode) {
     case AMDVI_IOAPIC_INT_TYPE_FIXED:
@@ -2159,12 +2186,6 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
         goto remap_fail;
     }
 
-    /*
-     * The MSI address register bit[2] is used to get the destination
-     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
-     * only.
-     */
-    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
     if (dest_mode) {
         trace_amdvi_ir_err("invalid dest_mode");
         ret = -AMDVI_IR_ERR;
@@ -2322,6 +2343,30 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu_as[devfn]->as;
 }
 
+static void amdvi_refresh_efrs_hwinfo(struct AMDVIState *s,
+                                      struct iommu_hw_info_amd *hwinfo)
+{
+    /* Check if host OS has enabled 2K interrupts */
+    bool hwinfo_ctrl_2k;
+
+    if (s->num_int_sup_2k && !hwinfo) {
+        warn_report("AMDVI: Disabling 2048 MSI for guest, "
+                    "use IOMMUFD for device passthrough to support it");
+        s->num_int_sup_2k = 0;
+    }
+
+    hwinfo_ctrl_2k = ((hwinfo->control_register
+                       >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT)
+                      & AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K);
+
+    if (s->num_int_sup_2k && !hwinfo_ctrl_2k) {
+        warn_report("AMDVI: Disabling 2048 MSIs for guest, "
+                    "as host kernel does not support this feature");
+        s->num_int_sup_2k = 0;
+    }
+
+    amdvi_refresh_efrs(s);
+}
 
 static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
                                    HostIOMMUDevice *hiod, Error **errp)
@@ -2354,6 +2399,20 @@ static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
     object_ref(hiod);
     g_hash_table_insert(s->hiod_hash, new_key, hiod);
 
+    if (hiod->caps.type == IOMMU_HW_INFO_TYPE_AMD) {
+        /*
+         * Refresh the MMIO efr registers so that changes are visible to the
+         * guest.
+         */
+        amdvi_refresh_efrs_hwinfo(s, &hiod->caps.vendor_caps.amd);
+    } else {
+        /*
+         * Pass NULL hardware registers when we have non-IOMMUFD
+         * passthrough device
+         */
+        amdvi_refresh_efrs_hwinfo(s, NULL);
+    }
+
     return true;
 }
 
@@ -2641,6 +2700,7 @@ static const Property amdvi_properties[] = {
     DEFINE_PROP_BOOL("xtsup", AMDVIState, xtsup, false),
     DEFINE_PROP_STRING("pci-id", AMDVIState, pci_id),
     DEFINE_PROP_BOOL("dma-remap", AMDVIState, dma_remap, false),
+    DEFINE_PROP_BOOL("numint2k", AMDVIState, num_int_sup_2k, false),
 };
 
 static const VMStateDescription vmstate_amdvi_sysbus = {
diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
index c8eaf229b50e..588725fe0c25 100644
--- a/hw/i386/amd_iommu.h
+++ b/hw/i386/amd_iommu.h
@@ -107,6 +107,9 @@
 #define AMDVI_MMIO_CONTROL_COMWAITINTEN   (1ULL << 4)
 #define AMDVI_MMIO_CONTROL_CMDBUFLEN      (1ULL << 12)
 #define AMDVI_MMIO_CONTROL_GAEN           (1ULL << 17)
+#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK        (0x3)
+#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT       (43)
+#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K          (0x1)
 
 /* MMIO status register bits */
 #define AMDVI_MMIO_STATUS_CMDBUF_RUN  (1 << 4)
@@ -160,6 +163,7 @@
 #define AMDVI_PERM_READ             (1 << 0)
 #define AMDVI_PERM_WRITE            (1 << 1)
 
+/* EFR */
 #define AMDVI_FEATURE_PREFETCH            (1ULL << 0) /* page prefetch       */
 #define AMDVI_FEATURE_PPR                 (1ULL << 1) /* PPR Support         */
 #define AMDVI_FEATURE_XT                  (1ULL << 2) /* x2APIC Support      */
@@ -169,6 +173,9 @@
 #define AMDVI_FEATURE_HE                  (1ULL << 8) /* hardware error regs */
 #define AMDVI_FEATURE_PC                  (1ULL << 9) /* Perf counters       */
 
+/* EFR2 */
+#define AMDVI_FEATURE_NUM_INT_REMAP_SUP   (1ULL << 8) /* 2K int support      */
+
 /* reserved DTE bits */
 #define AMDVI_DTE_QUAD0_RESERVED        (GENMASK64(6, 2) | GENMASK64(63, 63))
 #define AMDVI_DTE_QUAD1_RESERVED        0
@@ -380,6 +387,8 @@ struct AMDVIState {
     bool evtlog_enabled;         /* event log enabled            */
     bool excl_enabled;
 
+    uint8_t num_int_enabled;
+
     hwaddr devtab;               /* base address device table    */
     uint64_t devtab_len;         /* device table length          */
 
@@ -433,6 +442,9 @@ struct AMDVIState {
 
     /* DMA address translation */
     bool dma_remap;
+
+    /* upto 2048 interrupt support */
+    bool num_int_sup_2k;
 };
 
 uint64_t amdvi_extended_feature_register(AMDVIState *s);
-- 
2.34.1



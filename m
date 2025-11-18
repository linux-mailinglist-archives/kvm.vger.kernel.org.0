Return-Path: <kvm+bounces-63533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F2623C68C9F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 261334F3343
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BBE33F379;
	Tue, 18 Nov 2025 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aUQ0wygd"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C92341660
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763461022; cv=fail; b=nRjSAnlElxEAUImdq8c6+KseiG9rrifhwtPbzYXvkcxYIQq2+QdDJpbQYBkCM2vpqpcevk8soJCBj3S4zsIPs4vqChGe5PXzec0VFDKZ2n9EPY5KZlG7VohPBLdxqdYCPzNkgSQb123UEgi4Iin0nv35NKS+c3ufhUANmAA5RwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763461022; c=relaxed/simple;
	bh=PhlElGyY6wvjBPYM7SjLj9cBr8PdZN6Z4ya+jy4siTc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeWSMpM+Qdh6HmQQTFl+JLJfSv+W8lHIcCI6yc6We4u725LkTT/ErxZZxli8U+5iCLa2M3X572uONuvqpkDhmTGyjY5n+1jJuQ2vjA4eCoRVkdvBYVTJfxrHCQfkYHNQxPrabWowLqPCbZMA7ywcZN1nZfebnwGW7jvMD2o9qJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aUQ0wygd; arc=fail smtp.client-ip=52.101.56.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scGX+2vWs8GOaLQBytm0wNoDhJm76Vr+02YICb+V3f/IxlJ9hafa44TuYMC5syhZSd/RKtyld3LCYYuUCW7+IGmaX5UCnY6RfR7Gbj3Jupcd1Y5N8g1UozKc67K0wjmv5okL7qU41WHx/Oa+xQRI9Z+NLs8KFJH6nBWyIRYucDlCqjEWrK5dEvvzpG//c6lNIodvwhmGMEu++kH6Qd5U0WjndXcjzzDSKTvpO6XH4s6ejcX/aQYpoUJhNmQ/iss45WCQZhKM0mSVFeMvuHMN1ceFaU/SpWuev+vngjJzeawMhgcbcQCs9Pejbi4j5fdPA6gasu9sC1ksyBL001SXRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bf1B/H7NzD2snA92lk0wyoyd2QWsUAmfEuMtaU8nugk=;
 b=X90KtRMXQ6P3oAH3D32IdKlDGc0DE9Zc+tS0KEbuloAyclcycPl/fi3U26/Rjot2gsufkGqyuSnAknCFSzhss8YQzNtr+NoOj757PNQGqTXef79ziJBJ12MzC5Q43YHusrOzus2wk8YX5qFkb0oxdZxRGIYO9Xj35vOU3VDOFjp4ea4fqgKM3vqHK4FIiwpT9S6gGvvo7uvRuS06/sqHz/TG+khnMi0xRmOfztSzxM2KzTmW8l62eiUbDVRaNtAchm8GO1ebvoYCLcuBxPSeipKgUTSXUYpcsXtUMhZricRPl5z2KxaQOiCf+HJS2w7aNXFziaGMswAlPKSLiY55iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bf1B/H7NzD2snA92lk0wyoyd2QWsUAmfEuMtaU8nugk=;
 b=aUQ0wygda60Iq+73y3ay9qH9AG02OuOuExwJQusG8lxKhupTCq7XV//ZKxVrCkqlhfaRemoweFXvjd4yvpufC6MdanUQ9asoaUREqFXdUgSteQe0JXBYJz2WZXq/T6gweJf9M9wlpNKGp9WJGEyGgfsHzpQEXzLcIeXo34Gf7sw=
Received: from MW4PR03CA0287.namprd03.prod.outlook.com (2603:10b6:303:b5::22)
 by DM6PR12MB4386.namprd12.prod.outlook.com (2603:10b6:5:28f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 10:16:52 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::f9) by MW4PR03CA0287.outlook.office365.com
 (2603:10b6:303:b5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.23 via Frontend Transport; Tue,
 18 Nov 2025 10:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 10:16:51 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 02:16:45 -0800
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
Subject: [RFC PATCH RESEND 3/5] amd-iommu: Add support for set/unset IOMMU for VFIO PCI devices
Date: Tue, 18 Nov 2025 15:45:30 +0530
Message-ID: <20251118101532.4315-4-sarunkod@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|DM6PR12MB4386:EE_
X-MS-Office365-Filtering-Correlation-Id: fb0079da-2274-415e-ecf5-08de268b9787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Vo7nRywtMW8OI4HrDODq9ahRTjQrtvK5fDjrPzM08oVU3Kyra/T6ZpWIVz/?=
 =?us-ascii?Q?gQqdGdyo594spWegLdKpYFBpdVAMJilFpmCnXijH3GxZqBaTE04xwlqCsxpy?=
 =?us-ascii?Q?+BvRKh1XOwBc/6W5FPGd9Vx9sEgKmsgXTnqiRPyka82gincc1IfWJqsTl1Jm?=
 =?us-ascii?Q?8P7ttOmTfOVLgVxiP6kXgDq9qa/r3tgTWiBqnM1Z3VvSix5PWfp8JNfXQWlP?=
 =?us-ascii?Q?7CNj4Fe1TcqPI1dFgseNoYKSt8/XIOcDD/bMFIMrcrewru6qq6X7DorchE7D?=
 =?us-ascii?Q?jnSP0gvXn3kj59tzY4v9ilWeua7JYsw69JCZbuVGJrKrRbsiCGTz6IUFHeQZ?=
 =?us-ascii?Q?6+Eh03bcPlwCvQl9/yFDNYN+tzpRrM11sbvoxm/C8/EKaobkoYcewDf97a4o?=
 =?us-ascii?Q?ItjFzrGZIlAmAl8dJ/a+8XSgVJg44wvrqsb4t8HTPRYHN5OcibzBvGxlUygy?=
 =?us-ascii?Q?zvkel21eEtlHBFSnV3F6p+eWjD/Vzzn091+Np5GENHgBSYo28D9bCv+1+mLc?=
 =?us-ascii?Q?8XdCXEyQVx6J/SVYErfJIQS1ZjYvP6+nwmk6g27yXmjGlrS24H8asMvShi7+?=
 =?us-ascii?Q?YfQ1Y4tFwWoBBSpTjcYQfe9DW8RobIML27W4+DH0vS/Me3pr7qgMpSeXhEli?=
 =?us-ascii?Q?FaSNtIC5ftC0fci23r4XIhLj8K8OqM9ow2z9ivdWUuEToAHWG/MOKPma925R?=
 =?us-ascii?Q?uPZLdndaJMP53HZhcrqci/vF7oxP6s/8w1MrkIttAX+o7vMZdeEAGT+rQdKy?=
 =?us-ascii?Q?afTHazhuDKpyt3GuaiEnSIQCTFJx7gKUJVK/ieN6LjU9vWiVh6hVLbCmuQFe?=
 =?us-ascii?Q?ISEUrShP8CSsDBN7FXl39Bqsl5C18cTxQKuW4uGsfPZ3wsFYN0Cflyvj6iJW?=
 =?us-ascii?Q?GafBsHWcSQtfX/j5c6P741h2p5hy8Cv/OEVkpRtMlZDt/47jTGewKaaa1l7W?=
 =?us-ascii?Q?uf8K18tBQRfAFzurdtuIQx0/camcohynGqJycj2mg3EmiUr5IlsyFseZENMw?=
 =?us-ascii?Q?Pw8zm5mdgejR5LljYHqJuPJ1sgY5GMWooyJcpod2PDumBbsp6oGmY/DwmRA2?=
 =?us-ascii?Q?zDtjZ+IRu2bHhU97vwxNL3wL2tUWCLJ2W8k2h1dSZTps1zWYE5uNYKJ1HYol?=
 =?us-ascii?Q?FPzJaS/tyASHNpVBSlR0ZYjosERAJnt7QsuzITKKpXwcmBOfOY71ePGpAqkr?=
 =?us-ascii?Q?ifWydcwC7vw+/lbEeEovtpN94c83c56Ash/GYKnmHcohbX7k6mjmgvDeRwF5?=
 =?us-ascii?Q?UN2kbBvqru6l3hCCfWxMhR276mK+y52ZJuoox0fu5HWok9TFyTkvkwf+rN93?=
 =?us-ascii?Q?+PcFAotrKKr1h5To8rmq3gGXp+NWaQzVlS+IA0X2moLR/FmWn6k8lS8Ku4DF?=
 =?us-ascii?Q?/QIJNZJJcQyFe/ArjPdlN8Vt8vuEUmYSjVVmtID+y5KTdwTb1eWj0qysvjf7?=
 =?us-ascii?Q?Oj6CWcGQTEWHTlAfH/30sPauZ5qy3kpTgOz2o0q0mlbcbf+nUYmsF3ptRmKP?=
 =?us-ascii?Q?ZOcehv8IlWKbxOLqqM6w0Q/InUVRiKAJbU7sz1qmQ5Ct4ga7rDv8MqrQnIRv?=
 =?us-ascii?Q?VE/8MtjstoGGVqmALHQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:16:51.6405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb0079da-2274-415e-ecf5-08de268b9787
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4386

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

"Set" function tracks VFIO devices in the hash table. This is useful when
looking up per-device host IOMMU information later on.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
---
 hw/i386/amd_iommu.c | 71 +++++++++++++++++++++++++++++++++++++++++++++
 hw/i386/amd_iommu.h |  8 +++++
 2 files changed, 79 insertions(+)

diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 378e0cb55eab..8b146f4d33d2 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -382,6 +382,22 @@ static guint amdvi_uint64_hash(gconstpointer v)
     return (guint)*(const uint64_t *)v;
 }
 
+static guint amdvi_dte_hash(gconstpointer v)
+{
+    const struct AMDVI_dte_key *key = v;
+    guint value = (guint)(uintptr_t)key->bus;
+
+    return (guint)(value << 8 | key->devfn);
+}
+
+static gboolean amdvi_dte_equal(gconstpointer v1, gconstpointer v2)
+{
+    const struct AMDVI_dte_key *key1 = v1;
+    const struct AMDVI_dte_key *key2 = v2;
+
+    return (key1->bus == key2->bus) && (key1->devfn == key2->devfn);
+}
+
 static AMDVIIOTLBEntry *amdvi_iotlb_lookup(AMDVIState *s, hwaddr addr,
                                            uint64_t devid)
 {
@@ -2291,8 +2307,60 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu_as[devfn]->as;
 }
 
+static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
+                                   HostIOMMUDevice *hiod, Error **errp)
+{
+    AMDVIState *s = opaque;
+    struct AMDVI_dte_key *new_key;
+    struct AMDVI_dte_key key = {
+        .bus = bus,
+        .devfn = devfn,
+    };
+
+    assert(hiod);
+    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+
+    if (g_hash_table_lookup(s->hiod_hash, &key)) {
+        error_setg(errp, "Host IOMMU device already exist");
+        return false;
+    }
+
+    if (hiod->caps.type != IOMMU_HW_INFO_TYPE_AMD &&
+        hiod->caps.type != IOMMU_HW_INFO_TYPE_DEFAULT) {
+        error_setg(errp, "IOMMU hardware is not compatible");
+        return false;
+    }
+
+    new_key = g_malloc(sizeof(*new_key));
+    new_key->bus = bus;
+    new_key->devfn = devfn;
+
+    object_ref(hiod);
+    g_hash_table_insert(s->hiod_hash, new_key, hiod);
+
+    return true;
+}
+
+static void amdvi_unset_iommu_device(PCIBus *bus, void *opaque,
+                                     int devfn)
+{
+    AMDVIState *s = opaque;
+    struct AMDVI_dte_key key = {
+        .bus = bus,
+        .devfn = devfn,
+    };
+
+    if (!g_hash_table_lookup(s->hiod_hash, &key)) {
+        return;
+    }
+
+    g_hash_table_remove(s->hiod_hash, &key);
+}
+
 static const PCIIOMMUOps amdvi_iommu_ops = {
     .get_address_space = amdvi_host_dma_iommu,
+    .set_iommu_device = amdvi_set_iommu_device,
+    .unset_iommu_device = amdvi_unset_iommu_device,
 };
 
 static const MemoryRegionOps mmio_mem_ops = {
@@ -2510,6 +2578,9 @@ static void amdvi_sysbus_realize(DeviceState *dev, Error **errp)
     s->iotlb = g_hash_table_new_full(amdvi_uint64_hash,
                                      amdvi_uint64_equal, g_free, g_free);
 
+    s->hiod_hash = g_hash_table_new_full(amdvi_dte_hash,
+                                         amdvi_dte_equal, g_free, g_free);
+
     /* set up MMIO */
     memory_region_init_io(&s->mr_mmio, OBJECT(s), &mmio_mem_ops, s,
                           "amdvi-mmio", AMDVI_MMIO_SIZE);
diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
index daf82fc85f96..e6f6902fe06d 100644
--- a/hw/i386/amd_iommu.h
+++ b/hw/i386/amd_iommu.h
@@ -358,6 +358,11 @@ struct AMDVIPCIState {
     uint32_t capab_offset;       /* capability offset pointer    */
 };
 
+struct AMDVI_dte_key {
+    PCIBus *bus;
+    uint8_t devfn;
+};
+
 struct AMDVIState {
     X86IOMMUState iommu;        /* IOMMU bus device             */
     AMDVIPCIState *pci;         /* IOMMU PCI device             */
@@ -416,6 +421,9 @@ struct AMDVIState {
     /* IOTLB */
     GHashTable *iotlb;
 
+    /* HostIOMMUDevice hash table*/
+    GHashTable *hiod_hash;
+
     /* Interrupt remapping */
     bool ga_enabled;
     bool xtsup;
-- 
2.34.1



Return-Path: <kvm+bounces-18418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFFB8D4A4D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A38B1C2231F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95C91761B8;
	Thu, 30 May 2024 11:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4lBKtUmR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF221761B2
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067834; cv=fail; b=roy1ckDC4e/feyntkusnZamCbaDeLjbnNP4PyVCGaPxWqgFZRr+Ft/MstDBB1N2+pJXnk6faODoUzQ8bBAJOFgAO7PY72+x/wEF0fAdHm7iHY6HkhrFORHd/A9I/BhmYTb4N+hL/2mfgrVroebOvV4pCdwn85Sjollxg49re4TM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067834; c=relaxed/simple;
	bh=Vf1Lh1l7UrceRstoRIuH9Nk1/cRheFxPZ8+nO6HrUKk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M57JVZT/fc4reT8PUV1MpDL8s+TV6QRQz5FW3eipJJid057MceeYMs2/A2F73wctQS6ca6xuu6XjtlLTjuqYZMujc1uif7JK+92vR/eqJ9/4qVCl7QHJcfJi9PA9YWlYXztdhs0YsVCpJUR5FOkY+pgD/V9rsc7cjOC8vZNQ8W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4lBKtUmR; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGPHmpr5WvTu0h0+snCJsqLr9mjDHiRUTzgBnu3NeS4Yk7yIvpfDR1aS1+TXzZy7QEj2AgdJkwUtMsAyQCuqLw1Hl4xKMPYFW3ghbEkLZMcudXFwYFcOiQQqvZISlq9r2NawlBUDj8ZgZkWKiiGYerz+pDeNwtBtYg7dk14vUS4cmk0QDsU3ui9/AO9UorRDu2hko25y9f8MrfSwj6MikurASnbEN6rsJwE1ji0PGqTnVOerg1028r0bNI9B6iJNZoaQzwzaDUH2QFjoxwlZQ84uDZLBEk5s0deq8SUQISsAXtXJbakz9rHhNLqax5O3DTmSurrKX9jSywRQtVeCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQzio6BhWqWfeYOoY/C3vUF9KAwOA/c0yNwqi+AAPlU=;
 b=MdrJBzOHyWISwEOzJ6zw+ZdfqDj4sS3DIE6CT58MW1fBn8f4/l/FHOK8CmP1tiFyv+dI2vQHVAUJ+Ion4TmA9m4Lydh+nTvJdHd6emyFeWs3LYFSGXfq4YJo4OIj77lYXGuINVjiVGW0YwE/StgWvOdKcV+aDJ7OQW2oNlsoOwwwFeUCyN0MOmFok+xggtnJKV342qTjPcEQbe/VCKnXIWQWQODLZgbT4oJ8dtbmUANzwdoXqqYDX/lN8c+LQeZeupqSs4WgRnw1V7lpEJcKgpMUuOJF8q+5e1TgdZzhCBsxZPwOls1J7wkNKR2TbMy8yz3b3VT1jCjgUeH+VbMv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQzio6BhWqWfeYOoY/C3vUF9KAwOA/c0yNwqi+AAPlU=;
 b=4lBKtUmR9w21tqLIAWHkh0WppF/kQ2zq2S57kyRbhMijhpXpV8qtZ1xiCsUwGU3a8haBtOqdP9n2Xl/LF81WXHxMakLzuHFXsZ5wWVxErBo7UUYve4an3atkfbjobXYmZ9/olq7/zB4t7RSWBz8D6K6DyECfyquAq2T4OvYXyvU=
Received: from BN9PR03CA0687.namprd03.prod.outlook.com (2603:10b6:408:10e::32)
 by SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 30 May
 2024 11:17:09 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::a0) by BN9PR03CA0687.outlook.office365.com
 (2603:10b6:408:10e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:17:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:08 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:02 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:17:02 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction with -bios
Date: Thu, 30 May 2024 06:16:41 -0500
Message-ID: <20240530111643.1091816-30-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|SJ1PR12MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: 32f028dc-7b39-4aee-1991-08dc809a0b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ZT+PLg2lp3P5WY0M+mu2Mb0/blL455eG42qMj6BS9osF+JJz10HSrxfwtJ4?=
 =?us-ascii?Q?2HZQYcP4huO7bm4EHpGIVxxhva2N/PGgkTRL858Y7+CXEE0pt36IEZPIAx0C?=
 =?us-ascii?Q?usjuHZTM3/wO+sgDbkk4t/oqZYmjrkf1svS1CWc6oBsAWO1JzSYUCSGS7Rgo?=
 =?us-ascii?Q?fOnewuwC+7PYwUL+xoL7qrneOCvE0o9KI+gAdE/MTJBzhvN0p+te5sSilmmw?=
 =?us-ascii?Q?JTj9Xz4FqCHhcskxtgTfLhrN5Y3jpmt8CWQkqQ32OXmuYlBNDwATeWxQc55R?=
 =?us-ascii?Q?vBLCS1VWfMkC1ID9jix2UUsJx1xVNQLHtO4YO1n6jrxOZr14WgG5Fj0YZb8o?=
 =?us-ascii?Q?p24OIyOwQHKJ5o6h0xtK/BiBIIPqj4L620sQp8eWoi4PiFNwhyExYH/XM9Av?=
 =?us-ascii?Q?oDIAPH7LmGVI0n56XUk6eq/HVHQGylLmq5u8ewyzs1+/s4YMi1t+JctZ5uKZ?=
 =?us-ascii?Q?H2F4gO0kV3FZ/0MVaBXHh1DtXTs9EgE+5C4LMuykDdzHpGy0g4w/fs3PJYLb?=
 =?us-ascii?Q?pmeZbpX7T/13ge43bvLzMzRr3HX19r3kQwfOop25fqam925Tu6ZwCHRKfSvY?=
 =?us-ascii?Q?Ri9sWnRATnT69kBwXumlN2LrdIMcgNCLJuDu0R7ACRxHufX+UUnEFDgl/CfP?=
 =?us-ascii?Q?x45XVscYtryN9miOT1kbFBQlsssRyRsZL9tm40xL0O6PYcxLETyvbF7KIHZd?=
 =?us-ascii?Q?p6xvmI84G7f4qvnSJgmW+k6b5vL/m07pLrz3jLSAEqRubj1Al3+RfKZ3pLlG?=
 =?us-ascii?Q?b1LIYuHQ9ciiKoeEuEv+24PmkJ5JP3uIFqS3bsWE0f6bDeY/JUw771CX9uba?=
 =?us-ascii?Q?WNmEKiQnaDu0cg6GhfwPsKu0tOwnzq6niVNry2aMO1vW83ufb1SyYiADohZP?=
 =?us-ascii?Q?SsWPmDW7I21n2TyS8ppF7CnG/HcgP2TvxnR2Mks8viEz+fXP6jzgpHXk51pJ?=
 =?us-ascii?Q?OXw+uR0N49Vs7jMvnQ1faAonn2LhhIrKPvUZO7NPkkDD2xCPV9JLt63n4zN3?=
 =?us-ascii?Q?tUUS5Kq/jXJaKZwy+7BqS1XLbkL6zcnh3bTsO6jk3aGuQ7xRIFljigjRXi3j?=
 =?us-ascii?Q?4EMWGubM7Flx6alntuKVErWTLvda/COJ037QGHVBZzPXtdf7i3xXFbP6Ghks?=
 =?us-ascii?Q?bWbtLM8vC+yZVY0/efEIfLb9eG7x92FBDzVk0WmNnujRcNhizDM1c7SD+8mb?=
 =?us-ascii?Q?BuB42zHowDaibZWWuXFpDKiV5r6DercN1ExwGx/ddYEBPAoIZAtfcXhKp/Ou?=
 =?us-ascii?Q?zGLrRmGLmhmzxVkuCmGkdw6rBKxADNvYcA0/zzCey3oSeqoCydfldBPZo9cV?=
 =?us-ascii?Q?V3RjShhUctrolJ/h5ZWCkfhRnJFENqrUG0T5aLd5Dk7hOn+KKzYh27TD4B60?=
 =?us-ascii?Q?bMwlZ9cgdGzsNgb8MAqRZUB+dKbr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:08.7160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f028dc-7b39-4aee-1991-08dc809a0b96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6363

From: Michael Roth <michael.roth@amd.com>

SEV-ES and SEV-SNP support OVMF images with non-volatile storage in
cases where the storage area is generated as a separate image as part
of the OVMF build process.

Currently these are exposed with unit=0 corresponding to the actual BIOS
image, and unit=1 corresponding to the storage image. However, pflash
images are mapped guest memory using read-only memslots, which are not
allowed in conjunction with guest_memfd-backed ranges. This makes that
approach unusable for SEV-SNP, where the BIOS range will be encrypted
and mapped as private guest_memfd-backed memory. For this reason,
SEV-SNP will instead rely on -bios to handle loading the BIOS image.

To allow for pflash to still be used for the storage image, rework the
existing logic to remove assumptions that unit=0 contains the BIOS image
when SEV-SNP, so that it can instead be used to handle only the storage
image.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 hw/i386/pc_sysfw.c | 47 +++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index def77a442d..7f97e62b16 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -125,21 +125,10 @@ void pc_system_flash_cleanup_unused(PCMachineState *pcms)
     }
 }
 
-/*
- * Map the pcms->flash[] from 4GiB downward, and realize.
- * Map them in descending order, i.e. pcms->flash[0] at the top,
- * without gaps.
- * Stop at the first pcms->flash[0] lacking a block backend.
- * Set each flash's size from its block backend.  Fatal error if the
- * size isn't a non-zero multiple of 4KiB, or the total size exceeds
- * pcms->max_fw_size.
- *
- * If pcms->flash[0] has a block backend, its memory is passed to
- * pc_isa_bios_init().  Merging several flash devices for isa-bios is
- * not supported.
- */
-static void pc_system_flash_map(PCMachineState *pcms,
-                                MemoryRegion *rom_memory)
+static void pc_system_flash_map_partial(PCMachineState *pcms,
+                                        MemoryRegion *rom_memory,
+                                        hwaddr offset,
+                                        bool storage_only)
 {
     X86MachineState *x86ms = X86_MACHINE(pcms);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
@@ -154,6 +143,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
+    total_size = offset;
+
     for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
         hwaddr gpa;
 
@@ -192,7 +183,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
         sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
         sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0, gpa);
 
-        if (i == 0) {
+        if (i == 0 && !storage_only) {
             flash_mem = pflash_cfi01_get_memory(system_flash);
             if (pcmc->isa_bios_alias) {
                 x86_isa_bios_init(&x86ms->isa_bios, rom_memory, flash_mem,
@@ -211,6 +202,25 @@ static void pc_system_flash_map(PCMachineState *pcms,
     }
 }
 
+/*
+ * Map the pcms->flash[] from 4GiB downward, and realize.
+ * Map them in descending order, i.e. pcms->flash[0] at the top,
+ * without gaps.
+ * Stop at the first pcms->flash[0] lacking a block backend.
+ * Set each flash's size from its block backend.  Fatal error if the
+ * size isn't a non-zero multiple of 4KiB, or the total size exceeds
+ * pcms->max_fw_size.
+ *
+ * If pcms->flash[0] has a block backend, its memory is passed to
+ * pc_isa_bios_init().  Merging several flash devices for isa-bios is
+ * not supported.
+ */
+static void pc_system_flash_map(PCMachineState *pcms,
+                                MemoryRegion *rom_memory)
+{
+    pc_system_flash_map_partial(pcms, rom_memory, 0, false);
+}
+
 void pc_system_firmware_init(PCMachineState *pcms,
                              MemoryRegion *rom_memory)
 {
@@ -238,9 +248,12 @@ void pc_system_firmware_init(PCMachineState *pcms,
         }
     }
 
-    if (!pflash_blk[0]) {
+    if (!pflash_blk[0] || sev_snp_enabled()) {
         /* Machine property pflash0 not set, use ROM mode */
         x86_bios_rom_init(X86_MACHINE(pcms), "bios.bin", rom_memory, false);
+        if (sev_snp_enabled()) {
+            pc_system_flash_map_partial(pcms, rom_memory, 3653632, true);
+        }
     } else {
         if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
             /*
-- 
2.34.1



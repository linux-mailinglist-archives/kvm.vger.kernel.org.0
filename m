Return-Path: <kvm+bounces-18415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5DF8D4A49
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64D80281FB2
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAC41822FD;
	Thu, 30 May 2024 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BmpF6A2W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1941822CD
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067826; cv=fail; b=nAMqlfYy0EUg9fHB5pXzNGSHW++lAFrNBrJj5BTc/ueIG4R1aiFoLLeFbNjfTlDTXVawGsLWVYcd/vIIQK7hlISKClQEYwPsLnWEvUw2xjDb8mcRvW3ZcHpAL81IMMX8rcn1wGKFnazbN73QTq8C83DZyCShCg+d2gLjSySv8JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067826; c=relaxed/simple;
	bh=aCc4kG/GLQ467Vo3iqYG2jipQsEdf4KBy2m9NL7iqac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDP6mN25/YFjOdEPr84izaRFcmCcAoHmnQpz77SBvLE+dw96Ll8YKIftVCE7JOgdwL6WQiBTa5GPqy4MVtJmSkK6Rk4EIaAZnW1uper9EZv7S7+b392wBuLHHRhQTWqvDBsAn77riAJKm0MrgBebDmWRJHp0QmGUyUBldIyuR5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BmpF6A2W; arc=fail smtp.client-ip=40.107.102.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ikt3GdTpKCAHiLx8ozTxSpnzsMz9XNQbQ+4HK2d/j3k/9w1g9hF3RK9KtTL5wXC9TabHNSmm46avRbaISWq1qNTqaXdvrXQtkB8JMWgUtg15f//aIo0wP3AlW/JOl3oeQrn1V8dzOE2CDKe1VgbnYdiVXin4VZsDCPuFkvztP15hIbygYU1NZsMIQgAEH9nTsUzbVij30Ir9ogTuVsgMgUppio1MDWLJ6yhmWIk/XgWpvL8z+1iz2PQHayW6v6HtG2cBFonM48gA6NH5SBcJ5dWd8msuyz+icG/vVD5HpqW+/NVpkL3511g5rYSRIQwuBOtI73gEhAfpm0G5fwJHCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6lss2Hg9OxWRNKdJdzyXq7LJ3ceSxLzrC+ts+YdeIg=;
 b=h6e1dYB9yJ26hSZV0KdYD3YKfJ0sTlFYKv4rRqKRRUytmYqk+grtUsN9sHv3ARaugnv0nVA2PVEqxjm7sbHE1YvgTItPpeFGzLMDSIgYZeIEkZwP3xvyLqxHmbTWED+VUfp5x1ygkKDn1CCbZUV/+KeNxtd8cZVTtdCEFg5RoBk30cXfEsbPOriBxT5c/6q7xV+L1FwCg1TNMgQRiAby4GiXEAkynE1mNpvQq9Ura1U0kTl5cU2jGpQrsWzmux+sClVjl7eJmS6741lglr5Ap1eP6ccQx2q3/lKnmneXbStntvvTxsUMw5JObg5M1350ir5la34PFRW47p7GB9wcVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6lss2Hg9OxWRNKdJdzyXq7LJ3ceSxLzrC+ts+YdeIg=;
 b=BmpF6A2WbnA1Chavg1NueMcHYoYAeJ6CMxnMXlgExfuRvBH7Gp1uWBO+PiKJlmOb7cfNV4VF1JYH0iWLsklAhtQbMjheyfUuYi5Hz6ve+i8Zb/0KJyYzVZSHPvN7iMKU+GluXKaFcuS5dHqqgo33h7I0Iquiur3hBlnvcNguLlg=
Received: from BN9PR03CA0761.namprd03.prod.outlook.com (2603:10b6:408:13a::16)
 by PH7PR12MB6934.namprd12.prod.outlook.com (2603:10b6:510:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 11:17:02 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::e5) by BN9PR03CA0761.outlook.office365.com
 (2603:10b6:408:13a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:01 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:01 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:01 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:17:00 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 27/31] hw/i386/sev: Use guest_memfd for legacy ROMs
Date: Thu, 30 May 2024 06:16:39 -0500
Message-ID: <20240530111643.1091816-28-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|PH7PR12MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: b7e5f545-cf03-45b9-6b2b-08dc809a0779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xMzsJqpZD+6+QHzbhcTR4Lhfd7l5Xvs2UObFprFDgpH4Pjs2qBLLOgv3m0rk?=
 =?us-ascii?Q?5bY7BKtl8+vVqBsS87oxHjw8LSjbRzFAR/1gagc5QZftN84bZeLtaN+/kpHQ?=
 =?us-ascii?Q?067C0TQ91Px5RCrDmUoi+I8migWgF33fV7IGUOpxX855c6yWKwhJI0Yrwyww?=
 =?us-ascii?Q?ctKhtyLLbMtamwU8bXtLwhsuNCbzURGyQtZOz6TpAi0zHt168CWp7hWgqTpi?=
 =?us-ascii?Q?At4tXgTaWvyA460zeInOw2unp9NbXtbCCy4KcjKzGRGkGEZXhmIm5GFDdp6U?=
 =?us-ascii?Q?BfKyidWpHBS4HnoBcRr34mqR0R3vr0EPYaVzuXRpemM/n+rZmhwvgs1yk5MJ?=
 =?us-ascii?Q?RpXble2+vfxX9luAVXpvhltWhK//86XMN0U3VL/G6TfRXBfR1y5FDnl0aMM7?=
 =?us-ascii?Q?tipMmhoKVZhdWQJndm/Mm36A0C1TZpOC0Y1StM8274EkWPyhbOggo3UKdKVP?=
 =?us-ascii?Q?sEVOPOqdRe7n94whYcBU7nrgEzGdtDOQkmOz2JBO52Rjx8D5eZCCbGgafSFV?=
 =?us-ascii?Q?6tiin/GtwygmgqaZ/SaX9cEFoLzT9DnoHQIlB/39qyEtk+A8qYgFzXRBU6v0?=
 =?us-ascii?Q?EYCUS6doVFzhgjj6nDxz/0d1kxsi/jbREoj4DOVZeObw592QlQcks+VdTvXK?=
 =?us-ascii?Q?rJUmuyhQ+hGo/f7oFz/ByU6SnbPcwGsQAgJ+K8Dm5sIwqkqpJEAhhFrkAO/8?=
 =?us-ascii?Q?LgoQxgCWdiWGT1/6yZN6hxi0LTDx0Tkn9I1O9mohqntCdxaaVvYsBYAWFCBH?=
 =?us-ascii?Q?rztYBTz24UViquOg+gFa2F+RwE46eMDO3Vy+Ut6TyFtE3/8rRwjPO+qk/TQj?=
 =?us-ascii?Q?mBxzy1RfSjOgv2p8OaIW6haXPSIrvE86JflD0WqkZ3QOfti4SE05G1kUGj13?=
 =?us-ascii?Q?pcYnFHMCYQvvt2tDT5MP7zu4tey2Ps2meSV2JwAHlwlBJMK4E+RZldYQ7TNe?=
 =?us-ascii?Q?eWeRarFoZ8A/IyOvfcV1rmv++wnOCuJLHd0a6kcfLSmNHa3M2m8RzbkxTJk3?=
 =?us-ascii?Q?St9ZQa1t+RG9+fWjTZW8o2rGw4ps5q/3b5YbJV9WMaKa6kXFRsC5BGunlkTM?=
 =?us-ascii?Q?Xs14mTIwC2IZvAmSvbFGd0W7wHbMawYd8P6WDGmBUX+FckwbkNLU6t7IC7UH?=
 =?us-ascii?Q?wpabIWqWdrH8q1cWn9PVousubikagn/3KHil13HmpDRGE9goaw7eGhJjI8eL?=
 =?us-ascii?Q?vAUv+Ih2x8pZ05fzDE28K7TD8MA3SU5BVhzMZZ6XSSELrwm/EL2XbofF1ePa?=
 =?us-ascii?Q?f8amRshFGnrcJYBYplXSXWVFn9LKBfaJ9TOJRUtqA5xcF2yx7OOoyxDFva4i?=
 =?us-ascii?Q?Orb3swIFepsd39OtEQgTY1vMfx9hdlMXhdpRtgO/m6ImFlCVxU6HUB3lb8mE?=
 =?us-ascii?Q?j/5kl1EkhJp0PcN/hFQ6+EkujIHh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:01.8015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e5f545-cf03-45b9-6b2b-08dc809a0779
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6934

From: Michael Roth <michael.roth@amd.com>

Current SNP guest kernels will attempt to access these regions with
with C-bit set, so guest_memfd is needed to handle that. Otherwise,
kvm_convert_memory() will fail when the guest kernel tries to access it
and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
to private.

Whether guests should actually try to access ROM regions in this way (or
need to deal with legacy ROM regions at all), is a separate issue to be
addressed on kernel side, but current SNP guest kernels will exhibit
this behavior and so this handling is needed to allow QEMU to continue
running existing SNP guest kernels.

Signed-off-by: Michael Roth <michael.roth@amd.com>
[pankaj: Added sev_snp_enabled() check]
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 hw/i386/pc.c       | 14 ++++++++++----
 hw/i386/pc_sysfw.c | 13 ++++++++++---
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 7b638da7aa..62c25ea1e9 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -62,6 +62,7 @@
 #include "hw/mem/memory-device.h"
 #include "e820_memory_layout.h"
 #include "trace.h"
+#include "sev.h"
 #include CONFIG_DEVICES
 
 #ifdef CONFIG_XEN_EMU
@@ -1022,10 +1023,15 @@ void pc_memory_init(PCMachineState *pcms,
     pc_system_firmware_init(pcms, rom_memory);
 
     option_rom_mr = g_malloc(sizeof(*option_rom_mr));
-    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
-                           &error_fatal);
-    if (pcmc->pci_enabled) {
-        memory_region_set_readonly(option_rom_mr, true);
+    if (sev_snp_enabled()) {
+        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
+                                           PC_ROM_SIZE, &error_fatal);
+    } else {
+        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
+                               &error_fatal);
+        if (pcmc->pci_enabled) {
+            memory_region_set_readonly(option_rom_mr, true);
+        }
     }
     memory_region_add_subregion_overlap(rom_memory,
                                         PC_ROM_MIN_VGA,
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 00464afcb4..def77a442d 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -51,8 +51,13 @@ static void pc_isa_bios_init(MemoryRegion *isa_bios, MemoryRegion *rom_memory,
 
     /* map the last 128KB of the BIOS in ISA space */
     isa_bios_size = MIN(flash_size, 128 * KiB);
-    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
-                           &error_fatal);
+    if (sev_snp_enabled()) {
+        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
+                                           isa_bios_size, &error_fatal);
+    } else {
+        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
+                               &error_fatal);
+    }
     memory_region_add_subregion_overlap(rom_memory,
                                         0x100000 - isa_bios_size,
                                         isa_bios,
@@ -65,7 +70,9 @@ static void pc_isa_bios_init(MemoryRegion *isa_bios, MemoryRegion *rom_memory,
            ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
            isa_bios_size);
 
-    memory_region_set_readonly(isa_bios, true);
+    if (!machine_require_guest_memfd(current_machine)) {
+        memory_region_set_readonly(isa_bios, true);
+    }
 }
 
 static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,
-- 
2.34.1



Return-Path: <kvm+bounces-12263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BECE2880E04
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7420A284509
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D20639ACB;
	Wed, 20 Mar 2024 08:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ALp8rBgC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827E39AC1
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924976; cv=fail; b=FgX4zAXbXrTtH7ooHG+ePHa2BwzRv6d4wX1CiGKnuiJncpQR2irjVjZRQeK6geGHNCD6DlA3NNtMjcS9yVuVfs7rrFrf+1GMMlmWj+X4Ni9cPB74hJRJuOV0I17VIjg2VIVANx/Y6oyZKMMPfGn4BGwlPzKVhwM7Ozey/HUJcIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924976; c=relaxed/simple;
	bh=9s6dVFxYHMwgvp09hx/VMFYPjtM6jvtgjx9PzvEleMg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyYXGPoed5Ng2ii32glzjyzy4CWITS3uECnrb+gLu7FcRnZMmE3v24eIw/lqmX5OSCl7hYukuOQ0INupJ1M7gBIvCnDMr7YhoppTOWRthEh1Jx/ycSTghpckXXQz6SoV9NoK9bqJehlG4gHZbdydrl+nOX7guw8VWw3M1IH3Oa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ALp8rBgC; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeBlpNlXQxuvWvoIP0Lezk8qMm07hVp9Xomsrz22eHkeI+Jw/ncn46iPF8Z69L7uaK6vmQJs9X9hHO2o8Z9cku58s9GCCH/mFWzbV8Y4UfvBdKM8NOYvzb2D354nY+CRHQEclX9IWbnF2z2hA1mn9lmakCctCY8VOhH+rfn66a1ustPu0UvuDbbMVuo5zp0DT8/9Kw3x8xvKaeYZCLAyQgISuX7hg4Wwu5J4IOg9DeejBkfmxXNmrBhISDziaIPr/1lfV71MV6Ege8HD8sy5YlH1j16eHCJoh1C5G4O8Sp22zRPijrm6ADob9fRLjy6xobY/2Erkpco3RKPTT/alKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0E/Kfm7FjVTHJdrRiizkTs8U/YQj6h39yD41y1O7YEY=;
 b=MonyoSvxha17UvF9fZoijSG9k9Hqsgd3sFj+8FaCmFxZ1qbNCHVxaO8bG/PnuIncfuySSIEWugr3WpehMa3LtX/0eDKqmfc6TFKu4dY1xsdfsYSub/Q8JaZKlsfRoW54JMr+/RtXy+GlYQ1vzA5CD76YFe0EuW3067p1sm3nNDnE44Q1VLDeemnZ+QUJzJILGlvnzDaPV1e/uMO5DKTgNUvRzlDQYf1hs2VlyRv/eLpPpFfxBYu+IwxSSfbBaEdYXiEMbFo96h4078ZiOAsJlLm+WDpBbXel6WR5xMrDOrgn6Q5bYpxPBPhfneKj+lO7zY8ueS0N2SZd2eCQ70YgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0E/Kfm7FjVTHJdrRiizkTs8U/YQj6h39yD41y1O7YEY=;
 b=ALp8rBgC4zxEExXM2cKfpIJj1CX9AMpZkUw5hN3BYedy7uPRWkKM5fT/s+43wQdfKBvNSS+lya+RTy/nYTfgrjWb+jEIaYw6/pWHbVnvGtd3r9Cl+NUnQ0zWGP284rrQyvMI5gfhscf4ChoPTl/8UQ4fuNlDiqr0RZtX+ZuJGlc=
Received: from BYAPR07CA0032.namprd07.prod.outlook.com (2603:10b6:a02:bc::45)
 by MW6PR12MB7085.namprd12.prod.outlook.com (2603:10b6:303:238::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:56:12 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::47) by BYAPR07CA0032.outlook.office365.com
 (2603:10b6:a02:bc::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:56:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:56:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:56:09 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 48/49] hw/i386/sev: Use guest_memfd for legacy ROMs
Date: Wed, 20 Mar 2024 03:39:44 -0500
Message-ID: <20240320083945.991426-49-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|MW6PR12MB7085:EE_
X-MS-Office365-Filtering-Correlation-Id: a6bbff3f-3dc2-47bf-2ea7-08dc48bb97a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oP1IYz3RRSF70OF0Wt1opqwX+IbO53yRvmllQP8V6FOufCgL07I3iwo6iB+IPzw2/Q5gpIlpf2hNkAeLz8fJtzBUD7q2DRbvl47VUFzYDUODT7AGEiv+h+NcYI2RiJ9pz4KAAyke77QsYqpll8ISFBv8mM95um/S01gI+CTUTrsFSdfXiDI0h9QwLSPogwXeg1Gv4aXFP9wRCEov42oo/13i+3sXK8yZ9klHitUOBGnb1kuZ7RUbMLo7SfZLLRMkbpyneV+WBa5OqDoRDQuZMeQ8S+/LAwpsSyrq0Oxj04wY4eYb2H8lS8OfP5EMitlHqWEoqXdk2dOFPeWkv2BFbhvuzUD41dqh787CNDYu24ZlABqypyudNyD6JizAXX83rpx4cFoZGDWkzUDDRgYBIKFvB3qwBaAzelBlMq3EAKQmwO30CdxZAilXJr9VcG83axsTdlXBOmjdVLNvtvywFFA8sqaJi6yTQ6mP5sGrUN4/bEwbMCykwr34Aooa9z5rNrFLMBnetAAAQt7XASkf6MCrjoTx8AOjlzd+3pzkWDPGOYUg/zWRaYtmYOPSXHpR384wGzCPjuduQrZBit+bFQGLOafg39AaDg2rOi4Nc5SdFm/X+p5Uh03dlvLhApgyjTCmQTeBK79D96O5YPQtmKnj1rO25/C4mL6MpiupTtmHHzJzxmlFGfxsV24zJbHDmCzaQGKQbH5eqxZ5tia/66CClmE0R9sFuWyWCyee4LOILrHNjubjI1/NcXGk+wRc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:56:11.7274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bbff3f-3dc2-47bf-2ea7-08dc48bb97a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7085

TODO: make this SNP-specific if TDX disables legacy ROMs in general

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
---
 hw/i386/pc.c       | 13 +++++++++----
 hw/i386/pc_sysfw.c | 13 ++++++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index feb7a93083..5feaeb43ee 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1011,10 +1011,15 @@ void pc_memory_init(PCMachineState *pcms,
     pc_system_firmware_init(pcms, rom_memory);
 
     option_rom_mr = g_malloc(sizeof(*option_rom_mr));
-    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
-                           &error_fatal);
-    if (pcmc->pci_enabled) {
-        memory_region_set_readonly(option_rom_mr, true);
+    if (machine_require_guest_memfd(machine)) {
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
index 9dbb3f7337..850f86edd4 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -54,8 +54,13 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
     /* map the last 128KB of the BIOS in ISA space */
     isa_bios_size = MIN(flash_size, 128 * KiB);
     isa_bios = g_malloc(sizeof(*isa_bios));
-    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
-                           &error_fatal);
+    if (machine_require_guest_memfd(current_machine)) {
+        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
+                                           isa_bios_size, &error_fatal);
+    } else {
+        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
+                               &error_fatal);
+    }
     memory_region_add_subregion_overlap(rom_memory,
                                         0x100000 - isa_bios_size,
                                         isa_bios,
@@ -68,7 +73,9 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
            ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
            isa_bios_size);
 
-    memory_region_set_readonly(isa_bios, true);
+    if (!machine_require_guest_memfd(current_machine)) {
+        memory_region_set_readonly(isa_bios, true);
+    }
 }
 
 static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,
-- 
2.25.1



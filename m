Return-Path: <kvm+bounces-12262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF229880DFE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADE301C2289D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA253BB20;
	Wed, 20 Mar 2024 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QfXfgAzK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1363B791
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924953; cv=fail; b=D2w5BSvRNbwD7bgO9IWMF/hAUHbVMTmmMQIhono6TmI0HliA2ScD9lxw88tSelFJnypxCGCW0hp0zGE5+h06J3pkONy9RpJwgGHRc/RZjBspDY/CICh4zDWFCGnaD+87CBQk+ujSWf8lftIAK6t7dyu/9asCccRUfLZe2533RA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924953; c=relaxed/simple;
	bh=BBCmmMiLbqnIhDpW+4Z4NRWl2vuX/NIBBlIcdqY8maU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aupR3h5OvqpeAiJAvuQttfP4EJNcebjwEC2KDYmf/y2gGS/mn1q7qvQFQ9Eyhx85BCLcUXVohvpqtaFBSNwoZ3gAwJtqUlWNfr2uOay52TYeF1m2a5DUUlhez54OxMMJBzf61zYsM4W1RiTwwPnryj1HEWh5HW4sm/u4Z3owrck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QfXfgAzK; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCxlwSCgiU4nC3r8sMLAXL/sBtFGzjajO3VVSAEgB7uF9AWTHU2ipxNEM5eCV/uQ2DPm+QRziPZiSBdaoSG8bmVZBDZcU6ssu4sFSA/UWSNJ1aM9JdDrGj7mRM0sjEHPRx30LlBx1pljJWds3qYzMRP3+iPY+VQrt6CW4M+4M4Twc7wVUEHCwCgBG3/B1jyEGViTBugooyCGbKRPv5PX3WKV8nztQO3Hh1GWJTZUGwQMWI/G9Qls4n1z1mQEbqYFodTfa4xOcYEzXiSSN43ZJGvgbKvmgaS3TEYnqG3gC9RHDJrmFEVg8nNpDCMLqTVB0bRd1ZzqlrNUjMFIrnJkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQPDiZM6u49YLOOuOVH8cA/W1WwHxBkgenoMkfrl3jc=;
 b=a5E+kLAv7dd5qEDHUTpUyMoEpCLIsyLgMCkYbhWYMt4IXqMrgFiOoUIZJXmHilM/bf4u3ha+QB1YroDzyP7u+cs/R7fi2P9TWYjxz9GbbYIyTMpFRuUpqJZxle27GvlxBiKfTI9oJ2SNUDh5EEd6wWI/Sbl8Ji7RPYi9x4MNy88T3GGz1lytPdLsYkmz7vW5SCuNI8T+SjW9vl9rK+DDvArzn+tOnPpqA0ZTGL1P12T10wYLVM3TpaNgpcPyZSeltzqBw8+44baKD9vnwNldPgWncs9XoPyoJQxKsG5K3I5XSQZb8aVhHf3ay6gWivlzOW9ER1qEWPJKc4VBlwYGJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQPDiZM6u49YLOOuOVH8cA/W1WwHxBkgenoMkfrl3jc=;
 b=QfXfgAzKMVpH7zqdeNODwBSNyyLeWnh3b8nkWuHD7ggwQFXrHtgSqkQbljgBBeZyJYGkpp7SiUTCqTFF0K8x1M1j+4M67U6DhtAhyNDHch5wVV9QCcHtYxEa/jVCMkhQrW4dw0aDO7ckdofHOZmJq28UBIChdM0IfwQLhB2u7U0=
Received: from BYAPR07CA0057.namprd07.prod.outlook.com (2603:10b6:a03:60::34)
 by PH8PR12MB6842.namprd12.prod.outlook.com (2603:10b6:510:1c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 08:55:49 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::ea) by BYAPR07CA0057.outlook.office365.com
 (2603:10b6:a03:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:55:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:55:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:55:48 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 47/49] hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
Date: Wed, 20 Mar 2024 03:39:43 -0500
Message-ID: <20240320083945.991426-48-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|PH8PR12MB6842:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d2c1fe5-34e8-4cf4-1997-08dc48bb8a58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uIVsm6e9Qzjx/69NnJo/+kjClghbATXQ1L1VUYIBZ7EicO9hWZpFqWjI+S1jG+QGJH+dhzwYm0ZnjO6wDy1t6+bskaxvm0DxfztNSMylniHHwN99rGYzZqVObm0rG4z8mmAchtHfqrmRC/2aBcUk1vrkpP2aumg0hlg717/scVGzlb1pq9m2hDYjkY9fJjkyVTTovEIMDd2oXmFg5C2y6TMrWyWUSY7cHYXulbXCdqJugJ0o9KfwZl3Nmi9CKAEdfqngGw6KoIvWw96GcLArvyb9k3x+qo4pOf7537TTonRDB9UfzXSzVhzRmR+Ew8WJRUQAKKGcnwIPe2NGGKDR29deHohqGMvpRchz2qunRAmScc0X690LBEUCJZlPIP4gfFxJMEgQ/AwGtQKxHVmEmUF5qH0PkRq8ZuJ6/meCbIXvI3ZjKMzHz1PlrlPfHLxVhuUWAtKWpDkV6WarhEvTT6u3u5GoP/xegcxcnsFzPn+1YeIkHOwFcdwoR6XebovGEujQeLmM0g0JRyzPpQnbJWgdFSMSkGEuzTcuXFj5DGsDfdGTDA3eBEWXEkIMezMLt5T/m6Rn5K33yS5cXQxAwM/tyrrHuoOrrUWu9VUgtCvTGeYtJD4tmJv8MnVKYIktk6RmUi6VddI0e7NSQdW/rZ/WAh0leflfSaLk9a4TrZGFErHQsQe9IZTi8VOFGnWoXQlT3XnbI+Sli8NTg0A7MLvOsZ4BbiV4GKYrFu/8uN4GEPz9JtA580G/G1eQOOLR
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:55:49.5162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2c1fe5-34e8-4cf4-1997-08dc48bb8a58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6842

TODO: Brijesh as author, me as co-author (vice-versa depending)
      drop flash handling? we only support BIOS now

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/i386/pc_sysfw.c            | 12 +++++++-----
 hw/i386/x86.c                 |  2 +-
 include/hw/i386/x86.h         |  2 +-
 target/i386/sev-sysemu-stub.c |  2 +-
 target/i386/sev.c             | 15 +++++++++++----
 target/i386/sev.h             |  2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 3efabbbab2..9dbb3f7337 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -149,6 +149,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
     for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
+        hwaddr gpa;
+
         system_flash = pcms->flash[i];
         blk = pflash_cfi01_get_blk(system_flash);
         if (!blk) {
@@ -178,11 +180,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
         }
 
         total_size += size;
+        gpa = 0x100000000ULL - total_size; /* where the flash is mapped */
         qdev_prop_set_uint32(DEVICE(system_flash), "num-blocks",
                              size / FLASH_SECTOR_SIZE);
         sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
-        sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0,
-                        0x100000000ULL - total_size);
+        sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0, gpa);
 
         if (i == 0) {
             flash_mem = pflash_cfi01_get_memory(system_flash);
@@ -192,7 +194,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
             if (sev_enabled()) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
-                x86_firmware_configure(flash_ptr, flash_size);
+                x86_firmware_configure(gpa, flash_ptr, flash_size);
             }
         }
     }
@@ -245,7 +247,7 @@ void pc_system_firmware_init(PCMachineState *pcms,
     pc_system_flash_cleanup_unused(pcms);
 }
 
-void x86_firmware_configure(void *ptr, int size)
+void x86_firmware_configure(hwaddr gpa, void *ptr, int size)
 {
     int ret;
 
@@ -262,6 +264,6 @@ void x86_firmware_configure(void *ptr, int size)
             exit(1);
         }
 
-        sev_encrypt_flash(ptr, size, &error_fatal);
+        sev_encrypt_flash(gpa, ptr, size, &error_fatal);
     }
 }
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 825dc4c735..e3ddc39133 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1161,7 +1161,7 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
          */
         void *ptr = memory_region_get_ram_ptr(bios);
         load_image_size(filename, ptr, bios_size);
-        x86_firmware_configure(ptr, bios_size);
+        x86_firmware_configure(0x100000000ULL - bios_size, ptr, bios_size);
     } else {
         if (!isapc_ram_fw) {
             memory_region_set_readonly(bios, true);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 4dc30dcb4d..53dfd95cb2 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -143,6 +143,6 @@ void ioapic_init_gsi(GSIState *gsi_state, Object *parent);
 DeviceState *ioapic_init_secondary(GSIState *gsi_state);
 
 /* pc_sysfw.c */
-void x86_firmware_configure(void *ptr, int size);
+void x86_firmware_configure(hwaddr gpa, void *ptr, int size);
 
 #endif
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 96e1c15cc3..6af643e3a1 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -42,7 +42,7 @@ void qmp_sev_inject_launch_secret(const char *packet_header, const char *secret,
     error_setg(errp, "SEV is not available in this QEMU");
 }
 
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     g_assert_not_reached();
 }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index e2506f74da..d8e6aba67c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1449,7 +1449,7 @@ err:
 }
 
 int
-sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
@@ -1459,7 +1459,14 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 
     /* if SEV is in update state then encrypt the data else do nothing */
     if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
+        int ret;
+
+        if (sev_snp_enabled()) {
+            ret = snp_launch_update_data(gpa, ptr, len,
+                                         KVM_SEV_SNP_PAGE_TYPE_NORMAL);
+        } else {
+            ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
+        }
         if (ret < 0) {
             error_setg(errp, "SEV: Failed to encrypt pflash rom");
             return ret;
@@ -1829,8 +1836,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     }
 
     if (build_kernel_loader_hashes(padded_ht, ctx, errp)) {
-        if (sev_encrypt_flash((uint8_t *)padded_ht, sizeof(*padded_ht),
-                              errp) < 0) {
+        if (sev_encrypt_flash(area->base, (uint8_t *)padded_ht,
+                              sizeof(*padded_ht), errp) < 0) {
             ret = false;
         }
     } else {
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 5cbfc3365b..d570777769 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -59,7 +59,7 @@ uint32_t sev_get_cbit_position(void);
 uint32_t sev_get_reduced_phys_bits(void);
 bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
+int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
 
-- 
2.25.1



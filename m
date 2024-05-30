Return-Path: <kvm+bounces-18413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB988D4A46
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A9A282718
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2745B1822EB;
	Thu, 30 May 2024 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2ab5YwdX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38C417FACF
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067825; cv=fail; b=JBHocD77AEdN/+wVVuLNgVdmK9wSF21Nng7mxp/kcC0zlrI0YFnUqd/1rqO9XHqm3Lw+NuKz70+PLcwc+6j8qVd15VvBTz143Hm/+sg66rKgXO40a3fAWGJOpGX4jHIKyowqJWIketBJLnnt2oOTzPMb63dEgqjkeQMtmcaBNEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067825; c=relaxed/simple;
	bh=I4POQjfDroNptoyo7Mmafii0sqHzqyg3UNXhDLoCaoY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S43aOuiwjRH4WZdB9W95zVzjxvsVslvOGnCG5NlYebZvVldZai1uhAwuP3dZrwnfnLUgHIpk+PTgXQVaeVd3Fi1b07J6q5a23HJkngigpxEe/MywzwFq5mbLRTGOBYKtmVLkV+W+dGyczbWdD/5axqFtNHuaRbnwxscyfAZ4qDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2ab5YwdX; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMqmcpMWjPyrmpBFp9qe6ay2tIKxFYeE47jFMgk3DeZCHFmt4t4RJo0yQ9yorP8IMVcHsUVRthYrTNlvX8mPam3PWIa3gX9bWRHflrn0MaR0S8An4vng/bnnuMnPCk98DHxNzrMNyF5pri/ehQ86Jf5BvWTdGJasUnUXjMFek7VnjTICRQLhoY62cqCo0zJy2aBKgXEIgJuu8REMt8WXgdxWhEKQYvwj3IgzZYi6oWW1h2VMMk56mJGXv6uoerz/NA8rQBlCOZKudUsdpLQc89Rz9trywOvaHljyZ75afjvLNN5t3QJ98iwR83Op07pDSroDV74iwocpMxZv1HF/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fep7LfKQwCDtcb1ZlkZHvJQkOvgysAN3qM7LUYrgB3k=;
 b=UTfH7MlzKPjJJ8MNd7k079pNk7HpUriDhJHDHAuuURjR3q5vIQytFufONnd3ZTemYKVNifuTr0ybmTAA97lJTp+UIF9X9IHgit5BrD7CPnzAygWwAKffhBN6uWi19nUdixkTQpkZ3DkCIQZmh+OcR1ovG2wCJZiM2vNB0ov8X0A2YQtoeFWVTFi6f1OjnOxuHzyS/r1EtPqDp6xYt9xIqzreEzylrC6ftz41zty0rS+K5uGihMY0Wv1ATkoiRRKKDD3YTthxYO8yXGmtwTC8XaxcP1lcSXcydlymlcbSps+I1J7daDkmGHJg53ZCW/1XAs0XhBrpl1yCrVmk8CQ/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fep7LfKQwCDtcb1ZlkZHvJQkOvgysAN3qM7LUYrgB3k=;
 b=2ab5YwdXUyMjdRoDvB0sUGyNXrlEEEMAXr3r297gtZOi2WdZX83Lnxm545YjzBOvOh8uf0+X5zddFgU3HMCh1AGODZiRBiXgpEE+N5w+IDANo0sj1hin/bFTdWNnSsLaRCCutLgrif8pnpWf3NWbeDqx6ITC3niyRAX9ctbRHuE=
Received: from BN9PR03CA0668.namprd03.prod.outlook.com (2603:10b6:408:10e::13)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 11:17:00 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::a) by BN9PR03CA0668.outlook.office365.com
 (2603:10b6:408:10e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19 via Frontend
 Transport; Thu, 30 May 2024 11:16:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:59 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:59 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:59 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 24/31] hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
Date: Thu, 30 May 2024 06:16:36 -0500
Message-ID: <20240530111643.1091816-25-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 76b14d0e-cf15-4f66-f6b8-08dc809a063f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hqMtJJksQKakdNHX/VFJaaGq2e2NKtNt4rBNPUCRrgja//eVrQLTcO2jHIm5?=
 =?us-ascii?Q?spEwsFjd0FNTOkyImy6vOuLZjTJ9IX2E3Z5hNQa+YumYIvVHFwNu7BPww9YK?=
 =?us-ascii?Q?I0TFJtwXPLlEx/7EmgpF938SzUPjLb98bzDi44zpQu2KcPmx7GcXoJX/8CdW?=
 =?us-ascii?Q?DLQ4Y+DXICXZheIN7Ea+Lvr8VkgT40EF69mmhtLJ7YGb1GvYC6nBHvlLKCUz?=
 =?us-ascii?Q?BH+6YIk0/6ko8CH+D3n+KSLJA3M34iIs9AIDp+fIEgeGiagaltNsnvrqlXPk?=
 =?us-ascii?Q?inVYFtSUqB7zRkPLimaaWO0UK4nSNOTPhc/68J6wJMNnqba88EAOdvFXzWXy?=
 =?us-ascii?Q?vuztsiJdRrRUQxeR5gSKFQCA8ibVpn0M8rB2/4/AVlcpo2RstxcgDhV6etpo?=
 =?us-ascii?Q?74vgD1LSXsMFrITGJtXVRDeL2wGn8e4H6L5FgvomfwRKsdEoAG6MMLU0MMc/?=
 =?us-ascii?Q?989JRAdmLgdKKj1qGMdr/9otIOFAC3RnWlkDv8CjbXp2R3TsBTRKSWVEfeNJ?=
 =?us-ascii?Q?HUWkbWR51ZQ/UnXBnXLqPSf21uFPxI3jMBBZ+Gft3T9PFhbCLMHfvbmqNzQe?=
 =?us-ascii?Q?RuU8jU5IEDVsBfX3sDeR+SgD37GWCAVjJSvlCZ+NJWyuAm0T3GXdN8BrplMF?=
 =?us-ascii?Q?i7TLKe+QGFcXQPkdyLl/3gXrwUeO5UIkXs2IVAN5qQFTH/tofgP6uuFsFYJR?=
 =?us-ascii?Q?/goiU1OqfdiVL29+hgIJpWTs++zLWrvFTZgzPcbSjw4zSQOJgUbtShiqISaa?=
 =?us-ascii?Q?9snvUI6JlqiTIlssqutX9Bf2w7glcnQDrY7h6gn4hdGnf+kZ+f/cXel7Ju3Z?=
 =?us-ascii?Q?JQExxz3kTR5Z9lMVtdHybHOy1dnHST6tBnGHfrun1c8NKwjtNnOQzRNFKaP+?=
 =?us-ascii?Q?WbN9rPztq8g9zHZuKA6hacTJtNJCD9bphGt6Sm77ERxlmuhvZLGPevCbDX+3?=
 =?us-ascii?Q?izBJCL876JT0qAdgTceDYmx7AmmBtTX0u58qVwQBUbx3sgC5JpOQt0QGcySP?=
 =?us-ascii?Q?qo8StU58Mr1+ch/MFVbH0iPW494w4KhPw8x3dq1zMkAvcPvgrX+Cr1M5j/Tg?=
 =?us-ascii?Q?+BUYmAxMrk55iAbljEp+afTeQc3fcqYiwM3hyAfTFJQHFc454R26PfaZzVSf?=
 =?us-ascii?Q?Srsfl4kiOfUip9xq3kYhwepLOksnFj2ngDwz9mAz8xfZz7n+OHI4Lh+Guxjy?=
 =?us-ascii?Q?Fvb/9HjmZTtZvZTWh4l+BYMzSZtgpRQWswK96p4zQss3cP3g6V5Aoq0VCGS1?=
 =?us-ascii?Q?b1SveVoQNUWosiH+uTsGrWcx0V9oJPnKz9k/bx+5C4xP551moIu05m4s7U90?=
 =?us-ascii?Q?9S8GBMj/Esg/92casrPHw3ic5TYBbDjTX4k0l40QrMvBmibl7TW3P991Iht5?=
 =?us-ascii?Q?IIljT7g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:59.7473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b14d0e-cf15-4f66-f6b8-08dc809a063f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220

From: Brijesh Singh <brijesh.singh@amd.com>

As with SEV, an SNP guest requires that the BIOS be part of the initial
encrypted/measured guest payload. Extend sev_encrypt_flash() to handle
the SNP case and plumb through the GPA of the BIOS location since this
is needed for SNP.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 hw/i386/pc_sysfw.c            | 12 +++++++-----
 hw/i386/x86-common.c          |  2 +-
 include/hw/i386/x86.h         |  2 +-
 target/i386/sev-sysemu-stub.c |  2 +-
 target/i386/sev.c             | 15 +++++++++++----
 target/i386/sev.h             |  2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 048d0919c1..00464afcb4 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -148,6 +148,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
     for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
+        hwaddr gpa;
+
         system_flash = pcms->flash[i];
         blk = pflash_cfi01_get_blk(system_flash);
         if (!blk) {
@@ -177,11 +179,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
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
@@ -196,7 +198,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
             if (sev_enabled()) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
-                x86_firmware_configure(flash_ptr, flash_size);
+                x86_firmware_configure(gpa, flash_ptr, flash_size);
             }
         }
     }
@@ -249,7 +251,7 @@ void pc_system_firmware_init(PCMachineState *pcms,
     pc_system_flash_cleanup_unused(pcms);
 }
 
-void x86_firmware_configure(void *ptr, int size)
+void x86_firmware_configure(hwaddr gpa, void *ptr, int size)
 {
     int ret;
 
@@ -270,6 +272,6 @@ void x86_firmware_configure(void *ptr, int size)
             exit(1);
         }
 
-        sev_encrypt_flash(ptr, size, &error_fatal);
+        sev_encrypt_flash(gpa, ptr, size, &error_fatal);
     }
 }
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index ee9046d9a8..f41cb0a6a8 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -1013,7 +1013,7 @@ void x86_bios_rom_init(X86MachineState *x86ms, const char *default_firmware,
          */
         void *ptr = memory_region_get_ram_ptr(&x86ms->bios);
         load_image_size(filename, ptr, bios_size);
-        x86_firmware_configure(ptr, bios_size);
+        x86_firmware_configure(0x100000000ULL - bios_size, ptr, bios_size);
     } else {
         memory_region_set_readonly(&x86ms->bios, !isapc_ram_fw);
         ret = rom_add_file_fixed(bios_name, (uint32_t)(-bios_size), -1);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index b006f16b8d..d43cb3908e 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -154,6 +154,6 @@ void ioapic_init_gsi(GSIState *gsi_state, Object *parent);
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
index 1a78e98751..c5c703bc8d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1522,7 +1522,7 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 }
 
 int
-sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
@@ -1532,7 +1532,14 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 
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
@@ -1902,8 +1909,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
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
index cc12824dd6..858005a119 100644
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
2.34.1



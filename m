Return-Path: <kvm+bounces-18416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF918D4A4B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA99AB242E8
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04806183A65;
	Thu, 30 May 2024 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zcbeVi3k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F08D6F2F7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067831; cv=fail; b=aJYUxrJf/NE7qiFfxMvkcIi2mPpPB3HZyszV2070jDluHSP5kciYxpHNBo9N40bd9TPyiW/pvPPPUbF8FfYdhv8ePAw0pBCWrZS3TY+xHZmwbZEyReMSl/KCsxBU3oluc9hDAwgN3Fxye3B5LSWtWLPkVEc8+N0FbjC/xXnapS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067831; c=relaxed/simple;
	bh=3euVNwsIFSvZDx1XXKRt12QdXmwZ94Q8sJLNhbn3EX0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5BjCVDnIU2o8jFFU/6J9PkDj9bKZwyVpji9Mjlw7Xf3j7R3ls72ZxCaLxCOwkIZ3B+S+Aa8bQnDz62Jrpm399Rq+rvXvLMplZmpBj150rkgCey4sTvXspH6P4GpjqnVbmdFhiYUTMyx5U+h0TC2fYGf65+JLKzMel0fvTbZcGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zcbeVi3k; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cL69pESnpYLjxXNxBHCbsRWq3DFf8ywaKzOnX/U7uFzH3Z4/Ir/vGOJcMsluIz+DaiqeL7aliJOUzcfwka24EVHUyzh0I1NUlgKvm+zDqukf9v/IwZq892Olr0twNrbA1SlWBPsN+9KQzN7VEDo2oLwBE3Gn+kZsoTOL2HE6OPu9AyEYxMCzAvwMhF04B3/xZrbto6Iq+zVhIcGp8WWlRxg5pNRd2oLdNhUTkUaqE/GinHMRugf+a8cLAd8dktP+t+uTasdxqoTPHgnm6427BupWyOqt2x+j5njPpUhO9APLJSmQ2m5uqtRkix/JPE+Zk/bVa6eHmpoSwDJtqNLhhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68tnYI6ipZ8mBahj5St8AOyJU76kc67TAbkPM3BQUuQ=;
 b=UatOY1ZcFnvywQ0JeQ2kH7+bW6seFkLCtrB/tm2o9VHCtmXtkkpbaWjfJ0YNXFINdk/3UIVjwb/pFxWa+VQD6fc1GdJyI+zP7E2fEe5GXYJU0UpdNDeb8nMnWRxU8Yh5SdpaY9I+ZNYY55931Acm9Mh3+Nrca9J7DbEEBiuIDl2v3Cjgm9A1CMhiBG7/aQv0+a2fmf2StpXIjKf23g8DM8TJuVmWXgC2fMbYF+tzN9ZF7PliPrMf6burNRsvwnG5vLi386+X+GfWjBU7XGg9pgYF2hnVHf3VH9PH7K/FlsItzq/WFpzUrtJG2ausr9Rj0sgUPTGYrfpKFTLibl/oEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68tnYI6ipZ8mBahj5St8AOyJU76kc67TAbkPM3BQUuQ=;
 b=zcbeVi3kwznfCoNR9EwsrhijPkyKMl31yhixfRgEgeEe7qCzNY7XGHFejg5qTE1aALcnMmDDYZvxzf2JCJ9z6Yvrq2L2Lw2TW0HfOJGeVmLXSz17YBJrSUSfLTEvVl8llUAGunaq59C0H5s8bEd521PrgOvxzPRaMoqbG+eB9TA=
Received: from BN9PR03CA0670.namprd03.prod.outlook.com (2603:10b6:408:10e::15)
 by SN7PR12MB7856.namprd12.prod.outlook.com (2603:10b6:806:340::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 30 May
 2024 11:16:58 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::18) by BN9PR03CA0670.outlook.office365.com
 (2603:10b6:408:10e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19 via Frontend
 Transport; Thu, 30 May 2024 11:16:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:58 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:57 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:57 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:57 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 21/31] i386/sev: Extract build_kernel_loader_hashes
Date: Thu, 30 May 2024 06:16:33 -0500
Message-ID: <20240530111643.1091816-22-pankaj.gupta@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|SN7PR12MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db6d0fa-2c05-461b-5036-08dc809a0556
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o1/wygQbTLs6vnev5n5jBA9Lnn9Rl4F7Bj9fjG/67aTfXbgFN6pUXzIWlh6s?=
 =?us-ascii?Q?nrRfM8KSDpdMCGz13nmIjF3fdwp4yCuaReI4cMled9D995UERI0etwgP3XXJ?=
 =?us-ascii?Q?W7NcmLMQ9280j9zslqFsHXnc2opNPnF6YzVgUIIpwK0OC8biku+Iw2WnDgsG?=
 =?us-ascii?Q?kLDrJe+qV0GpVfTh3028vIGnRQDDwMtTvu6+DwKfK8YCB1HBIk2e/p76bhnH?=
 =?us-ascii?Q?YTmNaKbw5HVd3J/SMP2AsUeZkmYpfASiC1THNrsNdddh/ggueiQ+C3HEIsRF?=
 =?us-ascii?Q?DhKZDjpW7XtHqAbHuN6g506Vt4d+KI9SZf6sBB5s+x09dqEj9gYU2U23vvmc?=
 =?us-ascii?Q?6uzvaI4B5ywm1uFYbnYL7Z1vPb3Rngd+FN8Nj+cCWwDoFTUhZNFpAl/sRhhS?=
 =?us-ascii?Q?ugF0pkY7YqrzY75bpsVjOsGgyp9rUTH+hGct2HzenmcJWxPFb7L7yfD665vQ?=
 =?us-ascii?Q?qaCYzArxd9T9qk8XrHuy36cw0oM+qL9OjIdYpCNh5Jth2HMAyxCmf8G+RYv9?=
 =?us-ascii?Q?8H9OWAq7kgwQHXWH6vIYi901JFdSxIfFppK2qna1Ht8XWTAnMZ53GcLxe90C?=
 =?us-ascii?Q?cGEykcaG9c+Bih3rb5cllrg7qz79qDoYbpJanoq9XjXk0iJ5w0lEWYPOdYkL?=
 =?us-ascii?Q?HFkIIZ2uTSYpBaZSeDQy91FdgBm30otc4i1ZQRJEeBzZnzcSWTSPqb46hIWc?=
 =?us-ascii?Q?/b1yxw3M/7edLe+iiyS9BqAYbgI3bUi4RLg2HL2jIcEuwwdnZisQyhRn84Ic?=
 =?us-ascii?Q?dlLAPdwyBKn83G4vJZlLkmMceH/Ib1+LE5cahJ6BIyxhmoBzoNJp9LwXIDQe?=
 =?us-ascii?Q?K9ww3rbUth8pUADsnTOY45IDhV62I4gePkgrDMldUfGCOZ28gL5tnxDY+fgI?=
 =?us-ascii?Q?Stcl+3WgeWLEMLDPSdBJD3fjQYJ51Ow7kvU82hMSB9Wa7KKzGTQa0r6exYJZ?=
 =?us-ascii?Q?UfwpGBaB32iBXDOuhmp3s5E6WfPNLcfhzOOSLEdw+ReZB0jiG4+Xpj8UJW+D?=
 =?us-ascii?Q?dTM4nMycMp5v/AbqDEJea1n6KdaF56KwuFliM86eLWaYg3AHkvpgc1mNAFcm?=
 =?us-ascii?Q?GQbJlomVS0kG/f37HpoGG7grR0a9sRnDJCI/1bnHifVejlYtYsEvTWvmmdGK?=
 =?us-ascii?Q?zakEDT0vAbv7hfBCGooubf/dukIzLBYNzjMF2vzYFhu7aNTJ+JXLW3imOIMO?=
 =?us-ascii?Q?2jDgkciz/kDxYlqmRvih81VhwZjkKY91crMfKKHjwUthd12mSudimk+T7cBM?=
 =?us-ascii?Q?5+AH2uG3MC3LTTyGjuEBKebbRGXbK1LK7Jzm0V/2PKuqQFBz7Agoo5VIKVCK?=
 =?us-ascii?Q?2pWVEiOrhyYKLts7vQK6OWrzWxtMibJtzMlzVnBe8fSP5z5p9rjHmUTNZUP/?=
 =?us-ascii?Q?YG4eQkZIMH3URuX+7B33nFb4e2ri?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:58.2160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db6d0fa-2c05-461b-5036-08dc809a0556
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7856

From: Dov Murik <dovmurik@linux.ibm.com>

Extract the building of the kernel hashes table out from
sev_add_kernel_loader_hashes() to allow building it in
other memory areas (for SNP support).

No functional change intended.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 101 ++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4388ffe867..831745c02a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1751,45 +1751,16 @@ static const QemuUUID sev_cmdline_entry_guid = {
                     0x4d, 0x36, 0xab, 0x2a)
 };
 
-/*
- * Add the hashes of the linux kernel/initrd/cmdline to an encrypted guest page
- * which is included in SEV's initial memory measurement.
- */
-bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
+static bool build_kernel_loader_hashes(PaddedSevHashTable *padded_ht,
+                                       SevKernelLoaderContext *ctx,
+                                       Error **errp)
 {
-    uint8_t *data;
-    SevHashTableDescriptor *area;
     SevHashTable *ht;
-    PaddedSevHashTable *padded_ht;
     uint8_t cmdline_hash[HASH_SIZE];
     uint8_t initrd_hash[HASH_SIZE];
     uint8_t kernel_hash[HASH_SIZE];
     uint8_t *hashp;
     size_t hash_len = HASH_SIZE;
-    hwaddr mapped_len = sizeof(*padded_ht);
-    MemTxAttrs attrs = { 0 };
-    bool ret = true;
-    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
-
-    /*
-     * Only add the kernel hashes if the sev-guest configuration explicitly
-     * stated kernel-hashes=on.
-     */
-    if (!sev_common->kernel_hashes) {
-        return false;
-    }
-
-    if (!pc_system_ovmf_table_find(SEV_HASH_TABLE_RV_GUID, &data, NULL)) {
-        error_setg(errp, "SEV: kernel specified but guest firmware "
-                         "has no hashes table GUID");
-        return false;
-    }
-    area = (SevHashTableDescriptor *)data;
-    if (!area->base || area->size < sizeof(PaddedSevHashTable)) {
-        error_setg(errp, "SEV: guest firmware hashes table area is invalid "
-                         "(base=0x%x size=0x%x)", area->base, area->size);
-        return false;
-    }
 
     /*
      * Calculate hash of kernel command-line with the terminating null byte. If
@@ -1826,16 +1797,6 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     }
     assert(hash_len == HASH_SIZE);
 
-    /*
-     * Populate the hashes table in the guest's memory at the OVMF-designated
-     * area for the SEV hashes table
-     */
-    padded_ht = address_space_map(&address_space_memory, area->base,
-                                  &mapped_len, true, attrs);
-    if (!padded_ht || mapped_len != sizeof(*padded_ht)) {
-        error_setg(errp, "SEV: cannot map hashes table guest memory area");
-        return false;
-    }
     ht = &padded_ht->ht;
 
     ht->guid = sev_hash_table_header_guid;
@@ -1856,7 +1817,61 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     /* zero the excess data so the measurement can be reliably calculated */
     memset(padded_ht->padding, 0, sizeof(padded_ht->padding));
 
-    if (sev_encrypt_flash((uint8_t *)padded_ht, sizeof(*padded_ht), errp) < 0) {
+    return true;
+}
+
+/*
+ * Add the hashes of the linux kernel/initrd/cmdline to an encrypted guest page
+ * which is included in SEV's initial memory measurement.
+ */
+bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
+{
+    uint8_t *data;
+    SevHashTableDescriptor *area;
+    PaddedSevHashTable *padded_ht;
+    hwaddr mapped_len = sizeof(*padded_ht);
+    MemTxAttrs attrs = { 0 };
+    bool ret = true;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    /*
+     * Only add the kernel hashes if the sev-guest configuration explicitly
+     * stated kernel-hashes=on.
+     */
+    if (!sev_common->kernel_hashes) {
+        return false;
+    }
+
+    if (!pc_system_ovmf_table_find(SEV_HASH_TABLE_RV_GUID, &data, NULL)) {
+        error_setg(errp, "SEV: kernel specified but guest firmware "
+                         "has no hashes table GUID");
+        return false;
+    }
+
+    area = (SevHashTableDescriptor *)data;
+    if (!area->base || area->size < sizeof(PaddedSevHashTable)) {
+        error_setg(errp, "SEV: guest firmware hashes table area is invalid "
+                         "(base=0x%x size=0x%x)", area->base, area->size);
+        return false;
+    }
+
+    /*
+     * Populate the hashes table in the guest's memory at the OVMF-designated
+     * area for the SEV hashes table
+     */
+    padded_ht = address_space_map(&address_space_memory, area->base,
+                                  &mapped_len, true, attrs);
+    if (!padded_ht || mapped_len != sizeof(*padded_ht)) {
+        error_setg(errp, "SEV: cannot map hashes table guest memory area");
+        return false;
+    }
+
+    if (build_kernel_loader_hashes(padded_ht, ctx, errp)) {
+        if (sev_encrypt_flash((uint8_t *)padded_ht, sizeof(*padded_ht),
+                              errp) < 0) {
+            ret = false;
+        }
+    } else {
         ret = false;
     }
 
-- 
2.34.1



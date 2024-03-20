Return-Path: <kvm+bounces-12258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6F7880DF0
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD53A1C226B3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82703C47B;
	Wed, 20 Mar 2024 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C3yzA0sI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB353C460
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924891; cv=fail; b=PWZq+zWQNYlKFRR4aqDdcXYszssi8EsyyN3xE5i+03vuQsWUgbqvFNsd8KqwKs3nf2YJ8JGzXyr8wdNP3UYFDWup0KYEgBu88WcECACPvBVCAWyZAaZMtT0FKCdUozDMMMkzH72WmcOh7rYVYYjSaonfNIBof7Mom0c1lOEGKtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924891; c=relaxed/simple;
	bh=/fFGFE/uGJLThJ/8j0kjAVbPnrEebcnx16qgWjYnzHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Upi2kNiMBSh78iM0fXqryvdMFoEmcdZumy7hJjuDo7YI96IeyUujpILZ+Ny+zHHaEPHaQ6cWAlKBZ2JMYJ/TWGFoIYGXJVzdS1NcK3x+0r8cfQTP59AD9+TK1ikjp63pHfbhKIgDAowSTc1IrEHAkbI/NGWY1Bdml8cMpWjnxjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C3yzA0sI; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLLVw4uSm732kTkwb2uHPsa1eImQ3zxqugy0mqA5VKvVGHxywgd+C6mrBbFuaBVWTpTQ89QQ55k3Ru0o5/S2Vrn8lEWRVgWq5sTaIY+LVrrqeC4SDug2mvzoBIAAFyToIPKErYXQ1OuAoP4G6tArhQicGVdylYMgt1udxGL2PJWu5FC6s97PHVmtCc68jKJla7gNX538JyFwGQBaAhdGNvPmfN5kHd6jwZdZmZVpWOOR6Dh+jLb8DgDSsVytx1PMaQbxFF7nHpC9+eyquE2JsSRbLr25SHpQI1YVH01ItvViYF9pIGEOaLGtT7MYW0UQNkKEcBLU7HqIwZoLZTtQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbbD+3bbhQXC4I9P2lv+uXkLWrYjKykmwVYs67iFU0w=;
 b=bQK5pRqNMLIqdlVTBtu3PMjfzj0auBK1Lzs6JFffg1TJEttAOVBzZc9UfAhQzSgZYgTUCB8zxikE81U6DfOewbg/KRhONsh1r0Rzwwy5emd6CeFL0/PfhBT3liOJ8o3/YEol/3JwchkFb/aTTiZz0uD9vwuXDWh/J6LW//JKsoGgYaBda+hmZ4xM0GKKdikZphXKhzAdLDoG3vT124cHydn0CxESpE4QklRpOi6AuTzSMXzDNjM1NMhiaXtmKJG9PVZELxv9W/Xm1THtJOFkdxWW9Ot9WFl0MCBTX9BYLDE3c3EUG5LCAqHpk0lSlNwegZZiowOmLqTbFpmPztcBhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbbD+3bbhQXC4I9P2lv+uXkLWrYjKykmwVYs67iFU0w=;
 b=C3yzA0sIPv4mKOF9TIb8PURGiRRykKqDD0VVsn2YhnD5Kb+4kgcKs21/KbGTB+MJ0nPmcjl8Ki4wWrben/skrC6Tonc6XswovdtkcqcxPaLcSLl41Xyx4xdkULSEL3W1GPMoeK1LsHjnn5LHV2S7/eZmhDhEGGcIfBJll5eGqc0=
Received: from BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42)
 by PH8PR12MB6747.namprd12.prod.outlook.com (2603:10b6:510:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:54:47 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::e) by BY5PR17CA0029.outlook.office365.com
 (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:54:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:54:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:54:45 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Dov Murik <dovmurik@linux.ibm.com>
Subject: [PATCH v3 44/49] i386/sev: Extract build_kernel_loader_hashes
Date: Wed, 20 Mar 2024 03:39:40 -0500
Message-ID: <20240320083945.991426-45-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|PH8PR12MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: d44691ba-d049-451f-261d-08dc48bb64f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PD4k8L6dX4+8Zz472yqEPVtXueWPRQyXkyCxaPFyR1PFWEv4nAPt7FdZP3GmAfv/5hCp+HfoLu2GvlFJsp5WscpxxmDSKHKE7KOh6aTr+Z1hVl8AXY+adEozIFQHAX9T3s22ACzQp6dcBdRHrkDI1jIFkfLP5okhNcWFYGCpX0nc91pg28ZPr231mvH23VU717+7BRDg8+zCAvEDit0dgGC5K1pbExgyJLTD0K37KAwa6/PTeaG0UAtJgFcR09ra+zYhfd9LTdeA8i3DsmbVfM2vK7sG3QfgFwAvUZFWf669ruxoeIXllLOYmwlAB/Ae41dxQ3lENafH3CdAFjU6TE/uiPa8RXoHw2EDy8gEZ3L5QIepuAJR0Mi0dSXFomRmi2wJeFBBBmJxN1Yb8+DSsBoGKeluiA74Hh0Sn236elpb8UnzhJ/MG4YVbQIrtZKyostjOXn4gbZANcT3WS2aQRQOocLrk5/eVWiT/P2MyqzLJjTOBRENW8YmsJOSLTGxjuoIMB/SjGdYrz1r3zcya3H+oxjxt49B7lxRnWLXCf9vGJ0UxdYWWqa5pIqaIXEtj91pMgkIzUUXTukDhO96acNAedEW0vcing59pSl0/Jr4nLfljIig1tjcN/++/LoAzSBn3BH5subFLBX+9ukz/HYnNY7/t+aDDhP0PxZYrSrI2vkQbfYAP1pdGlXwrDfE6SyF1OpxZYgN1pJ+yKbwlv/tOEdsCUD3kQ/Hrxi9bB2qOzIHoBU9W1CKR8FOmUFi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:54:46.8052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d44691ba-d049-451f-261d-08dc48bb64f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6747

From: Dov Murik <dovmurik@linux.ibm.com>

Extract the building of the kernel hashes table out from
sev_add_kernel_loader_hashes() to allow building it in
other memory areas (for SNP support).

No functional change intended.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 101 ++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 3187b3dee8..0913cb7fed 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1677,45 +1677,16 @@ static const QemuUUID sev_cmdline_entry_guid = {
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
@@ -1752,16 +1723,6 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
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
@@ -1782,7 +1743,61 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
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
2.25.1



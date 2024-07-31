Return-Path: <kvm+bounces-22779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8B49432C7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17954283E77
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D061BE854;
	Wed, 31 Jul 2024 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iu0Q0oih"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B91BE851;
	Wed, 31 Jul 2024 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438544; cv=fail; b=pIT29Fism68fEq38b/bY3juJBxDeFxsRwY0jbRkod7CGd8bRxwBJsKHzgYNYlyFCIcSZj49Ubvz3JePdrLXOpon7TTd6sqYb3VOf2ffpe5O39V1QVih6x2E4lmYmibrMOtrIp9SSTDQBaxsUMPFj9Gno5T2Ixy48HRNLuUJl9lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438544; c=relaxed/simple;
	bh=HnO8omW8SicKCqY9xH0+gCZ7+UPc6jxUsFgZzJxv3TE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIalO4pxZAqsCxix8sjQseJwNO8uAOV/HETfOWIAkQ7+tEYug2vvcl/EsIK83ArQbRd979epJssjBkNj8jWAJPzjR3R9Fl+4ZahbC9FPM4P2o5TDOzRpGgYSbYPLDodcAGMRKVdkA50SZTdokQAm4ISGzzOq3BbVy0rWlq56W5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iu0Q0oih; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJxwJiPtDTa7G66Ourfohgt28PUZQQUiwmbOaYpi9J2/F0T1Tj4VzlloB3pfVVTM4omQPWa4PpYwjc30Cf2GCKd20JZUbSczDhgT5t+OwyteVnBLbB5ecjMfNgTAOLzqcumSmMgcpStYJJpVUt97h4wzxsuj+E4LsOMAuadAifEY01q5ZWll5hk2mpR7oev9jYgb+2Mdd+Uuk7Y64PBR5ay9Z8CQT1GOZmgvPIr/Q/UiMga/u/yF0J4nlXOYUztbu0hJH/0oJLMLi36PH6JsdZMUr3ysN5ZARiS4taSJRoJ1kFc/vy/G1Is1GEZ+9MYmLpnh6j3YF5HkHEBAuQ/k/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUVryATV69BcwcXaKxjkuok2Lyt9krnyGsk2B2MfiFw=;
 b=FEMe10QDUAvJfQ9232mjliMJvZqDd5ojH6RwQOqNPcSbDuobIyKOxP+ljLRl6wi0jIRmVzKYBJdquyYLa2laz9//5+zSMOiyRl8yY3Z1XI2/hXwHfh/xjSGMDrMnXnDb54CrgoHk1LBINAGpA7kYsKjkTrA4RqkKw4gD1vCzgx2rRKO0TePj3sFLoVH38SpBclx1lXKeLx5Rkl9dYnP3qWViE0U0mivTKXnKg0YfoWTS0bkXKt9MrZsF/drK7AB29QWj/xQN7/e8X0COEy22rHfsEJIU2JdhzzFjAyb5nU1TbGRMD6MUo6X1QrIh3INYVx0VTSSh8IPGWx9xnYseAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUVryATV69BcwcXaKxjkuok2Lyt9krnyGsk2B2MfiFw=;
 b=iu0Q0oihCTbDgXZhJO0LQVxSdDQSzjQH7jZCILVxh6PnOqKulf4FoctMpS361fnbeNQGBvcA2VXqo/eXbUPZWrWswbGXe8E9HVLkWpFLOh/q2r/9LvoLjcvMM3vvyWLdu8jbAQIqHD3OJCqp6vmbBYNXkOtsRuuQGOXGVw7Y4AA=
Received: from CH0P223CA0001.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::32)
 by CH3PR12MB7619.namprd12.prod.outlook.com (2603:10b6:610:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 15:08:57 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::66) by CH0P223CA0001.outlook.office365.com
 (2603:10b6:610:116::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:55 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:51 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 07/20] x86/sev: Cache the secrets page address
Date: Wed, 31 Jul 2024 20:37:58 +0530
Message-ID: <20240731150811.156771-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|CH3PR12MB7619:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bac3b7-3222-407f-c48a-08dcb172b26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1MjA5YicdTUq67dhvxvtG71uJdC5xFZdBGovC/ppzvkckzzoPDqTz2lOy48b?=
 =?us-ascii?Q?3qGPDeqHd0yMyua1TxGUNG/D/SpFMqHqhpxcBX6rad5ONovH2nfWyWfVZYBq?=
 =?us-ascii?Q?sL1ErlOcNSB1iMXsH0iqKG/WmeVvaAXhKyCT2AQkYgf5kAzoU/6kXCYxgQEu?=
 =?us-ascii?Q?Q7Uz0/NPld4Evf+Cc2D5bjntmTjCjrCa9tZPMfoqf/NQvwX7b7MBvuUlB83i?=
 =?us-ascii?Q?G8Wih6bQvLagsnKwLBuqCZvUTD7p0JnrYa4PAqdR93hFyn3cGhRtTzay/0JO?=
 =?us-ascii?Q?rGCCCMYbValgrZRF/yJ9Y5iX2QforBG/aZ38d0jdqmNRIq3EOa8g9uKGBmKF?=
 =?us-ascii?Q?vK7lAld78QKcqSbnzT9sQIV3xHqIZh0HBfEVDQt1z7DUNzsdNXhX4mJcqI/V?=
 =?us-ascii?Q?vXX6gWewCTI0wZfu1sWIYzWsGZYRxCyBzQHlBJIOMKnpI8uiOYEce0sGeEDQ?=
 =?us-ascii?Q?E1VJ5gUkBnFgtH35jbDqiKHQdrHk+Kv1j08fAidG9MNimo6MipusgThZkwFF?=
 =?us-ascii?Q?RtPeNmgodY6ChrPmBC+M8tMSZzVcfQAsuf+L0lS9SBTcHbSXkg14KQub2NLv?=
 =?us-ascii?Q?b2Xl9LIbN45Y/GXozc8X43njlBwiv8CsJTBOOTLc4DCE/51j9iphjsrsWloX?=
 =?us-ascii?Q?/q9BLTg+pUgnNef0I4aEvIaKOOfjPWi2Wi3OjPpT3nSSjHQkQoWgH9en4PbD?=
 =?us-ascii?Q?ZEH6LtPR5n4t1f+hIcun1IG3+7n3kTf5NI+609XfAw8y7jiWfbvPQ2Kv4KDI?=
 =?us-ascii?Q?wJa2DKpvBfT9UNID0OwEsFpgsI45mUEa7gqlzKa08YcMuWjb7Bcz7Gi0wF6/?=
 =?us-ascii?Q?/kaO4qVZ/7h0nFlquu48isiVKZHs9hVGtqkFAEN4x/p5s9zFG++qTWfdInKq?=
 =?us-ascii?Q?ss+pZHFQvVqicbPXE5udvSL3ePmJYwJQffKTo77iUS41lpl6t8HU4qoCaC8W?=
 =?us-ascii?Q?w4c5gJ3jFVxbZxhNEddRvQNGgtaSeICzgIZ08bCZDWQ7hCYLQWKYbxEHoxm5?=
 =?us-ascii?Q?h9uagMNNqjTzml7HTHAGJCZagvmDr9FmUbZKwOm4C3Uq62q3h+9tpr8694Oz?=
 =?us-ascii?Q?tpQ57z0XL2BVfTifyOzH/EWF3fTN+58Z5NytPa5OT0xh47SS6Z6WfyPSK8sP?=
 =?us-ascii?Q?dkAFWTVaP4e1oGh/wIO7PVlcCsnhRDPRS8U4ySzq92kBEN2EqCyoXCYPRJjy?=
 =?us-ascii?Q?LPiXKBZxnq+ATPnGSr1EUVGWrrPkGi/Q+AwgWsczMgmVsotN/DuWuo8pPUT6?=
 =?us-ascii?Q?iWK1QdGOMkMHjOZ8/iIbCAKBVgE9jtRmKzPLVfPW2vE6C0M+lWGcW5Vf1ZnC?=
 =?us-ascii?Q?cJzuY8ZOCfyN8G4z2EXQik+Jy0pD4/lN/0rDrD0iB3HygwrM/a8O3vud2VZL?=
 =?us-ascii?Q?Q2KTnfxKRMDoALZV6VCpeLRHeD2ya/Qz8ZDBLp4DWIM54/b04mxWVaqC/O81?=
 =?us-ascii?Q?a2Hd0Cza/zfX7tC8ZnSe8nPxptj0yw15?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:55.6534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bac3b7-3222-407f-c48a-08dcb172b26c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7619

Instead of calling get_secrets_page(), which parses the CC blob every time
to get the secrets page physical address (secrets_pa), save the secrets
page physical address during snp_init() from the CC blob. Since
get_secrets_page() is no longer used, remove the function.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/core.c | 51 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 082d61d85dfc..a0b64cfd4b8e 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -92,6 +92,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -722,45 +725,13 @@ void noinstr __sev_es_nmi_complete(void)
 	__sev_put_ghcb(&state);
 }
 
-static u64 __init get_secrets_page(void)
-{
-	u64 pa_data = boot_params.cc_blob_address;
-	struct cc_blob_sev_info info;
-	void *map;
-
-	/*
-	 * The CC blob contains the address of the secrets page, check if the
-	 * blob is present.
-	 */
-	if (!pa_data)
-		return 0;
-
-	map = early_memremap(pa_data, sizeof(info));
-	if (!map) {
-		pr_err("Unable to locate SNP secrets page: failed to map the Confidential Computing blob.\n");
-		return 0;
-	}
-	memcpy(&info, map, sizeof(info));
-	early_memunmap(map, sizeof(info));
-
-	/* smoke-test the secrets page passed */
-	if (!info.secrets_phys || info.secrets_len != PAGE_SIZE)
-		return 0;
-
-	return info.secrets_phys;
-}
-
 static u64 __init get_snp_jump_table_addr(void)
 {
 	struct snp_secrets_page *secrets;
 	void __iomem *mem;
-	u64 pa, addr;
-
-	pa = get_secrets_page();
-	if (!pa)
-		return 0;
+	u64 addr;
 
-	mem = ioremap_encrypted(pa, PAGE_SIZE);
+	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!mem) {
 		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
 		return 0;
@@ -2300,6 +2271,11 @@ bool __head snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+	else
+		return false;
+
 	setup_cpuid_table(cc_info);
 
 	svsm_setup(cc_info);
@@ -2513,16 +2489,11 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
-		return -ENODEV;
-
-	data.secrets_gpa = gpa;
+	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
-- 
2.34.1



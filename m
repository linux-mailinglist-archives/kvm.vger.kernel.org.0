Return-Path: <kvm+bounces-4940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDB481A207
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAC30288192
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1033B3FB19;
	Wed, 20 Dec 2023 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gu3L2Dpr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D047046520;
	Wed, 20 Dec 2023 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrHG4WUscSl3BoZdYeCD0cP0Gelkk/bLQ6uYyWfWpnlkQc/tCkQ8VmKdgG45ewH0Jttn4mPMKEIWItIN4dRg0Zh3IqZnaK2qds9G0WFbJmm6Zi6ZvYmjoEJcvyUVvXrz1z0AaMTrpNX/SYYBsMnaJK8rBtgB9EPcTD/IUD3Cs0rGui2Kb7gnRQ+tscu/nA6JfrgINeyqFUVCpAbMZ5L5U2WMgyD9sx+bjADd6hqfUA4A+5SKUtnGwG4TVERERi7/09HuaI5TFU/0M1ZAGNyAVBgQn6vShJkmNRy1fKsk1dKIxG1rpchRlP6nyEkUdGC7l8Kx0R3vmIoVRWcuIyoRpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb61C2VBMEdTj3oQKKzqnTH5/4GBr84KkydekZoou5U=;
 b=jPiMU3riLi2vTnSBQpERmODFl0gd67DrEqMQ0DxmucVReDiT3a6IBQXSSr/bAbFDxGzNhPF3MaM3o0zHqlHU4STqZcZqTWRTRzMRaokIcPKadTRw+URt1enStqsaMq+VOTmpV+D/5nKmL7dfpXhv1qpjkcDfY8p0zCjnwaHuoO4mFMhjvq8lt9GvzxkNirF812LUTl0lUWGO7QIambZdqUhrBVTo2+EseNtGftevzi8STa5QXJA209bTVYPrb8CiguPKba1/sekG06oiOb3Sl//KYFYbqahi2vOTmE16t5tBvoQhIJPbjxG4e/AE8PgX4QrR+89yazs4xj3zWwbXuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hb61C2VBMEdTj3oQKKzqnTH5/4GBr84KkydekZoou5U=;
 b=gu3L2Dpr29B7rRt72lxAtj7zl7tbaSQgjRAIZTiwguTwg4Y2DRHy5G52N4VaXSWmTehuem44M2DOX6IGrCoScgJvxuccgyr0hxaxxbvbB8uXG6JBPKmWwizu6EfB45nKhCoyOlcg1m4EncgWqa1UtAtn1oGTjaRMBGyqNThhpoM=
Received: from DS7PR03CA0226.namprd03.prod.outlook.com (2603:10b6:5:3ba::21)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:06 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::88) by DS7PR03CA0226.outlook.office365.com
 (2603:10b6:5:3ba::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:02 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 05/16] x86/sev: Cache the secrets page address
Date: Wed, 20 Dec 2023 20:43:47 +0530
Message-ID: <20231220151358.2147066-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fefbb10-e4d9-480c-e962-08dc016e729e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v/4XhmQJO8Zm/WfkD8jnNz73cKrKQgifiK7RDJeb7LVvg/KnbeH0WMq8H/z9W7rI/NEj8ehIz1qKokZn8dKGP2ytPrGbitLGDKTzE4k1hjqeBSwidtRml5hT5p5sbNE/bIks7GnwezG8kd9raAcgjntTBWVZloXOPa9v2RNwt10IaFlAcwLZKUPPZyDgATXde+YfjijnZk78SUplItm66LRqKpWN1GhwzMQG77KtoKvwPOyIUsnfSxeutBW98hXFSRW9ri9iQ5o3dEJl8I+QhSCtVSbj8Ihji83G6M6DLBq7T9NKt/BIcS4R1rIYC1iMD2Nu46X46jFFg4f1lqpspV2rkLWpQhB1Pon/FOgEeoV3/Re9dYKuq29mcM+7D2qhicxmBaarQ1JReSW8TJe6pZ+BooZugo/HQuaZeKeUPh+FA8fC6S0X51AjckduT5sdsNzO6Vf0iev+4XmloJQYTEZPychu3fR54nk98tSXx7eT4ry/NyUTW1PXAd3BuLlDrlveIlFnFQhq5fAsXi4alh+O+U1r5jCVZTphrncqzTF2G7vjuxJ1/abw00rlMdwdqMv0vztWZxviF4/WUcjTb2sdGf/N0MsPcDM2eqPVHZUs63XfxmoC0oe9/oAyfyySJ9Lxf1ZFFBJq+5BBSvU2y4XKzVTbswzhFvmeUUqTo6Dw6DO8+exPPYSUAAhsUKtqQ37CO6RsXH74/ZoLab6aTa2CuueNegGTF7m7AuITVLsdixBMeklFTniXlEtYUqy2cwVjfGVvDd/EOLCCCHDyPA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(186009)(64100799003)(82310400011)(1800799012)(451199024)(46966006)(36840700001)(40470700004)(2616005)(40460700003)(7696005)(6666004)(478600001)(336012)(1076003)(16526019)(426003)(26005)(316002)(54906003)(70586007)(70206006)(110136005)(83380400001)(36860700001)(356005)(81166007)(82740400003)(47076005)(2906002)(36756003)(7416002)(8676002)(5660300002)(4326008)(8936002)(41300700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:06.0033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fefbb10-e4d9-480c-e962-08dc016e729e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743

Save the secrets page address during snp_init() from the CC blob. Use
secrets_pa instead of calling get_secrets_page() that remaps the CC
blob for getting the secrets page every time.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev.c | 54 +++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index fd89aca22f6a..6aa0bdf8a7a0 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -72,6 +72,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -598,45 +601,16 @@ void noinstr __sev_es_nmi_complete(void)
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
 	struct snp_secrets_page_layout *layout;
 	void __iomem *mem;
-	u64 pa, addr;
+	u64 addr;
 
-	pa = get_secrets_page();
-	if (!pa)
+	if (!secrets_pa)
 		return 0;
 
-	mem = ioremap_encrypted(pa, PAGE_SIZE);
+	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!mem) {
 		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
 		return 0;
@@ -2086,6 +2060,12 @@ static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
 	return cc_info;
 }
 
+static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
+{
+	if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
+		secrets_pa = cc_info->secrets_phys;
+}
+
 bool __init snp_init(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
@@ -2097,6 +2077,8 @@ bool __init snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	set_secrets_pa(cc_info);
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2249,16 +2231,16 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
+	if (!secrets_pa) {
+		pr_err("SNP secrets page not found\n");
 		return -ENODEV;
+	}
 
-	data.secrets_gpa = gpa;
+	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
-- 
2.34.1



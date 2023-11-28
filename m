Return-Path: <kvm+bounces-2603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F2E7FBABD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 645ADB22152
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606D457873;
	Tue, 28 Nov 2023 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5qBtNu8O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC81BDA;
	Tue, 28 Nov 2023 05:01:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnDCPWp5kvHO06BNbt4ZnrCroXMmT3uhhynnbgvvEr6fjg3sAegqZXETTM53ka6eZ+y2M6iL1J0nyt/nAUfWA7nPlYwNMIDwKaHCs64sY3EG+y8ytHQzS3ffZxITqV3aQS96WBSkdOtGMYO0xwIYPGbjHbFjajPIPY1c4RD+N6PSZAk1nUYpQhhcbrD9r8SwhzA/izIcjwgWdDPb6toBXS29T3fT+/B+u8J1YmzVifNQVOxTkwS5MmtDXZj+Le9PXNRxxMuHRJEDkzQCkzmNekwLQ40/8EQflS2hP2G2yP1yuuCU1AZnFICqCYmbUERLY9j2m5LIJNXKZ0U7bRWkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtoSEYU4xIwFMSzXfF6Gd+dIQ0h+iQs8FLK1igLUhwQ=;
 b=Y1ASDVaYjLCEVy/o17dYc4N9erTpY9hfNBVSgBxNO6FUcmbYpfevhY6Xoa90+3ZLhZVTQzNp86lLQ3mbksKHjXZ8MsVpDFwaXmFoh5Vqa7zS5AKk+T5ek0FZMGZ0ZuIL2L40nZm8clQZ73UnnBtjmlxrnd+ITN1pJsQcKWjly+U/eltdJYcAMbO1miAstQxvQKbdEx1hjpKNm9tRp9YsDv3PSmM1KEdeRMAK4f8TKkwqII+GXZXdpa0ltJGPoK9kLICL/z42Oqn1VndT81jzNXtOmrB9286GS+I52/2uOGaSyfA6tFKxW9BrTcrTfX4MWT2tjTVwTj2nDZ96Pz7VVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtoSEYU4xIwFMSzXfF6Gd+dIQ0h+iQs8FLK1igLUhwQ=;
 b=5qBtNu8OlcScgrP7ckzWhaQOa8ZugjYFmBErNyRnDRKzz+NTM3eBX5MLjwbjfgRlMelofClIGcX79E8G6G+otBnmfoJjLnz4O0zSKI2Ui0II/Oe72xAsM1FmcLa7RUzNGsOPSletJnfK70M2Q9N+HBJadyWubCEgKjwSku8wGxU=
Received: from DS7PR05CA0029.namprd05.prod.outlook.com (2603:10b6:5:3b9::34)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:01:19 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::c4) by DS7PR05CA0029.outlook.office365.com
 (2603:10b6:5:3b9::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.19 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:14 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 06/16] x86/sev: Cache the secrets page address
Date: Tue, 28 Nov 2023 18:29:49 +0530
Message-ID: <20231128125959.1810039-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|BL3PR12MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6f466a-6748-4e2d-a4d5-08dbf0121cfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i0nmacAWfMPNHcL1Za+PbWz6p+fEDfiFxCpK67Ouim3yTObeSQRwsWn0jymfnAfdl4XMpULglrLJySMaENSu7LgPVrC3UOW4/xeiDV+PwkonVuhcYmnGqWDZ/JtK2ewpQPUch8JhpHnh593HcKH2F3qKi88bzBVW+/B/FnYyUolI2nw3I+rX9uldAc54+GiXkXUfGYc3I9UapyHYAxyMP2n+1g8drGAG8pmOrWRyJqkVBn23EFXCROrI9oC14E09JKdBQUK5ozKh+NpZVyXYRZSXSIsgIwuFuLPJGS/Rqp5UUxmje1JCtxvsj+nddZzN50IeEF/KE0iBtp14Shca5aAiSuHdfI8YogM+fw8i6CZMHpoBpS0TomGi0Dn/FcDUs1BpNUTS2z8BD2TyIeg9liZNJNk4wlE0GutVJoZgMYwcJi5IlHTqax3APFLMZ4zFRFdE01qtf/SpNEgL1f8aiM/Pcz1IgpZZXHuY2IlaW6WPhCX48nX16L8gb2M7GBrtxW8POYiPwUUcMnKPPhIUV3RvtBbvLhwyw/ZWlTsooQ99F0pkTqrhZYCSg31MxqG8BbZ3wiri3ZOXUmCPb6DXGkOkomxlV3Crdq5Xd0iQqiQo9AA+bfgoiS+y9yhahWsDbEcAfQ4tYVTWUfwQE9vo5Q1W8jiNIHrDV8perA3ERKJoYs3JvDrqIzW+cBYj8gyD/VjudlkGJNPOMLBXOzmtHpSiocknqQ1vK2qVbSe44QYYwTL9gjlm/Al9E7TvRNxwSRMPOaTzsb/Pr3qZ2aZueQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(82310400011)(186009)(451199024)(1800799012)(64100799003)(36840700001)(46966006)(40470700004)(2906002)(7416002)(40480700001)(5660300002)(40460700003)(6666004)(36860700001)(478600001)(36756003)(426003)(8676002)(8936002)(4326008)(41300700001)(81166007)(356005)(336012)(82740400003)(7696005)(70206006)(47076005)(16526019)(2616005)(83380400001)(70586007)(316002)(54906003)(110136005)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:18.8294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6f466a-6748-4e2d-a4d5-08dbf0121cfb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473

Save the secrets page address during snp_init() from the CC blob. Use
secrets_pa instead of calling get_secrets_page() that remaps the CC
blob for getting the secrets page every time.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 52 +++++++++++++------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 01a400681529..479ea61f40f3 100644
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
@@ -2083,6 +2057,12 @@ static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
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
@@ -2094,6 +2074,8 @@ bool __init snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	set_secrets_pa(cc_info);
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2246,16 +2228,14 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
+	if (!secrets_pa)
 		return -ENODEV;
 
-	data.secrets_gpa = gpa;
+	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
-- 
2.34.1



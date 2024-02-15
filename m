Return-Path: <kvm+bounces-8751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B1A856230
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07984B2D240
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AEE12C809;
	Thu, 15 Feb 2024 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m0MJWPep"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488212C555;
	Thu, 15 Feb 2024 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996740; cv=fail; b=OLBHzpqiqZe4j8R+PHp3/nw3IzRI4RbcObqVGeB99HE21X5528rN0CCk9N1j1jQ3q9b6HmKnKJAno0G/fmVPo8q1loblCbMTqHy5UeN7I5T6L4Kd+XNg7dLh9MneW64aD68cAjlZzJ5+Xmu49IkDv7+Y+kTPJZqmkF+Q9Qucl9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996740; c=relaxed/simple;
	bh=6AuogQzkgeHmdyur0JYogSubXFLZDMbl6j0an4nrMG4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=heaVv7Odic4YsSOS+FhsM0538W0oRMfZK2zh7IdC5HBe0mNUTaUWoYx5x0z4ZDWNggkR/ZL/fbPBo3XQzTF95o3O7iWtDZyLNMiZ16PkdVaj1oyyVPhAqveRBiMH3beYiYRbiYyIR1XoFC1aohdUod5zCRiZHBLh654dh+oCdlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m0MJWPep; arc=fail smtp.client-ip=40.107.101.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Noz5Yxdkb11NNarPHJrudSn0nyaEVPDljJM7XmrmsXtnE63mfaSTrj7/QC9RZVu8MR6GQ6q5suMN0DJUr6xweZ45eBtbtkNtCMtlZ2OV8bK8PRfCLZat2V4kxh+pstZmd/gAIjs0LS/tnfff7v1xnVwEcbokLeHUcxw7PMPllZiXFii2+RSlgILyYZnllXO9vjB5yS3TzbbqYaZ3UzLyG7Pe22ZI8LdOuZqRLZU9s9Yr1vrR7t+vh3QPb2nG8O6hkWPZQ7w7ojlJzIsKGNUYBNw68Zp5+9iOVHpMxe3klTv/smC1v6+tO3wAvx4oEWM/FbXjSmh5Gomnf2KNV3zIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+439rbSSVbKzuLYwTuXqhQP/Ql7owCviaCzopdKK7M=;
 b=P2sTTQ2YE5P+tsyEp28QAtAzMlrvyP+qdgoii9ujuL6qqx0PYSpZwf+nbgPwepjT2M0FsZ6oAcxwVn4TDSEpFSCpMTC79PlAK/wdOu4XsU3IxIRPWTEV2lyFhWhvL/XThfhIsfDomaDPYTACvOST1+kr3wH3r6l2olGQmlNifBi2n8bwjX7hJz9RBnO+y1fdbf4D05qs9VihpS0qRxGdP2GqKXlBINoWtrAktPRT+dDXH9KkKRP8Fi8YouFTVbeArzG1K5XKmyGoj1tnWE7YbhLXOY8fNgHx8e7lQBpMGJOBPq5aBsqDfpllL7zryt8ZcA+4Rf5V1SorP65ZF6tgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+439rbSSVbKzuLYwTuXqhQP/Ql7owCviaCzopdKK7M=;
 b=m0MJWPepoUXxrcS20lDG4pmTBFJNcvtxkd1yloTAVEBoky34tKCfFYKnXC3fNJZe3g94vK4nQ5D2kK6LXu1zFdYUdDnhHGj50gPCGE/mzuGXR+NLWyfHa98tno+BYHeo5PpsFyFWHkDL0UFqOu0Hhhr52orx9/gQlDncsLapgHw=
Received: from MN2PR18CA0011.namprd18.prod.outlook.com (2603:10b6:208:23c::16)
 by SA3PR12MB9090.namprd12.prod.outlook.com (2603:10b6:806:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 11:32:16 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:23c:cafe::66) by MN2PR18CA0011.outlook.office365.com
 (2603:10b6:208:23c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:12 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 05/16] x86/sev: Cache the secrets page address
Date: Thu, 15 Feb 2024 17:01:17 +0530
Message-ID: <20240215113128.275608-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 7060767d-5bf8-4d26-b192-08dc2e19c359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X+FSePRPbvB1SoOw3wqCaD+YCq26DV+eDAmJMg2o4viKtjrOGkqq5Wb4qQcV5BCAsoghjSe/X4IdGzz90GPC2eZOZyjRUplm6QaWjXr32oeZTYHzsjfEHbeJQR79vjFLg6QJLADc1qwcd7+lA7r9DXlkP6Q+i26zijOH9mPWrk6CsU3/8+hbWejqPjrwZrT4+puZEQXDcO+zSGEa7NWZGMHWevoTrqWergKzkunHqK07GNIrZ0ZsHULqqwmESeMDXtfJSFJiLTys2bgn3DwiGY06CradErJ4Rjjn6ka5JZtrLG1Ci6XDZgZx7mCE0ovXawe5HAi4WDPWBiLeGS7ZgP2AxblszvjAefzLk2yxsixLUKh3a1MWzhK8CVjQ+xfuqH10e4fTX6gdQcPfIMQ/cmxB0gQ9eg7nAHnb+sMcA6Rqmi2I7X1gu3oLDJQmhqwYXflhCDOnG/K7MBjVZ0hZfHWG+PNWWEsLBw9L0QWlu2j8TF7mCRIiVM4u7x/HfB+PEeF3D9kX3n2RKqLMY8ZHxwMN5qTl00uLDXKJsQ3m6xh8kHTDDIOnSVhIwVcSkd0qYyaqC120aJs3rbH+PvyV2/0damJWvlGYsytWA3Yfz+30L01IN6Jio25cuQL0DG5OLsUUSyH/Dxy3/Desybr7SJpCYHrVh+zCkB2GaLN118E=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(36860700004)(40470700004)(46966006)(7696005)(36756003)(4326008)(16526019)(478600001)(41300700001)(1076003)(8936002)(70586007)(83380400001)(26005)(5660300002)(426003)(336012)(8676002)(70206006)(2616005)(110136005)(54906003)(316002)(356005)(82740400003)(81166007)(2906002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:16.5794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7060767d-5bf8-4d26-b192-08dc2e19c359
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090

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
index 479b68e00a54..eda43c35a9f2 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -71,6 +71,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page physical address from the CC blob */
+static u64 secrets_pa __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -597,45 +600,16 @@ void noinstr __sev_es_nmi_complete(void)
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
@@ -2088,6 +2062,12 @@ static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
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
@@ -2099,6 +2079,8 @@ bool __init snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	set_secrets_pa(cc_info);
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2246,16 +2228,16 @@ static struct platform_device sev_guest_device = {
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



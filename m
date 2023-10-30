Return-Path: <kvm+bounces-53-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D30A57DB39B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83C2B281415
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1913D27A;
	Mon, 30 Oct 2023 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mw5NEosP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A2BD263
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:39:32 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E548F3;
	Sun, 29 Oct 2023 23:39:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkS8hUmfgoQSLmx8FI/zq+MIJrZc+iOqtKZUu0oHy77DjunAxj2+se+lHOh+8mgxZSV4KorOIHzXP7rjIYciWHX2NxD0duA+Xg9fEo6S+CTHykHwOnDHq/ZvmoiF3CxGQD6gcRCr55+KwTaVH/AcPDKMpUIWFLcSUFMZ1jh4pKGKy31zp4vdFZmNR6qd5pfJJi/fTmEeeoKjlUyummf1qEhemdo6o/uWlIcBx88DNtSOxF5a673O/p+WTS0cghy1BGu7ypkj1/RDJeAMG/4ifePGe+HW24tT1H5+k1TUCUPjynJ7WM/HurIOIKRa3e5Vqp2me0ToCEQhsB/r+vDh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7S0QfNyZyCPa4u3nkOKUErbZa/aijuE0Cav6TY9y0Jo=;
 b=dEKbUtzBVyAPUqsIoWpl7nZ5a7D0sfprtxuFCU83wSpDMePeIIMS4Nzjko0x3BBPHEcvUfgEREyCVw8e6qfSbE4S0C3i9uPmwwPIxGXempy9u2BU2U8gttISX3VNgyKLAgEmwE/7aYxOVSzp5MJHuFNpe24bFmOtR/oJoNSj76Pcug25z45topn7yqBQ8nENR4+pVoD0OjTGKBqYUPvPZ5Oi8isctazW1myEkSB3AfxTXh07uxC3h+niPjwozBr/vMknFqTD06UTE5M5Ll1S5Wv8Vwaq9NqNLoURArvx3yl85nKDJOlKcZc4pEl4xi1YxGuD07bMmVYnerUhnYloVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7S0QfNyZyCPa4u3nkOKUErbZa/aijuE0Cav6TY9y0Jo=;
 b=mw5NEosPzc8OhhPO1ytdra4r0BlYWjdiytGAMn3sDaEdd8bV5AqvBg2A2klNdMZDPHvj16fpV5KCJB7lQ5A/5/NYCaDVyKiJEmfR96WPAYVrQyxTks+ZabFcBN5/tpn75D9e4tpECfPY8WXzyM9SzA44t4GQDfg9i/bXkseBVVg=
Received: from CY8PR19CA0046.namprd19.prod.outlook.com (2603:10b6:930:6::10)
 by DS0PR12MB8041.namprd12.prod.outlook.com (2603:10b6:8:147::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.25; Mon, 30 Oct
 2023 06:39:09 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:930:6:cafe::71) by CY8PR19CA0046.outlook.office365.com
 (2603:10b6:930:6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:39:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:39:08 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:48 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 14/14] x86/sev: Enable Secure TSC for SNP guests
Date: Mon, 30 Oct 2023 12:06:52 +0530
Message-ID: <20231030063652.68675-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|DS0PR12MB8041:EE_
X-MS-Office365-Filtering-Correlation-Id: 3968ae8b-6668-42eb-64ca-08dbd912eba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	26/CSPagFGtGSue1wm/NaJtR5R/sHa9keuLy5KZI/zPpe/FQcsogOXKoBMOnvH56my8zIiWIACCu/lcZzr/qtkUwZigwJfH9QFHHnMHlPDSP+GfSG3+4yUlg5TvWpYjPEmyeLmmln2nwFH1ZMjjPBfb2s3bRJtLfPvILC84GjZRZy9y+zjPBMfVR3dwGrQK5zBm2PGgJCWaOzzfwXHoV4XUgQu8PDzPcEWAGIuMGLkj6uRiaBBL44VjQyFIwV8lY62617kyZYHumvKFQFwxIQk+PHlejhANLE3ONqA/jXObexbr7GfbgqNlqjtTBv11E5boKafJZAzdb2PWC9xpI2FntRjoKxFGX85MrHWENkd2URghAZGvuZIBbnuTljEWhB6qeJ/ei2XVIjul71J/rYmI7+8J3QxreijhWffmnGbhxYalXGvIzZ7POtO9XYkXJsKPpREQ2sK3slWPyQwVBMZx1hZbNoorZdvxbPNjBKSr/REGhlhVA8djY11V1QEXQMqLvDYpgBzdYd3pJOd4MNUtJ308RRSl5R1sv8yTn6Dene1AbheIfyC5DLFZgIHyowLXXXEhGl6CMju66tseDubasBbEgJqnwPZHteC6Hc6jWTlxIwImFJVgNMcs2c1ElNOYy74kqofDqYIi7ndCIDv26BknraNKpFcHBGwYCv2a+Aw/jgY9U+0gD+SccWIxmIimfohLsaOtPzrC9Gtx2CMUp/wDjpWFdBcQFQnHINEP90t9O24vLIgrusr0Ipg8ZBOusthphwP9wj2mubUaBfA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(82310400011)(1800799009)(40470700004)(46966006)(36840700001)(2906002)(40460700003)(36860700001)(54906003)(70586007)(70206006)(47076005)(81166007)(356005)(82740400003)(316002)(478600001)(26005)(7696005)(6666004)(110136005)(83380400001)(2616005)(16526019)(426003)(1076003)(336012)(41300700001)(7416002)(5660300002)(8936002)(8676002)(4326008)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:39:08.8349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3968ae8b-6668-42eb-64ca-08dbd912eba9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8041

Now that all the required plumbing is done for enabling SNP
Secure TSC feature, add Secure TSC to snp features present list.

The CC_ATTR_GUEST_SECURE_TSC can be used by the guest to query whether
the SNP guest has Secure TSC feature active.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/boot/compressed/sev.c |  3 ++-
 arch/x86/mm/mem_encrypt.c      | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 80d76aea1f7b..b1a4bab8ecf1 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -375,7 +375,8 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 01abecc9a774..26608b9f2ca7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -69,8 +69,14 @@ static void print_mem_encrypt_feature_info(void)
 		pr_cont(" SEV-ES");
 
 	/* Secure Nested Paging */
-	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		pr_cont(" SEV-SNP");
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		pr_cont(" SEV-SNP\n");
+		pr_cont("SNP Features active: ");
+
+		/* SNP Secure TSC */
+		if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
+			pr_cont(" SECURE-TSC");
+	}
 
 	pr_cont("\n");
 }
-- 
2.34.1



Return-Path: <kvm+bounces-51220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D961EAF0486
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E93CA1C06629
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BB7264A9E;
	Tue,  1 Jul 2025 20:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MHjQThq/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F433261573;
	Tue,  1 Jul 2025 20:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400973; cv=fail; b=upfIEm34e6nIcvfg3541QaVFmOUP5Euz3dv82jyPeJsE1VANgfW3JdO46qxMKbcz2mWvN263yHGDuSinN0/Sexf+Fsgq76wp+QsMq24XagngOzJeKNxNmi8B1tHnlRqS8No2+t8a8Gaoz7zKzRhhVA47gVkVlUO2IEHCGgtgEH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400973; c=relaxed/simple;
	bh=5ljD1hrlAAxCS2KXYaphZ4aIMTOq2GD0/jlBVWRMimk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jc9Abj5VIgcN/EvlmiaA94GqoNlNekCrI95Jh4M2cQQub1rhohYkDP1ONOkGzby0zq2FreyYXRNUYKPA0lsXnMpb3rpjLOB3PJZWgiPtJ3DA9WRL33ZYm4GXBbCH/1moIJ5axziKU1PWk8/kk+WYTuVQrNUR9pOmQVqQjM0j5Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MHjQThq/; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUGn6mg9ZBxgVYtMbD/QRQ8/dOmomA9Cbp15vubMadb7l4oaGvX/j74VqwC/qRasQv0DMspq1mccFIZA4XpDt24U52+KPT5oG38ikc4gxYt8/q7AoTyt8ltrb6PBf8R0r8XXOEqkIpoduFsi28D1j6RyLeD4301MngQTSmeWy8DA0IzpQDoTB/7Gtw67ADppI9xo3+B/CwHjx0yOM59Un7/wfNx6dqRGCGHf/1IdK+OCRVP5jxu4Z4eH493YYDodbjNDOyArcZ697tcD2LNTBYuCDue7L8Wn1j74c0grYHJfZLPekoEzeUi4Zm10ny2ane7TuZRRpbp+rppDKQX1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVxM/XUc1AbKN4AMuy6XADegUDEWQdz5NLxP+N5Dx8E=;
 b=jZ6xK/DNHZi8Z8LlBATcUGgbj5A+I0C7gmjRnTRSwsSNZIK5nEqDhiRtgYK+5/UT5BujPzdw7brTmvSF5jsuadTWQYjPTLiACfhqG91cIjzuPhKc6LF8vR7md9YlbYDMcN/R0mUU5tlCqbbed548UxJq+uhcLvy9JBOeOOclTiu6Jkw0LdS8k0OFifaiXQJgMt6clMkNHHhqGLgervB70imzSMsZzWYa+wlFaHNm/K/TCNq1w6SkuQegb8HzW+C5WbmfICv3mfsty6w4CbA4JirhBrFFK8O29Lob2DAoRs+O43pZdf9O8NOrFQNtz1xVSbpgM08E1Zskw3YBec1nLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVxM/XUc1AbKN4AMuy6XADegUDEWQdz5NLxP+N5Dx8E=;
 b=MHjQThq/erD4hxbe/kOPqfPf+mVe4NvfkeWE/sR19UBAHNwI2Qv+YMn+7ajWx5uQ4/2VnXTzEFpdPRgr9FIKh63Tfdw9iiS1LqFtO9+OkhCMdHbot9fDk86OS67iYfnFOX7FDlOKHM1/5pePU/N179KSzvDYmMjvhfroJS6Iang=
Received: from DS7PR05CA0097.namprd05.prod.outlook.com (2603:10b6:8:56::26) by
 CYXPR12MB9387.namprd12.prod.outlook.com (2603:10b6:930:e6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.31; Tue, 1 Jul 2025 20:16:08 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::6b) by DS7PR05CA0097.outlook.office365.com
 (2603:10b6:8:56::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.18 via Frontend Transport; Tue,
 1 Jul 2025 20:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:16:07 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:16:04 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 5/7] crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
Date: Tue, 1 Jul 2025 20:15:55 +0000
Message-ID: <68885411fddfdba2fe0c3ab023dc5d5eb108689b.1751397223.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1751397223.git.ashish.kalra@amd.com>
References: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|CYXPR12MB9387:EE_
X-MS-Office365-Filtering-Correlation-Id: 418d09e2-6d74-4844-4c4b-08ddb8dc1d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TJKPfYbHRQ1H5rmhBy0QjG5d6QP3QN5uPRCc76t4+HW+aRxFqVkzTeQ99uwC?=
 =?us-ascii?Q?VCtsMz538hHQBUNVqo3b3O34QyxJYkzpeB8356TuokbzvtFNqIqHJmO6U30h?=
 =?us-ascii?Q?m11wBc/h3xmfly7//WzrkRl7r7F5vr8OWZJKtOtpkneQq5Cmc1h4JYncKFau?=
 =?us-ascii?Q?WjdDO0QH197h+b2qstYN5zalbcuoXO5quOFzH0lXdtNG/oZDNo7MIqh0kevO?=
 =?us-ascii?Q?UOB5pmg+xNijtDBDZS9lZAUqUBAypqeCkTedRrt3a2ShiTGuD1dByKjGEf8z?=
 =?us-ascii?Q?7WyrKYgnS8cw6sE9lyn13KWaGQs40t5HtfbCTuooSNLZaFSge+DUFBHRoyML?=
 =?us-ascii?Q?2blpDG/WT0IVC9YB/w2gIjzujtrWzdcN5OTMtbq856YujqDVWRIElHsaGJ5Z?=
 =?us-ascii?Q?9mvXHyJnGm6gqrEjNoyGz9G5zDuOpHtlqvZhTuzeFCcig0M0Jj2USpqe4YYk?=
 =?us-ascii?Q?Aud5NVZ8905yzuXmPpPsktsf7BoVROLXOtxpW3JzrW1ELj0988HiDidwHyfT?=
 =?us-ascii?Q?de4ZcrYXJxDQMDsiEpG5PyQT8YXOmRcFaRxZdagf7jzVHzl/dmv62vYqmj53?=
 =?us-ascii?Q?dRoSSc83PYTc9C2P2yx6pODbLDx9mCtWwirFrqsx5YIUud5wajTawfdekhD1?=
 =?us-ascii?Q?b82qSW/QOn+KhNbZ4tiYT9HP0sbCIB1jzhKNMJ6mhIGzPhRhpwjcFUMA0ZZB?=
 =?us-ascii?Q?+eEbDETmp682OGjDe6CxgBfc8oqtaCgDjL3Yab3yxvgmybYO7jlQXGe2vSP5?=
 =?us-ascii?Q?5xSSDtF7MpRclGDnLsygSrw7aIMN5M8FIp9COeHRq6RCic+6dc7wzYZBi9zT?=
 =?us-ascii?Q?han/h65hQahR4Uuc3P6MhJvmMm4VPvV5PR/urD+qt9Kv5Jd0TZttGLdMYXPs?=
 =?us-ascii?Q?TW/NTK77saPebhzUosT1yk3ACTPMPIx8vxEfeIFAyEgc1ElZ1iW5zKa8fB5e?=
 =?us-ascii?Q?Wz8qahnZ0qQfj+Ep5YJOAGv2dpZsT5ob6BA+ziZFdOBwCANnGNsi4TINf/2a?=
 =?us-ascii?Q?XenT3OetIF4xNlGbbKhVCkD6qu1GmkJl/AXzOGs3aTROa8oqci2SXw7hHPMQ?=
 =?us-ascii?Q?WqGzgv1TGAVuV2hNmLRdULrDzv6k/ubY8DSHBxn+4TmiTkv97CUbXGklRYtQ?=
 =?us-ascii?Q?nRGmGkXAfscEKuQvtr27WthkF8dA8ac3s8Tp1IJcpvhBKFMjW7Ap7GcCaclM?=
 =?us-ascii?Q?SAciIgWQJDcPdYU8Sqsr/2Xxis1ZrXbHbEZGKOvSukoRJo2LGWOGkOgVUTZe?=
 =?us-ascii?Q?m8/HzJ99oGeQtTxiCTOjh8Mg5Oquy0Kxcfd5AXqIf2cA7P9fg2EMfx7iwzdw?=
 =?us-ascii?Q?iO8BpUi4EM6WfOhO0nHdf4F7qTAxtadAblLEXdpSLpNJQA1qvxK7RN4DU2Bs?=
 =?us-ascii?Q?lmkQIX3Gt6J1g+RzFWNsRpkflbkR+wIRrDI6S11kv6EVsBGvemO7SW/bOarw?=
 =?us-ascii?Q?UFXb26HWZldMdOR+hh8DF883+vh/PXzHzNKS7Gwz3KSjXI6jJfWk+f27hJ5b?=
 =?us-ascii?Q?ROFrZUmgS6l2PIPn55UoJJi5Y0Al8adNU+XcrGnCqsiIFaRRUUqTCXp5Uw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:16:07.6435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 418d09e2-6d74-4844-4c4b-08ddb8dc1d1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9387

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding needs to be enabled on SNP_INIT_EX.

Enhance sev_platform_init_args by adding a new argument that enables the
KVM module to specify whether the Ciphertext Hiding feature should be
activated during SNP initialization. Additionally, this argument will
allow for the definition of the maximum ASID that can be used for an
SEV-SNP guest when Ciphertext Hiding is enabled.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 12 +++++++++---
 include/linux/psp-sev.h      | 10 ++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3f2bbba93617..c883ccf8c3ff 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1186,7 +1186,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static int __sev_snp_init_locked(int *error)
+static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
@@ -1247,6 +1247,12 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (max_snp_asid) {
+			data.ciphertext_hiding_en = 1;
+			data.max_snp_asid = max_snp_asid;
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
@@ -1433,7 +1439,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(&args->error, args->max_snp_asid);
 	if (rc && rc != -ENODEV)
 		return rc;
 
@@ -1516,7 +1522,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 {
 	int error, rc;
 
-	rc = __sev_snp_init_locked(&error);
+	rc = __sev_snp_init_locked(&error, 0);
 	if (rc) {
 		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 		return rc;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index ca19fddfcd4d..b6eda9c560ee 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -748,10 +748,13 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 rsvd:28;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
@@ -800,10 +803,13 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ * @max_snp_asid: maximum ASID usable for SEV-SNP guest if
+ *  CipherTextHiding feature is to be enabled
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	unsigned int max_snp_asid;
 };
 
 /**
-- 
2.34.1



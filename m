Return-Path: <kvm+bounces-51219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EBFAF0481
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0EDB1C065E3
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EFE263F59;
	Tue,  1 Jul 2025 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZFpe6kIz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF05382;
	Tue,  1 Jul 2025 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400955; cv=fail; b=Nw2Mcxk16+Aw563klIVQxOKdsY3mhjeKdIBnq9JsQFFlxPx2nGqD+0dslGybLz2kHQnxtvsfb89Ju3kbHvFk/aemxFDGni0Fj1/ss3tFnrWXNVpGyXfm27F8V/ORekDOKPSR1Z9vEe8sitym1LRiBvDVD3ZzjGJwhUfXugZZ2cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400955; c=relaxed/simple;
	bh=QfnCeRx3YhFPUoxdtNZ+4EdLwvUIz/+51QaIIvAg9U0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rtdek9aeRikT1UvJDanoN+Vjoh2rL0kZ8QIBoZSoX5Lb4kqz88OtSHi6txyRuePSRBD+IPdpMYT3eqneEhvdvmRD+jgh/ODsV0Wt+M3OKSuisOQcXBXIZLlB0QqwRze+iO/zLTRNieBiE30H9OhBh4MRRGVJrQr+tLfY+kCU6Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZFpe6kIz; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUu7DbNoR7LWzeamT0YB5oeXW5nftxZhA19Z946S7I7oNC/EUOzrax8xDh2tAM0mBJxDDjWkRiRhA3fhwBNp73+3FkG9cfx6hWTzwyONOcL87AeD3wysDYY4mFNMk7HrMXbL7bg3TQWnsPy0+bMnpnVGhvpRMdxJLnCMhdBeAxPNyAmsttQ+QgPoVYYvcrHON9KlJHFXUIfzjd5b7BSuBamg/hJ28W3JpJCqm+n2O2rmo6Dzhlc5ogtNLpi3lFilqZhapGefoW7C4ERjhb5c3/OVPN+e9+UPIxwdD7DNizY9vMIRnCPNa/96Ps0ni9dQltm1nhA2L2JCcdYlElc/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18c0/hWJUO05qBkA1prdnwiZaT7lEK2XdUaU8LlkJlQ=;
 b=EPZ/HksBY5fJB5llZ6B3+L2otsCS5NCJ7kH2pi/u6rgZK0zihV+CtEbRevMPbKFfyIKrcJ95yto0i0v3fM3TaytH9pdtD9d6r4bj2LoxKOexZ+zDWxsozqBx72APURXVeSi82TnPKwnsNk2oQZMla64oyDrvfdiCAXggunCA00H8LzuvZKaFqRghLhRowd41zZO9+16pIhMMhBleFxCUNFcs4JIAxgGGLlBJi5MXy5v2iImDzNaw2GokYdUK15FbtVFk1g+pHvvr8ujH1pOlhGT6TRrAT4IAUmHD5F7cu7PWdflGgXBc/J46sD4tjLTjH9aLGh1CU7Pds5Xcl0eRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18c0/hWJUO05qBkA1prdnwiZaT7lEK2XdUaU8LlkJlQ=;
 b=ZFpe6kIz5Ps3DRA4ZLkdwvIndVYGyPeQ9AQ5LUM4gBz9vvQfkT1c5osUeYmUFl0fD3/pHlulczuAQ2/W0TVBgWkMoOt4Q0bjm/blXLEHvyQv9Dbade2bbLKDxY11OFYpVGbsZdBmASf1V9c2zSsTw0rPUm0DGl3TG+4AR1auu9Y=
Received: from CH5P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::8)
 by MN6PR12MB8489.namprd12.prod.outlook.com (2603:10b6:208:474::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 20:15:50 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::ef) by CH5P221CA0021.outlook.office365.com
 (2603:10b6:610:1f2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.19 via Frontend Transport; Tue,
 1 Jul 2025 20:15:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:15:50 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:15:48 -0500
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
Subject: [PATCH v5 4/7] crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphertext hiding feature
Date: Tue, 1 Jul 2025 20:15:38 +0000
Message-ID: <a93e3912accb6c3b6d66b748f0045bd9e147c800.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|MN6PR12MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf4516a-37a0-478c-02f4-08ddb8dc12dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RM0G8rwBmzpvR//Yj5I4/bNDBYjWFcJPrDJf4Ur9ZRFrJ79Jj3TksMspsCJ/?=
 =?us-ascii?Q?T2JaxH+HD+eDIU47tUDmKzk18xMo2q9i+PaCjTdBP3mBAyFTZTp8VbJX+res?=
 =?us-ascii?Q?a9NqvGQLt5DXk+P+zbi6EO1o7MazwgKv/665k4g3nsJyzaDG8U73mYQOGJ3m?=
 =?us-ascii?Q?RJ51dtMlvvYUp4h0GivrOomPEykvFHB67+5N2eLdIbQPdU0LYWyJBsD1T50i?=
 =?us-ascii?Q?hXnKDkSf8GXBr9G1oK/9lXOnLlJi0RnTzlc0JNJpT+1w2UbpCMxT0kERwkq2?=
 =?us-ascii?Q?xftpomtV3MPgrYG4nyDEtaEapFWONkJZtKoaN+n2njb8rUtgV1707eDUxpuD?=
 =?us-ascii?Q?HHGEjEuMtRINSUnOn5gXWuOWm+lBAA2H2WtxLf0583XgcpFOSkEFo9qzQ3n/?=
 =?us-ascii?Q?ehoLkguSCJPvTWC/BDiWyl8FsPRdMGGqh1QWY1mzLZGbvopnJ3gyKolTOIuK?=
 =?us-ascii?Q?4IN8YoFqOcovHH2hN/oIkFRoeD+8P2KN/7DXmSt6ZMl7wKZmzSqD+iegVyNN?=
 =?us-ascii?Q?wKrtt3FB3H3pPPDbb9BBEa0cM1L0yXDGisD6F12r6DRXqNxr0WbqzCw8R+Hj?=
 =?us-ascii?Q?t7QaiWkDkfJe5Wive7j7ech/YS53IXLtFxRXo3OFaxl14yrg8C1YYilJhQY1?=
 =?us-ascii?Q?ImBX5lzH35tRqvEl9K4tO1MEvMwkUSmOWFIdkT92KTNKRSHYfnBpaFzCmdCK?=
 =?us-ascii?Q?9NYrY/3GO6+cisG+b05yEu895PQ3VTO0v0hatCBRLx/R0vUGbmaJ4XAcDATI?=
 =?us-ascii?Q?tPnIPFBMy8K0T1a1xqjeD/hRRzQV+RBL3bjupGkM5w50M/9UthMtSLQq4MNl?=
 =?us-ascii?Q?phfG/Zo9UhBbh3ezLpSaCC9dxj7CPrCVaIhoVxDqpyq7JZxDQ6koJITG3JZX?=
 =?us-ascii?Q?F1yD8wdPC4gY0bMXLWdJh5qh177AjemUBR1hF95Gx0DgN9UZZdRJLFHMYds5?=
 =?us-ascii?Q?pXrtooWA7YOoEEldGT0xpVoe+uqK/iiTWfLCU9ofiUAqlp5ybg/JLCtas5wG?=
 =?us-ascii?Q?dJGWlW65XIkBKDV1mkPKnuak7YKg1J4/j1yKr6273vSLe+LKVcEt7WEUxglE?=
 =?us-ascii?Q?D7K4pXMgIrl5UgQNlDTJ1quswEHPgraii1Hb0/EZMe3vN25VXRjPPdKHAzC/?=
 =?us-ascii?Q?KSGKY88G6a8cyywMtugkmb5Cx+EJW4tdNWHOBicytw4OGWApz60w7ZpyVohN?=
 =?us-ascii?Q?FlE9y0qVziFwA2pXYM7HpSoajitZkyjCUMmublaGq2wZN5xm+7YlJ9fXsd+9?=
 =?us-ascii?Q?oDmgtfnCgV8cXtXSD8g6rjz3E0LjlINAwxoXjnND0lp0MZrymb1J3cG6A+QY?=
 =?us-ascii?Q?MNjzXLzvO1nFkeCiADOsZk4cHC7L3fZXoaYLsNnO+Q2h7f3BEpr4a2zwc6k2?=
 =?us-ascii?Q?Cud5s4Ewd4ZZ23ETYDmgJx6subY+xkXTx5mAPhfQ9zeVrjdjz0gmj4+CGT+k?=
 =?us-ascii?Q?gq0weGMEjQytW5ybq37Oz0i/6w6Yc0UAlciG1wp3fIqFIBk+HdE714HSsPVR?=
 =?us-ascii?Q?TRHYidnkq4NhkROvNfZvL6nBluhs8/QsmL17NRTbI6ZqoanxGeNnyrgz1g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:15:50.4438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf4516a-37a0-478c-02f4-08ddb8dc12dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8489

From: Ashish Kalra <ashish.kalra@amd.com>

Implement a new API interface that indicates both the support for the
SEV-SNP Ciphertext Hiding feature by the SEV firmware and whether this
feature is enabled in the platform BIOS.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++++++++++
 include/linux/psp-sev.h      |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1517a91a27d..3f2bbba93617 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1074,6 +1074,27 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+bool sev_is_snp_ciphertext_hiding_supported(void)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+
+	if (!psp || !psp->sev_data)
+		return false;
+
+	sev = psp->sev_data;
+
+	/*
+	 * Feature information indicates if CipherTextHiding feature is
+	 * supported by the SEV firmware and additionally platform status
+	 * indicates if CipherTextHiding feature is enabled in the
+	 * Platform BIOS.
+	 */
+	return ((sev->snp_feat_info_0.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
+		 sev->snp_plat_status.ciphertext_hiding_cap);
+}
+EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
+
 static int snp_get_platform_data(struct sev_device *sev, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 935547c26985..ca19fddfcd4d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -843,6 +843,8 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
@@ -986,6 +988,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
+bool sev_is_snp_ciphertext_hiding_supported(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1022,6 +1025,8 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
 
+static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1



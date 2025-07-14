Return-Path: <kvm+bounces-52369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E197B04AE0
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 023964A657F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EBD2749C2;
	Mon, 14 Jul 2025 22:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wibqIVuF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D9022DA1F;
	Mon, 14 Jul 2025 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532839; cv=fail; b=i8Lc1ke+SMVFSrOLv7+FoGqp3bEsGbRl8pM+JtuadEWmnId5lwwAQWqi5NGJ5BpsEGE8TiUP5u763uVs0yA135pds3Zb8Zf66UOk+p8ivQZNizxwimwXZS/eTDAD9xXwRLRgmWzOhF9Jj2FaMn+U/yFueUPmgs/P402Qwl4sAz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532839; c=relaxed/simple;
	bh=EbCfapcfKNXTw9Wn0+yaQtHA8gtCQ+ExdT5njBRoUHg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYVa2NCqJqauKvcK8jRuv5+OtYBXMijNgULWfQDlCgNt+Pp4fUZbf7p6g9TqFtYEU+Ob2IR6lz/+9A31+rrfmQkIMMqNWEBbMjGMgw+0mzCW+U8l21JIsGS3cV3+0rBkdgYgSZp336JnjuG2xiVvIk4AWgYDzaXzdIdAgJ519hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wibqIVuF; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNM3YfMQSNy33ZrrmIbpFqQXc7L6Bd0tRXUCWfhwhCJKeUQ1rMpkF5o0M5hP3FxVTAjBcPAqcOL5ReLjAhRYmZDmpszXTya/KH1txzbfuOBVVTrjHcNq9/lia3BdY+YPdHaV7byvk06zkCuHqrwRHCwDQv0Oxs1vzgzbd5NVGQorYnMm/HZstZkOSVs2CQXLTY1FcXKCUiiHyFyTk7uQqgVitIBqXXCJFkFuwmoHZlCRDakpCNV/ngQrc6t71/EI0V79ed9U5EmJDcVm9FgmRwIQ8BY2iUOzNEWqYVCGqfG9aVpDcwR9+2TESuoocGLMZHeviYhF/wsGruUXs3CLIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJCiynNmCfzkXzvlMNkD8O9M1HMiKr9Bqv7ewdRFvZo=;
 b=GkCHNFr1xCG8D9dhHhXc09kWUKtTqcqxI1YyTPfTXdFmHx4sIIadEGYqLeSDE5NRnuCcR6AraeKWmC+Sbx1qc8W0Jac81+f3iF8ns6daGzAjld3GryWox1pzPGA8/DmkDsUSxA0DHNqnnQvd1qmZPHzfhg1oW4e4o2O2eU3n2ldSi1SHm2JAkss9b10v5ZjQNg0LnRtDfPfNwjSP7USRnIl1NaEr3Zjxh8T4KkzBjaaCgRTpWJKenzW5qBnI1wBFynx+xbZosWxgrx7jsLIQuf5N6+ZrE/mmM2AL3o+fqi2gRjAZF4aardtDbjNH8NHco+q/ocOSgZRu+t525ivOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJCiynNmCfzkXzvlMNkD8O9M1HMiKr9Bqv7ewdRFvZo=;
 b=wibqIVuFlVm3kHTEQR/YppLbu+kY+/mw5NdsOU8HsjSR+p7WpBE8rWLj5pZjLg+6CLciZG+w48AUQR8ACKpZWD6TKM48tU8lJv3RRvNiyNyGeidpIEnKs20cWRTjcagSrkbrNufwgDi9nq5l5Bw1V8lLY8APzz28/HAEgYcMxEs=
Received: from SN7PR04CA0233.namprd04.prod.outlook.com (2603:10b6:806:127::28)
 by CY5PR12MB6225.namprd12.prod.outlook.com (2603:10b6:930:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Mon, 14 Jul
 2025 22:40:30 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:127:cafe::c0) by SN7PR04CA0233.outlook.office365.com
 (2603:10b6:806:127::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.32 via Frontend Transport; Mon,
 14 Jul 2025 22:40:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:40:30 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:40:28 -0500
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
Subject: [PATCH v6 4/7] crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphertext hiding feature
Date: Mon, 14 Jul 2025 22:40:18 +0000
Message-ID: <2afb8bf011d6d40419b880303f4556299a1a2c46.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|CY5PR12MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: d17624c9-37fc-4dab-f45a-08ddc3276fca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EIZOUcc4tqbmEf2BxrxJmTHXcC2KgaTe9j5PAWmcV+qaTvbq9+2Un4edUFpj?=
 =?us-ascii?Q?UPTMnkPgzP0MfbEHU2bSulxwcTZshJfZqaQcgxS7OkqsN/8LcH7eMFgcucbP?=
 =?us-ascii?Q?oIFsB9DXDgrirR8c6HAmYb4G2PlZ1UELPv6iUUABjMxWN3kKWln9V7tvOT4p?=
 =?us-ascii?Q?T4tG1uwmebD4+J26arO1YMF0shZm1sSk0EA5SA/Et7Y0DR6EsjURtaKljZ0S?=
 =?us-ascii?Q?wG579oVEVz624jriFnDiqtB4i+T42nbqqE4wVWPcuze+Hw6lmg7wDFw/Xk/y?=
 =?us-ascii?Q?fbabt/3nKFTAhHcwmGgvKd1tfWTbKDflh9fNEQYfiuHJEXhlDm8WcLtUopv1?=
 =?us-ascii?Q?PwEgd1JfuZFkOXPjAYomZTjpYysokztAKAdq+4cVJKGWAL1zIGmmWWhe/NLR?=
 =?us-ascii?Q?5Frk3BGiY5gkC7R+TTsOesQ2umHZ1ikdCLf6NavgffC9HLCxrOHVoRctcl1p?=
 =?us-ascii?Q?VTKvl24HOSRuVQJFHS6WynKSsziZWTUHlmwIt92pyIkgs0IwXxIVs8LFhZrK?=
 =?us-ascii?Q?/HJtw74IeYUxJO0Cpm0VFXQuwTkluB50+AEp38TUMDnE4r6fAFUhdfRDyf5F?=
 =?us-ascii?Q?DVkXEOu+BcSo8dspemD84R10Ug5DMlGbA3RqXS2emF1H4s/pepOODNkvjPSY?=
 =?us-ascii?Q?yohZKIDTcpikbyyTFwllUDH9wQl980b5i8duR0wI/oJVScXuyVKTCA2J+yR2?=
 =?us-ascii?Q?gge1SfndVgrESlYPt4ElIVehuU1gI883YoH5xqCERwJHB729Lg1HVZCRk2Q2?=
 =?us-ascii?Q?HrQ1wLph0b1G+Jn816Rqn/5ML9UkhiM8uja4Yq1sJl8eWiBV6/6w0Z6wbjMg?=
 =?us-ascii?Q?oMimE956r1HJlN4aQ6DgPEmeO8t4IoXEkIoKacR2+WbEoCKSTrB1Thc7LyKr?=
 =?us-ascii?Q?AWMgBEPJOB1WItoceM07QdCJpy9sG7IxkYWTuURZaalhgKn+n8Au07/km6aw?=
 =?us-ascii?Q?IVRk3okj+pa/CsEOD8k7oRwenRLx1hHn6m6jyrT0n1A5iIMXkTsJP0YHYfF7?=
 =?us-ascii?Q?9AhiLFo+AWKtGSKk0XFlZpwYwfTnW1LH4ZEZ8ADNJgTwuIfbHLR51KepsVnR?=
 =?us-ascii?Q?6kUYj9oMVLXbPryFjrrTRzkh4Z4TYlGD55kRvo/4o4B1NUX+gmad2nXtb+tz?=
 =?us-ascii?Q?fRURSfRTMEbXOhqgIudiOsa7Ia0rZACaKWghGCSZvic+Np2CqFna9npDPnOp?=
 =?us-ascii?Q?gd+80fArOqxxS/3/tJpzDJ7wkoY8Mb7TF83DjUWTW+296Rva0E+pZ7iXi8h6?=
 =?us-ascii?Q?NkXuU7al1qrDGEoa+VzypKpGLNJa2UUm7GZR7UiEkp4zRqiSyJt9buL1PS+t?=
 =?us-ascii?Q?Pc3QpWrBErQKbHT1nMJBj/q3V3keF+3pyvg6vWQ3dPrCaGorGDkbvIl/R9f2?=
 =?us-ascii?Q?/jCse1r4D84/QqYTVX653940Gw6SJMH1OcbxfDKxuk7qo+mU5I7Z3M6EX3B7?=
 =?us-ascii?Q?bweFYx6YHgXoYobqbwYxaffnuR+t+l5phJaMUzC/xI0+gNFthDYG23oGge9n?=
 =?us-ascii?Q?sSRsBPEb1C34Yf++eR3ih/WBxAHauMVS741Vdqh7zs6sUjK+E9FST649rw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:40:30.2539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d17624c9-37fc-4dab-f45a-08ddc3276fca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6225

From: Ashish Kalra <ashish.kalra@amd.com>

Implement an API that checks the overall feature support for SEV-SNP
ciphertext hiding.

This API verifies both the support of the SEV firmware for the feature
and its enablement in the platform's BIOS.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++++++++++
 include/linux/psp-sev.h      |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8f4e22751bc4..ed18cd113724 100644
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
index 5fb6ae0f51cc..d83185b4268b 100644
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



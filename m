Return-Path: <kvm+bounces-33889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AD49F3E97
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D177169D5A
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF08A1DB372;
	Mon, 16 Dec 2024 23:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MUARCNxi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2050.outbound.protection.outlook.com [40.107.101.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288C1DA305;
	Mon, 16 Dec 2024 23:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393563; cv=fail; b=qxZkS3RsFrC/GjNDSbWcmuTSFfmBHUCAvvIviEEKnf9w6/95FH8Rb/sv7iDfNT0Mzr8IampFxKegEZ8eqoEgmHF7iRYRho1respQBJ8wolMFpj4vTSfo4uqGTJNxnV2USo1sN/KDCwydhhs+RInFQML7zTh7o0RcEn35WGhLGlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393563; c=relaxed/simple;
	bh=z96zz2l5e/UrE5xUTkiYFBvUSkoBjAbXT+XnOlMKlqE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BmZPWMXCMZX3HVm9jEH/BSdsJliaPKyfcW5vnZIE6eYTLtDr5GVT9aoh3jNK8lEhMJSOA9KazRCOf7DP7jgJVpjtDSoKGx2L2RTwfpCD3uBQ3YZBFJF5Whpt1EzDh2txK5x6Di0j13SVPnAlzX/d2f7D/HvouW93MGIeAMEVLOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MUARCNxi; arc=fail smtp.client-ip=40.107.101.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QAaa/nNqgPz1oyvxei0jKRNYKuaSiwOPAmIy7wseb9kvTcb4YvOK82BoMbtalg/g+3gQNg9NeLlwAOySA6Lg16ZMeDxHrlM3Uy0LMPYBK1J/dQ+cgncsyegzKOHUhV88XOeFqHnS6YWcmjSXBQRnw+OBn7wmeGLgHrb97I9GB4CKtFKJ6MVDfOxte7ihQMMHfn0AE/M50k2uqZ6rj8Ikiq1gjtY0AFQ5ST+EUrl+qyXEZl9smAKeIao8elLwD+MUfHmUPpGkq9R0wdXuQ8Dra6HrLCJBefLGOPZuevKHrhCr9ACQvaA4pReoWiKy2HGxOPhlEsc15o4RjvIsXpUfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWDt4j5npiNQiARNJc9xzgL4hq7NnujXlMDBc9bJRI4=;
 b=oQUQzmVnNLO9OOg8DTFvv0xFhNVDHz9ki6zswpRoRolx2y21Xocb2HL6Ri9+S/TVAQp4pUvYpTC24djIacSuPhOTBJCrlJq1DFpyXarub0Nh5t7QWs4DN+qoP3UAkmtRuREclVctR1l+cCDE1XO42KnJooRBeFgq2owSOiVPnSVtVZ5pwRxUE4BvXtQDdd6FzwGvy7UXO8N5r6zSq2xvrTTLux7lVfLAYuAVrDgTNKM/6CLr/pPLNxBAu1ESFMJHLCLmozn5uHpDZz567/iWhssYJoPlkEVMeteC2v/hn3LoBp72l2qq4yrd4rX6orevoDSCDJSb3ylwKOur8CvWnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWDt4j5npiNQiARNJc9xzgL4hq7NnujXlMDBc9bJRI4=;
 b=MUARCNxi0EJTe9HlUsrbEbJNwibsoW4n1CBKY6sQb+g4X3SScGAOoqB3NkhUmv8sNXb6A4Eqb/A4A8VCwHd2DoCVTb/a9zIKRY3MtMhCnKQvbh4/BgcxQOBVFzsFc9TCVFygBnhSRxsta5TeyHCPyKDtYbM+8iH7EAJRaVgZGrs=
Received: from SJ0PR03CA0359.namprd03.prod.outlook.com (2603:10b6:a03:39c::34)
 by IA0PR12MB8896.namprd12.prod.outlook.com (2603:10b6:208:493::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Mon, 16 Dec
 2024 23:59:18 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::b4) by SJ0PR03CA0359.outlook.office365.com
 (2603:10b6:a03:39c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Mon,
 16 Dec 2024 23:59:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:59:17 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:59:16 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 6/9] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Mon, 16 Dec 2024 23:59:08 +0000
Message-ID: <11ce67db2349a0c18fd549be41815ccccf401e64.1734392473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|IA0PR12MB8896:EE_
X-MS-Office365-Filtering-Correlation-Id: 138dad49-becf-4448-0e4d-08dd1e2da707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6b3jpGxORKKk3jfgzwItAAOOEmOzMed0Uo+utmFmoHQvrvgj2cUD0uSuGZwE?=
 =?us-ascii?Q?7MXqRdZQWrNOs+zTDltwdOB7twelwBQo6rT1ltW68bPsaYul2z+742eDXG3J?=
 =?us-ascii?Q?qcZKDvLSgXB3+w7mSq9GKT9urusDWfajiCW6eKTrsEVlJVSXtgTdwC7hzGej?=
 =?us-ascii?Q?VcyPWSgWE2FgybF6708DV3LyhuxVM2O4uFNAJ1MQ+x5uE8yLAS8ZDLvlJAYu?=
 =?us-ascii?Q?zpqT1l+JBxRvgzvLSPKhxakUQpitMz9ceix2gh/3dlBWOy/Hvvt6vVDwJWnM?=
 =?us-ascii?Q?z0hhng/sRApuIYi8GmeSiE2E8KeOsMpRSMLxQ8yJWBA8FvWBVx/Qj/1ZcmJT?=
 =?us-ascii?Q?WKXZ4uDZPmQhFaS92pqQz0ItaBPDrl5HzvK8Bs1hn9vL0DNzsVYMZ2G6i7zK?=
 =?us-ascii?Q?SERPgAtE7Sjqo2AMcwWqXN21bMNLlPQZE9kAt7CaDoNP36E6ZYBwyu1T/LUH?=
 =?us-ascii?Q?Ll6o2C45MtLGop1H0zlInJdYvp9NOY94jUkbvcO3UdAXxDPtJ8TcX2kSLNVm?=
 =?us-ascii?Q?sSZveTNZD4a105Iq3RYBmiGrNQUJf0P62AQDdbHFjp8dGhrEhs7lznmPNPeh?=
 =?us-ascii?Q?rlFnBlZP95sM9yY+hAgKuQfmHzWkA4SMjprHlQdvgwa7df0trLMg+i3vlEpn?=
 =?us-ascii?Q?uQFV5txfifRaxoqZkI6PKIAzKtUVIulLT/V3FW26AI/fiW06X7G7ktIK0yCk?=
 =?us-ascii?Q?Pdvjn7VU/eiMCtLLMwHzqsbJA/oA6phJO4gA1bK/aILU5CwISMpVcK0GWjfD?=
 =?us-ascii?Q?6X7Sa/98LP2NYDUehcds1z9w0K9kEmie3YCkEnHFzEdW13Zh2lFjM7DDsMYJ?=
 =?us-ascii?Q?sbJbOwCenDdSEV6pikuVmZxtqua962PpORH6pRedHLmwBqYeLxYSV1tyF0Xl?=
 =?us-ascii?Q?9t31Z7BvVn5T67fv71LUIIbqCpouZ/ue+HS92qIItgWdh+v+AemQnOAJPFMx?=
 =?us-ascii?Q?ZHP/RlyO+6d94fNbAwnkJC9AxEElsstvSKviwxXXXKWBROVusCeJ8NK0a1mj?=
 =?us-ascii?Q?COOszQeUCLdlYu+avsuE4Iik4/zz7ii8IAqak/GoeR0KHYlTPPThvm6+nXAt?=
 =?us-ascii?Q?ey7vBLZxGWhplsRMTt0wkRSLv3emqgp2aEXJLpWQ6yHeEgztnFOPcAk1bwCP?=
 =?us-ascii?Q?dsxJxwJJV7jg1q5arEXxjwrfP0nmmDMOfkyJv+XoAmsXe+R3qr5UZnGCJu0P?=
 =?us-ascii?Q?BqFyXIsDcEe6vFdqWKd+okWRf75qL5Hq9n+xj6COp+j/MGOuGyy02n40Khvk?=
 =?us-ascii?Q?Ek4/RTc3wFZNu4kW0mcH4s2NK/DoR/Ah5gXuZo2Hoy2JjjGpiUDsgKk4dq5y?=
 =?us-ascii?Q?hBiTLtIsAygg3DL+OEiQ1h38j0oazc7PUifCHD5tq+JqHppONRGMYvcVfzj/?=
 =?us-ascii?Q?+0RnuID1MWe8KE72BUtZ8I6842qTd/UZkDWA+p+71a7CW5GH4T/atgedFB0Y?=
 =?us-ascii?Q?2kGcEQgNCp01rl5NcbFIOawqH7TcZZmlglPovFR7NU4JSRmipBwkozlJpsL+?=
 =?us-ascii?Q?/hQ74pu2dtzHwY0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:59:17.9535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 138dad49-becf-4448-0e4d-08dd1e2da707
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8896

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded. This interface does a full SEV and SNP shutdown.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++++
 include/linux/psp-sev.h      |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cef0b590ca66..001e7a401a6d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2481,6 +2481,19 @@ void sev_platform_shutdown(void)
 }
 EXPORT_SYMBOL_GPL(sev_platform_shutdown);
 
+void sev_snp_platform_shutdown(void)
+{
+	struct sev_device *sev;
+
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	sev = psp_master->sev_data;
+
+	sev_firmware_shutdown(sev);
+}
+EXPORT_SYMBOL_GPL(sev_snp_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index fea20fbe2a8a..335b29b31457 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -946,6 +946,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
+void sev_snp_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -982,6 +983,8 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
 
+static inline void sev_snp_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1



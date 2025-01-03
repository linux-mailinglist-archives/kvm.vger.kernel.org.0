Return-Path: <kvm+bounces-34546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACD3A00EBF
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FF77160693
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1B01BDA95;
	Fri,  3 Jan 2025 20:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dgPlJOrL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF91B4F17;
	Fri,  3 Jan 2025 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934512; cv=fail; b=KQccuB5cLEUJHfbgFetIr8ACT+72/2+qnMup5zSQjdEYL43GSvkbbQgaVllDJ+YXiwmEmmVrwgCcqg5Ll4mvy8piNleqLcuigXOM9m3PK1Q+Qk47FwjBYhiNfFmBe08wxthPXhlLj0Hkh02IVCyOllLUSZZoV29Nbl73ADgvz04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934512; c=relaxed/simple;
	bh=jCFt++qCQk9Sg5jbRA1/795ly9eisyXkC1b++cEoVEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z67IjzgZtS0Ca08m8naMAnhVf3LrtywZ+OuWl6WMmXK71zQazkhrPHBL/FVLw0lnWptuIH6hMMzBuutRb+47d0hA+byM4m11moSRw0PXDqNUrezs6typHQJKQMhh2tDgol9GRQiLDLe0JMmQNW0n0FcAh0c8VsfFcI4jOavJYpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dgPlJOrL; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rY7oaTANnLU6btgTBi1hjn6usYysfcDH4Y9yRiioSbubK+VA9I85nQot2RJoLiF05GCx3lAX/QbaCZdHbP/RmGlASZC8ebblfXltz2npAVTeAku0W8CtCE7EYzOkx4CdtegkUK9z5TOmn1U0uxJ0TwW/0LYswrAvqJsxLFGxlA/yG8OEow4MLtMhMXtv5nekUZI8wWEclpmBAYwJumSz0dFdv9XB+5amw0Kka4WF8z/Mipqjt3JVAlQ+muptvL8ibGI7d/w+FG1ROpnUzWfOuM+mOXGPOsR7JvLrVSr3KJjzVu0DxSoEno/jCIGGeutS+z+NhL8JsceyaXQBXSaoZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLhdquEZpBE9GOKFIxrmmYxxn4rshYnt4bu0esjBJgI=;
 b=AFs4LPkuJUi9vsvg3ui7N/t138VdQULWTgjmml5lvvkCBqDZnXJVe3kmfkfuJEk461R/rS4PmaV0JiV13mV5bOdyvZr3Q8S/P5nJNyB9GS5swaxfXd+cy1RMmiGf9SCczrn6CepLm0oU7hju4l1xQmlOjKq7tyHOJTGnHdf9jExjrfM21rcrECopaNI8fRsHmmfYoHJj23IqEWuWwxawmY75I5o3hOUMfxRlmuOFLDcA8Z+JB/MKJyC4NvgFeU88UjhszWo707qYNQD3ZWZ4495Y4sYS4WmVbGTrknb243hGg3twPrRy5+zULEVpj3/zMLRv49sw4sJyjNpS5lOrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLhdquEZpBE9GOKFIxrmmYxxn4rshYnt4bu0esjBJgI=;
 b=dgPlJOrLMPKTmVjifBDcwBHLIlyOQ+FsRAZlA9J3HVtKp0GK36KewlfChgkGoV1aSAahUvfmm+YIEY3WSfIMg1Y1zpw9a46xjRFdthzlrr2E8tpKZEz1dSxB6M8J+sd/jpyDUXAyfoDwfCSTIlFPD0nhyLwjBbxP5rSWpvDN2Hk=
Received: from CH0P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::6) by
 SA1PR12MB8721.namprd12.prod.outlook.com (2603:10b6:806:38d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 20:01:40 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::42) by CH0P220CA0008.outlook.office365.com
 (2603:10b6:610:ef::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.15 via Frontend Transport; Fri,
 3 Jan 2025 20:01:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:01:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:01:39 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Fri, 3 Jan 2025 20:01:26 +0000
Message-ID: <da32918b84ad6d248a0e24def7955c0912c9cce3.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|SA1PR12MB8721:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d19c4b9-633b-4f70-a69b-08dd2c317063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gJJiukiyCwcBUfMmfOvGRtNReFWmp046hM5IG6WSF4ZEIdBZSkMyjMul05EV?=
 =?us-ascii?Q?2fDjboEtIhVLJI4WlkegeyZdjxAZ7/1UU2Ig+vjKG9d6WWew+dcf2mD7hXYT?=
 =?us-ascii?Q?rDIPcndr1Qj8ZI+0GpIyUCLXfKPejQ6RZEVxpz7WCbXvek6LU4vR39y54c3v?=
 =?us-ascii?Q?o9jQy/MZcy+zp7C35WuNEjTjxnEHpgwPDWANXPCYiAmHgPvRfcO15Vnqi7aR?=
 =?us-ascii?Q?8GasE3ZMRpXIj3ZGPFHcgGSzgAyTe9aDxXe8NPhABZqLGejHiKV5+CGrKy7a?=
 =?us-ascii?Q?KBExaq28PHQ8oeNDJFhqta0yzUAS0JWUfhXyWeN8M0qt1JJ7BccK4gqn9MF0?=
 =?us-ascii?Q?X3WurUm1ieS8/7pyRjipDYqdKGXb0sTGaREWEerQlp75v6Ta4cE0fXh3/fp/?=
 =?us-ascii?Q?nwQ8qHKTHsGP4TteNaUKW02QqSnC2/siKHvRb10K07uuX5/ghRLGyuBipx+R?=
 =?us-ascii?Q?6/dx8QCjn/gxh7NCj/NzkYZkVBAK8RyDQa1jXtijs7r90QOD8m90+3N+uvN/?=
 =?us-ascii?Q?xRIgTKY7y5mqFyteEYjmslnJJtOyoUmmIVSXrNnRL73nU0Sn9A4zqKVnNeR7?=
 =?us-ascii?Q?FZN8s2PkaXeb/kZe4IQRzuWSyK3d581796Nyhqda8+v/5oFeAgQ6I2M4PCh+?=
 =?us-ascii?Q?4g+yFFOqBq75ulZ6TpoCZ0grG/8yzVxqoP+jTkDYmCfKMrzV9pYhV4l7R2Z6?=
 =?us-ascii?Q?qf97UNpCCEtaprdORumwc6dBsLl3UwTd1i82PrczfvoNeIB6h6ZHwlvFMCFZ?=
 =?us-ascii?Q?g6R4P+bLafLUkgSuuMFiq//HTWF7i8oceogVlhsZLMrjaVjlef843NgYu3gg?=
 =?us-ascii?Q?yvPBOWsSf+a9RapHKDcUy9/J8I/P8JSdV9AYbXOdqE8kFWXwxNMkhNFm8WBb?=
 =?us-ascii?Q?td7xODhWCXylFRliXiAGZn5havfh35SDpbHIgR5HOGIT5HGYxDtyaUmRuUrJ?=
 =?us-ascii?Q?gpwzrYfFd7BA/5ARUDOQySSpOXNdNquR/HcdSPLT2QlTIEqY/Nbj0Lqq8wY9?=
 =?us-ascii?Q?Cx1v38kGYFsh3Va6RtuwJe+PJlDoh92syypDiMrtaxS2mUK1fW3mrq5MHjzM?=
 =?us-ascii?Q?uFOdw6YNv+iqnN28HSDOjMK0CRHVmEF22+Ua6yyr8pK7Y9R+eL3Nq8cRc5g+?=
 =?us-ascii?Q?1u9CXmUVfG1Bg+4z70vQp13L8+htLefr5Fz9DkPvPyJITQCuT3H+UT+sBNw2?=
 =?us-ascii?Q?O1q5XdlgL/SfQ7ZcSIqle8mqlyaLJ645tvE53gNcNv4eLf1JwuDnL29fqARS?=
 =?us-ascii?Q?m7qy3JxaCsMcvQq4cMM6M4zLRpS4I5y6QCLvAAeEMXTdu1EMpBq4y/FH+CP5?=
 =?us-ascii?Q?YIOv8Jdd8IoEGsqBQG5QG/VAAMg3wZCplZr2lUU4lIpxidMU/wJoGV9VpdSB?=
 =?us-ascii?Q?V30j3f5ZiQ4F7KldMwpnArz093tUa0GOZKbh+KVPkVrORzJOrabNJwE6Ti7c?=
 =?us-ascii?Q?pcq2kC90uuHJ6bMUqu1iwIS9FFePEsIfFnz0bRFDMt+PhSTx+3R4fZq24Z9Z?=
 =?us-ascii?Q?XkAISn7uh53q2wyUxjfhL+28GZrPdgb38mFj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:01:40.6295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d19c4b9-633b-4f70-a69b-08dd2c317063
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8721

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++++
 include/linux/psp-sev.h      |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7c15dec55f58..1ad66c3451fb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2469,6 +2469,19 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
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
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..fea20fbe2a8a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -945,6 +945,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+void sev_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -979,6 +980,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline void sev_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1



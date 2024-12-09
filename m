Return-Path: <kvm+bounces-33346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1529EA2C5
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2786B164F95
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8321FD7A6;
	Mon,  9 Dec 2024 23:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0QOYvBpq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D08B1F63F7;
	Mon,  9 Dec 2024 23:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786778; cv=fail; b=Sgoz16A1uCKoMGJPHi/5jYfohfZLOBy5Cpc8bhsBR4Rh0rcdW77E6d9U3adH+LR0P4gGnVPpTs/Kd0Gzwrk88gStKXYsXJeb7vpxZq84cITlgu9lYVB5TVWERGuO/BJof1fkMfi7CPQWzr30ED3wHxgnEE3Zv/Q1XwXClHuaa+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786778; c=relaxed/simple;
	bh=Xj6xU4HvdyCfXcWyrW0YWOysGCKY3b9ga9+q950Toj0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwmJ/TUPHpqeWa99HhM2A35ZOsovBgivQzp7H1IZgBRvUVG/02fifjZ6pd4eAsXFfOj0myHOnG2VKQLWzdNMzTo6cjBDZBrOU7Jg+giMRRMXx4B7Ej3mFPyLrhIRBTfhp16pwDhAbNmAAwgw0mPK+aOIEQkLAHG5CPq7KIQSjkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0QOYvBpq; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vp1oVC2/Nb4pKfODorwwFIpsKYYBFC/vjkuMyklGCED7JAi8OXtID3ZwOGCzVncKX4traXi1S0p7WIPdviQa/gcCGlOcCKGYR+uqm2iYSKD5CAs1S0aqoZpDBAbqIaGBTVp1xRt4E/NF6ew7hrfVLze7P8j8nIkvZJ+Ee/r5Sbn44ZPdGwTTTYQK5pvYGJgj5bChpxtgN/oPSjRgAY557Ti+BTNQzYDaFFXyBORs0g2Zpw8EPfR3ChhsQKpYisQPImhrEdl9dorZPkUiY4yZNoGCkWWafnh/lbUYdxvOrMSqws214LJefUUknGEiLNq+6+eriROclyAf1Ujl/eueFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeClOsYnsfYv/ynEGCv0F2Oaq0h9asa4VflWepZi3h0=;
 b=OrwpAimK0WV1W6/NejM4oFmTZv0vmzvvCqXKCx0sIcuCBOV6hOuLCacKnaEG7RG7ZxRaR7+B0RG+cp3VqkmP49L4PURKNed/7AoI067+1VrVZXxNFSJP7TaSpxsQw8/hvMc7vxDQaeXa5qQDEwtv74FYEycgh7+r3qoz6bc0RyATY5T5B+IRkgVuQnADcAcopPLcuJMxj1XQ54PHej0jx9CHzlAn0di6jQ2itu5QVGBQbLj5jxNH7vuf1Jw6h9dqhgS3QVnyenTw+UTQK65G/q66j4ZD/eqb8t/pYUSMcDSaeYpTM/WnHyajzwghuHWL5Ni1+opzbu2IQHUDTB7PVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeClOsYnsfYv/ynEGCv0F2Oaq0h9asa4VflWepZi3h0=;
 b=0QOYvBpql6yuDI6VgfMEEt74yXD29YPg+zIjUWk17LjGbZPgIB437HiQ3MeQD4ixlqCsC30gt2wtwZEI93I60MNzwcsuJYU86nupKU9JwRqeI5LpAfvg9hVYW2hxQDe/BBwtqrBQTPaAFEzdDN97rTJ5EeaLVI4O/1chP4Z/RS4=
Received: from SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::9)
 by SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 23:26:14 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::2f) by SA1P222CA0121.outlook.office365.com
 (2603:10b6:806:3c5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 23:26:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:26:14 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:26:13 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Mon, 9 Dec 2024 23:26:03 +0000
Message-ID: <7a247f583553ea0b24ff772885570082a42f8c2f.1733785468.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1733785468.git.ashish.kalra@amd.com>
References: <cover.1733785468.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|SA0PR12MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: b93cb5da-fe0a-4225-ed40-08dd18a8dfa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6HxMNmag1V5WKKbaLX+IWlQagMtibN1Td/ohL4n6LP6IYJUPpJ3IOFwOpesM?=
 =?us-ascii?Q?Gw1hCvdgb6qnnqblNC+DBT19X0vIJDN9onLIr0mhbArvF/18J6ba42BoT0MY?=
 =?us-ascii?Q?EUHgespI5+tCtcjKqGqzpV+WVugHy1rn1D7sVQhwLtUX76hOuhkMjf93ZCfC?=
 =?us-ascii?Q?yFWsztU48CEq/UqZj0mgKsHJ442VAgOgie1mhevUlsryKR6Bz5vKXsTku5lh?=
 =?us-ascii?Q?BFf7sC4ua1MtfOQzXyjjGHp8Zl91yMLWBUBJSVdYQsJ4AlDlkJuyd2Bkp90I?=
 =?us-ascii?Q?y6708EYJsrDmqOkFG0y1FFj6YM8KO27z47B4oo1b2cbK0nkS0/ntBy+OyXJC?=
 =?us-ascii?Q?wYTlcnlDYX0QB6s9Li2fEMG4l4pj6u9He4i6sPlY41AFnWBb0hEbZUXstjfW?=
 =?us-ascii?Q?EECr0Gf5/8PnX9bFV7t1L0B0zbiLsDAb4CUSQz74tBwThvgZHQKuUGf3vYtY?=
 =?us-ascii?Q?WyS73kpMJTFXbfxqfNlRtl802DYx2zc2AH6GGfA7j02R7/BXFbOGSaHRjxgT?=
 =?us-ascii?Q?iHCdj6+3RS6FBbgqOK8Ekvvsa9/DsSbjbr0HzePAmxH4a82iRccEyWH7Qnyx?=
 =?us-ascii?Q?zHzdZZ01TfEIL7UT6SbLYmL7gz8ZZZLQSYfwGt/eDgOwOJm8Xs+xmhr3x4e/?=
 =?us-ascii?Q?OZqZUw3c5Ve7ZlfFryaH8p8jbPjqdqM6w1WR1Ra01UR1mBV6DTQSJ9n9BTNo?=
 =?us-ascii?Q?kWI8QrdEkyN3zYMqCRNaKuKY9HZ7kAOTQUkvwZ6YcPhTljsAOUdyYrtqmucn?=
 =?us-ascii?Q?1eBXKWlEC3nH7n6kwp4uthb1WqXqkDUUABz80oIjRwUq0UzK+DeGPoBjzN/4?=
 =?us-ascii?Q?BeOuMlw5dOnvMM+4e4u1IdTSpQLOPrFQt4iRz8jmHMqvk9xB5RbE3AH5oALK?=
 =?us-ascii?Q?luEMiZNphd2rncHz5Ot5i6EyklwoMV7J0Nv3CPWzL+En3Mv0CFxI8IQ69Tt7?=
 =?us-ascii?Q?gd1b22Z+MvDO7Ry2hQLngu9190peLqeyES3l3TjCLFbr1EmXJppLLZjcxntZ?=
 =?us-ascii?Q?7Pw9iOOv+Q+ELI0bJIn3uDb6cRLFqrLwqHPlgaIUYA+xr7uDck0hkBKFyIkY?=
 =?us-ascii?Q?D2PgBdKgIslaBD4vmgk+JNtPa5R3TwWaewomeVFiMn7exEit//v9FepRmXf2?=
 =?us-ascii?Q?RJSSo1l90Gl2Gw6yHjEG+FPSeXGHYCxgH422Zl8j3zbp1SFV9NdqbDH9yvG3?=
 =?us-ascii?Q?go59m09jlQauJ46IsLE/m7B8gBTre08Usx4ewYaN0s0QMRO9fT3Awjb/tcgp?=
 =?us-ascii?Q?xek3xpkDZC58RZ5dFyzRmtvXfEZDOqtOwUx055ISJSTnawpVsmS7Qy/oErna?=
 =?us-ascii?Q?jbuM5W5BU6xnSqq1Rgn8euTrHiq/swXPozHKRBdBdr2nCC47LPpyaHFKKmgb?=
 =?us-ascii?Q?PkHwHQPLaN8tdKDWaeuovpN4eDmxF0L2oNYC9XG5sKWF8Z4iaX36hUZ2vYZx?=
 =?us-ascii?Q?WTM7NCK+fboBiKk2/OKyM03yFm+ffLlBRxJzyppRezJLqf3h3c6yfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:26:14.1331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b93cb5da-fe0a-4225-ed40-08dd18a8dfa3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++++
 include/linux/psp-sev.h      |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 21faf4c4c4ec..b8938c96915b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2468,6 +2468,19 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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



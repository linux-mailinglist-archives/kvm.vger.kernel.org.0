Return-Path: <kvm+bounces-33884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B13909F3E88
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BDC918902CD
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F63B1DC198;
	Mon, 16 Dec 2024 23:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rh2+9Gw/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2074.outbound.protection.outlook.com [40.107.96.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC21D9A48;
	Mon, 16 Dec 2024 23:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393446; cv=fail; b=Lh02DjKSrgdUUPy1VRwesxzj3u3wpgfPZEV23KfIf8T0g8U65tZtvluHzY5btHJ3WmdFHxohkco3lhL/MOE9vP0F2AZsP/9XLqO6+96x+3fohyZH9y8EJaAu7eFmh4oGakIT0cYpUOg3EtRw4ms6H0ln9JFUI3dUpPYciNXcGNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393446; c=relaxed/simple;
	bh=6FdxdC3qNIfl5cXPz6sqwQFZCfSEJDOg8y/TwaTsY/8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=czdgwE+awkPebDqyJy5cADcFPPBYIJwHtDK6BBLrDl0a14AW2EKHJ+sSZ12bIf5DCVZfPeG2fsvJ0dh66ntqUdiXtRBVZTQFcdEY1M5UyNnhzuivCcvcsiGEwg85NojNxH0J2Bzyw1EE7VyV+7QEURnbtKt6TkS2nvv+SagoPfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rh2+9Gw/; arc=fail smtp.client-ip=40.107.96.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xXkiznv6lhzJOwwiol4mK8aF6ok/b6wWF9PUX2g5aRs4nrSZDVTdjGerjH8szq/001AfWVYyAs96+TFVmQRTGtJFEZt8ayg8VMw9p32zbl78YHQ6+xs2zMNjogzoUYPDjxRlo5alJk0F4YOFQwqT77oYllC3tlI0geoxzHsM09lCWL7NHeUpczMrkrgKuuG+z/jy7LZfHNgqgK3PkpRM4LGnj3kIlou+znPhV365/bzN0WxFjF3z+aso95uIqqb5qx+uG0Qm9NC6JSRcyblsFjK8QHJ5d8CuaCCOcnAZ4r5MWOkqkFNb5V+xYWIQlGZhl5BDLpn7RGhE8awLPN9akw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y28cJaSX8GxadSnRF6IQ3KU7BGogRdcwSui/xAVveOs=;
 b=qAh/jnRJhsTSt3W5TAu08PPP6xQZnTTFoXdhyQh3nVFjwlPe4dSKs2sWS0Qlcy8qoe7yE5ejBtcD72KBbHW7pyAZ8TanGb13higWNPAhTJliIX8PeAykvKAtlB9HM8PBkUgfQrhWNa5r9vvGS3etX7JCzkdCyagILS56dGyBkYy4jRi3PSjksg4rnF14mQNhC+UaoE0dqGblxH6MunhkIfMWCY4MLDKk7ZxLd2HNthT/AjpESGUv1J4qV7QuDdZPRoKvac8IXedvIZ0cGMJUD/2Mm2n7QvFVYQ65Mz2XalVVXS9HM/spCluoIXtaqoFzFUML1RppAkpzUZcAs1ciZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y28cJaSX8GxadSnRF6IQ3KU7BGogRdcwSui/xAVveOs=;
 b=Rh2+9Gw/bhcHpwUwudxZpPHXHiG+d7Mfj+l1scMA7VydchuYzGEOgNy0Amwo3301Bu+SGRMcmUUA+aUMDtv6nRODSOQEuEkcXcviYewPxuWyQqlDKw/zKKWWQXg5Mgo9XRXDVLnrd7F6IqwL1blgRVie+njKrm0HvUImiZOp+3Y=
Received: from SJ0PR03CA0181.namprd03.prod.outlook.com (2603:10b6:a03:2ef::6)
 by CY8PR12MB7289.namprd12.prod.outlook.com (2603:10b6:930:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 23:57:21 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::23) by SJ0PR03CA0181.outlook.office365.com
 (2603:10b6:a03:2ef::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.16 via Frontend Transport; Mon,
 16 Dec 2024 23:57:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:57:21 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:57:19 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 1/9] crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
Date: Mon, 16 Dec 2024 23:57:08 +0000
Message-ID: <ddbf0b28d3c7127e0489ce7ec817b9b4f0c9d476.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|CY8PR12MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: d775de56-7d24-465f-4243-08dd1e2d617c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JUNYI1YOtuqZkx+GRUMtw+OrxjMNwjPq1OMNTmNsfnMACu7j7pI8/PUq9T7P?=
 =?us-ascii?Q?dmzUoYhqzs0waDLj3GO4Skk/AEQnNYlovnfIDwXId7QoIyP7aLTQk4Ss+T3Z?=
 =?us-ascii?Q?1z/nfweMQvZr2cfryeLjN1etvmpA5fh5qBSmndZdTh6O6mCCgI/VwU65R78O?=
 =?us-ascii?Q?lere2l8tvQY0gdp4smTsw3BvMTSjij/x+6G0O8UmotYqzo5FkzRV46U299uL?=
 =?us-ascii?Q?bWzyvCuT12GHA6AQiYOD90MUqHlH1Yaop1b4d9slBPnm+QdIUp6EraV8zFeu?=
 =?us-ascii?Q?0QN34MQODHaC3ogv15NpL1LHNe1tSCznGRUXjNmSf3IYpRPbsOV/r6Yofu5R?=
 =?us-ascii?Q?QP6bx/V5h9ShXx2/RxjIfDeCt4R1QBK2wEDU6xxQB4B5c7E72ZVaDzintYeO?=
 =?us-ascii?Q?lt4LNb0a+gRoJHeORe4SxjRO6czQRdIB4dDPvP03TKosrbXcPKYv1LY3FYx7?=
 =?us-ascii?Q?GWGk9JpdVz95VcAgFaTIV9DSLUFY1bXH46sfORGdHCh2JKnKcAI8rbb6yyGh?=
 =?us-ascii?Q?rpF53f3gYJk4Gg/ambkjwdz4ZVGlxf0yjl82Qb9r1maXUE0jaYntx2lewzJe?=
 =?us-ascii?Q?FmQIVgCUG0uzqUAVprrU5JJFPoCxc5lulXJUappi/3nDxPY5p9w3XXblGgfr?=
 =?us-ascii?Q?8j3LJTa3UUWTOETT0JbbyKP3WAEVWMo44mQl0AY8cTgG7wJlwsBJ9v+zxens?=
 =?us-ascii?Q?5/mVJNouxQepHjcY0nD54PlJNJftxyle82QpYWFlWulEOB5jUgQBNROMFEDE?=
 =?us-ascii?Q?/3kCVhz93DBZsb+/QrzRxOJOlRie8KXuOuP6HeZfAEar3TbEdmiZLBlOMF0M?=
 =?us-ascii?Q?gGK/UcFt3sY+CDKuzg2bqO3y9shKYDtooOjOC3sTHoZDAm+5vFbmYJ/sWsHL?=
 =?us-ascii?Q?HWuTiCS7SrgxAu2yO3gqoDLzGLaKNCx4+OUzWMA0QThD8TkCy5Omy//ENPn0?=
 =?us-ascii?Q?HL4jy8cVWpb8ZT/R+8t6miAYdOa+E9aCHfBew2bN8/Ag4oT+c1sq2UuXwF7U?=
 =?us-ascii?Q?hOkG2etSVk9aVBgBX3zu6nwRhAqAwSn/5C+n/LBvsrPMVJ83VS7jBGKYigYa?=
 =?us-ascii?Q?wBE6iAONF4iyjW+nbiuEIEdvAAbM3Z4jwzObLMDsaBlw+4xXIKHUl9QbiuMQ?=
 =?us-ascii?Q?W04FhX7oFvy8RKBilEkivu2X2anISN+56+orH2IVjsnbFxd9y2GWUJm0xa0L?=
 =?us-ascii?Q?sXTYCBYmQointsXRLgnnwpOUbpTB60oD1H77Ero7mAs8qxFTmuwSi6b6QmQU?=
 =?us-ascii?Q?6JjGbCy5PJEQ6Urty5pjI/ipb4GXL7kQz99yVGoeIl0v1wLH2WRgc2JstfKp?=
 =?us-ascii?Q?AHd66HW/PX2n6oTFgF5bYB9Yq+dhjnqVeQRquxhsedg88trur8R9VTegLrdZ?=
 =?us-ascii?Q?y+kW77dBynEGMtCluW/9gTA6Nj8TvHSUPEQO2hju+k22CwRZCu/w3xuc+wE2?=
 =?us-ascii?Q?MctSUMzBnDFGueTY4MSUXtntZLGE1tBubBMX3HRb41OJ8cdXsPLlCiAUWw2/?=
 =?us-ascii?Q?Pz5idnvZ6OWoKImmyyA9zcuBsnm0eE1GcEvz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:57:21.2810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d775de56-7d24-465f-4243-08dd1e2d617c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7289

From: Ashish Kalra <ashish.kalra@amd.com>

Remove dev_info and dev_err messages related to SEV/SNP initialization
from callers and instead move those inside __sev_platform_init_locked()
and __sev_snp_init_locked().

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked() and __sev_snp_init_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7..1c1c33d3ed9a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1177,19 +1177,27 @@ static int __sev_snp_init_locked(int *error)
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	return 0;
+
+err:
+	dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
+		rc, *error);
 	return rc;
 }
 
@@ -1268,7 +1276,7 @@ static int __sev_platform_init_locked(int *error)
 
 	rc = __sev_platform_init_handle_init_ex_path(sev);
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
@@ -1288,7 +1296,7 @@ static int __sev_platform_init_locked(int *error)
 		*error = psp_ret;
 
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->state = SEV_STATE_INIT;
 
@@ -1296,7 +1304,7 @@ static int __sev_platform_init_locked(int *error)
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1304,6 +1312,11 @@ static int __sev_platform_init_locked(int *error)
 		 sev->api_minor, sev->build);
 
 	return 0;
+
+err:
+	dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+		psp_ret, rc);
+	return rc;
 }
 
 static int _sev_platform_init_locked(struct sev_platform_init_args *args)
-- 
2.34.1



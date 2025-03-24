Return-Path: <kvm+bounces-41867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6D6A6E586
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 430DA188EF56
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6371EDA04;
	Mon, 24 Mar 2025 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QiaVOXIK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6097019007F;
	Mon, 24 Mar 2025 21:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850964; cv=fail; b=Q63JcSgXzSJeY2A7boxalsqXMoMR08t3UPgwzfNbByPeGmUiMppgsU3rAsH0KM/+cpCjpbPmrmlTvi137Snh6eV7LlfhCNFa8KB/FO2ABFEqfQkK1flU+sgVj7aNx9kuG9n/mpXHhBzngUoTY8gQZK9aDFB9LvMJ902XRdFQsmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850964; c=relaxed/simple;
	bh=LTlAm50khwx7MyGHDUe/J9IemorC42ny7oeVhuaTFEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPbblEorc9iWZ9YifniTVSmTlVXs3mLF+/+nAv7bTamNMxcUMQQFuGS6qnx0FTIVXSckm2AE5PFlDOyFVQE1tkdxb1j0ygNuqUZq+qm/UdOh6x9n4Rgys3Zn6inyKXae4LTReoF+JKROMyjliPPvi2PlwMsm+ddqtvuR1GSn2bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QiaVOXIK; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNCoW3Kf4crN6r0FTxWPwsim96ZVewc1HTh1Ej6SjtUHHMyczVF9frHx2j/2k/82STcdPgxOeCqwF8PsfHYO4X9c97rYfmQUzOmE0/Ip+Z4nOAmBcXKg1hP978C4BO+ALAiMO01xUWq5KhpnfqICD2xBrLdXokrOCLSzdecGKcee0XSxjfsAeZLbZX5pMJGqKpvlz64v67OceH/tlQICNsA9208HyMXTpRHroYAZva1c+shfqZoq/PmNqw+SpS6/LAvgJ7cNzByQLpZYmBl6imt3Y8u80ctkn102l6DxNGS+3+QcWxJdR4QeoAz5e8ll0mbzAZNUbAFjf0k0DSF2sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cNuKj6mGvdKVap2fHNknx2ahhzqXtraUwGyw/xoIZ4=;
 b=Bpp9tEi5ol8bbhZrNpFLRQCjmZO93tRtuZKy/LcxsMw+tT0nWK8ETIUQOB8+zGMNJqAzsuH4jKU9tejx/S9mEmjo3iqnKGCZwSz/RTQgnj3R2GB5YgV+xfsrKAz0ltSQx2hfHhAElb91sUVQMGeDwinnke3rb5AkbSOUZgWN+MSzlWCq9Bd8Txwyusx9S4IbaFwve/KctcCUe0VmEkieuBZSSDlh99wjeFVEekHyHNSRUrpN1UliuMw7nl/78bRoIyb3eouXa7DMAAjB6ZxcCFYkhqDEk38wc1OCD/Vy2FYMH2qdz3W5+0RccJEkAwUwp/ZK4tWNHMcS13M2li4ipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cNuKj6mGvdKVap2fHNknx2ahhzqXtraUwGyw/xoIZ4=;
 b=QiaVOXIKEdpcJtJTVCjIp/kb/ltUKFU2i36T38wIkJOK9BGdMGmNu0zDBhc1WakxnCby0qjh3CCR7308PCUqWWVFmk5enmZeLQKD3MfslerOCQwe2WPO4YmCgsSTKJpFuJ6q/CHNzYYB1Rprwrot7IVKJGGIku7b6QGHuAAs5IU=
Received: from SJ0PR05CA0133.namprd05.prod.outlook.com (2603:10b6:a03:33d::18)
 by SN7PR12MB8436.namprd12.prod.outlook.com (2603:10b6:806:2e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:15:58 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::73) by SJ0PR05CA0133.outlook.office365.com
 (2603:10b6:a03:33d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:15:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:15:58 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:15:56 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 8/8] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Mon, 24 Mar 2025 21:15:47 +0000
Message-ID: <1602f82feadaa127c0e4d626c55c93c29b3a022d.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|SN7PR12MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: c25f39d4-16c2-4490-bf65-08dd6b1912ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jwHV0ALn7etJiukZ+byXcH1G7tPBwN/Ez0q82Mge2+ydexMqt7Ig3DkEu3Ul?=
 =?us-ascii?Q?4DQVEakBCUVwmUNT1Bm7BD6a0mYDz95hpbe0DYVznz2aB5ZyPclWO4FQmUWb?=
 =?us-ascii?Q?Bi3zAi4e7M053QASMekfv5hrLmoHxHGbOpqL0pwX+ckIFGsKXkLhdsbMQQQA?=
 =?us-ascii?Q?x6ecMMx370QJjkhf0W0zl+kKNINdMyTqruyM9oPD7bF1XRQoGYq1oNT/54Mk?=
 =?us-ascii?Q?n8Mq+WrocfwW2xb7a5GILHaTF9UdwFMuWeQDxiTVBSO/7u63CnxSax9SRblB?=
 =?us-ascii?Q?XtVe1UdV6kaigtxYRzkvAfLKWRjp7VO0KK4LS6fVzWjcYzALCVX91fQn7IQW?=
 =?us-ascii?Q?XIBIsdbsdVQw8gOHZ/N3+Jl7s+cUG2LqTNiXBapeNlXQGo/K63v6wA3XQdC2?=
 =?us-ascii?Q?/06G4517owqXixHzyJQGU+nWqlrmqSUrhi8QPA36XeyuDIGGxq08cdQjVzsQ?=
 =?us-ascii?Q?9ZMhsaDkqF0+bTAWetwwo2z8koe4D7hjOiDAuZJuOZ5cZsZPn4HIWmppoewy?=
 =?us-ascii?Q?1aZdC2Fgr3U6lZqn9F+NOVcHzxohL1JQVZ5jPP38h0NvlBud4X4QAuHMh1KN?=
 =?us-ascii?Q?ljAEr6W6+Y9TJsoZoXUoavOT1r2xcYQO+4rcXESBY4p3FegdK+2oUHsvBGOn?=
 =?us-ascii?Q?YIdFDD8+/clvdSRsUfJyTVsxe3gTT6vAvRMut/ltUkAQrj58cUGy7kf7QJTh?=
 =?us-ascii?Q?vRS+k61Sa2SIfZ+DQx24YHg60EBDb5+CePtaKQp4Nl5bhmRUJaz+dpUF5ld6?=
 =?us-ascii?Q?7tZ8QTjXpHcSApc6h5ZqDjAI8KNqr8WpZkh2d8mwo3A4iEZ9BHMqJyQbPlD6?=
 =?us-ascii?Q?n9YJOw7mrp0pL2Ym4ghoiK0+HlzYYw0MjiovdCOMEsJ8Y3p8JjYbwbKeL3nX?=
 =?us-ascii?Q?xGNWk6mMRRDBGvCI9I1z80Zbxzk+4+sAPpG0lXZT0OwziOu2I/W/IckAKvPs?=
 =?us-ascii?Q?/KTkdOaEht0bZ61XeL9K4Jm8QJjhOUhGTSh6AJENo0MNO6v0wDy2zHatQ5EV?=
 =?us-ascii?Q?P7OgcWYBSbyVLWf6zN9SYJy+fGx8Y91gakukRrXizR60bHeYvdM4idIx7VBa?=
 =?us-ascii?Q?yaamDwX0ompESMAeAJiwaQvV5My9tvG8tw2NfWuAsY3REM90+NTx4POfb4+V?=
 =?us-ascii?Q?1poFAeBBop9E4ezbtCJZA6w7/Ee5AqPrQ2jXmJg1rrFTC5yRV8lxLlEsJbVb?=
 =?us-ascii?Q?2A9lQQaJi0+u/foE8iYbEmWeQvc5dAWEl3wHX9DTLnbJWGW5coIG/+Td288A?=
 =?us-ascii?Q?2W/PCKGVvW1xR0GAXEUORZJzR4R6TOImCBHSKfI7R7RFNp1mD/OwPDRFpzI2?=
 =?us-ascii?Q?ShTBQ5xsGDBZWWGlwo5h1/fb1PicYUNMuWKfNXR46wOF2+nCSCVxwkWQjOT7?=
 =?us-ascii?Q?dkiuPKezrSHOeYbXVUTFmUCgIxJDiOEb7IA+uuK5dtGhj3mcbHvbsjUVkvaI?=
 =?us-ascii?Q?fredew0ut5Wzo/BJ+yNqtjNPhU51Jutrq+Iv76hSVcaAD0Ssd0MGG/Jhee8R?=
 =?us-ascii?Q?+4+zkl1lQXNmbAZJYD0PesekVc7kXKjj9OpH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:15:58.6868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25f39d4-16c2-4490-bf65-08dd6b1912ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8436

From: Ashish Kalra <ashish.kalra@amd.com>

SNP initialization is forced during PSP driver probe purely because SNP
can't be initialized if VMs are running.  But the only in-tree user of
SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
Forcing SEV/SNP initialization because a hypervisor could be running
legacy non-confidential VMs make no sense.

This patch removes SEV/SNP initialization from the PSP driver probe
time and moves the requirement to initialize SEV/SNP functionality
to KVM if it wants to use SEV/SNP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 671347702ae7..980b3d296dc6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1347,10 +1347,6 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV)
 		return rc;
@@ -2524,9 +2520,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2549,13 +2543,6 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
-	/* Initialize the platform */
-	args.probe = true;
-	rc = sev_platform_init(&args);
-	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			args.error, rc);
-
 	return;
 
 err:
-- 
2.34.1



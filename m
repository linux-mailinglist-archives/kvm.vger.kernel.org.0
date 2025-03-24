Return-Path: <kvm+bounces-41863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17495A6E56E
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272BA1894E83
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8831DB548;
	Mon, 24 Mar 2025 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cVz1iDUG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E788C1E835C;
	Mon, 24 Mar 2025 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850903; cv=fail; b=iEVDnHqI6DK/m0c3kNoiytlfzPVU79r6NLRBPTliMFZZIc1E5fgjFWkWT5JMq0TuF3dS16edHCWE+kAOwVmKWHWnIzIseVCGBERdXxXMQq745s8LFtsrIdFpagTsRyIXttecTHVbDSboXlD+/V3+E/2Mq5fWYVZ37dXmay7QlSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850903; c=relaxed/simple;
	bh=h0idtQKPZLSPA9p3DBpWA8DE+QhQcqieyJQqq0ysLes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqu1Gw/eEeWOxlDn6FQoVEQqM2cryyHz6KkfVPA4fdTYCTM8ZdKDW4DQ9MFr/g+2KkRrRf82iQXH3EQJD6DQK49euQRfN0X5MXB5HvPzkF5owz/l+GWWgXpoZg+N0ugVDw4PB6/1hUKhw915bjW+rtT1WDsSLrti4ruiJP22KkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cVz1iDUG; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKG7kpl4Ch1mVMoqLDUXGsRtjuF5V9Oh0ukb5oaBe+AjNrvccF0Hj/PEtclD15nSF+lAOA6pNh6qa/8/XnoGneW+evR5hTxxDDn2ZBn+bhkLFsUjbPS/JJgzpsVjbjQNfHQO5+uEXoUbB2ipdt21+0htg6tNwPUQb82BXSZnjFoaM+RH1DPs/3nj2mZ72pi6EvwDF+P20UeRfMCO0LAP/drzv3KLHbNxy/yFpB/wGZVZ83UeWTs2vL3CnVAiLhstf5QG6RQPPJlYzI0cHhMu/dFpuIDENRrlICWfIpsGbp3nR/+TzNf8I16S85dIRqoXgRUkc57uzfJHCYmhVYUxYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9S5ixd8ovR+GatCwKB4CaC0KmwPJsHXJagfAeboRX8=;
 b=QfiXv9AnBEV0gQjWIZdBizzWv2Kd9VMJnleK05/zDvBbeOYJdhv6rr0oSdEn48kgfviPFkTwJ7sTfaIxoVDXveyGPQKXrcp52vrNNSrz5VqjypA+dRe1tvQuQAVH21mfaL7dqslaxkb8lLV+rK9abzb+qF+6LPzY/JovWnC+DUJle8Ieg/rdMxkDcqaIAk/vnuKyZGlkXyFism9sX2mCdSSorHNdVoRvlxs6OxiRfx2Tl5VQbrts01dH5b7TQUnPY/S5dLCoj5ESC6rX0nseggprElOMQj3QhdBHinwM6BCoyydRty4cdSpmR2saIaz/h9bX8L/27mfGMpNbmfHYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9S5ixd8ovR+GatCwKB4CaC0KmwPJsHXJagfAeboRX8=;
 b=cVz1iDUGmUuyZX+yMXM/891R3j9GNhoj969uu9t/oDotxoBWm7JHzrCK5vCSbpe6n/HHOuJ2guvPUDfcIjF2WQpR1u9LSz6FdyGvZADeklDmwQa5Fe5C14lcqIOni1oPTLMihMyyl+6MhSFGl3hhjt9oD1T89CKJseQ8dTmGBuE=
Received: from SJ0PR05CA0128.namprd05.prod.outlook.com (2603:10b6:a03:33d::13)
 by LV8PR12MB9135.namprd12.prod.outlook.com (2603:10b6:408:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:14:59 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::3d) by SJ0PR05CA0128.outlook.office365.com
 (2603:10b6:a03:33d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:14:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:14:58 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:14:56 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 4/8] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Mon, 24 Mar 2025 21:14:47 +0000
Message-ID: <4d424fb89a6a972587694caae356623618e57e52.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|LV8PR12MB9135:EE_
X-MS-Office365-Filtering-Correlation-Id: aacc53b8-703c-4206-da6e-08dd6b18eeaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Yhmq+CEJf2KQQu9OAO/HZIPbM7IFwG83UVOsY7Z4CjUrX6kCfjselGsIgwf?=
 =?us-ascii?Q?wQiMJjqG78fqGHjlbVIXMkT4ozVxTaybyRr9MghrmNZnu3yTH+uZDgueyYKo?=
 =?us-ascii?Q?KIY/mBjMuIR39N8UbqYznyapdzxJL3kAdsmAL5262xhMY51CaUCR6t3Fothj?=
 =?us-ascii?Q?sfi1wZM8sI6BL4ZdOgr9zzNmu9Hm1NNj8ZyMKibAln0PIqLTKZ1REjsYcAzf?=
 =?us-ascii?Q?YaBEXqp0DNweA8N2Gci+qC9K3s+9ghZZMTeXtIzxqZHd4t5qTS0p8e9bdOXv?=
 =?us-ascii?Q?R8nOJGC3jkged7WIGFa0kef3M0kGAfVc1A0lXzaldkQzN0M7BscdINnR+QsO?=
 =?us-ascii?Q?PWzE2r4Ix3nJO6zFhocnrJy7/dAsiAxLHZAb30iAPD92kRSvmNEJ/rSVuD7r?=
 =?us-ascii?Q?aH5MJwLVMlbhVwddljsO0MkVWnEx5VquP1gDpPZNc0esKc9LQrcIi7q+ClVW?=
 =?us-ascii?Q?UEy3aBy87jOt62j7MAxg4FKN8WFq5G+kgYHEqrJPooJzxVRFHbS8Uxnq/LvX?=
 =?us-ascii?Q?kb0sKGUqdo4q2+B1W81AZWDW01lU66XtqfGZTY7d4eRSKLtaTEbo6S6hwowP?=
 =?us-ascii?Q?gXVeBTKzGjtmISZuUlSXQn6+CWudpGMl18gAs1v3cx5iRA0hftppZufdkM5h?=
 =?us-ascii?Q?/BvTZBdP64Bm700xQrhMzylWabXJ5E1br+7rRzTtuC8Ev9ADI27pLj129bp5?=
 =?us-ascii?Q?SBoQpm3DvY3vMElXm3XRYJwN4eMrrdm5xWuBPsM04K1OCNXVeRggKEZEjcfY?=
 =?us-ascii?Q?C9uwJ0bGrpI6eEUEid7AIMmIPiMhyVKNcuMRUYjMNWF16NLmWuiXUQP6ze48?=
 =?us-ascii?Q?B9ndv+/CIVfRLUgWODJUsg4sNAeALZjlFWCORTnwpTHlus3ESOwIhf/iJxSz?=
 =?us-ascii?Q?A0lla/ShCWoEHSUvUeEcuNGRILYyl9ADmnBqJfmwDOzYfqkkFQUE5B1a+KH0?=
 =?us-ascii?Q?l8goL25CQdvE/SgvU/UT9oMtPpAl0yA19QVxgW4vxgSsimVuIlfgZJXm5Z3p?=
 =?us-ascii?Q?ncD2z75/4kQ5LCc5nOOvSaLixxEh5vhniiorH7eU3VTl+HUSlGHD8WI0uV8n?=
 =?us-ascii?Q?mUDe0qT+jK3hYtUTsQjbHIdvbWeLYcPgy95uB2eK64kQ7ACzjUnxnZe2mTib?=
 =?us-ascii?Q?OWYcoeAJiA0Vk/tvThmUm6qX09tXnNkHMisSuq1C8FPOmCBB2EIbTRJvIFKw?=
 =?us-ascii?Q?svjHy0vXfcKySFwNaUrhv6TmBikMd8RysoXxvbEkL7a3+rEnHxhu6K4RwNYd?=
 =?us-ascii?Q?rIdlAnSX0XRNjyhLnqVM244SfEpO5ivmi5W82OauYShCn1GL3MUo8pysA2rm?=
 =?us-ascii?Q?OdyIa7EFnmvjeiPzSl1S0AAI81KcajKtn9CzhbDuXG3/TLGmILoEdQGSNA6C?=
 =?us-ascii?Q?jtadfJ2zAYFl4sOw7hQ11pXNkwc4wUFAh5N5UGkd3TWD9pfcuPcn7qYb66er?=
 =?us-ascii?Q?BsmvhtjdsmZyrKwTnK/Ku2+Bw80U6PdkRnjZ1bYXnllPtrwD+FTGm/XjVBQ7?=
 =?us-ascii?Q?AvnMDhZtutvAYMindpdJs4iSbfJGhzlR/kKm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:14:58.2805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aacc53b8-703c-4206-da6e-08dd6b18eeaf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9135

From: Ashish Kalra <ashish.kalra@amd.com>

Implicit SNP initialization as part of some SNP ioctls modify TMR size
to be SNP compliant which followed by SNP shutdown will leave the
TMR size modified and then subsequently cause SEV only initialization
to fail, hence, reset TMR size to default at SNP Shutdown.

Acked-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5bd3df377370..08a6160f0072 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1778,6 +1778,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1



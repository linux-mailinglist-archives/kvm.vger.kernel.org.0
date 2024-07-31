Return-Path: <kvm+bounces-22778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA71B9432C5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0444B1C203BB
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500081BE24D;
	Wed, 31 Jul 2024 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dkh26gng"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C861CABF;
	Wed, 31 Jul 2024 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438537; cv=fail; b=jQRlsk2xyk8ewIwPUNxjAc7m0aNVlJG2zy97NRXgwjIeZUF7NNT3dPBde6rOgQGvAaYrjF0sFOR4db/Q8DvJ/jf/wkMHxZ3COcD+BHSDkcsSUYkjL4C8zBU1RSuts+StaeH2cYKvcLiZjJPQjoSuHwK9kldvsOjho2WZq8MN+cI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438537; c=relaxed/simple;
	bh=1zJ34qRNdt4eq8G7OUYU9BUQ/QIAq0ZnCelY3alVorI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQL6DyUFEjUYrEHeyplP02QRN9hpoJMT9aRHH8tdahvf9q1/MGoMm1mbVuXXHTxnOWa7VLpv7hEAL5htsd+jyY/2m5h+PD4k8/CrBbgQ4Qd5dIfyVRmZmbNVI23C/7WqPDMswGFYfvLC++t4zku3shuzjOYhTD7nKLO88q+x6ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dkh26gng; arc=fail smtp.client-ip=40.107.100.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnVrsvUQkBvyoCRMnMEOSu678rS9JeC2irkqPbEyVdyVe2JuQt1hNHWzBReKuIYXm4L0cUcF6rnDcDhQmp5ERHtK2C6Oe0BL9fxlt0DN76CmwpkPild0BCxos9SoLAvv3kOnDMjGgU6L8T7aeUoiu5CdE8vrM0bZbASJTGRDx2ymLQr5yiRwcR7umrCnA0Ws3i11vNo03DF9igObO8y2MqHtTJf1FEaefRb3ENuNFEVu+LMS2C3k8S5HtkwiRIMZXJDAiGrJvc8diqDzbUr2yKk0xfvHb+ui2rmo3N/UEKeVBkkmYLWuLEwvjb0dqQQDrwIXedZsUR7euxi+2i3trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBZbd+6vfgzmsCuDkCZy6V+wB1Yn4gE3mvKYArsqRyc=;
 b=B3Cd7d+QNHYWvoLophfBS+YqaIaSPggEv48K3ljYR+2MQ06eAJS+Dfxvko1td42B5B8y8qv8hs8q0L1nNT+FPmSqoIdEVP4+pTfOmkMeAiU9/OylsZoTfRQpvLJPEHoOzJI6B5K/HA88qXpiOB0QNea2XeB0FJwLlItvW/Tjq8SV/5KwlXzn3JBvTVIFxLh85o16fhFf0QVyH3vqVwday3c+mcsJNFAeWvUl9R9K+6GYCQSWEFiRAWDFcZiSkx5hDLVeT4glQH995KvymWOk7VvIekhmKONMW/G9+CM8bbQr9rkInDfQgGPzZXO+0TdTqvBapg5fqiWC/YMScYNFNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBZbd+6vfgzmsCuDkCZy6V+wB1Yn4gE3mvKYArsqRyc=;
 b=Dkh26gng5Uv8dabUJts4Y9i+yqs63j1SjDY5u50QILwSCYtwBgGrM8XXecgnwOJx++6Tm+U85G4KF0A3DuW2xuhMkZ1tKbVa/15rHDEOnK3G7yggmF7SsyumLB2F4qHKclzcmrEFICxuuEBbmfQ4XskEZmFR+twcIzcRoBdsezs=
Received: from DM6PR07CA0057.namprd07.prod.outlook.com (2603:10b6:5:74::34) by
 SA1PR12MB7102.namprd12.prod.outlook.com (2603:10b6:806:29f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.24; Wed, 31 Jul
 2024 15:08:52 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:74:cafe::51) by DM6PR07CA0057.outlook.office365.com
 (2603:10b6:5:74::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:52 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:47 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
Date: Wed, 31 Jul 2024 20:37:57 +0530
Message-ID: <20240731150811.156771-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|SA1PR12MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 180ca082-30c5-4d50-d250-08dcb172b06a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JQFurnZzs/BPi3h4PKawHpW8WhjBWkhJKN8nRPTKt9h9c+rgOjqlz7pOZYUT?=
 =?us-ascii?Q?4ewslVlofTbOruYrWQBNa/vQFm8q2si3j16HfF2PN3abFyZw021zD1JAY+kz?=
 =?us-ascii?Q?7mE5/fYYdazHXTjEawGW4beUpxNQX0aB/FakJfzBvPtVBTTiIEmqUW9XiBPM?=
 =?us-ascii?Q?xomZMQu4fsr6KySAuVn2uQZQf/DiKnHcbItjZJMf7oiy2LBazqIX53NlAvC1?=
 =?us-ascii?Q?pYnJQxT7EYrluroJln/P8jHA/oKrkwGj1eWn4qwwOr7bMfEpcrKLG1fMgluH?=
 =?us-ascii?Q?+ot9iEnRVj78ZJtJOzRdY/DmbWotvbcDJgjLPyijjSUM1IGZL5EeRnIS5de6?=
 =?us-ascii?Q?3SxJ0qmVRdvh+UZi6VWG3ajcRzcA/TY+GlMuwRJW2VGlTXPQUbi+uuE0G+5w?=
 =?us-ascii?Q?sXakzMzxOqQbdFUIdojXrl1GDCw9wxNJPQYVPJdycUROYMBJk0BvXZ0HhfUf?=
 =?us-ascii?Q?LBRMkLoUmC+NsLiVqSktiIKw67+Sz2DMcg888eAUxshXv9UjHftiMQ43wse2?=
 =?us-ascii?Q?DQCXMt5x2Ba33kZwcF3vDcnhN9ppR+S+Z3l3BnexWyZ9fBoxr1ZNB7e6Qrmb?=
 =?us-ascii?Q?dRPOdBdskElPDNEWMZiIQvqeiDCsWzPg0CiP3PEdl8pEca0TZnSis3h49O/d?=
 =?us-ascii?Q?2vnrf4yVXjo7tI6lAIjVLKalRJBV3weeDqKugHqFhmrrW37aflqkwa1s/W3i?=
 =?us-ascii?Q?bTEWx1P1MaqqIapKfBYMj5ghVZNXOKbi3s3lhds3Q0G5PUJGDdLt12DE6FKw?=
 =?us-ascii?Q?bm7U6Fahh5tmZ5GqgvwS4vN2E0BYGXj5HyX9zvLRiLyiT7x9pjqCCmCr5lhv?=
 =?us-ascii?Q?wiSxoqGsqojDTq+LQ12PuvKQ8H7ofGsEoMtSDFZp5CyBR2ZcmSfphG8t/SE8?=
 =?us-ascii?Q?m/LWMWjdJnNlyO5j9CHHNdIB8nuSeycWMeZQPOYCFd6NDoAIe7AojPsMGeo6?=
 =?us-ascii?Q?xw01F5DlXb+U8NLlXGZR3shoiX9PTjWhvM/4oMFWOuO8GhIRIcW34duOJFYr?=
 =?us-ascii?Q?Kj1XHkVUsF5TSrHQFj9JB6KJJ44TFNbNTaVneaPpIcMkW5AAeHULNyqPr/PL?=
 =?us-ascii?Q?3QKTMZWt31hkj6A+ZBYZZqujN1lSNGUrNwTdXOzrrzrTPnHpYNdjuFNjqhud?=
 =?us-ascii?Q?3GlbI9CtHHaVDnycpt/Sq3BJS1kLAcR/ey0rvGdSDT45ufQzV4/ekJ7ok7Dy?=
 =?us-ascii?Q?XGWXovzV/3tElQdGHTvFW6PpoMne6XZcOCWCuTeH09zbMGoLclVR+7yJJJBM?=
 =?us-ascii?Q?6+lK8hddSNB5zAcL3n7nrFXtPqDlOiyLawZXX9BpVQkcImTYyzUoh0+cSyoc?=
 =?us-ascii?Q?W1jQ44FrKWn5NE0NCIgqExO9QiKO+9umcqmBgGU1pyg/l7RZ8Cn6VTptD7M0?=
 =?us-ascii?Q?GD2J/hUiNdnCN/yZ+XVwDYZRe9TK5M3Wzo54gJDzjYOYrqz3QHadqpmK3obz?=
 =?us-ascii?Q?iubGN08zK3dloboGXeATxefg/4m8imZ5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:52.2852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 180ca082-30c5-4d50-d250-08dcb172b06a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7102

Address the ignored failures from snp_init() in sme_enable(). Add error
handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
blob or encounters issues while parsing the CC blob. This change ensures
that SNP guests will error out early, preventing delayed error reporting or
undefined behavior.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/mm/mem_encrypt_identity.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index ac33b2263a43..e83b363c5e68 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -535,6 +535,13 @@ void __head sme_enable(struct boot_params *bp)
 	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
 		snp_abort();
 
+	/*
+	 * The SEV-SNP CC blob should be present and parsing CC blob should
+	 * succeed when SEV-SNP is enabled.
+	 */
+	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
+		snp_abort();
+
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
 		if (!(bp->hdr.xloadflags & XLF_MEM_ENCRYPTION))
-- 
2.34.1



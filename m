Return-Path: <kvm+bounces-20260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8F29125C5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B5DE280CC9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21BB16E860;
	Fri, 21 Jun 2024 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VEfNt6xW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C16D16A935;
	Fri, 21 Jun 2024 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973621; cv=fail; b=l3J/NbiXb9fczNheSDHmyVQhwKTg9GK/Il8eU6D4k/y5Gy41ak61LU+3Q64ph0EQZnzY1gDmrCdvtrn720//jwa3LXwP3/Fi28/FlfmtOQz2l11MlZsaBExsYgHqUyIb2DZIW6MPu/IFAJ5Y/uqhwntjvqzAW2Iif031GHPW4Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973621; c=relaxed/simple;
	bh=5qSYz184dG55AgMt1KcS/YHhgJrEhgfTvgTTCjahzBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcnqHlzc1Uq5Ei444yH8j86+Thyz+jMEBhdX09chsKm8lg7SwvKVZj9955kACg/xSFD7M0GPewf3HqlRp5Hx2SrIPnTvkImGseBW5xIUrkae9EdTHu9+kTMQgH5gk8/lc4my0uNa0lwEI6pG5ZA182Po0WyHC2pYOr5TTSjWjQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VEfNt6xW; arc=fail smtp.client-ip=40.107.96.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdPUzQahDpcPddO636tIKV7/BLNMcplVQ/4CkgPOQwaqrwadYAw9LEw6qIXQGXFQ8SDsWiBQqjnq7GLN0Acwhb3ncZG+otaXUkPpKokAHJM+Jrk5WuVQzzTNCaTDPSEky1YxWm1ndwJ5mHveR+PUbyuNa16DoQGtg6xls0VQzB5/zQ0avd6dTjchf++KgaXEjF4owZqcvZoweVU9fOja89B92lqDVOeHdyst1p/fBZStOfqTz84r+tMhWJktB94+yTFDpyWCU3VUvxfhGXWzycfyeakcQoWRNthsTUUtK/QiKm2ofkpPA5XC4WZH9C2BGuZei9ASNvLPD+MVmKzc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcHu6ihXJZRoVgQf2gK8G/BljboPy4aUZTH6uo1HfZM=;
 b=invZeENaF8dpL9EFeH6ZAPWmuUXr4nlO7EvchGQXKHajvDyBIV/JCjRQUrq/cXnG3hAQj/aa/7OwcUTz99bcgrPhP5offb7mIhXS7WaNIfMt0D9d8lwUlEHgtpl9521QXNRtqIXYCtRNgVbRR3Eu8w0chqUlxkLert+Cy5MfuvwqCoyXmJBcWmzRImsbgezEZ1znzLDMayhFlkSD894ueLfAgq4/llLLZHp+LGU8b6ykAYq/GhVHiBj24EpB1QZoclrXC7/tK70wLEHTzK2yyTTYiFhS+NDUEBbNe8CSuZ10Qj3D2SF153dEXbFC8D0PVY7052xfAYJ6Nr+ffKUz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcHu6ihXJZRoVgQf2gK8G/BljboPy4aUZTH6uo1HfZM=;
 b=VEfNt6xWyY0FfGLdnuPAd7Bx0Pkx0phG6x/kGSWhN4o5Kcprs96658ydKfJnOfLc0K4pfIqu/oBSqz0N5MViHmTJ/iNJOdD5k/ee6BjcZUGXa7XYd4fnHqHBcasjyTPPuipo9cVgNaEhrPSIAT2ivYqUnHGtXMwc9Vgs153CzyY=
Received: from DS7PR03CA0247.namprd03.prod.outlook.com (2603:10b6:5:3b3::12)
 by SN7PR12MB7023.namprd12.prod.outlook.com (2603:10b6:806:260::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:40:17 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:3b3:cafe::9f) by DS7PR03CA0247.outlook.office365.com
 (2603:10b6:5:3b3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:17 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:12 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 14/24] x86/sev: Handle failures from snp_init()
Date: Fri, 21 Jun 2024 18:08:53 +0530
Message-ID: <20240621123903.2411843-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|SN7PR12MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: f473bb25-8436-4f3b-580c-08dc91ef4df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|82310400023|1800799021|376011|7416011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyjVJIe0Z09bOmmANyYiMt810ca0XSHkbcsiKGPxP7iwG30ZFWLVIkHShLaE?=
 =?us-ascii?Q?+MPsd0nP2zab2WEax56CdtDEzoQxLw/5TDwki4TD5XOjCBVM5wNP/+4Xe8X/?=
 =?us-ascii?Q?LokRKvq2rUmxgS3rMBchC6e4nqb/5kPmgUH4ciZ6Hkk1SmInb94AFfcub1vV?=
 =?us-ascii?Q?QCVZE5qGuSTPZDwT4ogcPqZOefeNH32cQVQvSLMu1z6EnSXdRtXqKsxkRQoH?=
 =?us-ascii?Q?0jxajpB2NJTbLKVVOr0Qh2ELyYGCcT5dxc1RAfuU3JjK+8kROZuyIXMeBeAQ?=
 =?us-ascii?Q?HWnn3abgWSUKddy/ivXGr4Dy3da4UrfdXVSD8YoJm4EUGwhkqPUMrRVtVV8s?=
 =?us-ascii?Q?lNNhdMKvHdqOka0O+4l2WTb6YhOEisbI3EHc++vAspkC1FmivO1w1tb4txuX?=
 =?us-ascii?Q?uuKBw3acs1Pejlh9s5JI7UuJEAMMjm1fv/F+d6U2fmhe9ZFqEeSTMsf2HUUb?=
 =?us-ascii?Q?V2n+9lith9PlIDouFodxQplhzii9IhJXjjx5y45OHCRfVKkrwy3TYlnZfrT8?=
 =?us-ascii?Q?U5DECAIC6W8h0STHfVqP0VNDZnvGSiqVx5Xa9fjts0xCyjwGF99K56uPYo8p?=
 =?us-ascii?Q?8XT/x8wDZpEMAkaCOkK/FrD4HNRa/Os8GnekM8Ib/dUQV/NHOEp71GQrVVat?=
 =?us-ascii?Q?GNVriWKmTcnTPYLHmv3ue6fhkCxa3PZgBY16ewlALfKN49Wy8IS0M/GL9BHS?=
 =?us-ascii?Q?Ha59uRt4R+OFdJBo0h33OkL0HgQ5qNmpLiTRjdrTTCUPJOkJ+VuMtLZGoYFY?=
 =?us-ascii?Q?911cbINsj6ghEb4elwwqUVi8oJSh2zVGN7PU6FH5zsgxt9cvC2ZmqyKexFe0?=
 =?us-ascii?Q?ibiwvyrGT/Wf7aJ1eReC63WBoYAc1A09+my0gIID219kQx3IW4Caz2QFZpYT?=
 =?us-ascii?Q?ymdbs2CBoo9S6ruo3+sXR0vWTBv5T/sqdfRE3+z2NKIN0FTmRYMVyACEhJ+J?=
 =?us-ascii?Q?cZefZfiBMHooU+mzbMBH5E9P5/gD1tjKaTwuQKEeeBe5FxE0xoVRDkfR+tjV?=
 =?us-ascii?Q?s21fUDfEtMMbXMP/c1MbKGnBJFz8SkdWwW1rFOmk8u/CG5q7sUDW/5dYPCM9?=
 =?us-ascii?Q?puMDaGM6VkRB0Z8W9lFMOKmA43pg8Vup3+uG6UytRpxK4xerSBH5hPuGmpUP?=
 =?us-ascii?Q?bIo9PVzWNwEjGofLvPNRMuBvjiKNdrpj/Led8qEG2c5+5hn8R/psMug3PavD?=
 =?us-ascii?Q?yXtCXNXPW5klqmNOd3+XAOaCcBaQH9GjMHEZ6shZy9KUF+RMe+KEhGkEBbB1?=
 =?us-ascii?Q?pea9z5I4HPThJ1nRsTruzFvMVx9+MSb2xZcFqbzx4bLjHo7/4CHW7vJHS+aA?=
 =?us-ascii?Q?yPHjSkEH7bYOIDyPwgyPqQLUO3FZZfOuQlbk8jY5d5WmAhsvxCZWkCOXBmxP?=
 =?us-ascii?Q?Hgwgs0akjEG0Y+BJvbq1+RBBY2NTfBXtHbTQig6jGNmOdKFkRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(82310400023)(1800799021)(376011)(7416011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:17.0006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f473bb25-8436-4f3b-580c-08dc91ef4df8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7023

Failures from the snp_init() are currently being ignored by sme_enable().
Add missing error handling for cases where snp_init() fails to retrieve
SEV-SNP CC blob or encounters issues while parsing CC blob. SNP guests will
error out early with this change.

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



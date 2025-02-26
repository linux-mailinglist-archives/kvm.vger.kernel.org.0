Return-Path: <kvm+bounces-39260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE488A459A2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D651A189C82D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308F7238166;
	Wed, 26 Feb 2025 09:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TuwWpoav"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA920AF8E;
	Wed, 26 Feb 2025 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561024; cv=fail; b=YRc3i5M53YoUo0saSmH+HPjPuk30PtAeez/bNwPHc9Us1lKwQjOZdhuF6wJT9+9wIRS3sEkbow/8SmHG8DzjAfENQwFLPmgwToa0rNuEtlybnmKE04W5zsGkfKX/pW1Fu74Hq9RwvXKdXgvq9s2ZeFjhJOIs1hSdD1MzPVLTXNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561024; c=relaxed/simple;
	bh=UUiIkU37FyyX2UUqlU8a6dF35nRaBUV1AK21cu1a/9k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyDIvQn+CXd1beTaUPY9EvcFrgyJUCLixeMiCbr39SAJuDloDsrF3EOLzNpKQfTd7fu0WEdfIcFRWq/YaW3rJW+dh3M5qV3dTxFNbbFzrwKwhPA/fzMFZP2G/cn+BhRf19RXFtCXFt7y5nJs/wK+chpjGNDL44Koj/vwWjOV51Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TuwWpoav; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCbwvEk0Faa1+SG1xf8m80/s6cbT+RZE/OnKcMUAIgCFanoy2HrXBi6dTy4l5AORyBgpAnqCRlpwTss5BHr6/wMVaMDMQpYU2nmxYj6qvkpT49+UARPbiwXyTntik17HbMQcYivamOPyNZZDNfxPGdbnGjizi5BLDVpSTAEu1Q6mGJCokSfgKXhClispbTIRRAjfIs6Wyl/Efum94F/DWXZ7XiamRFChN970KjrPpWTRWmg9h0xhrzGOEPYPEtColg0SjDQ8Smn5XI29vkmMr612E0xciQt9M1iuj6optzMxhUZ3nd+WuZUplckSN8ttDGN/4wCPZUAk79x1KLEVDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kd18RLjve6SBH+2qK58fUwqhQjWkc3kFk8XEZH7+1Is=;
 b=G9qGXAiKoooCeciXV5wyg5MpWE/S3CpwsxDOijc7W6/opxZzlk1xKnDxN5BhyHOEFHmBa+yrhqOuqBpnapUZUvT+ZmBXCa7ZsnK+jKqSPPb7guJn3f/e6t0U7levDnyWsXoVHr+gPFWWA9cjO2s6OBSZaX8eQz9bZoNbFQnu9qJEz3hhnETws1XyB5W7iI7bReBugzT72A9/u0WStjrsu9AR1VvWsvIAew2IONXHF3aAhYrOtzNNDcjSZtkbRjQeJ6mzPH0TCt+8FfVhDGVpG9e3T40I65CSIORuSGUogQxK9Rnb9EkK60Eup64Td8hbwGMtKZzXAoELS9DKQQSLoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kd18RLjve6SBH+2qK58fUwqhQjWkc3kFk8XEZH7+1Is=;
 b=TuwWpoavXxzwR04SpByqX7bbPTgrSJdAeAayx0mWDOcD2XITZeXsk6RMBFITP2tHp9fPfLS+LzKJln63d3AxkSE+19aK8hpgde/LwKEHcjsR/loPPsV8JOhNLkZEEh1GEfU+l2xJMQi8z2m7jVUnKuro7mjyBf1t+K+ndkg9v6k=
Received: from BYAPR08CA0009.namprd08.prod.outlook.com (2603:10b6:a03:100::22)
 by BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 09:10:19 +0000
Received: from SJ1PEPF00002322.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::80) by BYAPR08CA0009.outlook.office365.com
 (2603:10b6:a03:100::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 09:10:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002322.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:10:18 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:10:12 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 15/17] x86/apic: Enable Secure AVIC in Control MSR
Date: Wed, 26 Feb 2025 14:35:23 +0530
Message-ID: <20250226090525.231882-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002322:EE_|BL1PR12MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f98cdaf-60d2-4ea0-1ffe-08dd56456408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5ggCTyAKvEr+2GjCaaqir+JortaPdK3Trxu/n8wYcI413SwpUydOQFLDFzoj?=
 =?us-ascii?Q?/JNL1B/ZDMRxHrbSlbcDxoVysHU5Vnz8TSm+NNhWbkqBY+777t9oyxX1RSs0?=
 =?us-ascii?Q?MGSJQHHw9Jd0J33Dlm+90eHlpESipovubh1eTznKlaWRufK9f6B9X8TexoGi?=
 =?us-ascii?Q?CMnuxGxG88bFxezt3XRGc0c0Gi3NA458xXKShIoGOyDJi1IBt0H9wjgaaLhk?=
 =?us-ascii?Q?P2TmcmdbgUN5dg9gsqbXQuYsn+xNMOcMCtfkHLNbXzaPiCGwTeIsw/pyvSGt?=
 =?us-ascii?Q?GcBA6AV6SGb7+jH0Nd+xMfAI2I1boEybsCFOwv2m6MsgiQkGsHaF7XHIhYEA?=
 =?us-ascii?Q?licepfndg0NKXMQKIIhF7UCMQQqysrG5wSS3LNTuv3HoV+/134ndge5LRB9Q?=
 =?us-ascii?Q?2CpAjD+EJkS8XB5GA25R3e+sis3mtpU0BD6Z/H+u7ZmokLG/f9k9YkLRFQOf?=
 =?us-ascii?Q?HeepCJkVf6/mpWFuepPbQWIkxQA1A5rakh5FDgIx0t0Ur72Av5U8sCu362b0?=
 =?us-ascii?Q?fWyo5dZaMtePGiAFBw7qGDmk5d/3nkPGkyJwT7UNZYAwHzDjLkacVAsAkYkl?=
 =?us-ascii?Q?swnyz0rSaF56n43GN4yaEu64bqJEyHHoAdGkwydtIDWPS2jqDMlDLVkFFHyX?=
 =?us-ascii?Q?9EAFeh/htw1L3fGEZI+qQfHyE/iAcSBOHtj2WoPYAD/H4tKZT3ktkDfTcFK7?=
 =?us-ascii?Q?w1exTMt5tjY1WSUHSpUeAgK9YtwiMrby5ZJmgStlkB/mSDtg/rmc7G0XIBK0?=
 =?us-ascii?Q?aCd4aWq9oPqcylfrM2edFnRGwOWIxWDpVc+ZCr7/3vWITk5F291w6zg8xkj+?=
 =?us-ascii?Q?Km+jL07hVe2PC2z07zP6xouWV61wIW+bi3YFkgKpwy4x3aaloi26TKPIme6A?=
 =?us-ascii?Q?FTNjdYYwhyjxSJcmcXnZodkTMRxCiL/Hb2E7PpsnZZlboXJmYJbkBRzSybGD?=
 =?us-ascii?Q?4Z6ual+NzwmX1iElEhacMYvldL9TJU1orUW00bVX4fq3xZNOXzgMWbS+OWDE?=
 =?us-ascii?Q?Z8880zIahSEtvuVCgMaxchaA8bR9aP6SVajy9DSQMUqsZgULT83LNyWuGKgk?=
 =?us-ascii?Q?wIdE4eMubMHD/s/77OwzNthMQGysO/3zvNB5yuhYN49E7H3D4XtWUFTUBfm0?=
 =?us-ascii?Q?oYzhEr4MJo4baNmls/3Fvk2vZgkTDA7ofuR2SDNv3TrC527SejNghugv2qB/?=
 =?us-ascii?Q?K9Nm0mOTY2BEVlOZJ9ZDKPRoqyU81h9vW+PxV3iqtJiaJGw1iGlhFYIt1H/2?=
 =?us-ascii?Q?uQCnLTKiKphtkSV1iyKwKNQQfnxGT0B5uifyfw/DJnU79+cMNp3falv7sHKb?=
 =?us-ascii?Q?CWw8Q9k0exGvKYIxugbejMNbBo1t96/03rxeqs0R4WtEZiAkpkM6lapvgWYo?=
 =?us-ascii?Q?oGJtZWg2aGwTz4y/Da8RGo/1gNXduCGqAXzYkg5jTVVK84YUC6yZfkL2oTcj?=
 =?us-ascii?Q?mGqHN3v/viYF+Dl/Oou6T1Aw8G9lefc/W2g/XPOWYvq6cL7ZEkL5r/lvKCqi?=
 =?us-ascii?Q?4r0aBKSN6Jm/J90=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:10:18.5745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f98cdaf-60d2-4ea0-1ffe-08dd56456408
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002322.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
hypervisor before Secure AVIC is enabled in the Control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as #VC exception) operate
on guest APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 6290b9b1144e..2f3482fdc117 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -413,7 +413,7 @@ static void x2apic_savic_setup(void)
 	ret = savic_register_gpa(-1ULL, gpa);
 	if (ret != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int x2apic_savic_probe(void)
-- 
2.34.1



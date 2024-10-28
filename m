Return-Path: <kvm+bounces-29808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE239B246D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 221C41F2239B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06E2199921;
	Mon, 28 Oct 2024 05:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2uwhUj/7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33394192D70;
	Mon, 28 Oct 2024 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093740; cv=fail; b=bwh9tlaAJiSM31PafYQ2bt76imh0O32xFIfqf2HHv1qH7567qADZmXDyEdLKbj894kOP7s4WeTLiQM445pYWv5RjAg4iunb6ohFU68sb7/lNDSPJ89p+e/j67ZFcyxl81ZQAKaVO+fhHEp5oucHZqgVHgA7PSOY4pzCKzaAl8lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093740; c=relaxed/simple;
	bh=wTiiW3zg+ZEXEs6HyoUwSSwd2a1sEJVoTxWCh49OUQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OiIBGHE3XNBy4O3iJFpdYUI8L2Az2gl8BCELqniJv1+oCogy9jcLnmn/eGt0vjqFhY7POBZHXISOxqoATEz6eP9Z0WQo6+5EwA58N10kOOyu9sVFNAdrMKROMz09ZmwPA1A1NWEE9Uf0HYE+OwbCS/7DJcV/s0hXDu1HuefOIHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2uwhUj/7; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHS1a4FRDGp0VZZ5iW8sKp8sErYr6CQV3QNLUb4TdZSXWaWdBh0HJ4rxIhvk3bvAtpUyQZ++pHggMBFv5UrXnE7QZIs7cpz18z76qKN6kHZOnInNfgFp96tuAR2pts/fc6v6TdsmGzDNBIBavtwIMSJIxZNb/Vh2YDy6TsyYtRTcA0cSZAWywfEftl69AH64pVdHTf3roi57Rg04FG1RpzH63SHiskxEXyhVAGYeo2yNED4E4YezkjumbXVEQA8U/DtrzOyY5okY38sBb6ILydwDRWFSXqLf8ob0wl28uCOgy8FFWUrcyYKmiCNNVMtCnGiMDnNpu0w7iLniz9Ejlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=x89xhI/FaSi6kIEnG0iwt75YtB/frn5AhrUPhSnu0AYLi8CE6M3BLDBYSbLyCWNJMEZm7EIrLya7wZm1Bss3wGRD0tVs5l7nZ+lkWGLmz07ZBjY4fovHAo3QvWHaqQUZBvCGMmS+7EEfgbSQvqzQPT99E9qG63XIqgsk+zmgY7lGocYl/stsKsHTPXDphzNPyUtinv0F8FuBxlzyGgP94FteGscSMbpWceh6R3PcgBsfGJyVoX4QLVu/xfdRA/3ZQTDDDVUKQZrT9bOZkMJIStW5+xhe/CObJBF82RvBdgo3vDNalztI4E0BCGvVRfrTECK6zRg2KFXxKJzHYjGKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=2uwhUj/7Ku/+2j6eYnbVNmMBI3G/TduYKaHHmId7I4AvlzbDBOGy/s4W2HByaBjhwCfd8TRIYdNUn9Ydfd2hgRWvfuzAAHGqyydWVN9pC4rfFkaRB3nWk+oKoS9Quk7XMvl9U3BFSBOlRxPnxS8HErLVd4nlFrXmTmLdE6DMLa0=
Received: from BN9PR03CA0518.namprd03.prod.outlook.com (2603:10b6:408:131::13)
 by MN0PR12MB5907.namprd12.prod.outlook.com (2603:10b6:208:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 05:35:34 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:131:cafe::84) by BN9PR03CA0518.outlook.office365.com
 (2603:10b6:408:131::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:30 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 07/13] x86/sev: Mark Secure TSC as reliable clocksource
Date: Mon, 28 Oct 2024 11:04:25 +0530
Message-ID: <20241028053431.3439593-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|MN0PR12MB5907:EE_
X-MS-Office365-Filtering-Correlation-Id: df5a1d38-6252-40bf-dedd-08dcf7125887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mu/eT0MXqHu7yr3w09rZxU29thKKjHxWX0HIg6C6OPi6msNCQH0bCW4EUV+q?=
 =?us-ascii?Q?6wHmMPMUSvvc6YL2dHcvwNPwrRQlKuXisXflTQZvXJy9fAO2JfUgPq3y6OTv?=
 =?us-ascii?Q?yjMPLLEcPjG5rj3MQyNwNxj5NfrDP1f1BUR4oF+KFxr+crjsaBs5gzBSTIld?=
 =?us-ascii?Q?kTUmaOeaUM/5dXsUoaIIdsckwl/8aeDWxjEYDoYd+eBQKvx9buXPx4cJdGST?=
 =?us-ascii?Q?6l6KwqE0O3tLSjkDOBsjNlQAcAm0aXomyrrf0gARknUhnzkpxwmJTdtho3L7?=
 =?us-ascii?Q?mOk8aIox+ixAUVCUF/am3eTvjeqJVD0lkDBNWiLAED7s0vg6rf4RGF0BbutP?=
 =?us-ascii?Q?nkCdQX7V4ApvPnwhZkDkIzXjdR1V3EpGHsmBUUSifVSf1uxnWsr33XyG+a6G?=
 =?us-ascii?Q?TDzqLiBvLNjMeVMcBjXN3uOTVq7ieopHu1JkTHC1ZUNFg/x1CKKIm5rEWmeG?=
 =?us-ascii?Q?HO1n7p/6peCXyMQ5vdS15er6FvkcLhcleQwfsCSQQjbnbWv04YRr8dBCYtVP?=
 =?us-ascii?Q?onUijuaFOdtbqVVnFlr9Cj1CF4UiRi/wojO/5plDdQXCYh6GBi6BLYTmEDUA?=
 =?us-ascii?Q?OapABcxwmh0laY2REItXOkV9s8kR55tTS/Tkrt+MUOGMjFVAk31VMcXGq1fn?=
 =?us-ascii?Q?CyOfGFNYfh+kyBMwR2uoBDbbQB8NANety6W4qymj1zBpevhtfPEJybu8Xnve?=
 =?us-ascii?Q?GS+O6VXcql2yA3uCYChEp0r6DezfWLSJOnsu27Ow8hAifHQUcr5RLVaGxY6a?=
 =?us-ascii?Q?App5UswioNn7NTcESel+lnRCf1kcKVY4Mmum1f1V7NiF3eizWJlGChDTzaoh?=
 =?us-ascii?Q?0J+rzWVXAnEE+PGpfUZQEeoW/RQHxYsMvV6qiYXzGdM7qkLiq2razdOij1BC?=
 =?us-ascii?Q?4eftAipRCSgxeRzTOxHNE1l6p5ZQzZsQVmtQ3rg1j9E8OL3v0zCSNXjfHEP+?=
 =?us-ascii?Q?7yjtPkUIu2cwvmto08r2Icpz+aKoDqu5WFgp/bx+M13vSlfSetPEee4QzjDj?=
 =?us-ascii?Q?3JByZfrrJ8SEsjsa9B34h4QOgUMZc6jxg+W6opvlKkksCVFJfHCBOKBX/8cf?=
 =?us-ascii?Q?DqS8qW8IZ5JmsOeowAno9w51EPAZ8FvquYaMKcvXTY/A+u2wIYjcPwH2Pg/C?=
 =?us-ascii?Q?NwhhZXupS1GNsLRwGr+CaxaOh4eZq2GsyvqAhZ+oeUtPPcx2fvz6lhOMCUQH?=
 =?us-ascii?Q?UN2EzdmYz9G0v+LmiGJAFJ6YygfRdIqooKU7uCF42m4nTsJDOqBtffEEUEzK?=
 =?us-ascii?Q?MA8zNupGPHWcxI1XM51BlXbjw3S4ZHOSM8jOn7YmE0zbySOBvKoAXi2BiGqq?=
 =?us-ascii?Q?78UIvbbLOWHlyE1TcQTU30rtQJiYem78w/bLpy7AjWVxJ0MMq/UEm3DTlBV1?=
 =?us-ascii?Q?dWEu4o0XPT4PNg+MjRuxv7v3b+wXp/TWSbGyvlGGSW4PLkUjCQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:34.5757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df5a1d38-6252-40bf-dedd-08dcf7125887
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5907

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Hence, mark Secure TSC as the only reliable clock source,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 86a476a426c2..e9fb5f24703a 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -516,6 +516,10 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1



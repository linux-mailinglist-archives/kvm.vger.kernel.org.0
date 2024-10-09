Return-Path: <kvm+bounces-28217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5145B99657F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBFDB1F213DC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F00194C76;
	Wed,  9 Oct 2024 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JBlmJZun"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F919342E;
	Wed,  9 Oct 2024 09:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466220; cv=fail; b=YX3OL5xWSBcBqGaUun82XrXtgwvIyiX/YD2zAiKR5d4S0eLM4c1sgTcelpxbx04BmmlXSMgkSnN7AOAb8YMXt5dByofCbwA3FNyihArqit0mZQecSdTyMUbEl/1MvZsYCjqkrxlMROXC6vxfRYa7pYuTQAa3ARP35AptPiQfzDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466220; c=relaxed/simple;
	bh=X6++Jp2Ou8fBJega9miIi8e/Suj3ITziWWo7kosPDjc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZ57RpVqAvYCCMq3KZfliqG9GhMTLnGZ3Ubt0+UfWSbJcY9IYDKSxfeKsEZc5TCSWVgYWuvmvL0xLc/ssZ6CZp8w7DhRS4eJI9aUr+by6hmnvw/pwD+iGImyaZfmaYww/ze5jCrOtJQSITJ5fyjRHQ9t2cKp13BKlt1Ed0jGyMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JBlmJZun; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZXn7pL95w2k9vGh2RY2+HRl2wYXpCtTPPp/IC7jjERQLO4112Bpguw1K/jgCr/wcQyzOZgE77GPL1CDQ+J1V937luT5J6uM1z3pzy35V7AU9fVMHOex3S1rI//iMej3Ri7W6NR+SDS/nLl9I3vW/TxlQ+DIvJPVFgfv1xZJ/eWhIcGksfZ3oj1cD5yovnvs5wU9Ee5YI3SAA6mLwHqXOiIPK8BaQ0/qkg6OCmAROQnnamxRlq+UZF3yn3GPB3RiKcKkhb4PPl9vOoq3ksT+zkMPHJsC5y4Q2eJFq02smlhXO16CH+9qyaqOXrTLDv2Npm6GxrPgxeYcV3EnfR44Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZCh+Ouz3YgEU+vCusYEaultbYtc/AIAaxrWJf+YIuI=;
 b=fPzdTMD8UGLcXw9XsOYVG6QVe3y7G6icH5IHFt4bFuRAQ8p/yC0VUS6rWYtq/hwsN9MnPFIHtXtMiUOlgiZloMOgWywavZwIreOxPVOM0cIwMY7bYiRM+rBEVRhcdtVloSn48P5wHIh2oQHCp+hsLKOBfDIohbxQNELvtAc0BApIF9QoYFYjZHHmyO9r8cQJVY7IsYK0XlRfyfcHj1l3feeJb9rIecsmAFUqJQD9KycQE9/2rsqct44ZN1xlIodT7iT9S+ypptrz/o17GD13m7rFqOgs5rvZcxVvUwKYqM7d5OOTz73Z+ilvXCMNW7ghZliV13X1KudZl6oAAMQ/Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZCh+Ouz3YgEU+vCusYEaultbYtc/AIAaxrWJf+YIuI=;
 b=JBlmJZuneyEOzLOJ3iYqo0IGCN7zmrka9A3JdQhvOWF0wSvFv6f8BZLOmYGp3OwKewXVgt3sOKEBWFQFdFbtroas33fwsp23mp7V9e/zWg28noVyQpqGiP1YgfSCpAf3vhYdkosjZlWkF0ZmqaiEP5Zz/EXxfBX63TekiVw88Pg=
Received: from BLAPR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:335::8)
 by DS0PR12MB6438.namprd12.prod.outlook.com (2603:10b6:8:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:55 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::5f) by BLAPR05CA0026.outlook.office365.com
 (2603:10b6:208:335::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.6 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:51 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 12/19] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Wed, 9 Oct 2024 14:58:43 +0530
Message-ID: <20241009092850.197575-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DS0PR12MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c21ee7-cb91-4745-bf0e-08dce844ef52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?InzpGp8F2m4gGIX36ZhfRV02VEuByCmULdaTtXOjEznYCl9llEOwNHf3gedc?=
 =?us-ascii?Q?Ka+lYuBNmAJpdUYz9+011J5skcZsOBPykErpqlSMtFSYRlejt62aArFoXxaO?=
 =?us-ascii?Q?brZCrSVgiLRkITAKnRXROMBe0I4CyBD3cPUYY88KUJjvN33+KioNIIyfrUW8?=
 =?us-ascii?Q?yYizxBegHupqHIRMnzW2cefzHtoJzlu6etZqmzReCxFcWgFu664wy31j7suM?=
 =?us-ascii?Q?CDssL4otlxQZTIf72PMor1ygADw26sqRgO2ih7BgN3JrRdLq8FQp5a2pXQAO?=
 =?us-ascii?Q?EEHP7LJIeDRT5cwR0vMyUnWE06jvRW2VHLqwyWKGTL+VJJXXf9m7HYToiSrl?=
 =?us-ascii?Q?Hm+YV4f7vVhL9263ldKbU8MQ7hL/esijYsBLFB0oMkar6fG44OTb7EijCZoU?=
 =?us-ascii?Q?i7E4hTGoTf1RtWfJpFJnvAFTwX9fsppOEz28Vcv4AOkoS4bE4o1MO3nHMwMF?=
 =?us-ascii?Q?Tki5Dv6johxSJNjxEU0DOfSJO+Gy7UHuuSaqE3/EboR0wI6l+6jPM+cho6jn?=
 =?us-ascii?Q?gX23TCecb70CAHgzep9MKpKkB+XE69Zbae5WELKwOgR9BgaQhdd24QzBehFW?=
 =?us-ascii?Q?U3Ac1I9GhvCTJyRGDaz5NdLb0kBfoAGGF1IJno/OvVBTSygbmaz6gfHHJ4IL?=
 =?us-ascii?Q?u14LEFHRW9zxNmxRRDJLe7Sw00ZVKCYA39SKe7HyfqrLrN/f6/uuYZUbcpiq?=
 =?us-ascii?Q?KXzNWO4hV0or7l5GlZ45jgmEfXbWLJkG5PpqhodOBwg5u7TG8vdJTM7uQO1V?=
 =?us-ascii?Q?JmkGDMg88phoxo90gp0IlBDcjwCPsxPHeUUfPB8TCD3fXN7ZghO+3vnjOEVw?=
 =?us-ascii?Q?UOHeesEapHaUV0fd5DeaawC2+H2++jHU3i7dEkc+X/UvMowXwMMkm4ty2fJg?=
 =?us-ascii?Q?cuytEbPm8LXQOQ8m80XMH5nrIG4/pKl6finOLnEqq0z4olVyabBYC3Hbx9jG?=
 =?us-ascii?Q?U0dddr6rDqDlNc2JTvfzeUJM4N94+P1wewSi3+VmwcVYEBLHTqxjxIcxT6CV?=
 =?us-ascii?Q?lbfbyAwSadCmcgBdM7F8SV8YElJ5giOLxhNnfDhvnKrLuimFiaDAlLjZ2gCe?=
 =?us-ascii?Q?q+pHz3ZcDp10iAm07tvIc3ZldH9MY5q34mV3+H2vtvdtxwxzD4RZsse/wAKe?=
 =?us-ascii?Q?5oSI0EVEv86hcnEk3SJ4kkw9bsbWOEllGf01b4dlqMApysx9wpzPHq0KcdHD?=
 =?us-ascii?Q?FMuhumW7/wLwDjDgTD5Ml4e++/cxGxuIg2GFYx7mVLHOvWu/C3a5ZRPRVgDE?=
 =?us-ascii?Q?AXL1uVzEBcjVXLg9DbOKEvprBbjEeu8mWCTsMPmlbQmhUroWPdYO/ptzVo8x?=
 =?us-ascii?Q?AakHdOgcWCqPYnoXI/5G1EabA8qWzDdODwN+7bRPo94cGB8XoYujE/Cvp5U6?=
 =?us-ascii?Q?WAD1nDv5R74sdPEAPmoVJUJPy9P6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:54.9585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c21ee7-cb91-4745-bf0e-08dce844ef52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6438

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71de53194089..c2a9e2ada659 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1



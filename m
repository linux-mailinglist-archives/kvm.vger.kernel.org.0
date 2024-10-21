Return-Path: <kvm+bounces-29230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D60619A5A00
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E28D2822AA
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757781CF7C3;
	Mon, 21 Oct 2024 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ODPxSjQY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD367194AEC;
	Mon, 21 Oct 2024 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490261; cv=fail; b=R21WtHYRJEhzKHrnbQTUkG5ionYyke045TW399J8JlLZv0nDCUOYTPw18e2zHQz9/Y0fIZuXBhjOeSp+HSjujfQa1E93o398R+ezfxqGyc4uEKH/Jz8wPyna3IOznTDjPPjOplhc86dqxRpuCgSrijZHciLnK3rIcMedGpjK1Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490261; c=relaxed/simple;
	bh=X6++Jp2Ou8fBJega9miIi8e/Suj3ITziWWo7kosPDjc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lg952xBR+/fcL2rR9rHvS3pXvplgqK3HsZLv5IItE8WPVHPBU3S0ZEAOEFNGnVEZyzzApD6wOCfx45C81NaAmgQ/PqWK4pjaHpBlLXjJ8o+jAIjZScvHpJCrZrwTAjWKDfClT6CQEe/rwjFESqZBji9m/wGrsHiqVs08jk/VuXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ODPxSjQY; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cq0HjGrBVK3SUSiguZseXE8d2TR7w1tQw7TE/8OKkgRbOtdnix77X3udvP6fSbttsLFFc0kUebl+xBLCj2O6nTLrYeNZV1QfskSo4wqS7CSFY4CcwgTjDlr8MowGC75smISoEAMYS9NoQH6ClBHkTF0zZF8OAjzucqQLH0v0P40YGAwA52y7+JTVNtmqYQ9bSZcbtmuB+jJI4GwWgH8v3Tg9SrDw/Jei9uX4J1JIJHNQF6zscP3Hlwco64V1DQGoM+OT14lnbX/fyNqfg9Si+Sr4liaHrtAGAHWR0O8oOgvbyb8wt71B8Ib4K2JcfNbXjuUh9Ajt+N4+EafYg6Gdvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZCh+Ouz3YgEU+vCusYEaultbYtc/AIAaxrWJf+YIuI=;
 b=GmOFwdT4riolGa3n4SnHfGKm8rTX6IcVnWO8AqDjjpU6OAnAE0m11uk/Y7dyfi39vWTIIc1l+OI7y8PENbeaV35WSyXakCDVoZpVDIFnqmTPzP0PYXjNbEGWlQ371wPhpvIOty6oc1lnkXbwyux2XCkE0KN/oif1BjDnCAm2HpYq2GC+wER9yjqkfGqD0iQ+kMlI96JCBL7keuvk7mX5VDO2e6edNvFVIHdeNZBxQICu196381qoZTlbeWjWKmVNhUuI9XJ4M711bFOqCoQrv3bkvGvXmzQVqS0aDx1RQ4uzNsrYqwftiUcF4xFBGxhL0SoX9pCES4/1BijMxVMGmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZCh+Ouz3YgEU+vCusYEaultbYtc/AIAaxrWJf+YIuI=;
 b=ODPxSjQYo8Yv7pHn9KcepnaO7C3+FcDHgyqTZTgrFKRHF8Sg0IMbyV4LmBIcP25NBStbKQExpolbCES+QkoZNilq/hRrkIIdRAqlk8wjteMfZhdw5m3zF32WzipngfIcm49vkPenf88hqtgsskDfcJzm58hjBAjgsw/GVuSiKZA=
Received: from SJ0PR05CA0181.namprd05.prod.outlook.com (2603:10b6:a03:330::6)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Mon, 21 Oct
 2024 05:57:36 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::83) by SJ0PR05CA0181.outlook.office365.com
 (2603:10b6:a03:330::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.14 via Frontend
 Transport; Mon, 21 Oct 2024 05:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:57:36 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:57:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Mon, 21 Oct 2024 11:21:48 +0530
Message-ID: <20241021055156.2342564-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: bef44371-8dbc-4f09-bdc7-08dcf1954392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rCWWBd74c0vhovse9kClKJU+/oovGzo7ank6Cd6I8yLunHCDhVQGcOx01ADw?=
 =?us-ascii?Q?Qv9O+t5LtGp50DQXx3nl7tzw/rTTnAQJ5XwujwC/a0qNgGVznudKFFi3+gUY?=
 =?us-ascii?Q?CvpcXpvw6Owib2zmR0wHIyjIEPgSKbnPTLRQCflKlmToH/DuTV8jsu5r+BTm?=
 =?us-ascii?Q?TokWnzaKqojBd6r1MHbAtOQ+MoHYnIeMUxcAWV2TGWiJmzm7bCg9IUcWhMga?=
 =?us-ascii?Q?ft9SMkPC2M0PTI11F0FPa4KQaOfGeHdbvZlM2i74RaNZWLmy2wEIoho4sLaE?=
 =?us-ascii?Q?7cQ7brXmN26zPyohqrzBUZwGr/Vr/CgauwWUnEeoBI4ICX0dkKVTU4ZTrXSO?=
 =?us-ascii?Q?WCf0WogPjSO80NIqGgMZsZix7Dl4NHrTfkXtrZAU1EUZ5wjrIrurWeqlL7Ob?=
 =?us-ascii?Q?o40nBP31JvDoO57A300th7Xf+UrGemMtazdDmQMkBoti77xgfZhw8B4f/6CE?=
 =?us-ascii?Q?O4OujkhSaIsB9swLMbBMRRr8zIOyf6r2HnqXW3GoI9lGGb9iI9bHKr4AN047?=
 =?us-ascii?Q?qIHBDcMJWAn3APBzrF8bop3/GGolaSHjVSYa2qnoSk7zVkhIkN8/H36sGdUM?=
 =?us-ascii?Q?fIpE7IpTOM2GNQEEBr/gZT3s8QbX2iF0HBX3oTUsww/THG3Keb3CJxypqe50?=
 =?us-ascii?Q?PFsoxbCjdNqT9zES2jn4UfbE09pAMZTW2/k2hC9DybS6SpAGO/lspQWH8GoC?=
 =?us-ascii?Q?T53/wOcIsNB+x0eYdo48rYEDzsiY6LHykvZNaSLfD1n8Ws2KNHlB7kJ4E847?=
 =?us-ascii?Q?iEqhSUry6afhscaGNGyBPcQTnsXmY+w+vPTwhLh+cZHH+ENw18ntnWhyUnla?=
 =?us-ascii?Q?HhVzHVBwr3JDLJm6Con/LCrKKXpL40Vl3+JMIIaKc+J7hCHR+Mvbr6ib8Rhu?=
 =?us-ascii?Q?czgL4RPtJPcM6u/6W+VjSjVXZIp9KcY9ZN/3w7E+5lU6ULD4ZQ+7BDGHPRH4?=
 =?us-ascii?Q?KrFMJmRivLLRmTZPoysQqpu2HkWmRSxlCc/7Nf+GW9hfbbCyi1jNbO2VTIX+?=
 =?us-ascii?Q?k76wP+a/M9adViQD+G6wfyXL/THDVeMxy7vL3J02LmoWf4MQKnFaq0rB4ng4?=
 =?us-ascii?Q?gPu6bl9r08qOBG4iLiZ50Orb73RUQ5kDSTps4IVcfcD1vxwjraE4LzCD5VnJ?=
 =?us-ascii?Q?CheIBGD2l9uggB3I+Drvda2jBYw7If+8FegWzI0CzYGBG2L/2QCluZpXt+s9?=
 =?us-ascii?Q?Zx+kU3GYxS/Rt+RGEiGLjoQ39u0xmxRxodWnKJrzZrVEDw6vrISbYTU4ktck?=
 =?us-ascii?Q?IwfZW9uWh8cCvSi3mU9tvKgfdTwnysrygFHMnK2qmxVf8ZpbCScBsMPwt/D9?=
 =?us-ascii?Q?jKjfol97wcr+PRy/6I8X35bpywsgBK3cgpS41C04EPSVbV0C81xCaMvw47VW?=
 =?us-ascii?Q?pIJEv18GPVneR7yE6rVUMxLbux0NcM/08ggMd1hLBtlfPBYLHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:57:36.4472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bef44371-8dbc-4f09-bdc7-08dcf1954392
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

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



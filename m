Return-Path: <kvm+bounces-44707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 322C1AA0310
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF6957B12ED
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1594276027;
	Tue, 29 Apr 2025 06:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ihERkzLs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CDF1D6AA;
	Tue, 29 Apr 2025 06:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907501; cv=fail; b=oByjktHc0xsrD7AWv35v0nK1CwQTk5ibhYsvTrNMntIMTBdGo8Q2TWJoXRVaMalZPbcuxjY/JJiM9B1JTtxFPBw6nn9qgT/ZXoiDqnc8ZckCkEOfqRieOo9SzzHusfS68kxmRJ4CQjLU6xJmMYDWDW9X+cP9NCpPWMSNk9Cz854=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907501; c=relaxed/simple;
	bh=SFEG7BZx5zbUFu5YS2+vLSMLQqbmV0DZoZxjnBDLUAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVzBjxzLQixBoGlXYr/iMmScGLvBZyfLmRUSbgBC+nY0lXi0PQNGiPlLGir5lX4wkG1G+VYSxbiZ+nIMxC3u7H1GRADXFRURoIoU1PEA8zyAW2uyOFIirlgqjvvspHsJzNxVCFXOoPu03DkgCnijTWgYBoh3WYvN3eGRw3BATEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ihERkzLs; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nexiOA/yTnpjB1HKmVydTDqbEAdLCE7NhbKsniBrmjNcjhi5QkTNmFXUgOZjLzL2Xbyzr8ZL/q3AVFEug8f1FqS+q/UsP0gw0UDY1tDi/5Vljh0s+l1EedLKUc9vPkRADzXiYM5E4X79rpJIC+M4yHrPCvZ7Kofh1SR7Jltd5Q/KyuAUYdQvIWkBY581rJbfngHjuQlhMuLHFZCRjBypcPj3FqrXK5huXDBn20L6YSNA50WPKhM6FuA8c4h+i2yGILRQUBKQFfLJtNkD4pHh6vVgJuABjonU28zTI44/+9aBJvmbHnRFMw1c+jzkJJC5x5MXfEWvdLM2t7Ez5+hbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDLlvLT2mRP3NS4ypSR9MagrzfdU7pEp1rzaRbKT3os=;
 b=rrnIQbxRRfPbuhoL1DyvrCWeo7ccoEySRDzG5sqIpDLKc7EyasjiMl7MJdTnEnx5oa4ZEucO1o1PyMsF0ghdcmORKAfz+jqiGDbcZYhFH5dllpLw1XDTlYzKtliP9ygjUTyNsHov7yTJyYstirhaM4MxXIV2DzqERllsHB1h1SyTLjBqxssAQJzJV0G2nZ+LEFRvdogJ+m9LVozpXJ8Fn0PFVeSd/pCtWyIepuW0YshmG5qqEwRACXpH4ZPjYzV4gtuqB1wZ/tLTlaNEaWJhiJFrXA8SUBHxXFegQJBAAQC5V3rzolDJiNfiSX/4owq2ACoQaHcSaHCHUvN8tFysHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDLlvLT2mRP3NS4ypSR9MagrzfdU7pEp1rzaRbKT3os=;
 b=ihERkzLsWj3unnPodh1xDOpKm+mlomyt3+fgeIM90ofmyaCmYyRjGHau42kR00kmJrHjmxy0OZ27r0zjJC3xJ/LEG3eIHj5UifoKZC5sr+DBioe+4b/nyjpOava3RJO1g9NdiHnF6FRf0LCqmWFjWWMOuGXnALYxkFhgsh4wiHI=
Received: from DS7PR05CA0105.namprd05.prod.outlook.com (2603:10b6:8:56::19) by
 DS0PR12MB7850.namprd12.prod.outlook.com (2603:10b6:8:146::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.34; Tue, 29 Apr 2025 06:18:14 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::f3) by DS7PR05CA0105.outlook.office365.com
 (2603:10b6:8:56::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:18:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:18:14 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:17:59 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 19/20] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Tue, 29 Apr 2025 11:40:03 +0530
Message-ID: <20250429061004.205839-20-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DS0PR12MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: c7e990f6-604e-45bf-0804-08dd86e59fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5jr7cW/mg7JjDk9xRnD0TZaQxgBXXQWcE6+jq9CVixD1lfLe3hrbmEoBW515?=
 =?us-ascii?Q?m7jXrXEl0ZA+Pxjqw7DZAoGX53pAjCsl9xnd67ZJpvSAr4koNFCslbsdB60A?=
 =?us-ascii?Q?IV/I1xHwqsiQftfQJahw2ZUM1vpYg1OvVrVkdBxDIQWVFtZ3oGECQANIPGdE?=
 =?us-ascii?Q?HTlxuvbr1QDx5HIv+YhPhv3x/lvrJEGabMI8nPtesz633VfnKVA3mapMkQgl?=
 =?us-ascii?Q?u8tXaoFGlv4J3gVhOkTdEtayyDhsNuzKz7JPGSsO7IbNfdVlr/6D9ITga+xW?=
 =?us-ascii?Q?S4zHOR4k148fBUzQUMzUCbxwSFMmAwqSNjIJUAx83Q98B7kAC4phIHCgVR8y?=
 =?us-ascii?Q?pkWlQ1bzEvJXG3GrlEXll4Wgt0flCdqF4/sfiS6hj79Yboi+lyaBaeqw8MV4?=
 =?us-ascii?Q?kWriXppKo5uGuI+lQpjPN8S33X8gZYtyadHdmrMbhomluYS4BEJALMo0nHLu?=
 =?us-ascii?Q?Q2LikUwf0v7aGLPBklnp1VgnPUWyL8Esq0WqzlTZkeI5LIgj/XhYxVPzgTS/?=
 =?us-ascii?Q?Z2Q58dEvLRt85pLTRKO9eX9XACwKqa0UAcFc1U6393R2AJH8hTbk70uPbhhK?=
 =?us-ascii?Q?T0cOVXV47oQB3zoOjM1MbMaLjiXPxN48Uc3SlVlFuprvr/cZssxnfpR1YpyX?=
 =?us-ascii?Q?dBBppTlOs0iJX8sSPfIN+kKBweapWXO1DJKLqfEfBL/f+4Op0yO/Cvb73ZGJ?=
 =?us-ascii?Q?SjA9gd3ZWlk2jSuyTtfYF2L1HS0q6N5MEI3mi9r06V2JcoM8QJtZYgt3YnY0?=
 =?us-ascii?Q?v3w5tdTvIPdQtWB8zHSEVVXUeZ8pc+j6UFi/pTukKq9xMfaDqdnNlMRpyZlk?=
 =?us-ascii?Q?0wp4yJ4wMzLeeZui8WZ0oU7aOpTHfnSeoWojJbTLq0VHwz/M64CIlgpE05ca?=
 =?us-ascii?Q?0X9Wg3N4RHSokgR9CTHefin+Sdk+fxhw3mcZUDBOKaXmK3R6kueyYE6WAwyZ?=
 =?us-ascii?Q?bkSito+/H+tIL+6RpsvIqBXdZ2+V48sBUcyrV9rsj8OiZ8B5eyPa054E5n2e?=
 =?us-ascii?Q?J4jpJzTbimDe7OCGGhAQG5wcenKXzCLjbQ1z9vt1Z536+/ERLJaiERepArOO?=
 =?us-ascii?Q?KQDOiSXDCEL9lJppRKguU5ICOaFouxlGprHe7/XsSDXgL9oovLny/tl1E803?=
 =?us-ascii?Q?VIgEEyzAaP90zT4zdAy3DTyFFOUxHs+QCIe4UUCOyWJYGQMnHzN4NcRawe5P?=
 =?us-ascii?Q?KYEbsqGiYJ5INZw5okkGwyeR/AuYc//VbXIotgn7ictTT9EoOmQGc3BCtBRp?=
 =?us-ascii?Q?GgDBG/kArKmbKTmYWBtIBUl9sXxmfF0kTiKZcrkpzigRxsKHN1PbMr7Utus7?=
 =?us-ascii?Q?di37VvpChR3cOhMHmSKpsr57UR2FtXSkDadz501DRDaOtaR8zUIlXW89HV1a?=
 =?us-ascii?Q?nVNWBSj6aGD/MXI4iAHR+p4iq0mMO+Z2L9W9oIjNYPE7Q97fJLj9TuWc73Nx?=
 =?us-ascii?Q?d8E9WlllMhzeCtnbCaLAV/0nbylGZ+vGcykqm8nX1FEKadO2M32Ing3+0ktl?=
 =?us-ascii?Q?YZu9W2OoeWK6TumI79kGXnF7jlgCf7R2cKFK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:18:14.2290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e990f6-604e-45bf-0804-08dd86e59fcc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7850

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - Resolve merge conflicts due to addition of sev-startup.c in mainline.

 arch/x86/boot/startup/sev-startup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/boot/startup/sev-startup.c b/arch/x86/boot/startup/sev-startup.c
index af7ba9aab46d..0f9cb02cb54e 100644
--- a/arch/x86/boot/startup/sev-startup.c
+++ b/arch/x86/boot/startup/sev-startup.c
@@ -623,6 +623,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		break;
+	case MSR_AMD64_SECURE_AVIC_CONTROL:
+		/*
+		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		break;
 	default:
 		break;
 	}
-- 
2.34.1



Return-Path: <kvm+bounces-48852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E47AD41AF
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE0EA3A7A8E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A463024502C;
	Tue, 10 Jun 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hdJgm73O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449615C0;
	Tue, 10 Jun 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578881; cv=fail; b=Pe1xQXg2hLko0mjF8SnYsO/sC+zyj8UHmjxgLkd+z7CKahfGdhwmAB4OeYuBA8N2KnKrsHXAioTpQQIh1papft1D6o+EfbeFN4431E0XEQ2RbYPCyQ4VmrLihBPJIzpxJxE/rvPzg7sRyqn2/bAZYF+IDckvCXhHYdu95TlkbrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578881; c=relaxed/simple;
	bh=9QoDb+q+W0e4ETbstQDEtU2rSgCMpGFLPVA1SDdz7M8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nk7poIvlCt9GHzrLhQmAJYe9Tv1rwGo5rLchikKk/7qPzQqJOAo3PLjQ67DmobRRRVIsiyV7IXJrfoja8NLmIPa9wpWaKkTssneFD/iVbtGgn+ozXhOoYwYUvXS9vGnLBI1ysSL5WTImP3nCzqsI1oj+aX/xvMdNLE8uZOmziVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hdJgm73O; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tipCBZb8lcpaAA/UJzxd5K611ImSBJsklUt3b0gmto5ve2/2Z3wPqfm5M2WQ3iygxBXUrRq7QlQa2N+xvFiZNxNZjIZR8ZkugW6bSCHimlWUHEYb0RCVpx5pV/7M8CD7MLY5lv/WTfLm0opffvan6e9eq2sg0MCy9OP/XahvTpJQ1YDn8hPLkf9wxXKPggfKw3Rn1TbbrWGJ5bg0KAvG401adAtNSVjRUmaErfvTTPrdj8nBi68HD4+5kWFgttCayX2FqBjdR5pM/HJC+9JwO5gjYuh2xxXhvdX2WcvFYooTfBevoOn4jb0Ks5wx8Lqx8RmCYhvCJZ1vwpEkem7/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjdidJyOY30Fi16ktTXpY7rHkcBOBGHEpphFjfPO15k=;
 b=Sxu2BREePLibpQa8jt2WYlnRybawDgzN0rMclttrH4nNh86D7OpFEaY5Chv4KzLAly+aPBeSZl0FO2lrkri6GfBESl8zZBel7QKbO0G7gcmow1Zk46vDVzWU9NJu9JPgcuzADZgSGRmKWOl8rjOCtttOUEZRyrJlM4CO2rIPGWx+tIhUWEx8YVlDcxt4S5yZR6D5oeMX9pKGpk4Rt9r1qGYCQsF8UxaOex0jvRngLk1Yn6NtcQpGsitLgHABfyxYnPtY0tOb7FR7bHYZpkgMrb4l6Op5Zlw0yZnXyn6E9eHjjhnpgqY4Ro463n0Axm+kBw+OvXYx4B3uILOSGjNjug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjdidJyOY30Fi16ktTXpY7rHkcBOBGHEpphFjfPO15k=;
 b=hdJgm73O3/ydenrXxf2pI+U9YpBGjCasR4y34FtQOpyiFFE+QjXGW6aoNT+xEc+Rmu67JedZMdJpcUkHoKEzg2Q6AFkBrEBMWw0EFcLeFdHIErjvIBHpn+BG4ivMkhjVbAagrBHO+L3RvQ3vT39knShNVVqLN9YJFmFS5PfnI2o=
Received: from CH5P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::29)
 by SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 18:07:57 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::9a) by CH5P221CA0005.outlook.office365.com
 (2603:10b6:610:1f2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:07:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:07:57 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:07:50 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 36/37] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Tue, 10 Jun 2025 23:24:23 +0530
Message-ID: <20250610175424.209796-37-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|SA3PR12MB8803:EE_
X-MS-Office365-Filtering-Correlation-Id: 768d8c03-857a-4689-7979-08dda849bad0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YDtVS0njTuUX4/hLA4xylFwxs8m8YaBOf+GTFQG7UbXrVedB2QnDMhlFcPDM?=
 =?us-ascii?Q?RyjNUnhF8P6q9qLJuHtxCnShK81ycbkM3tGdbzmgYGW9ZoGbs9h68oVO1MOl?=
 =?us-ascii?Q?vN7onjjOZKIorne8ljncEebQfVBUTHLLUldGVwY4gZ2cMY0jL7onFxLTPgkI?=
 =?us-ascii?Q?EWudJhgINFW3mKFrn7ptWMclouir6/VdddpQrqqv/82/g8eqpekxrAhT+6Tm?=
 =?us-ascii?Q?2/IiREifJyUdnrNZ/LhKBH2n8PdOh7INPsTZFk962wLNQfiMi+GkCG3yz4Xm?=
 =?us-ascii?Q?bVA/R24MeX3SwGzmkQ+tYRQPsbvZKAy783e9zCgN5OWOUnXB1pkTQHKmoCQ6?=
 =?us-ascii?Q?YeaBusCMEMh3T9T3N/Vb9dcewu4r5JH/VXuW7u/EdLhF1K+0pcyEOunbU/8R?=
 =?us-ascii?Q?sSGmFDUqjdUv0jpE8wuw7VgeJSLcWGCXzVlHrEzoCfM1bFxHFL3hasNT0foq?=
 =?us-ascii?Q?jPP16qN2+kE1kUKWEaoCFsMQfMid+xtbdIB9Mhdca7QD0Zig0hJFUirxZMKs?=
 =?us-ascii?Q?uAlxlNYsD/n2AU2wwMlRdQziKjmCxVcTIOZTGFDKAwJb1IT0JYHEU5GvDiMB?=
 =?us-ascii?Q?+jittnFKTAvhhtAdt7LG2LPsG2Sw8Gt51tknjbUokzxAVJw3Zc7LZOdNelm1?=
 =?us-ascii?Q?sqJC39S+IdYTCJdYcJNE0b1AsPVJGiYB9iwnp+72ZNhcAtnkw3e3scuUBeID?=
 =?us-ascii?Q?B3+m6bRqQfVkHjcYScz0W0mWH4momRLXg5e/9vFgo0n3RgTG8GePJ6UNGEVE?=
 =?us-ascii?Q?ajbyLTX4dS65DvMac+NYpR1gtTztr90/qmGbTZT/7VnO4RsvnSeDSfBvAFk0?=
 =?us-ascii?Q?5+CCFDyyziyGPC9kOSV6wdjTe79hjPAcvrHMGwuLzoQMgxT9C6TDNv+asyqf?=
 =?us-ascii?Q?xaZm/4dulAWNO3KSPlClH5rqmFrpPOlajK94GPIqmB7ebbeV0nAAr5uMqGde?=
 =?us-ascii?Q?Ce5crLP1rjYheupQKky3WYNfAjDCTJ5KbmYI0rarW3Wk1Qk0gOwObpRkj3Nr?=
 =?us-ascii?Q?is36UbvYWLq0cLGp3O4557TRy653lL6AIqhi8PKb05E9F8/vA5Tsjb9oHD1i?=
 =?us-ascii?Q?sik0OfrmUE+YpHyRB4XcFsH6vYBOIWA/J9E/py9faItG+b6CeNh1k+XLXViq?=
 =?us-ascii?Q?lCLjND0WuzcOgegVdeC77DMPhMPtMehiy8Tukmyrrvu5YpGRuCmKyn0PuQ8O?=
 =?us-ascii?Q?CqRH0Z1elUlw3tKgxUDTiI1JsPD7S9ev3UZnOJ30XSPao0l0/Od2DM1IG/q6?=
 =?us-ascii?Q?qTaKOSxQ4XOlY6qg7NNvGl/pR4LxDFkxdL9IqYFE+DeDRw4aFrWnuD/0M4Jk?=
 =?us-ascii?Q?i6r3CsvSFqv4JUznXcKFvHz+l48MVVYeBXw0T/+RSlRJfGQfrzl+9oaSER/N?=
 =?us-ascii?Q?4+ke/Mbv01S011c86zh1mMEypm3s+oEPjxkaxmcYl2IZW/RbR4s8ufMTHMdT?=
 =?us-ascii?Q?iGtN0rRCqH2Sz8SmYI2pRRnfXycrxz9AIakenpHQF05UYZNREZ0fueVYV43Y?=
 =?us-ascii?Q?cXavy1p7FQMClvX24OeZbmA3xi2BgH9uqT9a?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:07:57.6214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 768d8c03-857a-4689-7979-08dda849bad0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8803

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
---
Changes since v6:

 - Added Tianyu's Reviewed-by.

 arch/x86/coco/sev/vc-handle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index dd6dcc4960e4..ed6da4a738cb 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -407,6 +407,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
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



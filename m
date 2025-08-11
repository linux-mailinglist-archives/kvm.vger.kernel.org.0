Return-Path: <kvm+bounces-54405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97011B20486
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D41D16AD36
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2025230BDF;
	Mon, 11 Aug 2025 09:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="esGL8nrH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A168B1DC994;
	Mon, 11 Aug 2025 09:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905873; cv=fail; b=WyMMVTKpyg2aXz9TbmNTAVKNNnKubA393es/y1BNzOk/0aZrKIB6/jOG6/qppIYXxr7KENzyCCP/qAI2Ifykf38ZDr+N6IjEv2GvPmRApIRXFkJOLcTAzosdBPuNMVVEyfrRbWDW4xajT1OK8+4MncxK+GP08m6W3aK5NwbYbIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905873; c=relaxed/simple;
	bh=mOKJJw7QOdP7gPCUQ73slRa1si86zMH5ESzu+trOLUE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SaFLReV/ER/8scdK5hUDuWYYYyrsvQCx6rXGj6SqXpWdfyxgONuqP+B6fwtw+JD2Te7JsGsN8eM+lTkyf7/lDzaXUyHCWa+JDEMJzZS264uWCAVcMD/yM2HuEumIu7OvAuBry38TMRyhJynirS16uDvNrCYp+ihtJA3eR40KXs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=esGL8nrH; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DFMW4yjm3Y+qI8MJ2daKg6noAms58mwfeEfINBWAcDpWlHgFdQeqqSbJG/wbNpELUCq0fjJYnPts3XIArFFom09yn+j57JqY8LXY/Dbb6lP/EgzzKVeT+G8Mz6OcsvCoVFrt6Bhp4CcY7Ch1j4ACdBLFnbLASmjlFpiNtOuCQTtzPuxA3z+zkstvImFMFNz/+1ZXeGfcwUt/YNJZV1emiB99cC6p8eQIzlnaVJaZk0p9uo0mWajVQH3U9ptU1jWVcaE3rvjnJyu4lkoJrppjocM1dgPZ5XcdnrOItKNEDBKeaj1Ie6Ird1ILKQbH5aWSkz7cTMMk9sUI9nz+xxh2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TI+X/xfOpYtOI+rY6A+qOe/y5REsbc7gwpLntLiVkU=;
 b=SvDCNnmoOh2zYiW9pLEm8qmODA74M4aWseaJxB8yf8u7G9h1B64dcXE0kHUt0yvxM7yNavp0Uc9+E4QNA7dRWneDR4J9jU56hc3QPIcBTlEMDl/IsKTUrJeSuk6kR46e9UbO4Xm8bf1XwQJ6yeQXabsQ+RBelsPLGy15QKdPr6tTNWgjSQ5Z7l1W+cUnASpz66cnke9w6yPWSzG3lQ+A+3MFOX7pG33h0Fy53HPYeb/zDrSARp5ALIuzv6LddeOpuAhW9evsSLBmhRNP8w3H+PF1Ih35FXvAj+z+i3noeE3gW2eV1n8t5WqDhvxB8L0bKyTqQ22QoM/xeFyrUdXjBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TI+X/xfOpYtOI+rY6A+qOe/y5REsbc7gwpLntLiVkU=;
 b=esGL8nrHe1qCuw60w/fF1CloVKqqVosjish69kR90SJvgNCvjCoNPmsHrDXFnnUXMCbSu9hGHJgFj50dRdI8a2jXrlfRQrr0rxnMzZJxL0hYRjfjR+hN5X0gsOAa37U59U8E6CLAeIicbX6vlx3kJNaFFQdIBLfCXk46s9wqKcY=
Received: from BYAPR03CA0014.namprd03.prod.outlook.com (2603:10b6:a02:a8::27)
 by SJ2PR12MB9237.namprd12.prod.outlook.com (2603:10b6:a03:554::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:51:08 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a02:a8:cafe::55) by BYAPR03CA0014.outlook.office365.com
 (2603:10b6:a02:a8::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:51:08 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:51:01 -0500
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
Subject: [PATCH v9 17/18] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Mon, 11 Aug 2025 15:14:43 +0530
Message-ID: <20250811094444.203161-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|SJ2PR12MB9237:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b95f2a5-a664-4e47-a167-08ddd8bc98b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qRExuyHnJuXIGWYAQi+CfLiv/OCVF736eyR6mFsydqNBEqfXI1+by1TtOlA2?=
 =?us-ascii?Q?Kh424rcdAzBVUUs57E/CQlfRjdmzn6cQq77TuQHDKsbIAFMYmlbda6VZUqHQ?=
 =?us-ascii?Q?S4XvlCwcIvECXqabtY7ZWpWCyHlPeQXr3tXNZi1ahMk9r7Rm59ukR/+3AxzM?=
 =?us-ascii?Q?dngHUaG1GELv9o94Kud3z/OmA+7nAbHHQQfNJ1Y3Yi9ekKi5tfMfbpuiUKGY?=
 =?us-ascii?Q?J01Ch66gJo5cyiIPq7TWrkB9VhAFuXONl3DzuoT4u48Euzz1MwS0b9OC3k/O?=
 =?us-ascii?Q?xd0sGpc1VaNRYb+G1tX4TVvhpsSoYbqmNmdDSS2RJMK+D53qGLG65qMpZGru?=
 =?us-ascii?Q?h6hznORwH8WmSuuO7AZg3bwHJBG6qba7zW2f19YHUuezYqvZuGXQNPZ4tae+?=
 =?us-ascii?Q?cRMW7LY8PtpaSflQMahbW7S7Txoy3jlRmdvJ+2xla9qOKClUeJXPF2LnsigO?=
 =?us-ascii?Q?ojco6OrXOIdODeXt0/8rzBO+5pSpOohtsYhLGVUoQEYM73488E1ybYGdjkfz?=
 =?us-ascii?Q?ThnfBqVViw14ZAILWX8e7UTCOXPcUhsIS2ZmOmNr/EXem/va8U3ahRYf8L5J?=
 =?us-ascii?Q?qg3CYJ9o+YJwSJutFg+1XJahqLJPmpjxPMFBGJdH6umCgPeEdsXk/uLHyibg?=
 =?us-ascii?Q?Tb4CKoGhbX4UkbDk8//7ApVI08Twtf9AxxSGcoxbSkoVUtQiN9EvxlX8sIyX?=
 =?us-ascii?Q?HJ8LsP09jc8vRG84J6L8M/tvO7lGOmJIvIn0yBqwD+OCHQIH6zFx3ZLICc9A?=
 =?us-ascii?Q?34ovfkbqiwHZYSsZAzHRcCi/2sDDMBlnC/PIgI5uZ8iIAMvjeEqPcYgoYwGx?=
 =?us-ascii?Q?OIQ+FtflQp6CkYGqgI7rJRvCg9F8MBnNZuAVhsNxX4yCK0+oRzj5y5wUQ+rm?=
 =?us-ascii?Q?JbzKMUIWCHh3G8O+GFJZd90rBTjwgmD/aZYKMtXKWHwoiyPO1p0E1uXnnRQc?=
 =?us-ascii?Q?BV+JOUA/fcS4He3Pm6YTLQqqP1DSNzDyPXXXi31nNPJ4ALgjdtg+lrEsec/T?=
 =?us-ascii?Q?OERxCRpEW4itTVJr5rUSVX3cZKnnTDU7+g+1lOjVijOCgKxrMEZz+9+3gGos?=
 =?us-ascii?Q?ajFB3BxDj3dnqaZwcfsjtIfVsb3ZXfowbOha8Nt5FLZ2CKVGfgC+dzOkvSPq?=
 =?us-ascii?Q?LDa9UaA19nS0vDsYorGlRRNhP73Txzu75tJ0AqNIzjyZFnoGgE7cNT3JiEKX?=
 =?us-ascii?Q?sV7hlhtYmkpD6sjl1gzpzd/szbmNIRgRkJTrponFa16iYwjsbh1v8BpMv5WX?=
 =?us-ascii?Q?sUTUOqigLYZ4mXI0ezw4Ep13eAZKX2H/IbPjSTGitpPK1fR+/IJjGemxITQQ?=
 =?us-ascii?Q?8astkKt8eEloNdErEwkzN7xK+0uKnIULHYPZ7k++jh+NDervFeRLbESkcE/T?=
 =?us-ascii?Q?4VIL1yfJ/lGWKShvcCXR4XtOXLAh8+G7sFhN4CjQrKPjWrDc95gPBhZ9+6hd?=
 =?us-ascii?Q?E0wHINET23zTBPP29K56aq2foc0FUe3FWnkxDJcsi7NEriWJWzKsd+35D8F8?=
 =?us-ascii?Q?zIPIpc0K42QL48LEfRS4NfjmIJfrNAYob9oZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:51:08.2880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b95f2a5-a664-4e47-a167-08ddd8bc98b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9237

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - No change.

 arch/x86/coco/sev/vc-handle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index fc770cc9117d..e856a5e18670 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -414,6 +414,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
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



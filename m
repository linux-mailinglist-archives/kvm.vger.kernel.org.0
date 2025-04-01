Return-Path: <kvm+bounces-42316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C528DA779DD
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0C103AE160
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487BE1FBCA0;
	Tue,  1 Apr 2025 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tFUoQ+Ao"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23421FBCAF;
	Tue,  1 Apr 2025 11:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507704; cv=fail; b=lSR6jA+dMX0gfMq0OKT0IEDwdurZJy0tbIfahrav+8AMgah11FDtnAka3WoaERrq+vY7OIUGhwpmkG62HdtiKzOgorl7n4oXLFuP4OHEvYlKder4NMPfVpQd9R0TaHmghW7GFiY7KttH0EGhEjBzSHH91A6qQC03k5wiEN1PEkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507704; c=relaxed/simple;
	bh=kUAjmdky3xyTMHyKTE83Mnl6VoFcJIGYp5plMgPpudI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jep4X2kvuS15sn6YjmMHZGZS1tSvTOcbnn4GgpMTtRhgCkInzCLAIpMBrlrsZKDSaSnl3Cm0pmgiOHP63XldCxJEvV2g9pT8/Jv5pmhdKEnpG+udp6y+O7TorMausNe1lGLUGYOz/zn0+SEmNGZ10W+q0U7iKA+I5EWgsitaZyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tFUoQ+Ao; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2bGVcx4sxDQph/GCmDmVhW/3OCHon62rbxgNss1GIVAzF6S6Gbb6CvS1oW/YFGchEYpyfX+I0QXtOvWdlB3vDevwFJCcKZ2bTNYtdoqlHToaP/60nxZd/Jwy0hlYEOWh6GuwWCEA3g8elJZsI+8vU5bMrse7hYK+lsmYnFoqh8L5pXzjCyU8k4wzU+XnoRmolAGAwTYuE/3bHSTkJEoDGj0gpZ+mpyyGe3QIL9ny+w2hhJtBR/EIaw5Yz4SouoRkBJnZjOp+S9H9T5lnvKFDlkCfAX2qM2XZ+U5Ayu/FOZJrZpt72T/8rUDCa4Why5bTkow+dcb+JeLcjrXaITWxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSQUUrGbLToxq/x6nMFEWuq+5HjuQNNEefgrGItHWA4=;
 b=TWkumQ7b0c/5dsf2glc9jRSlaULGKpq0mAuc+GJeUvnTzuZgSg8a5CDxpigu2zEMvGExPGXujRDqFkMAq6RRp5uzdYjFAtdKUjLUo1eheVinXx+UZlQziCW0aEXcs8ogSlbhYpYnQolOhBc/wmNZo5o+ICjCbNBUQKCCvnUwb0qRlPxaPiXno4osj30F3Zygb2qFx8f3F8mN1K8KI6jPvVrNHCxQ3HTmh8U+7BADM81j4GUNOQYilYFYwh+VlQIVA0iKf2+DzvzrG5K2MsOnn8C2bvb6ElZJ6erb7XGfx/J5hOv+CIPQjpAdoxLJNbO9CknSc1a/dKNGMVyTvyMB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSQUUrGbLToxq/x6nMFEWuq+5HjuQNNEefgrGItHWA4=;
 b=tFUoQ+Aoi+1V0VycQuiKc/6NqiyYSJ/Uknf0mKBSqk04tD1E1GE7Ybx/R9EbGAsboGk6f5KeZ3zXyE4595t6ZcC7ILaP4NEu9753IbG33Gui7vgQSlsgnRu8JmkciiExFPN4Bmi6z37VuL+32DtPpAGjoPisybW1WsMVKpcgX5c=
Received: from PH5P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::13)
 by LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.45; Tue, 1 Apr
 2025 11:41:40 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:510:34b:cafe::32) by PH5P222CA0007.outlook.office365.com
 (2603:10b6:510:34b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.41 via Frontend Transport; Tue,
 1 Apr 2025 11:41:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:41:39 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:41:28 -0500
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
Subject: [PATCH v3 16/17] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Tue, 1 Apr 2025 17:06:15 +0530
Message-ID: <20250401113616.204203-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|LV2PR12MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: e17845c4-796a-4cce-d285-08dd71122aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YjBI3jgYP8NFsiCUpt9ouVlatoWjPdLhkK+SEARFUK7gOukObtG3InidJST8?=
 =?us-ascii?Q?7fJZK3CkDwGz4Kn0m18sa9IbI4Ds50zr9lmE2CG5VEzF4yIdxU1dhm4O+oAg?=
 =?us-ascii?Q?qitqH8gtblfQvlaSP9Xah0EoS8qCrSwA9PFXq8CvZlCJBp18QifgUiDjnCeb?=
 =?us-ascii?Q?yUt2GsHX4v/zoSp1bm4GNAebakPuhs5mhrr9xkyDoQsBy5lzk1xQX5sIbELD?=
 =?us-ascii?Q?zUChdXZOdJfth2XD3Mmo9jwSu8p/Glx9PbYjohmFa9eqsJJDNIzU82UtUe5r?=
 =?us-ascii?Q?IMW+vpCA3eV4IGflrGffzCt1lHbFuCTCw890KXQGWVWsbXVt7QxGCNJ2rgpJ?=
 =?us-ascii?Q?/m759YUh7AoofmVlqTi5k3EnVk8shGioQXLvlvPFovbqae1//kuNoptj0Qx0?=
 =?us-ascii?Q?SuTx3qTgnt15ZFWcYOSvAOwJlvV8JK5/3xt1cdrF28SI6i85/pGpANHiPrwb?=
 =?us-ascii?Q?+fn8DhZYx58dBwONtjPDq9SQCLgJbYhUi8ibR7DF+kXgSWyfl3EKnDAY7XOI?=
 =?us-ascii?Q?QOIqErF5hBHNySJFPQOPoJtNRCK4wZHP1RxMtN3eNU40Gk4C9aXXFWVpmFoP?=
 =?us-ascii?Q?baBtaViEh+W/4HG53iE915gEDglDRD25wfoCiUkfCop9BzdY3DAcYGWOQWmG?=
 =?us-ascii?Q?098B++lsWNUuBiwmfKtG+2fxGdnQZTx8pbl8tWripODd3iJR4Sbj4giPAa5Z?=
 =?us-ascii?Q?eGflbp3lrBr5cxVHQzYQJd3OgNcOCLq9Zglnk3i1XEonO1f5mr7kTFu9FL/7?=
 =?us-ascii?Q?n6XfCSa2v/glD/EBeXX7SP4JJqiJzAmy/EDWYCqATFFPq4lXO39D5YIJ0p+o?=
 =?us-ascii?Q?2TwY0tuxYF5kwEarpBYL77Ng2SEJX33AWJv7mwXn5aTNS5OYjXO4kqdhUT72?=
 =?us-ascii?Q?3R6xcvdqLhh2XlkajiCbjLlB2ewTHZ9gz2TsWKOJevbWHqJiyrH/n7ObH1ik?=
 =?us-ascii?Q?1XbwDQhcgRt76CrsMb9Y1C7OF1JYRT2wVXJW5mvI5lDN3l28ACh4jui8Pbbf?=
 =?us-ascii?Q?w/WdFUgUBmql0iAoY3pk2/EmHqTUTTvK3JGyMH2J1abYi8kZRfV1hK03XcMh?=
 =?us-ascii?Q?E+7pIYRiVa8NnYKK/VDl0S0Hsgwa/SONxUl2sWWfI0PiEfu6BYHi4R+Ld4jB?=
 =?us-ascii?Q?N3SCrztnmcX5HJPDxthfAc/dGQzhp+G5L4hCRjw39A8b57ne/ONi8nrjNgJj?=
 =?us-ascii?Q?lEnjU4MFmWtLFXl8QaiI5h43PnU85MknBBP4NHhwtvYtDDvP+ZG00Y/NO71j?=
 =?us-ascii?Q?Z8PJUQVW3buf+pzKofbAZzPHxiQ2ytn8eiDH0h1ntGKr1rhlaqOGg3OjZ51B?=
 =?us-ascii?Q?e416hlOmeGBLQi9GKf691RaLqWnkxpk1jFJ2so0eG8IOCvjSFYCOg5R1WPX2?=
 =?us-ascii?Q?tmNHU4D0LnbC4ycyPpgcIGE/LQJ4awgpAl3EuZ5VE9FGG7DXxNRWlsVwnlH7?=
 =?us-ascii?Q?eKXN2Vr7lkj9UasSHXlZSADaHlYnFN6HSmObda7kr95nBa1kKKEXJQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:41:39.8635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e17845c4-796a-4cce-d285-08dd71122aee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - No change

 arch/x86/coco/sev/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 2381859491db..3707813c421e 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1480,6 +1480,15 @@ static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
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
+		fallthrough;
 	default:
 		break;
 	}
-- 
2.34.1



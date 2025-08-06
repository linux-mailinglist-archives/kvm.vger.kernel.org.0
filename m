Return-Path: <kvm+bounces-54189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90965B1CE06
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87F97565628
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82365224234;
	Wed,  6 Aug 2025 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oUw7BRl3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F91FDA7B;
	Wed,  6 Aug 2025 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513173; cv=fail; b=Zf0pNCw/ZweKSngMqIQ7gaUBW15eFGiKnxlBVk6dT63zB9wYSumstVtflnlOM+BddO9OmzLKO/GVFHf/m9Ux9P3xhWZ68EX6Z/0Y8b5sfGEJyHNVIsnzWcAzx5Rf/qr6h6pperTLuqNPWr1wV32azP4y8UCztUUL4Rln5GZ3Tgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513173; c=relaxed/simple;
	bh=BK5znaHJEe0uRckoX4IwW+44IjiW2FlqfnX1sT4RHPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJrPitv+3sghkR4QcV3n5xPwLILyn/LDeQPUx3TU5ME1ijcDbe0KcJHmSM6Urx6PCw4fy9BpbbS1Z5R2kphwCDI0Usv/aJQq8rbh6BCL4p7Yu+LwfxwHTZ479zDA/TsPnm2P7SMxcfl/dyAXu3TDLssMsk8EU/JnnlpNDj5415k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oUw7BRl3; arc=fail smtp.client-ip=40.107.96.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O05rtY/Q9HqUGaiZ45FRfWn1IglludIq4J3lb+6iKkSG6na/g0EB4fDRt4JAazdAMHpmnOUSKF3iXW/vH2Cu5hn5Hm6DFYp66NVgdmR/FHNYqGmIoHSZ+yFjx9Mb+8e0F9PxL19rs8+2W0r87RGZoaFbu05/jbcoKWNe+aWi05ojQTrevla+BbDOeu2l7XOfTwb9E8KSyw4BNp/WAG/Nx6Q9E9ZGwlqSecemJ+/aXjErQBQDHpsultNeiQG5e4kgFP4gNe8w7VY4K2qKSpsiFGby5EHYG5sD4ozV8eBgqx6GPbMDEM2WQJXV71JztumrgnybDIpE/0XME0zVlMSCrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SM3zcavWSEJZ11kwd593RwLh0vIJmdTs6cct+a9G1c=;
 b=DtUtjyw6Z8pZCwZBGikQWV3OkFZWiJpBOYImvWIRP9XeJ1bu2LFVIcbTUVS/nwEk/C9h+8U0+TNYGac0QcyEiO9ptXsTetDaKlv5kF0qy6qKC5auJedRW8jwvZOzCVzNvmi4aCk8sTV5fd2e44GMFz6TpuzMtt/AwHN2LlZfa1gUQdWW3TETUMu6nZQClXQo2NUN7l/1rr6k48P88GzSoxE66xcD4TAEQAzmZc1K3P3hcClsKmdIcpiSFjsj70n2IZlw5H5cnaOx/xQrodSBz1V1BDWMmGXdrKKqUEPjGviMSC2l5tCPkQAEcxnpIuUvCedzpA04HJoGbuhg8AtxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SM3zcavWSEJZ11kwd593RwLh0vIJmdTs6cct+a9G1c=;
 b=oUw7BRl34a+sTEcG5dJuHI6bF+AXNIVZcfqhD0Lg1U1PFDslQfP3004MWUafsD5jt1rmn8YEOddWDstK1sHgs7yAkvGeCU5lgyh313aWlt4v8flEzRIfwdBsozxotKgBRP3pzFxy1R7tHvESEkPSeU/lmEpiW2L7Pm/99IAJtvg=
Received: from MN0PR05CA0022.namprd05.prod.outlook.com (2603:10b6:208:52c::22)
 by CYYPR12MB8891.namprd12.prod.outlook.com (2603:10b6:930:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Wed, 6 Aug
 2025 20:46:10 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::15) by MN0PR05CA0022.outlook.office365.com
 (2603:10b6:208:52c::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.5 via Frontend Transport; Wed, 6
 Aug 2025 20:46:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:46:09 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:46:07 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 2/5] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date: Wed, 6 Aug 2025 20:45:07 +0000
Message-ID: <20250806204510.59083-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204510.59083-1-john.allen@amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|CYYPR12MB8891:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f23a2d-edd3-48d8-abcf-08ddd52a460c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q25agQ6Xc7n99Jp/C0xMGOGmsZZ/XJmsJHmaMDQ6zpl/2S0KfjZLmtsN73RU?=
 =?us-ascii?Q?B1E1ag+21mwbYSk8UxjVuR+V83p8YPZMxJDjLrOFLIEqxrCJjHKCCO3CRaz+?=
 =?us-ascii?Q?CNGapRZKH08G+Nwbqei0of7ywvfZoI0SNAHcd3ENtExxdMZ+XqqsUHwnFK/G?=
 =?us-ascii?Q?bfdqssEcH5Pw3EWKmPM4Ld+u2AJp6BIzdFEhKn5Bb85dhcmB0r7W1xIPPHQv?=
 =?us-ascii?Q?Frshpr56xNWcf/GRfH33zq05XUH8NesACLNkrU6g2+weK2re03oZgNrgIMVt?=
 =?us-ascii?Q?DdbzM1OXf1RzPx/bna+jE+ZbsO/pOySsrDFEBQxkJeqgwO0BGHNp02uZpTbu?=
 =?us-ascii?Q?DW/XKwmqNk3v0jYC27fijqNjBEzBjp8OLeIqGQtAIt+L7GH0pRGmCIU0IVjx?=
 =?us-ascii?Q?ZljWt90JKURwUijCoTzez2+P5vkN2FwtStJQuTUI+R70ahE6aZd215MEvTqd?=
 =?us-ascii?Q?SqCsQhsmJ+BJ4w8eitmXIBwehm0DleNVhJ9lI9whaAO0c+AjS2tzgvoSk8b8?=
 =?us-ascii?Q?/qXt8nTzsasau12s39d3gbxmEM9f/0FhYMPA7qehfatbZVi0Hif0Qk4MktDm?=
 =?us-ascii?Q?pMALuoDKJt4yGOlfAQMVM3qWDprwO9wcfic5qW2qaAYqdI2tv860GuHXSSDA?=
 =?us-ascii?Q?4TnAFm0aR4Vn8pSbR3rviaFkFP8rk0Rgqzhd5JF1upTGtweuFSIT3UYf7eHy?=
 =?us-ascii?Q?E0clo2TCxAow8OBqhxBQ1XQT/f3yJpeeVp1YsWuJ6E3+v84ozfDm5Y3hmAvO?=
 =?us-ascii?Q?nCHnnBtDjZxWXnt92FEGBJGC6zsAYP8Qp/wVfLPZ8/LiCNCm4RV0btTaBzqt?=
 =?us-ascii?Q?LMUlUNRhGl8N0h4JQMBoec2qrkWAuqSff12K81bWcCTTh2DqnOY4xb8t6rvU?=
 =?us-ascii?Q?aR67M40X1L5Tl5g2ancRbiGFwk/DCFrlDEgwq3iInnlOOaMlNNYl9wPuvkXP?=
 =?us-ascii?Q?rkcOz710Cf/IlQe8+wk/VfIYFE4NKvpZFhsOvyAJGxJrq5pzFPBjzZDZVNPB?=
 =?us-ascii?Q?HRn2rNT7IN+mLNRzRKtrSMMs5DYWKfQTYvQskJ/3yimLPDEGzAf1XRIa3OED?=
 =?us-ascii?Q?o2iIslOvjebKSVLu87xfRHqMcovrHwHQrjuGW+yANFqLgQcugRA6lu/RcPr/?=
 =?us-ascii?Q?z9m/FKFRsrS7l28p1fnSI8N6MInb5H56v7mPPvVBKKEelNfP1E1tSn0+k+e0?=
 =?us-ascii?Q?W2LrRr6TYWGvqmuVynlwC/cNbohaqUFuSWtoEkEQs6xhSUlQwxH7zusLfayq?=
 =?us-ascii?Q?1oBRQ7WxC5LUC/6h0ziES3KAcNYMSD/KgPS9dWJyZsGrqrm2GRSWvDFyeVU1?=
 =?us-ascii?Q?Y9UsWkXlXTo8hWXfHN8ORJx56JRB3p4qBAdCBb1AfjfqnqTOMYqsEDoq+0G4?=
 =?us-ascii?Q?EymrXu8pdxPPHoIVUyzvizR1Zw0kjWxeXOQReyv2xuoPHhPM+btH5vSwSuoj?=
 =?us-ascii?Q?4VbTZMc9Il1VgrcbLwjOuAWf6KPZgh/Vx/GD8U1guK0vzYH8BA+ogGyskyqd?=
 =?us-ascii?Q?tCCC7opEqC/j0eN02QWlexN87FP1z6lOHDHc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:46:09.6608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f23a2d-edd3-48d8-abcf-08ddd52a460c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8891

Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
and U_CET which are only inlcuded in the SEV-ES save area.

Signed-off-by: John Allen <john.allen@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4e27e70b926..a027d3c37181 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3416,6 +3416,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.34.1



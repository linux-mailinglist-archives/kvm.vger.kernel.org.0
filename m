Return-Path: <kvm+bounces-39676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E63EA49484
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC0C6188E4EF
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4073255E46;
	Fri, 28 Feb 2025 09:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iuMf9UmP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2052.outbound.protection.outlook.com [40.107.96.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8389D254B12;
	Fri, 28 Feb 2025 09:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734033; cv=fail; b=u2EresD/sAcw7W5iENZczM52t0UfMjIvAIS8Vg8qgiKRa+Qt5aDwYNF2380AbPaQKCFCII6rB1phxn/sH5tGuTJcX73VduzSPDdgyaAeX+7ojvaFJn3b7Fivppei4re/+cTPH/F2Czo+N6IfRrUw9eqeNH1Ybpsvcx7zoMtzl2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734033; c=relaxed/simple;
	bh=8RAAu7VnyiNu5X6xM5tO/TTLkVq26OKwHKqiqxEBT24=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q61MOGARMGig2F3ShS/zZxv+7dzlUgfn1KWOHvO6IeG95Wuw7dghiO6j7sOIZcYxta0KnmnkbeljDP2ihkacfLY8ENzzieGum3jqHYwGXuwSzo+6gG3xO1vg4Bxw/DUuhYq6irkyM9J4TV1BRM7bw9IWyDfFBe98hvLm1RZWRkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iuMf9UmP; arc=fail smtp.client-ip=40.107.96.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+pWhUP1Bv968Ix0pCpX+Y75a0Hd3BRPSyyRT01k8KL3u2YvRbX5xwoQeKehYHrEPZ1bHe7yfVRdpA671iL8hqMqrHrGVMIQDT2F4XlYQ5Zl8BDsXWEbMxgqN2DB6nJy+uouOR4LJPMYvUcMrJUJlhPME+LWu5dP4AFjYDHuiyXfvIaJPyKVYJPwU8hlH11t26XfU2QK3v0dlZbQGQ+G+t1b5pei4OPVC0E80b4qsIlxakYsZxIWuofyPjN0kUmG3qJ8nvjW5YfsdnLTuz+DELI0mfwjNSz5WQvQa5I+c38DHuDJUzQml3Ml0sGO2lri9AX0uNmDSuqSn4qiboLc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwCIIAx4mo6GZthQ+QjcqFhumzsWIPnKgOakLMImHKQ=;
 b=k41Dm8qwXlvzycEkYfcz1gsEUDj6pt+wbn15npSZ3zcc6L1adYSTzhf5jDFfTIFIMVUsuzCRy3TvMAgjqTfRx3R5gHdMpJPBjVAlN8Aw/3sge67+c8xl1q5JseGs0OwyO65p69ZO6c5zvQHe7KurpjHrD6skBXIobKPFxO4ggVy5AaJbj6pTb1/CFewco4gjlS4/UGrcC6DGKgC0slTj5vfMytiFjdJV4PTgGAp6XGx7rz+dBPkik60mZJtBXuEVkgYxRx9OejfCC14HP7y9wMsQ6ZxE3hUSSEx0t1thcUQp1/wdSY/ts1xRp4lNmvcFubGAf+HN7R7oZkczPqk8fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwCIIAx4mo6GZthQ+QjcqFhumzsWIPnKgOakLMImHKQ=;
 b=iuMf9UmPryRn9IKJw6o4iSWAcMpZ0OSlg9oxzeyzb0FzCwb0gcL0y0rAzcn+i8cVSrd902f1uyd0vvrGjpTj1su39LLO6amfdmw2I3u3tSwmDDJqmPuhg9yRZ2jk1FkfCZGPHHm4T8NAnBAgNI0kocuYN/LGciWwtLeAKtoLs3E=
Received: from BN9PR03CA0473.namprd03.prod.outlook.com (2603:10b6:408:139::28)
 by PH7PR12MB6953.namprd12.prod.outlook.com (2603:10b6:510:1ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 09:13:47 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::10) by BN9PR03CA0473.outlook.office365.com
 (2603:10b6:408:139::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 09:13:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:13:46 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:10:00 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 11/19] KVM: SVM/SEV: Do not intercept exceptions for Secure AVIC guest
Date: Fri, 28 Feb 2025 14:21:07 +0530
Message-ID: <20250228085115.105648-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|PH7PR12MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b43e718-98c6-45d7-c5c7-08dd57d834fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s1q+xSPmM9EpQTuK9lYoha7KnAMXdsJPQzeeJBBHuzoVo+BZB1yK3YQMKdiU?=
 =?us-ascii?Q?vktUnNHlU8hAfGRVFNGNW7TfJhUVjR1IOUUh27skxp/SFIwomYBa+vGZtP9u?=
 =?us-ascii?Q?4Msd+LjqxBqt+pLyh5DKRfY65VITRU517JPHgOWaas14LWMtQbYe3liRCqqW?=
 =?us-ascii?Q?IAdaIEiGbjSrj0P8CPV0FRRjU0TMtC+SqZFIhCKoHkvJrLnRkRxctkWj+5Tm?=
 =?us-ascii?Q?Fwez8JJcRUwsS+4Z8i0xPdKkbbTditYQZXWRzz4NZ8kDW30Pg633gn4IpBU6?=
 =?us-ascii?Q?KgiujNyE8b/CCWiETwu3bPab2w42YBAcX1hrJkj6cy9sl3juupdPWzJsuKRH?=
 =?us-ascii?Q?92w3I2/vJw0Wlt8xXCURcUjIQ3zHRw9OyQmoSWRVgp7dwVDvS0XoGc8G9Enk?=
 =?us-ascii?Q?CszDKpmTGvilTtdGh+eNvlFhXYUPgz9QxG4qm//Rsg18qyTpkuYZGK/0/P/F?=
 =?us-ascii?Q?vIxVYdbNd4jgQUUYII1dGusbaob82r/T9aW6AthUYw1+NmmMuwILtoxAH8K+?=
 =?us-ascii?Q?lzz9y2sWAmXMLw9CuMJLDVxymM7ysGxOt/wqXt6S0gjiFHxhgvGkm9Nq3Dxe?=
 =?us-ascii?Q?ug10YaXAgg0C6MKNDzhzcoX6FrjrxNu6dBGaaCgRpY+fBfwaJ3ur31/e6rGh?=
 =?us-ascii?Q?/lV52MqSy4TIvTHYUAV8HNwe+RQ+4BslBm7VAQbFxJWnYzdINd0sfIP5tfor?=
 =?us-ascii?Q?j9qdI9bc6le6XFOHxa8McB+FpkNYBwmurlJNGhutDz1kGPcycNSx289QCC9W?=
 =?us-ascii?Q?h0j9jzb2aJlu0BftWZVPnhDQOOtzk9emKyzo25qqsLaFTJOVya2KOmxlktEQ?=
 =?us-ascii?Q?7wX4HBst9znNCyqqS/L3wg8O2qnwY7DQxzNUxtGkRv32xjvkK0+TH0IdKAq0?=
 =?us-ascii?Q?gmHv2I4TBsImC2vs7Vr6KK71jgGpPtf3gjfWGcF8Kuirgiz0REfXYglWB9Qs?=
 =?us-ascii?Q?lczrRGj9uYQty0Ejk+oIz6HEsdG982fWHsJUpzMhBjqglYYTCP2yMQfBmDiJ?=
 =?us-ascii?Q?adKpgrA4EHuvh3b4F9OVh7Dy5SpXZpwdQ+xFo9e1OOPlHLNeT4yDl0FrFmcT?=
 =?us-ascii?Q?45Ua1Qb1RBU7ooYSIWrafc8FNhlgcU6aZinSgltwsq9Q3tDR8WmasJQxz1Wb?=
 =?us-ascii?Q?M5KN+N/n1nGOyFptu0427twXdhDiDLBdi6igu69qpbitQHUqji9AnU00Z0oW?=
 =?us-ascii?Q?eJuTk1vgKNRw/V/SjNLPqmIcTKcv6vbZX7hG11HWL9dP0+u7dW0KmdX3tYmS?=
 =?us-ascii?Q?74hPKU1W1YGghr2bAOf5FSlKyeLfKijmK/cLfeFYyHxFYQLGcYO2go4BfzCB?=
 =?us-ascii?Q?E0eq5oliOD2H8bam4i5cof7rfjJYjb709iyh0gp6mouMbH/byDizlbfV/5kA?=
 =?us-ascii?Q?71LaO27/g8+8QJwcaQndQPvqidJRT2hskJyJua/9XuK+PPVhdAbG4syGFKLC?=
 =?us-ascii?Q?hcLcaMN+3rVLDe6AfZhY2+dih+LxpmTqdWDxCQgyhhI1ODlqrMdwUgH2IRbQ?=
 =?us-ascii?Q?Xkx/az93ltcb9J0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:13:46.9674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b43e718-98c6-45d7-c5c7-08dd57d834fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6953

Exceptions cannot be explicitly injected from Hypervisor to Secure
AVIC guests. So, clear exceptions intercepts so that all exceptions
are routed directly to such guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d8413c7f4832..5106afc40cc8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4786,8 +4786,17 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
 
-	if (sev_savic_active(vcpu->kvm))
+	if (sev_savic_active(vcpu->kvm)) {
 		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_SECURE_AVIC_CONTROL, 1, 1);
+
+		/* Clear all exception intercepts. */
+		clr_exception_intercept(svm, PF_VECTOR);
+		clr_exception_intercept(svm, UD_VECTOR);
+		clr_exception_intercept(svm, MC_VECTOR);
+		clr_exception_intercept(svm, AC_VECTOR);
+		clr_exception_intercept(svm, DB_VECTOR);
+		clr_exception_intercept(svm, GP_VECTOR);
+	}
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.34.1



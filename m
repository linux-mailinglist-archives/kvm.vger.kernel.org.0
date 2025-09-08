Return-Path: <kvm+bounces-57010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB34B49ADC
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535103BA8AC
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4752DC335;
	Mon,  8 Sep 2025 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NLn9yA1j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC626CE07;
	Mon,  8 Sep 2025 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362724; cv=fail; b=ixbHacG+G/vycSCPj6Tq84HKyNMtjgmEQ1CKdFZD3sHIdbT6TeKwPqQtZi1XZZ7tT+P2IOeDS7tWxnPZ0eVeKwhfJhSfDq+1g9W7GFr+l86i+g0gykkrecr9xCf6UR5Sk1NKQmqfb9UMdBpPovmvsb1IwoD6QdJl4Kq71EYteNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362724; c=relaxed/simple;
	bh=VQR2UwXrlNXqi7ANs3p4xxrziQsT7uCfWKWsThpCU70=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIF0vCqtpKLPXZlz0pkOnNUlebCZmPApTMLg8CP/A2Hb62LBl0PZGEugB4AWNIbBATONz5z6aM4bbO5mEAGCZGC72ldib206/XbV9D69nCGszOj+4H4kYc1WZVHPUWFGqQfPeVWDpjM/G3R9iWxEAo9AhWNSkrBwFqNNZV3yHqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NLn9yA1j; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSOVBE7fx7IPIpGl6wtEb4luSA+H+belAyv2ehezmhImkPE/5AC5Uod/mputyF/rUkonJCs4GsFq9Hg9vfY7CNIn1RFbBGT+OzCGbbZs/cpK5OYIY0wjm9U7ffzyzcFJEJyyKSSedf4nS0139cpydBmusZYu9QAjHOxTu92RjmiqWIA0mDtQ/kblqyF/E8g05ZliN9PBFYvzSVkTWIJzMyThR+NAjp80Z0gd4y4namvuNlMTdsOGc/wqrxOZOTiudd98+z2dthqu67+nGjotLGyGBT6HGtQr0g5ukYysnmwUhp77k/d4PMDIZQphNrBqGIfzbDdofLRWNVJ/PAdnFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zxrtNF68c0BSWwO/aM5DYS9TgQ/UKMMu3vg6JhnTRk=;
 b=Z1CzdyM3SqEFSZ+cjy0T/frhqUMUT+MKlmSEOkFY47t4PtiML6vBryz8axyFDNhBJH4zVxdY9M4Jjv/wjoHi3rA5jWzQyfGL2ukhq1wYvQy695tiUFWWI7ewzzMfzyVjg6EpOGUg3zrLTuRtQ2o8U4xf1AtE0WBwslg9mITzxixkaNwEe0ZYZt4EEmAsucsa6wk4TSA3S7v5121buk1V6hRkLQPMn4KM2XC1JRR0OEBvj0QtUYvACIdAesZDZNbt3c+lj39JZly2zELbdg/gC+h1U+yA1nsQLUH41mCzxgQ0k+9joClWIk3dj2lybLOoTN9N+ou+QlM367AML9VZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zxrtNF68c0BSWwO/aM5DYS9TgQ/UKMMu3vg6JhnTRk=;
 b=NLn9yA1jUaWWRgJxNZIm5ceWsXT4yvgWHcltOnecUco/as11kDrxlez1TWceu2lFiJQ0cMTEfRT0p5ZcgTcAMBLGIGyXOFDMv5Sd0lWh0yMxQor86asvBMxB7yNZEGmRjnZv+ibJkQNjQ8JJD7VOQYpEkkNC+Kia2HbPEEngcbE=
Received: from SN4PR0501CA0062.namprd05.prod.outlook.com
 (2603:10b6:803:41::39) by CH2PR12MB4214.namprd12.prod.outlook.com
 (2603:10b6:610:aa::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:38 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:803:41:cafe::d5) by SN4PR0501CA0062.outlook.office365.com
 (2603:10b6:803:41::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via Frontend Transport; Mon,
 8 Sep 2025 20:18:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:37 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:22 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 2/5] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date: Mon, 8 Sep 2025 20:17:47 +0000
Message-ID: <20250908201750.98824-3-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250908201750.98824-1-john.allen@amd.com>
References: <20250908201750.98824-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|CH2PR12MB4214:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa81feb-59fc-4ba0-eb7a-08ddef14e4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lJRYlWhMir6/oXlJPMe6cATJygf132Kj2gQRBxMphAKNq7gEyVETLru0WnoI?=
 =?us-ascii?Q?Avm77PYDiBdERiZBv18S2WNmll+LXnFLUzoZ5CHYEITTd668X3EzjFBfOn3i?=
 =?us-ascii?Q?Qn8t6LIBC3o0BXi79AnlWwMc5mRWdsqtMivQLhoAQNHI6w98zFTFpjOQ1Mit?=
 =?us-ascii?Q?vViCxLp2IlVMIL7yRLu1fAavyOGxUobCg+nvcdDNdgRt5K7fJyYMH3pCpDMq?=
 =?us-ascii?Q?GqkWYH8OhIiB5UWgk0TDeW8FUCQPOpKueLlRVoUDjp6WlN6Kk+XKJ3pqQAj7?=
 =?us-ascii?Q?MkNbVeSHyBoRveTNy8yWPFOanMX52l/T59np9l7NMo9TyumvgnO/UIaj1vLG?=
 =?us-ascii?Q?rVaJ4XKIiAmtWPAHOnV3cHGzdbhB2vqD3rTlGmK2mONIwIp/dVHx7rq7MbEs?=
 =?us-ascii?Q?L2CuSnkPd+e84siocRbQhzyeh+KfbPuRskvkD7ExHITvfq8OcuAUEbSKefdO?=
 =?us-ascii?Q?FcJNcN8HMdCjSgAjGFY6pzeUP9K55aQOPHJGYKXIribLExzpNsNyYWrHepSf?=
 =?us-ascii?Q?4CP7ByClk9iYvwS2N0soUl4iI66UsHsOtXtqDSgbk9/1WURGwQ7h/Gnz5W36?=
 =?us-ascii?Q?/CpMz3iaI1TZ50fg3y5ZuAs9swOGic7bCsc+imdunkznWXf8HITTUS2ezdmz?=
 =?us-ascii?Q?HeVvxhbtbcOJPQFcZFV3mpoKHlkaYWg0sVxNhKneaRW1DdZUILKCD5OnHEo1?=
 =?us-ascii?Q?xkBOI8xmb1QP1l0UBGfvrkPFNJvBu+IoAuzIG6+Vx3ae1YQT2d8oX/uQFTUT?=
 =?us-ascii?Q?6aH9dvW7K0pJeFEK9OcpfnswCo4Y3n4TSqWXqVwSJfW2xB6O3UFXlNOuse3v?=
 =?us-ascii?Q?MlnSppKC516fdOOcePtp3jPY+8CIMZuSP7NlhnNFQ14gCMw0yKGdm2q6zcJE?=
 =?us-ascii?Q?FICgJz1S1oDZTsu2Uwhu1RDEWFZzIISwDA7QHbe5E38GtybzBm/01Emh0q5n?=
 =?us-ascii?Q?N0KgmFK4BfNkZZxBN15Io2sLpix1f26c8sVcTIBF0nISU0BbS1VwtT3h9WPb?=
 =?us-ascii?Q?kpC9XhgUNpfVzSfqy/Zm5d6ZIjYclOl/nh1GmgzvRN4k59UDNMQHkc7c4EV6?=
 =?us-ascii?Q?toTgnU+q1d+pRmfbqXc3jGJAp2PPiYEqsfrddArjnkC1/EUaL3KyO89aj9Dg?=
 =?us-ascii?Q?GCJeYYrLIAHE2i87bbluzihKxouU+CVCmI07EBziXP3f1Zs0Hr2HUieTd6ZD?=
 =?us-ascii?Q?0rhQcwdIKpa2vrvBITHD1g4TIxLHhlVMHiwxnsLf93XKJfH0/sFu2F7FrD7w?=
 =?us-ascii?Q?6JBJ8mm08MyuJTlkrTBEPAz4qhM7rFAp9jAfSJpYAR8aUsLKz2bObxiDOhSF?=
 =?us-ascii?Q?x3eU+aOgpYOFHPHHjfzm6SMCoQQgwoLuZYrVJFill5P9LMitdCtBfhHaFf7i?=
 =?us-ascii?Q?5h6J3X6bcYLiFmGuY1MjAkQ4LruiwtUxBVWgynjSSEV5CFJ+Wpk01L8Fk2LM?=
 =?us-ascii?Q?+GoZaTfjZkhLmO9nFASNJneDiNjnZt9xQbdoRohX9tA9S9hnm9zwSSGCfxtx?=
 =?us-ascii?Q?3sJjM+qGF/8aAuTA6vlqK6Sfc2qVYL+arhdY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:37.5198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa81feb-59fc-4ba0-eb7a-08ddef14e4f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214

Add shadow stack VMCB fields to dump_vmcb. PL0_SSP, PL1_SSP, PL2_SSP,
PL3_SSP, and U_CET are part of the SEV-ES save area and are encrypted,
but can be decrypted and dumped if the guest policy allows debugging.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v4:
  - Dump shstk fields in sev-es save area.
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fee60f3378e1..aee1bb8c01d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3407,6 +3407,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3431,6 +3435,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		pr_err("%-15s %016llx\n",
 		       "sev_features", vmsa->sev_features);
 
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl0_ssp:", vmsa->pl0_ssp, "pl1_ssp:", vmsa->pl1_ssp);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl2_ssp:", vmsa->pl2_ssp, "pl3_ssp:", vmsa->pl3_ssp);
+		pr_err("%-15s %016llx\n",
+		       "u_cet:", vmsa->u_cet);
+
 		pr_err("%-15s %016llx %-13s %016llx\n",
 		       "rax:", vmsa->rax, "rbx:", vmsa->rbx);
 		pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.47.3



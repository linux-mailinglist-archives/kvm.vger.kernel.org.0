Return-Path: <kvm+bounces-40573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C72A58C41
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42BEF188C494
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351671CD1FD;
	Mon, 10 Mar 2025 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T5s7I6j2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC671C726D
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741589155; cv=fail; b=N7vZhh+WYQf0zy3x6O33J1VJv+uXgkalw9C+CUSqBfQmCSCM+C7bXiwTjrxcqoMT+V6jbv7e1XX4RZJtSKKIhub9dnCb+JjBGlyt+PPXWsw5ZEGx8q6rqxMbd2CsFPNf+8XD2LNYIoDOtdjezw9JAUdBHF9R/xg3bGZcMCT+EYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741589155; c=relaxed/simple;
	bh=J5+R8ODDGBaUlMdGfjy0iUs3DzKrLs/BuhUtNP4k/iQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VB+xb3W5+A8DkFg9q3FbbRjGt7Ed4kQnGoHqpbhXl80v2G/G9fBdcHH6WOboAdCELLynqEC5WkpR3h7Hlj5b2zY7TapS6xZfnmSUpHYgyWHq6Ne7D4R7aijjXa/cMUUCsCHU6ezZCwLa4/GVdsk6M49A/G2uxhtbGhu2UK0vXl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T5s7I6j2; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSKCMdBbROL6on6XWSDbP7NmonV3H4vTsqz14+BZr/sbTprCCfAJ06bB4TeTMG7S3PCUzOG7dN0ynNf02XnvdmbrXLMaK11Pa+S6I3JLaq3dRnMYU7SRA7OtTpexC/v3Fx2/CKfHN56L/v00sz0Tc0Aa73bpjlY2KNInM4IeLpfnF8UFbKpIAg2HB8xtiBnPkHMJs9Fefs3e4RjrKwynM6u+l89pcUdI9tUmtDfgg19J9koq10BNoBx7zjxs2oY18lXL4LE7tQtI4RfC05kFkFT3Kj/8JmOT+SgfXPZ18oWA5f4CT556Y9U2UPVmShXbxElrtbsNDuYO+UsuTo4pyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpTYS3MgzJOWKAvRKZHWNRO//ALZuYi9TSwTXg8BVgw=;
 b=hwCOY7OsY7ATV/u5i+nKKU8CltUi7YF29QPDL/apTgeM8lMVgoyk0NuwwIK930y1WRjiS5XD2hrBSFd8N1bZIMxMPWGCPeJzcF0mwVswAKcbEpl1gH+/1NupIAo+uSSn6NPBvFYX6vLLSoUzstcl0Xg39B+oZ+cAKTQgXgrOhITS7CwGWZMwKTnQA3O5pvOJaoIjFghyGTccorNck7oZSrNWAm0tEqZHeTU0LlESXJroS8FXXeIqVbX2tZeNC5dwzw1VieIfPud6uzHrowWfHYudfDcj6IWpRG607C3slqP7qF4qUQKAvbdVxRTvk17DsU376MNYkHJJmS95mlOdkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpTYS3MgzJOWKAvRKZHWNRO//ALZuYi9TSwTXg8BVgw=;
 b=T5s7I6j2SMl8GmK2FxnD/fp60oLZVIV0r/EZLEicwMX83PUy0Jt7F3VWKP73HbSFB2b/7CnggJA6bdQOfNL2MyVxon/30TXR6wbiS0NobnrMmTuVgue+nAsEwZxwJlLMV/gSoP3/OVOaqwHYY5OE8AUFvcYTNKe/7fiYy4EWg1g=
Received: from BN0PR08CA0006.namprd08.prod.outlook.com (2603:10b6:408:142::26)
 by CH2PR12MB9541.namprd12.prod.outlook.com (2603:10b6:610:27e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:45:47 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::7f) by BN0PR08CA0006.outlook.office365.com
 (2603:10b6:408:142::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 06:45:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:45:47 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:45:44 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled
Date: Mon, 10 Mar 2025 12:15:21 +0530
Message-ID: <20250310064522.14100-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310064522.14100-1-nikunj@amd.com>
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|CH2PR12MB9541:EE_
X-MS-Office365-Filtering-Correlation-Id: 34968d86-b217-40cf-71d6-08dd5f9f308c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wG7lM4XkAyBJu7G6bMVRrNGTcuPmZLQ8N31kVT0bAoQKEZVtSM3qunXCRvzP?=
 =?us-ascii?Q?9X1HVJu/LwQJ19e50H6kvm3y72xI//Unv18PrULI0grdr7f+KJzrheFGRCML?=
 =?us-ascii?Q?+Hsvfe5+9WIBZkf18FZ83Gl/97qZx/vOCV2SP6ZbVz3BlGO7pY7WaqnroKmk?=
 =?us-ascii?Q?Hkq2bVO7onUfI3QRueg8EbzF7jGnf43iztmkp5LblAP9a9TjEOxDBFwsBMoT?=
 =?us-ascii?Q?G6Ewll7I3PgphMFCc6RlMe/yN1DM0VLAreFrFd8KelQ1hmAzGTBVEvdNnL8q?=
 =?us-ascii?Q?DLkQfYPfci/cNR247qVoDxjon1RYyX7T5Xy2rGYMhuyKugdLATALBtiK9Wct?=
 =?us-ascii?Q?EZRtsb7YnPx8+6Df6UhEn9U0wVw3b3H7IrzT+ieVuZBVKLZ3JpFdUBTuiVZP?=
 =?us-ascii?Q?4XcjMZwm8/WCLTWu8lZombzNrQyML/Op9yi/VbifwPU437S6J8oFe8DVWh26?=
 =?us-ascii?Q?rX5xNpmPyamCgpMay/66BP/MQv1HuHLBhE5zt47PN1hN0fnnqURYrhL2I5jb?=
 =?us-ascii?Q?ieE0zeT+94l9jqNECknoyYSjMF1VYVr4ok5jN8R/Zu7QmYBFAUeOs31jzrqH?=
 =?us-ascii?Q?oao2Xw1UU0QNCTUR/KnDwvauWpIhZFDBHpdNSOa6NpJqPnFmgUJeJSqlK5I+?=
 =?us-ascii?Q?lnK96wKUmY0j6Q1J3pQZi1ItgN6hmY9fp4AJuX0NReLwfHyhMm/y/IBtTbC4?=
 =?us-ascii?Q?C6wG49tfHWzCa5QwutRXrj5djdhqcpRcU369nxD1Ani6LWVJRNvAbQr7brKY?=
 =?us-ascii?Q?3Pyks3/FZVQbMNIOAFoFzMScbVOd4gZ6vzgXRXfbv28a9NyDtLsf7CXd24Wh?=
 =?us-ascii?Q?VwQUFAm8fM/BNXUwrUjGnM9HF2gQG9HMPAIihKQssNc/2XVviGVWy9V9V4Dc?=
 =?us-ascii?Q?tFMEWCObcI/MaxhwPeIZktYTqGwertv+AK/dY3UAkA5YSnv4RSDszhjpR9Sf?=
 =?us-ascii?Q?HPLqw3DgzeVBLIGuf4doqSQtlzyqmjV4bIxQoOZypeaskh5tC4QgIYhafF/+?=
 =?us-ascii?Q?hnUaif6IRhLgldktg9tR2H8UmdlDWWjnTRBJdXZ2p/PQ79mEpbuq1OBWNIfY?=
 =?us-ascii?Q?i4z/SqeFZRy9VnGDCpfKlC5NKUqCnUDM0qF1Ih21LS4MG0ouRo9cJCC/vdaN?=
 =?us-ascii?Q?bAAGl8aW9Yp4CmzxiMETyibvT+3YO5indaT7xPxj9kVmUQkzDtFx2r9LY/TJ?=
 =?us-ascii?Q?8RjA7rZEXdtUBkXCL9np1rkRNG/Btfu7zWHDgxKHCYCCYD7wpfaeYDV5bhqM?=
 =?us-ascii?Q?oOHQp90pY1LrGK0wEqudHoHk0Q+xsfgJSqwK0gYkLdZpsQIxBmP1kZWYScvL?=
 =?us-ascii?Q?23zyyJC5qCYP370VjesYqxOYUviePN6yjaWcjk1J7Pho4T2HV5YQatw27A1a?=
 =?us-ascii?Q?eCxVJyKX8I2aPsk633ulr51iN8t8sX7W88xVhvn1vkrqeQlwRopP7TtJhhmi?=
 =?us-ascii?Q?RyLbSa0v85AXGGTt4aEyaQRG84NiR+mAcK12oePG04g7Wct5zrNPL5gDJX9W?=
 =?us-ascii?Q?3HhdM+sKX3lTgKs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:45:47.4959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34968d86-b217-40cf-71d6-08dd5f9f308c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9541

Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests. Even if
KVM attempts to emulate such writes, TSC calculation will ignore the
TSC_SCALE and TSC_OFFSET present in the VMCB. Instead, it will use
GUEST_TSC_SCALE and GUEST_TSC_OFFSET stored in the VMSA.

Additionally, incorporate a check for protected guest state to allow the
VMM to initialize the TSC MSR.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/svm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e65721db1f81..1652848b0240 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3161,6 +3161,25 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_aux = data;
 		break;
+	case MSR_IA32_TSC:
+		/*
+		 * For Secure TSC enabled VM, do not emulate TSC write as the
+		 * TSC calculation ignores the TSC_OFFSET and TSC_SCALE control
+		 * fields.
+		 *
+		 * Guest writes: Record the error and return a #GP.
+		 * Host writes are ignored.
+		 */
+		if (snp_secure_tsc_enabled(vcpu->kvm)) {
+			if (!msr->host_initiated) {
+				vcpu_unimpl(vcpu, "unimplemented IA32_TSC for Secure TSC\n");
+				return 1;
+			} else
+				return 0;
+		}
+
+		ret = kvm_set_msr_common(vcpu, msr);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!lbrv) {
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
-- 
2.43.0



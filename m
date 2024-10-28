Return-Path: <kvm+bounces-29814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA769B247D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B58B283F46
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6675C1D5CE0;
	Mon, 28 Oct 2024 05:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aazIxmqW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06CE1D54D6;
	Mon, 28 Oct 2024 05:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093765; cv=fail; b=OgzGFimKIuZjqa49W5AwQDuwxAUbqEFZia9+LEzt07HZsDPrsl9WZZRe40smL9fgg6GS8P66JZkeCaC+pFp8RGUhoe8TmHT0C2KbeIKmMN/FA9M2I2/8prBgfmQel/YQ0ISn1W2dxl8N87rYxwMFFtdiAO+WLBtjPVvTSH8Pu8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093765; c=relaxed/simple;
	bh=J7ITyZv4fTZN+ZfiudI2wlQZ6XlSSdAR/6O3kPxxatE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q3ojP3ESl6RN0JVfqAdpAK940mmLhMuJslbf/D2VM083V5Ml+rw5hpH/WCFvYVZEQ/eGKy4QmSi0168c6KrBNkn388urSZwI2wEIXrqDIecRUZJfDObLrRhOFfYgvAYuxnoAcVtEn/zsYWvgeOz8QHhVk9c0wizv3kZkbK3ZJKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aazIxmqW; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qTqkiiEumCFD3x22vlbq6cdJTxDDxTro7caHZXRpaFs2CtAe5m4WdmR70BK4beqGj8HT70WyW9u+HVpjgEiCg3GRuEFtu2v3d2hrnw5uyP2wREAK/zYqKYZC0RVrci1CX5TPLYhJmbfS9zNmBpXAWAbp+rHXN00Bzu29DkXagf4629CVKdXPrfNQmwK8emDynmt8fa4XIO2t0dJni3/fVHBZjmBUD7JFsTURDhe+c9dAMTFT4XpoStSVqO12SKuS5xyiVb97LAa/WtntoQQGSpHqHghHaDEm639ILzI88oNTnbkAxRYCv1xevyIPmeTCA/KLOyKWzu+SF7nBNZvCWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=OFYuxfmyzKeo7p0gVSIfTsaugW18CzmZuKU3zX6H316R25PWWyxS82eXPGnJ3wnzOSOPSZWLdnRcCNTa5CKpopDI0Q6+Ndoc330cj+mdy+XRtLo3bj7KWtcP/g53+9sciYcpeGt4hMGlgxbkLORohcsXQ942Zh/CjnZHw/w5Dd0sz0NrlmwidqxW8pdl1Xfd2mrp2ziLgEv0Js6omh+dK3yCYKWu8hyTHfB5T6VFyUnr5Vnkb1HtgExk1ur9CkxSojS6LQLOsTwxeiQcWJcTrCk61zuTDYGyxsLTienyuNQN7Cls6q95e1VfmEbZa8PYcd58t+efHBLK/c2+pi7trA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=aazIxmqWAyBdlhVayXe067K2t5WhQu6IGClil4y/bywDnD7orvvnZ75mD237d+sZ7zk9ciAeuDvRkhvk6+u9IiZ6JXjs3YhbQ8Xlr4MxDHst1QGIjWU4yfkVb2kUMqwoeCZtWRzNz+Lbve1h8gj0GKG8waj0p9Yyo3l8q1VIhSk=
Received: from MW2PR16CA0012.namprd16.prod.outlook.com (2603:10b6:907::25) by
 SN7PR12MB7371.namprd12.prod.outlook.com (2603:10b6:806:29a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 05:36:01 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:907:0:cafe::3b) by MW2PR16CA0012.outlook.office365.com
 (2603:10b6:907::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21 via Frontend
 Transport; Mon, 28 Oct 2024 05:36:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:36:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:53 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 13/13] x86/sev: Allow Secure TSC feature for SNP guests
Date: Mon, 28 Oct 2024 11:04:31 +0530
Message-ID: <20241028053431.3439593-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|SN7PR12MB7371:EE_
X-MS-Office365-Filtering-Correlation-Id: 959bb9ed-6d77-44cf-7112-08dcf71267f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RWvUNBW7Z2WxICWH/8rz4P8vOLZF5Z7u/7MW9VD0ijtvbTNComrnugYuYi9E?=
 =?us-ascii?Q?YYxbwl+KYRwXxl52lXdxNrZOxf2I8feeJmsk7jYeL2Zl6jch6cN9+HAEA8I2?=
 =?us-ascii?Q?VSf4hLKNYvF05aJ9uTgSK3KysV4yJLoy49kCpUR6bnl7I5SD+J/t0GzRM1zC?=
 =?us-ascii?Q?dvW2NNMsp/KCpJjbF6nw3GsYP1ANdBJTgE8nadZw7ioWIjgBrddpCIlIbrNu?=
 =?us-ascii?Q?YuUt8CfhcM+1I2hSrZNQfPJA6wJx7b0Z+ByW6niY3lGybQ79ofExZlncY428?=
 =?us-ascii?Q?FuhkxYcLzezHVUuZz9KVdu30g7AfLuu7HqpXABKGuBuvNiD+a6bq63vCl5Nz?=
 =?us-ascii?Q?d+RdqdcNGhzGcW/VeZWfv08ecJ/kfXnNoFHmPhwzkgpaczw0FGhggFLo88pI?=
 =?us-ascii?Q?MjcXG19CURbkgm7t3zF2JyIbjCDQ56yPfF7czowBE0j1G721+A1mhTIWKcrw?=
 =?us-ascii?Q?dSTMj8sQYZPQE1OqAo/0heNDh8+w+PPVCAIxyuUWuZM4CV5iwv3SaJ8nvfay?=
 =?us-ascii?Q?7BVd8kqG4Ql2M8b3s1X150yoxaqllH6hVD02aOzZUg9zWEXzvdlAUaxr1vOi?=
 =?us-ascii?Q?jnQSW6q9tE9+vftv9ZNV3fPOtpeX46+KNzsXkxJhfamy80idgM4smR+PpNlp?=
 =?us-ascii?Q?ISCZdk4LANBJMaTiDpWpDWq2J1MlVkbb4+3/tcMPRJMax6RqE+2cwH3Vx8lT?=
 =?us-ascii?Q?V6QaVQ1gQxzEHuvcrzqDwWvxD64h6o6v0/j0sbaaGqMuhLlTOXkmqaKE7heN?=
 =?us-ascii?Q?uGPuAM9HeE2qeayPoJsxcdhJFhAamcH8km55ZaK3/bVNXwAYcl6mV78dh+z4?=
 =?us-ascii?Q?ad8nwJrEyg8Csrwb1GjCFMvu8IyXlApBmnFDVGx3gDKRbXPkalVQthCr7FB3?=
 =?us-ascii?Q?aNX5wjS2EAoWQIiqkB/9bZZ2WdPmJuxQVkF0LB3ABItzoFDQQBirHHPfycbL?=
 =?us-ascii?Q?ftEgyww3Qe1aGpeMhThyAxhd5FaAL8/gpAulRBJYPsIWojDs84bnf8c4Pz3j?=
 =?us-ascii?Q?3igSsf2k9/ilYGkoLmmDKUjYKsfutpL1o9yihLzy/XnmqU3HMXoyTtVCCWLK?=
 =?us-ascii?Q?n4H4IwJDlzFedWEFCQqFXDYFSZHhYL/v7iR3M9oKozTQs2F1OthT/7B0XNdO?=
 =?us-ascii?Q?uggLTdw/uieDLjmEN27iLbo1xQt2uReq79h6Gw45+R8qLeUB/I2hYpA6v9Mu?=
 =?us-ascii?Q?W4eNhLAkB42kH4U7StIKkbNfJRYEaPeAr1RjHedv08CYSdZpPgchB50H3kZA?=
 =?us-ascii?Q?uayAtTmTaBga9Xgw4HvWiGu9Vc4kgmuHHnlgGf2hZ5fFh9HDv/Vh6UpHm1OB?=
 =?us-ascii?Q?kFLTLIcjO8gpHqPuOQmR/mlBl27viw3iDg/DXD0AM/wd9Zm/+rum97Qnv2gR?=
 =?us-ascii?Q?ctsaAQmwfzVxEiJb00BX+bEdpnER0oAti/UMyirXAPplwTcBLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:36:00.3619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 959bb9ed-6d77-44cf-7112-08dcf71267f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7371

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1



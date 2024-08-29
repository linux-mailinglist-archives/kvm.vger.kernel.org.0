Return-Path: <kvm+bounces-25327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B01329639F9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D56971C21CF8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF4614A0AE;
	Thu, 29 Aug 2024 05:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GWKqD2ug"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95D01494DE
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909905; cv=fail; b=YrshnwJAOymh63+l9OkAjBzZZCTyJ+9k0th9ht9vE3bxrAvp0O7zM9YUFVyrKcYRVxUAcaS2EODOzUqfEXeTTEC+OeJz72DZPqawSZ3g/XTttQvny7Zczcj/TxkrWqdxi37f6KdRgOyW4N9pH63vrCFJbMLqzAgSJxNIyRoXwf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909905; c=relaxed/simple;
	bh=19lZxip+m/BvusFpy6+HU+yXm4CqMNti2X8D8waUzPo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEWrQBMfpyVfhp+W35Y5EF51Py0fd0Wks/2DO3QWL55cjJgMWdRr7gXqSzH3ENWBdWtWQ9jScKBmSkF4vIpb+iyLPBCYEJVUJ50/rnZ6i9h0FYLbidjV3kGoD5LjExoxeML6XJuZN+cK9NUQFRzkkVrZiWz9B7SP1Z3HItrE3Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GWKqD2ug; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjNA2/D4POv3yzKdT8T8tPulG4w1UkNv5kPfxEZLjFtdqyETASgS2y15UbsklWnqIBN1ECkIv8xhtXB0Ov6d4JwzYMvGN6U3R9oZmCztQD3f8SjvHgJw0t+iFCygZstKmE0j2Pnpw6zM5GRf65X5fkpMdSFO6Wta/1RxOGf61pVD5rcltvJkdh6i9o+92IOPkmXBaUUL5Etb6icAJGz+KmIYISymNcuXpn2ni6kUv2RXWUtHQcdGCYplbHCfOlo086Bqmgd9wgI5R7qRWmqSXEx1s+vjjhSmqlc/zuREOJVxMcOH5S/7C0OrFja1/gWNYKvQGXhRuT5sQGcUyPu+Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MsZ3IxFreGm/g9yzgSf9GQvqML7BP+dEu58wqhagMo=;
 b=Wqe8bsVTr9MR+I566lsNgKp6VF4U4u5zj/CN4F8P8s7GezjMZG8uDtgw93j2N+xfHH2qi5wDp1Smu1dHYwewr5vydVgI6GLeVo34SsW6bbORgncnp7TwEzY6y7SFANq6kl0LVyCZG4LioPMzQsqDWZK4RrdQUvGrJ0fl6s+PpL6eXlf+MjxcvYYHyvSmtmw8YmfBDPsqAAALK69yT00hPVEjJgUtGwrTLrZdd2XNpwT1xNxxth1XzQPEaJ55BVXLfq+wd+GIOl70KPc01fGvqXKP/K3Qr+GwFTmV9iYLKqgE0SffXTonSSKfDqh1c+C3JPHbd36SW0n0Y27+Lfq5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MsZ3IxFreGm/g9yzgSf9GQvqML7BP+dEu58wqhagMo=;
 b=GWKqD2ugifaCDwo3u5ukQN9WD7kVWJH7fEY0EbrcXAwxy2Ares+up/guVGD4uXMOYNmiwGQR2ZiSRM3kyor5BBQYk/E6BM2MoqEPwVYR+I0PEl2XcAUyWRo9y0Ef2mg8KaSp32kIv9Yqhjxzyk0wAjcZdkfUlLakSOJ/OuSgTi8=
Received: from SN7PR04CA0081.namprd04.prod.outlook.com (2603:10b6:806:121::26)
 by DS0PR12MB7703.namprd12.prod.outlook.com (2603:10b6:8:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 05:38:20 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:121:cafe::c0) by SN7PR04CA0081.outlook.office365.com
 (2603:10b6:806:121::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:20 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:38:16 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 5/5] KVM: SVM: Add Secure TSC support for SNP Guest
Date: Thu, 29 Aug 2024 11:07:48 +0530
Message-ID: <20240829053748.8283-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>
References: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|DS0PR12MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: cc19d00a-d4d8-4c30-4c7e-08dcc7eccabb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6O8QYYA7MDQur7tkQTlnDWzoNEAZ4cjjxeaOPXRZh6Ets2bo7bu/3xWLBou8?=
 =?us-ascii?Q?hRNhJ3FGLPfZ3+xGLzu55PLmaF3YqdQubAxvm8KicCgSoGspKY3vPxSQXrgQ?=
 =?us-ascii?Q?XtVZmJaEUt+5igfwKunYcqQPdK1x3/pJzQO03Bvw8GAhVMX04v+dDD1vRt1s?=
 =?us-ascii?Q?VMahLVv9FlhYX4xONz4YEnhURs3508ZN5X0m/AlMckrRGeBBc5B9TuzEJgX1?=
 =?us-ascii?Q?+KGzuwXs4b8v03xbiCPeCpE0kZw5nC7ZGqTr5ZgheAsrkZ29Nyh5uD9Th1RK?=
 =?us-ascii?Q?Tbw1pwenCxRiy5Yl039YOXbu8j5GsHIQjyKm9AVxgEMLyVvZBL6yCuLvh9mG?=
 =?us-ascii?Q?aWl7Boy1q11eCgZQWSAa0sfAjSCzgsM/yrohYtdpMeUXMP2WH3UHmvwWJLpK?=
 =?us-ascii?Q?llLWnO3qOv7reJagvxclFsE3peJD0xbpPQCv0V3Fspa4kn6AkHbfQOKSYPca?=
 =?us-ascii?Q?0TM615nE43zfiwty3MHLV2zdzx974FLorPyha4ZNgyYKE8nz9+z9kxe+lcV0?=
 =?us-ascii?Q?N7+L8A3XJr+fIzTD/aBDTQfOVYw2XbSLufd60WsjSuz07WN9MUO6DOZ1/cro?=
 =?us-ascii?Q?zvNfJbkd6Q7H3cN0oBQSme/at7rGHNXaYpFVmniHHNxW52iw14qT6KrDIGsp?=
 =?us-ascii?Q?ffkgeAWImHuyGRP/W6yLMqdv7o8doP1/PiWBkS+usY6NTXzLElFEoWnwZmA4?=
 =?us-ascii?Q?aTBXIh0z32saK4lCP2gY8OdX9jk5wpN7gJ4ENepwf3hNykY7vUyJTE0yuOJO?=
 =?us-ascii?Q?23DuGiv+J1+Yrqkatxui+ZeHhNsq/dRPHZPxz9JDLkh0rb0l5JEXlHizZoFq?=
 =?us-ascii?Q?7sT5LhI1ESV3ZRvPoC/E3IgV+e/QsTVg0JWBb7XsEf8XjmEOQRZoQCq2P65L?=
 =?us-ascii?Q?yo+HiMLzqmjwUetH2Ry9ORDd6cXGDX6AhTTQY9DVkdH6tm0/7Cl+ERn6saLI?=
 =?us-ascii?Q?wNiAh7BGntC088aOp+P3AIiT1QREQ9Djh1dT43LAD3wTpjf7WSDjlFKXwie/?=
 =?us-ascii?Q?hxnMX7WNtTen9Yw0OSw6T5H47IDbdbJ/dkWFGrxlGkMPyrMxaW7nHL7//MuD?=
 =?us-ascii?Q?WI4tmZTUMs+nJnybxGDytnuGc+Ydm9xbcHCKTh+UIEQ9etCeB9qae/ZgsEiG?=
 =?us-ascii?Q?xOpWcApKc/ydwU/ArayUbMPHvCHham5k+3GrtF2+6oXwQmZO3QpvVLkIUoiZ?=
 =?us-ascii?Q?7tz2SETWknM+AKsmgIb9Dhrig3QA/Tny2Yn05PfRQgkFzv9wC//SPbeBrttf?=
 =?us-ascii?Q?s47O3tb1/9VCUAR+gn/EFgttNuoJfGcne8cTI5IYjYaDMBtEoGSeDeJxgzYH?=
 =?us-ascii?Q?eoQyfDfhkfsZKBkUseOWfz+VORmTiEzTcV4qx5g9P1AptTuv1mzGVpnXwQ2h?=
 =?us-ascii?Q?IK9vdcR4mTyyb9nNe2CXz01hJHocpV6CTdbiHgn6M/aEQN1+up2+UvbPB8O9?=
 =?us-ascii?Q?Sgwut0gkVxZQ2RBcJtvkmzX1NnsqlWAr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:20.5062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc19d00a-d4d8-4c30-4c7e-08dcc7eccabb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7703

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Enable the Secure TSC capability and add it to SEV supported features to
allow the userspave to set the Secure TSC feature for SNP guests.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9adab01d9003..c37fcd164413 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2966,6 +2966,9 @@ void __init sev_set_cpu_caps(void)
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
 	}
 }
 
@@ -3088,6 +3091,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.34.1



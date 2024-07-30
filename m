Return-Path: <kvm+bounces-22685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 719EA941EFF
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26E3B282F27
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EF2189906;
	Tue, 30 Jul 2024 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dSl5KJk+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE61A76C9;
	Tue, 30 Jul 2024 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722361689; cv=fail; b=SztzD4zGCMfHjkAG+mL4eKkKz81WGCELste6HDJfzWZD9uUxZJmy/H/QeRCgSMSpc8E27yg7p8x39SgYUkvekOvIbqIpbcXC9ppwTpJP89vMifPQfkTk9UZLSRYx/IQ4b677qEXbNfOMvbYexpy/Nz+yxrHdZDMfw9S2Y5GrErw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722361689; c=relaxed/simple;
	bh=UVdOoDqkW+JfDcHohtmWPsPUJfYRRob821dht5pIB9A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VD2nbiyFE5NBQnWP/pCpWsL0yeZ9X7oU50kCO7Wz3WQVNOJfZ9mCdq80+1ynfzKk5Xun5cxs7xCdyuJ5YksPZKwCzT0lpMn4foL0WsXW5HG1nDdK5Puy4WTPX51EVy+uUaZUcIfhX0r00lSYe1L+QPh6iaK37iamqiwH5E+8U2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dSl5KJk+; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQk+EbKabk+C3qXUVfa4nHXAFM069gVob0RE5hKR3a7SWkIIimDLfufQYwud+NNpYLJHRhOLdc39SbzS1AtuPXmxCM6IEu6ASrVDoV6V5S9ILW2Sv/FhOeyY5/fS0nphYTglhKvzqotLIsL4ccZzw6zHw4fmiwJ2N2REeXaxy94me7tTJPEf/glHPSR3KJkXHeHjZAYodc0Yoa18gvYjPJ9ECt+aI6zfChOnSzabzc+7loCscCYPTC71e/ObOc1kH9/3Xww9FIqqaS7w35pD1LrgVuXWmHIPAmYK3E2RZQ+bwvQORVhsQH1ReIGU57kkvOSI350jaTX7nqnDgMaVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIy98NjlSXC1ND3boF3xg+apJfE2tn3TX27mS+JLVIs=;
 b=Ketu7yi2ahDx1q8rfybPsH0+OkNBFYtqauJQZfdzuurG2c1P5Jjm1H5awcii/iqHdv4uwZ+2Ypf/XuLSS6T1rXqvpGkQei6Ev1QQByUFkshAtlDWOHUJPLIdL35c+/yOXkFuCWsOpyuvftzpuCg5HuU6DtRMDaqPO7cPUCMtS0Oz33GgbhGpKbz3C909A06WwAUwNEfd26jmjQHeQILR9oCfWsLi3PUjWkK5r8yzwjT2qj23pfqRfokWUn0ofeanQ8+2lU1WS346OcuVWN++w72lwlB+RIXqmX27zYgazWFYpw0kdzueg4DgE47WdEjXY4RmffH2wsIYkEuEAHg8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIy98NjlSXC1ND3boF3xg+apJfE2tn3TX27mS+JLVIs=;
 b=dSl5KJk+gLK+8u5zXTg5MEaiRDKHfZIynWAcGEukDu4rNUJMN2m2CqY0xruIpfsZfDd9Jr2U6ejoALje6jf2oNrlGOE1WXsV1K/Jevr+7CN3vDvWRx0CVk2LTKPceBzf2D+/hvdRhgDNQjGW6VfVYtOcySOxVLLWQNBdkANSDMY=
Received: from BN9PR03CA0516.namprd03.prod.outlook.com (2603:10b6:408:131::11)
 by DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7807.30; Tue, 30 Jul 2024 17:48:04 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:408:131:cafe::6a) by BN9PR03CA0516.outlook.office365.com
 (2603:10b6:408:131::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Tue, 30 Jul 2024 17:48:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Tue, 30 Jul 2024 17:48:04 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 30 Jul
 2024 12:48:03 -0500
From: John Allen <john.allen@amd.com>
To: <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yazen.ghannam@amd.com>, John Allen <john.allen@amd.com>
Subject: [PATCH] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
Date: Tue, 30 Jul 2024 17:47:51 +0000
Message-ID: <20240730174751.15824-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|DM4PR12MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: eb79fd1e-2629-491f-2b3d-08dcb0bfc355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IhUA/Ln3Jtzc+DS/swtsyWi+qq8og7oQcNHQ0ltqpwBCKw4NN2P83tnEhnml?=
 =?us-ascii?Q?304fLRp40X4a1JQA4q+g4PqA1RUUNmFv9y0CeEwpmZ6rwJOgHSkmq2d8JSkK?=
 =?us-ascii?Q?+7fysIxDq/nNmzFaRCCl4qa1nT6WAIYHJwOGCUy5ejPnAlw7Gx54hET4qWfc?=
 =?us-ascii?Q?hx+QqUGhcCAMaeZTXYywrucXY7cEI5J7Y6FRWrtNdhCw16Q0e9us/JvUVZnR?=
 =?us-ascii?Q?LHoU/BGx/VuONpGcy6evyyp9SDZ9z9qSa0HNz8LQdqB2hO2P0KWrIHcm0Atq?=
 =?us-ascii?Q?5uDg8odAI0P747ChGDjpSkefmot+h7WiURHrTi7EaJ3ymanJ7v+gdjvljtX5?=
 =?us-ascii?Q?W02zQ9GdpPexw0HhrVW1RavdEWXsoEgofWJ69ZQKIV6+bsRumcFh4ZHGpqt/?=
 =?us-ascii?Q?dDacwVQP1oBcGy9X47tKjmFxdGEdEwJOH5y+7+RVq4BXktPyDc0KdOnLxtLV?=
 =?us-ascii?Q?Nh8CIaEIXONN7ia0ic7Q8zsLNQK5CCeARg4ATib3pcQVjtqDpTDs82/5HzSn?=
 =?us-ascii?Q?IJKGZ9DNWyW5TpJzUXYeErXOOsvxZcL4jQnu5y7jVty3wgeCwg4i8idsmoHc?=
 =?us-ascii?Q?hNeXYgQVP3eG2YTfksOYh24OTubqsIBb1OXqqFTHbrykldylCfNynrPULGCr?=
 =?us-ascii?Q?CXaOPp2cP55vwfdX0rXQcxBb5LJFhchFIovEaMyE05Q54uCAh/u6kmpeEHnF?=
 =?us-ascii?Q?piuWO+gcNKNIe2jX1rZyt2V7gEeIu64LXI4aGMSxIs7mCCJ4zcopYsYTq9sv?=
 =?us-ascii?Q?jKp/d6VB7PXryRW4SaL4+vd78wdD5tnAqgy9tns9cf9ikhHWmBpXZ06H2Efe?=
 =?us-ascii?Q?dLLwvV3tcQEPV7O4mcNDX6chdMQM5uOljatz1OdLoXqPcUjwxXzFK3WIg+1x?=
 =?us-ascii?Q?DP29wJMSF+1ZOPJUrf6EoN50s3/vNyGbtkhWLrxBaV0NQpNc5Sp+zEt2HdpO?=
 =?us-ascii?Q?NobpU/64UdogVw2XOAA2kHnob0xpQTxrWalFNHIwxBdrt20/txXx9p4xP/RQ?=
 =?us-ascii?Q?GBk+EIbIEpVTwQpAKE/IW8NU9aBx2k/86SkK0iDj5bwFa1e1uoP4bPiwZUaw?=
 =?us-ascii?Q?HHV+LtYkXvHoSu8MkYmMhe02dWDcFoM15Dtcahs3GeCRLgzw+DglwzXgTbpi?=
 =?us-ascii?Q?sdlqCYMK2CDqdLBi9VLzG9lmBWqdIFGwPkixJ/Nc1pDXlD5EEDbH6hUoW/It?=
 =?us-ascii?Q?q/ocN33RVhVSkiojDSMI6qjyVMPH0+90KzWx2/aFOfvXr/aUb2/wUE0vGKNT?=
 =?us-ascii?Q?nmSroELh3ZciKtEvcl0Q6Wm/oao6ptS59W9bQ4Gpta9IyuaqreioCBDl/YKH?=
 =?us-ascii?Q?JNIBApyvpiQICLUczvqTggX6IMpRm4mxy23tKtA7NxhjtETVu8EZ+GMYum7n?=
 =?us-ascii?Q?8d9dF1FVyeBwmw61ngGi8J4w8/1jFJ3Y+gPl92yC5g4zienE1thOFvJbMwTr?=
 =?us-ascii?Q?3+Wpy0dH35QaySykvyPf+grCexvSWjsP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 17:48:04.1211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb79fd1e-2629-491f-2b3d-08dcb0bfc355
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446

Handling deferred, uncorrected MCEs on AMD guests is now possible with
additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
bits are advertised to the guest in KVM.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/svm.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..4745098416c3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1241,7 +1241,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		/* mask against host */
 		entry->edx &= boot_cpu_data.x86_power;
-		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->eax = entry->ecx = 0;
 		break;
 	case 0x80000008: {
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..a6820b0915db 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5199,6 +5199,13 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
 
+	/* CPUID 0x80000007 */
+	if (boot_cpu_has(X86_FEATURE_SUCCOR))
+		kvm_cpu_cap_set(X86_FEATURE_SUCCOR);
+
+	if (boot_cpu_has(X86_FEATURE_OVERFLOW_RECOV))
+		kvm_cpu_cap_set(X86_FEATURE_OVERFLOW_RECOV);
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
-- 
2.34.1



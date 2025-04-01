Return-Path: <kvm+bounces-42311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A81A779C6
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54ECE189066F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72A71FBC87;
	Tue,  1 Apr 2025 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WxE0z0vQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1D1EF395;
	Tue,  1 Apr 2025 11:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507609; cv=fail; b=JQytbNvxsDpn1QJcOjVumjwyKcxbyaMs/dw0WffHESKDuxU5B0+OqMiPh6eYIMqOfzrqTFDrpXa3tM46XHGNLN+6MJCER7XH+O1fKtUaPVd9u/Ne5w35eM1vo0dLXjCCjPidOWKab1sqaUkexpalixB3ZVKE1PTUS3piRxDC8Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507609; c=relaxed/simple;
	bh=rnJ3uHkek6YCNu0HufrgGTVLa3+HIHV/kCfVlf7wo24=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ulE3S8WIriQ+dXnfyxn8FS1+dAZ7mQPsVpytDmMNrbg3PmTPa3wboI+oowwcZfjAJh6ODRnbcpDnPWrI09eqIOcCsxmisS7D91wLdDlW+dnsejf2IYFnjKchtl6Xz5fiQJCYEjuunBPvbMuq9vgFssKeVBTmL4O3YnOUJDC2ZsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WxE0z0vQ; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vU3NpuMM5nM4BFbchQ+JZZ+YJaIppcQvFUHKuL25oUxhIIKU36Ai7o9XCyaaoAjdbvAh0GvQkhqrEEwJCfOV+hiZ59y0Ixe/I7zgBATvUy5BbOSGgz3JribIjKz8VheHUOgje1Pu1joyRojhOCJoIcOtcJ8sCjQ3hzbubGVBJmjG19STuw3ViPEnK8jGoxnyA9zXWc/QzSI1TyIQ3ua/uvYe0ux+x9aq1ApFTEPvRAO88wUpIV722bp5Am7yAj+r4gsyxxNwzW1ZakNM4+9uL/492k4Y5BbDtIr/WKZ65rkQh32ITVdAUgRAjISzPaOdpL4e2vgvssp/na9adcw6fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynjG5hX/apCf8xGpWnwVDuZzJnKio/266tn80B9kAGk=;
 b=Zm41gMtmP/SX1C3pQid4ozTi3HGarTx8/lf9LQbikGakJDNlmD/JdGG2w3jKoNhjclYuXcMii20MGlvJGDwvPLJne2sfquXPjCXXlZINVEjTLjsuSE3Q2OGj23sWVMsNdBtiaN6YP4cJdqzKW4kCF+JeMIXtc28+rdQ3MpEsq3ekA31FnzvfpOpWJ4pVdEtbG6simhykHBAWmfb1PTAAsSVZmtDw66U8EJr9uKCLtXCW6xkIoYH60CfE9wHuaZv0kkJT4by3y0amf4k1dP6BsXCf/plQ4rZYR/T535/tLg6048tztE0yPmmaO3ILji7hm+hXlCwZc0wO0NiofQc0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynjG5hX/apCf8xGpWnwVDuZzJnKio/266tn80B9kAGk=;
 b=WxE0z0vQmnh0scUZq32FNqmCUcHRARuoAMuSlCd9Cfo1wz26MFQ9FZsp5oOzCVT/ZWtCqO/Knz9nWIVq53u3NrrnYxC2QDwq8cr2ywJMVXwVF9o2fN8XoJzcMkEFtO6MqB85MAIEOQuN/7Xr9CRW5Zl/1QjXelYRO1sadTqXlQU=
Received: from MW4P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::31)
 by MN2PR12MB4317.namprd12.prod.outlook.com (2603:10b6:208:1d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Tue, 1 Apr
 2025 11:40:02 +0000
Received: from CO1PEPF000044FB.namprd21.prod.outlook.com
 (2603:10b6:303:115:cafe::cd) by MW4P220CA0026.outlook.office365.com
 (2603:10b6:303:115::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.38 via Frontend Transport; Tue,
 1 Apr 2025 11:40:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:40:02 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:39:56 -0500
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
Subject: [PATCH v3 11/17] x86/sev: Enable NMI support for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:10 +0530
Message-ID: <20250401113616.204203-12-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FB:EE_|MN2PR12MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ced0ff-1d17-43b1-54ec-08dd7111f0a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fip+Ko9YNAQbM/hCMBuVYbZ5ko1Cw9Y71m6Dw3wJ6DiYA0OhPNBgL69CizFQ?=
 =?us-ascii?Q?+1JA33e49DxrUM+MM1lPGCEcZihI94uTU4qcp3AaA2/+xSSm0SnrfF4go7DP?=
 =?us-ascii?Q?0EYKyjXSBYTny6WgQvdqDy/3ztbAp18McfYYEGyo4GYVdueWk2ba8xglvAuY?=
 =?us-ascii?Q?QM9pzUk7cz+BLe3v3ojJm7NNbVbjqDklylBqenefuzPg438gcPE6K33faLDL?=
 =?us-ascii?Q?e8zZJM5IFpjNaJlb0oylMHmVoAbBsDuKLNBKAZ/HcXWoJ0FJWhV6fd3lnlGf?=
 =?us-ascii?Q?Skr8s0B/bimWFALjJxGiQnbkT+3nPlpohMX0dzzvVlD7/0hwRjlVkua2QtIu?=
 =?us-ascii?Q?t3PanMQobARFtkHCnXlOtEdsuBcbcyG/vz6NxMm+AtyWnNacn+ntMA34WB97?=
 =?us-ascii?Q?bgTvEXFfQyZ066bSyPhYZZEoe0ewiEeJxihf3paFS/l3lMOMunXkkZyyg/9z?=
 =?us-ascii?Q?s4ceFDv5rskSWJIztY8VBEjm3ZgrkuXAQOAAJl0F6VovLBvPH8tInPssUzBr?=
 =?us-ascii?Q?AIkzQbFJpEXaGySNJSIa3j9sVX2F8gQcdQdhqGBvRTwl9A5+wow5gkg8KIKD?=
 =?us-ascii?Q?0Ddboeeo+gYlgCgS3h1AxezUeXX2QorpJskgDyuOGDrPK4Guhc4ZHIgbkw3+?=
 =?us-ascii?Q?EB0vF9wP3rtW6gTeul7IaZByB2QhGnrai7w/Zvsv5MpHx5YvSsgjSlS0N8kE?=
 =?us-ascii?Q?ryKhOTqEhNdZeOVb1VpdCv3UxtBqPr/L8f+NKzEEAAdHe8TR79jDmMfUbHVl?=
 =?us-ascii?Q?j0NvsstV0F41NNtMiamQIvdhZmSuWipw592MFytBe+CizKWa4SgYW4w1PBJM?=
 =?us-ascii?Q?7KxnV7L5PbNOXxKgw8wfk6ADkIXwrYp92AmqJcLr5ktJGWFn97rjobByWfxW?=
 =?us-ascii?Q?1nSW4lwrbUggqtyHzp8OsKgsRWe6N2pbsnDF8OEcR4XmADcymadVvPMERfms?=
 =?us-ascii?Q?VwqjFdVg9frfBhbPsVgERhTPhPBelPa9i+HCr25KxIakh4xAeO5mlwKFV+PK?=
 =?us-ascii?Q?NzI4IjF4aNAjcmBy8lUc3CbXLvhrsu7O4/Z52AXw+pF832vjlkXg61qM24+4?=
 =?us-ascii?Q?WBoajmF8E/1JnMS1zufNvmFtPzPbL0lWRSKv+vmB5p9CYxRYBi4d/RT3ZC1j?=
 =?us-ascii?Q?cSK/7YKEUJpHvXyUXKbY7catoC3FfxD7Y3rlGiTi5MHDCdcnUEFSb+Y9vbgl?=
 =?us-ascii?Q?q1hH0nPvSFZFq0eIfahW6Lh/V7Ap5Je4nQ9MPAGbmhehSwzd7GVzUDb26iB9?=
 =?us-ascii?Q?1+aaL2bMNaZZljxtGU/i8uKA4U5s4gsXmL8OOmlC8jTQdBntEHE5kpWHzS7M?=
 =?us-ascii?Q?IJtS4DVb9mrqBgQXoqN30e37q7Yvw7a0U5/72q9cybE+/+5RoFrU5OlLLgTn?=
 =?us-ascii?Q?6xy2r63w6DjIMPoxXy4uiSXtfGnVYNiTFOwT7pVhg1mnpKvxZLtG+yYe5EgD?=
 =?us-ascii?Q?D9HiX4dZs0tMjaKGkQWXCxmOL5NEkqJ8MxUjCy3qFK2yi7ZK6n+FkfqtpAWB?=
 =?us-ascii?Q?aT7fGZOVShgd8Dc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:40:02.0470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ced0ff-1d17-43b1-54ec-08dd7111f0a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4317

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index bc8c3b596dd1..9ade2b1993ad 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1271,7 +1271,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1



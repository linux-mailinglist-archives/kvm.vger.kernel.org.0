Return-Path: <kvm+bounces-41556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0999A6A722
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DD6516F4C3
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80C7221549;
	Thu, 20 Mar 2025 13:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5kMvIqrk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D320C01C;
	Thu, 20 Mar 2025 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477263; cv=fail; b=jL4rMF4GabcifJ4enF2NwBoNnCvk6xwFZX2qGyh+1ZjCrnfJVS61xHMFBrRawEuZmG1dwbe/k/NZiQH5DuMSyOf1pX9CPlwdaySDfETU1NgOc78IyC0z4hoqQ7KYZWBkEPmDRYDtlZQgm6s04+MfQWe3TbeXPggdzcBTktVJTdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477263; c=relaxed/simple;
	bh=2cnzySUpuTyPFt0EpYyfNUrKlZcncRnoNYKvHpuiIu0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqD8oJ5h1mXXn5wEvt/+B/UHlDMYQInrO0nrPAtDyQd88zLrQez019IDif4CHutgDMZF6bxuCC6vewCqLMnXRGmEl31dG2ZIAEJ5nQVB2X5cwF9RWjdo5Bf0ql1UiIHni2ggWiwomyY8MPnnceiuFYZsKixIKeoLApjW0HN0aD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5kMvIqrk; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkuWzoQpP0yWTSTZOKZyWL1KoDMO4rhKHp/ow6Gs0gRyIL5qbqHIHdJbp8ZKPuoCvyugT8TMAyWMINGj3s8mkfh4W61ipjfflkHscRWBWu9IgkwTtD9i3Caicd25j6cYEGSO8lsytB84N02Srz/qxB+Y8MkzGdNiBxrejafWiTvXsCrOKn4MXNFVKrn/y8u1G2azXI+9dBO2tDvCEGtd/dM0SOWrJ//Xm/Gn5UCyTj+gFOsWuhRqLz1XWRgaeB9eMemvcOqzU+TZ0kEaIFf2Cf2bBtjIoSZ8yNdr7BPWf/YydACxUie9ucNHJ59KrYZElRzIyg6PaZuojmIuQA0V0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9OQ8DICGLJW0UGxHk1ZnajLap7a34oWm2c0rXYtnuE=;
 b=je1VTFA1dTs60EgosyM0ahjTz42isKfZ0bwtEa/D++RzrTkja/ZnvL31n3KMqmgFvMfB/J8fFhaDOK9jblI8vy44WA7HUQGEbe0mtCoZBqNikBO1rbdrbDFQtbTeMFs7uE+HZlWFVzXJcVELS3m8bfEzhPbypig+JHxuFUJUj23rU3sh3t02dVo0evNQYv4xXjM+LhrH2UKGoEXD4v8Nsy624SYgNVFA/hwIGX1isQZbNKSlm60YwDkHLee5Zp+A91iu2Zovp5LA8qntYCs3djoYxXgxETaqSZbgpZR25c0AXBAofeM6S3PEFqhPbkB8i6qSsceIKW/U/LmFeHce0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9OQ8DICGLJW0UGxHk1ZnajLap7a34oWm2c0rXYtnuE=;
 b=5kMvIqrkFw9mgM82OFsB0Fv55688NV2rHPxE3KSIx9/zdO96ebpGcvPuQXGbYvqyGGmRMNypRqfQmJvzb44t1Etw7mFWnCacUNWo3Usph8wmfYISZDkZUh2+Y5cr01yb8REQkr/KqutIDGPLSn4S3IuYtmGHmL5FD0d9x7ItZ3Q=
Received: from MN0P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::26)
 by DM3PR12MB9327.namprd12.prod.outlook.com (2603:10b6:0:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 13:27:38 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::87) by MN0P220CA0016.outlook.office365.com
 (2603:10b6:208:52e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Thu,
 20 Mar 2025 13:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:38 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:37 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 4/5] KVM: SVM: Include the vCPU ID when dumping a VMCB
Date: Thu, 20 Mar 2025 08:26:52 -0500
Message-ID: <ee0af5a6c1a49aebb4a8291071c3f68cacf107b2.1742477213.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1742477213.git.thomas.lendacky@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DM3PR12MB9327:EE_
X-MS-Office365-Filtering-Correlation-Id: d0199f2a-651f-49a4-4548-08dd67b2fbcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iHAGwsEwJTh/W64yc1N9wM2p3soaXMLr8zkLFu6azBfDeFKpHry0qZmthssJ?=
 =?us-ascii?Q?qPLQFVO++zDf4cfo6hjF3XdhvdPDXKlMU+sx2cssXi2W4p6Qivg2InsKxerW?=
 =?us-ascii?Q?q5nNA4sVd6WXu61nOf0xBv+6kf35VZsEcckhPDcXIM0LaGcG3rXUWsrZMBDU?=
 =?us-ascii?Q?TQn1PNXKYmfaVWSDT+iAMWBzrw4m4EThQzw3DoOXPdmeSSs3bVIOieYR9BRN?=
 =?us-ascii?Q?QiLvnk3AyWRohft1hyulNz0BoVdZmhbs2v8e1kAbuwY1a2X/NztBjezQZ/dp?=
 =?us-ascii?Q?FOgfn72IqVwa5IvAdiynWTJzNl1/WW0wxbv6RTD48LuTqCw+E34EEaCq+esY?=
 =?us-ascii?Q?31A/Ty5F16G9Q65Y8CkmhxLMl8OlPtW9xMRjOlE05gMk+Wa8KBh5ldNWorro?=
 =?us-ascii?Q?56xycoyjbNY+043jvKnFCQXcMj9ukBS2d1upuFXlOlR3gWWwe1V8D0/SghvW?=
 =?us-ascii?Q?VDNl10lobJVtzwTfosU/0dt00MlPy4tfQJpXJnEqdTBDhOHy+nkfqMRYKWeq?=
 =?us-ascii?Q?UFXMjU8MCTTNtgNaFn1U4y9Lg8Ve1rZuZyNaxI/mWmpL7cT/LFP73bVjQUwp?=
 =?us-ascii?Q?B49l9mT3olS0GzbA74J3OWoj+SUDvpS9LEmsJuCV/BS0u71XQzvyduLme1Um?=
 =?us-ascii?Q?Qkw4iQ3Fc/ttvIVidZMkt8Ir4OVrgAZQlkTMsFsVBTExC+PCUWi7L78s/+Rt?=
 =?us-ascii?Q?wrkcmDaTRROXGvfLH57CxB/6J1XDn3TqmwWpGHQFpk2BhkYSBLX0VY9LC2D1?=
 =?us-ascii?Q?Ro9opi5AU4sXYv/haU58cwads3bK1hY6SLg4nN3/SqsOM87R2C/MWK/u5mJu?=
 =?us-ascii?Q?wyN2quY1c4n92ycSNLkgu6alKsNoiXZXC0jU/Ibg1sm997kEqqKTOTGg2oVv?=
 =?us-ascii?Q?v6gpkWi3mivHbmacLMMTD99/WgSLoF9cNiYV8rKjuro/xaJdgBRmVoXxsZeY?=
 =?us-ascii?Q?YMj64fa/FJdgH6nzn0L8bIB58JIWDtF7Hfz+w56M6WDmANnscKlg3zVVCgW6?=
 =?us-ascii?Q?IYUJLv+hNNEw0sqoDbjzEkeRPY8LyxErHG2qdK1xbtnZMfGrrwRLe3NDhiF+?=
 =?us-ascii?Q?w0HlEFiabFPwlErkRlYAYsSW1ct1WjtKJ0C1GTlEf84tlyehObPswMmuBc7D?=
 =?us-ascii?Q?fcO0KSaCmh8KNRYLVSiJToa51pUNaDPljghFi503wPZz9BoYaFiH5/Qe2ad/?=
 =?us-ascii?Q?aCRzRu9HF8E6UyHvr6nbhThWduy8Zy3d2A0iQHUWRzdAKpUR6TfbhyYzL7wJ?=
 =?us-ascii?Q?UD0QBAAu/EJkX3cN5u5DiktRx5MicDfPtIi0QD2BjkIsIfOStaeQRVFX2L8I?=
 =?us-ascii?Q?bGkrgH+URwpurdpjDM2lc3v71a9Xl0YxfkwPsaOgb0IYQTpo6hpCRlOcu+OQ?=
 =?us-ascii?Q?Ah8/iFgWF3l74mu3FnQb3calOJVpho2lZi7CTrgQ8cxqZQW+gscS2R0VYmCG?=
 =?us-ascii?Q?gnpSVEVHuXa19LjjaGdiMQPFsc8xL1xLVqVHgndlH6xKEqvZdC18jA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:38.2670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0199f2a-651f-49a4-4548-08dd67b2fbcf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9327

Provide the vCPU ID of the VMCB in dump_vmcb().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 73b5ab58d2b8..99f2d9de6ce2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3389,8 +3389,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		  sev_es_guest(vcpu->kvm) ? "SEV-ES" :
 		  sev_guest(vcpu->kvm) ? "SEV" : "SVM";
 
-	pr_err("%s VMCB %p, last attempted VMRUN on CPU %d\n",
-	       vm_type, svm->current_vmcb->ptr, vcpu->arch.last_vmentry_cpu);
+	pr_err("%s vCPU%u VMCB %p, last attempted VMRUN on CPU %d\n",
+	       vm_type, vcpu->vcpu_id, svm->current_vmcb->ptr, vcpu->arch.last_vmentry_cpu);
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[INTERCEPT_CR] & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[INTERCEPT_CR] >> 16);
-- 
2.46.2



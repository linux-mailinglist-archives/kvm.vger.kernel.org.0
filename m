Return-Path: <kvm+bounces-12664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E0488BC0D
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 607D52E37F7
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E1E13665C;
	Tue, 26 Mar 2024 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mUW1I4P/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A512AADB;
	Tue, 26 Mar 2024 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711440732; cv=fail; b=ccyJ6SKghozE2gDb5rLIccEo5yIgIPmPCSc853vmrIh+s/+A7TI2zXCvYRbZ7z7OIROfo0WfNLNCu/fT35wA6GyDkOedGCFcKFr12RcosNofhIkGzuRsBohqtoMTZixa0hFm8fGxZ2nDDOjMjv9dnJBTUid5KLJiK8p08+FphFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711440732; c=relaxed/simple;
	bh=WFKIX0RsmCMf7RSqDF5ypGZbCyOrl0LGXnCxWogA8uA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D938dIjR/UOkCKSfjfkYYPC+xDJdmmJzlQfWZFlBQO5aTkOftTyV03uLhgzrvBXeiKXk1ZuIi7Pm92t96+x5YvryB5tyQzrqeGcei+IO1k/uL+Z3CXmMkRazGeSyiSNfz5aemtU25iiHfuoJA/I186zYa9eJNKQex77F9U3gQ1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mUW1I4P/; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN7W+pUd1lMN2pLVNwHyl6X98ps8kyjvCzIMwdOtLkhPJF2i3FmZ77WwAxpo9Zw/xBwl0f2Omb3RCieoKuHDa26nIaJ50RkIhFCgZVDYzGsV1Lv8m4QMWh9ktZdu92SHOV1gxw7+uDoAFnewpIPuQMa00PNjhhUdSuV1y3/nnbxcGAPBS5vElexe1u9m74UjWiDIGug040pmDwrF7AsBtlQ5zdvchTfAyYIyEYBZOuL/h90eLPJdshSeNacM09NbaRKvSLk145lDYv5HRjDeSsY3fIydbaanp6pW8MZ8+4dZbL2gplP4CGdy/hsVxOLk09fTWuAFbudBmZuXSlom3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BHIzc9SrkeuuDQVM7Ulxlc4VlYV2lBzNgCL5M0Oqic=;
 b=ijNT7r/yzrXWGn5iZAtKpZkCCl+Uj7RtZZeq/s2uQmv43uD19KAkpwvpPD18jj9T63xg9aiHv5ROt2Msc9ChYIQw0N2zQub8JUX0addU19zU2OO+Gp3hsfeuFivaLcDmQkNJWRgsP2GGdYtB86fMid5xY8Ra8WQgeOxbHPD8MkTiBNYBLlgrSVVq/C44/0xDRdB83o5teugsXEolidV9xP7oeez39koAEym3HrsWNnDgf9RilVHSPUWJ0Qpk5Rh/zaSmq/kqy3ayi0/btM7j1HvLU5dbmWpVGOrspZVnmaJBjhh0zS5Iozux1nvEzOjJl7NBMtP3Lx4fdV3y7e+ebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BHIzc9SrkeuuDQVM7Ulxlc4VlYV2lBzNgCL5M0Oqic=;
 b=mUW1I4P/f9zfRjUqtKX2qfj/sOQ1Zbgs/Ah8y0sOw7cw08T92V9xrsEURvEDVAlo0EQHu2eHHugUDfx0/7udUZvUSthJcMo1nUpYFK2KANuLWb1vn5b0L/mmVNBGkaK0yIwx49ZyNcio7W17+a8w6HGkXKRdEhhzcnbdqj0weDM=
Received: from DS7PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:3b5::16)
 by DS7PR12MB8084.namprd12.prod.outlook.com (2603:10b6:8:ef::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.33; Tue, 26 Mar 2024 08:12:07 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:5:3b5:cafe::42) by DS7PR03CA0041.outlook.office365.com
 (2603:10b6:5:3b5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 08:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 08:12:07 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 03:11:58 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<santosh.shukla@amd.com>
Subject: [PATCH] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for SEV-ES guests
Date: Tue, 26 Mar 2024 13:41:43 +0530
Message-ID: <20240326081143.715-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|DS7PR12MB8084:EE_
X-MS-Office365-Filtering-Correlation-Id: 8007e184-6791-4944-6347-08dc4d6c6dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZSba2vr7NdTsi1LDnxt5nml1yt6+mJZwx5MBQFldMh+nuPIOecvgwE6DwiH3AqPihfIfFq4lzV7uXTaTABZ0Gnmf8WrP+DaISAwmvCC7xvyYJdYti4VVuaTwv415FhZaE6IAiHhMgAbOkX1nQbCXKy14RaH2/rWa9+JcgWgxNeonibAPkhXEReSzehD3h+oAyOFgF9o6svnp5XlEJSh3Uo0GwqJiPZTMMvhVzXjVUPc9Zu+oKZ1BDeXe3izC1/Af/eCs0CoS+4eAmXYXHOg1R1EUxIQeGSEEI0nPSF9qmBL8XgMBIOWBI+eOQMETBdzwxWkgnxZRoF/wDG4JXvkIfTxfHksOg+tJzmm/inCzZxdVt0bGBtrFYj1M9Hk3uUeQQXoFIYgcIoiE4G7Ka6AG+/IwpFKB0cFYDYcZ1MliVeymqP9YfdrXk/fWOhNtNPyPT4q4k6VYSsSym/X2ZCiAPFEEwN8pHbTuOzK1bTGztPfI1MALYlD6urnm26wgGzTLGbtWFw2fMZQEA1wm9uWHA49viTLl5vFBNBVNxNRx8+OQDr+8LVNiA8Rl70AUIJvIdR3sKfv5f3IChOjXOAu14jzc0Ts1zxEfnf0N747b7X7FODrYIL/cd/8DhWYv1Klo7dBEmeKCKHbQSwD5Jt5rkbhy1S2yCXCqQ4805SnEkvoPuXkPAH2y975O2s6YCXoskiUHUbA46jWB1jGqMy1c8Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 08:12:07.5934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8007e184-6791-4944-6347-08dc4d6c6dff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8084

Currently, LBR Virtualization is dynamically enabled and disabled for
a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
avoiding unnecessary save/restore of LBR MSRs when nobody is using it
in the guest. However, SEV-ES guest mandates LBR Virtualization to be
_always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
guest, in fact it results into fatal error:

SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1

  [guest ~]# wrmsr 0x1d9 0x4
  KVM: entry failed, hardware error 0xffffffff
  EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
  ...

Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 arch/x86/kvm/svm/svm.c | 1 +
 arch/x86/kvm/svm/svm.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8ce5226b3b5..ef932a7ff9bd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3073,6 +3073,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..5a82135ae84e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
 	{ .index = MSR_IA32_PRED_CMD,			.always = false },
 	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
+	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..7a1b60bcebff 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	48
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.44.0



Return-Path: <kvm+bounces-17217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 961B28C2BAD
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B90E01C20D5E
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F0C13BAF6;
	Fri, 10 May 2024 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="slJ9PMxf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDFE10965;
	Fri, 10 May 2024 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375930; cv=fail; b=D5niY4F1UfoSWYjZUFZ3T+Z+prhwwXXrkPDPrLTfBo33Ld959AG2YlLEh1dPUIjsx5qx7cWMx8eG+7zqy+Cypb3RCfoeOiGYGIveMwXHQSncej3pN0VwA9bWx6/eWPjCZ5WcNpM4ripf+e2Xh+DRHYrxXZa1Um2kwI7HoDdSxEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375930; c=relaxed/simple;
	bh=9JCtn8+S20SwpWMEhIghFBGaVob1SNk4SVHk5JxPUlg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VT7JzUDabuE7cUmL1FG1xoB6OZcw0kvzY+5VCIWk7ssryErgyeb0cRGlEchkknvlDot/gZ/jy+28pxaFYADQ98KSLj1HXmBXuNymRr103cQgOxvJPDV1rMFBoUQbdkNew7bsLn6+Cyc4kDB3wiAgCJTAKuc5Yc4g0gp4L0ZzwIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=slJ9PMxf; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0r1KWLwG7ZnpQmhXJ1xhWAKAdngetJRDPT/cfQBJkmRPfAjqs9pb01PycFr33bD02VXCagiTW6FQiwBKbwXo6MsP0XgxFhtzVVqISsE99eJFigkHCwzDv9AFG9D4nKYFIGbGwRLrIlp7DzPckQDLgUAOuuPRzv7rkGpSDcETSjIMGvLlSynaVYiLAXp1ixaBEZ15iek5majVQKkbONcJRN/Txsa0IrCd35hnduGsSg7WHrUS+rbOhPPkOVMCVQ/D6gWIubThDzy2kjHUyIMPH2xv0+LTMQBcC4ykCXQepQV8vUmtS916zO0zoPWgYOFR4szcXlSEYKDXNZ2bVkwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfJHXmG/cO0gjpyu0/O7QuOJmDVvYEZ92UUxOzehpUA=;
 b=FxdKV9xht3petyiRPmb1RIVr2He1aOp68bIjSkKO7evGmfQSOD+MYFmflj1gxKHae0slNuzleMTyDH4MCzmHEOewWfu55DdwK26NV9vo0I2f1+yPSPHgDXozetG3Qva/TdBVgVwq5fTiSRuc+5E7ry9QoFLGLbA73B9T1ib4js8qdtGLxfdb0OV4h0+OXQO17DbuxkWZHp8XYEELqoXGLlkiQYG90CB92EgZoFu8quc0ry4H58DN2JWjlj5cxR+Wn4nc4hh+ldkPmJJgiIt4ujBqmBIBVNTN8YsWTD9ODnYDH3bl7RDDCOE6kBASKFiAyQE3L+smLMi61TU1WpZeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfJHXmG/cO0gjpyu0/O7QuOJmDVvYEZ92UUxOzehpUA=;
 b=slJ9PMxf9ZdXf/CdRus/tLKCFO7jb++QWjeA3UaMl10m/qX5pPDkm6toeJk7KTl5H7ZvCDv1XGbs3vOZfZRQT0BGvatWEO6/gW6XhPuq18AIjtI1b4eVXEXSW7FxIq1hEBIsjd25J1ad0QXjjDFRPtQ0kCmOJy9Wc8VWrpnPYh0=
Received: from BN6PR17CA0060.namprd17.prod.outlook.com (2603:10b6:405:75::49)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Fri, 10 May
 2024 21:18:46 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:405:75:cafe::e3) by BN6PR17CA0060.outlook.office365.com
 (2603:10b6:405:75::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:18:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:18:45 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>
Subject: [PULL 14/19] KVM: x86: Implement hook for determining max NPT mapping level
Date: Fri, 10 May 2024 16:10:19 -0500
Message-ID: <20240510211024.556136-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: b9554561-7609-487a-3ad5-08dc7136c6fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?262MfFX+R1N7pxo6EyEa45/LqjiJ0SseMJZpXBHmh9D3ftAEURbMOS0TVE/A?=
 =?us-ascii?Q?Z9YJtpxGv6Iqznri0XpYiXu6/EExQQFwCpKiE+Dqun+x9Kr42I2tsTumdBQP?=
 =?us-ascii?Q?i2MG9EDrVdofQW7BtG4BxdivSfgh9NCuiiRQqKtdjwhJdEkXAtpLODzFAPCy?=
 =?us-ascii?Q?DqJvbU0xFV7ZNqp3Tmix7dTS8Cs+fphhOcS/b/QaulvZpiwUdJ0lxgaD7jMP?=
 =?us-ascii?Q?2Xod+d5ejeW9yKMuI9pPObAXEzEjcVmPU96HOyMaMLsItYvPZtRr4y8lkk42?=
 =?us-ascii?Q?UOvWn45MhvOKH9vTuZbjUhkNqhrhVkurFwvdIzvE2ZOPwECEslDBY7n7FVKg?=
 =?us-ascii?Q?MSPUr9CLEgFLJ0mJLWZ4TyiO8AC8csL1R7cuRSGg8OOS+ceRg9XpYjBUcIQU?=
 =?us-ascii?Q?DozDtkchfaPD9OpWmDAGV3stx/pRS7PXPIRu/k01yRW9AI49j3Aq/eIjGxDM?=
 =?us-ascii?Q?Bwe21VUHXrkSEAxz9+6wQdCQxo20uvyaogBovdqpv8aL5lHCduTvhXAyz90U?=
 =?us-ascii?Q?FjkB5wR0tJHaXBzx8j74otIYLZ7UnXLU7/fSbc8BJPAI0K5XQLM6gTAeiy3S?=
 =?us-ascii?Q?lupl3JIJd7dpYUCUCjeO52sQ3NLyik6cGk3DrEKjHpzcitTEJYtYgizS7ssd?=
 =?us-ascii?Q?DKGanwKZt2ZF951A3+fVK+3KG2+ZC4McWBc0aEXb3wY8cnc6eLi5FuwtPYRt?=
 =?us-ascii?Q?T5f9t+M2f3mZ6lGoeLNCuqWPuMQifmuDeRQCdKZPgd2+Worp86sszyldWlF5?=
 =?us-ascii?Q?TezD/b+AX9Bck398Cw7gEWBplmIMcSiYSE+3Y3YW8g9RJn+RT2+RIVyEfVSn?=
 =?us-ascii?Q?UBnkLwZglnD0zI1sG1w5i4xNTjWb5qMLdLIdVfM2AeI6Wq1nC2Q1XW5U/lkU?=
 =?us-ascii?Q?d5pe6U8Z6MDt4sApUClqNLq66ZNNHrODtOj7SDfixRqCTMj5Zd826ZgG5x4z?=
 =?us-ascii?Q?GJwudRLLLea+Eo3/gGOixKZUZM5kGzch4/9F9kZ37rGqI0eGul6TJavJuxA6?=
 =?us-ascii?Q?zpPJ0z2dxMLZotqUgX8khBDdmiLhw6WET63BzMY7qX+DvA9gMJgv0y/8piQy?=
 =?us-ascii?Q?bGul/bjiZ0IusdGTdu1EKDBskqaK9TvM0CJd56bxnuw3yZ6LRxrAP0204Lel?=
 =?us-ascii?Q?yTbrl9Ic3WhEnIv1yxB4S4Xolv2zW4zkh6zeoeVz53ToCy9jiMrzspQklDiD?=
 =?us-ascii?Q?0AA3cWKxpWjsZkRRg1xS69vZywlev/11DlltQ3AaRW52UEqV01miZ739RJvx?=
 =?us-ascii?Q?a8kGbXS7kVMSnrxVMD5aiowNtg4HWjYAcRazcUWA6E7zkvZP4FM6OhRY0bp2?=
 =?us-ascii?Q?URRsqmERfGe63ABIMtZukqngdtjannNpEwQzpqjtvW6WUxw0l434RCDKivT2?=
 =?us-ascii?Q?za1PMu2wLJMrMn1qfd5xcLEyplH+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:18:46.0021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9554561-7609-487a-3ad5-08dc7136c6fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Implement a kvm_x86_ops.private_max_mapping_level() hook for SEV that
checks for this condition and adjusts the mapping level accordingly.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-16-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  5 +++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 379ac6efd74e..d603c97493b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4727,3 +4727,18 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		cond_resched();
 	}
 }
+
+int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc || !assigned)
+		return PG_LEVEL_4K;
+
+	return level;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 653cdb23a7d1..3d0549ca246f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5084,6 +5084,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
+	.private_max_mapping_level = sev_private_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3cea024a7c18..555c55f50298 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -738,6 +738,7 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -759,6 +760,10 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.25.1



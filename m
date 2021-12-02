Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01BD466E13
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 00:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377687AbhLCACs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:02:48 -0500
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:28548
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377673AbhLCACq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:02:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1pk5Y342p+Z7ZP6+CoT1FJKXjKEHp5RmP0/NuCsEh6UxLt0KBS8ahsIft3NYljO0XJNvQHldSKCkxvbePQy0ZDPtrQvVXv7oVxsupF/u4oUdrHWkdbLAtDfkRS5vh9RaoPFkRvmpO+dKN30QUVGWJOAsGnyc6Z+18H0UxuMA3y8zaFwDjuj1kMJKPHjlH6eJJFOrur3PED3mii6nxMGatFVaed9A44LA5n+tOdq1sgBt5wHuHHn41YN1DlvtUL2YvDUpvZAEgx8rQvtD32VLVoTSGAlxCCfm612oIrAhIwOH1fLl9J+YN6iZZi6AOtXERSmShYKnHA4hTqNkZVo/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK0jSEH43G7j7xfV9Ewa/PRdFYJJa5khQG21RRA4R5E=;
 b=PI+1phDgF/reEhx+RVvCs9LKjkMDwishF1CROPIGbLwekdigGYWhNRPrsCkqWiwXG5KpvV7F5NvStSLoyhEVlHrIKk1SQLnJM5JlsuafFRSMjurKjWuCakcFqyOdeIsesojbvHvHNdDnFtVHqJERPeu9VrkqQU5Ujoo50XepIqCu/ZeGuyAC/wrIY126c0K3Ug2+Un2QQC9t7KVTTvZTD3rCZLwaVoKltb3bJRwpwsN3VDLjN2jsd2IUkCWmxBrcUhESn2bDTcPDO5f0FeHKynazd869byCDXM1A1rdSmVvjbKRxvlqtXn7d4dXJ9q+9RY4dU6ChUIg6DWL+FEh60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK0jSEH43G7j7xfV9Ewa/PRdFYJJa5khQG21RRA4R5E=;
 b=2GR2ftirYuX3ZJjSpA2QKAw/1gdK5mu5n6KfTP5krmiaVCCswmHbUvSDTZATgi9Yr2khaddT/Iaxr1YlIBY+5CezTC5Iu2zaZ1hr+uEovQJZtQqyEzxcC5pmCShzpVSd3LX691F30NtKuRIXWWQ+/ZwQWBOJ2bjk1nwq1ehEOI0=
Received: from MWHPR17CA0077.namprd17.prod.outlook.com (2603:10b6:300:c2::15)
 by DM6PR12MB3628.namprd12.prod.outlook.com (2603:10b6:5:3d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 23:59:17 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::90) by MWHPR17CA0077.outlook.office365.com
 (2603:10b6:300:c2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Thu, 2 Dec 2021 23:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 23:59:17 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 2 Dec 2021 17:59:14 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <peterz@infradead.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 1/3] KVM: SVM: Refactor AVIC hardware setup logic into helper function
Date:   Thu, 2 Dec 2021 17:58:23 -0600
Message-ID: <20211202235825.12562-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f307a1-a74a-4ae0-7660-08d9b5efc057
X-MS-TrafficTypeDiagnostic: DM6PR12MB3628:
X-Microsoft-Antispam-PRVS: <DM6PR12MB362830A873D9B0996166D043F3699@DM6PR12MB3628.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:30;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saLBz6RnwpL1moBu9N7qG6OvefoT5prb9KDEV/ZJQTP6fcmex06q+XmKxUM1g02wY85Pw68BtOZesbqBjRoU6DXp9+ObZecK+UvIo8uZVzzmDJlyXRD6epEIo/mjQBc46cS/0w3NewRpwk2J46jqutKFgsFULutK48aycXctEVBycx2mve3QQRDLb0GXZaVCCtWF8RjXU3V8tUTXv5sSU7N5ncClhx5+o+bq6ZLQa8c+TWS58HrOaLYmo9oBwGDS0bQo1SW49ktc3ANw2XiMtEZtQ+HB69RK78kYHIhWGWhjT1QsZltiuWPfPYdBOkPXp8SWQSQGxjwKWx//R4RAPn2V/J7MkhPbXc3ugTrm/HBPVGVH0Ee0nIc4U6Q9I6asgCKv3UgT3DLHzuUfftNEOtrgG1Vch9aI/LnX01KCyjpjZOOb93fUZ4a4nLXTA6GLm9RskbuPKxJNTkuTxxfchc0BK15ehr7btcujutedyI+wGIsJbNkU4vYV9TlW2rQa0zi03lkT+rLG84+CeNnVzLBpLsIUfenhuhYjIiulj986Wno95W/uIicFfuDowxDLBzYUmJDNxbuFQAAEuKHlBVxwOtYghnuMWD4hB0sNXHvtCMy0JqQZfmtxUFWxcNXBWz13on1QabFLKuFSmoGIVKH4K6dxbYE+XDfi5d57EzAKdtNpyUxXb8QWPx2eTh6sb9JhZxfV6N0zFAaldYpl062jaIsGsr4/WQgdFRZcmQaIJLsz9fXUaU1pxdaHJfcUoQli0h65LlYiHfiiGFG4xc4CRJJHp+7pHt5WzcMXdGk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(1076003)(83380400001)(316002)(186003)(2906002)(54906003)(6666004)(110136005)(508600001)(8936002)(26005)(8676002)(16526019)(47076005)(5660300002)(70586007)(81166007)(4326008)(426003)(36860700001)(7416002)(2616005)(356005)(86362001)(336012)(40460700001)(36756003)(70206006)(7696005)(82310400004)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 23:59:17.6772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f307a1-a74a-4ae0-7660-08d9b5efc057
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3628
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To prepare for upcoming AVIC changes. There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++++
 arch/x86/kvm/svm/svm.c  |  8 +-------
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e0..6aca1682f4b7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 		kvm_vcpu_update_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
+
+bool avic_hardware_setup(bool avic, bool npt)
+{
+	if (!avic || !npt || !boot_cpu_has(X86_FEATURE_AVIC))
+		return false;
+
+	pr_info("AVIC enabled\n");
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 989685098b3e..d23bc7a7c48e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1031,13 +1031,7 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
-
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	}
+	enable_apicv = avic = avic_hardware_setup(avic, npt_enabled);
 
 	if (vls) {
 		if (!npt_enabled ||
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d30db599e10..1d2d72e56dd1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -515,6 +515,7 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 }
 
+bool avic_hardware_setup(bool avic, bool npt);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1


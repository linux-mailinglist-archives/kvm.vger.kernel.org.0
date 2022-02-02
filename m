Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12F34A6ACC
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244319AbiBBENl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:13:41 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:23809
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244275AbiBBENf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:13:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2IFgTHL92Y2/0T6/b+GY9fnxsXan84KLRDcNJFF4wTaVBl1bKNxRVOTesdlED8g/m9uqn2e6QC9stWx3tv15kGKKyS1sPZIHvy9xAAbbQxCxhCOBO8ytzRrrHvN/zjaw4GCSNaLk0FSlC5cy5stvVCxOaESvBVWXhvEJTTDGPu+Bz2ME+GGK953M7rRWrJFDScP5hZK6ELn1C0v21x+hvEavOSAMckKeir8UpyB1UMkMCpa9h0Ex2jjhk+A13xz8qURoBa/jV+IuFBP6nccucWpgL1wNRe1kh6qhotxGplRr3OduJtFJA0dKyXtIuDLF+0/+MEZvQHc7edoDAL1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8kDgA3ZhNJgcp8z9OczXhS/s3+uCb+h8OAHgrpCkbk=;
 b=joWhGRCSsFgU7NoDs/W/cGPp+oerKkmT5IEsPmlhK7IdUByPoYQHGSMsmQJQc6dgQaADaIpEkbk9ZT4YL3FqTzWrz8gV66vZLH1zOUEnvK7dTckRDpGw8tbgZzLu+i6cO1JVioIGrOik76rVDePQNudTTyTbVySJqJYhHeSxtotQelRjazpdkjWVj+qGNU268DZQWYk5NFirpuG9MrQ55KWg/qcUX1AvfB2EH1ojsIWrfG9nBDVGsU0phqUs1tVLHVSwmXl0ByrnH0BC6Ita9hX0YntkvRZf30gWTXfuHKTPvGwIE8EyPKPr2tWTzXrkzIDsSKi7Zn2+TZ2ZqGVr3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8kDgA3ZhNJgcp8z9OczXhS/s3+uCb+h8OAHgrpCkbk=;
 b=A5euqg70RGVOGuWDeMwjGCajK2ai4IjbobcFlMWeREUhu2kWPon7n0+LJ/IjZOVQqKj3FQ95VaP06yHQiHO5UTrzNZcxNelmJbYIc1y7h0SvhUs9v/JaRSsFN/sWC2ZqgP5shoBqP1y+LXpiLzG/65B7Ez4GxxL8UgTuOJtx/VI=
Received: from DM5PR2001CA0018.namprd20.prod.outlook.com (2603:10b6:4:16::28)
 by DM6PR12MB3196.namprd12.prod.outlook.com (2603:10b6:5:187::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Wed, 2 Feb
 2022 04:13:31 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::77) by DM5PR2001CA0018.outlook.office365.com
 (2603:10b6:4:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22 via Frontend
 Transport; Wed, 2 Feb 2022 04:13:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 04:13:31 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Feb
 2022 22:13:28 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 1/3] KVM: SVM: Only call vcpu_(un)blocking when AVIC is enabled.
Date:   Tue, 1 Feb 2022 22:11:10 -0600
Message-ID: <20220202041112.273017-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
References: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d38a0e75-6bb0-45f6-05ba-08d9e6025f56
X-MS-TrafficTypeDiagnostic: DM6PR12MB3196:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB31967D128F4E80412E965FB6F3279@DM6PR12MB3196.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:120;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRYW76rGfG8ZDC0AKw0ROEBUueeDPZLXmpS/zD2HY3Dd4YFFgrXnCkylUCLn+RlfXem5CZTtFV4fom6Q1sxMY1JuBSpYzQRfwPhvDtANH23CRbA+tSbz94/ncgnbSgaMAfjZ93b6Cqi4Jbz4K5edQZankQl2q+PtxnwbAmaIeVkeUpuifg2cn1WStLb4tRlwwZuPBItGjy18BjO3SCZ6dVo4JkXZyzmQb5Lvd6k3pu0tpTPmb5uPqIkFIllk964e7naUeq0j87cFm/HbJ6RPWDkiz0sCpFYzXUPaF1eyVhMuc88caF6t2tsZRmfIPA65D70SS1/RbqW+Pc1nDX0HtJveVW48sGRQc+cu2Dsufd5Yh11tWILtWCyTU00Azpk6TCU6aT89NNk5f5oNFxv4UFweqKd52+GVf4xsrc6lOFX0BM1+IH5XL2BMf6IN+SH0T4ZRfv0NH6VkixvBqvLSrAibE2UXykE6l7piIqqBY580llu7n+qd3Ev+MPFW+zqcY+oAIz0j2AzLJo1iJHRXvgwdUU+QXG57XHZ8OQfXds5gpbFWapSDNm/hAPpBgw1AkiY5k+9dRwONEzVXxONPvCznp3nB4Xv5xEAcuHL3vDH0QUNbfloUbjFia974U03chXCRtSR6wRmjsqnK8SgqP3F5IKBZtUiuwkN3tREQF59VBbOpGbMny9fin+5bC7NZl+8YpctArAg2lQb2kFG6JxUGjSR+RYrsBbdflhr4sNtH7STeGAiLqTCrCevgYvmtUwnbGiy50glw5zGtletDYA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(82310400004)(2906002)(54906003)(7696005)(6666004)(110136005)(36756003)(7416002)(508600001)(8676002)(8936002)(316002)(44832011)(70586007)(4326008)(70206006)(5660300002)(47076005)(16526019)(83380400001)(81166007)(86362001)(356005)(1076003)(26005)(186003)(336012)(426003)(2616005)(36860700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:13:31.2338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d38a0e75-6bb0-45f6-05ba-08d9e6025f56
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3196
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_x86_ops.vcpu_(un)blocking are needed by AVIC only.
Therefore, set the ops only when AVIC is enabled.

Also, refactor AVIC hardware setup logic into helper function
To prepare for upcoming AVIC changes.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 17 +++++++++++++++--
 arch/x86/kvm/svm/svm.c  | 10 ++--------
 arch/x86/kvm/svm/svm.h  |  3 +--
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..f5c6cab42d74 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1027,7 +1027,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -1052,7 +1052,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
@@ -1066,3 +1066,16 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	put_cpu();
 }
+
+bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
+		return false;
+
+	x86_ops->vcpu_blocking = avic_vcpu_blocking,
+	x86_ops->vcpu_unblocking = avic_vcpu_unblocking,
+
+	pr_info("AVIC enabled\n");
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c99b18d76c0..459edd2a1359 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4391,8 +4391,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = avic_vcpu_blocking,
-	.vcpu_unblocking = avic_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
@@ -4676,13 +4674,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..f2507d11a31a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -572,6 +572,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
@@ -592,8 +593,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-- 
2.25.1


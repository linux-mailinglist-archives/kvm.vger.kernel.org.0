Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7267B472B70
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhLMLcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:32:22 -0500
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:30209
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235966AbhLMLcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 06:32:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/wqGSyCsbQF51AxIL+zPPpPB9yzYg1+BHT0NVGuAmEi8jLwRhL9630WCIAMsbrkh51+DGqVpnid0N6bC0XeYUk5mgg41NUbZLaejzVUx767tZtK8279OxsjLNrFq7K8oreiCX7w0UIdYhUOQuCviVJ+96p3ufeFN5GdwRdKbdspGoRYgsZ/JkE4Ll51qy2csMqL9jxJDa2+9st9Fn7jnesssiIgyqeDF+aVnwwRRjkCtOOG+WgnbsB/mxYjBxb8MkNeEWegIp7L0UK4PYe6W5gom1jhpjDxtMz9n0SyIyCd48VXMMIF0GmLpnWCL1134Qq9duHjlQtK61dCuEXiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayrNgUPgIoeKA2wvv571r2UQnc/0zrjoHkRP7eNb2/Y=;
 b=b+WjECu8K1r8m29/KEh5kv3PSzejfjOrIVK5oFl/uDhqhZjsnRUnszlSMnmPwQsxEbNOXe17eizvhXTz17AhIZ9cpMyFoya7iDusoCCGPPavMc1VtOLy6Osd+CqgxmoZ88K/VZBpLN7PDWbJa3hI7xSKjjywLNZWXg469lF1R15Pt/FyJ68AZbZ8Wb1FxheB6D5+1lgOqqwN/O+Y182a4S9d3cjen1umAP1BBLkUvcdGAAiVhjK8RXIYCCjhJ5gV3X6EDJCHMyvuYo2ueI9c+V+6O5F7uQ2Lqeo/gFtKirCDxYCH/2njU1mgqap7QegfND6IICLXbPEGq4xhQMuzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayrNgUPgIoeKA2wvv571r2UQnc/0zrjoHkRP7eNb2/Y=;
 b=LKoMSXW8LJnkqzznKBjZ+MztsxUfT0PtREnZQj8fPX5x2ln++oTmfsVjP5kyjlaYI3p2jMZT+tIRwPf+3EiVjx7peeatUYBigFS5b5kWbR7cWb1bhuXETAhBNYxMOAQrXBAkOIDw5K0r7+HqeKFEsHq+7YtGT3KG/s5byWwpAwo=
Received: from DS7PR05CA0054.namprd05.prod.outlook.com (2603:10b6:8:2f::28) by
 BYAPR12MB2647.namprd12.prod.outlook.com (2603:10b6:a03:6f::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Mon, 13 Dec 2021 11:32:17 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::56) by DS7PR05CA0054.outlook.office365.com
 (2603:10b6:8:2f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.13 via Frontend
 Transport; Mon, 13 Dec 2021 11:32:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 11:32:17 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 05:32:15 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <mlevitsk@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 1/3] KVM: SVM: Refactor AVIC hardware setup logic into helper function
Date:   Mon, 13 Dec 2021 05:31:08 -0600
Message-ID: <20211213113110.12143-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8601b0d6-699c-482e-854e-08d9be2c380c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2647:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26475932FCBB2D37947E3B9FF3749@BYAPR12MB2647.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:30;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWKgF06uPsnsR1mCWrYCb5KOccik7aXnyNhdm9Pt4v0kTLJnDWMqo595pfyS8604FrFpeb2vMzqJCLWbRL49sXGEJkb6W+1PwD9kjQ5DstQjd6Xwr7F2pdGEfsXBiyIrMnwbo4faH3XFaqdrb5cfnPfnS0DyOJ3HJhJnzB60bvZQHvq6iz5zwC0KQ54F4UMKw6l1CoSlaJSZK2d8ZPtRcw8XnMJWdRo/A8HUeLKYubdIGIQv1mEeoiES3JyT1mIMBL+mWdodJzXudeinmsThaSF/O+4ORhEjrrah/cbr405sBM/zybvxQ8L1v4PYorepxehNLC/nzdD47P+kfxIIx5OKodPFFJEbvCnFgui7FRGdNDV1l02AryUbGk90N4uuVSitpaIDQizBqoIvTfndFYocasgrSU5p/2GHqaHqLigvLrCPHbofyxgjJsM9LY+XeZfJT5kB0lTylMZ8Uo1ppBvCT6AHYU3YufzsRz/ORN6luvuW9BlRdeJMXuhPlWrmd/dAnZr3yVSWplQckFIykPOTotVJ4rMHW4q6uJeWE5ROoMxjbXPR1Nf3dxwNw5uTuphFV8BcHu4/nXcJUI2glF04j4WlM4x59h8lnokgyB31cY6eDELH+3ZwcWo0g8rE2BQtkFL96orG1EWfl4fKPCwGXJc2X2LhyAGSPzGptkC1ky/ZmLbQ3nNLQalQpY19oY4z1OaoHPEBnxW0T6L7LNXY/C0OFAe2IVtYY9I0DtAXKQ/H3f8mKqv7yT0Hj56VlS5AP5pvd40ZsUkkX48GoNgTyNO41qV4PFhrV0e3/48=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(110136005)(186003)(16526019)(6666004)(83380400001)(4326008)(81166007)(47076005)(316002)(70586007)(82310400004)(40460700001)(54906003)(26005)(36860700001)(1076003)(8936002)(336012)(36756003)(8676002)(2616005)(356005)(508600001)(7696005)(7416002)(426003)(44832011)(70206006)(5660300002)(86362001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 11:32:17.7025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8601b0d6-699c-482e-854e-08d9be2c380c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2647
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
index 8052d92069e0..63c3801d1829 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 		kvm_vcpu_update_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
+
+bool avic_hardware_setup(bool avic)
+{
+	if (!avic || !npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
+		return false;
+
+	pr_info("AVIC enabled\n");
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 989685098b3e..e59f663ab8cb 100644
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
+	enable_apicv = avic = avic_hardware_setup(avic);
 
 	if (vls) {
 		if (!npt_enabled ||
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d30db599e10..3fa975031dc9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -515,6 +515,7 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 }
 
+bool avic_hardware_setup(bool avic);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1


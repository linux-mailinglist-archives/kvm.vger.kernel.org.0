Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1094FCF74
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfKNUP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:56 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727075AbfKNUPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSNPky+wmtoOBGtn9Ls/+LOsJk9eemHoXOO9kVQIMGsNc65b0cTvWRQlN18Y2yXnYEiCkQ0MFiQgUVfyEdf8kq6vN2saaKmbCscUk3rwfhpHKQkiQwyXStzrsqDbJrekjsSdB7TXqIUSTx7+80H4KFceEB0ntx0jA+2bKgchVerik3qDb2XZXMc/WbSmhywMCbw0Xe3sl1NxuhKVtBsKW1LPCSPn1Q54TRxanGXnFemBQPVnGVND/yv9C+0zIR5j6EbmbsgK182UEDMaMoZ/mwyyAuvbDwmrzayhjyX3tBCkRWc0SGTQBeGn/n6inrvCdPxwxIoi3h7Zv1zu76z8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWsd6qyCLPcJKCGgLf9VxJ9pO//usGje89paaLOIk6s=;
 b=Hx2E5mMBmkjRRUObv+fNsL9EbrI6F/oycs4yP+IYVuISmpCBxpgxDFpUBB864muw71hcOsiiTu6Pz4265X+p1SVE3wyNGBiDvdQnwj30Z9e1gRAxonYR0wviBG4GlWb9h2YLdJ5vVaG27BJYF6NGgXn3iCZB6bFjAFVqoYOblvZ4ukio7Y1l8r588cZloLGr1tlFgt3+DfH3H8wxwYaWg/ec4wIbMzSmFLrlp4d0L807R1bHnYbFBMSXV1AWRHrFpLXRZRJCZdYitRsrkkjBkjzrnr+y3FvlnjO7ylnu9pmcf7+Onuc0J4eHospIgcQj/V14YpkR+ukW8rDeUtmOEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWsd6qyCLPcJKCGgLf9VxJ9pO//usGje89paaLOIk6s=;
 b=i2QIf+SPENG7SgoGbaOTtPXG8fnvsR9haETwoIOzSWbPGMHmvBMxN/wyV4CrufxALI/27D+VkescJf8dLHlOlFkPRwMZTtNNl59rdXHXVFfE5tNQ47POzOc0QfjOclgBwK5yJiwpswWVhrK5FydXl8vf3nxcILztad+f3tkv0KE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:48 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:48 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 13/18] svm: Temporary deactivate AVIC during ExtINT handling
Date:   Thu, 14 Nov 2019 14:15:15 -0600
Message-Id: <1573762520-80328-14-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50b9fea1-398b-43b1-ed05-08d7693f6fe3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739E25764FE5D35559D8DA3F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZFSkOqFyleGmJriTGscE6Qw1iJqF7bBAnjTcSBcWYlpvdq6m9iCoxUGaKhvXpvAVmHA9k3/LMeLJRR1TzV614quy4Sxi4qcVLWJpTyghsIUQKpLw9O8+N14CUEUlGN4VLL0DRmggE8jF/4UQ87O/cZm+WBAo4pFYzEWUAVnCPynfe7pmi8ApL7Ptn3xrjEJYilRanQqw4VKMXwzSJ8i89Z+zsNFkrBqANO5ArQMBDtU7uVoUDSik+GHnR//VYVXJ+bbQ6opo77jIumsXoFx99XxcT99qHIfc9HKu3FisvAAjT+Zp8xJh2TYyg4tylyj8VTMJIbVXTZ+zNNbsunwnzCImYk9O7z3B1rz6sRh3NmrO19TYcnIshcwZgRtNtee9QjGHAn/SeXq+kPo621nKUd6O6mYJ7ocKffjCo2di1cMaXyvKbsVSww2/DCcq8O5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b9fea1-398b-43b1-ed05-08d7693f6fe3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:48.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jk1z5sUJXLYvT4fUbrVTMoo2Wx562jcWmUR/nTnPJGX6JEKQv1vZ3PhUVbiiqkOjLXriLJlo38qZ3k2hvI/JoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
deactivated and fall back to using legacy interrupt injection via vINTR
and interrupt window.

Also, introduce APICV_INHIBIT_REASON_IRQWIN to be used for this reason.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 36 ++++++++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c598ca..4b51222 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -852,6 +852,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
+#define APICV_INHIBIT_REASON_IRQWIN     3
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ac4901c..b7883b3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -386,6 +386,8 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_request_update_avic(struct kvm_vcpu *vcpu, bool activate);
+static bool svm_get_enable_apicv(struct kvm *kvm);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
@@ -4450,6 +4452,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 {
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	svm_clear_vintr(svm);
+
+	/*
+	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * In this case AVIC was temporarily disabled for
+	 * requesting the IRQ window and we have to re-enable it.
+	 */
+	if (svm_get_enable_apicv(svm->vcpu.kvm))
+		svm_request_update_avic(&svm->vcpu, true);
+
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	mark_dirty(svm->vmcb, VMCB_INTR);
 	++svm->vcpu.stat.irq_window_exits;
@@ -5143,6 +5154,17 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 }
 
+static void svm_request_update_avic(struct kvm_vcpu *vcpu, bool activate)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_request_apicv_update(vcpu->kvm, activate,
+				 APICV_INHIBIT_REASON_IRQWIN);
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+}
+
 static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
@@ -5483,9 +5505,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5495,6 +5514,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * window under the assumption that the hardware will set the GIF.
 	 */
 	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
+		/*
+		 * IRQ window is not needed when AVIC is enabled,
+		 * unless we have pending ExtINT since it cannot be injected
+		 * via AVIC. In such case, we need to temporarily disable AVIC,
+		 * and fallback to injecting IRQ via V_IRQ.
+		 */
+		if (kvm_vcpu_apicv_active(vcpu))
+			svm_request_update_avic(vcpu, false);
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
@@ -7253,7 +7280,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED);
+			  BIT(APICV_INHIBIT_REASON_NESTED) |
+			  BIT(APICV_INHIBIT_REASON_IRQWIN);
 
 	return supported & BIT(bit);
 }
-- 
1.8.3.1


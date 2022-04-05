Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A944F5515
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443881AbiDFF2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452953AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FE45132B;
        Tue,  5 Apr 2022 16:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSMSQRtlZsUNkYXMdRbMGRmqPbVrtxpIPegYFHHPP4a/53khgN4UFCuLWlrz0kjCD5S+ycM8blytA3avRJ7XhRAGvO+VtJuSq5KAuzAq55QAtvKynSKz6aq7qya9hHMJcf4qvKT9LqakSR0rNsfFi2h18w1AuW7hLQN4tb6k+8jBdFqNbNinwN2oCw0k7x/14Y09d1hznrIF4XsvI3DmkW3qWCSeRZOfBhzQWGjt6gNcbDlDNpIMlOwuDoUOqDDiQVLlH4lpnHdnZrdc0PqfnZNVFmc5sbqZs/d/7AFdvaY9uJcwItPAsmn8MwtRVKSQRTsneDPL57+D5gmQ6dye6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYH8QWqIDTr5SCkJlSwvot345eEaJPHLPXRhOkMoyrc=;
 b=my69GMi/LMMjoxahk550PQtxkVq+r8NLM9nCoec4yn7XfOQqFz0bIeEku4r7uau/R55h7bxeTJfK07Rimjhzss+jdKNcTJQi5dRRt3wNPmmChLw0S896EVP7/5BEqcSd1H/YceNIvJnYFGLH6dI2tVi53KZXL03EikH98EnsF1H5hWQcXdVcQPQQNw/NiC/TMrjrqmH+cUGlR8jvNOgORsUBXE6vxtNfFY12KNeeC2fCMXWHqoFhXJ2VhliykdRR6S3/k+O8iQGC6pzFvOptHccdf5exIO5AYmK/i4QwIpKe83FS9wJL3eoEbJUYhp6hTXMC4mmDnInCreGna+QHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYH8QWqIDTr5SCkJlSwvot345eEaJPHLPXRhOkMoyrc=;
 b=afC3v1BJDqIhI6DVTCKgIlrWX+qUDkz+Xm1Ze+FYSjIFJEShjBWHaxzRrkzamkDrR4GUUc0GhF3eFEM701BncPl0D4IFfqSkpPHdELFazaHo8fkRVUhWWDhiiaW9Uo9hxKpHI/3FCoYlbvUupROm/M4+dqsebRhFwl39qZ/ztnk=
Received: from MW4PR04CA0082.namprd04.prod.outlook.com (2603:10b6:303:6b::27)
 by BL1PR12MB5778.namprd12.prod.outlook.com (2603:10b6:208:391::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:34 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::e) by MW4PR04CA0082.outlook.office365.com
 (2603:10b6:303:6b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:34 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:27 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is present
Date:   Tue, 5 Apr 2022 18:08:54 -0500
Message-ID: <20220405230855.15376-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fe0dedf-ec95-4a86-120c-08da1759593e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5778:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB57788B5CDBAC7EFCC5098E05F3E49@BL1PR12MB5778.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YELKRQ4YxUTzluZDoaDZHBSVB+yws/S5U9hvQEQkNwFUxMh+LBGKQlOHVzugiJUYY68rSV3V7UD+G1MwsdcFQX+91hSdJPmiHzh8Apxf1Y/Kl1/gwNQen8OEVJO8epZoqSDhaAtZT5t8kN+kJ5UVPUunO/2neUFpU4cIFYDz3dEF4IIpb2hdGvhVLT66GxGBKuvC+8ztjLZSMKNID10R3BycbqaLogBReWBp5FnnXSaZ9zskQ+h1s93Il29KWW89WRNz/WB3eSXx7P04Egf6jhixXxZrMMEQYGWiDie8wihQ6y9R99PAXac2usFQpkeOHP03Xxfp7RvtQqJuAcmlgYorqLmagZOlCZjCjKi141dw8YVkSSAh0GvbS7YLQGTJIcsoW7BgXYP49IDUYqTlB7DofMSaxMKLRRF1KrDTIyjWRpNpHXgJnZLYXL1J8PO9KQGaDIIYINm3xGlK6kjA3O6nS3TcKZlJmsftcPmcepqRa2spvYuHH00T/w0BeEUYTsCePvydN1EQzbZ/TokWjuz6uUjMjqNnSPOIijqfdWzhwgYCLyhg175R3pll0w+wkl6HsIOcu8KB+w5bfCtn8OAziAdmWsn+J/eUJ4jls6t8bI7BtXdJ+vjIUUG/AFi+WU6KyoYYyR5SrmuhrCzzpo9WfURWFMuZNvfZJvFarvgSdx+ayI3XWPdwqa/6/WBS8Nqp2eS08NQ3v5TiQ7/CA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(110136005)(70206006)(81166007)(356005)(6666004)(7696005)(508600001)(82310400005)(316002)(86362001)(8676002)(4326008)(54906003)(70586007)(83380400001)(40460700003)(47076005)(2616005)(1076003)(36860700001)(186003)(16526019)(26005)(36756003)(426003)(336012)(5660300002)(44832011)(2906002)(7416002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:34.0771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe0dedf-ec95-4a86-120c-08da1759593e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5778
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
This is because AVIC cannot virtualize x2APIC mode in the VM.
With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC is
no longer enforced.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c  | 18 ++----------------
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a6e161d62837..335783d2d375 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -21,6 +21,7 @@
 
 #include <asm/irq_remapping.h>
 
+#include "cpuid.h"
 #include "trace.h"
 #include "lapic.h"
 #include "x86.h"
@@ -159,6 +160,26 @@ void avic_vm_destroy(struct kvm *kvm)
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested)
+{
+	/*
+	 * If the X2APIC feature is exposed to the guest,
+	 * disable AVIC unless X2AVIC mode is enabled.
+	 */
+	if (avic_mode == AVIC_MODE_X1 &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_NESTED);
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 56ad9ba05111..62f8c6bf3baa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3998,23 +3998,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		/*
-		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-		 * is exposed to the guest, disable AVIC.
-		 */
-		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_X2APIC);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_after_set_cpuid(vcpu, nested);
 
-		/*
-		 * Currently, AVIC does not work with nested virtualization.
-		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-		 */
-		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_NESTED);
-	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0bbbe8d6a87a..35f57952e9ab 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -570,6 +570,7 @@ int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
-- 
2.25.1


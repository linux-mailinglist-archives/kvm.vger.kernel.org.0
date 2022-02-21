Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE684BD3B2
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbiBUCXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343577AbiBUCXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:18 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2075.outbound.protection.outlook.com [40.107.102.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C0F3C714;
        Sun, 20 Feb 2022 18:22:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiyOXAihlW8D2vBsuRiKOB9ExagBufxcQVHBzDEA0szWcV9sgnJUQh5Ya/XLshHeQB/YfAlatkHXrd3TRJlUBB2e9Mdg00F5mCoVZ2EB05m58dsnyKYll7BK6kAELnfgfcT1kKdaEx3UH55CctXXiLkfhXNb2wrcEmMKn4aFoXtt34cTfKTcQIB+cx4Bct3NVys01XTfQiZGa20tfSQyBiacMVm/r0LPC7RTWlVwvceDefzPRE86wNiq9cXBslJBETXNZx6VpyP2jyXTWfEpaj+JgV7TN3xEBY8vp4ingM378/r/HQqjxyjjR1EEONomGFSLCQI/0+4MoA9B7aOD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvIp0p4pZlBVKI2PFQUjtOkxcwpA/DW+EYwkCT75Fto=;
 b=aoe0VakwPGgLCXW4Ul3zX1mMYFzirafKnKHZl3INHRsr/BcdV/h0vAfgfMQKvDhOiaDY0oO4xsOGvKTuFpTYZGAi4KvtRJXx37tLSwtJ6tP++c2vQ7zWA/1jegsjrp7CvXi+kzXIUCRrhJc+y75+1tl+1TEPcb7PHpbaPOgb2K+Mdk3vCjXkXbUAxbBSxJCRkKjdpepMKXa3ZeJBK6m0rd020a+yN7NVqie7suvpYs5pJQyNzv2VXp+EAu/kSbqp8R5iNH1tdLbfNab8YYTI1PPIxH9uQ+nfPlLOPAYD4uWDo4qjrFbCJoB4miQtTnG8nBkT6jYbrqzDDwmZ3qv/EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvIp0p4pZlBVKI2PFQUjtOkxcwpA/DW+EYwkCT75Fto=;
 b=dkkuHRc+NW/+5z1DoqkRvdb5qCVJuHSsqa0YAKRgPYs9mpvi/8Ho1L2NDl3LtTr3F3VG2Uq5ObJy1FeKbZTveNSZe2HHmCbA0MSUbnaXt9BV+KXmJjOV6ZGzS00poNZcfm0N4dKShdCg5gFLVanVbliGDCoaZVbFzADKIUEcS5s=
Received: from MWHPR1401CA0002.namprd14.prod.outlook.com
 (2603:10b6:301:4b::12) by CO6PR12MB5395.namprd12.prod.outlook.com
 (2603:10b6:303:13a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 02:22:53 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::6) by MWHPR1401CA0002.outlook.office365.com
 (2603:10b6:301:4b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:53 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:49 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 12/13] KVM: SVM: Remove APICv inhibit reasone due to x2APIC
Date:   Sun, 20 Feb 2022 20:19:21 -0600
Message-ID: <20220221021922.733373-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80429246-04a9-4098-6039-08d9f4e110ee
X-MS-TrafficTypeDiagnostic: CO6PR12MB5395:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5395E76C1C0316B26794AE75F33A9@CO6PR12MB5395.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqKOpfGPJQobwNMmn+38xgqlmu43rH6I64O5+OnpR6lOyEsvxkxR01Rzy7E18zf1AXHkt8D3+G+nhH19JfrMv2SwSP/x/SghiQueJMVB+hWkOAZMkzbV0+d+MLgHKc483VowfyycKwtU3DVtoSqfO8N6tSDCGOrIHGJqP0dNs5cNkstdYo2bE8AZ1K4XsXvmYoixYydj9RcVmfu2e0Lz2bdTA35GbgQQ//+xYSzsf9x9RvPhJ7uI07Y22LGCNyBRs5V9LA0L7d+vBxOWCDiGTFcmp/msvIYVxQ6uRKSEHOaSC6Ow65JJGur6wYLCbZxhiczBvkclCwO3QlAPsZvjcQJ5w6h05ESGz5uSPF3xneSi/9IFVDJKpOnHneZGLgJPZB6v/OspDSjzHN/a1OrGIAMYBUSYg/1YNE4RNDzcbXktXEggV8ZPjUkxxECY8HE0+8l425/yQNXs9sxmYE8cMGVWfmeL4NEzrOIRISMLisTaTXm2q+B82uv20Q3wXpVuTE0FdwLF5TSH/awtns+v71XAUKsFZO/sa6/yHLHkVLS+oqYYAE2d14f79f2c8oxT6f1widuuUGDf3aveuMS27sUBgWlvmZym/0ArvTrQBVrv4xRGHumsgQrt32YXQEassvzt/vjjbhuJAXvArTSFS/FKRxz42GIdALG1O2QGClYqJLrICyE4Wv25q86qzwK6El3PlzgWOg2hkqcQPRa3qg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(1076003)(2616005)(8936002)(316002)(54906003)(508600001)(82310400004)(86362001)(110136005)(8676002)(6666004)(7696005)(4326008)(336012)(83380400001)(70586007)(36756003)(40460700003)(47076005)(36860700001)(16526019)(81166007)(2906002)(26005)(44832011)(356005)(426003)(186003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:53.6637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80429246-04a9-4098-6039-08d9f4e110ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, AVIC is inactive when booting a VM w/ x2APIC support.
With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC can be removed.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c  | 18 ++----------------
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3306b74f1d8b..874c89f8fd47 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -21,6 +21,7 @@
 
 #include <asm/irq_remapping.h>
 
+#include "cpuid.h"
 #include "trace.h"
 #include "lapic.h"
 #include "x86.h"
@@ -176,6 +177,26 @@ void avic_vm_destroy(struct kvm *kvm)
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
index afca26aa1f40..b7bc6cd74aba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3992,23 +3992,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index 41514df5107e..aea80abe9186 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -578,6 +578,7 @@ void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
-- 
2.25.1


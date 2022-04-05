Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3ADF4F551F
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573574AbiDFFaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452786AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B8750B1F;
        Tue,  5 Apr 2022 16:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1of8WNjFz9yeN1SGMcDCs8W1yZnz0/gu9YEgC0FsUvBmvU9TMnX+RXnty+J1VIGEYbdexlYVN5YvCmqIiA5Fl684YQS+yIThlQJgHiyLgmt6I9znplnTVPjTUvUAfDvs1MbGByORtSpvEmBXSh66pFsOojZR3RPttQX7sFJnJl+rSdpFkYk3qZk8rh/0cZUT2vdXKJ0il3fUvrv7pX24XydtiW8FqTXUQII84q6KZQCkUUPTT4hS7rvtBKNibnhj1bOrJ84C4IQS5hth4KxwuO8btyuKq3kBtxKRRJ8WooDjF7LU7mqvNFVLgZeBSVyXsbIgljL6tFefwOjxMWZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01k0lDFBrX4TSaFFTyGWe4vMN9NeCWfH/vZTEoeUjCY=;
 b=HY/SeyYlHaidJTLtA4chOqIBwNKU7/OOjMMKvW21PBQgPk4oF3wGqTK0IG3eyGxFMCt9Xn2mxgye42Ds0q8dxMzwuegmVhGqSKLvQWJPTne+aNBR1rsdk73gKyrYbZQmWYmpjT9i2fV6L4xVIJ3zEUIMVJtlZDrv9m6AmWa8rz0axZs6Q97g/Ne/arGV26fcGv42JmlyU7tU8BFGAp9ufsiK+Gm8ECbqmaKyt5vx+fYXGqvUDf2BpRMyL+vrN0RaFiFOJQdPr7sRJYPfKnmFQuEFEFF+K7ifBU28RdGSs593FyCPQnda/3PlKWSWYKXatbao860gRZRuJFptVptYwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01k0lDFBrX4TSaFFTyGWe4vMN9NeCWfH/vZTEoeUjCY=;
 b=j4nrpcSf8iLoHPjp7jaRRfUZ/asaTtggLUmGqbXmc+Vk62M2SUqt83TfnY4RdrT8tm2DN45WSG8cca4zckTFnUTu9gmx6ij8MPnmKfNvG8YPl9/4ZBdYNk5C5AWnbdxb30wqgo8EE6kIG1zVPW6NVa1IY7KInyUCXLbdqTdIj7o=
Received: from MW4PR04CA0075.namprd04.prod.outlook.com (2603:10b6:303:6b::20)
 by MN2PR12MB2990.namprd12.prod.outlook.com (2603:10b6:208:cc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:31 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::d6) by MW4PR04CA0075.outlook.office365.com
 (2603:10b6:303:6b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:31 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:25 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 09/12] KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
Date:   Tue, 5 Apr 2022 18:08:52 -0500
Message-ID: <20220405230855.15376-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: b8c3a912-21ce-4a12-a25d-08da175957a1
X-MS-TrafficTypeDiagnostic: MN2PR12MB2990:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB299080B45B4744EC68C01876F3E49@MN2PR12MB2990.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Ba+BB3k3v+n9QoxBHgL64O8LWKE8ZK2VgUmN1gwUQ8WbxVKU9A+ZIMR4Ig+0f1716CwYzYXaqrj07Bk2Q1jo7oXOA4/foLjVYi04qaqLNrLQSzD4hyTjwoRtWCk+QSAIw2FwG/Nxp+mXaAf0q/zseKYZZFZH1Ziq2PL0XmW6p6ISPrxgHHEdLG8zjz5TBqejljI0WQUrhNjGxrcx43m1aocrjk4PFsdMu1eF9rRNRVsRen0AJnnoJwCK5rn3cFos6hpi7HYec5aeNYWDdSBkPFWHeAO9ifqksPmBwlgiGuFJWs58k0P4mH8P7JbYr0N24rawst9ml4TK63xSHih6Ipl8QgCr9PoApZGt3A3KTWRnZKjrJ9iS6Zz4+PhV0M84j8BeJMMY0x7RxZliJBRKOXJbBe+aSyhq48afOKMU4vtDL8waOxiM/fl+DQ49ONbzIeG3O2fqCMjNowusxvENJoLHO5GerMaHRNeBIm/lrz7XlglSB+z0puDmLu0yvDdOb55CQ+BHIle7Mq5yiYui6h6QZ5ymyYcyzDdISQIpHJxn4wg8WDsMDkcN93VhqmqWRgR1Vwjf+kQ9K5D6q4N6dmnEFX6EE3s0hdJBqCR4DmQXuR80WyNXRrCCJkR3na8t4SjaH2jEqyqYieX9aEQfDyn1Vc52uCeYYcHynh+QgfvmzOf74Lod2dkXFzAY0sA05bmpkr60DMJyBp07Qy0rA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(356005)(81166007)(54906003)(110136005)(82310400005)(40460700003)(83380400001)(5660300002)(47076005)(44832011)(36860700001)(8936002)(86362001)(4326008)(7416002)(316002)(8676002)(70206006)(70586007)(16526019)(6666004)(7696005)(426003)(336012)(508600001)(1076003)(26005)(2616005)(186003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:31.3741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c3a912-21ce-4a12-a25d-08da175957a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2990
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the current logic for (de)activate AVIC into helper functions,
and also add logic for (de)activate x2AVIC. The helper function are used
when initializing AVIC and switching from AVIC to x2AVIC mode
(handled by svm_refresh_spicv_exec_ctrl()).

When an AVIC-enabled guest switches from APIC to x2APIC mode during
runtime, the SVM driver needs to perform the following steps:

1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
APIC ID support for each mode accodingly.

2. Disable x2APIC MSRs interception in order to allow the hardware
to virtualize x2APIC MSRs accesses.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/avic.c    | 48 ++++++++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1ccf301648a0..2519209c5f4a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -248,6 +248,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 58b58a327826..4f9990526485 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -66,6 +66,45 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
+{
+	int i;
+
+	for (i = 0x800; i <= 0x8ff; i++)
+		set_msr_interception(&svm->vcpu, svm->msrpm, i,
+				     !disable, !disable);
+}
+
+static void avic_activate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
+		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		/* Disabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, true);
+	}
+}
+
+static void avic_deactivate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	/* Enabling MSR intercept for x2APIC registers */
+	avic_set_x2apic_msr_interception(svm, true);
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -183,13 +222,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	else
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 }
 
 static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
@@ -691,9 +729,9 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * accordingly before re-activating.
 		 */
 		avic_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
-- 
2.25.1


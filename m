Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED934BD3AE
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbiBUCXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343580AbiBUCXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508223C703;
        Sun, 20 Feb 2022 18:22:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zvao851NemKXDPJdV5xiT7azcgTtx83gKkWuxNd8OBuAcpSxQAGo44/PijlmR2XvIRVF2SrnyYO6SLRiv0SKx3jdMl6O+eDkeiEG6Eqxo2nJwRspA5K9ojCvzutCp7GiGYSfymWHU9iKtPFKhz/cKHxxzZhmsJ+FLTlgNuLKXi+xCtKjbNMMCz+JORvpGJz+0HROXps7t3sfJw3cAiNiugDMyygQt2kLuoTQbzjLWdJt9Q38zrlTBVEw6ld/7wiN1tzbkkuaHFuSp6F2QpY1QjpBLWcIzY26SqDUi9DfCuEqLaOqcX5eloVe99oWHsh3Q498H+kKmVhy0Rrd/6jzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWqxW5Bk27JG5B8Y/OttJ646HKJr0VU3kxleSYyOppM=;
 b=jIuiYn+w34PBdqOsyqsV/v8UUprxna+LW48MqSGbjFSOpRLMjZuUptw6ddmNVYprPiKUYrbbiTPf/PR7q3fE2XCywbY8srAjpg1L3XI6yIcuMMyoffcwSGT+OrXOjCbJbOTNXRqYXoaHWQ9XW/prr1ds+NHJYZMVy8pOie3Z1NeRxMInkSDE2poi+gc+MnONkuxG3CPysbvVKndTrOcVeS6R8nt6/sq/QHV+hOFGLku4LWaIpqN6G4tZGXWq2CkcxPM0XxQ21WNYxpSC1916XWWIZBTsKvMZfH9TCg0F6ARmcE7TnJonVu2v50qNmmN/zbnemVSy5oVmmr/7BJfm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWqxW5Bk27JG5B8Y/OttJ646HKJr0VU3kxleSYyOppM=;
 b=OMbQmNWEh4JLWezqSZti9UdTr5yR1pchlpXLUwV/slc8wHyI5H2XaHohySpm0lqcJXWVE/TSWu7SGNdVzuBK7nZXuZvGEMA6HyB+VmnM4nBdbY3nA2eoOjUgyG8Z4wcVf4mWy+7K6BQmHFLW+F7dhG2V9kU9VFde2jMlYSlVF7E=
Received: from MWHPR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:301:4b::34) by SA1PR12MB5615.namprd12.prod.outlook.com
 (2603:10b6:806:229::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 02:22:53 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::60) by MWHPR1401CA0024.outlook.office365.com
 (2603:10b6:301:4b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:53 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:48 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 11/13] KVM: SVM: Add logic to switch between APIC and x2APIC virtualization mode
Date:   Sun, 20 Feb 2022 20:19:20 -0600
Message-ID: <20220221021922.733373-12-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 488689bf-d1d8-44a4-7e70-08d9f4e110cb
X-MS-TrafficTypeDiagnostic: SA1PR12MB5615:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB561567F2288DA894A5065D80F33A9@SA1PR12MB5615.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIeQAIqANV76Tv7oOCTy7PtzxzfvhKCwT5zAI5WXUBKLOtmOetto8AJew5f/h1bU3csu0ZiMFYLk1M19PcRv0HHPWnw0zzKBfIlwzHKKNoXVBc+iekPeT/peIDUx2iK5bt/j39krnzC9tkdC9bBp+KyrpvtblYbpR5ScDqOWi2FcmWoOP6ajqlXX/GeZ3wXmeuI+crh/eJ2MLeTxaIYl44hjjm2HLUhccvBP5a+gDM0GikKeiv9NjvCQli2Ag2JffePC/E/RrQOKS8i/91cz/NEc0ICorz8E88nsuaBB2zyy1Sk/B1NIAkyS4+b8QJ8K1as7zF+WDytHx+W0yQvXePG8TasQ5GJYYa8eye8pN3R/Ze+YqqEuqzIaflfwD+9Jxu9uCso3CmiK1P2Bjqx9y158O23ZCkR8S7z2zSXYDuAJGPyNcib41n1y6+62h7fD0HB4UVbca8FNmAUidx0WPhj0/Hd8Q584PlA34vywdjg4LP/Gsocu7n+EJeokHONVxN+Af3wLfCxRiGhFewwouk6VG/EDw+AFu34uikdIwDnVgdDyoJVlMQwI9Kzw+FCJf9c/XsFfcqVWj0hWW6W0L2sGs4NyXk0vSfNnzCsc9+c+JkLOMcayIt0zlsaaTOiGdRmGdZRliVy2c7LATB7HHa4oYCWcbPDznHcOc1Dt9L8x6s0X2GsMUKL33qEdyLj+mJRtHFWDgolo2hyRRjzBGA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(186003)(8676002)(70586007)(70206006)(82310400004)(1076003)(26005)(16526019)(508600001)(2616005)(81166007)(316002)(356005)(86362001)(54906003)(110136005)(6666004)(40460700003)(83380400001)(2906002)(7696005)(8936002)(47076005)(36860700001)(36756003)(5660300002)(426003)(336012)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:53.4351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 488689bf-d1d8-44a4-7e70-08d9f4e110cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5615
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an AVIC-enabled guest switch from APIC to x2APIC mode during runtime,
the SVM driver needs to

1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
APIC ID support for each mode accodingly.

2. Disable x2APIC MSRs interception in order to allow the hardware
to virtualize x2APIC MSRs accesses.

This is currently handled in the svm_refresh_apicv_exec_ctrl().

Note that guest kerenel does not need to disable APIC before swtiching
to x2APIC. Therefore the WARN_ON in vcpu_load() to check if the vCPU is
currently running is no longer appropriate.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 61 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3543b7a4514a..3306b74f1d8b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -79,6 +79,50 @@ static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
 		return AVIC_MODE_NONE;
 }
 
+static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
+{
+	int i;
+
+	for (i = 0x800; i <= 0x8ff; i++)
+		set_msr_interception(&svm->vcpu, svm->msrpm, i,
+				     !disable, !disable);
+}
+
+void avic_activate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+
+	if (svm->x2apic_enabled) {
+		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
+		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		/* Disabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id &= ~AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, true);
+	}
+}
+
+void avic_deactivate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+
+	if (svm->x2apic_enabled)
+		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
+	else
+		vmcb->control.avic_physical_id &= ~AVIC_MAX_PHYSICAL_ID;
+
+	/* Enabling MSR intercept for x2APIC registers */
+	avic_set_x2apic_msr_interception(svm, true);
+}
+
 /* Note:
  * This function is called from IOMMU driver to notify
  * SVM to schedule in a particular vCPU of a particular VM.
@@ -195,13 +239,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
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
@@ -657,6 +700,13 @@ void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
 		 svm->x2apic_enabled ? "x2APIC" : "xAPIC");
 	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
 	kvm_vcpu_update_apicv(&svm->vcpu);
+
+	/*
+	 * The VM could be running w/ AVIC activated switching from APIC
+	 * to x2APIC mode. We need to all refresh to make sure that all
+	 * x2AVIC configuration are being done.
+	 */
+	svm_refresh_apicv_exec_ctrl(&svm->vcpu);
 }
 
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -722,9 +772,9 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
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
 
@@ -1019,7 +1069,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1


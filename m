Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97358519852
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345565AbiEDHgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2050.outbound.protection.outlook.com [40.107.95.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A16F2408A;
        Wed,  4 May 2022 00:32:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEDG5wQBKH28JNI786voK1ptIteq+N5CYTjSrV7pmA0zl9LWnBgl6JRpLWfkmaNFJ5EBYAE1I+cmth7MyveOENrunEscyqVHS0AczQpT0QCSXiMLVWXgOV2ZaCp9r3y45fYAloZYSvsfxCWB31j3Q1kZ3S4l9y65EHH5lhwq3l2f9OL2TgQCrBRNJyAEtWfJRUbnLBowtlwFjvxG2kKNwqar26xlUb01v8s8C1o3gCNthqcEqOg66p7z3CbdCC9zk/dy5ZNsuFAy5TBkVl4eOJNUHCht5uUmKy43OeOSwkUjZSar9igTcd3rM5lt7gtdikIO1aKvVXrLUHOO5CjpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9d1mpnhuBPi06DaWjPziRVs22zzek3stCyobtsuEvcQ=;
 b=n8vmdscnZoxLSvmWpef9MB1rNAXI1HjLCwAeP1zW+NWMrEKfXzdEG7FjaVewrEkMKJPRHsADCSxLBjJSgAVW/8tPv5lYUUkd/wzOSiZ12bf1zAwaDw4axhsrKhl5nbDeEDDwgrSGPpOiT0X8crGlguFYzukTxGMtVKesJ+/Qnmhs4J6P2cmbFAOKl85j/na1aFwZOBw0GCAzQq4YgCrPgIzz/I7pGvCkYw0PIJbCvbhdSRqrL/l/y5ar0tTmKYLRTwVucACJQH/ffDGKnd0mcTjX6Zb5MhgHA6sA/R+FYaqom8vyYKwc67Aj6609zEPgwMptGie+QD4fWiOaVbdsCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9d1mpnhuBPi06DaWjPziRVs22zzek3stCyobtsuEvcQ=;
 b=4Sj+mjoqIbmTasxf09Jbqzu9vkfonY+FzAua5e9qMWbKExV9GLYZIOkZFx7NO4zFjNu72fJD+t0ZFnPraFOzsHjZc6CXB2YEqub5KsePIlrSZpNHwKxe4lNHy1DgJdOZQ00kPyw0VY6bBwbAK9tjeXzP2SnsLROl8vQ1Retz2wA=
Received: from BN9P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::22)
 by DM6PR12MB4619.namprd12.prod.outlook.com (2603:10b6:5:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 07:32:06 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::93) by BN9P220CA0017.outlook.office365.com
 (2603:10b6:408:13e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Wed, 4 May 2022 07:32:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:06 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:32:00 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 11/14] KVM: SVM: Introduce hybrid-AVIC mode
Date:   Wed, 4 May 2022 02:31:25 -0500
Message-ID: <20220504073128.12031-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93a0c27e-df9a-4075-4489-08da2da030aa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4619:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB461945432E7BD908284E6118F3C39@DM6PR12MB4619.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6ErR5aeRwwLX5i95pqhRq3Eelb4eAqrOxbA00ORy3DEQ0DmAev2Xe45grEmx2ImRDeLO67RqbMTWDb6Qlai/Ojv6fcyT7e6e5sx5O3qOG8L6I3/0zd0J29JAIv+x9f2YB7QeWD49blHd6mTC3hdLuC3rr8R4wVgnNDpFrUONQbTcLZuQIKLOkagh7Fc+/+FZ1/Vivbo9ocSSVSIOcbQznsuyJ2eWUD2SaC/g4eGgB9JYptdKsgWAmmAMYczYgVx7iS6TiQPPjLqaYaYg9R5OLPnghiGPY7S/4RA5SspeESKAHidJnxYsFgu4upkf/CRX303vhTo/f2pJ3P/Ss9wkKmDElUNJBx3nvGIu46N79GT9gEGLYd9i58BWkKbOMV3RNsKeg4C8s9IRsOCjeIBb6DN5ljPpQnvZokACDd9D9JHIImE6dKcvyl7ZXLcF/KE2vnOZ1LxI4dcLnM8YB0CxicJ7nfhxm5M+uLXkbVjT0Wa+fpnLxR9gw2vYKx2hTNJjGCAyshgFEjJznnPgCxxRuf0A9SJueD3dCWbLrDs2Ex3T+th6YX+MuEuAvBi3V3JT3z7KAVTR1m2VAfd701ZDmiCSBffi2RQxzgS5o0H/0+DeZrbSPd+8N2/Fj83ieHoXgWXLpHER/+rYS+rsGqz4iBqbH8hToE/ax1lHt0Ts92IVdCJ9/cmpG4PXT4eok9ZU0O/NQhYaKN4Mme2p4Pbvg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(186003)(336012)(81166007)(6666004)(356005)(36756003)(26005)(1076003)(7696005)(2616005)(508600001)(40460700003)(83380400001)(36860700001)(47076005)(16526019)(70586007)(70206006)(4326008)(8676002)(86362001)(2906002)(8936002)(5660300002)(44832011)(82310400005)(316002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:06.0203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a0c27e-df9a-4075-4489-08da2da030aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4619
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
because AVIC cannot virtualize x2APIC MSR register accesses.
However, the AVIC doorbell can be used to accelerate interrupt
injection into a running vCPU, while all guest accesses to x2APIC MSRs
will be intercepted and emulated by KVM.

With hybrid-AVIC support, the APICV_INHIBIT_REASON_X2APIC is
no longer enforced.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++++++++-
 arch/x86/kvm/svm/svm.c  |  9 ---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d07c58f06bed..3b6a96043633 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -92,12 +92,20 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+
+	/* Note:
+	 * KVM can support hybrid-x2AVIC mode, where KVM emulates x2APIC
+	 * MSR accesses, while interrupt injection to a running vCPU
+	 * can be achieve using AVIC doorbell.
+	 */
+	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
+	    (avic_mode == AVIC_MODE_X2)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, false);
 	} else {
+		/* For xAVIC and hybrid-x2AVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, true);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 96a1fc1a1d1b..c0a3d4a1f3dc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4041,7 +4041,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4073,14 +4072,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		/*
-		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-		 * is exposed to the guest, disable AVIC.
-		 */
-		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
-	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
 
-- 
2.25.1


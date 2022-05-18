Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643752BFEA
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiERQ2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbiERQ10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD2B36F0;
        Wed, 18 May 2022 09:27:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmURWlJWNOTBXzc3+h8nuzzv1VQj2uVila+/aPe+Niofnvu3qLHewul9d8GGrO6uBVrS/TTzcBGa8rEPl9gMGi+mlPEMQDioE9YCz2Jluo8C+k6nBfqe/7+Qyib8896dtvUcsakrBUHE5zjhL7P5ePw46RmCajfqGgEWj5XTUTaIof8OnjW3BbTYpkWw0nmxYttigd3x8p+2C5GuAqbE8LlH4LERn853hgw7zBRCbHKCTbhmHRRA5Gc/2R03QTjtyrQs7Cwpvpr1YP4Vxuga7sYGDMyo2UuwtkeTqipLotrRprVFS51/P09hzaLJ2Xaqz95QHt12scHXXJXSSdjP1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cNgGsdFWKRWIjCLSQ4nHmgOHOsK+GyL6ZVYxn6pkHA=;
 b=VdxHCmAh3qXlQwWwKTowHn0qY011iExsLjwbXLNeHxvhJJ7p1vV7FmGe1o8p6Ctp9PKkh1SUOnxeE+CNHVae3NSPugX4yKwZmRectJhMnBHDLI/JSLbJoCmyBUwpaKkFOOeG8KNVgrQL9j9GdtEQDWj3ENNmVe2mArqosv0bbetjkJwl1NmoSxRhv7sQk4zcw//g45hqKwtR+t9ts6AC0QD68qdGG5zHh3+QRUSfHpRlo3ihG6RvOGa7cPsn/VMDfq/9uTDKFaDE+XbKBHl0ByXARBpzBVYWaYpiEcMdZYzKeDpI3rfwggnmPK/odm5R4YIS1Jbx/WsnJ7enr+wWtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cNgGsdFWKRWIjCLSQ4nHmgOHOsK+GyL6ZVYxn6pkHA=;
 b=HZ+CFI3FiTaeO0WFJALtk/7xB2qboMIaxLKircfRC91dLelhOSAJOvgQsld66pRqksydc5sacyCc1kZD7zxkv6HMeBNEqfbTzB9T9ZEPDKsnU+J4Za0EIWir3VuHaYcVsXl9mNeejH1Zky+77MjTc9vbUmhlGfjX2K9s325MvJE=
Received: from BN7PR02CA0010.namprd02.prod.outlook.com (2603:10b6:408:20::23)
 by MWHPR12MB1551.namprd12.prod.outlook.com (2603:10b6:301:9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:17 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::cc) by BN7PR02CA0010.outlook.office365.com
 (2603:10b6:408:20::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:17 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:14 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 12/17] KVM: SVM: Introduce hybrid-AVIC mode
Date:   Wed, 18 May 2022 11:26:47 -0500
Message-ID: <20220518162652.100493-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0c8ca90-a30e-4ad4-de9c-08da38eb464b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1551:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB15518DE59BCEC787DBE3D8EBF3D19@MWHPR12MB1551.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JJR9aP0FnX5sE8rQ0K340jp8ZYnR6LsRs4aVGPI8zpcWbDUEKUD3nucrGJkxfAj95pOKiaUgKiMBh+gfpmNB6Za2HiKJ/va1bdvTk3ZYOWH0sgtz2jvjWk983GavRKOG9/muMXA2MYbjuxBxelyVo6pejLTRxzK4/rjfgRiRr9bYDExYDc23OnXhN8R7wF5uAkVg6gQrqvu5C9EVxDmU9654TsC8eE86gHtWcqU89UkS4LUJNrkSKF4qQj87PrkLoxPr0A6C7945nFVd7KHEx1ycjJ0Pqsenrv0YQbvnYIMjFay6RlSXgCOplHVjlfMUHOLo+mWIUIdYJRfRoMIRPaW8N9c0lHrAETSMglqgGQemj6u+BBy9CklmvXcc45ig5C5P7YiJEVt9OYgXZ/TE/Tua9MGRMEOZjOELo92WO9z1lIWXzG+Y3e/vXJSKfVWYXBhoaLku4cX4lgx6BmVaKPgKdBqy73SnuCs3RoT3H4Xji+D84sKRXlNPogt8Iw/6QULxCW6XvjMxQ8XkTRcgZwsZDTM3u3Uj0XOgYEuBbjDa6+HtDVRUh/F/EM6k9XigUv9XuE1VpKMJeKKeOkHMzLWImguQAloqLQYn93UKdVxVPmuetrpmQlznMdbITldyBzTK56XoxaYiIO3Kw9elhRGf70qteimm4v6MgTuFz7kmj24XPX/3pK+gwV5IzZNt/rQiXOolvGy2elvyZJ/zA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(40460700003)(110136005)(54906003)(26005)(356005)(70586007)(36756003)(70206006)(1076003)(86362001)(81166007)(4326008)(316002)(16526019)(8936002)(508600001)(44832011)(8676002)(186003)(426003)(336012)(2906002)(7696005)(2616005)(82310400005)(47076005)(5660300002)(6666004)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:17.3412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c8ca90-a30e-4ad4-de9c-08da38eb464b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1551
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/avic.c         | 13 +++++++++++--
 arch/x86/kvm/svm/svm.c          |  9 ---------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c59fea4bdb6e..da03111b05f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1051,7 +1051,6 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_NESTED,
 	APICV_INHIBIT_REASON_IRQWIN,
 	APICV_INHIBIT_REASON_PIT_REINJ,
-	APICV_INHIBIT_REASON_X2APIC,
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 	APICV_INHIBIT_REASON_ABSENT,
 	APICV_INHIBIT_REASON_SEV,
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2d9455338b1f..bac876bb1cf1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -71,12 +71,22 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+
+	/* Note:
+	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
+	 * MSR accesses, while interrupt injection to a running vCPU
+	 * can be achieved using AVIC doorbell. The AVIC hardware still
+	 * accelerate MMIO accesses, but this does not cause any harm
+	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
+	 */
+	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
+	    (avic_mode == AVIC_MODE_X2)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
+		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
@@ -978,7 +988,6 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ec2444c342d..e04a133b98d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4061,7 +4061,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4093,14 +4092,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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


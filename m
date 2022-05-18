Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9C152C0A0
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbiERQ2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbiERQ10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD49A777B;
        Wed, 18 May 2022 09:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQLt83nRAE2RZ5yUMTFG9+RopQlzUXtGSXNzio4KuebIMbtIZazL3IZDCFQmOFeji1q5NBSdRBTLtihNETr60vfAwpDwVdEmOxRmafg7ntunowoV/iPFzrAfvEdpIEIxwvWohepBBC/3JCsdvNoE3vtTb5fcZ9wYwl6jDwdXP0ctoPiONsHXm1ZBNDOLbx6ygMlIIYqh7X1ATu+6rrEW1tfOtZ+VOyboLqPpvMKUhELD1RPJ/lj+NXANQkiBbFAOA9ARKfJCqRQEG5HvwmijxDeOdvH74Lqc3sRIG4NdgeIn2RyIeLuSwXhsg0JuU0+F4bjTlZYxGoxl6rS0JtQO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPj83bZ8mihTAUF0tvoNhgkl3Cn0mGFmF6SK7lQl6vQ=;
 b=a0rhuiNOLxO+rDtQ7USSKTNtGqAUJvKSI9ESBgLYZEtZXQhL6+0ekZzzDkWUwfI9DVgJkZI/yCAkslIEdGngYnvSrmZI9DFaMj3ExwYcAdMZHZIiLFn6n+5o3996b37wWG2kJ/47Oa6QmvoBqOj/aX9OQLNu+FyCqCQcNj9VhIaJoApThI17CCwCidtDgI5gf0hw00in5CInk+blAe4t8POQ8bZAXPeoy2++BlFz91qrER0poDwOouFqy2dCTyuRbSMOcwUvIW3MPC18JMN31QJocqxmKlpg0eZy0vaUZaW93vchEykv61rPqFSJyqSkRPbrJZqKUOYHUsswAiNtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPj83bZ8mihTAUF0tvoNhgkl3Cn0mGFmF6SK7lQl6vQ=;
 b=lffppYN4WxhUzwURtqDR6mck76lKlMC4lKdtANUvBKNbNuSQc3Cmg1Fl8v8CvY0N/pXn9/fWv0mTghhyQ9o8jb9VkNtq68ZRx8WjGVSKbmdwn8oUOJlPfFmdq5Zolfpoob6d4EOHtxCTXdEq/JZVrpFbTjWfRAUp6fbq/TA8v1E=
Received: from BN0PR04CA0166.namprd04.prod.outlook.com (2603:10b6:408:eb::21)
 by BYAPR12MB3304.namprd12.prod.outlook.com (2603:10b6:a03:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 16:27:20 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::56) by BN0PR04CA0166.outlook.office365.com
 (2603:10b6:408:eb::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:20 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:18 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 17/17] KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception
Date:   Wed, 18 May 2022 11:26:52 -0500
Message-ID: <20220518162652.100493-18-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c813c516-5356-490b-9891-08da38eb481b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3304:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB33045AABFE678CFD82C52181F3D19@BYAPR12MB3304.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOpTzVF32twR82/tCSrtRgckD61OqhdC6LWqre+QBMBKyGiAbKGduEMJS+UlcFUmQ8X86IQVEt7US+U+focIGsG85ybIA0mmYPT+ANsQAkc7Y0POa4+xvJE4JuJ7FDeSzVT0Tesbc2U3ttLYQcYYmXSNdwRVd/dIuKZdvMyb+IRqjCdLezOIunXE5amE+v8lZekg4+A330WC7Zmud33aOqzt49BUykDX8JUNC2n8BT33LWHBnX4HM3BsZI8BGktdzDSfvsRwIfjqwzL3Q4QSHtuP+Nqb9v7ZkOtUlN0GSX2q5Js0pE4wKHx7B3zXNfaB++LRcVIHCPwpfqyMSdRlKrsQR0qu8yqRO0QMB8bn52qfiT0HDU8wmaweG0hoOw+FPiDwLMhn+V/Iz4VmxpXYJzRjRAQbtctFcvYf57qFLlPBXn3Pm8yMrEHyA592fDiCqjJuvHMT9E7zvtWCgPx9DUD+FZiY7VMPv7yvI1Rvi864YhryiY6xuvriK9M2plBme5qeGO1lXfPiQ+8AcxktVOkdrXslHc8FL6HW7pwmFbVD+Ftw8TNSoAKwYDcRbtDHsIQCL1jYjK0PO9tF9vvrVAxKdS8LqEsuLcWXhXH0pBd54tXIzkh6+jzkoCaHIl5SNPEKdfE9VRruB4Qlp8gKOxN1pa8PStpvp9LEdv153FtNjoUTTFR91EH7CfRiqxMZo8NK3dlhy9qgSj4cnEbh+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(426003)(336012)(40460700003)(82310400005)(47076005)(316002)(54906003)(8936002)(86362001)(36860700001)(2616005)(1076003)(508600001)(36756003)(44832011)(110136005)(356005)(81166007)(5660300002)(26005)(83380400001)(6666004)(4326008)(8676002)(2906002)(7696005)(186003)(70206006)(70586007)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:20.3959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c813c516-5356-490b-9891-08da38eb481b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

- Avoid toggling the x2apic msr interception if it is already up to date.

- Avoid touching L0 msr bitmap when AVIC is inhibited on entry to
  the guest mode, because in this case the guest usually uses its
  own msr bitmap.

  Later on VM exit, the 1st optimization will allow KVM to skip
  touching the L0 msr bitmap as well.

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++++
 arch/x86/kvm/svm/svm.c  | 7 +++++++
 arch/x86/kvm/svm/svm.h  | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2a9eb419bdb9..0d7499678cb9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -100,6 +100,14 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
+	/*
+	 * If running nested and the guest uses its own MSR bitmap, there
+	 * is no need to update L0's msr bitmap
+	 */
+	if (is_guest_mode(&svm->vcpu) &&
+	    vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT))
+		return;
+
 	/* Enabling MSR intercept for x2APIC registers */
 	svm_set_x2apic_msr_interception(svm, true);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e04a133b98d0..4165317c0b00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -750,6 +750,9 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 {
 	int i;
 
+	if (intercept == svm->x2avic_msrs_intercepted)
+		return;
+
 	if (avic_mode != AVIC_MODE_X2 ||
 	    !apic_x2apic_mode(svm->vcpu.arch.apic))
 		return;
@@ -763,6 +766,8 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		set_msr_interception(&svm->vcpu, svm->msrpm, index,
 				     !intercept, !intercept);
 	}
+
+	svm->x2avic_msrs_intercepted = intercept;
 }
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
@@ -1333,6 +1338,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		goto error_free_vmsa_page;
 	}
 
+	svm->x2avic_msrs_intercepted = true;
+
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 309445619756..6395b7791f26 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -272,6 +272,8 @@ struct vcpu_svm {
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
+
+	bool x2avic_msrs_intercepted;
 };
 
 struct svm_cpu_data {
-- 
2.25.1


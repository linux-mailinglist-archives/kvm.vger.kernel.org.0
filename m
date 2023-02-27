Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C576A39EC
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 05:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB0EA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 23:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjB0EA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 23:00:56 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CCD449D;
        Sun, 26 Feb 2023 20:00:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRRUPLrpzZdP9kpRkU+2WiztXWJ6Lc7WErLA0n8BvRfdU7NMvmetHZSNPvnTepLPM0n0M3dD5CyIECSsStZemJPS5SIUVijeXTgPFc3y8SiJsPkv44mCJQBWjXvhBSEhe31kdDlEsfbSIVzTn8ElYwW0A5cLB9LGXXBYkTnb/oeMoQ5mcMBSaetUUBOeoXbVmg4MzrtpGEQWyAJGCMAWk9SZ2okV3zNPRW++vKQinzNOBWNFNIeVKmOZkO00r8sEXakOA4IQtx5NxIGoMUQJxsq/zSza4vpBbLZL3XFSq42uiMt9f286U5upmIWBNM8EprKAM0qkd9fD71UiJh6q2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9u4xVXYBKQLka0SdRLlVEKG9tVqHgP9QE+7II39nWow=;
 b=TRUpU11cDXga+IPJ1RnHk8V8loc69zlAU43pbZz1D9oFF0mBWqJDYsQj5YaYgaMQGd5YpjdhfX2fxessUk3Y17CiJZI46vmAA5n1GcKwt/mxNSgDY0oO5DiFDV9c+tYqTAanP1iU+mTrRhD4X2pznxgmAw2L9AD1pki5OtdWB6G1Q5FrHP5M12SVDuYE28VHBju9dLFIo0pt+XIMjSIZszzXeLPvwXpcpel/oCRfhJGrxH2x6ZrUd9iV0ixPvSP9MtTuXrSnxMaIx9R6l+slbfCTjIgs45/shc48gMKTMrSU8jnmj8ckeec2ESz1IkJ190+GLcXqQVXk4UocsBwSEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u4xVXYBKQLka0SdRLlVEKG9tVqHgP9QE+7II39nWow=;
 b=iPBQSgjT8p3oPG8cF9NqRCiriWHDRRvNOZ63DiN6w8O4A/gyEQTAZWbmjmQmBv9mkZ03dsjKuAiyUO6Ma/BD7/fCkd9K6HmOl9fP63AYYFkOgyIQ9aM6Hju8ADhBnkJ0bzia2r9UF7V0yo16WaH9LilGbpXj4mU6E7agFb1i89I=
Received: from DS7PR03CA0227.namprd03.prod.outlook.com (2603:10b6:5:3ba::22)
 by IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 03:57:23 +0000
Received: from DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::9d) by DS7PR03CA0227.outlook.office365.com
 (2603:10b6:5:3ba::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 03:57:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT114.mail.protection.outlook.com (10.13.172.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 03:57:23 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:57:18 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 10/10] KVM: nSVM: implement support for nested VNMI
Date:   Mon, 27 Feb 2023 09:24:00 +0530
Message-ID: <20230227035400.1498-11-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
References: <20230227035400.1498-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT114:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f73c24a-64dd-45b3-b459-08db1876bb6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2FYZ68RVOM26ioss4wsAUt+vA8/nqGkL4iaygKZAHJTbFQFYn5u0sazX3zDyi9HLrE8yQjq4JU963kJ77JxvfeNObsetK9pYarKw9TzhVRLRfTdOP1Kvtq0yzENbnX0p82eALmcx0ec7gxpbjHzeSHg2J4dybBfd69NhK+ScEo4eGQ+mBzGLI4ZPgU3Ef3WWq37410F4NDLiXh2h1DvUXpo4L5WsZ3br00xu9305beyk3ZWgoYwYmWGCP0Pw669PKeaJBq5KhV6SKC55ElpBYl3aBcXXc9d0LgHz/ZjJNm8IAUYuRtuhuYn24ATa6kD3pD1G+EmXQMQYICcef5N6gzbCj6u3ZUlaSr2PNAbZnKl/RvzU8lmymwdq3+/+LB718RTRx3iz+28+yw63V9ePXvEIoXfAOD12ixUdhbs8SFx0mo7ISmLJyk2V07tt2F6fqqt2P+K/DCk13Vsy/r5DfYyFWgHDYsQCQEM6hmxkgwmU6/KfQC8Za4/v3+24IyW1D7v0ZhvS7qz1mQd6bJrshk+nlTNRo9+ffYCUQkTCWgM1H6IOBn1iSvEcVSYNwXsy1DHXCP58d1apbFIUuKnp6ocj9lX0kJUawT9htOfy5K90BtUE7dG7L8OqpqFcOGMhO7yOKNaP7s+2WCCWeOstHPfhcMjygS/9I5wZqsIi/n0lygWGYyK4XpCZPVPdFbo9CH9tr06swZmRMO3dVm/tvHWtlPhTJ0kvjJXYZTfV54=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(16526019)(82740400003)(81166007)(356005)(4326008)(8936002)(41300700001)(70586007)(8676002)(2906002)(70206006)(36860700001)(5660300002)(40480700001)(336012)(26005)(478600001)(7696005)(44832011)(1076003)(186003)(426003)(2616005)(6666004)(47076005)(966005)(83380400001)(316002)(36756003)(82310400005)(86362001)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:57:23.1946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f73c24a-64dd-45b3-b459-08db1876bb6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allows L1 to use vNMI to accelerate its injection of NMI
to L2 by passing through vNMI int_ctl bits from vmcb12
to/from vmcb02.

In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
vmcb02 during entry and vice-versa during exit.
And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
vmcb02 during entry and vice-versa during exit.

Tested with the KVM-unit-test and Nested Guest scenario.

Co-developed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
- Fix identiation and style issue.
- Fix SOB
- Removed `svm->nmi_masked` var use for nested svm case.
- Reworded the commit description.
https://lore.kernel.org/all/Y9m15P8xQ2dxvIzd@google.com/

 arch/x86/kvm/svm/nested.c | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 74e9e9e76d77..b018fe2fdf88 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -281,6 +281,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
 		return false;
 
+	if (CC((control->int_ctl & V_NMI_ENABLE_MASK) &&
+	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
+		return false;
+	}
+
 	return true;
 }
 
@@ -436,6 +441,9 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 	if (nested_vgif_enabled(svm))
 		mask |= V_GIF_MASK;
 
+	if (nested_vnmi_enabled(svm))
+		mask |= V_NMI_BLOCKING_MASK | V_NMI_PENDING_MASK;
+
 	svm->nested.ctl.int_ctl        &= ~mask;
 	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
@@ -655,6 +663,17 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (vnmi) {
+		if (vmcb01->control.int_ctl & V_NMI_PENDING_MASK) {
+			svm->vcpu.arch.nmi_pending++;
+			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+		}
+		if (nested_vnmi_enabled(svm))
+			int_ctl_vmcb12_bits |= (V_NMI_PENDING_MASK |
+						V_NMI_ENABLE_MASK |
+						V_NMI_BLOCKING_MASK);
+	}
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
@@ -1058,6 +1077,20 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	}
 
+	if (vnmi) {
+		if (vmcb02->control.int_ctl & V_NMI_BLOCKING_MASK)
+			vmcb01->control.int_ctl |= V_NMI_BLOCKING_MASK;
+		else
+			vmcb01->control.int_ctl &= ~V_NMI_BLOCKING_MASK;
+
+		if (vcpu->arch.nmi_pending) {
+			vcpu->arch.nmi_pending--;
+			vmcb01->control.int_ctl |= V_NMI_PENDING_MASK;
+		} else
+			vmcb01->control.int_ctl &= ~V_NMI_PENDING_MASK;
+
+	}
+
 	/*
 	 * On vmexit the  GIF is set to false and
 	 * no event can be injected in L1.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 84d9d2566629..08b7856e2da2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4226,6 +4226,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4981,6 +4983,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fb48c347bbe0..e229eadbf1ce 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -266,6 +266,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -540,6 +541,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
+{
+	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
+}
+
 static inline bool is_x2apic_msrpm_offset(u32 offset)
 {
 	/* 4 msrs per u8, and 4 u8 in u32 */
-- 
2.25.1


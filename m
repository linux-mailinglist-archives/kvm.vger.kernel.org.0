Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DFB791553
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345328AbjIDJ5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbjIDJ5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B436CDD;
        Mon,  4 Sep 2023 02:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI3yQleDK9C01la1wK54A09FLBBe9J6r8fU/7SZC/GdbuPjnMxZ48/vO7H7rm0yR5nXL6u3TGNyH4AYpPB+qakN0xYQ62upu0Z34KwHfTLNW2pJ/grPSF7yoGaBZDQfqrKcBJE0ofGkatuxUVsAYxc7Bv9V1TPiWW5d9rtXiCb/LygZh4FvpFrLhAaibCGMMrhDT0rRphv/SjV8Qn1/iHW4n7cpMJbXhrEDMRMqS4fNUnddAiLJPcWaERmavg+hNvVpYhIP4h1entG2/A0UAUZwB3SyOyt0ze9lLmxTZNdM4WK28Yi0ph3lU33Ta9tjyRtPANPeh3NVA7asSVUHD1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97cPuiHdBVgFWXjozzcAr4IkG+RE59gPVuL/xtgQR/o=;
 b=NCOIBtrHGnkfzjMy/XZm2P7a7m/qZBYrmaiUsV1IhmSmLI6dNmXJI7KO+5Z6oO53S1zBvJg1+S0AejsNARUM2vGxnXbPfqlrID+mfqAlD9lZTNdXj+NP6hLVnKOAZIip0IcB/1MaxQm9m0hv6PKwMTCJJk2A544bWcXPqT7tnuzBaCinQqzq6lRSTSp1L5lE2cserNMRtY2gL7ir3SqTt+rEf1OIj08ASc2x7EuCuaY8w8jt7P0RCW2d44c6OQB7x3jzsfQhPScpvyAm7Kxw27EYOrwQ/SZfGQvPqg1lMKjlrJ311AiywDzJBXdKtkgcchG7miA7oEeNkPOZhMumkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97cPuiHdBVgFWXjozzcAr4IkG+RE59gPVuL/xtgQR/o=;
 b=35LRglZm38hZIUHcRT3uc1YUAelI2rtM+HD17pUPvXKG1rbIjt6g3fDJIz1+y+lSGDFyf0oqPldqhq3s9lKV3RUfxIk0Twbwku9hDorfg4vxEAyhtPyDq0+3XtS3HcZFf7FPnbIEuWcwlQkt4mrmMSpvmJXd7eh9mh1YP0HEu6g=
Received: from DM6PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:333::7) by
 CH2PR12MB4135.namprd12.prod.outlook.com (2603:10b6:610:7c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 09:57:33 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::df) by DM6PR03CA0074.outlook.office365.com
 (2603:10b6:5:333::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:57:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:57:33 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:57:24 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 13/13] KVM: x86: nSVM: Implement support for nested IBS virtualization
Date:   Mon, 4 Sep 2023 09:53:47 +0000
Message-ID: <20230904095347.14994-14-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH2PR12MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: 3edf4798-f9f6-483a-041c-08dbad2d5c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mLR3dp9Kk9uRX6jwFpw6/GCZ6K6Sz+Hn957UnkbAqhM+vq56LxzJRNJTiktRj0NHbULU2GYFxN4TT8E2rSxYJYSskE5ifk5o7gkLoePGC5pYUG2X2t6nYSA7FgomD9vZGfe3BI4sTdq+TLqFTwPpEiKFG3Yaa2xYl8XxkiK9eGxuXkxuVJ2qn4qMXTDvclnJ+7PL/jqrcBk79hMmu7MgSm+sgcOhnw0aKD9ArB+Isf/rVyR+Jfb4sGuP+OUb+UEUv7YEtO6b0ndmOAsNk2ZuS0vYq9TyXnNoJgd4j5bTZM+/pF/E2YaaQH64ddBjjK0tz6BOQgs8abcagW+u8r8fMxmPs/KgPaafZpQxHktivVfu1zTldrTExR3y6ShFfvWLD4N4Z+WomD/+zN4o/invJ51VnCb66xvSQeKyCq3E5DJ2ENp643gVxET7HZ4lyrMoOt6UjweNHrA5fxsdJx/mgjf+u2Gg9CiipnBi+7YTOyTP7LTBtgvumJwQ1fHqDI9GpH+VO3HFKR9f8ap34aWvs+5wl1CTNMEzuxkJ/owupFE7dmVcGrCrg0d8XHc8nIQ4+7K7vjVD1KJMG27fy39HMmi/Cw4ByOZ0dia5QDs99+82w/nAliTbz8ceNPedFzxLZO30FUoBf7FXDZ5ruqrZPOP/ouKCf9cZKa5hB4gdEWz3SVJxf/Gw1G9HBWDWea27QFKUrkeC9NCBKsgbsKMhmSj7gouUz8uh0SM3Y75HBoWb4bNnr/CyNvFDKrrt1cd9vrigx4rxwZuAz6zSuXRgjg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(186009)(1800799009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(41300700001)(40460700003)(6666004)(7696005)(478600001)(82740400003)(81166007)(356005)(83380400001)(2616005)(426003)(336012)(16526019)(26005)(1076003)(47076005)(36860700001)(40480700001)(110136005)(70586007)(70206006)(54906003)(36756003)(2906002)(316002)(86362001)(5660300002)(44832011)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:57:33.4846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edf4798-f9f6-483a-041c-08dbad2d5c3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4135
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle the case where IBS is enabled for L1 and L2, IBS MSRs are
copied from vmcb12 to vmcb02 during vmentry and vice-versa during
vmexit.

To handle the case where IBS is enabled for L1 but _not_ for L2, IBS
MSRs are copied from vmcb01 to vmcb02 during vmentry and vice-versa
during vmexit.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/nested.c        | 23 +++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c           | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h           |  1 +
 4 files changed, 43 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 423a73395c10..101c819f3876 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -16,6 +16,7 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
+KVM_GOVERNED_X86_FEATURE(VIBS)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91..a1bb32779b3e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -616,6 +616,16 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
+
+	if (guest_can_use(vcpu, X86_FEATURE_VIBS) &&
+	    !(vmcb12->control.virt_ext & VIRTUAL_IBS_ENABLE_MASK))
+		vmcb02->control.virt_ext = vmcb12->control.virt_ext & ~VIRTUAL_IBS_ENABLE_MASK;
+
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_VIBS) &&
+		     (svm->nested.ctl.virt_ext & VIRTUAL_IBS_ENABLE_MASK)))
+		svm_copy_ibs(vmcb02, vmcb12);
+	else if (unlikely(vmcb01->control.virt_ext & VIRTUAL_IBS_ENABLE_MASK))
+		svm_copy_ibs(vmcb02, vmcb01);
 }
 
 static inline bool is_evtinj_soft(u32 evtinj)
@@ -741,6 +751,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		vmcb02->control.virt_ext  |=
 			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
+	vmcb02->control.virt_ext            = vmcb01->control.virt_ext & VIRTUAL_IBS_ENABLE_MASK;
+
+	if (guest_can_use(vcpu, X86_FEATURE_VIBS))
+		vmcb02->control.virt_ext  |= (svm->nested.ctl.virt_ext & VIRTUAL_IBS_ENABLE_MASK);
+	else
+		vmcb02->control.virt_ext &= ~VIRTUAL_IBS_ENABLE_MASK;
+
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
@@ -1083,6 +1100,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	}
 
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_VIBS) &&
+		     (svm->nested.ctl.virt_ext & VIRTUAL_IBS_ENABLE_MASK)))
+		svm_copy_ibs(vmcb12, vmcb02);
+	else if (unlikely(vmcb01->control.virt_ext & VIRTUAL_IBS_ENABLE_MASK))
+		svm_copy_ibs(vmcb01, vmcb02);
+
 	if (vnmi) {
 		if (vmcb02->control.int_ctl & V_NMI_BLOCKING_MASK)
 			vmcb01->control.int_ctl |= V_NMI_BLOCKING_MASK;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b85120f0d3ac..7925bfa0b4ce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1084,6 +1084,20 @@ void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
 	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_ICIBSEXTDCTL, !intercept, !intercept);
 }
 
+void svm_copy_ibs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
+{
+	to_vmcb->save.ibs_fetch_ctl		= from_vmcb->save.ibs_fetch_ctl;
+	to_vmcb->save.ibs_fetch_linear_addr	= from_vmcb->save.ibs_fetch_linear_addr;
+	to_vmcb->save.ibs_op_ctl		= from_vmcb->save.ibs_op_ctl;
+	to_vmcb->save.ibs_op_rip		= from_vmcb->save.ibs_op_rip;
+	to_vmcb->save.ibs_op_data		= from_vmcb->save.ibs_op_data;
+	to_vmcb->save.ibs_op_data2		= from_vmcb->save.ibs_op_data2;
+	to_vmcb->save.ibs_op_data3		= from_vmcb->save.ibs_op_data3;
+	to_vmcb->save.ibs_dc_linear_addr	= from_vmcb->save.ibs_dc_linear_addr;
+	to_vmcb->save.ibs_br_target		= from_vmcb->save.ibs_br_target;
+	to_vmcb->save.ibs_fetch_extd_ctl	= from_vmcb->save.ibs_fetch_extd_ctl;
+}
+
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4441,6 +4455,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VIBS);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
@@ -5225,6 +5240,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vnmi)
 			kvm_cpu_cap_set(X86_FEATURE_VNMI);
 
+		if (vibs)
+			kvm_cpu_cap_set(X86_FEATURE_VIBS);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c2a02629a1d1..f607dc690d94 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,6 +584,7 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
+void svm_copy_ibs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-- 
2.34.1


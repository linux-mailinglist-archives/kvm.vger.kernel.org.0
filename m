Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE05A46D6
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiH2KLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiH2KKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:10:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F50636C;
        Mon, 29 Aug 2022 03:10:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl0dm4QhrKLTopKRABFoAtmsTn6x30gAPOj0iaCaIr/UKpmxPqalAr4a/Gbw2fXB3vUzILdCd5F2OAdPS3OuR9WnuIbgWcnI1jBnQenHtbj4W7V+2i3cABTm/375HpnS1+eelRDnqRCArWha4MeoO3LhwlPcrnxN6mvaSUhXCtH7XDHzWU8bN2IFyrEA2Ny8JmqKkYFLpP1k7+dvSBmgpu38Fp09gn0ZG5QVkkb4G1dFB3dSG2CLHcE4/P9PXGMiBGrtwaIzmt9x3ROkjRlmHGUEn5uW7t2odhuEAQQ0d/vVzfoDFPXGMeFIovRHkAq9KGlcBQfHh6/rv2pL0iBjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4hWf2cX8HyJA6YkFBwdnL3SgpKG6/MFN+iTFTu3cas=;
 b=SgRBWNzYONcAm4oRTtDe7ge3aU1HfYWOE42/jWcj5GxXjTNeFwmZBIzvK02Djw3y+wFDojKouG6+DTw5S6wlgkHLvmvX8CvFwc2ySmLtIo+OtZ7psBTOaO+kCQRzSoJHsQ9DbDZm78C/2wd45VebHtGky30A/J3HBGKXR5z8GinX43OBcHUdbG4Y6vwn8VFUzzBmYmIQeiPNWSzHlUNRa83cRTLYDQlcaQoEI3Ub1FqgzH7wM2vP4jkYP2u1/Y4t9XrIPdmC13iR4NXPpPZsj8Bc18rf8A9//x6MFdsRZOuyWFQ6f3il3M18hUBEVrTG+mozUsdxRMXMXUmT79oeiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4hWf2cX8HyJA6YkFBwdnL3SgpKG6/MFN+iTFTu3cas=;
 b=HtSsJpuu45KE2ekyhIWdeB6MqX7f8yzbVkPPr3s6xOeOeY82BdugORkr/JvLB9b/tlaEMjrffqJMTEV/rloOKN5jOD0/w7WvJMzjmlDoZY6KsLRffwRFJYOD2gEd7OPspLaujz8udgd8VCXL5cg+4s0RxMxEfSdqm+cSH28wy+g=
Received: from BYAPR04CA0026.namprd04.prod.outlook.com (2603:10b6:a03:40::39)
 by PH7PR12MB7113.namprd12.prod.outlook.com (2603:10b6:510:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 10:10:28 +0000
Received: from CO1PEPF00001A64.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::ec) by BYAPR04CA0026.outlook.office365.com
 (2603:10b6:a03:40::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 10:10:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A64.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:10:28 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:10:22 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 3/8] KVM: SVM: Add VNMI support in get/set_nmi_mask
Date:   Mon, 29 Aug 2022 15:38:45 +0530
Message-ID: <20220829100850.1474-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cc8280b-669f-43f6-c5af-08da89a6b2e2
X-MS-TrafficTypeDiagnostic: PH7PR12MB7113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zfXCdNpGXmvzHtOZu+RhYXt3cXQVPxlM6a6QQvi9yvTVV+19+cSODizVk4CPFahfzuhxSvF6B+Xm9d8P3XSS21PmMVfwiBXVaRaZHC/2sz2ke8uZe4VvyYpy8mHKUAbixUNxD3egPI1QYqpgEF84udRdLKPkMkE/RnmlF8LBqh/LeLgM5jFt/KEXTii+T340BL5zHgSQ88pjwhpnTcSUlPzlgbPynGrW80K7h7Qvph50eMASk1xGsNHVti/MjN3HPlrSNCqGTqfDHOxWX43dmElODaz8doDAbkaVYhEe5VAAejUSfG9zDy492xMLNyjl+Lm0nsRv1wx4U8oPZGN+FYpb6y8fhfN765Rev5i9mNTmHa00a/r4KtFnmFo13KfJNYaN7SFR7l3bUco+zJueophnb2qGh8JXwNpvYaoeBe19WBaObWVKX6ClTqjJz68NLsZOabK3EZUl/h6SR/fIMkS+o09N5QoEq+UkxThm8qtn7FY+iPeOJjGHFTmMVEOagc1rCGeaFwXXihU7146Rtu7btU4JImVaAKv5dNE08k9+o7EE2Ny/HVVFywjFVsQHayf1qh0sb9sBKmyEde+c0pT8FporRTN2dY9PLqMA2t0JrOZUlxdovf0/zvr9tPMbO9ou1rhAAjHVmEMzpWPP/9l0l0ELImDTurDn5U2G+x7OyyfjEVEPV2NLN7ff6fdFQ75Co0c8seap4VRP3mJHy729eOlmVRPeY9zpFMxaGfdlD2Jr/4jCnxndmfToG7cPhJ+yWmrIpYAEuFjzS0wlUK8JWHqHO79fPaSgU9M7mCzWZgkzD/A9BGXmcGWEYY/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(46966006)(36840700001)(40470700004)(83380400001)(81166007)(40460700003)(16526019)(426003)(86362001)(36860700001)(1076003)(47076005)(186003)(336012)(2616005)(356005)(44832011)(82740400003)(5660300002)(36756003)(4326008)(8676002)(70586007)(70206006)(2906002)(82310400005)(40480700001)(41300700001)(478600001)(7696005)(6666004)(26005)(54906003)(8936002)(316002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:10:28.3254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc8280b-669f-43f6-c5af-08da89a6b2e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A64.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK
as read-only in the hypervisor except for the SMM case where hypervisor
before entring and after leaving SMM mode requires to set and unset
V_NMI_MASK.

Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
L2, and also API(clear/set_vnmi_mask) to clear and set mask.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
* Handle SMM case
* Added set/clear_vnmi_mask() API.

v2:
- Added get_vnmi_vmcb API to return vmcb for l1 and l2.
- Use get_vnmi_vmcb to get correct vmcb in func -
  is_vnmi_enabled/_mask_set()
- removed vnmi check from is_vnmi_enabled() func.

 arch/x86/kvm/svm/svm.c | 17 +++++++++++++-
 arch/x86/kvm/svm/svm.h | 52 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38db96121c32..ab5df74da626 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3621,13 +3621,28 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.hflags & HF_NMI_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm))
+		return is_vnmi_mask_set(svm);
+	else
+		return !!(vcpu->arch.hflags & HF_NMI_MASK);
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm)) {
+		if (is_smm(vcpu)) {
+			if (masked)
+				set_vnmi_mask(svm);
+			else
+				clear_vnmi_mask(svm);
+		}
+		return;
+	}
+
 	if (masked) {
 		vcpu->arch.hflags |= HF_NMI_MASK;
 		if (!sev_es_guest(vcpu->kvm))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..cc98ec7bd119 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
+extern bool vnmi;
 
 enum avic_modes {
 	AVIC_MODE_NONE = 0,
@@ -532,6 +533,57 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
+{
+	if (!vnmi)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu))
+		return svm->nested.vmcb02.ptr;
+	else
+		return svm->vmcb01.ptr;
+}
+
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
+	else
+		return false;
+}
+
+static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_MASK);
+	else
+		return false;
+}
+
+static inline void set_vnmi_mask(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl |= V_NMI_MASK;
+	else
+		svm->vcpu.arch.hflags |= HF_GIF_MASK;
+}
+
+static inline void clear_vnmi_mask(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl &= ~V_NMI_MASK;
+	else
+		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1


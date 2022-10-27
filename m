Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFDA60F2A8
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiJ0Ik5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiJ0Ikz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:40:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D01D81118;
        Thu, 27 Oct 2022 01:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp1+oyWDg3VojRH3E0g4SroUjJRp/eCZvrMLf1jdL7DGh74FcxPktPdTeQMG6TewmInApeWmfwLzMf7QU3QlqHN/L4RxVGo8Geqy1hwQCoy2RjtJqR/WB0LbxQJIgfZZEmtZXp0yccZadtoTNGEcLfqqxGvVHrAYlsqiydMLj76sqGGvwYJHonl24NTgAZKTl359DrMkSaZdlXqmuJIKWIAawy9keBysc1gbKdPx2/EK2EzFowKzzLIjXnOm+zJTlHCOHdQOqpLxMBt9fauBQXHqHSlHI4aGTENlTl5wGJ+qB7oBqM7e3B9SGKX9vQdmw25/8fdzEfMFF9ru1CZSqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8fNxPMdbSh7jOwrDytEMM5OjzTzz0SSsEa7nmd0WLQk=;
 b=c8pWgVzQjGIaB/A+hUHjR4tnBGs3ZMZm2863UR2sdxmBexMe9ugj8/LV+oZ2vPGRsvMxKHKVfA3zVegubnYNmEc7Zw1rArB7zT/PUwraiKNOtN+6l98sb9hBRpcDmOLR5uPQMXLupkD+rJVG5IVGasf8GZNQZvr52tpKPQPjgmvSzkpFtCS/egjNAzDJrSre7PL6hYEAv2LpDbRkzH3K6PdePFNwJRneWj9WqnrDh+V7kjV8zzLfRaG93qLNFSv1Bf6NoVCSPszqHxGqcB8I4Tcr6PLR9jYU2mPUSkNRQ7PGwe2K1LUQqtn2LV50OIPk59JhoVy3ILVRW9YMDHG6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fNxPMdbSh7jOwrDytEMM5OjzTzz0SSsEa7nmd0WLQk=;
 b=hqEAbKglHpA6k9hpm7psVUNqBFQupH1cBAhEBatsidMkqbK2rCE9e0166Y2P7pjbrWnhboXT8eVlOLn125HRUtmcjrL59mlokI9cV0Pmp5MZHBBeOB4YWjoBO/eaGIFR92VM5KZIL6tWIDDszArp5cOUlD4D+KfmxZHnEJSN7I4=
Received: from BN9PR03CA0928.namprd03.prod.outlook.com (2603:10b6:408:107::33)
 by CH2PR12MB4199.namprd12.prod.outlook.com (2603:10b6:610:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 08:40:51 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::81) by BN9PR03CA0928.outlook.office365.com
 (2603:10b6:408:107::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Thu, 27 Oct 2022 08:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:40:50 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:40:45 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 3/8] KVM: SVM: Add VNMI support in get/set_nmi_mask
Date:   Thu, 27 Oct 2022 14:08:26 +0530
Message-ID: <20221027083831.2985-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|CH2PR12MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 1acb6b31-7710-4827-0682-08dab7f6f406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjCykIE5OoSdR6vE2OogsUbVbY76sH6UOpTeqJukn5fou0Lb9x7Jbs2gA2dJz3p3cg+OkZQKg4+VyGkDAdPCQFLYxB/FcgSg+SXhPv/JnkIoa6tuWtJBaenJ5CPko70j+CNvQ+Kgt/NfnBBmeSzQm+08UMcXleFiCl1UbDAuvF4SKYE+EhZiVxj9Mit2RzkuiSHPrOG3+TiZLwfmz2TgB3xskEUctX0hjp8DLLulhEoLcX5edBg4ppo9kVv9TOVcdaX3W5sP6Z+GRX8BLI3O3JCscvPRGwIYU4sFbAQCnsQxmihyQrnhBc6Yg3ODrKJ9DidJPZnfd0uHKb0af9NI3MwMpugUGnAkddpp57Wdr5nNlxoqEK3O4Xn/B7qi/Nk7+29Odm2MgLzVDkXiCk36zRaArrlokgXxME5nG0LOkg8yLjGwFc9wlitWdU7P/rerFhLGQYoFGRUKWg0DbL5pw5r2uracEoN0o1ViHPA4FSs+HuF6fC41vseVldFt0s+Q+5K1Lb06rPOFk3ecQ3LFTAuEGKJ6V6bnzORSh804WOCRbLJoAeL8JbcBC6TaDA1HSgXsauHQONd/6sR0BCsSoMb0IGxl3PTiYuz+GnT9Luayhl3lPNL4nkU/pfPrGgZpUnZnr6xI70FqfykOJak977Skzu+NMJf7HJ+KbYvZKp/XiFpOf33RosJdRxlcaVE1wIQNDuavFvab9GUHG4B35wtQElJqJEOqWDWewbK1fFEhZrHXnQ9k1Sm9peVtZaXbIoR+SZlHg6dZJcUgPpDKrQokNSHIGpmHYnccUdYAMiVABI4Es0pOL0Qr/8TZn9/b
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(86362001)(36756003)(82740400003)(81166007)(356005)(40460700003)(336012)(186003)(426003)(40480700001)(7696005)(26005)(2616005)(47076005)(36860700001)(6666004)(16526019)(44832011)(2906002)(1076003)(478600001)(83380400001)(8676002)(316002)(110136005)(41300700001)(82310400005)(5660300002)(70586007)(4326008)(54906003)(70206006)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:40:50.9751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acb6b31-7710-4827-0682-08dab7f6f406
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index b759f650fe2d..cb2eb5581d71 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3620,13 +3620,28 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
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


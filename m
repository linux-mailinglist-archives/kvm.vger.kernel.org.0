Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C816A58E735
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiHJGQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiHJGQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:16:11 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A91224BC7;
        Tue,  9 Aug 2022 23:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Revx+4IIqmWlZzmQqN6iOCn8MlISmiGWqmE0HGM7sBzxga67hbhkK1mSiyO1KZu6tH3msrFJixt8bRcCxfUccxZRHKTLGjv78FAtWYGmSioUZKwHy1siSgBIF5z+6L3k9iVTguAT9aqGyMGDvTisEC5JvfAiomH7g/fBzLJrceN2NUqBP3uxIxZK4VnUIkpoLnyo2P2gEK5POemW8KPDZOCNLPWadLGX034j/vfFVnuOrCEWUR3xoy97iNb/RLzh/bK+kZ0xdlfmrYTif4WVy8u/nsN2ZycJcfuC51GDYrQ2aTNGaYiAR8YrcrjKX+Qdt7KQh6q+1z6flgWLEEuvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GR4F0hLb1RfTPlWxdUvliDgkDtRGi/1FubkI13uYPg8=;
 b=Ex72Tzx5vIsyULgZtbJe8LeaWornGCM/9mSgeXRJVltDgDaNWIMC3oS5yDpgwIoipDoDeHKvHV+rixIHplbgcqwvWVM9uf9ZSdaZyitEMrryfFsMJntGCghaoZkH7HFRnPt/fjpLddT6uoQr6kPPBK1wi6aL8bZGEryPCQcv+j7mc8qscARofKVTPX6MKUnbvA1kPzlsugB5rJ3Zw97PNnxag+uLAu9jpNlIhuM9NIncwrei+araRpvWBn8KiBLiAom0bIIvaWkerYUshPhqDfjUVMEdzVOazJtgQjgxutWOYt8UV7OoIOV7a/hrvGzNFIdoOpDA2w7rTSF6h5hTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR4F0hLb1RfTPlWxdUvliDgkDtRGi/1FubkI13uYPg8=;
 b=EW20Ok+Y+R9h4Gm7DeQu66I4LRBqqd9UYfiFtervUYMy7bcND/cp0dbrs7oBJwdKXRAvXYoNyIAUwMWRnUlhRr3TXZIFi3abtd8zvpYPCJlu53I2HI0VCeoPAXHSbs8AEpvFuK1+Ud4pPkXk7iQkOCTUbzRcs/l2i7b062uwp6M=
Received: from MW4PR04CA0061.namprd04.prod.outlook.com (2603:10b6:303:6b::6)
 by BYAPR12MB3240.namprd12.prod.outlook.com (2603:10b6:a03:136::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 10 Aug
 2022 06:16:07 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::9c) by MW4PR04CA0061.outlook.office365.com
 (2603:10b6:303:6b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14 via Frontend
 Transport; Wed, 10 Aug 2022 06:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:16:07 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:15:58 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 6/8] KVM: nSVM: implement nested VNMI
Date:   Wed, 10 Aug 2022 11:42:24 +0530
Message-ID: <20220810061226.1286-7-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c5e26a6-b800-48f8-4541-08da7a97cfeb
X-MS-TrafficTypeDiagnostic: BYAPR12MB3240:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pxln12FpWZ2NWV7qGIDXMYJYlbxT2kXgz6vRWsdBxQX6ZKs9QNM5dUhtuQZVIRb9+EBR2VSfOB3xGYJelBpCgKu8J6YGkYbb3mNYBeD3kfft7VN9Nhe3zeaAuFTGqaUPP6/hmQnPRkFkYpaQTO2sipp+2jXGUeIHMptQkM5BqfeXTFZKh6Ut8hqxv6I6sx0jvWmIXnERrlQLWM+CtVD9n1cSGigAUSJT3tsKNFSQpfUsM+V7uPn1Han5ta+7rsqKnAOwk5A71MomcpaTMY/0gM7TOTkwzgcUCU9WdCnaLu8y9vCl8DoQ+7RlvmdRoWyaoa6MmjMPPgs13BAS8Mr98rlWJWxto/tjxdzQhC3oSNrBfNe2b58h80KFwdSdoGTTfh7JwINaRj7FsmV+wXTHNpFYgT1+OYro9KhOacMoC46Ka6ngTcYbzEIeH14eRr+BT9pkPQDZGLlxEsAJX4nHM9xiw9uAjaVzputaxRLz8Xs54jvXZTOXwIyX1W9oSoQfVpua9Q4zX544856sCHUgffKrHQA8LfEJi5JLRfSD6UneP6vXR6685pCCZwyCWiZnlqe3z9FRZv3V9eUotLadilRAL0UU6uUAxrH45r+E07NCC7CsCb4kzH+CBGC/ZE7re5o808Z+5wGyS/C8WYzFR1NOP8DpfldZZWqTUmHzp1tsqgRAETb27uqhebyPxYUXKUUHaW94vx7RcYh8Z1CI//gCkLAvFqSGZAHarhqGJ2uNuFhAOiYO0iSdvVf4nWTMHz18Aq4UCVdcPv1pdI1pZW9A+DAoaDWBpIJO2m5yBeEL1zAkyUCUh75jJw6/qyuh6ft/F0biWkXlxBXuUZ7NQg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(40470700004)(46966006)(36840700001)(6916009)(316002)(5660300002)(70206006)(40460700003)(4326008)(54906003)(82310400005)(8676002)(86362001)(40480700001)(36756003)(478600001)(8936002)(44832011)(70586007)(36860700001)(2906002)(83380400001)(82740400003)(81166007)(356005)(47076005)(41300700001)(7696005)(6666004)(426003)(2616005)(186003)(1076003)(16526019)(26005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:16:07.0955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5e26a6-b800-48f8-4541-08da7a97cfeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3240
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support nested VNMI requires saving and restoring the VNMI
bits during nested entry and exit.
In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
vmcb02 during entry and vice-versa during exit.
And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
vmcb02 during entry and vice-versa during exit.

Tested with the KVM-unit-test and Nested Guest scenario.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
- Added code to save and restore VNMI bit for L1 using vnmi and L2
  doesn't for the entry and exit case.

v2:
- Save the V_NMI_PENDING/MASK state in vmcb12 on vmexit.
- Tested nested environment - L1 injecting vnmi to L2.
- Tested vnmi in kvm-unit-test.

 arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 76dcc8a3e849..3d986ec83147 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -662,6 +662,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (nested_vnmi_enabled(svm))
+		int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
+	else
+		int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
@@ -1010,6 +1015,28 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
+	if (nested_vnmi_enabled(svm)) {
+		if (vmcb02->control.int_ctl & V_NMI_MASK)
+			vmcb12->control.int_ctl |= V_NMI_MASK;
+		else
+			vmcb12->control.int_ctl &= ~V_NMI_MASK;
+
+		if (vmcb02->control.int_ctl & V_NMI_PENDING)
+			vmcb12->control.int_ctl |= V_NMI_PENDING;
+		else
+			vmcb12->control.int_ctl &= ~V_NMI_PENDING;
+	} else {
+		if (vmcb02->control.int_ctl & V_NMI_MASK)
+			vmcb01->control.int_ctl |= V_NMI_MASK;
+		else
+			vmcb01->control.int_ctl &= ~V_NMI_MASK;
+
+		if (vmcb02->control.int_ctl & V_NMI_PENDING)
+			vmcb01->control.int_ctl |= V_NMI_PENDING;
+		else
+			vmcb01->control.int_ctl &= ~V_NMI_PENDING;
+	}
+
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8c4098b8a63e..c9636e033782 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4217,6 +4217,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_V_NMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4967,6 +4969,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_V_NMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7857a89d0ec8..4d6245ef5b6c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -253,6 +253,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -533,6 +534,11 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
+{
+	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
+}
+
 static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
 {
 	if (!vnmi)
-- 
2.25.1


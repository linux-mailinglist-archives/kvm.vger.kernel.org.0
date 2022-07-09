Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87B56C9A4
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiGINox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGINoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:44:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB977DF41;
        Sat,  9 Jul 2022 06:44:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VY6RpXyNLZNSmsDcUnCBaabnNDfu0Mfist1rU5trmeXqLTPo2ARXZQ1N8Nul2Zb1fT3s0wwsutd9X8mdC4gnWT4hvevKY7Z9wPuDcNR9MNYFB/kHbIIzEYPW2SjeDikIVvoh57kAWq11D52u0xzyv/2dcpKzv2nZrmT7YJ/Ip9yK/mMAAlkeyvAgzhEPBlDnerr3lBWn/F4zJykFeZoGnA+dMWafhkP9G91chyxnUJz64jf1ftqKEAJ2kGHRq5kd8KcJWY+VOuo49EUXc8xY/m2KQ/iOPNKL7j47e3CPVUgwN0Jlz0+ZA/YEjHr8WLmPO9lnLKFQKgtuIMfYVJvrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FVVfUIJQB6fSxS9GmZDX9PHoER4w6yIl0IQ/fAiEB4=;
 b=n708eWLuM/9hb8THVxO1vqBJSmBUK2lwGQfW7PHQWBDgtgl+3ihibknGH2FWxTSIPmzNiZMUMcn9kJQIbBI3w44jhUjLFsdM9wvwwZOlkcDuRnLlUUGYqwc/9cNtk2DR/1Z9VLUsJIpK5LqZyF4WubaG+mO2gJeOOiZpP3w7CT87G/KOO1vIsHruEpWmcrU2TwW6mtlsM6wagIEwwMOStPWkBa9cUyAn0D9bdqfadYkmjLoUMDbVVd9XROBUejaitsCKmLht/ZQg4SutRSybfllXo+zbrNDltKPTPtO2VtUvFrKZSBzZzMT52BIAXRVxUAposz4eJGMCQZ/PISPEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FVVfUIJQB6fSxS9GmZDX9PHoER4w6yIl0IQ/fAiEB4=;
 b=QdUhgS0Ds4Sr6xwlQ70NcbvU9WrCkzi5eN8uJAKyW7Wc4eIXGexShwbduF2WWlL338KEmFa2073/TSjyi3s4Edyz4kbqqK2p48K/UWrBGqL1tTy+R0B9Njz7rRp3MVGBpVFg6dp/wphchJBHfSMGV93keg08H1r9m3WzE8ztWYg=
Received: from BN6PR16CA0038.namprd16.prod.outlook.com (2603:10b6:405:14::24)
 by IA1PR12MB6532.namprd12.prod.outlook.com (2603:10b6:208:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:44:38 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::16) by BN6PR16CA0038.outlook.office365.com
 (2603:10b6:405:14::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Sat, 9 Jul 2022 13:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:44:38 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:44:33 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 6/7] KVM: nSVM: implement nested VNMI
Date:   Sat, 9 Jul 2022 19:12:29 +0530
Message-ID: <20220709134230.2397-7-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30b8246b-7372-418c-4d76-08da61b12ae6
X-MS-TrafficTypeDiagnostic: IA1PR12MB6532:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+ZpsWpBgC8AdPmWouX0r4TDPMsXyV7lEWc4M7SZObSKdXzcIPrB8lEE9C76Sc5ulH7rJEYnaFBBX0X+lRtbaA0yITlkZIJkFC860CtQmlqzEg3hX8UTbrv80/DQbChxa4IyJ+rh5ejDd1ms3HF94jFbrURxTJVPfpwXrEkI6VwkR3b5PtheCFYZg+UxQc76nSXHuBj4Zyb9qc/DQwArNEMs5Xf1yExu0KC/P3CMR+68VNQE1KIgKsNWBItQ56b/dbgbE6Iv8YR2fyqfaaH2laRC30u5XGOcg7MJiieIxBFw8Yi8J7TRvlQ2ywJG4FB5BWhAnIaaRBugJfaL87d8fC3WVVg1qEtOtJOrBiOQld96kPKwbycxcAr1cRT+NwYBegmyNjfoq2CpfQxps+lCja+Hbk6s/OcBI2Z9h4eJXT7xmu+H99IbfKC80AM5ObsiHat4Nl3nxoiUXdsXt5gD42Qxk74Rq/of4eQfSU/JLEgRTDiEEvucu7PDOy2Y6RMHzSj65DrhXZA42TFlwFfOMIzeyzX/CHnf36vn15QZf6oFCLlD8cie5surR4y++j/ct/YKUfJyN1o5FvA/yohsORIF/WCburvAXsnWeftr3vaJNQTQcjru7Ne9Q3Mpp87HkOfjy2dUxTYNlYjiovuyLGfK2GreLUDqvZCoTnubb7Q3+DZ1uvB/+ia7vrVS3o+96PSTTZSuO1I9YLEn+MwCYRJDepAF47JCGHMk6EWMJN75qTb/3YERC1fy91rrq9v05Dpn6YYj1JNrhzUDpWht1NqovguYd+s6lWe9R0DP2h9FIHicXhord/CpcH8BpnfN9R6dnz6aFz4/uqBzvU3IVX2BO/wF6GczjwOZGIc3y1XMgnl6LoQCHt/75RIYEgV5
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(40470700004)(46966006)(40460700003)(26005)(426003)(16526019)(36860700001)(40480700001)(8936002)(1076003)(2616005)(44832011)(47076005)(336012)(8676002)(7696005)(186003)(36756003)(6916009)(54906003)(316002)(4326008)(86362001)(356005)(2906002)(34020700004)(478600001)(41300700001)(81166007)(82310400005)(6666004)(70586007)(70206006)(83380400001)(82740400003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:44:38.2563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b8246b-7372-418c-4d76-08da61b12ae6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6532
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently nested_vmcb02_prepare_control func checks and programs bits
(V_TPR,_INTR, _IRQ) in nested mode, To support nested VNMI,
extending the check for VNMI bits if VNMI is enabled and
on vmexit save V_NMI_MASK/PENDING state to vmcb12.

Tested with the KVM-unit-test and Nested Guest scenario.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v2:
- Save the V_NMI_PENDING/MASK state in vmcb12 on vmexit.
- Tested nested environment - L1 injecting vnmi to L2.
- Tested vnmi in kvm-unit-test.

 arch/x86/kvm/svm/nested.c | 16 +++++++++++++++-
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba7cd26f438f..f97651f317a0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -629,6 +629,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (nested_vnmi_enabled(svm))
+		int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
@@ -951,10 +954,21 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
+	}
+
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
-
 	}
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c73a1809a7c7..d81ad913542d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4069,6 +4069,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_V_NMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4827,6 +4829,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_V_NMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f36e30df6202..0094ca2698fa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -241,6 +241,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -510,6 +511,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
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


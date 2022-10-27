Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6B60F2BF
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiJ0InS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiJ0InP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:43:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C9E1578BA;
        Thu, 27 Oct 2022 01:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT1qNd0G/3sKnrVSoz+OIfPPWL26XdnVolH7MsRSs1SMFbYgbFso+bX/Qp/8XxOH2UUONgfSbaDZWWBfgKb+muX676Ig2DbI9amv+kSP3O3yExBYCIf2JX3qbTGWemOZz8Hvx/VWV+XKbASokg+SL9O+GyCJrmsvlJBTVswcKsDfalIHuhDHHj3T6UChQjoKLAFovL4QkHsj1qStFrOBl76Oetb4+0QACTRvKsUKB6/M/hoD5sQcX2KNavZZD8I1HjcKIVP7llSzL8ExTAzQQhBdD/n/kNnqrCUbX3LyO/fJO30EQ3kk9pTcOEgaI1FGwBThRJezx0y4oGMTk3IHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+HM0jLpd86Hg+XGAub60xPoH1ueBYIr5PPN07cEdHA=;
 b=O1iYLQK+oDWH4HZ+1+UEngZJDi1Eo7GtSnPqB/Zw8zxzHL8/l4oPmoGLZ3Rub9LThMaC7ElQyBY9/J9f9hH4iURwl0IDWeMVWQMHQLlJvixFhchMhfPoDNX/vIEf7Tn72a6VicMX/fE1ZtuoJosqU6sWtNoOxU+ZW7xcPmxyZfu4R6iwz5k5AMhuhJZjKVf1cN1X26nf9w2LsmoVyogpLeiHiuLKtVmOhzq/gXQWn41/w0m6936S1HZ+BMAWez6OO99nEqYI7o11N9AP+QbevG379UDUERKmVq4OeXSR8qzhgN6hvQ0fmlrnlo0W5TZOHbo9dfIY+kAjnzF36fXzEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+HM0jLpd86Hg+XGAub60xPoH1ueBYIr5PPN07cEdHA=;
 b=fLEkR+30O0C8lt1u+cqOTMWNaez7X6BXdQQeMM72DEmQiPj4mCNUdmRa1NVODyIshp4yBih4VcG8mmx4+/Cw8zyw2lrrZqrvmP0ZNCSlBbJsqTeW/FybTXacgM2xChDh3/7utnLWkhSzBt41uk+4sUyq9BVcDVGJRc7LYTjAcVQ=
Received: from DM6PR07CA0125.namprd07.prod.outlook.com (2603:10b6:5:330::7) by
 SN7PR12MB7953.namprd12.prod.outlook.com (2603:10b6:806:345::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 08:43:10 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::8c) by DM6PR07CA0125.outlook.office365.com
 (2603:10b6:5:330::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Thu, 27 Oct 2022 08:43:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:43:10 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:42:38 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 6/8] KVM: nSVM: implement nested VNMI
Date:   Thu, 27 Oct 2022 14:08:29 +0530
Message-ID: <20221027083831.2985-7-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT031:EE_|SN7PR12MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: 5694fa07-882e-494c-c70d-08dab7f7470e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Om1uUHPt5RH62PfaIs8LKdHvimtIM6C0TtrFRR6tjZx+9taJ9MsYiJ3zEeKOxSer2iYJGOKI0xAvQ/Lru0lXsOt9j8NMhC3ziYJp5ixRqjiPSBLO0V4UmoHBD/INEoWV+l1hdVi/eP5PkC7yWs02b+iutWiw9D/OWj6goQ7NE2BgJSsiG49F+jyMVNMHYFP99qxNG3aVZrSLU+UL3HPZ+xA5qzmZnXWkziOt9vZIlzBrASUS3TH45B6LO4jjMkKiOe6CAYE3WbRa1Rfxgfh8UjbWAu88duXBmUkrFIo6yCoOXbQqsZEem/cBw4uLy3MnXMTii84NRwTbaiA8+PBVbJNGVccWLkJx7h4YJIEDozuROMc36A/QTgpDoyPOBEfEGG1XSeBf5Vn4kLyeDlBWbs11dxXgHxBiP0FGobOeVroQntlwcvDUxf8BTg995My/K/lf5qgwudsbOXPAlp6uF2IG8YSb+YAaOa4nCb29I6kHsyjKfprS4NM5Vmw4eCj/+CPeBeEilM14rFLI3NgSBZIUD8usF1AqAZRJfC3ATV5rSpCD10rhucG6tsz02cWCaNjb0lsvsf7ZbReE95FVX5+VMFHIUD+OWQuf/7KVJF9Uodmf89+SFVuSopLEMvZ38VLcmfeswmE743UFWdYrtDK40SbbHasoXBN9qbLRxnOXcIZZ7xRrsah6h+4bb8pvdFHOzTTxvCC7cYh8hpkG2A4OzV8RjDY7DemZAz84JcsILxrXOUPcUW5dXr4aOAWyiWeiKAZ8j+AtPDASSnXB1xQkebdDdGbMg/J+p2Bc0jU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(1076003)(6666004)(4326008)(36756003)(8676002)(36860700001)(356005)(336012)(70586007)(186003)(81166007)(54906003)(70206006)(110136005)(82310400005)(16526019)(40460700003)(2906002)(316002)(2616005)(5660300002)(44832011)(86362001)(26005)(8936002)(7696005)(40480700001)(41300700001)(478600001)(83380400001)(426003)(47076005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:43:10.2521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5694fa07-882e-494c-c70d-08dab7f7470e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7953
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
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
v5:
 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI
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
index 4c620999d230..d1c22c89427e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -640,6 +640,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
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
@@ -992,6 +997,28 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
index cf05a41779f3..d8edd40e48e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4216,6 +4216,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4958,6 +4960,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
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


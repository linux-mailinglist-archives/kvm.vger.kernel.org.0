Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013195A46DE
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiH2KMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiH2KMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:12:00 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01FCB7EB;
        Mon, 29 Aug 2022 03:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFeEPcpPSGX02bPuM7MQy5pVgs1lvULxVMB7zIm2JnfmABGm1zpH80pzL89swCFmrJWTCvRpsahGn6UZOlRH1Nb0po96A082bJ9x0XnfF8RG98R1mhH+VuBlxQJJ7Rt4UhHClBp3RNAO/fwM5Ig5KDwD9GFNM7/x7+REtG0sLrOY1BgkYEdNtAOso53Vx7qyXvtRLgeCCYdphl2P4mIdW4Ebjq3XDdTDUvAlU+Eiu82Ds3v7+qtMnTFKWhRmPew3v7/2rI6nQZQUj+Qo+1DPPIlcyBV7sMduXTHDCZxngNu65U15k3mWfBaxIhAZk39ePU9ObSGWjvC1WMvGhyUalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSvewsmvxCcTYLNh2jK4uUBqj+oiabAnv54l8AY76T4=;
 b=KyKKyvKxAD7McbjzYVBSDDAlbXPAfzyY7EjvfuRkVemz/v+p50pMQi1PMXKEcfgK5tNSI+BXonE0lJPLnZ3KzZAYI7JVz/c9wXVPfHCLtW/3DSid2YNsKGCJCyS/lH2GwJ0xT8xs3VI2zY2YPT3TmEEMTNLfBMHIj7l8HQsSzJjTels8Cs8t3Kk3qzkKe+TiSTUpHKQ0DxiK+pV9VcYolRYIZdC+mIBbfWzpnQOqhfb5jOlfqWqC7A6dcABt2rok7I6oL6UjseVUxZYtfkP0ScYusUkDSLUfUZnmJr62G4TF8oYs0mt9vvfDgKEN0CALkW8TsvUHgrkagNHbsg38XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSvewsmvxCcTYLNh2jK4uUBqj+oiabAnv54l8AY76T4=;
 b=D3Mc8vbhpMsqZ6lJeSBigi784b92DEHz7a0rNTHKt+5bko0kCfg3yjnZvLgsdaOjg/BinRBLroSQzatkNTYYGPAivv0hKkz3JhPlbEzrSHRS25xHiTzu7kVUG/fMABwh0SBFl5DmEY6jdmkMxMDDJkwlHtUFRmBiD/0g0FfJ23Y=
Received: from MW4PR03CA0179.namprd03.prod.outlook.com (2603:10b6:303:8d::34)
 by DM6PR12MB2956.namprd12.prod.outlook.com (2603:10b6:5:182::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 10:11:51 +0000
Received: from CO1PEPF00001A5F.namprd05.prod.outlook.com
 (2603:10b6:303:8d:cafe::62) by MW4PR03CA0179.outlook.office365.com
 (2603:10b6:303:8d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16 via Frontend
 Transport; Mon, 29 Aug 2022 10:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A5F.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:11:50 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:11:37 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 6/8] KVM: nSVM: implement nested VNMI
Date:   Mon, 29 Aug 2022 15:38:48 +0530
Message-ID: <20220829100850.1474-7-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: ed155cb3-400a-4852-5b14-08da89a6e423
X-MS-TrafficTypeDiagnostic: DM6PR12MB2956:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2waBXnPfDzBiawQDhoxTIuBrMBtoC+i95/0/p87dxCS2Lu/IAqKqlb9bJv/tUEQpouP0ImHiLkm8UzipeqxfBM6+PFa7lmVGZVxKPNEh3tKzO+9IkscyMKHCPSuMBziI9seuP2CDy4zJzuv0etSGHR+7eXEF8zXzZj+TZs6jjEzDY8i2sSr70sRUA0K3mHW4KGfBJri2e7APqQ69N9Kp9kDCyrJnI65kJtD5fyYAWsda1qR6cfjqFRYedjna9S3gmEmoyiaIme5+tjsJUA6xUTsECLESFamPw4FTxhBmwZVRzSeY8PWKioPbpeli+hhJzsKC84FT7iB/2zYdsLfkOKGfJRqL1TVmZMLmfu13eBFjVtW04s5iVenztX9cjRVRrWkE+R6R7Aw+OTklfAkNsOaA8OtEVnAUkmzNq31FGF302tBBaR8msvFrWHxbETSlwXcIgR5TRxRDO5/Kk8FsEljDzIwqip2M6F2IgVqQZD+LYV2yBLKSjR3v5LwHmYMqe+IVYaYzorGpmOEv/33lDw8w86vHTkZLqI9PQUSZzFqwVxZoZVSnJ6RVG9hjnqCg5mQud3eUFcNWgkekN2wYjrkJEOYnKQYbTfbH3rt6KMRNgkk1sv2ysIQobMnmE77wI8aGBM9TlbViRKHmpRUjPGuu+id1zqeUpY2ahlxMbg8viEFN+i3kbS8X239dN4My4X7LzekXjx0BDeY5GWJAGl/pKgWAhBVWfPkpBhFANfMCwW7aPE6IL9tcLotEfq8gwXxUPKHJYcJrsyrca0MV2rONrn8H1X04eQBQLdSyffg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(36840700001)(40470700004)(40480700001)(2906002)(82310400005)(4326008)(8676002)(70206006)(70586007)(8936002)(7696005)(6666004)(26005)(316002)(6916009)(54906003)(41300700001)(478600001)(426003)(2616005)(336012)(186003)(47076005)(36860700001)(40460700003)(356005)(16526019)(1076003)(81166007)(83380400001)(36756003)(82740400003)(5660300002)(44832011)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:11:50.9569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed155cb3-400a-4852-5b14-08da89a6e423
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2956
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
index 4aa7606a9aa2..2e50a7ab32db 100644
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


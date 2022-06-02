Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2479953BAB9
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbiFBO2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiFBO2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:28:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1914384A;
        Thu,  2 Jun 2022 07:28:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZTgb7axA73cOy+tg9NTNFt7/MtLfwqVneRkjpzwslK1KH417eSILvywvfjaVR+DhE0fEA7xNHVxF5ZdtcTp0M3ZJukFx4GJrF6zmcjNFt27ojQUznmot/BO8DN2vHVtpePg1Ix5JtCZUUG84ff0/bubh7h3zbnXpO9HqfVMoU/oAQOyLpVXB2vCnCXXCFaUBDvCQghjcr0n/xDJILTShZgBazDYDuAbALOS2aHQEhWq0p/tZ6G8ijTETsMBodklsnpOncPWy4IW4lt3pRJa9VLfnna7KMh+rjn7lg95ay0umUbKcUmlDOQ//iLvRmyL4HBqeL5/huLNZVa/r0cNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyEVcaBruJ4JWrm47fj0kT7aSHHgsOLC3gTRPDHESB4=;
 b=bHrS39CYasqfCXIWj3WzrLBk6liHpsCACDd3SKO+jW/Ktt0vKYFI5/qvBdsdqFBLH3UmeWR3Swi0D2eHbnNFj4+F6Afl+8QadqMvs2lDypPsKYY5E1wLj85zQj73GzTlJSTsbl07QdvUFRyaUxnxgwLCCxVwviCSPKqLIWYPbr3wiRq78F5v2hlQK3G3VIBQ5rga5G7gQGMqzH88IjSP37YNsq2iHXJ+CKRzAfl9xAEOI10y5FFPsY02DAeUVQ7xOSzW/ssjKIf+SICWG/wTx7hrySQ/f0nnMMpMUamCzNTzqQs5B4UIOhXuwglTvL9wcG1CuUcS86yG2oSRJexJHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyEVcaBruJ4JWrm47fj0kT7aSHHgsOLC3gTRPDHESB4=;
 b=qtFvEsyJFPu/j56Ij+oJewhdpsf9xHp/m70u8Wo5MTkakroXGlV8I0erOyOykYqmvAlwwH0byLzLm7cWIBTGCCZ7ETVUvImsYzL/xGbQyrSZHq3H87LsTHdhcwVl15p+CaiWXDRT60aJ2B66OPHAv9EnMv2tJXxiz4JU9bCd8jk=
Received: from BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::21)
 by CY4PR12MB1848.namprd12.prod.outlook.com (2603:10b6:903:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17; Thu, 2 Jun
 2022 14:28:18 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::2d) by BN9P221CA0027.outlook.office365.com
 (2603:10b6:408:10a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:28:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:28:17 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:28:14 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 6/7] KVM: nSVM: implement nested VNMI
Date:   Thu, 2 Jun 2022 19:56:19 +0530
Message-ID: <20220602142620.3196-7-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 286acfcb-1ea2-4682-dd9a-08da44a422f9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1848:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1848652030F5A7EBD1288DB387DE9@CY4PR12MB1848.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3OuF0q8rpvdu09ZJ/5KThFz08dwyCZEjE9axfp9zsMKqdMVfYk5NqTLL4+nWcQZAd8vYdfBgJ4EfiXnyY2X99bnaL+O4DqE5mwi+4BhcuZfRX3zXioLHGG7nBK0FKbzqsMshNQTxT/h9mnbP782TMzYuUqOk8tk2Q0aqS4CbxYn6g7dKnFR2hZxGwaHc9XOEu29cLMkwYKLQIUCtaEWyEebrro3RSUZM0rEsFnxOLTnVjDxsY1Nj/3gLibML6rzCwr1DkYIWZQy6TrDo6JRrR31b7cMPOH5ewIGHqRLZsxH4Qae96KP1LnRjOY1mTP+4iMSXUa5KFTy//P3u3HHhgj3yKEE/YbtmMNaZ2C/MCUJnUuND69O8WPvwhyNIqAisQB1vliizKTk54SEPGdpJXRAwt4T+0y2e0sXo9poMYlGG1iqNVcstw96Kjx4HS21ndntFUoViwoAoR+mHUYE5/RjzX0jmF/wafckmAJ1Ltv7iX8/8TCmA36bIHT6Tfy3m8vOLJNnm4Zr0PXgq432774d1pFn6Q+VywpIMEAZyiXaoGSEbr6khm380/G/c3diVQNoNcwopHJuquXQaL67Ms3NSqqp3YzxsNalkWtZmzQRb3jlVhzYeV4OGoUPCKJofitgib9rOPM5XslEUCfJFjCWymQ8Do1pAbNKc2+b6kTDEZQQliRLC6a2Ls9RQ2RNAozOte87EO5yAbwSuQI5Aw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(316002)(70586007)(26005)(44832011)(1076003)(4326008)(70206006)(508600001)(82310400005)(36756003)(8676002)(5660300002)(54906003)(8936002)(86362001)(6916009)(81166007)(2616005)(2906002)(16526019)(186003)(356005)(7696005)(336012)(426003)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:28:17.7847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 286acfcb-1ea2-4682-dd9a-08da44a422f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1848
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
extending the check for VNMI bits if VNMI is enabled.

Tested with the KVM-unit-test that is developed for this purpose.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/nested.c | 8 ++++++++
 arch/x86/kvm/svm/svm.c    | 5 +++++
 arch/x86/kvm/svm/svm.h    | 1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef..ce83739bae50 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -608,6 +608,11 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
+static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
+{
+	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
+}
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
@@ -627,6 +632,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (nested_vnmi_enabled(svm))
+		int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 200f979169e0..c91af728420b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4075,6 +4075,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
+	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_V_NMI);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4831,6 +4833,9 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
+		if (vnmi)
+			kvm_cpu_cap_set(X86_FEATURE_V_NMI);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 21c5460e947a..f926c77bf857 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -240,6 +240,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.25.1


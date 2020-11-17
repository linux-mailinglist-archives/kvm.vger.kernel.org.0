Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D762B6B56
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgKQRL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:27 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:38625
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728195AbgKQRL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rxuf7vAkDg75XmpFuPhOhS0j6tTR0EmPLNMgjy3Y/H4Cf1zdXABNSJWlbWRX6ImeW+55iasKBfih3l7G5jGCTlrKFL+82gyDoG8UGrixEDpaVmQbA/8/WITLjoNhFXS1HHEYvhBu+swKS5sXfJjOyaElXOFWqwXH+Wh5WusaAOkzeprpfkZG4taK/vUlXZV70Em5d381Q+ue6aleKWW+9X4w6SUIuCPUESsUxBrM1IKNUGh7TyCbhL3NW+cq3cAQnPHPdYsf8gECHGRSesZ/6lqIICBsHI2opQTkxP6W76eRGsEOQE//cYeMwsHyJoFzI0c+/sw/M048nk3SJ8x31Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFh2yeP11XAYkAP/OeVAP2e6Hbfn5Ae0oSITtuw4T8s=;
 b=GoNg9acPjsCP07OBPaD/BsXsV0lUlzHivGoPRiPSySWcwmxFlBG8H1ZuWnU6bNABGnbrnKymcStffS+MqGU4nMe5ABgScfz07Rk5U3vSPRrwRUOI1s0J+Zd/CCV3Hnwo2kTvOjJ4IqUUqh0gsFWXg4hrALS+uxx7zc0P2cthus5XUFWf+TjH/ERODlh1Rz1LCk8ZFdmkkXS/xqwZVdBwTHnowVMLzOOYe8J61d04SkvaNHAmKkHL2NTICkIVR6Wy4n/kZlCw9/K2fxBdtxuuptUeI97s72OgL8NsoMa+tCx1+2O3xuJIM0hMjZzBXLTgI/mYxk+cChBkVLamJJ6Iiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFh2yeP11XAYkAP/OeVAP2e6Hbfn5Ae0oSITtuw4T8s=;
 b=bibio/OoTrCMdCEIqvxsFobrIoiLRObOk9uNyYMmjD7hu0Os8rKjgs/J9TZtKnwp08MKNfbKxi3nqUs3yXsdn6tc2hcBOko8NrdtXoCIkU5fHo8hPxVvBVhLV7vbn/zTuRP+6Gs/p3nImIH3vGEEjLv1gElBure5kMtcPJKWBPw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:11:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:11:22 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 25/34] KVM: SVM: Do not report support for SMM for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:28 -0600
Message-Id: <f3817c9df017b0d0fd89c0733aa68e57b4852570.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0099.namprd04.prod.outlook.com
 (2603:10b6:805:f2::40) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR04CA0099.namprd04.prod.outlook.com (2603:10b6:805:f2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:11:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c73d1828-394c-4ab9-11d3-08d88b1bce95
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17723909604A7972B0CEE31CECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zj14EFvYhynTeU0FQQPStkWWMnA79tBaIYLe7XQcRfL+kUYWbuXw/MeIREjsAEHYer2YlkD0l4tEPuDiV/wZOMNgrR7kRsLthA/SH6kRFuEPKBuosWzTVSaWiBsQgLU+xEVxZvvSCO9wv9cUqcMTIemOS1t7Tyq05fpohCOTk8eUh2P7qRAOsyiYeyAf+nFiJnsLJ1/zEpUKHAyCq9jLl6ys92XZ2qpPyxjKozLUhcDYR3EjI+KB6OFk5MLe2o+k9l8+7mn4BceZXloS2s5EVQDnrjU0nMdTq0C+dD4rv3fkzZu80fE0Vxv2OUJRu9TzmvO17HYfhABIQ+ecBo1PRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GQh8tYgU+USCYEDg2oHm0hiZUGUpH2rSEbttiDEE7KYdGh+lYdHDcQER0atBs4BHiBihGGf4HlILq5MClEFtoKNJN4t4MsnWMj3k228xAhxhta1vPyh2RfOE/L0VLUaX2MkYzTFfdgHX9H9RIrLwsr/xG52lJBOqUtCTJ7NSK4Z3+xTaFq83od/XKE0It70e5PuWPwRs0EMorfKAeDYooVWr9rFde6703OyfD3TefXVsxAehjzpHF7kE8H9XBGjnzwaru/n62JCEYSA84C+CeYcr1TIQQSAilgGzkwdFW7+GxVH0ENR/3QqbGmU/qS/N+l9d2SPLuhEUm/R5qqvy+gzng/lfT+ZtvB6RcJRjeUjYIkyH5qTmJi3E+6QiM6oTojoT6lP8vPXX6VqEdkFNHgUsATtp656o+7aIey+M6Sg3XUlDyiYPuwEzp6r3+Takz+yrtNAgvNg7gj7tH3o8nE9CaM4KfjyGKNcjflYcexT+tnrXJ+BEg5Q1ORyGTMfmD/UyDpuqhi9QKNicR0gOL2cAkxrTIdJzeQeG72cJftuByPjVmgStTNn3ENLosma9qRKeAe/ppka/Tz5Sc3MRiCNOuCxLYFr5/v2Cf5krebdCXE6V7t1BYAxkJNCY0hhJ/DzcD0xqF9oYklH9YC2UNw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73d1828-394c-4ab9-11d3-08d88b1bce95
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:11:22.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJm1kwnWYRPFhYIM+svTHBeg9guMuKpSe31HVwnKEvmzdAxYr9NV604aHTk5KSWgw+CanI4ZtSG87WdvoOXNYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV-ES guests do not currently support SMM. Update the has_emulated_msr()
kvm_x86_ops function to take a struct kvm parameter so that the capability
can be reported at a VM level.

Since this op is also called during KVM initialization and before a struct
kvm instance is available, comments will be added to each implementation
of has_emulated_msr() to indicate the kvm parameter can be null.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd7169de7bcb..51343c7e69fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1091,7 +1091,7 @@ struct kvm_x86_ops {
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
-	bool (*has_emulated_msr)(u32 index);
+	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f5188919a132..f68e6284c3c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3922,12 +3922,21 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
-static bool svm_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
+	case MSR_IA32_SMBASE:
+		/* SEV-ES guests do not support SMM, so report false */
+		if (kvm && sev_es_guest(kvm))
+			return false;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..006d91dca695 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6399,7 +6399,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		handle_exception_nmi_irqoff(vmx);
 }
 
-static bool vmx_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e848fa947d1d..3ac0edecc5f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3777,7 +3777,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
+		r = kvm_x86_ops.has_emulated_msr(kvm, MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
@@ -5789,7 +5789,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
+		if (!kvm_x86_ops.has_emulated_msr(NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
-- 
2.28.0


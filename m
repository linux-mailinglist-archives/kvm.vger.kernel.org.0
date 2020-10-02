Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3B2818BC
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgJBRGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:40 -0400
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:63233
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388551AbgJBRGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnrjKYDf16wxPPxHXuaLGWzGbFmdQff7iOnC0EMk+FQLsWxVB8wD0ktATQDv1MlgMiLI9Ir1LmaN14KxD2vtJb5Hr6CsZ4NrMErJItWDQTX35fJsC5TPcVQkIf0t/a2TSmj9xP6Ty4m4R4OjiQdrSLkpQIwx+yqRAkY6t1MxGiwscIYHq844cdDrk1orvwGV2HmP26cbLslQsu2F5akVsYOua+REDayVsDoY9IVk40VXtdSmLuL1fWCoeIX7yltf58TagUkpOPGHAiBfiI1uQ9DT+bQj6c0wmWOuCESVh/gkY3Js2tQwOF/jZKUTmI6AhV4eF0Hj1YJwQ/GhCSY4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sGdAWs6qF7xvlmoBigtPt/0VIuHw9TXTsk+1RJb9IQ=;
 b=C2Cbr8LFiDPJsFWTf61A5IxOQhMNU70hRHg8jrFIRHxDWD9wBfYk8LcJOK0mnJkq/7t8F8CL8tFssf7GlVtLTTF/iInb9U6K7N1KT78IvNkTG6Mg/A6TPDjAs+AyuHyyHeFbn8/XWzg90UmFNtIpvne8YhSdya7mW3INPHGQmDv54wk13LsPzGyo7I7jZ6IQcdm2vZzGmi8kJ6V03EnWl2jVTkC58g+ou8exRRDftCxT6QaqZy7WxKPbCyRM6BTLXgzYp0FBR2IuIYaUvSqXnLwB3HTNo/C7jW+S5dWccma/AnN8TuPto0Mf4PoR0gw/20qfVJtJK6Jdn7woG0a7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sGdAWs6qF7xvlmoBigtPt/0VIuHw9TXTsk+1RJb9IQ=;
 b=dkS8SiRJL5lsDeEssp1Arf6ujE83+81RJ+c274OFOoQm2RvBDITyWZag5e12prWePnrGNP+22QU/snViaMEJUFMShcE2Z9ycdzBlsyQQE32KnM0F1/4Kcq5ZWiPA0Ruh/iTiafiaUWCDgStdv1JcS6RgRyBvvILXp+J37dBZnIQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:34 +0000
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
Subject: [RFC PATCH v2 24/33] KVM: SVM: Do not report support for SMM for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:48 -0500
Message-Id: <99a8fde909f388884c74b463d4eddeaa313d6468.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0041.namprd05.prod.outlook.com
 (2603:10b6:803:41::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0041.namprd05.prod.outlook.com (2603:10b6:803:41::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend Transport; Fri, 2 Oct 2020 17:06:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21c9f297-52cb-49bc-a729-08d866f58430
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218DD7DF1B99D4598CDF9F5EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFKgi0GSABI0BvY+VZGDG/uxE/867ONPf1CTrEdK4Zm4VBFygPZiY4wkI5SuxWQBMQtyizJSBqJ/rQzyYput6VLFc84PPzM0VB+DI1WowFgALDNnmF+POPPfs8uWOE3nWHFyXV0iCnJUo/X2LZBhIAtQET+JUUhAW3VN99uZnncgBLYfyqBRJhzqEo7uklNkgf21X387zVqYaWWVxu3ZZJhS/NYsSEMdh2ColPPDy4myXS3OcQAbWdg5mB0sxjfkoUViUmc4kiN0ZdzKHeOUEzTn60Co7vuZEXYPpe5Axdra7gYGwXJowe/SjH568M9k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Xazq7XFOfajccEr/kOp2ttLUHvRLryHmEvX+jh4+c4hkrtKbc8ZOv9ZhscmVO+1t1wT5oTk9Nkglu77BJrzunWqZU8ZQ2tTVbl2u6NctoEL0JgqUfieUSuKme3gUC/YZKiEsSOKX4V/DI67nxdTAL20sM+zZEk0PvmRxBYeW4WnhhGMUGN0VUEIjMJTCloc0aIkpgd/5kEyUHaLjD+Ck/K6ZIEJSadBIgQEiC1a7jMDAqhOU/8MQXcncGcPsY2B5l2rikWXSIOtjKV+sLjKbxKeycZsLVoMFJyZ/Kkj4yMVhfEert2iLYmtuPwcvVNrqUY+XwQDqx9a8hcJ3DXhAFXjmuGCXVVqM/CHqAnJabr+FU3K6W8kZF46bwlAXyRR69cx/5tgqjrFgGPopVpRDLXIinyrFO4XM25Ie7nQjqJe1lnVzjuWbwKvW7Ros7z02t1dLVbhpEwx3rcpWXqKxhKDHEQuq0ot1FVoP1THnfzneANzXWHQw5PPsAAnvpd+AFv1hGaj1pJwvvP/fCjNk9Q8gfhUaw3Gn6hZFkKCdhfYFgGbBbN5mXaUC1IQ+ZIdLrnSfU497E2is2KDfUznUZNgjuGfH5M9VXoHUZhgZiYlVmGD881uLDZNVdl9yCpmcOSCVfWRq0unt+BIj+NVQ+g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c9f297-52cb-49bc-a729-08d866f58430
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:34.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjviaB9pZRwxOmMdPriEBWf4xLm51oHr4ADUeB0ohSZb6QTFGrVidcKBwS+K1yB4om/AEyULCywN3Q0vxwEykQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index 44da687855e0..30f1300a05c0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1062,7 +1062,7 @@ struct kvm_x86_ops {
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
-	bool (*has_emulated_msr)(u32 index);
+	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7082432db161..de44f7f2b7a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3934,12 +3934,21 @@ static bool svm_cpu_has_accelerated_tpr(void)
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
index 4551a7e80ebc..4fb4f488d4e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6372,7 +6372,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
index 39c8d9a311d4..20fabf578ab7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3690,7 +3690,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
+		r = kvm_x86_ops.has_emulated_msr(kvm, MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
@@ -5688,7 +5688,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
+		if (!kvm_x86_ops.has_emulated_msr(NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
-- 
2.28.0


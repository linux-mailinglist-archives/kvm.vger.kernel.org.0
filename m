Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE228189F
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbgJBRFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:06 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388372AbgJBRE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcFXwR3ffmEDuV2gAF79K5iXGW6RgXO0kfwLzm0EdQ4bQEnAwjKZ21qLHEUnzyjg4T4Q3fX75yLWu9bFOF8tC3gkzeTAP4KCyn9vEuPGwSKj+w6b8FK+fP0isPtXgt1j5HVMWdJ5mFbLxVmsQVtLZjNfMBLg8M+IGnzcMq0PdUPQFNCWU5zkAGK61aDiToxVGu8FBhQyeM6Z4T9fwznsTjKd38CyunUYAXXdKFoEbWd8nY1+CzTd3ubDaYQyGKY0cTIiSP26gFw5hG4buNHjvZ/CRSIuMVRa8hdZgN4ZW1pHki7QBT/Mhed+ZivE0WxUFJJQ/mi1BVzwACcyArAQzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7vee8SVF3Zz3TBSiO8CKujAE4pUYK5BJSKCCaHw9fs=;
 b=gBHKS+4TI5JDk8aGgetq1DobDyOylkuO1JWXHlj2Cm1dMhNM9ROkjbsATdqmCvjtggTXYPScUCmW4ZQJIufCQDx0hyKdDNS8VydltEhL/py00rY0YQlyAfHeyGSLBwd2U8zy/6MHtWlwVi6mJ0Ga0wHlOLCxb+rEi3ACCbMRR0Bo71Db1bfhKaFeX9sEe3uFGacB4Jjkjbdw1TB4VY3Zt336STulpBV/DSsnKQACjPaIvkjhtoqfJNfVNouZ+uTOIPfi1EBOjOb/s12+5GZVISvJiRyeMwYx5NdvxzKuWrlz7NG5gPm/fIA9fF2J8+y2Sp7rReAJpjMHPAl5alPbqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7vee8SVF3Zz3TBSiO8CKujAE4pUYK5BJSKCCaHw9fs=;
 b=w7v6lZaXpXouOR9Puyr0xcvX4fYJ14+/Y1nzW02OeLahPejFkCwNwi3Kl2Z75cKd3KMRT6a06vDguPCJXEzm0lx6gEghbK+qPJ8y5OIgklJYoYYYNDOJ0c5LhBxAKbH/FG+0S5ynocj1lCoQobrr4OWVHkaq14yp5oagy9rjUpQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:37 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:37 +0000
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
Subject: [RFC PATCH v2 10/33] KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
Date:   Fri,  2 Oct 2020 12:02:34 -0500
Message-Id: <a77104b911d8822d539f928cf31490be537bd157.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0011.namprd07.prod.outlook.com
 (2603:10b6:803:28::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0701CA0011.namprd07.prod.outlook.com (2603:10b6:803:28::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 17:04:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb3ca592-b527-43f5-7f1b-08d866f53e7e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706C96A84AF38F9F4CE4802EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ag8NW7wRZP6haOyQmKcrAiuxRihEILICaO1Ep6Hlwb3ltitk4ilcRdnraIABmy7Twjvt0UNl8P7f6HQB6NFXV83OUpKWjbrPtApym0QJMGXO0PBEPWMvpKxfkUq850nUlHmiXyjSrfVFnEOxI2srrxArvBQZ+t+9G4o/xAkY0MFNHzbWD6Cn/XdSLFGYAjjkUVxotfaDJauTafafvBv6i2KVg5bgX00kcA6MG4iZvZ/TSsZ6OtzJQxg1RHQmQ3S16tx4nbe/9p2U3pkP1MKYNhYT3igWS9FuBaLASESkAd8B2E7PEp19i91pZT8x7Qa1R0omCsvUHMCHFsaVCsIyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UtNhP4FMLUOMiXgupENiPANFVaCIpINeUa8HcT0PeYdydG2Q+cLkzjfQ0+0rRT74y+JPlFRwiAlsDwPdPWQ2Kzr1BEZ/8w8Ji37dEVD8mpx9wFVs+khYvvpe01vmDPrSWanxDybsrcCPGNOOnhw0+4HKn2c0PQt8+O953wAUVc2G5uUKkc9BuO1K1lNDMwu/VVR+cXUsSKbmFiM4j8gGqSs+JlNdf4deG69Yw9K9C7MHAyaJ0V8eqCjUEM9BYUFaco9w3RUAb2Qosx70xpfuk9648cFaMnxOmjMVD0EwPA2D7adcA60swuLDyx0Yum4IRNS2ykvskyNia91gYqcOEk7jbLbr6U5W/fut0sM1QWag0q7eZ7kskrlT/hBqRkxKRSu2YsOueCYLzgex9SR3bU7UeZVfJZb7BOICNx+zyKrYQimV4evxl6PbzYlN6z9BknQq7GCErvq1HInlG1yIM6Hmm1EUgi8TXYEGxC9d43stTsgEvJB8dF/R1Fu94xjwzEBGEAsp4nAOxqx3fKiXRXT9uS5a5ALPd3SC/+5UhP+UYUdyXdbi4i2hemE3ndGO8wtKr8622bjt7RFAV+xwgV7fcBoe1Sex2h8XtkBtzmlkvmVB77UthsnYsUW+cu+uMOaDWf3bhBDPPbKjnkMb2g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3ca592-b527-43f5-7f1b-08d866f53e7e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:37.6092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R3ycfUiLMdbXF8B0vlfAYhOnuhMEikwIPL4kIRaTIILs6sgbQyb+yEs0l0bkT6DFWXKe4tVLeqOrRQ3j8H8gNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This is a pre-patch to consolidate some exit handling code into callable
functions. Follow-on patches for SEV-ES exit handling will then be able
to use them from the sev.c file.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 64 +++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5fd77229fefc..ccae0f63e784 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3156,6 +3156,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
+static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+{
+	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
+	    svm_exit_handlers[exit_code])
+		return 0;
+
+	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
+	dump_vmcb(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return -EINVAL;
+}
+
+static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+{
+	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
+		return 0;
+
+#ifdef CONFIG_RETPOLINE
+	if (exit_code == SVM_EXIT_MSR)
+		return msr_interception(svm);
+	else if (exit_code == SVM_EXIT_VINTR)
+		return interrupt_window_interception(svm);
+	else if (exit_code == SVM_EXIT_INTR)
+		return intr_interception(svm);
+	else if (exit_code == SVM_EXIT_HLT)
+		return halt_interception(svm);
+	else if (exit_code == SVM_EXIT_NPF)
+		return npf_interception(svm);
+#endif
+	return svm_exit_handlers[exit_code](svm);
+}
+
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
@@ -3222,32 +3259,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || !svm_exit_handlers[exit_code]) {
-		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
-		dump_vmcb(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 2;
-		vcpu->run->internal.data[0] = exit_code;
-		vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
-		return 0;
-	}
-
-#ifdef CONFIG_RETPOLINE
-	if (exit_code == SVM_EXIT_MSR)
-		return msr_interception(svm);
-	else if (exit_code == SVM_EXIT_VINTR)
-		return interrupt_window_interception(svm);
-	else if (exit_code == SVM_EXIT_INTR)
-		return intr_interception(svm);
-	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(svm);
-	else if (exit_code == SVM_EXIT_NPF)
-		return npf_interception(svm);
-#endif
-	return svm_exit_handlers[exit_code](svm);
+	return svm_invoke_exit_handler(svm, exit_code);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
-- 
2.28.0


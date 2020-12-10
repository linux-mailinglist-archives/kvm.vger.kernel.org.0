Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465822D640E
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392555AbgLJRNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:13:44 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392489AbgLJRNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qek+XS/7pdg0pgT04Ql7dVDEwxvwxXTu/N0TTR+T4cHrFdDevyjCSx9sh8mTqTeYalUekkc6Wy7B/CMm3iqRvExEorhMTtKbUsWvZjLurtQFLEsxLgm13FERxr4srQZ4t6gepFvJhkUkUd2OHQ/Fli9a0+uSltAevDuY5BDJ5M5MezN+9RINFuve2F6T5w7skL3ovMbuVWqKS9Hm95HiTC4Ue7nOtZmPcsncN9I1LZVbKifHdCMV8iGsvsI9kwtT2uWWhepRJA4sexpWYu+KNVv80vCrtydr7Z4421j6Em+y57LrUrOHwIJsX7tFPaVE1zAgY9AHuZIkf+nS5k1Vqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CmqtN4gBaYiDKhaGn4hwAyhEc/1DYcFY65MrkQf+5I=;
 b=g1JHLk3kIe3X4bhAbbEZBiDgJotGjaczhfAGgx1HTXsfkZzoAkhWizTxfyM5kVMxKAWkqfJM1lMOvRIAtKDvdFW+HQTnESdpZd+MetXS40Cpsw6c7OLZRlYaVbA2nEGBGY5QN2E1368n62R5wVMiiPWwcrfSk3dvsiCYjWGOLKYP+gFf/Ah+GK1IYJ0Vyc/34yNh1Rc1F99cfWwIA37F4qc4d4xTW51Qmr6qXalzH4+3aBHyLwM8MEB9oL2W59JpaVa/tzGXUYLmZGeIG+u8YpTlhz9N78pYhTuY5/Lw2NWrRzhom2VMcFVHlPsThct4vrUYGh83JGAwtoqLkpW03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CmqtN4gBaYiDKhaGn4hwAyhEc/1DYcFY65MrkQf+5I=;
 b=g5szKvevR5Aiv06odTccjv6Qs+LLWp9nczMS+mIJUCBIi2Y0/+QhuOF2/N9qCqcAPRIDVLWy1TQjGth/LggFAIaMMxiTqIiNtaUqFN7NG5XvUDaWLGt4qoQBRSgtzw6fH/pl5qzS1Gpkj2hemq7w5IlYTt7enVWASzt3Tp8yaqo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:55 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:55 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 11/34] KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
Date:   Thu, 10 Dec 2020 11:09:46 -0600
Message-Id: <5b8b0ffca8137f3e1e257f83df9f5c881c8a96a3.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:610:60::19) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0009.namprd14.prod.outlook.com (2603:10b6:610:60::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06d0c3e1-0283-4f7f-1676-08d89d2eb239
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01491E2AF15279A80F0510EEECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D18yWKl2Dv+C0zqpiP7lN7rsLFnYiElCTiuTQ6nq6bfLtc+uWXIGo0KWWOkwY6TKfRq/Qf7kXL39YzQPuEJkuby+3IB4cMG9qS6SSEOpWJif9RNeq7Ae9xgLs69jeMlOGNAohdyb4SvDBjxb+wq6z9Y72PnXM4ukw+LbF1vMUnxsgUSWtDG2+BWtTs1imnTpAfArdb0eVPA609cR1oSRRThnuqejn3/Kxcd/Jh6tj1QOCsbL3yNpWwYTZBdzXQyd+CLLkevyHhHggOakLf+wIRgE/Gu54KBlewYlDaePHoe+j5BrRXfhC0+7iOSm1B5m6CFoxFLhbzQtVk0Axa1pWET+Bs3RkSA8yvEBXm978xLW+vgh1WwGJ5dFw77Y6IXc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0AnR5bse5+04dFzo4qxxL0/LHzhBmiqYsEkq/pbAkTO6POdjkWOid+EQ+WmG?=
 =?us-ascii?Q?whjdxWV1diT6kYk/OoEJYB0ml4wY8GnClSi/scQnz7DzJjNBsxIFrSCRLRJf?=
 =?us-ascii?Q?PFiaPr8tzpACACQa7JSqxGVKG9z1oSOao+K8d14meo3hLAwm5nEHhaPbOHwZ?=
 =?us-ascii?Q?ZLUIxunAPsT56MfX5KvM+LPRKDAqUfpMQZoUPv2lNTtV6xbcBpiLvPJ61VHC?=
 =?us-ascii?Q?p0oc9Zv53mYgfmJp1MDDMSIoFCqbE/0NO4A3UkMoLCYXJvnXyFjYP9i59pMf?=
 =?us-ascii?Q?A8OBhuP+vT4GdFFjW93ItV/ZawfCFbPB80Ww6zlrBTf8ElV2NXUCvOdcH07Q?=
 =?us-ascii?Q?cotwgaXNQHgAeNqnZ81D5XCLj6o89THeGEOoz/9xgvSrQjiy7rFeU0OcSdCO?=
 =?us-ascii?Q?lRyJY2AIVHEv/MWXDlmlzvc2ld3BWOtW9eV2epnlaqKdH6oqUqNfM4o2HDd6?=
 =?us-ascii?Q?+NtT/m2qlq/1xxhiczF9zSqwhqZRk2RPO6Oc4tKLc1BWA8jN6gdze3UAhz+b?=
 =?us-ascii?Q?/Qb6k3z0dBOepbU5k/FDdT1ZdfZJARigG2QLEboxspKHRueMzsQTaa8rxUv0?=
 =?us-ascii?Q?xnzcn+VPfB+hXatUAYfWpRUhmsITzYq2x/mm0Xd13vmd4X9UEXJoThXDQ15D?=
 =?us-ascii?Q?0J17rUQu1GIG8i05IulPaZrRw1fbCvTQcawDXcDQ12mCFHVe/KUKJmKZUila?=
 =?us-ascii?Q?FEBqnULB6dNevywNJ5nzdpeOh5lw/gs/a0TIxltxl/TyQ66ZJQOTAyYQPY/i?=
 =?us-ascii?Q?HpzH2TfJtb7OYhvFL+dXqg6GBx5P6o3DPTrSq5i/Ua3oVkVxVZtsre+XqRrY?=
 =?us-ascii?Q?SyebsO/BAbhaVaiV+0oEZUm61q35aARjSX+bonkaezqHeqyML8y6HfUg7uqP?=
 =?us-ascii?Q?NdNyLSlBXJ+rj63y8dr+qb85iVliiLj81vQj7KUOCtxgQke/jeLSO+qrJaM8?=
 =?us-ascii?Q?iL3DzGiPPcPsyVp2ndUX/glXKiKwKfJN+i1Hsua5yz+QNmt8A24r5+JKNXtY?=
 =?us-ascii?Q?sowu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:55.6017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d0c3e1-0283-4f7f-1676-08d89d2eb239
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUeKvcRild/cLPDI8LJg3ZURo9NgsN5RICn22nmtlP8RIL2n18xKjzjxfPd63+cMKEMrhMqfIzvtHFcRGNkegA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index 3b02620ba9a9..ce7bcb9cf90c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3151,6 +3151,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3217,32 +3254,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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


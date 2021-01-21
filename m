Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1D2FE341
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 07:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAUG5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 01:57:32 -0500
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:35598
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726324AbhAUG5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 01:57:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R92UkCVre8u/zeRHoFAUOHIEG01QSF2jds+EUoRRKWGqaFFT3ja56E/Xx/a3lZTEp7/i8trF0bGPaywPkQiQTz7fPeK9OP4cy5dIqFSavBb1yuetG9168nN/vXvZfNsfxZPD9KFfr5jE7646BQ3TJlJ7V1OrqpFlFQROUC4YKg9o/vqiwF1lCmxuQHPFIXTbeufG8zJkwg/RmeED/+rO2n0lpU24U9jz68iEaEY2K5nadX1Khss0c9qhubxp53lr6poCpZrYRN00SsDf0JD7PqGQJr8pF/VvISbIahffUbEH5bga0+vNTtP1Azdeq+K5kYzXlThboGRXfx17hrb6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWRhRO3ipZl2BovuoC1BQFXysuEQjKHSz4E+7Auq4/4=;
 b=EZP90QTvsUdCr5f5lZ9OtuHU8pxCv6ylqKbRa6pKi/rI9srIG+uSYy0ZGWUyanULOM0hHT1yiDkNmNczEf4iG8sI6CVlSkfaBBZr3FOOyUl1lr76pezljMbdDt8tvlu29aE/Y3oLh1w3ULzUiypPkOf4AiIVDRkYylYR8JBTrB0Ppld5GR2lGbITwr9H5JBQevxi+cFHyMWVPxtyw4KVr0NlXnBimfqjG0Jy2eKQOHV7P5KVeiqWa7fK5jeXDBZcoXdtAXu12IESvkPJD90CtQpOLo9ZWgEZ4SsDKwCkJ8olWnm/tIiCRfJev3ulcCFoOcVdGjDsZopgSa5o9OKWWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWRhRO3ipZl2BovuoC1BQFXysuEQjKHSz4E+7Auq4/4=;
 b=ZMyncybh0jKsiqm028QL4YvykzOwF4up8FEykGoLvCZ2MlxV7qYLZ1iGdg+o1PBY2hpQO4CLnu8dVoz/o9Cdaa2bFcdcBwIgnHtJWo2qsALMUC5tBK7h5yNsTHRrKOXf2k14wkw/6X6zPwqQ27kBIKR9nn4nTR790tP1Iq27IIs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 06:56:41 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460%10]) with mapi id 15.20.3784.013; Thu, 21 Jan
 2021 06:56:41 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v2 2/4] KVM: SVM: Add emulation support for #GP triggered by SVM instructions
Date:   Thu, 21 Jan 2021 01:55:06 -0500
Message-Id: <20210121065508.1169585-3-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210121065508.1169585-1-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 06:56:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbaa2551-4ce5-4228-e1eb-08d8bdd9b472
X-MS-TrafficTypeDiagnostic: MW3PR12MB4441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4441B4BDD53A2F763CBACE66CFA19@MW3PR12MB4441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DROG17Nq0hBRkIZVeljyzbwjUvl7RbdduiLHZAv0KyHFAMEYyuUCVEskq00zitUOju5KHuylGxP6KWVbxvuoaW67YblBpY1rznC6504tV7X2arT/W38SZTVt7tSGidaPsJQTyJTKE/YBsGaLUA4zf15HMkd73r+49rvIzuXutLzmKtgAPJL0NMHSZ8ugEPQiSkAbYSLH9NpJhGLZ73QXQ84ATLH8WW748nz/N5hJkO7/s2SNElVaSLSuTic7YZ2CQHjWvqbVVBqWUR1JFeVilqhQ+lW8NAkbZdSA11B16BP+Ras2ciM7FruTJ1RViu9n1dC9obkWfma9/fIRAQncVP5fIkiAUz+V1NTwZOeNM8vVcDY/f7c2eb3n21GlK2/i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(83380400001)(52116002)(8936002)(86362001)(6506007)(66476007)(6512007)(6916009)(2906002)(186003)(478600001)(4326008)(6486002)(16526019)(956004)(26005)(2616005)(36756003)(8676002)(1076003)(316002)(6666004)(7416002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1g80F0mn5KFKxGfUZHxLoW2meMf+4nY0hrcOeMNIxM81s5JF9iIrp5q83HEE?=
 =?us-ascii?Q?cjzZZfJduAJ8B1SWBrqLlJYfxUubpW49Mlly4OytRlfGto2IEV26louTlnSS?=
 =?us-ascii?Q?J3Uxxhobl57yvYMcLRCmtjNgmKhczKQKXI7VQjrDSZh0+RCgM6/ZJCB8fsnB?=
 =?us-ascii?Q?ytSdg6vW7RIssOu1hIF4ma8qAYsGCUVGGCiqe9Mb8nf1gHRsHUiB6bSX7AwD?=
 =?us-ascii?Q?YS4ataoENxl7GCcH7/Vib/5ZbKd7F8pxT0Fr3CEjIpqAlE1YOQ4vf9/G7Fgj?=
 =?us-ascii?Q?4H3mHLe+gsCDDdyF++lUIrddMMK0KcvI+vRECid5wxniQDY9TZXothyzuyZw?=
 =?us-ascii?Q?cT8XlYPx8EkRnNeHFFR0HxSRZRZjf4hat71Ga0Mu688n+kjMFgpOccFaiu2A?=
 =?us-ascii?Q?TNWHhAsatzzguUWt63cV2DC0ZNIhBZEHiFL/lE5eaE2/ahDyWAUq1axzPZkH?=
 =?us-ascii?Q?eM3Z51bAyxT3bWPL0QUuxTjx7xej1okyQcPEiq7MNA75B+M2cJaxBYDyqGdd?=
 =?us-ascii?Q?3nusl4Oh/Q7dlrx5W2hBuLJ+KylB1IqEXtrV4qPq0FSu969VVgs8CQd3P9qd?=
 =?us-ascii?Q?1LGF8CW46aeXbn+zOuZvKOA89t+h5YjpGkpH1ijFFbNiZB17bgr5PYdjGAiY?=
 =?us-ascii?Q?jOLL4k9NCZx/48WqX2MbjHWxZ+vXOm+dLva+p1M6+YkSpWfr4jf4wwDXN1Uh?=
 =?us-ascii?Q?m7tBVP4gCNlHsWICcZATBr4IomG3gZHgpAjX+cEeXm62iGC9crHwQw1OkXww?=
 =?us-ascii?Q?uBPXrrW4vnlrKP8KPfhaPXx2uMDe0nAJqkU1/9RkJDiFhTc6lqBZCLaFOkH7?=
 =?us-ascii?Q?mYLXeGRkSNeUwbp2iDggTS8Yc6CX1xpMhbvu+MBKE/ov+NykQe4UZ4sEcKdK?=
 =?us-ascii?Q?OLYffxpkLqPw17t8mcU35xrk3zJZ2cHVVaDk9vxtxcYrM4m/JmVfovCiGwcM?=
 =?us-ascii?Q?0YEqQDmjyFJLYHYC83k5n8aWq8CMwym9lPiBnzFrkLxtQUSTK680trw0iCFW?=
 =?us-ascii?Q?SBlu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbaa2551-4ce5-4228-e1eb-08d8bdd9b472
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 06:56:41.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UQNxBTdhJaa3osKSeI2I/c/BmyYjoxQltcV0Y+xYVjBY97mTLJkPW3bT+VyIEH6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
before checking VMCB's instruction intercept. If EAX falls into such
memory areas, #GP is triggered before VMEXIT. This causes problem under
nested virtualization. To solve this problem, KVM needs to trap #GP and
check the instructions triggering #GP. For VM execution instructions,
KVM emulates these instructions.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 99 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 81 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef171790d02..6ed523cab068 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -288,6 +288,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(svm);
 			svm_set_gif(svm, true);
+			/* #GP intercept is still needed in vmware_backdoor */
+			if (!enable_vmware_backdoor)
+				clr_exception_intercept(svm, GP_VECTOR);
 
 			/*
 			 * Free the nested guest state, unless we are in SMM.
@@ -309,6 +312,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
+	/* Enable #GP interception for SVM instructions */
+	set_exception_intercept(svm, GP_VECTOR);
+
 	return 0;
 }
 
@@ -1957,24 +1963,6 @@ static int ac_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int gp_interception(struct vcpu_svm *svm)
-{
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	u32 error_code = svm->vmcb->control.exit_info_1;
-
-	WARN_ON_ONCE(!enable_vmware_backdoor);
-
-	/*
-	 * VMware backdoor emulation on #GP interception only handles IN{S},
-	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
-	 */
-	if (error_code) {
-		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
-		return 1;
-	}
-	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
-}
-
 static bool is_erratum_383(void)
 {
 	int err, i;
@@ -2173,6 +2161,81 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	return nested_svm_vmrun(svm);
 }
 
+enum {
+	NOT_SVM_INSTR,
+	SVM_INSTR_VMRUN,
+	SVM_INSTR_VMLOAD,
+	SVM_INSTR_VMSAVE,
+};
+
+/* Return NOT_SVM_INSTR if not SVM instrs, otherwise return decode result */
+static int svm_instr_opcode(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
+		return NOT_SVM_INSTR;
+
+	switch (ctxt->modrm) {
+	case 0xd8: /* VMRUN */
+		return SVM_INSTR_VMRUN;
+	case 0xda: /* VMLOAD */
+		return SVM_INSTR_VMLOAD;
+	case 0xdb: /* VMSAVE */
+		return SVM_INSTR_VMSAVE;
+	default:
+		break;
+	}
+
+	return NOT_SVM_INSTR;
+}
+
+static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
+{
+	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
+		[SVM_INSTR_VMRUN] = vmrun_interception,
+		[SVM_INSTR_VMLOAD] = vmload_interception,
+		[SVM_INSTR_VMSAVE] = vmsave_interception,
+	};
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm_instr_handlers[opcode](svm);
+}
+
+/*
+ * #GP handling code. Note that #GP can be triggered under the following two
+ * cases:
+ *   1) SVM VM-related instructions (VMRUN/VMSAVE/VMLOAD) that trigger #GP on
+ *      some AMD CPUs when EAX of these instructions are in the reserved memory
+ *      regions (e.g. SMM memory on host).
+ *   2) VMware backdoor
+ */
+static int gp_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u32 error_code = svm->vmcb->control.exit_info_1;
+	int opcode;
+
+	/* Both #GP cases have zero error_code */
+	if (error_code)
+		goto reinject;
+
+	/* Decode the instruction for usage later */
+	if (x86_emulate_decoded_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
+		goto reinject;
+
+	opcode = svm_instr_opcode(vcpu);
+	if (opcode)
+		return emulate_svm_instr(vcpu, opcode);
+	else
+		return kvm_emulate_instruction(vcpu,
+				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
+
+reinject:
+	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+	return 1;
+}
+
 void svm_set_gif(struct vcpu_svm *svm, bool value)
 {
 	if (value) {
-- 
2.27.0


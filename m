Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3972D6340
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbgLJRPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:15:47 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:35297
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404101AbgLJRPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASnuO89WMMycSLqXgFP7OUoOUrBw34AFUZQYoFLxjSfXR3ProcIPngqXW9oIKqjtqe5+TGMnfsCVBigho6QdrLE3UsjCFtprG7/cABcw3z8bSk2udqwjjpb6c+7oU/tUE3VzloGyPPGZFPsFv5cRC80Hao9WPGPMrZKdTIhm/2PmQLd/K0BABfCPtp99wTZv+hucy7xtEt5ZF13nW+NUyV5FlllJ1smMpdn/Ypd1lNkW+lb7LpTSbeA4Q8NGE6lLI15WTT1wlbu9DOj6kDqURz4dTB+YoKXFMwkTA6ScZ4DlM9dKpPmmLH3u/8CleYx23CL9bQM9ep6MDLmoVbiXtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1Xi7z2RN82oW3MFTL0fZz5ePpILWaOpUbbZLgymsRo=;
 b=l/Gy3tJGwGQ2FfGQOKkOAOab+ohCsDboE3rfTuCbgzmsUmAEdpV9GX32k8M3rF5wbUkPZdtwlKZim8J9Zdz+Lx3IP7mxk5v5HJYtL3nVMV+V1CX1DGDdFWQPqJzQGliaUCf8sqYXC7wfgcZQh0yDznhH85dcUanFyIvgZLowpGVrhBo2vGHQaMbeabXmW4dV8UwnfrFjgWboktz0GJyErBpV9k4t0aPwbZhySHI/ug7mMLuP96UN70xNpkKYsMY3KU6E0l7V6wwEcwdWRVIehW+tfJQheL35VVtnvgmE4BBD6oIkibGqbqCui2U2qU0pMKFlW012AMqtiDBM3LA3ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1Xi7z2RN82oW3MFTL0fZz5ePpILWaOpUbbZLgymsRo=;
 b=UGCLiB3MDvX9o0k0Y552iUBeQ4SzSC/sU9Af0oI2Z4K1QQyxMozxCh6pFeb5TmKdInLixhSJ5YcqscbaGXaA2jgvFzZlkj1Iu60DDSrY+Nm5CdKVv78WnUfYgZkKPa9FQYCDuWQk0JeIBCpIF0iY3DYtO6KpxHrh+HqwCGJogtU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:37 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:37 +0000
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
Subject: [PATCH v5 22/34] KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:57 -0600
Message-Id: <c3880bf2db8693aa26f648528fbc6e967ab46e25.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:610:20::24) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0011.namprd07.prod.outlook.com (2603:10b6:610:20::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a502b57d-20a8-417e-aa0a-08d89d2eef08
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014980F50B768219E0FB2E22ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apAP+rd1LCIDO7fr+cSSa//66SmtfbS3TlDRD1cHO9WDJp1F2OmFa+blnrngxA6G5XmTGTzONrPryHJQ98nL0sWcvjlCXfVKfgecFTwZHnMaazrc1M0j2EhsJHfEgcw4m44dfS4VxUU5cH+RkObTXFPQViXNmybawjKEp75ZosYFKqLozZJ1f1yoh2IFWb9MSN0k/AtrtudROwjLbX1iQqdM4hgmtHXvNoCnA2hJOf/sBv0lYSc+asFE6tIJtu0pcGp4KwAWglFyuvsb285oIs8dHF8dAUqMXQ03/i3TgudcDOBeDr3Nsa0JOSKoonqkCnAZomYS9hViS3HfHkvvPrPC+RFRe1asImOq8YeRRqox68NZLCVozQHVPOQkr0R1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oMwSD1mJ/Yk1ht5HdAywHVu0JfMZXz04G3RqR+Xlix6eV4327NMFZo0GYqKn?=
 =?us-ascii?Q?/T4qXtQhtCgJtOW8/OONTm4rZq7UGMzRtgaEOECVZge+Is1CgA6CuhPRe75G?=
 =?us-ascii?Q?Kbl4F9827BpjirPbv0PLZ6t9wuEFwMGB6PiTSDDDZpHakje/zO2L/XRYZ8d5?=
 =?us-ascii?Q?92d93Y1/Obfi99sejYqBH2ER1ZtGdpB5iAtFROrrM9XN8jewq+b9HMmVhZhN?=
 =?us-ascii?Q?rbZB129cDQtVXFB2JZD0BCjCCOvNdfuaggJYn07/FQ2Vx5M5vXr9/IXA6oIx?=
 =?us-ascii?Q?smGf5aTP+mdZa6c1nKwgl3UqPqXVGuMucJ0Xizv8n4cPFQEMGuqusIER+KMz?=
 =?us-ascii?Q?O7ir5R69SIg+U6sn2cHFYDN8TW7deDInKiHTNH2je2g9emW30I03ybQvXGsU?=
 =?us-ascii?Q?ZG7wYqjvFBQTKRqE5Xpqg0si33XNrqBrRW0ZGrTgbCbM92EtBK0PuNaFQhNO?=
 =?us-ascii?Q?Eiza42fwmdmIRrif+a4Z5X5fyZyGj9CkNAKdQQRfVD7uVvnzQ27vt7q2ezmK?=
 =?us-ascii?Q?JoMMDAyGMrd3Hl9qKjT2dXydw6tKTcqA6DxyYlTqRxAUfkswwEsrvLNlc1Xl?=
 =?us-ascii?Q?za2LcyFkUx8CtRDrDacv0oiXEcxDL26UJEsNORVBuqChGJNExJXnTdaG+NOe?=
 =?us-ascii?Q?TjK7pUX5RzQ09Gxxi++21RApwnMDDtR+S0aAsickjxRI5KBEQTawbMz7/+ve?=
 =?us-ascii?Q?iO/mwDAuV5KFCxm5EpH4YEe1ByjVhVlIzcVEBcbdwmw3A9tFaYJHNpxU2KB1?=
 =?us-ascii?Q?JHa8jXMD2iVNKVky1gUT+vtr3rsK0vpj+z1Ue5cj7EcZ2HTr2rfrqhJJtXMJ?=
 =?us-ascii?Q?ppSVTg2PtSLtivXo/K6zyXy2n/5y6IBsAFIq4xa9DPr6VC+CfATuf3jjqUgr?=
 =?us-ascii?Q?di5VfgD69xuLXdJYfQXYjRcHYTwj/+j8D34XhWKXiRlAiNw31gLh+ZUYaVNh?=
 =?us-ascii?Q?Pk8gfVkaEBAL7meuvyrSUxqT9CT9R8ncsQyqdfL1e4G0QjIkQoxZuFxOBJXO?=
 =?us-ascii?Q?XZp+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:37.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a502b57d-20a8-417e-aa0a-08d89d2eef08
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBlNft6WDUQiViZjQQrWXUL603RRP7SwVvKbBS3q7GwclS9+aKiJqRuXSo1Q9Eftoy/SZ1eK43pknV8DqOf21Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of control register write access
is not recommended. Control register interception occurs prior to the
control register being modified and the hypervisor is unable to modify
the control register itself because the register is located in the
encrypted register state.

SEV-ES guests introduce new control register write traps. These traps
provide intercept support of a control register write after the control
register has been modified. The new control register value is provided in
the VMCB EXITINFO1 field, allowing the hypervisor to track the setting
of the guest control registers.

Add support to track the value of the guest CR4 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.c          |  7 +++++++
 arch/x86/kvm/x86.c              | 16 ++++++++++++----
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2714ae0adeab..256869c9f37b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1477,6 +1477,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
+void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 14b0d97b50e2..c4152689ea93 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -203,6 +203,7 @@
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
+	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e35050eafe3a..e15e9e15defd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2486,6 +2486,12 @@ static int cr_trap(struct vcpu_svm *svm)
 
 		kvm_post_set_cr0(vcpu, old_value, new_value);
 		break;
+	case 4:
+		old_value = kvm_read_cr4(vcpu);
+		svm_set_cr4(vcpu, new_value);
+
+		kvm_post_set_cr4(vcpu, old_value, new_value);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -3077,6 +3083,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b3f1f326e9c..c46da0d0f7f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -983,12 +983,22 @@ bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
+void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
+{
+	unsigned long mmu_role_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
+				      X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+
+	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
+	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+		kvm_mmu_reset_context(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
-	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
 
 	if (!kvm_is_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1015,9 +1025,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	kvm_x86_ops.set_cr4(vcpu, cr4);
 
-	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
-		kvm_mmu_reset_context(vcpu);
+	kvm_post_set_cr4(vcpu, old_cr4, cr4);
 
 	return 0;
 }
-- 
2.28.0


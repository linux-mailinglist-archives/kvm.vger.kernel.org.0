Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A222AC886
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732430AbgKIW3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:11 -0500
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:29185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732360AbgKIW3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+S3568TSG0Qk+4F1laoXTWkaZ198f0u84U83E2jeWFOp42xB7yy7eNhBFJ71XjkbTkqZx9/5lxj0xOf4fuBRsKPacF5rAYlsjMMabQ/jAKuGKBPBaGVuUL1YKiFST3LKU7XoNxyOBWsw5kSltyS0Vta5LdXxWM3X5Q62OWQ0OFsLqUU+yTO/RRortxauMzr6ho0jOIBx+MqKQGwSHxqjjiIEkHkwddHPiMBTIqW9gvNXt+sMma/v7qqM73hoxRatMgEgZfqNKz7Rsrjgi6lEiTOQzcSplXD8c7XtGINEFwXscyYJ6vOh55k99hAq2uxWqwTOsKEgX1P3+fACrZDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pfs2MVTCsOHQ9Gudx6NKZlO67PGvT3cAcDpDewtcZ6o=;
 b=CqeQUiOQfN6reW2nZQdMTimjyTHjvX5GKr5Teg8/RQ1Vp7k3Vc8SIMtPmBYKCj7NosNMiZiWk0son7Xj+e66dVgTfLtxDUZUNXna1fcXDeVMbPK5nlIPpWB+R5f1RzkQfeziE0v8iLqrpVtblRta9ArvmNdLZZ/kQ+FVKAZQSqvJ7lTyIDXgFr5NNFo5G7z2KBo9YnFwcXbNb6bNvijtUeukhsdgsdsQdh5eZv+RVUT3keu6gVqH43S8/fbEHzrV+Qbm85qK+tOz6wJWogDU9nY6mlhG+o3oglu4DCJMLHjC6EMCjN9qcaJYo2xsVyR0i6AQ5PCTpHCzf3l2opCkYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pfs2MVTCsOHQ9Gudx6NKZlO67PGvT3cAcDpDewtcZ6o=;
 b=26Y+hdO8E+YN6u5caXll6m72KE8owWD4njnqyh7Fr6ESHTbl/uE+osyjHz14VUNvAKTndkWV9EDMTQ1BMaZ7mkpJeyqD/4B7n+vL+Ey3pM4wM2qa8SXSbmhS39g046YSjQXF1N2f5Fnb/LS5OKSN+LoZiBuHe45OQM5BsGiaFwM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:06 +0000
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
Subject: [PATCH v3 22/34] KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:48 -0600
Message-Id: <f1f42e83bdf4bb0c4126f2873648f5466648fa54.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:5:100::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR03CA0055.namprd03.prod.outlook.com (2603:10b6:5:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7683f19c-c2e5-4e73-8b90-08d884fedeb8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40586FB0CA44288AFEC5866DECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mc3dKJ3wUgCoWRa/RPq5H7rwunMxp6AcE8UBtpXyYf0giHvFa872vQIMwgv5B0JLZopcOuTAT0YK8ft2JAuGdJfIgFtk0KZAXobK+5DFBUCN/+dmkdWtlOvoYy8HHcM+TdhZV8dze1sao6S302wE63B7fMJp+7jDNldQKxkViyoxYe21CTYlaySma8hjRaCew08jpYHXfYosI/sJHWSj/FgqNdI3uugS/Wbcl6c7EAC3mL5YCtbiLKG7SsPGRj9YudoaobABOe/JetHHmXTLWP/HeSPV9lHLLA3SJHl3/QFp6lLUjY9ldM0WIOKSExXB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SCWeWvFJkJMyCcKVB1VeOef/weMeLvOb5+aQ8tcUHVl7d5R+L3xHpOo7EDHlJdHsIcSmzwL5JIenRi+xYbnwJmGLgCutOZQiv3pEko6tWgf8iII/gibsbOQsYEZhtCdfAAb+ENyUq/OcY7V9jsPpb458dI2fPazMZB1ZmSZOA3H/aj4FUK5q1BKTMnPyqzOKZa7MIvL7WeMIEUSM84JHnFentn8WBWhr7L0fEgaH8uQ1u6Yg1m3huPts7N1R1x5ecLQ2C4i6Khmeq+rineYoQNtgiMkKLLZFP2AUAjCbLEezGfcFgY3ivtvFjMcmobPyhBwBcVclPrM7fnoyQ6EeYBScbREnGk9bI4uE8VYnKXxGREWJ68wQtgjbIFqb3rt31KZX10yoqH7PnNHIG8WMLBjmrTJMfJORh+kauK3y27ik+f6s72apboDoYYWNOMK8M7cP2MnZJjCYvpKvb7bnfLA1N8bGSwLmhUCCMPqy2L1GkMXd81UWS8+o2tpzzyYXFSnmm0FrZWWldEwFPeSeX4JvSewWRJ1Z+ZpfwtZtuF3pvMemgu39kM4Wsq9m1NPtYATuiTwvSrWp/dRaapxcF9YduerQ3es2Tv2oaLtW9pcd7EtF02fGMWj4D+je3DAOYvQApiaVAj84R0IbGrpQMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7683f19c-c2e5-4e73-8b90-08d884fedeb8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:06.8030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bL1f3QgwcoSFpuPXWyAjlmv3/V3bS8/l3BAW3NnxGjf38GjvmS6uenbOsV2XCRIZD4XvW+g5xxPH7FAm2KU1nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
 arch/x86/kvm/svm/svm.c          |  6 ++++++
 arch/x86/kvm/x86.c              | 32 ++++++++++++++++++++------------
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 068853bcbc74..bd7169de7bcb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,6 +1476,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
+int __kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
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
index 7a5adc2326fe..20cf629a0fdb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2481,6 +2481,11 @@ static int cr_trap(struct vcpu_svm *svm)
 
 		ret = __kvm_set_cr0(&svm->vcpu, old_value, new_value);
 		break;
+	case 4:
+		old_value = kvm_read_cr4(&svm->vcpu);
+
+		ret = __kvm_set_cr4(&svm->vcpu, old_value, new_value);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		ret = 1;
@@ -3071,6 +3076,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc9beb1c4c8c..b42bc0418f98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -983,12 +983,30 @@ int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_valid_cr4);
 
+int __kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
+{
+	unsigned long mmu_role_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
+				      X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+
+	if (kvm_x86_ops.set_cr4(vcpu, cr4))
+		return 1;
+
+	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
+	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+		kvm_mmu_reset_context(vcpu);
+
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+		kvm_update_cpuid_runtime(vcpu);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__kvm_set_cr4);
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
-	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1013,17 +1031,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (kvm_x86_ops.set_cr4(vcpu, cr4))
-		return 1;
-
-	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
-		kvm_mmu_reset_context(vcpu);
-
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
-
-	return 0;
+	return __kvm_set_cr4(vcpu, old_cr4, cr4);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
-- 
2.28.0


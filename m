Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0407A2B6B4D
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgKQRKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:49 -0500
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:34945
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729303AbgKQRKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKDIWTc1/Fia6/vKqz9VkmzgRlAIuI9a1orlHXIMPdrVp0r6DoY0sPDd3D/k9+S1EzKabwHJQhBfoBnpiWU8tnyRNBWhBHoInLOfcx82YRYwZwB3wj0y6Rp8WpjS4h9ingZIgxdjuCDE2A3wRWixac7YHzd+i0DdEwC9aNJfeQcY+h9HDW8kjMnY2TiiQlY7kF1Im7npRSMlk8BC2d2YnmvYUWkqeL9MGFzPVITZk/qaoas0++nOTKUzyUyDVPPvZ/EEXKzTBAtk0TNPptETr4Fc9en1x3mLhE9QDWvJUBuIcuKtzsJdn2DcYzbDydxhmm6hrw9qr28JVUqiK9YxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1B5ANj+qmKjDmJ4qJxIBqF/ZmCBCoYQ0IKKgp4zL+k=;
 b=guXpox4CB8KMAq/TXTydAEDwQpri/yIJkyVu8Y/F+kVKveY4V0ngThqeodItykTVjq9VDYXahaS13WKOYD2Xf/j2x/x5IbR4CvBy4EJ6xTwEZqpVMpqeOHzn7DEdYaaF4rD936aOuOSwaagcGYts8oAlVMiFj+DoKD6wLd4A8dPLgxe0AYCvEvKYOt8qWOpcbbm+4OsTC0yUJFGyn8vlUO8OJH5R+GlopGD/9xRegu3b2FQMjQHXCVXXlNAwAH735eO95cZxRAMhjSP8USjF2Om3lqAyXD7qjLQfuzGKVPOb5pAx2lxx65cP8qFt5U1HDDCwioOhWpQb5gt95+ioOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1B5ANj+qmKjDmJ4qJxIBqF/ZmCBCoYQ0IKKgp4zL+k=;
 b=EMSK6Jdu6XHoGT/jvpiH87740YKJaySMtpHrm7z37A/jw7BbhCWvZ0yZA5x86KlamAej2isP020AG4dN67AGqlBy0vUpb+jJXVmSoPKzmhklk5sYg9argrJwKFPZ6/M/X5g6g+5ceoaxbXnJ/O829PSejT+lcF7RqavkCQmAuDk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:42 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:42 +0000
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
Subject: [PATCH v4 22/34] KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:25 -0600
Message-Id: <3407b117f17c5cabceac69a24488602f4b78cf53.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:806:27::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR13CA0132.namprd13.prod.outlook.com (2603:10b6:806:27::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:10:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbcc1287-a72a-43d1-a2fe-08d88b1bb700
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772530A5F357BA7305C3C96ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uwy/zcKf9vh6nikt4X4kMkLl0TNM9sriLfaR+T5Jv6fhMZa3oSAPzD79dfuI11m5pgXAmbTXmjQlOrGkELDHVByTae/NHPfTC7PcGiwJ+PLg8ZSJBAr/9Nad6JwRNihnrPsdochXHxdiJ+gvyiVX5Emlif5tTOLli1n7LoQhyv3jOcabOgy6+tOmyGVgyOxk+k+99B4K4vXY9C6AYc1biKCRw4M767tX9pvaUa5wG50wlJ1oS5mXlvSCJkI+ZPtwjW4a0EzyVGZ8Cpj8BISeyGCsEpfeGy6tIcwCP6akXyzmTL9LZlcnNxYuGcaY+G/P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 28f8nHKC3IU0f5wItTlBVjqcvZ120ItIbyjRmL7su9SJ7x/eZ9AMQ3qe+zHK6kylRP7pgHV63q21iA65urw837d0HdVPL3Sb4hKu+NIQTmKRcW2bn0xa4TWlOunu5KEWUkyqBNYKZJ3PG5lKy34+T6kgIMPYeNPxf/ZgCPMV9vJ2Js9SoOSfIOV82mx+8pafnYll1XrJhAiGTOs27h7uzvz0zxZYYGVhPwsn8xrFoFy5n8iB3ap20f9PX6cDOsW73T6l5i+Vyh5tmo6Yr+ph+78Tqn32aJTCvi8YQZY3DHLqSO+Em591Q0WnSMDT2GGm1NVS5J1Adk0WZoFjBjNyjzOeye9eYk4aOF9xbz7dCmbBevoBbKXrDqCt4PnMRpZN/VibVeXjNkqecyLRwyTGadz+dd9QNmLI07fY9iCzNhmwzmKLEWFkCg+knqPMsr5PRhddMUqTTirnA14W4FsEs5gMiz3En8HeNK+WUzYOrXf9X9D/SW+6VB8ZNPh95Y2dc9fQ43ZE12HNZcn6vFFSpAlQqB0e4IiCOKThzDNWfZ7nSiCWjh23ysVsTNBKsdM2wSu6ckjX3hcWScmt7LIxixCLvVPhUewd6jujQds8PGdLJhSR7nn+P9mRthhVUA5JnQaZ2DBOtNjPy+NgM6WI/Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcc1287-a72a-43d1-a2fe-08d88b1bb700
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:42.5414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgoHQLSKpf27999l68V3x5rFt97XO9XQaBBF84hSpFVB6JlYRVdyySHlLxY+/SGp6UBWYB4qpV80JdZNeMuE3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index b6b16379ae8d..146dbfeb5768 100644
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
index a25c2bd43de3..0305a97abf28 100644
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


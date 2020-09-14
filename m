Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE5C269648
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgINUVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:21:16 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:56449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgINUTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZ0r2RPLaVznIgbdH7ZVCd2dwk4NrywkaMN7eAycoqWitKXkhmJ9fTx5Gg7veSpRSeLY6iLHLkqYcF3xN6V1pjMnRhGuHrEGTGX2eJkXvmtw/8hoK8C7koVt4s9CXN+0arIFcgFjZiwp66ojpS5dg380AheY3F0L4tmET64CaYIGSfJHTmUpbUeui8LG+6VKlKr0FTWSnirIZ70jO9Y87Vpj6xpg3j+3FoE3M6PpsIjv9wxir5PfhP9IsBCME93ZtbVQ/0fnYIzx9BnQZPH/AqV/hg9yRpbYgWlgv0M1J6PMdK3dBuspS/wqRGsd/7K7rRrCzyXU3XQ+ahaglLn5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0NsNk8spO96Mb7KTzGSL7JkcJ9Q6E2ZOgZVR55Hdvc=;
 b=GHvsT/RaQgrDRMimkSsfTT3YUgg8gY3o1UCzExv9/y4bUqxMsvjzG07NMYvbNIKvo6f2/Cju1sAZb0HgpIa4wx0kX116ClwG4/jPziP8l4CK4uy3RS8twZvhXdDg1cNFZrMZDb5MT8WvxB7Q9+Jq/gIgDiD/OUNCI6Szvr1iQZRMBKTetx176rrStpoMOcWZrl2PC8DgvzoUQwHs3XcXpqGzOQyShLbjoQToAAQKd6DsdaLJlfk1GmxCXvSAhTgfZj9eYUE5pyftfEUTCi0gI+1DhFlymRU0PUZJRcty/gTkHgTIjdB9CD0gakx6RiG1ZcuHCo8tMySKjAL2jMjpag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0NsNk8spO96Mb7KTzGSL7JkcJ9Q6E2ZOgZVR55Hdvc=;
 b=oxVvQtXLOzDkr7P/6nh48JQ3zAR6gp/RzO1RqAZy5D/mgSv3jXBKZs4rbqKNtCr8D9C9l5hNYUT8psCR2g/ehiRL4i96OEZHQfopdA/9nftOdTYxe+9se1o6HKrpg20AKziYq4oygKHRLZ8vLvx72hR4LRHN0zncYyVod7W00+I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:55 +0000
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
Subject: [RFC PATCH 22/35] KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:36 -0500
Message-Id: <68f885b63b18e5c72eae92c9c681296083c0ccd8.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0046.namprd02.prod.outlook.com
 (2603:10b6:803:2e::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0046.namprd02.prod.outlook.com (2603:10b6:803:2e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:53 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cedfd4c-3376-45aa-5f12-08d858eb6752
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988B52025B1420E2712D455EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHaWpYYERFeutxZ1gk7AO5M98Kjl73pz8RRzdoeCUtGwwSiCphYCo2HXHhCzVLPqPboh4BjU5bwZUT+q1fAgPka3bQKKSbcKtDqJMEYCHbcYGxGRXgtbgxBVptElSER2ivv0mxnwmCjDdIBgNbNVBlDcKASvhdonEyILcyfTniquD2aI1bE3sWuuQZvYjKvNh23SpnenD5Vvmb9Lu5VcFNOTNA8i5XuRGP7kc31AbDzz8DNZs3+lNN/7aQ7N2T6yDOOyM4v+KzmUSAjVIZdowZpJ6ySlagU3ExH7QUc+B9VXLy3+nSgB+XoQBXlsxgJf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0Yn0mncDcNlvQvq5fTNDxYN/dMEH1XlC57GJitEAcQtFVv6JTLpdN/uIXBqhhn7y1xMGBIOSEHNbTZv3/B30ps/xXiOIxbo62Ekrx7qw1PKJ4RpkW1T+rv2/IkxjwzVU+6bT3PueGGhr26N/6q4txV7pntCITo1bKifaEC4P2ScF0hdQMypI1dhMwacYP+AojhCUnUp6jN0M5nAlA+IPZyzXlg+1E7gCJavBQZFfv/vDQUem6ncTijJd4m4af9FCrWWbXkgF1FIJQtUtEy9iBLzVcutbU0S59l6QuvkpuvxzjTbcI4KnkQv6FVM7Dl+cvA1LEdo/DDFydACXRJxFzTYyfICIGdaImTUPDYzldJIuLhU9MljZBpxdyjF2DR1wyFKBXzHnSBkd5C7oZjZzyfGRHkIhGFuTMrSfXXBrEq8ysuKDYl3npIJSFyCLzoediC+tcZqvr3cZ1wraAAH5v1WdF1DDE9t9dR3qfwmITrig6OM3RjujKUBybtSjhl//ck5OtAc33N8MV0oJLdKWA9JHVuFyWXA2ZuWxkCDapw/AZIqa8jCJZmwuGT4SRqRkDx/7qz5IK9uo7oUHyVBKwPnLZpqgLrd9IORVG0hskz4PzXCCEs4lDjwIZaP+yyElP/G+8MO4qSWvmnYAOg64BQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cedfd4c-3376-45aa-5f12-08d858eb6752
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:54.8714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgOvykuVFYpibUpXefBKdYFCF7DXuOaGa9l3z3aa0AnvWTv5a08hoIc6riYasjSGxIT66Ft7DfX5keG6N5sC2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
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

Add support to track the value of the guest CR0 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h | 17 +++++++++++++
 arch/x86/kvm/svm/svm.c          | 20 +++++++++++++++
 arch/x86/kvm/x86.c              | 43 ++++++++++++++++++++++++---------
 4 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b535b690eb66..9cc9b65bea7e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1432,6 +1432,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
+int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index ce937a242995..cc45d7996e9c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -78,6 +78,22 @@
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
 #define SVM_EXIT_EFER_WRITE_TRAP		0x08f
+#define SVM_EXIT_CR0_WRITE_TRAP			0x090
+#define SVM_EXIT_CR1_WRITE_TRAP			0x091
+#define SVM_EXIT_CR2_WRITE_TRAP			0x092
+#define SVM_EXIT_CR3_WRITE_TRAP			0x093
+#define SVM_EXIT_CR4_WRITE_TRAP			0x094
+#define SVM_EXIT_CR5_WRITE_TRAP			0x095
+#define SVM_EXIT_CR6_WRITE_TRAP			0x096
+#define SVM_EXIT_CR7_WRITE_TRAP			0x097
+#define SVM_EXIT_CR8_WRITE_TRAP			0x098
+#define SVM_EXIT_CR9_WRITE_TRAP			0x099
+#define SVM_EXIT_CR10_WRITE_TRAP		0x09a
+#define SVM_EXIT_CR11_WRITE_TRAP		0x09b
+#define SVM_EXIT_CR12_WRITE_TRAP		0x09c
+#define SVM_EXIT_CR13_WRITE_TRAP		0x09d
+#define SVM_EXIT_CR14_WRITE_TRAP		0x09e
+#define SVM_EXIT_CR15_WRITE_TRAP		0x09f
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
@@ -185,6 +201,7 @@
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
+	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ac467225a51d..506656988559 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2413,6 +2413,25 @@ static int cr_interception(struct vcpu_svm *svm)
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
+static int cr_trap(struct vcpu_svm *svm)
+{
+	unsigned int cr;
+
+	cr = svm->vmcb->control.exit_code - SVM_EXIT_CR0_WRITE_TRAP;
+
+	switch (cr) {
+	case 0:
+		kvm_track_cr0(&svm->vcpu, svm->vmcb->control.exit_info_1);
+		break;
+	default:
+		WARN(1, "unhandled CR%d write trap", cr);
+		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_complete_insn_gp(&svm->vcpu, 0);
+}
+
 static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
@@ -2956,6 +2975,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
+	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b65bd0c986d4..6f5988c305e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -799,11 +799,29 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+static void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
+			     unsigned long cr0)
+{
+	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
+
+	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_async_pf_hash_reset(vcpu);
+	}
+
+	if ((cr0 ^ old_cr0) & update_bits)
+		kvm_mmu_reset_context(vcpu);
+
+	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
+	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
+	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+}
+
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
-	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
 
 	cr0 |= X86_CR0_ET;
 
@@ -842,22 +860,23 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
-	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-	}
+	kvm_post_set_cr0(vcpu, old_cr0, cr0);
 
-	if ((cr0 ^ old_cr0) & update_bits)
-		kvm_mmu_reset_context(vcpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+
+	vcpu->arch.cr0 = cr0;
+
+	kvm_post_set_cr0(vcpu, old_cr0, cr0);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr0);
+EXPORT_SYMBOL_GPL(kvm_track_cr0);
 
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-- 
2.28.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F9269647
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgINUVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:21:13 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbgINUTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+78ZsZMJCW0V/MmbGfV81Tvb6H8dJhkIMZlzbbf/yq8jnOkJxuwxt9xqOU5/bxU8B4P7pH5xfqMokUdEHzGLlYu9a46LcO66M59ysfjZKVXXYGO+qgTIaTKQjB85KGgDqnaGVHJhDtoEupuoElVswJNyEHmNOOnNnl6jvCI2Dtnr8N6zjD2SnP7woNHSEA4E4MlOtCQskcxkus0+5O5uHjeTFgmA3/XWyXVPX2vPrD0gMvk43jIUz9tL/vX9r7FgHiIbps9twlPaH3LYRsIVfv5UOlezJJJYXV6RZBaD6KK0jEzdWMe1RnZ4XyEz/qH7Z8x31VCUtmMuqOb2QEXEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oifPIUm+7KGaHA+TycuJnWx91BwfFHXwDmv+o71oqY=;
 b=dnFV0Ole/FZC1v4deOBcA3rnId5t4KywzwoTs2cjFgyZ4fQ7N93XFlSqKGpzq9T28yduO7ETFBgP2+xyy0dz0qQtcDIXe322FKDl1tdfhn/U5E0lrbGgx1aZsuJQNmsWhd20BReLTBUCrw41d3UUap6L2LZX2CvTDl9X9CtjBLFC3fItYq/XZugzuPSCWvwVb/OTMjx/HYBOW+eS/8iZvZ6WH8vFmDMiZRX8GQoM+gyLBKcn/W3Kb+fq/IHc2Y+3bqlJqWoaV046SIU2VH2S2uxteb36XkfHiBaGsjjwsMLjZURhNc71zj3SUkQ/5qO7aXu8EHdtHJ3L4QSVbkxWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oifPIUm+7KGaHA+TycuJnWx91BwfFHXwDmv+o71oqY=;
 b=NvfQJ2SPpmHKG5m3Zpj7MB2ATUnf2g9kZdQE8D10N1ttAbgJAX0lIMgJX234KvzwBGzWpo/zwKjjtWhmh8X+eZZnWpH4PEza2lu76HEi+G0NOp47HYFr/BaLzdK4IxzFhtQYaRoKSUVxa1ACDSgPL5R5iARo1+zsZBP3w0YB+C0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:03 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:03 +0000
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
Subject: [RFC PATCH 23/35] KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:37 -0500
Message-Id: <97f610c7fcf0410985a3ff4cd6d4013f83fe59e6.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:19:02 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5362e0d-7d8f-48ff-6a2c-08d858eb6c3f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29887478CF4E0489B822B08FEC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQc5FvX7Vql1RGxiALYExaQ6gqk94xVJUtOAAPRaYuNBCsrsflXTzIj+MkPpt+kyrz3Qmi0OxyyPt73b1Gygt/b4/Au6Q3YpF/5xMZ0kmF9Bv5q3kEwJ/BSm2eUgZOJc8zZw/Y2wb/mEGBFXyeKb6KDOfLLqJlL8jKYTWWeWiTOuZTj81byeUvg226W4bd5OgyCBr3+D8RQxSys7amDIMMrKPI0O0CzmJJ8aELqKsc7rEq/XEkw3mPj2a8OyjSjDFgSgwec0Z47HzjX8TDkzpMIP0VqOCjlF+IpJUP9CkwdNXM5TcMpJBUEuWs9omn93
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L0Cp7ywZNreHjxDYcJs2KJ/busWRolUW0VOAMJfRYRKpoMb08/AzblDcUkwouEUHdV3j4ku13YI3KUE9W3ofQZVpY79Z7axOrZoFLD8E2a+AaJc9IlMuXz/SZph5z286ZWKPKpHf+fJ8gZPxWaDY0TKe/7RuwP9KB/7Jz2vwx6AFB6i5quETWDhaf/0Km8LAU517WHokbcTdDnD/3yuWKddvyCfIwHclr9crOEn0Zt2hX1Xnu1lsbNWhIRhzAyhtBhCc2FvfUpHmYsPwkxf19AH9T7olmgJZn4ixKPUSxY+kIE/3qX1vbF4pKT9i3Pe8EFPvMfitJJRn+9BPMZHPH5tV0p4GytcUmhnyp6UuGCXQ1dxPcU0LGnMvyc9icqKyWRuViascSfvATEpJ/C6zN9w7iTEKGibPGclqsqcV6v7fMdUBjum3Cp8hPEEJ/2fRzEvAkLkNZAOFGBVh2P5nOrxn5jgB9bbPTGLSxy8wTeqjsYjCVpk1FL6SHA9yEBFkrxrL7MkJkN2ketPG2YyKNaAqJM6sA9Q/OXms4eScaoAbhwhq/0i/2IWoOQIHYzA6puINxUvtOerHNGseX/Yvt6TByzOLIzfE6IANTnv6eW679uP9EGKdBvnT1d/vtT57dQsR4B+rwQu8ggrhRaw4+w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5362e0d-7d8f-48ff-6a2c-08d858eb6c3f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:03.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghrav+F2UljazbFoSDLRP700zPxutg/xiL02xZCoHMDYtJdsZEuMGKxANXl384vKK43yI6hM6FlglTjcX53aJw==
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

Add support to track the value of the guest CR4 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.c          |  4 ++++
 arch/x86/kvm/x86.c              | 20 ++++++++++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cc9b65bea7e..e4fd2600ecf6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1433,6 +1433,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
+int kvm_track_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index cc45d7996e9c..ea88789d71f2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -202,6 +202,7 @@
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
+	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 506656988559..ec5efa1d4344 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2423,6 +2423,9 @@ static int cr_trap(struct vcpu_svm *svm)
 	case 0:
 		kvm_track_cr0(&svm->vcpu, svm->vmcb->control.exit_info_1);
 		break;
+	case 4:
+		kvm_track_cr4(&svm->vcpu, svm->vmcb->control.exit_info_1);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
@@ -2976,6 +2979,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f5988c305e1..5e5f1e8fed3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1033,6 +1033,26 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
+int kvm_track_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
+	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
+				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+
+	if (kvm_x86_ops.set_cr4(vcpu, cr4))
+		return 1;
+
+	if (((cr4 ^ old_cr4) & pdptr_bits) ||
+	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+		kvm_mmu_reset_context(vcpu);
+
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+		kvm_update_cpuid_runtime(vcpu);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_track_cr4);
+
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
-- 
2.28.0


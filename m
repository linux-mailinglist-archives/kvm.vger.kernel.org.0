Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133332818B5
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbgJBRGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:12 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:63681
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387768AbgJBRGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4c5k6OgRxiuj3Ckzm6vl8CdFeuo79Fu14mwqJAH5sQa7qyNoe3ypdsYcw5rEN8nMGITWbI1NMPUNRGoEJSPBS4sAJZmlVuiDww3Eujo8l2MQi4TJv9WtcBc69FKKHHv9B/gURk+00OkT+4eRtFeEfNFQpTlHXNxAk3TQZubel9if8fgHZIGWNq1xbuK4pNl3tSeVJhSYBocVBC5G9Y9s58Ay3yv1IJaubi6N4UpkiYKsurQ1M9M5h7Qi26POx4pRCMD3u/t/OSE/j8hdOgg/84MklJRPgSqdwYM8pEfyUVE4cSbr3jOvbloLDR/VTWIlkGw9fDaBoqcF7q5WxDs0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKHF41jg/K6wQjq1SnL++Bt3l+yGR4vavQFSIFHAfTc=;
 b=e0d5iT8So58wDz1VjEyxyLaCSN6h0rP02Ki7fNn0kVYQY3z9PM+AW2IIA+sp0pCkeRNXkvPHv4TrX97p0H5BSOgC5cD1CAITnpF/0iRRXR9hZKqwjiOnA2TqxLUbYnH2jiUGd+wn6lWpTsw7tyTvWvNMOhRaHkOqtHmHvy80tXzor82x8oIJ7/DyUSIrRkn7mdjYV91ClSfF53BdlgbCd7hqRvHI1MvqlUAzL7SxioNts9/um+N9Vh4d+bRvXAyEu/3Do7Di4fviBLe58y/oUpieHPfJalssUQZSVhhG6HRqRaXRIK4vP3qP2bCeaeUDY0tXZ6BFGfMry5uHePdzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKHF41jg/K6wQjq1SnL++Bt3l+yGR4vavQFSIFHAfTc=;
 b=1QC242vVf+4YueCMCF2kImHFUZEu9kdLvYJpxsf6nahzaS9OscmeZnUClYLhIbppd44P3B3GgWrT5lMWANtNf5HAqZsBmEB3n7k1XXLGBKbFMzZi4tcBaqwGH6AFsm0dpg8rGs9PkWjXwZwZorJMCe5rKV9HQapFoWE/W27fQ6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:10 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:10 +0000
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
Subject: [RFC PATCH v2 21/33] KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:45 -0500
Message-Id: <e909e555c851308b8a2542fab229a9837ac25257.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0045.namprd04.prod.outlook.com
 (2603:10b6:803:2a::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0045.namprd04.prod.outlook.com (2603:10b6:803:2a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 17:06:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b07f43a-870a-4c86-2779-08d866f57595
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB421831DDEE470DC53CE4DB7AEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTdDd96jNf/lHx/U/yDqI1hQqpBBkAMwpTs9wXujItD+slKxRQ9Mk5NG9R/iLmhWjIFMe0B+fBkHGtbnynySY1rBJHqLy/yDrDyoN5VMLkKBufOBt3wd25bfYIRBPtpRossTYZCRVYgIp1fINp+RIsa3+yNYPHGGedFVwzMoKX4PtMUKlcL0ZM2zFnRkS2j9KN9GnUZ4r/XV9GnkG/c4KedJ1p5xsNuyWoBOw+CgcK8Vp3CAxUKQZLPBCRqEF3acDAlU7P6xCWm3DHSoyxQB+oOlUapLh9kpBKd6UIdciCZ9G/IZc/si5KTZbwKFwn6Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tWMGvueVli7D2yJZ3tAykwUZnCJzB6ZaNKTi3CaCRMs5IGMVzz7TXi9KOqjnzEKtkU0XmqHDI1B6BCqIJupCS/B8glh39BZ5Z2YRykJxHM2aaF+5cIQS59essM0+GwSrtkkS8GP/zwxJ8HwVdeBGjHr8vnV6B55FXkR3jTDcI8HRas9snQCBKYLFOlTEt5WuAEYB6nWG4mkCUCJBquPxUD35vxNwqPBbZ6KuUFvF9Qc8vEpfHAyP39XkwjPrkZrjlOdI85HZUG/psGzjzz5Po48P37ULTYQzO1qZLdcYrF/xf5+kg6eJqP12PnCL9htN3lWyVAhRk1OharYQHV7oLsQoC5bf82ACqS++clUNP7KxW9Y7rQ+2x4VpVRkTCbjWUKfeXNW6WOgvEsvps7lcqB55a+WGTn3zyRnU36smkR+v21jwY+k6kTujSvORXCroVVAx7A1MBjPfT4VpleVRZh95sHc+4bKkpymWgc4AHCOx0fDuJ0X4J2uRNtszFyCa4kSyvjuqOzm8wNLDgUA7nX21iwlqiP9sh5lPfPuX5G5io81dOLq9tpCQRNZc3qEcgOQauTcyxMa03uwI8cwucq7qwnSL17sm3tffb1/dFkDCVM4vTa+e3vWhKMgSM49OqPYWNt0x7ZnWDSkfwDPkMA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b07f43a-870a-4c86-2779-08d866f57595
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:10.0254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGD6Mz+OKm7s2Db1XINDeKyhl0s///J2bRu10g9cPZ8FwqgrH2lluQUkKunoyPpJO4Ic402I4Tp6DGwYJ5F/Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
 arch/x86/kvm/x86.c              | 31 ++++++++++++++++++++-----------
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b021d992fa46..44da687855e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1447,6 +1447,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
+int __kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 671b8b1ad9e1..423f242a7a8d 100644
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
index 913da18520a2..6b6cf071e656 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2493,6 +2493,11 @@ static int cr_trap(struct vcpu_svm *svm)
 
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
@@ -3083,6 +3088,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8b2d79eb2a3..90a551360207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -984,6 +984,25 @@ int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_valid_cr4);
 
+int __kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
+{
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
+EXPORT_SYMBOL_GPL(__kvm_set_cr4);
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
@@ -1013,17 +1032,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (kvm_x86_ops.set_cr4(vcpu, cr4))
-		return 1;
-
-	if (((cr4 ^ old_cr4) & pdptr_bits) ||
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


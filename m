Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057192818B3
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbgJBRGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:06 -0400
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:58054
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388442AbgJBRGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGzOibe6tnVAaAusDikf7/u8nyMGQ4p5XdmXx8lXHuXt8QTLu4Lx/wh9Fxh4FE5rcH7YYU+H1ZwylHRbL5j3tV3smKHXYRnISz7CddMGvL15f9e/SM4QLNaUxglkSXlehZTGXB7/7lmLwYVjcHp48El4yN4Xp7m3sDQPiHtRKCTqI9AoION+r84i2OrMjyzOpsJdpotUwy/wIUjlkBlT1/2x86fulGGvqsDXhRuGb3TUucwrQQ6E3Se6u/AywcnckMGfuM3wcyaRTUkgtF4LykjYCjxCHjeWtNvqDizXtSOrjqIfkaqnUrX3vMX+Dg6oilRpRfUaEmXu9fMQDVtnzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxrqh0nVme72sHdEAn37Ve6If5s8l8BUO2/kyIr9Sl8=;
 b=WHl2syIssLGJPmpKvPDKcBJ5jNFmy+LkI7r1krcySO5/n/bak0M2JJMrn3Mm0WN+MtPyyeTicDLEhcJyeB9EC/hq3Grkr7RU+sFC82dIessCNh8rHfkIANAiuG/gf9W8MGYAlnUYIcMgMvxvC/fOywd8sho1iF5gGcQJfKjCcVwp4+guotfBWG0OdjKebFAo+JfwzUI/HqsdQuDte0M2HMVXbvvd9toR6L6yjKfD6rnQ/2mDxvR3T+9RIRFa7Wk6rYq9GrVG3HhEFGGsQ1Hg2kAzwhAt5fbWMfxWELn0FjmhdBSa7nT5cobEewW8dMlsQ93ugqIBfenmRm33Pg1Usw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxrqh0nVme72sHdEAn37Ve6If5s8l8BUO2/kyIr9Sl8=;
 b=z9Ivxz/S7bR59ebHlsP8tdm2w9CXgqHIMa9cSn1OKjShxTYpWxckFaaP9JzOM5JMoHOzit+qqzjyA+MXea3oZeE3IQ5ZLVycWIP01XKiztkYvftWEx1kewFMExMaVymQD0lZgrnyArPVkLcFnVBs7nfd5yO7BJjlfbD3AqPcfs4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:01 +0000
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
Subject: [RFC PATCH v2 20/33] KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:44 -0500
Message-Id: <ee68994fba81a60b5650c40d232972603163c817.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0023.namprd06.prod.outlook.com
 (2603:10b6:803:2f::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0601CA0023.namprd06.prod.outlook.com (2603:10b6:803:2f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Fri, 2 Oct 2020 17:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b234e5e-91fb-44f9-3551-08d866f57068
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42182E4A65B83FF0D5B5BF69EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8bz1iczOK3vPhvqTbptPr6reoS0mkhsW9R9SoNjwuW/ZObEEiocKI8A56T//O6GR4JxsANAXv3RviAJJsthOotFM8bQgm18TdhtK8mMM/lzg9wI8NNXZqKvm2UAtKU48SrvRfg/PESp1zmqUQdD9Bjf/KCRhpGez4US5rVnXJu4o1wUp+oV1lNjxXBMgg/SDYzUh5X51/5Pda0SmOzoUvZ755NnJydI3uyMnhHNhiRKskBpMmbZyuZ2gP+LKsMOAtSNqDF3m1lsmF2fi6DPPmaC5zQwgORJZrwBTeu5DsLmw3sKJLXeW/79P+4vkAGQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +4lSzSbeBHqZ/CapC8NPH6brlayCR1Hr429TtOJchNrmNRHjkeR23Jv4+YeiJEtr+CUWGgjB/kDF0gFKz3xeEWx/M9qzkzp0ELIzyx1aL0mXyrLtwPK6npmGWNhTkakztl6QmT+CDQK3inVNf2LaIF8hUBiP4IJIkAQMBY5dTFuKY6hKSGY0P6+41Y90FM/UIJIiXRN6vKiig6mX2Syn0hhx3l4BiFx9P/BV2umgHlpUB7z6kx6qKBTK8Bz3DEAakQq7fHaZPMiu6U7lILVTajxrOrrK1LItYiZdIW0nSs8BYXGDUXWeN45W7wKfm3kuNWSs/mZQ+zD54aW8T7ChHX7VADuDuCHFPx0t1IdTZ3p74KyInw4oxeVlzh6AmEPHszpsBPYvcw5uyLElxcV8R4VcyiH9l3Ht8c0Z9hBXlNwMR0XOKc1AEgyfA5Nf2/snFXfbk7lPgYS+wIORL+HeAv46m9k+hBzExK72T2yOYrPHa9FA1jS0TjH1whSbmVh00DPg6hrGtwmBo2MM3uryxtfqTmEw4tjXTQl8xqMugRdRk+nJ/g3hifgj+irzCeBlA3i/add61LMzz+Ro/IuUJPb9joIY03owepKrScfNLbHu/Dyytm6xMTsMTluHYL3axqnrdgjDn6o/Uc6bW2+S5g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b234e5e-91fb-44f9-3551-08d866f57068
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:01.3642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R6Y3Y+NSViVyYh5dGHB1NGVyzAgpjcvFrNZdIAn1kb9rUBtzj0RxSPDMWTmGNhHffQtvflnZium7Yt5XdTlQUQ==
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

SEV-ES support introduces new control register write traps. These traps
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
 arch/x86/include/uapi/asm/svm.h | 17 ++++++++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++++++++
 arch/x86/kvm/x86.c              | 41 +++++++++++++++++++--------------
 4 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e7ae3b85663..b021d992fa46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,6 +1444,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 73ff94a28911..671b8b1ad9e1 100644
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
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -186,6 +202,7 @@
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
+	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f5bf40c7ba74..913da18520a2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2478,6 +2478,29 @@ static int cr_interception(struct vcpu_svm *svm)
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
+static int cr_trap(struct vcpu_svm *svm)
+{
+	unsigned long old_value, new_value;
+	unsigned int cr;
+	int ret;
+
+	new_value = (unsigned long)svm->vmcb->control.exit_info_1;
+
+	cr = svm->vmcb->control.exit_code - SVM_EXIT_CR0_WRITE_TRAP;
+	switch (cr) {
+	case 0:
+		old_value = kvm_read_cr0(&svm->vcpu);
+
+		ret = __kvm_set_cr0(&svm->vcpu, old_value, new_value);
+		break;
+	default:
+		WARN(1, "unhandled CR%d write trap", cr);
+		ret = 1;
+	}
+
+	return kvm_complete_insn_gp(&svm->vcpu, ret);
+}
+
 static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
@@ -3059,6 +3082,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
+	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a5e747f80865..a8b2d79eb2a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -805,11 +805,33 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
+{
+	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
+
+	kvm_x86_ops.set_cr0(vcpu, cr0);
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
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__kvm_set_cr0);
+
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
-	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
 
 	cr0 |= X86_CR0_ET;
 
@@ -846,22 +868,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
-	kvm_x86_ops.set_cr0(vcpu, cr0);
-
-	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-	}
-
-	if ((cr0 ^ old_cr0) & update_bits)
-		kvm_mmu_reset_context(vcpu);
-
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
-
-	return 0;
+	return __kvm_set_cr0(vcpu, old_cr0, cr0);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
-- 
2.28.0


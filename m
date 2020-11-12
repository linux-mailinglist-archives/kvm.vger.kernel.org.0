Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F4C2AFD3F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgKLBb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:56 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:62305
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728061AbgKLA20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 19:28:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM7ntXbpHdBfsb5g2ahkmSpX/fTsMBg4r99QNX6RPL34v7q6cxoNkNLpSgz6mz6HjZpU7cADDFKbW8vdX9aRKPlK2q8tQ+mC1bTk3AZ/QHIVo33cjKqJtp4XP5k5v/CjfFYsQx1rHGsT6yKc8Wk1xQzUvs+7el4LY4mMmUDIcHigOubCq1Nxr8r6UIXAtbIP2kg0m61djO2A4XcZlwrexY/N8E/zsGkR5aklg9JsSl+7s8jNZVPXcyw60x4///cJ34Y5qFhe0lnkinpRMPBUjRHwJJbrIQAz4pTq7unpcrEg7zzQF4tNs+QH7YOkvJp7ILzMIWvcKSP9wyD8X3S3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0PZSI69jL+c1lpI8Sax5WEdK5iJzpeRzSv2b6GQz5I=;
 b=oPAje0R64EQpHxgL+Wl1lCzAJ8yvS+MOe4SMsRGfaOdnA52FYYMDkgpHnWv+EXTMm8bCw/eYxZ7Ju7lGKexP8FvejPFgqP+lWbx6Xz3p4QqhoYV+2S7L+dApTEr3bZYb5ng/VGDBfPLtd4eqYEisFSN2FaYzxDvKIrQFiJS8+GsZiBH8QfdtyJ3W3+i6/dq7AWWwGliLnyf9iCLAh8WrecIiQ4rAgSxGya6DcUQ09p99kI0ZSF6nnRssf/5cOQRO50tqQIjtq0b8qkmtrFAK3zWVoPC6DTcjrbSLpA4zGyNx5IgkZigxRw5Z6cmouo3oY+Fyz2tGMv1g1XzbyydzbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0PZSI69jL+c1lpI8Sax5WEdK5iJzpeRzSv2b6GQz5I=;
 b=ukb7n55/EuOAy94TfRf6y/gzvWHddXTmjyWTKWWcPE1OOz5OOuoar2we1aCUUg7aN4a+bI1WePsR34c35PdIYbOwprF524Lmy5BgEQIgjsEdtVN/0+5QCjQ3CdAYyypmuyDlksKa8osMoCZDktUu6YBaSehav4h68HpbTnJsO74=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB4685.namprd12.prod.outlook.com (2603:10b6:805:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 00:28:21 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 00:28:21 +0000
Subject: [PATCH 1/2] KVM: x86: Introduce mask_cr3_rsvd_bits to mask memory
 encryption bit
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Wed, 11 Nov 2020 18:28:19 -0600
Message-ID: <160514089923.31583.15660520486272030205.stgit@bmoger-ubuntu>
In-Reply-To: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
References: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0125.namprd07.prod.outlook.com
 (2603:10b6:3:13e::15) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR07CA0125.namprd07.prod.outlook.com (2603:10b6:3:13e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 00:28:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b40dfe3a-64c8-4ef0-9489-08d886a1dbd1
X-MS-TrafficTypeDiagnostic: SN6PR12MB4685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4685C5E31ACA7BC747A6779F95E70@SN6PR12MB4685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zoGRSAC+YIyxtGxIH/nm77iu0zojP87ljj3T6AAu1AUxpdDKfRM1EvxMH+WS5fUcnS8Mflgt0hB0XeqeHEmom7XPB8oexmYOPA+sG+gKthSI9N+ZvUvxuSKKqwpcZQmKSw8vs3dVC9YPQmd/Tnu0b1gXXkN9IT5IgpW4Gw0cVZ5xy+I2necpyVz3PZsK83dFPQdSOnYQ0l+BUPDYJDfxU0OUx0+VAXCvW53OLq6uouwWTYgF0euqOsI3kQGkIMJxw1sF08izpYtcrZVnfQbACLshcAqrC0ZbiudSafyOJ7EDYxcfbGxuMoC9vHzHg7H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(346002)(376002)(83380400001)(52116002)(186003)(9686003)(26005)(6916009)(7416002)(66946007)(44832011)(16576012)(33716001)(103116003)(956004)(66556008)(4326008)(66476007)(316002)(2906002)(16526019)(6486002)(5660300002)(478600001)(8676002)(8936002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KE7+Khfn3DD2DwKYm0pfoBykKtGn6Lge3/3BQdEMGUl6+4isfP9aQMEGTKBJ3a3JQ/8r9qLelPbwVXMLH8PCaWXBCpWvjQ7IXF9jgKiJ5s0wG6h06FrBlJxxsWWmoR9IgLBoRA654R8vQvg2YTWTlV1RnRCUWPI7YyMpwYV11hV7SkpaBSKCc/UaaU+wBN4zsvhtQAL+Qq6n+0vWPgWUQCrsJ9e4c27zdOTUatQTfH29TE+gmWbiRddYMDmcil6Qhdnx07Oa9atRYlgyjr+mecx/6oMfh1oqXyYQbZCg2pbUjHZssE03noW3wL+19RnTi0t/b8ZeZGLlV6SgCQbCflFUmQ/sMHqrUQhbVuPV6tbCBwE5OCxVaxS9sp9uqDuSGeCTcadXUV5H4kM/tC+1jmktwpdbL8ws7RMrvUGzXyMfgHQmchKhD9dWjuAjsgLJi9iVA7ZYL6B1UNYJPQKHE2f2VbfAwjTtqF3OGWtGzX4H2Uy8CMUQCg94/4BG0LGs/maRm4i4soQzyjCmO2QF+ED5l3LINH4ktPWpBLOsX4dnHfwQNKPQJ6WACjiR6g1eFN/c13WPkq7YFKIdjx+r51JvD4B3t1NWcVYdkvNojnAom5EEOdbTNX+IbNnXKhmQJVKWBT2RegCXuAaX7hkE2g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b40dfe3a-64c8-4ef0-9489-08d886a1dbd1
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 00:28:21.1675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9CCsHPDuuDMTyEf/CqTKbo9NB58TyOrvskRBwX+mwvsaoGzhqbOhXi4SSV0OrIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV guests fail to boot on a system that supports the PCID feature.

While emulating the RSM instruction, KVM reads the guest CR3
and calls kvm_set_cr3(). If the vCPU is in the long mode,
kvm_set_cr3() does a sanity check for the CR3 value. In this case,
it validates whether the value has any reserved bits set.
The reserved bit range is 63:cpuid_maxphysaddr(). When AMD memory
encryption is enabled, the memory encryption bit is set in the CR3
value. The memory encryption bit may fall within the KVM reserved
bit range, causing the KVM emulation failure.

Introduce a generic callback function that can be used to mask bits
within the CR3 value before being checked by kvm_set_cr3().

Fixes: a780a3ea628268b2 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm/svm.c          |    6 ++++++
 arch/x86/kvm/vmx/vmx.c          |    6 ++++++
 arch/x86/kvm/x86.c              |    3 ++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..e791f841e0c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1265,6 +1265,8 @@ struct kvm_x86_ops {
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
+	unsigned long (*mask_cr3_rsvd_bits)(struct kvm_vcpu *vcpu,
+			unsigned long cr3);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..a491a47d7f5c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4070,6 +4070,11 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+static unsigned long svm_mask_cr3_rsvd_bits(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return cr3;
+}
+
 static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
 {
 	bool smep, smap, is_user;
@@ -4285,6 +4290,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pre_enter_smm = svm_pre_enter_smm,
 	.pre_leave_smm = svm_pre_leave_smm,
 	.enable_smi_window = enable_smi_window,
+	.mask_cr3_rsvd_bits = svm_mask_cr3_rsvd_bits,
 
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..68920338b36a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7556,6 +7556,11 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
 	/* RSM will cause a vmexit anyway.  */
 }
 
+static unsigned long vmx_mask_cr3_rsvd_bits(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return cr3;
+}
+
 static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.vmxon;
@@ -7709,6 +7714,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.pre_enter_smm = vmx_pre_enter_smm,
 	.pre_leave_smm = vmx_pre_leave_smm,
 	.enable_smi_window = enable_smi_window,
+	.mask_cr3_rsvd_bits = vmx_mask_cr3_rsvd_bits,
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ede41bf9e6..43a8d40bcfbf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1042,7 +1042,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 
 	if (is_long_mode(vcpu) &&
-	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
+	    (kvm_x86_ops.mask_cr3_rsvd_bits(vcpu, cr3) &
+	     rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
 	else if (is_pae_paging(vcpu) &&
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))


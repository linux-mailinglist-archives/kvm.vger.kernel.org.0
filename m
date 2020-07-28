Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B622A23164A
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgG1XiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:19 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:64480
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730582AbgG1XiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik35edonk4X64c+XwoHJq6Xj06hhlkpmpnOA0Od5zhv+ysJvtZWWXbMyQ8SZj3Ps0JfsNfN1gXalHiONleijNR0u4a1eJsjxVi/RE5NW5W0U7MrhEI8h8RuDQLbFdTl3ftT4OT9bHtkJLkNXUCFNb/Ds7L8k1ZX3/uwrPRt/vpmhLmeN8aOvKctUhCWPeTSrs/HF/2zsoNRnYtwnCZIy6jHGpQQSHEXUhGj61HzMaiz9tF1np5qsdzdHCCgps8KyuEbttsH3VQhLuisbmVsGCScTfOT3rMP1HwAvMHqLxy6HJpctQ4GukmOqUcARpc8U+y23YpbzHnA/ENW8FRJxZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwN/4cKJg6P1OhhdpWzfCklDBSMhE7FDPpHZsM0SXcA=;
 b=exgjV9GmRjRoFBTYKNBb5QlGslceA6PUfNwrN6QmrjA53gqgDJcb58kF4VtZQCL4yid7DF04myB8Kp0LZ72ZTjguxHta03klIYnsAYIZF1J5C9IEUmHIVpEoGXHxj32gdutgtf3s6cJZKpHYq4EWVYyj2OsU0X+vbCG0gnF3rLmyH7t1Arh7Ov1zVwB70hz6gYWkWXNYp9Zex+LNf0xJcCLZQZYRROfaklXy0OsQUY3TJ3GfQYmglryhuuP4OJJV1SnGqN0Gmf8CJ0qvsg8XD2FEaKZ0Pav0kZvQMsoQG/CfzA3DUgdMPNbwu9jOscEVDuYdnXGSGs3KtGY8muH89Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwN/4cKJg6P1OhhdpWzfCklDBSMhE7FDPpHZsM0SXcA=;
 b=DpVLtJoIf3Xi61GthCrFEbmg7qdEvyKaVojx3zXf/l1HCC0rX8waC79Zr1CV4zPv9MWkGOv9kjcHR1pPcohMimB2pgDKaxQJ1de8jSgQVb6PtSN3N/qux0t91hc3GHvKGWeJsC1NU9+iRti+60qXVjT2gEO0atO2/BVZMHBhUJM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:14 +0000
Subject: [PATCH v3 04/11] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:13 -0500
Message-ID: <159597949343.12744.9555364824745485311.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0006.namprd02.prod.outlook.com
 (2603:10b6:803:2b::16) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0201CA0006.namprd02.prod.outlook.com (2603:10b6:803:2b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 23:38:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bfa90d81-53e9-43f3-0f99-08d8334f4c00
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559E28CA2F348CC0C6DF00495730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FjXJci3tPrrg5M13WGZQT6ebApndLVBzPkc1vgR7b5Cb8JcMB25whHl8YEPbNw5OGMyifADzs6dnF+S33NYI0Liy/ivvn75/NyO4pOOaf2ez2zkK4DSgMqOWDST3gR7zb+UxUiG2eEGQwsS1j6CH3pQFIVHUa/S4rUjXs5Eqlzf6ZiX2Njsx//Aqzfekh2NnOvQXOQ/ig3/TbbKVSG81ATvQlmtShMYJz3E7EVl320+1maU+dJetc/+H31H7PBdDpZQDylgHpI2r6aLpenw+sXqqQWctVzRq4lSdbC0MV3p0viQoviUPzHh0eh5eYaXtFQYpOC1h/c++azCO+QTx+FW5GsiElLEwnc623LTnHE9FVq5sqhypGD4YlERpgblG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /OiD9kOmZ4w+OC57IncT6XrDcqbiKNOGWTyTFPTzZw//vYbqARwMFuG/HYs5dGf5b7B+p+YsAL0Tzqx6i3ft/9CzAtqITaMLXHw+DAQ6DtB6ERKXVoAwrsHW2qsqm7gDsuBYUv7aixkFmTOcwCQ8DfvBmTkfQJP/FRFgvZK8OcB+iEgSDNg1qEneYxf8ZBeLejBtO4NegHToLI2AM/+VkDTaZh/kOCVU7Tyl/cbZhzHURJ2YICw0DuegKBKO9TGBEjCkr71OGQLH1URFo+g7PFLvPIVSosCCzJJFm4LHiSinA+jBcFUsYkkrpdp3bYmrJl8/NHunwG6ZotXUclJvFDlIjub/UdMyDBRYmvwEnTMwE4mjxtFWJHg3htsRTmHUqcvaoXXMSvcUENfYB4uj/ZR3i8S5TTcRa3PUel4I1FYnlY3PsARh2IW8t1SEx9R44deEvon9vqcX+jiHXxH+q53i2fhl+zZYYXq4l88Ew3pyYtEl7VF5ySEb0dWg3rv9NgyylW8CT3/vN9KWLJpBRUv+HU7Qyu3QnEAyXEER1tIv+bTkVgUBLmZpVSya15adKAaXYXc+sNtEICP9fhJ/u5ZsUpc4eYJY+f7tD/diDpovCvRfjQQ1O4JojccMtxYo+rKw57AgrVL3t+8U7uGumA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa90d81-53e9-43f3-0f99-08d8334f4c00
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:14.5988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMmKetKPQQ+gjY96yA+GDjZolSLPGt4LxbObxbcfnJzS7N/SxQe3jAAxPnH4J9ed
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_exceptions to generic intercepts in vmcb_control_area.
Use the generic __set_intercept, __clr_intercept and __is_intercept to
set the intercept_exceptions bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |   22 +++++++++++++++++++++-
 arch/x86/kvm/svm/nested.c  |   12 +++++-------
 arch/x86/kvm/svm/svm.c     |   22 +++++++++++-----------
 arch/x86/kvm/svm/svm.h     |    4 ++--
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc89d8e4fcb..751a6deb64ef 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -3,6 +3,7 @@
 #define __SVM_H
 
 #include <uapi/asm/svm.h>
+#include <uapi/asm/kvm.h>
 
 /*
  * VMCB Control Area intercept bits starting
@@ -12,6 +13,7 @@
 enum vector_offset {
 	CR_VECTOR = 0,
 	DR_VECTOR,
+	EXCEPTION_VECTOR,
 	MAX_VECTORS,
 };
 
@@ -52,6 +54,25 @@ enum {
 	INTERCEPT_DR5_WRITE,
 	INTERCEPT_DR6_WRITE,
 	INTERCEPT_DR7_WRITE,
+	/* Byte offset 008h (Vector 2) */
+	INTERCEPT_DE_VECTOR = 64 + DE_VECTOR,
+	INTERCEPT_DB_VECTOR,
+	INTERCEPT_BP_VECTOR = 64 + BP_VECTOR,
+	INTERCEPT_OF_VECTOR,
+	INTERCEPT_BR_VECTOR,
+	INTERCEPT_UD_VECTOR,
+	INTERCEPT_NM_VECTOR,
+	INTERCEPT_DF_VECTOR,
+	INTERCEPT_TS_VECTOR = 64 + TS_VECTOR,
+	INTERCEPT_NP_VECTOR,
+	INTERCEPT_SS_VECTOR,
+	INTERCEPT_GP_VECTOR,
+	INTERCEPT_PF_VECTOR,
+	INTERCEPT_MF_VECTOR = 64 + MF_VECTOR,
+	INTERCEPT_AC_VECTOR,
+	INTERCEPT_MC_VECTOR,
+	INTERCEPT_XM_VECTOR,
+	INTERCEPT_VE_VECTOR,
 };
 
 enum {
@@ -107,7 +128,6 @@ enum {
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercepts[MAX_VECTORS];
-	u32 intercept_exceptions;
 	u64 intercept;
 	u8 reserved_1[40];
 	u16 pause_filter_thresh;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 71ca89afb2a3..ee126d5d3348 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -116,12 +116,11 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested.ctl;
 
-	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
+	svm->nested.host_intercept_exceptions = h->intercepts[EXCEPTION_VECTOR];
 
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
@@ -143,7 +142,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
 }
 
@@ -155,7 +153,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
@@ -438,7 +435,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
-				    nested_vmcb->control.intercept_exceptions,
+				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
 				    nested_vmcb->control.intercept);
 
 	/* Clear internal status */
@@ -773,7 +770,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	return (svm->nested.ctl.intercept_exceptions & (1 << nr));
+	return (svm->nested.ctl.intercepts[EXCEPTION_VECTOR] & (1 << nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
@@ -922,7 +919,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 
-		if (get_host_vmcb(svm)->control.intercept_exceptions & excp_bits)
+		if (get_host_vmcb(svm)->control.intercepts[EXCEPTION_VECTOR] &
+				excp_bits)
 			return NESTED_EXIT_HOST;
 		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 			 svm->vcpu.arch.apf.host_apf_flags)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d95025938d8..d4ac2c5bb365 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -988,11 +988,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	set_dr_intercepts(svm);
 
-	set_exception_intercept(svm, PF_VECTOR);
-	set_exception_intercept(svm, UD_VECTOR);
-	set_exception_intercept(svm, MC_VECTOR);
-	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1000,7 +1000,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * as VMware does.
 	 */
 	if (enable_vmware_backdoor)
-		set_exception_intercept(svm, GP_VECTOR);
+		set_exception_intercept(svm, INTERCEPT_GP_VECTOR);
 
 	set_intercept(svm, INTERCEPT_INTR);
 	set_intercept(svm, INTERCEPT_NMI);
@@ -1078,7 +1078,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		clr_intercept(svm, INTERCEPT_INVLPG);
-		clr_exception_intercept(svm, PF_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
@@ -1120,7 +1120,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_UD_VECTOR);
 	}
 
 	mark_all_dirty(svm->vmcb);
@@ -1631,11 +1631,11 @@ static void update_bp_intercept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	clr_exception_intercept(svm, BP_VECTOR);
+	clr_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			set_exception_intercept(svm, BP_VECTOR);
+			set_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 	} else
 		vcpu->guest_debug = 0;
 }
@@ -2801,7 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[CR_VECTOR] >> 16);
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
-	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
+	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
 	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f33a50f92b92..9c798781172d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -294,7 +294,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions |= (1U << bit);
+	__set_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }
@@ -303,7 +303,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions &= ~(1U << bit);
+	__clr_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }


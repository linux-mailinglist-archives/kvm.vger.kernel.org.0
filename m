Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55928253817
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgHZTPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:15:51 -0400
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:17060
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727839AbgHZTPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:15:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnYrpGCGE7Uis/Nf/Df73147cbwGO7WM+FYm3b4GBlr/ZJiIK9SWb6bSPDnUX0ZeIVD88mdQdvN8A3EzreVasOe/kNyXn51mq/ykl4orRFB96nJT/diVTvGvNRpD8AXFLROKcllZa4Y2DH/GSprwUOKQHy2IPFyDRqbVOtFHzWozMVSOD90Hxb0ybHrR8FdtrQji03Na44+FVrPkOKvbTjKg0pJNW7xDpTveKwXZ//STeIcabVMhbZYdXUcoPgjU3Ekg6WaJKjX5TaJukzSZBOoGIW1Rcnkg/0/eqOWDnkgBCtdLhrepPooHPjUlefNtAoGVSpBnDKYvUtA2blvGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iuhytloBtnaKsztjIqH3ytB44RmUMXEQwPPBKhD3vE=;
 b=QXQBjVExXUlkZNyXyl/FK5OPpmI7+YZgfjC+WENdEi2Mlv2wMcNYPLAX4PHx/GAPPRCh2WeIZagjm35f8gMGkUibaSNIE/PiJbe3Os8rNej7/ENCuTJOsATs+SXvn9BepjuNrijFx/NwJDCk8Bx1V0ygqB5osTQ6l6uSIDOTjXT80U5ac2zb2HvVC7722/ZXsn6GqDOeSs/AYZ4MDPYfypohRoXBU5hO/HUjLfIqEKuN0ocx30/PbfyQJHvTD1sURK2W8us2Q1iO0j4wFiCMZj8katTcb5Kw6qWNJN6n/2p9bVrbMVaIow7imMagRNAP6wMsyk2m/Jgp9vIl6Xr67Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iuhytloBtnaKsztjIqH3ytB44RmUMXEQwPPBKhD3vE=;
 b=1L2ObYWsEYui4KA4TX+kmj0O4eOec1xa10t+9GS6lPvQfgxvCOrYPSEf9CxQYvdAE+EGJrj6xPNaJ9SQLEtIQHajROFwQI+PCq9kX3SLrbiriNpuyJHfIqyDgK8YSnwr7jUW9GTtnOpLayIoTz2N0t9MgAVybzEnW9iCWZtmLuw=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:14:17 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:17 +0000
Subject: [PATCH v5 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:14 -0500
Message-ID: <159846925426.18873.12673817778834207178.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:5:40::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR03CA0004.namprd03.prod.outlook.com (2603:10b6:5:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:16 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f7070dc-c365-4888-cba1-08d849f43a74
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2384ECEEFFE53E1B35D88C9A95540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yatw7g+RgDlKxNMqgsrKHIU04/SIDQNZ0k6uzcs8zewQMRGK0+M7wIDVvp/z5ddqarUk2itKcWx5T54thj/wL3VmfPtBfXkNcbqJYfE4/nk0/TQQMKzj1bGLs1JYMeJNoyYERis2scB7tRJREC+7+CjGWl/JfeddXyEx11Wk8yUJad8IRERx5zmk+h4+qZgQWh2BwNgGzwkMXQX3I5AlKPiui7TQ/lYJMaZa6+zLVAJiNgpS0NNGf182usUxVkNa8lCaeRA/YfzBNts1feSQJb8oidQUrOKBfhEz3hWSkn33gYCTnhfgVsOrCVD0EEN+jnhgpfel3u/CWLzJ2btnZxxsWyYySiGWbwW5iBhmtVbsUAr5+lXNKsL+Ojmy4DBU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 71t1I7s+Yr/q0IA3C9OhQgiycxGsUaQ9tlptvbhPuEni2p3B5yjUS4rhv/BKY+hxh2jjAsg88p1osfNsFRIrv5novUIT+2TMHxyO0cs3H73tbFVkqhRy0NLUhb+3/N6ELCy0EsZ6OowcKqyw++Qi3dtTAdNbY6Jml83OOlmbEkdUr2EETPYdajotWqg4uozF2hbvRso6fRSuQy09indFX6capDb37akasq5NgU4VywRZF84SBY6BjIoC0ZxTRLu7U7at6pZmVrfmp+q2tojrjhfkMQBxrexRUB0pc4bm2cuZ6nTn2oU+sLoZOl2m2zIXQHXmatUSZmOk6cqwcBieoeJYriZEVXG6i03Sq8piwx/I11mptG2JqhmSRxJ9JPQDiAZXyLKfGfq61ToW/ms0L0qV/8bfwinloGSLLK79cFO55oitGETwWXun3XdPXIyNQ23B9lRKeXfa9HRJlgwaNiYvqhCMf1Ft6vZtSHHdvshvUrrrpAXDZjVSDt/j17Gz1D4UpZQ5vFM2T1rtSbqxAsluQAb+mNZbpI2q4pJf8T6x8r0a8qtOsvX29CR7utzv728FeVOStyKk7g5tgoZPBm0FT+5HhBw8LKffV9r8yDbC1lDlmz3srZ0sHbuq4FZAThQ1eD4SFvxXw5YrpxL/qQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7070dc-c365-4888-cba1-08d849f43a74
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:17.6154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d36fe4fBLYlcKC/CdB2ifvHJ1sWboiNXch1VeOe41fdvUvM2xPMalUSW5g33JMVI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_exceptions to generic intercepts in vmcb_control_area. Use
the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept to
set/clear/test the intercept_exceptions bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/svm.h |   22 +++++++++++++++++++++-
 arch/x86/kvm/svm/nested.c  |   12 +++++-------
 arch/x86/kvm/svm/svm.c     |   22 +++++++++++-----------
 arch/x86/kvm/svm/svm.h     |    4 ++--
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc89d8e4fcb..51833a611eba 100644
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
+	INTERCEPT_DB_VECTOR = 64 + DB_VECTOR,
+	INTERCEPT_BP_VECTOR = 64 + BP_VECTOR,
+	INTERCEPT_OF_VECTOR = 64 + OF_VECTOR,
+	INTERCEPT_BR_VECTOR = 64 + BR_VECTOR,
+	INTERCEPT_UD_VECTOR = 64 + UD_VECTOR,
+	INTERCEPT_NM_VECTOR = 64 + NM_VECTOR,
+	INTERCEPT_DF_VECTOR = 64 + DF_VECTOR,
+	INTERCEPT_TS_VECTOR = 64 + TS_VECTOR,
+	INTERCEPT_NP_VECTOR = 64 + NP_VECTOR,
+	INTERCEPT_SS_VECTOR = 64 + SS_VECTOR,
+	INTERCEPT_GP_VECTOR = 64 + GP_VECTOR,
+	INTERCEPT_PF_VECTOR = 64 + PF_VECTOR,
+	INTERCEPT_MF_VECTOR = 64 + MF_VECTOR,
+	INTERCEPT_AC_VECTOR = 64 + AC_VECTOR,
+	INTERCEPT_MC_VECTOR = 64 + MC_VECTOR,
+	INTERCEPT_XM_VECTOR = 64 + XM_VECTOR,
+	INTERCEPT_VE_VECTOR = 64 + VE_VECTOR,
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
index ba11fc3bf843..798ae2fabc74 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -109,12 +109,11 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested.ctl;
 
-	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
+	svm->nested.host_intercept_exceptions = h->intercepts[EXCEPTION_VECTOR];
 
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
@@ -136,7 +135,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
 }
 
@@ -148,7 +146,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
@@ -495,7 +492,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
-				    nested_vmcb->control.intercept_exceptions,
+				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
 				    nested_vmcb->control.intercept);
 
 	/* Clear internal status */
@@ -835,7 +832,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	return (svm->nested.ctl.intercept_exceptions & (1 << nr));
+	return (svm->nested.ctl.intercepts[EXCEPTION_VECTOR] & (1 << nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
@@ -984,7 +981,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 
-		if (get_host_vmcb(svm)->control.intercept_exceptions & excp_bits)
+		if (get_host_vmcb(svm)->control.intercepts[EXCEPTION_VECTOR] &
+				excp_bits)
 			return NESTED_EXIT_HOST;
 		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 			 svm->vcpu.arch.apf.host_apf_flags)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a5f3908b388..11892e86cb39 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1003,11 +1003,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
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
@@ -1015,7 +1015,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * as VMware does.
 	 */
 	if (enable_vmware_backdoor)
-		set_exception_intercept(svm, GP_VECTOR);
+		set_exception_intercept(svm, INTERCEPT_GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
 	svm_set_intercept(svm, INTERCEPT_NMI);
@@ -1093,7 +1093,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
-		clr_exception_intercept(svm, PF_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
@@ -1135,7 +1135,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_UD_VECTOR);
 	}
 
 	vmcb_mark_all_dirty(svm->vmcb);
@@ -1646,11 +1646,11 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	clr_exception_intercept(svm, BP_VECTOR);
+	clr_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			set_exception_intercept(svm, BP_VECTOR);
+			set_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 	}
 }
 
@@ -2817,7 +2817,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[CR_VECTOR] >> 16);
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
-	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
+	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
 	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d3b34e0276c5..2fc305f647a3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -291,7 +291,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions |= (1U << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -300,7 +300,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions &= ~(1U << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }


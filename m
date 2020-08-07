Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AE823E54E
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgHGAqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:46:54 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:55392
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbgHGAqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdDoxCkUAhslwj5yKRz5v4FXjVXoNQqgycgkGxonjyHd6O1fAKFT8QSYMdKCeXnh2anfknzRRHvALgB6cgCRh3zf1ofGSP5t+JqT4v6p74TJh05s4MRBJ4xqrfQAJ8rHnAhh8Mg73N8xIV6FXwcxVC1FCY50tzU9+P2JXncuz5sD1MRsrzKV7yLeTggnV6ZF25iBw8mDTLYtUNM719+Po2H1irYsCOg0zbzpkf1dRprRu66ij3pAJvHT42/JI/I23lVfZ9aFLbRZMhdoMA8kw0eUkI72w+AKf1zqlsRcCiTw+TQ3L25Vu9sPspsyAl1/gPVIhjYeZjFjnGDiVheIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTb7FxoV9P8KyrwoTsh9R6moGRtFKsdc50bAbWtEPe0=;
 b=Mvn24k9kJ5tbCcIxc8uW6Kmri6qfwskpqVO9q7KrcekaKDt+SjhNaTzfYl6iBh4BnCu1rOd2aA09ScZGi0/bmVqot0lNqvJnFzk1Swu/bibBaVSmBwTuA43srkQ+/IyiTVvVs+oE69MRZdxl/dY1HY3sYEpJDGdYhFQ+qZdcNIi9YwppJT7nZ6+qvo+0HlUTXTJkjqfUhGCsB0bYaI1b/8TPedzRiGokBiWBERmwiNe1TfRvxZOCrAMyW07ZVSb0csvpvV68HYJlTYgwYlDIx4xFdjx2cB9Qkv3suxb4zK/FoX+GCkv5Hx5OCmLZuYutmlEDtsDXX6T4IvdBCjqDpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTb7FxoV9P8KyrwoTsh9R6moGRtFKsdc50bAbWtEPe0=;
 b=ndQkI2dAqCSAw5tXUWPn++Q3Fsnp31nDNIMEZTSvMeVxsS0mm/cNNLnqfuNh5MxgY9C8Lw4lQy4eLEAWmvf0MKTkeMjlzrnaGkuQQ3lHG2ASAufCbqLKmdOiscscmA8jvF7c6YG0XHQVCvI+CYLpXFbgq2EzSF9EU2ccdplBis4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:49 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:49 +0000
Subject: [PATCH v4 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:48 -0500
Message-ID: <159676120839.12805.2738643693308373916.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0050.prod.exchangelabs.com (2603:10b6:800::18) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN2PR01CA0050.prod.exchangelabs.com (2603:10b6:800::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 00:46:49 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 231637c3-a4f9-4b36-6b62-08d83a6b5e84
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB447909F7A9BD8F15E082EC7495490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8NTY8ZSlOF7f64q3dsGzN/yq100CgXV6zvQch0VsjLbWbBATIpt5m6FMVWGnmhN8q6FAhj1SfJKezjbcv9AvfdBoY2VgKap2aurfE4MWiqImg8fTmcMwEHHUiVzGw/KXaWykUa8Rzj1N+5KyLK+gQ8Bx/iAwVOhTSt64Oq7IOtSc6pPojSh1F6UcJTcegvbB2Ffd8qZlpK+ufeUXdMzKee3W1OoGsivh09pyduhHtfZUkxKsM8DWAeuaNgasZDTAogDiMPXQy8kBzR20vJEvJHDdh2T0c8SgrTflkOZsmYwNWykPcrlWNoQZ2yv9gtWxzneH98FoyyCv5aSGqJqRujxoKOFBZJkVqmcfO6gJlX8SGq+QQGqwkekCoJjXRid
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cJ82OCskPljAWxM7iW5lw12pn7L9DPEwzzVTsH81J+/j/sqvtdKYR8HxlZ9483VeCX/ZIFlK37SLFOy9bI6JIhy9+GL1ZT/z7uc7PIPHQOkqlCyDvA5VcitN438yO6NjZvH6so6BB9QsAxE02NrnKc6Gx9bvBlorALenUwfQwooOdQEvqDzUDLOdLdFKYFQDcrnq75jhCuXm3Nco573PUqkgwUXXxWWSqpTFw+eZ494zYP2oRaittPiHU0K8F/joiDIOJUI7k8DeBj8HE2jz1ktAZmgpPRTOIX2bGqvwoS4hP+f2Ms7ifFMcteLgmd7hD/SYAk95noL9aCO9RIfOkPFy8Quy8oJsniu7p4zFojh5LZU13J2lFxy4GYLB3qvT0mdjBFhNS6NO34rRIMrYkH8BVexlUEPV7tahXly4x68I9ynJhPW5bTBEYX3YwfT2miUTYLu5FIvHlgwEwwMoOJb03ypnyq4xvyNP7Zs7dpTQ/q+WWxxe3ErwZEL/iDnMfDiic6v8OP7SKp9g+WQvlE61RR2REQyJsyXjSVnUdtkImIq5z7ggQstNm52BIKxNwkw2SHEourcriUYDtd0Oz3cBHqRx1uKWw3325Sy63wOqKiqe/2VsS9/sqL9bkwzNhXAhluTQzoOXVzK1m+veXA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231637c3-a4f9-4b36-6b62-08d83a6b5e84
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:49.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsfCgkjs0cRSgwX8zxyo98qfFgtIQxzX8XuFj9ZyKuaGn9T5dreg1++mBrRKjFEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index 14165689bd8d..080c76dc05d4 100644
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
index 24138874e8d0..246ee5fc8077 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -294,7 +294,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions |= (1U << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -303,7 +303,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions &= ~(1U << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852692537FD
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgHZTOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:14 -0400
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:64192
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727772AbgHZTOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI7igB/YlPW4eYJjH40QOc44pxuluwyJBZAoSRKkr13dgCFeYS/zJiStf3TBhgC/6bFYShG3tPW9rmPHQ4dSrUaPduJgpmVOH+cze5r6NAlRvG4mtrnDRrbQwUJ8jS8FshGkcqVi8TUUHN94JUc4nHAB/2KRMOH9Rg4JWKcB3F6yr6MJDgUOI5BD498x0sPzdqmQNRraLnZDmZo5rVdJNkFxZIvYhgyCV/shMK5F/GoElEGvQ6Tv+S+poZn9mQjdvNEZK6+Z0mKeCQXcvbSTcTMDUY3OlCnPym9FBCSMGdSiaOSF8HdMH7pE/O4Xb7jNsi6jCcNDKGmvAL883i8PtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOjuipFjJFW6NJStl8V3ODovc8K5IpQW1UGena9ytZg=;
 b=Pvsw7atgS6ND7Cs9MBWt4Hgj1qseFYBI8dPMgDBthmAYQ3OOJLaYZFN02WQdZPssAMJaIbdYcZ288qm1K0mPNv0oceQcRF3xy/SZeDoigOYf0DAXoaWuV0MfmhzFqQCk+qTjWX2cq8Z7/e5ooUn3uzKzODZ7i6TkmvV/X5m4jhKxJIzBsJ6FeUKL56f0WReK74z6osqkTMeDx94vymvVZIFn6VVgv9E+nVKwxrukLcdp6ASaAc+wSn92QcLwY2F9VcHC3gAFGplUTOTZ6J6xveQqjReulh3Ds2rTRsoKn8Klg9DIxSqRXm+z3G69eWKoXySh/OCv1DTSlz8fvu0N/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOjuipFjJFW6NJStl8V3ODovc8K5IpQW1UGena9ytZg=;
 b=f4tWSiwmIyrtWP0oCxWO0ffvQMgH/8HuI8OLdsC6VxtH/Wd1BjsLtgXKMjD3A0N69lEYU4DdRHxPpfO+9kBQfxT2tBGIhtKDeU/dTBdq7gEeDEj1CRl6lws1VD8n43GOisZszlipMV3KcKsn1hZNtXW5Y+uLFoU1Jk6e3J1c9js=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:01 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:01 +0000
Subject: [PATCH v5 02/12] KVM: SVM: Change intercept_cr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:13:59 -0500
Message-ID: <159846923918.18873.8521340533771523718.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:3:23::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR13CA0024.namprd13.prod.outlook.com (2603:10b6:3:23::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Wed, 26 Aug 2020 19:14:00 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6163e3d-4cc7-416f-7a63-08d849f430ba
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2461A8C1B4A3B78B1DB505B795540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhW4S5LMDrOifx4VYXmKCjdHmRr8WwhIAsvSOja0/T6G17xF3tsfwXcmUgvTm4CcW3kNhI5TVMrbPaqDgaKu9PWs7dfpni83I6x8xZ2EW/GBwfFrJBMI+sqixXW0njp1Irs32ioyVwHSRY3LWeIu+UF6p0PbfmLAzuJApOOQwTwMQh1PfziEgtV9c0x0yNpPc8FtFpJTx1gyr2kwXMEJcHodMUGZ1Bxn3oleNzU4Z3Wjp3cNKzwE57de7eqx67ZIo8Oa2X1ofjF9AXgdrM8tn5aIkb4PPe5f69rkyWLj2mvqUaFGVgDKnWUwIKw5/0Sgzl+1c8q7yQayvBhDx94k2LY3jNEbpJoRqTDnvjgS0x/KluMZIwKTwnrc1gNyH6Y3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(103116003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mT3yP7HC1Lzzj6Bp3fY2mXgF6CsnFSvx+Y1ZENiSahmITkaSyC5UInTCbTngEsu5m+58wIP15sCON5SKNZiO1xesq9Cmu3YWi6twmMVRXjQEC6s0tqKHC7uVN3g+Yb1LjbfeaBo1VPH+bTOoUCCiAZto0ezPKs7yYtz0Lv5hANPyeP6mIpDJ4oS9eYLKjTZONWBU87FD93nPx5jHmhfejp5Vbjnb7hiBXdmoq1gcFxZLC0wpQWIV1kucIbF7IGWzmxL1OwxXflLQCghRghDD8DDdZTeG5YeJGu6ckGUGy4mZuuUpOgAAM/0vLO78TU374jIRTIXXM7B60pNZLFf3Vl/DMVy6bsg25fMo0hD5FaXlGLJu/dsPdZ4GjZ1ifnIzuo40cfi6X7+4Ioua0n+PHFdVICenZmP2g2eDbMa7ElKu1zrkINeKGlZZ9tceZblg4RXEkDjK4dDDY96Ycl72g9Rz7kU8mN2H54xDK6cvV0pgkbkIWFO4eMwPNibPHf+lBj9kjB4dOKkjxsW0V6MVvqTaSkB/gaGqj6uZTDVn76QJA5OKjSsrxTWrRgaCpLI/xd74tIt8Kxr6CJ/fx7SPkjP15No4dDJWUpgpXA0JRiIzwQrHu6y451YaPr1r5A7k1OPyrVaJy5sVOgon4iRkwg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6163e3d-4cc7-416f-7a63-08d849f430ba
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:01.2789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZ1HvVu3xq3NxRD4HOp3Sk00jxgn/CYXelECoCJFvChz8QpKm1udlx8t8IZTkgGd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change intercept_cr to generic intercepts in vmcb_control_area.
Use the new vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
where applicable.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |   42 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/nested.c  |   26 +++++++++++++++++---------
 arch/x86/kvm/svm/svm.c     |    4 ++--
 arch/x86/kvm/svm/svm.h     |   12 ++++++------
 4 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 8a1f5382a4ea..d4739f4eae63 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -4,6 +4,37 @@
 
 #include <uapi/asm/svm.h>
 
+/*
+ * VMCB Control Area intercept bits starting
+ * at Byte offset 000h (Vector 0).
+ */
+
+enum vector_offset {
+	CR_VECTOR = 0,
+	MAX_VECTORS,
+};
+
+enum {
+	/* Byte offset 000h (Vector 0) */
+	INTERCEPT_CR0_READ = 0,
+	INTERCEPT_CR1_READ,
+	INTERCEPT_CR2_READ,
+	INTERCEPT_CR3_READ,
+	INTERCEPT_CR4_READ,
+	INTERCEPT_CR5_READ,
+	INTERCEPT_CR6_READ,
+	INTERCEPT_CR7_READ,
+	INTERCEPT_CR8_READ,
+	INTERCEPT_CR0_WRITE = 16,
+	INTERCEPT_CR1_WRITE,
+	INTERCEPT_CR2_WRITE,
+	INTERCEPT_CR3_WRITE,
+	INTERCEPT_CR4_WRITE,
+	INTERCEPT_CR5_WRITE,
+	INTERCEPT_CR6_WRITE,
+	INTERCEPT_CR7_WRITE,
+	INTERCEPT_CR8_WRITE,
+};
 
 enum {
 	INTERCEPT_INTR,
@@ -57,7 +88,7 @@ enum {
 
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
-	u32 intercept_cr;
+	u32 intercepts[MAX_VECTORS];
 	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
@@ -240,15 +271,6 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
 #define SVM_SELECTOR_CODE_MASK (1 << 3)
 
-#define INTERCEPT_CR0_READ	0
-#define INTERCEPT_CR3_READ	3
-#define INTERCEPT_CR4_READ	4
-#define INTERCEPT_CR8_READ	8
-#define INTERCEPT_CR0_WRITE	(16 + 0)
-#define INTERCEPT_CR3_WRITE	(16 + 3)
-#define INTERCEPT_CR4_WRITE	(16 + 4)
-#define INTERCEPT_CR8_WRITE	(16 + 8)
-
 #define INTERCEPT_DR0_READ	0
 #define INTERCEPT_DR1_READ	1
 #define INTERCEPT_DR2_READ	2
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb68467e6049..5f65b759abcb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -98,6 +98,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 void recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *c, *h, *g;
+	unsigned int i;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
@@ -110,15 +111,17 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
 
-	c->intercept_cr = h->intercept_cr;
+	for (i = 0; i < MAX_VECTORS; i++)
+		c->intercepts[i] = h->intercepts[i];
+
 	c->intercept_dr = h->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
-		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
-		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
+		vmcb_clr_intercept(c, INTERCEPT_CR8_READ);
+		vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
 
 		/*
 		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
@@ -131,7 +134,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	/* We don't want to see VMMCALLs from a nested guest */
 	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
 
-	c->intercept_cr |= g->intercept_cr;
+	for (i = 0; i < MAX_VECTORS; i++)
+		c->intercepts[i] |= g->intercepts[i];
+
 	c->intercept_dr |= g->intercept_dr;
 	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
@@ -140,7 +145,11 @@ void recalc_intercepts(struct vcpu_svm *svm)
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 				   struct vmcb_control_area *from)
 {
-	dst->intercept_cr         = from->intercept_cr;
+	unsigned int i;
+
+	for (i = 0; i < MAX_VECTORS; i++)
+		dst->intercepts[i] = from->intercepts[i];
+
 	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
@@ -487,8 +496,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 			       nested_vmcb->control.event_inj,
 			       nested_vmcb->control.nested_ctl);
 
-	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
-				    nested_vmcb->control.intercept_cr >> 16,
+	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
+				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
 				    nested_vmcb->control.intercept_exceptions,
 				    nested_vmcb->control.intercept);
 
@@ -765,8 +774,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		vmexit = nested_svm_intercept_ioio(svm);
 		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
-		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
-		if (svm->nested.ctl.intercept_cr & bit)
+		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03dd7bac8034..523936b80dda 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2813,8 +2813,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	}
 
 	pr_err("VMCB Control Area:\n");
-	pr_err("%-20s%04x\n", "cr_read:", control->intercept_cr & 0xffff);
-	pr_err("%-20s%04x\n", "cr_write:", control->intercept_cr >> 16);
+	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[CR_VECTOR] & 0xffff);
+	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[CR_VECTOR] >> 16);
 	pr_err("%-20s%04x\n", "dr_read:", control->intercept_dr & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1cff7644e70b..e775c502a074 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -216,24 +216,24 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
 
 static inline void vmcb_set_intercept(struct vmcb_control_area *control, int bit)
 {
-	__set_bit(bit, (unsigned long *)&control->intercept_cr);
+	__set_bit(bit, (unsigned long *)&control->intercepts);
 }
 
 static inline void vmcb_clr_intercept(struct vmcb_control_area *control, int bit)
 {
-	__clear_bit(bit, (unsigned long *)&control->intercept_cr);
+	__clear_bit(bit, (unsigned long *)&control->intercepts);
 }
 
 static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
 {
-	return test_bit(bit, (unsigned long *)&control->intercept_cr);
+	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_cr |= (1U << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -242,7 +242,7 @@ static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_cr &= ~(1U << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -251,7 +251,7 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	return vmcb->control.intercept_cr & (1U << bit);
+	return vmcb_is_intercept(&vmcb->control, bit);
 }
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)


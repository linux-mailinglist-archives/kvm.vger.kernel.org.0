Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A2523E54A
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgHGAql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:46:41 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:36993
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbgHGAqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUxLw+rXMhwkA8w6AsfXawf5ShyUchWT5x1NGS49W1dXyrrkhbyZznKBGjUaxlZdx3ZOCKv12IZDs7+EXKGXC0UAREPhSBe2vtgz9Pfr4iB65QnbezPJxBbwE/YppBIKZ/NWX+dd9rd+yZvodPuvpE/2Bg/aSPFcxcG6w9zB+r3jqJ47uYSi4LiKTLwLqV3kKd1OBYPcZkTHB/jvcK6eplwRMc+GrISt1jczn8+sLClWc68Ptqj19x33OHzuGqUhtb1giorAWhiSC6C9DyF9TCszXCpR7HaEnU6kA/mw3SogwKMW1p6B01STFop9ytrsfCQXaw6M+WCY0OGyB+tASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuwCb5C9JkblCU6rnYzFKqHshivrMHcXY9J26eoDsSM=;
 b=ezJo9YiorN1y7ZxqEzMQ3hkLUj2dmy06LCnQqDGUV1Jx3PndUsSgI+xuR+qjO7VbCi4MGsn4LTKRDPX4+Ppt+9ZerkFBEnPN/19C8OVsHv7VNuPpoOR2RT+C+BehgEC36HDDGn7+ZjS2HTOINNSZS/ol5fCHu1cXCbyZFZbtv46uPXspwC/1fg8RHDWFEFWHcTXarwWOiFoOO+RKBw/UOyn9QJWXwC/ADnJuwiSl+CgsmmTQckeigSsc6CTNk6A40xMIk8hKe0Jxu2GYAzmf9XAYsgHpoJlo31vsbqe9fOEJypBJ0gER3JIkqPZPsokY9a0IqJm0/F9uA8wVMh0hGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuwCb5C9JkblCU6rnYzFKqHshivrMHcXY9J26eoDsSM=;
 b=e+BMdZSoGY1mvGVqpPBbmB2+23ej6G0Ca/vUKvML061Sm64WuXulkixGtIKN2QmtHo6yhESHP4cyd08vyWfYZs5mIhPeiRd6BLLzO350tAVEG1s1WpP3mTD3ghCXkjseEkVO8R8PSHUf+S9xphNFU83SWO16dcrXdqJquZi2Puo=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:37 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:37 +0000
Subject: [PATCH v4 02/12] KVM: SVM: Change intercept_cr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:35 -0500
Message-ID: <159676119579.12805.4839763918770862251.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0076.prod.exchangelabs.com (2603:10b6:800::44) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN2PR01CA0076.prod.exchangelabs.com (2603:10b6:800::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 00:46:36 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ea08657-9676-4a86-f0d5-08d83a6b56f7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479411A884757AE586DB86B95490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2Mj5J7E+hhZxNjaimNn8iCQjMh6P66IdoTdZrAZ9x+HcBoaIMfLd6pxRT/jEv1MnbIVnTMUcgjeJfFnKXtEwqDAmZsGyLwkG4i959bFKfOnuMM0+Z2xthzJ3ddRT4KqmeHOfGDpKIlS/fS3XguozYdAgRUmnwiRusc0EVawpstNFtWqC8lrNLX5nnEdG/jgez0Ub6E20X9K4ImQZIA17i5W5DODCD7A3VPOazOmUwmjo11/mg3MVgcGuHRz0npV/mL9018quUgzxRgTWGAobx1SGWWCDFIAJhT15Md3R0VGWic4uVtBSms4V0G7TAJrd5e8ukyA1n7CS7EkdFLnRR3i2GZ+ozspgmLgPLntfd5wq/yBVul62vD6YTalT4y7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1j0I4OkJcSQ2Rw4mNU/scdD6Aeij8P/DfmCWGJXNug35vAeqjjtlicmDgbDjMcdAq0l8rfWmjjrSeeBbDzFMOPmf2NoCBzzcIg7+LqbJDLKf1lYCtIApQEF47WNNI2jZU8weYiCvexNSGGuOnK99p+b9IPsMc0qAGa8+dl6CZqc9d8ojDRMThhOoVa6n+XEAovti2CIbBAQq7l8OtNhbZZi6699OzZdtnvnWEwzWqQ0KceNyhdryvgKRGQEAwfXx7ejP4CLScieE41S7Df01e9UW9GNTrD6H7gt32w8u16PGQUpApWgC1TKKwhvZDP2ytlZrEncBbu5lPush+hKrdPkDiPDM7Ct7AdnjXT027IS3WWHTPuohEq16Pm+jnypRkXf0pNotTTHNquZb4ZZl2fC+mw9t9LqpCb68f8XWWTS3g+5m5bVegWcOYmGKAEBdt6Cruy6k0IFqayLjT7IOmF7VpIlXtI2nDPuD/PkrpsJVK4jogXqSBLdtvLmANyDHlBVQ94PjHvwD4d9qY2G9XqN+NwJvGHmRvsO90GkfXlgVXOYYuJAdXYhuL/c+9COCEdXIyw/de3ktZdVekwmHte5+Y+x7ZJJDXgIjZGX6fGMIIxVdyvHyQKnIJVYFwMVTXLWuatQyeKs3f/ppoJcm4A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea08657-9676-4a86-f0d5-08d83a6b56f7
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:36.9245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqFVzD29S5agImvIAdleDfHxwTBicHpRMrDHwoNMRTTLdFRuIM1d87lBzf+5FTa0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index 6bceafb19108..4f7faca0d0b4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -105,6 +105,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 void recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *c, *h, *g;
+	unsigned int i;
 
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
@@ -117,15 +118,17 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
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
@@ -138,7 +141,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	/* We don't want to see VMMCALLs from a nested guest */
 	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
 
-	c->intercept_cr |= g->intercept_cr;
+	for (i = 0; i < MAX_VECTORS; i++)
+		c->intercepts[i] |= g->intercepts[i];
+
 	c->intercept_dr |= g->intercept_dr;
 	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
@@ -147,7 +152,11 @@ void recalc_intercepts(struct vcpu_svm *svm)
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
@@ -430,8 +439,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 			       nested_vmcb->control.event_inj,
 			       nested_vmcb->control.nested_ctl);
 
-	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
-				    nested_vmcb->control.intercept_cr >> 16,
+	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
+				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
 				    nested_vmcb->control.intercept_exceptions,
 				    nested_vmcb->control.intercept);
 
@@ -703,8 +712,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
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
index c0da4dd78ac5..334bda8b31c1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2797,8 +2797,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
index 9f3c4ce2498d..6d314cee5496 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -219,24 +219,24 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
 
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
@@ -245,7 +245,7 @@ static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_cr &= ~(1U << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -254,7 +254,7 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	return vmcb->control.intercept_cr & (1U << bit);
+	return vmcb_is_intercept(&vmcb->control, bit);
 }
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)


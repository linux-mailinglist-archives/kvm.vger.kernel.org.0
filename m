Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6226231641
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgG1XiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:06 -0400
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:63269
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730524AbgG1XiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5lRYoUimJyweDT2mKBKHoLDfrkgZfgGty279gMd8vmED+YW+vWFN/P7a4vlqKaLhvmjgRXrhwgcQwP/8YpXM5Fm61XV/Tt9PwVoWDSVE2fjjWO2rYmDWVvKLC4n6D/xeU4aaLvyNW4zTSsmp0Q51fqRFzhXI26eMCzP57mTE9tUFbpZDKIFX6jSiuor/eW4VqusrnLzN4u3cL8u/LT8s7Tg6pNOlLuavHoOu6P0bjrvr6LGA8dGm2uO+Yhoq6MhtktkrMj5FKBzYtqfTN64gd32edmn4AmSWQFvHmWSxGfFYV+PiiM66QYfQuneiOct/UD4RZuBYFpRQFIgC3RO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sliE6gee74NebMqunLgxVFwJiiMaJ+5F+GpeLOK5vog=;
 b=ELpwfeD80b7p1fkdUHzbmWyCfJHRnA6Bu8K+8uq4uCzRG7il4bb4aqD7nTuQ5PiSjtlnkpUy/np8mbtlx949aWb8X2ewuMpML8GGtQwa1sYvYMqErqyXC7JkxIEOQNH4lhrNTgrVQHIDHf26ZCXJ3EAqwzfVO1CKIfUj9MnCAN//XOy1DMJRiKsYnN92ww5Ou1ST9hwdF5VzURTksFhJ9rsouQx8x4+IU+uNDvjL6I5KuvevPe6QwTKJeRsnlOiNwt4SWaJQ/2NfUqL5SNd7XbWIjSUu4363e0kMZWtWOtvxxqFQIcPE1+DklPRYHHQrdMYDfyrO0foiPaEXz4ALfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sliE6gee74NebMqunLgxVFwJiiMaJ+5F+GpeLOK5vog=;
 b=fv67r88UdtCEyVyfWTVag1vzCdh8k0vZklmllHojUfX3LrigkDKnviOMcOEML/Tinj4/GMAKDEeTS6H1t4FYkgdXGopLCcMbv46kSOWN3HjPYbrQ1f9IGWbTm45rM2oCUQFAfDs0ja3ElhcgbpJY29LaxDZm2IHZWt5kYYd+w1U=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:01 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:01 +0000
Subject: [PATCH v3 02/11] KVM: SVM: Change intercept_cr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:00 -0500
Message-ID: <159597948045.12744.16141020747986494741.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 23:38:01 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e9f0055-0167-4cf6-e369-08d8334f445c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559D1F50453634B29076B9195730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HhketZtoC1cp/LvaAobyY9pqaJIl7zD7Z38p3/w0dr3gtpe0T7+VZcVOq30viIaEm5E/+PZ9N7ukKL6PtJfIJd1JqahW06+uVVoqRPfLrPbNahTaO/B7h3miGc5qFjLGT78ACkb1PZAl6xT2lvNHAVEdwOl7vPHqKiftjxxtP6g0UDxU/2XpGmK4hYZ7NhS7HYg0fWCc7LnkIUzHfdSHpUP8jN5L2UIlWWsDJagGrUlkyMYluvXaEoiy1V3J3WPF3/FBE0v847hBVrwTMJr68SxNk+VaxjdXUy3P7B1vrnNnUea1wQs2gGMlvIE3jgWezA3a7J2sUICqQ6z5uSv1jsk5F+YP31qkkC4AxE1MLqtPhI2idhf9TcpCiIgZU42x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LcfJnCr3crPxPjEoZuAVJgpLsiTtH3azBaNBdryQiENzP5kGRsLSJddjTIqMAObeJJmMNejFX89lypi8Q2A5YTtTK2+d0Ep036TQM6eJqs856PJXYziYNg6mZPKPPLvsCoJNRFGLlHFqs5vcqiby4eoxGDPn4obz184xa9L1GIgVWkDEzVo22J7eYUy152m+CCj1ChNg5DwAC5b1u0ZblgRW3eQ4BpGMh+B4DqLbSX4p9nmJ26sEhbmguad3VvfwMCjxR8mQSWnosg3ddL58cqleJZhIPiGjESxioQryR/H0aZOoOpCmiq5/FtNqWFvZTROYRhh3jQzDIkN2R1qvr91RulxEn+l0h19uK3BrSoaEkNuEhYAbZQcoq1FZv+cmtSTU2rm1IAUe6LqXLY1ebmSOC2zgjfLUCunK7GfJDUA+OnoItuhwChxJUqvq8WQt+0PBiYlV4mhTK3+YackIomoQyMIeyGDDcH4QP61fLAnPd+ykZ7kvnMGLLpQpW6Sp/wbWzoo+dbEwiMVfRi15rDPFDpMSEY9Y1o3644IfV6P7oKMJeIqPvrmplesyOulNYrxsCh/59Fb7SUf0uU1DF/O+YYE/BSAxPaO2bp3SKUROl59mww9UYLjlv52lzusVcYYtms5e/SWvxUwuoNbg0g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9f0055-0167-4cf6-e369-08d8334f445c
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:01.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrqt59QHjrz19BD9q8vcaxfMpzqlRj1Rq2oV5xykbtbSf5bpiwO5gR6jV9s20PBF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change intercept_cr to generic intercepts in vmcb_control_area.
Use the new __set_intercept, __clr_intercept and __is_intercept
where applicable.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |   42 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/nested.c  |   26 +++++++++++++++++---------
 arch/x86/kvm/svm/svm.c     |    4 ++--
 arch/x86/kvm/svm/svm.h     |    6 +++---
 4 files changed, 54 insertions(+), 24 deletions(-)

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
index 6bceafb19108..46f5c82d9b45 100644
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
+		__clr_intercept(&c->intercepts, INTERCEPT_CR8_READ);
+		__clr_intercept(&c->intercepts, INTERCEPT_CR8_WRITE);
 
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
+		if (__is_intercept(&svm->nested.ctl.intercepts, exit_code))
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
index 3b669718190a..89d1d91d5bc6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -236,7 +236,7 @@ static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_cr |= (1U << bit);
+	__set_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }
@@ -245,7 +245,7 @@ static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_cr &= ~(1U << bit);
+	__clr_intercept(&vmcb->control.intercepts, bit);
 
 	recalc_intercepts(svm);
 }
@@ -254,7 +254,7 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	return vmcb->control.intercept_cr & (1U << bit);
+	return __is_intercept(&vmcb->control.intercepts, bit);
 }
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)


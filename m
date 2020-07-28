Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B3231643
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbgG1XiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:12 -0400
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:51361
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730588AbgG1XiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZV+3RpwPuhEaCelKCeR5tK/laP6RB8Si8PEUHgw/rnXHMIqJr+cJniA+HNlufZZ4u8kq9dX/BytSC1LfE50bVZYdLApv9NpRJYmnI/EECVEQTzN8ZmU7+URJ0j/ufhXBj9y3LN8E70SJvJci5r6XDRSK4RpM6zhXCvBUcNZtBd5MoOQqRi2SsB/yqmmBAcc28BlWQ2DcuhmzNB5F620AJpKUxgFFDPcBZ3GrdqswvnrTOaz0oacwI0+jQ7MiLiMa9WDnWe7D8tKC5lFujK7I4rksYrWKMOnoaWiVaQifxu+3Ct7nA3MDU55z+6Tnhs+6F+TQZsajmRNJcWu8V30lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4GAgvxErdN16DJVEhtTixrGTiH7gu54Vpz7T8g2k2k=;
 b=MgUauhL+rPlyTSB6+8ROL+0i0diO1xr54cz3gKcpIO/J7Mr3jGRsAiCfkxjRQiI8Nw4yJqTbvJUj60VMyexdK3m3txue1SKYmNI6k60jagPvHwyTpEOkcp76oW03yvySYbPp5hfT/yq2Q1xMklYVvAk+GsqrxTsEtnYjkfV43/OY3fm5R3urJU/WtmQ/YjLWf7+pBSHCDErqhnUg0X+rH1YeKkQ/1SadvvKMywngF22+qGKlg7FRtOmyH1KGizskKXllYlSTFNPdHYg1GRDtgq+fsAd4yGtbrbDFkq4WFwYT6n5cY+BuYaqfiFTqjWy1BCBDx4A9//XvDl7FcHeJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4GAgvxErdN16DJVEhtTixrGTiH7gu54Vpz7T8g2k2k=;
 b=yyFP15Z7PH7VJzjIq92/6yjNNEqcGUyjOtbsM+GcJrTPKh7JyNUur5YNqH4P0uc3C4HHvwl3L2uuL4cDo31AnutRuG7wqyVGoeahvTgpCqj96gOQmlrhJJtaDeae2l7KAsb0G33OeGolqsPolosXGqOJMhq0wiaavIwY5xjk2eg=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:08 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:08 +0000
Subject: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:06 -0500
Message-ID: <159597948692.12744.7037992839778140055.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:805:de::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR05CA0021.namprd05.prod.outlook.com (2603:10b6:805:de::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Tue, 28 Jul 2020 23:38:07 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fad44a4d-802e-453c-348a-08d8334f483d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559F5A6FE4ADB1BC436610395730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfuJ3WgMWVZ+ZQbUz4o5pFxT1YOZxV4jSeunDd4x1CWeD7+mry5ZBQALRZwhEtGPAxkX0zunv233my6EG43D3H4OYcR9goYI9Qu86xUW3Lslp9eEG9pFxEEh0fPmKRx9T+8mjlYTgkeA7ElWKqE8qfbc24XZjpjQvMItsBq5XPqN8bNoneoM/oUysLc2ryvcf17wb4+nrzZK7y8uDfr34FOKaoZaNaVeBoSN549OUmCzdK5ZlMpDvUXFKN7uNbQJR2maIPF7sw9FVy3/jnFzQQkAwBzcjEFZLF5Kd4FpEXXfCgpXJNAQzCh6aUreU+S0JhMGa38l1NNlAFjCeH9iceKRz0Chy7+A74QXKPBB5oKQ+JjbKgwd6jIAj/2EAh6R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kqYZb1kh1BR4CADGtlSDAJMXMjuHiAI1Ac8lqp7VqbIvA8Iq6IhxY23H35hfAYPJzyn5Ujq5mpfPuRHKnLlDh2kBNpMQPkgRskXKL1uBdwzSFcf3arWx1A9nqR2KXgEf2JCn/KxfhSP2V9/CXqc5TKZGTilETmWX9lJZ0bPabI8+ZlKrNOi+XNqdwk7Dh/J0uti6cfq7QFD4LLwaDvfAKhxQraVnagzX2brNC2oBKdHpJC4x/ArMgWyS+qrb7SpI5fD3a6y/TDnE3MEAO3Z0GDNgEmt4Gy3j6Nni6EcOBhz2YviYUd8Pob7yah1yu+ezCINUH2yykNnFekg1CxW1lTpUtDCV4Xueq9W3OHIHHRRz5WtxfzQAh+sswwBgysRL3NBHbk/gSt3Y12RDtvL+c3gY3HmzDkoN9KO2c3N4N9ysxDH8wfSK2zdRpGczyhGDTCCh8imiBNLTADmab4egolx57s9WCdQGrY+xt2WwzgTCCSBLqhT8ftGaRNiBSRWdsyhLSXF8dM75GKH9j/5gFrwXBlPmMQ2YX/njTJ4buRm7tzRdqAzOAeZ+nimIbStQzcfr8cWCAT+gzpVFMoJrBx6Fp7tlgNNpMvGi7nTCktinU88kZ6NfwADU+DZ2y9DuPMpYJsJ4lN5Hjjj1mJgaHg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad44a4d-802e-453c-348a-08d8334f483d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:08.2657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nkMwFGYlLID2oJffm5+8Ts8YnwBdesJbiyb3Mo0sXnPgxAeD3IYTydQhbFZxwoH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_dr to generic intercepts in vmcb_control_area.
Use generic __set_intercept, __clr_intercept and __is_intercept
to set/clear/test the intercept_dr bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |   36 ++++++++++++++++++------------------
 arch/x86/kvm/svm/nested.c  |    6 +-----
 arch/x86/kvm/svm/svm.c     |    4 ++--
 arch/x86/kvm/svm/svm.h     |   34 +++++++++++++++++-----------------
 4 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index d4739f4eae63..ffc89d8e4fcb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -11,6 +11,7 @@
 
 enum vector_offset {
 	CR_VECTOR = 0,
+	DR_VECTOR,
 	MAX_VECTORS,
 };
 
@@ -34,6 +35,23 @@ enum {
 	INTERCEPT_CR6_WRITE,
 	INTERCEPT_CR7_WRITE,
 	INTERCEPT_CR8_WRITE,
+	/* Byte offset 004h (Vector 1) */
+	INTERCEPT_DR0_READ = 32,
+	INTERCEPT_DR1_READ,
+	INTERCEPT_DR2_READ,
+	INTERCEPT_DR3_READ,
+	INTERCEPT_DR4_READ,
+	INTERCEPT_DR5_READ,
+	INTERCEPT_DR6_READ,
+	INTERCEPT_DR7_READ,
+	INTERCEPT_DR0_WRITE = 48,
+	INTERCEPT_DR1_WRITE,
+	INTERCEPT_DR2_WRITE,
+	INTERCEPT_DR3_WRITE,
+	INTERCEPT_DR4_WRITE,
+	INTERCEPT_DR5_WRITE,
+	INTERCEPT_DR6_WRITE,
+	INTERCEPT_DR7_WRITE,
 };
 
 enum {
@@ -89,7 +107,6 @@ enum {
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercepts[MAX_VECTORS];
-	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
 	u8 reserved_1[40];
@@ -271,23 +288,6 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
 #define SVM_SELECTOR_CODE_MASK (1 << 3)
 
-#define INTERCEPT_DR0_READ	0
-#define INTERCEPT_DR1_READ	1
-#define INTERCEPT_DR2_READ	2
-#define INTERCEPT_DR3_READ	3
-#define INTERCEPT_DR4_READ	4
-#define INTERCEPT_DR5_READ	5
-#define INTERCEPT_DR6_READ	6
-#define INTERCEPT_DR7_READ	7
-#define INTERCEPT_DR0_WRITE	(16 + 0)
-#define INTERCEPT_DR1_WRITE	(16 + 1)
-#define INTERCEPT_DR2_WRITE	(16 + 2)
-#define INTERCEPT_DR3_WRITE	(16 + 3)
-#define INTERCEPT_DR4_WRITE	(16 + 4)
-#define INTERCEPT_DR5_WRITE	(16 + 5)
-#define INTERCEPT_DR6_WRITE	(16 + 6)
-#define INTERCEPT_DR7_WRITE	(16 + 7)
-
 #define SVM_EVTINJ_VEC_MASK 0xff
 
 #define SVM_EVTINJ_TYPE_SHIFT 8
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 46f5c82d9b45..71ca89afb2a3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -121,7 +121,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept_dr = h->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
@@ -144,7 +143,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-	c->intercept_dr |= g->intercept_dr;
 	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
 }
@@ -157,7 +155,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
@@ -717,8 +714,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
-		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
-		if (svm->nested.ctl.intercept_dr & bit)
+		if (__is_intercept(&svm->nested.ctl.intercepts, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 334bda8b31c1..6d95025938d8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2799,8 +2799,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[CR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[CR_VECTOR] >> 16);
-	pr_err("%-20s%04x\n", "dr_read:", control->intercept_dr & 0xffff);
-	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
+	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
+	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
 	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 89d1d91d5bc6..f33a50f92b92 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -261,22 +261,22 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
-		| (1 << INTERCEPT_DR1_READ)
-		| (1 << INTERCEPT_DR2_READ)
-		| (1 << INTERCEPT_DR3_READ)
-		| (1 << INTERCEPT_DR4_READ)
-		| (1 << INTERCEPT_DR5_READ)
-		| (1 << INTERCEPT_DR6_READ)
-		| (1 << INTERCEPT_DR7_READ)
-		| (1 << INTERCEPT_DR0_WRITE)
-		| (1 << INTERCEPT_DR1_WRITE)
-		| (1 << INTERCEPT_DR2_WRITE)
-		| (1 << INTERCEPT_DR3_WRITE)
-		| (1 << INTERCEPT_DR4_WRITE)
-		| (1 << INTERCEPT_DR5_WRITE)
-		| (1 << INTERCEPT_DR6_WRITE)
-		| (1 << INTERCEPT_DR7_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR0_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR1_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR2_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR3_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR4_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR5_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR6_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR7_READ);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR0_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR1_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR2_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR3_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR4_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR5_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR6_WRITE);
+	__set_intercept(&vmcb->control.intercepts, INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
 }
@@ -285,7 +285,7 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = 0;
+	vmcb->control.intercepts[DR_VECTOR] = 0;
 
 	recalc_intercepts(svm);
 }


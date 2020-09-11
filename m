Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAE2668E9
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgIKTet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:34:49 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:49377
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgIKT2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cp8M1C6QJCTi3fEnTHCXFQPNNxhfMtxjT6lCqJQVukPgNZpCkJFNP3Du19+Jk1BWgbgWH62As9kS7VZxH9PkjVD+8Ozy1D2c3E5AecP5XK2KUFPsg/vbgZO/Vz+NfNAWcrSGUfqGIVNKtVPXSLcmXpeWOi6FVCgZKr1e9gyCOXsowrkoyGZfNSsSYk7oPnmg9CxhZiyyYGcHjIWk88MMWrHw61ZL6ZFL6xjkz2ZVuafUX9NWB/WX9gfeV4q2otrnXiFN2FoDSfyZ9zYD4fDhrdv4VYSq/fnsWrwXEq/c6PS2i1hY42uf1xMnvHEwWU6khAuxSts1pLDK0YJwqHXaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epTd2sqgyV2oHEQKepmcFy2r+btPsCycThlOKFFYiag=;
 b=C7NPesV7ntsCKTrsujIqZEgBE46xX28bES2NYz4WEb0IPRMDGbHi3Ho9FbrwV78gBrfGlSTLcDWqXX3617a/kC4z6+1X9ZiJnJqz3SqB5ZOxL6qRHPxfcK2IDiY/JDNgPAdlVPRVk3f2RwcRTosQAESOiE+Ji23Be7ny0uYSNMTKADfxSIav/pP/OC6QIlwzMWDTw/fTzQj/FlSzEs3gnGp1B81+en+ODSv4Nx3gC0cvGyl1yf3TiqBRihMeJbY1Aeb1fB+/kFW3gob+21edw4OUuXKxMHlu9g6pCXyJssg4NGPI2Fie27tvIFRyW0E58bstekEk/fHSXopOah9t7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epTd2sqgyV2oHEQKepmcFy2r+btPsCycThlOKFFYiag=;
 b=lafIg+nU2aC0bLSy+Otb38HhURX2yAqqWVLbp2cseBih7tKlsyhNVfLhocMt1ICxHRVQ8VUMRGiJ099fNSEVeLy02DDypin6TPlvqI0HIRRtsurbhnHxvp8BYhnwlNSbRiBBf0Nlw6OJxkghMyzEMic/TvT07rj9RMd+Tit4W5E=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:07 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:07 +0000
Subject: [PATCH v6 02/12] KVM: SVM: Change intercept_cr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:05 -0500
Message-ID: <159985248506.11252.9081085950784508671.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:3:d4::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:3:d4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4 via Frontend Transport; Fri, 11 Sep 2020 19:28:06 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6aa8f17-ecc5-4864-9297-08d85688cfa3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454395FE3C398330176FC2C495240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9HjTeBKI4XXU9Jd8PhZtLFSp1NoIZdh6K1WXbvdxT8Ysn7dQ6sWOX6dWTkDfPt5bstegpCLDMOnO9c82xph0/pd2DpKHW6nHQJGIWBHTaZd4g1zCShr8wSqRF1up8YnVyR50KCgo76zaiOLTXCvcQw1T/xGuBRWUrxMhJeu60/jBXeMLSRtIH+mVCahSrBPauu9oXjs9GKTmbDfK0rM3wgdFzDw7J7qN73qzCAjV/SXG9mw0+UdHfAVjFt0MhZRBBiQqaDiQNJCMmuZrVXaaj2lQL/ennzxdar3+elhO0Ec6YEPSnLepTDHCynJFmDHuemrhlyjNZCCT1jjwq9AFlK801wuJTDMG3YGVVyYR8Bh3QlCmNqCuoiYjAEqQ562
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VQHryGawRkZhShK0zJxMcGVKKk0Wo/cAv0Zy4kRu1Oqhoqx5ef6Sn9190lOA6fpzV4xT2dCh820eFUNUr4PCI+JCh2MbQux8xaUgc2gMfv9blva/C3WZA5Q52G1iRhqCqzgYKiXT5xil8Alv6GPMwtTfR88u/ISg3jHJEsu6uWzB8RW6kiGM6Pz4YPoW/qxqJ5PaSh1ArGav5Xz047kAGKLsJ5gm2FLMdNwC82zuFdgI+pk2mm5GvKey4qlO+w+Hl2VS6saf4zOOP9nqkNXNWQb2FTLgashw8dC2eA34p6OExRPXC+6QbpzE0pLwOpxy5DaCrEMuYoUS1zKdv7kfysZ/nuBkR0kumReuB2m7pkPDkCfjTR9/Ydr5gdf0xR2SvUb3VPVMuq0Dv7irvz5L7BAjNarmPeHQ852Z0iLC4j+dBdTaTU+Ty2V9iHvrhXhe6/7lrr6EeH5lbH8QVC3eG9W8sI//20iNPAoGtdk4gxDFBNDgnLKXCfuBitOYUHdc3cbMqEd4NzEKZdjG0WKlgrTJPYO6M1kwglShIYEyl1vul9yufQXpOpGgqN1pMC3rN+0L2ixGD+11n10EH2V47jzGI4BehqIp2RYNjzDtf60DKx5RTqraAuhsw1qZyth9IPe0Wb5jKFln/PBJTQIipw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6aa8f17-ecc5-4864-9297-08d85688cfa3
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:07.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9I29RHbMwXGIB9oVSKo/npJgX/Xshqfy88+UH1c3iA2FQLvDfqevOu8Sl1oVbz6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change intercept_cr to generic intercepts in vmcb_control_area.
Use the new vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
where applicable.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
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


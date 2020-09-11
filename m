Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F9E2668D4
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgIKTce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:32:34 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:49377
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgIKTcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:32:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEaMcmLd5PlUuFgnT5Se2DEtpxhRqLVKNZhtguIF0SvnSA0+vc0p/RN9VaWTJfCXSgljK3psSvcCAmzCYEadEmZ0WX9CXbWMo+njm8/AUvflLSXfcF+rpf04/TnAuZX36845G/Hdyag1AmgmzdZFP3Bzleg/ZZqsrzWeqc1ZlbZh3jEcHBwg/P+PkwsS+GcCC61Y00dt699Tt2NINI9wgaXCarhtB0ADcSktGOsxRF3E9jwiNA8a/pZXiMfuktJ5YxwaEyG11vS7kiddKhqfMfK0g8rSHhLD6H3tKj38k/DicsDwX9pP4eDm7PiD2SDRt28Bmswccx7IMz1hGG+Pag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxI0klGKMl7daCyQYoiqlfLP3wvifwYsQqsx9i7BXz0=;
 b=PQ0MxPq3ntR0kfmWAi8qi94rEC8Yx626SMwPZ7UocrVAYA2z1PS4g7r/H5COsnE42vUs1LRAL2OL+gpl/oNaqhYF1ZqU8Diiu8npC3tVxqtMu+fcI+3HKCXkty3NPa67Zw5YT/VzAm04fl/t9KyeVQob+SNTt6TaXs2lw01ZJ4bXkKo6tEpp9Us8s7o+13UDonlPCHGdHmvFS6I/olHd7Lce3erDGJAaKXDHolM/2TOCDCGc6iMtsbBjZJBv4fon2RA4M0qbLSxIHag5I1NN6C9ggf3CUAdsv6FeiUEN7RZHWP7m2T5b4eKwQ3BIuTKgCTUMxdXMK6UQoL0C8q+nSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxI0klGKMl7daCyQYoiqlfLP3wvifwYsQqsx9i7BXz0=;
 b=qPbcDISquG0jYGLIQv9W59tfAeizXSzZFoeWjVw7S6KbYVemyDuPkoncr7E67q+2xi/QDdEPDku4/EFvq2JzX9q5jrD4ZYVTptLq/ddZs40SQs/IUOtJunD1wnxTH2YX7eG91IOAnA9q6idDHjqMzDVfrtihoUG6/0wrtrc0s+I=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:15 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:15 +0000
Subject: [PATCH v6 03/12] KVM: SVM: Change intercept_dr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:12 -0500
Message-ID: <159985249255.11252.10000868032136333355.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:3:d4::26) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR05CA0016.namprd05.prod.outlook.com (2603:10b6:3:d4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Fri, 11 Sep 2020 19:28:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0dd14278-cf76-4de6-e217-08d85688d406
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45439A585B66C4FF25687CC295240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47l3NZo063R/OtBYnB8vSqKGbs+k65QdSVN+bJNDr+4+7OpMKolrJYrLyQjqUauTkCZhil1Jr7Oz92JRcqAllYYuj4Ou3fIVHggDthZkU5mFVHateV1D/e+g/DSQXRcF8Vcj3Qi5gGeADjfxl6UvDCTBkBdRUYdIyNXPK/9KH7ESgcpqlhzsEo5Kbj2MZqRdxvnz6Ghh8pZ7QkkFW7ff1U+KSGMOauEi1KmwQ0Cu7xAhxU1PFyvi3gc1fzRiWmOSJZPfr1/RG5ZmBhJNWE+hc205pyCOEVIrBMH7aippKOPzVkTv4fLIcWFXqaJIsWdJn/ANBaPUGINNuBfiQaIbjOj5TBTvmkJN5Yl65Zob6VvcHQJAkwcaANjXc3zDsRMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Qtdpy3+WZPRCaYWruw8ojAnAVEY+TSEwpKbtzZjNNeUo3KjXF7PgtiVMxkeqmFPjXsp4aQXQRrfVpdY14LHsvxoERKGYlxbNlk2WRfwg3fgjG7oke4DJV9fkxq8lg/c8nRycWqPuhHXAI4kEu3lPJ8Zs8QAUzNklC+Uy2LKDX0Lg3VRrATX4ZwaeE+CY69wteuOgtZje0LEhVuRfmZ7ZveYLKvrWgyaKYDmxEreo1G/aWl+bakeCX1nevXR/CvlzegPDLiPvNCS1w30nbyxVdhHjuLb70kY4o9oXkclIT9l6wDYScd/5twPREl2U4X45FkD/vQty6XMISKJS4OD9XWWeS4VQIakof6XDs+fQVaRoXvhuygVmELCKcBWMXtLK3DxBu5JRbe2GmC1UHxTAtwMsmAa625yoXM/lyQroR1TUhIU3WZRObkocdaIcPsOBGC0Xk9QSvdb3UzdfdRUM/clj2dikkgS1rCN880RzkaFLO+Ir+qb4qXC3sp+jhf0k5TEWfijcYyMPq1g5Mu06rDlmGE9Y2sJVXu2C68Hj7ENCZSkaLL/fQtFA9onH8QCOJ3aQr2xC08dFfp3riN0kWqk4X2HIXonwSOBrJXflOkkeBjkJs5Q4HT+x64WdzDZkRJ0UyKBiNC0W6yFE6kIQnA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd14278-cf76-4de6-e217-08d85688d406
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:15.1603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEO9khH65FBnBeGbXt8fdGvHXAAyFdZ2hoaImTG3ZfkMBRQC2809RrkFpI684zYl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_dr to generic intercepts in vmcb_control_area. Use
the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
to set/clear/test the intercept_dr bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
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
index 5f65b759abcb..ba11fc3bf843 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -114,7 +114,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept_dr = h->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
@@ -137,7 +136,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-	c->intercept_dr |= g->intercept_dr;
 	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
 }
@@ -150,7 +148,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
@@ -779,8 +776,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
-		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
-		if (svm->nested.ctl.intercept_dr & bit)
+		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 523936b80dda..1a5f3908b388 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2815,8 +2815,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
index e775c502a074..d3b34e0276c5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -258,22 +258,22 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
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
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
 }
@@ -282,7 +282,7 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = 0;
+	vmcb->control.intercepts[DR_VECTOR] = 0;
 
 	recalc_intercepts(svm);
 }


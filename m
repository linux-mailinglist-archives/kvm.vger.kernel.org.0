Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72477253800
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHZTOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:24 -0400
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:31745
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727813AbgHZTON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbAKKOGaHYt0Q8TWZVLw4LQgI0Tkaya0CFab4ItrlP6/KazXZgve0DKu55iYKFJgu4ZcZtvtQjyRTgQiJXAMrOsXpm0eEDum9hzyPZm+H9ydWjMwv4PJ1JegnT9qMm2bVyaxSDW+0SH5Hn83k8Ohi8VGNfHpfErm25vGm8ycjn1XK9Ac4wvNszDUwnyEQz2CE4gc9uPHQbIi2oqStul9G+uyHMQ9h0zEfeQb4MMuaJTjk1to9KcBLvf6hUbau9Ejmdf0kShNPBkw2AIqyW0WMMCsFLIJdk5/3ckR8HgZeEdUaAyHNvrvNL/kw7LG3Yd+Yzbe4k3QgKkudcIIE3ktMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bckht8T8MtG8i/+MDkmslAfdqqqLtYTbpiPUur41qhk=;
 b=VWwTs6KpQ7+fZ7OmBjT7dVR0f/RWgAnPKbJF9FEZl6R2mYa2CnXHJatlhAwaBL6KzEYLtA0Ww3X5dvtvEOQPv77KsPidfwzdF7y9aRr+fuQCvICd+TcV39xix7clUaMKvuCyYZpKIijs5GLMM8zwjj/wXp7/TLyuk6AwSzo+9Q32hOXZ/mxJxXkutezMU3PBk0yUgkw8g2KK4EShjDHk0pEkC7UB+crGaSe94WHTw6YMJiHEm5IjIdfBGvx8RJGse8OnpdroZJBBPQU1fRNtuHhy+9s+mu0of8sjRAWKf5uFV6oBitxikoycT/K1T7quSm2xVZZKPeL3UqsbiDPoYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bckht8T8MtG8i/+MDkmslAfdqqqLtYTbpiPUur41qhk=;
 b=fvsKoVJn9HrIBdGgq6h7bkfKH6iwFLrfpQ0TRKRUTocfvF70C4COIJONVSYRaj6M7+IK+lhcQXHBr0a8UliksOsx1p7qfpq60Ol5K8WW0nVVT3IoE3Pbw+EShjRkSODx4iYoieObuVEPW+Xq+2l41s+veXc4tKp0UExjakA0124=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:14:09 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:09 +0000
Subject: [PATCH v5 03/12] KVM: SVM: Change intercept_dr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:06 -0500
Message-ID: <159846924650.18873.2599714820148493539.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0079.namprd18.prod.outlook.com (2603:10b6:3:3::17)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR18CA0079.namprd18.prod.outlook.com (2603:10b6:3:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:07 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b259a83e-3a1a-4b12-0fd8-08d849f43556
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23840B4EDD09B5040D14274195540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQSYsGvg0LL7yBA9smwKohORBTcOZJfxX2M9WLrF06km4VTU3pve9DxGAtYp7VpzGHXGDST8w7akvU22GneIqjHN6Gd+lhP8p79E+Dmy2LoDV0OEwYF4+IFCho0GwfltHN6I6VPDbPMOgSJT10Ku4thJ5q7q24psU6qrWuzBWLmYd51hNAu7aRUnFbdnpzgzHbwJNLYOV++XT1K3lsA+XAAOvfkGqPNAtZMc9z77xvipA4SmaKew1JVTDPiVgK11c+lyygmAdS6RtAAIa7JfHWOCGNWBgPn59929Or1F3h8h0lc9lnTVzpmGt37lUXC6HN3IgEjYDuXX488pfyEnzlc2k1cOY2RsGb3Wh1j/2xxjmRGyIAR+Df36pxuf6Azb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 64tfhUfbdqs3Bu2zvi0v63Kk3DkGy6ea11/3wc8FT/KfxWr6eYrf0R2H5nFmsZ1ZuiB8cL4sAjGmyY233ol38vR/KhBSCuS3FNpvuWy8FWAaICklVydsdJSkOk383jbRQ7x5qFCC489JHw0O6LJJdndFHXEWtDgtKiNVGuG9X2Axd/8s2Pt+qb24SY5V5W677UUDRJ61Yp2LBVrqqwnCkyOe9YFET0/CE38RkVb4tRua9YX24FHoSali1IKVxrLSupbCO1LFfx4IBLgAktNnToGnQjtB2lKUgJzgk5jEh7S/1U4TuiF1eCpPpeQaCSusiEHWKl1oe72WJYRU6N/VdT8/+ciSPpvkULA/GIcG/TVFH9sQoe3UeYaKtQ4eCzixwiOl0Ra89ZgWQD00FFhdckoq/dpaXOJM2uyzCgr838zA1OoIUqBmTQ/oGKb5KtkzbFZCk8cr0lkmaKH9h/r6sTMnm7yY3pglAuFOLUS/6OfWse0hJziUW25E0Qi9sHdxL55XaNNPogj+R7hhQx/vw4pzmd+El979uUF5VHef8x5PsyAHUPYBztBJANOu+9b05u7Miu7KkZNpFxBG0vgiBLTCD0+/s4hdl1iPTbk2x7iVSjsxAjIgKhcpHJYYaNTm+3XwT3cJ8duo7xgw02kEgg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b259a83e-3a1a-4b12-0fd8-08d849f43556
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:09.0414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyomhryTBUOxBvOoOd6/JlXvpCoLN7y5b2AAigOdR1M/dm8TG2eU9G2YeTqVQJX9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_dr to generic intercepts in vmcb_control_area. Use
the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
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


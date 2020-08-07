Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673FF23E54C
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHGAqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:46:48 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:39648
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgHGAqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXLTVLHun390HTRNtYIERD40OinVhm7QXeXKwaCcak+nsSI0XYGak0Jjn/egM+6SGf/Pv5tHxJFMFPqnH4oZIK4L/JGR3fcJKixLwF/r2vTna9eHKJL8aX1Jn5WV4JDeCwOSAr3LuXu87UfmCX1I2LqEUS+fys45Lzp1PpM8+HB7EFPIvODEXSjVMc+tVKBiznza7OwvObPp/6UGWy3pn7Tupe2z9S08CGaz/37pmI7VyOQrPxFZQsewO9K0bJm/LqaR44CVQklBjoTNUlY0k/O86NjPLVHf3KpqKdQoBdDMb4ijK+yBZQISGJloVh7Pq/egzDXg+RQmUKL99s5+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0yTwZNd26VQ1TVLHsYQBlG2BWZkf51oWo+ZYW4hiN4=;
 b=VjA17nkJMcD7+P+Bi4oQOAa61ALnezaCWTo+iq9jaelaclMb4kmxbaSHnaGL+dsqPoHNxhaAQ0B4AVkWOTX+Jic82Ui6X05Tf10uHmwxZq+53AVG8ZnOHZppPJdnYQGI39Zz6jvH3Ync5BlN5uoLFZ3+rqQyJfXvEf68vLw3CA488JgXcD3Lj8z+ghHA4eNYpZpEmNBuxD+2hXCd2pxnUDxNx6S44b8GAqe7p2RMJSZ0IUXBPBy1bBGWiLE30Lkn3ZkH3I1JIDk3XvvCrbXO0qDO8iuFcUma1l2NYWXU/tYYX3oD/UUCvoH1cxJy+sbZ9StOE7SGhEfEJMf5Fo3rlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0yTwZNd26VQ1TVLHsYQBlG2BWZkf51oWo+ZYW4hiN4=;
 b=KTeJ/GzVfj94oAqRsmGQCo5Gd0Ccg0cwsiQW6Lfs9M+Z59IAsxuHw03QhEw0gXT3acASolXnm4+Y2uzHJJF3B/9oH/FXGRYueZLRLHdlylKgHwSAjehLAEdys3cgfmmvQ5vA4NUhUTyOdfIkocYS5gVcJTioTEx9hV/FpF7IN+I=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:43 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:43 +0000
Subject: [PATCH v4 03/12] KVM: SVM: Change intercept_dr to generic intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:42 -0500
Message-ID: <159676120207.12805.9462937617728281607.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0018.namprd07.prod.outlook.com
 (2603:10b6:803:28::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0701CA0018.namprd07.prod.outlook.com (2603:10b6:803:28::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 00:46:42 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21ad7bdf-ccec-4eac-e481-08d83a6b5abb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479032F3266CC3128D456CF95490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rN2Z8mdXdONwkIQbvE9570HAmddUBh8O1BIOJ/OD6O4MXJDI4+Nbq1Rc0YL5CyDMf6jRq4yTYFkyj2ybU3+lbK3DDxpqO15n/y4zZc8s7x4nmBk+pCjhgVNA9mgOB53nYygTcyETd3EyFLOCkmXoe6HNLezsw6iYQ+JIxuZwsOOxtPb6oNz62eFSNoF1ShitFdu93gE/k3O4rT00SUpSM4dt3A6/MQm5f6u/gHST0LiwxZq5ZPyGD1F9FsDlE5sumnWIGlmWuw3NR+2b9tpEsr6epjoXGcFlsJgtCFS6Rq8cSsy78gj11+g4pQg8gQsjehtc7qTaknWxO6lj3/L/IFIFA526HSwFsMh7fMXfGv7jEil9hr9l+mK2N8IIQwyA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YS0K8FH4ERu3l0DY+1Fcd7G7s+EGbIDwl4Uj0oBp0JwsxFREPqwDYzw6ICuKme2mQTLD08pMLIK6PURb38SCyEigIp0qTq+zrzuvk3FSPEsI00AnKSk/5QhduXjwwJmtMdLSRzALlviNekiZIk/qwoZvVGAKDfjR7UpJSmRh8/39EhAOHqB0LpLstJcgtEwR8f6FGohOUFAfGKT2DN9WXss8KGYQVTJB5rTPLeuBAwHqGueBy147OoQfFMmV1fUOAG3YBO5PwmZ6ZmA9aU79M4meWfLcz0ekyn33ShaOGtB1IJ4YX550dbuNbnKbJn+fZR+Kx5p/XBFQM4t99C7D862x1ZAEemHxKFRYqJZ7LhrpxUCnx52NYAwyIog+noApwPmo0lWb5VfL9v/L5uBHdv//G0+L6rRyErecufS35uLct5g3+/+z31xYdf6TEMmvvAPwm3TW3dipqNmoR4K5z2/7iWtykNhqU5q82S/dkbY6ZbcvMWmL4D7sLQTVum8xkP61f0nJYZW3n1cguIsB+/VxiK3u/X9xGzQ5sk3O74eTVGy/Gs6csGdAXKk4FtZZli52COCcPhYoPfxAk5Nk80RjlKxJZAPlDaoUTHaAV/xa1ALPavBo9mbBk5J9tKox0pOmlmKFCvm54MXwEPrp3Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ad7bdf-ccec-4eac-e481-08d83a6b5abb
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:43.2579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8RoLnzkVKY75bk3w83a9Bk7dynttNSQ0B74QM6VnjuyJ60qt6Sdd9KWHj+bBuSQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index 4f7faca0d0b4..14165689bd8d 100644
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
+		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
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
index 6d314cee5496..24138874e8d0 100644
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
@@ -285,7 +285,7 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = 0;
+	vmcb->control.intercepts[DR_VECTOR] = 0;
 
 	recalc_intercepts(svm);
 }


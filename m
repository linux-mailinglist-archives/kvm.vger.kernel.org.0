Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351FD23164F
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgG1Xid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:33 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:42944
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730282AbgG1Xib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0F0qK4MXTrk2n5LFVTVi7eXgAM2+rS7ootOVEAeG9mtBlVgeBpMq3U5zKJl3HLDYmk/fhLJwyMuT9Ny6e3M259lIOrVbtAflrK9undQqovESYC2rS40EKVCgUyFXHyCuNT2a/OlKA2skA3TnjzqID98x72GP7roORB9DZ6ZOhA6nGVs1szsNZro+3+fKlvfxdL86JY6ALDhG69FVlOiR05aTC4RZGTFm6NvnGkY7v/DvIR1/uBJB4J/Xeulo9NV4N8rXFGU0LbrhHQg0PBGDMEwk2SrEbD8W9jWqeAzTgoA/zZaYj0UNPt7miffgFATMKDxdb6pjjlvhSMKOazJKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi62rILaWEuAOBwppvMTee2rVhGUjSHrpiqACH33Zpo=;
 b=mLXRz5aFBiI6+Y5vgfLtjLDqconO6k+t3TZr2/8NDEzScHjrxBfPsBosIlnuxHzEuY8rS8ZjDU5La83tf0yKmB3WcOmeIHQ2hFPAM0K4yKD1ieKFJBTu6o00ZYgPeyPS3HP75m8iO1yo1HdE5Kx+rforsyCbA2eEhvGUeSQtKclYr+e6uLB0BtktNlmdx+lxpA4XS3cOeOtA1sD7pflp9V70zRWsy1mZ0aieUUegbZ1q6RON6Lo8gTBzNLN0eFzQolQUMbVj114j0QfaDlTgv5YOTGqfDpCEYh4r9gdW43DvmaKOtOXYAaU//oVO2lu60W5LmlqntRbbzJekENQkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi62rILaWEuAOBwppvMTee2rVhGUjSHrpiqACH33Zpo=;
 b=VV4nb22DoUr6QRlnUQxW4bb4gpVwzmn95+Tmo7NLISd2i/hhC//RTDM0Je0sIN3SvgK3WfAKdz167fOulHpFSee5bavgY+gNJbarzssuStuJPthwdPn97NsTBCUKv9g9qaw/HkGVpxAVvLph7ub1J9mokqX00hGDOQkZa0kMXVo=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:28 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:28 +0000
Subject: [PATCH v3 06/11] KVM: SVM: Add new intercept vector in
 vmcb_control_area
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:26 -0500
Message-ID: <159597950612.12744.7213388116029286561.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0039.namprd02.prod.outlook.com
 (2603:10b6:803:2e::25) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0201CA0039.namprd02.prod.outlook.com (2603:10b6:803:2e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 23:38:27 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0ef879e-9e05-4c8b-b1fe-08d8334f5442
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559F79F1EA9D66CDE530C4395730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uhtohiv4sjCdCAejCHEIbUL7kV9CCtxD2AWAofApY3YxDipsAAGk14yDUo8+Ap83T56KLPIS36i3v8Q7Pw1I8FYjuV+QHr51wZkSCyrZLyx/GI/e3IUo5FN2SkCk22DPBHd+wJz2/0gpLogYTrJrWpDOBKuPz+bByPuFOpJQluvlOIVSXwICYP1G65B1n/BK6FJYV715fGjsZvQURFePqTN2RSQyVSbYGRdoaeTfpB8IdMwmkrn+1ThZdLQeMZHg5EhCVOFXlwjQLNGrm8NW8SukiNyB5ZCIOkaY8FLyRmOFBbr80HpSeSnoALONMwQFpZe98XgZ0dFywUaPPIrLIxL28SvSwVpm9dgCFRJ4ohwj6q0y+BOaimuG+HUgrm2uXfGxLI6/zcOKjWXhdD5jrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(966005)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FnO3ooG868cPb2NvMjZ7WU0xEbj32sgAOfXaDuviv4bduMT6IcP1UiiAImKQ6ScSfZGTgCiu7vkMzdAv4ckTd2qN9MtHW9rLDBrUvm24BICRo1dcwlHEveeSJrclR9FvOHv6fK7BjNH4MNhiGGQCbQr9b0SWAhcKSVO5Acilxw+xMBV3LUc0qNELB05rq7k6caDBfg4biDUgPKN3iHKcD5NKvBZN7E/wxYbjCnGIshx6h55p3DgcfJ6KwXjOpIPAGhwvZwCURmVs3GuutJvsVxntY4UsfXZSDAEdLHr0Wb/ymgiFckEnimVa8Lg3LpaIoYMccoTQoO4qfE2wrIf85GeuWwIJWxJP0Tdt/e0qEB1MYdd/ltQcdoBdvijXc3uf/IIDGzCtBuYacr1QXppBRJoMHriiqJjKUktfjSptxU90HUqqUKJqvGuq4JzzCjxSvuAQ8bs2kTySr8GsRigO3B3eflf1bYVB/5TJ7y1Mbb7EStqCrAkGrAo5YjCVoUp1OT7wiedpRpk7KVLOflzN0N0O2tp0Jp2YMjOf//0SICBPP6h0D3ax4NMwnO3MKL0jtVWXyeq3wUh+Z4HOMPHzNPcl3VVFl1w8jSNbW8y14g+SeuDKtbiE/UTFbKOGIPtKQQliDoQ0FpUXfoemIWJ48w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ef879e-9e05-4c8b-b1fe-08d8334f5442
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:28.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnd3ld+D1M9l+jzYs2Ny7GDLaCXqXtCVv2Lmvgwp/1gvyVFQjxdLj0hyzcimprPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new intercept bits have been added in vmcb control area to support
few more interceptions. Here are the some of them.
 - INTERCEPT_INVLPGB,
 - INTERCEPT_INVLPGB_ILLEGAL,
 - INTERCEPT_INVPCID,
 - INTERCEPT_MCOMMIT,
 - INTERCEPT_TLBSYNC,

Add new intercept vector in vmcb_control_area to support these instructions.
Also update kvm_nested_vmrun trace function to support the new addition.

AMD documentation for these instructions is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming, Pub. 24593
Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |    7 +++++++
 arch/x86/kvm/svm/nested.c  |    3 ++-
 arch/x86/kvm/trace.h       |   13 ++++++++-----
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index aa9f1d62db29..75cbcfb81332 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -16,6 +16,7 @@ enum vector_offset {
 	EXCEPTION_VECTOR,
 	INTERCEPT_VECTOR_3,
 	INTERCEPT_VECTOR_4,
+	INTERCEPT_VECTOR_5,
 	MAX_VECTORS,
 };
 
@@ -124,6 +125,12 @@ enum {
 	INTERCEPT_MWAIT_COND,
 	INTERCEPT_XSETBV,
 	INTERCEPT_RDPRU,
+	/* Byte offset 014h (Vector 5) */
+	INTERCEPT_INVLPGB = 160,
+	INTERCEPT_INVLPGB_ILLEGAL,
+	INTERCEPT_INVPCID,
+	INTERCEPT_MCOMMIT,
+	INTERCEPT_TLBSYNC,
 };
 
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d2552de42fb1..b0e47f474bb6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -432,7 +432,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
 				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
 				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_3],
-				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_4]);
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_4],
+				    nested_vmcb->control.intercepts[INTERCEPT_VECTOR_5]);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6e7262229e6a..11046171b5d9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -544,9 +544,10 @@ TRACE_EVENT(kvm_nested_vmrun,
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
-	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u32 intercept1,
-		     __u32 intercept2),
-	    TP_ARGS(cr_read, cr_write, exceptions, intercept1, intercept2),
+	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions,
+		     __u32 intercept1, __u32 intercept2, __u32 intercept3),
+	    TP_ARGS(cr_read, cr_write, exceptions, intercept1,
+		    intercept2, intercept3),
 
 	TP_STRUCT__entry(
 		__field(	__u16,		cr_read		)
@@ -554,6 +555,7 @@ TRACE_EVENT(kvm_nested_intercepts,
 		__field(	__u32,		exceptions	)
 		__field(	__u32,		intercept1	)
 		__field(	__u32,		intercept2	)
+		__field(	__u32,		intercept3	)
 	),
 
 	TP_fast_assign(
@@ -562,12 +564,13 @@ TRACE_EVENT(kvm_nested_intercepts,
 		__entry->exceptions	= exceptions;
 		__entry->intercept1	= intercept1;
 		__entry->intercept2	= intercept2;
+		__entry->intercept3	= intercept3;
 	),
 
 	TP_printk("cr_read: %04x cr_write: %04x excp: %08x "
-		  "intercept1: %08x intercept2: %08x",
+		  "intercept1: %08x intercept2: %08x  intercept3: %08x",
 		  __entry->cr_read, __entry->cr_write, __entry->exceptions,
-		  __entry->intercept1, __entry->intercept2)
+		  __entry->intercept1, __entry->intercept2, __entry->intercept3)
 );
 /*
  * Tracepoint for #VMEXIT while nested


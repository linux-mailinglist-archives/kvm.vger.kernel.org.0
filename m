Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24C11FC152
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgFPWDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:03:52 -0400
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:29120
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbgFPWDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:03:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQZGQw1+i+2QmeUOi3VeDbhFcPROhlXDlkpTRCh8cynG71Cc29xvT3EQkJosP/KvkrNjJ3nAVikcNDMRWsWhZdDZ5AeAOZIxSpCjkFNXe2+p+tvPCcjn6bBsR6AgJGyi4pU8X1XoANBWHQ6s3q3dRiYZi5L1cOYQqTaN30175M3Oiw6Ehtx3H8Wp2n6XuuuIIKBnFXgSgQBzx4vL9QkYMwLPvNwak1gOZKFwr+oTklgamRACYEiI1o0EqU/uCelffUP3DI5ludGqeHq6YDTMdoWX4g2yIIT2wr5uQ6K6VuXIU2/IG2YPCgCi3+liSTPcrVdFoXxKXsSFd0AKdSH1pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCbFx1uj/us6VMaPGyeUXTCIk1Md1eRoxx9Pkn6b2s=;
 b=G+qgGW1iuRGuyQs/ofckXpbjgo4DtpezyxSFA+bwk6pNW6ZxbouJeVaklghbr1thHbVx3IkZrVAMTvZXbVsrksO9JgEMc4ruQgdi5W1SZEDMvsEgdOQ92BRT7vTECxuGjNMZwxhx6zVZBtqMetC1MIxfY5JpZEij9ndEMTF+Eq5FVCTn4rm5pi5I8cEfCqcwUAt0Fe3ctwwoouuetD8O/HH1z+9iOgvEAyqnvx5Evzz8mu4eYZMrISHDp3l0OeEbHYAtZafJtsYMC5/5Xn9XjRAv9qCIBke+vkTJo+dSOkVzx0NMYWo+/eCfddQJnKfvdOqtFqooqYj5Xow7bDD3Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCbFx1uj/us6VMaPGyeUXTCIk1Md1eRoxx9Pkn6b2s=;
 b=s/NuqB+tCZmklBJwQyfqIFHJx+3MJBTZSnM45AnZylFYtMVI5W8Iw8KPRtFFKS93+ElO5NhoNRg/4oiUFmMygVcT23E1o6GOuCWqBlyBj+jcQooMrzWFJXT+jmQzBehavtFzCyUMmoK9hdiM3aXGCqkxJPdT1j/ApE8ELeLH5jM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 22:03:46 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 22:03:46 +0000
Subject: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 16 Jun 2020 17:03:43 -0500
Message-ID: <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
In-Reply-To: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR18CA0092.namprd18.prod.outlook.com (2603:10b6:3:3::30)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR18CA0092.namprd18.prod.outlook.com (2603:10b6:3:3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 16 Jun 2020 22:03:44 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b7975fd-1a4e-4de1-1dd2-08d8124123f0
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB262201455604C52F541644B2959D0@SN6PR12MB2622.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04362AC73B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIaZbOXue1Gcp0CGUzNlzcB/WvM3tqNqKZtiFSfRvlFwqCo08W08efsACostdB0CBDN7nGA6pQWqFQLJAQH7LxpvmXIxXuQieH17R2ae6ie6KCRTQEcSwkpaJA16QP+35zpO7Fv0INI9xQeVcfi2Fs02r1THiNeKoqKS5JVTjPeOr5ahp08FaGT7OXx8vV0V6/1X/3ifxychvEk0GKrbCnXPQ881f+sf8PGAMxmUSgOtL6IEMEI9b5YmFhpPZCp3BrelQpTyoWTd64yU3XQtOy04bIEi/ZnPSPXUdYrw9DirH5dG7fgdfQChyo3CtvRBtC1vlWkpk42fus5oIquyVPC1pRHVPRdcWbNsI+Wit9+C4HwoUNAxFd/cnWHe1XFzOu2Sc8RNannCzMrkbI3NaiTu4XAYUidlI5iGFhQ8tlpGG85QIS0xpsawZTV0IQP6U3b36XSM2aldkfxGUYz2oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(7416002)(8676002)(83380400001)(478600001)(5660300002)(16576012)(966005)(8936002)(186003)(4326008)(103116003)(16526019)(2906002)(316002)(26005)(66476007)(66946007)(66556008)(956004)(33716001)(6486002)(9686003)(44832011)(52116002)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 033vGGlvudT4Z1kVY1ajuYakNTn2Qgdb9o6HXkIhZGz4prREk4Y5RM3K0FQoUpJxnQJzvX7fPwjxltXeSwkBRbU65BLqpmKu10S1u3hCWrF9m4cfLRMCX2nvqrR72IAblKjiW2kiPOuBsiXfD/0ij3qlJgNMK7Pna27qU2ENeNalnvbqr5QXtavEEN5QAdZFalAOu95vjE1Bnjs01bXLZOzz60/rK5/bt8Y3vwZtqQE3V7+9ahXS6QgMRgK1F8MrHDQREo3qPt6K5kHE9M8W8FDf8l0BYptZMLerPGQrcUk79oRV5VN0EuI+bTA+przCx7Zvz/jxHZJuNRfQIDD1NXJwXvtZfs5z13JQTIr87/T8jgNZ/OwqJtIxE2rmil07sTmKltCZlF2WmZ6Yygy8VbNMD5vT/VbJhVYzzN8moawlqmQTycrWJ7hN55jQ12MNWhFhUem2JD48KrOCZq1oAW92T4NL1ile3XV7EQ5itjs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7975fd-1a4e-4de1-1dd2-08d8124123f0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2020 22:03:45.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LVqI2U3NbPHiLD1Yj1tkiv9U0eJzcKW9XE540ziENhS+/fFu50aG+G9yHzblKsZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new intercept bits have been added in vmcb control
area to support the interception of INVPCID instruction.

The following bit is added to the VMCB layout control area
to control intercept of INVPCID:

Byte Offset     Bit(s)          Function
14h             2               intercept INVPCID

Add the interfaces to support these extended interception.
Also update the tracing for extended intercepts.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |    3 ++-
 arch/x86/kvm/svm/nested.c  |    6 +++++-
 arch/x86/kvm/svm/svm.c     |    1 +
 arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
 arch/x86/kvm/trace.h       |   12 ++++++++----
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 8a1f5382a4ea..62649fba8908 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -61,7 +61,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
-	u8 reserved_1[40];
+	u32 intercept_extended;
+	u8 reserved_1[36];
 	u16 pause_filter_thresh;
 	u16 pause_filter_count;
 	u64 iopm_base_pa;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8a6db11dcb43..7f6d0f2533e2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_dr = h->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
+	c->intercept_extended = h->intercept_extended;
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
@@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_dr |= g->intercept_dr;
 	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
+	c->intercept_extended |= g->intercept_extended;
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
@@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
+	dst->intercept_extended   = from->intercept_extended;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
@@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
 				    nested_vmcb->control.intercept_cr >> 16,
 				    nested_vmcb->control.intercept_exceptions,
-				    nested_vmcb->control.intercept);
+				    nested_vmcb->control.intercept,
+				    nested_vmcb->control.intercept_extended);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e333b91ff78..285e5e1ff518 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
 	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
 	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
+	pr_err("%-20s%08x\n", "intercepts (extended):", control->intercept_extended);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
 	       control->pause_filter_thresh);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..935d08fac03d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_extended |= (1U << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_extended &= ~(1U << bit);
+
+	recalc_intercepts(svm);
+}
+
 static inline bool is_intercept(struct vcpu_svm *svm, int bit)
 {
 	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2..5c841c42b33d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
-	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept),
-	    TP_ARGS(cr_read, cr_write, exceptions, intercept),
+	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept,
+		     __u32 extended),
+	    TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
 
 	TP_STRUCT__entry(
 		__field(	__u16,		cr_read		)
 		__field(	__u16,		cr_write	)
 		__field(	__u32,		exceptions	)
 		__field(	__u64,		intercept	)
+		__field(	__u32,		extended	)
 	),
 
 	TP_fast_assign(
@@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
 		__entry->cr_write	= cr_write;
 		__entry->exceptions	= exceptions;
 		__entry->intercept	= intercept;
+		__entry->extended	= extended;
 	),
 
-	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
+	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx"
+		  "intercept (extended): %08x",
 		__entry->cr_read, __entry->cr_write, __entry->exceptions,
-		__entry->intercept)
+		__entry->intercept, __entry->extended)
 );
 /*
  * Tracepoint for #VMEXIT while nested


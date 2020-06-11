Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B771F6F91
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 23:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFKVst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 17:48:49 -0400
Received: from mail-eopbgr690058.outbound.protection.outlook.com ([40.107.69.58]:29215
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgFKVss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 17:48:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVQ2XC0t+LlV6iK5rTTCzMRVBDGOxvcJBEXZy+Xlt23LQCvYdXRpLqZeN4S8zwBVeoXFaPAAelzjwReUTncpqPwveSqNTEzGuzTIU5LXnfOwyyG940LnSLxWD43cjYG0jgP9zBpMQ0TlwJh6ogZd2ltWHq/oBUYnCM13CsFSuS61hc6Gjk5tJ3lzuZ4O3qoRvQidQpJmhR/CKx+J05NCPTDnN4ochJJyHX3KoNgLy1Z6qVghbl1Tsux0+QBm47dHHsZfp6wWdc8WmGipu3FDf0AI4bjm9XrbOkKasCu5oHqj43JjEnuz1nTQx+s8x30ZG9mFRzEsnsmQryyYyck6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCbFx1uj/us6VMaPGyeUXTCIk1Md1eRoxx9Pkn6b2s=;
 b=kcqRMKtWl9MpFglPojv4gmpsgKtHMsPBMWBuIl6REC7PiFsrP6e0xOAkBE8acWUPoBKlpbIdWUXSJQKq9/yLvIfYpDhMc2wQzHGrONIt/Gto3ScjmzDy+AWLez8bK4ZLXrNuP28TsZeng2djo/hWVxRqCu5Dk953lZODlLGaQzFo8pMUGawKA6/JbEbKjUvXhSo0NEOiojHZU0kMeWyobxgeiqUrtPqFdRLI2YNw3zG4TzBPTe8xSsSSl8qR3hUj0mzl+HDZictUP+MTwhJCBoxgfZ6nw84b+XQcVfK4yWNTa1lumu/rs1sQtrGk3eCgeEwxb2zZPN121vVLXavWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCbFx1uj/us6VMaPGyeUXTCIk1Md1eRoxx9Pkn6b2s=;
 b=kN55s5OBMzyjlXAQzoLhYbSt8KJ7Ubv9vWpPHAPW023x5wqP+iaYYucBgAI7lNGuCOfbjlK5r8mvysEsNFLFS57CqawVuuE3EuSrH9LOine3qKDIcxWTc6pqAesiv6uIIF7+vRW42jBYxvaqiWGpmz0a2Pv6kwB7mJdmEHhXeWE=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:48:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:48:45 +0000
Subject: [PATCH 2/3] KVM:SVM: Add extended intercept support
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 11 Jun 2020 16:48:43 -0500
Message-ID: <159191212308.31436.11785815366008795008.stgit@bmoger-ubuntu>
In-Reply-To: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR11CA0002.namprd11.prod.outlook.com (2603:10b6:3:115::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Thu, 11 Jun 2020 21:48:43 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a9d8c9a-2d21-4d16-697f-08d80e5136de
X-MS-TrafficTypeDiagnostic: SA0PR12MB4589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4589EE3381EA90D9F2C5395695800@SA0PR12MB4589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qyJ8RHF5ULvHmubg7PEby6aZii7cXK02E5xHJZp4o09Xrkhw2Wi2SBGLdKE45rUabgvZyJv9LY2iEzbbmP/LiGjgBNypJWHZ0UHmtuxIG7hj/9UPyDTBqsI/IMOfqZQI3sQdkgxNrZO0fIhYC3BflF3qtdgmG8AzL4lDXFErkZ7KnzPf+SFjOH6C/8iTv2SBc2DJWTFQv5a4SYxwdmqckgY6LL1oksBZoKUfkvXPoj6pCVV4DHOXoCFXpKtI5DTDGhpU+EFBIr8wkH7fVwl8yo4p80XGB3jtBfQCOskIU5UvD9aPW5gJG7hSFcfLKe6GFW43V799bNQqH6NcYEP6XlgRwdoZnR3P4nOMJrw6ynk4RnnTMjDrDeMGX5TPzmP/e4bM2lXLLzVQ1N8VfMdj9UTu3xTmFQ/lsJ/rmrP4rHzfJhYZIL+zVXK/X+2f5OtvCkTrkAj60ENU5pOFn1Ww1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(52116002)(33716001)(6486002)(16576012)(8936002)(2906002)(8676002)(16526019)(9686003)(7416002)(186003)(4326008)(316002)(478600001)(966005)(103116003)(44832011)(956004)(5660300002)(83380400001)(26005)(66476007)(66556008)(66946007)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mmVpxNVtYqjMkaytq4AbxwL8VHX7zFfANIaAyZ4h0VfXrWL3Ker32hVl+Y9TVZLog2xa4OsaPSUiLy9rob59IktjMq6IflPvsdB23rR0rtg147WE5TlKij/jXAEON5TDmlVMpQQu2yEdJVd1REEErXuklrj+AOJBynvdfXA50Hl6cwuFk75u7j0KxJjXVZoQyPFfeXNI6BJApO43vsKwotZavzfGDg2jXFdUoLuki+Uh/E2p6jClp6Tpjrgxn9/HBZ6KujaXTfKFy/bZL7u+DEeFhuReBCJwqMWMtMENBeH5okD3wxX6Yppo6wbvGr038E/7ru0qxC9hwf+maDKhg8h3/8nk060Qn0hf77+9gadcw6bt+usfW92/eRspZWIsW7/0AVWF8fdmWRDTxerfAzutLlA7Ppqi90vOb3ahXRXWWwTKFba50gleAFTbCU+6fk/mVdCz66GzD+LK0vHJh6boqx1hG19MzIVL3Hj4VYc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9d8c9a-2d21-4d16-697f-08d80e5136de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 21:48:44.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8klLjHOgqP+n+hWAZL1+6kNDV764o+bDRha577j4G5zPALIdeqbQSNAIYyesylT2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589
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


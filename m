Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05A8253805
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHZTOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:43 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:11707
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727907AbgHZTOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UT0Jwi3sOfOJAbK+LIsvQEu4k2awNVIYLBJLNtog6RYtTabrSgp3WzC+uHOKoHj3UryyDMC+c935zeBnD1FqSlYV2JFKQsV9M2hZMOCqsFqrN5DGkipbe69VGwxYdqw6Me1ChOnKFcteyg7JC66bTtNSBaMjBudiaBvzLfDNQ61j2JZHC1majHO/ZjpPIITmD6yNJL8JLDLaVn0r8Sidu3GUr4p7xHop1DEQfICWzsQzbVKafZDWsLG3sJBG2RTMhz2LylYuoqD4HxCKIQ5gB49J1pwHEO+B1Fi+Ecj4UzH2s/Cow89yqSDkdgL6XKC23Fs2AudZv4MOBbVPPYUqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAJ3gLkCEa1T8AveMIsuX7jH78jUznLkEZ+oqhm5kPI=;
 b=TqBMGjTaFKgrAPE2qGMl1BKgxKzCPxpBYrfxowdwjdCkzNOfS0zjhNGNtn4ewRgtIx4NFxXvfLmUH09YWy64tFZDjiCYt06JGesQvA27E4c2N4GZEogXbUdHEO1zkiisPFiDHqStQzBYiPB60XjP0kCPa7CyLjDC3plNCi7X60nGPWGP9Ck/o33w4RBKONvaRt6BTWMxWAO/3O8nWOt6pR6oJE8BC6lPkABSfJFzb0aGL4GyMI6CIMjpi5fUs60cMlxlf4aT2uD6KGsyFxHwmrYgjdnQ1lyHHbnWkOu4RKNJ6t3mfPVTIscGRFBs4xYESLeFSEY9HhxmcCtIGYd5uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAJ3gLkCEa1T8AveMIsuX7jH78jUznLkEZ+oqhm5kPI=;
 b=hD9KPKlax10DWg9qhRkrwQjwTkxzWvg/ROgjMnms5oHPv2PqfTngXQT7fePdcoDbifLr8WjZ2b8MGVk3I4+CQMM3KgjeJUyxWiHATo1ecUFd/q9PzQLIsaGNr4PIyBGNztA8JDb/ce29adC/mwzBb9oDum2BdZpqeHiB82EmXYE=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:32 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:32 +0000
Subject: [PATCH v5 06/12] KVM: SVM: Add new intercept vector in
 vmcb_control_area
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:30 -0500
Message-ID: <159846927031.18873.4812578770870007547.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:0:50::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM3PR03CA0021.namprd03.prod.outlook.com (2603:10b6:0:50::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:31 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 430d451c-4ae0-4cbd-8bd8-08d849f44358
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB246112D8E81C47689BE5B3EE95540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OAPVk4TA0seU+Z6MbsbJsLJIPMU6YakfKjSb6HxSf8XTXLeTgF8z3kvB+7jiRbXkn47AG61nJOOnPitOcE5d+YoHJfdYXdftQgHJZgMvOoM0s9TsOM16rrMswEReQmWKToCEAAVgkplps4fJfiYlXWov0+aJdGjd+NOBadvjpvz98Kdzrn3dUU2pH6PO/1YjIBhX1e39djSNc+8hgJnjrUmqW1wY4riB4QOMm+bVupW1JFXBcEsQHCG2PV93xIxLDuRMVmx2910ufDYLAUmHH6qXqlB4VUcMQKMRUNhyxIPFzTGP4npnCUGaaWQ5ffPTO+RgvNvVJtIHcOe/jppSU4aO9K4IuTyyJqfFudZ3uDSTas9gE1GMlJMl4DYZbnq0uFitBxcNAs2dDZsHriwhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(966005)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bIqtvppJ0msJgOgu4XhHKfpomWbWrziisq0l5xtYMXNJ9mSAcq3IixDKE+0Y0kPr7SAcDpUx9vj4E8Y5C3Oev7jX2ZgR76JpvPoMtSnqwTmLVyECKvXKelDtOLepF4GxHR0/Suf5cWhm/qr6xrd0+jWUwmuEaCb/hJ7TqovAu3Jal6qWeBOpqzUHKNW+zRa6sTlJYoBtr0aA7KISkN6tFFRrRg18ntveNjl7qsjU3YY2ORgrnHwzg7tFVIWEXZatCz+DFtfUXEEg+Wa8Af7n2M9NTJjWVV3CIPTOPB2XlYkYcxt1w/Rb832I6XHcZnzqSV0iyefU8WyeiHkXYbjbRhaRdzLyPOQP+0DUZUYEPa26joZnzrMUA2tg4d8KjUiJUuZC6Q7N43Dn/0NOW5IeDhbOs6n2h4UdhDTcnOTh9n2mqwyjjBzgeNMh1k+HEOYNYrE/Fvwvkg7r+4WqEnV+MIJJ5MqO/8/xLST9ZrC6bEdUKOsskHE2JRw6G/IP2FdedAs4KRF12X0s7H5MkDIjk3vJBSIsN8RLVXLUs2i+I5iYbqFIUShGGj5AlZYooB3fWJQ2d63drcPqEgnH4UJ3KwgSQzSpdw4TfDa9p6/RQMnJYOS46tlAyKxF/G/qScVXvp+cSMr5nQfmXcN8Hf19vA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430d451c-4ae0-4cbd-8bd8-08d849f44358
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:32.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6m3FbkXHwc3jpwwEzATLiABJ6hvvJWQeMy9viNCkMWOT551JBqif2xWn4jNh7xb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
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
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/svm.h |    7 +++++++
 arch/x86/kvm/svm/nested.c  |    3 ++-
 arch/x86/kvm/trace.h       |   13 ++++++++-----
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9f0fa02fc838..623c392a55ac 100644
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
index 772e6d8e6459..a04c9909386a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -489,7 +489,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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


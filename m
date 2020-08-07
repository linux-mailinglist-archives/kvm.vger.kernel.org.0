Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C0423E552
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgHGArG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:06 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:26337
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgHGArF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5aqcOXrTaifaAvFy6uwcY1WXOdn3bx2BrCk0nxlWqPCOOdc2o9lqSiDP4DvdoLmFxcgESq75Zpy1SCSYT9jm2dRdF7Q6y37ycwO1E+T0uxAJIKeDZ7OSODoBg1UckP8lrp0c2O1qhdckktjAALd1pJVczWDmKTQowpc0Ys0t/P41iyjwAs55/RN2+Syd1M/DEOpuWLD1R/vuc3cbj4c3bVbSJQWBWOXDkeMAsoFgyOnK/Pa7AFMV6rdNfedqQPvNSqKX1z4JHmZm4pRhSwourr6bdT3DkAyKv/7K2Yv1tiyfoZw5vbzcP15/JDoPzUIh1Ry8mdvSUClkD2i2aqO5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snlA7AjhiwpY0bRQHsigms3px53kQiNRgM0dGvVeQHU=;
 b=JqK2G4p+fHEL5Lfn1SYIJl7nNNsOkC+HaNpotf3YSHmAmdSGZHgR38HBXitarissEz4GJQBF5xJSXvw9wf2YJVmgrg47+y8/d/ftufmMwFkwDGRSuiYcLVXJ69R/sFCQC4pxq8MF+CJCxvPS+/IMY7L4HHy8JwqoxTfUVetPvrFRYHE6Et84gQVRTkBVbJCDUlJCPawdlbdSHSiwYMrmYX8vHVFKufOtcwNBQw/9GIloaC+1GV4gzP1qwiBRPQ1/XZrxf4646bKg8Q5HnpTTfPsgnmSyrqquSJh4r/Nz+7yvHi7E/Qe+xh6HaV9X7Hes8mm7WZtttIW91KD2tc6uAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snlA7AjhiwpY0bRQHsigms3px53kQiNRgM0dGvVeQHU=;
 b=tcMCXdkuEZEkYTwdfiMRpzOb4cA2iz3eKz3SL90ilaWuWrsR2dwEkYn3OjV4yP2vo0so6O9OyPW3sQ+JV66e1D8JgMT4Q4sxzvmJprQsT8eXBrqlKf566FiIBQZ59G41ANo4AIqHNHzGW47e5Cq5fLzJqf2K9oehYJ4KNvjaGCA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:02 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:02 +0000
Subject: [PATCH v4 06/12] KVM: SVM: Add new intercept vector in
 vmcb_control_area
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:01 -0500
Message-ID: <159676122109.12805.1137119026568471621.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0054.namprd11.prod.outlook.com
 (2603:10b6:806:d0::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0054.namprd11.prod.outlook.com (2603:10b6:806:d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16 via Frontend Transport; Fri, 7 Aug 2020 00:47:01 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ee70220-ed8d-4770-99c3-08d83a6b6632
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479AA52F1919CC2A683381095490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vp5wyEsKEGQ2RPnuaLmAV90sKd9yq7OurGeKvBFLdLeMW1B8BOPNOHtNeJ+QH4m9Tgkq3YeiKtSRKW0uzu9bO+hp5pTuCfBfLEtUYDAWd3G2MSRazyVQ7ikjtUm0QUbSRNloWqFCpGpuDJwMMhGqA8JZI7LhxC1WBmR7bUZGPvUikEnZCx6jgk/kptVVU2xbIwITQJuhAN+c9LUWkmOhePn+fzgJ8hbGuNwd3eSFj/FA1cShw4k80W9aS+YJ0jP/sOHJ5Bcy+0F9s16HT/SpI1TN3Ld/+OLAm165yNtzm5t1os/pwd3ZtEidFPAd+y0lqOHK0J4N6emN8vdNGVMjVTlxOo8f7HizmlvbS9MyvSmuJhid5Ur6tpb6GcYzJzkpxePu2eRg+yBroI69IOLUIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(966005)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZmgZgKTodl47EQOATtTwdZIoRv56GPjo4z68tu58aoNNg55bJ+jmA5a3I9wpOgvzpMCwfm/Tr1yh5TReCHOH5V1wvkSGHYbq/NMP/5bNvuNTFT7XIKQsU5rCRBZvvZ3SDI+ne2A88zQWoRo5Es0lTHdQ4BRQvoo3FoXqKHsyOhq+pEfNxI1WUD+4cB0qID+1ZhNirASqMar/3vgBtsPCbMhVjz2tx6E0fSXivIhkvE0764p3La1w/gc6m164Qsj5uLp0rzqXp11M8ETxuNM4DG2zHkEEdVoLPSrp53XGspE9259YrAqQQSnP5m+7hTiZAp8Vbys8Lm9ah1YJXiK3pFmKhQWaLOCeSq3gtf0cYzT0cvjxiO2SapD4hq2xs0sktcSYkWDw6bZh/0sxGedSk5lqFjsXWYsdjm4v6FbDC54mroEUGoSunY0pzvR6h8B6GKAJbT3bkXoitho6iqJKEeW+/9IJIUsb+OTqfj3FmsyWtDvF4I+Ws83gPUatcnrsk5T8Howdh1SpOmvKNEz/8rZZbNRyJHUL5rM5lOt6/2lvkwkOKYbCV4TwniuS7KP8DEv61M+gjPhH00F+Cx+3+Ct/SMaL0lxPaADnssEUPeFvNNxb5XCFL2I3Or2l9a3HAp7y0SjAzisD4cx1k3hgYA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee70220-ed8d-4770-99c3-08d83a6b6632
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:02.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBmQikv6itZfzPqHO0F2I5rSQ9zCa9+Y9KF2SJtyXpYfmIS2bFT+kG6gjxRVbi+n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index 2f498641e15f..c0f14432f15d 100644
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


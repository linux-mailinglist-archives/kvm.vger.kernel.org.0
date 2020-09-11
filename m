Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE4C2668CE
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgIKTbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:31:51 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:48352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgIKTbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:31:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW+riekq5FNZ7JmejLmWD9dW/NA8w8u7YTWZ79RNNaIZu0FjF3QSr7YrD46dIi4/fKes0Ni1600QIcM/1jTkUy9iYLNrTpkQcUr9FgUsUU+eIDKHkO5v+8dIvSouyLmjJekepxKHHjr1fGl73e9zgk1FLw2FOd/ht23lu70Hx5D7gVoEk8l7HSN8ztggXHTkoRKG0xGX2m4C0GfXFnk9VYOiPcCCU7rrwLbQcIVuj/q4sJhgj3qW7xpl/FoIi8DHB4Hu9Rfglxocc05JSpFibdzmqACfKoEWGlg6UPbnqaLC4V2kTBEHPUvKcHnRXxZmoKrG3vI8reYYhg8OFRsx3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji8bao6PEXOBRnbVSa/HgJpXSzz+KaVMysJDSmCCHPo=;
 b=BdyhAfTfqWfR0KKg94Hwm2X8qKKzEcvHF/kB7sxqcKSkRBn81I3dg5l8ppBR3xHBPRETY9h8coTDyz2xgiNBHKv7vBtVUXL46CgKS2Mt0+aLsUDC1bMCCSc8I/+8wgys9/VI1EZ1mPuAq6pPIuhC5VCzEJBOy2+aadFnJwMhljqigyx2ugN9s3FiZFknV2Q2tblJ266gHoe9b1XTEtux48oZXBP5vDA37UMxmGnxODe7zdlYbPt0nQLOQMjFtTXaeQwDzCT3NBKPQB3BxbNwseQeOKe2XFWABDs1sQH01s6j8W8Dv6aVpJWOuX8aiNcUkFtS7264yhs7tMhDYYUrzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji8bao6PEXOBRnbVSa/HgJpXSzz+KaVMysJDSmCCHPo=;
 b=uyvpP9MEiev6FWXKZD+QEVNoGE/uniF2ZVZkvLiS0pj/a3mIMZL+su16DUfSnAm0TBZF1A0D8CnwkmKuyknxySAVBH0Z9GfVHogEM9kGSow+Sbr8koaoaKVkFAawW55mm5KlqO2HEn3v2N0U9E+sSDKBpgFMp3mtVl0qlVtWjwY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:37 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:37 +0000
Subject: [PATCH v6 06/12] KVM: SVM: Add new intercept vector in
 vmcb_control_area
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:35 -0500
Message-ID: <159985251547.11252.16994139329949066945.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM6PR21CA0019.namprd21.prod.outlook.com (2603:10b6:5:174::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0 via Frontend Transport; Fri, 11 Sep 2020 19:28:36 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72ddbb70-a117-42e9-532b-08d85688e1a5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454302D1E6E646783012883C95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B96j0Lr7tzGEcgdRfy2bB9dt2wZgIsq72OwJtTrSvNkPTFWijrjyNl1MUvovicwcCNX4QJJ0Nc/whVBZJ5oYpBqpbVUs4ACG6jA6FidVTE21OaG3WmBcIte3uvAV+1D7usivUopKQ4fuZ/OqlNzE5dl2xtegNk7sNht7uahKOjFBa+FtNmgkb9npgYmSSPjK/Nk7soeSz6eCytAk9zOT/fW0EPyHRemGAYl4D9NhhVPp/ISPXEkwcrwiihU7YK5htLd+SPLhTMhjZNfl7TCEGbbOR15G5WpGp81OiPYwzTeA1LHzdHixpPDBBpAd3/KZ3dA2SibP569m1GBu44gw8Rw174XK6p7GM38BBza2PjHrmZDWdl4jYzOBG+x2bt0+KaDbbpRBS7n4QJpM616KqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(966005)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9+7BLEuD9nIzGIuF1xB6E92TnjPINbJfnSsIkH3jSOjtWUDmj8H4vUtz/Sx2eCUsof0chS/JeRm/mftoxf+JZ7hI1lIpEMdHLeY8uXAFf23gIFOi43+d/vYDEcYKj4gM4UNV87zth0EpiliuB8tycRKCA9rcR8Lwe4K8WaAD7Jsj3VlU66eBSmjg+VwN6iFDWl5RYQUJkGDvqYQzUzWwV2hgYUSotUUmyNuZYfJpwKkkEDBotevau3PQgv9UoNEj9+8qY8MjKjbdDSuntCqtvt/jixvnAPFSI9Yj7O1LbcHf7wfZjpPhXSTd6V9bZxfQxokFCg05KLZIemFVwajpIZIZvc7Vl5x8G14oXrpFyZ4QiATMtzaWlmjP1m+VyGb/iu5r69WvfQDOBvL/SkoMCUg/5Oib0h99Pm6IrI6ngG/V9wySX/5OnArakZcNBMeaPpRcrPokp6ubZIUlx7DlqH6S+RYYfoMWS6iWqcgh9Bfy4YCXntUh6JwQnNy5VmNyxuCkeq0KXppImOjjMhqrgXRizbxHg2kMB4fKtf1rfzDy+xVxEUiDaeurSkP6Gy+y9qaxnzvBzpstw1E81/fnu47cdOmXTlQkZWFKVxPenINoKgqs9Q/+W/W7o/pXJFyL/XNVODlC+QQxLmcxjeVGgg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ddbb70-a117-42e9-532b-08d85688e1a5
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:37.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /M9hQPVT97YjCiKV89ODUT7mQ6hBbsyLePb4sNSe/N1uSwGhPZDe8r1uqxaTGXhc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
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
index 353d550a5bb7..c833f6265b59 100644
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


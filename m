Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4F1CE932
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 01:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgEKXd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 19:33:28 -0400
Received: from mail-eopbgr760071.outbound.protection.outlook.com ([40.107.76.71]:28677
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728261AbgEKXdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 19:33:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmpiUN8TOjyVVaQC2/9tucfFiS+aCn5Lf3pL8VPs50N6V9EkXwq8OPTSJSB8SRIWd5GOnZEjdH5iVtJYjJwd6fyfCx8ZqZiRr45zuctFw/RYlalyf18o6BLCuEK3G0eku0pNcut0mpHuhHWIAlJDTtqnJmkLFtEoL1/Sn7YOlp7/yyF3yrnOy8ow/2VALo+LdhgTAPU9YEfxfoZlDpWazx5xZfL/AUPDVY1XqJsFSl4Ha+cIQUGKdIiEOvYDKrlnrKqv9REpZ6FC7XNzl3sKSGKYDN/uX14h7W6TNiCHs41XiDIbemtM3hQpLC5gXuvkePZJp0/F8din4rn+5UCEAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqilRk99qOMYfRRW+I52uP2RhGJQb5USNbXwMyNhXao=;
 b=auSiidjsJM32KiX7QnZ+DCEVl736SZAFGojDc/KiZBccFOVyHCpOLEWWZSQJDlrOeIickLpih6HzfbsnCRzfWj5n78742MxtD2oh+GMdNRtr/8OYFPUv2SSv0QAs9GVbtWSH4LCSwE+Z476Rod93YQcF2128W2NSxSZrfA8q5za4/HiAWstLJLCtVX/NxxYc6NLckVxIpge9YqBktwYbKzrYnR0uodJeFhFBHWytbMl0h6Et96hVwyBOr2qkc+WCsiqK8QJCguuzVI62H14dNgH0rC9gwdioh6SpwxthFEIe+qQ9azpujKn305K/Z7X5yvj05dQ9+JDzzleGKNU0cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqilRk99qOMYfRRW+I52uP2RhGJQb5USNbXwMyNhXao=;
 b=SoskrIKb5cKOTTfiSsqxiDvfZiI8UT0Hi6TFPSgZ/qO7DxiuIN65gBQOaUWGCamL5SwcCKUilD6Vtwc0XrWvWLqwGhmDB+bbztiqzTzKy0xZhlcQBUpbAi4rVdZ1++yXdS8SiY/cq4dkBdkLBlhn/8F1WOxQLfUnSyzpBpFbjMI=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2478.namprd12.prod.outlook.com (2603:10b6:802:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 23:33:19 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 23:33:19 +0000
Subject: [PATCH v3 3/3] KVM: x86: Move MPK feature detection to common code
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 11 May 2020 18:33:14 -0500
Message-ID: <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
In-Reply-To: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0055.namprd18.prod.outlook.com
 (2603:10b6:3:22::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM5PR18CA0055.namprd18.prod.outlook.com (2603:10b6:3:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 23:33:15 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17e3548f-d64b-4b4b-b811-08d7f603af88
X-MS-TrafficTypeDiagnostic: SN1PR12MB2478:|SN1PR12MB2478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2478FC72FAB45AF0F43E22AC95A10@SN1PR12MB2478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lp07EaxNHX/7UDrHydmFbTYgzFZ0Zz7eRxSo8b3Z9IlhAdMGlVzAjgz8uMbUfUj0RKxL4syQlWQtLss+dNV5TIdPtJJFyw2D8DCsCc50kOaHTEN1cH33rM7e2hsWhi8KLUIhxDPrFztyqFnnBngeDFq3MGpaIYe7+bADFz93JS9jDmBVvL13dxWNSsec98gMVAPaZ2WRAU+fJNHMkB5CTeLOjAr79gqe3YwDVAFrbh/syAAlJnOPLj6BU9/MAGdAkEZtd8wIWyM6N4WtBH5Z9imrRM3jC06a9B+B2Dj1jLR2i8jx3d/MLeIpNtG3du3zwP0iNOvD3sWaF4hZV01UC62BzdqgmYhzPu95NqNgDfvvY4iWBh3YyDcswTgUdUnWbDxu0iXls+ZClsS3AxDtTrJTeQwnElokiywnjBKLoYKxyl/yYfmsoMvmdElGXkcfeg8MhlDHYhbFEUHKq/z1q1Jck/uLd9wnJ+NDXDR3ENsz0Ik1AyNsr88Pxt8JRmNV9NZAwb4LepCm24uOo6LQ8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(33430700001)(8676002)(2906002)(478600001)(4326008)(8936002)(186003)(26005)(7406005)(16526019)(5660300002)(7416002)(44832011)(86362001)(316002)(103116003)(956004)(33440700001)(55016002)(66946007)(52116002)(7696005)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PDTczmJ3m/hcF6x/S3Wo6YXKY5N52wztI/VHD78AuumaQ001Vv52lOWW1ccQgXnO19C8xLdgfsyEOd1IxJavGA1eKg9UE6kUM47tJBdCgL7M52OulIhCX6GquILf/BLekYetcvH+lZXVNBTr1Nw96uuLUZdtv4wiWISXM0JojcXDW38w6sCWvllNNiyB9Hq8kzo7pJhVena2VJ5tkcubszWUdXMFrTUXn2yiR4wlBjJ3vv6krmg936BnsAuHzoSVJTfU4+V093eNr0MYIRYvXe8pUxndKZmlhguN40O8xbogTG5HTynDlF4NwlI3/oKo25/yQKt4RGYP2nX11guXkWJcgI4K7s/XP9LOdN1ERe59apgQzxXVTEYcq+wWyBzkiMXSo87LXcEzumHsMDOnlhFggz6VKgiH0DHBSRB7Q9Y11HEOswTtNl+2XrIPKG28Qaqfkib74seTadMmYYKy3Tn0CUB7I6rM6VwZExaMTdw=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e3548f-d64b-4b4b-b811-08d7f603af88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 23:33:19.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGON+zFMhVGFkbIStjochE+orrsYkDCkTm8PMduUPnYpgc4C3eu6edxW5O+MeLgc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2478
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both Intel and AMD support (MPK) Memory Protection Key feature.
Move the feature detection from VMX to the common code. It should
work for both the platforms now.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/cpuid.c   |    4 +++-
 arch/x86/kvm/vmx/vmx.c |    4 ----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..3da7d6ea7574 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
 #ifdef CONFIG_X86_64
 	unsigned int f_gbpages = F(GBPAGES);
 	unsigned int f_lm = F(LM);
+	/* PKU is not yet implemented for shadow paging. */
+	unsigned int f_pku = tdp_enabled ? F(PKU) : 0;
 #else
 	unsigned int f_gbpages = 0;
 	unsigned int f_lm = 0;
@@ -326,7 +328,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
-		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | F(LA57) | f_pku | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46898a476ba7..d153732ed88f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7136,10 +7136,6 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
-	/* PKU is not yet implemented for shadow paging. */
-	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
-		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
-
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 


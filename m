Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8329228188B
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbgJBRDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:51 -0400
Received: from mail-eopbgr760070.outbound.protection.outlook.com ([40.107.76.70]:58595
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388297AbgJBRDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVRfckAIJbFV+RovLdAJ5B1KaZIMp4fxJMaUgrG+JoOldXwvrhfKRRFFeU+7SQWiMaUp9zIfYTooCfo51GS+CkvH51Q07ac83bLQ0rGh6stLCT+qsshVgfuJpy2mGzLJBBdJ0NjlfQgSkztoJhlFa7CYxr0axmhgwdbar0tcMSfVnB403wqrYkFlaTnrpFQLLNgMM/6LO8G5veEKQ2PDM+TM4IreNmjDCTlVfLE8yIn3hNSeJBtB6z36NyojRmD5/2QmxfOODE/kP7jF/oiM+vqH7KyvqQPFD6QwG5GIQZJD+gWu+8hPEEsJqzqE9TP7BSdc0Eox/cl9W+aMbkSieQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9xCxv8dswiT0frr1WLtJTcLzg4+OlqNYoBbvTVDcn0=;
 b=WhMYLdPtph8WpAubsZWMCi3zq/Y4bySnAc156W5Ihphh1Esju7IE3oPXTEQ2785uDcRLZKv0zoG1cWdpeUrdiFc1VbEkCsPIWx1r3blSRK2rhqOblIJLp4e8NtZn6tsw4A9d9mKSNU+wBLUExfWFHk6xjK0DBCOfUOMiX/+EQ02I6nAOsmrYNpDoSlvkpajqzlzg6nzfJSiDKhNbnlDTQpB8c0Fpq3pSWacEXiWPZD61ePZYY4VZZVVMxurZtGUM6vTiwGDNf5U7q7Gib06G2pTo6UqBqd+2Puokkc5fWTgUWEoY0J4tHAIqQf+v4O4ACTCQ6ERngVo1NboiwDheqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9xCxv8dswiT0frr1WLtJTcLzg4+OlqNYoBbvTVDcn0=;
 b=IdeV+29KBdr1x8sbYbWoJlPHnv7ZOPSpsEqH6uMX4htvN9LE0NStxNUPe5/o3kFFi2AEom9f0GuFv6Ltooo/vHcxTzhF56c04aqn14VkCx8w0sNkJxzbmIr9ulTWvNb25cfbIxBgJxA6bXjZ0oRte19kL/X4OaTaOBKFbmTl2co=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:03:47 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:47 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 04/33] KVM: SVM: Add support for the SEV-ES VMSA
Date:   Fri,  2 Oct 2020 12:02:28 -0500
Message-Id: <ae294f4efe36da6eef2356af40ad1710f66f06f6.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:806:6e::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR11CA0012.namprd11.prod.outlook.com (2603:10b6:806:6e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 17:03:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 916b5841-ebbd-4627-ddb0-08d866f52098
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706DB4C2CA975A7FA5AD1DCEC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JKuHdD4pYMR+9E/xg50tQ8WQZO4A8RmAPoXCZ3zGhch/hUlYZMzy42imU5bZzPybtu8xYxgcqS9Q5e+VigSHI9XqzkqGZAChcp3DZBNlVWnmc9DXWe0cxUMtEvTl4NT0qPJ4P8O8ksVzhOc9uyuQ+f4+2zvchB2axoXkoAJmvXCDt6Q5Y/vaExl3uszQAfDI4nKXD2QWZ9xNSpjeVfTAp7PkS89BhYN1m8dqiFcGFGSQGRNk+uGVFeAW6zMNGcijp3ted41yTm513KBMaU7RTbneCr2SCNg0K2tWPntRnhx+WCnn9pO2XkYCcjE58FISw3rU/mnYojPFcp0u6H+gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nJXsqCH2ztdOxMT6KyDpAdKzj5RpbcdkK6bIzkz5qLfsKoErXruukzFP6/RwHlwqtBvmXgkn6xoqCyOSrKJHSropavjMgV5dptbegZlKZccoUv9wnjz7GXC5n+3Tf0bxTz9JE3MlYXk4xiNvZykcku5VumPYre/i0S6WY2VARTDkzKdaENgRhdzBuozh6u/BKyVHFHq0DJRUPIPlgP1NwhZ5lWB0S9GqecMBCZ7s4ptkTLzNyppBSx0jEuAdKvW+dmfL/fewRJxCDTidKpKzVKci5g7/P7U7DL5OA63qSP5KVvBLWFaOJfW2JLjEl9hgPnI7Y90ZIfytPlgQx6rpNYaGPWURGrUU7qZJYAXHwWl4QwRqcfHQ41k7MCQfZzX+NU1j+QsM2Q8fddvZiVY1APjjkUQEUZB8TVEv/fOzbo1O8VAq5CO8QIQRksiwI7OxnoeIuExXf8PboD/qChd4g0+gCbgq9uZsw1gBZfN/P+bP9cGHGG1B8LLRGnbvt17S2hikDoaeubF1y5ho0eWCxO9VT6YZ22kSmh3ykuMMaZK5UC/MFFxh94sEmbioDdzbSt75DZmUXcN8s22ODnt4dUChiouHUkTt9k5sOFK3H5Zw+mMKwm+D5y12s12n1xeS6p42j2SHuR4chptRrizPcQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916b5841-ebbd-4627-ddb0-08d866f52098
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:47.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NX7TWbNR/X6Tt3bb/uNtqRmx01wKbd2Vnt5ii4jjhzciWiE1Xic8nt+l3FeaLk/y8i4TpwlGVolWorYNo0z8bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Allocate a page during vCPU creation to be used as the encrypted VM save
area (VMSA) for the SEV-ES guest. Provide a flag in the kvm_vcpu_arch
structure that indicates whether the guest state is protected.

When freeing a VMSA page that has been encrypted, the cache contents must
be flushed using the MSR_AMD64_VM_PAGE_FLUSH before freeing the page.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h  |  3 +++
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/svm/svm.c           | 42 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h           |  4 +++
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0f77235da92..355fef2cd4e2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -789,6 +789,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* Protected Guests */
+	bool guest_state_protected;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 249a4147c4b2..16f5b20bb099 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -466,6 +466,7 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
 #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6c47e1655db3..5bbdbaefcd9e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1268,6 +1268,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
 	struct page *hsave_page;
+	struct page *vmsa_page = NULL;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1282,9 +1283,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!hsave_page)
 		goto error_free_vmcb_page;
 
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		/*
+		 * SEV-ES guests require a separate VMSA page used to contain
+		 * the encrypted register state of the guest.
+		 */
+		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!vmsa_page)
+			goto error_free_hsave_page;
+	}
+
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_hsave_page;
+		goto error_free_vmsa_page;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1296,7 +1307,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm)
-		goto error_free_hsave_page;
+		goto error_free_vmsa_page;
 
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
@@ -1309,6 +1320,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
+
+	if (vmsa_page)
+		svm->vmsa = page_address(vmsa_page);
+
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
@@ -1319,6 +1334,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 error_free_msrpm:
 	svm_vcpu_free_msrpm(svm->msrpm);
+error_free_vmsa_page:
+	if (vmsa_page)
+		__free_page(vmsa_page);
 error_free_hsave_page:
 	__free_page(hsave_page);
 error_free_vmcb_page:
@@ -1346,6 +1364,26 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	if (sev_es_guest(vcpu->kvm)) {
+		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
+		if (vcpu->arch.guest_state_protected) {
+			u64 page_to_flush;
+
+			/*
+			 * The VMSA page was used by hardware to hold guest
+			 * encrypted state, be sure to flush it before returning
+			 * it to the system. This is done using the VM Page
+			 * Flush MSR (which takes the page virtual address and
+			 * guest ASID).
+			 */
+			page_to_flush = (u64)svm->vmsa | sev->asid;
+			wrmsrl(MSR_AMD64_VM_PAGE_FLUSH, page_to_flush);
+		}
+
+		__free_page(virt_to_page(svm->vmsa));
+	}
+
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	__free_page(virt_to_page(svm->nested.hsave));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 84a8e48e698a..09e78487e5d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -165,6 +165,10 @@ struct vcpu_svm {
 		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
+
+	/* SEV-ES support */
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
 };
 
 struct svm_cpu_data {
-- 
2.28.0


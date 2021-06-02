Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87570398C79
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhFBOSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:41 -0400
Received: from mail-dm3nam07on2052.outbound.protection.outlook.com ([40.107.95.52]:27104
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230428AbhFBOQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi05moGjJF7sjNfbuyqOfxQs97Fmnnxy1C0vVqYLDLW5GTO69BnJ4vjDiYk81Gi/paoVsWYQoL27DTAGGZZgp2sO77tCd9ks2ach1fo8geNt1HFWpY2EgbIjlzlz5ro+lgIDOsz8uZcSSz9dVh+5YGrSCHoaoU6Wsy6GnITzPNNpVr7R0waRgINgqD7oXvgUSNVMxPiurrucu5pGjmyqi4pUMcSc/zw66U1q6xpe+znh8G1EnqqM5DkrVIMja9IPpsnsLuBO/vnKCo8PQCJzvoEZuqOM3lJ0Vi+IvAkDtUI1ZJtW8rhdJXCyqm+TeLZJFjTbxmef8X3hRh73QJ8T0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPIvRwnNwHdEha3n72i7CJC71O88LkOUXxlGm7zAFkQ=;
 b=mGge8w/zGpQVRUkjzknnVZFYKu+uT/sUdti/8eBRhn0qjgbobiIW1oXKbPaDh4NRdZy/Hl85ZCJ2GAcZjZt/2zCxrwJ6SalKfRfZVI0hYDNNVVKJxIMKLFSOROoQdVV28zAzPBaiWSdPhPSQYOBLacyaQGkJZjhD9oKa4s606UKAox9ddcam2CEHP8vcEMdDdR+BqRlTJpdimCnGIbFbBOy1aQeGqm/CeXA6CW0l9Lg08NF1evg3n0uqFteRCJCpuEXTXb0DtdbCcNTyV6iV6yboXZTvYEmdYHVRl1tHZwtat0UkReDxr3rO/+kNnzw64eAQTIlcwkEnUESP8XscQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPIvRwnNwHdEha3n72i7CJC71O88LkOUXxlGm7zAFkQ=;
 b=YdP0bwDJbYf9WOaM9VRVtd/1Lt6IhbrslL5syRtmUDU/CmBaMZ/4Bj5Nn055hTlAUp6YaMz581/ndLGfJvvMKeTueeENNat5rS7zfjk98NVQLXItR8XNisIvcS/mDK9EjhXQuJH4fLzuR9wpT8qagcAsV+ZadV4uqBoRDKpyr30=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:41 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:41 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>
Subject: [PATCH Part2 RFC v3 36/37] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Wed,  2 Jun 2021 09:10:56 -0500
Message-Id: <20210602141057.27107-37-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 094a8188-f328-48c7-f338-08d925d06c33
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574A2D7197F8F69874F6BABE53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+Y3OI4oA2E4uIZQPKG8+w8L7TE6scjBXj0uZkKba3jyGTU81j+2ZC9dvTKCF70l3wVCSU29KAtWi/2VwA7nLjMxEsQIJuWAI7TjFtxq7oyJgDeV/ExvY+N0wIigu0hzSVlb1jvqwNyexHkwDvgE/33KY/8OeuyBQxBPEyA5uKhFWflm5qLXdO2kM7gisjIh0jO8aOMmpTBwHCGdH0a5/fD9pU/ispRLvjARdKu1aPEXBKn3YNN1QAg29kiMbGk4IezVY0tCh9uZAEkeh8vDquR343VInqdL4dv+NzD2z57G1nZ/Yoa4DbpqW3+9Ab5Y0up9n4o1X2rdmL/pYfthDMzQjGBniWvacqgkkAgl455Fxni3jnqDpiBFu7+//LZe/xJ2lAi4QsEtzfhMhcY7EIUaTPsYHcxeHcQNrKUWy+TJTlnpGGiM8YVl0Odd2hhbxF+E4sCVETzFgbY3bV4/AyYFt2kkCRpFOmg6aWGCobwkwS5M4anY3KfERZExthao6X1CHjo0/R7kEikLI/qJ1WYJBGiT7uUa+jrg8X2LT42TAwBD0f8QLcSctsmLqAsk18jGw9+Fhl7WJp5sn4aC07Wq1nHPmsdr2f5jBxQ7tQgHB+eBdgT6ENTNpUH+j+JoQDNyieAPh2VngthfJH4fww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XoneEl81jzW+xpqfSMvmQc9NPyrCIyx8WIvgnK/4JiVXPMrMYJwp3r5+Epbu?=
 =?us-ascii?Q?PrbReS7UZ0jLcIobAWEBpy21Q+qgabhW/RahZp6XF4q0Hg3nZZRbbtOvCpYZ?=
 =?us-ascii?Q?S3UZSGmA99NeO61cqQ9rPjZTDt0U00hBM4pZOfXGce2GsenEYx5GMpjizrH3?=
 =?us-ascii?Q?YQcV2uF1j7eNZ59OWilyW3zyqYvLQD/eBM/uOzfcWuVS1De2vqbm6vQI6Qr0?=
 =?us-ascii?Q?j3bpZdQTHlQLUCrshvTGhyh/CvXUz4ask2qFXdFviSWCGok+XO9KoOAVgQXA?=
 =?us-ascii?Q?bmI9HRrFbjPmWuZNtrsAlWg81YVb1AtQc+SyX2A8YAr3aY0p4elO+edhkvH/?=
 =?us-ascii?Q?wLpuTu10G+1X08hfVMLassIyGSy2QLVWIXz8oer3mk61pn4Qki3p1gNt04n3?=
 =?us-ascii?Q?+LbzmUBnAxVh1r1xwpTKLh4g75hTBF4cDyIFlKYJNfcDJVhCWd50AIjEjLri?=
 =?us-ascii?Q?W4VrUgei3u67IuOQvhw6F4Eof6cSaTUae/aE7bxtkUCLzg2lKr3G6HQX7YlV?=
 =?us-ascii?Q?9CwcKDOkUvWTBd6Cg71jvNGOde0cz/cJd0uDkYiMu2RDE/8hy/5+us7Vd/dl?=
 =?us-ascii?Q?nDF7lL/BukQu0inHxbJ/gxrR2eqjT0zhjW/HLGY1EbiqC5HTQ0cwHXzFWBI4?=
 =?us-ascii?Q?1EotoLPH3w+ULTWrFBEiySVO1hFLuGNcqfhuNvQ30rOV0LqWZl9mrElJrp4D?=
 =?us-ascii?Q?vgzBP+IeB43CzImK5iqGKceym022xNaCg+lfI2IMy81/t5IZU4iM4S8YadG7?=
 =?us-ascii?Q?bm0fLiMMLXcgz0sK6I3RfVcXIkLfqlLFiHkZhNcwLcxQBa42V/LBnVIzNCd1?=
 =?us-ascii?Q?xOG31cVXUecJ170otAHuQpRnYlbMpAF2tpObjUuA415v8uudcU/QfvAQ2zha?=
 =?us-ascii?Q?QsmnemNWNAc21Ojyha4oQAYsQwwHbtnPLXprnmdTNdEsXbe2UN6KzgiG/cE+?=
 =?us-ascii?Q?zL19C1NMjv1r/bOJcVsSHBqkOCE4CmPTH8IZ84xFmaVd1Luim6kM+WQ8ycfL?=
 =?us-ascii?Q?e2fesmB7EwTUVa8FHjzgyquIHVsPE+F2t6pDol10qxOHVm7bu2UN6XELTwZd?=
 =?us-ascii?Q?bDy79OzOdhSsPgUZ+/N9N27yXOab2lmb+n09lZ/613EowZgnz/lxYYJ2GZQU?=
 =?us-ascii?Q?Tp3f4QUUJpq5Ln8FVYC8xpq0/DEnrieo5mr40ULAjNUUviLsNbYRzdYQZp69?=
 =?us-ascii?Q?fB6ueEivyZYp0ikeT3i3bUVf1gs7fTs4xJKrTgOTaddcbFGiwXlBll4YCMS4?=
 =?us-ascii?Q?Nbz+He3J3X03QdviGTUVxG6WeoyNgkBEOp0G1du2VYZMWC9hJG8XCvdmrXR6?=
 =?us-ascii?Q?2nm92z00LwadxcvKwyBmrZ9W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094a8188-f328-48c7-f338-08d925d06c33
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:15.0763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzjZDUR2BUltO9e6yHECiWCVLRpdQv7uZ4VkH/M/4qUiAEITyY+RJt2y1jTCS45jwzi8/+97XMTmHq36VlXswQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5718e2e07788..047f4dbde99b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3409,10 +3409,9 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
-	 * VMCB page. Do not include the encryption mask on the VMSA physical
-	 * address since hardware will access it using the guest key.
+	 * VMCB page.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+	svm->vmcb->control.vmsa_pa = svm->vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 32e35d396508..74bc635c9608 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1379,9 +1379,16 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->vmsa_pa = __pa(svm->vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4efcda3070d..52fd3cf30ad9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -176,6 +176,7 @@ struct vcpu_svm {
 
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
+	hpa_t vmsa_pa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
-- 
2.17.1


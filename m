Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8869D347EBE
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhCXRF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:59 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237062AbhCXRFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NskGhWGriLel4TmQWc4Eg8l0LwQzmZzIh0VbZKyPg4g74MzOCJ90zQAuFnwEt2PoSHkTC5EE543haiRQbFCIHM/coWdn0h+jHarF9Qe/gOwQHMSSLsfTh1Qgdns2K58ElH6qpFOOEYqlmcHQNXUDBja7Ndi2ug7/NFy2F8qCZwZxQGe9l94yusG4rDV448A6uJiolgUPmwkb14b8GRQ8WT/c3ZRsFiDfEzQ6cj19N3D2b7faMzCjNGfm04LqgXu8HoegX4kzYM2Mz5QnrQgE0EPBGPE4AmZnWMVfJ3MZFZhR24fafjh36EUzwSSsW2C/LfwDKP8cCMl5eScS61DHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkaNcJi+It6It4AFqPXfKx5o9ZdPI/+jG/Un8afHthE=;
 b=Wc330QUTrXGZt0ndJ0REzXjxHdKafPkSdyVjdJMdNtS6dsZ8vKtcl3JJ1/2XifxABQftUPUjf76ZbjGc0Ee0RZR0sDXKv5svbe/qz8wgZOR8Y7Bz94Xy/crQvKkgycFqErAJg5e760c6Ag8CP4fO7S2nrer5YPNjJc+rA7PhyQLRBxM5AtGoD3OvJbOzHepdZ45Huh7uYf7OQrAwhnxplCE/S9Tp+24H1q1qvlU3Z4kB8MZIFswUCr0Z5lQFP1ocssiqlGcLhVzV4E2ycDYFg74kSAAw3Nu8Pr4rYKoW+h+iLsEe/Ocdd0dWpLGL1rlxmeeGUzypiJ0oGmdLb1HJ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkaNcJi+It6It4AFqPXfKx5o9ZdPI/+jG/Un8afHthE=;
 b=qEvHSG3+IHUbPMET02ucfC8S1lVtmiIqltjQMyRefmE7SXdmoaVrM+ZP/sITc76fEy1pk1xaI6vFnh3WoQP6YPRyXqA0U1rKk1MDCOlTEBc1cFeFnydNgb6FsfopY5MtoUHHantDD9MhAnJlvfVWKhj23ijXgfQ828quq2uR2oc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:09 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 22/30] x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
Date:   Wed, 24 Mar 2021 12:04:28 -0500
Message-Id: <20210324170436.31843-23-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 97662453-063d-43fc-8a5c-08d8eee6fac2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43821E000A8F89D490630AF6E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rrF+EOQoOL5hQ62GeEsYpmt6j38MbOWbw4WN9hlWfpleuiXyupO+g99hUoqiNDH0IYhnZS0WOk7pDOIR2wqAINtiN1VWl6yyoLrYts2avsflSmKGtJigYYYjpg95T6uzbyY7RWSt1rSQFIvWlwX1WtT/HO/fql81GcT9t2sfCsT28Ee6MKLdj/5rmcBbaV2BNLFNytjHcC3BABwcfcuROgUsB34rSLTNVEonDbr7mREQS6/qcItArp74NI48Hzs1wxXSJoMl20aSJLzjuBVm0tdLywsZhprZ0nwAL/tGFPN9rAqWKt2QJdqmvHN0cDzH1oikJZ9bjsMqMVY39tm+3hV0H/lD1UYvWU30IcpragbY9KIIhd44lom/0RqFRdP4nzyWrPGfQbqbhYVlDzeC53n4LadEdKVYjVXNHF0FOJ7CTo5mKcZSDn0cj6rbicoa7wRmev1ZaMqn58cIUlZk5j2bY4G3LLr6zJYDANDhqkHljOgyNbcnfJ0H2S/j1Z6PmewLKaj95pBUU4bJUdQFrde9U2DiXE3jNrqw1hpsKX1nKKFCffe8iGu1lmnpIrcVbaVVswN/mBJWE8CJFhuFnRlQ7E4xY9BOccHWrR6Uvti+WXy3rEZW0BBFom48VSrulXpz3GWsb+EMpsjkw8M5aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ymywn1j8u8HMVGBvylVj6HNFMbZFdWJx1pNJrn05HrvZP6AvdKXQ8yelvxXh?=
 =?us-ascii?Q?1208UqCo4ddpiSx7sucWw85MROUs9eCLNciUCcvHG26DrYGZtVx46fBJJ+gp?=
 =?us-ascii?Q?tkI1Y9KmmqcGzsxeNM94qxY/+6kVUbnDGDb/IuPJpHuztsoraPM/3eUtdTL0?=
 =?us-ascii?Q?RTpFcKwJgdbssEEDf1pyiFihSBc0y2K+l+nnYMjMq8SzMF8nZ9lZN88hyCLC?=
 =?us-ascii?Q?pDaUUpvYHx0ejj6PDsuHNQzSscNuEO/XFAjAtGzUUqK8lei3QJ4iqh29P7Lr?=
 =?us-ascii?Q?kcm8h+eQ24UFyV0iIa4ugJP0RbeFA70pMBQfi7XENe6ZpMtnMTWMTly0wIaY?=
 =?us-ascii?Q?DmV3JBhE+rmK+rAzjfhwjfViXi0L540Y1O0a0NpFkUN78m8Ph4vGDgGwoMtX?=
 =?us-ascii?Q?HsytxtpFjzxgKCIxhTfglbjbqrt9Ae8u79ZU6K+6ypodjLkiz8vg5On64hlo?=
 =?us-ascii?Q?tW3PU9Zx2mLjl46Cv/SwTDfbpf3v7PQrD3kBe76zgJN/skk1i/7DLU9Q9I5q?=
 =?us-ascii?Q?506aWsElESBEE/YXCY2UP0tMulUQh9F3TCPbJyX9c1f9xKCMEgcBJ55JW5Gk?=
 =?us-ascii?Q?76mspC3Zhex79wiO0azqjjU8mL0aumSS3YVxH0JCo8dzVA450iKFM4mFMbKn?=
 =?us-ascii?Q?3UBxSzOhqmbFg85qAIDunD8RLQVwifjZbUZZkr0mOoPO6lVm2wmbcZT6XWhE?=
 =?us-ascii?Q?yE6/Duv3reRNVR7QvK7xldqRoXfHCfzqmSVMceA7oeMjIxSSIEZ4YGkQneuU?=
 =?us-ascii?Q?HT6HPlfjBI3Q7Ue2+ZARUCcKONDiXRwNflwPNWGUzu1AFBE/U0eZYMzA7ADR?=
 =?us-ascii?Q?XOLoj4q0RgCdUDs6u0dzF3gMQyl/OloFxM7JatqtIhraCC0071rjckHJwQei?=
 =?us-ascii?Q?XJGYBG6gbjrEyjTZD78WMxR7oyq1F+1Eue+K3M67A4eV8+N8wfq8N/UcmSDp?=
 =?us-ascii?Q?gK6epfFCm2v4E9OoxbFI6dEsp5id+2omBSRS/S7A8nO1QOE5Q/WkUeyadjpj?=
 =?us-ascii?Q?AN+Nx5+fli3fsKFW0A4Ix1g+Xewl6da9SbtK3zjdPAlI2f6wBakOyTWrD54a?=
 =?us-ascii?Q?+MzlO3UJC4sBKcfx414I8VtX9t3iRU7NNqvu4tQamfMsxViVI0AEQonUnrD2?=
 =?us-ascii?Q?fkvfU5FdvFcdu+VLXpqSuLCkDf4o57irouzWpxE38wQNl/WsK1YemQKTmPEV?=
 =?us-ascii?Q?mWbKkedhDtMEzN7HF1PPY9tSdMpgLkWpnR8hv2iFlLEN7lgT8BkibmfKKz81?=
 =?us-ascii?Q?7r3mY6bFBkor4ka3Nv1RrJEIFuHzKqXua+jmefI1+69P4Wb3T+nzqVlRpZrc?=
 =?us-ascii?Q?ZvMcmSZgfzoPZ/tSIeHV662q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97662453-063d-43fc-8a5c-08d8eee6fac2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:09.1216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVbL0rrV3a6Z1LxjUgPMrurtIiM6mo1zXdm+ChfJ9IVm5EIfdP1ToIdKZr2bGWk/I3ovsgOEo5yOjB9lO0ceJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper to directly fault-in a TDP page without going
through the full page fault path.  This allows SEV-SNP to build
the netsted-page-table while handling the page state change VMGEXIT.
A guest may issue a page state change VMGEXIT before accessing the
page. Creating a fault-in, we can get the TDP page level and PFN
which will be used while calculating the RMP page size.

SEV-SNP guest calls, page state change VMGEXIT followed by the PVALIDATE.
If the page is not present in the TDP then PVALIDATE will cause a nested
page fault. If we can build the TDP while handling the page state change
VMGEXIT, it can also avoid a nested page fault due to the page not
being present.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 261be1d2032b..70dce26a5882 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -109,6 +109,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level);
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e55df7b4e297..33104943904b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3808,6 +3808,26 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 max_level, true);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level)
+{
+	int r;
+
+	/*
+	 * Loop on the page fault path to handle the case where an mmu_notifier
+	 * invalidation triggers RET_PF_RETRY.  In the normal page fault path,
+	 * KVM needs to resume the guest in case the invalidation changed any
+	 * of the page fault properties, i.e. the gpa or error code.  For this
+	 * path, the gpa and error code are fixed by the caller, and the caller
+	 * expects failure if and only if the page fault can't be fixed.
+	 */
+	do {
+		r = direct_page_fault(vcpu, gpa, error_code, false, max_level, true);
+	} while (r == RET_PF_RETRY);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
-- 
2.17.1


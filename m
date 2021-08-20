Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3189F3F3098
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbhHTQBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:48 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:45024
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234308AbhHTQBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYUFuOJjvMncr1EHrqP0Vo3cBubDyAr9ugv0BUVKtdn+JSR6wh5rip71rHCzCSsHnf6IlnEV4xN9NGeZ8F5Lr7X07GBrF+EQ0gusPDQfiA6mSkRZsOpgDOPROpRS8jlx41GdFSNsS2dK+APBbfZNVpJI41ZCFzvTL8uovqvW/B7zJTX8LsDEzKLGzDxVGNRL2UqWqCgl9UmdKI7V9Vt9/EnwsYhNVwaEzrIDrp5iQN172lwErljB3JMGDoEZGCSMh3z0CsQLMXtKMwfJBvnqIPoQ8LSJpgTg2p2sx6tw4iLksBlbqzSUyam+L65ZsOyKY6ejQFgh+zsbJbGVvhJe6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea5eJngmO5Yeqnd+tUYrFGA2H052zw3MY6v1zatEhIw=;
 b=TmEN+W0JhQKOt4Kz+0HUbrefGax8Y8w6qNWwCzci1sL1DFG4WDHzwgxOaKURuGc9noZpKIgU/psCg+AfaqriqEoK7NLNm9Cz7ylvYT0WxjbYQ7VYwvOy2T+jQCJzKBxcepRjhClo8Smn07h8CEsz9z23JMwEVSqGFL+zyoQWnZQjqOfzR1WT8GLyQ1fR2Fb02XTtP4R0J4LdrxaqaK+iQTLqjI/xxKq3BN/jC7UY0lbSBl309AtWNkF+KehmsWq75Ct+SGafHzgH+GGrauH2yWV46RcEzTTGLKIaa6AZN7uKSTf+RLngwtahYLFt5oaFiu6fuKfTYSDH358bCfPeeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea5eJngmO5Yeqnd+tUYrFGA2H052zw3MY6v1zatEhIw=;
 b=fhbeUGGMy7KnXA+ichr0pGAy/RGIrl9Tj8h1DPQ10hxFzUPdgXihkeTfFiqfimR2ZxKGZ39Vim4jpx5UjanbvF4KYFTAOBuenGif7Z+cHi1ss1a7roJgVRDxj3IfGqNyQWlmHUog2Y+ChEE4ysANStQDFmLCp+rES3eUYE7a7gY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:33 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:33 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 31/45] KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
Date:   Fri, 20 Aug 2021 10:59:04 -0500
Message-Id: <20210820155918.7518-32-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 812e28ae-ca6f-47f3-0bcc-08d963f3a445
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45090BFD24D11AE8A7FE971EE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gAbkoZkHogV90QO8HqzvgrBufmux7cLSjhD3Rk/x7qTbiL+urpFu5C6ArSt1+1neJQR1y0fnNylrkeWeQ2P6ogDJPLkIpN42bT5KlztNCIblaPVMq6fbW9KhkNld3zeLU6WN2JPt7M0KTzskktyV49o+FU40ZMZGvWCncZ+O4ZkMibPqkZxZ/b3WGV7iYPQs8jxHBcMIfpN5TxfNu+NB2se/IZGWW/7nZlK7qd9GLNAlmMwZwpe6qJkLQAUEzPTiDCYEiqu5kovhjnYXLS6WtmoYv8hMR+PC3x+3qWLMNRRSSN3Ki9iqhgFcCVuvM6F7en9yJscGpDM6qQ1zsjbTKB1YgYBXlFC9lnaiW2tIkiKqg19caGKnEXOMsS+520Qg0neAfh8n4rmcc1pC6S7h2ZHh9PsqgQ0p8R/VwcyCCO5q5GcIxoEoJgPz5YDRFzKX2r3lEz8r0TcQIaCUH3325gYW7+oIR0mHdyWlWu185Ixy8+4rnBkxLvoqgFR+iW03lb7/D5B/aau6CbH8yLc/dyglj5CDH0eoCuJhWmghI4hvZJQ7nBUOuEHA3DOZMCgZeO6zIc/kSItgPGuuGpLtTLrBM8Cl1SJh/VPCvbYez7hA50VWrx4zl5QWzhE/Muu8Cmoj9SZCRr0IHo9qtvsZRlarTPmMLK05UkbfpZZJHPC0P9PU1XkTmkfigPt94n1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q1sPQKmOqX3QtWm8jNyMPc0vmp1relXGEXkLeQND/FQQk3cgMQgI4oCwl8oz?=
 =?us-ascii?Q?2jIOEkhDR2+HWHfm9wEneID9/uP8853bbGdpjmS+hdaD7j+KbgJn+vYlxo//?=
 =?us-ascii?Q?aafduStC4DLjLVCrB8F1LL2JjzNJXoniHmSQKFg2ko4loAHpTgHU13BrMt9c?=
 =?us-ascii?Q?KfysAZS8V66Cc6SSKMEXx9+3yVNRh9vxF8LPEufEVt/LX45pc7lYLoNjsXtN?=
 =?us-ascii?Q?fDSyWYgtCO36i9Q4VKMJDg3nVROZh37m8Wt9JrlWVU3iBY6JEi305xKgZE4h?=
 =?us-ascii?Q?o5OdmHS4m15zmpl1112OpypUuEoGB94QeSJDCNc/mi7oF1neJjdI8J3jxP2v?=
 =?us-ascii?Q?aMo8dpq4pW5GEV/ksvFHgo1HXxNPUCuYW/Yt8QyvUO6z84bQULoLQYinGjl/?=
 =?us-ascii?Q?J9UTeVU5tPMaknxQ4nqTqcDJxL//2tTYW7iPu2LIbjpUjf72CN31thk4OsQ8?=
 =?us-ascii?Q?tuzmhcS3eembewKFQEOkMVf+6TDn7hYW2dwjmieqW42klwlZAKsLOK+DxtK0?=
 =?us-ascii?Q?34NUDBoiGaOWset+l5xbwcXNnTSmE/e5bygdfdJYmdBlDgkZ2FfbAc3kDw6j?=
 =?us-ascii?Q?5HCVvbEJcANCrwZ+gcAJychK1+Xd5i27KYG6FbGg6gKOCbBy7XDX5xsFjunW?=
 =?us-ascii?Q?8+SJYqJDYfv2CrafmqoTggTw7UWssja2uFnYDcIipkCCSlB5JBOyxpkXbhWA?=
 =?us-ascii?Q?CXw6RW4aoBqgvljrgJ8VFxzAoEX9cXmtuxCWnzjD51QH3AfZFLs0u9QYuLRz?=
 =?us-ascii?Q?Wra4KpYcQ75EMGPin4a9L2nSofbhFgXcGSQmKiH5BKgNu4IDOGLTqWm1Baw3?=
 =?us-ascii?Q?eT3uLji2pCqiGbK9K+wQAK2vEa0QZYqXXqjzKITdQviRFuJWrRs7WHRz0+Yd?=
 =?us-ascii?Q?OMKMAGG0gdgCEj6lsvIYveHsmyIcrx+DZNwRgf7hKd23xmY8WWcHJiVO79Fe?=
 =?us-ascii?Q?BxkiSwVvLXeSZ7/Ep5tvV8uT5ww6rUC+bPGRvj6E79jnt8uZ10WeJxCF7dSA?=
 =?us-ascii?Q?hAC+HeZppYP0kR1hP/W8EWfHNNG+PkUHgwGPQ96AgsW5In48oG9yoBi2OUfD?=
 =?us-ascii?Q?wzbOJoCE+l1D2TiMRZB7FtiNLRqbFiOTKa8Tld+Sq+IJAy3+HjkaFexB/Ou+?=
 =?us-ascii?Q?84RNKM0l0FFOhBVmVwdDHBrO3iN+KUOhvQGq84lazmUSJmkrvdbC3oUcuI1u?=
 =?us-ascii?Q?8bK8CmXcg6cwh48SGWB9fU8yDilQfR+vXuw5JUzTGjzQ3itlUaCVvJ0C5kjs?=
 =?us-ascii?Q?93vT3cwcrzYkuhDSCb5xt5vmGVV0+EVKraeBDrwt70nBdPdaBSgY/DMCMzz9?=
 =?us-ascii?Q?ETgANycHoDFYGFB3LgfBp9bY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812e28ae-ca6f-47f3-0bcc-08d963f3a445
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:33.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ED2anUndPzkA8up0BEA4hGoSKBbLWWxpmHSE0nLUOMoGQaZqjt2NS5Td0No28RoLPZ7DsOZwaM8EGlZYpwk+CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP VMs may call the page state change VMGEXIT to add the GPA
as private or shared in the RMP table. The page state change VMGEXIT
will contain the RMP page level to be used in the RMP entry. If the
page level between the TDP and RMP does not match then, it will result
in nested-page-fault (RMP violation).

The SEV-SNP VMGEXIT handler will use the kvm_mmu_get_tdp_walk() to get
the current page-level in the TDP for the given GPA and calculate a
workable page level. If a GPA is mapped as a 4K-page in the TDP, but
the guest requested to add the GPA as a 2M in the RMP entry then the
2M request will be broken into 4K-pages to keep the RMP and TDP
page-levels in sync.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index af063188d073..7c4fac53183d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,6 +117,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a21e64ec048b..e660d832e235 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3973,6 +3973,35 @@ kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	int leaf, root;
+
+	if (is_tdp_mmu(vcpu->arch.mmu))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, &root);
+	else
+		leaf = get_walk(vcpu, gpa, sptes, &root);
+
+	if (unlikely(leaf < 0))
+		return false;
+
+	/* Check if the leaf SPTE is present */
+	if (!is_shadow_present_pte(sptes[leaf]))
+		return false;
+
+	*pfn = spte_to_pfn(sptes[leaf]);
+	if (leaf > PG_LEVEL_4K) {
+		u64 page_mask = KVM_PAGES_PER_HPAGE(leaf) - KVM_PAGES_PER_HPAGE(leaf - 1);
+		*pfn |= (gpa_to_gfn(gpa) & page_mask);
+	}
+
+	*level = leaf;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.17.1


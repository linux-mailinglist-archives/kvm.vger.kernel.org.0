Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC313F30E5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhHTQFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:05:11 -0400
Received: from mail-bn8nam08on2074.outbound.protection.outlook.com ([40.107.100.74]:63904
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229839AbhHTQDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC6aPrrb3JyPu7irSddVzRFkeW50Z/sQ61pU6iQcpHfLfNmTepBEon8Gz0UCZenxk0ng9ox3Ytuxgcnfj+bwQf4nmBUt0TCXe65A9P97daO/FO0Y6pgXOtXnnsTNuTE6Ism/JJ9fjrnaWzACfFi6HS+T3tvnhNmXoK7mFmCdJBtp2kUnZUEePc41RcABZsYW2KTgmphBGTasFbSPWEIeGnJ4HiIslVjx+ZtrSjB2JvCy1Vu00DEWZHIG+hEW2sWLlXFhqgJRu/PQfbYLTFufwCs60lkQAVh4VrnpIjZn44+RLvyVck+nLeGQIvaBf7pN6BEZLBgVMe1MpcXHEAAxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0LA2fTvBV5lJO5cJhgyEBV8r+bvc0RhNYF71X66yHg=;
 b=Vee6dkotNpr2jSGBpssCDs3mpfJjyEuPLrbjH3TSJCbu8wSixU1tBVFaQtl8LvkbrDkZp5yzez+HVY1Wf0h8MtRqUoFveM9RqRkPfCL6IhxYQYcD2HBtKUz5n53yOTFXvH1rhwLzoQQYDMTY0EYyhwI5LUrda5QKWml0GcobaTZm8egBA4NLT3SXdEkrUxP1ap1eiuh+frHOmcCOHvx6EXh3LkWRIvBmNjeEmE1eCjJzv2xGAzQpKa0e6Tbv1pBk7S/Yg4l7cHUI200g57Txp/w9V7hbHHdVkL3jIpEocuXAX9+9hSU/WJvdxY4MJud0OehIkNybM565koC18pLc/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0LA2fTvBV5lJO5cJhgyEBV8r+bvc0RhNYF71X66yHg=;
 b=BTHD4UDbk48YfG8TQ8PQ4mvMZmtJRp8UJJq2FDkrHFYR+jp9w4+IKLRZyInqzLLt79uHQKYfZAvXV31eLyugV8fh2G7WloAqFPrx+7JyMMX4Q2QYJKFt/NN9hd+50e4YojKXxQSgXYH/7UG3NjtDGuSipRr59XxygmmzUqDIKKI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:30 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:30 +0000
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
Subject: [PATCH Part2 v5 28/45] KVM: X86: Keep the NPT and RMP page level in sync
Date:   Fri, 20 Aug 2021 10:59:01 -0500
Message-Id: <20210820155918.7518-29-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 256706e5-aa1d-4430-fa36-08d963f3a21e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384DE5BE1F9F009333C60A3E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iyl7F6iwQsklCSPA1agI5pZFelWgRk97icHaaU3TJqCyemDhZf1/8/3tD7LRUG1ZsNUESIuUVXjRlbRqu71rJU8D7s13CmzFW4uWWFAdKdujXe1ckWr+qq/Tno77h4rm3QVbc4LShj81Gepxtzf5sxKjb77n9exjYWSw8SZNDSRXiiU8/1PKT27krXUyhEzdXSbsGwA7k1UDMrYAvmLKz40IVDR5V/JjCbRYLknUCFov2pe1BsUlgMEhVCTM+X6sZPUCuF2UPd4Tg7A9lOJraEOTeQIjQhms0nlLZsGkzVQpMJN/SdqOL/ZFeXF2VS+nyLyL29DB2YdpYK5r827tc2ojPk1RWuGQw7d4LW9t7q6yo5SI6753IqAwh5QKqTTI4cdGA/OIPLQoN5AHUQr/O1UPzP9oGhC2IcytQBsLHq66yjMkxIaMqljREFnLnexriS6n9bYkCijlY3qfYKhow6d2Iy5Krm1GA1N0kekG+Xh0gCUyVyuZUMPIRKyF8j7AeOyub+xtQ9EB2uguaUH0D+9r+Yf2LAFUqbdHvLRuK7NecC0qfG7rsN8gjIgrGZ6qTwj+s1vcB+hvnUvVq7U7w6O8YQGmMkB9vNYJRahXNBMApQcM3uMQvMqiYulqpN7OfnYhbdkqf9uQmX/nD+2j5Flg8o5TIPAdLbzLY4qRh4JiV+0kDfoD3J2b9/TodyaC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8kHMEeO7hWpbyTpKgazKpKSOBTz65M5gvf5YOJZyzpaMdh42SNWhQFqniW9P?=
 =?us-ascii?Q?WrjfUShEO68wJalOKfYf714obe0dlqhEAWgae88R5oxapyZGozuqvZaD0khT?=
 =?us-ascii?Q?VIlYaDgdBUaxqSqR3Kls888/pqAFrYfxIwGQsT6lASYZYN2/ngzHZvRfwiuI?=
 =?us-ascii?Q?Pe72FNDB8V7zQO3oL0WvFpIejKWgCU6ZGXoA3obRx114qFnRWmuM81bd9fLj?=
 =?us-ascii?Q?NPOjjDOHBTcYSK4B8XLnwQCpjSXYIjTcGQwLMjvwMSXoW0vqTJ7hu0CtGblD?=
 =?us-ascii?Q?Ndb8wsP4pxOR19OpyBGEPRUgDMjNyGH2dX8xbj/FrxYp6dACGzAChkjg1aLX?=
 =?us-ascii?Q?lEohn7kpq74o1WskO7uFd24KP5FmvHbv6roMuacEyCjz28wKTzNMAGTRkHA3?=
 =?us-ascii?Q?fR0ZphGaKbxCn6URSYIqhm5OA5OerJjv74Qq0WQjA1a/klolrbT/UPug2L8O?=
 =?us-ascii?Q?hzrcbSyrSG4Pk2hgZgcmT/OXda4zwPnT6SR8L1h4oxeOCPAFMM12bTJDsh8f?=
 =?us-ascii?Q?xp8JyvzepP6NOy8jWr08M2bXkgxHZntK+mcz9dZvvZfl1IHcXjMuCjqhKY6r?=
 =?us-ascii?Q?j0aQw0Z7vDhoP6rhtsIgTXhVHpsJ6y3Xlv5aHCpVuik1Xayi9yIttKWYmQiH?=
 =?us-ascii?Q?VyTuvy21gaNKV/clhWuQmEzw03BhEUae4KjpGIq4vowY2ehc6WjYmEDAQujj?=
 =?us-ascii?Q?vJFA3yE2rc0trJ6IvA3zzVxOFmYThJDmB1ZTmN1zCL3NuYcU5zftzymD461N?=
 =?us-ascii?Q?egZ7quU8d2HQfoc6ixx8oPkAQDlx9J8KIRPFNel5ywfiJ11SJ3eQFZTKgFYJ?=
 =?us-ascii?Q?GkvyN45oto+jMRsSROE+whSJQ7Z6B1b8EXSrYzBl7BhVGU6ud7g4NusPwyxK?=
 =?us-ascii?Q?hR9r2e5q+NPi5A8v9cvsLxSINu6NFXnPV1p4Z6HgzZVRy/xA5nHj8XtK3NCR?=
 =?us-ascii?Q?234Uvk3fd7iecvtanCObMEgpDco9V9mERU5QmYM7m09/QD3AtDgKZauIrHrl?=
 =?us-ascii?Q?i/yKtjqRxync1QXvtA9uuCneiy8KzmzrRc1mmuNqn/Ze/+dQ5g0s+sppSCVk?=
 =?us-ascii?Q?2CsTOz9Tq8O2kspUwDGILFbIXBZPVEdkov3z31zTYUS/pjjqE5qKktGCrUhx?=
 =?us-ascii?Q?3aD36yZ59Hy4JkleM2l7lZ6PAgB/Mnk8K2vBEu6hj5syXq2HzoO1HB+jwEal?=
 =?us-ascii?Q?UhlhE9UucUARsyI19AK3B8npchpNi/4JHxthPkDUupbT97NemgQvTupWCBMT?=
 =?us-ascii?Q?DUANbdKwbn+mNHjyN97kHcteYZ7b2wIVk+zCcYF6+AxShoN0ctMVVQw24E+P?=
 =?us-ascii?Q?XvSLo0y1XVMJZT0hfWNp9gtc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256706e5-aa1d-4430-fa36-08d963f3a21e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:29.9406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zqA5MZ2dJF38A1IPTll5+Z7WE9LnsdF7zr2CqfvOUpzH8+zHt8dt9uxUcY2eMV+3JFBq1uBGIqzG7yg8eVwjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the NPT translation (gva->gpa->spa). The NPT page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/mmu.c             |  5 ++++
 arch/x86/kvm/svm/sev.c             | 46 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 56 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 36a9c23a4b27..371756c7f8f4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,6 +123,7 @@ KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
 KVM_X86_OP(alloc_apic_backing_page)
+KVM_X86_OP_NULL(rmp_page_level_adjust)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ad6255ff5d5..109e80167f11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1453,7 +1453,9 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 66f7f5bc3482..f9aaf6e1e51e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -43,6 +43,7 @@
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
 #include <linux/kthread.h>
+#include <linux/sev.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -2818,6 +2819,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (unlikely(!pte))
 		return PG_LEVEL_4K;
 
+	/* Adjust the page level based on the SEV-SNP RMP page level. */
+	if (kvm_x86_ops.rmp_page_level_adjust)
+		static_call(kvm_x86_rmp_page_level_adjust)(kvm, pfn, &level);
+
 	return level;
 }
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 248096a5c307..2ad186d7e7b0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3231,3 +3231,49 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return pfn_to_page(pfn);
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	int level;
+
+	while (end > start) {
+		if (snp_lookup_rmpentry(start, &level) != 0)
+			return false;
+		start++;
+	}
+
+	return true;
+}
+
+void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)
+{
+	int rmp_level, assigned;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		return;
+
+	if (!assigned) {
+		/*
+		 * If all the pages are shared then no need to keep the RMP
+		 * and NPT in sync.
+		 */
+		pfn = pfn & ~(PTRS_PER_PMD - 1);
+		if (is_pfn_range_shared(pfn, pfn + PTRS_PER_PMD))
+			return;
+	}
+
+	/*
+	 * The hardware installs 2MB TLB entries to access to 1GB pages,
+	 * therefore allow NPT to use 1GB pages when pfn was added as 2MB
+	 * in the RMP table.
+	 */
+	if (rmp_level == PG_LEVEL_2M && (*level == PG_LEVEL_1G))
+		return;
+
+	/* Adjust the level to keep the NPT and RMP in sync */
+	*level = min_t(size_t, *level, rmp_level);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 058eea8353c9..0c8510ad63f1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4679,6 +4679,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 85417c44812d..27c0c7b265b8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -589,6 +589,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 
 /* vmenter.S */
 
-- 
2.17.1


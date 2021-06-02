Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125A2398C46
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhFBOQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:16:56 -0400
Received: from mail-dm3nam07on2088.outbound.protection.outlook.com ([40.107.95.88]:21280
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231548AbhFBOO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMwu/gcNpjuLadBNkTEq0R08Dj8uy397nP71/jytuK+Mb3qScox6k6J/E7wD2ihYj9ietwXydw0V5ZsihL/7tRrDuCCh6Q3vhrlybKQ26urXTGzNkYydaxUFnQld4QUuMAeSHf1sbHAc+fcS7BNxZTi39s2i5a5+Rl0+u5W76GWW7+NTkQxp4UpJ8bKILXwogiDg/kZArC9sgUmjK12uxDkX3gvGmX/O17+kqxE10U8gYh+XQY15S8bN7IXM6PlhXQxURKcAxSKTfox5YTU5B7hfxkZFO3/Bo1KPMM/IhOU+/RWlKGJM5RhMzWYUIcY1CVtcYUSmSIfWtktabZgbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDsLkHL5aTZaasn23+ED9nFSFLBcECCwr0UJ8Ws509Y=;
 b=FFxa4L/cXUaCHPpICYb+4Ph7wtq01SeBm5l62ydH9tzH3ZeS1RNY7K+Hw8ek0ZP2mCEcgL25VBSEPvTkKar7z3VkJ8zBtr1ILFWhZw5jrOWdD2gBdA1xAiX6yJ3I3Gx27QE6KBq1oM9h03a1SaU6PrRtlzrfMA3+kb3pk7oXiVABqIEpFT843yL7WrixGyutyGO/S5035osjkEMeponp+BbUlUcBBsCTJW+J5KIBYjojhGR6cyf5F7hsnxMDFgioa3kdj/9hyqdDOZB31IAicFBk+gSq5cyZZMvdmDoSeSSJ6rWtJr2ifpGAnqgtIWqtwg/GaUTdxYZfv2qldGKfOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDsLkHL5aTZaasn23+ED9nFSFLBcECCwr0UJ8Ws509Y=;
 b=Q4u1pwJIbI33IvoivrmoPtzdGPcnIXhCxKwcPrr33cILqKIeyUtvM7CigevBUgC0kbZguy1On2NAfWNMeHTFPqhWAYEdhMKL1wmfk6SvX55Ee67ZWl4gNJneqGT02BmHXVKgIwjT5eqp8Yj53OUcYacRQRN4sHzEhZY7IrjvX4M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:38 +0000
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
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 32/37] KVM: Add arch hooks to track the host write to guest memory
Date:   Wed,  2 Jun 2021 09:10:52 -0500
Message-Id: <20210602141057.27107-33-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 183e5096-4d91-4492-519a-08d925d06925
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45742E0E4678F48853AB42B8E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:499;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fq/y53872CXo38W0Q6VlJ24Rugq8nDmFB45crsAielaZXEXi+ZDws8om9FML7UhoDZK+TTaD5cLnwUSgsfX/poC/IhL1H8II1qKLDTBYmiYWxHfGT4XstnTWAavZZNXGQoFzIbqV7qrM2AI3Bn4see5E81cCHQ5YkzafqdSJCDs+8aAT1/IvgtSD6so4SZ7F4C4sHI4gTZ0xm8wm+4rcuT87KKJBYQ2t4/41IYYO8yLyshYzSaq1LPf+0HuqiinOJ3qOU33ad1Ysi1sRbPL+w55nGwoIDnjq23/zHP8vM1CIcDsaf1chKrvtocvSyO4jplOy8/YwXYVJvbM+gQ4GwOF7AuowqVLWnJdJsFgUoBIklo1et2rTVQ2T1FfQhIDTEgu8v2VpCzOxaL0ba8bD7uzND+R6nulwhizqvPVo5o/lCfzNY+U2AXmQaywXQ02KMeF8ZLSURZ8HLNLSN/yEHhq5mZuDTlwBCEVEZ7HNKmMTutcW++Rg9sKSZ/RvPi9f2TqWe4d3Z/ZL+DmKWBf8uQhpBzm55B6K+fyhcOs6tZmXpZEO+AN9bfKm2w2LutFlgnsG86DSDMev8y21CqSA5Ie32bz5yMZ5I2WSZwxIEsw3tojpvlJoHoWfrOGu50JU/YmUE4fR8F8cDlMzyNFLTwTUa52G+OmxNjyM5FJW3U5/GfAb6X4Cf8Fxu2hmkPzi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(30864003)(6486002)(54906003)(36756003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tXNI+YrVgG5dti+ZK/+XCi958g6yQE7OLKQZLFcc/ES42JFg5YWBnmh4OJ52?=
 =?us-ascii?Q?+ocE1eGOSFXC1lc7W34xxPHVtT7TzfMaQTeydcUWqQuJCP+GnADSb4nlFlvf?=
 =?us-ascii?Q?hMEjM3lfmuSdc8CScEg0SAHsHzTCCa5/c62IEcJ/1K8i4UuAOyN44NSEUQOo?=
 =?us-ascii?Q?j2XQoOpzwUumpMU/jd2TFwPQE1jPTo0nu7lgMEmPFKixJGSKVz6VodRhe2J5?=
 =?us-ascii?Q?+7bTr3MIrPyUu9FBNNj12ixNPBOY45Ai4eW8PdzRg0uihvcT1gHL6SYB5m5v?=
 =?us-ascii?Q?11AARAsclYoFYT+ZQuB17OYGY49NRsKj2D55bZ7CbeCsv4h7vTOWQcQv7OzZ?=
 =?us-ascii?Q?2iN/oAPE9hjr1FnFP0ziIj4QgEJA9fJImjLam9SLs1a0a7KzYcdnDZMWjWt9?=
 =?us-ascii?Q?QV+Hs1FdteWoPf+1TpXPvEPcLqUH4uEQKvBd6poIvUHwZYDkJrpvBRSDtLVf?=
 =?us-ascii?Q?y/gJcq6UKTwbimgN96nwrZuie9ZWJJVs5XRls0zZ8KzM4Ge+2+wQwNriyg0i?=
 =?us-ascii?Q?R7fVY5RDF+Dbgoxa6Ti1kDD8uZM3k2N9vC0WCZXQbXx4amVc8jIiariTF2SE?=
 =?us-ascii?Q?xNfMpGZngZBLZBcUhOX1cmwps+SvluFPHf1qQL3Yw546SwGWzy8c65ha62GC?=
 =?us-ascii?Q?5Ph96xlGEmFznEEIZ0H42IUWgsebp+Wciei7Er1cksJ1WsXNuJWwG2nUdpdM?=
 =?us-ascii?Q?A/3TGklosXRLmyI2hzz1heqGIcmOwezJUgVxOteVTuklPzN3t8TuGgFYx7oh?=
 =?us-ascii?Q?uz2FJ3z3kG1qZa/lwWpSpBj+wcN7pI11zewSpy8x/RsCHgZVILekuf/6P/ss?=
 =?us-ascii?Q?sGQeWbKDrhXBb7AlIEh4ZX37D3i/EZ9KSLFiAElr+WgS+EuhXL/5h6fIb2R3?=
 =?us-ascii?Q?/pSt4yTrmdoh/ZmFxfN1C7vXORH6IcFjW3zng+vvRDw36ImFgmv6wsBgJUpQ?=
 =?us-ascii?Q?oOLrrKSon26PSJcyVOHdSSPc7y6WR4857owDooslRnAEEpEaDqm8MvZf69Nr?=
 =?us-ascii?Q?PNyIRrmNjrCWU/kL3kviBZlmvsJ/KpPRFUkNpR0NSYGeFnyv+WUP1qt8jRko?=
 =?us-ascii?Q?Rs9uG/GaCyt/DAghGGJ4RJEnRg+QBCcTrLaoYaaZK/J9GQP7quJDbfL77Toi?=
 =?us-ascii?Q?s0Ut1krWK/wECLyU9pv+XxszmYBOIm+qL6bXx56GU5SNuUZjuQhOLMDIZpE3?=
 =?us-ascii?Q?aWKbpq8oqZiM8+iFUbaInG57efl2gta2Pz/swTlWk0WevqpQkIy2E+BJoNPk?=
 =?us-ascii?Q?v1Jjk6kKuyQriYKgThRC8Joqc7mv6lFJ9qNFopq6llU/HbcsWR/cyGK+2Kou?=
 =?us-ascii?Q?v/5adNK6eRi70ZfxCvGZofZ1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183e5096-4d91-4492-519a-08d925d06925
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:09.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKmS2xQ+wfrE6KhpXPeIVku/xu6f6bEVolqP63Jrr1oz9Eavo04eTRHgOcUbDVdjy1pgVvwJjvxr3V59ILldsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_write_guest{_page} and kvm_vcpu_write_guest{_page} are used by
the hypevisor to write to the guest memory. The kvm_vcpu_map() and
kvm_map_gfn() are used by the hypervisor to map the guest memory and
and access it later.

When SEV-SNP is enabled in the guest VM, the guest memory pages can
either be a private or shared. A write from the hypervisor goes through
the RMP checks. If hardware sees that hypervisor is attempting to write
to a guest private page, then it triggers an RMP violation (i.e, #PF with
RMP bit set).

Enhance the KVM guest write helpers to invoke an architecture specific
hooks (kvm_arch_write_gfn_{begin,end}) to track the write access from the
hypervisor.

When SEV-SNP is enabled, the guest uses the PAGE_STATE vmgexit to ask the
hypervisor to change the page state from shared to private or vice versa.
While changing the page state to private, use the
kvm_host_write_track_is_active() to check whether the page is being
tracked for the host write access (i.e either mapped or kvm_write_guest
is in progress). If its tracked, then do not change the page state.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++
 arch/x86/kvm/svm/sev.c          | 51 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  2 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 78 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  3 ++
 virt/kvm/kvm_main.c             | 21 +++++++--
 7 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 59185b6bc82a..678992e9966a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -865,10 +865,13 @@ struct kvm_lpage_info {
 	int disallow_lpage;
 };
 
+bool kvm_host_write_track_is_active(struct kvm *kvm, gfn_t gfn);
+
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned short *host_write_track[KVM_PAGE_TRACK_MAX];
 };
 
 /*
@@ -1393,6 +1396,9 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+
+	void (*write_page_begin)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
+	void (*write_page_end)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ddcbae37de4f..d30419e91288 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2862,6 +2862,19 @@ static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
 	return rmpupdate(pfn_to_page(pfn), &val);
 }
 
+static inline bool kvm_host_write_track_gpa_range_is_active(struct kvm *kvm,
+							    gpa_t start, gpa_t end)
+{
+	while (start < end) {
+		if (kvm_host_write_track_is_active(kvm, gpa_to_gfn(start)))
+			return 1;
+
+		start += PAGE_SIZE;
+	}
+
+	return false;
+}
+
 static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2873,6 +2886,14 @@ static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn
 	if (!e)
 		return -EINVAL;
 
+	/*
+	 * If the GPA is tracked for the write access then do not change the
+	 * page state from shared to private.
+	 */
+	if (kvm_host_write_track_gpa_range_is_active(vcpu->kvm,
+		gpa, gpa + page_level_size(level)))
+		return -EBUSY;
+
 	/* Log if the entry is validated */
 	if (rmpentry_validated(e))
 		pr_warn_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
@@ -3446,3 +3467,33 @@ int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
 
 	return min_t(uint32_t, level, max_level);
 }
+
+void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct rmpentry *e;
+	int level, rc;
+	kvm_pfn_t pfn;
+
+	if (!sev_snp_guest(kvm))
+		return;
+
+	pfn = gfn_to_pfn(kvm, gfn);
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+	if (unlikely(!e))
+		return;
+
+	/*
+	 * A hypervisor should never write to the guest private page. A write to the
+	 * guest private will cause an RMP violation. If the guest page is private,
+	 * then make it shared.
+	 */
+	if (rmpentry_assigned(e)) {
+		pr_err("SEV-SNP: write to guest private gfn %llx\n", gfn);
+		rc = snp_make_page_shared(kvm_get_vcpu(kvm, 0),
+				gfn << PAGE_SHIFT, pfn, PG_LEVEL_4K);
+		BUG_ON(rc != 0);
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2632eae52aa3..4ff6fc86dd18 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4577,6 +4577,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
+
+	.write_page_begin = sev_snp_write_page_begin,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index af4cce39b30f..e0276ad8a1ae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -576,6 +576,7 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..1398b8021982 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9076,6 +9076,48 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
+static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
+			     enum kvm_page_track_mode mode, short count)
+{
+	int index, val;
+
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
+
+	val = slot->arch.host_write_track[mode][index];
+
+	if (WARN_ON(val + count < 0 || val + count > USHRT_MAX))
+		return;
+
+	slot->arch.host_write_track[mode][index] += count;
+}
+
+bool kvm_host_write_track_is_active(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	int index;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return false;
+
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
+	return !!READ_ONCE(slot->arch.host_write_track[KVM_PAGE_TRACK_WRITE][index]);
+}
+EXPORT_SYMBOL_GPL(kvm_host_write_track_is_active);
+
+void kvm_arch_write_gfn_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	update_gfn_track(slot, gfn, KVM_PAGE_TRACK_WRITE, 1);
+
+	if (kvm_x86_ops.write_page_begin)
+		kvm_x86_ops.write_page_begin(kvm, slot, gfn);
+}
+
+void kvm_arch_write_gfn_end(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	update_gfn_track(slot, gfn, KVM_PAGE_TRACK_WRITE, -1);
+}
+
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu))
@@ -10896,6 +10938,36 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
+static void kvm_write_page_track_free_memslot(struct kvm_memory_slot *slot)
+{
+	int i;
+
+	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+		kvfree(slot->arch.host_write_track[i]);
+		slot->arch.host_write_track[i] = NULL;
+	}
+}
+
+static int kvm_write_page_track_create_memslot(struct kvm_memory_slot *slot,
+					       unsigned long npages)
+{
+	int  i;
+
+	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+		slot->arch.host_write_track[i] =
+			kvcalloc(npages, sizeof(*slot->arch.host_write_track[i]),
+				 GFP_KERNEL_ACCOUNT);
+		if (!slot->arch.host_write_track[i])
+			goto track_free;
+	}
+
+	return 0;
+
+track_free:
+	kvm_write_page_track_free_memslot(slot);
+	return -ENOMEM;
+}
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	int i;
@@ -10969,8 +11041,14 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	if (kvm_page_track_create_memslot(slot, npages))
 		goto out_free;
 
+	if (kvm_write_page_track_create_memslot(slot, npages))
+		goto e_free_page_track;
+
 	return 0;
 
+e_free_page_track:
+	kvm_page_track_free_memslot(slot);
+
 out_free:
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvfree(slot->arch.rmap[i]);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f34487e21f2..f22e22cd2179 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1550,6 +1550,9 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
 
+void kvm_arch_write_gfn_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_arch_write_gfn_end(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
+
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
 #else
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..bc805c15d0de 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -160,6 +160,14 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_write_gfn_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+}
+
+__weak void kvm_arch_write_gfn_end(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -2309,7 +2317,8 @@ static void kvm_cache_gfn_to_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
 	cache->generation = gen;
 }
 
-static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
+static int __kvm_map_gfn(struct kvm *kvm,
+			 struct kvm_memslots *slots, gfn_t gfn,
 			 struct kvm_host_map *map,
 			 struct gfn_to_pfn_cache *cache,
 			 bool atomic)
@@ -2361,20 +2370,22 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	map->pfn = pfn;
 	map->gfn = gfn;
 
+	kvm_arch_write_gfn_begin(kvm, slot, map->gfn);
+
 	return 0;
 }
 
 int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic)
 {
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
+	return __kvm_map_gfn(vcpu->kvm, kvm_memslots(vcpu->kvm), gfn, map,
 			cache, atomic);
 }
 EXPORT_SYMBOL_GPL(kvm_map_gfn);
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map,
+	return __kvm_map_gfn(vcpu->kvm, kvm_vcpu_memslots(vcpu), gfn, map,
 		NULL, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
@@ -2412,6 +2423,8 @@ static void __kvm_unmap_gfn(struct kvm *kvm,
 	else
 		kvm_release_pfn(map->pfn, dirty, NULL);
 
+	kvm_arch_write_gfn_end(kvm, memslot, map->gfn);
+
 	map->hva = NULL;
 	map->page = NULL;
 }
@@ -2612,7 +2625,9 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
+	kvm_arch_write_gfn_begin(kvm, memslot, gfn);
 	r = __copy_to_user((void __user *)addr + offset, data, len);
+	kvm_arch_write_gfn_end(kvm, memslot, gfn);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
-- 
2.17.1


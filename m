Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B8736FA96
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhD3Mk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:58 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:56928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232756AbhD3MkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h98DAqboqgVwcXrNXUj5fJxpSryAKpZPGmqyRyHw21ZItU48J9Bph8mqfFCq6eJyIoW0S5ZTMZ4WdsQOhXLwGp6Jm3+Y3AZeYyIJkLAaliIZdalaim6OjHwvsSXurxufYLnTRuusp4q26crAp+q1SycZNeDB6zyoFx0a6R55ijdSiU1J6C2hjBiVZNaok0a/o2SYqITYBfYR0iyNJqsShpczMFYn1SDt5oyBmqnmpqeo/wo6rkNfqDBj6Akbx250VkTJFWo0lmwPvOfKiRzLKYAulNMXIOeR6MQ0lCNqF8nOyQjzd5DoV+YJwRPiQUKFuothioS9c8eI3mX5eDYcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpKNtrI4wPJGS/F2I+MzU2QNP6Jzxn1gV6zI+j2Te4Q=;
 b=c8CDRuHC+x3NhrzxVcmtSesyd/aaCrIHWV4OK5abjj1gMwZAAPKM5heR84jgxbbnhhV9qm9Oi4RYMA4h29EoLnNn3RcvPjQ7J3e1eGXAxwdEp8meRGlKPpsqQ/F+2oIzAdql/FemdkmOUWLebWpyJnSeesT1RvsBdPoVZdTPEkU5kh6zbWrvlGBEv6DsxrsMLhjELSYMCLFZosys4SseWFeqLq5hjkU87xJhqjiw30qcv16WM6n33WBRim84a0jj0WRMk0hql+ONSQlkCAzczzmawdfFwjTdfQfscj1wuh/EcPyTgE875dGiQ6JYebNlO7Yaj2ba/PIb7N2m1ICMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpKNtrI4wPJGS/F2I+MzU2QNP6Jzxn1gV6zI+j2Te4Q=;
 b=OZupImQh3mfIIbLXw5/jsZlEjOmobIJXNxDpxwZN1NYpFeN4Sch81D5TEoiyOsYa2PasQWMwaSthkIKnNG2rxkGJDdjZHTo/A2Ymbfd+9bpurkHX9hpgfRfU4uHBsNwfySWypTo5u32JoFGKkbSQksyv1CCh+4omEP4VPjnLkOA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:13 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 26/37] KVM: X86: Add kvm_x86_ops to get the max page level for the TDP
Date:   Fri, 30 Apr 2021 07:38:11 -0500
Message-Id: <20210430123822.13825-27-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b2d423-bea4-4ea1-0f47-08d90bd4f567
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268888E491714F07FC472B8FE55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqhnBIe8/vyH00zc12uAZKO9rvbNVX67EL9EhCkaL5eX9x0Y3BQutCUoAKaahL/y7TWZqw0dfz21nSpxeI/QwkXQorC93Fi8XCDUX2yJRFSNPvdXS85VvbP3UdaeIMEoBdE/FSF3lebumiIAskxFGaB9Ol7nx7jcQYiC8FVdhs9U9JLGAQXEtOyBaAYEd+iH4GDZQrygZtyKnnRBVhPk4hdZkdZ6/hGAfke/vVR7k4mFNDKjsJ0XyW+fLMUTNfnf1JnQ/Wf5GLfmc2PgqQ5cx9Zc63WfJZB8aZVyeRJpUb2KADER5T3cDAQvus4aPKtTxl0Tsp7GKsRF5fd/j8Gy0c9BT1PGplT62T2IbSHwTq+z4LYeb05y50dRJeyAfo6ekmA9CgNwk81NVwjjuoN9aQhqjYm3/h5QKAPeml8JlqYz6MdIFYnWKPqTfN8WadOD+11TV/qA0YVsLUPEGGHCDIdhfGq9ZrIbMC0erbBktL7KMxqFN/9wKvyRB/GsN2uwxqUg/n6wDNd/SiWku82/6qMbCKMR3Z30MCHVn4nRZMM+hHVs/k5VMmzUvYVW2utT1IV3Ppf6ldIKFJCUaMmSgKadc53JOBSrj10FTKkpZML5q2RCu40JUBXFnu9EIXxIgJcoA6j+pqBpF4aNyb/xnVzr3hrPeIflYUe3rPFlTzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O7xpLd2lvI3kkgFCRZbwDNJpAN6XSs2sHwlS86cdkcdEM5zoK+Ol6r0TDQXC?=
 =?us-ascii?Q?1ZX72yiTHPPmKgOhv/wohI6d35m5GVq2EVh0/6kipR+d5J4HvyZ+FF5relG+?=
 =?us-ascii?Q?rc6RRUpIJNhFv3YT9QNQQxHq/ohEfxZb8zUrvL/1y9BWrE/aQX83bWxJK+M/?=
 =?us-ascii?Q?lrBORWwofSUvz8EtCu52+ZJE2tWpy39dnsbc9D1MuCDYoirKK9sI6kgB/R0O?=
 =?us-ascii?Q?jyrjXLy1WpBi9YMMlONkqSkCVCYXqvEX83CMqTZgJjphiZ9otOWRWmsLJOMP?=
 =?us-ascii?Q?94aO0xIkdLm+xWEjYHuARpZUGwKZ1bJbR9nZiyrEYygvax1sjAL9tAh/Xghe?=
 =?us-ascii?Q?k8S2BOuROTXxQp8yymvwL9CtMWh49ZroCpx6PpRsA3tWkLn95XdpUbEsB6Yf?=
 =?us-ascii?Q?qidQKeRYo3IwcchUZjKnP9TAZ1/L9IMqUlQ4WAqh13X9FJzvD8pX0HJxWMOP?=
 =?us-ascii?Q?7xiSxbynRRbLGuHjUtKxOZzJI7l69C2r8uk5Rhb7kcj1QuIkUCZBlpJ9ksI0?=
 =?us-ascii?Q?XXK+k/3EL3o2Eu8n5HW0Sw9476AWFzuPjj0h5iYDB2o2Zed6b/EBSDkeUK36?=
 =?us-ascii?Q?9hULZhp3biihE6M6isJdSA97im6wSHXCVjj5eGqYDEKcgIts1dcr1ashxdRE?=
 =?us-ascii?Q?RZrPfqLjiQ7eCRwvrOrZpzkBsSElafBbzAIvuHetPM3Iuh7XZMr6rmODHCPh?=
 =?us-ascii?Q?Jaa6x2LII2HPbpr3FXcwNOqDIFE2y6LMvTyfAZjzYeV11dP8XjsLcYS5a+CX?=
 =?us-ascii?Q?jQ7Tmnod2OTrtpAEXorFwe3bJBIFVuG3rUoiaxrntm6iz1Gw8bpZ0GjNEgvK?=
 =?us-ascii?Q?Ezo/2xt6wUqvygnWu3/xD92mIyLzU5typFTLdz++xYeyV2NL3GQK2OXW0vVT?=
 =?us-ascii?Q?lV3126D0GRW6p92XVSFpBMN46d9msW0zZMJcC7sL0hMjQw69JiwW9TfwZn99?=
 =?us-ascii?Q?UFDN8pcSe+9qgv03MZXbII7TaJ/cId4txmrzLs7aNrCU49v65C9jAPAgnr7Z?=
 =?us-ascii?Q?B3nLabDOmtPd8bBCXQC3LnrN+MU7VmdaGifug2knyErb91JqwRNSLvCpBPtk?=
 =?us-ascii?Q?fob6MTTn5jw/RFu7N7SDiIzHK1CQ/eP0afv5RSzVax0Ls9ERdZGylsc3qm45?=
 =?us-ascii?Q?JH8uoRjX1He+eRseWMTgjHT5cxDN9W3LyAX54g0ADwgGDheEZws/Af8aZpwY?=
 =?us-ascii?Q?oZpprxcRU4skLn6JB/23PKgZtCPSgnJAja1UmKNXjWWhGA5qvrV+BT0LjVAh?=
 =?us-ascii?Q?MdGOYufvzMt3uzGYlPDlR8Ld47X2JSZenzB+Wl5Zn7KSZU7IHXjuf35i9lYE?=
 =?us-ascii?Q?bDxKHI6g2OnGDe2CxRgU/ZXp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b2d423-bea4-4ea1-0f47-08d90bd4f567
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:13.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3wHyFisLVhMlV7m16Aq04cN/vExMJTOskaZnxSnyFzZFT56sQrEM05FkglnIJ9DWgw7OXBI9C1JQk/ulACFGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the TDP translation (gva->gpa->spa). The TDP page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

To keep the TDP and RMP page level's in sync, the KVM fault handle
kvm_handle_page_fault() will call get_tdp_max_page_level() to get
the maximum allowed page level so that it can limit the TDP level.

In the case of SEV-SNP guest, the get_tdp_max_page_level() will consult
the RMP table to compute the maximum allowed page level for a given
GPA.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 ++++--
 arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 6 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 71e79a1998ad..88033147a6bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1382,6 +1382,7 @@ struct kvm_x86_ops {
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 930ac8a7e7c9..fe2c5a704a16 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3781,11 +3781,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
+	int max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, PG_LEVEL_2M);
+
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+				 max_level, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3826,7 +3828,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 {
 	int max_level;
 
-	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
+	for (max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, KVM_MAX_HUGEPAGE_LEVEL);
 	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7da24b3600c4..3203abbd22f3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3188,3 +3188,23 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return pfn_to_page(pfn);
 }
+
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	struct rmpentry *e;
+	kvm_pfn_t pfn;
+	int level;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return max_level;
+
+	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	if (is_error_noslot_pfn(pfn))
+		return max_level;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+	if (unlikely(!e))
+		return max_level;
+
+	return min_t(uint32_t, level, max_level);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1b9091d750fc..81a83a7c1229 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4617,6 +4617,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a870bbb64ce7..cf9f0e6c6827 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -567,6 +567,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10b610fc7bbc..6733f1557016 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7670,6 +7670,12 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+
+static int vmx_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	return max_level;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7800,6 +7806,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_tdp_max_page_level = vmx_get_tdp_max_page_level,
 };
 
 static __init int hardware_setup(void)
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801537CAA05
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbjJPNnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbjJPNnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:43:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299C210DC;
        Mon, 16 Oct 2023 06:42:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Spq8igZs7BzUnErvO7nf7PjxENe5cYDkE/ru8OcpzQWsS8AYExfXGmXHIqUj2Z5Q6O2OxcZMKQFXf3l3sqrf1pgGJnbYCztlPqVGX9SHVVXwQzpfnpCJ1rrxNxNPnDhfEFVG8kGFTLDn6oJUi3u6kaRJd6mwNbHZ9pDeDL2WCvf8rwju+9drKOPpQZzmeCOGPUNKnyXW4UGhan6reedu6O8vlLjEScz3VgetbT5hKkNkO3+7F5RfCHQB/iyJZhOUTDjdX1VQ5e24MocaDYEz72n9UR9gQlPb7RWhChLBfNkVjmmcczUVuQHCrPbBEjSlLvB4LEjU7B4yVUOy2G+xfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWWSaTmDjMI9U0l/FGVVcrWjBRDXASnIBVF5pzyJsJU=;
 b=MA35UAigcHPOYnVv6k860C+JbvR6Qx7ge8x2a5oiqNEgZdl+CpcqF3l1/w1KvfvRcEFRtlgFqcgCGJpDg3SNekoDYGZeQV3Kzv97B2B+oEqQE8oeSPdHOieZgpTwERNFsqCCS9AnMK6RO4tliI5rEO+R9XEky1zhOcG+XAz7zfoMimF0UPt+hOnfGyvf4gCFTz69Jc/9odyS7PkNp0PD5BcC1/rPnY6piUTXpbfK031tw4LTTB81s7Uk8YUT+q6MOGe7jN+TiKgxE5/RfV8h4gCutMeXlsZUhVW3hp+6VRkjHcnKtd5TYwdq0WyuxvCbdshX6yMxMDuG3kYxw+kWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWWSaTmDjMI9U0l/FGVVcrWjBRDXASnIBVF5pzyJsJU=;
 b=ZGY6BC6gl/eSbwLcl2DNbMPG9qEmhPF7ZZTwfHTONCwCqWZX7b4KQUU5Syyn5liQ/caDj64iRv0+KtMkobnL/QZc/0xWDs0J/miBmxhTL5Q1AMnWxeBFmKFJi5/dA6cGrXGGCDZv8C3Bvef5EhXOEgnXdcnOJBUB5anzTNE/3d0=
Received: from SJ0PR03CA0002.namprd03.prod.outlook.com (2603:10b6:a03:33a::7)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Mon, 16 Oct
 2023 13:42:54 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::7b) by SJ0PR03CA0002.outlook.office365.com
 (2603:10b6:a03:33a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:42:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:42:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:42:53 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 39/50] KVM: SEV: Implement gmem hook for initializing private pages
Date:   Mon, 16 Oct 2023 08:28:08 -0500
Message-ID: <20231016132819.1002933-40-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DS0PR12MB7996:EE_
X-MS-Office365-Filtering-Correlation-Id: 375ff03f-4abe-49b1-e727-08dbce4dcc87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GQz8LNG1/Ev9LDgD6TSZ3CJ+aab9O+6w5+vH8VzT8JGbyD8D4/m6KJqWl1jyRwfmQBrXalpgbUZftP0ZfO0Gu+mo3TaMjq5flc9r2EW8bjMmgeW3y4B1oW/QnAcbAXpuyvVbT1cQddCmDo9KzdVuACD2l3cSQqMO8olDJvDf7N3lFLxoKuA4r+/nWJtRAK3Gp8UXD2GheH/hbzT+O8IbXMLYv6cjuzTI0sG7iDxfD+nq238ZmRUQfBxr5hRtr0gkWCcCVdbfKXh871Semk7avzAdnPce2OKVzPoFq8FWrzq4s5UNQGoRcMcnuVf2/cwtVZ2OJi754KimVLcb43OP8TTz2XpKKeIl4slRepqKpBgblzUBmkGxq3P0gefXsSMXQB7ZOMcSDl8k13xb1o9J3pVBMnYeEc5arso0zjabdyg3uGNbtAGegUNKdZLzFzKCrMJ7XGJzn5lKp1J0DWxTVdNvAlsQAPaXoO141s3cRHJstN15QJyUdknyApR2gTfX+UEDeczG327CC5G0mGioaFcNiBqeHId46GJUF+bWFgP/m5YOmrAJeHDvc/c4c/C55e9DTSY+ZHWVAStY/ZZYyHuuA54O9av2Om8JnQH9eEbNDCi514eMRgNqL2WHVN6ZPHFJz8LPy5k11VY/mVzP8psbwUnZI3mQgZWW5k6iO02DyyRKzSSKOX8m0l8mh/9CN8LN5NYz5VmzlUBTORen7AeBo2KSafjdlm2lGSDRfFSQygBsUJEYj1EVYgDDVvXr2fVJ+CRGA0vDlnVzXEFaQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799009)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(6666004)(478600001)(336012)(47076005)(86362001)(36860700001)(81166007)(356005)(36756003)(82740400003)(7416002)(7406005)(2906002)(316002)(2616005)(83380400001)(16526019)(426003)(26005)(1076003)(5660300002)(44832011)(70206006)(4326008)(41300700001)(6916009)(54906003)(8676002)(8936002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:42:54.1538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ff03f-4abe-49b1-e727-08dbce4dcc87
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will handle RMP table updates and direct map changes needed to put
a page into a private state before mapping it into an SEV-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 95 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  1 +
 4 files changed, 99 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 71dc506aa3fb..8caf2eb6add8 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -127,6 +127,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select KVM_SW_PROTECTED_VM
+	select HAVE_KVM_GMEM_PREPARE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9c38fe796e00..8cf2d19597b1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4135,3 +4135,98 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 out:
 	put_page(pfn_to_page(pfn));
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn = start;
+
+	while (pfn < end) {
+		int ret, rmp_level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (ret) {
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
+					    pfn, start, end, rmp_level, ret);
+			return false;
+		}
+
+		if (assigned) {
+			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
+				 __func__, pfn, start, end, rmp_level);
+			return false;
+		}
+
+		pfn++;
+	}
+
+	return true;
+}
+
+static u8 max_level_for_order(int order)
+{
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
+{
+	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+
+	/*
+	 * If this is a large folio, and the entire 2M range containing the
+	 * PFN is currently shared, then the entire 2M-aligned range can be
+	 * set to private via a single 2M RMP entry.
+	 */
+	if (max_level_for_order(order) > PG_LEVEL_4K &&
+	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
+		return true;
+
+	return false;
+}
+
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_aligned;
+	gfn_t gfn_aligned;
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc)
+		return rc;
+
+	if (assigned) {
+		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
+			 __func__, gfn, pfn, max_order, level);
+		return 0;
+	}
+
+	if (is_large_rmp_possible(kvm, pfn, max_order)) {
+		level = PG_LEVEL_2M;
+		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
+	} else {
+		level = PG_LEVEL_4K;
+		pfn_aligned = pfn;
+		gfn_aligned = gfn;
+	}
+
+	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
+		 __func__, gfn, pfn, pfn_aligned, max_order, level);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f5cdcbd1ba67..b3ed424533b0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5041,6 +5041,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f81dfa1594f6..c5cee554176e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -723,6 +723,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 
 /* vmenter.S */
 
-- 
2.25.1


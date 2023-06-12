Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8502872B6F8
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjFLExq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjFLExe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:53:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFECB1705;
        Sun, 11 Jun 2023 21:53:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYWJ+BPq3u4kFEGUa3D7tD9gXtCGgsJc5FwFeLskZXsiqIgMMbxYgwcuO4Zd1Jymaxv1ehNAK7P3RoHwKB9ddeYvtIZWDuuWw2P38lceIIdlRvHYNCIFNdkI/3I9/2MsB/44LCANICqA81axkE9oZ/I/gEAl3JRfvF0Tnl7btkGFA+dLPCbLLSqcZT/ly36tOdrEgbDWBVPC5W7bLhMEhHDBe41GJ+S6y+mlfniBPPs4nauND3N7YZ0JHLvA0oM4h55+2uRqESzr9DuWHzstuCcOivI7OuXvMq/yjU3TdGXpPy8XUIQMgFBMLj16Us9M+YB+EvB4pmRICQNgvgNokg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOF0hFPBW7R+0qZTxRk+TtpaZhSYVvpORM/XQ7vmlUo=;
 b=hUZZv7AFFPuRm4j2wJLb/u9JNf6//pH+SMAC1mdfgFe8loZbolvIUQcIzx48n/caDJg7m2gYiRKg5QbNRXyIz8EbaoA/qPBkerW7bEJ/s0QFvbatRvuWZaCGRmUi2sw3t9wP7c5MGz3Cqa+0YjInIXm5Jyu1g1TKTUTvDkQ3lPj/yvZdQOJh5SseSCL0b3rIeV05eIQwIttaBDZhs2WgvMjoZE4Ad4JP2sQs9lDnqr82sNhal6/RGXF2eS4bs3OWMEak/rVdOEqWb9x5C5QNrNS1A8OOdpRqfXZYgXLAUvHir+qntwNhySVrRAY178KOvzFZ+Q6B5TKVgG+TTU5qLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOF0hFPBW7R+0qZTxRk+TtpaZhSYVvpORM/XQ7vmlUo=;
 b=3ZLzc0RVys1/wb7SyxYwo0RmL6rRAugPzCp7YFc+lazIax3sYqYbXyJ6Yu+ZYe1Ju1xbz22ri2YfckYMmT8kW/V87N/GOH4NTX/qc5UrV1OIZxOxM67HUcTtNoO+xGEIRuITzphYGTiFPIVx6K/J6Dgo2glqgY4nKie+bfwW6/4=
Received: from DM6PR06CA0043.namprd06.prod.outlook.com (2603:10b6:5:54::20) by
 DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.42; Mon, 12 Jun 2023 04:53:17 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:5:54:cafe::c5) by DM6PR06CA0043.outlook.office365.com
 (2603:10b6:5:54::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:53:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:53:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:53:09 -0500
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 44/51] KVM: SEV: Implement gmem hook for initializing private pages
Date:   Sun, 11 Jun 2023 23:25:52 -0500
Message-ID: <20230612042559.375660-45-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|DS0PR12MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd15a63-b251-4390-65c3-08db6b00efd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqS0zYY7V6/SXVxsgnGA//ryGTcwnR4TiO8wPG4RvRQbNzIzLJeMo6pkNE2kP4bhaCGYHMtwT1BEclNiqf0CS21osC+D4ag3hGOQllS1GMTBA0DXk/diympqflIZrmRfs4hrutXHit4uRqu8f8nx729JimVp8R7G0CO5OMYP+23hdLakSL0a+cdjys1ak5201JgAuBC7X2ey4Enmkz3jqjRuIuw5NGkEdWKhFBr9s4tZkc07GsP9UeeBQhFthk2rzbeM1cf2lEI8/mOHMrmnorfkF97kj1erwyUUgKtHDcbM4mH4zxeXCsNUIvaN4vYvdhtAdE3gmoPVMY9XQRea6mygrn4WlrDKDck7V8rJNp/ERAOsbf5Xqi9gkRToL7So7JI5kp8adTWwYRUjlOxdc2B/6CTbWqFznejmR0vW8erTl/1gn/9G3rCr6WlkyrGRU7fzQUyye2bM7cJL+vvmWvC3BE+Oi1eshgEjXwJXFQnuKqCvsLVy0oUYkJL7qhAemNdH7vZ5NoLpomRLWDkrtuRLaLxpupOCzyFTZIMKfNSGsplg6LlV230gSF7LvJK2EYN8vn5Xlw/tn2pCQe4H/r2lSb5plEMZ8kcGASNMzlmgntbaACdu4IZAvlN8VrIl2iPhneDaZKgSGrILa6pBjKE4ebVUAEwbA4uiBQt8HhIa0b+6CyCjbBuu9iWk8MkAgdj4VKQT8/1jWrSk05Pq5OOH0L1ncm7Efe3Rof4eZRxaNAfhhaU9VLpSMD+t+LY3Aaw17l84v0ktGzHyI9JKkg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(186003)(2906002)(426003)(44832011)(26005)(1076003)(7406005)(40460700003)(16526019)(7416002)(36756003)(83380400001)(36860700001)(47076005)(82310400005)(86362001)(82740400003)(356005)(81166007)(40480700001)(2616005)(478600001)(41300700001)(54906003)(6666004)(316002)(70586007)(4326008)(70206006)(336012)(6916009)(8676002)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:53:16.9759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd15a63-b251-4390-65c3-08db6b00efd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7771
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will handle RMP table updates and direct map changes needed to put
a page into a private state before mapping it into an SEV-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 95 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  2 +
 3 files changed, 99 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 909ecd90d199..c5a1706387bf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4022,3 +4022,98 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
 	put_page(pfn_to_page(pfn));
 }
+
+/* Check if GFN range is marked private in the KVM/gmem xarray. */
+static bool is_gfn_range_private(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	gfn_t gfn = start;
+
+	while (gfn++ < end)
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: overlap detected, GFN 0x%llx start 0x%llx end 0x%llx\n",
+				 __func__, gfn, start, end);
+			return false;
+		}
+
+	return true;
+}
+
+/* Check that no pages in PFN range have already been set to private in RMP table. */
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn = start;
+
+	while (pfn++ < end) {
+		int ret, rmp_level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (ret) {
+			pr_debug("%s: failed to retrieve RMP entry, assuming overlap, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d error %d\n",
+				 __func__, pfn, start, end, rmp_level, ret);
+			return false;
+		}
+
+		if (assigned == 1) {
+			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
+				 __func__, pfn, start, end, rmp_level);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int get_supported_rmp_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn)
+{
+	if (!IS_ALIGNED(pfn, PTRS_PER_PMD) || !IS_ALIGNED(gfn, PTRS_PER_PMD))
+		return PG_LEVEL_4K;
+
+	/*
+	 * Check that both the desired GFN range states in the xarray, and
+	 * current PFN range states in the RMP table, are conducive to
+	 * creating a 2M private RMP entry.
+	 */
+	if (is_gfn_range_private(kvm, gfn, gfn + PTRS_PER_PMD) &&
+	    is_pfn_range_shared(pfn, pfn + PTRS_PER_PMD))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+int sev_gmem_prepare(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     kvm_pfn_t pfn, gfn_t gfn, u8 *max_level)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int level, rc = 0;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc)
+		return rc;
+
+	/* No conversion needed, just clamp xax_level according to RMP entry. */
+	if (assigned)
+		goto out_adjust_level;
+
+	if (*max_level == PG_LEVEL_4K)
+		level = PG_LEVEL_4K;
+	else
+		level = get_supported_rmp_level(kvm, pfn, gfn);
+
+	rc = rmp_make_private(pfn, gfn_to_gpa(gfn), level, sev->asid, false);
+	if (rc)
+		pr_err_ratelimited("%s: failed gfn %llx pfn %llx level %d rc %d\n",
+				   __func__, gfn, pfn, level, rc);
+
+out_adjust_level:
+	pr_debug("%s: pfn %llx gfn %llx max_level %d level %d assigned %d\n",
+		 __func__, pfn, gfn, *max_level, level, assigned);
+	if (*max_level > level)
+		*max_level = level;
+
+	return rc;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 81b9f4e04a8d..9085a122907c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4934,6 +4934,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e73a58e489c7..0438f52e4396 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -770,6 +770,8 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 
 /* vmenter.S */
 
-- 
2.25.1


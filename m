Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5764D0E2
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiLNUO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLNUMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:12:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F05343865;
        Wed, 14 Dec 2022 12:04:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4hdvMacOIAnfET+zFtZl15GOC+atFcvXM6MNpv2q4DAM7tC+RN/49X6tliHJCsdfk9gyb9GcNvtH+ekd6bTXwKv5rCU462nN3C/jiS98PoXLGKg5JdVemJ57yoj0Zk0w3yQl3d5s+4+AypEXrw8PHU5eR7RnUCaMyWvRoGmeQRODseg6MXcq7VcfSI33agqi+JO8veFx2iECc0NeT6PNvMwL58gE41aAcGNaVPBRoD62+AHwY6JaLCF8bhmlFiuziPGs8kp0LT+eHpFGl7q7acfzLiniYZk0vryOnYulE3qq813rIuVZ9id/Ry7P62TVahhIthAiAMcJwE4VC9b8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Jd4sSlG45whTkhGTHWXjOr2AQ4CCq8eVlab5mMdIrw=;
 b=RmNNC3rGnbpE1qrBUz4UG4RDQPH0Gc/ejw7sdxXlGUd/oSPX5lCcWSzmp3vzI26ptmIrBvrpmz3q9HmML39g4o3UQU0pZ6z8QVYB/uPFnGTgNs60t5MW50QMsv1Et+e3tPfVNcnebVeQ2EB8yW6Ce1MT9PMr1h+ndCq9Ox31icoIvvMcdf3JjpRi86jO78VJ83FM0/rSRVDt4fgOBOIFjSSUTZ/Trt+qthwofsA62bYzWtw52LD/JHcGd3XTztscsnPg59l2eETC1XdW5ya62T+D3wj0jQ4bByyCKLXz+SbtdYUZq1kTre9231Nkpe8gE6SSxpPj0bpRTfKL2nhB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Jd4sSlG45whTkhGTHWXjOr2AQ4CCq8eVlab5mMdIrw=;
 b=q189s+WaF2JnBMQqBmakZs8ZQZVa6gHkQTTjq82ABox97xEODVRjsmy57rGSvO6MqLdiIiGznj9/3ysV/vjg2j4EvK5pbEH91xQrbTb9IJdEq5dbinwPl3GWw9hxDnAA3VcWcnm/zRjQViH0WUdwU0B2mcbnNpGDbT03j/ucVcw=
Received: from MW3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:303:2b::27)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 20:04:36 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::a8) by MW3PR05CA0022.outlook.office365.com
 (2603:10b6:303:2b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.7 via Frontend
 Transport; Wed, 14 Dec 2022 20:04:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:04:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:04:34 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 55/64] KVM: SVM: Add SNP-specific handling for memory attribute updates
Date:   Wed, 14 Dec 2022 13:40:47 -0600
Message-ID: <20221214194056.161492-56-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: 10020b2e-3b6f-44e4-9419-08dade0e6c81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z3a4lW/+Qg1wUTpH0t53K0b3eeXn9mBf0LapCpB2B0Br8warerGU9ogIDW2eVVzVNaBnfCHWnvemo7qY5vPx7LbOL6sByUM3z2g6PMYovZgfXAvvldeyQGtEggbx2Fjq4WqFzVdrLjvMRtuI97GHIY35/vG+E3b8dC1IkRP8LSKYO12aVXUQNsiKJf26qLpitJJDXdcWYy8b1vuw6QYoAItooXBic6fryufNVxb8+uiuO6L7SUPx+2S2/ehO2afagmitvSLtYaJGOP+XEziZHLdBTWZjZr537TWQ2k+IkEcOv0vGRXVmEroyJJX4YZjNBxQJsiT/LsZBzjp0qwMK+jjEtVvW8bWoPsue0qkAA1CS/q9bVL+05VtkE1miXGqNlL+cZDF3dvBS6ioftZLWhXzO2dNwGbIB8Th9dHY72O9S62UHWJIw38EhOCapn8/Qx695qs/mY9zFC8D/A2R9G4KsK0NoLn+neomyaURzbJxygsoQUCe+GbYqW4Pupcjk4h2JDjcyMEyRBuXjk652DIIvy8wobJiqE9RRQAac4waw5xDA/4R4Q7TPPSZ3BauTPs5nTyyhdeurYJd3cX8+n5138C5gq+IVYkwhCD7BAsSOgel+UabaQ8e2s/Fq65o/UPvnKFc2QbPcBRyx+zUl4LQHvUpeWYgATkqQFAooXC4aUcdDmAG1pIghQixyRFMb7V8FpS9LRvHJVpvP1a8B4Wq3sEiTLgeKAqmB4Q62LOM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(86362001)(40480700001)(40460700003)(26005)(186003)(70206006)(8676002)(336012)(41300700001)(70586007)(1076003)(4326008)(2616005)(478600001)(16526019)(54906003)(44832011)(7406005)(6916009)(316002)(6666004)(36860700001)(356005)(81166007)(82740400003)(2906002)(426003)(8936002)(47076005)(83380400001)(15650500001)(5660300002)(7416002)(66899015)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:04:35.6123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10020b2e-3b6f-44e4-9419-08dade0e6c81
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will handle RMP table updates and direct map changes needed for
page state conversions requested by userspace.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 126 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |   1 +
 arch/x86/kvm/svm/svm.h |   2 +
 3 files changed, 129 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2f4c9f2bcf76..885a3f1da910 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3395,6 +3395,31 @@ static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
 	return psmash(pfn);
 }
 
+static int snp_make_page_shared(struct kvm *kvm, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	int rc, rmp_level;
+
+	rc = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (rc < 0)
+		return -EINVAL;
+
+	/* If page is not assigned then do nothing */
+	if (!rc)
+		return 0;
+
+	/*
+	 * Is the page part of an existing 2MB RMP entry ? Split the 2MB into
+	 * multiple of 4K-page before making the memory shared.
+	 */
+	if (level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M) {
+		rc = snp_rmptable_psmash(kvm, pfn);
+		if (rc)
+			return rc;
+	}
+
+	return rmp_make_shared(pfn, level);
+}
+
 /*
  * TODO: need to get the value set by userspace in vcpu->run->vmgexit.ghcb_msr
  * and process that here accordingly.
@@ -4428,3 +4453,104 @@ int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *priva
 out_unhandled:
 	return 0;
 }
+
+static inline u8 order_to_level(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
+			gfn_t start, gfn_t end)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(slot->kvm)->sev_info;
+	enum psc_op op = (attr & KVM_MEMORY_ATTRIBUTE_PRIVATE) ? SNP_PAGE_STATE_PRIVATE
+							       : SNP_PAGE_STATE_SHARED;
+	gfn_t gfn = start;
+
+	pr_debug("%s: GFN 0x%llx - 0x%llx, op: %d\n", __func__, start, end, op);
+
+	if (!sev_snp_guest(slot->kvm))
+		return 0;
+
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_err_ratelimited("%s: memslot for gfn: 0x%llx is not private.\n",
+				   __func__, gfn);
+		return -EPERM;
+	}
+
+	while (gfn < end) {
+		kvm_pfn_t pfn;
+		int level = PG_LEVEL_4K; /* TODO: take actual order into account */
+		gpa_t gpa = gfn_to_gpa(gfn);
+		int npages = 1;
+		int order;
+		int rc;
+
+		/*
+		 * No work to do if there was never a page allocated from private
+		 * memory. If there was a page that was deallocated previously,
+		 * the invalidation notifier should have restored the page to
+		 * shared.
+		 */
+		rc = kvm_restricted_mem_get_pfn(slot, gfn, &pfn, &order);
+		if (rc) {
+			pr_warn_ratelimited("%s: failed to retrieve gfn 0x%llx from private FD\n",
+					    __func__, gfn);
+			gfn++;
+			continue;
+		}
+
+		/*
+		 * TODO: The RMP entry's hugepage bit is ignored for
+		 * shared/unassigned pages. Either handle looping through each
+		 * sub-page as part of snp_make_page_shared(), or remove the
+		 * level argument.
+		 */
+		if (op == SNP_PAGE_STATE_PRIVATE && order &&
+		    IS_ALIGNED(gfn, 1 << order) && (gfn + (1 << order)) <= end) {
+			level = order_to_level(order);
+			npages = 1 << order;
+		}
+
+		/*
+		 * Grab the PFN from private memslot and update the RMP entry.
+		 * It may be worthwhile to go ahead and map it into the TDP at
+		 * this point if the guest is doing lazy acceptance, but for
+		 * up-front bulk shared->private conversions it's not likely
+		 * the guest will try to access the PFN any time soon, so for
+		 * now just take the let KVM MMU handle faulting it on the next
+		 * access.
+		 */
+		switch (op) {
+		case SNP_PAGE_STATE_SHARED:
+			rc = snp_make_page_shared(slot->kvm, gpa, pfn, level);
+			break;
+		case SNP_PAGE_STATE_PRIVATE:
+			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
+			break;
+		default:
+			rc = PSC_INVALID_ENTRY;
+			break;
+		}
+
+		put_page(pfn_to_page(pfn));
+
+		if (rc) {
+			pr_err_ratelimited("%s: failed op %d gpa %llx pfn %llx level %d rc %d\n",
+					   __func__, op, gpa, pfn, level, rc);
+			return -EINVAL;
+		}
+
+		gfn += npages;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f8c480dfa5e..6cf5b73f74c1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4872,6 +4872,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.fault_is_private = sev_fault_is_private,
 
 	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
+	.update_mem_attr = sev_update_mem_attr,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5e7cb0260dc3..5f315225ae4d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -741,6 +741,8 @@ int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
 void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
+			gfn_t start, gfn_t end);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1


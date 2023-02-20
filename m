Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCA69D3B3
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjBTTCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbjBTTCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:02:41 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702E92200A;
        Mon, 20 Feb 2023 11:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO4iwPjKE80tPuL9lmKCM5mmLO6HYbno7n/ituOTvT2gVHkQANMd8w46IryWQS5luuzAGm/Hr4zoRbDWCRXt/zCGDgrAVI0DT7UPYvjqlThakXsJrBNuwEeuyBHh/RY8mu6/QItTj1cqrAcvdVFMRBAryGfb4hQhnTz8JBw+SazuXS7N0H0H3F2jQ9qyNY6Hne1hMvjVtHxiQ1MAyOTQxEjGwQb+k2O+BntlpxLysa9WSngkJHn6B+CFB/3EswOVrlK+73To80VgIaZezWkqKbs0itded8AMav9+nkSjkIQT97VZIf23CfK05d6QGYQ2zkzs9ovdwFK10ydUhKaT8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwZqp+t05+zsG1Vq05f7ztxd34mOR92w8AyhJ0DMD40=;
 b=SWuwQchQyY5W0H+mg/T1qnHk7tpH9CEr1CWsrTVIjFRTDrzrqpPf4YS7IDdT08qPP2z0cC7NW5woF8PLcfbLx1UE06mgFpX+euWGnFXvY4d+szj/7qB6x1EpXjtcjvEPUA7t6s4TCJ3TbHF/aVoaEoV9P/mByCd22Tz1Hht2xnrmLqH6NI2zRSCNjlvRVMRZL5Va7npz+rLrlyJL2YxoHM1uEviLs1YdQDMTSUCTGZbKElbiTtVBSxpci29BtzQCpUbSq79ZUkOUdT1EaIcmGwg4SiKwhcgqFynF+S2b06fPSOLZHOP5tK1cHub8nxSkyHxPJASmzkqO/pEwqVVKxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwZqp+t05+zsG1Vq05f7ztxd34mOR92w8AyhJ0DMD40=;
 b=GZfHlX5EvrGWt1vMCFpgEiJjJxf6LZYxW+1F/tvbbPgKtUOQIsqNCwieNfv1UUboCovFFuSyxW3KpExpm3OAYW8lY7hYjX77rWncS14YvaOQTEA+e0+aKP1+nC33Q8JwsdNXbOz+AWGYLTg21ZgILH/VZtP/p5khO9Bvbzs/+jY=
Received: from BL0PR01CA0022.prod.exchangelabs.com (2603:10b6:208:71::35) by
 DM4PR12MB5939.namprd12.prod.outlook.com (2603:10b6:8:6a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:58:16 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::18) by BL0PR01CA0022.outlook.office365.com
 (2603:10b6:208:71::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:58:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:58:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:58:13 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 48/56] KVM: SVM: Add SNP-specific handling for memory attribute updates
Date:   Mon, 20 Feb 2023 12:38:39 -0600
Message-ID: <20230220183847.59159-49-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|DM4PR12MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc55256-0910-4096-d0fb-08db13746cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBp7NsOjtQRr9r2fumEpdAu2TR9WF4vodunw4ENlL2ILID28X/WPfusVJ37xj3+ktwvUzJe5DP/655UmLFKdVJSlIcWsF16TjWtHGKUVEkWny043koH9hJDr6d0IdnvPe0SHoLbHw4BfNhEyAhSgp39ArmsrNKKfD6EEPMupYkpHZOv7PXCPua6PHZYAu/5T3MtK8b4sqNvMofHg0d/S11Vu8TEbKeLOkihXXz0I86wF71DNWbzYjh1LVijQlGR9cjPZKw1niDGRoDqIEGY+W8lVrROW7SRwz3oOjTDF1WScGjY11i59xfHPitSLgYnfJDjN3o6M1x2cN0JeXjPreqD5A12aOkPavg/TeU9WiLMiQR0DD2PABDKd58TAs1DvOiRoEZa1e9n7G3mTkFOq/XWkZPTMgSdDmbpegjK7SOqlhCnPonTAa488rub51NY1FkoI0S4NCSiNfYTNRUXmtqIMj/3ug1zctR5kHplSAU0wutWTqn6idstZHMIr3z+fZemKhN1J4f5KQinbfdCFwGAnbAljLEUcfW9nDj7RDN3lu6gmOUorYjBCz8ZRPOUs6Y7dKXhCSFUDxSOjl+Nwnflcih3DkM0EUDHMvix+Ai787rblJAxG0ukUCicsCJPEG79NCnEg2G2Veo3dJk3q8zD5r/ryyoLLO4RVG4IK6JpR0B9SmXXXk6NJFT9X2OGDVqbTk3om9EbIWDS/AZVgRRN9p251yCKuK34HB/ZXlNg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(83380400001)(316002)(70586007)(70206006)(54906003)(2616005)(8676002)(8936002)(6666004)(4326008)(6916009)(1076003)(41300700001)(426003)(16526019)(186003)(47076005)(26005)(478600001)(336012)(356005)(40480700001)(36756003)(82310400005)(86362001)(15650500001)(82740400003)(7406005)(44832011)(7416002)(5660300002)(36860700001)(2906002)(81166007)(66899018)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:58:16.0331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc55256-0910-4096-d0fb-08db13746cac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5939
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_FILL_THIS_FORM_SHORT autolearn=no autolearn_force=no
        version=3.4.6
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
index b2f1a12685ed..73d614c538da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3381,6 +3381,31 @@ static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
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
@@ -4373,3 +4398,104 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
 	put_page(pfn_to_page(pfn));
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
+		rc = kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order);
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
index 539926b07ee5..e2edc4700e55 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4860,6 +4860,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.adjust_mapping_level = sev_adjust_mapping_level,
+	.update_mem_attr = sev_update_mem_attr,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 37bd7b728d52..50a2bcaf3fd7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -725,6 +725,8 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
+			gfn_t start, gfn_t end);
 
 /* vmenter.S */
 
-- 
2.25.1


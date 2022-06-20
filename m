Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790F15527FB
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346330AbiFTXOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiFTXN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:13:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F92559D;
        Mon, 20 Jun 2022 16:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCEstPXbifJwrtWR3RGRcXyvTLGiTiZ+xeEGpKx6OcZnZoWceGQLZ8uq1vqZw1Z7qLsVxe1BWJNVZL6QKrTbYLhakJY9OVTX6aPvLObdBn+5FA7b5KQUZkXrzYtdx+iCXxumqHAaJevkIRCvkg7uyiNpvLd7oeUEIC4SDpAjn0vvy6WljmzaD6UKKX/Dgjt2U+SQQgZT7hvcJ1VcOuAsmvmOyVfSISrKjphbPktz5AbUJcFYxDBlk5BNNcgtWh1lHk8plNnFslieadSvh8UkutdoaE6TFeC+0jDP36zzOUUoxe98h5mHIiiq7zOLuOcQBciImTUYezOBGqtR99yDBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK4GZZHa71tsVn0Q7XGYKFjiQP2Ux1FRQtn5tOCzLuo=;
 b=iFtKACm324Eua60OSQAvu6CaM/DncfYdIH7KOC9NWi+mdC2OjOQtg0BUlHkX+D2shKKSNUooFMn3xW6Qxjt1QM41JlDT2tZQwPmYQrWCm2UUbUUh5eBxvJ0sUmfyNU/UN4e5otOcvoM0g6nqyI7kIfwz74CfTBH4G2G14gWHzQ6M9w4PcJW/3RoOpMWmKpdURP5bNmN7lmiuCpFylmTGtXITDmDPq6kfI+ZjgtM6qU78W34+W64hsIVt2yTKTRua3Wh+/2wsPI8GyqSfoWQFYGV3OoTvrCTPMMYJXwB/AZg9hGXOhbUtWFJfmbVjfhRnVHcPJ0h0O3mPztFYJENHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK4GZZHa71tsVn0Q7XGYKFjiQP2Ux1FRQtn5tOCzLuo=;
 b=Tvb4N0GVezFo4CuoGSiErbhhDOS70I5DCd8dwVpfX6zDYnoQVpPJw/4v4dWnqhAtMJAwtZPNrXuy/VUSVcCqO1i9wpU1PqpXvo2ZTA9ggAAQz4AtAoERsNy7RMlGA8TXKb18oUCsqZ5HgqD/EV0Ox72Fmuvhz1yiS2YLf4/gayo=
Received: from SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::17)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Mon, 20 Jun
 2022 23:11:40 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:806:25:cafe::69) by SA9P221CA0012.outlook.office365.com
 (2603:10b6:806:25::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:11:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:11:40 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:11:37 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Mon, 20 Jun 2022 23:11:29 +0000
Message-ID: <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08dea892-46a7-4261-5d49-08da53123ba0
X-MS-TrafficTypeDiagnostic: IA1PR12MB6044:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB6044660E51C1F2190606F7F48EB09@IA1PR12MB6044.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnwavsEsaXZ7nOwa8zZVhxeke3rE9q9EtdbR7v56gfPLD3ZAKdTESs+bbDbxVpNiB2eDy5nE8TPp6gRjbTYl+IaGtZYQ+IK43YZhZxWuVEmldAvvRUwPk6KHb2WITYb23DXkSEMcsszQCypcAnS48gnIPdqvIjBb3kvyp0Wxe/13/cNRSJ5rVxHBzEF3kLiEVxXmWprJsRDOs++wuriK7WKOwhzULD6ofwkHgllzOfN38KZHhEC+7y91U7p4q/SYS4U7vioR98by3QX43hBc+VHL8KWcKuA2/aho7pRkZfhdeO4RsL4YH4h5q0K21/2Mm6KSKVSvESaswOrWDQvEpui8mj0O9CqgSg+YFx53+tcR+35d1uDY03MQePowIhyS1qPcz4OR3gQvg6rAa7cOgBe+wS5ihQm8A+Ls+kripBTkQye8VFDbJfLNBDHdUCcgetOxt3PRYvbMNLZKg0TVqhnrAg0P73joI7e+PD4MEAknlH4dZhYfY4fViOgKzFiPdNaV8LvsPiaB8oD5p3mOvnx7ZyEm83K+UVmlN451eVD/gKi5MPXOE2SQ2tlU9tgBpsCK3C2qqlW4daMemfGKMBgRBuHvNUS1+Kzq8YMGHXBPnAP9QtCEy1XmyAuiA1YBbLWjV7kJKOXqPQwnaO7PLgTkwwWK3PoAzmfjJ138F2mMBHb3TCrnmiWB4S5sQ+3RQ1MS7f/GXzyTbx4ZJAqzSj+wydEHas8TgUcqFwhEachp/voAoLvZ47gkedxgC4kbQAH7gOVBeDb/FofLlSvWcA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(40470700004)(40460700003)(110136005)(40480700001)(54906003)(5660300002)(47076005)(7406005)(8936002)(7416002)(81166007)(83380400001)(36860700001)(82740400003)(16526019)(70206006)(6666004)(336012)(2906002)(4326008)(186003)(26005)(2616005)(478600001)(82310400005)(70586007)(8676002)(41300700001)(36756003)(316002)(7696005)(426003)(356005)(86362001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:11:40.0134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dea892-46a7-4261-5d49-08da53123ba0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

Before changing the page state in the RMP entry, lookup the page in the
NPT to make sure that there is a valid mapping for it. If the mapping
exist then try to find a workable page level between the NPT and RMP for
the page. If the page is not mapped in the NPT, then create a fault such
that it gets mapped before we change the page state in the RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |   9 ++
 arch/x86/kvm/svm/sev.c            | 197 ++++++++++++++++++++++++++++++
 arch/x86/kvm/trace.h              |  34 ++++++
 arch/x86/kvm/x86.c                |   1 +
 4 files changed, 241 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 0a9055cdfae2..ee38f7408470 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -93,6 +93,10 @@ enum psc_op {
 };
 
 #define GHCB_MSR_PSC_REQ		0x014
+#define GHCB_MSR_PSC_GFN_POS		12
+#define GHCB_MSR_PSC_GFN_MASK		GENMASK_ULL(39, 0)
+#define GHCB_MSR_PSC_OP_POS		52
+#define GHCB_MSR_PSC_OP_MASK		0xf
 #define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
 	/* GHCBData[55:52] */				\
 	(((u64)((op) & 0xf) << 52) |			\
@@ -102,6 +106,11 @@ enum psc_op {
 	GHCB_MSR_PSC_REQ)
 
 #define GHCB_MSR_PSC_RESP		0x015
+#define GHCB_MSR_PSC_ERROR_POS		32
+#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_ERROR		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_RSVD_POS		12
+#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6de48130e414..15900c2f30fc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,6 +32,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #ifndef CONFIG_KVM_AMD_SEV
 /*
@@ -3252,6 +3253,181 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
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
+static int snp_check_and_build_npt(struct kvm_vcpu *vcpu, gpa_t gpa, int level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int rc, npt_level;
+	kvm_pfn_t pfn;
+
+	/*
+	 * Get the pfn and level for the gpa from the nested page table.
+	 *
+	 * If the tdp walk fails, then its safe to say that there is no
+	 * valid mapping for this gpa. Create a fault to build the map.
+	 */
+	write_lock(&kvm->mmu_lock);
+	rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
+	write_unlock(&kvm->mmu_lock);
+	if (!rc) {
+		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);
+		if (is_error_noslot_pfn(pfn))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int snp_gpa_to_hva(struct kvm *kvm, gpa_t gpa, hva_t *hva)
+{
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	/*
+	 * Note, using the __gfn_to_hva_memslot() is not solely for performance,
+	 * it's also necessary to avoid the "writable" check in __gfn_to_hva_many(),
+	 * which will always fail on read-only memslots due to gfn_to_hva() assuming
+	 * writes.
+	 */
+	*hva = __gfn_to_hva_memslot(slot, gfn);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 0;
+}
+
+static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
+					  int level)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm *kvm = vcpu->kvm;
+	int rc, npt_level;
+	kvm_pfn_t pfn;
+	gpa_t gpa_end;
+
+	gpa_end = gpa + page_level_size(level);
+
+	while (gpa < gpa_end) {
+		/*
+		 * If the gpa is not present in the NPT then build the NPT.
+		 */
+		rc = snp_check_and_build_npt(vcpu, gpa, level);
+		if (rc)
+			return -EINVAL;
+
+		if (op == SNP_PAGE_STATE_PRIVATE) {
+			hva_t hva;
+
+			if (snp_gpa_to_hva(kvm, gpa, &hva))
+				return -EINVAL;
+
+			/*
+			 * Verify that the hva range is registered. This enforcement is
+			 * required to avoid the cases where a page is marked private
+			 * in the RMP table but never gets cleanup during the VM
+			 * termination path.
+			 */
+			mutex_lock(&kvm->lock);
+			rc = is_hva_registered(kvm, hva, page_level_size(level));
+			mutex_unlock(&kvm->lock);
+			if (!rc)
+				return -EINVAL;
+
+			/*
+			 * Mark the userspace range unmerable before adding the pages
+			 * in the RMP table.
+			 */
+			mmap_write_lock(kvm->mm);
+			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
+			mmap_write_unlock(kvm->mm);
+			if (rc)
+				return -EINVAL;
+		}
+
+		write_lock(&kvm->mmu_lock);
+
+		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
+		if (!rc) {
+			/*
+			 * This may happen if another vCPU unmapped the page
+			 * before we acquire the lock. Retry the PSC.
+			 */
+			write_unlock(&kvm->mmu_lock);
+			return 0;
+		}
+
+		/*
+		 * Adjust the level so that we don't go higher than the backing
+		 * page level.
+		 */
+		level = min_t(size_t, level, npt_level);
+
+		trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
+
+		switch (op) {
+		case SNP_PAGE_STATE_SHARED:
+			rc = snp_make_page_shared(kvm, gpa, pfn, level);
+			break;
+		case SNP_PAGE_STATE_PRIVATE:
+			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
+
+		write_unlock(&kvm->mmu_lock);
+
+		if (rc) {
+			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
+					   op, gpa, pfn, level, rc);
+			return rc;
+		}
+
+		gpa = gpa + page_level_size(level);
+	}
+
+	return 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3352,6 +3528,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ: {
+		gfn_t gfn;
+		int ret;
+		enum psc_op op;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_GFN_MASK, GHCB_MSR_PSC_GFN_POS);
+		op = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_OP_MASK, GHCB_MSR_PSC_OP_POS);
+
+		ret = __snp_handle_page_state_change(vcpu, op, gfn_to_gpa(gfn), PG_LEVEL_4K);
+
+		if (ret)
+			set_ghcb_msr_bits(svm, GHCB_MSR_PSC_ERROR,
+					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+		else
+			set_ghcb_msr_bits(svm, 0,
+					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 9b9bc5468103..79801e50344a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -7,6 +7,7 @@
 #include <asm/svm.h>
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
+#include <asm/sev-common.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
@@ -1755,6 +1756,39 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
 		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
 );
 
+/*
+ * Tracepoint for the SEV-SNP page state change processing
+ */
+#define psc_operation					\
+	{SNP_PAGE_STATE_PRIVATE, "private"},		\
+	{SNP_PAGE_STATE_SHARED,  "shared"}		\
+
+TRACE_EVENT(kvm_snp_psc,
+	TP_PROTO(unsigned int vcpu_id, u64 pfn, u64 gpa, u8 op, int level),
+	TP_ARGS(vcpu_id, pfn, gpa, op, level),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u64, pfn)
+		__field(u64, gpa)
+		__field(u8, op)
+		__field(int, level)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->pfn = pfn;
+		__entry->gpa = gpa;
+		__entry->op = op;
+		__entry->level = level;
+	),
+
+	TP_printk("vcpu %u, pfn %llx, gpa %llx, op %s, level %d",
+		  __entry->vcpu_id, __entry->pfn, __entry->gpa,
+		  __print_symbolic(__entry->op, psc_operation),
+		  __entry->level)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50fff5202e7e..4a1d16231e30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13066,6 +13066,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.25.1


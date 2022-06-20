Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D128A5527D9
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346981AbiFTXLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346332AbiFTXK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:10:59 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF7E25289;
        Mon, 20 Jun 2022 16:09:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SF5RdWBC1T2HcI7S7QOMB9C6/O5obGwM5+/bff9JUSS0WbKEaXnDw0LCX1AEXfI8tS+nXvnzeI//eahgaSlJpL4R0F41JqAQBoQP9CpMfyUn8PHz/ughmA9GLF0e6+7cSXfqthn2IvW6rRMU5JU1X992QhkspgTJm6JGvWhtioAFCF/shXCrpIjjytZFQhlpJQAea3hBZ5kr630rB1JClVZjMw5e95w1N/GWq4qC6TkajAh+vaiTKZozJNBwpakmCF+sj1m7gOvjsttGFYpqAJ6DIdQZk7ET9n+ZeWhGOg/O3VU6u/ENPPTLTlVN5KqI+BplqUeIkvvR6ivwkiOuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0v0N0T8Vf/8XXZjkhhCfupcxoYGhRpo76s0qQCIMLhE=;
 b=NJPQO0u01JZSdZn2UXsoYdKVVEpiH1GV8f73FR1KDdycOxM7n3RcVW5K1obNBnFtiJew4ZdTg70HpjTqB12kHIsMq+LGKTzbtQNG0tkrq6hPjJtbm0kJ2MpHu+stokZT2w1ALUlWwA4VRB72wlFqcUbVAyH0AhNOjKyV5wellmBM3I8Zr1xb4dB/g6PiRlvU1v0ygyyLAwweFmH1DRGpp+aghv/yzAP/2yGCaT2s0Te9Kl5uBIHjh6y38QuqJDp0CcHDIivQP1IGIv5erwqRnb6PmQSu7CpFzZIUL+bItvmxrn3b/wi1zvtcKqcqYb4oWc9dvCkUZ/9QNJ/aWMEJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0v0N0T8Vf/8XXZjkhhCfupcxoYGhRpo76s0qQCIMLhE=;
 b=vYIwyLBsgutCovgsKPgv9tlTA+dCSsWfNl38dsZIwcI3ZnnSk0rFembtVs6mJpHlDw4FspdXPFWsBnUejdAL3pzM1mNDkDJzeTTpu9GCUf3D3R6AlDXKrtg6QIAsn1lM015BmG2Imp1ZOvWSqQlqnD7pwlWDPRhU95gqi7cfUag=
Received: from DM6PR13CA0004.namprd13.prod.outlook.com (2603:10b6:5:bc::17) by
 BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Mon, 20 Jun 2022 23:09:53 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::23) by DM6PR13CA0004.outlook.office365.com
 (2603:10b6:5:bc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.11 via Frontend
 Transport; Mon, 20 Jun 2022 23:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:09:53 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:09:50 -0500
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
Subject: [PATCH Part2 v6 31/49] KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
Date:   Mon, 20 Jun 2022 23:09:41 +0000
Message-ID: <9151e79d4f5af888242b9589c0a106a49a97837c.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e5c5354-123d-43b4-9636-08da5311fc05
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5221B0115BC4126E879228148EB09@BL1PR12MB5221.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsOUCst45OeJ5185T1tVp0ndaRkSr9/VkNgA/eQdXHM+UuMKXZGe+FiS+VzFMF7sSQLNT0ASlg24xayCAUEIxmzgD/Nt/FLPnmWoR0mRwRKuyMOCNwwwJtFHDEqC74+B+YOmbcb8BeAd30LYE1Tf1+Re8MVz1lKV1CmqP6imJ2BleV+mYuFx6x55FMCJ0xQnb9VeTGgxxyIWCYC/3E0Dr9q25IuPu9SW4fpDIqR6bGV+DNbygEUMky60lTTPy/4c9Nvbmmftakm0B135+Vf6bpHvNMcA7wFtHfO0X911LJk9RP7HnUAPKmEgB0+8/pJEHcV0RgKW1T6GHv038nqUM5g4EpCoGFTVQJSi8RwzUPqhLw95K3dZ37BHAFr91Ekp2no2mOxytF/ls+Q3A2+R1qSVYe2d458oxczHZ9TaPkFpBqPM0RMaY+dfojvM4Abvgp5CjH7ZnQi/KSGyAPYjDHXGdZwVerDhEpNnl3pAIC3URPeOgF+ZT/EW+m0+g+YwD5LfQ+Zel0xiCTuLu377UBShCoAu692kv4rpf8MjcNgHZTcCFZiazpEDmIBczzXzoKHyFA+io6vhX0j00/A0qHJrC1idm4VLnyxSHxFUvBffpGsMA4FxRFgTX9ONktWED+O/kFv8XO6cqbcct5XvJXbewDXI/YE1mYc/GNGYAPFTzXTLRdgviGgwDagP2u5nT9dadZBG2tzHRFkNVKkA12H2lThJUuQev7V81wE+PYUDQGo6r4YgLLMRQET+GYsyy99rz4VJDIEoodBH6yZQqA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(396003)(376002)(40470700004)(46966006)(36840700001)(8676002)(2906002)(70586007)(4326008)(82310400005)(186003)(336012)(41300700001)(70206006)(36756003)(426003)(2616005)(86362001)(26005)(16526019)(36860700001)(7696005)(47076005)(40460700003)(54906003)(356005)(5660300002)(8936002)(82740400003)(316002)(83380400001)(40480700001)(7406005)(478600001)(6666004)(81166007)(7416002)(110136005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:09:53.2870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5c5354-123d-43b4-9636-08da5311fc05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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

TDP SPTEs are RCU protected so need to put kvm_mmu_get_tdp_walk() in RCU
read-side critical section by using walk_shadow_page_lockless_begin() and
walk_lockless_shadow_page_lockless_end(). This fixes the
"suspicious RCU usage" message seen with lockdep kernel build.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index c99b15e97a0a..d55b5166389a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -178,6 +178,8 @@ static inline bool is_nx_huge_page_enabled(void)
 	return READ_ONCE(nx_huge_pages);
 }
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 569021af349a..c1ac486e096e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4151,6 +4151,39 @@ kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	int leaf, root;
+
+	walk_shadow_page_lockless_begin(vcpu);
+
+	if (is_tdp_mmu(vcpu->arch.mmu))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, &root);
+	else
+		leaf = get_walk(vcpu, gpa, sptes, &root);
+
+	walk_shadow_page_lockless_end(vcpu);
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
2.25.1


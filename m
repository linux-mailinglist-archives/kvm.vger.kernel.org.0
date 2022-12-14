Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F67F64D0C7
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLNUKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiLNUKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:10:11 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190A93D902;
        Wed, 14 Dec 2022 12:02:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZf2eOmzkNHGp5jgnXa4ZFKd62SLB6lZaOgmxHwiPurbe4tCd3UjAEPMzSSdLOK9siIQ/jR7U+2E8/WXKktMjqS+FFxzAyuqfRqj+8XJX3s4Us+DyRYBLogSvxNcjrB1stIj3CH2x1zrjcgv3Z+8RdvJt/gv3mjg4xZVAi2JgqlhdIWHmjwh76j8Xtb5MVwIXWHkiqVSOsFOnXR3VpbPMuwdc3l5gj7VStALW2HscCrJWwZFcgiQlYfHCIQyuySUrr45cVerolBZblq94JOGcEX3E3zSGwPwol2qJVMG9kgZD85NVXg1+A/FfaezRH3gHa5SOlTjFwtvVAre/j7vRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cUxxQ98/Df0ZZ4W4Ql1QYz2Nc518nF/wDeCqB4P90M=;
 b=DiSOlPHMG8TOIReoOVz/yI/NBqTl6v0BZ/n6UZpClshAS+EoD+79ZLpwkXv/5v0rGvScD+0h4SZSwmOVJdvXTxPCAWYOGNiJK/RoiCwCCz7c/4v/QTDBjaNkTt7wY3diET+mv77Tp3taQm4zDiy4w4pR9wzaWHORbnP7d8iQFsrIuOKfkBJltF44k/29ptqfRSzGOA8yoVA+n0PxiQlqgkjU5EvIqkmi9nXybsMpX99AZ2LDzw2kvw+Y6kDX8hgPK0iOs/+N+4+w7EQv1fgPiv9EfrOJGypja5RMb7k6D3aeuYDOIsKiCsryiamJjbhoUYAt9Gqq5FkLw4WB9KEMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cUxxQ98/Df0ZZ4W4Ql1QYz2Nc518nF/wDeCqB4P90M=;
 b=LzwwiaBR93+2qQ1nvGff6INTs/ZwXe1D23x8OjXI6hh5ZG7vBx2xfYQQEozg6rXl0LM/g3HJLK67zdmHSwv0BStW+tIAGlaKqpa7NYr3bvwfJXDdwxjhB21ZwDmUyQaoE18xIaTc17geUZLklyUoEBvYwX49tgGuMoORkSkjWDU=
Received: from CY5PR19CA0082.namprd19.prod.outlook.com (2603:10b6:930:69::28)
 by DM4PR12MB6133.namprd12.prod.outlook.com (2603:10b6:8:ae::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 20:02:29 +0000
Received: from CY4PEPF0000C970.namprd02.prod.outlook.com
 (2603:10b6:930:69:cafe::f4) by CY5PR19CA0082.outlook.office365.com
 (2603:10b6:930:69::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:02:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C970.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:02:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:02:28 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 50/64] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Wed, 14 Dec 2022 13:40:42 -0600
Message-ID: <20221214194056.161492-51-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C970:EE_|DM4PR12MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f434472-a91e-4234-cf5c-08dade0e2163
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtIzu9W9Pq3pOk4vqJ3WZK3b7uP0pTIlyDtBq4Zwa3Q/s70Y6Ggn8DuqcuMZxUfr7Xfwe5NraJxjQVizG8/6PqOAtqj58E7qirqbtvG0vmHhVnXkOQROuHLouOvDw+8byuWgGtizZWZ2DhJ6QNwIhOiV/dO/5u7dV3WJnHROR6GiYHPboPh7I5UIHVsK7dsH24Rq74xH0mt/Q9alkbX8LZNghBbb9BdhPrvslNcFl+QlkJwrMlaOU9j7/AI8iQXehkej8b6bq4ZOIJegVFPHTuvLNqMcXGQle1dQmlqi/DXpOuMPuuc6ipXiBaOlZn6A0nnaFDj2h469AhpF57l7Aou8d1XxIiCfoNdzKA+yNJXZSh4pkqmiGG+bOh1IE44VgH/WjSISAmIYHtCVbVswKzwwvc9cno7TWqcxfiLFYDdvGZ78IsbAUrzJ+P9obIM0iEuSh/1zHJn6d9PKxbpn4QF+V52OoNw96iB+e4XmlKA36LhVPq5lT0yg0GwhPH9eptuhWdcs86jopUE/7qnlY1TEV6Br9du5QSde3NVL9Y83DrJ6PWbsl8GNuuQCp2HI+6wgOUo0NG12w8zgWSe0awZtgtUWfs/+ODA97qqiyjE2RImoLHA4NqZNI68ZqKN8yGYhRliNTBvAwh4PYNqy4HTWjrk2JwBcBSV9R3Nw3m3HQXyg62KlZCFiRfFTifKV++CWrRvxMOjLgC66DhwN21jCN88dy8B2TeGyk+ZyxBs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(70586007)(36756003)(16526019)(40480700001)(8676002)(426003)(4326008)(336012)(47076005)(70206006)(1076003)(7406005)(54906003)(6916009)(316002)(2616005)(86362001)(7416002)(5660300002)(2906002)(44832011)(82740400003)(41300700001)(356005)(40460700003)(8936002)(81166007)(83380400001)(6666004)(478600001)(186003)(26005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:02:29.6037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f434472-a91e-4234-cf5c-08dade0e2163
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C970.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

While resolving the RMP page fault, there may be cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, zap the gfn range after
splitting the pages in the RMP entry. The zap should force the TDP to
gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f4bb0821757e..15b9c678b281 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1838,6 +1838,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..c94b620bf94b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -211,8 +211,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 25db83021500..02c7fb83a669 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6533,6 +6533,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1


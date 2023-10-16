Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C687CA9E9
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjJPNlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjJPNk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:40:59 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95EA193;
        Mon, 16 Oct 2023 06:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkPRP3TKScjhsW5vBDEjNwM7EYMwKyGYQnlVxRlsqP+HQrlRgr3StCvXlTMjK9nP4ROU2rZ2+dFtYgFdpCp0nYeWpT7j6FhXa4PZJUAkiU4xV7cryFUF3pVn21KCKr9kKhyuWabV3E2bPjZ5SEYmCLpWkF3nVv0QRfmgWKaSYbdS3yvPe5zTn5OXpM+aDJzH+tQIQcKkgODUw+AXTf+s7t4EETHyzDEI6fTboe5maF4/yZupfwQ3YyewzZOIDJmVmhjQ5EIYOq9Wyl8JSnvYrvFA+LQL0OFRI57ECzyroVSibqjWqg7jS/T8PmSXfON6p8DAY7cuY3Nq9DZ4rY0hhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKj6OwdFFKW73cQm+mqVj3AebP/aA4ntoX+PK97Dxi8=;
 b=HHjktoRYFSUfQ6fIlBZBxZR3+8htxTGW6PiJn5cMDTAoGkjIPPwyfYbl/4GFynYzy9SnFEmUXdlXAEuEyk/PoNHdJSQf8LBy1TRMwuhe4ItX8ZQZ5X1+JwfRiRDG+Zkex+cJvj9KX3afu+iE7TxaAq2tDXPToyDkBVsF0YVhHmxu8D5BA9D/UwovheNTeWbtLUWLazoLnvgVhnsNPMy+v4Y/OaVxO7UXm7/e/GqaJS/M0rdax5o/dFKgema0xzcFxKZkC6HPvimjIeDOZrVH47YXCGlieDFA83WOor//mfJFcovoteDkcgV0G4slORfP8hs/1A07LeOq0ImSOF3dOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKj6OwdFFKW73cQm+mqVj3AebP/aA4ntoX+PK97Dxi8=;
 b=yDXLRJwvaAPfpQPTs0fVYZoZCsqwM0sBRQSwb9vb00CiPfscSseMK/P6zDhw1YiTN271iBswU5W5wnaV7T36cLhscJ5JvCg6aOfnpQLPO32YfAhAMn8hOo1R8vKqeOG06nYP2CogyXqoDPNz7YFIKlLVdcuwKp9ieLrAh5XzDlw=
Received: from MN2PR11CA0024.namprd11.prod.outlook.com (2603:10b6:208:23b::29)
 by CH2PR12MB4889.namprd12.prod.outlook.com (2603:10b6:610:68::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:40:52 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:23b:cafe::74) by MN2PR11CA0024.outlook.office365.com
 (2603:10b6:208:23b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:40:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:40:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:40:51 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 34/50] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Mon, 16 Oct 2023 08:28:03 -0500
Message-ID: <20231016132819.1002933-35-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|CH2PR12MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: 44cacf42-17ce-4f79-9279-08dbce4d83cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6Oj7rXSyxI941yFUGCscT2MpwlvnPB9CcWCxh3v0Q8miNwSOuEH6+cSLoUs4ygF1r+ryOBFMQqziCPVTtwalh1gsNByTvj1MbOEc0ycGeXugBOMHeQheSuYjjd/RFwP8gY8FyEH3K6/gsAO0PM4UFAIyouD9GYl08Geky2kWHSlX8s0F0Oo2g34nAmxlIrBvtJfUdQm2Xb6+ay56MwGvnNuMs/9WjGK/o9xqb5a1HHTb0vXI/C4UJDuiqol4+9/fyKcriyrKj/5odOtdr0L/tZ0C3i0QhhbMmvVHAl0rlggmXfAMa1d9tq04xOMGWpSWdJN7//Q51Izsr56mctGkoP0rwnjHOrZamRIRCflNEAbDrXWUIt45xuMaGjzHdVVJXsxrsDdcOVnkLplkQDSj6wrBqYo1ArcQh60HdJF70w6S78otjsEpQiFq2rddsZZZleYnohwQN6bYUfGCmMF++zQWD7iEHLXTmkW2+2SOtLS2tgdJkn67ZvpLHkAc8yU+hclrLi6xscg1BcIPTplB04ZhanEVCql7V/zw8LlPmD5Luzsi2bsoAm2OnmAXcDwG55jvAfI/yayk75dazwMpJkhzLjB+T0UDln85bKAOFx7NMiv8JDbcAq/jzLF4v78Q5wYsebu1aYUEicfsfrAgfuD5G6/0iPgG0h+d3rC32aoDi2Aq1IzYuFB1yBDmhtkCdJgxW1vPc2FuHP8JVsVr0yssd+dVmJWCNNMk6re9c1v3MTdTSU+3dPNUhjXRNLADf4/dOmDE6VRcX4s0wMhHg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(186009)(1800799009)(82310400011)(64100799003)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(336012)(426003)(16526019)(36860700001)(1076003)(2616005)(7406005)(83380400001)(7416002)(47076005)(54906003)(70206006)(8676002)(4326008)(316002)(8936002)(70586007)(6916009)(6666004)(41300700001)(44832011)(81166007)(5660300002)(478600001)(2906002)(82740400003)(356005)(40480700001)(86362001)(36756003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:40:52.1457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cacf42-17ce-4f79-9279-08dbce4d83cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a3983271ea28..b9e783d34e94 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1872,6 +1872,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..40111f4dae9e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -237,8 +237,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 10c323e2faa4..8c78807e0f45 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6702,6 +6702,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1


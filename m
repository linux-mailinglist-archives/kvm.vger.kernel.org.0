Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09BB552804
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbiFTXQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbiFTXO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:14:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C14C2717B;
        Mon, 20 Jun 2022 16:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqwD/r7/D5TCtUR6b5WCm9mT0p9ya+VvJIB6/QPojYE7LQ+1rzZzjpmojc6By8wzwVREpTKSeeHnRnpIt3K+l73MWDEqjva+pBRIZM5/ZbdGVpYKukN7y+2Rk7YdY8mrfQM+JZ1+hO6V/LWNGG0qd3W5bg8yH0YQUEJVQqZ3Z7znykGY/9+7V+6vB8qMSaggjYA61hzpH4BF+rdSVrnNJRgKuP8TWJoS0p896hT6PcBILslgj9QB+or0+RsCchdS7oOl8W3H95Tj7k8bVnSJnPAg8cJfuVkl1UZK98Pi0jiR7J7Llyn772mjFP0vu8LsAArHR0rhs01UHCgkX0Ojig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPUBCdThmrDF2A2VzwtrISb6TK337bHMK+r46ZeP4j0=;
 b=JDmnQfcMj67za+G/yWor2hENIOehEPEKw3nJfZnAG46wYquyJ59HTfXpjmRnf0Z+r+q6Wco77sZaCVtufsPNJMazkZ9WRPH8rmdaNIZs0Aw5AaQ/CT0qjkoWQEP86dPUxPY5KCa09cHaBo/UuG+DynJU06yryS/CibVjdRbzpo+YtO05gKR2Erp/fSE3BLchWiFctFKo3IADnyaMbdW/ZbpkE7g8nJYDJkX/8MI6HtLHjeoMS+7pwXTxyOYpmeH6urFkNEWfh5Mp5rRAeZ6RdI5YobRrOjg82MQsnRXkHs5b683WrNxBrRM9C3u96EmyqBwIoTo7BEZrZ1pv0+oeSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPUBCdThmrDF2A2VzwtrISb6TK337bHMK+r46ZeP4j0=;
 b=dtsoSSXgVPqLlPph/XdDJk3ajoebSL6r/4gkclKtWz3p+gddJZJvze2YltMqNCDCVcWs/Dkvm3vXxLBCHzl3FL/uDTooEbj0z267lFN7pCmcL/5Bipe36ZofG/XuB1JA5xgQWGuD6xZk7KsmG62del6HqQ6S1rnr0u81Y+CApsE=
Received: from BN0PR04CA0156.namprd04.prod.outlook.com (2603:10b6:408:eb::11)
 by DM6PR12MB3113.namprd12.prod.outlook.com (2603:10b6:5:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:12:43 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::e9) by BN0PR04CA0156.outlook.office365.com
 (2603:10b6:408:eb::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:12:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:12:42 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:12:39 -0500
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
Subject: [PATCH Part2 v6 40/49] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Mon, 20 Jun 2022 23:12:31 +0000
Message-ID: <61a7eae7e78923c8aee65b457687a2674ab5f6e5.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 26c39b50-0bb7-4768-6007-08da531260d2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3113:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3113A46DF145ECEF395B616E8EB09@DM6PR12MB3113.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C5BXPUNI8qIDdaQJHnFKTz4/GyArOjeFG3VPlivDxAMNr/qyNWjl4lK/c62yUdML3/Bd1WF2w3k2KK7AXGDIkFfqOfPsiCJDzUgxqwW3WWtxBfoCP8EL5ole12qMZ7huI4pg5nliRfQIbfvm6Jg6zmxV19rbmX6ZeIyUS234R+uoktGr3bMn344AWCZNYs3+2yxn4Do3PQZGwai2lSFJ5yul8+WD0hX4YDOzCuUMkmSzBaOnqffH9xrV6rfK6Tt1QBa+dXy/0MXh/DBqRY4kP19rDPkn8gwSrrR388Zt6QAObpBezGiI2GQNtToj7XryvzjEFmPcZc0CRod1PBZ1eCphzmgODojXelSycxGxdBEflHWKPsEczIrL1FXCHMa2tNW+c4XbugTzC8Q26hpzbYVrGnZUGZB8DBbFDCQEcPYpa1XSufVO8iAjOI48yEP/c+km8m3b2qMAz6KUIjjOxMHgn2uGnsZn6HVd99eU+ceBScT/9chyegQ5xBRV7zKNcdX9GaW7QYVI+7NbnV7StRVogXfZ6i7OOIUU4oAEJYjweGZdBT3Cm+BWBt8kbbms7m1qty58s0A1m42GhnbSx8VgEv83A6aFA5AoNOSbZa9H21vwTtVl7W/XHl+bI962qyiTx/N9Fu9gftOX/kN3IKcVoU+02wDVmsdpGRnO55I8Vnbx6NGyapEEGBTUO558zfQ3E78nnQVwxqs6iP5B/S1CqJcQaNoliUHWrqimu+BVwAh2fcMrJumYLybsoAo8BFdV8C0FWUXHloOSry16aQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(40470700004)(36840700001)(5660300002)(40480700001)(7416002)(82310400005)(7406005)(2906002)(356005)(82740400003)(81166007)(40460700003)(110136005)(86362001)(36860700001)(26005)(7696005)(70206006)(16526019)(36756003)(2616005)(6666004)(478600001)(41300700001)(186003)(70586007)(8676002)(4326008)(54906003)(8936002)(336012)(47076005)(316002)(426003)(83380400001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:12:42.4325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c39b50-0bb7-4768-6007-08da531260d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3113
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

While resolving the RMP page fault, we may run into cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, we will zap the gfn range
after splitting the pages in the RMP entry. The zap should force the
TDP to gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8abc0e724f5c..1db4d178eb1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1627,6 +1627,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d55b5166389a..c5044958a0fa 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -267,8 +267,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c1ac486e096e..67120bfeb667 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6084,6 +6084,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
-- 
2.25.1


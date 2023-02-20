Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39D769D387
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjBTS60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjBTS6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:58:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEBC4200;
        Mon, 20 Feb 2023 10:57:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAgAjzV4VMeH0iOqWX5SBZs+tYoAFaVhM3kd/EuLG0Ps3qWfVeQh2nIXX/q3gia6tClovNmk+7bjGF8PdNfri+VVqwcowR1SOYOWpOkIdJlqJdBFXJbp/qsGaMjE/bDE8Tf4swNkk5yexq6hStMOt6ZMJYzEif4BhSpTg9sM7ANlFcbGUogHOTgSkCXm4fTgfi+YgrPc9uu2cepABT5TD4ND2bYMCQK9It1JPxm3uCJ9U7zhnJZqipWgyY74THa2GBdoeGiuKFsNZ8gSayJUQyNYo0+RsdshYmDqj2qYSKJ0ISXtUFtOEgBp8xp9D90sR6NzvsDZq1/C7xJ2rd/cYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogrA7qde+AG0fiChCB4rPy03CBPWzzR4SjMBo/lrZOs=;
 b=cTgsdCXqJ+Y+YwsEkQGm1CojIwQkH90aSL7ugi+yDMeKOUb24KKj9wG8b7uBqYN6hp88MkDIgigpJLmu7sBZ+bpdt93godtEee+gwbtjTq80RosJkj7BHAMZipN8BjP+DhEBuxJmiOkAt6WHIkrp0Y6s9+xtuNtZUmk8HCDRHpn1m8A/+/PeNFYD/WsALleVKrHd7zHdNjmqTcPVttPqt5AzyoxtzVOqC+gMfJhcsxatxjUGCKNWnkdaXmEBlTUwJ/z+0aECS1bszXl4lEaxjorzxeOZcGD4Hvq62b4nWDxS2qeVU+5gN4VF4mrmiH2PY199DibjE6wfAGwmG9mObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogrA7qde+AG0fiChCB4rPy03CBPWzzR4SjMBo/lrZOs=;
 b=B68GRleYMzew51RJPazcT6+NVSwt8DSDI8rMVbKjyxQ+30+U7mg8M98tqFYSwyUjDXza+YcpZa7Az/6eSSCsm7rO1DZ5QtJleu4LljWWwceOFwqQb+atOT0p1MMZ6itKDOKVDd+Oo6K2zhx93XGI4ak43PeXwd5jL0WnxnRRHRQ=
Received: from BL0PR01CA0018.prod.exchangelabs.com (2603:10b6:208:71::31) by
 BL3PR12MB6428.namprd12.prod.outlook.com (2603:10b6:208:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 20 Feb
 2023 18:56:29 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::f2) by BL0PR01CA0018.outlook.office365.com
 (2603:10b6:208:71::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:56:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:56:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:56:28 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 43/56] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Mon, 20 Feb 2023 12:38:34 -0600
Message-ID: <20230220183847.59159-44-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|BL3PR12MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: 1887d59b-f590-47c6-5bf2-08db13742cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhuUzXdSZdd6QrYrAPkyMFqRvj7kIvk1eIoqcvi69Rlg08ImjdJ7ksG4zlXNc3NWMUtremouWHuxkxyN7ljVnnMMN4jYIgni1FKQOAGntwTc+du+2wSTlhQakz/kT1sbLdhFjOplj/cpzCOosXRvXNAjQUwzN/yaZl2Ne9TvyBYIA7FTf1MdpDirqEmBmkjthgeDmpxa0YEpd+HSwh7RE6mvaHFyN65c69lYQn0BMnnfvj3wYCDrICOS6Zy9abpEU+UhkfbC6732UbOTjwrdvvf2y1NIa5lrbEwtChg3HPo9FAqZ82Mg4t6KiZaB6VRTI09NbHQqNq59zQWcc9m9/h0UdYii+0LNRfqcNDDYLwTRQUQ74CzYLXUhh2x4YLucr/1xH6OkigjXgkHeE3/0z3qEmWPjYhJQrpyPsom1Y0gmc/5bTxbjgLkirN1rdM6IdUSpU/Z2tueDTp6l4zttG6gM8XZfpH306BTrtqqYYp+iomfzzi0QR3jZOczjUhjAyQOyvuO/QeHljOPMezuH+lRhiVR0ROQYjmanvsB2rpnNwDIaIEp7cH0GSgaNQSNVcoLzWE0jb+zrA0KUTMkWpAxSGuhL7fnEiXnhWqlb+sxbXNvesy31zohRA1GHwRr3VYJSPHzMeHlbAUYs8YYV32M0VdLLVQqgIfZlD+Qpt/XYX9zTxMZ7JrckDWhQXjB6DhlFzGF636alC3fKOcMs6bAbLgeAikiwoAdI7Q+Lf00=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(86362001)(6916009)(8676002)(7406005)(47076005)(41300700001)(54906003)(44832011)(70206006)(40460700003)(8936002)(36756003)(356005)(70586007)(316002)(1076003)(2906002)(2616005)(16526019)(186003)(5660300002)(26005)(478600001)(81166007)(6666004)(4326008)(7416002)(36860700001)(336012)(426003)(82310400005)(82740400003)(83380400001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:56:29.3440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1887d59b-f590-47c6-5bf2-08db13742cf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6428
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index d2e1c109dde5..28b01cc7f64d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1845,6 +1845,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 168c46fd8dd1..0afaf8ff2bb8 100644
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
index d8e5254f314d..d7847af3e177 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6615,6 +6615,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1


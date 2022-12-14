Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243B364D0CA
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiLNULT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLNUK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:10:56 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBB43FB81;
        Wed, 14 Dec 2022 12:02:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBM3YpozxvDakSECPZjGpfo9DxLwteVKdxkIpc8aid+2Y3kOcdxobC38hProXV1H6k161wUhk+wWazjps9uoqmUTMbBaSUFBNvoyqqKW6X8R9jTSMEam09aq+yHrSOFxsSfPT0K0453Ky0pzGqtKyKZVBj1qqU66vAgeL3kVc2QXT/v5ERhQyqd96+8YjV+qd7MnucnWsbITyE9ZugjpilPoVCx5CgV0FXQhtb4zMnZVdYlAn+16bBbJN6QWmPm3ftJ+TssTYPRliCzyC9DalsRiEmt9m7xLfWGxkD7uMgeRSHeDZX2F4hcCiNvLxZ8Riarh4o+u+xitidol7dAGbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GV9jzxpLEX7mGVy+3N+X7Yta9vPU6GqxElewKLPQroA=;
 b=VMSZXGXmdjHCCA2x2zXKXFvRQBMvb0fklBTaXVUc8AaKXeXSQvbJ/+vhtnXEoJ9RtAPlMG9S3Ujfcnu3duU1nx/6GbBFvAeSiM38gzJBR2N/OGD8gN5FlYCp7zAYnY1yd+42GRgSJtTL6KbFUV16JzB6dB5TQCa4H9J//Bu/edwhPGFDpXdM8ULspE+qekUaqgQmR9ahcd/qyFnYN6s6wJelED8WSrkSUq2guTGJuPXaQxgzRMSWAZI4DRz30CHkD8qMdXX05yF+Rakp0EVOlwyU/dCw+9HwNztomSOm8NIcyxvippROcBt7hrvIzdurLLsjLfDu5MmOZcuJFc9mZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GV9jzxpLEX7mGVy+3N+X7Yta9vPU6GqxElewKLPQroA=;
 b=XHy5U2T452CNPyfQxz59PrWtZlKUlwidHwikMLEf2hLEO+8kzberFjYdt93GkdR3LTe2F45LSyl+3zhH39uZk+bHa+mHJcz9/DiK9jyXqyQz7QH2e9CKQ+CbyP2ThGbst0cxi5gMGIygdmaiGf3KmIP8dtAU479EN+ORru8DlA4=
Received: from CY5PR18CA0011.namprd18.prod.outlook.com (2603:10b6:930:5::20)
 by CY8PR12MB7436.namprd12.prod.outlook.com (2603:10b6:930:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:02:51 +0000
Received: from CY4PEPF0000C972.namprd02.prod.outlook.com
 (2603:10b6:930:5:cafe::9b) by CY5PR18CA0011.outlook.office365.com
 (2603:10b6:930:5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:02:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C972.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:02:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:02:49 -0600
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
Subject: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Date:   Wed, 14 Dec 2022 13:39:56 -0600
Message-ID: <20221214194056.161492-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C972:EE_|CY8PR12MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b00f74-6898-4706-c809-08dade0e2e29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYKHjiDhfjZgAIIO6CaDgEuzqlM+a0ijPgpwITnXYXNkZBIF8LUPvxXDiCXpYO0HmB7whPXoopeRUX2M88n9z9uc5kNpUiznygg7SqzWp6/0VRsoEKkcI8FWV5HjCwAisMaysrdgHyaj4/jwSyxyg6Jy7uYgsrwdJ6+rLxeoQCS08iesKTPUErjOPhru9Xj70gZz9EF4I0eHJKCluCdNefJhpPiqPJbl/SZVWVziX+yWdB5AteIdpJ88T4OzoXROmzyUI6JDQjeBKVtWNoFEotmbJvABsa5K6vY8HPEDBN99Uo5rzvYDZ/Is+vpoJmUteW2dqEP/Cmk/uWNTFplEGf8WCirig4khz73pbjTqlx8dhtepMEmuHhN7Esqq/b4PBPjjsNktOc+O6kx1P6rDaS0SJXDZc35bbLJeFIFSmkWt+8JFuEH1miIcgToOoI2RuQTJS6jfYR3OTq9JXDXD70wQTyBqNwXDSrJCJ1lDW1RsprmI2ZYyUe7nxUOZpNyMjgly5J0K60noML9BeOAKaAbWlbMwwfz91Yj6n5VzKQcR4TCtO77ifXHdMY5o/lNy4TURDXb2PgTVlhQZwMJJO742+adQo/IDM9djo8rw075TugyEfqZXnh5puG5gmf0RR1r9vXI+p//wXfKZK1eMG7EtoZzabd0llsOfdGG6rOZfGIiM+d+/IFYmFpToHn1BQ0E9wlnkR+0lGY2fzaflNBzoi8xvaJmgY6Io2uVo0Bk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(86362001)(83380400001)(16526019)(6916009)(316002)(40480700001)(186003)(426003)(26005)(2616005)(1076003)(478600001)(356005)(40460700003)(2906002)(336012)(41300700001)(7406005)(81166007)(8936002)(44832011)(5660300002)(7416002)(70586007)(70206006)(4326008)(8676002)(82740400003)(36860700001)(47076005)(6666004)(82310400005)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:02:51.0651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b00f74-6898-4706-c809-08dade0e2e29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C972.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This callback is used by the KVM MMU to check whether a #NPF was
or a private GPA or not.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             |  3 +--
 arch/x86/kvm/mmu/mmu_internal.h    | 40 +++++++++++++++++++++++++++---
 4 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f530a550c092..efae987cdce0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
+KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9317abffbf68..92539708f062 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1636,6 +1636,7 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 	int (*private_mem_enabled)(struct kvm *kvm);
+	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b3ffc61c668c..61a7c221b966 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5646,8 +5646,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false);
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e2f508db0b6e..04ea8da86510 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -230,6 +230,38 @@ struct kvm_page_fault {
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
+{
+	struct kvm_memory_slot *slot;
+	bool private_fault = false;
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault) == 1)
+		goto out;
+
+	/*
+	 * Handling below is for UPM self-tests and guests that use
+	 * slot->shared_bitmap for encrypted access tracking.
+	 */
+	if (IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING))
+		private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
+
+out:
+	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
+	return private_fault;
+}
+
 /*
  * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
  * and of course kvm_mmu_do_page_fault().
@@ -261,13 +293,13 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch)
+					u64 err, bool prefetch)
 {
 	bool is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault);
 
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
-		.error_code = err,
+		.error_code = lower_32_bits(err),
 		.exec = err & PFERR_FETCH_MASK,
 		.write = err & PFERR_WRITE_MASK,
 		.present = err & PFERR_PRESENT_MASK,
@@ -281,8 +313,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING) && is_tdp &&
-				kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = is_tdp && kvm_mmu_fault_is_private(vcpu->kvm,
+								 cr2_or_gpa, err),
 	};
 	int r;
 
-- 
2.25.1


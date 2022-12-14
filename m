Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E90A64D106
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiLNUUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiLNUUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:20:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161ADCE37;
        Wed, 14 Dec 2022 12:08:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IW1LqFlxYaAZcf0tG59JNxLFJwnTJu7ESOecM4DkS5fpX884bakIZsnv0Wzrd3Wpzq+VuCyI88ulo11qM3cNamcV1z3pV9NMbQlcN5t5SMRCnQxDofPGkeIq/ERtCVuId9SPcQsaEhD6aqJGCHie4lU0CodkrIj1gpfLlYqNkemQWwtGHZ9GErLLT5luRE0rk111MNPowPwZXhgnEXJCbxYNEFcki18vSHgbKHfevD7y9XcOa6hcCqD1IIbgFIL2qvDHR76RFjJlQj0WR0MLWbmSXZHcsSm7QFZKxDLfrJvbifc153r3cLsU57bccc0Z0rmhYMBWSkLtsQt2f9u1iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PugxjeKUReufCsaUR5iD8KRKurR+tDaJmIsUTovgDI=;
 b=lp/r6lEs3PHiKF/N+d33K6MLeiMdlsnndLQ+tOieo85pWBIXpXiG1R8JiFWnE4Czj7wCMH2K/B8Yd14PUtE/bSjmcvypdD0hjr6Jh8ocwhYM9LqyjBOf/tLbm/mXmsrVHLL9Hxsl4rJQYA4Yqr+uOAZkB14JxOAUWBhR9ztSye7D1Ak+Nt/U5c8HpxUP1y/AjeWlMyRZU9x2/yvuvQwF/63sMgzsTqBt+auB176V5AyMrR41qQOJZGw5KAkJYrQ6KvRIIfrp6M6u5Zrha7/GBgIPSXRBPLXuk/WwRlZGom1kIlBRLB7n0ahu4kV21n076Fe2dRBVmuutO4IUDR2eNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PugxjeKUReufCsaUR5iD8KRKurR+tDaJmIsUTovgDI=;
 b=1sNyg8++djEc+T5MQZld18lcz2OhVnwGmcOxKHz46yWWZ2Oo8FEoL3aoDHXZYGJiHCJ7v3XkCXtC6IX72f3q2p9RqEqewnowPErBeuT6TtqvIqNi4MYd6F3pSsSO2GPwcYpPidcZtLobK048Pd4iAZ7WjT+j3S5CEG8vL/rI1AM=
Received: from MW4P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::25)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:08:27 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::82) by MW4P220CA0020.outlook.office365.com
 (2603:10b6:303:115::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:08:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:08:26 -0600
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
Subject: [PATCH RFC v7 06/64] KVM: x86: Add platform hooks for private memory invalidations
Date:   Wed, 14 Dec 2022 13:39:58 -0600
Message-ID: <20221214194056.161492-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT044:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f862d7-ab99-45e8-cd93-08dade0ef6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+y53TCxwyYfogXia3NgoNVSRPB5gpXUDeGtMMpLuFuVX0+hghRKLh7LJYPVurhKQFbm1cbkNerVh9y5RgwlBZ7IW+p68ZzhIeIMIJc9hrfVvrw3Lg0GUYfPwayMZ1NYJIJRNAhI7Pyk377XDq5shB5Sj8AMN2OtuoGvypoIXI9rQb/jEN46vPIWuqptorgONyq1n+3tHZsf0JnxxLcF5etB3R/skpyyNAz0mT7uwPiB6VYkuU23z/LHfB0M5rn/9arKU97bHlFyCsdbPFH48Lv1oH8NgYylyVSdMxjDSzNBZGqujp3RyB82olOxhYXYGJ3RpYh6FgF9y32ISswZoBELdexj07YKOLEYbI6BE41u+bXblqpbukUJnOVA8DrQI7O0LOi6qjtL4UIuetRafpliFcUJ5GDoBa0G9OFWa00Ntio8X885ACX8zTx/qggWZEyjfkCzEcEdX6DEm5IqvRsasERHNxt8GGtf5brQceQ8P2I6zI3bUmJeK5lSvn80FwEeNYMHkkoBSceXn/AAyg4HL8r6VW2PSQF44b2kpONI2ddbE2kczlaJ8k6r3JsDwjKiKUln/WwOyJ4MKT4mCmp3Z0zwFQLwtmiC2W9S2xRt1NcaAbQ/eU9SQkZnYntCggybhSl4Cq/KH9Gt9sVCeRwKJ4eOySh8wNdF55yTFbp9krr5E+szR0NMKzTP2C0eHhqvh66QumAk7RzyDAMtOStxunEs63Vc2zw7tnzL7fk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(7406005)(81166007)(356005)(36860700001)(86362001)(5660300002)(40460700003)(478600001)(7416002)(40480700001)(41300700001)(44832011)(6666004)(6916009)(8936002)(70206006)(4326008)(83380400001)(54906003)(316002)(47076005)(82310400005)(186003)(26005)(336012)(1076003)(70586007)(2616005)(82740400003)(8676002)(16526019)(426003)(2906002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:08:27.4499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f862d7-ab99-45e8-cd93-08dade0ef6ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Add hooks to wire up handling of this sort to the invalidation notifiers
for restricted memory.

Also issue invalidations of all allocated pages during notifier
unregistration so that the pages are not left in an unusable state when
they eventually get freed back to the host upon FD release.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             |  5 +++++
 include/linux/kvm_host.h           |  2 ++
 mm/restrictedmem.c                 | 16 ++++++++++++++++
 virt/kvm/kvm_main.c                |  5 +++++
 6 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 52f94a0ba5e9..c71df44b0f02 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
+KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 13802389f0f9..9ef8d73455d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1639,6 +1639,7 @@ struct kvm_x86_ops {
 	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
 			       gfn_t start, gfn_t end);
+	void (*invalidate_restricted_mem)(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a0c41d391547..2713632e5061 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7183,3 +7183,8 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 		kvm_update_lpage_private_shared_mixed(kvm, slot, attrs,
 						      start, end);
 }
+
+void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	static_call_cond(kvm_x86_invalidate_restricted_mem)(slot, start, end);
+}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f032d878e034..f72a2e0b8699 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2327,6 +2327,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    unsigned long attrs,
 				    gfn_t start, gfn_t end);
+
 #else
 static inline void kvm_arch_set_memory_attributes(struct kvm *kvm,
 						  struct kvm_memory_slot *slot,
@@ -2366,6 +2367,7 @@ static inline int kvm_restricted_mem_get_pfn(struct kvm_memory_slot *slot,
 }
 
 void kvm_arch_memory_mce(struct kvm *kvm);
+void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
 #endif /* CONFIG_HAVE_KVM_RESTRICTED_MEM */
 
 #endif
diff --git a/mm/restrictedmem.c b/mm/restrictedmem.c
index 56953c204e5c..74fa2cfb8618 100644
--- a/mm/restrictedmem.c
+++ b/mm/restrictedmem.c
@@ -54,6 +54,11 @@ static int restrictedmem_release(struct inode *inode, struct file *file)
 {
 	struct restrictedmem_data *data = inode->i_mapping->private_data;
 
+	pr_debug("%s: releasing memfd, invalidating page offsets 0x0-0x%llx\n",
+		 __func__, inode->i_size >> PAGE_SHIFT);
+	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
+	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
+
 	fput(data->memfd);
 	kfree(data);
 	return 0;
@@ -258,6 +263,17 @@ void restrictedmem_unregister_notifier(struct file *file,
 				       struct restrictedmem_notifier *notifier)
 {
 	struct restrictedmem_data *data = file->f_mapping->private_data;
+	struct inode *inode = file_inode(data->memfd);
+
+	/* TODO: this will issue notifications to all registered notifiers,
+	 * but it's only the one being unregistered that needs to process
+	 * invalidations for any ranges still allocated at this point in
+	 * time. For now this relies on KVM currently being the only notifier.
+	 */
+	pr_debug("%s: unregistering notifier, invalidating page offsets 0x0-0x%llx\n",
+		 __func__, inode->i_size >> PAGE_SHIFT);
+	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
+	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
 
 	mutex_lock(&data->lock);
 	list_del(&notifier->list);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d2d829d23442..d2daa049e94a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -974,6 +974,9 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 					  &gfn_start, &gfn_end))
 		return;
 
+	pr_debug("%s: start: 0x%lx, end: 0x%lx, roffset: 0x%llx, gfn_start: 0x%llx, gfn_end: 0x%llx\n",
+		 __func__, start, end, slot->restricted_offset, gfn_start, gfn_end);
+
 	gfn_range.start = gfn_start;
 	gfn_range.end = gfn_end;
 	gfn_range.slot = slot;
@@ -988,6 +991,8 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 	if (kvm_unmap_gfn_range(kvm, &gfn_range))
 		kvm_flush_remote_tlbs(kvm);
 
+	kvm_arch_invalidate_restricted_mem(slot, gfn_start, gfn_end);
+
 	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
-- 
2.25.1


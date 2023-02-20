Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507A569D355
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjBTSxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjBTSxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:53:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD059039;
        Mon, 20 Feb 2023 10:52:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBaFVvxGVzAxIuGvMR7RPhwVAi4M+8L+o6DsaKo5Wt+2sBwUUOeLOsfwm/uXVpCYcJiWOirpfm/F+X343772CAPMdpmG6jYR/EEOld423YP4znDXQ6J7HWlSpjfQSZVVa4BBiERkJ2iM/N/gKLCntCmWHbNMNVBrIgT945PWxWht3DppBLjSbuB2YFg+UYyOi/fy5F9IWQ0kvY2buFuJP1Pg7CmSo7nbU3jyoB38aAYgryTRKoAtNUOLy9villAo10EJpTRLM/2NITfh1FKBYiDD6VufeIS18DQB2y+CHj6Hr1VGJnzd0/r3Hg6q+uH/MJJ5WBqKFWyn0eqQxKZWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nl9ReAu52r8NoHSvqQtO/vhnozQrmzY3lpXAFSgGIA=;
 b=A4ICQ2Egw4E9h1FsFNSL85Xt2SOf0jSeUaWmzWMti0BhKtbbwi9SVtGBTpcVSs/8wgfLJItow86W2S+F3tIdNe7i/iEPGcjr3D7/CgvPtidItjacY7fYGYH7vgTyYhehgLG/idsII4RsM/mOixSUflL1TlNOt4k6JALkSb4hwJ/0LrP8DaMAsINh7tjcKZGUbdpSqoHlqcsXjMnLWHuSC831SVwUtLtZ5eSJMclHxBDYJ78o5upnLDe7hMNk0mf9r9Fnnja1FU/By/5ixUYQ1aG7XzAgDKuPKs+jxoKRTN5tbc5ML7rcRdjlAR2ioTqWcOlEoKUsDLC01zbYfx/rsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nl9ReAu52r8NoHSvqQtO/vhnozQrmzY3lpXAFSgGIA=;
 b=aTeGgX/2/DFuWExk1bptM3xwtYiFj6A73o1BzlLo0jFSHja/si0L/kBUQQZJjzEp1p3F8m6Qj0YzTjpvXO7+hQVs8Lr+fO+T0jTGUYYcCVYrsK+zaHkq9W1htYSpylyxbtrJbfPd9dbplahT+xPTf2gP69ouFV8wzsyY79iuCYQ=
Received: from DM5PR07CA0064.namprd07.prod.outlook.com (2603:10b6:4:ad::29) by
 BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Mon, 20 Feb
 2023 18:51:35 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::db) by DM5PR07CA0064.outlook.office365.com
 (2603:10b6:4:ad::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:51:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:51:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:51:34 -0600
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
Subject: [PATCH RFC v8 02/56] KVM: x86: Add 'update_mem_attr' x86 op
Date:   Mon, 20 Feb 2023 12:37:53 -0600
Message-ID: <20230220183847.59159-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT014:EE_|BL1PR12MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: 829f19a8-d636-4e6a-cf32-08db13737db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4sTWKOgJR4B/cQaq4zDslFBI0FW/VH/CBEeNBvUhe78h8cSEVm+KP+U2KnFQ0wURfOp5ivivfDU2eoAOdyY9hUCC4nlrJydjmxQwGAl0af36spOfJcawVmlki0V/IKU1K2N4ponknT7yJM4RXAv5jbPIASyDkJ6kNPk1ZND0zcLsMDirMqvh18V517BPGk9NhodxnxrTDo+Dk7/U5iBlH3deTRQ0l/O+OA9dJ5riRDiFb8WsbA82BFmJ9nkQLCOv9qaFQIqNXiVH+a4OGtIfvKJ/B+/UNT6kucfBx9gXXQFXPRxXd/pRGHhE7MVeMcy1+d/FmFJNjGxBGmnU92m3VbqZHLVq5EKaiGfD2Ih94m4Klbg42mBgwU4XTFQNFBbOZa9gVnUtMcUYHVn3m8LOlQc2g/9C+tB04Ej/ZwTUfrnsBijEg8AS+rpAvJrkpNwonyBMYV1pimtNAPU4s5coHsFUcZwA9d3Pn0nzxgjcLTi1wkgFV6GJhaZn4XQCvD3u0Zkfr4I7iQdNeX1bOamWuuOSjtBo3Z/1xUmASw+EBr0VKdzjRBsd0o9OXdpbgJyNH2Gs6Zol8h6lAhuci8nbPsh0jASMXms+AR10wFQUbeV5LbuR+ygjIGyT+y3G8/yhQA2B8CA/rQo1V+P7sPnUZ5tuUY9LjWKeyET/YtLC7TzDum2Di0hR08itnh0iTSO9WWruLy3MTcBYwqRnbQKksmCYpYZBCW0joQEhOJADLOc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(46966006)(40470700004)(36840700001)(8936002)(41300700001)(7406005)(70586007)(86362001)(5660300002)(36860700001)(7416002)(316002)(356005)(70206006)(8676002)(4326008)(36756003)(44832011)(6916009)(186003)(81166007)(336012)(82740400003)(40460700003)(2906002)(16526019)(2616005)(6666004)(26005)(40480700001)(426003)(82310400005)(47076005)(15650500001)(54906003)(1076003)(83380400001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:51:35.3247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 829f19a8-d636-4e6a-cf32-08db13737db1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This callback will do any platform-specific handling needed for
converting pages between shared/private.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/mmu.c             | 13 +++++++++++++
 include/linux/kvm_host.h           |  4 ++++
 virt/kvm/kvm_main.c                | 29 +++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 72183da010b8..a8aaf532c2ab 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
+KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f856d689dda0..2da3fb2d5d1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1644,6 +1644,8 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
+	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
+			       gfn_t start, gfn_t end);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fb3f34b7391c..053bd77bbf52 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7251,4 +7251,17 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 		linfo_update_mixed(gfn, slot, level, mixed);
 	}
 }
+
+void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 unsigned long attrs,
+					 gfn_t start, gfn_t end)
+{
+	int ret;
+
+	ret = static_call(kvm_x86_update_mem_attr)(slot, attrs, start, end);
+	if (ret)
+		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
+				    start, end, attrs, ret);
+}
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fdc59479b3e2..d200b8f45583 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2330,6 +2330,10 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    unsigned long attrs,
 				    gfn_t start, gfn_t end);
+void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 unsigned long attrs,
+					 gfn_t start, gfn_t end);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b68574ff6c30..8ec985f1c57d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2561,6 +2561,32 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 		kvm_flush_remote_tlbs(kvm);
 }
 
+static void kvm_post_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
+				       gfn_t start_orig, gfn_t end_orig)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	int i;
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, start_orig, end_orig) {
+			gfn_t start, end;
+
+			slot = iter.slot;
+			start = max(start_orig, slot->base_gfn);
+			end = min(end_orig, slot->base_gfn + slot->npages);
+
+			if (start >= end)
+				continue;
+
+			kvm_arch_post_set_memory_attributes(kvm, slot, attrs, start, end);
+		}
+	}
+}
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
@@ -2602,6 +2628,9 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	kvm_mmu_invalidate_end(kvm);
 	KVM_MMU_UNLOCK(kvm);
 
+	if (i > start)
+		kvm_post_mem_attrs_changed(kvm, attrs->attributes, start, i);
+
 	mutex_unlock(&kvm->slots_lock);
 
 	attrs->address = i << PAGE_SHIFT;
-- 
2.25.1


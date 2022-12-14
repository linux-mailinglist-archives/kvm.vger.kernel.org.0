Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03D464D033
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbiLNTqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237752AbiLNTqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:46:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B513E186C3;
        Wed, 14 Dec 2022 11:46:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=It1ZnRUqJiqFmjSYP23twjCuXhLlF43t3nd7Tyn5LKgIBVmqnKKZstjEhXtTokR0Nlr3Q8CuaIJY0vBNkToiY3iF1HUFqHw6Iuy7MInPubCUhF4prJIEe2YfHTKlu5BLZ8fe6+8Rvzju1ZQuZ5Lv3/sweSPgAUHrgQ6IPSbUbar3BtPemytuX3Kx34ScbuafD/z8vwdsruvMQ9p2A4oQgG0zNOBnO05ISXKQDL1lPXdGeT+k/AkP55xBq5HE3t0qhZXMZtqNdBYqfq9f64hS4BjJeH9uEhh4ZmRGgPteuJbnocWFlDSaEyAXg7nStfvg/3bGHIYL8EZCMJSjOXUACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrawmOQcUfOvXjQ5967mZ3Vgq8NBVT7yFWCyAF6k3c8=;
 b=lIHSnzOUtMmIC0D7RLxzsXUwti5A329DVoMaazYwH2rvItFIre/51GRz5PMDxAePdfi+Q42SYG9XcIuae0EwjiVkCTvr/1594G+EGFME/E/TfxW3HQnnlGvZvVLU2yPcSyRKCcfICquokN9r/qIUcpkUinxjnfT4RwWuyjUqfR+qLyVVWsv6IdgWk2hMinmafnUXU1Hcm9xBncnxCcO5wwQ3Dh7Wmu/BBlI3ioM1LZqYbrIWYJfvtHFJgtwDgtEPWugUBU3eufus90Xqn5oU8ORVisR3hUe5cQgU13PARmH4udX79F+Qlk62VNIHoFUdUyjr4vfrzxfzYthSDQwlOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrawmOQcUfOvXjQ5967mZ3Vgq8NBVT7yFWCyAF6k3c8=;
 b=OeMfWvF9ubeqKey0wnQBXOt5M9XduoYkOw90bAnMW3wYvEE4y0OJWgRPPEL7QYvgHPqhx83CYMu52mJ90r1Ayyif7JAj9823ALMZLPZHmeTkko74xsY2LtoZi5CMm/izPsFYNO5D3Yx58yuQI2d7zfoVSzlmz8VT5lcBQUE4NJ0=
Received: from BL1PR13CA0098.namprd13.prod.outlook.com (2603:10b6:208:2b9::13)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:46:44 +0000
Received: from BL02EPF0000EE3D.namprd05.prod.outlook.com
 (2603:10b6:208:2b9:cafe::de) by BL1PR13CA0098.outlook.office365.com
 (2603:10b6:208:2b9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3D.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:46:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:46:43 -0600
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
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH RFC v7 09/64] KVM: Add HVA range operator
Date:   Wed, 14 Dec 2022 13:40:01 -0600
Message-ID: <20221214194056.161492-10-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3D:EE_|BL1PR12MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: 38003544-7ec6-48ef-62ea-08dade0bee01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NackQYfnOA84fpGzzOnRkBVpOip+ZZl5oXHHpNEk6hqquHntX/F5SMSmLPTFihkCegh1Lpg1WKCPMOcDwbSJ5ah1c9hKJwnUWGvmdgWxsnWX9voGera+h0dMsyvRClpCgOL1T7fDLguEjxfAGDK4lmYlbnZhOL8yqZVxEQJTs3r2CE+z0FAdap6j4Abn4x9KhTgOVe1SWCb5z69JBAUmt7yfBYTusyJvvh7JKlksIA+a5ERom6LFak0cInj048e6eLaY7UCedCKq3NFdDEThOrizEL/1CvZyyksjX5Hv1LLMKKmJCRGGEp52XVkoB+yG+4tv3GYjAU3eo9Yy/XUGx029NRKdmMglt2shsWv3iu3Or/YOwavTw4s1JluqttfmlP+6zAW1j5N3ljQbEebc6u0SQQMRt8jvYvhtGrZnlkuFV9lrWDxpDdeX1PiqJIlc1eXJBInUivnpd9wfoLWOULnseljBeL5k1zml3Pe7welAODqcdWsAAA41/E6Srtd6u6cua3hQNmDGgR+8InQhb1MyckrSlQgHfCbjx+7qoHtjRwjvaS55JA3AYTkl9N2agps+OM0R7yhHHK9Jac6SW5z7WuTIuex9YepkXiaRSfU6mezPab3Ji9Wo7ut0S64MaQn2t+205SxOkbpZYz2Dixa981Ydh7Lv3RThGPYdKScyJU6lpFiMVR/l0sk6aj/zdVduYR+0yv2H3cRjwqvltbneawFwbOpZsPWf7SPRGIE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(81166007)(44832011)(83380400001)(5660300002)(478600001)(36756003)(186003)(2616005)(47076005)(356005)(40460700003)(8936002)(70206006)(8676002)(1076003)(41300700001)(82310400005)(7416002)(16526019)(4326008)(86362001)(70586007)(7406005)(336012)(26005)(40480700001)(36860700001)(316002)(6916009)(54906003)(2906002)(426003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:46:44.4483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38003544-7ec6-48ef-62ea-08dade0bee01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

Introduce HVA range operator so that other KVM subsystems
can operate on HVA range.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  6 +++++
 virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 43b5c5aa8e80..21a539ab17f6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1407,6 +1407,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
 
+typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
+				struct kvm_gfn_range *range, void *data);
+
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+		unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2306ccf9ab1..4ff7adaf6c56 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -700,6 +700,54 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	return (int)ret;
 }
 
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+		unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
+{
+	int ret = 0;
+	struct kvm_gfn_range gfn_range;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int i, idx;
+
+	if (WARN_ON_ONCE(hva_end <= hva_start))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct interval_tree_node *node;
+
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot_in_hva_range(node, slots,
+					  hva_start, hva_end - 1) {
+			unsigned long start, end;
+
+			slot = container_of(node, struct kvm_memory_slot,
+				hva_node[slots->node_idx]);
+			start = max(hva_start, slot->userspace_addr);
+			end = min(hva_end, slot->userspace_addr +
+						  (slot->npages << PAGE_SHIFT));
+
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_range.start = hva_to_gfn_memslot(start, slot);
+			gfn_range.end = hva_to_gfn_memslot(end + PAGE_SIZE - 1, slot);
+			gfn_range.slot = slot;
+
+			ret = handler(kvm, &gfn_range, data);
+			if (ret)
+				goto e_ret;
+		}
+	}
+
+e_ret:
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return ret;
+}
+
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-- 
2.25.1


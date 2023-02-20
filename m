Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DF69D3A9
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjBTTBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjBTTBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:01:12 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955A02203B;
        Mon, 20 Feb 2023 11:00:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPitQX6gDSmqWlWvXdX2eJFfC+6cQ5XhdkL0cbdcgmS9tWyaWEFMGHICcnyFqhJ5GWUZqICPF58gIPFLQhtFaBJqryygL3H7myLsk2ZwtaaeMqs4+Q5YsNmKzN/OxNUwnbm5rBKp5CE8QtW1Rl27SUzxovUnOTWEuCqIRdkM8U7K22289tQfGIcIT+RF7ZwjZMGklhIu6CwHwZHrdGtcvZcC6s7b6CUGKitbcUq52gyhsIp3yRIS5PfMRfF4XCDTpoj0ButGgBS9YWd/TQW6WstY73KJ1FOsNZ8NeWHAtj4rwSrKL4fhmiXPzI2ynuCndPjTYPh9k53zpabX6Py3Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6t/7MChFwUyyN5VUBnMXSkXPBAhKTwfDsPWfcTbxIpk=;
 b=oH85ROPDiZpiMMEQj1UjAroCMmHzxxcQ5PjE/CvArFQgqreMZTKjxYyn4AeAZuedzo2pZ+iG9nT9E0cRwprsw1gxTm7a6lIhdcm/qfO8mNKgwjKKuwW6c7u2fg7QFgXyWpf44ZGQAV0x3P7qlcufNLWt6UXb+7hfb84XjN+887KamBcZSXQs5efLunQZQJEI9tgyubwtsfKFpCluWAZuQv5lWhhNYdSJGXYT4JkivIwIQ7ST/YhBfTWwZ/32bed0N92f6H1fz8yRqy0ZnFKVf37YqpgkVRK9Gi0v/aGotUihGHnLRzM2RslK36Zq9VY0qAfc8qvCQ3oUcpwWh5kDuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6t/7MChFwUyyN5VUBnMXSkXPBAhKTwfDsPWfcTbxIpk=;
 b=E4/m7VpOW/Y7wDCHcV89YgAv/D9G8DparRV5J+1NqjbiFxvjOeRnRavQFrwFe6d54kDjmKUoWzQrBnU/znqEC6y2Us+wRJpb/hL29mAwnc99TJ/dx9CMT/Pda0owReCzryZvVtwer0wjFiEmE4W5+2J6Rqgq4oEUA17br1dNN88=
Received: from MW4PR03CA0277.namprd03.prod.outlook.com (2603:10b6:303:b5::12)
 by DM4PR12MB5376.namprd12.prod.outlook.com (2603:10b6:5:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:59:17 +0000
Received: from CO1NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::1e) by MW4PR03CA0277.outlook.office365.com
 (2603:10b6:303:b5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT080.mail.protection.outlook.com (10.13.174.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:59:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:59:16 -0600
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
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH RFC v8 04/56] KVM: Add HVA range operator
Date:   Mon, 20 Feb 2023 12:37:55 -0600
Message-ID: <20230220183847.59159-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT080:EE_|DM4PR12MB5376:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c479bb9-eb77-4ba0-f8c2-08db13749115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hETg4WBeDpvBCTOlLB3Sjxsx0OINKjiUCj/grgUiBMpB3ZSzcgCuSSXjU7gNJv3G36sA3gEWsqvZhKYbuaiO1tK/lsZQe2hmab9rsWR0MM2gCA/cTM5+dYrAbRCUTH+qRCkQJ5R8IIq7dLlMf3lKPzL/lZmfZIAQv6faQ0aYDMdOhjBds+4aIe7dQALDb5Ge8k9iypWjYBpfNNNFIsxTpfLCKpt5MkssniaoHFmf/FeD5ePuC2hw1AOwGnOLgonWfOf/op+HswbS4Rt7V1xfrr3I5eCH9BvPE0+oN5Y2F39O315MGWYU6ljKgSDKgEm7LUc/lNeRG4ZRiltPabOfz9pnNZSZq8h7qrFoSVktXKVCHvjdP2DBOmNuJXf56kNxpfdkT1NYlczGsD+ksO1K2V2/+cYrunxlzp3o4VmgQAtZOsGPNBz/Yb8AVa+QY7fhxOCblpGG2BGmXU5FR+Z03sxPcm3RbHa+ObdHi5uGGejCg946K0OFNlxiyEqiMzjgMexmJfgGKOsealqB0pR7+5xakXODUU2+jHKeOaNSLLnUxiIkBzlPgXBsYJk0TLWwMf5xmakuz8lQ4Cd37/MsYTGkuv1y9fBEjMCPLKNjO3kJ37ngH+7UtEwwos7T9YvS8AGIJ3WbsRuZSOiV40cuWN/M5d2KJunCjJgsrtE4qw7dClIUWD0P9K1CTD7Mq2TxFtKi7/YgQUd1WEp2RjQC2RyZ7EpdyZ+EdWRB87sLsFA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(46966006)(36840700001)(36860700001)(356005)(82740400003)(86362001)(36756003)(81166007)(7406005)(7416002)(5660300002)(6916009)(2906002)(4326008)(8936002)(8676002)(70586007)(70206006)(40480700001)(41300700001)(1076003)(82310400005)(2616005)(186003)(26005)(83380400001)(16526019)(336012)(47076005)(426003)(40460700003)(54906003)(316002)(44832011)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:59:17.2608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c479bb9-eb77-4ba0-f8c2-08db13749115
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5376
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

Introduce HVA range operator so that other KVM subsystems
can operate on HVA range.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[mdr: minor checkpatch alignment fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  6 +++++
 virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d542060cd93..c615650ed256 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1402,6 +1402,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
 
+typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
+				struct kvm_gfn_range *range, void *data);
+
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f7e00593cc5d..4ccd655dd5af 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -642,6 +642,54 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	return (int)ret;
 }
 
+int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
+			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
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
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		struct interval_tree_node *node;
+
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot_in_hva_range(node, slots,
+						  hva_start, hva_end - 1) {
+			unsigned long start, end;
+
+			slot = container_of(node, struct kvm_memory_slot,
+					    hva_node[slots->node_idx]);
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


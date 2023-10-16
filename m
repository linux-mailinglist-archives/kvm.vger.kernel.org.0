Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D044B7CA9BE
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjJPNhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbjJPNhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:37:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A2010DA;
        Mon, 16 Oct 2023 06:37:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm2Jz1hxXXpdCgo4lxq3To1U7QMcg144teFGCS6C2/rgsfHUwpIdxNMVb0iwk9yNM43JoETrbRje8kpkebmS1G+iN8mNeGxolhEdkKbR0hdDx9KoxYzeH6R6o4Et+5/LxrZBgg55fdtAQRpQL0aZlCSx+oEgxlA336VAlMh7jJSOMkDXNUY2Q1AomJZHO7K4QZVvA5wC+TQpAQkUWjkk2OOujIgnxz4TtgrZThME0U8VHfRte9MoBDSZEkHOgTJKfrJ5yEWkfzTO+A/rNIDowVpu3PrdxgRoM+m7JA/WkZhjSqGzPwCQOt4vRgjjV12j85e5IufzmIYku1dAzKXYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttCY0PAjCssr2vk9Ijn11yJMsq141/jWm+U/FbPX6KA=;
 b=Wbs6XCSPjkamkkLEh4PB9AQIwd18+9tusvlkB8Q+OEQdiBWX+FjsjeXKA5MbNXi2+ffMsJpdy5Zj5jwKvrdOKgySFYixZ8Lx6o6gQvugzrlbdb15Q+6JVnw1zJ2ba5I2HYbY/2FpbYQZEUQx4Y82rYo60PVRXdBWT1J3DdDbee5qndtWWebQ5FuwqQfErHU1gL6A+kCamAVKmEpvgrRSYH5O7EF8Yg0LTqZX2TD8CsKfkJTUonYX1YWLYxFcuY51E1dch++CKMjanALNoKlbDAhc2/08QfFlBsuH6INo7g1bEnkmKSN1Lf0DWLKU4f2CL5TEJXr8eD07QVqB5UAVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttCY0PAjCssr2vk9Ijn11yJMsq141/jWm+U/FbPX6KA=;
 b=CY9xfaiHo0BbZpo0FjzC0TQOI9oDCPk+nLrLqZMNDnPETX+ct/YsMizEWWuJdvFioMGz81UwR67bU2Ftpa3KC+GEpEenkIQ7sPWYTN7CtZdoxalfoBHXiQI8HNXcg2zGfib/wVGY86yuZjIHpwKJQ5EVnjFbcyrbXq2jizZwDgY=
Received: from MN2PR19CA0020.namprd19.prod.outlook.com (2603:10b6:208:178::33)
 by BN9PR12MB5145.namprd12.prod.outlook.com (2603:10b6:408:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:37:09 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:178:cafe::8c) by MN2PR19CA0020.outlook.office365.com
 (2603:10b6:208:178::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:37:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:37:08 -0500
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
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 27/50] KVM: Add HVA range operator
Date:   Mon, 16 Oct 2023 08:27:56 -0500
Message-ID: <20231016132819.1002933-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|BN9PR12MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 26e67074-72b9-4eb8-8f80-08dbce4cff01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAI9pJtIoZpIAYc2AotSZPmlaEvun0DhmVRr8sGZIROLdfN/8pPu4Q4OwOidJizeNfFT6TqNwkZIQewIBGImIFdKmzwLXTDL7bT+wcdp66nLMjV9QV2nE4KNWXB4Z5PHFiEoIoxNI7NZX1ImpKu+jqJpGHelWWf4hrXhEEggNxhVseww9vixsPeZM58wMCvV4+9YxUyPOSCUcrfZyT8Y4MZDf2IaZPFcv9FHB3MpaJMhri4iFs6m8WIUoMlNdnXtlMHRhCn1Y/8UlZpk4YJnnn1+LG7ZsfCelYdeB3HnU1kByEIgHTX+8qWuTbk5OV0HGKDoQRaQcB+pPY5P72yDKSr5gmnouMotPudqbJ4C7uiocGrbumv2bEgeasb4TTuZmm/EwJ4IBRT90eZJ452VE1bRS8bxRbzeObNWxtv2ONBYvWPX8aMR1FE2cR26kpWtqcmOgombUouIaJGgmnr9foSrq9M8/mA9qD2+l/7htv2iG7Ixd4awGTwmFa/Tw45UKwFlV+ctXWzVAliOk2RqGkikewZWHOidykUYasjEjycPgwkWhxf7jF/5mv4nCe+BWJhRU4LABr9Bmudn15Fj0prjTRhMk8vlDte8O0znYS1oGmcJEjDW6q/NZGpuWOwiGMYmd3mzfFk/KuN10hI/KdPhQIsWj5gST7kP/6bfrzPldye5WX1Lh7vGI3JXcEWVfzkCPCrSxbIpPWVbp0llJy7VNte9YX9UYmiEjHhz5mWOS6yxTgWNnCzoJDw+dCGxV5sRclv9B3gCFnzcV8laRQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(1800799009)(451199024)(82310400011)(186009)(64100799003)(40470700004)(46966006)(36840700001)(40480700001)(5660300002)(44832011)(40460700003)(6666004)(2906002)(1076003)(26005)(36756003)(2616005)(426003)(336012)(83380400001)(16526019)(82740400003)(356005)(81166007)(86362001)(36860700001)(47076005)(7416002)(7406005)(478600001)(41300700001)(6916009)(316002)(54906003)(70586007)(70206006)(4326008)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:37:09.3560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e67074-72b9-4eb8-8f80-08dbce4cff01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 virt/kvm/kvm_main.c      | 49 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 840a5be5962a..f5453006b98d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1431,6 +1431,12 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 
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
index 959e866c84f0..2ad452a13d82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -676,6 +676,55 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
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
+EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
+
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-- 
2.25.1


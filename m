Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E893672B6A6
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbjFLElD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjFLEk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:40:28 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D07C19AF;
        Sun, 11 Jun 2023 21:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPi3DdT2PUo1OlJ+MiySWa7ZyCAQoxHyDwiJLMgT4bFeSQxnVte4gjr0i+o1HDxe0aP+VpSYSRSnwRjnEWPaomvX/JrZ8ScJ25jzj+Z25/0z8kaQijzr+DIJGOVpyjIyWX++k+qX9soDp6REMBGslhbyYbXlA2tw8qnNONScFKkqfX+q9HADKUXXtfNgl9uBncwxM3D5PUiYPlkJxhQs9mSh9dJFU6DrMrtNQHhcQzoQIcgnwhlemqVs4mFs/7WqaqpFIoV1UUzB5p3qHAmBFzkrBaRF7H7dzeMMdnhTHiJ+vetHX1SF3yCaqtUj5ALVEKuw+G4C8DC2UTn95P9f9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHNcgb3bW0RGuw2lf/r2QANgbsO2xqcPD/u1M2WbB/M=;
 b=g5mZMjYIulpTeandK60uHJQtTnOPx2LTYje7ns5VW2kwNvuu1C5J046mFjXWw8NPiVMguJ7i2SCNr0txjAq11j2IjVdmA3ucXOv2iQmrdlIm3/MiqWPeiFUgPum8A2qd5UyCwE4mC++jsKwD7RaVDe+CfiHya7RVFFqB08HXUPH53KTf26fO0TUJORabvWJVCKPYA31HBsSa+wo6WI7kzm9nH1zidZtgTuDip/nppgdiMg7CyY6sI3nI6D05KMrNc4Wk9tXOdbjDh6ge9pQCSSLppkIBEZeFeKhuvwoja2pyE4ORZEDmadhQ6IfCL3czZHC5+5RTUfjJKTQvlNZ6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHNcgb3bW0RGuw2lf/r2QANgbsO2xqcPD/u1M2WbB/M=;
 b=mWEiunBIUYm5h3yljexd3mZ6hGY0lEc/viKTVhNo5PUPfPqQfwk/s1oCiuc/ofwqfBh2ULiYFslFfrwX0EH8+5YB9WOXz87uO8ITRRibB2Pep9BLdUVqFqAB78fXypfGuReP3nzCKsvRBG4j9bzqa2LFWJaE0FYauBed7atIAeM=
Received: from MW4PR03CA0003.namprd03.prod.outlook.com (2603:10b6:303:8f::8)
 by CH2PR12MB4873.namprd12.prod.outlook.com (2603:10b6:610:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:39:26 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::d3) by MW4PR03CA0003.outlook.office365.com
 (2603:10b6:303:8f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:39:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:39:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:39:23 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH RFC v9 30/51] KVM: Add HVA range operator
Date:   Sun, 11 Jun 2023 23:25:38 -0500
Message-ID: <20230612042559.375660-31-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|CH2PR12MB4873:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e65158f-8517-41a6-9a81-08db6aff00bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /13cltSALSFlfzZt1R+Xu8figwINoNYALkqfZNNREKs963ny4VOWlyKZ3mv8mVuBHneJDOpqFLJKms8nCy38XsAKGVnKoD4L9UbSGDLwILyT4j0RWsblsM7EU8ffvy3hLterW+n8RK3DMEstvcFWrren5+wQOFMRTrWACQOyCq8FAhghYrfZjS1Cy8AxE1FQ5NFKV0O/qSbC9sblYDk9uwP2NgSd0L4kx+hoA3aRdiQbPLMXaeI+6MfjcOINQjNFr5JI4isHSrRzr5473WZ/uYNEODZiw+DqD05enRuCLTA+WU/A2Ylju/8/rK2P92bs8sTbzCNoxwMwHCo/DH/Mv9XAzgZSwbdV0katiImI2WOdErShobcIinGmWEedAbK+J3U2mDRjcJsuvmMaqtVFi0kGazxkuzaJOp1f7V2fSssJVNfjZlBGKHgqJ+qgR04dtiY2QU6wZ4z+p1CZv5qkwqDG3f5L1mIu59omczQBEw4PArEXaAbExfUQCODGfWEbEoKNutLALoqrcmF5TOMffY6cmCymoGNqrfzLJ48K946x3Nr0hQdK/RxSMlnEaM8CO86e4cGVjlqCpoFWTT46K2lydTkKxuK5IiIX8LiNkxIlA5+2ir8w5FxOYiG5Q2xGmEQeCSrFXeWN2Z+km7g7RrA3dqNMRrV14PntUFZERbwiixKrbYcqlz/GVAIHd1Qr/w5nxZu7NLFwW+0Im7iAFo+GHBu7Tm7/31qenbj9+vmrzuxERln+lXJJPfZpyHpvrzmfTmRW453YZR9IUfnuKQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(82740400003)(356005)(40480700001)(86362001)(82310400005)(81166007)(36756003)(40460700003)(478600001)(44832011)(54906003)(4326008)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(6916009)(41300700001)(316002)(16526019)(186003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:39:26.3281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e65158f-8517-41a6-9a81-08db6aff00bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4873
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 7de06add2235..9a9d4141ba74 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1400,6 +1400,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
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
index 422d49634c56..48beffca6b67 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -642,6 +642,55 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
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
+EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
+
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-- 
2.25.1


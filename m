Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A6D7883F2
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbjHYJhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244339AbjHYJhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:37:03 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA2C1FD5
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:37:01 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXF9V6pKpz684JJ;
        Fri, 25 Aug 2023 17:32:46 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:52 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 5/8] KVM: arm64: Add some HW_DBM related mmu interfaces
Date:   Fri, 25 Aug 2023 10:35:25 +0100
Message-ID: <20230825093528.1637-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

This adds set_dbm, clear_dbm and sync_dirty interfaces in mmu layer.
They simply wrap those interfaces of pgtable layer.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
 arch/arm64/kvm/mmu.c             | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 0e1e1ab17b4d..86e1e074337b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -170,6 +170,13 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void __init free_hyp_pgds(void);
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			  gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn_offset, unsigned long npages);
+
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b16aff3f65f6..f5ae4b97df4d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1149,6 +1149,36 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			  gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_clear_dbm);
+}
+
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_set_dbm, false);
+}
+
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_sync_dirty, false);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
-- 
2.34.1


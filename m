Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9831330005F
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 11:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbhAVK03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 05:26:29 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11430 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbhAVKO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 05:14:57 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DMZpR36vYzj8SW;
        Fri, 22 Jan 2021 18:13:19 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 18:14:04 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <yuzenghui@huawei.com>, Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v4 2/2] KVM: arm64: Filter out the case of only changing permissions from stage-2 map path
Date:   Fri, 22 Jan 2021 18:13:58 +0800
Message-ID: <20210122101358.379956-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210122101358.379956-1-wangyanan55@huawei.com>
References: <20210122101358.379956-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(1) During running time of a a VM with numbers of vCPUs, if some vCPUs
access the same GPA almost at the same time and the stage-2 mapping of
the GPA has not been built yet, as a result they will all cause
translation faults. The first vCPU builds the mapping, and the followed
ones end up updating the valid leaf PTE. Note that these vCPUs might
want different access permissions (RO, RW, RX, RWX, etc.).

(2) It's inevitable that we sometimes will update an existing valid leaf
PTE in the map path, and we all perform break-before-make in this case.
Then more unnecessary translation faults could be caused if the
*break stage* of BBM is just catched by other vCPUs.

With (1) and (2), something unsatisfactory could happen: vCPU A causes
a translation fault and builds the mapping with RW permissions, vCPU B
then update the valid leaf PTE with break-before-make and permissions
are updated back to RO. Besides, *break stage* of BBM may trigger more
translation faults. Finally, some useless small loops could occur.

We can make some optimization to solve above problems: When we need to
update a valid leaf PTE in the translation fault handler, let's filter
out the case where this update only change access permissions that don't
require break-before-make. If there have already been the permissions
we want, don't bother to update. If still more permissions need to be
added, then update the PTE directly without break-before-make.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  4 ++
 arch/arm64/kvm/hyp/pgtable.c         | 62 +++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..2bd4e772ca57 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -157,6 +157,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * If device attributes are not explicitly requested in @prot, then the
  * mapping will be normal, cacheable.
  *
+ * When there is an existing valid leaf PTE to be updated in this function,
+ * perform break-before-make only if the parameters to be changed for this
+ * update require it, otherwise the PTE can be updated directly.
+ *
  * Note that this function will both coalesce existing table entries and split
  * existing block mappings, relying on page-faults to fault back areas outside
  * of the new mapping lazily.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2878aaf53b3c..aac1915f9770 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -45,6 +45,10 @@
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -460,34 +464,60 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
+static void stage2_map_update_valid_leaf_pte(u64 addr, u32 level,
+					     kvm_pte_t *ptep, kvm_pte_t new,
+					     struct stage2_map_data *data)
+{
+	kvm_pte_t old = *ptep;
+
+	/*
+	 * It's inevitable that we sometimes end up updating an existing valid
+	 * leaf PTE on the map path for kinds of reasons, for instance, multiple
+	 * vcpus accessing the same GPA page all cause translation faults on the
+	 * same time. So perform break-before-make here only if the parameters
+	 * to be changed for this update require it, otherwise the PTE can be
+	 * updated directly.
+	 */
+	if ((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS)) {
+		kvm_set_invalid_pte(ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		smp_store_release(ptep, new);
+		return;
+	}
+
+	old ^= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	new ^= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	new |= old;
+
+	/*
+	 * Update the valid leaf PTE directly without break-before-make if more
+	 * permissions need to be added, and skip the update if there have been
+	 * already the permissions that we want.
+	 */
+	if (new != old) {
+		WRITE_ONCE(*ptep, new ^ KVM_PTE_LEAF_ATTR_HI_S2_XN);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+	}
+}
+
 static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				       kvm_pte_t *ptep,
 				       struct stage2_map_data *data)
 {
-	kvm_pte_t new, old = *ptep;
+	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (kvm_pte_valid(old)) {
-		/* Tolerate KVM recreating the exact same mapping */
-		if (old == new)
-			goto out;
-
-		/*
-		 * There's an existing different valid leaf entry, so perform
-		 * break-before-make.
-		 */
-		kvm_set_invalid_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		put_page(virt_to_page(ptep));
+	if (kvm_pte_valid(*ptep)) {
+		stage2_map_update_valid_leaf_pte(addr, level, ptep, new, data);
+	} else {
+		smp_store_release(ptep, new);
+		get_page(virt_to_page(ptep));
 	}
 
-	smp_store_release(ptep, new);
-	get_page(virt_to_page(ptep));
-out:
 	data->phys += granule;
 	return true;
 }
-- 
2.19.1


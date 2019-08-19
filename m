Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988E491C4A
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 07:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHSFQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 01:16:01 -0400
Received: from ozlabs.ru ([107.173.13.209]:47034 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfHSFQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 01:16:01 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 340AEAE8001C;
        Mon, 19 Aug 2019 01:15:39 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: vfio/spapr_tce: Split out TCE invalidation from TCE updates
Date:   Mon, 19 Aug 2019 15:15:53 +1000
Message-Id: <20190819051553.14094-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO IOMMU implementation on SPAPR uses iommu_table::exchange() hook
to update hardware TCE tables (a table where an index is a IOBA>>pageshift
and the value is a host physical address). Each TCE update requires
TCE cache invalidation, both at the PHB and NPU levels. The invalidation
interface allows invalidation of 1) a single TCE, 2) all TCEs belonging
to a specific IOMMU group (or "PE"), 3) entire cache. The invalidation
is implemented in the host system firmware (skiboot) via an OPAL call and
writes to the registers called "TCE Kill" (hence the naming).

At the moment iommu_tce_xchg() is the only interface to
update-and-invalidate a TCE, i.e. we call OPAL for each TCE update.
This is not a problem for relatively small guests (32GB guest takes
less than 2s to map everything into the huge window) but it is for
bigger guests. It gets worse with GPU+NVLinks as NPU (a hardware bit
implementing NVLinks) needs its own TCE cache to be invalidated.

To map a 100GB guest with 1 GPU + 2xNVLinks, a loop over the guest RAM
takes 20s where 10s and 9s go to NPU and PHB TCE cache invalidation.
This is that slow because:
1) we call OPAL for every TCE entry;
2) invalidating many TCEs takes longer than flushing the entire TCE cache.

This implements iommu_tce_kill() and removes TCE cache invalidation from
iommu_tce_xchg. This greatly reduces the number of OPAL calls and halves
the time spent in invalidation. Also, since now OPAL is called for more
just a single TCE, skiboot can choose to invalidate the entire TCE cache
depending on the number of TCEs or entirely (NPU).

This implements iommu_tce_kill_rm() locally in the realmode handlers file
similar to iommu_tce_xchg_rm() as, unlike iommu_tce_kill(), it is not
shared between VFIO IOMMU driver and KVM.

While at this, this fixes incorrect early returns in KVM's
H_PUT_TCE_INDIRECT handlers which skips unlocking locks:
both kvmppc_h_put_tce_indirect and kvmppc_rm_h_put_tce_indirect used
to return H_PARAMETER instead of jumping to unlock_exit.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

This came up after debugging https://patchwork.ozlabs.org/patch/1134763/
"powerpc/pseries/iommu: Add cond_resched() for huge updates"
which we do not actually need.

This should fix bz https://bugzilla.linux.ibm.com/show_bug.cgi?id=175630#c19
I have also backported it at https://github.ibm.com/alexey/linux/commit/25271aa004de51f518408a1f105e36fabe823bf5


---
 arch/powerpc/include/asm/iommu.h          |  7 ++++++
 arch/powerpc/kernel/iommu.c               |  8 +++++++
 arch/powerpc/kvm/book3s_64_vio.c          | 21 ++++++++++++----
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 29 +++++++++++++++++++----
 arch/powerpc/platforms/powernv/pci-ioda.c | 15 +++---------
 drivers/vfio/vfio_iommu_spapr_tce.c       |  8 ++++++-
 6 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 18d342b815e4..0dd50e299d79 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -58,6 +58,11 @@ struct iommu_table_ops {
 			unsigned long *hpa,
 			enum dma_data_direction *direction);
 
+	void (*tce_kill)(struct iommu_table *tbl,
+			unsigned long index,
+			unsigned long pages,
+			bool realmode);
+
 	__be64 *(*useraddrptr)(struct iommu_table *tbl, long index, bool alloc);
 #endif
 	void (*clear)(struct iommu_table *tbl,
@@ -206,6 +211,8 @@ extern void iommu_del_device(struct device *dev);
 extern long iommu_tce_xchg(struct mm_struct *mm, struct iommu_table *tbl,
 		unsigned long entry, unsigned long *hpa,
 		enum dma_data_direction *direction);
+extern void iommu_tce_kill(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages);
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 0a67ce9f827e..48e3c2940327 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1005,6 +1005,14 @@ long iommu_tce_xchg(struct mm_struct *mm, struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_xchg);
 
+void iommu_tce_kill(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages)
+{
+	if (tbl->it_ops->tce_kill)
+		tbl->it_ops->tce_kill(tbl, entry, pages, false);
+}
+EXPORT_SYMBOL_GPL(iommu_tce_kill);
+
 int iommu_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index e99a14798ab0..3bd17ed0250f 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -579,6 +579,8 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt, stit->tbl,
 					entry, ua, dir);
 
+		iommu_tce_kill(stit->tbl, entry, 1);
+
 		if (ret != H_SUCCESS) {
 			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
 			goto unlock_exit;
@@ -660,8 +662,10 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		}
 		tce = be64_to_cpu(tce);
 
-		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua))
-			return H_PARAMETER;
+		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua)) {
+			ret = H_PARAMETER;
+			goto invalidate_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt,
@@ -678,6 +682,10 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		kvmppc_tce_put(stt, entry + i, tce);
 	}
 
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill(stit->tbl, entry, npages);
+
 unlock_exit:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -716,7 +724,7 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				return ret;
+				goto invalidate_exit;
 
 			WARN_ON_ONCE(1);
 			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
@@ -726,6 +734,11 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-	return H_SUCCESS;
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill(stit->tbl, ioba >> stt->page_shift, npages);
+
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_stuff_tce);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index f50bbeedfc66..1170673c898f 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -240,6 +240,13 @@ static long iommu_tce_xchg_rm(struct mm_struct *mm, struct iommu_table *tbl,
 	return ret;
 }
 
+static void iommu_tce_kill_rm(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages)
+{
+	if (tbl->it_ops->tce_kill)
+		tbl->it_ops->tce_kill(tbl, entry, pages, true);
+}
+
 static void kvmppc_rm_clear_tce(struct kvm *kvm, struct iommu_table *tbl,
 		unsigned long entry)
 {
@@ -417,6 +424,8 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,
 					stit->tbl, entry, ua, dir);
 
+		iommu_tce_kill_rm(stit->tbl, entry, 1);
+
 		if (ret != H_SUCCESS) {
 			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
 			return ret;
@@ -556,8 +565,10 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		unsigned long tce = be64_to_cpu(((u64 *)tces)[i]);
 
 		ua = 0;
-		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua, NULL))
-			return H_PARAMETER;
+		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua, NULL)) {
+			ret = H_PARAMETER;
+			goto invalidate_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,
@@ -567,13 +578,17 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 			if (ret != H_SUCCESS) {
 				kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl,
 						entry);
-				goto unlock_exit;
+				goto invalidate_exit;
 			}
 		}
 
 		kvmppc_rm_tce_put(stt, entry + i, tce);
 	}
 
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill_rm(stit->tbl, entry, npages);
+
 unlock_exit:
 	if (rmap)
 		unlock_rmap(rmap);
@@ -616,7 +631,7 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				return ret;
+				goto invalidate_exit;
 
 			WARN_ON_ONCE_RM(1);
 			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
@@ -626,7 +641,11 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_rm_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-	return H_SUCCESS;
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill_rm(stit->tbl, ioba >> stt->page_shift, npages);
+
+	return ret;
 }
 
 /* This can be called in either virtual mode or real mode */
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index d8080558d020..ae1263bd9256 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2107,23 +2107,13 @@ static int pnv_ioda2_tce_build(struct iommu_table *tbl, long index,
 static int pnv_ioda2_tce_xchg(struct iommu_table *tbl, long index,
 		unsigned long *hpa, enum dma_data_direction *direction)
 {
-	long ret = pnv_tce_xchg(tbl, index, hpa, direction, true);
-
-	if (!ret)
-		pnv_pci_ioda2_tce_invalidate(tbl, index, 1, false);
-
-	return ret;
+	return pnv_tce_xchg(tbl, index, hpa, direction, true);
 }
 
 static int pnv_ioda2_tce_xchg_rm(struct iommu_table *tbl, long index,
 		unsigned long *hpa, enum dma_data_direction *direction)
 {
-	long ret = pnv_tce_xchg(tbl, index, hpa, direction, false);
-
-	if (!ret)
-		pnv_pci_ioda2_tce_invalidate(tbl, index, 1, true);
-
-	return ret;
+	return pnv_tce_xchg(tbl, index, hpa, direction, false);
 }
 #endif
 
@@ -2140,6 +2130,7 @@ static struct iommu_table_ops pnv_ioda2_iommu_ops = {
 #ifdef CONFIG_IOMMU_API
 	.exchange = pnv_ioda2_tce_xchg,
 	.exchange_rm = pnv_ioda2_tce_xchg_rm,
+	.tce_kill = pnv_pci_ioda2_tce_invalidate,
 	.useraddrptr = pnv_tce_useraddrptr,
 #endif
 	.clear = pnv_ioda2_tce_free,
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index babef8b00daf..91100afcf696 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -435,7 +435,7 @@ static int tce_iommu_clear(struct tce_container *container,
 	unsigned long oldhpa;
 	long ret;
 	enum dma_data_direction direction;
-	unsigned long lastentry = entry + pages;
+	unsigned long lastentry = entry + pages, firstentry = entry;
 
 	for ( ; entry < lastentry; ++entry) {
 		if (tbl->it_indirect_levels && tbl->it_userspace) {
@@ -476,6 +476,8 @@ static int tce_iommu_clear(struct tce_container *container,
 		tce_iommu_unuse_page(container, oldhpa);
 	}
 
+	iommu_tce_kill(tbl, firstentry, pages);
+
 	return 0;
 }
 
@@ -536,6 +538,8 @@ static long tce_iommu_build(struct tce_container *container,
 
 	if (ret)
 		tce_iommu_clear(container, tbl, entry, i);
+	else
+		iommu_tce_kill(tbl, entry, pages);
 
 	return ret;
 }
@@ -593,6 +597,8 @@ static long tce_iommu_build_v2(struct tce_container *container,
 
 	if (ret)
 		tce_iommu_clear(container, tbl, entry, i);
+	else
+		iommu_tce_kill(tbl, entry, pages);
 
 	return ret;
 }
-- 
2.17.1


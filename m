Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6AB9C919
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfHZGRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:17:22 -0400
Received: from ozlabs.ru ([107.173.13.209]:55958 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729519AbfHZGRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:17:22 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 0FE83AE80570;
        Mon, 26 Aug 2019 02:16:58 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 2/4] KVM: PPC: Invalidate multiple TCEs at once
Date:   Mon, 26 Aug 2019 16:17:03 +1000
Message-Id: <20190826061705.92048-3-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826061705.92048-1-aik@ozlabs.ru>
References: <20190826061705.92048-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invalidating a TCE cache entry for each updated TCE is quite expensive.
This makes use of the new iommu_table_ops::xchg_no_kill()/tce_kill()
callbacks to bring down the time spent in mapping a huge guest DMA window;
roughly 20s to 10s for each guest's 100GB of DMA space.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_64_vio.c    | 29 +++++++++++++++-------
 arch/powerpc/kvm/book3s_64_vio_hv.c | 38 +++++++++++++++++++++--------
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index c4b606fe73eb..5834db0a54c6 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -416,7 +416,7 @@ static void kvmppc_clear_tce(struct mm_struct *mm, struct iommu_table *tbl,
 	unsigned long hpa = 0;
 	enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg(mm, tbl, entry, &hpa, &dir);
+	iommu_tce_xchg_no_kill(mm, tbl, entry, &hpa, &dir);
 }
 
 static long kvmppc_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -447,7 +447,8 @@ static long kvmppc_tce_iommu_do_unmap(struct kvm *kvm,
 	unsigned long hpa = 0;
 	long ret;
 
-	if (WARN_ON_ONCE(iommu_tce_xchg(kvm->mm, tbl, entry, &hpa, &dir)))
+	if (WARN_ON_ONCE(iommu_tce_xchg_no_kill(kvm->mm, tbl, entry, &hpa,
+					&dir)))
 		return H_TOO_HARD;
 
 	if (dir == DMA_NONE)
@@ -455,7 +456,7 @@ static long kvmppc_tce_iommu_do_unmap(struct kvm *kvm,
 
 	ret = kvmppc_tce_iommu_mapped_dec(kvm, tbl, entry);
 	if (ret != H_SUCCESS)
-		iommu_tce_xchg(kvm->mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill(kvm->mm, tbl, entry, &hpa, &dir);
 
 	return ret;
 }
@@ -501,7 +502,7 @@ long kvmppc_tce_iommu_do_map(struct kvm *kvm, struct iommu_table *tbl,
 	if (mm_iommu_mapped_inc(mem))
 		return H_TOO_HARD;
 
-	ret = iommu_tce_xchg(kvm->mm, tbl, entry, &hpa, &dir);
+	ret = iommu_tce_xchg_no_kill(kvm->mm, tbl, entry, &hpa, &dir);
 	if (WARN_ON_ONCE(ret)) {
 		mm_iommu_mapped_dec(mem);
 		return H_TOO_HARD;
@@ -579,6 +580,8 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt, stit->tbl,
 					entry, ua, dir);
 
+		iommu_tce_kill(stit->tbl, entry, 1);
+
 		if (ret != H_SUCCESS) {
 			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
 			goto unlock_exit;
@@ -656,13 +659,13 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		 */
 		if (get_user(tce, tces + i)) {
 			ret = H_TOO_HARD;
-			goto unlock_exit;
+			goto invalidate_exit;
 		}
 		tce = be64_to_cpu(tce);
 
 		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua)) {
 			ret = H_PARAMETER;
-			goto unlock_exit;
+			goto invalidate_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -673,13 +676,17 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 			if (ret != H_SUCCESS) {
 				kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl,
 						entry);
-				goto unlock_exit;
+				goto invalidate_exit;
 			}
 		}
 
 		kvmppc_tce_put(stt, entry + i, tce);
 	}
 
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill(stit->tbl, entry, npages);
+
 unlock_exit:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -718,7 +725,7 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				return ret;
+				goto invalidate_exit;
 
 			WARN_ON_ONCE(1);
 			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
@@ -728,6 +735,10 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-	return H_SUCCESS;
+invalidate_exit:
+	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
+		iommu_tce_kill(stit->tbl, ioba >> stt->page_shift, npages);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_stuff_tce);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index b4f20f13b860..ab6eeb8e753e 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -218,13 +218,14 @@ static long kvmppc_rm_ioba_validate(struct kvmppc_spapr_tce_table *stt,
 	return H_SUCCESS;
 }
 
-static long iommu_tce_xchg_rm(struct mm_struct *mm, struct iommu_table *tbl,
+static long iommu_tce_xchg_no_kill_rm(struct mm_struct *mm,
+		struct iommu_table *tbl,
 		unsigned long entry, unsigned long *hpa,
 		enum dma_data_direction *direction)
 {
 	long ret;
 
-	ret = tbl->it_ops->exchange_rm(tbl, entry, hpa, direction);
+	ret = tbl->it_ops->xchg_no_kill(tbl, entry, hpa, direction, true);
 
 	if (!ret && ((*direction == DMA_FROM_DEVICE) ||
 				(*direction == DMA_BIDIRECTIONAL))) {
@@ -240,13 +241,20 @@ static long iommu_tce_xchg_rm(struct mm_struct *mm, struct iommu_table *tbl,
 	return ret;
 }
 
+extern void iommu_tce_kill_rm(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages)
+{
+	if (tbl->it_ops->tce_kill)
+		tbl->it_ops->tce_kill(tbl, entry, pages, true);
+}
+
 static void kvmppc_rm_clear_tce(struct kvm *kvm, struct iommu_table *tbl,
 		unsigned long entry)
 {
 	unsigned long hpa = 0;
 	enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg_rm(kvm->mm, tbl, entry, &hpa, &dir);
+	iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir);
 }
 
 static long kvmppc_rm_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -278,7 +286,7 @@ static long kvmppc_rm_tce_iommu_do_unmap(struct kvm *kvm,
 	unsigned long hpa = 0;
 	long ret;
 
-	if (iommu_tce_xchg_rm(kvm->mm, tbl, entry, &hpa, &dir))
+	if (iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir))
 		/*
 		 * real mode xchg can fail if struct page crosses
 		 * a page boundary
@@ -290,7 +298,7 @@ static long kvmppc_rm_tce_iommu_do_unmap(struct kvm *kvm,
 
 	ret = kvmppc_rm_tce_iommu_mapped_dec(kvm, tbl, entry);
 	if (ret)
-		iommu_tce_xchg_rm(kvm->mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir);
 
 	return ret;
 }
@@ -336,7 +344,7 @@ static long kvmppc_rm_tce_iommu_do_map(struct kvm *kvm, struct iommu_table *tbl,
 	if (WARN_ON_ONCE_RM(mm_iommu_mapped_inc(mem)))
 		return H_TOO_HARD;
 
-	ret = iommu_tce_xchg_rm(kvm->mm, tbl, entry, &hpa, &dir);
+	ret = iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir);
 	if (ret) {
 		mm_iommu_mapped_dec(mem);
 		/*
@@ -417,6 +425,8 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,
 					stit->tbl, entry, ua, dir);
 
+		iommu_tce_kill_rm(stit->tbl, entry, 1);
+
 		if (ret != H_SUCCESS) {
 			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
 			return ret;
@@ -558,7 +568,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		ua = 0;
 		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua, NULL)) {
 			ret = H_PARAMETER;
-			goto unlock_exit;
+			goto invalidate_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -569,13 +579,17 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
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
@@ -618,7 +632,7 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				return ret;
+				goto invalidate_exit;
 
 			WARN_ON_ONCE_RM(1);
 			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
@@ -628,7 +642,11 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
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
-- 
2.17.1


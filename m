Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0C2F60EB
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbhANMOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 07:14:51 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11384 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbhANMOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 07:14:51 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DGjrD61f6z7VLk;
        Thu, 14 Jan 2021 20:13:00 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 14 Jan 2021 20:13:55 +0800
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
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v3 3/3] KVM: arm64: Mark the page dirty only if the fault is handled successfully
Date:   Thu, 14 Jan 2021 20:13:50 +0800
Message-ID: <20210114121350.123684-4-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210114121350.123684-1-wangyanan55@huawei.com>
References: <20210114121350.123684-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We now set the pfn dirty and mark the page dirty before calling fault
handlers in user_mem_abort(), so we might end up having spurious dirty
pages if update of permissions or mapping has failed. Let's move these
two operations after the fault handlers, and they will be done only if
the fault has been handled successfully.

When an -EAGAIN errno is returned from the map handler, we hope to the
vcpu to enter guest directly instead of exiting back to userspace, so
adjust the return value at the end of function.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..77cb2d28f2a4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -879,11 +879,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PAGE_SIZE && !force_pte)
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
 							   &pfn, &fault_ipa);
-	if (writable) {
+	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
-		kvm_set_pfn_dirty(pfn);
-		mark_page_dirty(kvm, gfn);
-	}
 
 	if (fault_status != FSC_PERM && !device)
 		clean_dcache_guest_page(pfn, vma_pagesize);
@@ -911,11 +908,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 					     memcache);
 	}
 
+	/* Mark the page dirty only if the fault is handled successfully */
+	if (writable && !ret) {
+		kvm_set_pfn_dirty(pfn);
+		mark_page_dirty(kvm, gfn);
+	}
+
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
-	return ret;
+	return ret != -EAGAIN ? ret : 0;
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.19.1


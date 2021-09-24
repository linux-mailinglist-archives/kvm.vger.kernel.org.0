Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350304178B3
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbhIXQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347582AbhIXQdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTeF3nyB1tGiJ2+lXnLCbm9KzsW1bNX5sYu80yazkZU=;
        b=GRJV5zpqcUMLCvLkHO1yf0ElAw0Kur1Tc5lww8Qbwn3WQHbWyt+kw/N5pub705DWTqWWYX
        ZX1Xa1gv6y042oYXDv8AyergcBlACKp0iTokUBxqFSvVVgJvisTHJfnc1iJ/vAKIVJ8TRx
        IfvpH8kQNc33YqBUVtKb62kf6CRfvVc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-rgjA-fStMZaGkCJz24BwFw-1; Fri, 24 Sep 2021 12:32:09 -0400
X-MC-Unique: rgjA-fStMZaGkCJz24BwFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A4879F95D;
        Fri, 24 Sep 2021 16:32:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0728E7D3CD;
        Fri, 24 Sep 2021 16:32:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 24/31] KVM: MMU: clean up make_spte return value
Date:   Fri, 24 Sep 2021 12:31:45 -0400
Message-Id: <20210924163152.289027-25-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that make_spte is called directly by the shadow MMU (rather than
wrapped by set_spte), it only has to return one boolean value.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 5 -----
 arch/x86/kvm/mmu/spte.c         | 8 ++++----
 arch/x86/kvm/mmu/spte.h         | 7 +------
 arch/x86/kvm/mmu/tdp_mmu.c      | 6 +++---
 5 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 19c2fd2189a3..dcbe7df2f890 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2683,7 +2683,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int was_rmapped = 0;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
-	int make_spte_ret;
+	bool wrprot;
 	u64 spte;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
@@ -2715,8 +2715,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			was_rmapped = 1;
 	}
 
-	make_spte_ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
-				 true, host_writable, sp_ad_disabled(sp), &spte);
+	wrprot = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
+			   true, host_writable, sp_ad_disabled(sp), &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -2725,7 +2725,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		flush |= mmu_spte_update(sptep, spte);
 	}
 
-	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
+	if (wrprot) {
 		if (write_fault)
 			ret = RET_PF_EMULATE;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f0295ad51f69..94f4e754facb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -150,11 +150,6 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
-/* Bits which may be returned by set_spte() */
-#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
-#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
-#define SET_SPTE_SPURIOUS		BIT(2)
-
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      kvm_pfn_t pfn, int max_level);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 66be9452ded1..29ea996201b4 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -89,13 +89,13 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+bool make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
 		     u64 *new_spte)
 {
 	u64 spte = SPTE_MMU_PRESENT_MASK;
-	int ret = 0;
+	bool wrprot = false;
 
 	if (ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
@@ -162,7 +162,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync, speculative)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
-			ret |= SET_SPTE_WRITE_PROTECTED_PT;
+			wrprot = true;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
 		}
@@ -183,7 +183,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 
 	*new_spte = spte;
-	return ret;
+	return wrprot;
 }
 
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index eb7b227fc6cf..1998ec559196 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -334,12 +334,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-/* Bits which may be returned by set_spte() */
-#define SET_SPTE_WRITE_PROTECTED_PT    BIT(0)
-#define SET_SPTE_NEED_REMOTE_TLB_FLUSH BIT(1)
-#define SET_SPTE_SPURIOUS              BIT(2)
-
-int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+bool make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
 		     u64 *new_spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3e10658cf0d7..6de2c957edd6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -898,12 +898,12 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 {
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
-	int make_spte_ret = 0;
+	bool wrprot = false;
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+		wrprot = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefault, true,
 					 fault->map_writable, !shadow_accessed_mask,
 					 &new_spte);
@@ -918,7 +918,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	 * protected, emulation is needed. If the emulation was skipped,
 	 * the vCPU would have the same fault again.
 	 */
-	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
+	if (wrprot) {
 		if (fault->write)
 			ret = RET_PF_EMULATE;
 	}
-- 
2.27.0



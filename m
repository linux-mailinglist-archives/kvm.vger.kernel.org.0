Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF43524C4
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhDBA5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhDBA5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EC7C061793
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v186so7617244ybe.5
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tDfPmXbzjuXYEj7QinrksosPu+0bJFiZwViEuyBfiPM=;
        b=lb+qs0QKm/vKplDLvVTszodx9+lPNY1WATK8sX84CSZq8tI076ayThzvRmFWIC9ppR
         d8t9FSZnygTkkAg2cJC4qgr46yFW8WrEbI1c93uYTd4Tq+C40f7GmYGNn76no2eydFJm
         ELg1MV/l2E2VRXKBw+OxLEfDEUoMG2hdu1QZaxqsLn0ey5+2k2aTKxqSaN8KYwbGGpJZ
         LU2s/Dk7xnQsZ63ZuMGE1MCLqdVTzwBfjQTtDty7A1SwD1F+T3rYvXnjE6NGc0WaI/Wh
         rjmoa/1Y5xAuK8JFh3YXhP45SEhEa+DdFoZy2vyAMj8oY/jTXPmptXAWwzLudr/mz6DL
         n6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tDfPmXbzjuXYEj7QinrksosPu+0bJFiZwViEuyBfiPM=;
        b=iWy2TcOtSSn3JgvDwRlbEZvrQsIH+huujCKvXgXxX+D+YBA3VxdOOmLpBmCbKVXDkn
         eP3DKTWPpUQd84uuB2ryEJadM/CA1wBBvPyF/HgcwyPXmYVFCU4lpYddYL4yyzRPgnVb
         Kor8CiiVV9UbjKZahIKFRSv+4+zzRnhgk0rbnQmuuC5J4rtc9brWiemcoS/eg0o5grll
         z7GUStySEQg1DkODJorXi46ePkO8RfO7M95j1XxI8/5jur3SP0tAuNi4DLZa9qxC4VAX
         9rQYZpIaFNNnOII5szNuU5VAv/ZHTFq7K7A183PLLR3dqIUIqoHDQOWpvx2DBqVtY5aE
         /yGQ==
X-Gm-Message-State: AOAM533C2LjdnWlclhrFIANxinMFsBfhXY1gVBRmx1Wn9G6dbzgsN/Uh
        jWLzgNHe4lEkD8LxiE6Sag6BRAas5FU=
X-Google-Smtp-Source: ABdhPJxbKr645X0CcfRDIWTDLNH8a38GjXA6vUJ3jECMSWadG+jHX2J4YQiJuT8sNhsO5srQAIOw4KIsjrs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:f608:: with SMTP id t8mr16151942ybd.496.1617325027509;
 Thu, 01 Apr 2021 17:57:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:51 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 03/10] KVM: arm64: Convert to the gfn-based MMU notifier callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move arm64 to the gfn-base MMU notifier APIs, which do the hva->gfn
lookup in common code.

No meaningful functional change intended, though the exact order of
operations is slightly different since the memslot lookups occur before
calling into arch code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/mmu.c              | 117 ++++++++----------------------
 2 files changed, 33 insertions(+), 85 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 72e6b4600264..1ad729cf7b0d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,6 +582,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4b7e1e327337..35728231e9a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,7 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
 	 * the page we just got a reference to gets unmapped before we have a
 	 * chance to grab the mmu_lock, which ensure that if the page gets
-	 * unmapped afterwards, the call to kvm_unmap_hva will take it away
+	 * unmapped afterwards, the call to kvm_unmap_gfn will take it away
 	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
 	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
 	 */
@@ -1064,123 +1064,70 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int handle_hva_to_gpa(struct kvm *kvm,
-			     unsigned long start,
-			     unsigned long end,
-			     int (*handler)(struct kvm *kvm,
-					    gpa_t gpa, u64 size,
-					    void *data),
-			     void *data)
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int ret = 0;
-
-	slots = kvm_memslots(kvm);
-
-	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gpa;
-
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-
-		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
-		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
-	}
-
-	return ret;
-}
-
-static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	unsigned flags = *(unsigned *)data;
-	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
-
-	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
-	return 0;
-}
-
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
-	return 0;
-}
+	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
+			     (range->end - range->start) << PAGE_SHIFT,
+			     range->may_block);
 
-static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	kvm_pfn_t *pfn = (kvm_pfn_t *)data;
-
-	WARN_ON(size != PAGE_SIZE);
-
-	/*
-	 * The MMU notifiers will have unmapped a huge PMD before calling
-	 * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
-	 * therefore we never need to clear out a huge PMD through this
-	 * calling path and a memcache is not required.
-	 */
-	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, gpa, PAGE_SIZE,
-			       __pfn_to_phys(*pfn), KVM_PGTABLE_PROT_R, NULL);
 	return 0;
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	unsigned long end = hva + PAGE_SIZE;
-	kvm_pfn_t pfn = pte_pfn(pte);
+	kvm_pfn_t pfn = pte_pfn(range->pte);
 
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
+	WARN_ON(range->end - range->start != 1);
+
 	/*
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
 	clean_dcache_guest_page(pfn, PAGE_SIZE);
-	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
+
+	/*
+	 * The MMU notifiers will have unmapped a huge PMD before calling
+	 * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
+	 * therefore we never need to clear out a huge PMD through this
+	 * calling path and a memcache is not required.
+	 */
+	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
+			       PAGE_SIZE, __pfn_to_phys(pfn),
+			       KVM_PGTABLE_PROT_R, NULL);
+
 	return 0;
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	pte_t pte;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
 	kvm_pte_t kpte;
+	pte_t pte;
+
+	if (!kvm->arch.mmu.pgt)
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt, gpa);
+
+	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
+					range->start << PAGE_SHIFT);
 	pte = __pte(kpte);
 	return pte_valid(pte) && pte_young(pte);
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt, gpa);
-}
-
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-{
-	if (!kvm->arch.mmu.pgt)
-		return 0;
-
-	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
-}
-
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
-				 kvm_test_age_hva_handler, NULL);
+	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
+					   range->start << PAGE_SHIFT);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.31.0.208.g409f899ff0-goog


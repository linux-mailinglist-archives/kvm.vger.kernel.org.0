Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE83524C8
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhDBA5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhDBA5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D8BC061794
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f18so4724353ybq.3
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=noWYqCUZelFCMUSh7ZeHZ6bmzNaY4TJIP5y7J4PJixc=;
        b=ouD3RUjogj41I7jReVrpeXQU9Bb0xL3P8VWkyehuZzBOD88/Sc2uhZmTxennNsvLyT
         OqfLWztGLspvOdSW9kUrSN0V3oNghubKE1biSAWV6nMl4oHzXS716JlpFhiROhcyTwUH
         NbcktbtPM4RWwmh6SH9O64kxWxqQkxV/u5DbK70BqtuIOFBh4yhMHK2ChGOdkkS6Gv+I
         XgV7IbTc96h8bZePPBN13sw/RuQbx0zYdA+eYXja8N9DsEKEjoB1bbXu4L2tpOK43+zU
         jeK6OjT+/p9isY2SbCwiLQt0ceFPR6OFbFpaeX02nzYeRp1bvono9LbgC7yf01qw7JRI
         8G3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=noWYqCUZelFCMUSh7ZeHZ6bmzNaY4TJIP5y7J4PJixc=;
        b=lrecJHi07NedLuqvySTGBio54BuH8sxr92+CxL6wduC+qRfwkiL1UUUjZs2YSdIyRf
         MPQipGKXfu3aGLMFPL7WDmdarx4MeqZ93667G8I5Tx+Twm+IBCA9byqlYroVk4gcycpf
         zbelrFW2q50h8FWhloBj8FbOW12obVoBN9JRU5OXKzQyi3rm8ymsaxqbkTY3EERVVGYU
         Lqn8Lm8gP2Dr4ZC53m7LcIRP6lJSeXTyv8M2fl1qK7yYh4KAntinBER9dt5BaPLG35Lc
         Ma3T8QN6LKlhM2VlI7tcTmmgB3rhCUf1iyOswerAH9dfHiH1H1Zo9vxChvPmKt7cRkZs
         FWVQ==
X-Gm-Message-State: AOAM530QMlUJsXBO6D/I1MdnNGj7Y1v536O2pSKcF8iGCU1ZX8MRhgVs
        1QcR54J0dDjoj5lT7fgN89sZQROrd1Y=
X-Google-Smtp-Source: ABdhPJydkmZrVRRl/TCK20DP5D2eCr2nOcpte6dzBOlW4oeOa5/178wYriGJI5XuziulLinORup7GUWeoVI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:5146:: with SMTP id f67mr15369859ybb.332.1617325029648;
 Thu, 01 Apr 2021 17:57:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:52 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 04/10] KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
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

Move MIPS to the gfn-based MMU notifier APIs, which do the hva->gfn
lookup in common code, and whose code is nearly identical to MIPS'
lookup.

No meaningful functional change intended, though the exact order of
operations is slightly different since the memslot lookups occur before
calling into arch code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/include/asm/kvm_host.h |  1 +
 arch/mips/kvm/mmu.c              | 97 ++++++--------------------------
 2 files changed, 17 insertions(+), 81 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index feaa77036b67..374a3c8806e8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,6 +967,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..3dc885df2e32 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -439,85 +439,36 @@ static int kvm_mips_mkold_gpa_pt(struct kvm *kvm, gfn_t start_gfn,
 				  end_gfn << PAGE_SHIFT);
 }
 
-static int handle_hva_to_gpa(struct kvm *kvm,
-			     unsigned long start,
-			     unsigned long end,
-			     int (*handler)(struct kvm *kvm, gfn_t gfn,
-					    gpa_t gfn_end,
-					    struct kvm_memory_slot *memslot,
-					    void *data),
-			     void *data)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int ret = 0;
-
-	slots = kvm_memslots(kvm);
-
-	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
-
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-
-		/*
-		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
-		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-		ret |= handler(kvm, gfn, gfn_end, memslot, data);
-	}
-
-	return ret;
-}
-
-
-static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				 struct kvm_memory_slot *memslot, void *data)
-{
-	kvm_mips_flush_gpa_pt(kvm, gfn, gfn_end);
-	return 1;
-}
-
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags)
-{
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
+	kvm_mips_flush_gpa_pt(kvm, range->start, range->end);
 
 	kvm_mips_callbacks->flush_shadow_all(kvm);
 	return 0;
 }
 
-static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				struct kvm_memory_slot *memslot, void *data)
+static bool __kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	gpa_t gpa = gfn << PAGE_SHIFT;
-	pte_t hva_pte = *(pte_t *)data;
+	gpa_t gpa = range->start << PAGE_SHIFT;
+	pte_t hva_pte = range->pte;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
 	pte_t old_pte;
 
 	if (!gpa_pte)
-		return 0;
+		return false;
 
 	/* Mapping may need adjusting depending on memslot flags */
 	old_pte = *gpa_pte;
-	if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
+	if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
 		hva_pte = pte_mkclean(hva_pte);
-	else if (memslot->flags & KVM_MEM_READONLY)
+	else if (range->slot->flags & KVM_MEM_READONLY)
 		hva_pte = pte_wrprotect(hva_pte);
 
 	set_pte(gpa_pte, hva_pte);
 
 	/* Replacing an absent or old page doesn't need flushes */
 	if (!pte_present(old_pte) || !pte_young(old_pte))
-		return 0;
+		return false;
 
 	/* Pages swapped, aged, moved, or cleaned require flushes */
 	return !pte_present(hva_pte) ||
@@ -526,27 +477,21 @@ static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	       (pte_dirty(old_pte) && !pte_dirty(hva_pte));
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	unsigned long end = hva + PAGE_SIZE;
-	int ret;
-
-	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
-	if (ret)
+	if (__kvm_set_spte_gfn(kvm, range))
 		kvm_mips_callbacks->flush_shadow_all(kvm);
-	return 0;
+	return false;
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-			       struct kvm_memory_slot *memslot, void *data)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_mips_mkold_gpa_pt(kvm, gfn, gfn_end);
+	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				    struct kvm_memory_slot *memslot, void *data)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	gpa_t gpa = gfn << PAGE_SHIFT;
+	gpa_t gpa = range->start << PAGE_SHIFT;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
 
 	if (!gpa_pte)
@@ -554,16 +499,6 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	return pte_young(*gpa_pte);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-{
-	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
-}
-
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
-{
-	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
-}
-
 /**
  * _kvm_mips_map_page_fast() - Fast path GPA fault handler.
  * @vcpu:		VCPU pointer.
-- 
2.31.0.208.g409f899ff0-goog


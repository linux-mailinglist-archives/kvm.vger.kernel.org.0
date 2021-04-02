Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E303524CF
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhDBA5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhDBA5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:19 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C996C0613AD
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id n3so4392836qvr.8
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JN6JeOh2os7TETUBdatO/SE8rrYNulCw/eK8aUoUKlo=;
        b=eMrfPNSFFf9FEy/PgOFXlE0QW6+eiJ/B/GFm3098SJ8t5ML9FvPe4akfK9uP8Odqgd
         5bYn9hI52Cau/Zsc617HbZQPDpkDKTLNcWBqUn/yAO2EpjZEkp+jvMD3XcuPSs4b2NMx
         WTv2z4lQ7k1SMUeYuNPXv8EQZaJNVMMEpYyaJPjxJJHpO0BLXzl+0s9GnNslh5WIcl2o
         TmKMXkqNiylGj6uzaa0oXxBmNOQYDw86juXhCK7lDI7IRZjJKhF4iYXtGKqBsaBj0esq
         MW2yBN8IALvf1FH0CFOQHqQlm6PjoXPO+2fS171RoAUufjT5YLihSSEqzQLxWtTVqGS5
         uufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JN6JeOh2os7TETUBdatO/SE8rrYNulCw/eK8aUoUKlo=;
        b=BlrvXfocXmph99CrLH++t565KHdFl0qKz4fbU+8d4pR4ICq0KuVQln+tV1GNXWU8Kh
         XnaXYzrbJB/qGlnfYYAkDrtvnQOQUeKaQYH+j/A73hyzb3VNko3f3ugn9T5u0Y4n0NBQ
         71iGpy/qaTtGhQyTbBT3SoJHoec92SN8zsg6Jr6EY6H2p8gHIoxyTb6zatiBgrAuT5vk
         ccj1CO6/ucZ76CRfUSnZV99+VnXRLRCsh/5+g2oOknjpG9XZXOh7kNQZ2RySjzD88DTX
         3Db9AYhJxtEwHr8hJQiS+qQ8GHq2mwUMUXO2azz02NkuKEBO4/vnE950LXqhWdpAUA9c
         GIog==
X-Gm-Message-State: AOAM531ESp+Fxtg9Zn5fQgIbiLKdHcicQm0aRbwUK6hUaehGuE+PC2Xv
        ZEHuIvejd70r88szMlJOmW/cDMWT09Q=
X-Google-Smtp-Source: ABdhPJykRnNFawXAR7GTX30/MArrY/XbyRXdmuqfk1vxAaup1bjQe5AJdJRGU4o3M0zacGSEUMNzYTdDoHo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a0c:c243:: with SMTP id w3mr342583qvh.34.1617325034296;
 Thu, 01 Apr 2021 17:57:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:54 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 06/10] KVM: Kill off the old hva-based MMU notifier callbacks
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

Yank out the hva-based MMU notifier APIs now that all architectures that
use the notifiers have moved to the gfn-based APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   |  1 -
 arch/mips/include/asm/kvm_host.h    |  1 -
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/x86/include/asm/kvm_host.h     |  1 -
 include/linux/kvm_host.h            |  8 ---
 virt/kvm/kvm_main.c                 | 85 -----------------------------
 6 files changed, 97 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1ad729cf7b0d..72e6b4600264 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,7 +582,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 374a3c8806e8..feaa77036b67 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,7 +967,6 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1335f0001bdd..1e83359f286b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -55,7 +55,6 @@
 #include <linux/mmu_notifier.h>
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 #define HPTEG_CACHE_NUM			(1 << 15)
 #define HPTEG_HASH_BITS_PTE		13
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a21e3698f4dc..99778ac51243 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1718,7 +1718,6 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6bb401dd856..40ac2d40bb5a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -219,7 +219,6 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
@@ -231,13 +230,6 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-#else
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
 #endif
 
 enum {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7a7e62ae5eb4..2e809d73c7f1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -451,8 +451,6 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 struct kvm_hva_range {
@@ -564,8 +562,6 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 
 	return ret;
 }
-#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
-
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -573,9 +569,6 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	int idx;
-#endif
 	trace_kvm_set_spte_hva(address);
 
 	/*
@@ -585,26 +578,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	 */
 	WARN_ON_ONCE(!kvm->mmu_notifier_count);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-
-	KVM_MMU_LOCK(kvm);
-
-	if (kvm_set_spte_hva(kvm, address, pte))
-		kvm_flush_remote_tlbs(kvm);
-
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-#endif
 }
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
@@ -613,16 +593,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
-#else
-	int need_tlb_flush = 0, idx;
-#endif
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	idx = srcu_read_lock(&kvm->srcu);
-#endif
-
 	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
@@ -649,20 +622,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 			max(kvm->mmu_notifier_range_end, range->end);
 	}
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	__kvm_handle_hva_range(kvm, &hva_range);
-#else
-	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
-					     range->flags);
-	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush || kvm->tlbs_dirty)
-		kvm_flush_remote_tlbs(kvm);
-#endif
 
 	KVM_MMU_UNLOCK(kvm);
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	srcu_read_unlock(&kvm->srcu, idx);
-#endif
 
 	return 0;
 }
@@ -696,27 +658,9 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
 	trace_kvm_age_hva(start, end);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-
-	young = kvm_age_hva(kvm, start, end);
-	if (young)
-		kvm_flush_remote_tlbs(kvm);
-
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -724,11 +668,6 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long start,
 					unsigned long end)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
-
 	trace_kvm_age_hva(start, end);
 
 	/*
@@ -744,41 +683,17 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-	young = kvm_age_hva(kvm, start, end);
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long address)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
 	trace_kvm_test_age_hva(address);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
 					     kvm_test_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-	young = kvm_test_age_hva(kvm, address);
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.31.0.208.g409f899ff0-goog


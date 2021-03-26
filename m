Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7440349FA0
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhCZCVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhCZCUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CC1C061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n13so8314786ybp.14
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rP9VVmFz9tTW29ncW9PtW1i1icgd+TNgOdydaeZ7DTc=;
        b=YyE+zmkk6pXH2RexyDWG978Xxjj/u4QqerJ0Jdw4GGdLj6uS0ndq1vKuD/VORg3L2R
         emNhkpttx/IuToGZmFKMIkDu7iXiG7FVS3QRceqd/AOHh0eqpYPT6TKoSFSW+9x6GNsM
         AZdvcQD3IUjnKU64d8fzC/K9ynz3IygOPqdKizQJTopaYaQMP9UL8f45tGgj0d9KIVl2
         eVFNycjEVd/khAwRS9le7deOfUgMqS0LnRV6WYuL8fO0WYEcOzWmUiZhBDBYJSSH4hTZ
         Gi4MYxmLUOWZ6K872dKITkehA2W+OaUiWLEXSr2ExaVuXH5TNSYthD0Bh3BZGr3eU6EW
         MXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rP9VVmFz9tTW29ncW9PtW1i1icgd+TNgOdydaeZ7DTc=;
        b=iiUNz0B0IYuhRhHQ87lBw6kFPJmzvwlsBw5wx+rL/+KnZUWMU1oy9F+MwW1YU6clXc
         sxfDF1CevjVQt+SpPQfQ9ZnJXhD/Y7jBW9fEA6ktZ3YQF5ICSPdXBJulP6+Zrf6CU8Zt
         thVWB9C2tlsQSZiN1+zlGmqS0oX7HpBY3XK2Gu4/9RoEr4SplMeqY9iEq71RIXtO+b1z
         Z7igziITMh9PTcjjyLu8In2mPw4H5P8SivukGEup/ot6b67XWyFA9dKqAZSwh5sdUrkR
         Y0R3Z3jwsj8w95CmsQZEOJkgPVVKSO2EImhslPFy7VeGD07OoXdhncx7nZ1ildwWJPt5
         Fnmg==
X-Gm-Message-State: AOAM531smMhABKykN5WcGhmZsblamBRw3XQHTtYFnT3RZNcRjyx8ceBH
        uM6/+SG4oOALyeNcTWFn8rVJlDjF1Gw=
X-Google-Smtp-Source: ABdhPJwfMrzwJJK8gTYL6dVUS+tgYBhdYKKYyjZN9qKivIP6nH/vKKwBT9/mFEMjx4GL+u4YavlIG3nVM6Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:d714:: with SMTP id o20mr18028837ybg.385.1616725242737;
 Thu, 25 Mar 2021 19:20:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:53 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 14/18] KVM: Kill off the old hva-based MMU notifier callbacks
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
 virt/kvm/kvm_main.c                 | 93 ++---------------------------
 6 files changed, 5 insertions(+), 100 deletions(-)

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
index de74379a96ca..bfa43eea891a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -451,8 +451,6 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 struct kvm_hva_range {
@@ -564,40 +562,20 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 
 	return ret;
 }
-#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
-
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
 					pte_t pte)
 {
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
-#else
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int idx;
-
 	trace_kvm_set_spte_hva(address);
 
-	idx = srcu_read_lock(&kvm->srcu);
-
-	KVM_MMU_LOCK(kvm);
-
-	kvm->mmu_notifier_seq++;
-
-	if (kvm_set_spte_hva(kvm, address, pte))
-		kvm_flush_remote_tlbs(kvm);
-
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-#endif
+	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
@@ -606,14 +584,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
-#else
-	int need_tlb_flush = 0, idx;
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
-	idx = srcu_read_lock(&kvm->srcu);
-#endif
-
 	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
@@ -640,20 +613,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
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
@@ -687,26 +649,9 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	trace_kvm_age_hva(start, end);
+
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
-#else
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-
-	trace_kvm_age_hva(start, end);
-
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
@@ -714,15 +659,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long start,
 					unsigned long end)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-
 	trace_kvm_age_hva(start, end);
 
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-#endif
 	/*
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
@@ -736,38 +674,17 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
-#else
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
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	trace_kvm_test_age_hva(address);
+
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
 					     kvm_test_age_gfn);
-#else
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-
-	trace_kvm_test_age_hva(address);
-
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
2.31.0.291.g576ba9dcdaf-goog


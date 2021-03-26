Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7359B349F99
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhCZCU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhCZCUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E191BC061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 6so8367409ybq.7
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E73AHOQjBPWB3b7eepa8I3g6Ygw9PyS/TuWLtHYWQwQ=;
        b=uDH3hjnLP3hcmHYEfB2Jvqa+r4y3W8wJrJ04/Ad4Fp60G1iEjH+eEjpL+xNuswGHwc
         O0Ok57wCyozz0VL9FccBpaBbi+I+1S82VuXKSKmSgShJqkNrzcpqKBCi4zpbEKo7Oy1y
         4GcWwxpsQp2TFPrfQmrwy7t3mtkT+R864QvWWTKGWj1ItT0sB9clhsfS44jyQbW4Z7Se
         Df0RWv22xs3g8csKziDrQUx/dT8sWdlRXUnsM8ruakpV7oEyvrb+vjcEw8UwxAM3LCEi
         pJtlaKJw3+PyopoHNs1hsxGRbtsq09zI2TKzTGSSiPiMKIJ4KJdulM3S6GbRWv4ftxlH
         7W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E73AHOQjBPWB3b7eepa8I3g6Ygw9PyS/TuWLtHYWQwQ=;
        b=N03pQWnhD3EevsMrXVqXArFEKjZVyCyrrcyu/dElM54sBJRRkZWEWWWzl1NTbsYVA7
         xWKl/iLuNl6ocV6lVSkH7j0V6D81yaBKnN9CVtFGcWGEwVJNtmByfiUivXqjRPrGYzpV
         SmdwriPm6Ft+BvUUpNHae2Br34JVPg7wCabFzLShREg+dtfws2v46P4TLjS8brO9+2aa
         QRxFOEYXcYIf2e1SkSqMurm+dL9Z6xK6mj7Gf8Kl677f4v15J9jEhzQywuNBqZGjEY7B
         sXgeyUFTIGoKAbF11vN837ND6jOiuo3I/x92mr4SxfBsGMDf/jF3jTqSm26JyKGxs7CA
         E92w==
X-Gm-Message-State: AOAM531F+NWOrfCd44x83fKUkt0hiYM6urHgvR/AiSTRRiJvVz4for1E
        OyQxIzJMJoJt3I7eZFh3ZTWRURzRBSg=
X-Google-Smtp-Source: ABdhPJx7J0AHjHy4T9ri9h7rxvmUk9A6BI0ZEmrjzjf/OGqwCEhVMFXMsPH+P5e6WRHeKYr+Ul3KVIimyqo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:6f44:: with SMTP id k65mr15774100ybc.218.1616725231197;
 Thu, 25 Mar 2021 19:20:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:48 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 09/18] KVM: Move arm64's MMU notifier trace events to generic code
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

Move arm64's MMU notifier trace events into common code in preparation
for doing the hva->gfn lookup in common code.  The alternative would be
to trace the gfn instead of hva, but that's not obviously better and
could also be done in common code.  Tracing the notifiers is also quite
handy for debug regardless of architecture.

Remove a completely redundant tracepoint from PPC e500.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c             |  7 +---
 arch/arm64/kvm/trace_arm.h       | 66 --------------------------------
 arch/powerpc/kvm/e500_mmu_host.c |  2 -
 arch/powerpc/kvm/trace_booke.h   | 15 --------
 include/trace/events/kvm.h       | 66 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c              | 10 +++++
 6 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894db8c2..4b7e1e327337 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1111,7 +1111,6 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	trace_kvm_unmap_hva_range(start, end);
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
 	return 0;
 }
@@ -1141,8 +1140,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	trace_kvm_set_spte_hva(hva);
-
 	/*
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
@@ -1173,7 +1170,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
-	trace_kvm_age_hva(start, end);
+
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
 }
 
@@ -1181,7 +1178,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
-	trace_kvm_test_age_hva(hva);
+
 	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
 				 kvm_test_age_hva_handler, NULL);
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index ff0444352bba..33e4e7dd2719 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -135,72 +135,6 @@ TRACE_EVENT(kvm_mmio_emulate,
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
-TRACE_EVENT(kvm_unmap_hva_range,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier unmap range: %#016lx -- %#016lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_set_spte_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier set pte hva: %#016lx", __entry->hva)
-);
-
-TRACE_EVENT(kvm_age_hva,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_test_age_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
-);
-
 TRACE_EVENT(kvm_set_way_flush,
 	    TP_PROTO(unsigned long vcpu_pc, bool cache),
 	    TP_ARGS(vcpu_pc, cache),
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index ed0c9c43d0cf..648aefe1a3e7 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -723,8 +723,6 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu,
 
 static int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
-	trace_kvm_unmap_hva(hva);
-
 	/*
 	 * Flush all shadow tlb entries everywhere. This is slow, but
 	 * we are 100% sure that we catch the to be unmapped page
diff --git a/arch/powerpc/kvm/trace_booke.h b/arch/powerpc/kvm/trace_booke.h
index 3837842986aa..eff6e82dbcd4 100644
--- a/arch/powerpc/kvm/trace_booke.h
+++ b/arch/powerpc/kvm/trace_booke.h
@@ -69,21 +69,6 @@ TRACE_EVENT(kvm_exit,
 		)
 );
 
-TRACE_EVENT(kvm_unmap_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("unmap hva 0x%lx\n", __entry->hva)
-);
-
 TRACE_EVENT(kvm_booke206_stlb_write,
 	TP_PROTO(__u32 mas0, __u32 mas8, __u32 mas1, __u64 mas2, __u64 mas7_3),
 	TP_ARGS(mas0, mas8, mas1, mas2, mas7_3),
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 49d7d0fe29f6..200eb7465530 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -462,6 +462,72 @@ TRACE_EVENT(kvm_dirty_ring_exit,
 	TP_printk("vcpu %d", __entry->vcpu_id)
 );
 
+TRACE_EVENT(kvm_unmap_hva_range,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier unmap range: %#016lx -- %#016lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_set_spte_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier set pte hva: %#016lx", __entry->hva)
+);
+
+TRACE_EVENT(kvm_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_test_age_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..d1de843b7618 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -459,6 +459,8 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int idx;
 
+	trace_kvm_set_spte_hva(address);
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	KVM_MMU_LOCK(kvm);
@@ -478,6 +480,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
 
+	trace_kvm_unmap_hva_range(range->start, range->end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	/*
@@ -548,6 +552,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_age_hva(start, end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 
@@ -569,6 +575,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_age_hva(start, end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	/*
@@ -598,6 +606,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_test_age_hva(address);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	young = kvm_test_age_hva(kvm, address);
-- 
2.31.0.291.g576ba9dcdaf-goog


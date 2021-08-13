Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1C3EBCF4
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhHMUBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:36 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50316 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhHMUBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:33 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcvx-00041O-91; Fri, 13 Aug 2021 21:33:37 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/13] KVM: x86: Cache total page count to avoid traversing the memslot array
Date:   Fri, 13 Aug 2021 21:33:14 +0200
Message-Id: <a382d8f86cdac9f43de3110b367fe3fba6bf9d92.1628871412.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

There is no point in recalculating from scratch the total number of pages
in all memslots each time a memslot is created or deleted.

Just cache the value and update it accordingly on each such operation so
the code doesn't need to traverse the whole memslot array each time.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
 arch/x86/kvm/x86.c              | 18 +++++++++++++++---
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20daaf67a5bf..fa35408b6155 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1025,6 +1025,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
+	u64 n_memslots_pages;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
@@ -1552,7 +1553,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..708ffc3bf1e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6046,30 +6046,6 @@ int kvm_mmu_module_init(void)
 	return ret;
 }
 
-/*
- * Calculate mmu pages needed for kvm.
- */
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
-{
-	unsigned long nr_mmu_pages;
-	unsigned long nr_pages = 0;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-
-		kvm_for_each_memslot(memslot, slots)
-			nr_pages += memslot->npages;
-	}
-
-	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-
-	return nr_mmu_pages;
-}
-
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdc0c18339fb..6f9d9c7457d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11588,9 +11588,21 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (!kvm->arch.n_requested_mmu_pages)
-		kvm_mmu_change_mmu_pages(kvm,
-				kvm_mmu_calculate_default_mmu_pages(kvm));
+	if (change == KVM_MR_CREATE)
+		kvm->arch.n_memslots_pages += new->npages;
+	else if (change == KVM_MR_DELETE) {
+		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
+		kvm->arch.n_memslots_pages -= old->npages;
+	}
+
+	if (!kvm->arch.n_requested_mmu_pages) {
+		unsigned long nr_mmu_pages;
+
+		nr_mmu_pages = kvm->arch.n_memslots_pages *
+			       KVM_PERMILLE_MMU_PAGES / 1000;
+		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);
 

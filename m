Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E457235E1A1
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhDMOel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:34:41 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49746 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhDMOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:33:58 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lWJkH-0003zD-73; Tue, 13 Apr 2021 16:10:25 +0200
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
Subject: [PATCH v2 1/8] KVM: x86: Cache total page count to avoid traversing the memslot array
Date:   Tue, 13 Apr 2021 16:10:07 +0200
Message-Id: <7a3e21252b29f6703efee5d68ed543376d65cd9a.1618322003.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
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
index 44f893043a3c..24356d3f7d01 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -939,6 +939,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
+	unsigned long n_memslots_pages;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
@@ -1426,7 +1427,6 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f31e80a..762314b04a39 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5869,30 +5869,6 @@ int kvm_mmu_module_init(void)
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
index 16fb39503296..c73e5c05be6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10959,9 +10959,21 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
 
 	/*
 	 * FIXME: const-ify all uses of struct kvm_memory_slot.

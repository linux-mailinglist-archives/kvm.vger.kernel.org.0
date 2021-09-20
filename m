Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64B441283A
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbhITVnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:43:15 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:45368 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhITVlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 17:41:12 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mSR0Q-0006PA-1D; Mon, 20 Sep 2021 23:39:18 +0200
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
Subject: [PATCH v5 02/13] KVM: x86: Don't call kvm_mmu_change_mmu_pages() if the count hasn't changed
Date:   Mon, 20 Sep 2021 23:38:50 +0200
Message-Id: <8a94e762e212d2e347ebf5b19cb05f8447c33b29.1632171479.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

There is no point in calling kvm_mmu_change_mmu_pages() for memslot
operations that don't change the total page count, so do it just for
KVM_MR_CREATE and KVM_MR_DELETE.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/x86.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65fdf27b9423..2e4fe2511c5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11609,22 +11609,24 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE)
-		kvm->arch.n_memslots_pages += new->npages;
-	else if (change == KVM_MR_DELETE) {
-		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
-		kvm->arch.n_memslots_pages -= old->npages;
-	}
-
-	if (!kvm->arch.n_requested_mmu_pages) {
-		u64 memslots_pages;
-		unsigned long nr_mmu_pages;
-
-		memslots_pages = kvm->arch.n_memslots_pages * KVM_PERMILLE_MMU_PAGES;
-		do_div(memslots_pages, 1000);
-		nr_mmu_pages = max_t(typeof(nr_mmu_pages),
-				     memslots_pages, KVM_MIN_ALLOC_MMU_PAGES);
-		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
+		if (change == KVM_MR_CREATE)
+			kvm->arch.n_memslots_pages += new->npages;
+		else {
+			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
+			kvm->arch.n_memslots_pages -= old->npages;
+		}
+
+		if (!kvm->arch.n_requested_mmu_pages) {
+			u64 memslots_pages;
+			unsigned long nr_mmu_pages;
+
+			memslots_pages = kvm->arch.n_memslots_pages * KVM_PERMILLE_MMU_PAGES;
+			do_div(memslots_pages, 1000);
+			nr_mmu_pages = max_t(typeof(nr_mmu_pages),
+					     memslots_pages, KVM_MIN_ALLOC_MMU_PAGES);
+			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+		}
 	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);

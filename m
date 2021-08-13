Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3463EBCF8
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhHMUB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:56 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50338 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234190AbhHMUBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:55 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcwD-00041q-8d; Fri, 13 Aug 2021 21:33:53 +0200
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
Subject: [PATCH v4 04/13] KVM: x86: Move n_memslots_pages recalc to kvm_arch_prepare_memory_region()
Date:   Fri, 13 Aug 2021 21:33:17 +0200
Message-Id: <ee41f805f86fe1a50f3dfd9d9584d26ece9b9b19.1628871412.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

This allows us to return a proper error code in case we spot an underflow.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/x86.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ab0de7483ef..f39bf3c3a054 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11490,9 +11490,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, new,
-						  mem->memory_size >> PAGE_SHIFT);
+	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
+		int ret;
+
+		ret = kvm_alloc_memslot_metadata(kvm, new,
+						 mem->memory_size >> PAGE_SHIFT);
+		if (ret)
+			return ret;
+
+		if (change == KVM_MR_CREATE)
+			kvm->arch.n_memslots_pages += new->npages;
+	} else if (change == KVM_MR_DELETE) {
+		if (WARN_ON(kvm->arch.n_memslots_pages < old->npages))
+			return -EIO;
+
+		kvm->arch.n_memslots_pages -= old->npages;
+	}
+
 	return 0;
 }
 
@@ -11589,22 +11603,15 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
-		if (change == KVM_MR_CREATE)
-			kvm->arch.n_memslots_pages += new->npages;
-		else {
-			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
-			kvm->arch.n_memslots_pages -= old->npages;
-		}
-
-		if (!kvm->arch.n_requested_mmu_pages) {
-			unsigned long nr_mmu_pages;
+	/* Only CREATE or DELETE affects n_memslots_pages */
+	if ((change == KVM_MR_CREATE || change == KVM_MR_DELETE) &&
+	    !kvm->arch.n_requested_mmu_pages) {
+		unsigned long nr_mmu_pages;
 
-			nr_mmu_pages = kvm->arch.n_memslots_pages *
-				KVM_PERMILLE_MMU_PAGES / 1000;
-			nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
-		}
+		nr_mmu_pages = kvm->arch.n_memslots_pages *
+			KVM_PERMILLE_MMU_PAGES / 1000;
+		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);

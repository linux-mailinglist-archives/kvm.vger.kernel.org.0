Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312133EBCF2
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhHMUB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:27 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50296 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234251AbhHMUBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:24 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcw2-00041X-I6; Fri, 13 Aug 2021 21:33:42 +0200
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
Subject: [PATCH v4 02/13] KVM: x86: Don't call kvm_mmu_change_mmu_pages() if the count hasn't changed
Date:   Fri, 13 Aug 2021 21:33:15 +0200
Message-Id: <f333b277e9109ee4b45bad6b5ced6e90a578ff57.1628871412.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
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
 arch/x86/kvm/x86.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f9d9c7457d7..6bbfc53518d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11588,20 +11588,22 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE)
-		kvm->arch.n_memslots_pages += new->npages;
-	else if (change == KVM_MR_DELETE) {
-		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
-		kvm->arch.n_memslots_pages -= old->npages;
-	}
+	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
+		if (change == KVM_MR_CREATE)
+			kvm->arch.n_memslots_pages += new->npages;
+		else {
+			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
+			kvm->arch.n_memslots_pages -= old->npages;
+		}
 
-	if (!kvm->arch.n_requested_mmu_pages) {
-		unsigned long nr_mmu_pages;
+		if (!kvm->arch.n_requested_mmu_pages) {
+			unsigned long nr_mmu_pages;
 
-		nr_mmu_pages = kvm->arch.n_memslots_pages *
-			       KVM_PERMILLE_MMU_PAGES / 1000;
-		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+			nr_mmu_pages = kvm->arch.n_memslots_pages *
+				KVM_PERMILLE_MMU_PAGES / 1000;
+			nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+		}
 	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);

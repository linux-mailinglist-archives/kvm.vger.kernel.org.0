Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC8464079
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbhK3VqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:46:10 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56106 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344326AbhK3VqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:46:05 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAtI-0005xu-Vn; Tue, 30 Nov 2021 22:42:21 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/29] KVM: arm64: Use "new" memslot instead of userspace memory region
Date:   Tue, 30 Nov 2021 22:41:19 +0100
Message-Id: <9ea539d46841ea863b0bc46397062c4e0944aa2f.1638304315.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Get the slot ID, hva, etc... from the "new" memslot instead of the
userspace memory region when preparing/committing a memory region.  This
will allow a future commit to drop @mem from the prepare/commit hooks
once all architectures convert to using "new".

Opportunistically wait to get the hva begin+end until after filtering out
the DELETE case in anticipation of a future commit passing NULL for @new
when deleting a memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5d474360bf6c..dd95350ea15d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1473,14 +1473,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
 		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, mem->slot);
+			kvm_mmu_wp_memory_region(kvm, new->id);
 		}
 	}
 }
@@ -1491,8 +1491,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	hva_t hva = mem->userspace_addr;
-	hva_t reg_end = hva + mem->memory_size;
+	hva_t hva, reg_end;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1506,6 +1505,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	hva = new->userspace_addr;
+	reg_end = hva + (new->npages << PAGE_SHIFT);
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes

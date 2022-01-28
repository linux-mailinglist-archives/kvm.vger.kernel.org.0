Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123B04A02F6
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 22:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351469AbiA1VhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 16:37:07 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:34544 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347668AbiA1VhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 16:37:05 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nDYvI-0008TI-5c; Fri, 28 Jan 2022 22:36:48 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Michal Hocko <mhocko@suse.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix rmap allocation for very large memslots
Date:   Fri, 28 Jan 2022 22:36:42 +0100
Message-Id: <1acaee7fa7ef7ab91e51f4417572b099caf2f400.1643405658.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") has
forbidden using kvmalloc() to make allocations larger than INT_MAX (2 GiB).

Unfortunately, adding a memslot exceeding 1 TiB in size will result in rmap
code trying to make an allocation exceeding this limit.
Besides failing this allocation, such operation will also trigger a
WARN_ON_ONCE() added by the aforementioned commit.

Since we probably still want to use kernel slab for small rmap allocations
let's only redirect such oversized allocations to vmalloc.

A possible alternative would be to add some kind of a __GFP_LARGE flag to
skip the INT_MAX check behind kvmalloc(), however this will impact the
common kernel memory allocation code, not just KVM.

Fixes: a7c3e901a4 ("mm: introduce kv[mz]alloc helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/x86.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8033eca6f3a1..c64bac8614c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11806,24 +11806,36 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 {
-	const int sz = sizeof(*slot->arch.rmap[0]);
+	const size_t sz = sizeof(*slot->arch.rmap[0]);
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		int level = i + 1;
-		int lpages = __kvm_mmu_slot_lpages(slot, npages, level);
+		size_t lpages = __kvm_mmu_slot_lpages(slot, npages, level);
+		size_t rmap_size;
 
 		if (slot->arch.rmap[i])
 			continue;
 
-		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.rmap[i]) {
-			memslot_rmap_free(slot);
-			return -ENOMEM;
-		}
+		if (unlikely(check_mul_overflow(lpages, sz, &rmap_size)))
+			goto ret_fail;
+
+		/* kvzalloc() only allows sizes up to INT_MAX */
+		if (unlikely(rmap_size > INT_MAX))
+			slot->arch.rmap[i] = __vmalloc(rmap_size,
+						       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		else
+			slot->arch.rmap[i] = kvzalloc(rmap_size, GFP_KERNEL_ACCOUNT);
+
+		if (!slot->arch.rmap[i])
+			goto ret_fail;
 	}
 
 	return 0;
+
+ret_fail:
+	memslot_rmap_free(slot);
+	return -ENOMEM;
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,

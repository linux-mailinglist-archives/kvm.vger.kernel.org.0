Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772D218D9DB
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCTU4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:56:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgCTUzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:48 -0400
IronPort-SDR: zBOXt9AIK2pA/NfnUCLlmB88OZU4UxuqvreV8/at98T3h62uRy2txAGSjOODIIlCzO9UroCUrg
 UeqCv10w1bkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:47 -0700
IronPort-SDR: OUj5t6iz8d0eZtivRlx4QNpH4zqb8RymZ0YbZYk/OPYGii3ES4xsc5w3DGMWvQqAlBRFaZvkyg
 9q4P3wc+4UTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543317"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 1/7] KVM: Fix out of range accesses to memslots
Date:   Fri, 20 Mar 2020 13:55:40 -0700
Message-Id: <20200320205546.2396-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the LRU slot if it becomes invalid when deleting a memslot to fix
an out-of-bounds/use-after-free access when searching through memslots.

Explicitly check for there being no used slots in search_memslots(), and
in the caller of s390's approximation variant.

Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")
Reported-by: Qian Cai <cai@lca.pw>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 include/linux/kvm_host.h | 3 +++
 virt/kvm/kvm_main.c      | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 807ed6d722dd..cb15fdda1fee 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2002,6 +2002,9 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *ms;
 
+	if (unlikely(!slots->used_slots))
+		return 0;
+
 	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
 	ms = gfn_to_memslot(kvm, cur_gfn);
 	args->count = 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 35bc52e187a2..b19dee4ed7d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1032,6 +1032,9 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 	int slot = atomic_read(&slots->lru_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
 
+	if (unlikely(!slots->used_slots))
+		return NULL;
+
 	if (gfn >= memslots[slot].base_gfn &&
 	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
 		return &memslots[slot];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28eae681859f..f744bc603c53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -882,6 +882,9 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 
 	slots->used_slots--;
 
+	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
+		atomic_set(&slots->lru_slot, 0);
+
 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
 		mslots[i] = mslots[i + 1];
 		slots->id_to_index[mslots[i].id] = i;
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B02313E20
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhBHSx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:53:58 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:60334 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhBHSwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:52:37 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l9BdK-00044c-5D; Mon, 08 Feb 2021 19:51:38 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/mmu: Make HVA handler retpoline-friendly
Date:   Mon,  8 Feb 2021 19:51:32 +0100
Message-Id: <732d3fe9eb68aa08402a638ab0309199fa89ae56.1612810129.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

When retpolines are enabled they have high overhead in the inner loop
inside kvm_handle_hva_range() that iterates over the provided memory area.

Let's mark this function and its TDP MMU equivalent __always_inline so
compiler will be able to change the call to the actual handler function
inside each of them into a direct one.

This significantly improves performance on the unmap test on the existing
kernel memslot code (tested on a Xeon 8167M machine):
30 slots in use:
Test       Before   After     Improvement
Unmap      0.0353s  0.0334s   5%
Unmap 2M   0.00104s 0.000407s 61%

509 slots in use:
Test       Before   After     Improvement
Unmap      0.0742s  0.0740s   None
Unmap 2M   0.00221s 0.00159s  28%

Looks like having an indirect call in these functions (and, so, a
retpoline) might have interfered with unrolling of the whole loop in the
CPU.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
Changes from v1:
    * Switch from static dispatch to __always_inline annotation.
    
    * Separate this patch from the rest of log(n) memslot code changes.
    
    * Redo benchmarks.

 arch/x86/kvm/mmu/mmu.c     | 21 +++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..38d7a38609d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1456,16 +1456,17 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	     slot_rmap_walk_okay(_iter_);				\
 	     slot_rmap_walk_next(_iter_))
 
-static int kvm_handle_hva_range(struct kvm *kvm,
-				unsigned long start,
-				unsigned long end,
-				unsigned long data,
-				int (*handler)(struct kvm *kvm,
-					       struct kvm_rmap_head *rmap_head,
-					       struct kvm_memory_slot *slot,
-					       gfn_t gfn,
-					       int level,
-					       unsigned long data))
+static __always_inline int
+kvm_handle_hva_range(struct kvm *kvm,
+		     unsigned long start,
+		     unsigned long end,
+		     unsigned long data,
+		     int (*handler)(struct kvm *kvm,
+				    struct kvm_rmap_head *rmap_head,
+				    struct kvm_memory_slot *slot,
+				    gfn_t gfn,
+				    int level,
+				    unsigned long data))
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b56d604809b8..f26c2269291f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -639,11 +639,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	return ret;
 }
 
-static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
-		unsigned long end, unsigned long data,
-		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       struct kvm_mmu_page *root, gfn_t start,
-			       gfn_t end, unsigned long data))
+static __always_inline int
+kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
+			     unsigned long start,
+			     unsigned long end,
+			     unsigned long data,
+			     int (*handler)(struct kvm *kvm,
+					    struct kvm_memory_slot *slot,
+					    struct kvm_mmu_page *root,
+					    gfn_t start,
+					    gfn_t end,
+					    unsigned long data))
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;

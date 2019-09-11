Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D395EB0484
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfIKTTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 15:19:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:16558 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbfIKTTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 15:19:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 12:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187274874"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 11 Sep 2019 12:19:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Manually flush collapsible SPTEs only when toggling flags
Date:   Wed, 11 Sep 2019 12:19:52 -0700
Message-Id: <20190911191952.31126-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zapping collapsible sptes, a.k.a. 4k sptes that can be promoted into a
large page, is only necessary when changing only the dirty logging flag
of a memory region.  If the memslot is also being moved, then all sptes
for the memslot are zapped when it is invalidated.  When a memslot is
being created, it is impossible for there to be existing dirty mappings,
e.g. KVM can have MMIO sptes, but not present, and thus dirty, sptes.

Note, the comment and logic are shamelessly borrowed from MIPS's version
of kvm_arch_commit_memory_region().

Fixes: 3ea3b7fa9af06 ("kvm: mmu: lazy collapse small sptes into large sptes")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..70e82e8f5c41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9635,8 +9635,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * Scan sptes if dirty logging has been stopped, dropping those
 	 * which can be collapsed into a single large-page spte.  Later
 	 * page faults will create the large-page sptes.
+	 *
+	 * There is no need to do this in any of the following cases:
+	 * CREATE:	No dirty mappings will already exist.
+	 * MOVE/DELETE:	The old mappings will already have been cleaned up by
+	 *		kvm_arch_flush_shadow_memslot()
 	 */
-	if ((change != KVM_MR_DELETE) &&
+	if (change == KVM_MR_FLAGS_ONLY &&
 		(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
 		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
-- 
2.22.0


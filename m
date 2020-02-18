Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2019A163409
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgBRVIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:08:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:6396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbgBRVHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:07:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:07:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="253856465"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 20/22] KVM: x86/mmu: Move kvm_arch_flush_remote_tlbs_memslot() to mmu.c
Date:   Tue, 18 Feb 2020 13:07:34 -0800
Message-Id: <20200218210736.16432-21-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_arch_flush_remote_tlbs_memslot() from x86.c to mmu.c in
preparation for calling kvm_flush_remote_tlbs_with_address() instead of
kvm_flush_remote_tlbs().  The with_address() variant is statically
defined in mmu.c, arguably kvm_arch_flush_remote_tlbs_memslot() belongs
in mmu.c anyways, and defining kvm_arch_flush_remote_tlbs_memslot() in
mmu.c will allow the compiler to inline said function when a future
patch consolidates open coded variants of the function.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++++++++
 arch/x86/kvm/x86.c     | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..026e4a5c8e86 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5942,6 +5942,17 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	spin_unlock(&kvm->mmu_lock);
 }
 
+void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
+					struct kvm_memory_slot *memslot)
+{
+	/*
+	 * All the TLBs can be flushed out of mmu lock, see the comments in
+	 * kvm_mmu_slot_remove_write_access().
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+	kvm_flush_remote_tlbs(kvm);
+}
+
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd3c2abb715..fa3bff857578 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4759,17 +4759,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_x86_ops->flush_log_dirty(kvm);
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					struct kvm_memory_slot *memslot)
-{
-	/*
-	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs(kvm);
-}
-
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 			bool line_status)
 {
-- 
2.24.1


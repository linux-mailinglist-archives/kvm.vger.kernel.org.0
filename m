Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081AA4244BD
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhJFRmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53654 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239113AbhJFRmh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:37 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 31F3A307CAEC;
        Wed,  6 Oct 2021 20:31:03 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 177F0305FFA0;
        Wed,  6 Oct 2021 20:31:03 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 24/77] KVM: x86: page track: provide all callbacks with the guest virtual address
Date:   Wed,  6 Oct 2021 20:30:20 +0300
Message-Id: <20211006173113.26445-25-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed because the emulator calls the page tracking code
irrespective of the current VM-exit reason or available information.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h       |  2 +-
 arch/x86/include/asm/kvm_page_track.h | 10 ++++++----
 arch/x86/kvm/mmu/mmu.c                |  2 +-
 arch/x86/kvm/mmu/page_track.c         |  6 +++---
 arch/x86/kvm/x86.c                    | 16 ++++++++--------
 drivers/gpu/drm/i915/gvt/kvmgt.c      |  2 +-
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 43569a6fc776..692e55a5c312 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1610,7 +1610,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const void *val, int bytes);
 
 struct kvm_irq_mask_notifier {
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 79d84a94f8eb..f981b6360de5 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -28,12 +28,14 @@ struct kvm_page_track_notifier_node {
 	 *
 	 * @vcpu: the vcpu where the write access happened.
 	 * @gpa: the physical address written by guest.
+	 * @gva: the virtual address written by guest.
 	 * @new: the data was written to the address.
 	 * @bytes: the written length.
 	 * @node: this node
 	 */
-	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			    int bytes, struct kvm_page_track_notifier_node *node);
+	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			    const u8 *new, int bytes,
+			    struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being moved or removed
 	 * users can drop write-protection for the pages in that memory slot
@@ -72,7 +74,7 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes);
+void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			  const u8 *new, int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..a802c46d0e16 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5115,7 +5115,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
 {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index bb5d60bd4dbf..e0b1cdd3013e 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -281,8 +281,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
  * The node should figure out if the written page is the one that node is
  * interested in by itself.
  */
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes)
+void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			  const u8 *new, int bytes)
 {
 	struct kvm_page_track_notifier_head *head;
 	struct kvm_page_track_notifier_node *n;
@@ -297,7 +297,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
 				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
-			n->track_write(vcpu, gpa, new, bytes, n);
+			n->track_write(vcpu, gpa, gva, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b01d865f6047..723ef3b7f95f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6592,7 +6592,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
 }
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			const void *val, int bytes)
 {
 	int ret;
@@ -6600,14 +6600,14 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	ret = kvm_vcpu_write_guest(vcpu, gpa, val, bytes);
 	if (ret < 0)
 		return 0;
-	kvm_page_track_write(vcpu, gpa, val, bytes);
+	kvm_page_track_write(vcpu, gpa, gva, val, bytes);
 	return 1;
 }
 
 struct read_write_emulator_ops {
 	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
 				  int bytes);
-	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
+	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 				  void *val, int bytes);
 	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       int bytes, void *val);
@@ -6628,16 +6628,16 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 	return 0;
 }
 
-static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
+static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			void *val, int bytes)
 {
 	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
 }
 
-static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
+static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			 void *val, int bytes)
 {
-	return emulator_write_phys(vcpu, gpa, val, bytes);
+	return emulator_write_phys(vcpu, gpa, gva, val, bytes);
 }
 
 static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
@@ -6705,7 +6705,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
+	if (!ret && ops->read_write_emulate(vcpu, gpa, addr, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	/*
@@ -6874,7 +6874,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_page_track_write(vcpu, gpa, new, bytes);
+	kvm_page_track_write(vcpu, gpa, addr, new, bytes);
 
 	return X86EMUL_CONTINUE;
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 7efa386449d1..e0c7c17a439d 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1854,7 +1854,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	return 0;
 }
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		const u8 *val, int len,
 		struct kvm_page_track_notifier_node *node)
 {

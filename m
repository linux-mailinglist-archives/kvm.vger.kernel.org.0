Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5B2D1B13
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgLGUsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:19 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42604 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727230AbgLGUsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:18 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4AE65305D513;
        Mon,  7 Dec 2020 22:46:16 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 231563072785;
        Mon,  7 Dec 2020 22:46:16 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 27/81] KVM: x86: page track: provide all callbacks with the guest virtual address
Date:   Mon,  7 Dec 2020 22:45:28 +0200
Message-Id: <20201207204622.15258-28-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
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
index 65bce8aeede5..2ffc11c5c6c0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1396,7 +1396,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const void *val, int bytes);
 
 struct kvm_irq_mask_notifier {
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..9a261e463eb3 100644
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
@@ -68,7 +70,7 @@ kvm_page_track_register_notifier(struct kvm *kvm,
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
index 5dfe0ede0e81..1631e2367085 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4963,7 +4963,7 @@ static const union kvm_mmu_page_role role_ign = {
 	.invalid = 0x1,
 };
 
-static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
 {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 8443a675715b..d7a591a85af8 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -216,8 +216,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
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
@@ -232,7 +232,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
 				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
-			n->track_write(vcpu, gpa, new, bytes, n);
+			n->track_write(vcpu, gpa, gva, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f48603c8e44d..c2f13a275448 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6115,7 +6115,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
 }
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			const void *val, int bytes)
 {
 	int ret;
@@ -6123,14 +6123,14 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -6151,16 +6151,16 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
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
@@ -6228,7 +6228,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
+	if (!ret && ops->read_write_emulate(vcpu, gpa, addr, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	/*
@@ -6397,7 +6397,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_page_track_write(vcpu, gpa, new, bytes);
+	kvm_page_track_write(vcpu, gpa, addr, new, bytes);
 
 	return X86EMUL_CONTINUE;
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index ad8a9df49f29..4e370b216365 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1749,7 +1749,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	return 0;
 }
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		const u8 *val, int len,
 		struct kvm_page_track_notifier_node *node)
 {

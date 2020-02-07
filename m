Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF6F155DC3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBGSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:26 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40646 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727516AbgBGSQr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:47 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 012ED305D3E1;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E70DA305206D;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 30/78] KVM: x86: page track: provide all page tracking hooks with the guest virtual address
Date:   Fri,  7 Feb 2020 20:15:48 +0200
Message-Id: <20200207181636.1065-31-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 77de935979b2..378a094ceb5b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1324,7 +1324,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const void *val, int bytes);
 
 struct kvm_irq_mask_notifier {
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 172f9749dbb2..e91f5a16e741 100644
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
@@ -69,7 +71,7 @@ kvm_page_track_register_notifier(struct kvm *kvm,
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
index 6f92b40d798c..f2e016dfffe6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5412,7 +5412,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
 {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 3521e2d176f2..dc891d6a2553 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -220,8 +220,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
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
@@ -235,7 +235,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	idx = srcu_read_lock(&head->track_srcu);
 	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
 		if (n->track_write)
-			n->track_write(vcpu, gpa, new, bytes, n);
+			n->track_write(vcpu, gpa, gva, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4565f3cce201..0dd43cf5d2b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5554,7 +5554,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
 }
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			const void *val, int bytes)
 {
 	int ret;
@@ -5562,14 +5562,14 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -5590,16 +5590,16 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
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
@@ -5668,7 +5668,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
+	if (!ret && ops->read_write_emulate(vcpu, gpa, addr, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	/*
@@ -5827,7 +5827,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_page_track_write(vcpu, gpa, new, bytes);
+	kvm_page_track_write(vcpu, gpa, addr, new, bytes);
 
 	return X86EMUL_CONTINUE;
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 04a5a0d90823..59e2f783c6e9 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1682,7 +1682,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	return 0;
 }
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		const u8 *val, int len,
 		struct kvm_page_track_notifier_node *node)
 {

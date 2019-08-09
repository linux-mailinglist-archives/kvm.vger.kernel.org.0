Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4587FB2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437280AbfHIQUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:46 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53312 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407414AbfHIQT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CB08B305D3DE;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 870E7305B7A0;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 22/92] kvm: x86: provide all page tracking hooks with the guest virtual address
Date:   Fri,  9 Aug 2019 18:59:37 +0300
Message-Id: <20190809160047.8319-23-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed because the emulator calls the page tracking code
irrespective of the current VMEXIT reason or available information.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h       |  2 +-
 arch/x86/include/asm/kvm_page_track.h |  9 +++++----
 arch/x86/kvm/mmu.c                    |  2 +-
 arch/x86/kvm/page_track.c             |  6 +++---
 arch/x86/kvm/x86.c                    | 16 ++++++++--------
 drivers/gpu/drm/i915/gvt/kvmgt.c      |  2 +-
 6 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 67ed934ca124..2d6bde6fa59f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1263,7 +1263,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const void *val, int bytes);
 
 struct kvm_irq_mask_notifier {
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 18a94d180485..0492a85f3a44 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -32,8 +32,9 @@ struct kvm_page_track_notifier_node {
 	 * @bytes: the written length.
 	 * @node: this node
 	 */
-	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			    int bytes, struct kvm_page_track_notifier_node *node);
+	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			    const u8 *new, int bytes,
+			    struct kvm_page_track_notifier_node *node);
 	void (*track_create_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages,
 				  struct kvm_page_track_notifier_node *node);
@@ -72,7 +73,7 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes);
+void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			  const u8 *new, int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f2d1d230d5b8..9898d863b6b6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5222,7 +5222,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
 {
diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/page_track.c
index db5b906876bb..ff7defb4a1d2 100644
--- a/arch/x86/kvm/page_track.c
+++ b/arch/x86/kvm/page_track.c
@@ -236,8 +236,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
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
@@ -251,7 +251,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	idx = srcu_read_lock(&head->track_srcu);
 	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
 		if (n->track_write)
-			n->track_write(vcpu, gpa, new, bytes, n);
+			n->track_write(vcpu, gpa, gva, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f66db9473ea3..d3d159986243 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5281,7 +5281,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
 }
 
-int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			const void *val, int bytes)
 {
 	int ret;
@@ -5289,14 +5289,14 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
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
@@ -5317,16 +5317,16 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
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
@@ -5395,7 +5395,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
+	if (!ret && ops->read_write_emulate(vcpu, gpa, addr, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	/*
@@ -5556,7 +5556,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 		return X86EMUL_CMPXCHG_FAILED;
 
 	kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
-	kvm_page_track_write(vcpu, gpa, new, bytes);
+	kvm_page_track_write(vcpu, gpa, addr, new, bytes);
 
 	return X86EMUL_CONTINUE;
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index dd3dfd00f4e6..4bd2cdf79f86 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1550,7 +1550,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	return 0;
 }
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		const u8 *val, int len,
 		struct kvm_page_track_notifier_node *node)
 {

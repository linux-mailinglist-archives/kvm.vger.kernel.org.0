Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DA16F85E6
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjEEPei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjEEPeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:34:36 -0400
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc09])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08C611A;
        Fri,  5 May 2023 08:34:33 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZD66dQnzMqFxM;
        Fri,  5 May 2023 17:21:58 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZD60R4vzMpxBm;
        Fri,  5 May 2023 17:21:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300118;
        bh=SrFXUO04Nqgobaetk479001er96mJxIHBBoQ7lZlahM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpaXL8F3FW0faPdmfsziq7KNPT5JCNQ53r4Uxr1P2zxnScOSqz2qoUmOrpuWgBv6i
         NuH/ri5XXTqceSyc0YP1flR3e6CIXrSsEa0s/oRFw99Emxppybi4No1rUvvsCb7yVM
         kRuXppKZpZtphifBIw5w6qtCumEL2JsEPthxKuz0=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v1 2/9] KVM: x86/mmu: Add support for prewrite page tracking
Date:   Fri,  5 May 2023 17:20:39 +0200
Message-Id: <20230505152046.6575-3-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new page tracking mode to deny a page update and throw a page
fault to the guest.  This is useful for KVM to be able to make some
pages non-writable (not read-only because it doesn't imply execution
restrictions), see the next Heki commits.

This kind of synthetic kernel page fault needs to be handled by the
guest, which is not currently the case, making it try again and again.
This will be part of a follow-up patch series.

Update emulator_read_write_onepage() to handle X86EMUL_CONTINUE and
X86EMUL_PROPAGATE_FAULT.

Update page_fault_handle_page_track() to call
kvm_slot_page_track_is_active() whenever this is required for
KVM_PAGE_TRACK_PREWRITE and KVM_PAGE_TRACK_WRITE, even if one tracker
already returned true.

Invert the return code semantic for read_emulate() and write_emulate():
- from 1=Ok 0=Error
- to X86EMUL_* return codes (e.g. X86EMUL_CONTINUE == 0)

Imported the prewrite page tracking support part originally written by
Mihai Donțu, Marian Rotariu, and Ștefan Șicleru:
https://lore.kernel.org/r/20211006173113.26445-27-alazar@bitdefender.com
https://lore.kernel.org/r/20211006173113.26445-28-alazar@bitdefender.com
Removed the GVA changes for page tracking, removed the
X86EMUL_RETRY_INSTR case, and some emulation part for now.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Marian Rotariu <marian.c.rotariu@gmail.com>
Cc: Mihai Donțu <mdontu@bitdefender.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230505152046.6575-3-mic@digikod.net
---
 arch/x86/include/asm/kvm_page_track.h | 12 +++++
 arch/x86/kvm/mmu/mmu.c                | 64 ++++++++++++++++++++++-----
 arch/x86/kvm/mmu/page_track.c         | 33 +++++++++++++-
 arch/x86/kvm/mmu/spte.c               |  6 +++
 arch/x86/kvm/x86.c                    | 27 +++++++----
 5 files changed, 122 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..a7fb4ff888e6 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_KVM_PAGE_TRACK_H
 
 enum kvm_page_track_mode {
+	KVM_PAGE_TRACK_PREWRITE,
 	KVM_PAGE_TRACK_WRITE,
 	KVM_PAGE_TRACK_MAX,
 };
@@ -22,6 +23,16 @@ struct kvm_page_track_notifier_head {
 struct kvm_page_track_notifier_node {
 	struct hlist_node node;
 
+	/*
+	 * It is called when guest is writing the write-tracked page
+	 * and the write emulation didn't happened yet.
+	 *
+	 * @vcpu: the vcpu where the write access happened
+	 * @gpa: the physical address written by guest
+	 * @node: this nodet
+	 */
+	bool (*track_prewrite)(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when guest is writing the write-tracked page
 	 * and write emulation is finished at that time.
@@ -73,6 +84,7 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
+bool kvm_page_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa);
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 835426254e76..e5d1e241ff0f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -793,9 +793,13 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slot = __gfn_to_memslot(slots, gfn);
 
 	/* the non-leaf shadow pages are keeping readonly. */
-	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn,
-						    KVM_PAGE_TRACK_WRITE);
+	if (sp->role.level > PG_LEVEL_4K) {
+		kvm_slot_page_track_add_page(kvm, slot, gfn,
+					     KVM_PAGE_TRACK_PREWRITE);
+		kvm_slot_page_track_add_page(kvm, slot, gfn,
+					     KVM_PAGE_TRACK_WRITE);
+		return;
+	}
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -840,9 +844,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	gfn = sp->gfn;
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
-	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						       KVM_PAGE_TRACK_WRITE);
+	if (sp->role.level > PG_LEVEL_4K) {
+		kvm_slot_page_track_remove_page(kvm, slot, gfn,
+						KVM_PAGE_TRACK_PREWRITE);
+		kvm_slot_page_track_remove_page(kvm, slot, gfn,
+						KVM_PAGE_TRACK_WRITE);
+		return;
+	}
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2714,7 +2722,10 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(kvm, slot, gfn,
+						KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_slot_page_track_is_active(kvm, slot, gfn,
+						KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -4103,6 +4114,8 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 					 struct kvm_page_fault *fault)
 {
+	bool ret = false;
+
 	if (unlikely(fault->rsvd))
 		return false;
 
@@ -4113,10 +4126,14 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
-		return true;
+	ret = kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn,
+					    KVM_PAGE_TRACK_PREWRITE) ||
+	      ret;
+	ret = kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn,
+					    KVM_PAGE_TRACK_WRITE) ||
+	      ret;
 
-	return false;
+	return ret;
 }
 
 static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
@@ -5600,6 +5617,33 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (r != RET_PF_EMULATE)
 		return 1;
 
+	if ((error_code & PFERR_WRITE_MASK) &&
+	    !kvm_page_track_prewrite(vcpu, cr2_or_gpa)) {
+		struct x86_exception fault = {
+			.vector = PF_VECTOR,
+			.error_code_valid = true,
+			.error_code = error_code,
+			.nested_page_fault = false,
+			/*
+			 * TODO: This kind of kernel page fault needs to be handled by
+			 * the guest, which is not currently the case, making it try
+			 * again and again.
+			 *
+			 * You may want to test with cr2_or_gva to see the page
+			 * fault caught by the guest kernel (thinking it is a
+			 * user space fault).
+			 */
+			.address = static_call(kvm_x86_fault_gva)(vcpu),
+			.async_page_fault = false,
+		};
+
+		pr_warn_ratelimited(
+			"heki-kvm: Creating write #PF at 0x%016llx\n",
+			fault.address);
+		kvm_inject_page_fault(vcpu, &fault);
+		return RET_PF_INVALID;
+	}
+
 	/*
 	 * Before emulating the instruction, check if the error code
 	 * was due to a RO violation while translating the guest page.
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2e09d1b6249f..2454887cd48b 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -131,9 +131,10 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
-	if (mode == KVM_PAGE_TRACK_WRITE)
+	if (mode == KVM_PAGE_TRACK_PREWRITE || mode == KVM_PAGE_TRACK_WRITE) {
 		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
 			kvm_flush_remote_tlbs(kvm);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
 
@@ -248,6 +249,36 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
 
+/*
+ * Notify the node that a write access is about to happen. Returning false
+ * doesn't stop the other nodes from being called, but it will stop
+ * the emulation.
+ *
+ * The node should figure out if the written page is the one that the node
+ * is interested in by itself.
+ */
+bool kvm_page_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+	bool ret = true;
+
+	head = &vcpu->kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return ret;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				  srcu_read_lock_held(&head->track_srcu))
+		if (n->track_prewrite)
+			if (!n->track_prewrite(vcpu, gpa, n))
+				ret = false;
+	srcu_read_unlock(&head->track_srcu, idx);
+	return ret;
+}
+
 /*
  * Notify the node that write access is intercepted and write emulation is
  * finished at this time.
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c0fd7e049b4e..639f220a1ed5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -144,6 +144,12 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
+	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn,
+					  KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn,
+					  KVM_PAGE_TRACK_WRITE))
+		pte_access &= ~ACC_WRITE_MASK;
+
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
 	if (sp->role.ad_disabled)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c299d47e69..fd05f42c9913 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7325,6 +7325,7 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 			r = X86EMUL_IO_NEEDED;
 			goto out;
 		}
+		kvm_page_track_write(vcpu, gpa, data, towrite);
 
 		bytes -= towrite;
 		data += towrite;
@@ -7441,13 +7442,12 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			const void *val, int bytes)
 {
-	int ret;
-
-	ret = kvm_vcpu_write_guest(vcpu, gpa, val, bytes);
-	if (ret < 0)
-		return 0;
+	if (!kvm_page_track_prewrite(vcpu, gpa))
+		return X86EMUL_PROPAGATE_FAULT;
+	if (kvm_vcpu_write_guest(vcpu, gpa, val, bytes))
+		return X86EMUL_UNHANDLEABLE;
 	kvm_page_track_write(vcpu, gpa, val, bytes);
-	return 1;
+	return X86EMUL_CONTINUE;
 }
 
 struct read_write_emulator_ops {
@@ -7477,7 +7477,9 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 			void *val, int bytes)
 {
-	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
+	if (kvm_vcpu_read_guest(vcpu, gpa, val, bytes))
+		return X86EMUL_UNHANDLEABLE;
+	return X86EMUL_CONTINUE;
 }
 
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -7551,8 +7553,12 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
-		return X86EMUL_CONTINUE;
+	if (!ret) {
+		ret = ops->read_write_emulate(vcpu, gpa, val, bytes);
+		if (ret != X86EMUL_UNHANDLEABLE)
+			/* Handles X86EMUL_CONTINUE and X86EMUL_PROPAGATE_FAULT. */
+			return ret;
+	}
 
 	/*
 	 * Is this MMIO handled locally?
@@ -7689,6 +7695,9 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (kvm_is_error_hva(hva))
 		goto emul_write;
 
+	if (!kvm_page_track_prewrite(vcpu, gpa))
+		return X86EMUL_PROPAGATE_FAULT;
+
 	hva += offset_in_page(gpa);
 
 	switch (bytes) {
-- 
2.40.1


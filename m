Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E892197908
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgC3KVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43874 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729530AbgC3KUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 224F43074B6F;
        Mon, 30 Mar 2020 13:12:54 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F28E6305B7A0;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 35/81] KVM: x86: wire in the preread/prewrite/preexec page trackers
Date:   Mon, 30 Mar 2020 13:12:22 +0300
Message-Id: <20200330101308.21702-36-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

These are needed by the introspection subsystem.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             |  4 +++
 arch/x86/kvm/mmu/mmu.c             | 57 +++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                 | 42 +++++++++++++++++-----
 4 files changed, 83 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index c06e8353efd3..3dac53d56a85 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -461,6 +461,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+#define EMULATION_RETRY_INSTR 3
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bc00642e5d3b..6503f8ce7be3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5447,6 +5447,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
 
 done:
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
 	if (rc == X86EMUL_PROPAGATE_FAULT)
 		ctxt->have_exception = true;
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
@@ -5816,6 +5818,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	if (rc == X86EMUL_INTERCEPTED)
 		return EMULATION_INTERCEPTED;
 
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
 	if (rc == X86EMUL_CONTINUE)
 		writeback_registers(ctxt);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd82cf1fb6a2..7c6368ddc6a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1233,9 +1233,13 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slot = __gfn_to_memslot(slots, gfn);
 
 	/* the non-leaf shadow pages are keeping readonly. */
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn,
-						    KVM_PAGE_TRACK_WRITE);
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL) {
+		kvm_slot_page_track_add_page(kvm, slot, gfn,
+					     KVM_PAGE_TRACK_PREWRITE);
+		kvm_slot_page_track_add_page(kvm, slot, gfn,
+					     KVM_PAGE_TRACK_WRITE);
+		return;
+	}
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
@@ -1261,9 +1265,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	gfn = sp->gfn;
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						       KVM_PAGE_TRACK_WRITE);
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL) {
+		kvm_slot_page_track_remove_page(kvm, slot, gfn,
+						KVM_PAGE_TRACK_PREWRITE);
+		kvm_slot_page_track_remove_page(kvm, slot, gfn,
+						KVM_PAGE_TRACK_WRITE);
+		return;
+	}
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -3000,7 +3008,8 @@ static bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_mmu_page *sp;
 
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
@@ -3423,6 +3432,21 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 	}
 }
 
+static unsigned int kvm_mmu_apply_introspection_access(struct kvm_vcpu *vcpu,
+							gfn_t gfn,
+							unsigned int acc)
+{
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREREAD))
+		acc &= ~ACC_USER_MASK;
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+		acc &= ~ACC_WRITE_MASK;
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREEXEC))
+		acc &= ~ACC_EXEC_MASK;
+
+	return acc;
+}
+
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 			int map_writable, int max_level, kvm_pfn_t pfn,
 			bool prefault, bool account_disallowed_nx_lpage)
@@ -3432,6 +3456,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	int level, ret;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
+	unsigned int acc;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
@@ -3461,7 +3486,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 		}
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
+	acc = kvm_mmu_apply_introspection_access(vcpu, base_gfn, ACC_ALL);
+
+	ret = mmu_set_spte(vcpu, it.sptep, acc,
 			   write, level, base_gfn, pfn, prefault,
 			   map_writable);
 	direct_pte_prefetch(vcpu, it.sptep);
@@ -4125,15 +4152,21 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	if (unlikely(error_code & PFERR_RSVD_MASK))
 		return false;
 
-	if (!(error_code & PFERR_PRESENT_MASK) ||
-	      !(error_code & PFERR_WRITE_MASK))
+	if (!(error_code & PFERR_PRESENT_MASK))
 		return false;
 
 	/*
-	 * guest is writing the page which is write tracked which can
+	 * guest is reading/writing/fetching the page which is
+	 * read/write/execute tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (((error_code & PFERR_USER_MASK)
+		&& kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREREAD))
+	    || ((error_code & PFERR_WRITE_MASK)
+		&& (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE)
+		 || kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE)))
+	    || ((error_code & PFERR_FETCH_MASK)
+		&& kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREEXEC)))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17e8a9d4e138..d35cdda115cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5435,6 +5435,8 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
+		if (!kvm_page_track_preread(vcpu, gpa, addr, toread))
+			return X86EMUL_RETRY_INSTR;
 		ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, data,
 					       offset, toread);
 		if (ret < 0) {
@@ -5466,6 +5468,9 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	if (unlikely(gpa == UNMAPPED_GVA))
 		return X86EMUL_PROPAGATE_FAULT;
 
+	if (!kvm_page_track_preexec(vcpu, gpa, addr))
+		return X86EMUL_RETRY_INSTR;
+
 	offset = addr & (PAGE_SIZE-1);
 	if (WARN_ON(offset + bytes > PAGE_SIZE))
 		bytes = (unsigned)PAGE_SIZE - offset;
@@ -5646,13 +5651,22 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			const void *val, int bytes)
 {
-	int ret;
-
-	ret = kvm_vcpu_write_guest(vcpu, gpa, val, bytes);
-	if (ret < 0)
-		return 0;
+	if (!kvm_page_track_prewrite(vcpu, gpa, gva, val, bytes))
+		return X86EMUL_RETRY_INSTR;
+	if (kvm_vcpu_write_guest(vcpu, gpa, val, bytes) < 0)
+		return X86EMUL_UNHANDLEABLE;
 	kvm_page_track_write(vcpu, gpa, gva, val, bytes);
-	return 1;
+	return X86EMUL_CONTINUE;
+}
+
+static int emulator_read_phys(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			      void *val, int bytes)
+{
+	if (!kvm_page_track_preread(vcpu, gpa, gva, bytes))
+		return X86EMUL_RETRY_INSTR;
+	if (kvm_vcpu_read_guest(vcpu, gpa, val, bytes) < 0)
+		return X86EMUL_UNHANDLEABLE;
+	return X86EMUL_CONTINUE;
 }
 
 struct read_write_emulator_ops {
@@ -5682,7 +5696,7 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			void *val, int bytes)
 {
-	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
+	return emulator_read_phys(vcpu, gpa, gva, val, bytes);
 }
 
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
@@ -5757,8 +5771,11 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, addr, val, bytes))
-		return X86EMUL_CONTINUE;
+	if (!ret) {
+		ret = ops->read_write_emulate(vcpu, gpa, addr, val, bytes);
+		if (ret == X86EMUL_CONTINUE || ret == X86EMUL_RETRY_INSTR)
+			return ret;
+	}
 
 	/*
 	 * Is this MMIO handled locally?
@@ -5892,6 +5909,9 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
 		goto emul_write;
 
+	if (!kvm_page_track_prewrite(vcpu, gpa, addr, new, bytes))
+		return X86EMUL_RETRY_INSTR;
+
 	kaddr = map.hva + offset_in_page(gpa);
 
 	switch (bytes) {
@@ -6787,6 +6807,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 		trace_kvm_emulate_insn_start(vcpu);
 		++vcpu->stat.insn_emulation;
+		if (r == EMULATION_RETRY_INSTR)
+			return 1;
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
@@ -6845,6 +6867,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	r = x86_emulate_insn(ctxt);
 
+	if (r == EMULATION_RETRY_INSTR)
+		return 1;
 	if (r == EMULATION_INTERCEPTED)
 		return 1;
 

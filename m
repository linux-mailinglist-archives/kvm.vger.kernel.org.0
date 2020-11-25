Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4F2C3CB6
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgKYJmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:46 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57200 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbgKYJmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:01 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9A9C9305D510;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6A6283072784;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        Stefan Sicleru <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 30/81] KVM: x86: wire in the preread/prewrite/preexec page trackers
Date:   Wed, 25 Nov 2020 11:35:09 +0200
Message-Id: <20201125093600.2766-31-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

These are needed in order to notify the introspection tool when
read/write/execute access happens on one of the tracked memory pages.

Also, this patch adds the case when the introspection tool requests
that the vCPU re-enter in guest (and abort the emulation of the current
instruction).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Stefan Sicleru <ssicleru@bitdefender.com>
Signed-off-by: Stefan Sicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c     |  4 ++++
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/mmu/mmu.c     | 38 +++++++++++++++++++++-----------
 arch/x86/kvm/mmu/spte.c    | 17 ++++++++++++++
 arch/x86/kvm/x86.c         | 45 ++++++++++++++++++++++++++++++--------
 5 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56cae1ff9e3f..ad32632d4dcb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5474,6 +5474,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
 
 done:
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
 	if (rc == X86EMUL_PROPAGATE_FAULT)
 		ctxt->have_exception = true;
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
@@ -5845,6 +5847,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	if (rc == X86EMUL_INTERCEPTED)
 		return EMULATION_INTERCEPTED;
 
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
 	if (rc == X86EMUL_CONTINUE)
 		writeback_registers(ctxt);
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 43c93ffa76ed..5bfab8d65cd1 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -496,6 +496,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+#define EMULATION_RETRY_INSTR 3
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36add6fb712f..23b72532cd18 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -769,9 +769,13 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
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
 }
@@ -797,9 +801,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -2601,7 +2609,8 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_mmu_page *sp;
 
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
@@ -3689,15 +3698,18 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	if (unlikely(error_code & PFERR_RSVD_MASK))
 		return false;
 
-	if (!(error_code & PFERR_PRESENT_MASK) ||
-	      !(error_code & PFERR_WRITE_MASK))
-		return false;
-
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
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fcac2cac78fe..9225b80ab209 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -81,6 +81,21 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
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
 int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
@@ -89,6 +104,8 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	u64 spte = 0;
 	int ret = 0;
 
+	pte_access = kvm_mmu_apply_introspection_access(vcpu, gfn, pte_access);
+
 	if (ad_disabled)
 		spte |= SPTE_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4d19da016c12..a82db6b30aee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5911,6 +5911,8 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
+		if (!kvm_page_track_preread(vcpu, gpa, addr, toread))
+			return X86EMUL_RETRY_INSTR;
 		ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, data,
 					       offset, toread);
 		if (ret < 0) {
@@ -5942,6 +5944,9 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	if (unlikely(gpa == UNMAPPED_GVA))
 		return X86EMUL_PROPAGATE_FAULT;
 
+	if (!kvm_page_track_preexec(vcpu, gpa, addr))
+		return X86EMUL_RETRY_INSTR;
+
 	offset = addr & (PAGE_SIZE-1);
 	if (WARN_ON(offset + bytes > PAGE_SIZE))
 		bytes = (unsigned)PAGE_SIZE - offset;
@@ -6010,11 +6015,14 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
+		if (!kvm_page_track_prewrite(vcpu, gpa, addr, data, towrite))
+			return X86EMUL_RETRY_INSTR;
 		ret = kvm_vcpu_write_guest(vcpu, gpa, data, towrite);
 		if (ret < 0) {
 			r = X86EMUL_IO_NEEDED;
 			goto out;
 		}
+		kvm_page_track_write(vcpu, gpa, addr, data, towrite);
 
 		bytes -= towrite;
 		data += towrite;
@@ -6118,13 +6126,22 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
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
@@ -6154,7 +6171,7 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			void *val, int bytes)
 {
-	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
+	return emulator_read_phys(vcpu, gpa, gva, val, bytes);
 }
 
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
@@ -6228,8 +6245,11 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
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
@@ -6373,6 +6393,9 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
 		goto emul_write;
 
+	if (!kvm_page_track_prewrite(vcpu, gpa, addr, new, bytes))
+		return X86EMUL_RETRY_INSTR;
+
 	kaddr = map.hva + offset_in_page(gpa);
 
 	switch (bytes) {
@@ -7323,6 +7346,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 		trace_kvm_emulate_insn_start(vcpu);
 		++vcpu->stat.insn_emulation;
+		if (r == EMULATION_RETRY_INSTR)
+			return 1;
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
@@ -7392,6 +7417,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	r = x86_emulate_insn(ctxt);
 
+	if (r == EMULATION_RETRY_INSTR)
+		return 1;
 	if (r == EMULATION_INTERCEPTED)
 		return 1;
 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92E387FA8
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437253AbfHIQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:18 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53310 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437140AbfHIQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7FAAD301ACC2;
        Fri,  9 Aug 2019 19:01:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 341AA305B7A0;
        Fri,  9 Aug 2019 19:01:00 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [RFC PATCH v6 24/92] kvm: x86: wire in the preread/prewrite/preexec page trackers
Date:   Fri,  9 Aug 2019 18:59:39 +0300
Message-Id: <20190809160047.8319-25-alazar@bitdefender.com>
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

These are needed by the introspection subsystem.

CC: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             | 10 +++++-
 arch/x86/kvm/mmu.c                 | 37 ++++++++++++++-------
 arch/x86/kvm/x86.c                 | 52 ++++++++++++++++++++++++------
 4 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 93c4bf598fb0..97cb592687cb 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -444,6 +444,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+#define EMULATION_RETRY_INSTR 3
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c338984c850d..34431cf31f74 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5366,7 +5366,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
 
 done:
-	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
+	else if (rc == X86EMUL_CONTINUE)
+		return EMULATION_OK;
+	else
+		return EMULATION_FAILED;
 }
 
 bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt)
@@ -5736,6 +5741,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	if (rc == X86EMUL_INTERCEPTED)
 		return EMULATION_INTERCEPTED;
 
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
+
 	if (rc == X86EMUL_CONTINUE)
 		writeback_registers(ctxt);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a86b165cf6dd..ff053f17b8c2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1111,9 +1111,13 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -1128,9 +1132,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -2884,7 +2892,8 @@ static bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_mmu_page *sp;
 
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
@@ -4006,15 +4015,21 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
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
index d3d159986243..7aef002be551 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5065,6 +5065,7 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 {
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
+	bool data_ready;
 
 	while (bytes) {
 		gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access,
@@ -5075,6 +5076,13 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
+		if (!kvm_page_track_preread(vcpu, gpa, addr, data, toread,
+						&data_ready))
+			return X86EMUL_RETRY_INSTR;
+		if (data_ready) {
+			WARN_ON(toread > bytes); /* TODO */
+			return X86EMUL_CONTINUE;
+		}
 		ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, data,
 					       offset, toread);
 		if (ret < 0) {
@@ -5106,6 +5114,9 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	if (unlikely(gpa == UNMAPPED_GVA))
 		return X86EMUL_PROPAGATE_FAULT;
 
+	if (!kvm_page_track_preexec(vcpu, gpa, addr))
+		return X86EMUL_RETRY_INSTR;
+
 	offset = addr & (PAGE_SIZE-1);
 	if (WARN_ON(offset + bytes > PAGE_SIZE))
 		bytes = (unsigned)PAGE_SIZE - offset;
@@ -5284,13 +5295,26 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
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
+	bool data_ready;
+
+	if (!kvm_page_track_preread(vcpu, gpa, gva, val, bytes, &data_ready))
+		return X86EMUL_RETRY_INSTR;
+	if (data_ready)
+		return X86EMUL_CONTINUE;
+	if (kvm_vcpu_read_guest(vcpu, gpa, val, bytes) < 0)
+		return X86EMUL_UNHANDLEABLE;
+	return X86EMUL_CONTINUE;
 }
 
 struct read_write_emulator_ops {
@@ -5320,7 +5344,7 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			void *val, int bytes)
 {
-	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
+	return emulator_read_phys(vcpu, gpa, gva, val, bytes);
 }
 
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
@@ -5395,8 +5419,11 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
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
@@ -5531,6 +5558,9 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (is_error_page(page))
 		goto emul_write;
 
+	if (!kvm_page_track_prewrite(vcpu, gpa, addr, new, bytes))
+		return X86EMUL_RETRY_INSTR;
+
 	kaddr = kmap_atomic(page);
 	kaddr += offset_in_page(gpa);
 	switch (bytes) {
@@ -6416,6 +6446,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 		trace_kvm_emulate_insn_start(vcpu);
 		++vcpu->stat.insn_emulation;
+		if (r == EMULATION_RETRY_INSTR)
+			return EMULATE_DONE;
 		if (r != EMULATION_OK)  {
 			if (emulation_type & EMULTYPE_TRAP_UD)
 				return EMULATE_FAIL;
@@ -6457,6 +6489,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	r = x86_emulate_insn(ctxt);
 
+	if (r == EMULATION_RETRY_INSTR)
+		return EMULATE_DONE;
 	if (r == EMULATION_INTERCEPTED)
 		return EMULATE_DONE;
 

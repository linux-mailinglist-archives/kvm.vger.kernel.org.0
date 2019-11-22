Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CAC107AF9
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKVW6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:58:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:15520 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKVW6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:58:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:58:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="382219000"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Nov 2019 14:58:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Add EMULTYPE_PF when emulation is triggered by a page fault
Date:   Fri, 22 Nov 2019 14:58:30 -0800
Message-Id: <20191122225832.26684-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122225832.26684-1-sean.j.christopherson@intel.com>
References: <20191122225832.26684-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new emulation type flag to explicitly mark emulation related to a
page fault.  Use the new flag, EMULTYPE_PF, to move the propagation of
the GPA into the emulator context from the page fault handler into
x86_emulate_instruction.

Similarly, to help clarify how cr2 is used, don't propagate cr2 into the
exception.address when it's *not* valid and instead explicitly zero out
exception.address.  Functionally this is a nop, as all non-EMULTYPE_PF
callers pass zero for cr2, i.e. it's effectively a documentation update.
Zeroing exception.address is probably unnecessary as it shouldn't be
exposed to the guest for non-#PF exceptions, but keep the current
behavior to avoid introducing an unintentional function change.

Append _PF to EMULTYPE_ALLOW_RETRY to make it clear retrying is only
intended for use when emulating after a #PF, and add WARNs to enforce
that notion.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++++---
 arch/x86/kvm/mmu/mmu.c          | 10 ++--------
 arch/x86/kvm/x86.c              | 25 +++++++++++++++++++------
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..6311fffbc2f0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1347,8 +1347,9 @@ extern u64 kvm_mce_cap_supported;
  *		   decode the instruction length.  For use *only* by
  *		   kvm_x86_ops->skip_emulated_instruction() implementations.
  *
- * EMULTYPE_ALLOW_RETRY - Set when the emulator should resume the guest to
- *			  retry native execution under certain conditions.
+ * EMULTYPE_ALLOW_RETRY_PF - Set when the emulator should resume the guest to
+ *			     retry native execution under certain conditions,
+ *			     Can only be set in conjunction with EMULTYPE_PF.
  *
  * EMULTYPE_TRAP_UD_FORCED - Set when emulating an intercepted #UD that was
  *			     triggered by KVM's magic "force emulation" prefix,
@@ -1361,13 +1362,18 @@ extern u64 kvm_mce_cap_supported;
  *			backdoor emulation, which is opt in via module param.
  *			VMware backoor emulation handles select instructions
  *			and reinjects the #GP for all other cases.
+ *
+ * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
+ *		 case the CR2/GPA value pass on the stack is valid.
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
-#define EMULTYPE_ALLOW_RETRY	    (1 << 3)
+#define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
+#define EMULTYPE_PF		    (1 << 6)
+
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..fa49d9971b59 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5519,15 +5519,9 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		       void *insn, int insn_len)
 {
-	int r, emulation_type = 0;
+	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->direct_map;
 
-	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
-	if (vcpu->arch.mmu->direct_map) {
-		vcpu->arch.gpa_available = true;
-		vcpu->arch.gpa_val = cr2;
-	}
-
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2, direct);
@@ -5572,7 +5566,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
 	 */
 	if (!mmio_info_in_cache(vcpu, cr2, direct) && !is_guest_mode(vcpu))
-		emulation_type = EMULTYPE_ALLOW_RETRY;
+		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
 	/*
 	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a256e09f321a..848e4ec21c5e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6393,10 +6393,11 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 	gpa_t gpa = cr2;
 	kvm_pfn_t pfn;
 
-	if (!(emulation_type & EMULTYPE_ALLOW_RETRY))
+	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)))
+	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
+	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
 	if (!vcpu->arch.mmu->direct_map) {
@@ -6484,10 +6485,11 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	 */
 	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
 
-	if (!(emulation_type & EMULTYPE_ALLOW_RETRY))
+	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)))
+	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
+	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
 	if (x86_page_table_writing_insn(ctxt))
@@ -6742,8 +6744,19 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	}
 
 restart:
-	/* Save the faulting GPA (cr2) in the address field */
-	ctxt->exception.address = cr2;
+	if (emulation_type & EMULTYPE_PF) {
+		/* Save the faulting GPA (cr2) in the address field */
+		ctxt->exception.address = cr2;
+
+		/* With shadow page tables, cr2 contains a GVA or nGPA. */
+		if (vcpu->arch.mmu->direct_map) {
+			vcpu->arch.gpa_available = true;
+			vcpu->arch.gpa_val = cr2;
+		}
+	} else {
+		/* Sanitize the address out of an abundance of paranoia. */
+		ctxt->exception.address = 0;
+	}
 
 	r = x86_emulate_insn(ctxt);
 
-- 
2.24.0


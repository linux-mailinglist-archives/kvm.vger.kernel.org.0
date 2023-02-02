Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B65E688663
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBBS2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjBBS2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:40 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA93865ED1
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:22 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id s5-20020a170903214500b00195e3b26848so1299717ple.7
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3LgqJvQdTUnDV8KRYP5nK1SQHicVLOIOxzAR2ICFNms=;
        b=pTHp9YIB2s9i7ADRCxkxVMBN5TbosV9207UzxT5JLIoA0iiwHbPDOCF2B0ulq0gjTz
         dmAyphmWqMmPznzay2s5DpCEp6NHjMRfjIIOhNALqfZq69tbr0GklWjDEBSb6T6yiMcI
         Acuzx3NkksjEreIyP7FImla+4q+h2dTJ7RCe9MYgXigjsRFI8fyQnksSrbMoHYw8b91W
         ziXGJ4LKf1/CT/L9ptzIHGgioiuiR31ITCTvKCYXTdb0PQKQH3W7HHV1V2qWrfBNepiz
         dUAZbmAh8qZCWqN/6bAgBFqW5SsXLlahiTC1ecRRDFk1WgO502NqjIWWgNW35qFckskp
         oU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3LgqJvQdTUnDV8KRYP5nK1SQHicVLOIOxzAR2ICFNms=;
        b=XwDkRBksDI83N2naupGdrRBaD8sCA8exLb5SQ691eTyGhGRWqOYo36sobNbHMIoyjR
         92e+bQMXnbgPBobfdjLsgWZ9PJFCl8Y0G9309M+jGQKugKYuYQOIaaB58l2LBasSiMHo
         zGIhWYasWNAFSJk5f4hvOB5x/ZTqZpdTyOfODD7svRddY52nbjzxFIPVB/YuCtMvFhHE
         yw1+biAIly3ch9BxogV6gri1TTSCujGuvyK99+Of2TojMb0wpuv2spiQAPNJ9hVpstrW
         VT/fpJRxHVownm/5Zi8AOreUuwFVJWsmir3juFlGTXLger3TwPoK0Dz5BQVjqqZfgR2C
         3R6w==
X-Gm-Message-State: AO0yUKVwoxj2xRXnyXTpcewm0ovZoSdsYYrIq6N/Z1Lc8b9lGwxob9Qa
        +phHmz2ZAjG75Gvic3N6J3r3iNiiQWU=
X-Google-Smtp-Source: AK7set8791yB3wjoH7FuBUwIUtJIVac8TGy0qezAzhWOiy6iUzV6fwbwC2DKjeSjG9TB4l1FbkQDVo+TZsI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3da4:b0:22c:24f0:32f4 with SMTP id
 i33-20020a17090a3da400b0022c24f032f4mr755189pjc.93.1675362501969; Thu, 02 Feb
 2023 10:28:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  2 Feb 2023 18:28:15 +0000
In-Reply-To: <20230202182817.407394-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230202182817.407394-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182817.407394-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: x86/mmu: Use EMULTYPE flag to track write #PFs to
 shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Hang <hhuang@linux.alibaba.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a new EMULTYPE flag, EMULTYPE_WRITE_PF_TO_SP, to track page faults
on self-changing writes to shadowed page tables instead of propagating
that information to the emulator via a semi-persistent vCPU flag.  Using
a flag in "struct kvm_vcpu_arch" is confusing, especially as implemented,
as it's not at all obvious that clearing the flag only when emulation
actually occurs is correct.

E.g. if KVM sets the flag and then retries the fault without ever getting
to the emulator, the flag will be left set for future calls into the
emulator.  But because the flag is consumed if and only if both
EMULTYPE_PF and EMULTYPE_ALLOW_RETRY_PF are set, and because
EMULTYPE_ALLOW_RETRY_PF is deliberately not set for direct MMUs, emulated
MMIO, or while L2 is active, KVM avoids false positives on a stale flag
since FNAME(page_fault) is guaranteed to be run and refresh the flag
before it's ultimately consumed by the tail end of reexecute_instruction().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 37 ++++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu.c          |  5 +++--
 arch/x86/kvm/mmu/mmu_internal.h | 12 ++++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 +---
 arch/x86/kvm/x86.c              | 15 ++-----------
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..a0fa6333edbe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -942,23 +942,6 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
-	/*
-	 * Indicates the guest is trying to write a gfn that contains one or
-	 * more of the PTEs used to translate the write itself, i.e. the access
-	 * is changing its own translation in the guest page tables.  KVM exits
-	 * to userspace if emulation of the faulting instruction fails and this
-	 * flag is set, as KVM cannot make forward progress.
-	 *
-	 * If emulation fails for a write to guest page tables, KVM unprotects
-	 * (zaps) the shadow page for the target gfn and resumes the guest to
-	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
-	 * gfn doesn't allow forward progress for a self-changing access because
-	 * doing so also zaps the translation for the gfn, i.e. retrying the
-	 * instruction will hit a !PRESENT fault, which results in a new shadow
-	 * page and sends KVM back to square one.
-	 */
-	bool write_fault_to_shadow_pgtable;
-
 	/* set at EPT violation at this point */
 	unsigned long exit_qualification;
 
@@ -1891,6 +1874,25 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
  * EMULTYPE_COMPLETE_USER_EXIT - Set when the emulator should update interruptibility
  *				 state and inject single-step #DBs after skipping
  *				 an instruction (after completing userspace I/O).
+ *
+ * EMULTYPE_WRITE_PF_TO_SP - Set when emulating an intercepted page fault that
+ *			     is attempting to write a gfn that contains one or
+ *			     more of the PTEs used to translate the write itself,
+ *			     and the owning page table is being shadowed by KVM.
+ *			     If emulation of the faulting instruction fails and
+ *			     this flag is set, KVM will exit to userspace instead
+ *			     of retrying emulation as KVM cannot make forward
+ *			     progress.
+ *
+ *			     If emulation fails for a write to guest page tables,
+ *			     KVM unprotects (zaps) the shadow page for the target
+ *			     gfn and resumes the guest to retry the non-emulatable
+ *			     instruction (on hardware).  Unprotecting the gfn
+ *			     doesn't allow forward progress for a self-changing
+ *			     access because doing so also zaps the translation for
+ *			     the gfn, i.e. retrying the instruction will hit a
+ *			     !PRESENT fault, which results in a new shadow page
+ *			     and sends KVM back to square one.
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -1900,6 +1902,7 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
+#define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..bf38575a1957 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4203,7 +4203,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -5664,7 +5664,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 
 	if (r == RET_PF_INVALID) {
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false);
+					  lower_32_bits(error_code), false,
+					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cc58631e2336..2cbb155c686c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -240,6 +240,13 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+
+	/*
+	 * Indicates the guest is trying to write a gfn that contains one or
+	 * more of the PTEs used to translate the write itself, i.e. the access
+	 * is changing its own translation in the guest page tables.
+	 */
+	bool write_fault_to_shadow_pgtable;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -273,7 +280,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch)
+					u32 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -312,6 +319,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	else
 		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
 
+	if (fault.write_fault_to_shadow_pgtable && emulation_type)
+		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
 	 * async #PF path doesn't do emulation.  Do count faults that are fixed
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9..5d2958299b4f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -825,10 +825,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	vcpu->arch.write_fault_to_shadow_pgtable = false;
-
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-	      &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
+	      &walker, fault->user, &fault->write_fault_to_shadow_pgtable);
 
 	if (is_self_change_mapping)
 		fault->max_level = PG_LEVEL_4K;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..de2a0d1c9c21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8427,7 +8427,6 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 }
 
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				  bool write_fault_to_shadow_pgtable,
 				  int emulation_type)
 {
 	gpa_t gpa = cr2_or_gpa;
@@ -8498,7 +8497,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * be fixed by unprotecting shadow page and it should
 	 * be reported to userspace.
 	 */
-	return !write_fault_to_shadow_pgtable;
+	return !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
 }
 
 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
@@ -8746,20 +8745,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	int r;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	bool writeback = true;
-	bool write_fault_to_spt;
 
 	if (unlikely(!kvm_can_emulate_insn(vcpu, emulation_type, insn, insn_len)))
 		return 1;
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
-	/*
-	 * Clear write_fault_to_shadow_pgtable here to ensure it is
-	 * never reused.
-	 */
-	write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
-	vcpu->arch.write_fault_to_shadow_pgtable = false;
-
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
 
@@ -8780,7 +8771,6 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				return 1;
 			}
 			if (reexecute_instruction(vcpu, cr2_or_gpa,
-						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
 
@@ -8859,8 +8849,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2_or_gpa, write_fault_to_spt,
-					emulation_type))
+		if (reexecute_instruction(vcpu, cr2_or_gpa, emulation_type))
 			return 1;
 
 		return handle_emulation_failure(vcpu, emulation_type);
-- 
2.39.1.519.gcb327c4b5f-goog


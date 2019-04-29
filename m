Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976E6DE9B
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfD2JDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:03:06 -0400
Received: from ozlabs.org ([203.11.71.1]:50773 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfD2JDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 05:03:05 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44szFy2WMzz9s47; Mon, 29 Apr 2019 19:03:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556528582; bh=RlRN4OLR3H1+94X+iB+2A7lD1W5cuqU8o9l9I3+G3Oo=;
        h=Date:From:To:Cc:Subject:From;
        b=p3P/dxk8/yz64vnWvm41xuOVagoiYdzyX9uue3etWNxU8FMLBOtx7l6N245ptBFv+
         F4UX4PbVBrxeYrZ1ryWETSkBaLLWWj3SKqj0qBE9TOwj1cKMN50VNqDawCmXDzzS8+
         baEXmmWzq+MEQb7XCh3s3EvVjV8JXxYxrqmUupIuaZbONeUTc0dm9H8fvk7Fbe/G9s
         OaBGM3kf0zPyiCqISBOPQfEaXr6phD2cOr2vb6lSDWauXx5LI0NMD+ipJmP77Ltccn
         Cb9SAizWOWT6sYpyTesg3SKSat4ddp9G/Sp22b+9bhUDzWoaaJL1PTXIkjycPJIDlZ
         LdGJepNRZ51ew==
Date:   Mon, 29 Apr 2019 19:00:40 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: Move HPT guest TLB flushing to C
 code
Message-ID: <20190429090040.GA18822@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This replaces assembler code in book3s_hv_rmhandlers.S that checks
the kvm->arch.need_tlb_flush cpumask and optionally does a TLB flush
with C code in book3s_hv_builtin.c.  Note that unlike the radix
version, the hash version doesn't do an explicit ERAT invalidation
because we will invalidate and load up the SLB before entering the
guest, and that will invalidate the ERAT.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/include/asm/kvm_ppc.h      |  2 ++
 arch/powerpc/kvm/book3s_hv_builtin.c    | 29 +++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 38 ++++-----------------------------
 3 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 0579c9b..f8f7d76 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -481,6 +481,8 @@ extern void kvm_hv_vm_activated(void);
 extern void kvm_hv_vm_deactivated(void);
 extern bool kvm_hv_mode_active(void);
 
+extern void kvmppc_hpt_check_need_tlb_flush(struct kvm *kvm);
+
 #else
 static inline void __init kvm_cma_reserve(void)
 {}
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index b0cf224..489abe5 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -805,3 +805,32 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 		vcpu->arch.doorbell_request = 0;
 	}
 }
+
+void kvmppc_hpt_check_need_tlb_flush(struct kvm *kvm)
+{
+	int pcpu = raw_smp_processor_id();
+	unsigned long rb, set;
+
+	/*
+	 * On POWER9, individual threads can come in here, but the
+	 * TLB is shared between the 4 threads in a core, hence
+	 * invalidating on one thread invalidates for all.
+	 * Thus we make all 4 threads use the same bit.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		pcpu = cpu_first_thread_sibling(pcpu);
+
+	if (cpumask_test_cpu(pcpu, &kvm->arch.need_tlb_flush)) {
+		rb = PPC_BIT(52);	/* IS = 2 */
+		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
+			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
+				     : : "r" (rb), "i" (0), "i" (0), "i" (0),
+				       "r" (0) : "memory");
+			rb += PPC_BIT(51);	/* increment set number */
+		}
+		asm volatile("ptesync": : :"memory");
+
+		/* Clear the bit after the TLB flush */
+		cpumask_clear_cpu(pcpu, &kvm->arch.need_tlb_flush);
+	}
+}
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 139027c..6bfa0c1 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -623,40 +623,10 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	isync
 
 	/* See if we need to flush the TLB. Hash has to be done in RM */
-	lhz	r6,PACAPACAINDEX(r13)	/* test_bit(cpu, need_tlb_flush) */
-BEGIN_FTR_SECTION
-	/*
-	 * On POWER9, individual threads can come in here, but the
-	 * TLB is shared between the 4 threads in a core, hence
-	 * invalidating on one thread invalidates for all.
-	 * Thus we make all 4 threads use the same bit here.
-	 */
-	clrrdi	r6,r6,2
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-	clrldi	r7,r6,64-6		/* extract bit number (6 bits) */
-	srdi	r6,r6,6			/* doubleword number */
-	sldi	r6,r6,3			/* address offset */
-	add	r6,r6,r9
-	addi	r6,r6,KVM_NEED_FLUSH	/* dword in kvm->arch.need_tlb_flush */
-	li	r8,1
-	sld	r8,r8,r7
-	ld	r7,0(r6)
-	and.	r7,r7,r8
-	beq	22f
-	/* Flush the TLB of any entries for this LPID */
-	lwz	r0,KVM_TLB_SETS(r9)
-	mtctr	r0
-	li	r7,0x800		/* IS field = 0b10 */
-	ptesync
-	li	r0,0			/* RS for P9 version of tlbiel */
-28:	tlbiel	r7			/* On P9, rs=0, RIC=0, PRS=0, R=0 */
-	addi	r7,r7,0x1000
-	bdnz	28b
-	ptesync
-23:	ldarx	r7,0,r6			/* clear the bit after TLB flushed */
-	andc	r7,r7,r8
-	stdcx.	r7,0,r6
-	bne	23b
+	mr	r3, r9			/* kvm pointer */
+	bl	kvmppc_hpt_check_need_tlb_flush
+	nop
+	ld	r5, HSTATE_KVM_VCORE(r13)
 
 	/* Add timebase offset onto timebase */
 22:	ld	r8,VCORE_TB_OFFSET(r5)
-- 
2.7.4


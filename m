Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1934363596
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfGIMZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:29 -0400
Received: from foss.arm.com ([217.140.110.172]:42686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbfGIMZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DB5F1477;
        Tue,  9 Jul 2019 05:25:28 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 629CD3F59C;
        Tue,  9 Jul 2019 05:25:26 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/18] KVM: arm64: Consume pending SError as early as possible
Date:   Tue,  9 Jul 2019 13:24:53 +0100
Message-Id: <20190709122507.214494-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

On systems with v8.2 we switch the 'vaxorcism' of guest SError with an
alternative sequence that uses the ESB-instruction, then reads DISR_EL1.
This saves the unmasking and remasking of asynchronous exceptions.

We do this after we've saved the guest registers and restored the
host's. Any SError that becomes pending due to this will be accounted
to the guest, when it actually occurred during host-execution.

Move the ESB-instruction as early as possible. Any guest SError
will become pending due to this ESB-instruction and then consumed to
DISR_EL1 before the host touches anything.

This lets us account for host/guest SError precisely on the guest
exit exception boundary.

Because the ESB-instruction now lands in the preamble section of
the vectors, we need to add it to the unpatched indirect vectors
too, and to any sequence that may be patched in over the top.

The ESB-instruction always lives in the head of the vectors,
to be before any memory write. Whereas the register-store always
lives in the tail.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 2 +-
 arch/arm64/kvm/hyp/entry.S       | 5 ++---
 arch/arm64/kvm/hyp/hyp-entry.S   | 6 +++++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 388e1b520618..44a243754c1b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -34,7 +34,7 @@
  * Size of the HYP vectors preamble. kvm_patch_vector_branch() generates code
  * that jumps over this.
  */
-#define KVM_VECTOR_PREAMBLE	(1 * AARCH64_INSN_SIZE)
+#define KVM_VECTOR_PREAMBLE	(2 * AARCH64_INSN_SIZE)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index bd34016354ba..fb2e218ce0c7 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -127,8 +127,8 @@ ENTRY(__guest_exit)
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-	// without an unmask-SError and isb.
-	esb
+	// without an unmask-SError and isb. The ESB-instruction consumed any
+	// pending guest error when we took the exception from the guest.
 	mrs_s	x2, SYS_DISR_EL1
 	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
 	cbz	x2, 1f
@@ -146,7 +146,6 @@ alternative_else
 	mov	x5, x0
 
 	dsb	sy		// Synchronize against in-flight ld/st
-	nop
 	msr	daifclr, #4	// Unmask aborts
 alternative_endif
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index a911b8ffc0f3..ffa68d5713f1 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -226,6 +226,7 @@ ENDPROC(\label)
 .macro valid_vect target
 	.align 7
 661:
+	esb
 	stp	x0, x1, [sp, #-16]!
 662:
 	b	\target
@@ -237,6 +238,7 @@ check_preamble_length 661b, 662b
 	.align 7
 661:
 	b	\target
+	nop
 662:
 	ldp	x0, x1, [sp], #16
 	b	\target
@@ -269,7 +271,8 @@ ENDPROC(__kvm_hyp_vector)
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 .macro hyp_ventry
 	.align 7
-1:	.rept 27
+1:	esb
+	.rept 26
 	nop
 	.endr
 /*
@@ -317,6 +320,7 @@ ENTRY(__bp_harden_hyp_vecs_end)
 	.popsection
 
 ENTRY(__smccc_workaround_1_smc_start)
+	esb
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
 	stp	x0, x1, [sp, #(8 * 2)]
-- 
2.20.1


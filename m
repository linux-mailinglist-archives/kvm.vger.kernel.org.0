Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7763592
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfGIMZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:25 -0400
Received: from foss.arm.com ([217.140.110.172]:42656 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfGIMZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A59ACFC;
        Tue,  9 Jul 2019 05:25:24 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F1B33F59C;
        Tue,  9 Jul 2019 05:25:22 -0700 (PDT)
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
Subject: [PATCH 02/18] KVM: arm64: Abstract the size of the HYP vectors pre-amble
Date:   Tue,  9 Jul 2019 13:24:51 +0100
Message-Id: <20190709122507.214494-3-marc.zyngier@arm.com>
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

The EL2 vector hardening feature causes KVM to generate vectors for
each type of CPU present in the system. The generated sequences already
do some of the early guest-exit work (i.e. saving registers). To avoid
duplication the generated vectors branch to the original vector just
after the preamble. This size is hard coded.

Adding new instructions to the HYP vector causes strange side effects,
which are difficult to debug as the affected code is patched in at
runtime.

Add KVM_VECTOR_PREAMBLE to tell kvm_patch_vector_branch() how big
the preamble is. The valid_vect macro can then validate this at
build time.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h |  6 ++++++
 arch/arm64/kvm/hyp/hyp-entry.S   | 18 +++++++++++++++++-
 arch/arm64/kvm/va_layout.c       |  7 +++----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2ca437ef59fa..388e1b520618 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -30,6 +30,12 @@
 	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
 	{ARM_EXCEPTION_HYP_GONE,	"HYP_GONE"	}
 
+/*
+ * Size of the HYP vectors preamble. kvm_patch_vector_branch() generates code
+ * that jumps over this.
+ */
+#define KVM_VECTOR_PREAMBLE	(1 * AARCH64_INSN_SIZE)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/mm.h>
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index b8e045615961..318a2f3996fc 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -216,17 +216,32 @@ ENDPROC(\label)
 
 	.align 11
 
+.macro check_preamble_length start, end
+/* kvm_patch_vector_branch() generates code that jumps over the preamble. */
+.if ((\end-\start) != KVM_VECTOR_PREAMBLE)
+	.error "KVM vector preamble length mismatch"
+.endif
+.endm
+
 .macro valid_vect target
 	.align 7
+661:
 	stp	x0, x1, [sp, #-16]!
+662:
 	b	\target
+
+check_preamble_length 661b, 662b
 .endm
 
 .macro invalid_vect target
 	.align 7
+661:
 	b	\target
+662:
 	ldp	x0, x1, [sp], #16
 	b	\target
+
+check_preamble_length 661b, 662b
 .endm
 
 ENTRY(__kvm_hyp_vector)
@@ -271,7 +286,8 @@ ENDPROC(__kvm_hyp_vector)
  * movk	x0, #((addr >> 32) & 0xffff), lsl #32
  * br	x0
  *
- * Where addr = kern_hyp_va(__kvm_hyp_vector) + vector-offset + 4.
+ * Where:
+ * addr = kern_hyp_va(__kvm_hyp_vector) + vector-offset + KVM_VECTOR_PREAMBLE.
  * See kvm_patch_vector_branch for details.
  */
 alternative_cb	kvm_patch_vector_branch
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 2947ab1b0fa5..acd8084f1f2c 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -170,11 +170,10 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
 
 	/*
-	 * Branch to the second instruction in the vectors in order to
-	 * avoid the initial store on the stack (which we already
-	 * perform in the hardening vectors).
+	 * Branch over the preamble in order to avoid the initial store on
+	 * the stack (which we already perform in the hardening vectors).
 	 */
-	addr += AARCH64_INSN_SIZE;
+	addr += KVM_VECTOR_PREAMBLE;
 
 	/* stp x0, x1, [sp, #-16]! */
 	insn = aarch64_insn_gen_load_store_pair(AARCH64_INSN_REG_0,
-- 
2.20.1


Return-Path: <kvm+bounces-63155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 025FFC5ACE5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ED267351222
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC88428C862;
	Fri, 14 Nov 2025 00:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFcSF95Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ED12797BE
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080609; cv=none; b=mvhWr34syrakCnH7AfXFT98I2x+CWzfT8HSL9ZeE8/HZCBoTCQkR2xLgsyy9pSXsGoSZjaAVHSqkoMSGd7qOFJJKN0pdszIOHM/GOtYoxVsNx6Wd18RfYUsNi1B9OxzK+meU+b3tdVdEQLPMR+yieabuUjd4rnBKH0OEu5fNPP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080609; c=relaxed/simple;
	bh=PMYWDH/eAvAVOz7oIzkSH1SApkCEL761VG721I3KRFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0ko9SSMD1DnY4C8kJ5LUwbHsv/fIS9gcgbpW/M8Lt8TsB0z99hnJF1jtsHs8A3cDnyDXC2LNpNsNORexVknDBkKd6f1rT50JscLL0v1cCx+x/J4v9ar6p/az0eRXdQWBjOHyqU9NJfWUp0ZBSugoOty92vL4szxb7BE3b/kM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFcSF95Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ww8KhpoFqp+Cp+67q1J1s7L8jYHDIAQUvNnwK771bc=;
	b=MFcSF95QyDeM6AhtL7TkPck5/KnTzSFh8Tjc+0P8xZYRvTGAzo+NiAj7A3c2kr4GAQzMCu
	RD0n8akQFyZXZESFdiCOFGyE6E0Cr9vLYQs7oAHWZJHAhzJ6S1CvmYEtWI5UU3SRye2O26
	kpLNUtxnyOkVNn0/i5lNowNU/oL72xw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-d4G7l3MqMsyHNoD-wPRgZQ-1; Thu,
 13 Nov 2025 19:36:41 -0500
X-MC-Unique: d4G7l3MqMsyHNoD-wPRgZQ-1
X-Mimecast-MFC-AGG-ID: d4G7l3MqMsyHNoD-wPRgZQ_1763080600
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0225418AB414;
	Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A5F019560B9;
	Fri, 14 Nov 2025 00:36:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 07/10] KVM: emulate: add AVX support to register fetch and writeback
Date: Thu, 13 Nov 2025 19:36:30 -0500
Message-ID: <20251114003633.60689-8-pbonzini@redhat.com>
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Prepare struct operand for hosting AVX registers.  Remove the
existing, incomplete code that placed the Avx flag in the operand
alignment field, and repurpose the name for a separate bit that
indicates:

- after decode, whether an instruction supports the VEX prefix;

- before writeback, that the instruction did have the VEX prefix and
therefore 1) it can have op_bytes == 32; 2) t should clear high
bytes of XMM registers.

Right now the bit will never be set and the patch has no intended
functional change.  However, this is actually more vexing than the
decoder changes itself, and therefore worth separating.

Co-developed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c     | 58 ++++++++++++++++++++++++++---------
 arch/x86/kvm/fpu.h         | 62 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/kvm_emulate.h |  7 +++--
 3 files changed, 110 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6c8d3f786e74..94dc8a61965b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -141,6 +141,7 @@
 #define No64        (1<<28)     /* Instruction generates #UD in 64-bit mode */
 #define PageTable   (1 << 29)   /* instruction used to write page table */
 #define NotImpl     (1 << 30)   /* instruction is not implemented */
+#define Avx         ((u64)1 << 31)   /* Instruction uses VEX prefix */
 #define Src2Shift   (32)        /* Source 2 operand type at bits 32-36 */
 #define Src2None    (OpNone << Src2Shift)
 #define Src2Mem     (OpMem << Src2Shift)
@@ -157,12 +158,11 @@
 #define Src2Mask    (OpMask << Src2Shift)
 /* free: 37-39 */
 #define Mmx         ((u64)1 << 40)  /* MMX Vector instruction */
-#define AlignMask   ((u64)7 << 41)  /* Memory alignment requirement at bits 41-43 */
+#define AlignMask   ((u64)3 << 41)  /* Memory alignment requirement at bits 41-42 */
 #define Aligned     ((u64)1 << 41)  /* Explicitly aligned (e.g. MOVDQA) */
 #define Unaligned   ((u64)2 << 41)  /* Explicitly unaligned (e.g. MOVDQU) */
-#define Avx         ((u64)3 << 41)  /* Advanced Vector Extensions */
-#define Aligned16   ((u64)4 << 41)  /* Aligned to 16 byte boundary (e.g. FXSAVE) */
-/* free: 44 */
+#define Aligned16   ((u64)3 << 41)  /* Aligned to 16 byte boundary (e.g. FXSAVE) */
+/* free: 43-44 */
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
 #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
@@ -618,7 +618,6 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
 
 	switch (alignment) {
 	case Unaligned:
-	case Avx:
 		return 1;
 	case Aligned16:
 		return 16;
@@ -1075,7 +1074,14 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 static void __decode_register_operand(struct x86_emulate_ctxt *ctxt,
 				      struct operand *op, int reg)
 {
-	if (ctxt->d & Sse) {
+	if ((ctxt->d & Avx) && ctxt->op_bytes == 32) {
+		op->type = OP_YMM;
+		op->bytes = 32;
+		op->addr.xmm = reg;
+		kvm_read_avx_reg(reg, &op->vec_val2);
+		return;
+	}
+	if (ctxt->d & (Avx|Sse)) {
 		op->type = OP_XMM;
 		op->bytes = 16;
 		op->addr.xmm = reg;
@@ -1767,7 +1773,15 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 				       op->data,
 				       op->bytes * op->count);
 	case OP_XMM:
-		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
+		if (!(ctxt->d & Avx)) {
+			kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
+			break;
+		}
+		/* full YMM write but with high bytes cleared */
+		memset(op->valptr + 16, 0, 16);
+		fallthrough;
+	case OP_YMM:
+		kvm_write_avx_reg(op->addr.xmm, &op->vec_val2);
 		break;
 	case OP_MM:
 		kvm_write_mmx_reg(op->addr.mm, &op->mm_val);
@@ -4861,9 +4875,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		ctxt->op_bytes = 8;	/* REX.W */
 
 	/* Opcode byte(s). */
-	opcode = opcode_table[ctxt->b];
-	/* Two-byte opcode? */
 	if (ctxt->b == 0x0f) {
+		/* Two- or three-byte opcode */
 		ctxt->opcode_len = 2;
 		ctxt->b = insn_fetch(u8, ctxt);
 		opcode = twobyte_table[ctxt->b];
@@ -4874,6 +4887,9 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			ctxt->b = insn_fetch(u8, ctxt);
 			opcode = opcode_map_0f_38[ctxt->b];
 		}
+	} else {
+		/* Opcode byte(s). */
+		opcode = opcode_table[ctxt->b];
 	}
 	ctxt->d = opcode.flags;
 
@@ -5022,7 +5038,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			ctxt->op_bytes = 4;
 
 		if (ctxt->d & Sse)
-			ctxt->op_bytes = 16;
+			ctxt->op_bytes = 16, ctxt->d &= ~Avx;
 		else if (ctxt->d & Mmx)
 			ctxt->op_bytes = 8;
 	}
@@ -5154,20 +5170,34 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts)
 	}
 
 	if (unlikely(ctxt->d &
-		     (No64|Undefined|Sse|Mmx|Intercept|CheckPerm|Priv|Prot|String))) {
+		     (No64|Undefined|Avx|Sse|Mmx|Intercept|CheckPerm|Priv|Prot|String))) {
 		if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
 				(ctxt->d & Undefined)) {
 			rc = emulate_ud(ctxt);
 			goto done;
 		}
 
-		if (((ctxt->d & (Sse|Mmx)) && ((ops->get_cr(ctxt, 0) & X86_CR0_EM)))
-		    || ((ctxt->d & Sse) && !(ops->get_cr(ctxt, 4) & X86_CR4_OSFXSR))) {
+		if ((ctxt->d & (Avx|Sse|Mmx)) && ((ops->get_cr(ctxt, 0) & X86_CR0_EM))) {
 			rc = emulate_ud(ctxt);
 			goto done;
 		}
 
-		if ((ctxt->d & (Sse|Mmx)) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
+		if (ctxt->d & Avx) {
+			u64 xcr = 0;
+			if (!(ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE)
+			    || ops->get_xcr(ctxt, 0, &xcr)
+			    || !(xcr & XFEATURE_MASK_YMM)) {
+				rc = emulate_ud(ctxt);
+				goto done;
+			}
+		} else if (ctxt->d & Sse) {
+			if (!(ops->get_cr(ctxt, 4) & X86_CR4_OSFXSR)) {
+				rc = emulate_ud(ctxt);
+				goto done;
+			}
+		}
+
+		if ((ctxt->d & (Avx|Sse|Mmx)) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
 			rc = emulate_nm(ctxt);
 			goto done;
 		}
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index 3ba12888bf66..9bc08c3c53f5 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -15,6 +15,54 @@ typedef u32		__attribute__((vector_size(16))) sse128_t;
 #define sse128_l3(x)	({ __sse128_u t; t.vec = x; t.as_u32[3]; })
 #define sse128(lo, hi)	({ __sse128_u t; t.as_u64[0] = lo; t.as_u64[1] = hi; t.vec; })
 
+typedef u32		__attribute__((vector_size(32))) avx256_t;
+
+static inline void _kvm_read_avx_reg(int reg, avx256_t *data)
+{
+	switch (reg) {
+	case 0:  asm("vmovdqa %%ymm0,  %0" : "=m"(*data)); break;
+	case 1:  asm("vmovdqa %%ymm1,  %0" : "=m"(*data)); break;
+	case 2:  asm("vmovdqa %%ymm2,  %0" : "=m"(*data)); break;
+	case 3:  asm("vmovdqa %%ymm3,  %0" : "=m"(*data)); break;
+	case 4:  asm("vmovdqa %%ymm4,  %0" : "=m"(*data)); break;
+	case 5:  asm("vmovdqa %%ymm5,  %0" : "=m"(*data)); break;
+	case 6:  asm("vmovdqa %%ymm6,  %0" : "=m"(*data)); break;
+	case 7:  asm("vmovdqa %%ymm7,  %0" : "=m"(*data)); break;
+	case 8:  asm("vmovdqa %%ymm8,  %0" : "=m"(*data)); break;
+	case 9:  asm("vmovdqa %%ymm9,  %0" : "=m"(*data)); break;
+	case 10: asm("vmovdqa %%ymm10, %0" : "=m"(*data)); break;
+	case 11: asm("vmovdqa %%ymm11, %0" : "=m"(*data)); break;
+	case 12: asm("vmovdqa %%ymm12, %0" : "=m"(*data)); break;
+	case 13: asm("vmovdqa %%ymm13, %0" : "=m"(*data)); break;
+	case 14: asm("vmovdqa %%ymm14, %0" : "=m"(*data)); break;
+	case 15: asm("vmovdqa %%ymm15, %0" : "=m"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_avx_reg(int reg, const avx256_t *data)
+{
+	switch (reg) {
+	case 0:  asm("vmovdqa %0, %%ymm0"  : : "m"(*data)); break;
+	case 1:  asm("vmovdqa %0, %%ymm1"  : : "m"(*data)); break;
+	case 2:  asm("vmovdqa %0, %%ymm2"  : : "m"(*data)); break;
+	case 3:  asm("vmovdqa %0, %%ymm3"  : : "m"(*data)); break;
+	case 4:  asm("vmovdqa %0, %%ymm4"  : : "m"(*data)); break;
+	case 5:  asm("vmovdqa %0, %%ymm5"  : : "m"(*data)); break;
+	case 6:  asm("vmovdqa %0, %%ymm6"  : : "m"(*data)); break;
+	case 7:  asm("vmovdqa %0, %%ymm7"  : : "m"(*data)); break;
+	case 8:  asm("vmovdqa %0, %%ymm8"  : : "m"(*data)); break;
+	case 9:  asm("vmovdqa %0, %%ymm9"  : : "m"(*data)); break;
+	case 10: asm("vmovdqa %0, %%ymm10" : : "m"(*data)); break;
+	case 11: asm("vmovdqa %0, %%ymm11" : : "m"(*data)); break;
+	case 12: asm("vmovdqa %0, %%ymm12" : : "m"(*data)); break;
+	case 13: asm("vmovdqa %0, %%ymm13" : : "m"(*data)); break;
+	case 14: asm("vmovdqa %0, %%ymm14" : : "m"(*data)); break;
+	case 15: asm("vmovdqa %0, %%ymm15" : : "m"(*data)); break;
+	default: BUG();
+	}
+}
+
 static inline void _kvm_read_sse_reg(int reg, sse128_t *data)
 {
 	switch (reg) {
@@ -109,6 +157,20 @@ static inline void kvm_fpu_put(void)
 	fpregs_unlock();
 }
 
+static inline void kvm_read_avx_reg(int reg, avx256_t *data)
+{
+	kvm_fpu_get();
+	_kvm_read_avx_reg(reg, data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_write_avx_reg(int reg, const avx256_t  *data)
+{
+	kvm_fpu_get();
+	_kvm_write_avx_reg(reg, data);
+	kvm_fpu_put();
+}
+
 static inline void kvm_read_sse_reg(int reg, sse128_t *data)
 {
 	kvm_fpu_get();
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 5f9d69c64cd5..c526f46f5595 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -249,7 +249,7 @@ struct x86_emulate_ops {
 
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
-	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_MM, OP_NONE } type;
+	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_YMM, OP_MM, OP_NONE } type;
 	unsigned int bytes;
 	unsigned int count;
 	union {
@@ -268,11 +268,12 @@ struct operand {
 	union {
 		unsigned long val;
 		u64 val64;
-		char valptr[sizeof(sse128_t)];
+		char valptr[sizeof(avx256_t)];
 		sse128_t vec_val;
+		avx256_t vec_val2;
 		u64 mm_val;
 		void *data;
-	};
+	} __aligned(32);
 };
 
 #define X86_MAX_INSTRUCTION_LENGTH	15
-- 
2.43.5




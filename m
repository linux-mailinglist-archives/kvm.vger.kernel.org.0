Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176E3462DB8
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbhK3HqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239188AbhK3HqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:46:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29B6C061574;
        Mon, 29 Nov 2021 23:42:48 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u80so19734095pfc.9;
        Mon, 29 Nov 2021 23:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cEKEHXAnFqEWs2cfAOj4tplx3BT8KgIMnHJkci37HdI=;
        b=exXJRTbrcpxxUIL8XuHBUBDOgTvpMBZxmWpOqkW91KubfM0SgvmoBy+xEDb4TEbAvD
         PvfTvgLQYVgI1aQLkr1QCGLxleSqcPz9E7ZlZY9fnDgnpheu4SmxPnbrSRp89ztgTApx
         zIqIbBE8R53LZsHO2LdlfjHAe7cZvr8agIRNaXVJPqD0cc5MgWY3xKg9/q+jeZC63oc2
         QIE/ceyNygW1YwXfQHoRUzFUJuvKt6q6cV0MkLeQ4mclddbP1m7ALsP75BQ+RQL/dTMQ
         z25BJ+MBuJPp/bbht9tfXMavuzHu2Z7/8lzW/GR5qbyUo/UeUc3Bg0P0UlxW8Gwh6jf5
         k3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEKEHXAnFqEWs2cfAOj4tplx3BT8KgIMnHJkci37HdI=;
        b=GOHpqmU3jTo87h4c9mRUErcLbaNedNd/n2kyPL3svUSDfqEGb36FHCpapkhBth52/y
         THQSv1mVCEfeLak4B8l72EdPWe22GnpigD++29NWAgVTsZ3GPzXnyUOG4TWXav1qlYO6
         yeYDvMjpFTouUEnn1ooX1uj6FpQjv0GbgQQkBA78woCNau+4726FZvKzlPViK3gOYADj
         SO6/r+zayQMkvscW5yUg6stlWP31KLh7JP22QJL5BdhMBtwOZ2tsPh1jSyC6EmRg50qj
         UVcTf2z9CnU4ZB/xZEZyDcOCRj6c04Xr18QRDZbY53dJNv9lc67IPY8bKQq5aTpKVkEY
         0+rg==
X-Gm-Message-State: AOAM532b3kmTfkG7HsD2zFdX6hA6W4f2X1vfRCH9hRsgIfuesmAbG0+O
        XHV1AIMrA2feaFhyIztMcUQ=
X-Google-Smtp-Source: ABdhPJzUJVhiosPwm1YLAtHvzVGeRfs7/j087Pwo5LgS77p94Ub+3/N8EuQYSQE40rZkW9GqltVgdA==
X-Received: by 2002:a63:6882:: with SMTP id d124mr39543074pgc.234.1638258168170;
        Mon, 29 Nov 2021 23:42:48 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:47 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] KVM: x86: Update vPMCs when retiring branch instructions
Date:   Tue, 30 Nov 2021 15:42:21 +0800
Message-Id: <20211130074221.93635-7-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

When KVM retires a guest branch instruction through emulation,
increment any vPMCs that are configured to monitor "branch
instructions retired," and update the sample period of those counters
so that they will overflow at the right time.

Signed-off-by: Eric Hankland <ehankland@google.com>
[jmattson:
  - Split the code to increment "branch instructions retired" into a
    separate commit.
  - Moved/consolidated the calls to kvm_pmu_trigger_event() in the
    emulation of VMLAUNCH/VMRESUME to accommodate the evolution of
    that code.
]
Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/emulate.c     | 55 +++++++++++++++++++++-----------------
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/vmx/nested.c  |  7 +++--
 arch/x86/kvm/x86.c         |  2 ++
 4 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 28b1a4e57827..166a145fc1e6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -175,6 +175,7 @@
 #define No16	    ((u64)1 << 53)  /* No 16 bit operand */
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
+#define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -191,8 +192,9 @@
 #define FASTOP_SIZE 8
 
 struct opcode {
-	u64 flags : 56;
-	u64 intercept : 8;
+	u64 flags;
+	u8 intercept;
+	u8 pad[7];
 	union {
 		int (*execute)(struct x86_emulate_ctxt *ctxt);
 		const struct opcode *group;
@@ -4364,10 +4366,10 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch,			em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps,		em_call_far),
-	I(SrcMem | NearBranch,			em_jmp_abs),
-	I(SrcMemFAddr | ImplicitOps,		em_jmp_far),
+	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
+	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
 
@@ -4577,7 +4579,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(DstDI | SrcDX | Mov | String | Unaligned, em_in, ins, check_perm_in), /* insb, insw/insd */
 	I2bvIP(SrcSI | DstDX | String, em_out, outs, check_perm_out), /* outsb, outsw/outsd */
 	/* 0x70 - 0x7F */
-	X16(D(SrcImmByte | NearBranch)),
+	X16(D(SrcImmByte | NearBranch | IsBranch)),
 	/* 0x80 - 0x87 */
 	G(ByteOp | DstMem | SrcImm, group1),
 	G(DstMem | SrcImm, group1),
@@ -4596,7 +4598,7 @@ static const struct opcode opcode_table[256] = {
 	DI(SrcAcc | DstReg, pause), X7(D(SrcAcc | DstReg)),
 	/* 0x98 - 0x9F */
 	D(DstAcc | SrcNone), I(ImplicitOps | SrcAcc, em_cwd),
-	I(SrcImmFAddr | No64, em_call_far), N,
+	I(SrcImmFAddr | No64 | IsBranch, em_call_far), N,
 	II(ImplicitOps | Stack, em_pushf, pushf),
 	II(ImplicitOps | Stack, em_popf, popf),
 	I(ImplicitOps, em_sahf), I(ImplicitOps, em_lahf),
@@ -4616,17 +4618,19 @@ static const struct opcode opcode_table[256] = {
 	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
 	/* 0xC0 - 0xC7 */
 	G(ByteOp | Src2ImmByte, group2), G(Src2ImmByte, group2),
-	I(ImplicitOps | NearBranch | SrcImmU16, em_ret_near_imm),
-	I(ImplicitOps | NearBranch, em_ret),
+	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch, em_ret_near_imm),
+	I(ImplicitOps | NearBranch | IsBranch, em_ret),
 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2ES, em_lseg),
 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
 	G(ByteOp, group11), G(0, group11),
 	/* 0xC8 - 0xCF */
-	I(Stack | SrcImmU16 | Src2ImmByte, em_enter), I(Stack, em_leave),
-	I(ImplicitOps | SrcImmU16, em_ret_far_imm),
-	I(ImplicitOps, em_ret_far),
-	D(ImplicitOps), DI(SrcImmByte, intn),
-	D(ImplicitOps | No64), II(ImplicitOps, em_iret, iret),
+	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
+	I(Stack | IsBranch, em_leave),
+	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
+	I(ImplicitOps | IsBranch, em_ret_far),
+	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
+	D(ImplicitOps | No64 | IsBranch),
+	II(ImplicitOps | IsBranch, em_iret, iret),
 	/* 0xD0 - 0xD7 */
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
@@ -4637,14 +4641,15 @@ static const struct opcode opcode_table[256] = {
 	/* 0xD8 - 0xDF */
 	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,
 	/* 0xE0 - 0xE7 */
-	X3(I(SrcImmByte | NearBranch, em_loop)),
-	I(SrcImmByte | NearBranch, em_jcxz),
+	X3(I(SrcImmByte | NearBranch | IsBranch, em_loop)),
+	I(SrcImmByte | NearBranch | IsBranch, em_jcxz),
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch, em_call), D(SrcImm | ImplicitOps | NearBranch),
-	I(SrcImmFAddr | No64, em_jmp_far),
-	D(SrcImmByte | ImplicitOps | NearBranch),
+	I(SrcImm | NearBranch | IsBranch, em_call),
+	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
+	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
+	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
 	I2bvIP(SrcDX | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstDX, em_out, out, check_perm_out),
 	/* 0xF0 - 0xF7 */
@@ -4660,7 +4665,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4691,8 +4696,8 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4710,7 +4715,7 @@ static const struct opcode twobyte_table[256] = {
 	N, N, N, N,
 	N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_6f_0f_7f),
 	/* 0x80 - 0x8F */
-	X16(D(SrcImm | NearBranch)),
+	X16(D(SrcImm | NearBranch | IsBranch)),
 	/* 0x90 - 0x9F */
 	X16(D(ByteOp | DstMem | SrcNone | ModRM| Mov)),
 	/* 0xA0 - 0xA7 */
@@ -5224,6 +5229,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		ctxt->d |= opcode.flags;
 	}
 
+	ctxt->is_branch = opcode.flags & IsBranch;
+
 	/* Unrecognised? */
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 68b420289d7e..39eded2426ff 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -369,6 +369,7 @@ struct x86_emulate_ctxt {
 	struct fetch_cache fetch;
 	struct read_cache io_read;
 	struct read_cache mem_read;
+	bool is_branch;
 };
 
 /* Repeat String Operation Prefix */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95f3823b3a9d..6e05d36aedd5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3504,10 +3504,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (evmptrld_status == EVMPTRLD_ERROR) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
-	} else if (CC(evmptrld_status == EVMPTRLD_VMFAIL)) {
-		return nested_vmx_failInvalid(vcpu);
 	}
 
+	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+
+	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
+		return nested_vmx_failInvalid(vcpu);
+
 	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
 	       vmx->nested.current_vmptr == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83371be00771..c28226dcbe4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8243,6 +8243,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
 			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+			if (ctxt->is_branch)
+				kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.33.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B655C5976F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfF1J1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:27:16 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42121 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfF1J1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714031; x=1593250031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ULQ2VCb8CXWxm+kaWec/O4NZdxFzd2HSyJaiVp9JTV8=;
  b=gcEG6dDaUlXdzTJrwP7dLnEfh4SY+JRtPDsHE7JDZAlzAZfiAPCgcNDm
   hkcxp7c3vj7ax/ZCYhaErJVTTYEstkp4Avho52oZL6LOcEiSeDK8rbfvO
   imMVimF9joZs3NL9FY4G4mlPGYR3wwXenlwjxmL25ER/5plwBBUefS9y1
   g=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="808278090"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Jun 2019 09:27:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id DD4FEA20C3;
        Fri, 28 Jun 2019 09:26:59 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:38 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:34 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 2/5] Emulate simple x86 instructions in userspace
Date:   Fri, 28 Jun 2019 11:26:18 +0200
Message-ID: <20190628092621.17823-3-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
References: <20190628092621.17823-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added the minimal subset of code to run afl-harness with a binary file
as input.  These bytes are used to populate the vcpu structure and then
as an instruction stream for the emulator.  It does not attempt to handle
exceptions and only supports very simple ops.

---

v1 -> v2:
 - Removed a number of macros and moved them as static inline functions
   in emulator_ops.h

v2 -> v3:
 - Removed commented out code
 - Moved changes to emulator_ops.h into the first patch
 - Moved addition of afl-many script to a later patch
 - Fixed a spelling mistake

v3 -> v4:
 - Stubbed remaining emulator_ops with unimplemented_op macro

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/emulator_ops.c | 534 +++++++++++++++++++++++++++++++-
 1 file changed, 533 insertions(+), 1 deletion(-)

diff --git a/tools/fuzz/x86ie/emulator_ops.c b/tools/fuzz/x86ie/emulator_ops.c
index 55ae4e8fbd96..27ba486972e1 100644
--- a/tools/fuzz/x86ie/emulator_ops.c
+++ b/tools/fuzz/x86ie/emulator_ops.c
@@ -29,17 +29,541 @@
 #include <asm/user_64.h>
 #include <asm/kvm.h>
 
+ulong emul_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg)
+{
+	assert(reg < number_of_gprs(ctxt));
+	return get_state(ctxt)->vcpu.regs[reg];
+}
+
+void emul_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg, ulong val)
+{
+	assert(reg < number_of_gprs(ctxt));
+	get_state(ctxt)->vcpu.regs[reg] = val;
+}
+
+int emul_read_std(struct x86_emulate_ctxt *ctxt,
+		unsigned long addr, void *val,
+		unsigned int bytes,
+		struct x86_exception *fault, bool system)
+{
+	unimplemented_op();
+}
+
+int emul_read_phys(struct x86_emulate_ctxt *ctxt, unsigned long addr,
+		void *val, unsigned int bytes)
+{
+	unimplemented_op();
+}
+
+int emul_write_std(struct x86_emulate_ctxt *ctxt,
+		unsigned long addr, void *val, unsigned int bytes,
+		struct x86_exception *fault, bool system)
+{
+	unimplemented_op();
+}
+
+/* All read ops: */
+
+static int _get_bytes(void *dst, struct state *state, unsigned int bytes,
+		      char *callee)
+{
+	if (state->bytes_consumed + bytes > state->data_available) {
+		fprintf(stderr, "Tried retrieving %d bytes\n", bytes);
+		fprintf(stderr, "%s failed to retrieve bytes for %s.\n",
+			__func__, callee);
+		return X86EMUL_UNHANDLEABLE;
+	}
+
+	memcpy(dst, &state->data[state->bytes_consumed], bytes);
+	return X86EMUL_CONTINUE;
+}
+
+/*
+ * The only function that any x86_emulate_ops should call to retrieve bytes.
+ * See comments in struct state definition for more information.
+ */
+static int get_bytes_and_increment(void *dst, struct state *state,
+				   unsigned int bytes, char *callee)
+{
+	int rc = _get_bytes(dst, state, bytes, callee);
+
+	if (rc == X86EMUL_CONTINUE)
+		state->bytes_consumed += bytes;
+
+	return rc;
+}
+
+/*
+ * This is called by x86_decode_insn to fetch bytes.
+ */
+int emul_fetch(struct x86_emulate_ctxt *ctxt, unsigned long addr, void *val,
+	       unsigned int bytes, struct x86_exception *fault)
+{
+	if (get_bytes_and_increment(val, get_state(ctxt), bytes,
+		"emul_fetch") != X86EMUL_CONTINUE) {
+		return X86EMUL_UNHANDLEABLE;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+
+int emul_read_emulated(struct x86_emulate_ctxt *ctxt,
+		       unsigned long addr, void *val, unsigned int bytes,
+		       struct x86_exception *fault)
+{
+	if (get_bytes_and_increment(val, get_state(ctxt), bytes,
+		"emul_read_emulated") != X86EMUL_CONTINUE) {
+		return X86EMUL_UNHANDLEABLE;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+
+int emul_write_emulated(struct x86_emulate_ctxt *ctxt,
+		   unsigned long addr, const void *val,
+		   unsigned int bytes,
+		   struct x86_exception *fault)
+{
+	return X86EMUL_CONTINUE;
+}
+
+
+int emul_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
+			unsigned long addr,
+			const void *old,
+			const void *new,
+			unsigned int bytes,
+			struct x86_exception *fault)
+{
+	unimplemented_op();
+}
+
+void emul_invlpg(struct x86_emulate_ctxt *ctxt, ulong addr)
+{
+	unimplemented_op();
+}
+
+int emul_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
+			int size, unsigned short port, void *val,
+			unsigned int count)
+{
+	unimplemented_op();
+}
+
+int emul_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
+			int size, unsigned short port, const void *val,
+			unsigned int count)
+{
+	unimplemented_op();
+}
+
+bool emul_get_segment(struct x86_emulate_ctxt *ctxt, u16 *selector,
+			struct desc_struct *desc, u32 *base3, int seg)
+{
+	unimplemented_op();
+}
+
+void emul_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
+			struct desc_struct *desc, u32 base3, int seg)
+{
+	unimplemented_op();
+}
+
+unsigned long emul_get_cached_segment_base(struct x86_emulate_ctxt *ctxt,
+						int seg)
+{
+	unimplemented_op();
+}
+
+void emul_get_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
+{
+	unimplemented_op();
+}
+
+void emul_get_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
+{
+	unimplemented_op();
+}
+
+void emul_set_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
+{
+	unimplemented_op();
+}
+
+void emul_set_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
+{
+	unimplemented_op();
+}
+
+ulong emul_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
+{
+	return get_state(ctxt)->vcpu.cr[cr];
+}
+
+int emul_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
+{
+	get_state(ctxt)->vcpu.cr[cr] = val;
+	return 0;
+}
+
+int emul_cpl(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+int emul_get_dr(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest)
+{
+	unimplemented_op();
+}
+
+int emul_set_dr(struct x86_emulate_ctxt *ctxt, int dr, ulong value)
+{
+	unimplemented_op();
+}
+
+u64 emul_get_smbase(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+void emul_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
+{
+	unimplemented_op();
+}
+
+int emul_set_msr(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data)
+{
+	unimplemented_op();
+}
+
+int emul_get_msr(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata)
+{
+	unimplemented_op();
+}
+
+int emul_check_pmc(struct x86_emulate_ctxt *ctxt, u32 pmc)
+{
+	unimplemented_op();
+}
+
+int emul_read_pmc(struct x86_emulate_ctxt *ctxt, u32 pmc, u64 *pdata)
+{
+	unimplemented_op();
+}
+
+void emul_halt(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+void emul_wbinvd(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+int emul_fix_hypercall(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+int emul_intercept(struct x86_emulate_ctxt *ctxt,
+			struct x86_instruction_info *info,
+			enum x86_intercept_stage stage)
+{
+	unimplemented_op();
+}
+
+bool emul_get_cpuid(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
+			u32 *ecx, u32 *edx, bool check_limit)
+{
+	unimplemented_op();
+}
+
+void emul_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
+{
+	unimplemented_op();
+}
+
+unsigned int emul_get_hflags(struct x86_emulate_ctxt *ctxt)
+{
+	return get_state(ctxt)->vcpu.rflags;
+}
+
+void emul_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned int hflags)
+{
+	get_state(ctxt)->vcpu.rflags = hflags;
+}
+
+int emul_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
+			const char *smstate)
+{
+	unimplemented_op();
+}
+
+void emul_post_leave_smm(struct x86_emulate_ctxt *ctxt)
+{
+	unimplemented_op();
+}
+
+/* End of emulator ops */
+
+#define EMUL_OP(h) .h = emul_##h
+const struct x86_emulate_ops all_emulator_ops = {
+	EMUL_OP(read_gpr),
+	EMUL_OP(write_gpr),
+	EMUL_OP(read_std),
+	EMUL_OP(read_phys),
+	EMUL_OP(write_std),
+	EMUL_OP(fetch),
+	EMUL_OP(read_emulated),
+	EMUL_OP(write_emulated),
+	EMUL_OP(cmpxchg_emulated),
+	EMUL_OP(invlpg),
+	EMUL_OP(pio_in_emulated),
+	EMUL_OP(pio_out_emulated),
+	EMUL_OP(get_segment),
+	EMUL_OP(set_segment),
+	EMUL_OP(get_cached_segment_base),
+	EMUL_OP(get_gdt),
+	EMUL_OP(get_idt),
+	EMUL_OP(set_gdt),
+	EMUL_OP(set_idt),
+	EMUL_OP(get_cr),
+	EMUL_OP(set_cr),
+	EMUL_OP(cpl),
+	EMUL_OP(get_dr),
+	EMUL_OP(set_dr),
+	EMUL_OP(get_smbase),
+	EMUL_OP(set_smbase),
+	EMUL_OP(set_msr),
+	EMUL_OP(get_msr),
+	EMUL_OP(check_pmc),
+	EMUL_OP(read_pmc),
+	EMUL_OP(halt),
+	EMUL_OP(wbinvd),
+	EMUL_OP(fix_hypercall),
+	EMUL_OP(intercept),
+	EMUL_OP(get_cpuid),
+	EMUL_OP(set_nmi_mask),
+	EMUL_OP(get_hflags),
+	EMUL_OP(set_hflags),
+	EMUL_OP(pre_leave_smm),
+	EMUL_OP(post_leave_smm),
+};
+#undef EMUL_OP
+
+enum {
+	HOOK_read_gpr,
+	HOOK_write_gpr,
+	HOOK_fetch,
+	HOOK_read_emulated,
+	HOOK_write_emulated,
+	HOOK_get_cr,
+	HOOK_set_cr,
+	HOOK_get_hflags,
+	HOOK_set_hflags
+};
+
+/*
+ * Disable an x86_emulate_op if options << HOOK_op is set.
+ *
+ * Expects options to be defined.
+ */
+#define MAYBE_DISABLE_HOOK(h)						\
+	do {								\
+		if (options & (1 << HOOK_##h)) {			\
+			vcpu->ctxt.ops.h = NULL;			\
+			debug("Disabling hook " #h "\n");		\
+		}							\
+	} while (0)
+
+/*
+ * FROM XEN:
+ *
+ * Constrain input to architecturally-possible states where
+ * the emulator relies on these
+ *
+ * In general we want the emulator to be as absolutely robust as
+ * possible; which means that we want to minimize the number of things
+ * it assumes about the input state.  Tesing this means minimizing and
+ * removing as much of the input constraints as possible.
+ *
+ * So we only add constraints that (in general) have been proven to
+ * cause crashes in the emulator.
+ *
+ * For future reference: other constraints which might be necessary at
+ * some point:
+ *
+ * - EFER.LMA => !EFLAGS.NT
+ * - In VM86 mode, force segment...
+ *  - ...access rights to 0xf3
+ *  - ...limits to 0xffff
+ *  - ...bases to below 1Mb, 16-byte aligned
+ *  - ...selectors to (base >> 4)
+ */
+static void sanitize_input(struct state *s)
+{
+	/*
+	 * CR0.PG can't be set if CR0.PE isn't set.  Set is more interesting, so
+	 * set PE if PG is set.
+	 */
+	if (s->vcpu.cr[0] & X86_CR0_PG)
+		s->vcpu.cr[0] |= X86_CR0_PE;
+
+	/* EFLAGS.VM not available in long mode */
+	if (s->ctxt.mode == X86EMUL_MODE_PROT64)
+		s->vcpu.rflags &= ~X86_EFLAGS_VM;
+
+	/* EFLAGS.VM implies 16-bit mode */
+	if (s->vcpu.rflags & X86_EFLAGS_VM) {
+		s->vcpu.segments[x86_seg_cs].db = 0;
+		s->vcpu.segments[x86_seg_ss].db = 0;
+	}
+}
+
 void initialize_emulator(struct state *state)
 {
+	reset_emulator(state);
+	state->ctxt.ops = &all_emulator_ops;
+
+	/* See also sanitize_input, some hooks can't be disabled. */
+	// MAYBE_DISABLE_HOOK(read_gpr);
+
+	sanitize_input(state);
+}
+
+static const char *const x86emul_mode_string[] = {
+	[X86EMUL_MODE_REAL] = "X86EMUL_MODE_REAL",
+	[X86EMUL_MODE_VM86] = "X86EMUL_MODE_VM86",
+	[X86EMUL_MODE_PROT16] = "X86EMUL_MODE_PROT16",
+	[X86EMUL_MODE_PROT32] = "X86EMUL_MODE_PROT32",
+	[X86EMUL_MODE_PROT64] = "X86EMUL_MODE_PROT64",
+};
+
+static void dump_state_after(const char *desc, struct state *state)
+{
+	debug(" -- State after %s --\n", desc);
+	debug("mode: %s\n", x86emul_mode_string[state->ctxt.mode]);
+	debug(" cr0: %lx\n", state->vcpu.cr[0]);
+	debug(" cr3: %lx\n", state->vcpu.cr[3]);
+	debug(" cr4: %lx\n", state->vcpu.cr[4]);
+
+	debug("Decode _eip: %lu\n", state->ctxt._eip);
+	debug("Emulate eip: %lu\n", state->ctxt.eip);
+
+	debug("\n");
 }
 
+static void init_emulate_ctxt(struct state *state)
+{
+	struct x86_emulate_ctxt *ctxt = &state->ctxt;
+
+	ctxt->eflags = ctxt->ops->get_hflags(ctxt);
+	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
+
+	ctxt->mode = X86EMUL_MODE_PROT64; // TODO: eventually vary this
+
+	init_decode_cache(ctxt);
+}
+
+
 int step_emulator(struct state *state)
 {
-	return 0;
+	int rc;
+	unsigned long prev_eip = state->ctxt._eip;
+	unsigned long emul_offset;
+	int decode_size = state->data_available - state->bytes_consumed;
+
+	/*
+	 * This is annoing to have to explain the reasoning behind:
+	 * ._eip is incremented by x86_decode_insn.  It will be > .eip between
+	 * decoding and emulating.
+	 * .eip is incremented by x86_emulate_insn.  It may be incremented
+	 * beyond the length of instruction emulated E.G. if a jump is taken.
+	 *
+	 * If these are out of sync before emulating, then something is
+	 * horribly wrong with the harness.
+	 */
+	assert(state->ctxt.eip == state->ctxt._eip);
+
+	if (decode_size <= 0) {
+		debug("Out of instructions\n");
+		return X86EMUL_UNHANDLEABLE;
+	}
+
+	init_emulate_ctxt(state);
+	state->ctxt.interruptibility = 0;
+	state->ctxt.have_exception = false;
+	state->ctxt.exception.vector = -1;
+	state->ctxt.perm_ok = false;
+	state->ctxt.ud = 0; // (emulation_type(0) & EMULTYPE_TRAP_UD);
+
+	/*
+	 * When decoding with NULL, 0, the emulator will use the emul_fetch
+	 * op which will almost always try to grab 15 bytes which may be more
+	 * than are left in the stream.
+	 *
+	 * Calling x86_decode_insn from a buffer with a length causes it to
+	 * directly memcpy `insn_len` bytes into the ctxt structure's 15 byte
+	 * long buffer without any length check.
+	 *
+	 * We must specify a size to prevent the emulator from fetching more
+	 * bytes than are left, and limit the size to <= 15 so that memcpy
+	 * does not overflow.
+	 */
+	if (decode_size > 15)
+		decode_size = 15;
+
+	rc = x86_decode_insn(&state->ctxt,
+		&state->data[state->bytes_consumed], decode_size);
+	assert(state->ctxt._eip - prev_eip > 0); // Only move forward.
+	state->bytes_consumed += state->ctxt._eip - prev_eip;
+
+	debug("Decode result: %d\n", rc);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	emul_offset = state->ctxt._eip - state->ctxt.eip;
+	debug("Instruction: ");
+	print_n_bytes(&state->data[state->bytes_consumed - emul_offset],
+		      emul_offset);
+
+	state->ctxt.exception.address = state->vcpu.cr[2];
+
+	// This is extraneous but explicit due to the above assert
+	prev_eip = state->ctxt.eip;
+	rc = x86_emulate_insn(&state->ctxt);
+	debug("Emulation result: %d\n", rc);
+	dump_state_after("emulating", state);
+
+	if (rc == -1) {
+		return rc;
+	} else if (state->ctxt.have_exception) {
+		fprintf(stderr, "Emulator propagated exception: { ");
+		fprintf(stderr, "vector: %d, ", state->ctxt.exception.vector);
+		fprintf(stderr, "error code: %d }\n",
+			state->ctxt.exception.error_code);
+		rc = X86EMUL_UNHANDLEABLE;
+	} else if (prev_eip == state->ctxt.eip) {
+		fprintf(stderr, "ctxt.eip not advanced.\n");
+		rc = X86EMUL_UNHANDLEABLE;
+	}
+
+	if (state->bytes_consumed == state->data_available)
+		debug("emulator is done\n");
+
+	return rc;
 }
 
 int emulate_until_complete(struct state *state)
 {
+	int count = 0;
+
+	do {
+		count++;
+	} while (step_emulator(state) == X86EMUL_CONTINUE);
+
+	debug("Emulated %d instructions\n", count);
 	return 0;
 }
 
@@ -51,8 +575,16 @@ struct state *create_emulator(void)
 
 void reset_emulator(struct state *state)
 {
+	unsigned char *data = state->data;
+	size_t data_available = state->data_available;
+
+	memset(state, 0, sizeof(struct state));
+
+	state->data = data;
+	state->data_available = data_available;
 }
 
 void free_emulator(struct state *state)
 {
+	free(state);
 }
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




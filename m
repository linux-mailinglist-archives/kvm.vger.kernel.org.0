Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E850DE3
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfFXOZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:25:02 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64642 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbfFXOZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561386301; x=1592922301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NIX7oeNahvZftMI/3htiY+wKWhDyzf0/ATYBF/Yn4Qw=;
  b=GplmxMQCoDtvLUtW2KOIXgNZfPKeXjY0Ju1DR0uLSjZuIEltIHgh4mAv
   IIqXx+QMKK6v+CSCQbkzbYq7bZ6Y+rZ+Vpqsvfjlxa4pW6FCOmm2BJ/Cx
   UDItsLqa14+wHX/nxQ7ZwVOs95zi5IZDzVRhrGQldx9WnuZ3GN3quG47h
   U=;
X-IronPort-AV: E=Sophos;i="5.62,412,1554768000"; 
   d="scan'208";a="681742696"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Jun 2019 14:24:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id BA7E3240C46;
        Mon, 24 Jun 2019 14:24:52 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:33 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:24:28 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v3 2/5] Emulate simple x86 instructions in userspace
Date:   Mon, 24 Jun 2019 16:24:11 +0200
Message-ID: <20190624142414.22096-3-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190624142414.22096-1-samcacc@amazon.de>
References: <20190624142414.22096-1-samcacc@amazon.de>
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

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/emulator_ops.c | 325 +++++++++++++++++++++++++++++++-
 1 file changed, 324 insertions(+), 1 deletion(-)

diff --git a/tools/fuzz/x86ie/emulator_ops.c b/tools/fuzz/x86ie/emulator_ops.c
index 55ae4e8fbd96..a15168ee40d2 100644
--- a/tools/fuzz/x86ie/emulator_ops.c
+++ b/tools/fuzz/x86ie/emulator_ops.c
@@ -29,17 +29,332 @@
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
+/* End of emulator ops */
+
+#define EMUL_OP(h) .h = emul_##h
+const struct x86_emulate_ops all_emulator_ops = {
+	EMUL_OP(read_gpr),
+	EMUL_OP(write_gpr),
+	EMUL_OP(fetch),
+	EMUL_OP(read_emulated),
+	EMUL_OP(write_emulated),
+	EMUL_OP(get_cr),
+	EMUL_OP(set_cr),
+	EMUL_OP(get_hflags),
+	EMUL_OP(set_hflags),
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
 
@@ -51,8 +366,16 @@ struct state *create_emulator(void)
 
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




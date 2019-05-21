Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9225433
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfEUPkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:40:12 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:3398 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfEUPkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 11:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558453209; x=1589989209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=LI26iuFc1hayM1XvY3zlLM7H/SJeHaDj4s+5vkyXg9Q=;
  b=XEi48TSr6SpP0f+7xtB2djv7wf/2dGY2zqFPSiNyH3DwYHxssUdy9NeF
   HVbq3DwjDZDlQS0te5NGeGkZnnlUd5hE8T/NuQU4h7PjAK3rEevywbUsB
   WezSy9NFdcAtKtw46fcx9BPUrYRstQ8b0HHLpwT7FTPjXxnTXXkHpWTSg
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,495,1549929600"; 
   d="scan'208";a="403087828"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 May 2019 15:40:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4LFe29n055106
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 21 May 2019 15:40:05 GMT
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:52 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:52 +0000
Received: from uc2253769c0055c.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 21 May 2019 15:39:47 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcacc@amazon.de>, <samcaccavale@gmail.com>,
        <nmanthey@amazon.de>, <wipawel@amazon.de>, <dwmw@amazon.co.uk>,
        <mpohlack@amazon.de>, <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Emulate simple x86 instructions in userspace
Date:   Tue, 21 May 2019 17:39:23 +0200
Message-ID: <20190521153924.15110-3-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190521153924.15110-1-samcacc@amazon.de>
References: <20190521153924.15110-1-samcacc@amazon.de>
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
exceptions an only supports very simple ops.

---
 .../x86_instruction_emulation/emulator_ops.c  | 324 +++++++++++++++++-
 .../scripts/afl-many                          |  28 ++
 .../scripts/bin_fuzz                          |  23 ++
 3 files changed, 374 insertions(+), 1 deletion(-)
 create mode 100755 tools/fuzz/x86_instruction_emulation/scripts/afl-many
 create mode 100755 tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz

diff --git a/tools/fuzz/x86_instruction_emulation/emulator_ops.c b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
index 55ae4e8fbd96..38bba4c97e2f 100644
--- a/tools/fuzz/x86_instruction_emulation/emulator_ops.c
+++ b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
@@ -29,17 +29,331 @@
 #include <asm/user_64.h>
 #include <asm/kvm.h>
 
+/*
+ * Due to some quirk of building, the way printing to an unbuffered stream
+ * is implemented smashes the stack.  For now, we'll just buffer stderr but
+ * a fix is needed.
+ */
+char buff[BUFSIZ];
+void buffer_stderr(void)
+{
+	setvbuf(stderr, buff, _IOLBF, BUFSIZ);
+}
+
+#define number_of_registers(c) (c->mode == X86EMUL_MODE_PROT64 ? 16 : 8)
+
+ulong emul_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg)
+{
+	assert(reg < number_of_registers(ctxt));
+	return get_state(ctxt)->vcpu.regs[reg];
+}
+
+void emul_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg, ulong val)
+{
+	assert(reg < number_of_registers(ctxt));
+	get_state(ctxt)->vcpu.regs[reg] = val;
+}
+
+#undef number_of_registers /* (ctxt->mode == X86EMUL_MODE_PROT64 ? 16 : 8) */
+
+/* All read ops: */
+
+#define emul_offset (state->ctxt.eip + state->other_bytes_consumed)
+#define decode_offset (state->ctxt._eip + state->other_bytes_consumed)
+/*
+ * There is a very loose abstraction around ctxt.eip, ctxt._eip, and
+ * state.other_bytes_consumed.
+ *
+ * eip is incremented when an instruction is emulated by x86_emulate_insn
+ * _eip is incremeneted when an instruction is decoded by x86_decode_insn
+ *
+ * state.other_bytes_consumed is incremented when bytes are consumed by
+ *  get_bytes_and_increment for any use besides an x86 instruction.
+ *
+ * The bytes between emul_offset and decode_offset are instructions yet
+ * to be executed.
+ */
+
+#define _data_available(bytes) (decode_offset + bytes < state->data_available)
+
+static int _get_bytes(void *dst, struct state *state, unsigned int bytes,
+		      char *callee)
+{
+	if (!_data_available(bytes)) {
+		fprintf(stderr, "Tried retrieving %d bytes\n", bytes);
+		fprintf(stderr, "%s failed to retrieve bytes for %s.\n",
+			__func__, callee);
+		return X86EMUL_UNHANDLEABLE;
+	}
+
+	memcpy(dst, &state->data[decode_offset], bytes);
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
+		state->other_bytes_consumed += bytes;
+
+	return rc;
+}
+
+/*
+ * This is called by x86_decode_insn to fetch bytes and is the only function
+ * that gets bytes from state.data without incrementing .other_byes_consumed
+ * since the emulator will increment ._eip during x86_decode_insn and ._eip
+ * is used as an index into state.data.
+ */
+int emul_fetch(struct x86_emulate_ctxt *ctxt, unsigned long addr, void *val,
+	       unsigned int bytes, struct x86_exception *fault)
+{
+	if (_get_bytes(val, get_state(ctxt), bytes, "emul_fetch") !=
+	    X86EMUL_CONTINUE) {
+		return X86EMUL_UNHANDLEABLE;
+	}
+
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
+#define SET(h) .h = emul_##h
+const struct x86_emulate_ops all_emulator_ops = {
+	SET(read_gpr),
+	SET(write_gpr),
+	SET(fetch),
+	SET(get_cr),
+	SET(set_cr),
+	SET(get_hflags),
+	SET(set_hflags),
+};
+#undef SET
+
+enum {
+	HOOK_read_gpr,
+	HOOK_write_gpr,
+	HOOK_fetch,
+	HOOK_get_cr,
+	HOOK_set_cr,
+	HOOK_get_hflags,
+	HOOK_set_hflags
+};
+
+/* Put reg_x into a definitely valid state. */
+#define CANONICALIZE(reg_x)						\
+	do {								\
+		uint64_t _y = (reg_x);					\
+		if (_y & (1ULL << 47))					\
+			_y |= (~0ULL) << 48;				\
+		else							\
+			_y &= (1ULL << 48) - 1;				\
+		debug("Canonicalized %" PRIx64 " to %" PRIx64 "\n",	\
+			reg_x, y);					\
+		(reg_x) = _y;						\
+	} while (0)
+
+/*
+ * Canonicalizes reg if options << CANONICALIZE_##reg is set.
+ * This weighs the emulator to use canonical values for important registers.
+ *
+ * Expects options and regs to be defined.
+ */
+#define CANONICALIZE_MAYBE(reg)						\
+	do {								\
+		if (!(options & (1 << CANONICALIZE_##reg)))		\
+			CANONICALIZE(regs->reg);			\
+	} while (0)
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
+	/* Some hooks can't be disabled. */
+	// options &= ~((1<<HOOK_read)|(1<<HOOK_insn_fetch));
+
+	/* Zero 'private' entries */
+	// regs->error_code = 0;
+	// regs->entry_vector = 0;
+
+	// CANONICALIZE_MAYBE(rip);
+	// CANONICALIZE_MAYBE(rsp);
+	// CANONICALIZE_MAYBE(rbp);
+
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
+static void init_x86_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
+{
+	ctxt->ops = &all_emulator_ops;
+	ctxt->eflags = 0;
+	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
+	ctxt->eip = 0;
+
+	ctxt->mode = X86EMUL_MODE_PROT64; // TODO: eventually vary this?
+
+	init_decode_cache(ctxt);
+}
+
 void initialize_emulator(struct state *state)
 {
+	state->ctxt.ops = &all_emulator_ops;
+
+	/* See also sanitize_input, some hooks can't be disabled. */
+	// MAYBE_DISABLE_HOOK(read_gpr);
+
+	sanitize_input(state);
+	init_x86_emulate_ctxt(&state->ctxt);
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
 
 int step_emulator(struct state *state)
 {
-	return 0;
+	int rc, prev_eip = state->ctxt.eip;
+	int decode_size = state->data_available - decode_offset;
+
+	if (decode_size < 15) {
+		rc = x86_decode_insn(&state->ctxt, &state->data[decode_offset],
+				     decode_size);
+	} else {
+		rc = x86_decode_insn(&state->ctxt, NULL, 0);
+	}
+	debug("Decode result: %d\n", rc);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	debug("Instruction: ");
+	print_n_bytes(&state->data[emul_offset],
+		      state->ctxt._eip - state->ctxt.eip);
+
+	rc = x86_emulate_insn(&state->ctxt);
+	debug("Emulation result: %d\n", rc);
+	dump_state_after("emulating", state);
+
+	if (state->ctxt.have_exception) {
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
+	if (decode_offset == state->data_available)
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
 
@@ -51,8 +365,16 @@ struct state *create_emulator(void)
 
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
diff --git a/tools/fuzz/x86_instruction_emulation/scripts/afl-many b/tools/fuzz/x86_instruction_emulation/scripts/afl-many
new file mode 100755
index 000000000000..ab15258573a2
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/scripts/afl-many
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# This is for running AFL over NPROC or `nproc` cores with normal AFL options.
+
+export AFL_NO_AFFINITY=1
+
+while [ -z "$sync_dir" ]; do
+  while getopts ":o:" opt; do
+    case "${opt}" in
+      o)
+        sync_dir="${OPTARG}"
+        ;;
+      *)
+        ;;
+    esac
+  done
+  ((OPTIND++))
+  [ $OPTIND -gt $# ] && break
+done
+
+for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
+    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
+done
+taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
+
+sleep 5
+watch -n1 "echo \"Executing './afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && ./afl-whatsup -s ${sync_dir}"
+pkill afl-fuzz
diff --git a/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
new file mode 100755
index 000000000000..e570b17f9404
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# This runs the afl-harness at $1, $2 times (or 100)
+# It runs uniq and sorts the output to give an idea of what is causing the
+# most crashes.  Useful for deciding what to implement next.
+
+if [ "$#" -lt 1 ]; then
+  echo "Usage: './bin_fuzz path_to_afl-harness [number of times to run]"
+  exit
+fi
+
+mkdir -p fuzz
+rm -f fuzz/*.in fuzz/*.out
+
+for i in $(seq 1 1 ${2:-100})
+do
+  {
+  head -c 500 /dev/urandom | tee fuzz/$i.in | ./$1
+  } > fuzz/$i.out 2>&1
+
+done
+
+find ./fuzz -name '*.out' -exec tail -1 {} \; | sed 's/.* Segmen/Segman/' | sed -r 's/^(\s[0-9a-f]{2})+$/misc instruction output/' | sort | uniq -c | sort -rn
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B



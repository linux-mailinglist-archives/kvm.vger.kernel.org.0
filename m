Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433E74E99A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFUNke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:40:34 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:7793 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfFUNkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561124431; x=1592660431;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=61fPrBYUOKEVRj9HlimYPBFAn9PJGN+snudKMmd6UsY=;
  b=R9uS776mlkE7NPRuIeS1pcaeNloDgX9n/qxB0Ku+VgsBYT3ouu1b5deP
   svCMbOdTyd9p82JNRN5grApXIOA3dDmqgh5XUiKNsVZuEtu5RMKgSuskY
   bK7C5L9hHmvbS9pw2ynLSAjG1F3V2bZ+aj0cNmQ4j7Ah24DxV43RnT4w8
   o=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="401782586"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jun 2019 13:40:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id A884BA2886;
        Fri, 21 Jun 2019 13:40:25 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:40:24 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.16) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:40:18 +0000
Subject: Re: [v2, 2/4] Emulate simple x86 instructions in userspace
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>,
        <anirudhkaushik@google.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190612153600.13073-1-samcacc@amazon.de>
 <20190612153600.13073-3-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <c3584f30-2316-1545-e83d-3be20d38d9b1@amazon.com>
Date:   Fri, 21 Jun 2019 15:40:16 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190612153600.13073-3-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.16]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 17:35, Sam Caccavale wrote:
> Added the minimal subset of code to run afl-harness with a binary file
> as input.  These bytes are used to populate the vcpu structure and then
> as an instruction stream for the emulator.  It does not attempt to handle
> exceptions an only supports very simple ops.
>
> CR: https://code.amazon.com/reviews/CR-8552453
> ---
>   tools/fuzz/x86ie/afl-harness.c    |   8 +-
>   tools/fuzz/x86ie/emulator_ops.c   | 342 +++++++++++++++++++++++++++++-
>   tools/fuzz/x86ie/emulator_ops.h   |   7 +-
>   tools/fuzz/x86ie/scripts/afl-many |  28 +++
>   4 files changed, 379 insertions(+), 6 deletions(-)
>   create mode 100755 tools/fuzz/x86ie/scripts/afl-many
>
> diff --git a/tools/fuzz/x86ie/afl-harness.c b/tools/fuzz/x86ie/afl-harness.c
> index b3b09d7f15f2..a3eeab0cfc90 100644
> --- a/tools/fuzz/x86ie/afl-harness.c
> +++ b/tools/fuzz/x86ie/afl-harness.c
> @@ -50,7 +50,7 @@ int main(int argc, char **argv)
>
>   		switch (c) {
>   		case OPT_INPUT_SIZE:
> -			printf("Min: %u\n", MIN_INPUT_SIZE);
> +			printf("Min: %lu\n", MIN_INPUT_SIZE);


Why this change here?


>   			printf("Max: %u\n", MAX_INPUT_SIZE);
>   			exit(0);
>   			break;
> @@ -77,6 +77,10 @@ int main(int argc, char **argv)
>
>   	state = create_emulator();
>   	state->data = malloc(INSTRUCTION_BYTES);
> +	if (!state->data) {
> +		printf("Malloc failed.\n");
> +		return -1;
> +	}


Why here and not in 1/4?


>
>   #ifdef __AFL_HAVE_MANUAL_CONTROL
>   	__AFL_INIT();
> @@ -109,8 +113,6 @@ int main(int argc, char **argv)
>   			fseek(fp, 0, SEEK_SET);
>   		}
>   #endif
> -		reset_emulator(state);
> -


Same question.


>   		size = fread(state, 1, MIN_INPUT_SIZE, fp);
>   		if (size != MIN_INPUT_SIZE) {
>   			printf("Input does not populate state\n");
> diff --git a/tools/fuzz/x86ie/emulator_ops.c b/tools/fuzz/x86ie/emulator_ops.c
> index 55ae4e8fbd96..370ac970ab9d 100644
> --- a/tools/fuzz/x86ie/emulator_ops.c
> +++ b/tools/fuzz/x86ie/emulator_ops.c
> @@ -29,17 +29,349 @@
>   #include <asm/user_64.h>
>   #include <asm/kvm.h>
>
> +ulong emul_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg)
> +{
> +	assert(reg < number_of_gprs(ctxt));
> +	return get_state(ctxt)->vcpu.regs[reg];
> +}
> +
> +void emul_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg, ulong val)
> +{
> +	assert(reg < number_of_gprs(ctxt));
> +	get_state(ctxt)->vcpu.regs[reg] = val;
> +}
> +
> +/* All read ops: */
> +
> +static int _get_bytes(void *dst, struct state *state, unsigned int bytes,
> +		      char *callee)
> +{
> +	if (state->bytes_consumed + bytes > state->data_available) {
> +		fprintf(stderr, "Tried retrieving %d bytes\n", bytes);
> +		fprintf(stderr, "%s failed to retrieve bytes for %s.\n",
> +			__func__, callee);
> +		return X86EMUL_UNHANDLEABLE;
> +	}
> +
> +	memcpy(dst, &state->data[state->bytes_consumed], bytes);
> +	return X86EMUL_CONTINUE;
> +}
> +
> +/*
> + * The only function that any x86_emulate_ops should call to retrieve bytes.
> + * See comments in struct state definition for more information.
> + */
> +static int get_bytes_and_increment(void *dst, struct state *state,
> +				   unsigned int bytes, char *callee)
> +{
> +	int rc = _get_bytes(dst, state, bytes, callee);
> +
> +	if (rc == X86EMUL_CONTINUE)
> +		state->bytes_consumed += bytes;
> +
> +	return rc;
> +}
> +
> +/*
> + * This is called by x86_decode_insn to fetch bytes.
> + */
> +int emul_fetch(struct x86_emulate_ctxt *ctxt, unsigned long addr, void *val,
> +	       unsigned int bytes, struct x86_exception *fault)
> +{
> +	if (get_bytes_and_increment(val, get_state(ctxt), bytes,
> +		"emul_fetch") != X86EMUL_CONTINUE) {
> +		return X86EMUL_UNHANDLEABLE;
> +	}
> +
> +	return X86EMUL_CONTINUE;
> +}
> +
> +int emul_read_emulated(struct x86_emulate_ctxt *ctxt,
> +		       unsigned long addr, void *val, unsigned int bytes,
> +		       struct x86_exception *fault)
> +{
> +	if (get_bytes_and_increment(val, get_state(ctxt), bytes,
> +		"emul_read_emulated") != X86EMUL_CONTINUE) {
> +		return X86EMUL_UNHANDLEABLE;
> +	}
> +
> +	return X86EMUL_CONTINUE;
> +}
> +
> +int emul_write_emulated(struct x86_emulate_ctxt *ctxt,
> +		   unsigned long addr, const void *val,
> +		   unsigned int bytes,
> +		   struct x86_exception *fault)
> +{
> +	return X86EMUL_CONTINUE;
> +}
> +
> +ulong emul_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
> +{
> +	return get_state(ctxt)->vcpu.cr[cr];
> +}
> +
> +int emul_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
> +{
> +	get_state(ctxt)->vcpu.cr[cr] = val;
> +	return 0;
> +}
> +
> +unsigned int emul_get_hflags(struct x86_emulate_ctxt *ctxt)
> +{
> +	return get_state(ctxt)->vcpu.rflags;
> +}
> +
> +void emul_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned int hflags)
> +{
> +	get_state(ctxt)->vcpu.rflags = hflags;
> +}
> +
> +/* End of emulator ops */
> +
> +#define SET(h) .h = emul_##h


This is a pretty dangerous macro name, as it has great potential for 
conflict with a random header. I would suggest EMUL_OP() instead.


> +const struct x86_emulate_ops all_emulator_ops = {
> +	SET(read_gpr),
> +	SET(write_gpr),
> +	SET(fetch),
> +	SET(read_emulated),
> +	SET(write_emulated),
> +	SET(get_cr),
> +	SET(set_cr),
> +	SET(get_hflags),
> +	SET(set_hflags),
> +};
> +#undef SET
> +
> +enum {
> +	HOOK_read_gpr,
> +	HOOK_write_gpr,
> +	HOOK_fetch,
> +	HOOK_read_emulated,
> +	HOOK_write_emulated,
> +	HOOK_get_cr,
> +	HOOK_set_cr,
> +	HOOK_get_hflags,
> +	HOOK_set_hflags
> +};
> +
> +/*
> + * Disable an x86_emulate_op if options << HOOK_op is set.
> + *
> + * Expects options to be defined.
> + */
> +#define MAYBE_DISABLE_HOOK(h)						\
> +	do {								\
> +		if (options & (1 << HOOK_##h)) {			\
> +			vcpu->ctxt.ops.h = NULL;			\
> +			debug("Disabling hook " #h "\n");		\
> +		}							\
> +	} while (0)
> +
> +/*
> + * FROM XEN:
> + *
> + * Constrain input to architecturally-possible states where
> + * the emulator relies on these
> + *
> + * In general we want the emulator to be as absolutely robust as
> + * possible; which means that we want to minimize the number of things
> + * it assumes about the input state.  Tesing this means minimizing and
> + * removing as much of the input constraints as possible.
> + *
> + * So we only add constraints that (in general) have been proven to
> + * cause crashes in the emulator.
> + *
> + * For future reference: other constraints which might be necessary at
> + * some point:
> + *
> + * - EFER.LMA => !EFLAGS.NT
> + * - In VM86 mode, force segment...
> + *  - ...access rights to 0xf3
> + *  - ...limits to 0xffff
> + *  - ...bases to below 1Mb, 16-byte aligned
> + *  - ...selectors to (base >> 4)
> + */
> +static void sanitize_input(struct state *s)
> +{
> +	/* Some hooks can't be disabled. */
> +	// options &= ~((1<<HOOK_read)|(1<<HOOK_insn_fetch));
> +
> +	/* Zero 'private' entries */
> +	// regs->error_code = 0;
> +	// regs->entry_vector = 0;
> +
> +	// CANONICALIZE_MAYBE(rip);
> +	// CANONICALIZE_MAYBE(rsp);
> +	// CANONICALIZE_MAYBE(rbp);


Now that you removed the macro, please also remove all commented out lines.


> +
> +	/*
> +	 * CR0.PG can't be set if CR0.PE isn't set.  Set is more interesting, so
> +	 * set PE if PG is set.
> +	 */
> +	if (s->vcpu.cr[0] & X86_CR0_PG)
> +		s->vcpu.cr[0] |= X86_CR0_PE;
> +
> +	/* EFLAGS.VM not available in long mode */
> +	if (s->ctxt.mode == X86EMUL_MODE_PROT64)
> +		s->vcpu.rflags &= ~X86_EFLAGS_VM;
> +
> +	/* EFLAGS.VM implies 16-bit mode */
> +	if (s->vcpu.rflags & X86_EFLAGS_VM) {
> +		s->vcpu.segments[x86_seg_cs].db = 0;
> +		s->vcpu.segments[x86_seg_ss].db = 0;
> +	}
> +}
> +
>   void initialize_emulator(struct state *state)
>   {
> +	reset_emulator(state);
> +	state->ctxt.ops = &all_emulator_ops;
> +
> +	/* See also sanitize_input, some hooks can't be disabled. */
> +	// MAYBE_DISABLE_HOOK(read_gpr);
> +
> +	sanitize_input(state);
> +}
> +
> +static const char *const x86emul_mode_string[] = {
> +	[X86EMUL_MODE_REAL] = "X86EMUL_MODE_REAL",
> +	[X86EMUL_MODE_VM86] = "X86EMUL_MODE_VM86",
> +	[X86EMUL_MODE_PROT16] = "X86EMUL_MODE_PROT16",
> +	[X86EMUL_MODE_PROT32] = "X86EMUL_MODE_PROT32",
> +	[X86EMUL_MODE_PROT64] = "X86EMUL_MODE_PROT64",
> +};
> +
> +static void dump_state_after(const char *desc, struct state *state)
> +{
> +	debug(" -- State after %s --\n", desc);
> +	debug("mode: %s\n", x86emul_mode_string[state->ctxt.mode]);
> +	debug(" cr0: %lx\n", state->vcpu.cr[0]);
> +	debug(" cr3: %lx\n", state->vcpu.cr[3]);
> +	debug(" cr4: %lx\n", state->vcpu.cr[4]);
> +
> +	debug("Decode _eip: %lu\n", state->ctxt._eip);
> +	debug("Emulate eip: %lu\n", state->ctxt.eip);
> +
> +	debug("\n");
>   }
>
> +static void init_emulate_ctxt(struct state *state)
> +{
> +	struct x86_emulate_ctxt *ctxt = &state->ctxt;
> +
> +	ctxt->eflags = ctxt->ops->get_hflags(ctxt);
> +	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
> +
> +	ctxt->mode = X86EMUL_MODE_PROT64; // TODO: eventually vary this
> +
> +	init_decode_cache(ctxt);
> +}
> +
> +
>   int step_emulator(struct state *state)
>   {
> -	return 0;
> +	int rc;
> +	unsigned long prev_eip = state->ctxt._eip;
> +	unsigned long emul_offset;
> +	int decode_size = state->data_available - state->bytes_consumed;
> +
> +	/*
> +	 * This is annoing to have to explain the reasoning behind:
> +	 * ._eip is incremented by x86_decode_insn.  It will be > .eip between
> +	 * decoding and emulating.
> +	 * .eip is incremented by x86_emulate_insn.  It may be incremented
> +	 * beyond the length of instruction emulated E.G. if a jump is taken.
> +	 *
> +	 * If these are out of sync before emulating, then something is
> +	 * horribly wrong with the harness.
> +	 */
> +	assert(state->ctxt.eip == state->ctxt._eip);
> +
> +	if (decode_size <= 0) {
> +		debug("Out of instructions\n");
> +		return X86EMUL_UNHANDLEABLE;
> +	}
> +
> +	init_emulate_ctxt(state);
> +	state->ctxt.interruptibility = 0;
> +	state->ctxt.have_exception = false;
> +	state->ctxt.exception.vector = -1;
> +	state->ctxt.perm_ok = false;
> +	state->ctxt.ud = 0; // (emulation_type(0) & EMULTYPE_TRAP_UD);
> +
> +	/*
> +	 * When decoding with NULL, 0, the emulator will use the emul_fetch
> +	 * op which handles incrementing the state->data variables.  However
> +	 * x86_decode_insn will always try to grab 15 bytes which may be more
> +	 * than are left in the stream.
> +	 *
> +	 * Calling x86_decode_insn from a buffer with a length causes it to
> +	 * directly memcpy those bytes into the ctxt structure and does not
> +	 * increment state->bytes_consumed.  In that case, we manually
> +	 * update state->bytes_consumed by the difference in the decoding
> +	 * _eip.  This is gross but I cannot figure out a better way to do
> +	 * this.
> +	 *
> +	 * We must limit the size to avoid going over the buffer and since
> +	 * calling x86_decode_insn with a buffer does not go through any of
> +	 * our ops, we need to update bytes_consumed.  The only improvement
> +	 * I can currently think of would be a nicer way to get the size of
> +	 * the decoded instruction.
> +	 */
> +	if (decode_size > 15)
> +		decode_size = 15;
> +
> +	rc = x86_decode_insn(&state->ctxt,
> +		&state->data[state->bytes_consumed], decode_size);
> +	assert(state->ctxt._eip - prev_eip > 0); // Only move forward.
> +	state->bytes_consumed += state->ctxt._eip - prev_eip;
> +
> +	debug("Decode result: %d\n", rc);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> +
> +	emul_offset = state->ctxt._eip - state->ctxt.eip;
> +	debug("Instruction: ");
> +	print_n_bytes(&state->data[state->bytes_consumed - emul_offset],
> +		      emul_offset);
> +
> +	state->ctxt.exception.address = state->vcpu.cr[2];
> +
> +	// This is extraneous but explicit due to the above assert
> +	prev_eip = state->ctxt.eip;
> +	rc = x86_emulate_insn(&state->ctxt);
> +	debug("Emulation result: %d\n", rc);
> +	dump_state_after("emulating", state);
> +
> +	if (rc == -1) {
> +		return rc;
> +	} else if (state->ctxt.have_exception) {
> +		fprintf(stderr, "Emulator propagated exception: { ");
> +		fprintf(stderr, "vector: %d, ", state->ctxt.exception.vector);
> +		fprintf(stderr, "error code: %d }\n",
> +			state->ctxt.exception.error_code);
> +		rc = X86EMUL_UNHANDLEABLE;
> +	} else if (prev_eip == state->ctxt.eip) {
> +		fprintf(stderr, "ctxt.eip not advanced.\n");
> +		rc = X86EMUL_UNHANDLEABLE;
> +	}
> +
> +	if (state->bytes_consumed == state->data_available)
> +		debug("emulator is done\n");
> +
> +	return rc;
>   }
>
>   int emulate_until_complete(struct state *state)
>   {
> +	int count = 0;
> +
> +	do {
> +		count++;
> +	} while (step_emulator(state) == X86EMUL_CONTINUE);
> +
> +	debug("Emulated %d instructions\n", count);
>   	return 0;
>   }
>
> @@ -51,8 +383,16 @@ struct state *create_emulator(void)
>
>   void reset_emulator(struct state *state)
>   {
> +	unsigned char *data = state->data;
> +	size_t data_available = state->data_available;
> +
> +	memset(state, 0, sizeof(struct state));
> +
> +	state->data = data;
> +	state->data_available = data_available;
>   }
>
>   void free_emulator(struct state *state)
>   {
> +	free(state);
>   }
> diff --git a/tools/fuzz/x86ie/emulator_ops.h b/tools/fuzz/x86ie/emulator_ops.h
> index 5ae072d5f205..19f3bd0ec6a3 100644
> --- a/tools/fuzz/x86ie/emulator_ops.h
> +++ b/tools/fuzz/x86ie/emulator_ops.h
> @@ -59,7 +59,7 @@ struct state {
>   	 * Amount of bytes consumed for purposes other than instructions.
>   	 * E.G. whether a memory access should fault.
>   	 */
> -	size_t other_bytes_consumed;
> +	size_t bytes_consumed;


Why in this patch?


>
>   	/* Emulation context */
>   	struct x86_emulate_ctxt ctxt;
> @@ -75,7 +75,10 @@ struct state {
>
>   #define get_state(h) container_of(h, struct state, ctxt)
>
> -void buffer_stderr(void) __attribute__((constructor));


Same question.


> +static inline int number_of_gprs(struct x86_emulate_ctxt *c)
> +{
> +	return (c->mode == X86EMUL_MODE_PROT64 ? 16 : 8);
> +}
>
>   /*
>    * Allocates space for, and creates a `struct state`.  The user should set
> diff --git a/tools/fuzz/x86ie/scripts/afl-many b/tools/fuzz/x86ie/scripts/afl-many
> new file mode 100755
> index 000000000000..ab15258573a2
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/afl-many
> @@ -0,0 +1,28 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# This is for running AFL over NPROC or `nproc` cores with normal AFL options.
> +
> +export AFL_NO_AFFINITY=1
> +
> +while [ -z "$sync_dir" ]; do
> +  while getopts ":o:" opt; do
> +    case "${opt}" in
> +      o)
> +        sync_dir="${OPTARG}"
> +        ;;
> +      *)
> +        ;;
> +    esac
> +  done
> +  ((OPTIND++))
> +  [ $OPTIND -gt $# ] && break
> +done
> +
> +for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
> +    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
> +done
> +taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &


You want to add a comment above the execution via taskset explaining 
that this is necessary for performance because the Linux scheduler 
otherwise works against you for local caching effects.


> +
> +sleep 5


I'm still not a big fan of the sleep. Is there really no way to 
determine a sane monitoring state for real? Can you maybe find it out 
from looking at the open FDs on the afl-fuzz processes via /proc/$pid/fds?

Alex


> +watch -n1 "echo \"Executing './afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && ./afl-whatsup -s ${sync_dir}"
> +pkill afl-fuzz
> --
> 2.17.1
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87442AB8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731892AbfFLPTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:19:53 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61580 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731778AbfFLPTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560352790; x=1591888790;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ihkj6SMz7D9EB7IWwJlqwXPv8vO7xdbx5LNU9sDvX9I=;
  b=snEb77TrO+k61HAra0+YM7/W0XwgJH6zXMt9zs/QjFaYhb7ylYr5t/um
   BabolMe+t7QFV0T9UyMG3baI7EKAlsVtduSqCATSgsXnJRbB9CH2p4a8W
   NA26MbcUePkv1eWEMIVGt3vYVNaOyhsrBB4DCccZu6U7YVVTp6XQhkgqQ
   A=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="737164628"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Jun 2019 15:19:50 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id BF681246CDB;
        Wed, 12 Jun 2019 15:19:45 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:45 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:44 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 15:19:40 +0000
Subject: Re: [PATCH 2/3] Emulate simple x86 instructions in userspace
To:     Alexander Graf <graf@amazon.com>, Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190521153924.15110-1-samcacc@amazon.de>
 <20190521153924.15110-3-samcacc@amazon.de>
 <6a18a464-a621-da22-dd48-fd5d8a2fc859@amazon.com>
From:   <samcacc@amazon.com>
Message-ID: <7e0188fa-351f-157b-2815-ab19222f44b4@amazon.com>
Date:   Wed, 12 Jun 2019 17:19:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6a18a464-a621-da22-dd48-fd5d8a2fc859@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/19 10:38 AM, Alexander Graf wrote:
> 
> On 21.05.19 17:39, Sam Caccavale wrote:
>> Added the minimal subset of code to run afl-harness with a binary file
>> as input.  These bytes are used to populate the vcpu structure and then
>> as an instruction stream for the emulator.  It does not attempt to handle
>> exceptions an only supports very simple ops.
>>
>> ---
>>   .../x86_instruction_emulation/emulator_ops.c  | 324 +++++++++++++++++-
>>   .../scripts/afl-many                          |  28 ++
>>   .../scripts/bin_fuzz                          |  23 ++
>>   3 files changed, 374 insertions(+), 1 deletion(-)
>>   create mode 100755
>> tools/fuzz/x86_instruction_emulation/scripts/afl-many
>>   create mode 100755
>> tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>>
>> diff --git a/tools/fuzz/x86_instruction_emulation/emulator_ops.c
>> b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
>> index 55ae4e8fbd96..38bba4c97e2f 100644
>> --- a/tools/fuzz/x86_instruction_emulation/emulator_ops.c
>> +++ b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
>> @@ -29,17 +29,331 @@
>>   #include <asm/user_64.h>
>>   #include <asm/kvm.h>
>>   +/*
>> + * Due to some quirk of building, the way printing to an unbuffered
>> stream
>> + * is implemented smashes the stack.  For now, we'll just buffer
>> stderr but
>> + * a fix is needed.
> 
> 
> I'm not sure I fully understand this comment. If printing smashes the
> stack, wouldn't that always break things?

This seemed to be the result of the `-mcmodel=kernel` flag not playing
well with printf and a userspace binary.  I've started building both the
kernel objects and harness without the flag and it clears up the issue.

> 
> 
>> + */
>> +char buff[BUFSIZ];
>> +void buffer_stderr(void)
>> +{
>> +    setvbuf(stderr, buff, _IOLBF, BUFSIZ);
>> +}
>> +
>> +#define number_of_registers(c) (c->mode == X86EMUL_MODE_PROT64 ? 16 : 8)
> 
> 
> This can go into a header, no? Also, just say "gprs" instead of
> registers - it's shorter. In addition, you want bits like this also be
> static inline functions rather than macros to preserve type checking.
> 

Moved to a static inline function in emulator_ops.h.

> 
>> +
>> +ulong emul_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg)
>> +{
>> +    assert(reg < number_of_registers(ctxt));
>> +    return get_state(ctxt)->vcpu.regs[reg];
>> +}
>> +
>> +void emul_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned int reg,
>> ulong val)
>> +{
>> +    assert(reg < number_of_registers(ctxt));
>> +    get_state(ctxt)->vcpu.regs[reg] = val;
>> +}
>> +
>> +#undef number_of_registers /* (ctxt->mode == X86EMUL_MODE_PROT64 ? 16
>> : 8) */
>> +
>> +/* All read ops: */
>> +
>> +#define emul_offset (state->ctxt.eip + state->other_bytes_consumed)
>> +#define decode_offset (state->ctxt._eip + state->other_bytes_consumed)
> 
> 
> Same here, better make this static inline functions and pass state as
> parameter in. At least for me, it's otherwise really hard to remember
> what really happens when a variable appears out of the blue.
> 

These were removed for a far less complicated method of keeping track of
bytes consumed.  Additionally, using eip was a mistake since jumps could
massively change it.

> 
>> +/*
>> + * There is a very loose abstraction around ctxt.eip, ctxt._eip, and
>> + * state.other_bytes_consumed.
>> + *
>> + * eip is incremented when an instruction is emulated by
>> x86_emulate_insn
>> + * _eip is incremeneted when an instruction is decoded by
>> x86_decode_insn
>> + *
>> + * state.other_bytes_consumed is incremented when bytes are consumed by
>> + *  get_bytes_and_increment for any use besides an x86 instruction.
>> + *
>> + * The bytes between emul_offset and decode_offset are instructions yet
>> + * to be executed.
>> + */
>> +
>> +#define _data_available(bytes) (decode_offset + bytes <
>> state->data_available)
> 
> 
> Please make this a static function too.
> 

Removed in v2 in lieu of `state.data_available` on the state structure
which is incremented as bytes are consumed.

> 
>> +
>> +static int _get_bytes(void *dst, struct state *state, unsigned int
>> bytes,
>> +              char *callee)
>> +{
>> +    if (!_data_available(bytes)) {
>> +        fprintf(stderr, "Tried retrieving %d bytes\n", bytes);
>> +        fprintf(stderr, "%s failed to retrieve bytes for %s.\n",
>> +            __func__, callee);
>> +        return X86EMUL_UNHANDLEABLE;
>> +    }
>> +
>> +    memcpy(dst, &state->data[decode_offset], bytes);
>> +    return X86EMUL_CONTINUE;
>> +}
>> +
>> +/*
>> + * The only function that any x86_emulate_ops should call to retrieve
>> bytes.
>> + * See comments in struct state definition for more information.
>> + */
>> +static int get_bytes_and_increment(void *dst, struct state *state,
>> +                   unsigned int bytes, char *callee)
>> +{
>> +    int rc = _get_bytes(dst, state, bytes, callee);
>> +
>> +    if (rc == X86EMUL_CONTINUE)
>> +        state->other_bytes_consumed += bytes;
>> +
>> +    return rc;
>> +}
>> +
>> +/*
>> + * This is called by x86_decode_insn to fetch bytes and is the only
>> function
>> + * that gets bytes from state.data without incrementing
>> .other_byes_consumed
>> + * since the emulator will increment ._eip during x86_decode_insn and
>> ._eip
>> + * is used as an index into state.data.
>> + */
>> +int emul_fetch(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>> void *val,
>> +           unsigned int bytes, struct x86_exception *fault)
>> +{
>> +    if (_get_bytes(val, get_state(ctxt), bytes, "emul_fetch") !=
>> +        X86EMUL_CONTINUE) {
>> +        return X86EMUL_UNHANDLEABLE;
>> +    }
>> +
>> +    return X86EMUL_CONTINUE;
>> +}
>> +
>> +ulong emul_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
>> +{
>> +    return get_state(ctxt)->vcpu.cr[cr];
>> +}
>> +
>> +int emul_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
>> +{
>> +    get_state(ctxt)->vcpu.cr[cr] = val;
>> +    return 0;
>> +}
>> +
>> +unsigned int emul_get_hflags(struct x86_emulate_ctxt *ctxt)
>> +{
>> +    return get_state(ctxt)->vcpu.rflags;
>> +}
>> +
>> +void emul_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned int hflags)
>> +{
>> +    get_state(ctxt)->vcpu.rflags = hflags;
>> +}
>> +
>> +/* End of emulator ops */
>> +
>> +#define SET(h) .h = emul_##h
>> +const struct x86_emulate_ops all_emulator_ops = {
>> +    SET(read_gpr),
>> +    SET(write_gpr),
>> +    SET(fetch),
>> +    SET(get_cr),
>> +    SET(set_cr),
>> +    SET(get_hflags),
>> +    SET(set_hflags),
>> +};
>> +#undef SET
>> +
>> +enum {
>> +    HOOK_read_gpr,
>> +    HOOK_write_gpr,
>> +    HOOK_fetch,
>> +    HOOK_get_cr,
>> +    HOOK_set_cr,
>> +    HOOK_get_hflags,
>> +    HOOK_set_hflags
>> +};
>> +
>> +/* Put reg_x into a definitely valid state. */
>> +#define CANONICALIZE(reg_x)                        \
>> +    do {                                \
>> +        uint64_t _y = (reg_x);                    \
>> +        if (_y & (1ULL << 47))                    \
>> +            _y |= (~0ULL) << 48;                \
>> +        else                            \
>> +            _y &= (1ULL << 48) - 1;                \
>> +        debug("Canonicalized %" PRIx64 " to %" PRIx64 "\n",    \
>> +            reg_x, y);                    \
>> +        (reg_x) = _y;                        \
>> +    } while (0)
> 
> 
> We support >48 bits VA/PA these days. Also, why is this a macro and not
> a static function?
> 

This was actually dead code kept from the Xen fuzzer, it has been removed.

> 
>> +
>> +/*
>> + * Canonicalizes reg if options << CANONICALIZE_##reg is set.
>> + * This weighs the emulator to use canonical values for important
>> registers.
>> + *
>> + * Expects options and regs to be defined.
>> + */
>> +#define CANONICALIZE_MAYBE(reg)                        \
>> +    do {                                \
>> +        if (!(options & (1 << CANONICALIZE_##reg)))        \
>> +            CANONICALIZE(regs->reg);            \
>> +    } while (0)
>> +
>> +/*
>> + * Disable an x86_emulate_op if options << HOOK_op is set.
>> + *
>> + * Expects options to be defined.
>> + */
>> +#define MAYBE_DISABLE_HOOK(h)                        \
>> +    do {                                \
>> +        if (options & (1 << HOOK_##h)) {            \
>> +            vcpu->ctxt.ops.h = NULL;            \
>> +            debug("Disabling hook " #h "\n");        \
>> +        }                            \
>> +    } while (0)
>> +
>> +/*
>> + * FROM XEN:
>> + *
>> + * Constrain input to architecturally-possible states where
>> + * the emulator relies on these
>> + *
>> + * In general we want the emulator to be as absolutely robust as
>> + * possible; which means that we want to minimize the number of things
>> + * it assumes about the input state.  Tesing this means minimizing and
>> + * removing as much of the input constraints as possible.
>> + *
>> + * So we only add constraints that (in general) have been proven to
>> + * cause crashes in the emulator.
>> + *
>> + * For future reference: other constraints which might be necessary at
>> + * some point:
>> + *
>> + * - EFER.LMA => !EFLAGS.NT
>> + * - In VM86 mode, force segment...
>> + *  - ...access rights to 0xf3
>> + *  - ...limits to 0xffff
>> + *  - ...bases to below 1Mb, 16-byte aligned
>> + *  - ...selectors to (base >> 4)
>> + */
>> +static void sanitize_input(struct state *s)
>> +{
>> +    /* Some hooks can't be disabled. */
>> +    // options &= ~((1<<HOOK_read)|(1<<HOOK_insn_fetch));
>> +
>> +    /* Zero 'private' entries */
>> +    // regs->error_code = 0;
>> +    // regs->entry_vector = 0;
>> +
>> +    // CANONICALIZE_MAYBE(rip);
>> +    // CANONICALIZE_MAYBE(rsp);
>> +    // CANONICALIZE_MAYBE(rbp);
>> +
>> +    /*
>> +     * CR0.PG can't be set if CR0.PE isn't set.  Set is more
>> interesting, so
>> +     * set PE if PG is set.
>> +     */
>> +    if (s->vcpu.cr[0] & X86_CR0_PG)
>> +        s->vcpu.cr[0] |= X86_CR0_PE;
>> +
>> +    /* EFLAGS.VM not available in long mode */
>> +    if (s->ctxt.mode == X86EMUL_MODE_PROT64)
>> +        s->vcpu.rflags &= ~X86_EFLAGS_VM;
>> +
>> +    /* EFLAGS.VM implies 16-bit mode */
>> +    if (s->vcpu.rflags & X86_EFLAGS_VM) {
>> +        s->vcpu.segments[x86_seg_cs].db = 0;
>> +        s->vcpu.segments[x86_seg_ss].db = 0;
>> +    }
>> +}
>> +
>> +static void init_x86_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
>> +{
>> +    ctxt->ops = &all_emulator_ops;
>> +    ctxt->eflags = 0;
>> +    ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
>> +    ctxt->eip = 0;
>> +
>> +    ctxt->mode = X86EMUL_MODE_PROT64; // TODO: eventually vary this?
>> +
>> +    init_decode_cache(ctxt);
>> +}
>> +
>>   void initialize_emulator(struct state *state)
>>   {
>> +    state->ctxt.ops = &all_emulator_ops;
>> +
>> +    /* See also sanitize_input, some hooks can't be disabled. */
>> +    // MAYBE_DISABLE_HOOK(read_gpr);
>> +
>> +    sanitize_input(state);
>> +    init_x86_emulate_ctxt(&state->ctxt);
>> +}
>> +
>> +static const char *const x86emul_mode_string[] = {
>> +    [X86EMUL_MODE_REAL] = "X86EMUL_MODE_REAL",
>> +    [X86EMUL_MODE_VM86] = "X86EMUL_MODE_VM86",
>> +    [X86EMUL_MODE_PROT16] = "X86EMUL_MODE_PROT16",
>> +    [X86EMUL_MODE_PROT32] = "X86EMUL_MODE_PROT32",
>> +    [X86EMUL_MODE_PROT64] = "X86EMUL_MODE_PROT64",
>> +};
>> +
>> +static void dump_state_after(const char *desc, struct state *state)
>> +{
>> +    debug(" -- State after %s --\n", desc);
>> +    debug("mode: %s\n", x86emul_mode_string[state->ctxt.mode]);
>> +    debug(" cr0: %lx\n", state->vcpu.cr[0]);
>> +    debug(" cr3: %lx\n", state->vcpu.cr[3]);
>> +    debug(" cr4: %lx\n", state->vcpu.cr[4]);
>> +
>> +    debug("Decode _eip: %lu\n", state->ctxt._eip);
>> +    debug("Emulate eip: %lu\n", state->ctxt.eip);
>> +
>> +    debug("\n");
>>   }
>>     int step_emulator(struct state *state)
>>   {
>> -    return 0;
>> +    int rc, prev_eip = state->ctxt.eip;
>> +    int decode_size = state->data_available - decode_offset;
>> +
>> +    if (decode_size < 15) {
>> +        rc = x86_decode_insn(&state->ctxt, &state->data[decode_offset],
>> +                     decode_size);
>> +    } else {
>> +        rc = x86_decode_insn(&state->ctxt, NULL, 0);
> 
> 
> Isn't this going to fetch instructions from data as well? Why do we need
> the < 15 special case at all?
> 

I've changed the method of acquiring data in v2, but the 15 limit is
still relevant.  If x86_decode_insn is called with a NULL pointer and
instruction size 0, the bytes are fetched via the emulator_ops.fetch
function.  This would be nice, but there is no way of limiting how many
bytes it will try and fetch-- and it usually grabs 15 since that is the
longest x86 instruction (as of yet?).  When there are less than 15 bytes
left, limiting the fetch size to the remaining bytes is important.

> 
>> +    }
>> +    debug("Decode result: %d\n", rc);
>> +    if (rc != X86EMUL_CONTINUE)
>> +        return rc;
>> +
>> +    debug("Instruction: ");
>> +    print_n_bytes(&state->data[emul_offset],
>> +              state->ctxt._eip - state->ctxt.eip);
>> +
>> +    rc = x86_emulate_insn(&state->ctxt);
>> +    debug("Emulation result: %d\n", rc);
>> +    dump_state_after("emulating", state);
>> +
>> +    if (state->ctxt.have_exception) {
>> +        fprintf(stderr, "Emulator propagated exception: { ");
>> +        fprintf(stderr, "vector: %d, ", state->ctxt.exception.vector);
>> +        fprintf(stderr, "error code: %d }\n",
>> +            state->ctxt.exception.error_code);
>> +        rc = X86EMUL_UNHANDLEABLE;
>> +    } else if (prev_eip == state->ctxt.eip) {
>> +        fprintf(stderr, "ctxt.eip not advanced.\n");
> 
> 
> During fuzzing, do I really care about all that debug output? I mean,
> both cases above are perfectly legal. What we're trying to catch are
> cases where we're overwriting memory we shouldn't have, no?
> 

This is true.  Debug has been put into a compiler macro.

> 
> In fact, how do we detect that? Would it make sense to have canaries in
> the vcpu struct that we can check before/after instruction execution to
> see if there was an out of bounds memory access somewhere?
> 

As of now, I compile with ASAN, which _hopefully_ would catch most OOB
memory accesses.  We also use gcc's stack canaries.  Additional ways to
detect these kinds of errors are desirable, but I don't know of any at
this point in time.

> 
>> +        rc = X86EMUL_UNHANDLEABLE;
>> +    }
>> +
>> +    if (decode_offset == state->data_available)
>> +        debug("emulator is done\n");
>> +
>> +    return rc;
>>   }
>>     int emulate_until_complete(struct state *state)
>>   {
>> +    int count = 0;
>> +
>> +    do {
>> +        count++;
>> +    } while (step_emulator(state) == X86EMUL_CONTINUE);
>> +
>> +    debug("Emulated %d instructions\n", count);
>>       return 0;
>>   }
>>   @@ -51,8 +365,16 @@ struct state *create_emulator(void)
>>     void reset_emulator(struct state *state)
>>   {
>> +    unsigned char *data = state->data;
>> +    size_t data_available = state->data_available;
>> +
>> +    memset(state, 0, sizeof(struct state));
>> +
>> +    state->data = data;
>> +    state->data_available = data_available;
>>   }
>>     void free_emulator(struct state *state)
>>   {
>> +    free(state);
>>   }
>> diff --git a/tools/fuzz/x86_instruction_emulation/scripts/afl-many
>> b/tools/fuzz/x86_instruction_emulation/scripts/afl-many
>> new file mode 100755
>> index 000000000000..ab15258573a2
>> --- /dev/null
>> +++ b/tools/fuzz/x86_instruction_emulation/scripts/afl-many
>> @@ -0,0 +1,28 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# This is for running AFL over NPROC or `nproc` cores with normal AFL
>> options.
>> +
>> +export AFL_NO_AFFINITY=1
>> +
>> +while [ -z "$sync_dir" ]; do
>> +  while getopts ":o:" opt; do
>> +    case "${opt}" in
>> +      o)
>> +        sync_dir="${OPTARG}"
>> +        ;;
>> +      *)
>> +        ;;
>> +    esac
>> +  done
>> +  ((OPTIND++))
>> +  [ $OPTIND -gt $# ] && break
>> +done
>> +
>> +for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
>> +    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
>> +done
>> +taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
> 
> 
> Why the CPU pinning?
> 

AFL has a bad habit of being unable to spread its threads out to
different cores.  We cpu pin each thread to its own vcpu to help with
performance.

> 
>> +
>> +sleep 5
> 
> 
> Why sleep? Shouldn't this rather wait for some async notification to see
> whether all slaves were successfully started?
> 

Again, AFL is a little primitive in this sense.  It does not offer an
async method of notifying when the threads are up.  In the interest of
time I just put the wait in.

> 
>> +watch -n1 "echo \"Executing './afl-fuzz $@' on ${NPROC:-$(nproc)}
>> cores.\" && ./afl-whatsup -s ${sync_dir}"
>> +pkill afl-fuzz
>> diff --git a/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>> b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>> new file mode 100755
>> index 000000000000..e570b17f9404
>> --- /dev/null
>> +++ b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>> @@ -0,0 +1,23 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# This runs the afl-harness at $1, $2 times (or 100)
>> +# It runs uniq and sorts the output to give an idea of what is
>> causing the
>> +# most crashes.  Useful for deciding what to implement next.
>> +
>> +if [ "$#" -lt 1 ]; then
>> +  echo "Usage: './bin_fuzz path_to_afl-harness [number of times to run]"
>> +  exit
>> +fi
>> +
>> +mkdir -p fuzz
>> +rm -f fuzz/*.in fuzz/*.out
>> +
>> +for i in $(seq 1 1 ${2:-100})
>> +do
>> +  {
>> +  head -c 500 /dev/urandom | tee fuzz/$i.in | ./$1
>> +  } > fuzz/$i.out 2>&1
>> +
>> +done
>> +
>> +find ./fuzz -name '*.out' -exec tail -1 {} \; | sed 's/.*
>> Segmen/Segman/' | sed -r 's/^(\s[0-9a-f]{2})+$/misc instruction
>> output/' | sort | uniq -c | sort -rn
> 
> 
> What is that Segman thing about?
> 

This was for binning crashes-- check `tools/fuzz/x86ie/scripts/bin.sh`
in v2 for the updated version.  Basically, it checks whether a
segmentation fault has happened, and if so, launches a gdb session to
see whether it was caused by an unimplemented x86_emulator_op.  This is
useful in development for prioritizing the unimplemented features which
are causing the most fake crashes.

> 
> Alex
> 
> 

Thanks for taking a look at this.  I'll be sending a v2 out shortly
which addresses all of these issues and makes other misc fixes.

Sam

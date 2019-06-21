Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63F4E926
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfFUN2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:28:49 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62574 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfFUN2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561123726; x=1592659726;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7p0CjH+ZVru6bj34yR86Ng2z5nNSqzdfa/nZKcTY20k=;
  b=WkzbJ6z4e0I/AX634JLA/LB65zDdxIwUQ790+0zY3iG1+7ZW4CPp8x80
   3OFW+v9q1o5IpCUb+6U8+pxn6GG1yPTCe6XDLqKmXdsIvy+dDqpyfDnJ3
   D3aicmakjkiPK5nbbBQ+oLHAqfaQXsp7EtkKn3czXPuvpxc4DUm0DVpKf
   4=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="407495297"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Jun 2019 13:28:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id CB00DA2947;
        Fri, 21 Jun 2019 13:28:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:28:41 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.128) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:28:36 +0000
Subject: Re: [PATCH 2/3] Emulate simple x86 instructions in userspace
To:     <samcacc@amazon.com>, Sam Caccavale <samcacc@amazon.de>
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
 <7e0188fa-351f-157b-2815-ab19222f44b4@amazon.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <c5fbed80-5933-eca3-001e-0e2aaccfcd1d@amazon.com>
Date:   Fri, 21 Jun 2019 15:28:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <7e0188fa-351f-157b-2815-ab19222f44b4@amazon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.162.128]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 17:19, samcacc@amazon.com wrote:
> On 5/31/19 10:38 AM, Alexander Graf wrote:
>> On 21.05.19 17:39, Sam Caccavale wrote:
>>
>>> +static void dump_state_after(const char *desc, struct state *state)
>>> +{
>>> +    debug(" -- State after %s --\n", desc);
>>> +    debug("mode: %s\n", x86emul_mode_string[state->ctxt.mode]);
>>> +    debug(" cr0: %lx\n", state->vcpu.cr[0]);
>>> +    debug(" cr3: %lx\n", state->vcpu.cr[3]);
>>> +    debug(" cr4: %lx\n", state->vcpu.cr[4]);
>>> +
>>> +    debug("Decode _eip: %lu\n", state->ctxt._eip);
>>> +    debug("Emulate eip: %lu\n", state->ctxt.eip);
>>> +
>>> +    debug("\n");
>>>    }
>>>      int step_emulator(struct state *state)
>>>    {
>>> -    return 0;
>>> +    int rc, prev_eip = state->ctxt.eip;
>>> +    int decode_size = state->data_available - decode_offset;
>>> +
>>> +    if (decode_size < 15) {
>>> +        rc = x86_decode_insn(&state->ctxt, &state->data[decode_offset],
>>> +                     decode_size);
>>> +    } else {
>>> +        rc = x86_decode_insn(&state->ctxt, NULL, 0);
>>
>> Isn't this going to fetch instructions from data as well? Why do we need
>> the < 15 special case at all?
>>
> I've changed the method of acquiring data in v2, but the 15 limit is
> still relevant.  If x86_decode_insn is called with a NULL pointer and
> instruction size 0, the bytes are fetched via the emulator_ops.fetch
> function.  This would be nice, but there is no way of limiting how many
> bytes it will try and fetch-- and it usually grabs 15 since that is the
> longest x86 instruction (as of yet?).  When there are less than 15 bytes
> left, limiting the fetch size to the remaining bytes is important.


You want to at least add a comment here, detailing the fact that where 
the magic 15 comes from and that you want to exercise the normal 
prefetch path while still allowing the buffer to shrink < 15 bytes :). 
Maybe move MAX_INST_SIZE from svm.c into a .h file and reuse that while 
at it.


[...]


>>> diff --git a/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>>> b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>>> new file mode 100755
>>> index 000000000000..e570b17f9404
>>> --- /dev/null
>>> +++ b/tools/fuzz/x86_instruction_emulation/scripts/bin_fuzz
>>> @@ -0,0 +1,23 @@
>>> +#!/bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0+
>>> +# This runs the afl-harness at $1, $2 times (or 100)
>>> +# It runs uniq and sorts the output to give an idea of what is
>>> causing the
>>> +# most crashes.  Useful for deciding what to implement next.
>>> +
>>> +if [ "$#" -lt 1 ]; then
>>> +  echo "Usage: './bin_fuzz path_to_afl-harness [number of times to run]"
>>> +  exit
>>> +fi
>>> +
>>> +mkdir -p fuzz
>>> +rm -f fuzz/*.in fuzz/*.out
>>> +
>>> +for i in $(seq 1 1 ${2:-100})
>>> +do
>>> +  {
>>> +  head -c 500 /dev/urandom | tee fuzz/$i.in | ./$1
>>> +  } > fuzz/$i.out 2>&1
>>> +
>>> +done
>>> +
>>> +find ./fuzz -name '*.out' -exec tail -1 {} \; | sed 's/.*
>>> Segmen/Segman/' | sed -r 's/^(\s[0-9a-f]{2})+$/misc instruction
>>> output/' | sort | uniq -c | sort -rn
>>
>> What is that Segman thing about?
>>
> This was for binning crashes-- check `tools/fuzz/x86ie/scripts/bin.sh`
> in v2 for the updated version.  Basically, it checks whether a
> segmentation fault has happened, and if so, launches a gdb session to
> see whether it was caused by an unimplemented x86_emulator_op.  This is
> useful in development for prioritizing the unimplemented features which
> are causing the most fake crashes.


I can see why you want to combine them, but I don't understand where 
"Segman" comes from. Where is there a man here?



Alex


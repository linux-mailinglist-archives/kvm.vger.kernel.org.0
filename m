Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1C42AAE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFLPTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:19:23 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11547 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLPTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560352762; x=1591888762;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=cnB3AEZTm5fX0gy29VrpQ+7tiLOuylsFSd/NEnTAsi4=;
  b=aNzWMHZ8bTPU7+DZlHlgX+2gcR4rNE/VNDOPEumdItCkuzIiVyn/oYNo
   4HQCPJRF3fm0Lz/6PfSTI9dmZ1HZA09WTtqC6POoTjHoy8typ/rGR6Jwt
   PkxOcldCEUBH0vI9HWSLPQM83jUfGiQTvTR7hNohz+cBCFRSwF+RIWUQU
   I=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="737164551"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Jun 2019 15:19:21 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id ECCE5A03CB;
        Wed, 12 Jun 2019 15:19:16 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:16 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:16 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 15:19:11 +0000
Subject: Re: x86 instruction emulator fuzzing
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
 <6f9f4746-7850-0de0-b531-0ea0e6d7ca82@amazon.com>
From:   <samcacc@amazon.com>
Message-ID: <c1994ba8-7b94-e814-d911-febc545d7506@amazon.com>
Date:   Wed, 12 Jun 2019 17:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6f9f4746-7850-0de0-b531-0ea0e6d7ca82@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/19 10:39 AM, Alexander Graf wrote:
> 
> On 21.05.19 17:39, Sam Caccavale wrote:
>> Dear all,
>>
>> This series aims to provide an entrypoint for, and fuzz KVM's x86
>> instruction
>> emulator from userspace.  It mirrors Xen's application of the AFL
>> fuzzer to
>> it's instruction emulator in the hopes of discovering vulnerabilities.
>> Since this entrypoint also allows arbitrary execution of the emulators
>> code
>> from userspace, it may also be useful for testing.
>>
>> The current 3 patches build the emulator and 2 harnesses:
>> simple-harness is
>> an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
>> They are early POC and include some issues outlined under "Issues."
>>
>> Patches
>> =======
>>
>> - 01: Builds and links afl-harness with the required kernel objects.
>> - 02: Introduces the minimal set of emulator operations and supporting
>> code
>> to emulate simple instructions.
>> - 03: Demonstrates simple-harness as a unit test.
>>
>> Issues
>> =======
>>
>> 1. Currently, building requires manually running the `make_deps` script
>> since I was unable to make the kernel objects a dependency of the tool.
>> 2. The code will segfault if `CONFIG_STACKPROTECTOR=y` in config.
>> 3. The code requires stderr to be buffered or it otherwise segfaults.
>>
>> The latter two issues seem related and all of them are likely fixable by
>> someone more familiar with the linux than me.
>>
>> Concerns
>> =======
>>
>> I was able to carve the `arch/x86/kvm/emulate.c` code, but the
>> emulator is
>> constructed in such a way that a lot of the code which enforces expected
>> behavior lives in the x86_emulate_ops supplied in `arch/x86/kvm/x86.c`.
>> Testing the emulator is still valuable, but a reproducible way to use
>> the kvm
>> ops would be useful.
>>
>> Any comments/suggestions are greatly appreciated.
> 
> 
> First off, thanks a lot for this :). The x86 emulator has been a sore
> (bug prone) point in KVM for a long time and I'm surprised it's not
> covered by fuzzing yet. It's great to see that finally happening.
> 
> A few nits:
> 
>   1) Cover letter should be [PATCH 0/3]. Just generate it with git
> format-patch --cover-letter.

Understood and corrected in v2.
>   2) The directory name "x86_instruction_emulation" is a bit long, no?
Yes it is.  While tab completion has mostly kept me sane until now, I've
renamed the folder to `x86ie`s

>   3) I think the cover letter should also detail how this relates to
> other fuzzing efforts and why we need another, separate one.

This sounds worthwhile.  In the interest of time I haven't included this
in v2, but I'll write it up as soon as possible and update.

> 
> 
> Alex
> 
> 

Thanks for the advice, v2 to follow.

Sam

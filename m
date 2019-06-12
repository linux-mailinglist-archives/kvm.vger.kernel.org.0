Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8642AB5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407138AbfFLPTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:19:53 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:60027 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731789AbfFLPTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560352792; x=1591888792;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=CPFZzLHWbmSgpnYQ4rkNXWoW4rpvmWGWNrlgSIKtMfQ=;
  b=VASsFb7YRbdgVDw4VtwN51CHara+MjWjDnFEC9jRoZU4pv1Vv80BgKbR
   vaFkBeByX9NYSixk/gP2mi6Ii8PwmVsmh+0Z8YMj1U/VWuGwk6aE8VWCG
   lzyuJ+WDIyFyclB2ygv9y5kPG3xN0fOCZ+iQ0AUkxSljukwmRpHLzJanC
   o=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="737164633"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Jun 2019 15:19:51 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 5B93DA242A;
        Wed, 12 Jun 2019 15:19:47 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:19:30 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 15:19:25 +0000
Subject: Re: [PATCH 1/3] Build target for emulate.o as a userspace binary
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
 <20190521153924.15110-2-samcacc@amazon.de>
 <529ed65f-f82e-7341-3a4f-6eea1f2961a9@amazon.com>
From:   <samcacc@amazon.com>
Message-ID: <c4f8fe78-39d2-9db0-97c0-0af2c35f22fc@amazon.com>
Date:   Wed, 12 Jun 2019 17:19:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <529ed65f-f82e-7341-3a4f-6eea1f2961a9@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/19 10:02 AM, Alexander Graf wrote:
> 
> On 21.05.19 17:39, Sam Caccavale wrote:
>> This commit contains the minimal set of functionality to build
>> afl-harness around arch/x86/emulate.c which allows exercising code
>> in that source file, like x86_emulate_insn.  Resolving the
>> dependencies was done via GCC's -H flag by get_headers.py.
>>
>> ---
>>   tools/Makefile                                |   9 ++
>>   .../fuzz/x86_instruction_emulation/.gitignore |   2 +
>>   tools/fuzz/x86_instruction_emulation/Makefile |  57 +++++++
>>   .../fuzz/x86_instruction_emulation/README.md  |  12 ++
>>   .../x86_instruction_emulation/afl-harness.c   | 149 ++++++++++++++++++
>>   tools/fuzz/x86_instruction_emulation/common.h |  87 ++++++++++
>>   .../x86_instruction_emulation/emulator_ops.c  |  58 +++++++
>>   .../x86_instruction_emulation/emulator_ops.h  | 117 ++++++++++++++
>>   .../scripts/get_headers.py                    |  95 +++++++++++
>>   .../scripts/make_deps                         |   4 +
>>   tools/fuzz/x86_instruction_emulation/stubs.c  |  56 +++++++
>>   tools/fuzz/x86_instruction_emulation/stubs.h  |  52 ++++++
>>   12 files changed, 698 insertions(+)
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/.gitignore
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/Makefile
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/README.md
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/afl-harness.c
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/common.h
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.c
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.h
>>   create mode 100644
>> tools/fuzz/x86_instruction_emulation/scripts/get_headers.py
>>   create mode 100755
>> tools/fuzz/x86_instruction_emulation/scripts/make_deps
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.c
>>   create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.h
>>
>> diff --git a/tools/Makefile b/tools/Makefile
>> index 3dfd72ae6c1a..4d68817b7e49 100644
>> --- a/tools/Makefile
>> +++ b/tools/Makefile
>> @@ -94,6 +94,12 @@ freefall: FORCE
>>   kvm_stat: FORCE
>>       $(call descend,kvm/$@)
>>   +fuzz: FORCE
>> +    $(call descend,fuzz/x86_instruction_emulation)
>> +
>> +fuzz_deps: FORCE
>> +    $(call descend,fuzz/x86_instruction_emulation,fuzz_deps)
>> +
>>   all: acpi cgroup cpupower gpio hv firewire liblockdep \
>>           perf selftests spi turbostat usb \
>>           virtio vm bpf x86_energy_perf_policy \
>> @@ -171,6 +177,9 @@ tmon_clean:
>>   freefall_clean:
>>       $(call descend,laptop/freefall,clean)
>>   +fuzz_clean:
>> +    $(call descend,fuzz/x86_instruction_emulation,clean)
>> +
>>   build_clean:
>>       $(call descend,build,clean)
>>   diff --git a/tools/fuzz/x86_instruction_emulation/.gitignore
>> b/tools/fuzz/x86_instruction_emulation/.gitignore
>> new file mode 100644
>> index 000000000000..7d44f7ce266e
>> --- /dev/null
>> +++ b/tools/fuzz/x86_instruction_emulation/.gitignore
>> @@ -0,0 +1,2 @@
>> +*.o
>> +*-harness
>> diff --git a/tools/fuzz/x86_instruction_emulation/Makefile
>> b/tools/fuzz/x86_instruction_emulation/Makefile
>> new file mode 100644
>> index 000000000000..d2854a332605
>> --- /dev/null
>> +++ b/tools/fuzz/x86_instruction_emulation/Makefile
>> @@ -0,0 +1,57 @@
>> +ROOT_DIR=../../..
>> +THIS_DIR=tools/fuzz/x86_instruction_emulation
>> +
>> +include ../../scripts/Makefile.include
>> +
>> +.DEFAULT_GOAL := all
>> +
>> +INCLUDES := $(patsubst -I./%,-I./$(ROOT_DIR)/%, $(LINUXINCLUDE))
>> +INCLUDES := $(patsubst ./include/%,./$(ROOT_DIR)/include/%, $(INCLUDES))
>> +INCLUDES += -include ./$(ROOT_DIR)/include/linux/compiler_types.h
>> +
>> +$(ROOT_DIR)/.config:
>> +    make -C $(ROOT_DIR) menuconfig
>> +    sed -i -r 's/^#? *CONFIG_KVM(.*)=.*/CONFIG_KVM\1=y/'
>> $(ROOT_DIR)/.config
>> +
>> +
>> +ifdef DEBUG
>> +KBUILD_CFLAGS += -DDEBUG
>> +endif
>> +KBUILD_CFLAGS += -g -O0
> 
> 
> Why -O0? I would expect a some bugs to only emerge with optimization
> enabled.
> 
> Alex
> 

This was supposed to be the `ifdef` actually.  Fixed in v2.

Sam

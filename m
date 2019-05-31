Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D85309C9
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEaICj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 04:02:39 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:35496 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbfEaICj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 04:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559289758; x=1590825758;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=/WyYQHOnF3HxsjKHW7ouyvrjqjIbBcb2ZzLtjUBe08s=;
  b=mcR/9dijRIwhdhGy7RPNSytU6HQHt1d+zH4dgn4C1+uZibvSOgX2xAUR
   txIXyqeYVUEAaFK0/3/zr+poxkda9yEZOT+kM0zKDiB2VA1Up9TeW8Y34
   oyqMWymX22Ifxg6S2iuWgSj+co/ZhqfdTZX7N/zzy9N77WdvCMYKBnJ5F
   o=;
X-IronPort-AV: E=Sophos;i="5.60,534,1549929600"; 
   d="scan'208";a="404464927"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 May 2019 08:02:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id E4D9AA24B3;
        Fri, 31 May 2019 08:02:32 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 08:02:32 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.89) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 08:02:27 +0000
Subject: Re: [PATCH 1/3] Build target for emulate.o as a userspace binary
To:     Sam Caccavale <samcacc@amazon.de>
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <529ed65f-f82e-7341-3a4f-6eea1f2961a9@amazon.com>
Date:   Fri, 31 May 2019 10:02:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190521153924.15110-2-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.89]
X-ClientProxiedBy: EX13D25UWB004.ant.amazon.com (10.43.161.180) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 21.05.19 17:39, Sam Caccavale wrote:
> This commit contains the minimal set of functionality to build
> afl-harness around arch/x86/emulate.c which allows exercising code
> in that source file, like x86_emulate_insn.  Resolving the
> dependencies was done via GCC's -H flag by get_headers.py.
>
> ---
>   tools/Makefile                                |   9 ++
>   .../fuzz/x86_instruction_emulation/.gitignore |   2 +
>   tools/fuzz/x86_instruction_emulation/Makefile |  57 +++++++
>   .../fuzz/x86_instruction_emulation/README.md  |  12 ++
>   .../x86_instruction_emulation/afl-harness.c   | 149 ++++++++++++++++++
>   tools/fuzz/x86_instruction_emulation/common.h |  87 ++++++++++
>   .../x86_instruction_emulation/emulator_ops.c  |  58 +++++++
>   .../x86_instruction_emulation/emulator_ops.h  | 117 ++++++++++++++
>   .../scripts/get_headers.py                    |  95 +++++++++++
>   .../scripts/make_deps                         |   4 +
>   tools/fuzz/x86_instruction_emulation/stubs.c  |  56 +++++++
>   tools/fuzz/x86_instruction_emulation/stubs.h  |  52 ++++++
>   12 files changed, 698 insertions(+)
>   create mode 100644 tools/fuzz/x86_instruction_emulation/.gitignore
>   create mode 100644 tools/fuzz/x86_instruction_emulation/Makefile
>   create mode 100644 tools/fuzz/x86_instruction_emulation/README.md
>   create mode 100644 tools/fuzz/x86_instruction_emulation/afl-harness.c
>   create mode 100644 tools/fuzz/x86_instruction_emulation/common.h
>   create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.c
>   create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.h
>   create mode 100644 tools/fuzz/x86_instruction_emulation/scripts/get_headers.py
>   create mode 100755 tools/fuzz/x86_instruction_emulation/scripts/make_deps
>   create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.c
>   create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.h
>
> diff --git a/tools/Makefile b/tools/Makefile
> index 3dfd72ae6c1a..4d68817b7e49 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -94,6 +94,12 @@ freefall: FORCE
>   kvm_stat: FORCE
>   	$(call descend,kvm/$@)
>   
> +fuzz: FORCE
> +	$(call descend,fuzz/x86_instruction_emulation)
> +
> +fuzz_deps: FORCE
> +	$(call descend,fuzz/x86_instruction_emulation,fuzz_deps)
> +
>   all: acpi cgroup cpupower gpio hv firewire liblockdep \
>   		perf selftests spi turbostat usb \
>   		virtio vm bpf x86_energy_perf_policy \
> @@ -171,6 +177,9 @@ tmon_clean:
>   freefall_clean:
>   	$(call descend,laptop/freefall,clean)
>   
> +fuzz_clean:
> +	$(call descend,fuzz/x86_instruction_emulation,clean)
> +
>   build_clean:
>   	$(call descend,build,clean)
>   
> diff --git a/tools/fuzz/x86_instruction_emulation/.gitignore b/tools/fuzz/x86_instruction_emulation/.gitignore
> new file mode 100644
> index 000000000000..7d44f7ce266e
> --- /dev/null
> +++ b/tools/fuzz/x86_instruction_emulation/.gitignore
> @@ -0,0 +1,2 @@
> +*.o
> +*-harness
> diff --git a/tools/fuzz/x86_instruction_emulation/Makefile b/tools/fuzz/x86_instruction_emulation/Makefile
> new file mode 100644
> index 000000000000..d2854a332605
> --- /dev/null
> +++ b/tools/fuzz/x86_instruction_emulation/Makefile
> @@ -0,0 +1,57 @@
> +ROOT_DIR=../../..
> +THIS_DIR=tools/fuzz/x86_instruction_emulation
> +
> +include ../../scripts/Makefile.include
> +
> +.DEFAULT_GOAL := all
> +
> +INCLUDES := $(patsubst -I./%,-I./$(ROOT_DIR)/%, $(LINUXINCLUDE))
> +INCLUDES := $(patsubst ./include/%,./$(ROOT_DIR)/include/%, $(INCLUDES))
> +INCLUDES += -include ./$(ROOT_DIR)/include/linux/compiler_types.h
> +
> +$(ROOT_DIR)/.config:
> +	make -C $(ROOT_DIR) menuconfig
> +	sed -i -r 's/^#? *CONFIG_KVM(.*)=.*/CONFIG_KVM\1=y/' $(ROOT_DIR)/.config
> +
> +
> +ifdef DEBUG
> +KBUILD_CFLAGS += -DDEBUG
> +endif
> +KBUILD_CFLAGS += -g -O0


Why -O0? I would expect a some bugs to only emerge with optimization 
enabled.

Alex


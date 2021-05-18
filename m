Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FC1387804
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348875AbhERLuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 07:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348868AbhERLuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 07:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621338534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlQ7G6nQMS0+u70jyAdMN6frxJBI8Gxh0QekrRUBeO0=;
        b=c8Wx0W77KntKqi5egR/Yn4KdpMgSzgZOOhQqwYNp4Y6ih63kPsGxTVRECHJB5Ru12qScFX
        e+m1fFdF+cZF9ShbygPVNd3QISRDDlKyd4LP6HKoQ7PdoqZBnzgZEJxTRTw97cLmiSTqYc
        q1tSQYwngPVItcPSKOMDzL+jMIdAf1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-h6kIOpP2MM6TE80SuJXNVA-1; Tue, 18 May 2021 07:48:53 -0400
X-MC-Unique: h6kIOpP2MM6TE80SuJXNVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A794C107ACE3;
        Tue, 18 May 2021 11:48:50 +0000 (UTC)
Received: from [10.36.114.156] (ovpn-114-156.ams2.redhat.com [10.36.114.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 457A860855;
        Tue, 18 May 2021 11:48:43 +0000 (UTC)
Subject: Re: [PATCH 15/56] KVM: arm64: Add build rules for separate VHE/nVHE
 object files
From:   Auger Eric <eric.auger@redhat.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-16-maz@kernel.org>
 <2ff3a1cb-a310-7963-4171-bd1e7d08e39b@redhat.com>
Message-ID: <5d1853ed-3474-edbc-545a-1f88f2a4e5ca@redhat.com>
Date:   Tue, 18 May 2021 13:48:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2ff3a1cb-a310-7963-4171-bd1e7d08e39b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David, Marc,

On 5/4/21 4:47 PM, Auger Eric wrote:
> Hi David, Marc,
> 
> On 8/5/20 7:56 PM, Marc Zyngier wrote:
>> From: David Brazdil <dbrazdil@google.com>
>>
>> Add new folders arch/arm64/kvm/hyp/{vhe,nvhe} and Makefiles for building code
>> that runs in EL2 under VHE/nVHE KVM, repsectivelly. Add an include folder for
>> hyp-specific header files which will include code common to VHE/nVHE.
>>
>> Build nVHE code with -D__KVM_NVHE_HYPERVISOR__, VHE code with
>> -D__KVM_VHE_HYPERVISOR__.
>>
>> Under nVHE compile each source file into a `.hyp.tmp.o` object first, then
>> prefix all its symbols with "__kvm_nvhe_" using `objcopy` and produce
>> a `.hyp.o`. Suffixes were chosen so that it would be possible for VHE and nVHE
>> to share some source files, but compiled with different CFLAGS.
>>
>> The nVHE ELF symbol prefix is added to kallsyms.c as ignored. EL2-only symbols
>> will never appear in EL1 stack traces.
>>
>> Due to symbol prefixing, add a section in image-vars.h for aliases of symbols
>> that are defined in nVHE EL2 and accessed by kernel in EL1 or vice versa.
>>
>> Signed-off-by: David Brazdil <dbrazdil@google.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20200625131420.71444-4-dbrazdil@google.com
>> ---
>>  arch/arm64/kernel/image-vars.h   | 14 +++++++++++++
>>  arch/arm64/kvm/hyp/Makefile      | 10 +++++++---
>>  arch/arm64/kvm/hyp/nvhe/Makefile | 34 ++++++++++++++++++++++++++++++++
>>  arch/arm64/kvm/hyp/vhe/Makefile  | 17 ++++++++++++++++
>>  scripts/kallsyms.c               |  1 +
>>  5 files changed, 73 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
>>  create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile
>>
>> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
>> index be0a63ffed23..3dc27da47712 100644
>> --- a/arch/arm64/kernel/image-vars.h
>> +++ b/arch/arm64/kernel/image-vars.h
>> @@ -51,4 +51,18 @@ __efistub__ctype		= _ctype;
>>  
>>  #endif
>>  
>> +#ifdef CONFIG_KVM
>> +
>> +/*
>> + * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_, to
>> + * separate it from the kernel proper. The following symbols are legally
>> + * accessed by it, therefore provide aliases to make them linkable.
>> + * Do not include symbols which may not be safely accessed under hypervisor
>> + * memory mappings.
>> + */
>> +
>> +#define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
>> +
>> +#endif /* CONFIG_KVM */
>> +
>>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index 5d8357ddc234..9c5dfe6ff80b 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -3,10 +3,14 @@
>>  # Makefile for Kernel-based Virtual Machine module, HYP part
>>  #
>>  
>> -ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
>> -		$(DISABLE_STACKLEAK_PLUGIN)
>> +incdir := $(srctree)/$(src)/include
>> +subdir-asflags-y := -I$(incdir)
>> +subdir-ccflags-y := -I$(incdir)				\
>> +		    -fno-stack-protector		\
>> +		    -DDISABLE_BRANCH_PROFILING		\
>> +		    $(DISABLE_STACKLEAK_PLUGIN)
>>  
>> -obj-$(CONFIG_KVM) += hyp.o
>> +obj-$(CONFIG_KVM) += hyp.o nvhe/
>>  obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
>>  
>>  hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
>> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
>> new file mode 100644
>> index 000000000000..955f4188e00f
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
>> @@ -0,0 +1,34 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
>> +#
>> +
>> +asflags-y := -D__KVM_NVHE_HYPERVISOR__
>> +ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>> +
>> +obj-y :=
>> +
>> +obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
>> +extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
>> +
>> +$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
>> +	$(call if_changed_rule,cc_o_c)
>> +$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
>> +	$(call if_changed_rule,as_o_S)
>> +$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
>> +	$(call if_changed,hypcopy)
>> +
>> +quiet_cmd_hypcopy = HYPCOPY $@
>> +      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
>> +
>> +# KVM nVHE code is run at a different exception code with a different map, so
>> +# compiler instrumentation that inserts callbacks or checks into the code may
>> +# cause crashes. Just disable it.
>> +GCOV_PROFILE	:= n
>> +KASAN_SANITIZE	:= n
>> +UBSAN_SANITIZE	:= n
>> +KCOV_INSTRUMENT	:= n
>> +
>> +# Skip objtool checking for this directory because nVHE code is compiled with
>> +# non-standard build rules.
>> +OBJECT_FILES_NON_STANDARD := y
>> diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
>> new file mode 100644
>> index 000000000000..e04375546081
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/vhe/Makefile
>> @@ -0,0 +1,17 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
>> +#
>> +
>> +asflags-y := -D__KVM_VHE_HYPERVISOR__
>> +ccflags-y := -D__KVM_VHE_HYPERVISOR__
>> +
>> +obj-y :=
>> +
>> +# KVM code is run at a different exception code with a different map, so
>> +# compiler instrumentation that inserts callbacks or checks into the code may
>> +# cause crashes. Just disable it.
>> +GCOV_PROFILE	:= n
>> +KASAN_SANITIZE	:= n
>> +UBSAN_SANITIZE	:= n
>> +KCOV_INSTRUMENT	:= n
>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>> index 6dc3078649fa..0096cd965332 100644
>> --- a/scripts/kallsyms.c
>> +++ b/scripts/kallsyms.c
>> @@ -109,6 +109,7 @@ static bool is_ignored_symbol(const char *name, char type)
>>  		".LASANPC",		/* s390 kasan local symbols */
>>  		"__crc_",		/* modversions */
>>  		"__efistub_",		/* arm64 EFI stub namespace */
>> +		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
> The addition of this line seems to have introduced errors on the
> 'vmlinux symtab matches kallsyms' perf test (perf test -v 1) which fails
> on aarch64 for all __kvm_nvhe_ prefixed symbols, like
> 
> ERR : <addr> : __kvm_nvhe___invalid not on kallsyms
> ERR : <addr> : __kvm_nvhe___do_hyp_init not on kallsyms
> ERR : <addr> : __kvm_nvhe___kvm_handle_stub_hvc not on kallsyms
> ERR : <addr> : __kvm_nvhe_reset not on kallsyms
> ../..
> 
> I understand we willingly hided those symbols from /proc/kallsyms. Do
> you confirm the right fix is to upgrade the perf test suite accordingly?

Were you eventually able to reproduce?

Thanks

Eric
> 
> Thanks
> 
> Eric
> 
> 
>>  		NULL
>>  	};
>>  
>>


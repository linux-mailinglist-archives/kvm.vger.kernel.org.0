Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F731543EE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBFMVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 07:21:04 -0500
Received: from foss.arm.com ([217.140.110.172]:57790 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBFMVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 07:21:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCE3730E;
        Thu,  6 Feb 2020 04:21:02 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A6EC3F68E;
        Thu,  6 Feb 2020 04:20:58 -0800 (PST)
Subject: Re: [PATCH kvmtool 09/16] arm: Allow the user to specify RAM base
 address
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-10-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <9766652a-51a6-ab39-27ce-4c6fa510c695@arm.com>
Date:   Thu, 6 Feb 2020 12:20:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-10-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> At the moment, the user can specify the amount of RAM a virtual machine
> has, which starts at the fixed address ARM_MEMORY_AREA. The memory below
> this address is used by MMIO and PCI devices.
> 
> However, it might be interesting to specify a different starting address
> for the guest RAM. With this patch, the user can specify the address and
> the amount of RAM a virtual machine has from the command line by using the
> syntax -m/--mem size[@addr]. The address is optional, and must be higher or
> equal to ARM_MEMORY_AREA. If it's not specified, the old behavior is
> preserved.
> 
> This option is guarded by the define ARCH_SUPPORT_CFG_RAM_BASE, and at
> the moment only the arm architecture has support for it. If an
> architecture doesn't implement this feature, then the old behavior is
> preserved and specifying the RAM base address is considered an user
> error.
> 
> This patch is based upon previous work by Julien Grall.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arm/aarch32/include/kvm/kvm-arch.h |  2 +-
>   arm/aarch64/include/kvm/kvm-arch.h |  6 ++---
>   arm/include/arm-common/kvm-arch.h  |  6 +++--
>   arm/kvm.c                          | 17 ++++++++++----
>   builtin-run.c                      | 48 ++++++++++++++++++++++++++++++++++----
>   include/kvm/kvm-config.h           |  3 +++
>   kvm.c                              |  6 +++++
>   7 files changed, 73 insertions(+), 15 deletions(-)
> 
> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
> index cd31e72971bd..0aa5db40502d 100644
> --- a/arm/aarch32/include/kvm/kvm-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-arch.h
> @@ -3,7 +3,7 @@
>   
>   #define ARM_KERN_OFFSET(...)	0x8000
>   
> -#define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
> +#define ARM_MAX_ADDR(...)	ARM_LOMAP_MAX_ADDR
>   
>   #include "arm-common/kvm-arch.h"
>   


>   
>   void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
>   {
> -	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
> -		cfg->ram_size = ARM_MAX_MEMORY(cfg);
> +	if (cfg->ram_base == INVALID_MEM_ADDR)
> +		cfg->ram_base = ARM_MEMORY_AREA;
> +
> +	if (cfg->ram_base < ARM_MEMORY_AREA ||
> +	    cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
> +		cfg->ram_base = ARM_MEMORY_AREA;
> +		pr_warning("Changing RAM base to 0x%llx", cfg->ram_base);
> +	}
> +
> +	if (cfg->ram_base + cfg->ram_size > ARM_MAX_ADDR(cfg)) {
> +		cfg->ram_size = ARM_MAX_ADDR(cfg) - cfg->ram_base;
>   		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
>   	}
>   }
> @@ -229,7 +238,7 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
>   
>   	/* For default firmware address, lets load it at the begining of RAM */
>   	if (fw_addr == 0)
> -		fw_addr = ARM_MEMORY_AREA;
> +		fw_addr = kvm->cfg.ram_base;

At this time, we have kvm->arch.memory_guest_start set. Even though they
both might be the same, I think kvm->arch.memory_guest_start is safer
here.


>   
>   	if (!validate_fw_addr(kvm, fw_addr))
>   		die("Bad firmware destination: 0x%016llx", fw_addr);
> diff --git a/builtin-run.c b/builtin-run.c
> index 4e0c52b3e027..df255cc44078 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -87,6 +87,44 @@ void kvm_run_set_wrapper_sandbox(void)
>   	kvm_run_wrapper = KVM_RUN_SANDBOX;
>   }
>   
> +static int mem_parser(const struct option *opt, const char *arg, int unset)
> +{
> +	struct kvm_config *cfg = opt->value;
> +	const char *p = arg;
> +	char *next;
> +	u64 size, addr = INVALID_MEM_ADDR;
> +
> +	/* Parse memory size. */
> +	size = strtoll(p, &next, 0);
> +	if (next == p)
> +		die("Invalid memory size");
> +
> +	/* The user specifies the memory in MB, we use bytes. */
> +	size <<= MB_SHIFT;
> +
> +	if (*next == '\0')
> +		goto out;
> +	else if (*next == '@')
> +		p = next + 1;
> +	else
> +		die("Unexpected character after memory size: %c", *next);
> +
> +	addr = strtoll(p, &next, 0);
> +	if (next == p)
> +		die("Invalid memory address");

Could we use "memory base address" to be explicit ?

> +
> +#ifndef ARCH_SUPPORT_CFG_RAM_BASE
> +	if (addr != INVALID_MEM_ADDR)
> +		die("Specifying the memory address not supported by the architecture");

Same here ^

> +#endif
> +
> +out:
> +	cfg->ram_base = addr;
> +	cfg->ram_size = size;
> +
> +	return 0;
> +}
> +
>   #ifndef OPT_ARCH_RUN
>   #define OPT_ARCH_RUN(...)
>   #endif
> @@ -97,8 +135,11 @@ void kvm_run_set_wrapper_sandbox(void)
>   	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
>   			"A name for the guest"),			\
>   	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
> -	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
> -		" size in MB."),					\
> +	OPT_CALLBACK('m', "mem", cfg,					\
> +		     "size[@addr]",					\
> +		     "Virtual machine memory size in MB,"		\
> +		     " optionally starting at <addr>.",			\
> +		     mem_parser, NULL),					\

Given that we only support this option for archs who opt-in, could we
keep the "help" message consistent with what is built ?

#ifdef ARCH_SUPPORT_CFG_RAM_BASE
#define MEM_OPT_HELP_SHORT	"size[@addr]"
#define MEM_OPT_HELP_DESC	\
	"Virtual machine memory size in MB, optionally start at <addr>"
#else
#define MEM_OPT_HELP_SHORT	"size"
#define MEM_OPT_HELP_DESC	"Virtual machine memory size in MB."

#endif

Or some other means, so that the help text is consistent with what
we build.

Rest looks fine to me.

Suzuki

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE037F4AE
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 11:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhEMJIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 05:08:41 -0400
Received: from foss.arm.com ([217.140.110.172]:59812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhEMJIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 05:08:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEBF6101E;
        Thu, 13 May 2021 02:07:26 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AD5E3F719;
        Thu, 13 May 2021 02:07:26 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v3 8/8] arm/arm64: psci: Don't assume
 method is hvc
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-9-drjones@redhat.com>
 <3dd4b8f6-612d-e0c0-f5b5-d8a380213a1d@arm.com>
 <20210513070857.z22utxgp3vooar7u@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6c800117-9a08-2b97-f938-85e10809196b@arm.com>
Date:   Thu, 13 May 2021 10:08:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513070857.z22utxgp3vooar7u@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 5/13/21 8:08 AM, Andrew Jones wrote:
> On Wed, May 12, 2021 at 05:14:24PM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> On 4/29/21 5:41 PM, Andrew Jones wrote:
>>> The method can be smc in addition to hvc, and it will be when running
>>> on bare metal. Additionally, we move the invocations to assembly so
>>> we don't have to rely on compiler assumptions. We also fix the
>>> prototype of psci_invoke. It should return long, not int, and
>>> function_id should be an unsigned int, not an unsigned long.
>> Sorry to harp on this again, but to be honest, it's still not clear to me why the
>> psci_invoke_{hvc,smc} functions return a long int.
>>
>> If we only expect the PSCI functions to return error codes, then the PSCI spec
>> says these are 32-bit signed integers. If we want to support PSCI functions
>> returning other values, like PSCI_STAT_{RESIDENCY,COUNT}, then the invoke
>> functions should return an unsigned value.
>>
>> The only case we're supporting is the error return for the SMC calling convention
>> (which says that error codes are 32/64bit signed integers).
> psci_invoke_{hvc,smc} should implement the SMC calling convention, since
> they're just wrapping the smc/hvc call. PSCI calls that build on that,
> e.g. psci_cpu_on, can define their own return type and then translate
> the signed long returned by SMC into, e.g. 32-bit signed integers. Indeed
> that's what psci_cpu_on does.
>
> I would write something like that in the commit message or rename
> psci_invoke to smc_invoke.

I agree that psci_invoke_* use the SMC calling convention, but we're not
implementing *all* the features of the SMC calling convention, because SMCCC can
return more than one result in registers r0-r3. In my opinion, I think the easiest
solution and the most consistent with both specifications would be to keep the
current names and change the return value either to an int, and put a comment
saying that we only support PSCI functions that return an error, either to a long
unsigned int, meaning that we support *all* PSCI functions as defined in ARM DEN
0022D.

What do you think? Does that make sense?

Thanks,

Alex

>  
>
> Thanks,
> drew
>
>> Since the commit
>> specifically mentions this change, I think some explanation why this width was
>> chosen would be appropriate. Unless it's painfully obvious and I'm just not seeing
>> it, which is a possibility.
>>
>> Other than that, the patch looks good. I'll some tests to make sure everything is
>> in order.
>>
>> Thanks,
>>
>> Alex
>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>  arm/cstart.S       | 22 ++++++++++++++++++++++
>>>  arm/cstart64.S     | 22 ++++++++++++++++++++++
>>>  arm/selftest.c     | 34 +++++++---------------------------
>>>  lib/arm/asm/psci.h | 10 ++++++++--
>>>  lib/arm/psci.c     | 35 +++++++++++++++++++++++++++--------
>>>  lib/arm/setup.c    |  2 ++
>>>  6 files changed, 88 insertions(+), 37 deletions(-)
>>>
>>> diff --git a/arm/cstart.S b/arm/cstart.S
>>> index 446966de350d..2401d92cdadc 100644
>>> --- a/arm/cstart.S
>>> +++ b/arm/cstart.S
>>> @@ -95,6 +95,28 @@ start:
>>>  
>>>  .text
>>>  
>>> +/*
>>> + * psci_invoke_hvc / psci_invoke_smc
>>> + *
>>> + * Inputs:
>>> + *   r0 -- function_id
>>> + *   r1 -- arg0
>>> + *   r2 -- arg1
>>> + *   r3 -- arg2
>>> + *
>>> + * Outputs:
>>> + *   r0 -- return code
>>> + */
>>> +.globl psci_invoke_hvc
>>> +psci_invoke_hvc:
>>> +	hvc	#0
>>> +	mov	pc, lr
>>> +
>>> +.globl psci_invoke_smc
>>> +psci_invoke_smc:
>>> +	smc	#0
>>> +	mov	pc, lr
>>> +
>>>  enable_vfp:
>>>  	/* Enable full access to CP10 and CP11: */
>>>  	mov	r0, #(3 << 22 | 3 << 20)
>>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>>> index 42ba3a3ca249..e4ab7d06251e 100644
>>> --- a/arm/cstart64.S
>>> +++ b/arm/cstart64.S
>>> @@ -109,6 +109,28 @@ start:
>>>  
>>>  .text
>>>  
>>> +/*
>>> + * psci_invoke_hvc / psci_invoke_smc
>>> + *
>>> + * Inputs:
>>> + *   w0 -- function_id
>>> + *   x1 -- arg0
>>> + *   x2 -- arg1
>>> + *   x3 -- arg2
>>> + *
>>> + * Outputs:
>>> + *   x0 -- return code
>>> + */
>>> +.globl psci_invoke_hvc
>>> +psci_invoke_hvc:
>>> +	hvc	#0
>>> +	ret
>>> +
>>> +.globl psci_invoke_smc
>>> +psci_invoke_smc:
>>> +	smc	#0
>>> +	ret
>>> +
>>>  get_mmu_off:
>>>  	adrp	x0, auxinfo
>>>  	ldr	x0, [x0, :lo12:auxinfo + 8]
>>> diff --git a/arm/selftest.c b/arm/selftest.c
>>> index 4495b161cdd5..9f459ed3d571 100644
>>> --- a/arm/selftest.c
>>> +++ b/arm/selftest.c
>>> @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
>>>  	exit(report_summary());
>>>  }
>>>  
>>> -static bool psci_check(void)
>>> +static void psci_print(void)
>>>  {
>>> -	const struct fdt_property *method;
>>> -	int node, len, ver;
>>> -
>>> -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
>>> -	if (node < 0) {
>>> -		printf("PSCI v0.2 compatibility required\n");
>>> -		return false;
>>> -	}
>>> -
>>> -	method = fdt_get_property(dt_fdt(), node, "method", &len);
>>> -	if (method == NULL) {
>>> -		printf("bad psci device tree node\n");
>>> -		return false;
>>> -	}
>>> -
>>> -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
>>> -		printf("psci method must be hvc\n");
>>> -		return false;
>>> -	}
>>> -
>>> -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>>> -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
>>> -				       PSCI_VERSION_MINOR(ver));
>>> -
>>> -	return true;
>>> +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>>> +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
>>> +					  PSCI_VERSION_MINOR(ver));
>>> +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
>>> +				       "hvc" : "smc");
>>>  }
>>>  
>>>  static void cpu_report(void *data __unused)
>>> @@ -465,7 +445,7 @@ int main(int argc, char **argv)
>>>  
>>>  	} else if (strcmp(argv[1], "smp") == 0) {
>>>  
>>> -		report(psci_check(), "PSCI version");
>>> +		psci_print();
>>>  		on_cpus(cpu_report, NULL);
>>>  		while (!cpumask_full(&ready))
>>>  			cpu_relax();
>>> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
>>> index 7b956bf5987d..f87fca0422cc 100644
>>> --- a/lib/arm/asm/psci.h
>>> +++ b/lib/arm/asm/psci.h
>>> @@ -3,8 +3,14 @@
>>>  #include <libcflat.h>
>>>  #include <linux/psci.h>
>>>  
>>> -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
>>> -		       unsigned long arg1, unsigned long arg2);
>>> +typedef long (*psci_invoke_fn)(unsigned int function_id, unsigned long arg0,
>>> +			       unsigned long arg1, unsigned long arg2);
>>> +extern psci_invoke_fn psci_invoke;
>>> +extern long psci_invoke_hvc(unsigned int function_id, unsigned long arg0,
>>> +			    unsigned long arg1, unsigned long arg2);
>>> +extern long psci_invoke_smc(unsigned int function_id, unsigned long arg0,
>>> +			    unsigned long arg1, unsigned long arg2);
>>> +extern void psci_set_conduit(void);
>>>  extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
>>>  extern void psci_system_reset(void);
>>>  extern int cpu_psci_cpu_boot(unsigned int cpu);
>>> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
>>> index 936c83948b6a..3053b3041c28 100644
>>> --- a/lib/arm/psci.c
>>> +++ b/lib/arm/psci.c
>>> @@ -6,22 +6,21 @@
>>>   *
>>>   * This work is licensed under the terms of the GNU LGPL, version 2.
>>>   */
>>> +#include <devicetree.h>
>>>  #include <asm/psci.h>
>>>  #include <asm/setup.h>
>>>  #include <asm/page.h>
>>>  #include <asm/smp.h>
>>>  
>>> -__attribute__((noinline))
>>> -int psci_invoke(unsigned long function_id, unsigned long arg0,
>>> -		unsigned long arg1, unsigned long arg2)
>>> +static long psci_invoke_none(unsigned int function_id, unsigned long arg0,
>>> +			     unsigned long arg1, unsigned long arg2)
>>>  {
>>> -	asm volatile(
>>> -		"hvc #0"
>>> -	: "+r" (function_id)
>>> -	: "r" (arg0), "r" (arg1), "r" (arg2));
>>> -	return function_id;
>>> +	printf("No PSCI method configured! Can't invoke...\n");
>>> +	return PSCI_RET_NOT_PRESENT;
>>>  }
>>>  
>>> +psci_invoke_fn psci_invoke = psci_invoke_none;
>>> +
>>>  int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
>>>  {
>>>  #ifdef __arm__
>>> @@ -56,3 +55,23 @@ void psci_system_off(void)
>>>  	int err = psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
>>>  	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>>>  }
>>> +
>>> +void psci_set_conduit(void)
>>> +{
>>> +	const void *fdt = dt_fdt();
>>> +	const struct fdt_property *method;
>>> +	int node, len;
>>> +
>>> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
>>> +	assert_msg(node >= 0, "PSCI v0.2 compatibility required");
>>> +
>>> +	method = fdt_get_property(fdt, node, "method", &len);
>>> +	assert(method != NULL && len == 4);
>>> +
>>> +	if (strcmp(method->data, "hvc") == 0)
>>> +		psci_invoke = psci_invoke_hvc;
>>> +	else if (strcmp(method->data, "smc") == 0)
>>> +		psci_invoke = psci_invoke_smc;
>>> +	else
>>> +		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
>>> +}
>>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
>>> index 86f054304baf..bcdf0d78c2e2 100644
>>> --- a/lib/arm/setup.c
>>> +++ b/lib/arm/setup.c
>>> @@ -25,6 +25,7 @@
>>>  #include <asm/processor.h>
>>>  #include <asm/smp.h>
>>>  #include <asm/timer.h>
>>> +#include <asm/psci.h>
>>>  
>>>  #include "io.h"
>>>  
>>> @@ -266,6 +267,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>>>  	mem_regions_add_assumed();
>>>  	mem_init(PAGE_ALIGN((unsigned long)freemem));
>>>  
>>> +	psci_set_conduit();
>>>  	cpu_init();
>>>  
>>>  	/* cpu_init must be called before thread_info_init */

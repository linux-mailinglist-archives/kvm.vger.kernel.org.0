Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D2236C8DD
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhD0Prg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:47:36 -0400
Received: from foss.arm.com ([217.140.110.172]:54354 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhD0Prf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 11:47:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54D0D31B;
        Tue, 27 Apr 2021 08:46:52 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90A3D3F73B;
        Tue, 27 Apr 2021 08:46:50 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2 8/8] arm/arm64: psci: don't assume
 method is hvc
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-9-drjones@redhat.com>
 <20210421070206.mbtarb4cge5ywyuv@gator.home>
 <20210422161702.76ucofe2pbj4oacc@gator>
 <c36ad6f1-a48f-02f0-27c9-e18d9efe3023@arm.com>
 <20210426163543.rus23uuwoalcqgas@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <09d04363-e8f7-0d00-55ec-ef7342a87f92@arm.com>
Date:   Tue, 27 Apr 2021 16:47:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210426163543.rus23uuwoalcqgas@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/26/21 5:35 PM, Andrew Jones wrote:
> On Mon, Apr 26, 2021 at 03:57:34PM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> On 4/22/21 5:17 PM, Andrew Jones wrote:
>>> For v3, I've done the following changes (inline)
>>>
>>> On Wed, Apr 21, 2021 at 09:02:06AM +0200, Andrew Jones wrote:
>>>> On Tue, Apr 20, 2021 at 09:00:02PM +0200, Andrew Jones wrote:
>>>>> The method can also be smc and it will be when running on bare metal.
>>>>>
>>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>>>> ---
>>>>>  arm/cstart.S       | 22 ++++++++++++++++++++++
>>>>>  arm/cstart64.S     | 22 ++++++++++++++++++++++
>>>>>  arm/selftest.c     | 34 +++++++---------------------------
>>>>>  lib/arm/asm/psci.h | 10 ++++++++--
>>>>>  lib/arm/psci.c     | 37 +++++++++++++++++++++++++++++--------
>>>>>  lib/arm/setup.c    |  2 ++
>>>>>  6 files changed, 90 insertions(+), 37 deletions(-)
>>>>>
>>>>> diff --git a/arm/cstart.S b/arm/cstart.S
>>>>> index 446966de350d..2401d92cdadc 100644
>>>>> --- a/arm/cstart.S
>>>>> +++ b/arm/cstart.S
>>>>> @@ -95,6 +95,28 @@ start:
>>>>>  
>>>>>  .text
>>>>>  
>>>>> +/*
>>>>> + * psci_invoke_hvc / psci_invoke_smc
>>>>> + *
>>>>> + * Inputs:
>>>>> + *   r0 -- function_id
>>>>> + *   r1 -- arg0
>>>>> + *   r2 -- arg1
>>>>> + *   r3 -- arg2
>>>>> + *
>>>>> + * Outputs:
>>>>> + *   r0 -- return code
>>>>> + */
>>>>> +.globl psci_invoke_hvc
>>>>> +psci_invoke_hvc:
>>>>> +	hvc	#0
>>>>> +	mov	pc, lr
>>>>> +
>>>>> +.globl psci_invoke_smc
>>>>> +psci_invoke_smc:
>>>>> +	smc	#0
>>>>> +	mov	pc, lr
>>>>> +
>>>>>  enable_vfp:
>>>>>  	/* Enable full access to CP10 and CP11: */
>>>>>  	mov	r0, #(3 << 22 | 3 << 20)
>>>>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>>>>> index 42ba3a3ca249..7610e28f06dd 100644
>>>>> --- a/arm/cstart64.S
>>>>> +++ b/arm/cstart64.S
>>>>> @@ -109,6 +109,28 @@ start:
>>>>>  
>>>>>  .text
>>>>>  
>>>>> +/*
>>>>> + * psci_invoke_hvc / psci_invoke_smc
>>>>> + *
>>>>> + * Inputs:
>>>>> + *   x0 -- function_id
>>> changed this comment to be 'w0 -- function_id'
>>>
>>>>> + *   x1 -- arg0
>>>>> + *   x2 -- arg1
>>>>> + *   x3 -- arg2
>>>>> + *
>>>>> + * Outputs:
>>>>> + *   x0 -- return code
>>>>> + */
>>>>> +.globl psci_invoke_hvc
>>>>> +psci_invoke_hvc:
>>>>> +	hvc	#0
>>>>> +	ret
>>>>> +
>>>>> +.globl psci_invoke_smc
>>>>> +psci_invoke_smc:
>>>>> +	smc	#0
>>>>> +	ret
>>>>> +
>>>>>  get_mmu_off:
>>>>>  	adrp	x0, auxinfo
>>>>>  	ldr	x0, [x0, :lo12:auxinfo + 8]
>>>>> diff --git a/arm/selftest.c b/arm/selftest.c
>>>>> index 4495b161cdd5..9f459ed3d571 100644
>>>>> --- a/arm/selftest.c
>>>>> +++ b/arm/selftest.c
>>>>> @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
>>>>>  	exit(report_summary());
>>>>>  }
>>>>>  
>>>>> -static bool psci_check(void)
>>>>> +static void psci_print(void)
>>>>>  {
>>>>> -	const struct fdt_property *method;
>>>>> -	int node, len, ver;
>>>>> -
>>>>> -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
>>>>> -	if (node < 0) {
>>>>> -		printf("PSCI v0.2 compatibility required\n");
>>>>> -		return false;
>>>>> -	}
>>>>> -
>>>>> -	method = fdt_get_property(dt_fdt(), node, "method", &len);
>>>>> -	if (method == NULL) {
>>>>> -		printf("bad psci device tree node\n");
>>>>> -		return false;
>>>>> -	}
>>>>> -
>>>>> -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
>>>>> -		printf("psci method must be hvc\n");
>>>>> -		return false;
>>>>> -	}
>>>>> -
>>>>> -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>>>>> -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
>>>>> -				       PSCI_VERSION_MINOR(ver));
>>>>> -
>>>>> -	return true;
>>>>> +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>>>>> +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
>>>>> +					  PSCI_VERSION_MINOR(ver));
>>>>> +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
>>>>> +				       "hvc" : "smc");
>>>>>  }
>>>>>  
>>>>>  static void cpu_report(void *data __unused)
>>>>> @@ -465,7 +445,7 @@ int main(int argc, char **argv)
>>>>>  
>>>>>  	} else if (strcmp(argv[1], "smp") == 0) {
>>>>>  
>>>>> -		report(psci_check(), "PSCI version");
>>>>> +		psci_print();
>>>>>  		on_cpus(cpu_report, NULL);
>>>>>  		while (!cpumask_full(&ready))
>>>>>  			cpu_relax();
>>>>> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
>>>>> index 7b956bf5987d..2820c0a3afc7 100644
>>>>> --- a/lib/arm/asm/psci.h
>>>>> +++ b/lib/arm/asm/psci.h
>>>>> @@ -3,8 +3,14 @@
>>>>>  #include <libcflat.h>
>>>>>  #include <linux/psci.h>
>>>>>  
>>>>> -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
>>>>> -		       unsigned long arg1, unsigned long arg2);
>>>>> +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
>>>>> +			      unsigned long arg1, unsigned long arg2);
>>>>> +extern psci_invoke_fn psci_invoke;
>>>>> +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
>>>>> +			   unsigned long arg1, unsigned long arg2);
>>>>> +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
>>>>> +			   unsigned long arg1, unsigned long arg2);
>>> The prototypes are now
>>>
>>> long invoke_fn(unsigned int function_id, unsigned long arg0,
>>>                unsigned long arg1, unsigned long arg2)
>>>
>>> Notice the return value changed to long and the function_id to
>>> unsigned int.
>> Strictly speaking, arm always returns an unsigned long (32bits), but arm64 can
>> return either an unsigned long (64bits) when using SMC64/HVC64, or an unsigned int
>> (32bits) when using SMC32/HVC32.
> Hmm, where did you see that? Because section 5.1 of the SMC calling
> convention disagrees
>
> """
> 5.1 Error codes
> Errors codes that are returned in R0, W0 and X0 are signed integers of the
> appropriate size:
> * In AArch32:
>   o When using the SMC32/HVC32 calling convention, error codes, which are
>     returned in R0, are 32-bit signed integers.
> * In AArch64:
>   o When using the SMC64/HVC64 calling convention, error codes, which are
>     returned in X0, are 64-bit signed integers.
>   o When using the SMC32/HVC32 calling convention, error codes, which are
>     returned in W0, are 32-bit signed integers. X0[63:32] is UNDEFINED.
> """

I made a mistake, I read "long" and thought unsigned integer instead of signed.

I went over the PSCI spec again, and PSCI_STAT_RESIDENCY and PSCI_STAT_COUNT
return an uint64_t or uint32_t, depending on the convention. Those were introduced
in PSCI 1.0, they are optional and none of the tests use them, so I guess we can
ignore them for now and revisit the prototypes if we ever need to.

Thanks,

Alex

>
> And 5.2.2 from the Power State Coordination Interface manual
>
> """
> 5.2.2 Return error codes
> Table 6 defines the values for error codes used with PSCI functions. All
> errors are considered to be 32-bit signed integers.
> """
>
> Thanks,
> drew
>

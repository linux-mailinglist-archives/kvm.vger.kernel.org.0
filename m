Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861C72A4195
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 11:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCKV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 05:21:28 -0500
Received: from foss.arm.com ([217.140.110.172]:45896 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgKCKV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 05:21:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF045139F;
        Tue,  3 Nov 2020 02:21:27 -0800 (PST)
Received: from C02W217MHV2R.local (unknown [10.57.19.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B99803F66E;
        Tue,  3 Nov 2020 02:21:26 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: Check if the configured
 translation granule is supported
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-3-nikos.nikoleris@arm.com>
 <20201103100222.dpryytbkdjaryehr@kamzik.brq.redhat.com>
Message-ID: <fb339936-e034-b138-fc14-e115965d3cf5@arm.com>
Date:   Tue, 3 Nov 2020 10:21:25 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103100222.dpryytbkdjaryehr@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 03/11/2020 10:02, Andrew Jones wrote:
> On Mon, Nov 02, 2020 at 11:34:44AM +0000, Nikos Nikoleris wrote:
>> Now that we can change the translation granule at will, and since
>> arm64 implementations can support a subset of the architecturally
>> defined granules, we need to check and warn the user if the configured
>> granule is not supported.
> 
> nit: it'd be better for this patch to come before the last patch.
>

Ack, I will re-order them.

>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/arm64/asm/processor.h | 65 +++++++++++++++++++++++++++++++++++++++
>>   lib/arm/mmu.c             |  3 ++
>>   2 files changed, 68 insertions(+)
>>
>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>> index 02665b8..0eac928 100644
>> --- a/lib/arm64/asm/processor.h
>> +++ b/lib/arm64/asm/processor.h
>> @@ -117,5 +117,70 @@ static inline u64 get_ctr(void)
>>   
>>   extern u32 dcache_line_size;
>>   
>> +static inline unsigned long get_id_aa64mmfr0_el1(void)
>> +{
>> +	unsigned long mmfr0;
>> +	asm volatile("mrs %0, id_aa64mmfr0_el1" : "=r" (mmfr0));
>> +	return mmfr0;
>> +}
>> +
>> +/* From arch/arm64/include/asm/cpufeature.h */
>> +static inline unsigned int
>> +cpuid_feature_extract_unsigned_field_width(u64 features, int field, int width)
>> +{
>> +	return (u64)(features << (64 - width - field)) >> (64 - width);
>> +}
>> +
>> +#define ID_AA64MMFR0_TGRAN4_SHIFT	28
>> +#define ID_AA64MMFR0_TGRAN64_SHIFT	24
>> +#define ID_AA64MMFR0_TGRAN16_SHIFT	20
>> +#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
>> +#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
>> +#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
>> +
>> +static inline bool system_supports_64kb_granule(void)
>> +{
>> +	u64 mmfr0;
>> +	u32 val;
>> +
>> +	mmfr0 = get_id_aa64mmfr0_el1();
>> +	val = cpuid_feature_extract_unsigned_field_width(
>> +		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT,4);
>> +
>> +	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
>> +}
>> +
>> +static inline bool system_supports_16kb_granule(void)
>> +{
>> +	u64 mmfr0;
>> +	u32 val;
>> +
>> +	mmfr0 = get_id_aa64mmfr0_el1();
>> +	val = cpuid_feature_extract_unsigned_field_width(
>> +		mmfr0, ID_AA64MMFR0_TGRAN16_SHIFT, 4);
>> +
>> +	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
>> +}
>> +
>> +static inline bool system_supports_4kb_granule(void)
>> +{
>> +	u64 mmfr0;
>> +	u32 val;
>> +
>> +	mmfr0 = get_id_aa64mmfr0_el1();
>> +	val = cpuid_feature_extract_unsigned_field_width(
>> +		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT, 4);
>> +
>> +	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
>> +}
>> +
>> +#if PAGE_SIZE == 65536
>> +#define system_supports_configured_granule system_supports_64kb_granule
>> +#elif PAGE_SIZE == 16384
>> +#define system_supports_configured_granule system_supports_16kb_granule
>> +#elif PAGE_SIZE == 4096
>> +#define system_supports_configured_granule system_supports_4kb_granule
>> +#endif
>> +
>>   #endif /* !__ASSEMBLY__ */
>>   #endif /* _ASMARM64_PROCESSOR_H_ */
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 6d1c75b..51fa745 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -163,6 +163,9 @@ void *setup_mmu(phys_addr_t phys_end)
>>   
>>   #ifdef __aarch64__
>>   	init_alloc_vpage((void*)(4ul << 30));
>> +
>> +	assert_msg(system_supports_configured_granule(),
>> +		   "Unsupported translation granule %d\n", PAGE_SIZE);
>                                                       ^
>                                                needs '%ld' to compile
>>   #endif
>>   
>>   	mmu_idmap = alloc_page();
>> -- 
>> 2.17.1
>>
> 
> I don't think we need the three separate functions. How about just
> doing the following diff?
>

Makes sense, I was looking at how we do it in the kernel and got carried 
away. We don't need to do that much at compile time.

Thanks for the review, I will included your suggestions in v3.

Thanks,

Nikos

> Thanks,
> drew
> 
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 540a1e842d5b..fef62f5a9866 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -160,6 +160,9 @@ void *setup_mmu(phys_addr_t phys_end)
>   
>   #ifdef __aarch64__
>   	init_alloc_vpage((void*)(4ul << 30));
> +
> +	assert_msg(system_supports_granule(PAGE_SIZE),
> +		   "Unsupported translation granule: %ld\n", PAGE_SIZE);
>   #endif
>   
>   	mmu_idmap = alloc_page();
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 02665b84cc7e..dc493d1686bc 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -117,5 +117,21 @@ static inline u64 get_ctr(void)
>   
>   extern u32 dcache_line_size;
>   
> +static inline unsigned long get_id_aa64mmfr0_el1(void)
> +{
> +	unsigned long mmfr0;
> +	asm volatile("mrs %0, id_aa64mmfr0_el1" : "=r" (mmfr0));
> +	return mmfr0;
> +}
> +
> +static inline bool system_supports_granule(size_t granule)
> +{
> +	u64 mmfr0 = get_id_aa64mmfr0_el1();
> +
> +	return ((granule == SZ_4K && ((mmfr0 >> 28) & 0xf) == 0) ||
> +		(granule == SZ_64K && ((mmfr0 >> 24) & 0xf) == 0) ||
> +		(granule == SZ_16K && ((mmfr0 >> 20) & 0xf) == 1));
> +}
> +
>   #endif /* !__ASSEMBLY__ */
>   #endif /* _ASMARM64_PROCESSOR_H_ */
> 

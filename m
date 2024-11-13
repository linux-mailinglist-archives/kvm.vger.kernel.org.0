Return-Path: <kvm+bounces-31763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C4C9C735C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDE82B376A1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C08D201036;
	Wed, 13 Nov 2024 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Ys0X/1I1"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8320E282ED
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731507360; cv=none; b=X4E7+cQVYpELwZGV7ko6rF/Ols3WFMOqmPNVuLuMlggX2bR9CVM/W7ndrD2RCJMzHV2lfTNLu26xhWSGB6QGKotXfYFbxY6fCGC/zTG6jvWfTBRWlQA4G2iINODFBI8RS36dEfue89jkOgGhXI/sV6oK53KdA1jcfSODpPIX4rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731507360; c=relaxed/simple;
	bh=BhUVQTaxLsAJyNyqUeTjebjHTvgal8Qlf+/AL5Kf4eI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SwH6C2f2ib4Gp2NnCOqxm/69RU23WSRAHrYp8MmEQ+XsQpT3UaeRDRZ6qF8/xOHFqlpAWRJDLZxQfgyKv7r1msFyy4SLc+Esj1pjFesHq29uxSVGAGrAFe2PR1n4m7pjhopzEQB6ufse1nUnB/lA05Ul9s13/mNzxwZm0ZBEuzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Ys0X/1I1; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3f48:0:640:7695:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 7A2D460C69;
	Wed, 13 Nov 2024 17:15:42 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8011:701:66e1:20a5:ba04:640b] (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id eFMhLi43WeA0-o7dHQnkG;
	Wed, 13 Nov 2024 17:15:41 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731507341;
	bh=iBWa/wjom9iHI5eiPfgN++JO1f2akO7Rl9FK3yRoHdA=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=Ys0X/1I13TkGM3xmGNKIXZpQF4kGXejVLB6JqWv3LtSOsPsNiQQhuyAkSmzRtPDD9
	 QBKDhqWr5/BA0UHv7iLEIAB5AN82ChpCdeiU37Vc0d/cv+jgmrbwoT8eUOb6qAZ4+T
	 NjVr6gRkeC1t2Z/RDgNLhyU4FxbL/mGhLF0fnqHE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <7a42f98f-610d-43b2-8e31-9b28fc674191@yandex-team.ru>
Date: Wed, 13 Nov 2024 17:15:40 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4
 processor series
To: babu.moger@amd.com
Cc: weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
 paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
 mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 marcel.apfelbaum@gmail.com, yang.zhong@intel.com, jing2.liu@intel.com,
 vkuznets@redhat.com, michael.roth@amd.com, wei.huang2@amd.com,
 berrange@redhat.com, bdas@redhat.com, pbonzini@redhat.com,
 richard.henderson@linaro.org
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230504205313.225073-8-babu.moger@amd.com>
 <e8e0bc10-07ea-4678-a319-fc8d6938d9bd@yandex-team.ru>
 <4b38c071-ecb0-112b-f4c4-d1d68e5db63d@amd.com>
 <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
 <7f7bf82f-c550-48c8-af38-e0992829f57d@amd.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <7f7bf82f-c550-48c8-af38-e0992829f57d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi!
Thank you very much!
I'm looking forward to your Genoa/Turin series.

And I've sent patch series to KVM:
https://lore.kernel.org/lkml/20241113133042.702340-1-davydov-max@yandex-team.ru/

On 11/12/24 19:23, Moger, Babu wrote:
> Hi Maksim,
> 
> On 11/12/24 04:09, Maksim Davydov wrote:
>>
>>
>> On 11/8/24 23:56, Moger, Babu wrote:
>>> Hi Maxim,
>>>
>>> Thanks for looking into this. I will fix the bits I mentioned below in
>>> upcoming Genoa/Turin model update.
>>>
>>> I have few comments below.
>>>
>>> On 11/8/2024 12:15 PM, Maksim Davydov wrote:
>>>> Hi!
>>>> I compared EPYC-Genoa CPU model with CPUID output from real EPYC Genoa
>>>> host. I found some mismatches that confused me. Could you help me to
>>>> understand them?
>>>>
>>>> On 5/4/23 23:53, Babu Moger wrote:
>>>>> Adds the support for AMD EPYC Genoa generation processors. The model
>>>>> display for the new processor will be EPYC-Genoa.
>>>>>
>>>>> Adds the following new feature bits on top of the feature bits from
>>>>> the previous generation EPYC models.
>>>>>
>>>>> avx512f         : AVX-512 Foundation instruction
>>>>> avx512dq        : AVX-512 Doubleword & Quadword Instruction
>>>>> avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
>>>>> avx512cd        : AVX-512 Conflict Detection instruction
>>>>> avx512bw        : AVX-512 Byte and Word Instructions
>>>>> avx512vl        : AVX-512 Vector Length Extension Instructions
>>>>> avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
>>>>> avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
>>>>> gfni            : AVX-512 Galois Field New Instructions
>>>>> avx512_vnni     : AVX-512 Vector Neural Network Instructions
>>>>> avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
>>>>> avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
>>>>>                     Quadword Instructions
>>>>> avx512_bf16    : AVX-512 BFLOAT16 instructions
>>>>> la57            : 57-bit virtual address support (5-level Page Tables)
>>>>> vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject
>>>>> the NMI
>>>>>                     into the guest without using Event Injection mechanism
>>>>>                     meaning not required to track the guest NMI and
>>>>> intercepting
>>>>>                     the IRET.
>>>>> auto-ibrs       : The AMD Zen4 core supports a new feature called
>>>>> Automatic IBRS.
>>>>>                     It is a "set-and-forget" feature that means that,
>>>>> unlike e.g.,
>>>>>                     s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS
>>>>> mitigation
>>>>>                     resources automatically across CPL transitions.
>>>>>
>>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>>> ---
>>>>>    target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 122 insertions(+)
>>>>>
>>>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>>>> index d50ace84bf..71fe1e02ee 100644
>>>>> --- a/target/i386/cpu.c
>>>>> +++ b/target/i386/cpu.c
>>>>> @@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info
>>>>> = {
>>>>>        },
>>>>>    };
>>>>> +static const CPUCaches epyc_genoa_cache_info = {
>>>>> +    .l1d_cache = &(CPUCacheInfo) {
>>>>> +        .type = DATA_CACHE,
>>>>> +        .level = 1,
>>>>> +        .size = 32 * KiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 64,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = 1,
>>>>> +        .no_invd_sharing = true,
>>>>> +    },
>>>>> +    .l1i_cache = &(CPUCacheInfo) {
>>>>> +        .type = INSTRUCTION_CACHE,
>>>>> +        .level = 1,
>>>>> +        .size = 32 * KiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 64,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = 1,
>>>>> +        .no_invd_sharing = true,
>>>>> +    },
>>>>> +    .l2_cache = &(CPUCacheInfo) {
>>>>> +        .type = UNIFIED_CACHE,
>>>>> +        .level = 2,
>>>>> +        .size = 1 * MiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 2048,
>>>>> +        .lines_per_tag = 1,
>>>>
>>>> 1. Why L2 cache is not shown as inclusive and self-initializing?
>>>>
>>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>>> * cache inclusive. Read-only. Reset: Fixed,1.
>>>> * cache is self-initializing. Read-only. Reset: Fixed,1.
>>>
>>> Yes. That is correct. This needs to be fixed. I Will fix it.
>>>>
>>>>> +    },
>>>>> +    .l3_cache = &(CPUCacheInfo) {
>>>>> +        .type = UNIFIED_CACHE,
>>>>> +        .level = 3,
>>>>> +        .size = 32 * MiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 16,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 32768,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = true,
>>>>> +        .inclusive = true,
>>>>> +        .complex_indexing = false,
>>>>
>>>> 2. Why L3 cache is shown as inclusive? Why is it not shown in L3 that
>>>> the WBINVD/INVD instruction is not guaranteed to invalidate all lower
>>>> level caches (0 bit)?
>>>>
>>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>>> * cache inclusive. Read-only. Reset: Fixed,0.
>>>> * Write-Back Invalidate/Invalidate. Read-only. Reset: Fixed,1.
>>>>
>>>
>>> Yes. Both of this needs to be fixed. I Will fix it.
>>>
>>>>
>>>>
>>>> 3. Why the default stub is used for TLB, but not real values as for
>>>> other caches?
>>>
>>> Can you please eloberate on this?
>>>
>>
>> For L1i, L1d, L2 and L3 cache we provide the correct information about
>> characteristics. In contrast, for L1i TLB, L1d TLB, L2i TLB and L2d TLB
>> (0x80000005 and 0x80000006) we use the same value for all CPU models.
>> Sometimes it seems strange. For instance, the current default value in
>> QEMU for L2 TLB associativity for 4 KB pages is 4. But 4 is a reserved
>> value for Genoa (as PPR for Family 19h Model 11h says)
> 
> Yes. I see that. We may need to address this sometime in the future.
> 
>>
>>>>
>>>>> +    },
>>>>> +};
>>>>> +
>>>>>    /* The following VMX features are not supported by KVM and are left
>>>>> out in the
>>>>>     * CPU definitions:
>>>>>     *
>>>>> @@ -4472,6 +4522,78 @@ static const X86CPUDefinition
>>>>> builtin_x86_defs[] = {
>>>>>                { /* end of list */ }
>>>>>            }
>>>>>        },
>>>>> +    {
>>>>> +        .name = "EPYC-Genoa",
>>>>> +        .level = 0xd,
>>>>> +        .vendor = CPUID_VENDOR_AMD,
>>>>> +        .family = 25,
>>>>> +        .model = 17,
>>>>> +        .stepping = 0,
>>>>> +        .features[FEAT_1_EDX] =
>>>>> +            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX |
>>>>> CPUID_CLFLUSH |
>>>>> +            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA |
>>>>> CPUID_PGE |
>>>>> +            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 |
>>>>> CPUID_MCE |
>>>>> +            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
>>>>> +            CPUID_VME | CPUID_FP87,
>>>>> +        .features[FEAT_1_ECX] =
>>>>> +            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
>>>>> +            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
>>>>> +            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
>>>>> +            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
>>>>> +            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
>>>>> +            CPUID_EXT_SSE3,
>>>>> +        .features[FEAT_8000_0001_EDX] =
>>>>> +            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
>>>>> +            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
>>>>> +            CPUID_EXT2_SYSCALL,
>>>>> +        .features[FEAT_8000_0001_ECX] =
>>>>> +            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
>>>>> +            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
>>>>> +            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
>>>>> +            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
>>>>> +        .features[FEAT_8000_0008_EBX] =
>>>>> +            CPUID_8000_0008_EBX_CLZERO |
>>>>> CPUID_8000_0008_EBX_XSAVEERPTR |
>>>>> +            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
>>>>> +            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
>>>>> +            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
>>>>> +            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
>>>>
>>>> 4. Why 0x80000008_EBX features related to speculation vulnerabilities
>>>> (BTC_NO, IBPB_RET, IbrsPreferred, INT_WBINVD) are not set?
>>>
>>> KVM does not expose these bits to the guests yet.
>>>
>>> I normally check using the ioctl KVM_GET_SUPPORTED_CPUID.
>>>
>>
>> I'm not sure, but at least the first two of these features seem to be
>> helpful to choose the appropriate mitigation. Do you think that we should
>> add them to KVM?
> 
> Yes. Sure.
> 
>>
>>>
>>>>
>>>>> +        .features[FEAT_8000_0021_EAX] =
>>>>> +            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
>>>>> +            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
>>>>> +            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
>>>>> +            CPUID_8000_0021_EAX_AUTO_IBRS,
>>>>
>>>> 5. Why some 0x80000021_EAX features are not set?
>>>> (FsGsKernelGsBaseNonSerializing, FSRC and FSRS)
>>>
>>> KVM does not expose FSRC and FSRS bits to the guests yet.
>>
>> But KVM exposes the same features (0x7 ecx=1, bits 10 and 11) for Intel
>> CPU models. Do we have to add these bits for AMD to KVM?
> 
> Yes. Sure.
>>
>>>
>>> The KVM reports the bit FsGsKernelGsBaseNonSerializing. I will check if
>>> we can add this bit to the Genoa and Turin.
> 
> Will add this in my qemu series.
> 
>>>
>>>>
>>>>> +        .features[FEAT_7_0_EBX] =
>>>>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 |
>>>>> CPUID_7_0_EBX_AVX2 |
>>>>> +            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 |
>>>>> CPUID_7_0_EBX_ERMS |
>>>>> +            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
>>>>> +            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED |
>>>>> CPUID_7_0_EBX_ADX |
>>>>> +            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
>>>>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>>>>> +            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
>>>>> +            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
>>>>> +        .features[FEAT_7_0_ECX] =
>>>>> +            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP |
>>>>> CPUID_7_0_ECX_PKU |
>>>>> +            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
>>>>> +            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
>>>>> +            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
>>>>> +            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
>>>>> +            CPUID_7_0_ECX_RDPID,
>>>>> +        .features[FEAT_7_0_EDX] =
>>>>> +            CPUID_7_0_EDX_FSRM,
>>>>
>>>> 6. Why L1D_FLUSH is not set? Because only vulnerable MMIO stale data
>>>> processors have to use it, am I right?
>>>
>>> KVM does not expose L1D_FLUSH to the guests. Not sure why. Need to
>>> investigate.
>>>
>>
>> It seems that KVM has exposed L1D_FLUSH since da3db168fb67
> 
> Sure. Will update my patch series.
> 
>>
>>>
>>>>
>>>>> +        .features[FEAT_7_1_EAX] =
>>>>> +            CPUID_7_1_EAX_AVX512_BF16,
>>>>> +        .features[FEAT_XSAVE] =
>>>>> +            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
>>>>> +            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
>>>>> +        .features[FEAT_6_EAX] =
>>>>> +            CPUID_6_EAX_ARAT,
>>>>> +        .features[FEAT_SVM] =
>>>>> +            CPUID_SVM_NPT | CPUID_SVM_NRIPSAVE | CPUID_SVM_VNMI |
>>>>> +            CPUID_SVM_SVME_ADDR_CHK,
>>>>> +        .xlevel = 0x80000022,
>>>>> +        .model_id = "AMD EPYC-Genoa Processor",
>>>>> +        .cache_info = &epyc_genoa_cache_info,
>>>>> +    },
>>>>>    };
>>>>>    /*
>>>>
>>>
>>
>> So, If you don't mind, I will send a patch to KVM within a few hours. I
>> will add bits for FSRC, FSRS and some bits from 0x80000008_EBX
>>
> 
> FSRC and FSRS are not used anywhere in the kernel. It is mostly FYI kind
> of information. It does not hurt to add.  Please go ahead.
> 

-- 
Best regards,
Maksim Davydov


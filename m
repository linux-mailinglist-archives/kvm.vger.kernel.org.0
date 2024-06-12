Return-Path: <kvm+bounces-19426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7522D904F24
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFD591F27215
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F7916D9CC;
	Wed, 12 Jun 2024 09:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhLUvhJN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC45CA34
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 09:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718184214; cv=none; b=npkj+uhrnm7ZZGxTVPURgVf2r5k+TupMti5yZEiRYKgawXEYVuADqt5JQlQl4bdddbt+k9plmAqvnmEZQl/DlRmlSxWbON00ghAz09bXnTqKQSaOlR7TpgOqPCQiHyZc7yXuDlfJ9qYfg2UZr2YRhDJXK0KVqe5jUOpNsA2015c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718184214; c=relaxed/simple;
	bh=iLt/ilr2LuP/tKI+lJ7ptKmdm5nnJ+DEiNuS/HP/A0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fg3ui2jQ37eDttX/Idv8lZeVmp7/P7xQbR++AoSqjUD9gR2mrBGf4wEh372nhNqpIedZuivosYZPzhbcQg9iTe+rq6moEw0lK7accRypjxAgA5GtwX0zoHLy5SSy0TL40cFAzfRVVbSmPjPDCQmKViQrH6NiCAHczt2hbzPRy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhLUvhJN; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718184212; x=1749720212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iLt/ilr2LuP/tKI+lJ7ptKmdm5nnJ+DEiNuS/HP/A0c=;
  b=dhLUvhJNb0RweZMMZd3bRITb7PRP13fHdKbvC+C4XvxtDcbENePiwwGD
   ml+bPKXfwXhwRZSWn3usun5TlCAbUIjfdAox5+mbcdJjJncTsCq5ljmdw
   nc3KizmETiBPwbr7/zuzAP9Y6tSJfjeqggVv3Vu83Kgr/R51qHCPL4lBQ
   NmYoRaelgLRouEamtRwWrH0WGDIK/LDd8056roXCfdWsAnyncdiNf1Nfj
   vMFEGddyXO4qnVulf/gvR5CWByhRC0+IzmsuJ9lqmrOdqBzEuyK05BUWA
   iPYbVqVG7IdOKFfXwuBffa1KtvkjHXzGoCtI73fYCmEeWF2EOHzo+Ch3R
   g==;
X-CSE-ConnectionGUID: Z5lSzn7VTpCdAknWw2P89A==
X-CSE-MsgGUID: 2khlv4flQBKtHSbrPbLk6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14732055"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="14732055"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 02:23:31 -0700
X-CSE-ConnectionGUID: EYoD265pSkWKDyIPr9VlHQ==
X-CSE-MsgGUID: ubAFLb9yTt+/MVNTcD70cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="39839843"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 02:23:24 -0700
Message-ID: <04932fb5-1ab4-4f8e-90dc-4f1a71feefb6@intel.com>
Date: Wed, 12 Jun 2024 17:23:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/65] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-18-xiaoyao.li@intel.com>
 <511a147e-bc01-7fab-24d7-4ae66a6d1c44@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <511a147e-bc01-7fab-24d7-4ae66a6d1c44@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/31/2024 4:47 PM, Duan, Zhenzhong wrote:
> 
> On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
>> According to Chapter "CPUID Virtualization" in TDX module spec, CPUID
>> bits of TD can be classified into 6 types:
>>
>> ------------------------------------------------------------------------
>> 1 | As configured | configurable by VMM, independent of native value;
>> ------------------------------------------------------------------------
>> 2 | As configured | configurable by VMM if the bit is supported natively
>>      (if native)   | Otherwise it equals as native(0).
>> ------------------------------------------------------------------------
>> 3 | Fixed         | fixed to 0/1
>> ------------------------------------------------------------------------
>> 4 | Native        | reflect the native value
>> ------------------------------------------------------------------------
>> 5 | Calculated    | calculated by TDX module.
>> ------------------------------------------------------------------------
>> 6 | Inducing #VE  | get #VE exception
>> ------------------------------------------------------------------------
>>
>> Note:
>> 1. All the configurable XFAM related features and TD attributes related
>>     features fall into type #2. And fixed0/1 bits of XFAM and TD
>>     attributes fall into type #3.
>>
>> 2. For CPUID leaves not listed in "CPUID virtualization Overview" table
>>     in TDX module spec, TDX module injects #VE to TDs when those are
>>     queried. For this case, TDs can request CPUID emulation from VMM via
>>     TDVMCALL and the values are fully controlled by VMM.
>>
>> Due to TDX module has its own virtualization policy on CPUID bits, it 
>> leads
>> to what reported via KVM_GET_SUPPORTED_CPUID diverges from the supported
>> CPUID bits for TDs. In order to keep a consistent CPUID configuration
>> between VMM and TDs. Adjust supported CPUID for TDs based on TDX
>> restrictions.
>>
>> Currently only focus on the CPUID leaves recognized by QEMU's
>> feature_word_info[] that are indexed by a FeatureWord.
>>
>> Introduce a TDX CPUID lookup table, which maintains 1 entry for each
>> FeatureWord. Each entry has below fields:
>>
>>   - tdx_fixed0/1: The bits that are fixed as 0/1;
>>
>>   - depends_on_vmm_cap: The bits that are configurable from the view of
>>                TDX module. But they requires emulation of VMM
>>                when configured as enabled. For those, they are
>>                not supported if VMM doesn't report them as
>>                supported. So they need be fixed up by checking
>>                if VMM supports them.
> 
> Previously I thought bits configurable for TDX module are emulated by 
> TDX module,
> 
> it looks not. Just curious why doesn't those bits belong to "Inducing 
> #VE" type?

Because when TD guest queries this type of CPUID leaf, it doesn't get #VE.

The bits in this category are free to be configured as on/off by VMM and 
passed to TDX module via TD_PARAM. Once they get configured, they are 
queried directly by TD guest without getting #VE.

The problem is whether VMM allows them to be configured freely. E.g., 
for features TME and PCONFIG, they are configurable. However when VMM 
configures them to 1, VMM needs to provide the support of related MSRs 
of them. If VMM cannot provide such support, VMM should be allow user to 
configured to 1.

That's why we have this kind of type.

BTW, we are going to abondan the solution that let QEMU to maintain the 
CPUID configurability table in this series. Next version we will come up 
with

> Then guest can get KVM reported capabilities with tdvmcall directly.
> 
>>
>>   - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
>>                  totally configurable by VMM.
>>
>>   - supported_on_ve: It's valid only when @inducing_ve is true. It 
>> represents
>>             the maximum feature set supported that be emulated
>>             for TDs.
> This is never used together with depends_on_vmm_cap, maybe one variable 
> is enough?
>>
>> By applying TDX CPUID lookup table and TDX capabilities reported from
>> TDX module, the supported CPUID for TDs can be obtained from following
>> steps:
>>
>> - get the base of VMM supported feature set;
>>
>> - if the leaf is not a FeatureWord just return VMM's value without
>>    modification;
>>
>> - if the leaf is an inducing_ve type, applying supported_on_ve mask and
>>    return;
>>
>> - include all native bits, it covers type #2, #4, and parts of type #1.
>>    (it also includes some unsupported bits. The following step will
>>     correct it.)
>>
>> - apply fixed0/1 to it (it covers #3, and rectifies the previous step);
>>
>> - add configurable bits (it covers the other part of type #1);
>>
>> - fix the ones in vmm_fixup;
>>
>> (Calculated type is ignored since it's determined at runtime).
>>
>> Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.h     |  16 +++
>>   target/i386/kvm/kvm.c |   4 +
>>   target/i386/kvm/tdx.c | 263 ++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |   3 +
>>   4 files changed, 286 insertions(+)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 952174bb6f52..7bd604f802a1 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -787,6 +787,8 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
>>   #define CPUID_7_0_EBX_FSGSBASE          (1U << 0)
>> +/* Support for TSC adjustment MSR 0x3B */
>> +#define CPUID_7_0_EBX_TSC_ADJUST        (1U << 1)
>>   /* Support SGX */
>>   #define CPUID_7_0_EBX_SGX               (1U << 2)
>>   /* 1st Group of Advanced Bit Manipulation Extensions */
>> @@ -805,8 +807,12 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   #define CPUID_7_0_EBX_INVPCID           (1U << 10)
>>   /* Restricted Transactional Memory */
>>   #define CPUID_7_0_EBX_RTM               (1U << 11)
>> +/* Cache QoS Monitoring */
>> +#define CPUID_7_0_EBX_PQM               (1U << 12)
>>   /* Memory Protection Extension */
>>   #define CPUID_7_0_EBX_MPX               (1U << 14)
>> +/* Resource Director Technology Allocation */
>> +#define CPUID_7_0_EBX_RDT_A             (1U << 15)
>>   /* AVX-512 Foundation */
>>   #define CPUID_7_0_EBX_AVX512F           (1U << 16)
>>   /* AVX-512 Doubleword & Quadword Instruction */
>> @@ -862,10 +868,16 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   #define CPUID_7_0_ECX_AVX512VNNI        (1U << 11)
>>   /* Support for VPOPCNT[B,W] and VPSHUFBITQMB */
>>   #define CPUID_7_0_ECX_AVX512BITALG      (1U << 12)
>> +/* Intel Total Memory Encryption */
>> +#define CPUID_7_0_ECX_TME               (1U << 13)
>>   /* POPCNT for vectors of DW/QW */
>>   #define CPUID_7_0_ECX_AVX512_VPOPCNTDQ  (1U << 14)
>> +/* Placeholder for bit 15 */
>> +#define CPUID_7_0_ECX_FZM               (1U << 15)
>>   /* 5-level Page Tables */
>>   #define CPUID_7_0_ECX_LA57              (1U << 16)
>> +/* MAWAU for MPX */
>> +#define CPUID_7_0_ECX_MAWAU             (31U << 17)
>>   /* Read Processor ID */
>>   #define CPUID_7_0_ECX_RDPID             (1U << 22)
>>   /* Bus Lock Debug Exception */
>> @@ -876,6 +888,8 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   #define CPUID_7_0_ECX_MOVDIRI           (1U << 27)
>>   /* Move 64 Bytes as Direct Store Instruction */
>>   #define CPUID_7_0_ECX_MOVDIR64B         (1U << 28)
>> +/* ENQCMD and ENQCMDS instructions */
>> +#define CPUID_7_0_ECX_ENQCMD            (1U << 29)
>>   /* Support SGX Launch Control */
>>   #define CPUID_7_0_ECX_SGX_LC            (1U << 30)
>>   /* Protection Keys for Supervisor-mode Pages */
>> @@ -893,6 +907,8 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
>>   /* TSX Suspend Load Address Tracking instruction */
>>   #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
>> +/* PCONFIG instruction */
>> +#define CPUID_7_0_EDX_PCONFIG           (1U << 18)
>>   /* Architectural LBRs */
>>   #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
>>   /* AMX_BF16 instruction */
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 0e68e80f4291..389b631c03dd 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -520,6 +520,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState 
>> *s, uint32_t function,
>>           ret |= 1U << KVM_HINTS_REALTIME;
>>       }
>> +    if (is_tdx_vm()) {
>> +        tdx_get_supported_cpuid(function, index, reg, &ret);
>> +    }
>> +
>>       return ret;
>>   }
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 756058f2ed4a..85d96140b450 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -15,11 +15,129 @@
>>   #include "qemu/error-report.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>> +#include "standard-headers/asm-x86/kvm_para.h"
>>   #include "sysemu/kvm.h"
>> +#include "sysemu/sysemu.h"
>>   #include "hw/i386/x86.h"
>>   #include "kvm_i386.h"
>>   #include "tdx.h"
>> +#include "../cpu-internal.h"
>> +
>> +#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) 
>> | \
>> +                                     (1U << KVM_FEATURE_PV_UNHALT) | \
>> +                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) 
>> | \
>> +                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
>> +                                     (1U << KVM_FEATURE_POLL_CONTROL) 
>> | \
>> +                                     (1U << 
>> KVM_FEATURE_PV_SCHED_YIELD) | \
>> +                                     (1U << 
>> KVM_FEATURE_MSI_EXT_DEST_ID))
>> +
>> +typedef struct KvmTdxCpuidLookup {
>> +    uint32_t tdx_fixed0;
>> +    uint32_t tdx_fixed1;
>> +
>> +    /*
>> +     * The CPUID bits that are configurable from the view of TDX module
>> +     * but require VMM's support when wanting to enable them.
>> +     *
>> +     * For those bits, they cannot be enabled if VMM (KVM/QEMU) 
>> doesn't support
>> +     * them.
>> +     */
>> +    uint32_t depends_on_vmm_cap;
>> +
>> +    bool inducing_ve;
>> +    /*
>> +     * The maximum supported feature set for given inducing-#VE leaf.
>> +     * It's valid only when .inducing_ve is true.
>> +     */
>> +    uint32_t supported_value_on_ve;
>> +} KvmTdxCpuidLookup;
>> +
>> + /*
>> +  * QEMU maintained TDX CPUID lookup tables, which reflects how 
>> CPUIDs are
>> +  * virtualized for guest TDs based on "CPUID virtualization" of TDX 
>> spec.
>> +  *
>> +  * Note:
>> +  *
>> +  * This table will be updated runtime by tdx_caps reported by KVM.
>> +  *
>> +  */
>> +static KvmTdxCpuidLookup tdx_cpuid_lookup[FEATURE_WORDS] = {
>> +    [FEAT_1_EDX] = {
>> +        .tdx_fixed0 =
>> +            BIT(10) /* Reserved */ | BIT(20) /* Reserved */ | 
>> CPUID_IA64,
>> +        .tdx_fixed1 =
>> +            CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_APIC |
>> +            CPUID_MTRR | CPUID_MCA | CPUID_CLFLUSH | CPUID_DTS,
>> +        .depends_on_vmm_cap =
>> +            CPUID_ACPI | CPUID_PBE,
>> +    },
>> +    [FEAT_1_ECX] = {
>> +        .tdx_fixed0 =
>> +            CPUID_EXT_VMX | CPUID_EXT_SMX | BIT(16) /* Reserved */,
>> +        .tdx_fixed1 =
>> +            CPUID_EXT_CX16 | CPUID_EXT_PDCM | CPUID_EXT_X2APIC |
>> +            CPUID_EXT_AES | CPUID_EXT_XSAVE | CPUID_EXT_RDRAND |
>> +            CPUID_EXT_HYPERVISOR,
>> +        .depends_on_vmm_cap =
>> +            CPUID_EXT_EST | CPUID_EXT_TM2 | CPUID_EXT_XTPR | 
>> CPUID_EXT_DCA,
>> +    },
>> +    [FEAT_8000_0001_EDX] = {
>> +        .tdx_fixed1 =
>> +            CPUID_EXT2_NX | CPUID_EXT2_PDPE1GB | CPUID_EXT2_RDTSCP |
>> +            CPUID_EXT2_LM,
>> +    },
>> +    [FEAT_7_0_EBX] = {
>> +        .tdx_fixed0 =
>> +            CPUID_7_0_EBX_TSC_ADJUST | CPUID_7_0_EBX_SGX | 
>> CPUID_7_0_EBX_MPX,
>> +        .tdx_fixed1 =
>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_RTM |
>> +            CPUID_7_0_EBX_RDSEED | CPUID_7_0_EBX_SMAP |
>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>> +            CPUID_7_0_EBX_SHA_NI,
>> +        .depends_on_vmm_cap =
>> +            CPUID_7_0_EBX_PQM | CPUID_7_0_EBX_RDT_A,
>> +    },
>> +    [FEAT_7_0_ECX] = {
>> +        .tdx_fixed0 =
>> +            CPUID_7_0_ECX_FZM | CPUID_7_0_ECX_MAWAU |
>> +            CPUID_7_0_ECX_ENQCMD | CPUID_7_0_ECX_SGX_LC,
>> +        .tdx_fixed1 =
>> +            CPUID_7_0_ECX_MOVDIR64B | CPUID_7_0_ECX_BUS_LOCK_DETECT,
>> +        .depends_on_vmm_cap =
>> +            CPUID_7_0_ECX_TME,
>> +    },
>> +    [FEAT_7_0_EDX] = {
>> +        .tdx_fixed1 =
>> +            CPUID_7_0_EDX_SPEC_CTRL | CPUID_7_0_EDX_ARCH_CAPABILITIES |
>> +            CPUID_7_0_EDX_CORE_CAPABILITY | 
>> CPUID_7_0_EDX_SPEC_CTRL_SSBD,
>> +        .depends_on_vmm_cap =
>> +            CPUID_7_0_EDX_PCONFIG,
>> +    },
>> +    [FEAT_8000_0008_EBX] = {
>> +        .tdx_fixed0 =
>> +            ~CPUID_8000_0008_EBX_WBNOINVD,
>> +        .tdx_fixed1 =
>> +            CPUID_8000_0008_EBX_WBNOINVD,
>> +    },
>> +    [FEAT_XSAVE] = {
>> +        .tdx_fixed1 =
>> +            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
>> +            CPUID_XSAVE_XSAVES,
>> +    },
>> +    [FEAT_6_EAX] = {
>> +        .inducing_ve = true,
>> +        .supported_value_on_ve = CPUID_6_EAX_ARAT,
>> +    },
>> +    [FEAT_8000_0007_EDX] = {
>> +        .inducing_ve = true,
>> +        .supported_value_on_ve = -1U,
>> +    },
>> +    [FEAT_KVM] = {
>> +        .inducing_ve = true,
>> +        .supported_value_on_ve = TDX_SUPPORTED_KVM_FEATURES,
>> +    },
>> +};
>>   static TdxGuest *tdx_guest;
>> @@ -31,6 +149,151 @@ bool is_tdx_vm(void)
>>       return !!tdx_guest;
>>   }
>> +static inline uint32_t host_cpuid_reg(uint32_t function,
>> +                                      uint32_t index, int reg)
>> +{
>> +    uint32_t eax, ebx, ecx, edx;
>> +    uint32_t ret = 0;
>> +
>> +    host_cpuid(function, index, &eax, &ebx, &ecx, &edx);
>> +
>> +    switch (reg) {
>> +    case R_EAX:
>> +        ret = eax;
>> +        break;
>> +    case R_EBX:
>> +        ret = ebx;
>> +        break;
>> +    case R_ECX:
>> +        ret = ecx;
>> +        break;
>> +    case R_EDX:
>> +        ret = edx;
>> +        break;
>> +    }
>> +    return ret;
>> +}
>> +
>> +/*
>> + * get the configurable cpuid bits (can be set to 0 or 1) reported by 
>> TDX module
>> + * from tdx_caps.
>> + */
>> +static inline uint32_t tdx_cap_cpuid_config(uint32_t function,
>> +                                            uint32_t index, int reg)
>> +{
>> +    struct kvm_tdx_cpuid_config *cpuid_c;
>> +    int ret = 0;
>> +    int i;
>> +
>> +    if (tdx_caps->nr_cpuid_configs <= 0) {
>> +        return ret;
>> +    }
>> +
>> +    for (i = 0; i < tdx_caps->nr_cpuid_configs; i++) {
>> +        cpuid_c = &tdx_caps->cpuid_configs[i];
>> +        /* 0xffffffff in sub_leaf means the leaf doesn't require a 
>> sublesf */
>> +        if (cpuid_c->leaf == function &&
>> +            (cpuid_c->sub_leaf == 0xffffffff || cpuid_c->sub_leaf == 
>> index)) {
>> +            switch (reg) {
>> +            case R_EAX:
>> +                ret = cpuid_c->eax;
>> +                break;
>> +            case R_EBX:
>> +                ret = cpuid_c->ebx;
>> +                break;
>> +            case R_ECX:
>> +                ret = cpuid_c->ecx;
>> +                break;
>> +            case R_EDX:
>> +                ret = cpuid_c->edx;
>> +                break;
>> +            default:
>> +                return 0;
>> +            }
>> +        }
>> +    }
>> +    return ret;
>> +}
>> +
>> +static FeatureWord get_cpuid_featureword_index(uint32_t function,
>> +                                               uint32_t index, int reg)
>> +{
>> +    FeatureWord w;
>> +
>> +    for (w = 0; w < FEATURE_WORDS; w++) {
>> +        FeatureWordInfo *f = &feature_word_info[w];
>> +
>> +        if (f->type == MSR_FEATURE_WORD || f->cpuid.eax != function ||
>> +            f->cpuid.reg != reg ||
>> +            (f->cpuid.needs_ecx && f->cpuid.ecx != index)) {
>> +            continue;
>> +        }
>> +
>> +        return w;
>> +    }
>> +
>> +    return w;
>> +}
>> +
>> +/*
>> + * TDX supported CPUID varies from what KVM reports. Adjust the 
>> result by
>> + * applying the TDX restrictions.
>> + */
>> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
>> +                             uint32_t *ret)
>> +{
>> +    /*
>> +     * it's KVMM + QEMU 's capabilities of what CPUID bits is 
>> supported or
>> +     * can be emulated as supported.
>> +     */
>> +    uint32_t vmm_cap = *ret;
>> +    FeatureWord w;
>> +
>> +    /* Only handle features leaves that recognized by 
>> feature_word_info[] */
>> +    w = get_cpuid_featureword_index(function, index, reg);
>> +    if (w == FEATURE_WORDS) {
>> +        return;
>> +    }
>> +
>> +    if (tdx_cpuid_lookup[w].inducing_ve) {
>> +        *ret &= tdx_cpuid_lookup[w].supported_value_on_ve;
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * Include all the native bits as first step. It covers types
>> +     * - As configured (if native)
>> +     * - Native
>> +     * - XFAM related and Attributes realted
> s/realted/related
>> +     *
>> +     * It also has side effect to enable unsupported bits, e.g., the
>> +     * bits of "fixed0" type while present natively. It's safe because
>> +     * the unsupported bits will be masked off by .fixed0 later.
>> +     */
>> +    *ret |= host_cpuid_reg(function, index, reg);
> 
> Looks KVM capabilities are merged with native bits, is this intentional?

yes, if we change the order, it would be more clear for you I guess.

	host_cpuid_reg() | kvm_capabilities

The base is host's native value, while any bit that absent from native 
but KVM can emulate is also added to base.

> Thanks
> 
> Zhenzhong
> 
>> +
>> +    /* Adjust according to "fixed" type in tdx_cpuid_lookup. */
>> +    *ret |= tdx_cpuid_lookup[w].tdx_fixed1;
>> +    *ret &= ~tdx_cpuid_lookup[w].tdx_fixed0;
>> +
>> +    /*
>> +     * Configurable cpuids are supported unconditionally. It's mainly to
>> +     * include those configurable regardless of native existence.
>> +     */
>> +    *ret |= tdx_cap_cpuid_config(function, index, reg);
>> +
>> +    /*
>> +     * clear the configurable bits that require VMM emulation and VMM 
>> doesn't
>> +     * report the support.
>> +     */
>> +    *ret &= ~(tdx_cpuid_lookup[w].depends_on_vmm_cap & ~vmm_cap);
>> +
>> +    /* special handling */
>> +    if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
>> +        *ret &= ~CPUID_EXT_MONITOR;
>> +    }
>> +}
>> +
>>   enum tdx_ioctl_level{
>>       TDX_VM_IOCTL,
>>       TDX_VCPU_IOCTL,
>> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
>> index d5b4c179fbf7..f62fe8ece982 100644
>> --- a/target/i386/kvm/tdx.h
>> +++ b/target/i386/kvm/tdx.h
>> @@ -26,4 +26,7 @@ bool is_tdx_vm(void);
>>   #define is_tdx_vm() 0
>>   #endif /* CONFIG_TDX */
>> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
>> +                             uint32_t *ret);
>> +
>>   #endif /* QEMU_I386_TDX_H */



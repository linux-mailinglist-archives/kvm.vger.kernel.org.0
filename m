Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055437BF234
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376324AbjJJFaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 01:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbjJJFaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 01:30:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0324FA4
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 22:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696915812; x=1728451812;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6VJFbVvrQpAOu5bD0WuuWxMpxBE0tMfgXqFvuxiE6O0=;
  b=OTVDmuuGvGYbnGRNIlGcmWCdC+6ViaofQF6Tb9nn6o0f3oKdRsjvL1O3
   xohHA6yHOxXTfcskm7rpdF+vXf46PlNze3dUNg3awDOln5uUHp7W3ubwl
   taeb241rwloYcIuR4rB36HiJIe5dNyORDIWBGIHAShb6q5txNTBWBCzSr
   pE++L2/gr6Mj4w+mLgbz8QTNjBwyN5WFGHOFxreOdenlOJXfB4IVHSZf9
   GeH1h1Y7grUU7DvVCq29OVGZpsc4xemTK0/+TwMOPLFt4sibeGAi01Wbt
   ZU9p74b9asldJAVLFFxg/f+WJ19/BRwH2tujelYQ1QOmpCR0KoZSAZ0qr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="470575751"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="470575751"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 22:30:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="746943652"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="746943652"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.19.128]) ([10.93.19.128])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 22:30:01 -0700
Message-ID: <7e8deb37-4521-090a-cc77-83ece4e3aa19@intel.com>
Date:   Tue, 10 Oct 2023 13:29:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH v2 08/58] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
Content-Language: en-US
To:     Tina Zhang <tina.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-9-xiaoyao.li@intel.com>
 <2175b694-c21f-464e-afee-b9ee9da154c1@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <2175b694-c21f-464e-afee-b9ee9da154c1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 9:02 AM, Tina Zhang wrote:
> Hi,
> 
> On 8/18/23 17:49, Xiaoyao Li wrote:
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
>>   - vmm_fixup:   The bits that are configurable from the view of TDX 
>> module.
>>                  But they requires emulation of VMM when they are 
>> configured
>>             as enabled. For those, they are not supported if VMM doesn't
>>         report them as supported. So they need be fixed up by
>>         checking if VMM supports them.
>>
>>   - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
>>                  totally configurable by VMM.
>>
>>   - supported_on_ve: It's valid only when @inducing_ve is true. It 
>> represents
>>             the maximum feature set supported that be emulated
>>             for TDs.
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
>> - filter the one has valid .supported field;
>>
>> (Calculated type is ignored since it's determined at runtime).
>>
>> Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.h     |  16 +++
>>   target/i386/kvm/kvm.c |   4 +
>>   target/i386/kvm/tdx.c | 254 ++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |   2 +
>>   4 files changed, 276 insertions(+)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index e0771a10433b..c93dcd274531 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -780,6 +780,8 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
>>   #define CPUID_7_0_EBX_FSGSBASE          (1U << 0)
>> +/* Support for TSC adjustment MSR 0x3B */
>> +#define CPUID_7_0_EBX_TSC_ADJUST        (1U << 1)
>>   /* Support SGX */
>>   #define CPUID_7_0_EBX_SGX               (1U << 2)
>>   /* 1st Group of Advanced Bit Manipulation Extensions */
>> @@ -798,8 +800,12 @@ uint64_t 
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
>> @@ -855,10 +861,16 @@ uint64_t 
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
>> @@ -869,6 +881,8 @@ uint64_t 
>> x86_cpu_get_supported_feature_word(FeatureWord w,
>>   #define CPUID_7_0_ECX_MOVDIRI           (1U << 27)
>>   /* Move 64 Bytes as Direct Store Instruction */
>>   #define CPUID_7_0_ECX_MOVDIR64B         (1U << 28)
>> +/* ENQCMD and ENQCMDS instructions */
>> +#define CPUID_7_0_ECX_ENQCMD            (1U << 29)
>>   /* Support SGX Launch Control */
>>   #define CPUID_7_0_ECX_SGX_LC            (1U << 30)
>>   /* Protection Keys for Supervisor-mode Pages */
>> @@ -886,6 +900,8 @@ uint64_t 
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
>> index ec5c07bffd38..46a455a1e331 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -539,6 +539,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState 
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
>> index 56cb826f6125..3198bc9fd5fb 100644
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
>> +     * but require VMM emulation if configured to enabled by VMM.
>> +     *
>> +     * For those bits, they cannot be enabled actually if VMM 
>> (KVM/QEMU) cannot
>> +     * virtualize them.
>> +     */
>> +    uint32_t vmm_fixup;
>> +
>> +    bool inducing_ve;
>> +    /*
>> +     * The maximum supported feature set for given inducing-#VE leaf.
>> +     * It's valid only when .inducing_ve is true.
>> +     */
>> +    uint32_t supported_on_ve;
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
>> +  * This table will be updated runtime by tdx_caps reported by platform.
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
>> +        .vmm_fixup =
>> +            CPUID_ACPI | CPUID_PBE,
> CPUID_HT might also be needed here, as it's disabled by QEMU when TD 
> guest only has a single processor core.

Add CPUID_HT here seems not correct fix. The root cause is that CPUID_HT 
is wrongly treated as auto_enabled bit, I will sent a fix separately.

> Regards,
> -Tina
> 


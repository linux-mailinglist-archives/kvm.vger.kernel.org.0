Return-Path: <kvm+bounces-11483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1214F877980
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6326FB20A9C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D1E3C2F;
	Mon, 11 Mar 2024 01:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jW88nMDb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42142564
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 01:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120335; cv=none; b=UUJXBQyT2ZeDiRCieV45KY7TtkUUoCfrbLOWM7u5CELKDRLzE0VRa6GECQQ/rZLixNy6GQtV9U2qScdC6kpYt4SWsi3yeMVUoKfsmgpfbPW3+/qW/RFEp1xTRDNr4npw5AOcn8aqcR0nANbv3VpInkiQWtpFHx0mFKe/O5gmIPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120335; c=relaxed/simple;
	bh=UI4+jOjW/j+UcxXlHjkBdfXTuf43EPm4F465D+caGhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rU1K0qm8SXWPhzsRlpb1ifItvC/aVII+mEiDEvvYx6+272bxVGXruTEQBXoTK/TUKj3jU1qf6449uAGeeGy/32zlgwCiY44Nla3CPyExr/Vd4yOt5bIXrOMtXq/39tCM3W6cbFeUJzHdsQS+4DxpfBrHXsD6vcuabO9mo6NvwGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jW88nMDb; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710120333; x=1741656333;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UI4+jOjW/j+UcxXlHjkBdfXTuf43EPm4F465D+caGhc=;
  b=jW88nMDbH3ElUnv6ZB+b+Dkw+b6247pPEynOecv4zKn1XXpnswRpjnaT
   zyPe+p2BB17y0yO6RbBJ8jxgZuw2OTc4Z4Qz09zoWoRei1ZPxi69P3FJo
   gtOAPKdMEFB6aj385MrBGmNIutAJ3rJyBu9j1NLu4Y2c4/rOls8eCMvyS
   lqsp7SV+ASzgFNbpUWcl3el15MOm70mjPfDuzY782nOKhGF7T32mLV+Cc
   FRH6qEOil/Jj7Y8fps8eiILlGZ2GgWnK+fZsp4hDNOVaib55vZVVGMi/x
   cpLMxPZoZjwXBnWb4NNonwonLI+4iu9+oC4okcDbwJZfx/SgQsR+rxlPH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4618104"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="4618104"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="10911448"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:25:26 -0700
Message-ID: <5f426c46-1a8b-426d-bd7f-aeee95cc5219@intel.com>
Date: Mon, 11 Mar 2024 09:25:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 30/65] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
 Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-31-xiaoyao.li@intel.com> <87edcv1x9j.fsf@pond.sub.org>
 <f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com>
 <871q8vxuzx.fsf@pond.sub.org>
 <4602df24-029e-4a40-bdec-1b0a6aa30a3c@intel.com>
 <87v85yv3j9.fsf@pond.sub.org>
 <0f3df4b7-ffb9-4fc5-90eb-8a1d6fea5786@intel.com>
 <87ttli87sw.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87ttli87sw.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/2024 9:56 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 3/7/2024 4:39 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> On 2/29/2024 9:25 PM, Markus Armbruster wrote:
>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>
>>>>>> On 2/29/2024 4:37 PM, Markus Armbruster wrote:
>>>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>>>
>>>>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>>
>>>>>>>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>>>>>>>> can be provided for TDX attestation. Detailed meaning of them can be
>>>>>>>> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com/
>>>>>>>>
>>>>>>>> Allow user to specify those values via property mrconfigid, mrowner and
>>>>>>>> mrownerconfig. They are all in base64 format.
>>>>>>>>
>>>>>>>> example
>>>>>>>> -object tdx-guest, \
>>>>>>>>       mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>>>>>>>       mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>>>>>>>       mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
>>>>>>>>
>>>>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> [...]
>>>>>
>>>>>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>>>>>> index 89ed89b9b46e..cac875349a3a 100644
>>>>>>>> --- a/qapi/qom.json
>>>>>>>> +++ b/qapi/qom.json
>>>>>>>> @@ -905,10 +905,25 @@
>>>>>>>>     #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>>>>>>>     #     be set, otherwise they refuse to boot.
>>>>>>>>     #
>>>>>>>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>>>>>>>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
>>>>>>>> +#     (A default value 0 of SHA384 is used when absent).
>>>>>>>
>>>>>>> Suggest to drop the parenthesis in the last sentence.
>>>>>>>
>>>>>>> @mrconfigid is a string, so the default value can't be 0.  Actually,
>>>>>>> it's not just any string, but a base64 encoded SHA384 digest, which
>>>>>>> means it must be exactly 96 hex digits.  So it can't be "0", either.  It
>>>>>>> could be
>>>>>>> "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000".
>>>>>>
>>>>>> I thought value 0 of SHA384 just means it.
>>>>>>
>>>>>> That's my fault and my poor english.
>>>>>
>>>>> "Fault" is too harsh :)  It's not as precise as I want our interface
>>>>> documentation to be.  We work together to get there.
>>>>>
>>>>>>> More on this below.
>>>>>>>
>>>>>>>> +#
>>>>>>>> +# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
>>>>>>>> +#     (A default value 0 of SHA384 is used when absent).
>>>>>>>> +#
>>>>>>>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>>>>>>>> +#     e.g., specific to the workload rather than the run-time or OS
>>>>>>>> +#     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>>>>>>>> +#     used when absent).
>>>>>>>> +#
>>>>>>>>     # Since: 9.0
>>>>>>>>     ##
>>>>>>>>     { 'struct': 'TdxGuestProperties',
>>>>>>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>>>>>>> +  'data': { '*sept-ve-disable': 'bool',
>>>>>>>> +            '*mrconfigid': 'str',
>>>>>>>> +            '*mrowner': 'str',
>>>>>>>> +            '*mrownerconfig': 'str' } }
>>>>>>>>     ##
>>>>>>>>     # @ThreadContextProperties:
>>>>>>>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>>>>>>>> index d0ad4f57b5d0..4ce2f1d082ce 100644
>>>>>>>> --- a/target/i386/kvm/tdx.c
>>>>>>>> +++ b/target/i386/kvm/tdx.c
>>>>>>>> @@ -13,6 +13,7 @@
>>>>>>>>     #include "qemu/osdep.h"
>>>>>>>>     #include "qemu/error-report.h"
>>>>>>>> +#include "qemu/base64.h"
>>>>>>>>     #include "qapi/error.h"
>>>>>>>>     #include "qom/object_interfaces.h"
>>>>>>>>     #include "standard-headers/asm-x86/kvm_para.h"
>>>>>>>> @@ -516,6 +517,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>>>>>         X86CPU *x86cpu = X86_CPU(cpu);
>>>>>>>>         CPUX86State *env = &x86cpu->env;
>>>>>>>>         g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>>>>>>>> +    size_t data_len;
>>>>>>>>         int r = 0;
>>>>>>>>         object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
>>>>>>>> @@ -528,6 +530,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>>>>>         init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>>>>>>>                             sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>>>>>>>> +#define SHA384_DIGEST_SIZE  48
>>>>>>>> +
>>>>>>>> +    if (tdx_guest->mrconfigid) {
>>>>>>>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
>>>>>>>> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);
>>>>>>>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>>>>>>>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
>>>>>>>> +            return -1;
>>>>>>>> +        }
>>>>>>>> +        memcpy(init_vm->mrconfigid, data, data_len);
>>>>>>>> +    }
>>>>>>>
>>>>>>> When @mrconfigid is absent, the property remains null, and this
>>>>>>> conditional is not executed.  init_vm->mrconfigid[], an array of 6
>>>>>>> __u64, remains all zero.  How does the kernel treat that?
>>>>>>
>>>>>> A all-zero SHA384 value is still a valid value, isn't it?
>>>>>>
>>>>>> KVM treats it with no difference.
>>>>>
>>>>> Can you point me to the spot in the kernel where mrconfigid is used?
>>>>
>>>> https://github.com/intel/tdx/blob/66a10e258636fa8ec9f5ce687607bf2196a92341/arch/x86/kvm/vmx/tdx.c#L2322
>>>>
>>>> KVM just copy what QEMU provides into its own data structure @td_params. The format @of td_params is defined by TDX spec, and @td_params needs to be passed to TDX module when initialize the context of TD via SEAMCALL(TDH.MNG.INIT): https://github.com/intel/tdx/blob/66a10e258636fa8ec9f5ce687607bf2196a92341/arch/x86/kvm/vmx/tdx.c#L2450
>>>>
>>>>
>>>> In fact, all the three SHA384 fields, will be hashed together with some other fields (in td_params and other content of TD) to compromise the initial measurement of TD.
>>>>
>>>> TDX module doesn't care the value of td_params->mrconfigid.
>>>
>>> My problem is that I don't understand when and why users would omit the
>>> optional @mrFOO.
>>
>> When users don't care it and don't have an explicit value for them, they can omit it. Then a default all-zero value is used.
>>
>> If making it mandatory field, then users have to explicit pass a all-zero value when they don't care it.
>>
>>> I naively expected absent @mrFOO to mean something like "no attestation
>>> of FOO".
>>>
>>> But I see that they default to
>>> "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000".
>>>
>>> If this zero value is special and means "no attestation", then we
>>> accidentally get no attestation when whatever is being hashed happens to
>>> hash to this zero value.  Unlikely, but possible.
>>>
>>> If it's not special, then when and why is the ability to omit it useful?
>>
>> At some point, the zero value is special, because it is the default value if no explicit one provided by user. But for TDX point of view, it is not special. The field is a must for any TD, and whatever value it is, it will be hashed into MRTD (Build-time Measurement Register) for later attestation.
>>
>> TDX architecture defines what fields are always hashed into measurement and also provide other mechanism to hash optional field into measurement. All this is known to users of TDX, and users can calculate the final measurement by itself and compare to what gets reported by TDX to see they are identical.
>>
>> For these three fields, they are must-to-have fields to be hashed into measurement. For user's convenience, we don't want to make it mandatory input because not everyone cares it and have a specific value to input.
>> What people needs to know is that, when no explicit value is provided for these three field, a all-zero value is used.
> 
> Alright, the doc comment is not the place to educate me about TDX.

I'm pleased to help you (on or off the maillist) if you have any 
question on TDX. :)

> Perhaps we can go with
> 
> # @mrconfigid: ID for non-owner-defined configuration of the guest TD,
> #     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
> #     Defaults to all zeroes.
> 

I will update to this in next version.
Huge thanks for your help!


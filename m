Return-Path: <kvm+bounces-10478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFFD86C74F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B1641C215BC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6117C7A709;
	Thu, 29 Feb 2024 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A/r+R0j7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E58579DD5
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203817; cv=none; b=gZ5OMjhV33t2MgF3NELV1Y/sBds6hsZdTrRti14EeigHgxLNgoqX9Be24MrNQDFK6x+vckXuMtegvMhsSQ2b/G11cZjbkjLRc4cNjrSL/Dd1fx5clnzVPsqwQdKqalenoWQa+0Vz09WqOUvrcLU1JxRKFlHBTp+sc0dTNWMUF88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203817; c=relaxed/simple;
	bh=0bdk25y4UaeHfC2ste3IgJd3Bj2McjQ5CPjRqLHeorI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mWVeeZRwgWZuhc4lHrSE1/+FA0c+Jg2J/Nqvkx9EhEfeA3U6sPs8qXDCbQXMcO93GCOy6xmUbs61xJLnHQ3yqMfyx7DtRUE8um+4JGrzpMh3GnYB4DNkevczRbOA6rD/c+PSzol3D2rlNicwELvvM097cwv/+FReAWp6Zd3feeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A/r+R0j7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709203816; x=1740739816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0bdk25y4UaeHfC2ste3IgJd3Bj2McjQ5CPjRqLHeorI=;
  b=A/r+R0j7JCzy9shNZ7W9wKXmA36/hz29S2nmbEiqJ0JfpoU2KvFekXzL
   hQrVcxsYOSBLmR7osdF9EbBDPRvSyttPn+I+8DoSNs26RdznQc7zgUwHl
   J+v1S2t7wyhcAXw/yz3bp41fIJg4Q1tK7SUEcSKR06LV4x/6UFfu7SBdg
   ZMBMi9r8goRmJOq+tBZT7DidCXyHnEH6EhpXnGYHXWC9cwrI+USr1dijU
   SnfR7MBHhKhwBK1qbTDZ2+SlUhyHLzfV+vPBgioHD5Jh0gBLh8qqpjozY
   o14YBspM2PfbFoRz9jz8qaKaUQpWbuCSxzQwRpkY7PQUNE+IZVutTBunD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="15079478"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="15079478"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 02:50:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7706722"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 02:50:08 -0800
Message-ID: <f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com>
Date: Thu, 29 Feb 2024 18:50:04 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87edcv1x9j.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/29/2024 4:37 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>> can be provided for TDX attestation. Detailed meaning of them can be
>> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com/
>>
>> Allow user to specify those values via property mrconfigid, mrowner and
>> mrownerconfig. They are all in base64 format.
>>
>> example
>> -object tdx-guest, \
>>    mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>    mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>    mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> ---
>> Changes in v5:
>>   - refine the description of QAPI properties and add description of
>>     default value when not specified;
>>
>> Changes in v4:
>>   - describe more of there fields in qom.json
>>   - free the old value before set new value to avoid memory leak in
>>     _setter(); (Daniel)
>>
>> Changes in v3:
>>   - use base64 encoding instread of hex-string;
>> ---
>>   qapi/qom.json         | 17 ++++++++-
>>   target/i386/kvm/tdx.c | 87 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |  3 ++
>>   3 files changed, 106 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 89ed89b9b46e..cac875349a3a 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -905,10 +905,25 @@
>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>   #     be set, otherwise they refuse to boot.
>>   #
>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
>> +#     (A default value 0 of SHA384 is used when absent).
> 
> Suggest to drop the parenthesis in the last sentence.
> 
> @mrconfigid is a string, so the default value can't be 0.  Actually,
> it's not just any string, but a base64 encoded SHA384 digest, which
> means it must be exactly 96 hex digits.  So it can't be "0", either.  It
> could be
> "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000".

I thought value 0 of SHA384 just means it.

That's my fault and my poor english.

> More on this below.
> 
>> +#
>> +# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
>> +#     (A default value 0 of SHA384 is used when absent).
>> +#
>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>> +#     e.g., specific to the workload rather than the run-time or OS
>> +#     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>> +#     used when absent).
>> +#
>>   # Since: 9.0
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>> -  'data': { '*sept-ve-disable': 'bool' } }
>> +  'data': { '*sept-ve-disable': 'bool',
>> +            '*mrconfigid': 'str',
>> +            '*mrowner': 'str',
>> +            '*mrownerconfig': 'str' } }
>>   
>>   ##
>>   # @ThreadContextProperties:
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index d0ad4f57b5d0..4ce2f1d082ce 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -13,6 +13,7 @@
>>   
>>   #include "qemu/osdep.h"
>>   #include "qemu/error-report.h"
>> +#include "qemu/base64.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>>   #include "standard-headers/asm-x86/kvm_para.h"
>> @@ -516,6 +517,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       X86CPU *x86cpu = X86_CPU(cpu);
>>       CPUX86State *env = &x86cpu->env;
>>       g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>> +    size_t data_len;
>>       int r = 0;
>>   
>>       object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
>> @@ -528,6 +530,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>                           sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>>   
>> +#define SHA384_DIGEST_SIZE  48
>> +
>> +    if (tdx_guest->mrconfigid) {
>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
>> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);
>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
>> +            return -1;
>> +        }
>> +        memcpy(init_vm->mrconfigid, data, data_len);
>> +    }
> 
> When @mrconfigid is absent, the property remains null, and this
> conditional is not executed.  init_vm->mrconfigid[], an array of 6
> __u64, remains all zero.  How does the kernel treat that?

A all-zero SHA384 value is still a valid value, isn't it?

KVM treats it with no difference.

>> +
>> +    if (tdx_guest->mrowner) {
>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrowner,
>> +                              strlen(tdx_guest->mrowner), &data_len, errp);
>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>> +            error_setg(errp, "TDX: failed to decode mrowner");
>> +            return -1;
>> +        }
>> +        memcpy(init_vm->mrowner, data, data_len);
>> +    }
>> +
>> +    if (tdx_guest->mrownerconfig) {
>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrownerconfig,
>> +                              strlen(tdx_guest->mrownerconfig), &data_len, errp);
>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>> +            error_setg(errp, "TDX: failed to decode mrownerconfig");
>> +            return -1;
>> +        }
>> +        memcpy(init_vm->mrownerconfig, data, data_len);
>> +    }
>> +
>>       r = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPUS, 0, ms->smp.cpus);
>>       if (r < 0) {
>>           error_setg(errp, "Unable to set MAX VCPUS to %d", ms->smp.cpus);
> 
> [...]
> 



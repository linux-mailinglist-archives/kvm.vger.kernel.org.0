Return-Path: <kvm+bounces-30732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 779729BCC38
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B1B21C21907
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDD81D47C8;
	Tue,  5 Nov 2024 11:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ciXZFrcG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034191D3593
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807696; cv=none; b=ITU7VNEQzPJLunT9n0jZK5gmIsEn/rEnO61PL7SdreuC1FWMmYmRLrijWXv26DiWG1oJQabUDBp15XOZg214tENusuI8nixaSliY1ku7CwaXRC3v8ek8db0NMxyWvEAx9LE7nWbHpaqCoynrqbO/D5B+yZQ2aPFCnpN4YNURRJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807696; c=relaxed/simple;
	bh=p9rsca4qedfgBzXyq8Qwc5Nr7Elmpj9SiXaFRufhkv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OkYVJA+QvrgSWgJMfljAO258u3WNpCrlF9YWna5gGvpaFd5+6SExdY7XiKv95AenhUJsYxheNq+MAmpJl+Vwe1awJcb5EAbZ77pjL3ZlTzc3b2m1l/wnJKi8OLVKr6Iv+ky20AZfgljoIYsiSrmL2559EDBjJ3zXR51UnaOU5cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ciXZFrcG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730807695; x=1762343695;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p9rsca4qedfgBzXyq8Qwc5Nr7Elmpj9SiXaFRufhkv8=;
  b=ciXZFrcGio5PV31Bs/D9EOFc/VNKbNUSGqxCw5l87hu/vwNzj7RftsBz
   Dp80Eya3AR0h6h2AbBePeK/9l6pJWanrDx3FrkR0cNZRctAiqbxUbckMR
   ypQJ39KuG1mX16G741KZdP7UfNtICtLq9zmLh02noG0KhYxqW+kvIEEwF
   2RemYG82thPXhChH4oCnRd7YuZfZY/lrjAGMi8MXCXJOStyymQzrCz5Y3
   qhtuwY7bk/qrQpkRuOibmf5wBEj96UagsxFE6U6xOoOXx40q/HlkBtxbT
   6qIHW3e2mSptB3i0KR4BvUUADDFivounGgREZMJUv5cN61cs8GI2SD1th
   w==;
X-CSE-ConnectionGUID: 8jz8x1XzQciWf7QtP8C2jw==
X-CSE-MsgGUID: glDsMj3QQkiUnK9yFkfscg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41180206"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="41180206"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:54:54 -0800
X-CSE-ConnectionGUID: C+RWG7b1SpC/hJE7wUEjCQ==
X-CSE-MsgGUID: Fpkk3Jl1SCqn1YbtkrmyBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84382439"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:54:45 -0800
Message-ID: <1722bb61-32e5-4da0-8390-14f8ca8ab328@intel.com>
Date: Tue, 5 Nov 2024 19:54:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/60] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-15-xiaoyao.li@intel.com>
 <Zyn1qW36aJeIGqbC@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zyn1qW36aJeIGqbC@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 6:38 PM, Daniel P. Berrangé wrote:
> On Tue, Nov 05, 2024 at 01:23:22AM -0500, Xiaoyao Li wrote:
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
>> ---
>> Changes in v6:
>>   - refine the doc comment of QAPI properties;
>>
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
>>   qapi/qom.json         | 16 +++++++-
>>   target/i386/kvm/tdx.c | 86 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |  3 ++
>>   3 files changed, 104 insertions(+), 1 deletion(-)
> 
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 5a9ce2ada89d..887a5324b439 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -13,6 +13,7 @@
>>   
>>   #include "qemu/osdep.h"
>>   #include "qemu/error-report.h"
>> +#include "qemu/base64.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>>   
>> @@ -222,6 +223,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       X86CPU *x86cpu = X86_CPU(cpu);
>>       CPUX86State *env = &x86cpu->env;
>>       g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>> +    size_t data_len;
>>       int r = 0;
>>   
>>       QEMU_LOCK_GUARD(&tdx_guest->lock);
>> @@ -232,6 +234,37 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>                           sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>>   
>> +#define SHA384_DIGEST_SIZE  48
> 
> Don't define this - as of fairly recently, we now have
> QCRYPTO_HASH_DIGEST_LEN_SHA384 in QEMU's "crypto/hash.h"
> header.

Thanks for the information!

Will update to use it.

>> +    if (tdx_guest->mrconfigid) {
>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
>> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);
>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
>> +            return -1;
>> +        }
>> +        memcpy(init_vm->mrconfigid, data, data_len);
>> +    }
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
>> +                            strlen(tdx_guest->mrownerconfig), &data_len, errp);
>> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
>> +            error_setg(errp, "TDX: failed to decode mrownerconfig");
>> +            return -1;
>> +        }
>> +        memcpy(init_vm->mrownerconfig, data, data_len);
>> +    }
>> +
>>       r = setup_td_guest_attributes(x86cpu, errp);
>>       if (r) {
>>           return r;
> 
> With regards,
> Daniel



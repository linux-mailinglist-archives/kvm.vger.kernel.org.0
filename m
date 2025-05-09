Return-Path: <kvm+bounces-46014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 060C6AB0A80
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EE91505DFB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA68026A1D5;
	Fri,  9 May 2025 06:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WvYZdDvG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74041D7E41
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746771690; cv=none; b=QCTDS1h8iO08Ay7zcEmlg6AKCjf5RdiIDsSWevxzAFh+WbdekUhKxrYLa9/HMv+EyXsNyC6x4ZftE1RyGtlLptsrRS3360UoyLyooNsQPp+zdlEpC9RexGMICHiJFxJiSafVUpFyXrZMHxLsXCXzWRFEA72VHev8LQwM8pDSmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746771690; c=relaxed/simple;
	bh=jRUZzy/hdvsaJ7n/Y9b2uRRC/3g/EzCJMvS+AN5xPOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vs+hQE0blqeNIhLGhr7wKQdgJtwoB38II+9wQMD9YziXCs+z2MSK7QxWDfGsSe6FX9niNjsFQNJrWGD5IIdt6CIvS09OUPhPlstLkQ7vn+sFtOEL7wA79CrG4sV4LCyIraSprqnq8YvBup9evNdohjrs7621SkcMl0vOX0aSavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WvYZdDvG; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746771689; x=1778307689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jRUZzy/hdvsaJ7n/Y9b2uRRC/3g/EzCJMvS+AN5xPOc=;
  b=WvYZdDvGYpXyZokMQEqTooOOXZguQzi4tSQg2VrNiV5lH2dTn2131Bc2
   dnW7asbTVXaMgygJdpulnP2A/oOW1eGatFfbb2fMAbIeAAW4H2Ktrcpwb
   xTZZIkdEjvHf+bWNooX0j5fCkE8kNiDMD4oEElNurAXSr08bB92nEI5go
   RMrFRmyERya2542YkBn5kWYe6MAvYS4cQ1PDcU2TUcGa6GNwN0uqM/xuw
   doodq9+B201WMgZmGMCAiFvmCMMllCZsQKfDZZnZVJNPv3I7sM0unclv8
   40KObn5EO60yAzzvt+KjJcRCxqHuOY9iHX7JjfVmFeTYyr80Y8Y9NhD8f
   A==;
X-CSE-ConnectionGUID: zXcw3TcdT1iKv/NildvzWQ==
X-CSE-MsgGUID: VRaI5d5JS6qT/Kz5nN8O7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59989672"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="59989672"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:21:28 -0700
X-CSE-ConnectionGUID: Ofn2lzZERguaK2Pli/8GGg==
X-CSE-MsgGUID: leDuIIUmThi90JuIFA4hVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141296842"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:21:24 -0700
Message-ID: <13e47cae-8519-4e08-9530-87a48201ed2e@intel.com>
Date: Fri, 9 May 2025 14:21:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/55] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Zhao Liu <zhao1.liu@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
 <20250508150002.689633-14-xiaoyao.li@intel.com> <aBzT3TrdldaN-uqx@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aBzT3TrdldaN-uqx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/8/2025 11:55 PM, Daniel P. Berrangé wrote:
> On Thu, May 08, 2025 at 10:59:19AM -0400, Xiaoyao Li wrote:
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
>> Acked-by: Markus Armbruster <armbru@redhat.com>
>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>> ---
>> Changes in v9:
>>   - return -1 directly when qbase64_decode() return NULL; (Daniel)
>>
>> Changes in v8:
>>   - it gets squashed into previous patch in v7. So split it out in v8;
>>
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
>>   target/i386/kvm/tdx.c | 95 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |  3 ++
>>   3 files changed, 113 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index f229bb07aaec..a8379bac1719 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -1060,11 +1060,25 @@
>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>   #     be set, otherwise they refuse to boot.
>>   #
>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
>> +#     Defaults to all zeros.
>> +#
>> +# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
>> +#     Defaults to all zeros.
>> +#
>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>> +#     e.g., specific to the workload rather than the run-time or OS
>> +#     (base64 encoded SHA384 digest).  Defaults to all zeros.
>> +#
>>   # Since: 10.1
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>>     'data': { '*attributes': 'uint64',
>> -            '*sept-ve-disable': 'bool' } }
>> +            '*sept-ve-disable': 'bool',
>> +            '*mrconfigid': 'str',
>> +            '*mrowner': 'str',
>> +            '*mrownerconfig': 'str' } }
>>   
>>   ##
>>   # @ThreadContextProperties:
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 3de3b5fa6a49..39fd964c6b27 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -11,8 +11,10 @@
>>   
>>   #include "qemu/osdep.h"
>>   #include "qemu/error-report.h"
>> +#include "qemu/base64.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>> +#include "crypto/hash.h"
>>   
>>   #include "hw/i386/x86.h"
>>   #include "kvm_i386.h"
>> @@ -240,6 +242,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       CPUX86State *env = &x86cpu->env;
>>       g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>>       Error *local_err = NULL;
>> +    size_t data_len;
>>       int retry = 10000;
>>       int r = 0;
>>   
>> @@ -251,6 +254,45 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>                           sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>>   
>> +    if (tdx_guest->mrconfigid) {
>> +        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
>> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);
>> +        if (!data) {
>> +            return -1;
>> +        }
>> +        if (data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
> 
> As a general guideline I'd always suggest including both the received
> and expected values, when reporting an length check failure. Also
> the error message is misleading - we successfully decoded the data,
> the decoded data was simply the wrong length.
> 
> eg
> 
>              error_setg(errp, "TDX mrconfigid sha386 digest was %d bytes, expected %d bytes")

s/sha386/sha384

> 	               data_len, QCRYPTO_HASH_DIGEST_LEN_SHA384);

good advice!

(If it needs another version, I will fix it. If this version is going to 
be picked by Paolo, I will leave it to Paolo to fix.)

> 
> With regards,
> Daniel



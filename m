Return-Path: <kvm+bounces-30730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EEA9BCC34
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFF381C21991
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D8B1D47D2;
	Tue,  5 Nov 2024 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A40Ai0JL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449331D3593
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807648; cv=none; b=BAHtSQJv1TIjJQTqnhOynamcjRUGCYpFsrzhuKyEEQfF+f5KXW5x1TeFS+NEXtQStA1GYqf173eB5eIgpMPKn/6RbC4Gn/OKxdlXATy3bFFrdJzTPhS6Bz2z+N9XKL51Q0YLY2EAl6ZkGFPG69OwZdFHB8ZRG1kh2JNMd4+j5rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807648; c=relaxed/simple;
	bh=MU3Vwso6KH01jEsxvdnAJcmSqvWyHee3ON+2Ro2iZ6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rd64JPYOS4LnpTioSTPMKAGriTCNM6a62a83ScXBHpzTNa1XNwnWQyI4bntS0czNMm14E/q56nrytwjo/0iTvC2+Pjlx7Bm1rXma4uWTCUjg9w83P4q6u7e7Nym3LqP3osMbV1fzeHLWkZBXgf169xCvOxuw+1pLutFm57T6eUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A40Ai0JL; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730807646; x=1762343646;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MU3Vwso6KH01jEsxvdnAJcmSqvWyHee3ON+2Ro2iZ6o=;
  b=A40Ai0JLJ2HoFVaUFb9r49qRFYlHpUX0zzSYXx2N7mayniOS09reRfU2
   xv/T5TDNvzhuxpY+YVQrBicp+BcaSL/6/yYNemQ1RpbvQJkF4HBEnOsUj
   4zxBKRp8cMcYbRwtu98M3p+wMQtZsJa2DWw6rf3k9xs2RN6g1T/BanZE4
   +fWWZrFtiND/ipNA8ngRFDnQEOhEVpKwkUpJCGR8XknGF0bNSlXNl+vfz
   uPTT0kXfSLkkmAuKXRDz85FqTgpH3dQ8kt5baTarUr17awcvOFCGj8RF/
   Wm7J+J6dwa0BlHsovbJSDRuhh4BX4yf3cH7t3THub6hDZVC/V/i5DDtKw
   w==;
X-CSE-ConnectionGUID: 5eqtsUuySiqiTBw9xAZ+Cg==
X-CSE-MsgGUID: wdIwEf/UQhauLMBd+iOfyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41180108"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="41180108"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:54:05 -0800
X-CSE-ConnectionGUID: y9/TKhocS/aOJ8358YkO7g==
X-CSE-MsgGUID: hQkuky62TOeYbX1TYZTmBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84382331"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:54:01 -0800
Message-ID: <7fbf9071-493a-4929-afaa-d0a669346f17@intel.com>
Date: Tue, 5 Nov 2024 19:53:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/60] i386/tdx: Validate TD attributes
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
 <20241105062408.3533704-14-xiaoyao.li@intel.com>
 <Zyn1Jhxr8ip0lIcs@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zyn1Jhxr8ip0lIcs@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 6:36 PM, Daniel P. Berrangé wrote:
> On Tue, Nov 05, 2024 at 01:23:21AM -0500, Xiaoyao Li wrote:
>> Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
>> fixed-1 bits must be set.
>>
>> Besides, sanity check the attribute bits that have not been supported by
>> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
>> TD support lands in QEMU.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>>
>> ---
>> Changes in v3:
>> - using error_setg() for error report; (Daniel)
>> ---
>>   target/i386/kvm/tdx.c | 28 ++++++++++++++++++++++++++--
>>   1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 6cf81f788fe0..5a9ce2ada89d 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -20,6 +20,7 @@
>>   #include "kvm_i386.h"
>>   #include "tdx.h"
>>   
>> +#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
>>   #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
>>   #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
>>   #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
>> @@ -141,13 +142,33 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
>>       return KVM_X86_TDX_VM;
>>   }
>>   
>> -static void setup_td_guest_attributes(X86CPU *x86cpu)
>> +static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>> +{
>> +    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
>> +            error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
>> +                       "(supported: 0x%llx)",
>> +                       tdx->attributes, tdx_caps->supported_attrs);
>> +            return -1;
> 
> Minor whitespace accident, with indentation too deep.

Good catch!

btw, how did you catch it? any tool like checkpatch.pl or just by your eyes?

>> +    }
>> +
>> +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
>> +        error_setg(errp, "Current QEMU doesn't support attributes.debug[bit 0] "
>> +                         "for TDX VM");
>> +        return -1;
>> +    }
>> +
>> +    return 0;
>> +}
> 
> With regards,
> Daniel



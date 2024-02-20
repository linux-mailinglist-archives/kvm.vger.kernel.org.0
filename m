Return-Path: <kvm+bounces-9201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBB285BF85
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57DE3B223BB
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B6576020;
	Tue, 20 Feb 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eqrFzoWg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CF71B4A
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441843; cv=none; b=DW6EOYgTNWNtN+Py9Q0e42QjxKltbDhwYTLG+p8mj3hf7FsYSa1pP311T1SAcJRVy83JTJe3syHwxAlwBspNF5hHxXjmaYyQAUojmbInNVDnIwZFSmK6HullKet8QcI9Ig8ZRb/sdvWMUd1wxw4BSR0RS3BKKZLmmA10+vy2UUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441843; c=relaxed/simple;
	bh=MNul5Z8YS8ETylWhyngw23B0/F5Ht+fLakLw7oSXUeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE1PRacUcyju8pdrXm4yIELqCAeRR0bQ/rWBh1Qwuia4q/extzWllbD9FVt32SSgaKPdMESrl9Gp53Q5AH74WkNSJ9dZebLI5dsf/H05I/30k4FaoC1c8GwexDjFDNvrhXKtBpLioZh3TdJyT5m7yPmZTZjAR3d97mAsc+SL77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eqrFzoWg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708441842; x=1739977842;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MNul5Z8YS8ETylWhyngw23B0/F5Ht+fLakLw7oSXUeU=;
  b=eqrFzoWg0ipitX6cK0nLdnN4IMHl7i0dpudU51IfUo2hwwyU+koS0woa
   DGN9OQnCWiacSruHD1so8FM6NuR1C4KWosOjbAIvZwHJ3nkO1o8kai287
   nRTByNx+td3+28o4pu3NdGdnrRD8gbdpRAfhBLy6be1gF+EUHw2yCZTyz
   No6gwZuuEMNO1mk3lQpO9v5X9sq+IsJS3FbcLvhcWQ40tmhCTfJFAGUm7
   AueVln/xqUNCB48YMc/yWAvcdOkQn4PSh+4chK3Z69TncOIQL0ScH5S3R
   w9fLX8HwqN51Aw5xshn5MB/NvuY/iLQYjnmz3jqpJ5UYu7pMiEmoWfFOC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="13960861"
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="13960861"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 07:10:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="4845066"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 07:10:33 -0800
Message-ID: <cf9e91ea-825a-444c-9625-a571fdc3265a@intel.com>
Date: Tue, 20 Feb 2024 23:10:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 29/66] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2EBerrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-30-xiaoyao.li@intel.com>
 <875xykfwmf.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <875xykfwmf.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2024 8:48 PM, Markus Armbruster wrote:
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
>> Changes in v4:
>>   - describe more of there fields in qom.json
>>   - free the old value before set new value to avoid memory leak in
>>     _setter(); (Daniel)
>>
>> Changes in v3:
>>   - use base64 encoding instread of hex-string;
>> ---
>>   qapi/qom.json         | 14 ++++++-
>>   target/i386/kvm/tdx.c | 87 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |  3 ++
>>   3 files changed, 103 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 2177f3101382..15445f9e41fc 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -905,10 +905,22 @@
>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>   #     be set, otherwise they refuse to boot.
>>   #
>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>> +#     e.g., run-time or OS configuration.  base64 encoded SHA384 digest.
> 
> "base64 encoded SHA384" is not a sentence.
> 
> Double-checking: the data being hashed here is the "non-owner-defined
> configuration of the guest TD", and the resulting hash is the "ID"?

yes. The "ID" here means the resulting hash.

The reason to use "ID" here because in the TDX spec, it's description is

   Software-defined ID for non-owner-defined configuration of the guest
   TD - e.g., run-time or OS configuration.

If ID is confusing, how about

   SHA384 hash of non-owner-defined configuration of the guest TD, e.g.,
   run-time of OS configuration.  It's base64 encoded.

>> +#
>> +# @mrowner: ID for the guest TD’s owner.  base64 encoded SHA384 digest.
> 
> Likewise.
> 
>> +#
>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>> +#     e.g., specific to the workload rather than the run-time or OS.
>> +#     base64 encoded SHA384 digest.
> 
> Likewise.
> 
>> +#
>>   # Since: 9.0
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>> -  'data': { '*sept-ve-disable': 'bool' } }
>> +  'data': { '*sept-ve-disable': 'bool',
>> +            '*mrconfigid': 'str',
>> +            '*mrowner': 'str',
>> +            '*mrownerconfig': 'str' } }
> 
> The new members are optional, but their description in the doc comment
> doesn't explain behavior when present vs. behavior when absent.
> 
>>   
>>   ##
>>   # @ThreadContextProperties:
> 
> [...]
> 
> 



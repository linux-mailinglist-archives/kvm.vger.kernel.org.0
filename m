Return-Path: <kvm+bounces-10042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D999C868CAD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0953C1C2109B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB05A137C3F;
	Tue, 27 Feb 2024 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2WS0+7n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A263613698B
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709027478; cv=none; b=Nk40MdWagsebgSGg+m4hKVaMh+U5Mn7GYFq6A8ZbpRsLEt0NG4wrRByPETU5r7HZDZNpErksgvd+KJ91G/7Kugrs0zzJ94/PuWY+S6llZLnbTrMoClBaKFWXKiX/wk0HD2w+TWQt6tSbGPIg+lcqlfuJzHX2cIIOw2FFI7EpTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709027478; c=relaxed/simple;
	bh=zqNzZxK5kJTKvJ+QklHiadEBpHT0kyIhtbdJ39re5U4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmETLXN/073DR9/+6ciK+DX966ZZ29QeD8VZ/uTa4ApiQoSi0q7ijyK3vWbJvjuyYHa1imQ9ogH4junguzXnXZPrVD/HBApybKq2849PxvgOJ4ZUWg21V1jyGU1V9n9u0jD8Rfj+qYeCCSk3pfFMin7qy29A5khfhT2az6cL9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2WS0+7n; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709027476; x=1740563476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zqNzZxK5kJTKvJ+QklHiadEBpHT0kyIhtbdJ39re5U4=;
  b=f2WS0+7nT0lKC5LxZIN5+uIeJcCt88oyK5i5/rbc2mk8Rs7fGK9VCjEH
   QoyBmsgT6DmmKmFzG0ShYxNOKFVgd/FZQBWOMKXn7K9WsW58lNrCzKigN
   p7wf9aXVy2H1vyRwIGMWMW/mSCTR14xXNLT5FpO33jk/Ts+kXZfxiwqSI
   63qVZNt8Bf0lmjycAGmR12QLvKoADP4Kqa9GuejO0i3NZo734lX/kIWgp
   X4KP35CWQHkGaMlIYwAjn6/kWMlF0JgwjNL3JrLD7B1YIX4uhTgjjcUgD
   OYdJf3cUwziUaKT8v7zUsSLlVY23n/J18O2EkSzJfOj/CRYrgL+21l7mW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3218523"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="3218523"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 01:51:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="7192358"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 01:51:07 -0800
Message-ID: <1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com>
Date: Tue, 27 Feb 2024 17:51:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 53/66] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
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
 <20240125032328.2522472-54-xiaoyao.li@intel.com>
 <87v86kehts.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87v86kehts.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/2024 8:53 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>
>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v4:
>> - refine the documentation; (Markus)
>>
>> Changes in v3:
>> - Add docmentation of new type and struct; (Daniel)
>> - refine the error message handling; (Daniel)
>> ---
>>   qapi/run-state.json   | 28 ++++++++++++++++++++--
>>   system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
>>   3 files changed, 103 insertions(+), 3 deletions(-)
>>
>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>> index 08bc99cb8561..5429116679e3 100644
>> --- a/qapi/run-state.json
>> +++ b/qapi/run-state.json
>> @@ -485,10 +485,12 @@
>>   #
>>   # @s390: s390 guest panic information type (Since: 2.12)
>>   #
>> +# @tdx: tdx guest panic information type (Since: 8.2)
>> +#
>>   # Since: 2.9
>>   ##
>>   { 'enum': 'GuestPanicInformationType',
>> -  'data': [ 'hyper-v', 's390' ] }
>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>   
>>   ##
>>   # @GuestPanicInformation:
>> @@ -503,7 +505,8 @@
>>    'base': {'type': 'GuestPanicInformationType'},
>>    'discriminator': 'type',
>>    'data': {'hyper-v': 'GuestPanicInformationHyperV',
>> -          's390': 'GuestPanicInformationS390'}}
>> +          's390': 'GuestPanicInformationS390',
>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>   
>>   ##
>>   # @GuestPanicInformationHyperV:
>> @@ -566,6 +569,27 @@
>>             'psw-addr': 'uint64',
>>             'reason': 'S390CrashReason'}}
>>   
>> +##
>> +# @GuestPanicInformationTdx:
>> +#
>> +# TDX Guest panic information specific to TDX GCHI
>> +# TDG.VP.VMCALL<ReportFatalError>.
>> +#
>> +# @error-code: TD-specific error code
> 
> Where could a user find information on these error codes?

TDX GHCI (Guset-host-communication-Interface)spec. It defines all the 
TDVMCALL leaves.

0: panic;
0x1 - 0xffffffff: reserved.

>> +#
>> +# @gpa: guest-physical address of a page that contains additional
>> +#     error data, in forms of zero-terminated string.
> 
> "in the form of a zero-terminated string"

fixed.

>> +#
>> +# @message: Human-readable error message provided by the guest. Not
>> +#     to be trusted.
> 
> How is this message related to the one pointed to by @gpa?

In general, @message contains a brief message of the error. While @gpa 
(when valid) contains a verbose message.

The reason why we need both is because sometime when TD guest hits a 
fatal error, its memory may get corrupted so we cannot pass information 
via @gpa. Information in @message is passed through GPRs.

>> +#
>> +# Since: 9.0
>> +##
>> +{'struct': 'GuestPanicInformationTdx',
>> + 'data': {'error-code': 'uint64',
>> +          'gpa': 'uint64',
>> +          'message': 'str'}}
>> +
>>   ##
>>   # @MEMORY_FAILURE:
>>   #
> 
> [...]
> 



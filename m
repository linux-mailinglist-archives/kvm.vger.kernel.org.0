Return-Path: <kvm+bounces-10092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39660869915
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D39D328A2A4
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 14:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8507913EFE9;
	Tue, 27 Feb 2024 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QRToe8NB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B03D68
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045544; cv=none; b=d3r/kDvLr4KOlOb6Nm+qHXLVn79YUeJ+PQq2slFv68Chywp8VmdwgAyx06frpWpcwGbYyCHsxwXkN4XRGROlYy2eyY2iGnq8zHUxFCvIm/8bkDT7asofGtzkNH18jm379APmWX4V7DAJ8uWKjDAOqph64YTQJ0NzRBTXsdBFVHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045544; c=relaxed/simple;
	bh=1rvpg/DOCX8xcMRmnNM0vPbj4EnqPAf7a5IKP2FI66c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhRxU9Hxr2rl7Yo/UN+iEOtfBAtcqEiq0xKHRJ5RIrCm6NumxjLVl3/rT73maM65Be3+JJrjCmzDd7hNs1RGgxYah4638LRsFedY2xM2PIfYIYziRsznt52U8TTeMombN273DnAIHz6N2imbThh3RJIJXoWpCJd7iqpuCz3tn8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QRToe8NB; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709045542; x=1740581542;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1rvpg/DOCX8xcMRmnNM0vPbj4EnqPAf7a5IKP2FI66c=;
  b=QRToe8NBZgkiOnpY6PKE6oFbcOlJqpuqU1ZHgxYGnc10u7Q0PVdCk6ea
   14WDt+0iiCXYSKfKV4K8CkP2WIYrJbI2h7Qu0O2c4SmUEP9LvQWbkG0Z8
   5CnKBqLJL3RMiXJHN2nq3uwIADdeZOKeOZ+t8COd/SC1EXsfhajjYUV+0
   Ik+yyrnqgMflLtgKNn9G7cOiV+UyVs+M7QSzoUqbUy6mlC5/QFaApAiL4
   PL5rLYVpC4KrrPEHPxmc+V/IDL9hVYs8jEsru7dDHW4qGgnlGLFOnheGC
   2aUv7zmWkmnKYxq3pxuNBbLaALkatgiE/M2IuT7UvuljiUVvfgEt+UzI1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3547404"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="3547404"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:52:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="44576278"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:52:03 -0800
Message-ID: <7ef9d3c0-2bab-4edc-a5dc-156d17a467ed@intel.com>
Date: Tue, 27 Feb 2024 22:51:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 53/66] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
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
 <20240125032328.2522472-54-xiaoyao.li@intel.com>
 <87v86kehts.fsf@pond.sub.org>
 <1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com>
 <87le76dt1g.fsf@pond.sub.org>
 <09c5fd9b-be96-45b6-b48e-772d5b5aad16@intel.com>
 <87wmqqawa2.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87wmqqawa2.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 9:09 PM, Markus Armbruster wrote:
[...]
>>>>>> @@ -566,6 +569,27 @@
>>>>>>               'psw-addr': 'uint64',
>>>>>>               'reason': 'S390CrashReason'}}
>>>>>>     
>>>>>> +##
>>>>>> +# @GuestPanicInformationTdx:
>>>>>> +#
>>>>>> +# TDX Guest panic information specific to TDX GCHI
>>>>>> +# TDG.VP.VMCALL<ReportFatalError>.
>>>>>> +#
>>>>>> +# @error-code: TD-specific error code
>>>>>
>>>>> Where could a user find information on these error codes?
>>>>
>>>> TDX GHCI (Guset-host-communication-Interface)spec. It defines all the
>>>> TDVMCALL leaves.
>>>>
>>>> 0: panic;
>>>> 0x1 - 0xffffffff: reserved.
>>>
>>> Would it make sense to add a reference?
>>
>> https://cdrdv2.intel.com/v1/dl/getContent/726792
> 
> URLs have this annoying tendency to rot.
> 
> What about
> 
> # @error-code: Error code as defined in "Guest-Hypervisor Communication
> #     Interface (GHCI) Specification for Intel TDX 1.5"

I think it gets mentioned at the beginning of @GuestPanicInformationTdx

   TDX Guest panic information specific to TDX GHCI
   TDG.VP.VMCALL<ReportFatalError>.

Do we still to mention it in every single member?

>>>>>> +#
>>>>>> +# @gpa: guest-physical address of a page that contains additional
>>>>>> +#     error data, in forms of zero-terminated string.
>>>>>
>>>>> "in the form of a zero-terminated string"
>>>>
>>>> fixed.
>>>>
>>>>>> +#
>>>>>> +# @message: Human-readable error message provided by the guest. Not
>>>>>> +#     to be trusted.
>>>>>
>>>>> How is this message related to the one pointed to by @gpa?
>>>>
>>>> In general, @message contains a brief message of the error. While @gpa
>>>> (when valid) contains a verbose message.
>>>>
>>>> The reason why we need both is because sometime when TD guest hits a
>>>> fatal error, its memory may get corrupted so we cannot pass information
>>>> via @gpa. Information in @message is passed through GPRs.
>>>
>>> Well, we do pass information via @gpa, always.  I guess it page's
>>> contents can be corrupted.
>>
>> No. It's not always. the bit 63 of the error code is "GPA valid" bit.
>> @gpa is valid only when bit 63 of error code is 1.
>>
>> And current Linux TD guest implementation doesn't use @gpa at all.
>> https://github.com/torvalds/linux/blob/45ec2f5f6ed3ec3a79ba1329ad585497cdcbe663/arch/x86/coco/tdx/tdx.c#L131
> 
> Aha!
> 
> Why would we want to include @gpa when the "GPA valid" bit is off?
> 
> If we do want it, then
> 
> # @gpa: guest-physical address of a page that contains more verbose
> #     error information, as zero-terminated string.  Valid when the
> #     "GPA valid" bit is set in @error-code.
> 
> If we don't, then make @gpa optional, present when valid, and document
> it like this:
> 
> # @gpa: guest-physical address of a page that contains more verbose
> #     error information, as zero-terminated string.  Present when the
> #     "GPA valid" bit is set in @error-code.

I will go this direction.

thanks!

>>> Perhaps something like
>>>
>>>       # @message: Human-readable error message provided by the guest.  Not
>>>       #     to be trusted.
>>>       #
>>>       # @gpa: guest-physical address of a page that contains more verbose
>>>       #     error information, as zero-terminated string.  Note that guest
>>>       #     memory corruption can corrupt the page's contents.
>>>
>>>>>> +#
>>>>>> +# Since: 9.0
>>>>>> +##
>>>>>> +{'struct': 'GuestPanicInformationTdx',
>>>>>> + 'data': {'error-code': 'uint64',
>>>>>> +          'gpa': 'uint64',
>>>>>> +          'message': 'str'}}
>>>
>>> Note that my proposed doc string has the members in a different order.
>>> Recommend to use the same order here.
>>>
>>>>>> +
>>>>>>     ##
>>>>>>     # @MEMORY_FAILURE:
>>>>>>     #
>>>>>
>>>>> [...]
>>>>>
>>>
> 
> 



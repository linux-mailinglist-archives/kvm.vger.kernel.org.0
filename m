Return-Path: <kvm+bounces-11644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EDA878F0C
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 08:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D4331F225B0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391466995C;
	Tue, 12 Mar 2024 07:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6Bgubu1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15232C84
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 07:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710228434; cv=none; b=aYud35jgJYyJbn7WLVHzY3FyWfB9TAfvo7GjrP9A25Z7IkTNP+uOF8kG1Knt0uDI8KMpBavUsul/VmzS6HAKzbiAlyXH1nPaHKtWXFgLYqU5ma/8Tb5TdhAGUCw2LReHZJhCo8mO3Ozzc4SQwL0GSwR+e78I6CJoNurhItHJPYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710228434; c=relaxed/simple;
	bh=wq55gM97pyRdirQ5fxyXXyXEC+jco3c3Ytc8YdM0KwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiTyXfkkgAftwNIN+CsOuLxYxoQkuL4RCmv2SeDzuZ9CKNbcBM2tKw46tMG9JtDo45VRS/Svmby8jw8ps4YR+S0SR+pP3Xk9YD0UIMdFX2tmdPEBhKS8xo/8ZllnoxCrWy8HxRR5vCU8WhdtPhDqw56wWX4cRGmLjRjOQpqO0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6Bgubu1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710228433; x=1741764433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wq55gM97pyRdirQ5fxyXXyXEC+jco3c3Ytc8YdM0KwA=;
  b=j6Bgubu17KOHCKdM8XAbiLFfIMU045nnlO05c0qNV3X2NRa6wBk++4eh
   D2mKGxQYI5R07qOcfL9iVUrBKnfT7NfvrBf9BvryIA0IC3pBqoWT9K/Ay
   u4LCKdCbsBE+UT3PlYLOa+tby/T4BLtkacdDqypVyBAHFMjUlbIkIdwbh
   jwqOGywLU/rg96e3zFDAyq0/hmaZGSz5Cvtj63IRxR3zq1uEFshFQA4CU
   blogfDq0NtEVE6r6BphivDHwWQjdfEGS64QHApGWalSoz2yNwlz9DtUf6
   7HWKbVwlEMCt9Z2JU2yPKRlLvZeA2dkN8+4/GVxT0AjwIH3puXcRdMbsu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="16362948"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16362948"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 00:27:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="34622364"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 00:27:04 -0700
Message-ID: <73f7b57c-32b7-4ea5-bcb2-b6eecf52e08b@intel.com>
Date: Tue, 12 Mar 2024 15:27:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 52/65] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
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
 <20240229063726.610065-53-xiaoyao.li@intel.com> <874jdr1wmt.fsf@pond.sub.org>
 <d5cb6e5e-0bc1-40bd-8fc1-50a03f42e9cf@intel.com>
 <87y1au881k.fsf@pond.sub.org>
 <95e623e1-ccf3-4d8f-9751-7767db100e2b@intel.com>
 <87plw1uszk.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87plw1uszk.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/11/2024 3:29 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 3/7/2024 9:51 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> On 2/29/2024 4:51 PM, Markus Armbruster wrote:
>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>
>>>>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>>>>
>>>>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>> ---
>>>>>> Changes in v5:
>>>>>> - mention additional error information in gpa when it presents;
>>>>>> - refine the documentation; (Markus)
>>>>>>
>>>>>> Changes in v4:
>>>>>> - refine the documentation; (Markus)
>>>>>>
>>>>>> Changes in v3:
>>>>>> - Add docmentation of new type and struct; (Daniel)
>>>>>> - refine the error message handling; (Daniel)
>>>>>> ---
>>>>>>     qapi/run-state.json   | 31 +++++++++++++++++++++--
>>>>>>     system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
>>>>>>     target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>>>>>>     3 files changed, 110 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>>>>> index dd0770b379e5..b71dd1884eb6 100644
>>>>>> --- a/qapi/run-state.json
>>>>>> +++ b/qapi/run-state.json
> 
> [...]
> 
>>>>>> @@ -564,6 +567,30 @@
>>>>>>               'psw-addr': 'uint64',
>>>>>>               'reason': 'S390CrashReason'}}
>>>>>> +##
>>>>>> +# @GuestPanicInformationTdx:
>>>>>> +#
>>>>>> +# TDX Guest panic information specific to TDX, as specified in the
>>>>>> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
>>>>>> +# section TDG.VP.VMCALL<ReportFatalError>.
>>>>>> +#
>>>>>> +# @error-code: TD-specific error code
>>>>>> +#
>>>>>> +# @message: Human-readable error message provided by the guest. Not
>>>>>> +#     to be trusted.
>>>>>> +#
>>>>>> +# @gpa: guest-physical address of a page that contains more verbose
>>>>>> +#     error information, as zero-terminated string.  Present when the
>>>>>> +#     "GPA valid" bit (bit 63) is set in @error-code.
>>>>>
>>>>> Uh, peeking at GHCI Spec section 3.4 TDG.VP.VMCALL<ReportFatalError>, I
>>>>> see operand R12 consists of
>>>>>
>>>>>        bits    name                        description
>>>>>        31:0    TD-specific error code      TD-specific error code
>>>>>                                            Panic – 0x0.
>>>>>                                            Values – 0x1 to 0xFFFFFFFF
>>>>>                                            reserved.
>>>>>        62:32   TD-specific extended        TD-specific extended error code.
>>>>>                error code                  TD software defined.
>>>>>        63      GPA Valid                   Set if the TD specified additional
>>>>>                                            information in the GPA parameter
>>>>>                                            (R13).
>>>>> Is @error-code all of R12, or just bits 31:0?
>>>>> If it's all of R12, description of @error-code as "TD-specific error
>>>>> code" is misleading.
>>>>
>>>> We pass all of R12 to @error_code.
>>>>
>>>> Here it wants to use "error_code" as generic as the whole R12. Do you have any better description of it ?
>>>
>>> Sadly, the spec is of no help: it doesn't name the entire thing, only
>>> the three sub-fields TD-specific error code, TD-specific extended error
>>> code, GPA valid.
>>>
>>> We could take the hint, and provide the sub-fields instead:
>>>
>>> * @error-code contains the TD-specific error code (bits 31:0)
>>>
>>> * @extended-error-code contains the TD-specific extended error code
>>>     (bits 62:32)
>>>
>>> * we don't need @gpa-valid, because it's the same as "@gpa is present"
>>>
>>> If we decide to keep the single member, we do need another name for it.
>>> @error-codes (plural) doesn't exactly feel wonderful, but it gives at
>>> least a subtle hint that it's not just *the* error code.
>>
>> The reason we only defined one single member, is that the
>> extended-error-code is not used now, and I believe it won't be used in
>> the near future.
> 
> Aha!  Then I recommend
> 
> * @error-code contains the TD-specific error code (bits 31:0)
> 
> * Omit bits 62:32 from the reply; if we later find an actual use for
>    them, we can add a suitable member
> 
> * Omit bit 63, because it's the same as "@gpa is present"
> 
>> If no objection from others, I will use @error-codes (plural) in the
>> next version.
> 
> I recommend to keep the @error-code name, but narrow its value to the
> actual error code, i.e. bits 31:0.

It works for me. I will got this direction in the next version.

>>>>> If it's just bits 31:0, then 'Present when the "GPA valid" bit (bit 63)
>>>>> is set in @error-code' is wrong.  Could go with 'Only present when the
>>>>> guest provides this information'.
> 
> [...]
> 



Return-Path: <kvm+bounces-10079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 254EA868FDE
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DD661F2BF9A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D887E13AA20;
	Tue, 27 Feb 2024 12:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQFFDSfA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD513A24B
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709035792; cv=none; b=pltvdcGUFBFX8aJjXfy4Y1SwfI8IzFgx2dMZ/966NGwfox1V+zurDuWOm3h8fU/2J80F8jRPRLKn0zrkVjNWAPIcCCDxfY34niL2BC90BMJ2RFNL4uMdCismATtV2aWfQvEFmSXuvECB1eyqchPH/wf8eAilRXEF7BhwxoGUwX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709035792; c=relaxed/simple;
	bh=LcBc2xeaJTxXGy7RWmHyOmRx6954AwBxc525s+oHjKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HX+YAjmTnuWkXKl5RMZ+CGuPmWElI+bOuTx2ISBRqBtsz/miG+F1XK0zA5qinQsYGYWBx+A/QD9pjp5PDTJx8aT1wZbwEhdvlf6EWzMY3J/clFbRnqjl98xENJFTwS0Z3KFDFhzdp+BzS70bZkU2ZtBMsjibyAiBOpdU0ZjTTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LQFFDSfA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709035791; x=1740571791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LcBc2xeaJTxXGy7RWmHyOmRx6954AwBxc525s+oHjKc=;
  b=LQFFDSfAc/3P2cxU2LDiMNxO+it82aqkU7p0AFOOLsuWISwDNWhQhnPU
   z1JepMIOoaSgwkF1xK9nmd7/qzxjarVJ9XFm3zGUKgsa/AGqVeMnkfx9P
   SKaB73HRNKd4mDKsq7gcohCDyg9SMESBUR8A5HkQ3QsdDdRIsGYELO20w
   WNsdHtWYLpSmv2tE+03SJ6t9cthMZy7hnpyY2ugQiab9ByRAfdcihIQNK
   zMDVmJzr+dhqccmXrAtm837yvBgbkUW1EzHJeE7o/x6/jHfGXaOdzoMQC
   k8a3pY4XA2BAmjS6FP72BT6Sd+Db13ctOUOPD0D0hAq9vgr4vo4646dvv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6319311"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6319311"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 04:09:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="7001290"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 04:09:44 -0800
Message-ID: <09c5fd9b-be96-45b6-b48e-772d5b5aad16@intel.com>
Date: Tue, 27 Feb 2024 20:09:41 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87le76dt1g.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 7:51 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 2/19/2024 8:53 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>>
>>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v4:
>>>> - refine the documentation; (Markus)
>>>>
>>>> Changes in v3:
>>>> - Add docmentation of new type and struct; (Daniel)
>>>> - refine the error message handling; (Daniel)
>>>> ---
>>>>    qapi/run-state.json   | 28 ++++++++++++++++++++--
>>>>    system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>>>    target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
>>>>    3 files changed, 103 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>>> index 08bc99cb8561..5429116679e3 100644
>>>> --- a/qapi/run-state.json
>>>> +++ b/qapi/run-state.json
>>>> @@ -485,10 +485,12 @@
>>>>   #
>>>>   # @s390: s390 guest panic information type (Since: 2.12)
>>>>   #
>>>> +# @tdx: tdx guest panic information type (Since: 8.2)
>>>> +#
>>>>   # Since: 2.9
>>>>   ##
>>>>   { 'enum': 'GuestPanicInformationType',
>>>> -  'data': [ 'hyper-v', 's390' ] }
>>>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>>>    
>>>>   ##
>>>>   # @GuestPanicInformation:
>>>> @@ -503,7 +505,8 @@
>>>>     'base': {'type': 'GuestPanicInformationType'},
>>>>     'discriminator': 'type',
>>>>     'data': {'hyper-v': 'GuestPanicInformationHyperV',
>>>> -          's390': 'GuestPanicInformationS390'}}
>>>> +          's390': 'GuestPanicInformationS390',
>>>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>>>    
>>>>   ##
>>>>   # @GuestPanicInformationHyperV:
>>>> @@ -566,6 +569,27 @@
>>>>              'psw-addr': 'uint64',
>>>>              'reason': 'S390CrashReason'}}
>>>>    
>>>> +##
>>>> +# @GuestPanicInformationTdx:
>>>> +#
>>>> +# TDX Guest panic information specific to TDX GCHI
>>>> +# TDG.VP.VMCALL<ReportFatalError>.
>>>> +#
>>>> +# @error-code: TD-specific error code
>>>
>>> Where could a user find information on these error codes?
>>
>> TDX GHCI (Guset-host-communication-Interface)spec. It defines all the
>> TDVMCALL leaves.
>>
>> 0: panic;
>> 0x1 - 0xffffffff: reserved.
> 
> Would it make sense to add a reference?

https://cdrdv2.intel.com/v1/dl/getContent/726792

>>>> +#
>>>> +# @gpa: guest-physical address of a page that contains additional
>>>> +#     error data, in forms of zero-terminated string.
>>>
>>> "in the form of a zero-terminated string"
>>
>> fixed.
>>
>>>> +#
>>>> +# @message: Human-readable error message provided by the guest. Not
>>>> +#     to be trusted.
>>>
>>> How is this message related to the one pointed to by @gpa?
>>
>> In general, @message contains a brief message of the error. While @gpa
>> (when valid) contains a verbose message.
>>
>> The reason why we need both is because sometime when TD guest hits a
>> fatal error, its memory may get corrupted so we cannot pass information
>> via @gpa. Information in @message is passed through GPRs.
> 
> Well, we do pass information via @gpa, always.  I guess it page's
> contents can be corrupted.

No. It's not always. the bit 63 of the error code is "GPA valid" bit. 
@gpa is valid only when bit 63 of error code is 1.

And current Linux TD guest implementation doesn't use @gpa at all.
https://github.com/torvalds/linux/blob/45ec2f5f6ed3ec3a79ba1329ad585497cdcbe663/arch/x86/coco/tdx/tdx.c#L131 


> Perhaps something like
> 
>      # @message: Human-readable error message provided by the guest.  Not
>      #     to be trusted.
>      #
>      # @gpa: guest-physical address of a page that contains more verbose
>      #     error information, as zero-terminated string.  Note that guest
>      #     memory corruption can corrupt the page's contents.
> 
>>>> +#
>>>> +# Since: 9.0
>>>> +##
>>>> +{'struct': 'GuestPanicInformationTdx',
>>>> + 'data': {'error-code': 'uint64',
>>>> +          'gpa': 'uint64',
>>>> +          'message': 'str'}}
> 
> Note that my proposed doc string has the members in a different order.
> Recommend to use the same order here.
> 
>>>> +
>>>>    ##
>>>>    # @MEMORY_FAILURE:
>>>>    #
>>>
>>> [...]
>>>
> 



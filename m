Return-Path: <kvm+bounces-11484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 210AC877986
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D7A81C212FE
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E05EDB;
	Mon, 11 Mar 2024 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKKWZlmO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC02801
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 01:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120530; cv=none; b=tAF+HBBTklOAQ2yl+P0rKArETi6e22hYDzCEMwrf3Px/OiFXUdDbRdlB2o3VYFyQaO21pHP9VDpGAApDrCkUKIcCYllEoHyjMRtmM20HtZM+xKNRwjFqFoMlEja1oNx9RhTqM3CZL/paDvQ8OFVIAdDZpbqgIMYhe7onVJuDyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120530; c=relaxed/simple;
	bh=BZyyCiYR0UjspFIqdj1irv2all9tyd7KB68o6I992zY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ba7kwY8QtdLgbiB3NsRv5WHGGYGEsVDdAvucqGPYpvVfnBptZwyK4EFilMGlvn3CE7iWEiap2Ur4+X3a+1H0Pb3PR4g8+DWtPVSUsXDQwmG2m6IyzALm39tf9xWuECa1fHDdCTNTMuii5/rUG/Uj9A/OyskyI+jOVbQSYxyNK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKKWZlmO; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710120529; x=1741656529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BZyyCiYR0UjspFIqdj1irv2all9tyd7KB68o6I992zY=;
  b=jKKWZlmOeodcQg5mfdybkaj5jsdUUvqBZ8genToYhNLaRNYWEfaa2MUH
   QE+KKNXum6TwJBK8aMsoweNdcm3p4qOgAcSNYUMISntVSaQOfEHXJokqG
   zJD1jIbnrR2ALdt3/lVDe0GeZZo6Mz22nBlxs/FZlbdwR74IvNN76cC8G
   0Zcoj6I3HhIEThD2mVhJeVH5bCf59OV2wLTFSc/b3tuz3Y31KjFs6Vsko
   PvGBVUPJ3FKE/gPlod8zzIbGtidJifQJQwgY2OrpXEYfPCv0das2cR+aS
   1PbToUMIhE6YN5ERt2ygbMzSU5MJ+cRXw5BkvcvCfOZ9FMLOUvOYTDrgj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="15409281"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15409281"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15502450"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:28:40 -0700
Message-ID: <95e623e1-ccf3-4d8f-9751-7767db100e2b@intel.com>
Date: Mon, 11 Mar 2024 09:28:37 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87y1au881k.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/2024 9:51 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 2/29/2024 4:51 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>>
>>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v5:
>>>> - mention additional error information in gpa when it presents;
>>>> - refine the documentation; (Markus)
>>>>
>>>> Changes in v4:
>>>> - refine the documentation; (Markus)
>>>>
>>>> Changes in v3:
>>>> - Add docmentation of new type and struct; (Daniel)
>>>> - refine the error message handling; (Daniel)
>>>> ---
>>>>    qapi/run-state.json   | 31 +++++++++++++++++++++--
>>>>    system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
>>>>    target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>>>>    3 files changed, 110 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>>> index dd0770b379e5..b71dd1884eb6 100644
>>>> --- a/qapi/run-state.json
>>>> +++ b/qapi/run-state.json
>>>> @@ -483,10 +483,12 @@
>>>>   #
>>>>   # @s390: s390 guest panic information type (Since: 2.12)
>>>>   #
>>>> +# @tdx: tdx guest panic information type (Since: 9.0)
>>>> +#
>>>>   # Since: 2.9
>>>>   ##
>>>>   { 'enum': 'GuestPanicInformationType',
>>>> -  'data': [ 'hyper-v', 's390' ] }
>>>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>>>      ##
>>>> # @GuestPanicInformation:
>>>> @@ -501,7 +503,8 @@
>>>>     'base': {'type': 'GuestPanicInformationType'},
>>>>     'discriminator': 'type',
>>>>     'data': {'hyper-v': 'GuestPanicInformationHyperV',
>>>> -          's390': 'GuestPanicInformationS390'}}
>>>> +          's390': 'GuestPanicInformationS390',
>>>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>>>   ##
>>>>   # @GuestPanicInformationHyperV:
>>>> @@ -564,6 +567,30 @@
>>>>              'psw-addr': 'uint64',
>>>>              'reason': 'S390CrashReason'}}
>>>> +##
>>>> +# @GuestPanicInformationTdx:
>>>> +#
>>>> +# TDX Guest panic information specific to TDX, as specified in the
>>>> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
>>>> +# section TDG.VP.VMCALL<ReportFatalError>.
>>>> +#
>>>> +# @error-code: TD-specific error code
>>>> +#
>>>> +# @message: Human-readable error message provided by the guest. Not
>>>> +#     to be trusted.
>>>> +#
>>>> +# @gpa: guest-physical address of a page that contains more verbose
>>>> +#     error information, as zero-terminated string.  Present when the
>>>> +#     "GPA valid" bit (bit 63) is set in @error-code.
>>>
>>> Uh, peeking at GHCI Spec section 3.4 TDG.VP.VMCALL<ReportFatalError>, I
>>> see operand R12 consists of
>>>
>>>       bits    name                        description
>>>       31:0    TD-specific error code      TD-specific error code
>>>                                           Panic – 0x0.
>>>                                           Values – 0x1 to 0xFFFFFFFF
>>>                                           reserved.
>>>       62:32   TD-specific extended        TD-specific extended error code.
>>>               error code                  TD software defined.
>>>       63      GPA Valid                   Set if the TD specified additional
>>>                                           information in the GPA parameter
>>>                                           (R13).
>>> Is @error-code all of R12, or just bits 31:0?
>>> If it's all of R12, description of @error-code as "TD-specific error
>>> code" is misleading.
>>
>> We pass all of R12 to @error_code.
>>
>> Here it wants to use "error_code" as generic as the whole R12. Do you have any better description of it ?
> 
> Sadly, the spec is of no help: it doesn't name the entire thing, only
> the three sub-fields TD-specific error code, TD-specific extended error
> code, GPA valid.
> 
> We could take the hint, and provide the sub-fields instead:
> 
> * @error-code contains the TD-specific error code (bits 31:0)
> 
> * @extended-error-code contains the TD-specific extended error code
>    (bits 62:32)
> 
> * we don't need @gpa-valid, because it's the same as "@gpa is present"
> 
> If we decide to keep the single member, we do need another name for it.
> @error-codes (plural) doesn't exactly feel wonderful, but it gives at
> least a subtle hint that it's not just *the* error code.

The reason we only defined one single member, is that the 
extended-error-code is not used now, and I believe it won't be used in 
the near future.

If no objection from others, I will use @error-codes (plural) in the 
next version.

>>> If it's just bits 31:0, then 'Present when the "GPA valid" bit (bit 63)
>>> is set in @error-code' is wrong.  Could go with 'Only present when the
>>> guest provides this information'.
>>>
>>>> +#
>>>> +#
>>>
>>> Drop one of these two lines, please.
>>>
>>>> +# Since: 9.0
>>>> +##
>>>> +{'struct': 'GuestPanicInformationTdx',
>>>> + 'data': {'error-code': 'uint64',
>>>> +          'message': 'str',
>>>> +          '*gpa': 'uint64'}}
>>>> +
>>>>    ##
>>>>    # @MEMORY_FAILURE:
>>>>    #
>>>
> 



Return-Path: <kvm+bounces-11295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46EC7874D6B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A1D71C213AE
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511B6839E3;
	Thu,  7 Mar 2024 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xq7TTBNR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B118529A
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709811049; cv=none; b=OEOCVd7xZA1SCV4nLOcN/ggYCO/D/lGEJlVnx9yIt85FruteDHL3l7vM3ujZAK28Qf1/TbHSD04KFR+myNOTgfGrzeAQARPZQvXFu4X0twGokyXDaBnSwRw3IIXZ+zS+siQrjgwvtT41Wxc345Ti7wW91suEurehmCCf7AcYepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709811049; c=relaxed/simple;
	bh=A10UBKhRS/a5V9sC5bEpT6S/qORoPkNjQunvfSxHJ6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2L7ZDqQRIMpFn6xufHwFW+soBL5BXHlQ5dxVbNlPbe8tbl6btKw9lEWH4loegwAPB7J1nYzqmojgYYBxTXlay8489fxkhMsveqS+TVUZc48XkEH4uS3eYTxcsvZUU9IyPGeElZkFZCHzEVg/T94TJiFBMOPlWK2HiNOmWm6DGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xq7TTBNR; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709811048; x=1741347048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A10UBKhRS/a5V9sC5bEpT6S/qORoPkNjQunvfSxHJ6I=;
  b=Xq7TTBNRWJCNZik/3FD+4A6pHkf4GNXGh+mJFn71LnXzkCxMFZin3Kn0
   gRe9Pv2zzM3wmLl8qSnhvB+47Yj5rlUosXaSLVdmZHe8VQokUTm9Lsew5
   rC8PYpkmxq8fI+i9bDkQMOQCSAOBMADFCG8LOv1n/Kxp6o7Nw+zh5F+tS
   /OfNf4uAQLiNw9xduEJIaRjRSiQt4+blx/6qBech12yVBLXzzk1CcpGps
   pjENUW5hGM0aJXAAyhGo08MIKxXjqqJgeYMAf365EHTKk9btmns7qA/KU
   ecsko12s7mLeytRsLdWLoSEn/cEPHJvn/++coxDLh3AWohiebj1ewrMv0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="29916223"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="29916223"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:30:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="33237722"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:30:41 -0800
Message-ID: <d5cb6e5e-0bc1-40bd-8fc1-50a03f42e9cf@intel.com>
Date: Thu, 7 Mar 2024 19:30:37 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <874jdr1wmt.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/29/2024 4:51 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>
>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v5:
>> - mention additional error information in gpa when it presents;
>> - refine the documentation; (Markus)
>>
>> Changes in v4:
>> - refine the documentation; (Markus)
>>
>> Changes in v3:
>> - Add docmentation of new type and struct; (Daniel)
>> - refine the error message handling; (Daniel)
>> ---
>>   qapi/run-state.json   | 31 +++++++++++++++++++++--
>>   system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>>   3 files changed, 110 insertions(+), 3 deletions(-)
>>
>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>> index dd0770b379e5..b71dd1884eb6 100644
>> --- a/qapi/run-state.json
>> +++ b/qapi/run-state.json
>> @@ -483,10 +483,12 @@
>>   #
>>   # @s390: s390 guest panic information type (Since: 2.12)
>>   #
>> +# @tdx: tdx guest panic information type (Since: 9.0)
>> +#
>>   # Since: 2.9
>>   ##
>>   { 'enum': 'GuestPanicInformationType',
>> -  'data': [ 'hyper-v', 's390' ] }
>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>   
>>   ##
>>   # @GuestPanicInformation:
>> @@ -501,7 +503,8 @@
>>    'base': {'type': 'GuestPanicInformationType'},
>>    'discriminator': 'type',
>>    'data': {'hyper-v': 'GuestPanicInformationHyperV',
>> -          's390': 'GuestPanicInformationS390'}}
>> +          's390': 'GuestPanicInformationS390',
>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>   
>>   ##
>>   # @GuestPanicInformationHyperV:
>> @@ -564,6 +567,30 @@
>>             'psw-addr': 'uint64',
>>             'reason': 'S390CrashReason'}}
>>   
>> +##
>> +# @GuestPanicInformationTdx:
>> +#
>> +# TDX Guest panic information specific to TDX, as specified in the
>> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
>> +# section TDG.VP.VMCALL<ReportFatalError>.
>> +#
>> +# @error-code: TD-specific error code
>> +#
>> +# @message: Human-readable error message provided by the guest. Not
>> +#     to be trusted.
>> +#
>> +# @gpa: guest-physical address of a page that contains more verbose
>> +#     error information, as zero-terminated string.  Present when the
>> +#     "GPA valid" bit (bit 63) is set in @error-code.
> 
> Uh, peeking at GHCI Spec section 3.4 TDG.VP.VMCALL<ReportFatalError>, I
> see operand R12 consists of
> 
>      bits    name                        description
>      31:0    TD-specific error code      TD-specific error code
>                                          Panic – 0x0.
>                                          Values – 0x1 to 0xFFFFFFFF
>                                          reserved.
>      62:32   TD-specific extended        TD-specific extended error code.
>              error code                  TD software defined.
>      63      GPA Valid                   Set if the TD specified additional
>                                          information in the GPA parameter
>                                          (R13).
> 
> Is @error-code all of R12, or just bits 31:0?
> 
> If it's all of R12, description of @error-code as "TD-specific error
> code" is misleading.

We pass all of R12 to @error_code.

Here it wants to use "error_code" as generic as the whole R12. Do you 
have any better description of it ?

> If it's just bits 31:0, then 'Present when the "GPA valid" bit (bit 63)
> is set in @error-code' is wrong.  Could go with 'Only present when the
> guest provides this information'.
> 
>> +#
>> +#
> 
> Drop one of these two lines, please.
> 
>> +# Since: 9.0
>> +##
>> +{'struct': 'GuestPanicInformationTdx',
>> + 'data': {'error-code': 'uint64',
>> +          'message': 'str',
>> +          '*gpa': 'uint64'}}
>> +
>>   ##
>>   # @MEMORY_FAILURE:
>>   #
> 



Return-Path: <kvm+bounces-37321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 769C1A287C9
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1145C169A79
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BEB022ACEF;
	Wed,  5 Feb 2025 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mlPspv/9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FFE22ACDF
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738750797; cv=none; b=nQJQmgg3Bi8cv2ccPBlcxN9drEkTOjgbRY6pSTMxtPE7xRgePm3Lma3nzuZVnL41NDJlsR9lBr8POANi0hHI3j4pDG5EWVCfsuonq6c+s5fj0Io6YM8powJa62JZVAQyBje8FolVIKHlxHO12jUXC5D8mtmcSrxpLdafIa2iH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738750797; c=relaxed/simple;
	bh=ZlyeICVSSjRaYfD4jzB36Voj3oGOORphki8ao45B0yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQw4v6xW0zvY1kC6jNZWBzmZbBJVjZYYC27U5xijyHMAtUp8FLWm2bvJRgZqKoVqyLoGvknKscgcY3fbVSPmwpMkD3q9jqNavVbN4JP4mypCtBb5abR2vrrdTkQqbx81Mt8qYdjfuk1LRnZChF5V4LajwalgiRw47WTchpXiszU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mlPspv/9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738750795; x=1770286795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZlyeICVSSjRaYfD4jzB36Voj3oGOORphki8ao45B0yc=;
  b=mlPspv/9mGgbp4RgaQwrzmoVTUbDPByU5qLuV59Q1GWW9U3tBv6l8ME8
   ZXMw1jeAiXway7s9Jpy2P50vw59g5bttx5Ry9kAUpl4u8ri3Z9B375ond
   x7p3TC9TkxXDRYXpjf5VnIiZazV41fEiYMkFzAh6+S89d9zwdlrWNIrK3
   RCx79ae3YodKvQ4lOgg81+TSCWawLw7GTjMC57C5fNSlJDF4UwtCoEuXH
   psbeqkVp3vqoJYqdwPIZDIqo8SNaPpSMECbuQ66CYEoUiIZ+gk16+AjSH
   Na9N95ArOS7BmwNqxnB6xR+Rix9XIFF6VOCK93bZtojuUyy6ot2QA8LLE
   w==;
X-CSE-ConnectionGUID: sHvJgI91RJGvtGoGWgCibg==
X-CSE-MsgGUID: s6/2z+/UQkqXq/dA20+nkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="49560834"
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="49560834"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:19:55 -0800
X-CSE-ConnectionGUID: Lx/U0d8RQlGR6sBiX7GFjw==
X-CSE-MsgGUID: 6i2q+Y/ETBO3ololtO6Gvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="115856871"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:19:51 -0800
Message-ID: <1852eef7-57e3-472a-80a7-203ec043950c@intel.com>
Date: Wed, 5 Feb 2025 18:19:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/52] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-29-xiaoyao.li@intel.com>
 <874j184ukg.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <874j184ukg.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/2025 5:19 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>
>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v6:
>> - change error_code of GuestPanicInformationTdx from uint64_t to
>>    uint32_t, to only contains the bit 31:0 returned in r12.
>>
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
>>   qapi/run-state.json   | 31 ++++++++++++++++++--
>>   system/runstate.c     | 67 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.c | 24 +++++++++++++++-
>>   3 files changed, 119 insertions(+), 3 deletions(-)
>>
>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>> index ce95cfa46b73..e63611780a2c 100644
>> --- a/qapi/run-state.json
>> +++ b/qapi/run-state.json
>> @@ -501,10 +501,12 @@
>>   #
>>   # @s390: s390 guest panic information type (Since: 2.12)
>>   #
>> +# @tdx: tdx guest panic information type (Since: 9.0)
> 
> Since: 10.0
> 
>> +#
>>   # Since: 2.9
>>   ##
>>   { 'enum': 'GuestPanicInformationType',
>> -  'data': [ 'hyper-v', 's390' ] }
>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>   
>>   ##
>>   # @GuestPanicInformation:
>> @@ -519,7 +521,8 @@
>>    'base': {'type': 'GuestPanicInformationType'},
>>    'discriminator': 'type',
>>    'data': {'hyper-v': 'GuestPanicInformationHyperV',
>> -          's390': 'GuestPanicInformationS390'}}
>> +          's390': 'GuestPanicInformationS390',
>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>   
>>   ##
>>   # @GuestPanicInformationHyperV:
>> @@ -598,6 +601,30 @@
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
>> +#
>> +#
>> +# Since: 10.0
>> +##
>> +{'struct': 'GuestPanicInformationTdx',
>> + 'data': {'error-code': 'uint32',
>> +          'message': 'str',
>> +          '*gpa': 'uint64'}}
>> +
>>   ##
>>   # @MEMORY_FAILURE:
>>   #
> 
> With the since information corrected
> Acked-by: Markus Armbruster <armbru@redhat.com>

will update the since information.

Thanks!

> [...]
> 



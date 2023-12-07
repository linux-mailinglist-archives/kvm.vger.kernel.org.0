Return-Path: <kvm+bounces-3822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 041A2808292
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 09:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0021F21ABA
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF27F1E4B3;
	Thu,  7 Dec 2023 08:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nnWMRJbz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D1EB2
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 00:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701936677; x=1733472677;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ozGjfFWenBxqgP2+d8rZ5ATy8rbjN8S1yBgJ5GIxczM=;
  b=nnWMRJbzRgBFWBGxJdOFZOhd/3rF0QgXV/b1WBrK23fl+HMdosEz1IB7
   lCdwXj3eqXX1BdBYDKwxN+AL7hCl7Tj8ffhT7J46WjTxonxZ5Nkhhe3GS
   BxTGvIKX4jhDnXsN6iDr0lDJsMk31F5+IBJXN+8QIBUW4YtxFxG1hYTZY
   Rp/bnzrBA4BByv6IFzmIIfKc8ukPz7A1u2AHluuwP/7Ws95603c9u/wJW
   piBCSRSQIrxTcsOGhoECA/7uXnMEQTLVkIPI7jbzDWdoWxx0qCaMxyCCQ
   TjLvyzpvbUw+K/MVOyHoUVoYu2yUp1PDllJngaaoXYvALixKGYKlZoOKu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="7504372"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="7504372"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 00:11:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="862398054"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="862398054"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 00:11:11 -0800
Message-ID: <4f60f482-0910-4a8f-a521-972630c08ad2@intel.com>
Date: Thu, 7 Dec 2023 16:11:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 57/70] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
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
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-58-xiaoyao.li@intel.com>
 <87bkbaw51z.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87bkbaw51z.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/2023 7:11 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>
>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes from v2:
>> - Add docmentation of new type and struct (Daniel)
>> - refine the error message handling (Daniel)
>> ---
>>   qapi/run-state.json   | 27 ++++++++++++++++++++--
>>   system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.c | 24 +++++++++++++++++--
>>   3 files changed, 101 insertions(+), 4 deletions(-)
>>
>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>> index f216ba54ec4c..e18f62eaef77 100644
>> --- a/qapi/run-state.json
>> +++ b/qapi/run-state.json
>> @@ -496,10 +496,12 @@
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
>> @@ -514,7 +516,8 @@
>>    'base': {'type': 'GuestPanicInformationType'},
>>    'discriminator': 'type',
>>    'data': {'hyper-v': 'GuestPanicInformationHyperV',
>> -          's390': 'GuestPanicInformationS390'}}
>> +          's390': 'GuestPanicInformationS390',
>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>   
>>   ##
>>   # @GuestPanicInformationHyperV:
>> @@ -577,6 +580,26 @@
>>             'psw-addr': 'uint64',
>>             'reason': 'S390CrashReason'}}
>>   
>> +##
>> +# @GuestPanicInformationTdx:
>> +#
>> +# TDX GHCI TDG.VP.VMCALL<ReportFatalError> specific guest panic information
> 
> Long line.  Suggest
> 
>     # Guest panic information specific to TDX GHCI
>     # TDG.VP.VMCALL<ReportFatalError>.

As I asked in patch #52, what's the limitation of one line?

>> +#
>> +# @error-code: TD-specific error code
>> +#
>> +# @gpa: 4KB-aligned guest physical address of the page that containing
>> +#     additional error data
> 
> "address of a page" implies the address is page-aligned.  4KB-aligned
> feels redundant.  What about
> 
>     # @qpa: guest-physical address of a page that contains additional
>     #     error data.
> 
> But in what format is the "additional error data"?

it's expected to hold a zero-terminated string.

>> +#
>> +# @message: TD guest provided message string.  (It's not so trustable
>> +#     and cannot be assumed to be well formed because it comes from guest)
> 
> guest-provided
> 
> For "well-formed" to make sense, we'd need an idea of the form / syntax.
> 
> If it's a human-readable error message, we could go with
> 
>     # @message: Human-readable error message provided by the guest.  Not
>     #     to be trusted.
>

looks good. I will your version.

>> +#
>> +# Since: 8.2
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



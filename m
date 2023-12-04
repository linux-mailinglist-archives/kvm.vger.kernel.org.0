Return-Path: <kvm+bounces-3295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD5A802C90
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6364C1F21071
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 07:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3924BC8E7;
	Mon,  4 Dec 2023 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FS4Hb+uB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC12B9
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 23:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701676776; x=1733212776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Csrf5U+K+c8wvUwhmYqLhxcScMdtlKgKl4nvBXVNsSk=;
  b=FS4Hb+uBqr0doHEKZXCNN5scbyuxVNQoFJbMYfKjpBI8kblM3zg43fWG
   8+a080xY6ffx5RETIWch7YAgtqkvadu9Dztr2/GbMLOVCFnA7H6FfsGu7
   c7aQjJbuOKq+YZA1KFCxrs7dO1Uy2fGZhIHuF5NuvSadSPsywzy1Q/2e2
   G1y+//I49+6k9A2bo986mZeD7zylSPhGXUucOLUH6WzmCVoa8Uea9gQ6z
   dTDoxl931BBtTnRbQcjQVHZzQqY2+JeJZCoWGThcyI+R+cFpOCzk64Etu
   RN6v/vaqAWO12Y4jJPrNtvMf98HHSEQApufkP+Cm+np5sukaTBe1OBqHQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="384100615"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="384100615"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:59:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="17307334"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:59:29 -0800
Message-ID: <25b14f27-e970-46b3-a635-edc6f2926938@intel.com>
Date: Mon, 4 Dec 2023 15:59:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/70] i386: Introduce tdx-guest object
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
 <20231115071519.2864957-14-xiaoyao.li@intel.com>
 <87ttp2w5xj.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87ttp2w5xj.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/2023 6:52 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Introduce tdx-guest object which implements the interface of
>> CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by
>>
>>    qemu -machine ...,confidential-guest-support=tdx0	\
>>         -object tdx-guest,id=tdx0
>>
>> It has only one member 'attributes' with fixed value 0 and not
>> configurable so far.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> Acked-by: Markus Armbruster <armbru@redhat.com>
> 
> [...]
> 
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index c53ef978ff7e..8e08257dac2f 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -878,6 +878,16 @@
>>               'reduced-phys-bits': 'uint32',
>>               '*kernel-hashes': 'bool' } }
>>   
>> +##
>> +# @TdxGuestProperties:
>> +#
>> +# Properties for tdx-guest objects.
>> +#
>> +# Since: 8.2
> 
> Going to be 9.0.

will update it and all others.

(I left it as 8.2 because I was not sure next version is 8.3 or 9.0)

>> +##
>> +{ 'struct': 'TdxGuestProperties',
>> +  'data': { }}
>> +
>>   ##
>>   # @ThreadContextProperties:
>>   #
>> @@ -956,6 +966,7 @@
>>       'sev-guest',
>>       'thread-context',
>>       's390-pv-guest',
>> +    'tdx-guest',
>>       'throttle-group',
>>       'tls-creds-anon',
>>       'tls-creds-psk',
>> @@ -1022,6 +1033,7 @@
>>         'secret_keyring':             { 'type': 'SecretKeyringProperties',
>>                                         'if': 'CONFIG_SECRET_KEYRING' },
>>         'sev-guest':                  'SevGuestProperties',
>> +      'tdx-guest':                  'TdxGuestProperties',
>>         'thread-context':             'ThreadContextProperties',
>>         'throttle-group':             'ThrottleGroupProperties',
>>         'tls-creds-anon':             'TlsCredsAnonProperties',
> 
> [...]
> 
> 



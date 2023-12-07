Return-Path: <kvm+bounces-3818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D543808204
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EDB11F21FD6
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D6B199CA;
	Thu,  7 Dec 2023 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kVSDVmsI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5CA137
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 23:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701934723; x=1733470723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BXBFcsZwYwTDGcbTnD2OQCUETr2fkYGend2keFm5JYo=;
  b=kVSDVmsIPT4AVX17AFDTKFDlFqznZjuCl8uX6iQkTJjGZywprOFXHanb
   eEtjty6HVR2R/EcKYsCQ726XPh90yY5VGTXR6oDPWDjnn8fSE07+XPYWP
   gimohEj5sKFXET7YRiR064jLl78XHqhp8bo09+95Ja82DDftkr4S08YOT
   xRECIcSNLYyNrLZaFZ1Waujf5h72EMYNzXFwAXJwWA4/pPlNQC5kcFIog
   jRO9VGUbdeV/K+USGkfrntjoDh9KwshUEi13jr3IK6fNBzIB8BllycNHg
   U44OttEtKrchgRruaO8EINUUcAkQc52ZwE4r+7UeaxLotWXvMkUwPW/W8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="480381946"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="480381946"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:38:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="895048144"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="895048144"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:38:33 -0800
Message-ID: <a838be54-89cc-485b-897c-d069fc887d3d@intel.com>
Date: Thu, 7 Dec 2023 15:38:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
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
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
 <87jzpyw5hp.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87jzpyw5hp.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/2023 7:02 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> For GetQuote, delegate a request to Quote Generation Service.
>> Add property "quote-generation-socket" to tdx-guest, whihc is a property
>> of type SocketAddress to specify Quote Generation Service(QGS).
>>
>> On request, connect to the QGS, read request buffer from shared guest
>> memory, send the request buffer to the server and store the response
>> into shared guest memory and notify TD guest by interrupt.
>>
>> command line example:
>>    qemu-system-x86_64 \
>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
>>      -machine confidential-guest-support=tdx0
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v3:
>> - rename property "quote-generation-service" to "quote-generation-socket";
>> - change the type of "quote-generation-socket" from str to
>>    SocketAddress;
>> - squash next patch into this one;
>> ---
>>   qapi/qom.json         |   5 +-
>>   target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |   6 +
>>   3 files changed, 440 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index fd99aa1ff8cc..cf36a1832ddd 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -894,13 +894,16 @@
>>   #
>>   # @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
>>   #
>> +# @quote-generation-socket: socket address for Quote Generation Service(QGS)
>> +#
> 
> Long line.  Better:
> 
>     # @quote-generation-socket: socket address for Quote Generation
>     #     Service(QGS)

May I ask what's the limitation for qom.json? if 80 columns limitation 
doesn't apply to it.

>>   # Since: 8.2
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>>     'data': { '*sept-ve-disable': 'bool',
>>               '*mrconfigid': 'str',
>>               '*mrowner': 'str',
>> -            '*mrownerconfig': 'str' } }
>> +            '*mrownerconfig': 'str',
>> +            '*quote-generation-socket': 'SocketAddress' } }
>>   
>>   ##
>>   # @ThreadContextProperties:
> 



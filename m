Return-Path: <kvm+bounces-9195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A917085BE6D
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDEC21C21EE1
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FCB6A8D9;
	Tue, 20 Feb 2024 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EV8BxJGF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6226A35F
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708438572; cv=none; b=mOEBHeEoSjit50+UdKYidV97BqZ8YLpTykiXvene3FCxl7GHojTONHGcgxeaOnrfjdcpkN97xQhhi5XkEQG/P3EBoHN7QvPFmTuhStWQ/Oe03wdTQCuLXQ8a3ZO/aWt+nlqDcjwhBQYhPhrViHRp2KtqET/Ib4YTbj8pyB5fnTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708438572; c=relaxed/simple;
	bh=ZzOxx9Qf2X8K1Cl7sBHn+bbSKmwAI3HepkVQZN65h5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrX7+lg4H/0/QtE9dhTD+2L23VtVSDwikPCDmsVMTi7ja8GiYbqqK/AngX8rZk0SglcAteEly0Lj6zTiJa7SIMDWOplrofyxmosTO92SFGn/oolmF+8qLjwNOLNm1DKA0iaqQu4t71m5wmt9j7b67VjnrnaNE9po5hYhJi+jKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EV8BxJGF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708438570; x=1739974570;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZzOxx9Qf2X8K1Cl7sBHn+bbSKmwAI3HepkVQZN65h5s=;
  b=EV8BxJGFfFB8W0m+CEeSDD707uLUUo4JOYceQF0eacJOeJNXN/xk/yFV
   aP+3GiJ5EcX1zCjwfmUdFOcJLmcVs7q2u4lJ/tnMZ70aekEhW2PTn2AL0
   HRo92Rtx0CL09DtaIfljE7B9npfZwanAAGsoBsUBM5hOwgTLO2wbvbqA3
   e+YBlIePXiPgxkoM+S8BHR+BfNQjTIpnY/xCUVUMvNkyhCkRxYGAIoVG4
   QhpoBbx/WHAISgS8mT0C24pnOQQ/w65rTdBN0LkUimj23jrxn54qz4Ayl
   oIccJP71fbbdjMk3PC2QOjNz0l9EG3YyxB/eYUaj/KrkVwWb0UQYVA1IQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="20073616"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="20073616"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 06:16:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="9432630"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 06:16:04 -0800
Message-ID: <47975bb8-6c7a-413b-9152-1686d8d72ab7@intel.com>
Date: Tue, 20 Feb 2024 22:16:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-51-xiaoyao.li@intel.com>
 <87zfvwehyz.fsf@pond.sub.org> <ZdNPpcNiGcY4Jefi@redhat.com>
 <8734tojz2q.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8734tojz2q.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2024 10:41 PM, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
>> On Mon, Feb 19, 2024 at 01:50:12PM +0100, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Add property "quote-generation-socket" to tdx-guest, which is a property
>>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>>
>>>> On request of GetQuote, it connects to the QGS socket, read request
>>>> data from shared guest memory, send the request data to the QGS,
>>>> and store the response into shared guest memory, at last notify
>>>> TD guest by interrupt.
>>>>
>>>> command line example:
>>>>    qemu-system-x86_64 \
>>>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>>>      -machine confidential-guest-support=tdx0
>>>>
>>>> Note, above example uses vsock type socket because the QGS we used
>>>> implements the vsock socket. It can be other types, like UNIX socket,
>>>> which depends on the implementation of QGS.
>>>>
>>>> To avoid no response from QGS server, setup a timer for the transaction.
>>>> If timeout, make it an error and interrupt guest. Define the threshold of
>>>> time to 30s at present, maybe change to other value if not appropriate.
>>>>
>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v4:
>>>> - merge next patch "i386/tdx: setup a timer for the qio channel";
>>>>
>>>> Changes in v3:
>>>> - rename property "quote-generation-service" to "quote-generation-socket";
>>>> - change the type of "quote-generation-socket" from str to
>>>>    SocketAddress;
>>>> - squash next patch into this one;
>>>> ---
>>>>   qapi/qom.json                         |   6 +-
>>>>   target/i386/kvm/meson.build           |   2 +-
>>>>   target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
>>>>   target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
>>>>   target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
>>>>   target/i386/kvm/tdx.h                 |   6 +
>>>>   6 files changed, 493 insertions(+), 2 deletions(-)
>>>>   create mode 100644 target/i386/kvm/tdx-quote-generator.c
>>>>   create mode 100644 target/i386/kvm/tdx-quote-generator.h
>>>>
>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>> index 15445f9e41fc..c60fb5710961 100644
>>>> --- a/qapi/qom.json
>>>> +++ b/qapi/qom.json
>>>> @@ -914,13 +914,17 @@
>>>>   #     e.g., specific to the workload rather than the run-time or OS.
>>>>   #     base64 encoded SHA384 digest.
>>>>   #
>>>> +# @quote-generation-socket: socket address for Quote Generation
>>>> +#     Service(QGS)
>>>
>>> Space between "Service" and "(QGS)", please.
>>>
>>> The description feels too terse.  What is the "Quote Generation
>>> Service", and why should I care?
>>
>> The "Quote Generation Service" is a daemon running on the host.
>> The reference implementation is at
>>
>>    https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs
>>
>> If you don't provide this, then quests won't bet able to generate
>> quotes needed for attestation. So although this is technically
>> optional, in practice for a sane deployment, an admin should always
>> provide this
> 
> Thanks.  Care to work some of this information into the doc comment?

Sure. Will add a new section of Attestation in the last patch.

>>>> +#
>>>>   # Since: 9.0
>>>>   ##
>>>>   { 'struct': 'TdxGuestProperties',
>>>>     'data': { '*sept-ve-disable': 'bool',
>>>>               '*mrconfigid': 'str',
>>>>               '*mrowner': 'str',
>>>> -            '*mrownerconfig': 'str' } }
>>>> +            '*mrownerconfig': 'str',
>>>> +            '*quote-generation-socket': 'SocketAddress' } }
>>>>   
>>>>   ##
>>>>   # @ThreadContextProperties:
>>>
>>> [...]
>>>
>>
>> With regards,
>> Daniel
> 



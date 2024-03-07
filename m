Return-Path: <kvm+bounces-11294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A988E874D5C
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA9381C23C12
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E251292C9;
	Thu,  7 Mar 2024 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gd+1jSCu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE26786AE9
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709810757; cv=none; b=Bcua3DtRzhmzcveGki74r0mXgJuvebP4URKt3rNJddzFYZKC8lEuKuq1xUXq1iUhz32o/U+E+OcNg8gTJadmA38G3ShD4f99QVQFodoC2m4wmSYUYgOGQ8RqgZ4sg2CRgCtRM/uxDH93z1uH0U2Xh0793bWVhoRa8SSousCp8yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709810757; c=relaxed/simple;
	bh=1CmSZHBal2aoFmC/opGyMVJfHE9puXGcDcFD3caXTmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/OM6OZ+s8ATAew6BavWscQCwXIaBx0VNqdhRSU8K2ZMFJa8Ab3pm5XMwz31CNbADCnIj7eqZG0CWX6G8sF2+XWAuwKei9iJD/pnipaIeog7QFWeQJ9l8CFdkslnIbWd//s/h0SuMXzNGBxcBMRVZm0NWYqQlU7GbRfzi6/KtyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gd+1jSCu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709810756; x=1741346756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1CmSZHBal2aoFmC/opGyMVJfHE9puXGcDcFD3caXTmo=;
  b=Gd+1jSCur81SXMOR9nFcdLYpJtMHJFD5wUgsMOp8TgHG/+DeqngI/y3c
   N2xuM9mLF23WWK5VZTI55czQLEAWVdYNSrpPsII21bn5w374o3KGutzDf
   ZfCoVAGyKCQ4Vi9KJNsw1M6hKWEkFJpsS1MOzY7uXUlDuNGdwRufbAvE7
   ecSqWNVK1LZra8/WDGdGvc/NNpsBOsO/IaDrO9qgshCwj8SmQNwI7SVba
   yy+NZOjEA9IEjHt3EGHyRS5nlZExHByinNMuS4xdLFcou3QL5c7xFxt4l
   Jatr1VrflT6mmqDJhqIrn/zV+99O2bbS1Q7uk8EsQZCBnHnFVWeW1/Mys
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4327675"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="4327675"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:25:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="10527765"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:25:49 -0800
Message-ID: <a0fa9dc9-221c-4ab4-81f6-b692e26d8a23@intel.com>
Date: Thu, 7 Mar 2024 19:25:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
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
 <20240229063726.610065-50-xiaoyao.li@intel.com> <87a5nj1x4l.fsf@pond.sub.org>
 <8a2c760d-6310-42eb-b632-5f67b12e2149@intel.com>
 <87wmqnwga4.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87wmqnwga4.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/2024 9:28 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 2/29/2024 4:40 PM, Markus Armbruster wrote:
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
>>>>     qemu-system-x86_64 \
>>>>       -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>>>       -machine confidential-guest-support=tdx0
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
>>>
>>> [...]
>>>
>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>> index cac875349a3a..7b26b0a0d3aa 100644
>>>> --- a/qapi/qom.json
>>>> +++ b/qapi/qom.json
>>>> @@ -917,13 +917,19 @@
>>>>   #     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>>>>   #     used when absent).
>>>>   #
>>>> +# @quote-generation-socket: socket address for Quote Generation
>>>> +#     Service (QGS).  QGS is a daemon running on the host.  User in
>>>> +#     TD guest cannot get TD quoting for attestation if QGS is not
>>>> +#     provided.  So admin should always provide it.
>>>
>>> This makes me wonder why it's optional.  Can you describe a use case for
>>> *not* specifying @quote-generation-socket?
>>
>> Maybe at last when all the TDX support lands on all the components, attestation will become a must for a TD guest to be usable.
>>
>> However, at least for today, booting and running a TD guest don't require attestation. So not provide it, doesn't affect anything excepting cannot get a Quote.
> 
> Maybe
> 
>    # @quote-generation-socket: Socket address for Quote Generation
>    #     Service (QGS).  QGS is a daemon running on the host.  Without
>    #     it, the guest will not be able to get a TD quote for
>    #     attestation.

Thanks! will update to it.

> [...]
> 



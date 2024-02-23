Return-Path: <kvm+bounces-9461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7ADC860802
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE450B21218
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C6EBE6B;
	Fri, 23 Feb 2024 01:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhtwKgGj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C6E9455
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708650396; cv=none; b=TFJTyjEI/0TTiRDn+qkUualx7/2bpEIJKGIcPb9fuTA34F4v3X6WMzL1R7+rdwkMvBeOeIgU5+XC66okbFIg8YamMjdhOur9jP/3iAY+s8Zi/xODBW/AOdMOkAZ25QvRYDABIQX53fhyhJE2yJ0V7S/P0ZVGk6+1RkraY3EUX38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708650396; c=relaxed/simple;
	bh=UYf7Lpk+4RWbwrAMIQ5hC6FFwZoS9ehF7K5lptzklNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cE58VjQMfG5K77w1k9ME56MhGTmwKxGpwu28jRvRPjf58PTYqX53TT/V2CizY41vmgik+LIjQcvKwg3KkiIcgXDRfNsAjxu+w7UKEkv2p3mP/4SLZ/4GHlwR+eHowyKnS//lH9XkoHDXz+eCQz0sMlOvDmHd+F3oJumwzKUTsQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhtwKgGj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708650395; x=1740186395;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UYf7Lpk+4RWbwrAMIQ5hC6FFwZoS9ehF7K5lptzklNI=;
  b=lhtwKgGjMCe7a4pSbLZjS07zL8ZvanlkLRf8FDP8dSGw2rqEDrnVgrIx
   cinSYsSM/BZ1/w6lLH4liU98Ux2Oesoa7+bHWGMXGeIxq6x1W9Yu4wYPt
   mvnO8NpwzbVAAswdNYzoiPYhEizdkcLz9LYNlYy5JTqP6CoMKsYWff/iP
   nD6dH4sCz8n/2AfPlqOizayj8yjhAIzS7+Je9CdrarWIdB7vBUBCaqw/J
   LAXRadVoENQQc2SjqZiLH4tK6DfVL987nTYWdLInJg7Lrw0QiSUCWctfu
   omqFHoSb9RvTOk4sJA640PIANpXtJ7WI1fwkA4G/rcUyRVOXZvGuVHuWt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="13572780"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="13572780"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:06:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="6130250"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:06:26 -0800
Message-ID: <7968b9fa-af4b-4eca-893d-a9b3bb81803a@intel.com>
Date: Fri, 23 Feb 2024 09:06:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 feng.qiu@intel.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-51-xiaoyao.li@intel.com>
 <Zdd2oSFOiIparDIe@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zdd2oSFOiIparDIe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

+ Feng Qiu,

On 2/23/2024 12:30 AM, Daniel P. Berrangé wrote:
> On Wed, Jan 24, 2024 at 10:23:12PM -0500, Xiaoyao Li wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add property "quote-generation-socket" to tdx-guest, which is a property
>> of type SocketAddress to specify Quote Generation Service(QGS).
>>
>> On request of GetQuote, it connects to the QGS socket, read request
>> data from shared guest memory, send the request data to the QGS,
>> and store the response into shared guest memory, at last notify
>> TD guest by interrupt.
>>
>> command line example:
>>    qemu-system-x86_64 \
>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>      -machine confidential-guest-support=tdx0
>>
>> Note, above example uses vsock type socket because the QGS we used
>> implements the vsock socket. It can be other types, like UNIX socket,
>> which depends on the implementation of QGS.
> 
> Can you confirm again exactly what QGS impl you are testing against ?
> > I've tried the impl at
> 
>     https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs
> 
> which supports UNIX sockets and VSOCK. In both cases, however, it
> appears to be speaking a different protocol than your QEMU impl
> below uses.
> 
> Specifically here:
> 
>    https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/master/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L143
> 
> it is reading 4 bytes of header, which are interpreted as the length
> of the payload which will then be read off the wire. IIUC the payload
> it expects is the TDREPORT struct.
> 
> Your QEMU patches here meanwhile are just sending the payload from
> the GetQuote hypercall which is the TDREPORT struct.
> 
> IOW, QEMU is not sending the 4 byte length header the QGS expects.
> and whole thing fails.

I'm using the one provided by internal folks, which supports 
interpreting the payload without the header.

I don't know when will the updated implementation show up in public 
github. @Feng Liu can help on it.

>>
>> To avoid no response from QGS server, setup a timer for the transaction.
>> If timeout, make it an error and interrupt guest. Define the threshold of
>> time to 30s at present, maybe change to other value if not appropriate.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
> 
> With regards,
> Daniel



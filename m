Return-Path: <kvm+bounces-9473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F016686087C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4573AB226DF
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DF9B665;
	Fri, 23 Feb 2024 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n09Vh/G4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C35AB653
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652946; cv=none; b=gu3jn1/AutaSqOvRsWTEeWqNV0LjYC7UvTDruNXjqHqwFe6kv8bjnLcP86u97xcg754TjfZRhR0XQTF4AC5ogKQ10ulhS16sYJPexzRKrwE+Nmvi/3cHeP9uAExQ1eC7mf9gfqN6ykDB9+t0NROHgS5jUsez0DOe7ykPz/JWCu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652946; c=relaxed/simple;
	bh=OnhXajfGHNgS/YEiBCc3vldCEb75LI+l8F4i9Wi5Z3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsjJ2ZvYrHUViGRq6i/cBTKjZuq/4zCpdTN18PcHndSHTH+mLwzTeXGC/tP3xCGtTL+p8kN8q3A57WnwAAun+YmhJ5OEZUbinxXgKGLVOLZphE595cLWAjvONUyWHX+a+TQCOm2CoW4V0BbvxOvGcfeX1KO9d8Kf63Fp46lV1pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n09Vh/G4; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708652944; x=1740188944;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OnhXajfGHNgS/YEiBCc3vldCEb75LI+l8F4i9Wi5Z3w=;
  b=n09Vh/G4WL3qiXXbyomF6cLbhKleQK+OJrKyY60bPRvRiqFJ/dBtUbaB
   w4IYMDkXoaDVVew/8BWX8oeJEgJtLgpC6u96HRaQ/1fbAOvC1y8hZnLsS
   AVc5SxgL8OOMsSG1HaXx8q21q8MQecSc/e+Roi1UNGsoRTBpSlfvEVbRq
   E1excnzR0WudDWh6yBH5z2BCf36IypUGs1XUdplkOsjd5gTR+wWnOpF6S
   8Zrv3DrYamIV59LyVdhRHiFB1TLMWeki+iKifWQLoBrO8jSinxgIILuMB
   oNjl0Qt4S6LV0kSO79vLP51e8pKXLvb2+82MSLwsy6P5V7meqTgrp0J73
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="20391119"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="20391119"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:49:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="36767291"
Received: from fqiu1-mobl1.ccr.corp.intel.com (HELO [10.93.10.69]) ([10.93.10.69])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:48:59 -0800
Message-ID: <9d6068d8-fb21-4b10-94c6-5d74cc0aa6ff@intel.com>
Date: Fri, 23 Feb 2024 09:48:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
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
 <7968b9fa-af4b-4eca-893d-a9b3bb81803a@intel.com>
Content-Language: en-US
From: "Qiu, Feng" <feng.qiu@intel.com>
In-Reply-To: <7968b9fa-af4b-4eca-893d-a9b3bb81803a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Actually the 4 byte length header is provided by client 
library(https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/master/QuoteGeneration/quote_wrapper/tdx_attest/tdx_attest.c#L295), 
not QEMU. QEMUjust treats the how payload including the header a whole blob.
BTW, in the latest stable kernel, the TDX guest driver changed to TSM 
based 
solution(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/virt/coco/tdx-guest/tdx-guest.c?h=v6.7.5) 
and it will only send raw report without 4 byte length header and other 
stuff. Existing official QGS doesn't compatible with this change and we 
will deliver compatible QGS in the end of Q1.

On 2/23/2024 9:06 AM, Xiaoyao Li wrote:
> + Feng Qiu,
> 
> On 2/23/2024 12:30 AM, Daniel P. Berrangé wrote:
>> On Wed, Jan 24, 2024 at 10:23:12PM -0500, Xiaoyao Li wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Add property "quote-generation-socket" to tdx-guest, which is a property
>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>
>>> On request of GetQuote, it connects to the QGS socket, read request
>>> data from shared guest memory, send the request data to the QGS,
>>> and store the response into shared guest memory, at last notify
>>> TD guest by interrupt.
>>>
>>> command line example:
>>>    qemu-system-x86_64 \
>>>      -object 
>>> '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>>      -machine confidential-guest-support=tdx0
>>>
>>> Note, above example uses vsock type socket because the QGS we used
>>> implements the vsock socket. It can be other types, like UNIX socket,
>>> which depends on the implementation of QGS.
>>
>> Can you confirm again exactly what QGS impl you are testing against ?
>> > I've tried the impl at
>>
>>     
>> https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs
>>
>> which supports UNIX sockets and VSOCK. In both cases, however, it
>> appears to be speaking a different protocol than your QEMU impl
>> below uses.
>>
>> Specifically here:
>>
>>    
>> https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/master/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L143
>>
>> it is reading 4 bytes of header, which are interpreted as the length
>> of the payload which will then be read off the wire. IIUC the payload
>> it expects is the TDREPORT struct.
>>
>> Your QEMU patches here meanwhile are just sending the payload from
>> the GetQuote hypercall which is the TDREPORT struct.
>>
>> IOW, QEMU is not sending the 4 byte length header the QGS expects.
>> and whole thing fails.
> 
> I'm using the one provided by internal folks, which supports 
> interpreting the payload without the header.
> 
> I don't know when will the updated implementation show up in public 
> github. @Feng Liu can help on it.
> 
>>>
>>> To avoid no response from QGS server, setup a timer for the transaction.
>>> If timeout, make it an error and interrupt guest. Define the 
>>> threshold of
>>> time to 30s at present, maybe change to other value if not appropriate.
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>
>> With regards,
>> Daniel
> 


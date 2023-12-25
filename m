Return-Path: <kvm+bounces-5204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C3081E075
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8F4AB21427
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 12:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E557351C42;
	Mon, 25 Dec 2023 12:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tn1qdmcp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E5850253
	for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 12:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703507662; x=1735043662;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kBKpPgDUszsD89fUMQpcwLt3lcoERl6NfvEf9e/71sg=;
  b=Tn1qdmcpuo2blLc/bhORJcjJimF+vTAcnGBNpIOOywklSrp5hSO1aH0/
   27sWD4jtJqo1mGPhTyiJl8W1KQ/0W3AH0tezud61cUYIWuMvkRDZ3+k0Z
   kDQf4r8AiCmejmcKEiDJRHI6Ai6yHKLhoksafnsjm3o29k/l6J6v5UOiD
   WKBbLMIuvM9LX/CbKXzoVmk82L8h5xivx4XkNXt/qwi8M9JvMZgkYJm1z
   JKoqfI92ixRJ/FUkWKc+2OFTsy4l+3Mf+Cd50MpWFzoDsOQJ8bs9pjI9c
   2EOWxWuH22nMkxwtl7WLi232IPDxyTYL4J1O5YbcgYz/qXBKg/5ePrfSa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="3370909"
X-IronPort-AV: E=Sophos;i="6.04,303,1695711600"; 
   d="scan'208";a="3370909"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 04:34:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="901176927"
X-IronPort-AV: E=Sophos;i="6.04,303,1695711600"; 
   d="scan'208";a="901176927"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 04:34:15 -0800
Message-ID: <9aee1487-fc1a-4db1-b2ff-e572177eb83d@intel.com>
Date: Mon, 25 Dec 2023 20:34:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
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
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
 <ZYQb_P6eHokUz9Hh@redhat.com>
 <5314df8a-4173-46cb-bc7e-984c6b543555@intel.com>
 <ZYWLnIfXac_K7EZM@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZYWLnIfXac_K7EZM@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/22/2023 9:14 PM, Daniel P. Berrangé wrote:
> On Fri, Dec 22, 2023 at 11:14:12AM +0800, Xiaoyao Li wrote:
>> On 12/21/2023 7:05 PM, Daniel P. Berrangé wrote:
>>> On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> For GetQuote, delegate a request to Quote Generation Service.
>>>> Add property "quote-generation-socket" to tdx-guest, whihc is a property
>>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>>
>>>> On request, connect to the QGS, read request buffer from shared guest
>>>> memory, send the request buffer to the server and store the response
>>>> into shared guest memory and notify TD guest by interrupt.
>>>>
>>>> command line example:
>>>>     qemu-system-x86_64 \
>>>>       -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
>>>
>>> Here you're illustrating a VSOCK address.  IIUC, both the 'qgs'
>>> daemon and QEMU will be running in the host. Why would they need
>>> to be using VSOCK, as opposed to a regular UNIX socket connection ?
>>>
>>
>> We use vsock here because the QGS server we used for testing exposes the
>> vsock socket.
> 
> Is this is the server impl you test with:
> 
>    https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs

I think it should be.

I used applications/services bundled by internal teams.

> or is there another impl ?
> 
> With regards,
> Daniel



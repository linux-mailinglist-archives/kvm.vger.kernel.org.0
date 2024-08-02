Return-Path: <kvm+bounces-23020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 945A4945B49
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7E2B1C22A58
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE3A1DC470;
	Fri,  2 Aug 2024 09:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KG7YzYO/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59B51DC466
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 09:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722591733; cv=none; b=oBryPUlTgwlLSpW62DAC3tPqJSM5ezLO7/kA1V5aD/TlAwyB98drD9scyJySMSgVKbeNyOyXZ+NB9Vw/lVU1cBujHhZCYj2TXUSqNlnTY3PT4t203V0gfIiaB5PUgpZQ5D1f12hbRqmA7Fxv8w8A8C1I++Ysm0ZSVHBrWhOKEzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722591733; c=relaxed/simple;
	bh=TRgj5MQ1X+7M5ohpJvC6maspF4eQr+yB7z8ilgCTR1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iz00nVXB7hDIYBQ+3YuO9JLom8uECuOnBm6RZiDyDcdxQGNJwLDljomNkhGqgW7oU4PoyDmpGj3i0c9pXpzhSX9mmX91+049iG/bR3+YR1UJD4hW3VucFy6RxcjIM2OsfGQXnEIH4J1JktJAvTPITsqg4h6GsO01u/DKuU81l5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KG7YzYO/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722591730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SR6COq4r8Q0id3Rqkqe8/eU3zLpLWDQO48baLmfUlac=;
	b=KG7YzYO/JAp+jhw3t/zccsWe/k5rK3SeM31tGs6+ka6eV+htUii+jV8jp/shFW29FUeMk7
	hOcZrWpadjVlAybR6pslPxLiPbv11DuPbhX1TwcW9WRKlH8KC7PzXNF0Jn3vsY3E0r0ISS
	iHd/vB+K0Ac8SIjIb1ZRLWPgl09sTlc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-ka3sF8tRPSm9T-UAdRCGMQ-1; Fri, 02 Aug 2024 05:42:09 -0400
X-MC-Unique: ka3sF8tRPSm9T-UAdRCGMQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5d5cc01aee6so1084757eaf.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 02:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722591728; x=1723196528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SR6COq4r8Q0id3Rqkqe8/eU3zLpLWDQO48baLmfUlac=;
        b=I1ajuxf2gyD4OCElpHpnzWd2P9fGvBLJymK3PrszjZ5S5KII6eXe6X4xTQo1vV3BMM
         wwX37PB/Efx7KoeaTZYATxC8ydEoHAmU9Vcef/SrNmdONBiWafGdsPC+3/tN/rpDTh5I
         NU9lsUAuUtBiS3ZxtDlddWXD32Blh/V4tRJ/bUrkN8bxHFfpAaVvmQI4onXn32dcD/2w
         QDT6FCDz8PukfHnHdKhSlfAFf17XWuyJlOrWDeLUaMc3flowfpcSzVuFew2rDiQl10sA
         0Bcd9VSua6Qezo+fYORVpQKnTutolfBwdG7Vg7JqN4Mg72IEwl/rYbMvo813lhXVhH9t
         Gakw==
X-Forwarded-Encrypted: i=1; AJvYcCXNO23IlDv8VtoYM4RnBlG2MrkTC1w4GNcNFiy5OFzgodK7ZzCJXNN+C8lqn3rjjWctrTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCVSAOMH2eneziGJSxMjZNbALiw0wEV2fKjd/qcoFsM/zDH80I
	QdoShKr7JAjp/nZXBq8kZOFhys2VljByBoi6MlyD32RB0i6OMgGkGnuUlKG28rMSHa5mLiTrSo4
	jbH8WM2J5bJJRAW+G/3tIdUqcTw0qrPLxIs+F9AcZNBc8nxz3Sg==
X-Received: by 2002:a05:6358:3114:b0:1ac:f3df:3be4 with SMTP id e5c5f4694b2df-1af3ba1a9b7mr183374255d.2.1722591728472;
        Fri, 02 Aug 2024 02:42:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk0paCGeWVhRcyWCJElxcdxOb74/vgPqg4SND/eYZU2Qfu/PnDhtQB1D1iskdtqVUxfW1sow==
X-Received: by 2002:a05:6358:3114:b0:1ac:f3df:3be4 with SMTP id e5c5f4694b2df-1af3ba1a9b7mr183371955d.2.1722591727921;
        Fri, 02 Aug 2024 02:42:07 -0700 (PDT)
Received: from [10.72.116.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7b7654be84esm1042263a12.89.2024.08.02.02.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 02:42:07 -0700 (PDT)
Message-ID: <45e9258c-b370-4b5c-884b-80a21f69cee8@redhat.com>
Date: Fri, 2 Aug 2024 17:41:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Mingwei Zhang <mizhang@google.com>, Jim Mattson <jmattson@google.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <b10545d1-8e81-44f0-8e13-eee393ea4d1b@redhat.com>
 <ZqyovJZkOjm6HZFv@intel.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZqyovJZkOjm6HZFv@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

On 8/2/24 17:37, Zhao Liu wrote:
> Hello Shaoqin,
> 
> On Fri, Aug 02, 2024 at 05:01:47PM +0800, Shaoqin Huang wrote:
>> Date: Fri, 2 Aug 2024 17:01:47 +0800
>> From: Shaoqin Huang <shahuang@redhat.com>
>> Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
>>
>> Hi Zhao,
>>
>> On 7/10/24 12:51, Zhao Liu wrote:
>>> Hi QEMU maintainers, arm and PMU folks,
>>>
>>> I picked up Shaoqing's previous work [1] on the KVM PMU filter for arm,
>>> and now is trying to support this feature for x86 with a JSON-compatible
>>> API.
>>>
>>> While arm and x86 use different KVM ioctls to configure the PMU filter,
>>> considering they all have similar inputs (PMU event + action), it is
>>> still possible to abstract a generic, cross-architecture kvm-pmu-filter
>>> object and provide users with a sufficiently generic or near-consistent
>>> QAPI interface.
>>>
>>> That's what I did in this series, a new kvm-pmu-filter object, with the
>>> API like:
>>>
>>> -object '{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0xc4"}]}'
>>>
>>> For i386, this object is inserted into kvm accelerator and is extended
>>> to support fixed-counter and more formats ("x86-default" and
>>> "x86-masked-entry"):
>>>
>>> -accel kvm,pmu-filter=f0 \
>>> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
>>
>> What if I want to create the PMU Filter on ARM to deny the event range
>> [0x5,0x10], and allow deny event 0x13, how should I write the json?
>>
> 
> Cuurently this doesn't support the event range (since the raw format of
> x86 event cannot be said to be continuous).
> 
> So with the basic support, we need to configure events one by one:
> 
> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0x5"},{"action":"allow","format":"raw","select":"0x6"},{"action":"allow","format":"raw","code":"0x7"},{"action":"allow","format":"raw","code":"0x8"},{"action":"allow","format":"raw","code":"0x9"},{"action":"allow","format":"raw","code":"0x10"},{"action":"deny","format":"raw","code":"0x13"}]}'
> 
> This one looks a lot more complicated, but in the future, arm could
> further support event-range (maybe implement event-range via mask), but
> I think this could be arch-specific format since not all architectures'
> events are continuous.
> 
> Additional, I'm a bit confused by your example, and I hope you can help
> me understand that: when configuring 0x5~0x10 to be allow, isn't it true
> that all other events are denied by default, so denying 0x13 again is a
> redundant operation? What is the default action for all other events
> except 0x5~0x10 and 0x13?
> 
> If we specify action as allow for 0x5~0x10 and deny for the rest by
> default, then there is no need to set an action for each event but only
> a global one (as suggested by Dapeng), so the above command line can be
> simplified as:
> 
> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0x5"},{"format":"raw","select":"0x6"},{"format":"raw","code":"0x7"},{"format":"raw","code":"0x8"},{"format":"raw","code":"0x9"},{"format":"raw","code":"0x10"}]}'
> 

Yes you are right. On Arm when you first set the PMU Filter, if the 
first filter is allow, then all other event will be denied by default. 
The reverse is also the same, if the first filter is deny, then all 
other event will be allowed by default.

On ARM the PMU Filter is much more simper than x86 I think. We only need 
to care about the special event with allow or deny action.

If we don't support event range filter, I think that's fine. This can be 
added in the future.

Thanks,
Shaoqin

> Thanks,
> Zhao
> 

-- 
Shaoqin



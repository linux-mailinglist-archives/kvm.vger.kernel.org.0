Return-Path: <kvm+bounces-35505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8476A118BD
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1AD41680E6
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDFF22F832;
	Wed, 15 Jan 2025 05:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ojNFcQ6q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC0922F3AF
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 05:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736917662; cv=none; b=jkS1POCiC6Ye3Y0yUQsDeefkelZYF35hlzPDJv8jdVByLqRP4aP6zmgw4SFJ2B8+NTvFaus3E/HrzHvktT1voX8bcy5/rK4RqS0baLHISTqVcDVSCiS5FE3JohHA11RfVLdJMqjnBW4z+gb2/86MLAmKdUCx1HKqCxM3XWWn/rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736917662; c=relaxed/simple;
	bh=t4dXpTZmsRI2k2NZ4xiQUhN5dBPeJttIl5lhtigwHU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G9eKQLj+MKotj8YkSNISmOTRG/OMVnuGSzYexH82fqdC5S5S+rCewjOyUJ8LWWmbfLAegWZzm6ur0wALrYPLfy4rJwVorSLTQxb85R/vuAOBavBvNDavUUJIpk0FMbX9VRbHu7urtkwKxYYxxOv/JBBhF2Ppl/Li47WLhfFAsJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ojNFcQ6q; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21636268e43so147931345ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 21:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736917660; x=1737522460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tJj2ax30G5cYMMuz85Qw6SCJDIZ/bbwOrDlSPLFGRgM=;
        b=ojNFcQ6qbQMsuh63BrZPD2cg5u7/AjaUXt9B7ekVeZhZM8dOXf3eAAuYd+TBljvKwK
         JtNVSsZSxxxJMsHDenuRv66Q+3LiW/CEFkGmFZ15GfcB1tGh258PdjinToYMY6fN5CT9
         yLK/AIBtJTJJwU1XATwHLqPmqX6dv8V9mBOPQ6Rx1Sfri9vVUE/+dgN+cKHNzxg2ivhk
         m7ysgpWjGkfKAPQDfwx20th4mSNaYEPeGZwe/pPtPrlYgMFWu6FprvmzyPayoSWQys1k
         2nGX8N5IF/6m1UIIXjlIlqdAOoj5xaQRHCPESiDfRHfQYqYL7WKNb6iJHI4t1rnWxhjb
         XD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736917660; x=1737522460;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJj2ax30G5cYMMuz85Qw6SCJDIZ/bbwOrDlSPLFGRgM=;
        b=araAALeEn/NO1pSkUKSI7y9l6EkE6x+ya7eyXiBn13F1dHqmdrUj9XCuoDIGrDQO8r
         ODdSxgMT8HnK0ZeMLcE/NZExh6A3nvbzuI7sLk2ELl047dk+uEInqkKpyWL8Kn2VDxYP
         nNipKn9QVcaFwC2sCv3Ra9eFaYF1jI6z5N/KvV8J/kuFw185xO0APxzsQuImRTkEjnzD
         2osz7sMdFWH2GFEU62ELcQ2158j/ELGgtnuVwr8ilBLfi+x3uSjnd67UwrUlcdBp0Uxt
         gWueGb2HNeNxSn5nkvGc4XTlVatfDlV9TRwjBBjD1Zd6JD5OiJOfSWmHmZMzYJJrKkdM
         B2Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXFQVdY/fHi/Yw4UmTu8SuOYXCgz05Mc5V8el07ojYchiDdtqAcMPKS/ZG0hmqSmtKaDag=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9p3SWiM2WG91MXKj5C3EHt0vvosa/oGphRVATz2GGrvEPgA2K
	sOJQq81yichrF6dWIaN6ugsoiHpNGCJuQRVgiPjcAfS5nJI01Tajv1isYw+zQOo=
X-Gm-Gg: ASbGncuUZi+EZr6SFr7s23av/UrfKGiSi4P7XiymNBoShwFQeZDSMVByfxynYinHJFZ
	7WrvyMj3uTCIwkwKr6ZO1efhzvUxq/g8FBVqPAVUWHKeVOGvybrCXPyk6I+3+sDGvh2MxFE6g45
	qGqK1YJ3jBLBFgfOjbgFKEEIyWmtcyoOp0bMuas99Pvzsv+QeRSCfUt1y4PSMtvUk3R9p5TyizV
	9qFdF4QoUnQtyBgaAkME1BKe9NBAe2+qF9SbMX16znfjR8VBZwQie+klQyU0XxghkQ=
X-Google-Smtp-Source: AGHT+IH85/A6RLxL+2rEhiloGI8TMEvrvGtTvROtv7Pjqakmsz8YgZ7ly7fq+kIggy8KHNzrf4rkjg==
X-Received: by 2002:a17:902:ea0a:b0:216:3083:d03d with SMTP id d9443c01a7336-21a83ffc447mr470885135ad.44.1736917659024;
        Tue, 14 Jan 2025 21:07:39 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10e41csm73994625ad.11.2025.01.14.21.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 21:07:38 -0800 (PST)
Message-ID: <fcb301e8-c808-4e20-92dd-2e3b83998d18@daynix.com>
Date: Wed, 15 Jan 2025 14:07:32 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
 <20250110052246-mutt-send-email-mst@kernel.org>
 <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
 <CACGkMEuiyfH-QitiiKJ__-8NiTjoOfc8Nx5BwLM-GOfPpVEitA@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEuiyfH-QitiiKJ__-8NiTjoOfc8Nx5BwLM-GOfPpVEitA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/01/13 12:04, Jason Wang wrote:
> On Fri, Jan 10, 2025 at 7:12 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2025/01/10 19:23, Michael S. Tsirkin wrote:
>>> On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
>>>> On Thu, Jan 9, 2025 at 2:59 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>
>>>>> The specification says the device MUST set num_buffers to 1 if
>>>>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
>>>>
>>>> Have we agreed on how to fix the spec or not?
>>>>
>>>> As I replied in the spec patch, if we just remove this "MUST", it
>>>> looks like we are all fine?
>>>>
>>>> Thanks
>>>
>>> We should replace MUST with SHOULD but it is not all fine,
>>> ignoring SHOULD is a quality of implementation issue.
>>>
> 
> So is this something that the driver should notice?
> 
>>
>> Should we really replace it? It would mean that a driver conformant with
>> the current specification may not be compatible with a device conformant
>> with the future specification.
> 
> I don't get this. We are talking about devices and we want to relax so
> it should compatibile.


The problem is:
1) On the device side, the num_buffers can be left uninitialized due to bugs
2) On the driver side, the specification allows assuming the num_buffers 
is set to one.

Relaxing the device requirement will replace "due to bugs" with 
"according to the specification" in 1). It still contradicts with 2) so 
does not fix compatibility.

Instead, we should make the driver requirement stricter to change 2). 
That is what "[PATCH v3] virtio-net: Ignore num_buffers when unused" does:
https://lore.kernel.org/r/20250110-reserved-v3-1-2ade0a5d2090@daynix.com

> 
>>
>> We are going to fix all implementations known to buggy (QEMU and Linux)
>> anyway so I think it's just fine to leave that part of specification as is.
> 
> I don't think we can fix it all.

It essentially only requires storing 16 bits. There are details we need 
to work out, but it should be possible to fix.

Regards,
Akihiko Odaki


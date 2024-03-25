Return-Path: <kvm+bounces-12579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B21DD88A326
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F4C71F3BFBE
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56AB716F83F;
	Mon, 25 Mar 2024 10:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2nuKYT9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4BB7581B
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711357871; cv=none; b=ifDrYmeVe5G8gheTD0d0mKxAi1R2H/ZIoFDN+UMkyd09H+aaX+z7IGJwI0wZ+Jb7aXXMx3e0FyxYP8h638d7EBHiGNjUtT27WeOXP68c1wsW3dAB1Vaj4W8j2lC/C2VrnGoCdT4VYjJ0ba7v9fOcaK6UvTkkHY1OpDPKfM8TPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711357871; c=relaxed/simple;
	bh=ARF0iZoZIjdZhMwT1oVgCUXttDIoYZEPyHnnjmTJx6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzvUczOjsAK/x3F2V+T3y1U3cMIRwDcoW0Jx4JTYb4c8+iL3c3b8sRGgesbf6RL14hivpHHIwm4mV+ki4jeD4rm7V2i9j6gdNJsRISoumjV4yh+WG9rAnjz1OJpbRh5oujMNc0h6UH+aCYp8tSdI6Gfz5V+SYDfHwGgIAKJAQh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2nuKYT9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711357868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eodL44A0zmP+nkw2anBS4wOysdDIJWPYzeL/IC8ftqI=;
	b=I2nuKYT91pw9tCTCMUlsts5l8gu25inZIbjQSIp0sZ2gjT5fpEhfRCqCv4rwNA0yKWIGmW
	mRSlqKku+zJzyJUNZU5SJxFkgMVoLhMsLBPbh2OpymZ7x4HvVhl/xR+OmJ1bTz1dAIdG9d
	P2+nkIcb5WTd2H9gAx58A1GfvXihEdc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-7ONGumr8OAqIhEIeoZdhBQ-1; Mon, 25 Mar 2024 05:11:07 -0400
X-MC-Unique: 7ONGumr8OAqIhEIeoZdhBQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d45c064742so46761681fa.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 02:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711357866; x=1711962666;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eodL44A0zmP+nkw2anBS4wOysdDIJWPYzeL/IC8ftqI=;
        b=pKBYchxSeNNWq7Cie77LIK097mIWIvfzfCrjXe6o50BfYkLZSq0v5+Dipip5d+6VaV
         afjEgvHQvQa9PLg3OSbLPYBcqmK6/IUiq5073sBhbyC+mYmcGmY52Sc73Fjg77Pu5467
         +ZrE49gK1kAIqJWUzAv7Jj3tX4OwyYPJX48Vkra+0LH56s2axrauyZAqSNudtqE4sxA/
         ik4Nr67XinD7xB5uYnr/zhLHUpVGabZCuKpAjtgNh15jTwKsfer9avK2YAHroNr4N3SZ
         LPh+wrveI8Pee3mhXSvLZm8cO8FD2Th++CJqONsy8EoR0fpnCk9BXIDfu8AFbb+dRf0w
         Qy6w==
X-Forwarded-Encrypted: i=1; AJvYcCU876VcOsllmeqM3lU9lwro313A7jkzt0WwVWFpGX/eUZDXkG/U+YoUyCx4jcalOwzgbykM4fo5aUY56eVRfpzgGeRA
X-Gm-Message-State: AOJu0Yyu3DyL2U61/MoR2VneBTifa5KJHhEwF0sUQP+qsMR5BM1q3doo
	WAfQa4iY42I7dhhwQrckzpNapN1sjn1o9FFRabr9FkcStP09L38VWY53euaGFb9ZnZEzODpkU8e
	/niBoCiX4mG/xmeMQ+W8M+cIHpzNcTn/PvMZO/bNNiVmr+X4cSA==
X-Received: by 2002:a2e:8947:0:b0:2d4:7777:b7fb with SMTP id b7-20020a2e8947000000b002d47777b7fbmr4359239ljk.17.1711357865740;
        Mon, 25 Mar 2024 02:11:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7PlfCmimUoKtTJDbsbLoVaILrVOW6htqejyhlsq8LubUc6twBMEH8AEMoGLTKITdy3ouCHg==
X-Received: by 2002:a2e:8947:0:b0:2d4:7777:b7fb with SMTP id b7-20020a2e8947000000b002d47777b7fbmr4359222ljk.17.1711357865235;
        Mon, 25 Mar 2024 02:11:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:b400:6a82:1eac:2b5:8fca? (p200300cbc738b4006a821eac02b58fca.dip0.t-ipconnect.de. [2003:cb:c738:b400:6a82:1eac:2b5:8fca])
        by smtp.gmail.com with ESMTPSA id h20-20020a05600c351400b0041477f95cf6sm7785217wmq.13.2024.03.25.02.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 02:11:04 -0700 (PDT)
Message-ID: <041867ab-6cff-4bd1-9a44-2ca847c1ad63@redhat.com>
Date: Mon, 25 Mar 2024 10:11:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v4 1/6] virtio_balloon: remove the dependence where
 names[] is null
Content-Language: en-US
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Daniel Verkamp <dverkamp@chromium.org>
References: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com>
 <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
 <CABVzXAkwcKMb7pC21aUDLEM=RoyOtGA2Vim+LF0oWQ7mjUx68g@mail.gmail.com>
 <b420a545-0a7a-431c-aa48-c5db3d221420@redhat.com>
 <1711346901.0977402-2-xuanzhuo@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1711346901.0977402-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25.03.24 07:08, Xuan Zhuo wrote:
> On Fri, 22 Mar 2024 22:02:27 +0100, David Hildenbrand <david@redhat.com> wrote:
>> On 22.03.24 20:16, Daniel Verkamp wrote:
>>> On Thu, Mar 21, 2024 at 3:16 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>>>
>>>> Currently, the init_vqs function within the virtio_balloon driver relies
>>>> on the condition that certain names array entries are null in order to
>>>> skip the initialization of some virtual queues (vqs). This behavior is
>>>> unique to this part of the codebase. In an upcoming commit, we plan to
>>>> eliminate this dependency by removing the function entirely. Therefore,
>>>> with this change, we are ensuring that the virtio_balloon no longer
>>>> depends on the aforementioned function.
>>>
>>> This is a behavior change, and I believe means that the driver no
>>> longer follows the spec [1].
>>>
>>> For example, the spec says that virtqueue 4 is reporting_vq, and
>>> reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set,
>>> but there is no mention of its virtqueue number changing if other
>>> features are not set. If a device/driver combination negotiates
>>> VIRTIO_BALLOON_F_PAGE_REPORTING but not VIRTIO_BALLOON_F_STATS_VQ or
>>> VIRTIO_BALLOON_F_FREE_PAGE_HINT, my reading of the specification is
>>> that reporting_vq should still be vq number 4, and vq 2 and 3 should
>>> be unused. This patch would make the reporting_vq use vq 2 instead in
>>> this case.
>>>
>>> If the new behavior is truly intended, then the spec does not match
>>> reality, and it would need to be changed first (IMO); however,
>>> changing the spec would mean that any devices implemented correctly
>>> per the previous spec would now be wrong, so some kind of mechanism
>>> for detecting the new behavior would be warranted, e.g. a new
>>> non-device-specific virtio feature flag.
>>>
>>> I have brought this up previously on the virtio-comment list [2], but
>>> it did not receive any satisfying answers at that time.
>>
>> Rings a bell, but staring at this patch, I thought that there would be
>> no behavioral change. Maybe I missed it :/
>>
>> I stared at virtio_ccw_find_vqs(), and it contains:
>>
>> 	for (i = 0; i < nvqs; ++i) {
>> 		if (!names[i]) {
>> 			vqs[i] = NULL;
>> 			continue;
>> 		}
>>
>> 		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
>> 					     names[i], ctx ? ctx[i] : false,
>> 					     ccw);
>> 		if (IS_ERR(vqs[i])) {
>> 			ret = PTR_ERR(vqs[i]);
>> 			vqs[i] = NULL;
>> 			goto out;
>> 		}
>> 	}
>>
>> We increment queue_idx only if an entry was not NULL. SO I thought no
>> behavioral change? (at least on s390x :) )
>>
>> It's late here in Germany, so maybe I'm missing something.
> 
> I think we've encountered a tricky issue. Currently, all transports handle queue
> id by incrementing them in order, without skipping any queue id. So, I'm quite
> surprised that my changes would affect the spec. The fact that the
> 'names' value is null is just a small trick in the Linux kernel implementation
> and should not have an impact on the queue id.
> 
> I believe that my recent modification will not affect the spec. So, let's
> consider the issues with this patch set separately for now. Regarding the Memory
> Balloon Device, it has been operational for many years, and perhaps we should
> add to the spec that if a certain vq does not exist, then subsequent vqs will
> take over its id.

Right, if I am not missing something your patch should have no 
functional change in that regard (that the current 
behavior/implementation might not match the spec is a different discussion).

@Daniel, if I'm missing something, please shout.

-- 
Cheers,

David / dhildenb



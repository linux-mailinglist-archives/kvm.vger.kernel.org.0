Return-Path: <kvm+bounces-43007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 258D0A822A4
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 12:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 240841B67348
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089E225DAFD;
	Wed,  9 Apr 2025 10:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSTvaxi4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA282566F3
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744195615; cv=none; b=ON3fis4ZgpcbgiyeWJ+LaLQ5GCAUhPJJRbcDtkj8k2mRlleA1MrneV8//A93BpJs8IrzSn6H/qrX1HfYlQ9de8gSXWHkVRWqke6elwiXtoMLsHf9lDEw2dDYAHYVuomFH4cWFnokFJjJDHQq2ZfqxpM620JEfEDlOonuoh8i/rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744195615; c=relaxed/simple;
	bh=A2izym1Utk7diiSIRS/WVNxBg+tpqvZb4BlF0EjbH74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7WWyEOLi62YpzsBTF4lCRWaQ/V8gDmMudwKO07fS//WEubrzMNTYL/CdW2zyp64tXx2iuwN7J1BnyyN645cQV4Eb9fKmrdlSxGkU42Dix+9JE3goyrD1Gln22KA+MzPlFnWC7TKLGqAl1dLHQTQzLQ8ofSm43Ch2X84FtotEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSTvaxi4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744195612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6GURs+rA2kl1DB3dCBq9SPCewqe7vVe7c7T2yJZQFo=;
	b=jSTvaxi4VI6U8ggKklm+lJ4ajgoNwxdq/aUardQ9gYpfjwBFuXPooONbOh22NxT+DBy3D2
	320xWKFLU1/1aWVKYZfvZ862Ey/ZLe+ydsgmZV0BbObrYB5IAuavLcRCRYztF3dAcd1TsX
	4611Kbms/QIZU73I4sl1CDX9EKbXwLY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-JLMfSuK8OgO6li4rqJhXkw-1; Wed, 09 Apr 2025 06:46:46 -0400
X-MC-Unique: JLMfSuK8OgO6li4rqJhXkw-1
X-Mimecast-MFC-AGG-ID: JLMfSuK8OgO6li4rqJhXkw_1744195605
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so42115475e9.3
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 03:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744195605; x=1744800405;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C6GURs+rA2kl1DB3dCBq9SPCewqe7vVe7c7T2yJZQFo=;
        b=ZU7+KtRTfyerMEoEw7oGwouVaIznhMjS9UmuIgCy7/kVg6huK2WhKWbMUd7zUQ+ghx
         ub7D/RA1tqaO6T3gK2fwBB128oMTleKGY6xEORhR93wR3c2Eyhf8IH9PRfHBby/ay0nC
         yAs0rLJ+Xa2MTXhQ8h1byUNK5I8ZRKsRDB9u+xzUJGY38U8cGOmIEhpYWIbyjHNvI7NB
         m+ZKHI8Qe8pX/qlZ8bNvROoi98OlJpsvC77M19XhbMUR4h6JLwwSXjdfiP++Mje9m3zN
         nJJhkA8464e4rz238uY61Wpcz7KS0O3g/LTYK49MKiFnPepcwA2VZwf+s46D9JWc3VhH
         DFRA==
X-Forwarded-Encrypted: i=1; AJvYcCV7FiNyIWIU+b6CxoCvfiHdAV4RorCMzf7X+abKd7DyE2iDA03mvfQlshIi48VyLc8ZCIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUJ+MdKzmL+b7jtXVEuGFGLw03bX8VaeZV4ljIg3UX4rtztdPa
	9pocgQN+onwtkLpA0ttSzh+rhfbt+x+bQTsl0dCXPuYPdxgo6Areu6SFT2BfhMQ7GmQTzfeVsgW
	ATbcrN49a4dUBx6rFwLxJm5K08aB92s8sc7Pq9IhXhNABC7wSHw==
X-Gm-Gg: ASbGnctaectw/b2FC3b0QXJka+m14/KhuDkLH3/r5wRiQmkM0EADdCRQjhbZMLcoMVs
	5xhjmATEXS021E6NupFi5ofpH2/2io5G769PBc8gKFH6fad00k5Q+8v4Wi17pNm8GFYpUmhYy2C
	qGRUtb5o/sRpw0p5NiNGqOvYyYpvt2To3Jkuu7u15d7YyTpM2VSnSv7lDCQQJgCZfgRoKRZZWtm
	r1BN7KzvjRmIzMy+ZJ0jceZWxJQMZbGRSBqkAjE3F6ZysGV9tra5/J3aRi7kQJt1Hx+aG6LXOM+
	d8GsEElULhZysw5s17PXMKTsjx9BBHITxa3JqFMJHWod5bqaIcsqXQ49CCZofXvyGySvkFSw4QR
	eI814Fo72np+SCXZ1QYylqX0Q5BS1RJ1EvA==
X-Received: by 2002:a05:600c:3541:b0:43c:e467:d6ce with SMTP id 5b1f17b1804b1-43f1ec7ccf2mr23763485e9.4.1744195604946;
        Wed, 09 Apr 2025 03:46:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmXr3kF+YruO7Uq1wa7mPMZCskFwiPljKb7DzlEdURTSUO/hZuYTN96OR5ijWouCv8RJEFvQ==
X-Received: by 2002:a05:600c:3541:b0:43c:e467:d6ce with SMTP id 5b1f17b1804b1-43f1ec7ccf2mr23763245e9.4.1744195604612;
        Wed, 09 Apr 2025 03:46:44 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:8400:ed9b:a3a:88e5:c6a? (p200300cbc70d8400ed9b0a3a88e50c6a.dip0.t-ipconnect.de. [2003:cb:c70d:8400:ed9b:a3a:88e5:c6a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2066d26bsm16164845e9.22.2025.04.09.03.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 03:46:43 -0700 (PDT)
Message-ID: <440de313-e470-4afa-9f8a-59598fe8dc21@redhat.com>
Date: Wed, 9 Apr 2025 12:46:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>, Halil Pasic
 <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
 Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
 <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
 <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>
 <20250407170239-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407170239-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 23:20, Michael S. Tsirkin wrote:
> On Mon, Apr 07, 2025 at 08:47:05PM +0200, David Hildenbrand wrote:
>>> In my opinion, it makes the most sense to keep the spec as it is and
>>> change QEMU and the kernel to match, but obviously that's not trivial
>>> to do in a way that doesn't break existing devices and drivers.
>>
>> If only it would be limited to QEMU and Linux ... :)
>>
>> Out of curiosity, assuming we'd make the spec match the current QEMU/Linux
>> implementation at least for the 3 involved features only, would there be a
>> way to adjust crossvm without any disruption?
>>
>> I still have the feeling that it will be rather hard to get that all
>> implementations match the spec ... For new features+queues it will be easy
>> to force the usage of fixed virtqueue numbers, but for free-page-hinting and
>> reporting, it's a mess :(
> 
> 
> Still thinking about a way to fix drivers... We can discuss this
> theoretically, maybe?

Yes, absolutely. I took the time to do some more digging; regarding 
drivers only Linux seems to be problematic.

virtio-win, FreeBSD, NetBSD and OpenBSD and don't seem to support 
problematic features (free page hinting, free page reporting) in their 
virtio-balloon implementations.

So from the known drivers, only Linux is applicable.

reporting_vq is either at idx 4/3/2
free_page_vq is either at idx 3/2
statsq is at idx2 (only relevant if the feature is offered)

So if we could test for the existence of a virtqueue at an idx easily, 
we could test from highest-to-smallest idx.

But I recall that testing for the existance of a virtqueue on s390x 
resulted in the problem/deadlock in the first place ...

-- 
Cheers,

David / dhildenb



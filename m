Return-Path: <kvm+bounces-42868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E199A7EC70
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 21:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55E0B3BF266
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 19:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6583526561D;
	Mon,  7 Apr 2025 18:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZUf+4ylq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED2A265605
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744051633; cv=none; b=hdbpG1SpgBzOYwnoDUYhs2NLvSS5Lr8k4qPVm1UsBdMp7IEqQcRZci4i4vq3y0YvKkBpunohk2CjbucGO4B08jivw2hhj9/iLuuKHphJppXNaTe/qWtxqtQcgty7WIQ7y80pxb1h5y7YY2TTbJqSM/OZ+dlJeiSMEKCm7W1UsAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744051633; c=relaxed/simple;
	bh=vkOu48MHkcflXUL7qNZB9+9d1ToWnocR8NwjwAbMyC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g8gp9r9GtNvhX/OrJdv2DouiE0xq8czpObebTuz8DxCScCfz/5zDdQdi5XVP1hIGo4J7Ybw4AOWKS7ppdhr9BSaG/2a+mTpyKTtBz4wHPnuY04vlHKtxhMr8HFhUSNmxPIPWuidOEo9TFeeYW0V9ylT5feD2UkpK05lIsc7aW3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZUf+4ylq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744051630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7b5rA5RQZI8sbn9wq/jI1LUSbfaEQH/bKK8lzmExseA=;
	b=ZUf+4ylqUFgwdZJeMXPSGJZmsnFPCCmUZcGNOgvBe1mm7J4Dm9U6qFjvtUr/L8zGf3yUxt
	VljmqYsFTahXZggrD0DBQM8gAQgBkxfuWrQbAlmnZ4Qvs2b0JHA3IDQ6oaTQQXUuj8tkq/
	fxvVldVdfaL7s0hnVI/DiPPP6iglQpE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-5JIJWJP7M92iTb2hmhsfNA-1; Mon, 07 Apr 2025 14:47:09 -0400
X-MC-Unique: 5JIJWJP7M92iTb2hmhsfNA-1
X-Mimecast-MFC-AGG-ID: 5JIJWJP7M92iTb2hmhsfNA_1744051628
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so26411055e9.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 11:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744051628; x=1744656428;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7b5rA5RQZI8sbn9wq/jI1LUSbfaEQH/bKK8lzmExseA=;
        b=VUiWiZ6HyDzIv+MF2fuSNfTE2/vE9HF5J/mnt/SGsxMdtB6KoxG9SweiMv2LtV1ZLI
         wBCCZ6j++WL7nRcv1sTxjhrdg+BSSH0lQViAkc7ny6cuP33GXnZll2wKY1YUwSQy4pqu
         CAMDOvxKoaYcQE6/3GoFxkLJ1KBWOUWqgRQOg/Mkny4gCsg7URgfy+dlbLxr5olJNdZd
         DVjrR4nliN1PZAJ6DUl7cjxSociaFtfAkCYUO51xJuMYRCXhU7AvkUN5bQF1+pXcKBJP
         44S7N+qRn4TY4PaU5sv6Pobo6xOgO3CABmwUfFb6q7F3cErnyKirLGe4ECa2sZqpo9R7
         s2EQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0V4m4St1NHDdRGH2enh0bwm4KrDolQs2Q/Lpaob4VIWbt2CnP9t5s/8bZMv9evfBHeNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjreVo9WrdT7lDRO7vBLGbMbhs77EYHu6qJlaGSvTI4LubwlkJ
	Gvp96ZlaNn1jEqTpN5Gw1p0W8jHP5Vgif8iKvQfj/QUHDMc1uDZHW6fWsylzrrvzDjhuauQhHtj
	P2j4jxLnKtQcN0KwlJa3brwCM6fYFlFfk+ASgjwQOL2wSWpVfFA==
X-Gm-Gg: ASbGncuUdvrfLebPkO6B28sPtSCQccOGDticf7q8oIFZke7/y1BM0lIZwt23Bm/0L5e
	t4oGb4o9SsbviusDPVhlmjj7ng7QbABokpYaz+WBgnHhF1Yb50Loj8u2eLvqE/9lE7qXyDckS3P
	IwzxYRTSy2R/93quq0nfGYLubH7qcFWK0sd8MZZ4AilSMy5BG09hJI760nzZHXtj3mxl+bMOY4A
	Qgb/FoNXtVLDsUHowsnDjNSbp7tG4U+ADIz+SF5SjU/bh1pGHyk1FgjtNlD5lYjZ5PEkEZQNOJ6
	TI/WqnXlf5l5yhvNxC2mxN6ifz+yL6iAwmfItTAwpVkXxzi1HUeusnAl93dKvokdhbTK0G9uVLy
	qnHfsbbpwggZhbamkv03me/m1YrBX9ySy0baBALbN9tA=
X-Received: by 2002:a05:600c:4f52:b0:43b:c6a7:ac60 with SMTP id 5b1f17b1804b1-43f0e5dda3amr3887995e9.10.1744051628234;
        Mon, 07 Apr 2025 11:47:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoxrz4ei+DXosqWzgao7dK96K/l6U6i65+y/ivjaRH7Ta49V5vdaM73ev46no2rFzSjgaBYw==
X-Received: by 2002:a05:600c:4f52:b0:43b:c6a7:ac60 with SMTP id 5b1f17b1804b1-43f0e5dda3amr3887825e9.10.1744051627840;
        Mon, 07 Apr 2025 11:47:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec1795db7sm145047515e9.25.2025.04.07.11.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 11:47:07 -0700 (PDT)
Message-ID: <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>
Date: Mon, 7 Apr 2025 20:47:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: Daniel Verkamp <dverkamp@chromium.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
 <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> Heh, but that one said:
>>>
>>> +\item[ VIRTIO_BALLOON_F_WS_REPORTING(6) ] The device has support for
>>> Working Set
>>>
>>> Which does not seem to reflect reality ...
> 
> Please feel free to disregard these features and reuse their bits and
> queue indexes; as far as I know, they are not actually enabled
> anywhere currently and the corresponding guest patches were only
> applied to some (no-longer-used) ChromeOS kernel trees, so the
> compatibility impact should be minimal. I will also try to clean up
> the leftover bits on the crosvm side just to clear things up.

Thanks for your reply, and thanks for clarifying+cleaning it up.

> 
>> I dug a bit more into cross-vm, because that one seems to be the only
>> one out there that does not behave like everybody else I found (maybe good,
>> maybe bad :) ).
>>
>>
>> 1) There was temporarily even another feature (VIRTIO_BALLOON_F_EVENTS_VQ)
>> and another queue.
>>
>> It got removed from cross-vm in:
>>
>> commit 9ba634b82b55ba762dc8724676b2cf9419460145
>> Author: Daniel Verkamp <dverkamp@chromium.org>
>> Date:   Thu Jul 11 11:29:52 2024 -0700
>>
>>       devices: virtio-balloon: remove event queue support
>>
>>       VIRTIO_BALLOON_F_EVENTS_VQ was part of a proposed virtio spec change.
>>
>>       It is not currently supported by upstream Linux, so removing this should
>>       have no effect except for guest kernels that had CHROMIUM patches
>>       applied.
>>
>>       The virtqueue indexes for the ws-related queues are decremented to fill
>>       the hole left by the removal of the event VQ; these are non-standard as
>>       well, so they do not have virtqueue indexes assigned in the virtio spec,
>>       but the proposed spec extension did actually use vq indexes 5 and 6.
>>
>>       BUG=b:214864326
>>
>>
>> 2) cross-vm is aware of the upstream Linux driver
>>
>> They thought your fix would go upstream; it didn't.
>>
>> commit a2fa119e759d0238a42ff15a9aff0dfd122afebd
>> Author: Daniel Verkamp <dverkamp@chromium.org>
>> Date:   Wed Jul 10 16:16:28 2024 -0700
>>
>>       devices: virtio-balloon: warn about queue index mismatches
>>
>>       The Linux kernel virtio-balloon driver spec non-compliance related to
>>       queue numbering is being fixed; add some diagnostics to our device that
>>       help to check if everything is working as expected.
>>
>>       <https://lore.kernel.org/virtualization/CACGkMEsg0+vpav1Fo8JF1isq4Ef8t4_CFN1scyztDO8bXzRLBQ@mail.gmail.com/T/>
>>
>>       Additionally, replace the num_expected_queues() function with per-queue
>>       checking to avoid the need for the duplicate feature checks and queue
>>       count calculation; each pop_queue() call will be checked using the `?`
>>       operator and return a more useful error message if a particular queue is
>>       missing.
>>
>>       BUG=None
>>       TEST=crosvm run --balloon-page-reporting ...
>>
>>
>> IIRC, in that commit they switched to the "spec" behavior.
>>
>> That's when they started hard-coding the queue indexes.
>>
>> CCing Daniel. All Linux versions should be incompatible with cross-vmm regarding free page reporting.
>> How is that handled?
> 
> In practice, it only works because nobody calls crosvm with
> --balloon-page-reporting (it's off by default), so the balloon device
> does not advertise the VIRTIO_BALLOON_F_PAGE_REPORTING feature.
> 
> (I just went searching now, and it does seem like there is actually
> one user in Android that does try to enable page reporting[1], which
> I'll have to look into...)
> 
> In my opinion, it makes the most sense to keep the spec as it is and
> change QEMU and the kernel to match, but obviously that's not trivial
> to do in a way that doesn't break existing devices and drivers.

If only it would be limited to QEMU and Linux ... :)

Out of curiosity, assuming we'd make the spec match the current 
QEMU/Linux implementation at least for the 3 involved features only, 
would there be a way to adjust crossvm without any disruption?

I still have the feeling that it will be rather hard to get that all 
implementations match the spec ... For new features+queues it will be 
easy to force the usage of fixed virtqueue numbers, but for 
free-page-hinting and reporting, it's a mess :(

-- 
Cheers,

David / dhildenb



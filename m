Return-Path: <kvm+bounces-4307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86455810CAA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95B1B20C8F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CD81EB45;
	Wed, 13 Dec 2023 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A07qou8z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A8DC
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 00:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702457018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ypvU2CFpvjA4GuEgMA1XFzF02HXPcVncJHhzWckfAo=;
	b=A07qou8zhN6INiRcZo6Jts8WashAl5Jg07IQHHatmwFCJPqJWiHlCbGsya6DH2IBb0WvGX
	OoRfwAHiVD4WZCF+4VCQanrhJfEN8dRQmx1LJFzOcYXV4iWyTEX4eg2KZ+0ltjWEHAfcm4
	PAHkFbg8YdslPsD7iEErztnLy+zIgbM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-X3FQWZc5PSWKydNC9KIcYw-1; Wed, 13 Dec 2023 03:43:37 -0500
X-MC-Unique: X3FQWZc5PSWKydNC9KIcYw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40c42205ed0so25072765e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 00:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702457016; x=1703061816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ypvU2CFpvjA4GuEgMA1XFzF02HXPcVncJHhzWckfAo=;
        b=qAwuvotYYfcvGr2OZfIgC7hz+rNqJqHVVnZ6hwSJwj7+93WNwhmTLizrV/RP8uYPnD
         GdDURroanhs3pZ7LHQXs8VwgG/CiXS7bZqsxUCHu7/N4beg8I6PuMdkTMy/9wqEDoeHN
         6hzTEAmhac7V0gC6Hqn25/RhNy4H7Fy8VgnAFUXJ5s/P4CfebDBm0liL/vVvQvGnpIHn
         zSX+7HEN63DoxTn7YnFx9y+wR+7xxJ6ZVDMSHP0pG4h/rMxg1sgc1k8ycO20iPalgCwQ
         AGU0xvK6+Em7RaLRaRP4FnxRpTQKhlsrpD+S0YtseBrsT9A0ahtKK+sCd+kOtuzDiRMF
         +4uw==
X-Gm-Message-State: AOJu0YyL35khNcEkVzw1uDAcnxGi2BOfUuwcG2YuT+35TcqFU5lGntfx
	rQh3L6ntIUkLvWON01iNmiX9fEpxCR4q7V4YiaDAyOCHEzSD7kdd1RwXpd6lMERZlYEYORkAcPT
	oN8WGzJFBV5Qm
X-Received: by 2002:a05:600c:401:b0:40c:26ef:b24b with SMTP id q1-20020a05600c040100b0040c26efb24bmr3913391wmb.188.1702457015949;
        Wed, 13 Dec 2023 00:43:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1lQ4+EUeiLIk83v4dqAAgqvxh6iPVGvNgRE5vCofRk3mqgAvKUjUC7mCTX0q96Nl9r/GPpQ==
X-Received: by 2002:a05:600c:401:b0:40c:26ef:b24b with SMTP id q1-20020a05600c040100b0040c26efb24bmr3913382wmb.188.1702457015584;
        Wed, 13 Dec 2023 00:43:35 -0800 (PST)
Received: from sgarzare-redhat ([5.179.184.12])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c1c1100b0040b48690c49sm19575443wms.6.2023.12.13.00.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 00:43:35 -0800 (PST)
Date: Wed, 13 Dec 2023 09:43:29 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v8 0/4] send credit update during setting
 SO_RCVLOWAT
Message-ID: <ucmekzurgt3zcaezzdkk6277ukjmwaoy6kdq6tzivbtqd4d32b@izqbcsixgngk>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231212105423-mutt-send-email-mst@kernel.org>
 <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>
 <20231212111131-mutt-send-email-mst@kernel.org>
 <7b362aef-6774-0e08-81e9-0a6f7f616290@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7b362aef-6774-0e08-81e9-0a6f7f616290@salutedevices.com>

On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>
>
>On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>> Hello,
>>>>>
>>>>>                                DESCRIPTION
>>>>>
>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>
>>>>
>>>> Patchset:
>>>>
>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>
>>> Thanks!
>>>
>>>>
>>>>
>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>
>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>> have strong opinion. I guess @Stefano knows better.
>>>
>>> Thanks, Arseniy
>>
>> Fixes means "if you have that other commit then you need this commit
>> too". I think as a minimum you need to rearrange patches to make the
>> fix go in first. We don't want a regression followed by a fix.
>
>I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, 
>because this
>patch fixes problem that is not related with the new patches from this patchset.

I agree, patch 3 is for sure net material (I'm fine with both 
rearrangement or send it separately), but IMHO also patch 2 could be.
I think with the same fixes tag, since before commit b89d882dc9fc 
("vsock/virtio: reduce credit update messages") we sent a credit update
for every bytes we read, so we should not have this problem, right?

So, maybe all the series could be "net".

Thanks,
Stefano



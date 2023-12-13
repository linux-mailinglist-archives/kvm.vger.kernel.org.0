Return-Path: <kvm+bounces-4311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A47810D8E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A72F71F211AA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FEB210F2;
	Wed, 13 Dec 2023 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAAq0JUl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A8EA4
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 01:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702460518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMjiM4LhWNswCgPTt5l6t+VxQtdI2J7qu3AHHUQiHmI=;
	b=EAAq0JUlKUfVWvPLenjn2li3RJHfT822xN7HFRCB+LuPc55382fXypRrFLG3BYGmmRTnGG
	EL49PlqBpcEQsDJ6+LnhEUb8fx4MPdw0xYdOw6dULuD2HeKMv80a4Ho3T3Sm7HZ6dXRm9f
	gADLgPvoaxby8Hid16UYzjVd243ssmE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-pni7KFfwM_WjzAncVPuQ1Q-1; Wed, 13 Dec 2023 04:41:57 -0500
X-MC-Unique: pni7KFfwM_WjzAncVPuQ1Q-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50be5bdae9fso5271085e87.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 01:41:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702460515; x=1703065315;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMjiM4LhWNswCgPTt5l6t+VxQtdI2J7qu3AHHUQiHmI=;
        b=tiJ46PUnI1H9SuTPa2kHvnDWBm8BH7QY6K/Dp7pEVm+XkoTVwFNOMoZ3N7Sxt/0mNB
         D9YQjGY1kcnO3gL7WgzGIJEaLMIZj69DoxYTqCLTRjyPUQ4TaLxKtI27xiaPzSwXLgwD
         wnwVTDfZvPjDhiN5FxaO5jrHECWNJU8tf4pHK1b7bZg4jKLMPKvPe6TrvUoITKfj65gC
         j+U34jotU5fHrMdSAM4Abkq3Eg4EB7QrrTj3F4Nd1i7XgaZ07/r+/rwVcpuQ8HRmMaLj
         NBAlvIOlSteh8u6al+tdsDVk2P32zS7hud1iMAAuHrJOCbWz8+zMRJFceoWjzTrYN2OU
         yg4w==
X-Gm-Message-State: AOJu0YxUPRaEeWlaElc0FMbVId/UmiNBDEXk/SncbUxAtkXNImYA0P1/
	QQ7G3plgCmJ4yhoPZy1scjmLaoQvirYmPvl4cNpbqB0tZdVJilNul5U5urPGnYMlvvRUQZyYLqV
	l2W93/LGy7N4/
X-Received: by 2002:a05:6512:3eb:b0:50b:e5bf:cd08 with SMTP id n11-20020a05651203eb00b0050be5bfcd08mr2969681lfq.0.1702460515799;
        Wed, 13 Dec 2023 01:41:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWUHETsBer3EAOA0gPfl7B0VS0WtqWT/aW1HbYvhGOGQYIsmV3HSuvb3hi939lrTpgrAbrSA==
X-Received: by 2002:a05:6512:3eb:b0:50b:e5bf:cd08 with SMTP id n11-20020a05651203eb00b0050be5bfcd08mr2969675lfq.0.1702460515420;
        Wed, 13 Dec 2023 01:41:55 -0800 (PST)
Received: from sgarzare-redhat ([5.179.184.12])
        by smtp.gmail.com with ESMTPSA id e4-20020a5d65c4000000b003333ed23356sm12977633wrw.4.2023.12.13.01.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 01:41:54 -0800 (PST)
Date: Wed, 13 Dec 2023 10:41:47 +0100
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
Message-ID: <msexilrot3dmvzrsn25zfwmcnbxpsmiuuvktzbnirq34udk6as@pdz6yt4rrjvo>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231212105423-mutt-send-email-mst@kernel.org>
 <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>
 <20231212111131-mutt-send-email-mst@kernel.org>
 <7b362aef-6774-0e08-81e9-0a6f7f616290@salutedevices.com>
 <ucmekzurgt3zcaezzdkk6277ukjmwaoy6kdq6tzivbtqd4d32b@izqbcsixgngk>
 <402ea723-d154-45c9-1efe-b0022d9ea95a@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <402ea723-d154-45c9-1efe-b0022d9ea95a@salutedevices.com>

On Wed, Dec 13, 2023 at 12:08:27PM +0300, Arseniy Krasnov wrote:
>
>
>On 13.12.2023 11:43, Stefano Garzarella wrote:
>> On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>>>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>>>
>>>>>
>>>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>>                                DESCRIPTION
>>>>>>>
>>>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>>>
>>>>>>
>>>>>> Patchset:
>>>>>>
>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>
>>>>> Thanks!
>>>>>
>>>>>>
>>>>>>
>>>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>>>
>>>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>>>> have strong opinion. I guess @Stefano knows better.
>>>>>
>>>>> Thanks, Arseniy
>>>>
>>>> Fixes means "if you have that other commit then you need this commit
>>>> too". I think as a minimum you need to rearrange patches to make the
>>>> fix go in first. We don't want a regression followed by a fix.
>>>
>>> I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, because this
>>> patch fixes problem that is not related with the new patches from this patchset.
>>
>> I agree, patch 3 is for sure net material (I'm fine with both rearrangement or send it separately), but IMHO also patch 2 could be.
>> I think with the same fixes tag, since before commit b89d882dc9fc ("vsock/virtio: reduce credit update messages") we sent a credit update
>> for every bytes we read, so we should not have this problem, right?
>
>Agree for 2, so I think I can rearrange: two fixes go first, then current 0001, and then tests. And send it as V9 for 'net' only ?

Maybe you can add this to patch 1 if we want it on net:

Fixes: e38f22c860ed ("vsock: SO_RCVLOWAT transport set callback")

Then I think that patch should go before patch 2, so we don't need to
touch that code multiple times.

so, IMHO the order should be the actual order or 3 - 1 - 2 - 4.

Another option is to send just 2 & 3 to net, and the rest (1 & 4) to 
net-next. IMHO should be fine to send the entire series to net with the 
fixes tag also in patch 1.

Net maintainers and Michael might have a different advice.

Thanks,
Stefano



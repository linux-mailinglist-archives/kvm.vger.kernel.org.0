Return-Path: <kvm+bounces-4447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3886812A9B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34F5E28133E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADF72421D;
	Thu, 14 Dec 2023 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8xrOQDc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4261B116
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 00:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702543542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uecrAR2SvWDsLJrH3uSpDFiFSpzellwPNoFaP7Q0oHU=;
	b=N8xrOQDcZ9Od6WUoOj9he4irq+RLKGUXhgdgJTI/2elcM576OMBNLpWMbfeRQYg8zNhSb9
	Ub9JiREyfEKPAYwQxqiK6lzpJCBQNAja0EqtBAKMJ9JffXxw64Si3a3Cc+Dam+dg1jBzsc
	yo7ilL0MbdjmBrSo+LaIwd97Eop6YCA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-EwfkhP7XM2yU7HyBw5kV3A-1; Thu, 14 Dec 2023 03:45:39 -0500
X-MC-Unique: EwfkhP7XM2yU7HyBw5kV3A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40c4a824c4bso26750155e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 00:45:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702543538; x=1703148338;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uecrAR2SvWDsLJrH3uSpDFiFSpzellwPNoFaP7Q0oHU=;
        b=JuR3OC5arLYi2OkGn7okjLmuO03N+YJamXKpJVshtBcwW8Q3Kn3VLvyhGiAPK+0mX0
         GH3VHQs8JEfv5T/evhMb3oN5Z2lOLGbRWTh4YPk64vFYVYX4msfCdjU7EiXzF7+FwkOG
         aV0u0r9NwyLmGzmyw2Px3Kv1LaDG/4P58AU+Zs0FJdhbhHfBfzMM9M3XoDzg5j3UJMDz
         hjyM1tV1mtdSsRp+6HzgmDoAcJq0c4ihYVDV/4MRXsA6L2sfcTG16HZOmSKUQSysLc+p
         rc2pSM/AFJ+j8WtrgNCypTIK26zjHKiG4E7ebAJF82ruYKytwB0HctI+DTZQzNKhShbz
         zNYw==
X-Gm-Message-State: AOJu0YyxxrTL8dlFIPIE8J/IaSUme0ItbFDjT6vjj6tu2uXdV0yWf5+q
	vEFJB/3Lp4PGtemy2sEZBbC2BbLqBwc8Wcm4Dmn8bjp+mnaMgKgdsS1H5qFGjR6O/s7Zq7CyMsH
	EBWLG2W1PvZbf
X-Received: by 2002:a05:600c:246:b0:409:637b:890d with SMTP id 6-20020a05600c024600b00409637b890dmr4662198wmj.2.1702543538706;
        Thu, 14 Dec 2023 00:45:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEd9LpPd9LlR4EdQvDKYuR630GgNDCt0NG+pjD6dcylIDtVJwCEubGxS9oHa85KaPw5yjKlKA==
X-Received: by 2002:a05:600c:246:b0:409:637b:890d with SMTP id 6-20020a05600c024600b00409637b890dmr4662193wmj.2.1702543538360;
        Thu, 14 Dec 2023 00:45:38 -0800 (PST)
Received: from sgarzare-redhat ([5.11.101.217])
        by smtp.gmail.com with ESMTPSA id dd14-20020a0560001e8e00b003364277e714sm2802139wrb.89.2023.12.14.00.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 00:45:37 -0800 (PST)
Date: Thu, 14 Dec 2023 09:45:33 +0100
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
Message-ID: <gu2yvaqqgrfnffnh67fodsoob4cdpcw4zaifncku3qvadtuq5j@6unpf5ifdmtd>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231212105423-mutt-send-email-mst@kernel.org>
 <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>
 <20231212111131-mutt-send-email-mst@kernel.org>
 <7b362aef-6774-0e08-81e9-0a6f7f616290@salutedevices.com>
 <ucmekzurgt3zcaezzdkk6277ukjmwaoy6kdq6tzivbtqd4d32b@izqbcsixgngk>
 <402ea723-d154-45c9-1efe-b0022d9ea95a@salutedevices.com>
 <20231213100518-mutt-send-email-mst@kernel.org>
 <20231213100957-mutt-send-email-mst@kernel.org>
 <8e6b06a5-eeb3-84c8-c6df-a8b81b596295@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e6b06a5-eeb3-84c8-c6df-a8b81b596295@salutedevices.com>

On Wed, Dec 13, 2023 at 08:11:57PM +0300, Arseniy Krasnov wrote:
>
>
>On 13.12.2023 18:13, Michael S. Tsirkin wrote:
>> On Wed, Dec 13, 2023 at 10:05:44AM -0500, Michael S. Tsirkin wrote:
>>> On Wed, Dec 13, 2023 at 12:08:27PM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 13.12.2023 11:43, Stefano Garzarella wrote:
>>>>> On Tue, Dec 12, 2023 at 08:43:07PM +0300, Arseniy Krasnov wrote:
>>>>>>
>>>>>>
>>>>>> On 12.12.2023 19:12, Michael S. Tsirkin wrote:
>>>>>>> On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>>>>>>>> On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
>>>>>>>>>> Hello,
>>>>>>>>>>
>>>>>>>>>>                                DESCRIPTION
>>>>>>>>>>
>>>>>>>>>> This patchset fixes old problem with hungup of both rx/tx sides and adds
>>>>>>>>>> test for it. This happens due to non-default SO_RCVLOWAT value and
>>>>>>>>>> deferred credit update in virtio/vsock. Link to previous old patchset:
>>>>>>>>>> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Patchset:
>>>>>>>>>
>>>>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> But I worry whether we actually need 3/8 in net not in net-next.
>>>>>>>>
>>>>>>>> Because of "Fixes" tag ? I think this problem is not critical and reproducible
>>>>>>>> only in special cases, but i'm not familiar with netdev process so good, so I don't
>>>>>>>> have strong opinion. I guess @Stefano knows better.
>>>>>>>>
>>>>>>>> Thanks, Arseniy
>>>>>>>
>>>>>>> Fixes means "if you have that other commit then you need this commit
>>>>>>> too". I think as a minimum you need to rearrange patches to make the
>>>>>>> fix go in first. We don't want a regression followed by a fix.
>>>>>>
>>>>>> I see, ok, @Stefano WDYT? I think rearrange doesn't break anything, because this
>>>>>> patch fixes problem that is not related with the new patches from this patchset.
>>>>>
>>>>> I agree, patch 3 is for sure net material (I'm fine with both rearrangement or send it separately), but IMHO also patch 2 could be.
>>>>> I think with the same fixes tag, since before commit b89d882dc9fc ("vsock/virtio: reduce credit update messages") we sent a credit update
>>>>> for every bytes we read, so we should not have this problem, right?
>>>>
>>>> Agree for 2, so I think I can rearrange: two fixes go first, then current 0001, and then tests. And send it as V9 for 'net' only ?
>>>>
>>>> Thanks, Arseniy
>>>
>>>
>>> hmm why not net-next?
>>
>> Oh I missed your previous discussion. I think everything in net-next is
>> safer.  Having said that, I won't nack it net, either.
>
>So, summarizing all above:
>1) This patchset entirely goes to net-next as v9
>2) I reorder patches like 3 - 2 - 1 - 4, e.g. two fixes goes first with Fixes tag
>3) Add Acked-by: Michael S. Tsirkin <mst@redhat.com> to each patch
>
>@Michael, @Stefano ?

Okay, let's do that ;-)

Stefano



Return-Path: <kvm+bounces-50497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE0AAE67CD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03BC617CA64
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859592D1900;
	Tue, 24 Jun 2025 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhr4Jl20"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1260F27C179
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773953; cv=none; b=UYrozZB1YmChV3/8wA1/mN4L3fLw1Yj+OCQ3ffun+NB1O1L4g9GOcAtMC3Pmt1FMYrzoAXYW3WaqjZ2PoYIC9Jt4WrCMneQAG4FXeSQEefcsrbCscGRZhE49e9XucH+6cBjU9kbxzITQ9UdY1RVm3RvHvJ8OFNIvW6o0H6O/Neg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773953; c=relaxed/simple;
	bh=ShTqc7z0FpK2/U8YVqk2gMmafxHT4PEfEtsONZW/Zjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQ5NuLOaUlihmr6yr9mByjILbbmRqYoRA2PRXzFETdgMtdt1Dwe/2MlxlLkSBLXvwUFwinyhbB70nBoHkQAkKBSxZZKMEao2poCVICigU9znec2twlGT3otg72KLIs+A0epTwqJiP1RRfdWiy9EbqpB3dkMZAZRgfLx90eVP3Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hhr4Jl20; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750773951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D+TKbeGRcKoBZxXH6jFI/Y3rhb44odXuWUwrtNDdL2o=;
	b=hhr4Jl20Npy3QnyPdb8t3exYHPyyyFJlAWiI9vsTPAhPetHw7sMi8Ng03ovtGWJ/M6iTKd
	gw6yKhHtWxJxcjg3+D/G1KyPtLWfGNx5vHieiZrco8yAPh5158keadVBqL1U5cuGlop8PE
	gaSakWC99tLEDGRKdhzo27NZlgkJJRo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-Uc6lp7XtO-q-0iV72qyRPg-1; Tue, 24 Jun 2025 10:05:49 -0400
X-MC-Unique: Uc6lp7XtO-q-0iV72qyRPg-1
X-Mimecast-MFC-AGG-ID: Uc6lp7XtO-q-0iV72qyRPg_1750773948
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a50816cc58so246264f8f.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773948; x=1751378748;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+TKbeGRcKoBZxXH6jFI/Y3rhb44odXuWUwrtNDdL2o=;
        b=jlgrB/PGSJpmrIQtfeOLbEVraKw6+39tE1gdE+juC1y73sioxravNf8tB2hL9R8Z2F
         dNIfa1lx/olYimwjLxYm3vsT+hdktOoYtxF/YRGJXnmsc1EePotTv3a49x6FacuaY8um
         RY+XmIejAW5UvOOyXjY7830v9jKoUZPKhSmoxpZS2IfePMAv7Mpmdu8iGOIc+owuQ3yT
         sViZ+u/KBYpMbBf+cfFV06nVhAS26Caoh6GXgalN7PGeMtRd3fDvBokorEHnbud855c0
         Y2HKZ5qIw6vjoc4cbmIYmev1sd3JaMsVRRjyPBxRumLucrROjAf7EpyHTR1vv/N5ll5U
         Y5PA==
X-Forwarded-Encrypted: i=1; AJvYcCUlkDkT0Qh7j2ZtoX4Fg43mTTPp/Df/iG2EXPOUi6vU8MSiUKTBR+qM+K3OWvajX/7XUBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaMR6RlIcJja1cSXR98ENsSdd7xcEPCsQ84jxA2xc+a4Q9iCE4
	60FbovTmmPGxyjYLzNd4Hrve7XbctvxbzDnvH4s2rM+Mk9UrSCxVTztEU2L6gacmewQmKKGhdTK
	LEIl9BqV94/LJmpB0z1luoHKpbcp3em1VijxoOoJSzOwID5TiW5gT0A==
X-Gm-Gg: ASbGncuKpKTqyGDX5J9AXaCnSJQ5FnZPfduQQ/9kLpmtEs12+lG1VstO5XVK/ZiRmn5
	njy9sy1Z1uuX4wgSbVArfDZVN7lIWoK8iTQZq1P8JSkOJOC+q6VJ0EesXe0JsesZRnavCPwDMD6
	Agu8A6dzDpH/4W9K4uP0R3s8kIgsbkHsTHYodNK3qQxDfqV0NnXIZKkDQzPZ4idIltb/bWN+Ywt
	7Z5PVVxPj+/QKq+iiqDjK3LVx5uYB0BOX0ivSIVWvqCsR9qwDSpPC/EK2Lqvhu7ctHSOX0FSJAp
	8T8houh5vUtGvDWdrm++JrnUfbRG5Q==
X-Received: by 2002:a05:6000:144e:b0:3a4:f520:8bfc with SMTP id ffacd0b85a97d-3a6d1322c05mr14142475f8f.36.1750773945773;
        Tue, 24 Jun 2025 07:05:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErDuslqfWPmZ/xGGypV3ktOS9Nn3dYluWljaHpFoweUHaB+FTxcneVu21gRhwulUWipnA3OA==
X-Received: by 2002:a05:6000:144e:b0:3a4:f520:8bfc with SMTP id ffacd0b85a97d-3a6d1322c05mr14142006f8f.36.1750773940575;
        Tue, 24 Jun 2025 07:05:40 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2445:d510::f39? ([2a0d:3344:2445:d510::f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8106a69sm2015375f8f.79.2025.06.24.07.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 07:05:40 -0700 (PDT)
Message-ID: <6ebf5a0a-f13a-43c4-8e42-ba4743e7e417@redhat.com>
Date: Tue, 24 Jun 2025 16:05:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/2] vhost-net: reduce one userspace copy when
 building XDP buff
To: Jason Wang <jasowang@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, davem@davemloft.net,
 andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org
References: <20250612083213.2704-1-jasowang@redhat.com>
 <20250612083213.2704-2-jasowang@redhat.com>
 <684b89de38e3_dcc452944e@willemb.c.googlers.com.notmuch>
 <CACGkMEsKTLfD1nz-CQdn5+ZmxyWdVDwhBOAcB9fO4TUcwzuLPA@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CACGkMEsKTLfD1nz-CQdn5+ZmxyWdVDwhBOAcB9fO4TUcwzuLPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/16/25 5:01 AM, Jason Wang wrote:
> On Fri, Jun 13, 2025 at 10:16 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> Jason Wang wrote:
>>> We used to do twice copy_from_iter() to copy virtio-net and packet
>>> separately. This introduce overheads for userspace access hardening as
>>> well as SMAP (for x86 it's stac/clac). So this patch tries to use one
>>> copy_from_iter() to copy them once and move the virtio-net header
>>> afterwards to reduce overheads.
>>>
>>> Testpmd + vhost_net shows 10% improvement from 5.45Mpps to 6.0Mpps.
>>>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>
>> Acked-by: Willem de Bruijn <willemb@google.com>
>>
>>> ---
>>>  drivers/vhost/net.c | 13 ++++---------
>>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>> index 777eb6193985..2845e0a473ea 100644
>>> --- a/drivers/vhost/net.c
>>> +++ b/drivers/vhost/net.c
>>> @@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>>>       if (unlikely(!buf))
>>>               return -ENOMEM;
>>>
>>> -     copied = copy_from_iter(buf, sock_hlen, from);
>>> -     if (copied != sock_hlen) {
>>> +     copied = copy_from_iter(buf + pad - sock_hlen, len, from);
>>> +     if (copied != len) {
>>>               ret = -EFAULT;
>>>               goto err;
>>>       }
>>>
>>> -     gso = buf;
>>> +     gso = buf + pad - sock_hlen;
>>>
>>>       if (!sock_hlen)
>>>               memset(buf, 0, pad);
>>> @@ -715,12 +715,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>>>               }
>>>       }
>>>
>>> -     len -= sock_hlen;
>>> -     copied = copy_from_iter(buf + pad, len, from);
>>> -     if (copied != len) {
>>> -             ret = -EFAULT;
>>> -             goto err;
>>> -     }
>>> +     memcpy(buf, buf + pad - sock_hlen, sock_hlen);
>>
>> It's not trivial to see that the dst and src do not overlap, and does
>> does not need memmove.
>>
>> Minimal pad that I can find is 32B and and maximal sock_hlen is 12B.
>>
>> So this is safe. But not obviously so. Unfortunately, these offsets
>> are not all known at compile time, so a BUILD_BUG_ON is not possible.
> 
> We had this:
> 
> int pad = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + headroom + nvq->sock_hlen);
> int sock_hlen = nvq->sock_hlen;
> 
> So pad - sock_len is guaranteed to be greater than zero.
> 
> If this is not obvious, I can add a comment in the next version.

The relevant initializations are not visible in the patch itself, so I
think either a comment in the code or in the commit message would be useful.

Thanks,

Paolo



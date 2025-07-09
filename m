Return-Path: <kvm+bounces-51900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE02AFE376
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4488D7AE5F5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A7328313B;
	Wed,  9 Jul 2025 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdcyfnAd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7B5284B27
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752051745; cv=none; b=SLUy8hyU/cdZ7qpFz4FXj5TzvcJ1IFWKlD6GV0Znye+QhXlLfDGNF9+m8YtyNZLs+dxeVamXfAqMxGWZjp/9l4/5zhNgWROStVdDp6fIJVI34GiGSY+eAZSlEmT2Q7PMK9BB8SgG6UXfcUFdLXXmcq8MMyqAvFY9tK3KaaOdvlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752051745; c=relaxed/simple;
	bh=/J0ESgh0mnZJh7VIVascAzPB03YG2Nks06BWwBkQ7wA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FoAGFDHJT4cXuI1P7f1DG48LWl6pP9eL6nSzyFUgcXTVhFnTJRgLhPmH6aEZ8zEG+UyAZsh+jmU2Z+0YEbQtH0WmlL21WuZGD44fjXdIL0OyvPECs+QI+p+qZGNjAJrSSdKGcedT+yljELd1IfEH7F66hQmlYs7Df63S3NiNLgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdcyfnAd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752051742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gP/GXbkE1NcvqZ2RDyr5+g96OSyeyTW+E8pt68Nv348=;
	b=cdcyfnAdDecCXP6N7ALPN6Wnh2huithZFmn3G9SCyLW9xrKhmyBUZpVSgTD+1hVKaG2Soh
	T9l3Vbyh42064+Ux/Vb7pR5wiFb5XOFlVSW6PBMnccdf7E5SJaFuicVVeNY6Ppq3oNa921
	DEhlpEAoG41kCXKtvKe9Gioh7hLVeOY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-VUEqVGgWO1OsPMraIU32kQ-1; Wed, 09 Jul 2025 05:02:21 -0400
X-MC-Unique: VUEqVGgWO1OsPMraIU32kQ-1
X-Mimecast-MFC-AGG-ID: VUEqVGgWO1OsPMraIU32kQ_1752051740
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3af3c860ed7so2431779f8f.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 02:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752051740; x=1752656540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gP/GXbkE1NcvqZ2RDyr5+g96OSyeyTW+E8pt68Nv348=;
        b=H8VC5AW88fiP5qIJEU+cLZIK4emeO2LjWWKQmzI+9MZ81e784D9/ZBlOjHhNU3yM/c
         GwlJ2Q2Spc0JSRdFK1bPOlHqN48RELZG53r6ggPuUZ50xAah1uMM/FoeuX9qxfyxrv90
         gXeYt3QzR21y960Sfkq2e/ySHFlTRqKwvgLxYbG+vNEkupHPkcnqNFnsYXKlpcFEcU9t
         GCyYIT67f6ij0flTsHy3Qab0OG0VXzf07DeLDYWjbmZDyp885nozsdISc9FVP85L46Hf
         D58RsQp1ytAiyoouR1SHH3RXh1al11K1/IGQJTQJ5f8uThrIxc7CQTjgccmuq+Ccftlt
         8taw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ/6zElDS9uj82zzX74FPftn5w3sgfiJKhU15K1QvPeTumi2Rqup3A1T6XI9QX/Z3xEKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0DucbEun0FR3QphfU/DtQO8HD4i2qSg3DqCENIqODGM6nIBX4
	mpzDgKtQ73lpKKpFtTb/5RqEjk4vDL1ZEIFvlDWuYc3kQcHqh/iZKd+65x7fhc38fHKlmeWUS3E
	5gpU0Pd6vCCa4/dbtTi5jegh8lr/dlNsrQBgrk1KmPBdonXqPzGF4BQ==
X-Gm-Gg: ASbGncvbfpEIcpqnyuramug+aKbnTmlYdnHv3A4zd3V1qsvTvTeWt7FP0jrmZogjV0i
	lf4bmNoNLqecXvOn40tYqCR31VAKW4kjpxo+1mvX//Zk1uFHdDjtkrzN8/6O3XQvUJWflyybJtl
	1WgEZXK4QFc2I7oGZlHhaXeXuREnraTmp6yQE4EEsHycNOzQNlO3I/b8F/+zg92KG33Vu6yc9PF
	xH7MpuixfPBLAY0c8r9MPY5ugEz9Ommq9QAPZUf1kqH17vfEng9xrK/3DCBuHjp9SMjuCYG5MAN
	W7r+qvMo08/twdQfPpJY3sCtperZ159zvhXsYmy5mOgL/NKCaCGlIAYxkNpcfG/tibnCnw==
X-Received: by 2002:a05:6000:401e:b0:3a4:dd16:a26d with SMTP id ffacd0b85a97d-3b5e4557000mr1138909f8f.38.1752051739632;
        Wed, 09 Jul 2025 02:02:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw4zbfGS21uIVcbjgAQJWRQweoo04GUYIyOc9k/VYy3AR2hTTjemFRoGraFLo8yVdWPnB2Pw==
X-Received: by 2002:a05:6000:401e:b0:3a4:dd16:a26d with SMTP id ffacd0b85a97d-3b5e4557000mr1138868f8f.38.1752051739120;
        Wed, 09 Jul 2025 02:02:19 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:271f:bc10:144e:d87a:be22:d005? ([2a0d:3344:271f:bc10:144e:d87a:be22:d005])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47030ba29sm14962982f8f.2.2025.07.09.02.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 02:02:18 -0700 (PDT)
Message-ID: <cc4d09e8-d11a-4188-9f80-3ac7bb6e89e9@redhat.com>
Date: Wed, 9 Jul 2025 11:02:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
To: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
 <20250708120014-mutt-send-email-mst@kernel.org>
 <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
 <20250708142248-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250708142248-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/25 8:23 PM, Michael S. Tsirkin wrote:
> On Tue, Jul 08, 2025 at 06:43:17PM +0200, Paolo Abeni wrote:
>> On 7/8/25 6:00 PM, Michael S. Tsirkin wrote:
>>> On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
>>>> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
>>>>>> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
>>>>>>
>>>>>> The first 5 patches in this series, that is, the virtio features
>>>>>> extension bits are also available at [2]:
>>>>>>
>>>>>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
>>>>>>
>>>>>> Ideally the virtio features extension bit should go via the virtio tree
>>>>>> and the virtio_net/tun patches via the net-next tree. The latter have
>>>>>> a dependency in the first and will cause conflicts if merged via the
>>>>>> virtio tree, both when applied and at merge window time - inside Linus
>>>>>> tree.
>>>>>>
>>>>>> To avoid such conflicts and duplicate commits I think the net-next
>>>>>> could pull from [1], while the virtio tree could pull from [2].  
>>>>>
>>>>> Or I could just merge all of this in my tree, if that's ok
>>>>> with others?
>>>>
>>>> No strong preference here. My first choice would be a branch based
>>>> on v6.16-rc5 so we can all pull in and resolve the conflicts that
>>>> already exist. But I haven't looked how bad the conflicts would 
>>>> be for virtio if we did that. On net-next side they look manageable.
>>>
>>> OK, let's do it the way Paolo wants then.
>>
>> I actually messed a bit with my proposal, as I forgot I need to use a
>> common ancestor for the branches I shared.
>>
>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
>>
>> is based on current net-next and pulling from such tag will take a lot
>> of unwanted stuff into the vhost tree.
>>
>> @Michael: AFAICS the current vhost devel tree is based on top of
>> v6.15-rc7, am I correct?
> 
> Yes I'll rebase it soon.

I see you rebase on v6.16-rc5, thanks!

The whole series in now also available based on top of v6.16-rc5 here:

git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_08_07_2025

I'm not sending the above to netdev, as it will likely foul the bot and
the CI. Please LMK if you prefer otherwise.

With default config/strategy I can pull the above on top of the vhost
tree with no conflicts and auto merging.

Pulling on net-next will see a conflict in patch 8/9, file tun.c inside
tun_xdp_one(), and the resolution is as follow, which will yield the
code posted here:

https://lore.kernel.org/netdev/f076f2e1fa91041b15cf46efadc6708924afe8e0.1751874094.git.pabeni@redhat.com/

---
diff --cc drivers/net/tun.c
index 447c37959504,abc91f28dac4..49bcd12a4ac8
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@@ -2356,12 -2378,15 +2378,14 @@@ static int tun_xdp_one(struct tun_struc
                       struct tun_page *tpage)
  {
        unsigned int datasize = xdp->data_end - xdp->data;
 -      struct tun_xdp_hdr *hdr = xdp->data_hard_start;
 +      struct virtio_net_hdr *gso = xdp->data_hard_start;
+       struct virtio_net_hdr_v1_hash_tunnel *tnl_hdr;
 -      struct virtio_net_hdr *gso = &hdr->gso;
        struct bpf_prog *xdp_prog;
        struct sk_buff *skb = NULL;
        struct sk_buff_head *queue;
+       netdev_features_t features;
        u32 rxhash = 0, act;
 -      int buflen = hdr->buflen;
 +      int buflen = xdp->frame_sz;
        int metasize = 0;



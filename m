Return-Path: <kvm+bounces-34900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 898EBA071A7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73E913A5CEC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F0C2153F5;
	Thu,  9 Jan 2025 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="FQgZAh0A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4BD215176
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736415498; cv=none; b=sw/Xku6+wJWquNl4x+mLt3ft7jaGPQbX7JTlDFEuA6U1SrLclcJ/gqSQm3lZsyOkMk+QgxAt0c/NPXt2BDoZqk5DJl3fDl3yvNgID9Zq2nPCD4EBlq0wey8BJrGBpQLnU6/Xa82TxyzsugLmXijvu5FCsSgI+y7lC8xh9u3iuVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736415498; c=relaxed/simple;
	bh=Mf8o7lroOT1imCTt2bwlE12K0z806yPl+dcKb86wiOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TE4Aou7ArX9AhrNPGbqb+6Jd0ViJ8BWpDdA+lrhyM2RWuy8IlI/x8MoXQ5cHMaKDBBNIVagiMR/4K8kZ/Ko2/2YZhEk9DkeccMaZciFSIqnUk4tvF86UnxnYmULmiLeHpnMMyhC2bcGjgn+edPT/FR7UhmBx1fZa/noH58h4LSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=FQgZAh0A; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2164b662090so9722055ad.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 01:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736415496; x=1737020296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iX5Xv7vZXmp6Diw4dhkXM/NBpxHnqibMmwyNh801U+c=;
        b=FQgZAh0AaMVrQgZ8bguWTv62TPN4AXuQrBKi0vXwfZSilwTTsV3PU3zYVpJ5ZhNHqO
         ApT7x04fomqwmru9eysocHk5eBlWPiW1MjUqIeTpQQeBg1Q/sA9U2qP8ZmWUzQziiSek
         SHORWixaV3Rat0D98HXSI17BIGMBmLahXr3XQHbmuvirQCAq2kVP7jScJaiM+vQgM9UV
         D1Ark3iiW6P/Z7rCywAMzyr3MBs6c5YJV2Po/Vd9wayMTuXbI82hssme4h+Ap1EB6UYd
         UOd6KZkS63tDhP9DjJqeW7QZvr6qsLMl9Vm21nNwc///EgjEBfrSq60x3nN/xnsSq6FX
         1hDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736415496; x=1737020296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iX5Xv7vZXmp6Diw4dhkXM/NBpxHnqibMmwyNh801U+c=;
        b=LsakBfUt8s5awbhkUBRgnqR1e4qu2S+fBK8UX3+RHeakx1EE3CLPORgL0drIaThLOM
         A7Mvp8h2EqJLGvtAh80KFkmoksn1t1bTeK1koB1sE4ZAHKS8/YwU5wQu3OCthi0gETC9
         dymQdmj5TEj7CZxwD9L6PkizvE3vLA51JXIi23C7gkHQAPjAO1C7rbhUqn5SgMF4YEnA
         A6y6+YSvlTr5EJQrMmcz8gxq4AeMWq9q1fU/syq9OvsUrUNbyLQZ4DIAj1sjPpQmC+TL
         p8eQCOuHiMKdeJWW3t+w6f8hXEGegfrXeGHdTe3wozKzEiynWP1poez4GEpKW80YjP5Z
         h1ZA==
X-Forwarded-Encrypted: i=1; AJvYcCXPMK42f6tVro4OmeyBLMNRJMH/GZerF+BkSr6ua63scY+5NwGyuhyekHXDVwc5DLhTSHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQPFpbNt+cRjqb8VCvX25828y6D2RADfRcgrB2ZrMARL0L7MVQ
	/5yDOKfHJiGFlM+lU+GF/iV7ZDWo0P0c6UHqZ6omqi0J/Z/w85z1MBcs3Nzjitg=
X-Gm-Gg: ASbGnct2+aSeqDXOcZkiPwiji7Lx/xn/q+JDwCdJxVnrfxP44rethHFJMTN06M5utD5
	kU7hhoRjy8esubY1ALV1TMfgkgLcRorrQL0SLjDiDS06OGjctnwYBMPni72kD3FAAilp6/V+KCK
	BZUJ3dMhOWxMKBtBQkKRApBOr4TbWI5of+KjXQINgNFx6iI4Ux2B6Pk3ZVMI+XAM5Hz//B1nYHQ
	M8e8YDErqzBOMI6ot2vVMp2uwf49tlnPsqklEKSTVYIL/uYEyA1WzJR49hXXAGcwdE=
X-Google-Smtp-Source: AGHT+IE6uJuEESeHnIQxeeue01pEKjS62LqgqXa6Hf+8Q13I/VJgPMpbucR025bUQAgc88TrZ6Nz2A==
X-Received: by 2002:a17:903:1251:b0:215:9894:5670 with SMTP id d9443c01a7336-21a83f591cemr79565855ad.16.1736415496269;
        Thu, 09 Jan 2025 01:38:16 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a917687c0sm8556475ad.17.2025.01.09.01.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 01:38:15 -0800 (PST)
Message-ID: <ad580d7b-2bd1-401e-bb7b-b67ec943918f@daynix.com>
Date: Thu, 9 Jan 2025 18:38:10 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <20250109023144-mutt-send-email-mst@kernel.org>
 <20250109023829-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20250109023829-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/09 16:40, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2025 at 02:32:25AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Jan 09, 2025 at 03:58:45PM +0900, Akihiko Odaki wrote:
>>> The specification says the device MUST set num_buffers to 1 if
>>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>
>>
>> How do we know this is v1 and not v0? Confused.
> 
> Ah I got it, you assume userspace will over-write it
> if VIRTIO_NET_F_MRG_RXBUF is set.
> If we are leaving this up to userspace, why not let it do
> it always?

tun may be used with vhost_net, which does not set the field.

> 
>>> ---
>>>   drivers/net/tap.c      |  2 +-
>>>   drivers/net/tun.c      |  6 ++++--
>>>   drivers/net/tun_vnet.c | 14 +++++++++-----
>>>   drivers/net/tun_vnet.h |  4 ++--
>>>   4 files changed, 16 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>> index 60804855510b..fe9554ee5b8b 100644
>>> --- a/drivers/net/tap.c
>>> +++ b/drivers/net/tap.c
>>> @@ -713,7 +713,7 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>   	int total;
>>>   
>>>   	if (q->flags & IFF_VNET_HDR) {
>>> -		struct virtio_net_hdr vnet_hdr;
>>> +		struct virtio_net_hdr_v1 vnet_hdr;
>>>   
>>>   		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
>>>   
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index dbf0dee92e93..f211d0580887 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -1991,7 +1991,9 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
>>>   	size_t total;
>>>   
>>>   	if (tun->flags & IFF_VNET_HDR) {
>>> -		struct virtio_net_hdr gso = { 0 };
>>> +		struct virtio_net_hdr_v1 gso = {
>>> +			.num_buffers = __virtio16_to_cpu(true, 1)
>>> +		};
>>>   
>>>   		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
>>>   		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
>>> @@ -2044,7 +2046,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>   	}
>>>   
>>>   	if (vnet_hdr_sz) {
>>> -		struct virtio_net_hdr gso;
>>> +		struct virtio_net_hdr_v1 gso;
>>>   
>>>   		ret = tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, &gso);
>>>   		if (ret < 0)
>>> diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
>>> index ffb2186facd3..a7a7989fae56 100644
>>> --- a/drivers/net/tun_vnet.c
>>> +++ b/drivers/net/tun_vnet.c
>>> @@ -130,15 +130,17 @@ int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
>>>   EXPORT_SYMBOL_GPL(tun_vnet_hdr_get);
>>>   
>>>   int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>>> -		     const struct virtio_net_hdr *hdr)
>>> +		     const struct virtio_net_hdr_v1 *hdr)
>>>   {
>>> +	int content_sz = MIN(sizeof(*hdr), sz);
>>> +
>>>   	if (iov_iter_count(iter) < sz)
>>>   		return -EINVAL;
>>>   
>>> -	if (copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr))
>>> +	if (copy_to_iter(hdr, content_sz, iter) != content_sz)
>>>   		return -EFAULT;
>>>   
>>> -	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
>>> +	if (iov_iter_zero(sz - content_sz, iter) != sz - content_sz)
>>>   		return -EFAULT;
>>>   
>>>   	return 0;
>>> @@ -154,11 +156,11 @@ EXPORT_SYMBOL_GPL(tun_vnet_hdr_to_skb);
>>>   
>>>   int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
>>>   			  const struct sk_buff *skb,
>>> -			  struct virtio_net_hdr *hdr)
>>> +			  struct virtio_net_hdr_v1 *hdr)
>>>   {
>>>   	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
>>>   
>>> -	if (virtio_net_hdr_from_skb(skb, hdr,
>>> +	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)hdr,
>>>   				    tun_vnet_is_little_endian(flags), true,
>>>   				    vlan_hlen)) {
>>>   		struct skb_shared_info *sinfo = skb_shinfo(skb);
>>> @@ -176,6 +178,8 @@ int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
>>>   		return -EINVAL;
>>>   	}
>>>   
>>> +	hdr->num_buffers = 1;
>>> +
>>>   	return 0;
>>>   }
>>>   EXPORT_SYMBOL_GPL(tun_vnet_hdr_from_skb);
>>> diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
>>> index 2dfdbe92bb24..d8fd94094227 100644
>>> --- a/drivers/net/tun_vnet.h
>>> +++ b/drivers/net/tun_vnet.h
>>> @@ -12,13 +12,13 @@ int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
>>>   		     struct virtio_net_hdr *hdr);
>>>   
>>>   int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>>> -		     const struct virtio_net_hdr *hdr);
>>> +		     const struct virtio_net_hdr_v1 *hdr);
>>>   
>>>   int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
>>>   			const struct virtio_net_hdr *hdr);
>>>   
>>>   int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
>>>   			  const struct sk_buff *skb,
>>> -			  struct virtio_net_hdr *hdr);
>>> +			  struct virtio_net_hdr_v1 *hdr);
>>>   
>>>   #endif /* TUN_VNET_H */
>>>
>>> -- 
>>> 2.47.1
> 



Return-Path: <kvm+bounces-34882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F65A06F31
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A157E7A1522
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC59B214A74;
	Thu,  9 Jan 2025 07:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOBp+wCf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D352147EC
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 07:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408468; cv=none; b=jxoKpIvyqhTKOFZLeE/Ih8fwSM/xQcLOEpAxPkL77jByswZThg+wvPtaKN+am2aok1d1OVYsB7S/GVpSJRRcGl8rXDM6k/GgU6t1vQRjj1u3os5GlbKA5XGzVywwjw1K/UvmT9SL5oZBYnlo0WAV+w2QNjQK6cG3KYQpYuOTgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408468; c=relaxed/simple;
	bh=Qk38VXpNNITAt7xRhep592aDF5AOkqXBIeZKZMfgj1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCte1GhGObXoYP0iWvy6tLbBxOosVYq435rA1GJ3SbDWffuTGC8nn+URFOGRYE4LLnmBjyDoh40wkow5HM+PDB+4iro4FFX95xcXhDEZ0Gb+L3V+uKllsYv6NMg0ABsvucQNie88EUbzlA6PuziIBa15yH54l1LeG7pkyneGfrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOBp+wCf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736408463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvMHmhw41jW2VMbkE+Q7qKoGQkCDW1O/R8raW3Ad35s=;
	b=gOBp+wCfi/7c1xUZ5i2oQm4qD24RmPSRG+f0ADhCw9CcpjQWVFQkUs4Dk65ikNXogtN/tM
	syJdOLJHlRI4ikK8Fb9wGBV6dQBT6/8wA/3NX39OE0UG7+jr08q4so1AMuyq/l6xIvdrl5
	bOuGvJtIIeD29ZN5jWqWD9Ab+WX5m5A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-uYmwyxgOMJ6MZiZFrjwnrQ-1; Thu, 09 Jan 2025 02:41:02 -0500
X-MC-Unique: uYmwyxgOMJ6MZiZFrjwnrQ-1
X-Mimecast-MFC-AGG-ID: uYmwyxgOMJ6MZiZFrjwnrQ
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa6a6dcf9a3so44379766b.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 23:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736408461; x=1737013261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvMHmhw41jW2VMbkE+Q7qKoGQkCDW1O/R8raW3Ad35s=;
        b=hXZQKS86IxS3K3DG9SSg2FsiAZcArGOkwqBmKGKshALi0u+t2K8Z0pY62qBSq/IuRu
         XoU45qiUjKxFSoFsLZUCJ/IMrRQaW60HC7epk/bu1WGre7fEAwPhezPif43/MAvHBhwO
         VkVvYnGi9Bl/5CP3/Te/498xrW603u0BP4mdcZYtivLf0HOuyjVUjwYpSfycpwYGlLYG
         l/uyIoyONEaDFQ/RIXQILJ2NFfyjaTGqGrJ5ruBInHFPuqbHOQva1M/cctdnDjPy+px1
         u0ggLXv/PIK7eRlh9Jcce7h5M9vJyOt2lx47LjVbMqHxHRrEz1DqKAuluk4Kt0OQ7eLU
         jfKw==
X-Forwarded-Encrypted: i=1; AJvYcCX0M0cNpCnrkcDRMklx0ZRKWMwgjz4Z9cxe/YSxy4yTfIjTnhE8e4pHVxlRxmlqn9F8eHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCzgjwKTrlLdtgq3fBLA4e+TTVqhK3Sg3aUp8LDSLufDvkq5Y/
	7AZrUFtaeEFveEdIaeMk5rl3L1E6FP/BvDyng7twDtOxHdvpc0cQg9sgaNm1YzTeCML+PTr8qag
	UF5U6S29+/K2NGQVD46r5HWBgfOXMl+rm8Maro8y7oth5vgLyAw==
X-Gm-Gg: ASbGncvwZbd/5NgNwBN0ZUY4WPRJ/37N4jarjipUpDXkf11WHedgkhnjKpc8Ja0RiRs
	rhGfMMSQIQb+PVc6NFKBPMjax+/HegAqYi0uYSO+0Q1nnyt6tQz8m0OGiBh5uW/E0RdwoX9SsGk
	0daaXojdTphSwRjy88DeL5xwKhzdgUZW9S8aYXWT/fJYPFeJwihIvcj6+bsdtCQl5a1ee9giNJW
	I43FVdxMvAOZxPRUorplD+d2dy9306PSEvK4YhkMjv2+9XkE9k=
X-Received: by 2002:a17:907:6d01:b0:aab:d8de:64ed with SMTP id a640c23a62f3a-ab2ab6fcf85mr565432466b.25.1736408461317;
        Wed, 08 Jan 2025 23:41:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDzuwKOL/SH91ITfaKkGp53CDAvxvv6OgtnJor6T2CNBRRh8F6ch+wN71Fz8qty44wy1eohw==
X-Received: by 2002:a17:907:6d01:b0:aab:d8de:64ed with SMTP id a640c23a62f3a-ab2ab6fcf85mr565430166b.25.1736408460902;
        Wed, 08 Jan 2025 23:41:00 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:d62d:93ef:d7e2:e7da:ed72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c91362a2sm42852366b.85.2025.01.08.23.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 23:41:00 -0800 (PST)
Date: Thu, 9 Jan 2025 02:40:55 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Andrew Melnychenko <andrew@daynix.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	gur.stavi@huawei.com, devel@daynix.com
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
Message-ID: <20250109023829-mutt-send-email-mst@kernel.org>
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <20250109023144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109023144-mutt-send-email-mst@kernel.org>

On Thu, Jan 09, 2025 at 02:32:25AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2025 at 03:58:45PM +0900, Akihiko Odaki wrote:
> > The specification says the device MUST set num_buffers to 1 if
> > VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> > 
> > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> 
> How do we know this is v1 and not v0? Confused.

Ah I got it, you assume userspace will over-write it
if VIRTIO_NET_F_MRG_RXBUF is set.
If we are leaving this up to userspace, why not let it do
it always?

> > ---
> >  drivers/net/tap.c      |  2 +-
> >  drivers/net/tun.c      |  6 ++++--
> >  drivers/net/tun_vnet.c | 14 +++++++++-----
> >  drivers/net/tun_vnet.h |  4 ++--
> >  4 files changed, 16 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > index 60804855510b..fe9554ee5b8b 100644
> > --- a/drivers/net/tap.c
> > +++ b/drivers/net/tap.c
> > @@ -713,7 +713,7 @@ static ssize_t tap_put_user(struct tap_queue *q,
> >  	int total;
> >  
> >  	if (q->flags & IFF_VNET_HDR) {
> > -		struct virtio_net_hdr vnet_hdr;
> > +		struct virtio_net_hdr_v1 vnet_hdr;
> >  
> >  		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
> >  
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index dbf0dee92e93..f211d0580887 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -1991,7 +1991,9 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
> >  	size_t total;
> >  
> >  	if (tun->flags & IFF_VNET_HDR) {
> > -		struct virtio_net_hdr gso = { 0 };
> > +		struct virtio_net_hdr_v1 gso = {
> > +			.num_buffers = __virtio16_to_cpu(true, 1)
> > +		};
> >  
> >  		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
> >  		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
> > @@ -2044,7 +2046,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
> >  	}
> >  
> >  	if (vnet_hdr_sz) {
> > -		struct virtio_net_hdr gso;
> > +		struct virtio_net_hdr_v1 gso;
> >  
> >  		ret = tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, &gso);
> >  		if (ret < 0)
> > diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
> > index ffb2186facd3..a7a7989fae56 100644
> > --- a/drivers/net/tun_vnet.c
> > +++ b/drivers/net/tun_vnet.c
> > @@ -130,15 +130,17 @@ int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
> >  EXPORT_SYMBOL_GPL(tun_vnet_hdr_get);
> >  
> >  int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
> > -		     const struct virtio_net_hdr *hdr)
> > +		     const struct virtio_net_hdr_v1 *hdr)
> >  {
> > +	int content_sz = MIN(sizeof(*hdr), sz);
> > +
> >  	if (iov_iter_count(iter) < sz)
> >  		return -EINVAL;
> >  
> > -	if (copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr))
> > +	if (copy_to_iter(hdr, content_sz, iter) != content_sz)
> >  		return -EFAULT;
> >  
> > -	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
> > +	if (iov_iter_zero(sz - content_sz, iter) != sz - content_sz)
> >  		return -EFAULT;
> >  
> >  	return 0;
> > @@ -154,11 +156,11 @@ EXPORT_SYMBOL_GPL(tun_vnet_hdr_to_skb);
> >  
> >  int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
> >  			  const struct sk_buff *skb,
> > -			  struct virtio_net_hdr *hdr)
> > +			  struct virtio_net_hdr_v1 *hdr)
> >  {
> >  	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
> >  
> > -	if (virtio_net_hdr_from_skb(skb, hdr,
> > +	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)hdr,
> >  				    tun_vnet_is_little_endian(flags), true,
> >  				    vlan_hlen)) {
> >  		struct skb_shared_info *sinfo = skb_shinfo(skb);
> > @@ -176,6 +178,8 @@ int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
> >  		return -EINVAL;
> >  	}
> >  
> > +	hdr->num_buffers = 1;
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(tun_vnet_hdr_from_skb);
> > diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> > index 2dfdbe92bb24..d8fd94094227 100644
> > --- a/drivers/net/tun_vnet.h
> > +++ b/drivers/net/tun_vnet.h
> > @@ -12,13 +12,13 @@ int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
> >  		     struct virtio_net_hdr *hdr);
> >  
> >  int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
> > -		     const struct virtio_net_hdr *hdr);
> > +		     const struct virtio_net_hdr_v1 *hdr);
> >  
> >  int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
> >  			const struct virtio_net_hdr *hdr);
> >  
> >  int tun_vnet_hdr_from_skb(unsigned int flags, const struct net_device *dev,
> >  			  const struct sk_buff *skb,
> > -			  struct virtio_net_hdr *hdr);
> > +			  struct virtio_net_hdr_v1 *hdr);
> >  
> >  #endif /* TUN_VNET_H */
> > 
> > -- 
> > 2.47.1



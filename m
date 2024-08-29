Return-Path: <kvm+bounces-25350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5309D96450D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E2F128988F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674BF1AC89F;
	Thu, 29 Aug 2024 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ivJASajK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B59C192B83
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935075; cv=none; b=enbPbebnLilBbaeFDjTuZTJqnoNcUYtEfwhlLH2++Oelhp541qRopOW0OCUVczW8mCnIltAa8Wl9pVVQSm3fljvu5OSuD1KwS0RkhZRUgwdAOF2Q9EB6HA/4YFQxvj/kX8Rxmwifwwz9X3Wgwsl+uacfIKkpb0OL8K9lQ04l394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935075; c=relaxed/simple;
	bh=8IVyrfgUZxOCZf/vnKDXcnlww3JCaC6oS7COSF6Fv1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFVDS9LlUdb70OxlCspm/LFUhDN4btwkm7NyuwOEo7ySi3L1JLKRhrKAqxm1Kk9nWkhvqek0/XY6/Ml9pG3UG8OOCz1RgSNNqoigEIsQml4m/p1BkA+ynZdvpkgkmlAhuTniJNoq+jLqN/iVDn61Nusc6fFq91gcJgwlUS+5SeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ivJASajK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724935073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCAshlfXQBHJjsZimXGR/lheLVAb7fx9A/Gwhk+G6+8=;
	b=ivJASajKCXrZ7QcgHb8/IyLI6hE1cHnKWy4mnz290JC2Kl9CJrXVDemeLm3PoAeBmuq62A
	ebz+xT4SXqzCK73weM9CqQPij9VxmDUBtHj8mhcBgFqusRIKsWgTa8Mk14laoQvRkoSvJQ
	vpPm2zioSRd8ggv7njTvtrRWmuJiXTA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-i3gIntfwPpqGS6GN4Z2-Tg-1; Thu, 29 Aug 2024 08:37:51 -0400
X-MC-Unique: i3gIntfwPpqGS6GN4Z2-Tg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2f4082c7b23so6719511fa.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935070; x=1725539870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCAshlfXQBHJjsZimXGR/lheLVAb7fx9A/Gwhk+G6+8=;
        b=ntv+A+17hhQeAYTz+C6cKxUE20zJ/4yyCnJTyO3b90MiiWMBcFVctRPbSck+H59auW
         tFrKjKewK/pZC3UuHpwd4ZHr7Ctr629lg6vMH1+3VZIcEahz0sMclfJYfWlnxHcN6Ooh
         4hU3nwwBYxXQL2Vg4Cc8Tp0OE9p0V7sLDR6WZhYAK9vWnRy4JMcE8htPm1vx7aYh8BID
         d9yKBbFInD3Mm6dKg/tHrpt/zFEEwGiUsGKVrDf8lArP53Wbz5wEz4FGLABwEU1voz3+
         8CT+WqniWgpQSyzgEX6SEEqpHIyp+DxYjzkY0xmoRPr8iFJEEmZZPceV54lQ80LbO3MP
         /8hg==
X-Forwarded-Encrypted: i=1; AJvYcCXYOo3NjN/HBIXyNrUe5BWw6BKlt0TEoalLRsK5ndrN5k1nALfD7LdI3XgKkd5i0JVq17M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu2Iq/eHxZEJfgazPUHkvm339aQQgkKNr2k7BGHGeYXotxqyCo
	7nJ1AR4nwiAGvPo1c2f5pktmiuVlf3dHuPm6QusRy+uloQ/beZXL9ZWHDH4pkv1l1y6zcgmAZK9
	hMfqiDgmpUik9VuBT5ZRI5zad0vEZmfy92slRX1784az1R8Q6Zg==
X-Received: by 2002:a2e:4c12:0:b0:2f3:c0cc:aa37 with SMTP id 38308e7fff4ca-2f6105d9600mr14616211fa.19.1724935069849;
        Thu, 29 Aug 2024 05:37:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj40PJfS1FTib9Oe7KSH4YTXK1zPG8FNuwxORd2gOmXzgpNlFZMUwpvXHZrEgPUSUWT0t1rA==
X-Received: by 2002:a2e:4c12:0:b0:2f3:c0cc:aa37 with SMTP id 38308e7fff4ca-2f6105d9600mr14616031fa.19.1724935068778;
        Thu, 29 Aug 2024 05:37:48 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1ed:a269:8195:851e:f4b1:ff5d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989221c63sm73982166b.201.2024.08.29.05.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:37:48 -0700 (PDT)
Date: Thu, 29 Aug 2024 08:37:41 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, marco.pinn95@gmail.com,
	netdev@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v4 0/2] vsock: avoid queuing on intermediate
 queue if possible
Message-ID: <20240829083715-mutt-send-email-mst@kernel.org>
References: <tblrar34qivcwsvai7z5fepxhi4irknbyne5xqqoqowwf3nwt5@kyd2nmqghews>
 <DU2P194MB21741755B3D4CC5FE4A55F4E9A962@DU2P194MB2174.EURP194.PROD.OUTLOOK.COM>
 <20240829081906-mutt-send-email-mst@kernel.org>
 <22bjrcsjxzwpr23i4i3sx6lf5kkxdz6zjie67jhykcpqn5qmgw@jec7qktcmblu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22bjrcsjxzwpr23i4i3sx6lf5kkxdz6zjie67jhykcpqn5qmgw@jec7qktcmblu>

On Thu, Aug 29, 2024 at 02:33:11PM +0200, Stefano Garzarella wrote:
> On Thu, Aug 29, 2024 at 08:19:31AM GMT, Michael S. Tsirkin wrote:
> > On Thu, Aug 29, 2024 at 01:00:37PM +0200, Luigi Leonardi wrote:
> > > Hi All,
> > > 
> > > It has been a while since the last email and this patch has not been merged yet.
> > > This is just a gentle ping :)
> > > 
> > > Thanks,
> > > Luigi
> > 
> > 
> > ok I can queue it for next. Next time pls remember to CC all
> > maintainers. Thanks!
> 
> Thank for queueing it!
> 
> BTW, it looks like the virtio-vsock driver is listed in
> "VIRTIO AND VHOST VSOCK DRIVER" but not listed under
> "VIRTIO CORE AND NET DRIVERS", so running get_maintainer.pl I have this
> list:
> 
> $ ./scripts/get_maintainer.pl -f net/vmw_vsock/virtio_transport.c
> Stefan Hajnoczi <stefanha@redhat.com> (maintainer:VIRTIO AND VHOST VSOCK DRIVER)
> Stefano Garzarella <sgarzare@redhat.com> (maintainer:VIRTIO AND VHOST VSOCK DRIVER)
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [GENERAL])
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
> kvm@vger.kernel.org (open list:VIRTIO AND VHOST VSOCK DRIVER)
> virtualization@lists.linux.dev (open list:VIRTIO AND VHOST VSOCK DRIVER)
> netdev@vger.kernel.org (open list:VIRTIO AND VHOST VSOCK DRIVER)
> linux-kernel@vger.kernel.org (open list)
> 
> Should we add net/vmw_vsock/virtio_transport.c and related files also under
> "VIRTIO CORE AND NET DRIVERS" ?
> 
> Thanks,
> Stefano

ok

> > 
> > 
> > > >Hi Michael,
> > > >this series is marked as "Not Applicable" for the net-next tree:
> > > >https://patchwork.kernel.org/project/netdevbpf/patch/20240730-pinna-v4-2-5c9179164db5@outlook.com/
> > > 
> > > >Actually this is more about the virtio-vsock driver, so can you queue
> > > >this on your tree?
> > > 
> > > >Thanks,
> > > >Stefano
> > 



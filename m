Return-Path: <kvm+bounces-62256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D031EC3E3A3
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 03:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 660F01889144
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 02:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C122D876F;
	Fri,  7 Nov 2025 02:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9v2D5Ss"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCFB28D8F4
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481869; cv=none; b=AtqsIprQmFGadXxtUDrVYVndOWACe3q9WsSL0i4BaZe5YWpmHAEePIK04/8NeyGm/XN9EFx8IRYsUqjX/Pur/UeUiyr1nVkNmneyBjZFRDN4ljXyJ0u/GW73Xv0UojTTSnbp1Jq3RSsUfiUZBz2hMABgaMyv6SResTNr2VznZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481869; c=relaxed/simple;
	bh=n3gYr3RvsG4vHe7a+dCbLSQSRL9C74quEHXFc8TjktI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJcDM7Y315Ixl9jXZeVUUZgNHRySDnUBrAa9nmXS3l2sAJURQkRg3VaaK4SlN78Pf/yFFCSKjVPTmyAKQYgRt4+unogE+9zhpCAPf21bANULMzoRb8YMAmkRa5zSU4ScNB4cjw2l/jK8WAr360EQIG2m5b5VhBwkHk9DL9PZIGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9v2D5Ss; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787c9f90eccso722097b3.3
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 18:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762481867; x=1763086667; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f/qDZWpyxKihNvVQgiqCWAS1sqvTSoRcnWFm1GLCK/o=;
        b=d9v2D5SsfeCeXVKsLIF6ukY/S5jDZtenVQczg0yRrNoCXSF0W+9lD4qyJy16KwTV7n
         6anuKzewTjR5vHbYjW1YM9nwlFzsp85OFJg2FR/41t2WMcHb1M6eWJP2+JGDRRWd7Q9M
         fXI6roy2jhsvLTljdK+csj6wmJax8h60YPR7nr9c28hfyImyTjMiYnk3quQbc43N3NZs
         3V3ZIMd0aEJaNANavhjh1eIP6q+OYOa47Tr2KnIztIlMBsuC5G8RFWH+los1OOdPSnI/
         OtdiW2LP55wy6MpyXKagWKxDIPc5slvOgr2xdXWpjqa+2OHB/iC7tHXw/+k7T5eNWGx3
         OLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481867; x=1763086667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/qDZWpyxKihNvVQgiqCWAS1sqvTSoRcnWFm1GLCK/o=;
        b=s4YJ/GGreO8TKyBg1KyLXKLyHtj6gRn7Q/pQ3J1WHxmf++ltIuROiskN/U1tUr5b+N
         GkkPY1CuWO7QYXBuPaJG/gAUW5/qewknY+HWHLtQycHHEEHXBOjloZqONZJI6dwaOwIq
         4iNU4QtVrE5i1D5CCGSZ102g4jT0cLeKaAuPCXFqTMFtFAM1OZx2HCRCkmzdEY5ezuFr
         mUOGBB2n09DfhEoEsFcZCjDrZcWjJlvOVxRAtMDqv3zvx8ByOaYuZGnQTJiwFUVv+/NG
         J/3ovZRW3vF9KBFu7LDkHRFxmA1GiiA6x899LhvfmnUyMF4otDIlU5tS+Sz44vmzn2sQ
         tNgA==
X-Forwarded-Encrypted: i=1; AJvYcCX9kF06olhFqW4ksl9Rp7Iyz0XOJvrObu+tVU43yC44bGN63T6EUw5NN/tdNGQlfn+uu88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs3uwQAtuLeafP0wHEhrg7D9wIoiTY/NsymbdpdCSh2ncTkymp
	ZpB03nmP9mSWqAyw6C2pBgZ8JNeJTcFhPASDqw+HPmpdOA2I4s22wpxy
X-Gm-Gg: ASbGncvwMs1LsXxb3MBJAHkAB3Hqnf4lQQNxfzDP+vrdLa6hClHTKbOs3vLY8eqOa1n
	D7SuvSWgfL46eh7bl1GKBBOlYe5dtaamnfs+sRX4cJMeT48uv8R2TTIz6+4Au6ThB7dtK8YHPa8
	+P9t5v/6wVDC8c0PPpvayFuvMNYvveCg0xG53SwzdIJZZ2TrCedE2RwyuXV+/1pW+t0BS3vm2qF
	Xme+4vWsab+2KHVihufec9azLOFOPabMS8+r7aMfGSEHTnGHlqKGVZly4ZH0Pz0T+8Uo4eWBUHU
	6sSV5QSR1/a+fx2X/ko1EEkW4trdXue6HnY3MiPWnEBB4vy/cVVeav2puevrqWytTFGz61P6CpC
	n3qs4aCBaqAwv0fZz76R8ckga+R88U6hHmdaojY3oQdQlK0PbqGTdcPyW6LybsCutAjo5D5zuhf
	Ue57CTcxiF+U2Pt9jI1ZVLkjJzF+oBxCG+m5yl
X-Google-Smtp-Source: AGHT+IFZ8bZR9p7ByW2qTZ7t1G8+dcC59pbrnej+Xjx5wnA7nuCjNt5Anuhhygsgcb+Dgcf4MRxUlQ==
X-Received: by 2002:a05:690c:62c1:b0:786:6383:658b with SMTP id 00721157ae682-787c53e7b73mr13168407b3.46.1762481867107;
        Thu, 06 Nov 2025 18:17:47 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787b159b3cdsm13516547b3.33.2025.11.06.18.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 18:17:46 -0800 (PST)
Date: Thu, 6 Nov 2025 18:17:45 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v8 05/14] vsock/loopback: add netns support
Message-ID: <aQ1WyeN9VRy505si@devvm11784.nha0.facebook.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <20251023-vsock-vmtest-v8-5-dea984d02bb0@meta.com>
 <tuclqrdg5p2uzfvczhcdig7jlifvhqtlafe4xcqy4x4p3vrya6@jq5mujdluze5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tuclqrdg5p2uzfvczhcdig7jlifvhqtlafe4xcqy4x4p3vrya6@jq5mujdluze5>

On Thu, Nov 06, 2025 at 05:18:36PM +0100, Stefano Garzarella wrote:
> On Thu, Oct 23, 2025 at 11:27:44AM -0700, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add NS support to vsock loopback. Sockets in a global mode netns
> > communicate with each other, regardless of namespace. Sockets in a local
> > mode netns may only communicate with other sockets within the same
> > namespace.
> > 
> > Use pernet_ops to install a vsock_loopback for every namespace that is
> > created (to be used if local mode is enabled).
> > 
> > Retroactively call init/exit on every namespace when the vsock_loopback
> > module is loaded in order to initialize the per-ns device.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> 
> I'm a bit confused, should we move this after the next patch that add
> support of netns in the virtio common module?
> 
> Or this is a pre-requisite?
> 

Yes let's do that, it does need common.

[...]

> > #endif /* __NET_NET_NAMESPACE_VSOCK_H */
> > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> > index a8f218f0c5a3..474083d4cfcb 100644
> > --- a/net/vmw_vsock/vsock_loopback.c
> > +++ b/net/vmw_vsock/vsock_loopback.c
> > @@ -28,8 +28,16 @@ static u32 vsock_loopback_get_local_cid(void)
> > 
> > static int vsock_loopback_send_pkt(struct sk_buff *skb)
> > {
> > -	struct vsock_loopback *vsock = &the_vsock_loopback;
> > +	struct vsock_loopback *vsock;
> > 	int len = skb->len;
> > +	struct net *net;
> > +
> > +	net = virtio_vsock_skb_net(skb);
> > +
> > +	if (virtio_vsock_skb_net_mode(skb) == VSOCK_NET_MODE_LOCAL)
> > +		vsock = (struct vsock_loopback *)net->vsock.priv;
> 
> Is there some kind of refcount on the net?
> What I mean is, are we sure this pointer is still valid? Could the net
> disappear in the meantime?

I only considered the case of net being removed, which I think is okay
because user sockets take a net reference in sk_alloc(), and we can't
reach this point after the sock is destroyed and the reference is
released because the transport will be unassigned prior.

But... I'm now realizing there is the case of
virtio_transport_reset_no_sock() where skb net is null. I can't see why
that wouldn't be possible for loopback?

Let's handle that case to be sure...

> 
> The rest LGTM!
> 
> Thanks, Stefano
> 

Best,
Bobby


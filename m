Return-Path: <kvm+bounces-67981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AD7D1B863
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E77F83013BE3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53689352FA8;
	Tue, 13 Jan 2026 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WigX3av1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8535502A
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 22:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768341756; cv=none; b=sierE+6NUNBk8Da5AM8jkjKC6pegeE3Gek4BPBMVKqfC8euVH5XgqT9RzL+V0GEtSIUir4WNWd0miabvQtg4fJrC2+Ltg5ErpQRdH5PMjoQ8GafjFvfqvm0wfNLlF6mdH5Isy9h1ZffPZaFQjdq4V2nL2hLYjm9NHUYz3wrkBhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768341756; c=relaxed/simple;
	bh=h+UznknjOhsgpxn2WvyaKZdy+E01z3xst2FqiSOZMS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3pkwSyarceJ02mnEj/nqkbX84P1733NxeXcb9UZOOzR3L8XRT9POZC+rcqb6qMQQC2NABmN8PyAQiZBPWPlqDlX4LX0Bbu5LsgzRPaXaGAKv7laIq40gPXxY9tRGUibp4ECRi43z3oUDMhtSY64RsRRebGqyCg10LJh/dg0jn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WigX3av1; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee1879e6d9so94500321cf.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768341754; x=1768946554; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QzIlW73SYpRCgsFT6C0OFykRPA/kKAr4bQkErotYYOY=;
        b=WigX3av1M8kRfJO2sCmtvIHvRQTiATYk+bNpz8zJMq0v7CvSzbWjrdpFbP8Nesljwa
         o1RmrWdqnduASR9WjO25uE9xwQanaqrZ6PNSFGtatG8LL5Sn88U5K6N+5UqQMR2kfX/+
         1FVSP+0LUvOdQ2Q2S9DAKwBZPeCpQp4J61ywjUIRJVHy0ReiP7coP0owxUkc4radrPKL
         FSEr/X/Kiiryp3pQefjTm7IlJcH4drn9eLdWqdic1oHa9fK+wApRFeI+Kh0eT0wyLV5z
         /p4nVoql3m7bmehUd+/7eCdSGOkxCtKUNczjJgzkjrW65QzhxaFSTnVbyAYnHQsNIjUT
         E6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768341754; x=1768946554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QzIlW73SYpRCgsFT6C0OFykRPA/kKAr4bQkErotYYOY=;
        b=OimzONaeVi0l1k+26NX+Ica9jLGUbCcAeI3qgQf+xj7hnNo5ICG62qugOgY4xrPue3
         fPLXqptjLOphRfcpVIekQgXIzrPGYmp+Okhv0i7jYN6qRbBKXQbdFwAThzj2CN8GlgNk
         4CKjYOXYc06kFdjUtnvc3EpGqbprziLtUU64FpuFw2BRN5TupGBOBFhW+F7Hzf2P9YoL
         FDPcUcLJK8L0rqFKla1j/5iWa6u3sCAdeUxAUMK+wlH00wZjYFqbdmZzmT2vOaN5DS0p
         7SyLYqxjKIoNzyPBJ/i1DzRV5ZtuqNc5qSc3z+PMCPmLVIKdFWsd+IF8bUJYLCo9MyGR
         L6cg==
X-Forwarded-Encrypted: i=1; AJvYcCXVdytR9zSMBDLsVgnoM/JgHt3gA9+RYqhSLK9h8RyW4XGZR/LM92npafvCbKjnmtyetMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAsOZJO2s30qvxj8Raejm6WU8iHE76NBEiuMGNDXMmZ1Ue7yl+
	Ey1L4qHIJH09hg829ZfV7I5cRZMc9TMFSdhAWIv3rBTXnj40wr0gl9yAV+PCRw==
X-Gm-Gg: AY/fxX6cL65W5RlkcFA7TCRVXRt0N3VYZkOeoyX+jKPatvSF/fRVjqIEKpZJJUNIXM/
	RWl1qBrIbwwSplqFWrF46h7owokv6/oee14FpjQPfxhFiwumtO8KE7uf2dpwEX29WwQ5yoEW6mO
	61g1Qr3kE8LsWmUodl/VPXhr1wbdkGN1R/YiAzesCxPsFQWLKoMSJ+S32j/ufMG/2YyeLg3UdK6
	F9KxwZNYtCzHDg+VSjHugpqi2ebQNS0pagWEOEvLKNkhHTUk22Ouv6kzqKT8O+QuIWOK8ao//DH
	y8ZgMqeQ5FmULfYN8qEZp2AwyMv2UX/f7dbZ6jCbt3AR3bCBpW65Z+7S06JrEbteMBXjeCGbBC3
	pYBGMcm/m63OmSZV3WttVPnUFT0OHyG1OUcicSCkjBqw3RStIwVsarHKs59ZO5k1Tnu88sKYq1w
	Fn2hfDtPW2lrX+udrH/aFWZLf3gmAXJLq8Qxg=
X-Received: by 2002:a05:690c:c85:b0:78f:f3e2:35e0 with SMTP id 00721157ae682-793a1d4bad1mr1649307b3.42.1768336120080;
        Tue, 13 Jan 2026 12:28:40 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790b1be88dcsm77661627b3.47.2026.01.13.12.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:28:39 -0800 (PST)
Date: Tue, 13 Jan 2026 12:28:38 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org,
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v14 01/12] vsock: add netns to vsock core
Message-ID: <aWaq9vbBJGqg9+DU@devvm11784.nha0.facebook.com>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
 <20260112-vsock-vmtest-v14-1-a5c332db3e2b@meta.com>
 <20260113024503-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113024503-mutt-send-email-mst@kernel.org>

On Tue, Jan 13, 2026 at 02:45:32AM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 12, 2026 at 07:11:10PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add netns logic to vsock core. Additionally, modify transport hook
> > prototypes to be used by later transport-specific patches (e.g.,
> > *_seqpacket_allow()).
> > 
> > Namespaces are supported primarily by changing socket lookup functions
> > (e.g., vsock_find_connected_socket()) to take into account the socket
> > namespace and the namespace mode before considering a candidate socket a
> > "match".
> > 
> > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
> > report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
> > for new namespaces.
> > 
> > Add netns functionality (initialization, passing to transports, procfs,
> > etc...) to the af_vsock socket layer. Later patches that add netns
> > support to transports depend on this patch.
> > 
> > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > modified to take a vsk in order to perform logic on namespace modes. In
> > future patches, the net will also be used for socket
> > lookups in these functions.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > Changes in v14:
> > - include linux/sysctl.h in af_vsock.c
> > - squash patch 'vsock: add per-net vsock NS mode state' into this patch
> >   (prior version can be found here):
> >   https://lore.kernel.org/all/20251223-vsock-vmtest-v13-1-9d6db8e7c80b@meta.com/)
> 
> So, about the static port, are you going to address it in
> the next version then?

Yes, just wanted to get the rebase out to unblock review of the
child_ns_mode changes.

I should have mentioned the static port was a known issue and still
under discussion.

- Bobby


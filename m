Return-Path: <kvm+bounces-62252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 96671C3E187
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 02:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E27164E272C
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 01:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D6B2F12A4;
	Fri,  7 Nov 2025 01:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hw+9SazG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5062EF651
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 01:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762477774; cv=none; b=a+61b8OsBQIn0yfPWMgg08SkReLzIjDsZrtctvMBw/DSTWjV4r2gzt3JdSz7JfOuSLMBLa3855QTIr7+k3Y9jeo5LxltyXl/EvPr/bcUjRxm4Y63IFZfoSxt9enmqCRJZ480m2qVAu6IqOJKqGBgW2CYUdQcFkFHNXLeBAfFo1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762477774; c=relaxed/simple;
	bh=y8GsXoMpZfP1FEGzB5PcqGcDnM/GiApM178nf5o2DdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=giFxpG6R6QLKucS8K6uzPfI928xiV8Nrb+q6Ni2k/AyhKFNlZ/SdIIBXg7ftXoHBjJMzSLgGfjfWlqrTJdp8zMWSmuD+fXiahOmWVwPRzVb488zAcM2Gmh+GqSxv08ceKcZhvBImxir+PV/Te5VoN9FhrBhNywqD/RRWd/7S700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hw+9SazG; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-787c9f90eccso341657b3.3
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 17:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762477772; x=1763082572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvUJ3GAHgLW25cDlFG6h0rQPjnjrIg13OTjYu0f9NLQ=;
        b=hw+9SazGttaxASXszZn24cyY93Dgqbzee8SAZxh+YnQgF0OM+q/iDtOe02Uvp/p5Fe
         k51csJHvzBG006UTm/luMvEFtKOGH4azT1UnlZByYp4K0VH/3A2wZVJyX3F7wp9/gne+
         bSPlgyM2wOwSyJLQmi8tLjIowuDFAYljWRuOGubi/6LPjZZqkNApWnYXSjxMtEUoUJQL
         MHUn56SUjdMvwTK4DQGvHQnrtqA5nYegiwRuKbaWJlQKbeyUrMJKxI3W8hAXzPpEghdZ
         8ycZ9we9manbmrrdvRYNDHxYsBweWKyHvj07jRQOtAbfFSfhetvUCwWfJMY91FEaKpZ4
         Lp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762477772; x=1763082572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvUJ3GAHgLW25cDlFG6h0rQPjnjrIg13OTjYu0f9NLQ=;
        b=ji8/jLLxRha9MbbLMgMyAaDXyoG2H/hdGzuKbo+nPd/d4YPqLLX+OwK0FcL1/SPz+S
         SHNt9FtgDUJYMceWplGGeundH0941g4R1nX+KUkvpSGNbGH2QJp3Z6G4AZ1A5ty6m+DD
         74jK+18hQgI5KhjcfebCou+DOMGiTG38D20A7q2YwE4dROhKIhBxyTcEIM5TJTZWSEFq
         wioKT5k7G66zEFNFw5N1aRDeagFPJb9/3UoCz3SffxKwCjMGDVlBAvVDC/f74suS91+o
         W8oATQ7LEVSXXPaMvLJ+zF2whBXEAVFuJYivmLYd0PHRPMTFrC5wG+WDRcw2y37mmtEt
         AnsA==
X-Forwarded-Encrypted: i=1; AJvYcCV9dxth0VcP1FyAdgFifGcyMkImbCu6b0GgX/penQbceRs8u/PlOBOZ8Si0oEGd7xtpMBE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo9cA26jOWFkolS5TIm1Oaz/gpcJVyHvJGs2r8CqATIyx/+z8U
	VmvDsTEU6EsRGmFGHFxGdPPWyGdgw2w8O/y1fZrWrlpr8rJasqMUUqva
X-Gm-Gg: ASbGnctvxjKqXGgv8GQ4py4EUmvkh5Q1re9e0oQbt4Sj8Wi4vk9UZkGbu+QhlIn/7Fl
	A1Uux3emsc8v3TeS7+VuxRcovLKuxT6BU5NUdeaffvTQu09gEsLVDIcx5QynP5D1fsM87zGzLtr
	mynU2tna6GhuhLMjR4Tc4d+z9kQbw5Gxy7asTRxMRAw6PN+VRiatm/9Vrt1WgiQCEjGds11huqu
	PMHYeGAD3OiAh2bL5OVZCmbnXD/QiAHVC7/eM9lGePyVoES+3Ud4u9i825pggExdmiCnhz53bkH
	S/DuOhf2w/U3ca36adbzxQN5Ijrhy+1PsRusFinwS9ia5G6gKfJa0LmTT2ZxuVXq5/nSCN6Dd/F
	1iLarAU6nsddzMylbyUsa3KR9YniLeWNr+295QkEbLVanP/SefOlllq5iwJX1LY8kSAFF1SzZnq
	mTmtw3QvAr/49k+EinfyHHstTV+8bBoYBp48MB
X-Google-Smtp-Source: AGHT+IGIiNSL9xH9R1nGKHm9qDA5dUwel2Gn4NDFwi23AY7T7XKy/BbtnkHOptWZ8jTsfq60FDuFzg==
X-Received: by 2002:a05:690c:6808:b0:786:a817:77a0 with SMTP id 00721157ae682-787c5346349mr13381347b3.31.1762477772177;
        Thu, 06 Nov 2025 17:09:32 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:71::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787b1598d0asm13031717b3.29.2025.11.06.17.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 17:09:31 -0800 (PST)
Date: Thu, 6 Nov 2025 17:09:30 -0800
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
Subject: Re: [PATCH net-next v8 01/14] vsock: a per-net vsock NS mode state
Message-ID: <aQ1Gyp87UYnr/VAO@devvm11784.nha0.facebook.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <20251023-vsock-vmtest-v8-1-dea984d02bb0@meta.com>
 <iiakzdk7n7onhu5sncjd7poh5sk34nrtvusbiulsel5uswuekv@p2yzmblg6xx7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iiakzdk7n7onhu5sncjd7poh5sk34nrtvusbiulsel5uswuekv@p2yzmblg6xx7>

On Thu, Nov 06, 2025 at 05:16:29PM +0100, Stefano Garzarella wrote:
> On Thu, Oct 23, 2025 at 11:27:40AM -0700, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>

[...]

> > @@ -65,6 +66,7 @@ struct vsock_sock {
> > 	u32 peer_shutdown;
> > 	bool sent_request;
> > 	bool ignore_connecting_rst;
> > +	enum vsock_net_mode net_mode;
> > 
> > 	/* Protected by lock_sock(sk) */
> > 	u64 buffer_size;
> > @@ -256,4 +258,58 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
> > {
> > 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
> > }
> > +
> > +static inline enum vsock_net_mode vsock_net_mode(struct net *net)
> > +{
> > +	enum vsock_net_mode ret;
> > +
> > +	spin_lock_bh(&net->vsock.lock);
> > +	ret = net->vsock.mode;
> 
> Do we really need a spin_lock just to set/get a variable?
> What about WRITE_ONCE/READ_ONCE and/or atomic ?
> 
> Not a strong opinion, just to check if we can do something like this:
> 
> static inline enum vsock_net_mode vsock_net_mode(struct net *net)
> {
>     return READ_ONCE(net->vsock.mode);
> }
> 
> static inline bool vsock_net_write_mode(struct net *net, u8 mode)
> {
>     // Or using test_and_set_bit() if you prefer
>     if (xchg(&net->vsock.mode_locked, true))
>         return false;
> 
>     WRITE_ONCE(net->vsock.mode, mode);
>     return true;
> }
> 

I think that works and seems worth it to avoid the lock on the read
side. I'll move this over for the next rev.

[...]

Best,
Bobby


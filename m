Return-Path: <kvm+bounces-30881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB8F9BE1FD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 086F51C234A6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838591DE3AD;
	Wed,  6 Nov 2024 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQmyahKL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351711D90D7
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884073; cv=none; b=mdxanUohgtUARaQW3rXYek6pTQsqlYFowV6PvmyDBQlVgNTV4ujfE0v6makE1wtiudKyK22s/ysskKHZHeeBELhZ+GB0mRriRiOJ1srtLQrwedS2Xouo6pdFfvUPibwgacDquul4YS/A53pTlehFF9O7gSONaA6Zv0P7XctvyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884073; c=relaxed/simple;
	bh=iRDvP6Fds9e6sAJFt7TFL1RE85f61k0qNzCwm6EI0ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DiKKhcKQHZOUr/zTF15XEWSyMM+1n0C9UvcgZDHrTfCa+H4rr50YLpgxJ6faBN/CvApcH+sAnCqtnpUnDOZRTww7w0b3LhjLNETeCvIfAie87sOLKm4dwq8mNhbzgsNjN34KwpiI/2+YNsMzx2J4bf1oNEdXcgzk7jwEugr6aLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQmyahKL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730884071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=stsh36U7LL9w1fGvl92BzQf3qg6o4uyL96zdePlIQ+M=;
	b=DQmyahKLpa4uBsotLYNKDmHbDXgvZUnNoisXHyP5lY4MHhdN1ZZDOpcxTEJ8V8C5aELA2B
	unXYYdnB7WlxvJkVP0DZXVEcTqWy+FNLJfLSn3aljD1WI01uVAqyca0NFZNBy7IVO6L+UC
	bCzQupBxeyEYSLOOP8c2Mx3odJfJ2wE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-Gv-ekypJNXWo0EkOANqzKQ-1; Wed, 06 Nov 2024 04:07:50 -0500
X-MC-Unique: Gv-ekypJNXWo0EkOANqzKQ-1
X-Mimecast-MFC-AGG-ID: Gv-ekypJNXWo0EkOANqzKQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4316300bb15so40769345e9.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 01:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730884069; x=1731488869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=stsh36U7LL9w1fGvl92BzQf3qg6o4uyL96zdePlIQ+M=;
        b=C/SVHgw0Yz3QzZc6OE56NJtAfBr6RVArCCfMlG48jgUMySkZdIjmkem5wUF7jKIBuW
         cosLD+RTsH8/wUhbV8H1xObMXBhFP9vUIiPRIF0BLjsM6f3qubCyQOh6JKx0AErZLOI7
         4RjFABstH5doJ+3dXWrS02pnyVp7SBi6Jp4464LltCS+tynpJVCp4DlZ0b0pGmdLKpWx
         9ljSDh6zfi7Q1k5c0GHNwvwj80z1uH7CmpJDsfW8lvq6LWxQ6PoiGCEYhj/xBbaWpyCF
         dLNTCILN6CIuspnpvvf0FiiaW2OR8rdcB5WMO2Nj94kp2CPAXuF2zdiDIapAWRzVyI44
         Y/Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWmJPpi5Nn1isBKxoUbcfvTJqYRtmrp1lzJprwPUsYaK7WMrQIvYtWWF+3+idrbNYV3BoM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5p16GDL0dw2U/p7S+G7rtwYKywhHf4g7R9muv4JGdIzsJ1Aqp
	AyBhN6ADcyATU8PT0nEFUle0quZHungYPYzs8mmex45m4/cEv+MuAxDWOow4jdbz0a/1ar7LkQH
	2ejNCGs1ypZ6fcMT4cPm/vQiiTANLz1pfkFhGiMZJFytPLulSXw==
X-Received: by 2002:a5d:6902:0:b0:37d:4ebe:164f with SMTP id ffacd0b85a97d-38061200d23mr24637615f8f.46.1730884068794;
        Wed, 06 Nov 2024 01:07:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4QdCH0opectVmr8dgwxLSrIB+qc8WNu2CPVa8NB18xSiYf7L6K01+/errC2pGSWF3kucn/A==
X-Received: by 2002:a5d:6902:0:b0:37d:4ebe:164f with SMTP id ffacd0b85a97d-38061200d23mr24637597f8f.46.1730884068451;
        Wed, 06 Nov 2024 01:07:48 -0800 (PST)
Received: from redhat.com ([2a02:14f:178:e74:5fcf:8a69:659d:f2b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7e1bsm18681481f8f.1.2024.11.06.01.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 01:07:47 -0800 (PST)
Date: Wed, 6 Nov 2024 04:07:44 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Stefano Garzarella <sgarzare@redhat.com>, stefanha@redhat.com,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <20241106040705-mutt-send-email-mst@kernel.org>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
 <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
 <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
 <20241002071602.793d3e2d@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002071602.793d3e2d@kernel.org>

On Wed, Oct 02, 2024 at 07:16:02AM -0700, Jakub Kicinski wrote:
> On Mon, 30 Sep 2024 19:03:52 +0200 Aleksandr Mikhalitsyn wrote:
> > > At this point my question is, should we solve the problem higher and
> > > show all the modules in /sys/modules, either way?  
> > 
> > Probably, yes. We can ask Luis Chamberlain's opinion on this one.
> > 
> > +cc Luis Chamberlain <mcgrof@kernel.org>
> > 
> > >
> > > Your use case makes sense to me, so that we could try something like
> > > that, but obviously it requires more work I think.  
> > 
> > I personally am pretty happy to do more work on the generic side if
> > it's really valuable
> > for other use cases and folks support the idea.
> 
> IMHO a generic solution would be much better. I can't help but feel
> like exposing an arbitrary version to get the module to show up in 
> sysfs is a hack.
> 
> IIUC the list of built in modules is available in
> /lib/modules/*/modules.builtin, the user space can't read that?


So what are we doing about this? Aleksandr?

-- 
MST



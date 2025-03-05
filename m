Return-Path: <kvm+bounces-40171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3051FA50620
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 18:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7A116F74D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 17:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACDB1C84AC;
	Wed,  5 Mar 2025 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ust7rjDG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE61A3160;
	Wed,  5 Mar 2025 17:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741194844; cv=none; b=UAJLf1x/J9zOZObWECeim0nhfK7oIDmVU30JSkkkefIAsx9hqzvmdJzYej0np4e9+KDznUi2ds7U1k0mE8wIKkMm0oNfLSKuFZtvkQPwaIflkT6sTStjKeGs5nS1XTYIippBMJDlLSAz2EBjWj2n7I369sAyXtGk67lKww2udtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741194844; c=relaxed/simple;
	bh=JG3bEgryVkD89ivJEHDvKdoz5pX+G5di1bV0ReHD08c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQ9HkdP/X5q0LuDwdSvwS+l8JJPB1N3WDE0gopQdgDo5Kl7mcfpphb3hPAfLStSnBSNXlxqvF5BNE4TELZQrFBtdH7pQ7cq9KbOlPY+Izp9jsrMwpKzhslG4keaARnOvfpuEW8w1ElW4YFMHpNewQAfadvMhRsNcHTm01s3mz2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ust7rjDG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22334203781so21833985ad.0;
        Wed, 05 Mar 2025 09:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741194843; x=1741799643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDY4vgETAYK/Bcf1CBHzUdesUL3jSm/FcT00+a6QmGo=;
        b=Ust7rjDGoqZx3HCrfajj2gtB9xYBYxbHAFmYrxM0smoVZKk77Q6M0kqoqg95PjJqSG
         dndICRxP3GlP8LtzHOXhnuth0cIlIi3vSzbZSy6/0/x1VVGfYA0CCQ1p+/YB7yU8/xwN
         /U4lC5o3wO6zzKONdm5GZZSTZLGo9yVEUK4+uPKrscPqzxhQ5TkQsERYBlQZteh38q6Z
         9xxMHO+Vc3Z00xYcP/iOUSTKm5CHoBYo6T6CVRVxN8GSf7N+v/+rns76vwQ/Tf3TC6mk
         h/J5J+jLYxN9NHdJ8+e88nlYAxqim64nnzoRyWjckWS7ujnp7C3ne4B1Ky7ZcT6mmYa/
         5TEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741194843; x=1741799643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDY4vgETAYK/Bcf1CBHzUdesUL3jSm/FcT00+a6QmGo=;
        b=kF2yiS1dZmOD94UqNdARa+aNuSBxF5w1cDVViRDVnUHzBVTYMztLVIW5+vRkdrd21f
         tQxhurc/umE2fpZ4DCcslwVxc4jJxHJR/Ra9oZPS1b5Pm5pj8UyT8NbE7RA/ZSZ2vnDM
         7itjug/1dr1sdryNAkINBEdw7zfNkjy/L93OTmOK+whbaSYVMMay4/XAeLF1ovo11s0i
         w5TdMZky/9AOrRfMOhdEFVexMlJEE0UqA0JB/hAJlsTxC6ka0jHQfPXV6aGaxg1u6Nhu
         ej7+DMwIEnXhcTA5NlGlAD/i3rrSS5W3uND1Lv0k5rv8wIORcvQ1L3Vn44mbMEVc9g+V
         RWRw==
X-Forwarded-Encrypted: i=1; AJvYcCUyOOeTZEq9dy8OgFWAtVyltOoTqvgdVj+iNsg4otviKyZgsTTcOCb/KPwuqJ3D4WOH67k=@vger.kernel.org, AJvYcCV+WJdQwg5Jth1Okqp1+Z8LvIvdHroTvLDbyv5+wk4CuYW4DrcC8ZMF+1J8yzXPDXPiy4lFmtIM@vger.kernel.org, AJvYcCVa4mYbey2MNt7WSznsBJDo7A1x9a8AMo3PY6oIBG/cMEdr2ttory/tS5qsVv0Ks4LvExvxkonENo6rQETr@vger.kernel.org, AJvYcCVgnUtXFdBLnghdvW+uEkXdSTCOz0A2qpRiEKOY/I8MzQ3cj+pedWfdeMeLTiqwSGiUtAg9A68XwUP892ng@vger.kernel.org
X-Gm-Message-State: AOJu0YxSySokwwCx39XppRH3cw4KLy6czK6R66ErcAn0q5VJTkFuIy+l
	3C4xPuz8fjXvJqnmDCkDufqcFdLo9Jw4DJs+R9ZQEshAuOIv1/Mj
X-Gm-Gg: ASbGnct3X3iWjfSH1N1nC5iaXj9r8keT9DYKueD8SlilRI6ELxCs/z7v1WbeBCvc012
	DHbf4MHiXvHVa5LDbxuJb88limDyDYnD/wPWsAlXj2vYE4oTpNDgNymeDfOG7didrY7EvkeCtef
	CRv7i5efCzO5z3pwsMFmk8ZezaNvNwIkudPKrGXTXuw033ojbKyCp/8455QUYOjG7TOrc27cZsR
	0HAfifSe3T/Nu4FjTSYUIPO/+bp5q9rJgqiAAV/10ksUwd/lu7SD1WwD32F1GuldPZJi2TD84dL
	6Raoz1FVqgSlwl8y3gmjSYixiYtpIKiWTOQ+6vzu5WHHFKd0qsDpN8Vt5ZA0sy3Zog==
X-Google-Smtp-Source: AGHT+IEdZkMPD62CNO9btal/a+oXLs3ROwPZYX/AQSk8n+IbCHpG0Z2D91NOXzOmsZW9ggc8Myd3iw==
X-Received: by 2002:a05:6a00:26f8:b0:732:6276:b46c with SMTP id d2e1a72fcca58-73693cfa00emr165967b3a.0.1741194842711;
        Wed, 05 Mar 2025 09:14:02 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:1::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7364ba1371asm7133443b3a.5.2025.03.05.09.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 09:14:02 -0800 (PST)
Date: Wed, 5 Mar 2025 09:14:00 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Dexuan Cui <decui@microsoft.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z8iGWLsQGdTv47je@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <Z8eVanBR7r90FK7m@devvm6277.cco0.facebook.com>
 <cmkkkyzyo34pspkewbuthotojte4fcjrzqivjxxgi4agpw7bck@ddofpz3g77z7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cmkkkyzyo34pspkewbuthotojte4fcjrzqivjxxgi4agpw7bck@ddofpz3g77z7>

On Wed, Mar 05, 2025 at 10:42:58AM +0100, Stefano Garzarella wrote:
> On Tue, Mar 04, 2025 at 04:06:02PM -0800, Bobby Eshleman wrote:
> > On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
> > 
> > One question: what is the behavior we expect from guest namespaces?  In
> > v2, you mentioned prototyping a /dev/vsock ioctl() to define the
> > namespace for the virtio-vsock device. This would mean only one
> > namespace could use vsock in the guest? Do we want to make sure that our
> > design makes it possible to support multiple namespaces in the future if
> > the use case arrives?
> 
> Yes, I guess it makes sense that multiple namespaces can communicate with
> the host and then use the virtio-vsock device!
> 
> IIRC, the main use case here was also nested VMs. So a netns could be used
> to isolate a nested VM in L1 and it may not need to talk to L0, so the
> software in the L1 netns can use vsock, but only to talk to L2.
> 

Oh I see. The ioctl(IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS) makes sense here
and seems like the simplest approach. Maybe we don't want multiple
namespaces for virtio-vsocka then? The problem I see is that then users
might expect non-colliding port spaces, which means there needs to be
some kind of port-mapping, which would then require vsock users to pass
around their port mappings out-of-band...

It sounds like none of our known use cases requires non-colliding ports?

> > 
> > More questions/comments in other parts of this thread.
> 
> Sure, I'm happy to help with this effort with discussions/reviews!
> 

Awesome, thank you!

Best,
Bobby


Return-Path: <kvm+bounces-67311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B783FD007CD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CD52302EA3E
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8AB61DF25F;
	Thu,  8 Jan 2026 00:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lh9AaWzp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849F01CEAA3
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 00:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767832897; cv=none; b=nDPdAYHErSRfxRF16HLwDjWARvPRCbUisuy2Y9TTzC1AvpxXUoYCr73yzRvTsF5vPSm50oeUoJAz/P8BTi4LDDM6Uyj8SvXGHUN3dQLZ2ggQQd3PWo1v3G/FPFdwI7vOhOK0GGW8KuTFayhUJCdPogPHG8a++bNJys60ArrIDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767832897; c=relaxed/simple;
	bh=9g0zStzKQeS3+N9tmIKzZx3owOLSnCnzmMh7XbFrzQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LltaebGkNIrdQWW4+xfZp8YZ6siST89ze2MqnVHm+FzBj8K+5ILtMr/zXB4o6hj1R7dAEOAy81Y6Tpmyw0eu1HmQ5/Ed07z9Za30by9Prp5vy+z34YQ32GX8WODdtE1htz7CgwKRma4B4rY32ePJBNhLl0QMtq4vK8uNX8SKYw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lh9AaWzp; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78fc84772abso30711377b3.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 16:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767832894; x=1768437694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrenqTp8E4tDkOgXs7eMnB0GiU20rX+sxdLI3fByfBk=;
        b=lh9AaWzpXnlVl9nZXhJnRo0Y8K1o7eo2v3zX9HTdB/EjYm4atY/VsyMe8GBBfbdxL1
         MH0hMkuVOfYpgXKVnTBj6/tNewFC5wUaq7Y+9Z7k53yeBjrUkRjtqnV/qY11zl5ug2O7
         wksu4fd3gdNwP2DyBS+s0qtIz23y537d3e48wcy0dIkAHfs1mWrl71c2BdRIOTnhlBM0
         3LUvbvAQeGxsSW5jzPmATnyHTDyZ7308bcJtphsqX/8whzHOmvCwqK5YrxPR0t56ZApx
         TNA2JYT8nFglk8yG3BOIo9fYFE+zk7fZdx1PBltKZpeEN8iCcJbzVO5VNZPmLfds9L97
         uxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767832894; x=1768437694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrenqTp8E4tDkOgXs7eMnB0GiU20rX+sxdLI3fByfBk=;
        b=PIhsOmOuiGEVmujcBfheHvSjWiqohD+LYme89l8nQQBNHeQEQhJ1GmSj/hACT/G3wy
         ag8+ZyVJa5+WRYpxKCfIQOh7bnjeEz8ckcAgu6fYl6l5d+t5+OvGMEJk3DdYykyvqhrr
         PdW65zNFV59TY3J0MaG3pHkiEMvx2UrRPriNkM2LO7x0p3tooe/cw1DCAORFZvydi9Fq
         l4qDM411iVavzH8lqGSuV7WglPtEzKtuWFLrncHSvOuYEQwS3LpM9YhOJD5lwgh0/kHZ
         jxUQciW+xnFCB0sThYGtnU03AJU3fqCcUnwjFKgzbUhQqbmRx2RSWh63x5gVovcymhdB
         V8YQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpMkhvRkQERlgQ0dHZoTKksuV4HJNrwuQnNprT9D8UprKDkQNy4l13S69FVbiVZbPFm+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJgZ2YiisIG9BiOBQ+CBH6iHmgZsaw0vwYk+FgBkhdzas0ctM8
	NHfhZllBTYC8JXzxsAozV4/iRMjYtVKxcSFTCKEEoGVyCxQvyRWvO9BL
X-Gm-Gg: AY/fxX72ce08nAmwpho+f0PNrlz/TnjXEVNC1Ec4qAH4/VMSQk4x4tDbr3ZKFEGX7xg
	OvCcksnF51AB9i3f3+Rc3ggXti/1QeCgRgFejWSdvvhJ0FKGbB+U1rDqKdF/iIncZSFY4NVWeYf
	ywSBezf7XAG6+2wUlVdxDx1ye/nPBFfuXJjc3Tx2udxadoBoc+a4uHqJBkJ8wlSY9SJ5i65CsKK
	XufLcPUVlJZvfWc+cPBrNzZMmkfClxNQ8fhp20M2CznqQYeFEitKr34D1mfmhj+Mb6TAF/HaMcu
	1NWYrf7kzlvwUXSgpAMWT4s8jCPIKK6TA9orc5AVY7lb55CeWsEHTQOo+Ap96rVuf+2Y+RajjWR
	FmAdZD8w0lgPXweZGBSG73hu4WjNuovCrO1iKTidJx2ns8HLmmxhf7QiwuR7aPcQvZFqyGusUN6
	H2HjN1BEk3Mpjz0a+YsRpQDT+vrvE44G+0FzwF1dvGamHb4A==
X-Google-Smtp-Source: AGHT+IEnrEIlaG9p2xZXsCNaxYstFtQuumuk05m95Q+1JCx1iT0A6+p+K9E6BdjxZvhkaj4OdW4EFA==
X-Received: by 2002:a05:690e:1686:b0:644:60d9:8675 with SMTP id 956f58d0204a3-64716cbfa9fmr3525112d50.90.1767832894483;
        Wed, 07 Jan 2026 16:41:34 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d89d607sm2690822d50.12.2026.01.07.16.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 16:41:33 -0800 (PST)
Date: Wed, 7 Jan 2026 16:41:32 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v12 04/12] vsock: add netns support to virtio
 transports
Message-ID: <aV79PDVBDEqxHlhK@devvm11784.nha0.facebook.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-4-257ee21cd5de@meta.com>
 <6cef5a68-375a-4bb6-84f8-fccc00cf7162@redhat.com>
 <aS8oMqafpJxkRKW5@devvm11784.nha0.facebook.com>
 <06b7cfea-d366-44f7-943e-087ead2f25c2@redhat.com>
 <aS9hoOKb7yA5Qgod@devvm11784.nha0.facebook.com>
 <99b6f3f7-4130-436a-bfef-3ef35832e02c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99b6f3f7-4130-436a-bfef-3ef35832e02c@redhat.com>

On Wed, Jan 07, 2026 at 10:47:56AM +0100, Paolo Abeni wrote:
> Hi,
> 
> On 12/2/25 11:01 PM, Bobby Eshleman wrote:
> > On Tue, Dec 02, 2025 at 09:47:19PM +0100, Paolo Abeni wrote:
> >> I still have some concern WRT the dynamic mode change after netns
> >> creation. I fear some 'unsolvable' (or very hard to solve) race I can't
> >> see now. A tcp_child_ehash_entries-like model will avoid completely the
> >> issue, but I understand it would be a significant change over the
> >> current status.
> >>
> >> "Luckily" the merge window is on us and we have some time to discuss. Do
> >> you have a specific use-case for the ability to change the netns mode
> >> after creation?
> >>
> >> /P
> > 
> > I don't think there is a hard requirement that the mode be change-able
> > after creation. Though I'd love to avoid such a big change... or at
> > least leave unchanged as much of what we've already reviewed as
> > possible.
> > 
> > In the scheme of defining the mode at creation and following the
> > tcp_child_ehash_entries-ish model, what I'm imagining is:
> > - /proc/sys/net/vsock/child_ns_mode can be set to "local" or "global"
> > - /proc/sys/net/vsock/child_ns_mode is not immutable, can change any
> >   number of times
> > 
> > - when a netns is created, the new netns mode is inherited from
> >   child_ns_mode, being assigned using something like:
> > 
> > 	  net->vsock.ns_mode =
> > 		get_net_ns_by_pid(current->pid)->child_ns_mode
> > 
> > - /proc/sys/net/vsock/ns_mode queries the current mode, returning
> >   "local" or "global", returning value of net->vsock.ns_mode
> > - /proc/sys/net/vsock/ns_mode and net->vsock.ns_mode are immutable and
> >   reject writes
> > 
> > Does that align with what you have in mind?
> Sorry for the latency. This fell of my radar while I still processed PW
> before EoY and afterwards I had some break.
> 
> Yes, the above aligns with what I suggested, and I think it should solve
> possible race-related concerns (but I haven't looked at the RFC).
> 
> /P
> 
> 

No worries, understandable! Thanks for the confirmation.

Best,
Bobby


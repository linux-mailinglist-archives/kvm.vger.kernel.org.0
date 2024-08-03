Return-Path: <kvm+bounces-23169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5069469BD
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 14:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D964B21233
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 12:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB8B14F9CC;
	Sat,  3 Aug 2024 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRvMccqC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA4136E3F
	for <kvm@vger.kernel.org>; Sat,  3 Aug 2024 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722688789; cv=none; b=fCvIalal+Rqbi9eNKunj+RO2NKTQnCJHONpUfwLuDdF9h+AIpDyIIJtyXMfABJVwYyIEIJcgbBzDomlef4ydf39xrj8z8zU5w7ndUD8fv6nYipkKe9kYE2ULfSEmyLxbsz1clrg5dlpJDf0n7z5xpmrV+2B7dSNVlSDuRseJ1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722688789; c=relaxed/simple;
	bh=gD2FpfB39EnjPLFzGX1h9zd6wgd7sajf8+31wkVyNEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kntySytyswPMCSRyoetM5Y/zm3ZQb9gzsPX9fwhMRtZYzznGbsBv/6ne4OWUNF6GaAx36U3/jSwwWYQPLVH7dCO3riG7H3Ld+l4ve6BZbJv9SWvOiFWGWlW7c85ttM040aThYuiS3zbbkkSCB9g1mSQHGogUvre9aS6dtgKfD1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRvMccqC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722688786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bud4nRKRklECKnm96ltuCrae8m0qJHJoxUo8AttxE8U=;
	b=dRvMccqCKaOLdY9U7/3G4YIZ3rql/WcNU++gTYN64HnUsbd08KiDu7abDpNBrTT2ymkkUT
	pp149JlODk8CxNnqUB3Pa3AEp5mvhJO97Hm8r0wbhtrQaCXgm5uAYBGQm67GLdZppuK9+G
	pQ10kF2wNXCq34VZBaM3QXp9/Wm3pDU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-EWaCwpUwPTmxOevO-mQy9g-1; Sat, 03 Aug 2024 08:39:44 -0400
X-MC-Unique: EWaCwpUwPTmxOevO-mQy9g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42816096cb8so84326275e9.0
        for <kvm@vger.kernel.org>; Sat, 03 Aug 2024 05:39:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722688783; x=1723293583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bud4nRKRklECKnm96ltuCrae8m0qJHJoxUo8AttxE8U=;
        b=Q9x+pqXamLv0Zjlw8jbOYf4D2ooxfb+LKy5oIy4d7keik+UnI7RtwkD35CHXic1Qas
         qvHmxfDUsxu640pTk0LIqPkXRDJJ0B4pddRPVOCCfYSlH+U1K5wNf7OC3LiW8wAfR2Ax
         tQGn3P3v9FkF95NfO2+u2ngStZcdAgRL/zy1W/7SUhabxie7nDeUoonu6KmIt68YEQW0
         X9SjA8V7K4TUmTnFKwEOCdG/cmG3PUul77yqDI6aognyRmn7x5tIBWGl/rOJXHPHS2Xv
         rkK6cdPlo06VHIA2jHjwbWpJXZLVFwDAOh56upinMvutiYtzEqoU8unJPn8YVlI8K0AS
         ZwJg==
X-Forwarded-Encrypted: i=1; AJvYcCUktgdNeVpDAE4RXsBMGQa+MGYT6U0VbWwanDMJzuqj243qjhrE7uRUbMcw8Ycb/psIsRkNMK6Sxh3GlovVulHWDNLh
X-Gm-Message-State: AOJu0YyS0/4gxS2WTxmqArqUkpp3ZIwTuQK56+mt6RnreQIpYmCIL+FC
	F2u08zyJmdpTdqqz01Sd2tB0Z1ylRr+V93c5/tsFsCcqRpfBfMLmVDSehqKSw91rB24hsEDb8MD
	aL+UsDWWbrcpKoipA2g/MSpCjDrwWKkRWCUMr56P70mY+kvX21+noXNDY1Q==
X-Received: by 2002:a05:600c:46d5:b0:428:e820:37b6 with SMTP id 5b1f17b1804b1-428e8203ceamr44618455e9.31.1722688783170;
        Sat, 03 Aug 2024 05:39:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHztpDlicRIdPi/ph07KPQz9rUp5hL3ZffxDp857thGb8EBxST2h/nU6rQ6f3ID+f0aHwyskA==
X-Received: by 2002:a05:600c:46d5:b0:428:e820:37b6 with SMTP id 5b1f17b1804b1-428e8203ceamr44618275e9.31.1722688782353;
        Sat, 03 Aug 2024 05:39:42 -0700 (PDT)
Received: from redhat.com ([2a06:c701:743c:ac00:6ba3:915a:fea:a61d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282b89a862sm127450475e9.4.2024.08.03.05.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Aug 2024 05:39:41 -0700 (PDT)
Date: Sat, 3 Aug 2024 08:39:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
	axboe@kernel.dk, kvm@vger.kernel.org, linux-block@vger.kernel.org,
	oren@nvidia.com
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
Message-ID: <20240803083824-mutt-send-email-mst@kernel.org>
References: <20240801151137.14430-1-mgurtovoy@nvidia.com>
 <20240801111337-mutt-send-email-mst@kernel.org>
 <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
 <20240801112843-mutt-send-email-mst@kernel.org>
 <9400fb28-47c2-4629-af17-df2a95f2d3d8@nvidia.com>
 <20240801114205-mutt-send-email-mst@kernel.org>
 <6a8f0c72-ba77-42c3-8d85-6bb23a23f025@nvidia.com>
 <20240801175617.GA1133773@fedora.redhat.com>
 <a10e97ce-792a-410f-b68e-d00292987b3a@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a10e97ce-792a-410f-b68e-d00292987b3a@nvidia.com>

On Sat, Aug 03, 2024 at 01:07:27AM +0300, Max Gurtovoy wrote:
> 
> On 01/08/2024 20:56, Stefan Hajnoczi wrote:
> > On Thu, Aug 01, 2024 at 06:56:44PM +0300, Max Gurtovoy wrote:
> > > On 01/08/2024 18:43, Michael S. Tsirkin wrote:
> > > > On Thu, Aug 01, 2024 at 06:39:16PM +0300, Max Gurtovoy wrote:
> > > > > On 01/08/2024 18:29, Michael S. Tsirkin wrote:
> > > > > > On Thu, Aug 01, 2024 at 06:17:21PM +0300, Max Gurtovoy wrote:
> > > > > > > On 01/08/2024 18:13, Michael S. Tsirkin wrote:
> > > > > > > > On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
> > > > > > > > > In this operation set the driver data of the hctx to point to the virtio
> > > > > > > > > block queue. By doing so, we can use this reference in the and reduce
> > > > > > > > in the .... ?
> > > > > > > sorry for the type.
> > > > > > > 
> > > > > > > should be :
> > > > > > > 
> > > > > > > "By doing so, we can use this reference and reduce the number of operations in the fast path."
> > > > > > ok. what kind of benefit do you see with this patch?
> > > > > As mentioned. This is a micro optimization that reduce the number of
> > > > > instructions/dereferences in the fast path.
> > > > By how much? How random code tweaks affect object code is unpredictable.
> > > > Pls show results of objdump to prove it does anything
> > > > useful.
> > > This is the way all modern block drivers such as NVMe PCI/RDMA/TCP use the
> > > driver_data.
> > > 
> > > These drivers don't have driver specific mechanisms to find the queue from
> > > the hctx->queue->queuedata like vblk driver has for some unknown reason.
> > > 
> > > It is pretty easy to review this patch and see its benefits, isn't it ?
> > > 
> > > It is not expected to provide extreme perf improvement.
> > > 
> > > It is introduced for aligning the driver to use common MQ mechanisms and
> > > reduce dereferences.
> > > 
> > > This is not "random code tweaks".
> > If you cannot observe a performance change, then adjusting the commit
> > description to explain this as a code cleanup to reduce dereferences and
> > local variables, improving code readability seems fine to me. I think
> > it's a nice cleanup when presented as such rather than a performance
> > optimization.
> > 
> > Stefan
> 
> Sure. Please check the bellow adjustment:
> 
> virtio_blk: implement init_hctx MQ operation
> 
> Set the driver data of the hardware context (hctx) to point directly to
> the virtio block queue. This cleanup improves code readability, reduces
> the number of dereferences, and minimizes local variables in the fast
> path.

I'd drop the local variables part, it is not at all clear why is that
a win.

-- 
MST



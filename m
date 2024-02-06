Return-Path: <kvm+bounces-8163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4134184BFAC
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 23:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D991F22989
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FB01BDE1;
	Tue,  6 Feb 2024 22:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xzu1OTGe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7C51B94F
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 22:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707257027; cv=none; b=dQoLpl7SfbCG/omxs/olQmV0GNDP0hfOI53X9Y8sEb/3xbAuC6phBM0TYQS+gQpplzG7Dbamg3B8etlo9O+9MJQeFsaXsZnFScPbzIzFyJQLQ2HBKw8RWDTNGsTodGhznuM7/sVqqgo9iSRYOS/l+xaeBsWbjfOu8wvM8SyEOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707257027; c=relaxed/simple;
	bh=zElfxugSAaICSwSSy+gtvyX3G5fBSjbaZmZkf6g4Mp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNzRXeEIDv553Gu/MI5to7aq5l1+JyqU+3NhY0/8oMtm05nbd05MKjo5dvs/bKi1AR9e3dTeR582ixJQ5E4A1cjkZB1SonJyTy+L4X55qy3v1ulKmjWzQMWA9XxtTJxltq3uBz+FnRmDflG5j/RaAD+VoQcZ8EDU4ketRrssULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xzu1OTGe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707257025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDKzvyBK0Sw7QBvN0Qa/Z/hBlRKiTfiQLbziKDVBqPY=;
	b=Xzu1OTGe71CHkUbx7CDn21DKbRBFjfY0usNQiFofbeOEYGA9z57MCpVZfd9g0nwEvUSQEv
	Aubg1XI0q9OT6B8ZErog8JJ3IHCHkuyyYp8NI6OJIFD3cMPwL1nKaOXU34i1nfCyx6x06L
	4HYFM7YyHjsGgeoGNHkyi2y3ZpXlLpM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-YhkiFI2gPrKA9xRfWzKcGQ-1; Tue, 06 Feb 2024 17:03:43 -0500
X-MC-Unique: YhkiFI2gPrKA9xRfWzKcGQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-363be7d5b20so37231095ab.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 14:03:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707257023; x=1707861823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDKzvyBK0Sw7QBvN0Qa/Z/hBlRKiTfiQLbziKDVBqPY=;
        b=R9WzeL1cznird+nxtrhBoQWydfNlACj9uydTCbyfnPzXjeiEDeNgn2JRscM5Xi1gz2
         2wW1RGo8myOb7EREYT/PTwr57xTTGKHScEi88jzULCvQk8rxO/LCcy3nva77eNCAfKBk
         NWHuNAtLUDvQmlWpHu2fypj8uOUFBVLC6OrzafxLnSxJhAxrbDVdF58xTJcvoXJwd84o
         Jp0e4/b0L+0UU5zDPqMdyVijOPWMO9HhSvSSzS8FKPTkjSNongxUsHEN6W7w3y5gamcD
         S+LXlObxI1YeJOG6Fdm6DVSHB8+0TxvkTgtMoohARpNPd/oUGK3Sn3tbM/z6zra/bF+J
         NjoA==
X-Gm-Message-State: AOJu0Yx2HnJaxmmAXr3lFWlC4W0YiRBDGdhSMOU3vRvuTkBaoUzzz8Dp
	4tE0Q7FmX61EOnXU+/bXvia0+RVdC+7CZ8qIw48ywk34lSZ30CTppXpGI19jpusOS3S3hu5T+45
	0uYkjlheymRXvOjVW4gLWA7e67DM9hWhO293BbNl5mfRKgKFI8A==
X-Received: by 2002:a05:6e02:2187:b0:363:c4b9:d931 with SMTP id j7-20020a056e02218700b00363c4b9d931mr4354094ila.20.1707257023142;
        Tue, 06 Feb 2024 14:03:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEgmMurPiFX0s3p0W6ncNls4hF9xdUc1jGMmQC3nf9N/Pwq4ZKJ9xLB+JmCr61NA+quPismg==
X-Received: by 2002:a05:6e02:2187:b0:363:c4b9:d931 with SMTP id j7-20020a056e02218700b00363c4b9d931mr4354072ila.20.1707257022938;
        Tue, 06 Feb 2024 14:03:42 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXQzH2XLbn+eAliDfhQRmJ9GpqgucS43F2DwvbQAkrFSAfd1TrkUQ5NRwDPMzidsOvSj4+nXSlxS9ud1ag5oX6OCc0G89se0V83F9Gfc39s2FZppNKaAyYqSSIdrl15ov7pMBuBnavHAX3E2wiY9epoN/SnpYXfehS9YMnJRU+EgLZVr/IIG3JmF5jv46+7cIuqbx4MAkALe1xbXBMaDJtI1tKwh7QGEsu2i/2Cm1H7jFz382dWccXVV8UETzln47spDRfk4YKw686grjtiT6aqO2S+fxL9JcuPm4rcPjYBsnAoIiQA8d0XlX2j4zn6jJiq1Z7O5A==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id bp30-20020a056e02349e00b0036287013d01sm793765ilb.36.2024.02.06.14.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 14:03:42 -0800 (PST)
Date: Tue, 6 Feb 2024 15:03:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240206150341.798bb9fe.alex.williamson@redhat.com>
In-Reply-To: <5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
	<20240205153542.0883e2ff.alex.williamson@redhat.com>
	<5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Feb 2024 13:46:37 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 2/5/2024 2:35 PM, Alex Williamson wrote:
> > On Thu,  1 Feb 2024 20:57:09 -0800
> > Reinette Chatre <reinette.chatre@intel.com> wrote:  
> 
> ..
> 
> >> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
> >>  		if (is_intx(vdev))
> >>  			return vfio_irq_set_block(vdev, start, count, fds, index);
> >>  
> >> -		ret = vfio_intx_enable(vdev);
> >> +		ret = vfio_intx_enable(vdev, start, count, index);  
> > 
> > Please trace what happens when a user calls SET_IRQS to setup a trigger
> > eventfd with start = 0, count = 1, followed by any other combination of
> > start and count values once is_intx() is true.  vfio_intx_enable()
> > cannot be the only place we bounds check the user, all of the INTx
> > callbacks should be an error or nop if vector != 0.  Thanks,
> >   
> 
> Thank you very much for catching this. I plan to add the vector
> check to the device_name() and request_interrupt() callbacks. I do
> not think it is necessary to add the vector check to disable() since
> it does not operate on a range and from what I can tell it depends on
> a successful enable() that already contains the vector check. Similar,
> free_interrupt() requires a successful request_interrupt() (that will
> have vector check in next version).
> send_eventfd() requires a valid interrupt context that is only
> possible if enable() or request_interrupt() succeeded.

Sounds reasonable.

> If user space creates an eventfd with start = 0 and count = 1
> and then attempts to trigger the eventfd using another combination then
> the changes in this series will result in a nop while the current
> implementation will result in -EINVAL. Is this acceptable?

I think by nop, you mean the ioctl returns success.  Was the call a
success?  Thanks,

Alex



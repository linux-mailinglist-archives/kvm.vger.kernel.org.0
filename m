Return-Path: <kvm+bounces-20065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F084910214
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E31B1F21AFD
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF24D1A4F3C;
	Thu, 20 Jun 2024 11:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+H+Hj2j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F71AB36C
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718881379; cv=none; b=ZgWMdctubSpeF51VROnTK7ZGMSdeMfmQX+PnoWZ5k102VfUO+6CslgqlazU2RHXAna752/sp3TiFREXR99hbi21ja4Wyj7dwxrwwqA3CjPO/dIL/z/Iz8NiAmqgLschKZ+hNfdn6D1CbojPY/3ZuhLwPwiwV+tNv3vzwhTgK5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718881379; c=relaxed/simple;
	bh=vGdRlcjv/RpN0dRyZVCEx27/MH7ZqApjf2QhNbFfyeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhkGnzSQ8C8hrDrj9gqp7kr7oBNsK10wnJ2JDrgLra++/mhTWZuKJpuXxxNcw4zQmB03QC6CNU3p1vAnO24y3tEvybmbvEF9sl6WecbQOLNbExiSXO4tGLb5hpyaOYGY9ZcofVcIr10IpWmQaOjcggfJauW5p8NhjWkbXCHjMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+H+Hj2j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718881376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L86P9p9ZvtyDbyslOiO/HjffdgPvxJf/CzTLlhPlSzk=;
	b=L+H+Hj2j0Sga30Ubof+z5knGKI7Vd8DShHcZywvwGCsMiWcHsAyf3GNbaU0nGxnKgtxsiB
	CvDwEU/HhDIt6bev9orKdyW6nB3G1dhmQJ/36m3fvSatsTHWZDfBIIVI21uA19c66YIsLi
	aeli42MM75TbpHRghQKhpEdqX4v5Jhg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-DCLX0J-eMT6g6Op0eZFn2g-1; Thu, 20 Jun 2024 07:02:55 -0400
X-MC-Unique: DCLX0J-eMT6g6Op0eZFn2g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a6e37310ebaso27117266b.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 04:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718881373; x=1719486173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L86P9p9ZvtyDbyslOiO/HjffdgPvxJf/CzTLlhPlSzk=;
        b=mO9gBw7eU4KUmPM87ho516K7ztoFfTA4aeJbG4Xf9Ow+MOMrq2+srT9nAqxXA7Xk0f
         pXvgTlxCSZcawWGByVM6BVZ4C7wk6FYLWxE1A+th/DM234TAGsyInb5I0Vaj2Izr5OUq
         9fWwBNAe24I7tNTcvS1q9leHbIwbGB+CsBwGedvaKnaQSERTelDD734u+4s4ApeSnV5z
         EwOlo7Bf5y5NFTYfhtvjBLgZsH8UzYBWCYKSOfZDkQf1fOwvQaWCwVCcPQvJD6ARWeQL
         frl2D1+hmftZOKNUuqVCvW0XtdjRaoCya4L336Pq5FzvcuftBRVKAzzA7m17Qf56VVvk
         JZzA==
X-Forwarded-Encrypted: i=1; AJvYcCUZoGwigFB3RXos4jDW16GeFfIwySiofGiV1PiHCnuk0X1dnzdOwlU1e+HeE/cwDDgyZFyLuP/e2hzApqDiEqhVB/Il
X-Gm-Message-State: AOJu0YybaRjLTsAEdwQlKf3ikdYH9ggXXpLcxzrWSAfAcuLxDeGahItK
	DWxUpodd7TDg5NapsbBWO/JqbhO6CWkO+hblCZ4F16VH9ObhttEAjWPVsVSxv85RAqDu0+tyJSK
	7M43xTWvBjIKZs9Ze/N7GZfcavJoHJ0dl2G0ZOO0TPQREy498Lw==
X-Received: by 2002:a17:907:c784:b0:a6c:6f0a:e147 with SMTP id a640c23a62f3a-a6fab60b7dcmr378356266b.12.1718881373485;
        Thu, 20 Jun 2024 04:02:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9ewuijCjZ27aNU5MO4PJFwz4g9SWyjJ53x/p01TNo2aDQBodgE2tKraqk860qD0d8VNM0qQ==
X-Received: by 2002:a17:907:c784:b0:a6c:6f0a:e147 with SMTP id a640c23a62f3a-a6fab60b7dcmr378352966b.12.1718881372869;
        Thu, 20 Jun 2024 04:02:52 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f9978esm749086966b.200.2024.06.20.04.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 04:02:51 -0700 (PDT)
Date: Thu, 20 Jun 2024 07:02:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH vhost v9 2/6] virtio: remove support for names array
 entries being null.
Message-ID: <20240620065602-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>
 <20240620035749-mutt-send-email-mst@kernel.org>
 <1718872778.4831812-1-xuanzhuo@linux.alibaba.com>
 <20240620044839-mutt-send-email-mst@kernel.org>
 <1718874293.698573-2-xuanzhuo@linux.alibaba.com>
 <20240620054548-mutt-send-email-mst@kernel.org>
 <1718880548.281809-3-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1718880548.281809-3-xuanzhuo@linux.alibaba.com>

On Thu, Jun 20, 2024 at 06:49:08PM +0800, Xuan Zhuo wrote:
> On Thu, 20 Jun 2024 06:01:54 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Jun 20, 2024 at 05:04:53PM +0800, Xuan Zhuo wrote:
> > > On Thu, 20 Jun 2024 05:01:08 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Thu, Jun 20, 2024 at 04:39:38PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 20 Jun 2024 04:02:45 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > > On Wed, Apr 24, 2024 at 05:15:29PM +0800, Xuan Zhuo wrote:
> > > > > > > commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> > > > > > > support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> > > > > > > doesn't apply. And not one uses this.
> > > > > > >
> > > > > > > On the other side, that makes some trouble for us to refactor the
> > > > > > > find_vqs() params.
> > > > > > >
> > > > > > > So I remove this support.
> > > > > > >
> > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> > > > > > > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > > > > >
> > > > > >
> > > > > > I don't mind, but this patchset is too big already.
> > > > > > Why do we need to make this part of this patchset?
> > > > >
> > > > >
> > > > > If some the pointers of the names is NULL, then in the virtio ring,
> > > > > we will have a trouble to index from the arrays(names, callbacks...).
> > > > > Becasue that the idx of the vq is not the index of these arrays.
> > > > >
> > > > > If the names is [NULL, "rx", "tx"], the first vq is the "rx", but index of the
> > > > > vq is zero, but the index of the info of this vq inside the arrays is 1.
> > > >
> > > >
> > > > Ah. So actually, it used to work.
> > > >
> > > > What this should refer to is
> > > >
> > > > commit ddbeac07a39a81d82331a312d0578fab94fccbf1
> > > > Author: Wei Wang <wei.w.wang@intel.com>
> > > > Date:   Fri Dec 28 10:26:25 2018 +0800
> > > >
> > > >     virtio_pci: use queue idx instead of array idx to set up the vq
> > > >
> > > >     When find_vqs, there will be no vq[i] allocation if its corresponding
> > > >     names[i] is NULL. For example, the caller may pass in names[i] (i=4)
> > > >     with names[2] being NULL because the related feature bit is turned off,
> > > >     so technically there are 3 queues on the device, and name[4] should
> > > >     correspond to the 3rd queue on the device.
> > > >
> > > >     So we use queue_idx as the queue index, which is increased only when the
> > > >     queue exists.
> > > >
> > > >     Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > > >     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > >
> > >
> > > That just work for PCI.
> > >
> > > The trouble I described is that we can not index in the virtio ring.
> > >
> > > In virtio ring, we may like to use the vq.index that do not increase
> > > for the NULL.
> > >
> > >
> > > >
> > > > Which made it so setting names NULL actually does not reserve a vq.
> > > >
> > > > But I worry about non pci transports - there's a chance they used
> > > > a different index with the balloon. Did you test some of these?
> > > >
> > >
> > > Balloon is out of spec.
> > >
> > > The vq.index does not increase for the name NULL. So the Balloon use the
> > > continuous id. That is out of spec.
> >
> >
> > I see. And apparently the QEMU implementation is out of spec, too,
> > so they work fine. And STATS is always on in QEMU.
> >
> > That change by Wei broke the theoretical config which has
> > !STATS but does have FREE_PAGE. We never noticed - not many people
> > ever bothered with FREE_PAGE.
> >
> > However QEMU really is broken in a weird way.
> > In particular if it exposes STATS but driver does not
> > configure STATS then QEMU still has the stats vq.
> > Things will break then.
> >
> >
> > In short, it's a mess, and it needs thought.
> > At this point I suggest we keep the ability to set
> > names to NULL in case we want to just revert Wei's patch.
> >
> >
> >
> > > That does not matter for this patchset.
> > > The name NULL is always skipped.
> > >
> > > Thanks.
> >
> >
> > Let's keep this patchset as small as possible.
> > Keep the existing functionality, we'll do cleanups
> > later.
> 
> 
> I am ok. But we need a idx to index the info of the vq.
> 
> How about a new element "cfg_idx" to virtio_vq_config.
> 
> struct virtio_vq_config {
> 	unsigned int nvqs;
> ->	unsigned int cfg_idx;
> 
> 	struct virtqueue   **vqs;
> 	vq_callback_t      **callbacks;
> 	const char         **names;
> 	const bool          *ctx;
> 	struct irq_affinity *desc;
> };
> 
> 
> That is setted by transport. The virtio ring can use this to index the info
> of the vq. Then the #1 #2 commits can be dropped.
> 
> 
> Thanks.
> 

I'm not sure why you need this in the API.


Actually now I think about it, the whole struct is weird.
I think nvqs etc should be outside the struct.
All arrays are the same size, why not:

struct virtio_vq_config {
 	vq_callback_t      callback;
 	const char         *name;
 	const bool          ctx;
};

And find_vqs should get an array of these.
Leave the rest of params alone.


> 
> >
> >
> > > > --
> > > > MST
> > > >
> >



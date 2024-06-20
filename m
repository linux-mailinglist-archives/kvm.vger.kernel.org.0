Return-Path: <kvm+bounces-20077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B56569106CF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AF0EB22340
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B391AD491;
	Thu, 20 Jun 2024 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHXIc83i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A328175E
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 13:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718891536; cv=none; b=U3aYO7Aa5cMP9qXaS5uWmxv1hEOkASdGt+DcLde2xAf/B2u3L9H7QyNijyHn6m3yk+LrIwchypTkwSHMY7P4i8ThBgr5mw8l9CcnempTDlFTVdmRmX6g1YTrLmDl9YMEc6flEdto7i0+RZWRkEeOycTseAGD4dmJEJwpXKeWXwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718891536; c=relaxed/simple;
	bh=kZFzGdFBvUz4Gg6I42gew9txHyVBgSQU2rWpWdCqIqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIC5F97MqJnouqOgWj+MSbYHHF4bWIdm84/h8aJgTvfHORY3KaU6HqE6MU5MTdTjfLq8W79MVhy44Xa6mLjtfgf0pEvqUymV5hprTokXWJhwHB5NrRdQvqaZP112hJ4Hgk1q0Cpj2gNQaSJetpw2vKDQziNkoNyVXl6rL3WUmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHXIc83i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718891534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CNpcAjabNj7U5Kjrejmg/ilwXEXZseiB+OI7rnWLE5Q=;
	b=FHXIc83i1IFWAuvZ7bO1DC+WKv5kV+miQ9+UeFzbllGG7IQGwEqhEEpG5b7My3VBZLCRwE
	vGv4l6uxgC43fjtyqXPlfwu4TFkoZzWg32rmnDSGoY18Ri2n3Vsn6gHGTvibppJ4mU6o4N
	4Ak8M9xODdGIz2cae0ZdVPJVzUGHUU4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-5hCJ6vJ8Md2QECNgaJuuJw-1; Thu, 20 Jun 2024 09:52:12 -0400
X-MC-Unique: 5hCJ6vJ8Md2QECNgaJuuJw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-57851ae6090so530699a12.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 06:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718891531; x=1719496331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNpcAjabNj7U5Kjrejmg/ilwXEXZseiB+OI7rnWLE5Q=;
        b=XUCDT1cyYYcZZVDAfJa6HqdAAOHn+kh690qDcq1cENb4C+Ds6e8senaqojvxMrbR8E
         lgQV+VA3Hq1/3i3DisFTyBFEYzynboU6mMLJl5vjAdHqn0MTfvtDMt+iYERRD2IDatMb
         j6pWOtaoQ3INW1a2omg8rlKZJZGIAjinJwPq3Q9Pb+Tnd6z4EiwvKUPIGC7rZsksBUX5
         sWQ9eLyyBSCYkRV6D8PbjmD4pBiz7gNMjZH5O2mviJhTUZiiZl1PsjMJ+RngMiORUY9t
         i6xeEYUkZiwMoSpw0JLUAeAObxVN4prud2XJUprd81CWteyfSz60rraVecWFLi1+Hfxu
         YWew==
X-Forwarded-Encrypted: i=1; AJvYcCVJUTXwXkrkgpj6e7z4u15zCx+FI8ucF793eTLB6nHHboWOi1zS82IQN9k4hv4NRaLyt8o0DjsjntjVB3yLfdLebi1x
X-Gm-Message-State: AOJu0Yz84g1QNbh0xsn/rf2NDLHFFbOsPyVsYE7sX1oKGNij68ucaHmO
	N0qLQP9Q3E65zviVGFCi7CSphjPmUIhZz/CaVb5nXOqQHdgndaDBZCxtWKfkXD32RLWAWIt2EwB
	txMVSnSQ7OdiyBET9czp/gsU34FGyWVzHOKTJpIilrULwc9Metw==
X-Received: by 2002:a50:aad7:0:b0:578:3335:6e88 with SMTP id 4fb4d7f45d1cf-57d07c59ce6mr3503150a12.0.1718891531434;
        Thu, 20 Jun 2024 06:52:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF90OFOGv2ZZVHJ5dm1EVg30XUQltEQfgDt90ACAE1nuPoxRvgkNZnMIK5JtmqXjWOLvdB0xw==
X-Received: by 2002:a50:aad7:0:b0:578:3335:6e88 with SMTP id 4fb4d7f45d1cf-57d07c59ce6mr3503106a12.0.1718891530819;
        Thu, 20 Jun 2024 06:52:10 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb743b026sm9630648a12.97.2024.06.20.06.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 06:52:10 -0700 (PDT)
Date: Thu, 20 Jun 2024 09:51:58 -0400
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
Message-ID: <20240620070717-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>
 <20240620035749-mutt-send-email-mst@kernel.org>
 <1718872778.4831812-1-xuanzhuo@linux.alibaba.com>
 <20240620044839-mutt-send-email-mst@kernel.org>
 <1718874293.698573-2-xuanzhuo@linux.alibaba.com>
 <20240620054548-mutt-send-email-mst@kernel.org>
 <1718880548.281809-3-xuanzhuo@linux.alibaba.com>
 <20240620065602-mutt-send-email-mst@kernel.org>
 <1718881448.8979208-6-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1718881448.8979208-6-xuanzhuo@linux.alibaba.com>

On Thu, Jun 20, 2024 at 07:04:08PM +0800, Xuan Zhuo wrote:
> On Thu, 20 Jun 2024 07:02:42 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Jun 20, 2024 at 06:49:08PM +0800, Xuan Zhuo wrote:
> > > On Thu, 20 Jun 2024 06:01:54 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Thu, Jun 20, 2024 at 05:04:53PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 20 Jun 2024 05:01:08 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > > On Thu, Jun 20, 2024 at 04:39:38PM +0800, Xuan Zhuo wrote:
> > > > > > > On Thu, 20 Jun 2024 04:02:45 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > > > > On Wed, Apr 24, 2024 at 05:15:29PM +0800, Xuan Zhuo wrote:
> > > > > > > > > commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> > > > > > > > > support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> > > > > > > > > doesn't apply. And not one uses this.
> > > > > > > > >
> > > > > > > > > On the other side, that makes some trouble for us to refactor the
> > > > > > > > > find_vqs() params.
> > > > > > > > >
> > > > > > > > > So I remove this support.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> > > > > > > > > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > > > > > > >
> > > > > > > >
> > > > > > > > I don't mind, but this patchset is too big already.
> > > > > > > > Why do we need to make this part of this patchset?
> > > > > > >
> > > > > > >
> > > > > > > If some the pointers of the names is NULL, then in the virtio ring,
> > > > > > > we will have a trouble to index from the arrays(names, callbacks...).
> > > > > > > Becasue that the idx of the vq is not the index of these arrays.
> > > > > > >
> > > > > > > If the names is [NULL, "rx", "tx"], the first vq is the "rx", but index of the
> > > > > > > vq is zero, but the index of the info of this vq inside the arrays is 1.
> > > > > >
> > > > > >
> > > > > > Ah. So actually, it used to work.
> > > > > >
> > > > > > What this should refer to is
> > > > > >
> > > > > > commit ddbeac07a39a81d82331a312d0578fab94fccbf1
> > > > > > Author: Wei Wang <wei.w.wang@intel.com>
> > > > > > Date:   Fri Dec 28 10:26:25 2018 +0800
> > > > > >
> > > > > >     virtio_pci: use queue idx instead of array idx to set up the vq
> > > > > >
> > > > > >     When find_vqs, there will be no vq[i] allocation if its corresponding
> > > > > >     names[i] is NULL. For example, the caller may pass in names[i] (i=4)
> > > > > >     with names[2] being NULL because the related feature bit is turned off,
> > > > > >     so technically there are 3 queues on the device, and name[4] should
> > > > > >     correspond to the 3rd queue on the device.
> > > > > >
> > > > > >     So we use queue_idx as the queue index, which is increased only when the
> > > > > >     queue exists.
> > > > > >
> > > > > >     Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > > > > >     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > >
> > > > >
> > > > > That just work for PCI.
> > > > >
> > > > > The trouble I described is that we can not index in the virtio ring.
> > > > >
> > > > > In virtio ring, we may like to use the vq.index that do not increase
> > > > > for the NULL.
> > > > >
> > > > >
> > > > > >
> > > > > > Which made it so setting names NULL actually does not reserve a vq.
> > > > > >
> > > > > > But I worry about non pci transports - there's a chance they used
> > > > > > a different index with the balloon. Did you test some of these?
> > > > > >
> > > > >
> > > > > Balloon is out of spec.
> > > > >
> > > > > The vq.index does not increase for the name NULL. So the Balloon use the
> > > > > continuous id. That is out of spec.
> > > >
> > > >
> > > > I see. And apparently the QEMU implementation is out of spec, too,
> > > > so they work fine. And STATS is always on in QEMU.
> > > >
> > > > That change by Wei broke the theoretical config which has
> > > > !STATS but does have FREE_PAGE. We never noticed - not many people
> > > > ever bothered with FREE_PAGE.
> > > >
> > > > However QEMU really is broken in a weird way.
> > > > In particular if it exposes STATS but driver does not
> > > > configure STATS then QEMU still has the stats vq.
> > > > Things will break then.
> > > >
> > > >
> > > > In short, it's a mess, and it needs thought.
> > > > At this point I suggest we keep the ability to set
> > > > names to NULL in case we want to just revert Wei's patch.
> > > >
> > > >
> > > >
> > > > > That does not matter for this patchset.
> > > > > The name NULL is always skipped.
> > > > >
> > > > > Thanks.
> > > >
> > > >
> > > > Let's keep this patchset as small as possible.
> > > > Keep the existing functionality, we'll do cleanups
> > > > later.
> > >
> > >
> > > I am ok. But we need a idx to index the info of the vq.
> > >
> > > How about a new element "cfg_idx" to virtio_vq_config.
> > >
> > > struct virtio_vq_config {
> > > 	unsigned int nvqs;
> > > ->	unsigned int cfg_idx;
> > >
> > > 	struct virtqueue   **vqs;
> > > 	vq_callback_t      **callbacks;
> > > 	const char         **names;
> > > 	const bool          *ctx;
> > > 	struct irq_affinity *desc;
> > > };
> > >
> > >
> > > That is setted by transport. The virtio ring can use this to index the info
> > > of the vq. Then the #1 #2 commits can be dropped.
> > >
> > >
> > > Thanks.
> > >
> >
> > I'm not sure why you need this in the API.
> >
> >
> > Actually now I think about it, the whole struct is weird.
> > I think nvqs etc should be outside the struct.
> > All arrays are the same size, why not:
> >
> > struct virtio_vq_config {
> >  	vq_callback_t      callback;
> >  	const char         *name;
> >  	const bool          ctx;
> > };
> >
> > And find_vqs should get an array of these.
> > Leave the rest of params alone.
> 
> 
> YES, this is great.
> 
> I thought about this.
> 
> The trouble is that all the callers need to be changed.
> That are too many.
> 
> Thanks.
> 

Not too many.


> >
> >
> > >
> > > >
> > > >
> > > > > > --
> > > > > > MST
> > > > > >
> > > >
> >



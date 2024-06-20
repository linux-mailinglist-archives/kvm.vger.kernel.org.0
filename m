Return-Path: <kvm+bounces-20072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F60910329
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AD8F1F21BB4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756E51ACE62;
	Thu, 20 Jun 2024 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2Dc3nFL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE331ABCD5
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883466; cv=none; b=NkjFwlKbCQPTNH0Xo4WZ6f7MoQz8A4kHTsJohOElGvJ2/cB/uFjbh9bmFK0ZoBz01faX/XUr+ip0EhtfZtvhkXx4r/jv+gllUDDnsg7MVq/TjZCXgwWsonJ5vYIJ1YkJ7hhHL6/kIMR+t20FAwNR6JbgrMtxWaE9dzgQgv9FCHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883466; c=relaxed/simple;
	bh=+BUuzt0EV0E7b5HL9H0lKiRQzBuiOBmGvgWVpf0cnf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeiKSZbqXolAybCpI+hGlmHA/ZTgC+JFvlYp2MjrgepBvZYxBBExasXinDEur3pQ1DJelUUO5FkB5ajHnXd8UgVYlJW85CT5f3xe6CFnMdq60h6n7YiP4+7j6Oq3N0Q2fGL7ecCBFCULivHwOk+kg75kuNy6lgmPVLTGFmHNZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2Dc3nFL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718883464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0vRFjJoymfNkJ7AiCzZKbFSRm1LITjQgITc8revWNM=;
	b=E2Dc3nFLTCevt7RBWeSCN1qQxxLjVCwtYidCon7qRWZnlHfEkdtGa3o9/G4j+qkcM81vzo
	ibiAMvW6KYEixsay9+5nTsy939xhUx6JM9B0m7BOzSdL6q/n+48gw1QU7rSC/6/W7NuXvh
	zAG5ex41dRkwsi11UC/Xx322SloNJpg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-VWjwe2VxNlWBbNHn7Kcp5A-1; Thu, 20 Jun 2024 07:37:42 -0400
X-MC-Unique: VWjwe2VxNlWBbNHn7Kcp5A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a6f2af30793so35566866b.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 04:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718883461; x=1719488261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0vRFjJoymfNkJ7AiCzZKbFSRm1LITjQgITc8revWNM=;
        b=ezj9iCTuZnBx7nZvRHL+owhlscnAA9SSNafUIn3itBGCV+9Mx4EIIoGmHAuGZhyco9
         Rvso3Wi+NwiNpR7zsNwMVoAWzXmgS319bWKPQnaRtx6uGRgwhZRXZ/9I5bK0DuOmT2vl
         yJr+S9TPIB0ZInCPgVyiZgVnyX1Agml2FEIlX9jO7Z8nMABOxcY8DUhQrNQT9HEdcZIR
         Kt2TxcfbBstdbj4U0p2uKB4wp+HSJHoNwzfy4DN/WBN9YrMH3NP60YU4MUOKIRw6LA4v
         MdqSwWXxNocx42STIfC7Fykbo3ljjwW+TD0qCkUM6cViTmtHZ2QKknTqqpkgGg/ITatO
         gFrw==
X-Forwarded-Encrypted: i=1; AJvYcCUS17dISvnzJYNDDhjAdFuTacOeXJC6fpofDhipkUM5148v4QtHyr+E6tm2LLTrdNVXLcHoY/lY9RJ7x2iaFIv3Zez0
X-Gm-Message-State: AOJu0YyqRgbdjZ6YyTGs4Uqkr+kfo1LgXLrX16t+aoXhHq944+za+0yj
	VqL5W9RUmnyApeA3dVrHEOBxjNClYvjaXh5bGkuFkKUg3gRaPOX8ERKlujsZRgN8fkVd2ecnQXH
	MauUVzUxWzf2XJjCAKEdVXpqvOrJ+h82+Dg0iJrak856YrMp7ow==
X-Received: by 2002:a17:907:198e:b0:a68:a800:5f7e with SMTP id a640c23a62f3a-a6fab605032mr323036166b.10.1718883461409;
        Thu, 20 Jun 2024 04:37:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDIGM+jwPnAqXhfTi5j68F0TiQKYd3uIDh3xaq5X5qn943fCJOq9d8Dl2broWQ/a34GcpdjA==
X-Received: by 2002:a17:907:198e:b0:a68:a800:5f7e with SMTP id a640c23a62f3a-a6fab605032mr323032466b.10.1718883460605;
        Thu, 20 Jun 2024 04:37:40 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ecdce5sm752536366b.108.2024.06.20.04.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 04:37:39 -0700 (PDT)
Date: Thu, 20 Jun 2024 07:37:32 -0400
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
	kvm@vger.kernel.org
Subject: Re: [PATCH vhost v9 3/6] virtio: find_vqs: pass struct instead of
 multi parameters
Message-ID: <20240620073111-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-4-xuanzhuo@linux.alibaba.com>
 <20240620034823-mutt-send-email-mst@kernel.org>
 <1718874049.457552-1-xuanzhuo@linux.alibaba.com>
 <20240620050545-mutt-send-email-mst@kernel.org>
 <1718875249.1787696-3-xuanzhuo@linux.alibaba.com>
 <20240620061202-mutt-send-email-mst@kernel.org>
 <1718880210.0475078-2-xuanzhuo@linux.alibaba.com>
 <20240620070354-mutt-send-email-mst@kernel.org>
 <1718881968.7394087-7-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1718881968.7394087-7-xuanzhuo@linux.alibaba.com>

On Thu, Jun 20, 2024 at 07:12:48PM +0800, Xuan Zhuo wrote:
> On Thu, 20 Jun 2024 07:06:53 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Jun 20, 2024 at 06:43:30PM +0800, Xuan Zhuo wrote:
> > > On Thu, 20 Jun 2024 06:15:08 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Thu, Jun 20, 2024 at 05:20:49PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 20 Jun 2024 05:14:24 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > > On Thu, Jun 20, 2024 at 05:00:49PM +0800, Xuan Zhuo wrote:
> > > > > > > > > @@ -226,21 +248,37 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
> > > > > > > > >
> > > > > > > > >  static inline
> > > > > > > > >  int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > > > > > > > > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > > > > -			const char * const names[],
> > > > > > > > > -			struct irq_affinity *desc)
> > > > > > > > > +		    struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > > > > +		    const char * const names[],
> > > > > > > > > +		    struct irq_affinity *desc)
> > > > > > > > >  {
> > > > > > > > > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> > > > > > > > > +	struct virtio_vq_config cfg = {};
> > > > > > > > > +
> > > > > > > > > +	cfg.nvqs = nvqs;
> > > > > > > > > +	cfg.vqs = vqs;
> > > > > > > > > +	cfg.callbacks = callbacks;
> > > > > > > > > +	cfg.names = (const char **)names;
> > > > > > > >
> > > > > > > >
> > > > > > > > Casting const away? Not safe.
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > Because the vp_modern_create_avq() use the "const char *names[]",
> > > > > > > and the virtio_uml.c changes the name in the subsequent commit, so
> > > > > > > change the "names" inside the virtio_vq_config from "const char *const
> > > > > > > *names" to "const char **names".
> > > > > >
> > > > > > I'm not sure I understand which commit you mean,
> > > > > > and this kind of change needs to be documented, but it does not matter.
> > > > > > Don't cast away const.
> > > > >
> > > > >
> > > > > Do you mean change the virtio_find_vqs(), from
> > > > > const char * const names[] to const char *names[].
> > > > >
> > > > > And update the caller?
> > > > >
> > > > > If we do not cast the const, we need to update all the caller to remove the
> > > > > const.
> > > > >
> > > > > Right?
> > > > >
> > > > > Thanks.
> > > >
> > > >
> > > > Just do not split the patchset at a boundary that makes you do that.
> > > > If you are passing in an array from a const section then it
> > > > has to be const and attempts to change it are a bad idea.
> > >
> > > Without this patch set:
> > >
> > > static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> > > 				     unsigned index, vq_callback_t *callback,
> > > 				     const char *name, bool ctx)
> > > {
> > > 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> > > 	struct platform_device *pdev = vu_dev->pdev;
> > > 	struct virtio_uml_vq_info *info;
> > > 	struct virtqueue *vq;
> > > 	int num = MAX_SUPPORTED_QUEUE_SIZE;
> > > 	int rc;
> > >
> > > 	info = kzalloc(sizeof(*info), GFP_KERNEL);
> > > 	if (!info) {
> > > 		rc = -ENOMEM;
> > > 		goto error_kzalloc;
> > > 	}
> > > ->	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> > > 		 pdev->id, name);
> > >
> > > 	vq = vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
> > > 				    ctx, vu_notify, callback, info->name);
> > >
> > >
> > > The name is changed by vu_setup_vq().
> > > If we want to pass names to
> > > virtio ring, the names must not be  "const char * const"
> > >
> > > And the admin queue of pci do the same thing.
> > >
> > > And I think you are right, we should not cast the const.
> > > So we have to remove the "const" from the source.
> > > And I checked the source code, if we remove the "const", I think
> > > that makes sense.
> > >
> > > Thanks.
> >
> > /facepalm
> >
> > This is a different const.
> >
> >
> > There should be no need to drop the annotation, core
> > does not change these things and using const helps make
> > sure that is the case.
> 
> 
> If you do not like this, the left only way is to allocate new
> memory to store the info, if the caller do not change.
> 
> In the further, maybe the caller can use the follow struct directly.
> 
> struct virtio_vq_config {
>  	vq_callback_t      callback;
>  	const char         *name;
>  	const bool          ctx;
> };
> 
> For now, we can allocate memory to change the arrays (names, callbacks..)
> to the array of struct virtio_vq_config.
> 
> And the find_vqs() accepts the array of struct virtio_vq_config.
> 
> How about this?
> 
> Thanks.


Basically I am not sure how bad a single big patch would be.


> >
> >
> >
> > >
> > >
> > > >
> > > >
> > > > > >
> > > > > > --
> > > > > > MST
> > > > > >
> > > >
> >



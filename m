Return-Path: <kvm+bounces-12072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B3787F7D9
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 07:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA21F1F22032
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 06:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F06551026;
	Tue, 19 Mar 2024 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ccna45qx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEA750A73
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 06:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831483; cv=none; b=mCcT9Z3UFrtPoqtMpW7TSyOHkttt7oVHxH7pFVa6QOgLBgXFt4S9I3HjSjWGwBiZ/4UkdTGUQCDR97/ZGwlwI8/bKJN0NoyIm8kLAzb8KkjfqAyNBtl5aFyxBea7JapsF3fh3xrqMRRva2OGvJ8RjsD7WJ0Il+DNluInig3aBuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831483; c=relaxed/simple;
	bh=sHkV9c2cCvUDbeVxr0z64spNW2KJ43//daE/hxW1fLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUCZXOnzo5EhH4TBfs1PNkAEbuQ3XdC/JAaPoxgsFkbjoo6Q96sXX+V+ZvWrdBOCwN5R3JfY36ROwmaADz2YSrNBYDOfl1SyKl4Cv1h1+Y9IT951yP85RwEoEfKIDh8QjrEDIxlPwRKu3JgRydlkODYuDA9gU4GhroRKHIjhpk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ccna45qx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710831481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKRneGfnw6MSOgt3Bh59h7eI+wlS3o3Ic4CAJ/J4VaI=;
	b=ccna45qxcItesRQv+aM1eh7qsl7bNnJPFM3hA4QPZV1mXTc5To6BfNv2flM7LE74mK9Ri2
	MwDifra2JXgcv4bCYmKUmy0PKkS4Zby3QxpJ+LUmNXE0F2JCnUCZvYTr/2rAjEzyzMayiC
	yY/j6hL09maF+0B7S59fcXyJOghl2kg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-nsGRtV1rOS2fVFjEUHJ6Qg-1; Tue, 19 Mar 2024 02:57:59 -0400
X-MC-Unique: nsGRtV1rOS2fVFjEUHJ6Qg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-568a088c211so2806463a12.2
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710831478; x=1711436278;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WKRneGfnw6MSOgt3Bh59h7eI+wlS3o3Ic4CAJ/J4VaI=;
        b=HhWhODcccdZOwvQUGrRzLEIsixagdYONmuR/8CH+hOlJAeyIDaa/Q1Os13lry2IJ/c
         NC6fbTu/bSsgzhU2tk9MjGbtM9v6F2ahW4QZ0QXTNWOvbqg2w/1JxQ3Gmef/GNDN+475
         1FNnUH8q+FqRhX52v90Bm2b7Tk404WrFGp/WJMqBiJo6OkYcMpN2u0k/fUt3hw0TLhHD
         bfSeD33QCUeKjuvmiTYsVDJ8nLUowvf1RJn26qooiP0BfiGdkEUYcGpqH3J18xKUQG0l
         WZ7DLXnBUqijziG8cP97nFLw3+m1YW+qPYfNSS5+zm49U6Weacn6NT/jp3Vl9kiGfp9R
         flIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW7StubMShpqRgaZIGw2T5I/TCQAXAYHR6uSjbqFh71hLHZ/ThISVrybV+pNyOXQk9MTf7OkccqBpKSaUYRugtegz3
X-Gm-Message-State: AOJu0YxTnTniPpCkIzX6VRFm23sJLW/R1uopGXdivzjmtJ3o9t7zQJpQ
	hBOszwa/qFuXE7GV95TJa+ZO5xHGREZEyUIl+qMO/2qzyOlZY+3FUBCbyJzebXArqjUDKzgotms
	u4fqa9Or4u7xDXKgZBR3fdzLSeevNf/Wbx2J7OmHUfm1ZG2LNNg==
X-Received: by 2002:a17:906:eece:b0:a46:c11d:dd01 with SMTP id wu14-20020a170906eece00b00a46c11ddd01mr4018595ejb.50.1710831477846;
        Mon, 18 Mar 2024 23:57:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe8W4rxWk1HBUws9HJcN3Gt6tuPLOzUx2clDG/sopbKziEHlsuK6XGj9oSKeqgDXzCCBt6Rg==
X-Received: by 2002:a17:906:eece:b0:a46:c11d:dd01 with SMTP id wu14-20020a170906eece00b00a46c11ddd01mr4018565ejb.50.1710831477263;
        Mon, 18 Mar 2024 23:57:57 -0700 (PDT)
Received: from redhat.com ([2a02:14f:175:ca2b:adb0:2501:10a9:c4b2])
        by smtp.gmail.com with ESMTPSA id bi20-20020a170906a25400b00a46b9e36636sm2331023ejb.0.2024.03.18.23.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 23:57:56 -0700 (PDT)
Date: Tue, 19 Mar 2024 02:57:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
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
	Sven Schnelle <svens@linux.ibm.com>, linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of
 multi parameters
Message-ID: <20240319025726-mutt-send-email-mst@kernel.org>
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
 <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
 <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEsT2JqJ1r_kStUzW0+-f+qT0C05n2A+Yrjpc-mHMZD_mQ@mail.gmail.com>
 <1710487245.6843069-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEspzDTZP1yxkBz17MgU9meyfCUBDxG8mjm=acXHNxAxhg@mail.gmail.com>
 <1710741592.205804-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1710741592.205804-1-xuanzhuo@linux.alibaba.com>

On Mon, Mar 18, 2024 at 01:59:52PM +0800, Xuan Zhuo wrote:
> On Mon, 18 Mar 2024 12:18:23 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Fri, Mar 15, 2024 at 3:26 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Fri, 15 Mar 2024 11:51:48 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > On Thu, Mar 14, 2024 at 2:00 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > > >
> > > > > On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > > > On Tue, Mar 12, 2024 at 10:10 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > > > > >
> > > > > > > Now, we pass multi parameters to find_vqs. These parameters
> > > > > > > may work for transport or work for vring.
> > > > > > >
> > > > > > > And find_vqs has multi implements in many places:
> > > > > > >
> > > > > > >  arch/um/drivers/virtio_uml.c
> > > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > >  drivers/remoteproc/remoteproc_virtio.c
> > > > > > >  drivers/s390/virtio/virtio_ccw.c
> > > > > > >  drivers/virtio/virtio_mmio.c
> > > > > > >  drivers/virtio/virtio_pci_legacy.c
> > > > > > >  drivers/virtio/virtio_pci_modern.c
> > > > > > >  drivers/virtio/virtio_vdpa.c
> > > > > > >
> > > > > > > Every time, we try to add a new parameter, that is difficult.
> > > > > > > We must change every find_vqs implement.
> > > > > > >
> > > > > > > One the other side, if we want to pass a parameter to vring,
> > > > > > > we must change the call path from transport to vring.
> > > > > > > Too many functions need to be changed.
> > > > > > >
> > > > > > > So it is time to refactor the find_vqs. We pass a structure
> > > > > > > cfg to find_vqs(), that will be passed to vring by transport.
> > > > > > >
> > > > > > > Because the vp_modern_create_avq() use the "const char *names[]",
> > > > > > > and the virtio_uml.c changes the name in the subsequent commit, so
> > > > > > > change the "names" inside the virtio_vq_config from "const char *const
> > > > > > > *names" to "const char **names".
> > > > > > >
> > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > > > > > Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> > > > > >
> > > > > > The name seems broken here.
> > > > >
> > > > > Email APP bug.
> > > > >
> > > > > I will fix.
> > > > >
> > > > >
> > > > > >
> > > > > > [...]
> > > > > >
> > > > > > >
> > > > > > >  typedef void vq_callback_t(struct virtqueue *);
> > > > > > >
> > > > > > > +/**
> > > > > > > + * struct virtio_vq_config - configure for find_vqs()
> > > > > > > + * @cfg_idx: Used by virtio core. The drivers should set this to 0.
> > > > > > > + *     During the initialization of each vq(vring setup), we need to know which
> > > > > > > + *     item in the array should be used at that time. But since the item in
> > > > > > > + *     names can be null, which causes some item of array to be skipped, we
> > > > > > > + *     cannot use vq.index as the current id. So add a cfg_idx to let vring
> > > > > > > + *     know how to get the current configuration from the array when
> > > > > > > + *     initializing vq.
> > > > > >
> > > > > > So this design is not good. If it is not something that the driver
> > > > > > needs to care about, the core needs to hide it from the API.
> > > > >
> > > > > The driver just ignore it. That will be beneficial to the virtio core.
> > > > > Otherwise, we must pass one more parameter everywhere.
> > > >
> > > > I don't get here, it's an internal logic and we've already done that.
> > >
> > >
> > > ## Then these must add one param "cfg_idx";
> > >
> > >  struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
> > >                                          unsigned int index,
> > >                                          struct vq_transport_config *tp_cfg,
> > >                                          struct virtio_vq_config *cfg,
> > > -->                                      uint cfg_idx);
> > >
> > >  struct virtqueue *vring_new_virtqueue(struct virtio_device *vdev,
> > >                                       unsigned int index,
> > >                                       void *pages,
> > >                                       struct vq_transport_config *tp_cfg,
> > >                                       struct virtio_vq_config *cfg,
> > > -->                                      uint cfg_idx);
> > >
> > >
> > > ## The functions inside virtio_ring also need to add a new param, such as:
> > >
> > >  static struct virtqueue *vring_create_virtqueue_split(struct virtio_device *vdev,
> > >                                                       unsigned int index,
> > >                                                       struct vq_transport_config *tp_cfg,
> > >                                                       struct virtio_vq_config,
> > > -->                                                   uint cfg_idx);
> > >
> > >
> > >
> >
> > I guess what I'm missing is when could the index differ from cfg_idx?
> 
> 
>  @cfg_idx: Used by virtio core. The drivers should set this to 0.
>      During the initialization of each vq(vring setup), we need to know which
>      item in the array should be used at that time. But since the item in
>      names can be null, which causes some item of array to be skipped, we
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>      cannot use vq.index as the current id. So add a cfg_idx to let vring
>      know how to get the current configuration from the array when
>      initializing vq.
> 
> 
> static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
> 
> 	................
> 
> 	for (i = 0; i < nvqs; ++i) {
> 		if (!names[i]) {
> 			vqs[i] = NULL;
> 			continue;
> 		}
> 
> 		if (!callbacks[i])
> 			msix_vec = VIRTIO_MSI_NO_VECTOR;
> 		else if (vp_dev->per_vq_vectors)
> 			msix_vec = allocated_vectors++;
> 		else
> 			msix_vec = VP_MSIX_VQ_VECTOR;
> 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> 				     ctx ? ctx[i] : false,
> 				     msix_vec);
> 
> 
> Thanks.


Jason what do you think is the way to resolve this?

> >
> > Thanks
> >
> > > Thanks.
> > >
> > >
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks.
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > >
> > > >
> > >
> >



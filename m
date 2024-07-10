Return-Path: <kvm+bounces-21337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 282D092D85A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 20:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D0F2B21717
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 18:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10617197543;
	Wed, 10 Jul 2024 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FlNJV09o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31BB194C9A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720636778; cv=none; b=A+ecgUqCV6iWROiP8TR+YyYHYmb538jV2FOTrhSpjjn13iO4m02HRSAzcwCRo2dK/rGoB4uHmIOc2ZKsLnZaI2ulX70L3su2laKTj+jOud7pl9dG1vorUPom8ipoeVh9jeh5t1hM64hzupFCp0+aGeq+y/q0VCSntfPDHdcid0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720636778; c=relaxed/simple;
	bh=jl/G74jU3/LJKTndyg9Ir8ZK6ZCpRMd0UXIwTJV5u7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rU/C8foB/TdQIratv6/4fFfWsfr5GV8qHCnUlNf8P5wUARCmYysyw42B+WXzJS/HTbYMqYUvAseqeO7JdaNUSBQn0DZggHDGbWOfQT8PB5w9DR9UVg1SQ3RlHS8bezBTrtf1jbpVPOIGzCibt6IO/hsjxi7f2dyX4QMt7YaZ/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FlNJV09o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720636775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Wa91XRdvflqoUl4ERsLfqpwV8EWmy2Wo2L5wqHiP4U=;
	b=FlNJV09o7oEB3u2chwRYHwojVqIaoUy3LhTKPo61VCgLt9tGEMM3HgtwLg2o4jIxQU4YJ7
	fc+G3JEap7m7KRJ0zW2z68Ms1RTPkGEd7B+m9/giAgERJ7XeBqL7RJaWGN4NP3Y/EnoWFJ
	9Z64TXYZuSvJDZdfya3Co0cI4wXjy94=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-lur7OVGSM_mdyNK_OE6oDA-1; Wed, 10 Jul 2024 14:39:34 -0400
X-MC-Unique: lur7OVGSM_mdyNK_OE6oDA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4266fbae4c6so537805e9.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 11:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720636773; x=1721241573;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Wa91XRdvflqoUl4ERsLfqpwV8EWmy2Wo2L5wqHiP4U=;
        b=sL2PI0ySj/lbKVLxR74lfqsWdZGpF6auV+XZyZ5am2FvJ2bTvwognAnW5cyS3r8JuE
         zNQTMtK7J4rfAEL7IOjV+eVZY9zUgd7O5JlHaHwhzYDV5VAm0RstV2KIOwLW97pToCGf
         4nNOo9OxNj4qEGV9hrSqzVIX6fqzvaJLa6ABL5k6p0TkUP7lGJSMBuUzFbPcgqaQPZXz
         6MQLgA0hf6/Ohef5TY3ducqZIq309cxTALUVVe4WXf/lKN6sd2kFlrabcQjw2tw8EVZ2
         OSCzb8vSN2PnKUriCcxw2rJKfnq9pwaTZuuqBfvq/CvCr/FpNvnKHn1IO9zP4f6NCJYA
         Z0fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXifMVIvWOYtMJejUer7wXqeVU77C819zapoQf+EVTJ29Ji2icMepzuw0nG1DHep0iwFAPm2yAJe567JAPQkmis9aGW
X-Gm-Message-State: AOJu0Yyd2eXv4fbRoPOxX5xSevRaFFCBQBBpH24BTJMMr2IIQrmeHiJt
	Jf+oGyqsMSAPSyWF/iRlrFee6PEMnG33snKbc/g28o76WykvyjYY8bo3VD1mfMs/sxFmdyiHPV+
	BviSFig2VUm3XZoei7ZBYMze/c7sg/ZfSHXOLsy6puzgncT4h9Q==
X-Received: by 2002:a7b:c458:0:b0:426:64f5:b10d with SMTP id 5b1f17b1804b1-426707db59bmr38554185e9.14.1720636773021;
        Wed, 10 Jul 2024 11:39:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG74ZhHPUOEWOdKZQANHlo67lTxvcQgP6YunxBETGdCT6l5hx3iAl/9nDeoE0ZV+lKH4kLIVQ==
X-Received: by 2002:a7b:c458:0:b0:426:64f5:b10d with SMTP id 5b1f17b1804b1-426707db59bmr38553905e9.14.1720636772416;
        Wed, 10 Jul 2024 11:39:32 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:f6ae:a6e3:8cbc:2cbd:b8ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427270238a6sm57772915e9.20.2024.07.10.11.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 11:39:31 -0700 (PDT)
Date: Wed, 10 Jul 2024 14:39:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Daniel Verkamp <dverkamp@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio: fix vq # for balloon
Message-ID: <20240710142239-mutt-send-email-mst@kernel.org>
References: <cover.1720611677.git.mst@redhat.com>
 <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
 <CABVzXAnjAdQqVNtir_8SYc+2dPC-weFRxXNMBLRcmFsY8NxBhQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVzXAnjAdQqVNtir_8SYc+2dPC-weFRxXNMBLRcmFsY8NxBhQ@mail.gmail.com>

On Wed, Jul 10, 2024 at 11:12:34AM -0700, Daniel Verkamp wrote:
> On Wed, Jul 10, 2024 at 4:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > virtio balloon communicates to the core that in some
> > configurations vq #s are non-contiguous by setting name
> > pointer to NULL.
> >
> > Unfortunately, core then turned around and just made them
> > contiguous again. Result is that driver is out of spec.
> 
> Thanks for fixing this - I think the overall approach of the patch looks good.
> 
> > Implement what the API was supposed to do
> > in the 1st place. Compatibility with buggy hypervisors
> > is handled inside virtio-balloon, which is the only driver
> > making use of this facility, so far.
> 
> In addition to virtio-balloon, I believe the same problem also affects
> the virtio-fs device, since queue 1 is only supposed to be present if
> VIRTIO_FS_F_NOTIFICATION is negotiated, and the request queues are
> meant to be queue indexes 2 and up. From a look at the Linux driver
> (virtio_fs.c), it appears like it never acks VIRTIO_FS_F_NOTIFICATION
> and assumes that request queues start at index 1 rather than 2, which
> looks out of spec to me, but the current device implementations (that
> I am aware of, anyway) are also broken in the same way, so it ends up
> working today. Queue numbering in a spec-compliant device and the
> current Linux driver would mismatch; what the driver considers to be
> the first request queue (index 1) would be ignored by the device since
> queue index 1 has no function if F_NOTIFICATION isn't negotiated.


Oh, thanks a lot for pointing this out!

I see so this patch is no good as is, we need to add a workaround for
virtio-fs first.

QEMU workaround is simple - just add an extra queue. But I did not
reasearch how this would interact with vhost-user.

From driver POV, I guess we could just ignore queue # 1 - would that be
ok or does it have performance implications?
Or do what I did for balloon here: try with spec compliant #s first,
if that fails then assume it's the spec issue and shift by 1.


> [...]
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> > index 7d82facafd75..fa606e7321ad 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -293,7 +293,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
> >         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> >         struct virtqueue_info *vqi;
> >         u16 msix_vec;
> > -       int i, err, nvectors, allocated_vectors, queue_idx = 0;
> > +       int i, err, nvectors, allocated_vectors;
> >
> >         vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> >         if (!vp_dev->vqs)
> > @@ -332,7 +332,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
> >                         msix_vec = allocated_vectors++;
> >                 else
> >                         msix_vec = VP_MSIX_VQ_VECTOR;
> > -               vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
> > +               vqs[i] = vp_setup_vq(vdev, i, vqi->callback,
> >                                      vqi->name, vqi->ctx, msix_vec);
> >                 if (IS_ERR(vqs[i])) {
> >                         err = PTR_ERR(vqs[i]);
> > @@ -368,7 +368,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
> >                             struct virtqueue_info vqs_info[])
> >  {
> >         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > -       int i, err, queue_idx = 0;
> > +       int i, err;
> >
> >         vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> >         if (!vp_dev->vqs)
> > @@ -388,8 +388,13 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
> >                         vqs[i] = NULL;
> >                         continue;
> >                 }
> > +<<<<<<< HEAD
> >                 vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
> >                                      vqi->name, vqi->ctx,
> > +=======
> > +               vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
> > +                                    ctx ? ctx[i] : false,
> > +>>>>>>> f814759f80b7... virtio: fix vq # for balloon
> 
> This still has merge markers in it.
> 
> Thanks,
> -- Daniel



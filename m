Return-Path: <kvm+bounces-21341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 446AA92DA34
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 22:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC46285BF0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 20:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B92D198A11;
	Wed, 10 Jul 2024 20:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OezJpbxC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AD419149A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 20:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720643979; cv=none; b=lP6ZvnR5Aqtu/jmkaPnaa6EiFvhFyWjUCbCEkizW4ROtIYksYYSiCfoFlTgqH0MyZZdX8nQdh+rhPK01l0LXp5SnRyQvkh9hJ0BVn82oNLiIidB0nMLNRqZ6FrZs30JBEwMuN9NdI2e3T+apkTHbCmx2KDLw8san5K1whPGGygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720643979; c=relaxed/simple;
	bh=FkBwZIwX/vwv/flv1JLtkKzJfwEAAipbXsO2aRGsSSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/WTG/S2niD5Fk3YHuFpK7WS+jrEx2XHALL1ApG4AFHpd78RPJw9Tb0sO2h6LQXuGkwJFNu4uLSupNF5MfvZT+RalqtnUbPZUs9v4WcS+ChjqHEDjkk7hKoVBzHzMnVlKL/KBgQ9Cp05YXDBnfdQNwH16d6X+oCai+YS4KOWYcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OezJpbxC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720643975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+f+kV8PGs9cvgE7zeVigaMsenY/36PRSuVdnQGbWD0=;
	b=OezJpbxC3v3Q/EPgW7DQTNpRRvuvbRBz5Ichi9TDe1o5rtVSGKoQUAwcX/XHmZAlr4uf3I
	KjDySKNskPfe9jG+9pt0kNrPR8UWzZRSTjOc7I3Q75a5SqIsTlAyntgk5sy74GtHiFO2xF
	emD7glavDZ2GeIqxb/0WatsLsm25FJI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-7V1DCthBNWC417w23dFYuw-1; Wed, 10 Jul 2024 16:39:34 -0400
X-MC-Unique: 7V1DCthBNWC417w23dFYuw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4279837c024so1165395e9.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 13:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720643973; x=1721248773;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+f+kV8PGs9cvgE7zeVigaMsenY/36PRSuVdnQGbWD0=;
        b=o8lCRpKFSMbCFwA+Yr9qz7ldHHjUvZB3WXb8UZCVNef0Tb6rC2i7x7CdZgY9VBf8jD
         u+vLl1Q8iPF5LRvdi14+k/zkq0TYEXyE91KDhi4oJv/W+pISyK33ZQAELo6CFp71ii5h
         7SqKx+2vYRyJk1Wez5LXf8QKAGYnLaZfFsRYXKSFnd7oiAOLEb6QnhIp21+B2FUQ5Ip7
         s5ST6vvy9L1h9A0yQHOIsgfI3JVN19n6xbxtR4DUTKlpGic7YULdKlNfq2+rWZpcbHEh
         hm0Phu17H8ewZrIHAnGF45cj+fMBlN9RFwYc8bp1IPlZclONOGoFOG4erLFdMnT6JEsR
         EG1g==
X-Forwarded-Encrypted: i=1; AJvYcCXZ1aYxO6dCKBwmgsMhtfSGYFIQpiNxAKxixnWeRjuY7kP9IkuzeGZNpBEJ6Gm23VK6T8kE6p2wfumOl2O/kczj0GLR
X-Gm-Message-State: AOJu0Yzjh76GvTOZhVAizCD3NYHYRRksmhQNhkDEqSLNLU4Fm5O1zjYn
	XPANVh9lU1u1HvRwvBc3Zs+NRbkJPMJWpPp2hAyzNKSUfK00mZ7GQjMDPpLkxPtN4KJ9JyLEfgl
	sbKVB3473WD8olAhE4wp01XNz698TzeHOsIacRbLteFO9Tt8qXA==
X-Received: by 2002:a05:600c:229a:b0:426:5f75:1c2c with SMTP id 5b1f17b1804b1-426707cbc97mr44811835e9.11.1720643973118;
        Wed, 10 Jul 2024 13:39:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtCfrEexr56Rkv7hJ8Mgk/LJU1kKofEwb65pnZ1cmAQDQy0+5tLig+uLI502/i8+1HPIzcTQ==
X-Received: by 2002:a05:600c:229a:b0:426:5f75:1c2c with SMTP id 5b1f17b1804b1-426707cbc97mr44811475e9.11.1720643972423;
        Wed, 10 Jul 2024 13:39:32 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:341:761e:f82:fc9a:623b:3fd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f6e9666sm92264125e9.9.2024.07.10.13.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 13:39:32 -0700 (PDT)
Date: Wed, 10 Jul 2024 16:38:59 -0400
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
Message-ID: <20240710162640-mutt-send-email-mst@kernel.org>
References: <cover.1720611677.git.mst@redhat.com>
 <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
 <CABVzXAnjAdQqVNtir_8SYc+2dPC-weFRxXNMBLRcmFsY8NxBhQ@mail.gmail.com>
 <20240710142239-mutt-send-email-mst@kernel.org>
 <CABVzXAmp_exefHygEGvznGS4gcPg47awyOpOchLPBsZgkAUznw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVzXAmp_exefHygEGvznGS4gcPg47awyOpOchLPBsZgkAUznw@mail.gmail.com>

On Wed, Jul 10, 2024 at 12:58:11PM -0700, Daniel Verkamp wrote:
> On Wed, Jul 10, 2024 at 11:39 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 10, 2024 at 11:12:34AM -0700, Daniel Verkamp wrote:
> > > On Wed, Jul 10, 2024 at 4:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > virtio balloon communicates to the core that in some
> > > > configurations vq #s are non-contiguous by setting name
> > > > pointer to NULL.
> > > >
> > > > Unfortunately, core then turned around and just made them
> > > > contiguous again. Result is that driver is out of spec.
> > >
> > > Thanks for fixing this - I think the overall approach of the patch looks good.
> > >
> > > > Implement what the API was supposed to do
> > > > in the 1st place. Compatibility with buggy hypervisors
> > > > is handled inside virtio-balloon, which is the only driver
> > > > making use of this facility, so far.
> > >
> > > In addition to virtio-balloon, I believe the same problem also affects
> > > the virtio-fs device, since queue 1 is only supposed to be present if
> > > VIRTIO_FS_F_NOTIFICATION is negotiated, and the request queues are
> > > meant to be queue indexes 2 and up. From a look at the Linux driver
> > > (virtio_fs.c), it appears like it never acks VIRTIO_FS_F_NOTIFICATION
> > > and assumes that request queues start at index 1 rather than 2, which
> > > looks out of spec to me, but the current device implementations (that
> > > I am aware of, anyway) are also broken in the same way, so it ends up
> > > working today. Queue numbering in a spec-compliant device and the
> > > current Linux driver would mismatch; what the driver considers to be
> > > the first request queue (index 1) would be ignored by the device since
> > > queue index 1 has no function if F_NOTIFICATION isn't negotiated.
> >
> >
> > Oh, thanks a lot for pointing this out!
> >
> > I see so this patch is no good as is, we need to add a workaround for
> > virtio-fs first.
> >
> > QEMU workaround is simple - just add an extra queue. But I did not
> > reasearch how this would interact with vhost-user.
> >
> > From driver POV, I guess we could just ignore queue # 1 - would that be
> > ok or does it have performance implications?
> 
> As a driver workaround for non-compliant devices, I think ignoring the
> first request queue would be a reasonable approach if the device's
> config advertises num_request_queues > 1. Unfortunately, both
> virtiofsd and crosvm's virtio-fs device have hard-coded
> num_request_queues =1, so this won't help with those existing devices.

Do they care what the vq # is though?
We could do some magic to translate VQ #s in qemu.


> Maybe there are other devices that we would need to consider as well;
> commit 529395d2ae64 ("virtio-fs: add multi-queue support") quotes
> benchmarks that seem to be from a different virtio-fs implementation
> that does support multiple request queues, so the workaround could
> possibly be used there.
> 
> > Or do what I did for balloon here: try with spec compliant #s first,
> > if that fails then assume it's the spec issue and shift by 1.
> 
> If there is a way to "guess and check" without breaking spec-compliant
> devices, that sounds reasonable too; however, I'm not sure how this
> would work out in practice: an existing non-compliant device may fail
> to start if the driver tries to enable queue index 2 when it only
> supports one request queue,

You don't try to enable queue - driver starts by checking queue size.
The way my patch works is that it assumes a non existing queue has
size 0 if not available.

This was actually a documented way to check for PCI and MMIO:
	Read the virtqueue size from queue_size. This controls how big the virtqueue is (see 2.6 Virtqueues).
	If this field is 0, the virtqueue does not exist.
MMIO:
	If the returned value is zero (0x0) the queue is not available.

unfortunately not for CCW, but I guess CCW implementations outside
of QEMU are uncommon enough that we can assume it's the same?


To me the above is also a big hint that drivers are allowed to
query size for queues that do not exist.



> and a spec-compliant device would probably
> balk if the driver tries to enable queue 1 but does not negotiate
> VIRTIO_FS_F_NOTIFICATION. If there's a way to reset and retry the
> whole virtio device initialization process if a device fails like
> this, then maybe it's feasible. (Or can the driver tweak the virtqueue
> configuration and try to set DRIVER_OK repeatedly until it works? It's
> not clear to me if this is allowed by the spec, or what device
> implementations actually do in practice in this scenario.)
> 
> Thanks,
> -- Daniel

My patch starts with a spec compliant behaviour. If that fails,
try non-compliant one as a fallback.

-- 
MST



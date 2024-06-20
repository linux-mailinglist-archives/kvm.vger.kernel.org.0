Return-Path: <kvm+bounces-20056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7131B910014
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01553B22F8D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B4919DF71;
	Thu, 20 Jun 2024 09:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdFtzHhF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A2A19B3D7
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718874880; cv=none; b=TvcrzkElPfSZKomUSnhMd6KFwuNXp8KvHzJQjFBJFieIVoGfRIPubfVtqyCQy0nLld4AaFh3sz+70R2ajihktrIjlkBrxmNDvLSrgjXzKRkIEXOsEZ2pXy78sG2ZGPE0ts+CBGV+UwllhtN8PVpCaPfP5yeRoFd9FitGbrFeUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718874880; c=relaxed/simple;
	bh=AblgfDKsQmxG/rhwuU9LnaVafDArI7B9+bO2yRkgtrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH2H8D8p5XUHzQUOO7xb8GByLzJ1i4JFJGycT8/QhplxFMRHBiAhgBL/HN0YPUhheu064LBCwHoE8DBrCslZQ4DXpEu0Zlxut++8zy1EhpmKEsrF7+OcLFhdhevwZjaSaojDry45VPpWl0M7NvrRp/G37841hea44WZfL0F4hxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdFtzHhF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718874876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n/q6GHKkD/zFmXGYbmYPlaDuYuUj7aK/70/tkj3IdI=;
	b=PdFtzHhF02CNBCZCiNHjKgAsLwGlc1oXsiqPtdAqXh9/8eyWsd5MgkHU8n2KaIe1HWt69+
	5c6Im1aEvZ61kbP/nkjAobSk2ZbEtFs2ZQ194ceRM4fvDOcLojwBV5Lu5od2qzU8fT9xoU
	lf/RZiknU+YvRv9CsUKtNxI+WtyhH4s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-vBqa-HXHPlOIrkuOy8OPYg-1; Thu, 20 Jun 2024 05:14:33 -0400
X-MC-Unique: vBqa-HXHPlOIrkuOy8OPYg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a6f2af30793so26932966b.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 02:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718874871; x=1719479671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7n/q6GHKkD/zFmXGYbmYPlaDuYuUj7aK/70/tkj3IdI=;
        b=OYSbQR9QIqULHUgmzGEPRHwDmxIC91AKIJMOSRm3Xi/JKJEjnGqfpd5UmcikgzNA+W
         r//37qoEoKmPD3r5CRC3QE0ylMITft0CDs93uK4/G+uMRET3pGvO8fr/a2ya6V8AeLQn
         V478FinFQn/ruKXtwJsakvuL9Oy3mfJIxoTZUnPq3Xfy3I+D2ogjGRpWTeWulojE0OeS
         7V9ZvRQ529IWlgMOSK4URfDV1Ie/jcDhGA4nknF2W5wGtzDkDih3QYdKcsfT5DkLsFmm
         2oz88UX3oCpEsNPl7xtkahABRka2Jomw4LJ8kXe+vpV6AlNpYnnsSky76Kk/S8KKiENG
         /YWA==
X-Forwarded-Encrypted: i=1; AJvYcCWq3TikiLoB4pC/xVPx76/Ht7t7lB792oj65QqjNClAAULBn1vAVUCqJexlkkkxAIZ/CbyMvXr4En57hDfax+sT/01i
X-Gm-Message-State: AOJu0Yw/l6GXhTqbhh0MqAu19kILvTa7CQzJ5fSagXFHWONpFlV+fySV
	VRFW/0D5sBw75QsCfjymxM5hnwJv/R4ZkQLMCIvLFV4LGKggalLUkwIzcy91Zv2RnTD1nOnVRpD
	TTN5ynrV7FflZxldL57VDMLKJZp7uhbvfIgNQoz8GwF47cgAw/Q==
X-Received: by 2002:a17:907:a581:b0:a6f:af4f:ff82 with SMTP id a640c23a62f3a-a6faf500049mr334401566b.25.1718874871299;
        Thu, 20 Jun 2024 02:14:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxdf7P1AFITZr2DVkTfIKfl2IcVnjVg8p04jUd8bO23ArK3RuJSM+iwOfOkWQb1H37WeNIsA==
X-Received: by 2002:a17:907:a581:b0:a6f:af4f:ff82 with SMTP id a640c23a62f3a-a6faf500049mr334396566b.25.1718874870708;
        Thu, 20 Jun 2024 02:14:30 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56da3fe5sm759661166b.18.2024.06.20.02.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 02:14:30 -0700 (PDT)
Date: Thu, 20 Jun 2024 05:14:24 -0400
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
Message-ID: <20240620050545-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-4-xuanzhuo@linux.alibaba.com>
 <20240620034823-mutt-send-email-mst@kernel.org>
 <1718874049.457552-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1718874049.457552-1-xuanzhuo@linux.alibaba.com>

On Thu, Jun 20, 2024 at 05:00:49PM +0800, Xuan Zhuo wrote:
> > > @@ -226,21 +248,37 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
> > >
> > >  static inline
> > >  int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > -			const char * const names[],
> > > -			struct irq_affinity *desc)
> > > +		    struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > +		    const char * const names[],
> > > +		    struct irq_affinity *desc)
> > >  {
> > > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> > > +	struct virtio_vq_config cfg = {};
> > > +
> > > +	cfg.nvqs = nvqs;
> > > +	cfg.vqs = vqs;
> > > +	cfg.callbacks = callbacks;
> > > +	cfg.names = (const char **)names;
> >
> >
> > Casting const away? Not safe.
> 
> 
> 
> Because the vp_modern_create_avq() use the "const char *names[]",
> and the virtio_uml.c changes the name in the subsequent commit, so
> change the "names" inside the virtio_vq_config from "const char *const
> *names" to "const char **names".

I'm not sure I understand which commit you mean,
and this kind of change needs to be documented, but it does not matter.
Don't cast away const.

-- 
MST



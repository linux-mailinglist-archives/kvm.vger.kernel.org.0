Return-Path: <kvm+bounces-12073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FA387F7F4
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F4092281138
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 07:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2594051028;
	Tue, 19 Mar 2024 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zal7cuN1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8D351C42
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831677; cv=none; b=J1VLVTH/DoNusY+isoXTItL1Ba6MREdXCYGf7ZHOc7zZfHmNe8AhQNOJsa8nXNWJC4es+fX2w9Gqnk870gRNNCwSoMnriB5IbSmpLMRXUYla6asRx/qaxATZGdphpVhZNsFOZ3ErOBrkuVRUhMKuUV8TFYSBZQTe+v7WQr6FTNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831677; c=relaxed/simple;
	bh=+0yGzgO/uZDZuFmdyu9d+sc45NfVqM4uTrSkkmcuopU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mteceSnjQTGPLv+ftBR9V+FFzUJGU/VSL6cPhZv7xI5/y9LoDYf2fX8lVfVW+HdlSvlQAHHo9gsxX0xi1M9WZPup2BImvmq4XSltwK1iZbju8rEcUWHqU+YJCNdFDhL2ZQisZCnB5yrfnCMjs5RTJgYHjovB2601B0eeXUHL6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zal7cuN1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710831674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=foUSQQGmYmOu8nLXi1AjlC9r9SGWzmdXWf6sigKcUWw=;
	b=Zal7cuN10qazRbahZtmjEkWoeQv69CBEEZpTNm7ZoHh9ssATscXqs2AlwQ5qxgY+cLLfro
	k9q19wx/txFI0c5LBcFfqGZrgmHhd1K9XKAX8O8ce+QGLY+mJmjku1rKWAXUU9p2ju5cKK
	Vwsl5zfK1UcEtGShXoh1i2z1oUi64+w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-M3Jo8ybNOzKBSTSx-n5_sw-1; Tue, 19 Mar 2024 03:01:11 -0400
X-MC-Unique: M3Jo8ybNOzKBSTSx-n5_sw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4140a509ee9so12063555e9.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710831670; x=1711436470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foUSQQGmYmOu8nLXi1AjlC9r9SGWzmdXWf6sigKcUWw=;
        b=X60f2W8R223cGXUi27DZTQymjH3dMxMx8W45TqB4jlkhIeCVsC3Ia8AN1H5GIyn2MU
         ShEYhhoq84X8JyobRd1w6zaTmPwlsDneu6hJDtFYHT9nnuDCC/aNM8fNOPKc06DMnzK2
         IRDe/hu395iFmQF/P3xT7McRfeHKNlfR2OAQEWRISjAxo77CfzbFmCzqtGcwS9Iovoxl
         0Sj8NLFxH3xid2z4qRhekvX1LEBt9Vr0GELB1psORU2nEsYbrA8iWx7ErHCmEwNm8KLB
         pUmK3lffZQizXHGNy4/RB/k9pt1XInGbvrPZ0zcOHjw4o1U4RY20rgJrJB+P/4GxFajQ
         Egig==
X-Forwarded-Encrypted: i=1; AJvYcCUBk3UnPdfvggwGN9cUxL2KOLspP3LKFwn+Xsi69zpWmpcYd4LYB9z3KchMxZyJjHcxThunOxgff8ZUpuUoZK3JVONq
X-Gm-Message-State: AOJu0YwldQHN+ctMnj1t1Yh+94VyqaXkIoCp44bjkjoZOTpsr8T3tLjw
	LkteKHoO9CeuMFbECp7nlIH2XPzUHfBPERpMD8tsKQ6J/kFZmeAPnndPSwHsU/sCXFTOZX4AkIO
	TjYkHnBihxHQEbZUI8C61NyRPrX4NqSXh4iILMATqrKogwjpFQQ==
X-Received: by 2002:a05:600c:4f0e:b0:413:ef8e:4cc with SMTP id l14-20020a05600c4f0e00b00413ef8e04ccmr1095512wmq.40.1710831669528;
        Tue, 19 Mar 2024 00:01:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzg6YzD09DcsuSp1mTE4kCrxMGUWI9Lm91o60NEdPSVsYEnPJ0jVjqFhsmb8yxRUdsUTgvyQ==
X-Received: by 2002:a05:600c:4f0e:b0:413:ef8e:4cc with SMTP id l14-20020a05600c4f0e00b00413ef8e04ccmr1095470wmq.40.1710831668946;
        Tue, 19 Mar 2024 00:01:08 -0700 (PDT)
Received: from redhat.com ([2.52.6.254])
        by smtp.gmail.com with ESMTPSA id fk10-20020a05600c0cca00b0041463334822sm1536373wmb.26.2024.03.19.00.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:01:08 -0700 (PDT)
Date: Tue, 19 Mar 2024 03:01:02 -0400
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
	Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH vhost v3 0/4] refactor the params of find_vqs()
Message-ID: <20240319025933-mutt-send-email-mst@kernel.org>
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>

On Tue, Mar 12, 2024 at 10:10:09AM +0800, Xuan Zhuo wrote:
> This pathset is splited from the
> 
>      http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibaba.com
> 
> That may needs some cycles to discuss. But that notifies too many people.
> 
> But just the four commits need to notify so many people.
> And four commits are independent. So I split that patch set,
> let us review these first.
> 
> The patch set try to  refactor the params of find_vqs().
> Then we can just change the structure, when introducing new
> features.
> 
> Thanks.
> 
> v3:
>   1. fix the bug: "assignment of read-only location '*cfg.names'"
> 
> v2:
>   1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen
> 
> v1:
>   1. fix some comments from ilpo.jarvinen@linux.intel.com
> 


As this came in after merge window was open I'm deferring this
to the next merge window.

Jason, can you pls try to complete the review meanwhile?

> 
> Xuan Zhuo (4):
>   virtio: find_vqs: pass struct instead of multi parameters
>   virtio: vring_create_virtqueue: pass struct instead of multi
>     parameters
>   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>   virtio_ring: simplify the parameters of the funcs related to
>     vring_create/new_virtqueue()
> 
>  arch/um/drivers/virtio_uml.c             |  31 ++--
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  24 ++--
>  drivers/remoteproc/remoteproc_virtio.c   |  31 ++--
>  drivers/s390/virtio/virtio_ccw.c         |  33 ++---
>  drivers/virtio/virtio_mmio.c             |  30 ++--
>  drivers/virtio/virtio_pci_common.c       |  60 ++++----
>  drivers/virtio/virtio_pci_common.h       |   9 +-
>  drivers/virtio/virtio_pci_legacy.c       |  16 ++-
>  drivers/virtio/virtio_pci_modern.c       |  38 +++--
>  drivers/virtio/virtio_ring.c             | 173 ++++++++---------------
>  drivers/virtio/virtio_vdpa.c             |  45 +++---
>  include/linux/virtio_config.h            |  85 ++++++++---
>  include/linux/virtio_ring.h              |  93 +++++++-----
>  tools/virtio/virtio_test.c               |   4 +-
>  tools/virtio/vringh_test.c               |  28 ++--
>  15 files changed, 363 insertions(+), 337 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f



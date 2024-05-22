Return-Path: <kvm+bounces-17952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9908CC142
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 14:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A238E1C226A5
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 12:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9795113D62C;
	Wed, 22 May 2024 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qds0YO0+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226CB13D61E
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716380938; cv=none; b=oVbn5+rvaSHrAj1BbZVDZ0BdJKiI6qOylMHrClNxlISW6XMvbh9PSlm+2zs9+6YXrGcjqRb+Zhx6nE/ARZZirxv+mfX4zMejx3q7CMbmIBYFp5EqpeOLelFeGGVR/+VeK7OgB/I74aVOdoOlMDgtJDZOiQnJxJvAeNH0zOqzQ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716380938; c=relaxed/simple;
	bh=IjhE+2UdQAnuXtlylaE+JoyaTsfKnza85kdSkCPXqCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiJbzug/UR4/6yEOEXkdJ6uaD617dlniuLOxnwryS/64MpgcfsKb5KKi7CURh+IWJcuFEmJ9HcxW/DSWPBkAYji7l8SlRkqeIDtfuKyXYmiYkZjE3fLNBJlNcwvgjfHE3oWOJQkjI0DBz+WvKBCkQP8Bdpa1wF3rp0JcNUciiDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qds0YO0+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716380935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a+cu2mi6DrTCATyynjShlX3nyC2W5Pcy/CJyML1HBmE=;
	b=Qds0YO0+JqDsQm2ufPGkIWdTqt2K5G4Lz39qw6me2gHUrprn5tECSLMLJoLccAwJR/6RM3
	8zd6MLL/HMdoCrIov/JzKejUfYOa8VlbcGYuL63RtQXfsJcnUgb7SbMIRhp3vvCJ2qwUYT
	n46ZLWWZ28C/vaBZjW5VpEQl44U3Aw4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-CDXjo1xPOa-rgydChWyA3w-1; Wed, 22 May 2024 08:28:53 -0400
X-MC-Unique: CDXjo1xPOa-rgydChWyA3w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34db1830d7cso519339f8f.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 05:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716380933; x=1716985733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+cu2mi6DrTCATyynjShlX3nyC2W5Pcy/CJyML1HBmE=;
        b=mAjm9/0q+SY40gKGOJCHGb1gLcRXx+APQ20iCFgBLR6XEQ0aJih0dryufpSq0lq6iq
         GigMPmiAfAobA76/ThkMoFwDbsu9iyRUmbyH5nVq97jgjr2Sco6OmLD2zjJRkJwJUPaU
         aukvWie3cYlgrJxvN+hcn0to+Y+gcuWf1x0gahwRq2MJ2GoedqsrxXKZUB1y2agPzy5T
         VNLY81ud9nTNv2CkIu/YHbUC1j5Y7ozu2aQ7hAlKhPruikyReGWkfSUhVxeJEKq54ZA0
         M37lFC1rolUffSYbCuppck7hQ6IOcEWlyQZiS914eQEohaiKscDyyPKoAtYHwSBzqQjN
         Pw7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3d4Xd8LLDWjhGiP5B763BFZJHFjp/W/AEj2NfkZFxtgGeaqbGKrM7LFPqtZ1nHgcZeJnN7WYhe98XszCsPRGAHRNS
X-Gm-Message-State: AOJu0YybNJXiulmaoCr0a/Q0ix8bFiyfv2mA5DfdLeHxuObPv+4oD5Xg
	G86Gw7MS/59wzhd7DpBMQtygDzF0Cb3NFPaWSzO+78mWFh1TaHaO8g1U/5wfCH/g1X7AHzr19Pt
	g68JpscEz+dxVXFPviJuq+UzBrWB16w+mDg2MRRKUNze0TT/8Cw==
X-Received: by 2002:adf:e60a:0:b0:354:e22c:ea86 with SMTP id ffacd0b85a97d-354e22cebaemr1323587f8f.9.1716380932424;
        Wed, 22 May 2024 05:28:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzJHem68umXpabzX/QCksQommVuGzFjAE3Wqkqn0Byb8srELzLVtz9M/YE9lepG/jLnJp0Rg==
X-Received: by 2002:adf:e60a:0:b0:354:e22c:ea86 with SMTP id ffacd0b85a97d-354e22cebaemr1323532f8f.9.1716380931656;
        Wed, 22 May 2024 05:28:51 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:55d:e862:558a:a573:a176:1825])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b79bdc7sm34184149f8f.22.2024.05.22.05.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 05:28:50 -0700 (PDT)
Date: Wed, 22 May 2024 08:28:43 -0400
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
Subject: Re: [PATCH vhost v9 0/6] refactor the params of find_vqs()
Message-ID: <20240522082732-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>

On Wed, Apr 24, 2024 at 05:15:27PM +0800, Xuan Zhuo wrote:
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

It's nice but I'd like to see something that uses this before I bother
merging. IIUC premapped is dropped - are we going to use this in practice?

> v8:
>   1. rebase the vhost branch
> 
> v7:
>   1. fix two bugs. @Jason
> 
> v6:
>   1. virtio_balloon: a single variable for both purposes.
>   2. if names[i] is null, return error
> 
> v5:
>   1. virtio_balloon: follow David Hildenbrand's suggest
>     http://lore.kernel.org/all/3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com
>   2. fix bug of the reference of "cfg_idx"
>     http://lore.kernel.org/all/202403222227.Sdp23Lcb-lkp@intel.com
> 
> v4:
>   1. remove support for names array entries being null
>   2. remove cfg_idx from virtio_vq_config
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
> 
> 
> 
> 
> 
> 
> 
> 
> Xuan Zhuo (6):
>   virtio_balloon: remove the dependence where names[] is null
>   virtio: remove support for names array entries being null.
>   virtio: find_vqs: pass struct instead of multi parameters
>   virtio: vring_create_virtqueue: pass struct instead of multi
>     parameters
>   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>   virtio_ring: simplify the parameters of the funcs related to
>     vring_create/new_virtqueue()
> 
>  arch/um/drivers/virtio_uml.c             |  36 +++--
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  23 +--
>  drivers/remoteproc/remoteproc_virtio.c   |  37 +++--
>  drivers/s390/virtio/virtio_ccw.c         |  38 ++---
>  drivers/virtio/virtio_balloon.c          |  48 +++---
>  drivers/virtio/virtio_mmio.c             |  36 +++--
>  drivers/virtio/virtio_pci_common.c       |  69 ++++-----
>  drivers/virtio/virtio_pci_common.h       |   9 +-
>  drivers/virtio/virtio_pci_legacy.c       |  16 +-
>  drivers/virtio/virtio_pci_modern.c       |  37 +++--
>  drivers/virtio/virtio_ring.c             | 177 ++++++++---------------
>  drivers/virtio/virtio_vdpa.c             |  51 +++----
>  include/linux/virtio_config.h            |  76 +++++++---
>  include/linux/virtio_ring.h              |  93 +++++++-----
>  tools/virtio/virtio_test.c               |   4 +-
>  tools/virtio/vringh_test.c               |  28 ++--
>  16 files changed, 384 insertions(+), 394 deletions(-)
> 
> -- 
> 2.32.0.3.g01195cf9f



Return-Path: <kvm+bounces-17955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D37D88CC17C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 14:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 611481F2246C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 12:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA0113D8AA;
	Wed, 22 May 2024 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hF9WWONK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432AC13D63A
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 12:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716381840; cv=none; b=P1g/kObHT2oxzMc6fDNyjMl2/r9G0RLlUJt3//JW7VIZgQp8IZXkDNWjZXZsaJI4CrVFcESgckUmnKh4tYS4P4FXEa4NE4uzrI010SDD1+5X0a+G6Z+eSP/46sefUp5Ui17vmheJ4N/cLa/jzdU5FnF/i0VRMOK14nCFmP6qGbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716381840; c=relaxed/simple;
	bh=579+PwZAall9CCUoOjULlOHgIo8Ra+uTvd5iStPs+fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ddh2YyLSe8066NQDk1iBsic2N7BKdjGq+I9/SrzaDFQi9CT2BUzxoFSTqN9h1F1XABcJRLoAqOd/yL4xXBK/H9m7zSR73xzrGLGhcT9TAuayqdAZT3uFvruvpxpQoBpORhMLQQtwjqPIsNzdoCr8VRoMrLivJ/4qykVLXvQooH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hF9WWONK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716381836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUgbrkFHxg4F+kRJ096ILydWxQUTBg55cdfx2xz7DQs=;
	b=hF9WWONKq0z/mzTyXjDixPbOqM66qf+JgQ0G17yhNa9CbOYMj51p4AVCpFN591bJxpglsY
	nUHci6gW9DmleLigWEyZbYunBanPUvu0jJhIv1aN/6pu/eG/gD1B7Dv2+keZR4Xuvl7XKX
	q9CJNhtZXKxvPERpe8qli2aWut+/lKo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-9Q8zwp2fPHytt2ciof0hvw-1; Wed, 22 May 2024 08:43:54 -0400
X-MC-Unique: 9Q8zwp2fPHytt2ciof0hvw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34eb54c888cso10962095f8f.3
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 05:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716381833; x=1716986633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUgbrkFHxg4F+kRJ096ILydWxQUTBg55cdfx2xz7DQs=;
        b=os78frlsHwNVkZMHrmi7O2ZeY1ADifIN7RxXBAI5KBuI+3MNggCWT7XZh0KfLLwoZq
         Zk5i+JAu2j/XdiKfjCkjC2psLM8IYFHaX4q4lgkbcagtFSMhMPbFpWWw2Ca4+SMKbPR6
         BjZN2GtYBWhMuBf7OkkP7nv1HKioqfP65+u9xL5prDtrcziRwrOzrTvcCp15WwdReSiF
         9Cc3gw39lzcqX5cG0dWR5ctAXdlUBJ222d7x/VYRdP/FU48xH30YBmYIrTFg0N9ZqKQd
         qSeHedkYdYxNd+aheP9P1gxpMVijYK4OG9Xigri7Nuy3ouNLhPJ0Hxmz++iXXJ8vcvx+
         WlnA==
X-Forwarded-Encrypted: i=1; AJvYcCUVd5zMP6QAOXNmdgjruZIRCHAHVE0ZSxLkUeUl2uMAamM0VfBrWC4ywfyJVdHHsOgfKX6/gpBF43c4ejTfpvICoksI
X-Gm-Message-State: AOJu0Ywv298A0p6dWzZ3vFIb8df20yrtCbL1DEzURqF6Xb1fm5jwP6Ud
	7arS5vfA690Key5M03ic3rRVl/xHIWMlz8emwSm4gT6agV0zlNJwz/m+JLzKLCXPMS/Oc6fBypn
	LPqrWHgVvOFi7wOipOQACiJgRZJ54mQynONn+HKvhrRksyapaDA==
X-Received: by 2002:a05:6000:d1:b0:354:c2c3:a319 with SMTP id ffacd0b85a97d-354d8dad7camr1537129f8f.61.1716381832848;
        Wed, 22 May 2024 05:43:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxFpLqeLCJUrO7rqx1MM8b891NleWkGLj5GGveBxw1L4XYP6vJDRZB7/pPW2A9B5hgEhmBdw==
X-Received: by 2002:a05:6000:d1:b0:354:c2c3:a319 with SMTP id ffacd0b85a97d-354d8dad7camr1537078f8f.61.1716381832095;
        Wed, 22 May 2024 05:43:52 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:55d:e862:558a:a573:a176:1825])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-354c7df311esm7583246f8f.3.2024.05.22.05.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 05:43:51 -0700 (PDT)
Date: Wed, 22 May 2024 08:43:44 -0400
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
Message-ID: <20240522084221-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240522082732-mutt-send-email-mst@kernel.org>
 <1716381321.6426032-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1716381321.6426032-1-xuanzhuo@linux.alibaba.com>

On Wed, May 22, 2024 at 08:35:21PM +0800, Xuan Zhuo wrote:
> On Wed, 22 May 2024 08:28:43 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Wed, Apr 24, 2024 at 05:15:27PM +0800, Xuan Zhuo wrote:
> > > This pathset is splited from the
> > >
> > >      http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibaba.com
> > >
> > > That may needs some cycles to discuss. But that notifies too many people.
> > >
> > > But just the four commits need to notify so many people.
> > > And four commits are independent. So I split that patch set,
> > > let us review these first.
> > >
> > > The patch set try to  refactor the params of find_vqs().
> > > Then we can just change the structure, when introducing new
> > > features.
> > >
> > > Thanks.
> >
> > It's nice but I'd like to see something that uses this before I bother
> > merging. IIUC premapped is dropped - are we going to use this in practice?
> 
> 
> 1. You know this modification makes sense.
> 2. This modification is difficult. Unlike modifying virtio ring or virtio-net,
>    this patch set requires modifying many modules and being reviewed by
>    many people.
> 3. If you do not merge it now, then this patch set will most likely be
>    abandoned. And I worked a lot on that.
> 4. premapped has not been abandoned, I have been advancing this work. What was
>    abandoned was just virtio-net big mode's support for premapped.
> 5. My plan is to complete virtio-net support for af-xdp in 6.10. This must
>    depend on premapped.
> 
> So, I hope you merge this patch set.
> 
> Thanks.

If this makes thing easier for you, I can put it in my tree post
release. This way you do not need to keep reposting it.
I'll then merge it with premapped.


> 
> >
> > > v8:
> > >   1. rebase the vhost branch
> > >
> > > v7:
> > >   1. fix two bugs. @Jason
> > >
> > > v6:
> > >   1. virtio_balloon: a single variable for both purposes.
> > >   2. if names[i] is null, return error
> > >
> > > v5:
> > >   1. virtio_balloon: follow David Hildenbrand's suggest
> > >     http://lore.kernel.org/all/3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com
> > >   2. fix bug of the reference of "cfg_idx"
> > >     http://lore.kernel.org/all/202403222227.Sdp23Lcb-lkp@intel.com
> > >
> > > v4:
> > >   1. remove support for names array entries being null
> > >   2. remove cfg_idx from virtio_vq_config
> > >
> > > v3:
> > >   1. fix the bug: "assignment of read-only location '*cfg.names'"
> > >
> > > v2:
> > >   1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen
> > >
> > > v1:
> > >   1. fix some comments from ilpo.jarvinen@linux.intel.com
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > Xuan Zhuo (6):
> > >   virtio_balloon: remove the dependence where names[] is null
> > >   virtio: remove support for names array entries being null.
> > >   virtio: find_vqs: pass struct instead of multi parameters
> > >   virtio: vring_create_virtqueue: pass struct instead of multi
> > >     parameters
> > >   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
> > >   virtio_ring: simplify the parameters of the funcs related to
> > >     vring_create/new_virtqueue()
> > >
> > >  arch/um/drivers/virtio_uml.c             |  36 +++--
> > >  drivers/platform/mellanox/mlxbf-tmfifo.c |  23 +--
> > >  drivers/remoteproc/remoteproc_virtio.c   |  37 +++--
> > >  drivers/s390/virtio/virtio_ccw.c         |  38 ++---
> > >  drivers/virtio/virtio_balloon.c          |  48 +++---
> > >  drivers/virtio/virtio_mmio.c             |  36 +++--
> > >  drivers/virtio/virtio_pci_common.c       |  69 ++++-----
> > >  drivers/virtio/virtio_pci_common.h       |   9 +-
> > >  drivers/virtio/virtio_pci_legacy.c       |  16 +-
> > >  drivers/virtio/virtio_pci_modern.c       |  37 +++--
> > >  drivers/virtio/virtio_ring.c             | 177 ++++++++---------------
> > >  drivers/virtio/virtio_vdpa.c             |  51 +++----
> > >  include/linux/virtio_config.h            |  76 +++++++---
> > >  include/linux/virtio_ring.h              |  93 +++++++-----
> > >  tools/virtio/virtio_test.c               |   4 +-
> > >  tools/virtio/vringh_test.c               |  28 ++--
> > >  16 files changed, 384 insertions(+), 394 deletions(-)
> > >
> > > --
> > > 2.32.0.3.g01195cf9f
> >



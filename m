Return-Path: <kvm+bounces-3272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86BFB802564
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 17:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FF2D1F2101A
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 16:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6974315AEB;
	Sun,  3 Dec 2023 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ab++o12s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2B9A8
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 08:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701620638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZvOG5O1XML8m5bdEgP0BLaNE6m6L+TFl+VYXFF/Gc=;
	b=ab++o12sFhMNsdMoEG4uQ5u68DU26VUfNwal9n72Ha1HHZzQcX+pqEZeIRXOOTvuCxacFp
	+7wxOTfJJ/tWbbHEKtMEwsot2inc7rh+w0jzTGhaa1YMLt39WicG7ammZP6PKAtPs/GQQy
	cOlI/lx0+AVZ731IGC/GxjCpicsPCoY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-U81Qnn82MDG-dijy54LRRg-1; Sun, 03 Dec 2023 11:23:57 -0500
X-MC-Unique: U81Qnn82MDG-dijy54LRRg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-407d3e55927so31483235e9.1
        for <kvm@vger.kernel.org>; Sun, 03 Dec 2023 08:23:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701620636; x=1702225436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnZvOG5O1XML8m5bdEgP0BLaNE6m6L+TFl+VYXFF/Gc=;
        b=U2n7Ux5ASWQ+aKYV3XlstIjjxWwQlXc+yKF4k9LgzVSXSIsREp4r4SYRkvSLmvyfYd
         U56HvfeEQ0TQAyljWOIfQkYrtdKxDWdW4gh1fv9dPu70n3PxReNb9Cu7RvkHZpbZYVTn
         EeZ72oBTzLn2pGcPecdrrwvEa0FN0Lz1TrC4/9CHnrZAgx0TJTT7hriS1SKGUb6W+7ry
         t1+dObG5VcgyoR2MW51pysrGe0a5MRMtJTotLoPRNPaYIBH6UZggfJ/hra/OOHkCkJLp
         PaLXZJ1wccWS+tnxwQlu0cXR0U77n6npCiRcha8IHmdILDsx8t1/g5zpgsb98bmsU5/u
         6ksQ==
X-Gm-Message-State: AOJu0YxeSwY2giw449d9trPvGXPgrBbETVjsGg4QsWI6m+jeIHzdORPn
	hbTsxnZeKb5IhX8KAYA8wIYL5z1xbUcI41hqp8ew7L/pCBKzvd/HKk7F+9G7YlD6plZKcnrltnN
	rUKf4UFfhgsDH
X-Received: by 2002:a05:600c:705:b0:40b:5e21:dd4f with SMTP id i5-20020a05600c070500b0040b5e21dd4fmr1874531wmn.125.1701620635910;
        Sun, 03 Dec 2023 08:23:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKP9eXqXIJINqxrVU9tyc8Z3UHQwADTnS0+oYOUt7wpJ1p/7gUBKwhI0K0i3D0cbqq7yqUBw==
X-Received: by 2002:a05:600c:705:b0:40b:5e21:dd4f with SMTP id i5-20020a05600c070500b0040b5e21dd4fmr1874523wmn.125.1701620635528;
        Sun, 03 Dec 2023 08:23:55 -0800 (PST)
Received: from redhat.com ([2.55.11.133])
        by smtp.gmail.com with ESMTPSA id jg23-20020a05600ca01700b0040b30be6244sm12148007wmb.24.2023.12.03.08.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 08:23:54 -0800 (PST)
Date: Sun, 3 Dec 2023 11:23:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	Parav Pandit <parav@nvidia.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	"galp@nvidia.com" <galp@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Message-ID: <20231203112324-mutt-send-email-mst@kernel.org>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
 <20231202152523-mutt-send-email-mst@kernel.org>
 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>

On Sun, Dec 03, 2023 at 03:21:01PM +0000, Dragos Tatulea wrote:
> On Sat, 2023-12-02 at 15:26 -0500, Michael S. Tsirkin wrote:
> > On Fri, Dec 01, 2023 at 12:48:50PM +0200, Dragos Tatulea wrote:
> > > Add support for resumable vqs in the driver. This is a firmware feature
> > > that can be used for the following benefits:
> > > - Full device .suspend/.resume.
> > > - .set_map doesn't need to destroy and create new vqs anymore just to
> > >   update the map. When resumable vqs are supported it is enough to
> > >   suspend the vqs, set the new maps, and then resume the vqs.
> > > 
> > > The first patch exposes the relevant bits in mlx5_ifc.h. That means it
> > > needs to be applied to the mlx5-vhost tree [0] first.
> > 
> > I didn't get this. Why does this need to go through that tree?
> > Is there a dependency on some other commit from that tree?
> > 
> To avoid merge issues in Linus's tree in mlx5_ifc.h. The idea is the same as for
> the "vq descriptor mappings" patchset [1].
> 
> Thanks,
> Dragos

Are there other changes in that area that will cause non-trivial merge
conflicts?

> > > Once applied
> > > there, the change has to be pulled from mlx5-vhost into the vhost tree
> > > and only then the remaining patches can be applied. Same flow as the vq
> > > descriptor mappings patchset [1].
> > > 
> > > To be able to use resumable vqs properly, support for selectively modifying
> > > vq parameters was needed. This is what the middle part of the series
> > > consists of.
> > > 
> > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
> > > [1] https://lore.kernel.org/virtualization/20231018171456.1624030-2-dtatulea@nvidia.com/
> > > 
> > > Dragos Tatulea (7):
> > >   vdpa/mlx5: Expose resumable vq capability
> > >   vdpa/mlx5: Split function into locked and unlocked variants
> > >   vdpa/mlx5: Allow modifying multiple vq fields in one modify command
> > >   vdpa/mlx5: Introduce per vq and device resume
> > >   vdpa/mlx5: Mark vq addrs for modification in hw vq
> > >   vdpa/mlx5: Mark vq state for modification in hw vq
> > >   vdpa/mlx5: Use vq suspend/resume during .set_map
> > > 
> > >  drivers/vdpa/mlx5/core/mr.c        |  31 +++---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 172 +++++++++++++++++++++++++----
> > >  include/linux/mlx5/mlx5_ifc.h      |   3 +-
> > >  include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
> > >  4 files changed, 174 insertions(+), 36 deletions(-)
> > > 
> > > -- 
> > > 2.42.0
> > 
> 



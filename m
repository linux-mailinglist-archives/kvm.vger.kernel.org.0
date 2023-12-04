Return-Path: <kvm+bounces-3303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 842D3802DA4
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D7E01F2114F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880E3FC09;
	Mon,  4 Dec 2023 08:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2ipHsj7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB361D8
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 00:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701680118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0AN6JCFDsnCGduiL8fNvKVYamhB7M2dQghKbiuZenRQ=;
	b=V2ipHsj7/vqtIzoWc+SQIGdFEkBE8QcEPVaKJj84YSyDeqDhwiTqwZySk1NeB924rpZw23
	/EOzV5BH6a01NDnx05/NA6LxSRM+uX2UkO6wbXblZdWw1K4DuW1CVxtYft6cv5qBelSLXc
	BA47syGikmGrQN3KZ3rHqczKxP6F11o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-QwoU1VUJO5mt8oZ-TvIcng-1; Mon, 04 Dec 2023 03:55:15 -0500
X-MC-Unique: QwoU1VUJO5mt8oZ-TvIcng-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3334e7d1951so295588f8f.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 00:55:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701680112; x=1702284912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AN6JCFDsnCGduiL8fNvKVYamhB7M2dQghKbiuZenRQ=;
        b=EliQBn6luJExijutdagy10hTM7Z9tpOULefyqjsxUkwHokDelZcIGemrxvFswV5yYR
         Nipu+z9AkA3j9xEOe6sTTmVsMjXVHRcjyjSbxtIZBnm1pUq5rtXAO+NFSEHkXqvXTOfG
         zQMLXidAxrj24u8qVUyX358tMFkx6m9k4VyPv/dIG+nEY6eOUe4DB9TcBF+PoBs+USiU
         Y6Rxr69/zoENLpdUDNgSSyjAO0xgWgioNCddIF03syhZLeZOUJO1aeNUMuN4PnaWscjx
         DKbHXecMdzNExVLP7X6r4lgQMf5dnFrwMn7f5upAN0/APPWdRddIgxbDRKiwwa1FRoRv
         X/lg==
X-Gm-Message-State: AOJu0Yzm+KHhnYcEcdXzMFWVCwnvRn0C6YG69Cj8C6yPmM4ErPQYno3Z
	mkG1yUeAjPA1yMtDwxCxVDroBpZtVt4+JbomlEvThxxaQVMJo7852eX1YfHXth//nQUWNquLlYZ
	irYMxlzuFv4bb
X-Received: by 2002:adf:fe03:0:b0:333:2fd2:765e with SMTP id n3-20020adffe03000000b003332fd2765emr1292015wrr.79.1701680112063;
        Mon, 04 Dec 2023 00:55:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6o767vIbm8ZsJXOcZvJBzFh+btgTQgB0JYi5+5AiuODwwmWvCd5ESmGDV8zXhTYkKs+bnzA==
X-Received: by 2002:adf:fe03:0:b0:333:2fd2:765e with SMTP id n3-20020adffe03000000b003332fd2765emr1292008wrr.79.1701680111648;
        Mon, 04 Dec 2023 00:55:11 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id b12-20020a05600010cc00b0033340aa3de2sm4299066wrx.14.2023.12.04.00.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 00:55:11 -0800 (PST)
Date: Mon, 4 Dec 2023 03:55:07 -0500
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
Message-ID: <20231204035443-mutt-send-email-mst@kernel.org>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
 <20231202152523-mutt-send-email-mst@kernel.org>
 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
 <20231203112324-mutt-send-email-mst@kernel.org>
 <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>

On Mon, Dec 04, 2023 at 08:53:26AM +0000, Dragos Tatulea wrote:
> On Sun, 2023-12-03 at 11:23 -0500, Michael S. Tsirkin wrote:
> > On Sun, Dec 03, 2023 at 03:21:01PM +0000, Dragos Tatulea wrote:
> > > On Sat, 2023-12-02 at 15:26 -0500, Michael S. Tsirkin wrote:
> > > > On Fri, Dec 01, 2023 at 12:48:50PM +0200, Dragos Tatulea wrote:
> > > > > Add support for resumable vqs in the driver. This is a firmware feature
> > > > > that can be used for the following benefits:
> > > > > - Full device .suspend/.resume.
> > > > > - .set_map doesn't need to destroy and create new vqs anymore just to
> > > > >   update the map. When resumable vqs are supported it is enough to
> > > > >   suspend the vqs, set the new maps, and then resume the vqs.
> > > > > 
> > > > > The first patch exposes the relevant bits in mlx5_ifc.h. That means it
> > > > > needs to be applied to the mlx5-vhost tree [0] first.
> > > > 
> > > > I didn't get this. Why does this need to go through that tree?
> > > > Is there a dependency on some other commit from that tree?
> > > > 
> > > To avoid merge issues in Linus's tree in mlx5_ifc.h. The idea is the same as for
> > > the "vq descriptor mappings" patchset [1].
> > > 
> > > Thanks,
> > > Dragos
> > 
> > Are there other changes in that area that will cause non-trivial merge
> > conflicts?
> > 
> There are pending changes in mlx5_ifc.h for net-next. I haven't seen any changes
> around the touched structure but I would prefer not to take any risk.
> 
> Thanks,
> Dragos

This is exactly what linux-next is for.


> > > > > Once applied
> > > > > there, the change has to be pulled from mlx5-vhost into the vhost tree
> > > > > and only then the remaining patches can be applied. Same flow as the vq
> > > > > descriptor mappings patchset [1].
> > > > > 
> > > > > To be able to use resumable vqs properly, support for selectively modifying
> > > > > vq parameters was needed. This is what the middle part of the series
> > > > > consists of.
> > > > > 
> > > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
> > > > > [1] https://lore.kernel.org/virtualization/20231018171456.1624030-2-dtatulea@nvidia.com/
> > > > > 
> > > > > Dragos Tatulea (7):
> > > > >   vdpa/mlx5: Expose resumable vq capability
> > > > >   vdpa/mlx5: Split function into locked and unlocked variants
> > > > >   vdpa/mlx5: Allow modifying multiple vq fields in one modify command
> > > > >   vdpa/mlx5: Introduce per vq and device resume
> > > > >   vdpa/mlx5: Mark vq addrs for modification in hw vq
> > > > >   vdpa/mlx5: Mark vq state for modification in hw vq
> > > > >   vdpa/mlx5: Use vq suspend/resume during .set_map
> > > > > 
> > > > >  drivers/vdpa/mlx5/core/mr.c        |  31 +++---
> > > > >  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 172 +++++++++++++++++++++++++----
> > > > >  include/linux/mlx5/mlx5_ifc.h      |   3 +-
> > > > >  include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
> > > > >  4 files changed, 174 insertions(+), 36 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.42.0
> > > > 
> > > 
> > 
> 



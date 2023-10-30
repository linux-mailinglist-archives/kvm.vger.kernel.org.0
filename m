Return-Path: <kvm+bounces-141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B71A7DC326
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 00:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EF6C1C20B9D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 23:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B7B19BB6;
	Mon, 30 Oct 2023 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbFvMXkl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089A4199AF
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 23:31:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340EEC2
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698708711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hr5b+/tamFpp9Nju6BJVO0BdbMTX3Xt5jeifbWo4b6E=;
	b=VbFvMXklkYQ2v+6PNgwR/nb+fVzzAo75IdOpLKQ5s6p3zvlnHDdKGQTKbcKZAI9dgNGfLe
	TcJwqbMDnGm5gJ3Nqvb0ra1LgiuJljaPU+buonWz1NNLZDwhClo6O3bd1lTorkHmK6yBSt
	I54vtdUBo4xuIsTVOleA6vEni3c4/LM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-AyIE2EQGPteZ8703rGW2qA-1; Mon, 30 Oct 2023 19:31:44 -0400
X-MC-Unique: AyIE2EQGPteZ8703rGW2qA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40837aa4a58so33523105e9.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698708703; x=1699313503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hr5b+/tamFpp9Nju6BJVO0BdbMTX3Xt5jeifbWo4b6E=;
        b=uxAI0MlrFUu+/jYPI8MR/WvzS7mV3VOEwdJcJIuNnabU8PPzxpJ6yH71TZWuTlWjQP
         X2x3zRvn2a4vzAq1fBXzCT+wpaae/QNgLd6ZncC3WRxm99dgijvhL3Ki1cs/+bdWV7qB
         KurA2wKVnWzWIIzsI03oB3iMRBPF/LsTwpP+BLUIqqXn9F8he8m8ctZEgoAChenINhR/
         Io9XZaFCwYBvwEpIMd7/62ULkKnOYImDQXZbUljT9VXlTlXwjRpcxqGVyCoMR9WlPt4l
         KC69Ox7N4BMnMmny4hPsbUaYdraW2XoFyADNA64mazicaznz3cNaDiv66LowZso5wSDl
         MgHA==
X-Gm-Message-State: AOJu0YzKM9z68QJJ+EskB1vHZLyf2mSee/zVZ18CAhaFgndixeZhJfxG
	1rSk3ATuVMTizC53Z5CFKer6Dsm7Ft59JNiVB0XG/uCMT1yWvewpEW/OLzPUrbBg06F/KqKBoWd
	ckc5WnPSc77I7
X-Received: by 2002:a05:600c:5408:b0:405:358c:ba74 with SMTP id he8-20020a05600c540800b00405358cba74mr1087252wmb.0.1698708703266;
        Mon, 30 Oct 2023 16:31:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEB5LIBlkQ+jVd4pnrhNDIucdhp/bRgd7Y4NOKOvq4dvjKk9iXv7t9mM2QJArjIcoshhuYjQ==
X-Received: by 2002:a05:600c:5408:b0:405:358c:ba74 with SMTP id he8-20020a05600c540800b00405358cba74mr1087239wmb.0.1698708702926;
        Mon, 30 Oct 2023 16:31:42 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c294200b0040775fd5bf9sm156640wmd.0.2023.10.30.16.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 16:31:42 -0700 (PDT)
Date: Mon, 30 Oct 2023 19:31:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Parav Pandit <parav@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH V2 vfio 2/9] virtio-pci: Introduce admin virtqueue
Message-ID: <20231030193110-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-3-yishaih@nvidia.com>
 <20231029161909-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54810E45C628DE3A5829D438DCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231030115759-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548197CD7A10D5A89B7213CDDCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548197CD7A10D5A89B7213CDDCA1A@PH0PR12MB5481.namprd12.prod.outlook.com>

On Mon, Oct 30, 2023 at 06:10:06PM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Monday, October 30, 2023 9:29 PM
> > On Mon, Oct 30, 2023 at 03:51:40PM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Monday, October 30, 2023 1:53 AM
> > > >
> > > > On Sun, Oct 29, 2023 at 05:59:45PM +0200, Yishai Hadas wrote:
> > > > > From: Feng Liu <feliu@nvidia.com>
> > > > >
> > > > > Introduce support for the admin virtqueue. By negotiating
> > > > > VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates
> > > > > one administration virtqueue. Administration virtqueue
> > > > > implementation in virtio pci generic layer, enables multiple types
> > > > > of upper layer drivers such as vfio, net, blk to utilize it.
> > > > >
> > > > > Signed-off-by: Feng Liu <feliu@nvidia.com>
> > > > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > > ---
> > > > >  drivers/virtio/virtio.c                | 37 ++++++++++++++--
> > > > >  drivers/virtio/virtio_pci_common.c     |  3 ++
> > > > >  drivers/virtio/virtio_pci_common.h     | 15 ++++++-
> > > > >  drivers/virtio/virtio_pci_modern.c     | 61 +++++++++++++++++++++++++-
> > > > >  drivers/virtio/virtio_pci_modern_dev.c | 18 ++++++++
> > > > >  include/linux/virtio_config.h          |  4 ++
> > > > >  include/linux/virtio_pci_modern.h      |  5 +++
> > > > >  7 files changed, 137 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > index
> > > > > 3893dc29eb26..f4080692b351 100644
> > > > > --- a/drivers/virtio/virtio.c
> > > > > +++ b/drivers/virtio/virtio.c
> > > > > @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
> > > > >  	if (err)
> > > > >  		goto err;
> > > > >
> > > > > +	if (dev->config->create_avq) {
> > > > > +		err = dev->config->create_avq(dev);
> > > > > +		if (err)
> > > > > +			goto err;
> > > > > +	}
> > > > > +
> > > > >  	err = drv->probe(dev);
> > > > >  	if (err)
> > > > > -		goto err;
> > > > > +		goto err_probe;
> > > > >
> > > > >  	/* If probe didn't do it, mark device DRIVER_OK ourselves. */
> > > > >  	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
> > > >
> > > > Hmm I am not all that happy that we are just creating avq unconditionally.
> > > > Can't we do it on demand to avoid wasting resources if no one uses it?
> > > >
> > > Virtio queues must be enabled before driver_ok as we discussed in
> > F_DYNAMIC bit exercise.
> > > So creating AQ when first legacy command is invoked, would be too late.
> > 
> > Well we didn't release the spec with AQ so I am pretty sure there are no devices
> > using the feature. Do we want to already make an exception for AQ and allow
> > creating AQs after DRIVER_OK even without F_DYNAMIC?
> > 
> No. it would abuse the init time config registers for the dynamic things like this.
> For flow filters and others there is need for dynamic q creation with multiple physical address anyway.

That seems like a completely unrelated issue.

> So creating virtqueues dynamically using a generic scheme is desired with new feature bit.



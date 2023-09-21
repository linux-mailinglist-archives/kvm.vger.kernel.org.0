Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA37A95FA
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjIUQ50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjIUQ5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:57:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AAE110
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTY51miggRdWE++wgWPSa631sVV6TNDOXdpfXXaCrio=;
        b=g8ghs3q1xhAwE4eU+6sV9HU/2PlV5lucx4u/tET81Bw18GW+UVS5BNOkocLMoqJglPRbpC
        GuzW+/QvySiAn+HuxhooO4TqMLSCo6JBKp/8+AuwbZPxVx2Qc8Gu+F1zmTAwIwpPITLtzb
        8E6Oxu1/p7rXman4A1/oNrkJCXu4fb8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-CAsvDlxLOWqiuVbpvqvfXw-1; Thu, 21 Sep 2023 12:53:10 -0400
X-MC-Unique: CAsvDlxLOWqiuVbpvqvfXw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae0601d689so92788766b.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315189; x=1695919989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTY51miggRdWE++wgWPSa631sVV6TNDOXdpfXXaCrio=;
        b=Tu8IdvmdqNp2CyXD1gFjtb5OLIfkK3F7qnLBxFcQEGzsDdUncblc/MOr8yS4ypns1c
         uBmFHxpKNQNZ3gnuPcDQ3SgvGMjQSLl/W05zQgDp9syadjljA4Pn4jSRsHNB90xjsi+z
         iP8w123Xb9utK+TcBB7paQqAHYEac8O7NMNsdbsgzTK0yqeaFPCKJyMbv/+glG0jk0Wv
         NDc/8Fkfc29otc9+9VyO63Lr36lJF1NAaxaoEe53hRyMLeUrsuzh3HqoNEJzO+/jP19s
         NPCDoNj8kXI0Wko1DNZNHXGdzGtfkUNhWTTJ5McHs5K8eX0f5WnaFxa3/NwP4t1FzVb/
         V2xA==
X-Gm-Message-State: AOJu0YzN0+bFB27tVEziD3JzY4aKCVz/7hHLA5FxpiYq6zmC9aIvBa6U
        sMzhd8XVpELOla3P/MY0Y+voZ+Q7nJiqQXuVLxwuEJ0YhYvFh/uI2XBcgEm99Nr3OyX8eZgM/33
        uKd78DZ6IdGqu
X-Received: by 2002:a17:906:2096:b0:9ae:1de:f4fb with SMTP id 22-20020a170906209600b009ae01def4fbmr4943112ejq.46.1695315189579;
        Thu, 21 Sep 2023 09:53:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkuLbe2i4Ae15AXKkkLrs7IbEfMsz8AYs1syIIGDGmJjEOv+8QQvZkGaXHkm+zKICx2kVaNA==
X-Received: by 2002:a17:906:2096:b0:9ae:1de:f4fb with SMTP id 22-20020a170906209600b009ae01def4fbmr4943100ejq.46.1695315189205;
        Thu, 21 Sep 2023 09:53:09 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id h1-20020a1709063c0100b0099bc038eb2bsm1304274ejg.58.2023.09.21.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 09:53:08 -0700 (PDT)
Date:   Thu, 21 Sep 2023 12:53:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921124331-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921164139.GP13733@nvidia.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:41:39PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 10:16:04AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 11:11:25AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 09:16:21AM -0400, Michael S. Tsirkin wrote:
> > > 
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index bf0f54c24f81..5098418c8389 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
> > > > >  S:	Maintained
> > > > >  F:	drivers/vfio/pci/mlx5/
> > > > >  
> > > > > +VFIO VIRTIO PCI DRIVER
> > > > > +M:	Yishai Hadas <yishaih@nvidia.com>
> > > > > +L:	kvm@vger.kernel.org
> > > > > +S:	Maintained
> > > > > +F:	drivers/vfio/pci/virtio
> > > > > +
> > > > >  VFIO PCI DEVICE SPECIFIC DRIVERS
> > > > >  R:	Jason Gunthorpe <jgg@nvidia.com>
> > > > >  R:	Yishai Hadas <yishaih@nvidia.com>
> > > > 
> > > > Tying two subsystems together like this is going to cause pain when
> > > > merging. God forbid there's something e.g. virtio net specific
> > > > (and there's going to be for sure) - now we are talking 3
> > > > subsystems.
> > > 
> > > Cross subsystem stuff is normal in the kernel.
> > 
> > Yea. But it's completely spurious here - virtio has its own way
> > to work with userspace which is vdpa and let's just use that.
> > Keeps things nice and contained.
> 
> vdpa is not vfio, I don't know how you can suggest vdpa is a
> replacement for a vfio driver. They are completely different
> things.
> Each side has its own strengths, and vfio especially is accelerating
> in its capability in way that vpda is not. eg if an iommufd conversion
> had been done by now for vdpa I might be more sympathetic.

Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
sick and I didn't know and kept assuming she's working on this. I don't
think it's a huge amount of work though.  I'll take a look.
Is there anything else though? Do tell.

> Asking for
> someone else to do a huge amount of pointless work to improve vdpa
> just to level of this vfio driver already is at is ridiculous.
> 
> vdpa is great for certain kinds of HW, let it focus on that, don't try
> to paint it as an alternative to vfio. It isn't.
> 
> Jason

There are a bunch of things that I think are important for virtio
that are completely out of scope for vfio, such as migrating
cross-vendor. What is the huge amount of work am I asking to do?



-- 
MST


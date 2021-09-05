Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AAE4010BD
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbhIEQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 12:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237870AbhIEQDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 12:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630857769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UFUKBgO0Ri1xXVfSTLwQQ6n1EXRj/R2St3GRxbwUsHQ=;
        b=Nn5pFIVIdlJ6NotAlB5EAfRI2LZOW4UaEnOgbU8hzBUVxDALLZ0U29VC0Gw8t5ewDdSXi0
        uoC1xLYYYasDX6bfG1gOZwYrfYmCJcZfpxlyIpPXFEOpzsfc23yTuWKXIuKHJVTRRxVyNH
        PNNgkzu9rvbOUfUpAP5wvX03QWG4Xsc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-lCU3VC_QNJGxCb6N1cICWQ-1; Sun, 05 Sep 2021 12:02:48 -0400
X-MC-Unique: lCU3VC_QNJGxCb6N1cICWQ-1
Received: by mail-wm1-f70.google.com with SMTP id v2-20020a7bcb420000b02902e6b108fcf1so2711011wmj.8
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 09:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UFUKBgO0Ri1xXVfSTLwQQ6n1EXRj/R2St3GRxbwUsHQ=;
        b=XFjTVssn+uA3tGzOliLsccRLyZRpDZ7xFK0oatb98zHQ1dP9loU/G49YhGfwFnJdl5
         HAClBa5WMShRHOwCtNFYsjtXlBIREvOuWJhIcjliwaMXCYF0JuYJZ1wHgsfKIYGMZO/f
         Mwn4byww2poWHcRMCbtCovysq/WiHjS14e70O/iRyKYznTKUSZ6gxIzHwPNqUTXp8Miy
         WegS3vPK0v1VP/mVleV6+XOn8R+CRQKmbePMcxXEimAZj4dXrF+VGXKVrfdWHs/crTFP
         VlyHZeIAmuirqZkUwLhb0bKKn15TbpD+maGA9Tp1oIYzzalO6PSDsls9EqjtLODZAd1N
         6K1g==
X-Gm-Message-State: AOAM533xF5CesX6spqlLkg8UimEUiyTAsAt2SWjx/ynSpvSTC+fJJq5y
        LhAGHAvOcIl7nXL+wVCajBGTlIrevGLB68tyKekdB4JT/GDBzGmN/WFV3gtBcaV7cgIEE7ucTvD
        HlwiOOpVYUhWx
X-Received: by 2002:a1c:7503:: with SMTP id o3mr7425517wmc.129.1630857767179;
        Sun, 05 Sep 2021 09:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+jYdy0uL4WaJOpJ4iOFHt6H+cjCfQhzErPuJ1lH4FMlns0HOWIVet2jX9qnAP00mbt8+/SQ==
X-Received: by 2002:a1c:7503:: with SMTP id o3mr7425490wmc.129.1630857766939;
        Sun, 05 Sep 2021 09:02:46 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id q11sm4833205wmc.41.2021.09.05.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 09:02:46 -0700 (PDT)
Date:   Sun, 5 Sep 2021 12:02:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210905120234-mutt-send-email-mst@kernel.org>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > Sometimes a user would like to control the amount of IO queues to be
> > created for a block device. For example, for limiting the memory
> > footprint of virtio-blk devices.
> > 
> > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > ---
> > 
> > changes from v1:
> >  - use param_set_uint_minmax (from Christoph)
> >  - added "Should > 0" to module description
> > 
> > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > ---
> >  drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 4b49df2dfd23..9332fc4e9b31 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -24,6 +24,22 @@
> >  /* The maximum number of sg elements that fit into a virtqueue */
> >  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> >  
> > +static int virtblk_queue_count_set(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > +}
> > +
> > +static const struct kernel_param_ops queue_count_ops = {
> > +	.set = virtblk_queue_count_set,
> > +	.get = param_get_uint,
> > +};
> > +
> > +static unsigned int num_io_queues;
> > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > +MODULE_PARM_DESC(num_io_queues,
> > +		 "Number of IO virt queues to use for blk device. Should > 0");
> > +
> >  static int major;
> >  static DEFINE_IDA(vd_index_ida);
> >  
> > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> >  	if (err)
> >  		num_vqs = 1;
> >  
> > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > +	num_vqs = min_t(unsigned int,
> > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > +			num_vqs);
> 
> If you respin, please consider calling them request queues. That's the
> terminology from the VIRTIO spec and it's nice to keep it consistent.
> But the purpose of num_io_queues is clear, so:
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

I did this:
+static unsigned int num_io_request_queues;
+module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
+MODULE_PARM_DESC(num_io_request_queues,
+                "Limit number of IO request virt queues to use for each device. 0 for now limit");


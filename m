Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AF8538AF9
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 07:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiEaFmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 01:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242215AbiEaFmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 01:42:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6822177F3F
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 22:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653975740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXZqQ2bmpu17MD3xsKbd7SyCjtmA473Yqjdy/U/0t2k=;
        b=I5sGg6oJSyhIP8GyZ9iiccZvMogwudeTddgSk8PIXdkS6jBnVPfefb+rNINh0rBkGgMHFj
        5seVZSQVxsgci2nddhwFYN8fk2Bo3ppaSJi6udVwui2NQ0MyYkHS9YXXIOAE+YhGpvsea1
        j7L0YeNp8t/Odu8Y6jCIC3kvWBXc+x0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-HesHT-GAMtuxROSEF08YkQ-1; Tue, 31 May 2022 01:42:15 -0400
X-MC-Unique: HesHT-GAMtuxROSEF08YkQ-1
Received: by mail-wr1-f72.google.com with SMTP id e7-20020adfa747000000b0020fe61b0c62so1782426wrd.22
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 22:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lXZqQ2bmpu17MD3xsKbd7SyCjtmA473Yqjdy/U/0t2k=;
        b=4/S9hZPTTuqLR1pyop8wGDZdnv9S56I5uxSDwyNfx9wRbuoYBRCyOsN2C2r43eVAVc
         +PUxJaeI+Q8LZJGSVxv4001yc82Li3odeU+8YTGl5McynMEaICrP2nAINxGNqFR6RLqU
         31rV8WRTIeyyxJ9fLsFODoMdvtrj3gQnPgGCdMIpu3Xh6ugGAy9idIvlR27YN29+gh0E
         xy5iJ8pnDJ5eFjahdjwgL5RrMh0giFBiJgRbNe5BPlfhEjPeWJqLNcIkpfTNKp9O3Tab
         RrQB7Wiq7h6CT1iH5TrY/eA0U/CIVZCtbPsXj3q7uFcy8+fcH05RrCh5OdrpB/HsCBFQ
         NkuQ==
X-Gm-Message-State: AOAM533DEh9YUnzC4sm9GUtJAoaODsyyFysRLOoZlxGBvjSOH66RnJ5p
        x8/G+kYQyipVKfXMod/ey8Bt7XtiJIoBe8K28ff2W/f/7MxBRfaPTiFyJeF6sv/gIRU9TzOaNHo
        p7AcoVLWRZYNA
X-Received: by 2002:a5d:5984:0:b0:20f:f3a1:fc56 with SMTP id n4-20020a5d5984000000b0020ff3a1fc56mr26938587wri.718.1653975734739;
        Mon, 30 May 2022 22:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdE+qW9FBh7CyCXbLKMzMHLR0yj20nkiIZGrztEDmjYsCEbIiQpOmR1K3n4oHtOPy/6V+v4A==
X-Received: by 2002:a5d:5984:0:b0:20f:f3a1:fc56 with SMTP id n4-20020a5d5984000000b0020ff3a1fc56mr26938567wri.718.1653975734469;
        Mon, 30 May 2022 22:42:14 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5949000000b002103136623esm5160877wri.85.2022.05.30.22.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 22:42:13 -0700 (PDT)
Date:   Tue, 31 May 2022 01:42:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, martinpo@xilinx.com,
        lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Message-ID: <20220531014108-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 02:43:34PM +0200, Eugenio Pérez wrote:
> Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> that backend feature and userspace can effectively stop the device.
> 
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
> 
> After the return of ioctl with stop != 0, the device MUST finish any
> pending operations like in flight requests. It must also preserve all
> the necessary state (the virtqueue vring base plus the possible device
> specific states) that is required for restoring in the future. The
> device must not change its configuration after that point.
> 
> After the return of ioctl with stop == 0, the device can continue
> processing buffers as long as typical conditions are met (vq is enabled,
> DRIVER_OK status bit is enabled, etc).
> 
> In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_FD
> so the device can save pending operations.
> 
> Comments are welcome.


So given this is just for simulator and affects UAPI I think it's fine
to make it wait for the next merge window, until there's a consensus.
Right?

> v4:
> * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> 
> v3:
> * s/VHOST_STOP/VHOST_VDPA_STOP/
> * Add documentation and requirements of the ioctl above its definition.
> 
> v2:
> * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> * Fix obtaining of stop ioctl arg (it was not obtained but written).
> * Add stop to vdpa_sim_blk.
> 
> Eugenio Pérez (4):
>   vdpa: Add stop operation
>   vhost-vdpa: introduce STOP backend feature bit
>   vhost-vdpa: uAPI to stop the device
>   vdpa_sim: Implement stop vdpa op
> 
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
>  include/linux/vdpa.h                 |  6 +++++
>  include/uapi/linux/vhost.h           | 14 ++++++++++++
>  include/uapi/linux/vhost_types.h     |  2 ++
>  8 files changed, 83 insertions(+), 1 deletion(-)
> 
> -- 
> 2.31.1
> 


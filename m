Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67D57D8626
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345468AbjJZPrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjJZPrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 11:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB19AF
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698335184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7Ca1EAZL+2Z1bfHSI962eRHVYOz5lUhj6+DjkPXJCM=;
        b=P9xviG/QMb64anNfYWhgJTiaHeaLg2rgruq9hf1OkBt91LdmNEwyCJnnjEgdam+L1wgC5+
        aC6kJ8EGijgF7PpJnjljfgIzlysgBxHYNX1+PHTPI9xITg8AyfLccwTngORhlIW86ot7Il
        MxL8ApYYqQZXDVlqRMZN8mpHCNeaJT4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-IH2ozFCaPDuUEiDvTRM2AQ-1; Thu, 26 Oct 2023 11:46:21 -0400
X-MC-Unique: IH2ozFCaPDuUEiDvTRM2AQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-993c2d9e496so72264666b.0
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:46:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698335180; x=1698939980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7Ca1EAZL+2Z1bfHSI962eRHVYOz5lUhj6+DjkPXJCM=;
        b=Y+u04Q/2/dbH1a3K9HJPxUCv4181HL+sgyRmQdqZ25sT+4HAynBa7DTo5W2kKajTCc
         uKC9z1JWMmOlx4FKjRYh4W/ausooh1OaSN7oDC9wQOnh2jChl1Y45d3x0ruOP/oXSp7p
         WcRGzNn28IWHJ/WQ+S6+TdnjAxAT/LA+QSOP1vaVa+nGLYSOY3VsL5l+UbXxVRpaOG3U
         XZuzjJD8+vg69ZQ/lzbwOzeo/moQvVQ8FMc8xbcO5TTvwsHaEqEbBrC67GtHqv5pt+Hi
         UHOwm2K6hGxlbLpC7LqybOGPYs3HUbXxqmry53EyT+8QvFR/02ah4OZ1AHxmJ9Fbe2uM
         0btg==
X-Gm-Message-State: AOJu0Yz5yGQT/VaQxSod/varEuprNgWqnrU1zrYcUnhX3ILQ8Q6+92EL
        tzXwDwYXYDTxwtCdNuQKTeP0q4cTY6mNuqZvC0gMLbmePk3Ek0U2n9+ERunGJacVAjgtksbAdAl
        kyM0uGaqgyoMz
X-Received: by 2002:a17:906:fe06:b0:9c5:b535:ecb2 with SMTP id wy6-20020a170906fe0600b009c5b535ecb2mr75817ejb.40.1698335180277;
        Thu, 26 Oct 2023 08:46:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVQkSXrrdczESMqkWdiPrB10Y3ArwHAIVLW1OGeFIR3ZM33q6KKWKskiUbWxVPk206cohaHQ==
X-Received: by 2002:a17:906:fe06:b0:9c5:b535:ecb2 with SMTP id wy6-20020a170906fe0600b009c5b535ecb2mr75798ejb.40.1698335179911;
        Thu, 26 Oct 2023 08:46:19 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:37eb:8e1f:4b3b:22c7:7722])
        by smtp.gmail.com with ESMTPSA id li18-20020a170906f99200b0099297782aa9sm11654841ejb.49.2023.10.26.08.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 08:46:19 -0700 (PDT)
Date:   Thu, 26 Oct 2023 11:46:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026112804-mutt-send-email-mst@kernel.org>
References: <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026091459-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548167D2A92F3D10E4F02E93DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026110426-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54819C408A120436010F608FDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB54819C408A120436010F608FDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 03:09:13PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Thursday, October 26, 2023 8:36 PM
> > 
> > On Thu, Oct 26, 2023 at 01:28:18PM +0000, Parav Pandit wrote:
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Thursday, October 26, 2023 6:45 PM
> > >
> > > > > Followed by an open coded driver check for 0x1000 to 0x103f range.
> > > > > Do you mean windows driver expects specific subsystem vendor id of
> > 0x1af4?
> > > >
> > > > Look it up, it's open source.
> > >
> > > Those are not OS inbox drivers anyway.
> > > :)
> > 
> > Does not matter at all if guest has drivers installed.
> > Either you worry about legacy guests or not.
> > 
> So, Linux guests have inbox drivers, that we care about and they seems to be covered, right?
> 
> > 
> > > The current vfio driver is following the virtio spec based on legacy spec, 1.x
> > spec following the transitional device sections.
> > > There is no need to do something out of spec at this point.
> > 
> > legacy spec wasn't maintained properly, drivers diverged sometimes
> > significantly. what matters is installed base.
> 
> So if you know the subsystem vendor id that Windows expects, please share, so we can avoid playing puzzle game. :)
> It anyway can be reported by the device itself.

I don't know myself offhand. I just know it's not so simple. Looking at the source
for network drivers I see:

%kvmnet6.DeviceDesc%    = kvmnet6.ndi, PCI\VEN_1AF4&DEV_1000&SUBSYS_0001_INX_SUBSYS_VENDOR_ID&REV_00, PCI\VEN_1AF4&DEV_1000


So the drivers will:
A. bind with high priority to subsystem vendor ID used when drivers where built.
   popular drivers built and distributed for free by Red Hat have 1AF4
B. bind with low priority to any subsystem device/vendor id as long as
   vendor is 1af4 and device is 1000


My conclusions:
- you probably need a way to tweak subsystem vendor id in software
- default should probably be 1AF4 not whatever actual device uses


-- 
MST


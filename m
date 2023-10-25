Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CE47D71BF
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjJYQ3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 12:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjJYQ3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 12:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A3E91
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 09:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698251327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7f29laoIijhonXA1qplGzkrij7Cw17Yg8oi2F3zZn44=;
        b=PvFP7ts2JTTowheEmTPTiaU79rsGRDuAOV5RaURu9wdFK+g9eTlL8Bttj7rIptRfI0w2Wq
        LX2wji3xxfHWm6yBAzej4xEUy25sKQ32A1ELl5EbgpgxZrAR3iz23+4fvsi5Dq2vxktnLm
        qgOZtJgDPMjhInTA+hAvsXmX2RNwWsg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-Z6nGsnnUPAWTw27dmZk01g-1; Wed, 25 Oct 2023 12:28:45 -0400
X-MC-Unique: Z6nGsnnUPAWTw27dmZk01g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32d9a31dc55so2377353f8f.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 09:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698251324; x=1698856124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f29laoIijhonXA1qplGzkrij7Cw17Yg8oi2F3zZn44=;
        b=uvvwJ69XGLPW9+If8Z0Zg7czYBpUVS8K2WqmU7A1hKZ/EGm2HmKq2sKBmDPcpenULW
         2jspfmEGZUs3SUDuqEHlo39x8c8QRUdKCo/I7aatztTS1M92wW1cRfpAmtiia6X2Xr3U
         7IBCbfK1yIKQIIvvlPpnCzbQJsjeE/shMzJCurCAa5ABJP9Gfq2/jUX3wNNR0MGg9JDg
         yyqv2chxCwTOfPS/9tWxmW0a1JKGnN//Vj+SO8hHOSqpASvP2T8zZstDHMnQDcoK1eXy
         3HcMSPK94E6c7ZOuOmzYyy9SO/EEtN5Ys/EhTNG2yYwNqtnCgW7PScDy8iicWasTlxRV
         SHYg==
X-Gm-Message-State: AOJu0YxFuEi+53gWcIfV4ZFnqGCeOuPHkmE00PMmdKok2s+/HxFcZU7W
        vuaupno9mu6FBgvBpMS5raFcbGhtdIqeczBqdKTsgvgQe+5I5U8wrh8XT/Y912cGMDn5TVZErWo
        fBKrHFIiaNbS/
X-Received: by 2002:a05:6000:1109:b0:32d:a41b:bd47 with SMTP id z9-20020a056000110900b0032da41bbd47mr11542318wrw.59.1698251324161;
        Wed, 25 Oct 2023 09:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwFCy0YoDnDfGZABBJQyL64nt6U4pb11zgcVmczDFn3yanVZ8VhqJb6BqWxJQhAbRpcW+bJw==
X-Received: by 2002:a05:6000:1109:b0:32d:a41b:bd47 with SMTP id z9-20020a056000110900b0032da41bbd47mr11542301wrw.59.1698251323829;
        Wed, 25 Oct 2023 09:28:43 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f6:3c98:7fa5:a31:81ed:a5e2])
        by smtp.gmail.com with ESMTPSA id c14-20020adfe74e000000b0032d72f48555sm12387495wrn.36.2023.10.25.09.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 09:28:43 -0700 (PDT)
Date:   Wed, 25 Oct 2023 12:28:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, jasowang@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231025122625-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 05:35:51PM +0300, Yishai Hadas wrote:
> > Do we want to make this only probe the correct subsystem vendor ID or do
> > we want to emulate the subsystem vendor ID as well?  I don't see this is
> > correct without one of those options.
> 
> Looking in the 1.x spec we can see the below.
> 
> Legacy Interfaces: A Note on PCI Device Discovery
> 
> "Transitional devices MUST have the PCI Subsystem
> Device ID matching the Virtio Device ID, as indicated in section 5 ...
> This is to match legacy drivers."
> 
> However, there is no need to enforce Subsystem Vendor ID.
> 
> This is what we followed here.
> 
> Makes sense ?

Won't work for legacy windows drivers.

-- 
MST


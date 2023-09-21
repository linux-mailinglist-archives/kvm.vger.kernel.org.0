Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C307A99A9
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjIUSQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjIUSQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A61D768EE
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kw3etIssxrQ/liX7DeJiNaZoQgTiKSXZrdJc1Pm8JT0=;
        b=RZqrJKMHL8QQ1D58AM+cD+uw06oHImcTs6iBru5YK5GVoRulqez7puxQpOVVb2isuqEFcW
        TFtezD8E3tPWRT1P0v9RvZR9wNNJBVNe1iD9fItd1AHlhJEGpA4zWQBLLhGDQOwagb+Kli
        GCw3izvKTAj95e/A+O3XNlLVe6fK17A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-T0tgEFuxOxGqFf6ygcrXZg-1; Thu, 21 Sep 2023 10:16:10 -0400
X-MC-Unique: T0tgEFuxOxGqFf6ygcrXZg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-532ec54cab9so688888a12.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 07:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695305769; x=1695910569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kw3etIssxrQ/liX7DeJiNaZoQgTiKSXZrdJc1Pm8JT0=;
        b=DwIpWsDUj3mQjjMJf293EA+dF5MZDpz70PlGjhpfF3vIxhhLLdVVkuGsHlMH/y0fzw
         l+3qQ8ec3ok2QZIhHc/dEPfLDtLQlCH8oZTNhiL1loYlLSlfjfSw8OQTox9TN/W+Nw5U
         w8Rsu4MK78UCRBhze61HEzJ1aHFNh442Lwx6zEZWDwJGD//yrkgrRM+8I8wgLs1UPiUz
         sArcWU3szDwMtbOU7gtXjRtuNHzP//57N+PcCteRr6Btl1UPeOmHWZrT2HLi9oqEduFa
         U58ta/cFIztlPW5vjWN0Ro8r4P2HFmjuibeMkV7ZigTIf5s+4btOdn05toCM1ParOk4X
         wjkQ==
X-Gm-Message-State: AOJu0Yw9kGm/fzGfrc0AWESa6rC284nSc6Y7uY6gDdi73t/QtUVRROWf
        8hJfHGo8ZEElsLcbufkRJASDOGHN0MF2yGFuY6saa2GwKLGQaoaNmtUn/9QtZvFrX2ZXkloe+mb
        tcJ3xghjE1NrU
X-Received: by 2002:a05:6402:799:b0:532:e39b:8c05 with SMTP id d25-20020a056402079900b00532e39b8c05mr4331270edy.42.1695305769329;
        Thu, 21 Sep 2023 07:16:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxzLTHbNt2ebIMAxi0oxKaUMqw3rlH/H3Y3TPwFJTbD5T4ggpvGGooE7Nirx4Fu9wkUuMjcQ==
X-Received: by 2002:a05:6402:799:b0:532:e39b:8c05 with SMTP id d25-20020a056402079900b00532e39b8c05mr4331243edy.42.1695305768915;
        Thu, 21 Sep 2023 07:16:08 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id g16-20020a056402181000b005312a2b00cbsm870624edy.63.2023.09.21.07.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:16:08 -0700 (PDT)
Date:   Thu, 21 Sep 2023 10:16:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921101509-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921141125.GM13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 11:11:25AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 09:16:21AM -0400, Michael S. Tsirkin wrote:
> 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index bf0f54c24f81..5098418c8389 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
> > >  S:	Maintained
> > >  F:	drivers/vfio/pci/mlx5/
> > >  
> > > +VFIO VIRTIO PCI DRIVER
> > > +M:	Yishai Hadas <yishaih@nvidia.com>
> > > +L:	kvm@vger.kernel.org
> > > +S:	Maintained
> > > +F:	drivers/vfio/pci/virtio
> > > +
> > >  VFIO PCI DEVICE SPECIFIC DRIVERS
> > >  R:	Jason Gunthorpe <jgg@nvidia.com>
> > >  R:	Yishai Hadas <yishaih@nvidia.com>
> > 
> > Tying two subsystems together like this is going to cause pain when
> > merging. God forbid there's something e.g. virtio net specific
> > (and there's going to be for sure) - now we are talking 3
> > subsystems.
> 
> Cross subsystem stuff is normal in the kernel.

Yea. But it's completely spurious here - virtio has its own way
to work with userspace which is vdpa and let's just use that.
Keeps things nice and contained.

> Drivers should be
> placed in their most logical spot - this driver exposes a VFIO
> interface so it belongs here.
> 
> Your exact argument works the same from the VFIO perspective, someone
> has to have code that belongs to them outside their little sphere
> here.
> 
> > Case in point all other virtio drivers are nicely grouped, have a common
> > mailing list etc etc.  This one is completely separate to the point
> > where people won't even remember to copy the virtio mailing list.
> 
> The virtio mailing list should probably be added to the maintainers
> enry
> 
> Jason


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0B3B1150
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 03:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFWBXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 21:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWBXh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 21:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624411280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6WZjidwpALD0+6okLjRpzpQCZxBF9g0JCe+CU6OJZxo=;
        b=cZHnSC89gbIAWWcRT9UJhnH41wDlBldJwiBRVp2bpErPQXDJFv/TzXDuTGgGfI7dD+tilt
        CehZBb/iOjBosGe6umczxrlVrwVBqftwJUUu4kPMvXT+oiPHaR+Y0Fn6fQfQVdgA2VMvk9
        1qRvE084CPFlTxBPiIhF1VdjhhNO8wE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-fogVp_oeMIOWOATy_FrO-A-1; Tue, 22 Jun 2021 21:21:18 -0400
X-MC-Unique: fogVp_oeMIOWOATy_FrO-A-1
Received: by mail-ot1-f72.google.com with SMTP id i25-20020a9d4a990000b0290304f00e3e3aso211241otf.15
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 18:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6WZjidwpALD0+6okLjRpzpQCZxBF9g0JCe+CU6OJZxo=;
        b=k2PWrA4dthkvpzuF0gvSWKTRIsXLkF5kCxbzQWxBZnkDRxvEZIy4GCMXpb+ZiwBwqD
         KWNTLjRps1o6NzvpqaKzRq4uJa7MnD3e+yOv7fWBsmMAAAIMwaptQk8bMHr3GNK9T7uI
         JTym/Wli9f5VQ5108oWk/6M2rXXeaowMq5e5coomky2POqS9degJX550v0vexqmT/4Y/
         +oFtv8aRYzPrwsT3665lEcNhyFmFrXzWhAU9Z6fDbvH41d5gYoxHX1DQ9u3D5vobswq0
         CGWMBUjRbJyqPJpuH4o6wouBddDxjg12/zt9a3KlrJx5Y2UGBPUlZvNLk+e49bVeI9K0
         Cd4A==
X-Gm-Message-State: AOAM531teyPH2E/byPkby4KWn9a2WmaBQsWHPwaFL/oCRPzRz9fXrl0q
        plU07nwWC28tlhqHOnRkM2PfIIbkFkYGLHf1keD0c4aJ83U2EO+88b/3M/MOFptjQQCBJ3XObwS
        VZMcorOQlAJwo
X-Received: by 2002:a9d:c04:: with SMTP id 4mr5426569otr.245.1624411278072;
        Tue, 22 Jun 2021 18:21:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIMydhH4YIk5UlsJLWeyye09J8NdqydLo549hleKoU/i5XuOd4xS2Z30zIrGFONsoACRmAyw==
X-Received: by 2002:a9d:c04:: with SMTP id 4mr5426545otr.245.1624411277887;
        Tue, 22 Jun 2021 18:21:17 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q18sm239916otf.72.2021.06.22.18.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 18:21:17 -0700 (PDT)
Date:   Tue, 22 Jun 2021 19:21:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: Allow mdev drivers to directly create the vfio_device (v4)
Message-ID: <20210622192115.71e7e333.alex.williamson@redhat.com>
In-Reply-To: <20210623000550.GI2371267@nvidia.com>
References: <20210617142218.1877096-1-hch@lst.de>
        <20210623000550.GI2371267@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 21:05:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 17, 2021 at 04:22:08PM +0200, Christoph Hellwig wrote:
> > This is my alternative take on this series from Jason:
> > 
> > https://lore.kernel.org/dri-devel/87czsszi9i.fsf@redhat.com/T/
> > 
> > The mdev/vfio parts are exactly the same, but this solves the driver core
> > changes for the direct probing without the in/out flag that Greg hated,
> > which cause a little more work, but probably make the result better.  
> 
> I did some testing and it looks good, thanks
> 
> I see Alex has this in hch-mdev-direct-v4 in linux-next now, so
> expecting this to be in the next merge window?

Yeah, sorry I didn't send out an "applied" note, end of the day
yesterday and forgot today.  My bad.  I expect this to go into v5.14
given the acks and Greg's deferral for the driver-core changes to go
through the vfio tree.  Speak now, or... Thanks,

Alex


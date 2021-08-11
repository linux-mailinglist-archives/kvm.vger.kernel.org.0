Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6393E9AB3
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 00:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhHKWJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 18:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232166AbhHKWI7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 18:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628719714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZIuQpOSakjR1F0O38drzzzVlj+CamxwCqQpO6BT/Y8=;
        b=C+oXDkCj8FB37WTeRKaYp94Nxfp5BA7R84EVc+HhO51mNax9TinPCrsSiIJ0wOFlLA1Mio
        oLTGaqJAniL1FzCVpTY8az5yd20QOjbgisdN3EsA6bsfMfIugknsrQeSXl7MDkSkzMTeTh
        crlNa1/X1G/SCk/qCHxVRv6K4wmiQbo=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-kPEQFAzhOdi-VWw4tAM1Pw-1; Wed, 11 Aug 2021 18:08:33 -0400
X-MC-Unique: kPEQFAzhOdi-VWw4tAM1Pw-1
Received: by mail-oi1-f199.google.com with SMTP id s29-20020a056808209db0290240ce72dd5eso1967416oiw.4
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 15:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZIuQpOSakjR1F0O38drzzzVlj+CamxwCqQpO6BT/Y8=;
        b=gum1JLesiYjUdue58y/fDm/oW7PFkSsKJEXj4E5Tzoxn6TP/ETdoo3Pi1C/PhVESRN
         APxNB7Ndl0yWomikFqeujlfaERCNKhIPaL+JWywz6S+GtcaB4SSt6VCM//+kkjfsZQIi
         y41S+xryYBvmRMI2XSJ8hjfJZRLeinB3Z6zjMy5ximx/xGHzi+JLtrQRpDAws3Fp1f1W
         9yyrQHFjxNHHAC1xEdvdYs5BS05TvOM/PD4pJDaV9WDSux4FBDKdKgFYZ67IIZUlrix3
         HkdPzDBc0ir/Lg2WzPpnEttRePg89Qja2ukLqEsXZSmXvg1RNClDUW6ZAGzX4FGQT4sY
         KzHA==
X-Gm-Message-State: AOAM530l2+MO79zdKY89KDkt7u9GPlEgg+4a3Hs/WOV5WgMXg9NmtRTZ
        M05nOJ9ohSqujBo1O92C8zeq6eKyyh+4IKosO9RpR68/KtQZdJ05ZdFuUjao58VpFPfSYSRTXwt
        /eImAT5x6NWHw
X-Received: by 2002:a05:6808:1807:: with SMTP id bh7mr818901oib.157.1628719712873;
        Wed, 11 Aug 2021 15:08:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHW0oiASQt39stuFDakeRHLwQGeA6uybDAE7Lm1gE17v8QC+IkptQlxOrOWXX4IHmLzUHZ9Q==
X-Received: by 2002:a05:6808:1807:: with SMTP id bh7mr818885oib.157.1628719712733;
        Wed, 11 Aug 2021 15:08:32 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w9sm119012ooe.15.2021.08.11.15.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 15:08:32 -0700 (PDT)
Date:   Wed, 11 Aug 2021 16:08:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v4 00/14] Provide core infrastructure for managing
 open/release
Message-ID: <20210811160830.0c17b085.alex.williamson@redhat.com>
In-Reply-To: <0-v4-9ea22c5e6afb+1adf-vfio_reflck_jgg@nvidia.com>
References: <0-v4-9ea22c5e6afb+1adf-vfio_reflck_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Aug 2021 22:18:56 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is in support of Max's series to split vfio-pci. For that to work the
> reflck concept embedded in vfio-pci needs to be sharable across all of the
> new VFIO PCI drivers which motivated re-examining how this is
> implemented.
> 
> Another significant issue is how the VFIO PCI core includes code like:
> 
>    if (pci_dev_driver(pdev) != &vfio_pci_driver)
> 
> Which is not scalable if there are going to be multiple different driver
> types.
> 
> This series takes the approach of moving the "reflck" mechanism into the
> core code as a "device set". Each vfio_device driver can specify how
> vfio_devices are grouped into the set using a key and the set comes along
> with a set-global mutex. The core code manages creating per-device set
> memory and associating it with each vfio_device.
> 
> In turn this allows the core code to provide an open/close_device()
> operation that is called only for the first/last FD, and is called under
> the global device set lock.
> 
> Review of all the drivers show that they are either already open coding
> the first/last semantic or are buggy and missing it. All drivers are
> migrated/fixed to the new open/close_device ops and the unused per-FD
> open()/release() ops are deleted.
> 
> The special behavior of PCI around the bus/slot "reset group" is recast in
> terms of the device set which conslidates the reflck, eliminates two
> touches of pci_dev_driver(), and allows the reset mechanism to share
> across all VFIO PCI drivers. PCI is changed to acquire devices directly
> from the device set instead of trying to work backwards from the struct
> pci_device.
> 
> Overall a few minor bugs are squashed and quite a bit of code is removed
> through consolidation.
> 
> v4:
>  - Fix use-after-free typo in mbochs error unwind
>  - Allow mdevs to work when they don't have open/release ops, for
>    bisect-ability
>  - Redo the vfio_pci_try_bus_reset() patch, make it dev_set centric
>  - Change VFIO_DEVICE_PCI_HOT_RESET to align with the new
>    vfio_pci_try_bus_reset() design

Applied to vfio next branch for v5.15 with Connie and Christoph's
additional Reviewed-bys.  Thanks,

Alex


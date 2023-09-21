Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995637A9991
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjIUSQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjIUSPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:15:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B533779E33
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMrLP3EdMK20MxEzCyyOc/FFAdpv+7+G+3025LP6tgo=;
        b=MgVyiDqkmF1ib5kwJ/lGqts/NHvhw9KzXbJuwMmh+ALb5Hp9QUNZedYK38fD2NwnMd4m6M
        xEqf+tCXlHbUpkgItZ1DFMlePU21EwXrWYeUzzWy8z7kNMtxVqmueVGAUcgEWXKIKZGxvW
        NHjJNsWkQ12BjgSo3qbdHbQyCeZETDU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-YgdOjo7QNjuyIwB8vywpeg-1; Thu, 21 Sep 2023 09:16:28 -0400
X-MC-Unique: YgdOjo7QNjuyIwB8vywpeg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bfe60dfbc3so11990541fa.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 06:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695302187; x=1695906987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMrLP3EdMK20MxEzCyyOc/FFAdpv+7+G+3025LP6tgo=;
        b=vJVhOqpnwPUei9ry4PLSazwXyWhx2zhkg5ue5A29/weR4P1rtn1eG+S4lJvfdxXUz8
         Kh6WUVtKnrVbONR7O0U3DO2KehB8oYpbiTxoVVg0QxDP5YHh7gykAY5aVHaUrzAwb6R0
         iS9+qJ54hiAUiq7VqQTbqeQTLicOSyyoz5o0GTos+gcB37owQw9+WsUod2aiXCJxJdCh
         XR4aHozTDxRUV3eoFztMfh3BUrbRy+eSl5EgaJyNsPiVfL3GdSCJv40fjbbfF9d3bHzS
         FPk6f0Lbik9f0M0geP82PSWE4aZEUykCiFxSp4UzgFZ9aoU4bAxHNXIBIESjvjRcNPxN
         BeMQ==
X-Gm-Message-State: AOJu0Yz822Qanr4NfytY6eYP10XkS8QuFqdfNk8++PlqErRDJlIs/MFu
        YHS24W2BikxCVJd/ZFqKUIvx2ZiJk0Pi5Dv4wY/m2mqKyoKwPDBxA+Tp+iAnywNK+qWrZOpAsSJ
        wkP+YQBC6ANqN
X-Received: by 2002:a2e:7808:0:b0:2bc:b6a3:5a9 with SMTP id t8-20020a2e7808000000b002bcb6a305a9mr4817710ljc.37.1695302187222;
        Thu, 21 Sep 2023 06:16:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeHong65EmWyH9vC8e5QQ/mKvYJR1RUZd7rLbip2eyBn/fsU5KhMYivpgffSPQfjWqcCK9Iw==
X-Received: by 2002:a2e:7808:0:b0:2bc:b6a3:5a9 with SMTP id t8-20020a2e7808000000b002bcb6a305a9mr4817688ljc.37.1695302186796;
        Thu, 21 Sep 2023 06:16:26 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061b1a00b0099bc08862b6sm1052811ejg.171.2023.09.21.06.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 06:16:25 -0700 (PDT)
Date:   Thu, 21 Sep 2023 09:16:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921090844-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-12-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>  MAINTAINERS                      |   6 +
>  drivers/vfio/pci/Kconfig         |   2 +
>  drivers/vfio/pci/Makefile        |   2 +
>  drivers/vfio/pci/virtio/Kconfig  |  15 +
>  drivers/vfio/pci/virtio/Makefile |   4 +
>  drivers/vfio/pci/virtio/cmd.c    |   4 +-
>  drivers/vfio/pci/virtio/cmd.h    |   8 +
>  drivers/vfio/pci/virtio/main.c   | 546 +++++++++++++++++++++++++++++++
>  8 files changed, 585 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/virtio/Kconfig
>  create mode 100644 drivers/vfio/pci/virtio/Makefile
>  create mode 100644 drivers/vfio/pci/virtio/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bf0f54c24f81..5098418c8389 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO VIRTIO PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/virtio
> +
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>

Tying two subsystems together like this is going to cause pain when
merging. God forbid there's something e.g. virtio net specific
(and there's going to be for sure) - now we are talking 3 subsystems.

Case in point all other virtio drivers are nicely grouped, have a common
mailing list etc etc.  This one is completely separate to the point
where people won't even remember to copy the virtio mailing list.


diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
new file mode 100644
index 000000000000..89eddce8b1bd
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VIRTIO_VFIO_PCI
+        tristate "VFIO support for VIRTIO PCI devices"
+        depends on VIRTIO_PCI
+        select VFIO_PCI_CORE
+        help
+          This provides support for exposing VIRTIO VF devices using the VFIO
+          framework that can work with a legacy virtio driver in the guest.
+          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
+          not indicate I/O Space.
+          As of that this driver emulated I/O BAR in software to let a VF be
+          seen as a transitional device in the guest and let it work with
+          a legacy driver.
+
+          If you don't know what to do here, say N.

I don't promise we'll remember to poke at vfio if we tweak something
in the virtio kconfig.

-- 
MST


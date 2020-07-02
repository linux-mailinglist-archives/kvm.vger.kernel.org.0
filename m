Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4321205A
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 11:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGBJvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 05:51:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727860AbgGBJvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 05:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593683499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHogEYB9LdYLmlRRtpVvkwg/X8GA9U3ZCoLaT+Iq1ZM=;
        b=dqLCsX2XQmNKa3UouoQDbSc/8q/P3+86X4r7CHKwlklHA8Vju+gc4hjhYRDrpPWqZdQ2LH
        C9yAzTKYDvrLvFW+wgCfRKJhR6/F9WZManhhJSmahtItzwf+C6vkxIDw6DCtB5pREKZC/p
        DoTuIi8yRBmVugLuZiVyG5eXjDjQzEg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-k7DNJl2mOZKVz0ItIvlfnQ-1; Thu, 02 Jul 2020 05:51:36 -0400
X-MC-Unique: k7DNJl2mOZKVz0ItIvlfnQ-1
Received: by mail-wr1-f71.google.com with SMTP id s16so11511442wrv.1
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 02:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bHogEYB9LdYLmlRRtpVvkwg/X8GA9U3ZCoLaT+Iq1ZM=;
        b=XwVQ+LHp28qEZiSfJ8/x8WCM3/pGze7M7KJ3yFHZhMQavPgJ86ZUqFC7MiFFldilsw
         p5q2eEottLejSbU4NdLz4NI5smt0r/8V8GReQS1Wk4kJsOhISZh2exjqMHr/Wn4h6MP1
         wW+zQ8PdmJGV+j5FAArRD15lZj8sr1VY9H5iOtUsH9d3cKU5zytpGH2CI8Ci2qFAA+St
         SsA8KgjZUyWX+/ZwbB5gIqjnkcW1LWbeo1mKSpXMbbRUxv46IrCCjL5q9BlaVtu/u2xc
         KS70J9sd8BRpM8OupaVYG/vCRxuJGZ1y/Lt7Eue7b+wMGNZoTg09ViM+XO6GZXT78U7b
         LC7Q==
X-Gm-Message-State: AOAM531PziUClDppXE5KQyhl0NgKHrILtMnuEtqdbmMuu0Ha1FWBCuY4
        bcX+F5Db1tPKRox/n0QqrB3SChZLviW2UZXuBRQiYnlC4ILNTiyeTCtGkBu0rUqmFc5FISm4c4u
        Fdada5D77U35j
X-Received: by 2002:a5d:6a01:: with SMTP id m1mr32647449wru.115.1593683494974;
        Thu, 02 Jul 2020 02:51:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXVWeInx8Is6mzpEdmO8KzqqisDChfcd/0ZxL7aKAX8BZJxTsoFC5nkJpDq8uHhK7haSamAg==
X-Received: by 2002:a5d:6a01:: with SMTP id m1mr32647426wru.115.1593683494694;
        Thu, 02 Jul 2020 02:51:34 -0700 (PDT)
Received: from redhat.com ([93.157.82.4])
        by smtp.gmail.com with ESMTPSA id 138sm4695866wmb.1.2020.07.02.02.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:51:33 -0700 (PDT)
Date:   Thu, 2 Jul 2020 05:51:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC
 communication
Message-ID: <20200702055026-mutt-send-email-mst@kernel.org>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 01:51:21PM +0530, Kishon Vijay Abraham I wrote:
> This series enhances Linux Vhost support to enable SoC-to-SoC
> communication over MMIO. This series enables rpmsg communication between
> two SoCs using both PCIe RC<->EP and HOST1-NTB-HOST2
> 
> 1) Modify vhost to use standard Linux driver model
> 2) Add support in vring to access virtqueue over MMIO
> 3) Add vhost client driver for rpmsg
> 4) Add PCIe RC driver (uses virtio) and PCIe EP driver (uses vhost) for
>    rpmsg communication between two SoCs connected to each other
> 5) Add NTB Virtio driver and NTB Vhost driver for rpmsg communication
>    between two SoCs connected via NTB
> 6) Add configfs to configure the components
> 
> UseCase1 :
> 
>  VHOST RPMSG                     VIRTIO RPMSG
>       +                               +
>       |                               |
>       |                               |
>       |                               |
>       |                               |
> +-----v------+                 +------v-------+
> |   Linux    |                 |     Linux    |
> |  Endpoint  |                 | Root Complex |
> |            <----------------->              |
> |            |                 |              |
> |    SOC1    |                 |     SOC2     |
> +------------+                 +--------------+
> 
> UseCase 2:
> 
>      VHOST RPMSG                                      VIRTIO RPMSG
>           +                                                 +
>           |                                                 |
>           |                                                 |
>           |                                                 |
>           |                                                 |
>    +------v------+                                   +------v------+
>    |             |                                   |             |
>    |    HOST1    |                                   |    HOST2    |
>    |             |                                   |             |
>    +------^------+                                   +------^------+
>           |                                                 |
>           |                                                 |
> +---------------------------------------------------------------------+
> |  +------v------+                                   +------v------+  |
> |  |             |                                   |             |  |
> |  |     EP      |                                   |     EP      |  |
> |  | CONTROLLER1 |                                   | CONTROLLER2 |  |
> |  |             <----------------------------------->             |  |
> |  |             |                                   |             |  |
> |  |             |                                   |             |  |
> |  |             |  SoC With Multiple EP Instances   |             |  |
> |  |             |  (Configured using NTB Function)  |             |  |
> |  +-------------+                                   +-------------+  |
> +---------------------------------------------------------------------+
> 
> Software Layering:
> 
> The high-level SW layering should look something like below. This series
> adds support only for RPMSG VHOST, however something similar should be
> done for net and scsi. With that any vhost device (PCI, NTB, Platform
> device, user) can use any of the vhost client driver.
> 
> 
>     +----------------+  +-----------+  +------------+  +----------+
>     |  RPMSG VHOST   |  | NET VHOST |  | SCSI VHOST |  |    X     |
>     +-------^--------+  +-----^-----+  +-----^------+  +----^-----+
>             |                 |              |              |
>             |                 |              |              |
>             |                 |              |              |
> +-----------v-----------------v--------------v--------------v----------+
> |                            VHOST CORE                                |
> +--------^---------------^--------------------^------------------^-----+
>          |               |                    |                  |
>          |               |                    |                  |
>          |               |                    |                  |
> +--------v-------+  +----v------+  +----------v----------+  +----v-----+
> |  PCI EPF VHOST |  | NTB VHOST |  |PLATFORM DEVICE VHOST|  |    X     |
> +----------------+  +-----------+  +---------------------+  +----------+
> 
> This was initially proposed here [1]
> 
> [1] -> https://lore.kernel.org/r/2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com


I find this very interesting. A huge patchset so will take a bit
to review, but I certainly plan to do that. Thanks!

> 
> Kishon Vijay Abraham I (22):
>   vhost: Make _feature_ bits a property of vhost device
>   vhost: Introduce standard Linux driver model in VHOST
>   vhost: Add ops for the VHOST driver to configure VHOST device
>   vringh: Add helpers to access vring in MMIO
>   vhost: Add MMIO helpers for operations on vhost virtqueue
>   vhost: Introduce configfs entry for configuring VHOST
>   virtio_pci: Use request_threaded_irq() instead of request_irq()
>   rpmsg: virtio_rpmsg_bus: Disable receive virtqueue callback when
>     reading messages
>   rpmsg: Introduce configfs entry for configuring rpmsg
>   rpmsg: virtio_rpmsg_bus: Add Address Service Notification support
>   rpmsg: virtio_rpmsg_bus: Move generic rpmsg structure to
>     rpmsg_internal.h
>   virtio: Add ops to allocate and free buffer
>   rpmsg: virtio_rpmsg_bus: Use virtio_alloc_buffer() and
>     virtio_free_buffer()
>   rpmsg: Add VHOST based remote processor messaging bus
>   samples/rpmsg: Setup delayed work to send message
>   samples/rpmsg: Wait for address to be bound to rpdev for sending
>     message
>   rpmsg.txt: Add Documentation to configure rpmsg using configfs
>   virtio_pci: Add VIRTIO driver for VHOST on Configurable PCIe Endpoint
>     device
>   PCI: endpoint: Add EP function driver to provide VHOST interface
>   NTB: Add a new NTB client driver to implement VIRTIO functionality
>   NTB: Add a new NTB client driver to implement VHOST functionality
>   NTB: Describe the ntb_virtio and ntb_vhost client in the documentation
> 
>  Documentation/driver-api/ntb.rst              |   11 +
>  Documentation/rpmsg.txt                       |   56 +
>  drivers/ntb/Kconfig                           |   18 +
>  drivers/ntb/Makefile                          |    2 +
>  drivers/ntb/ntb_vhost.c                       |  776 +++++++++++
>  drivers/ntb/ntb_virtio.c                      |  853 ++++++++++++
>  drivers/ntb/ntb_virtio.h                      |   56 +
>  drivers/pci/endpoint/functions/Kconfig        |   11 +
>  drivers/pci/endpoint/functions/Makefile       |    1 +
>  .../pci/endpoint/functions/pci-epf-vhost.c    | 1144 ++++++++++++++++
>  drivers/rpmsg/Kconfig                         |   10 +
>  drivers/rpmsg/Makefile                        |    3 +-
>  drivers/rpmsg/rpmsg_cfs.c                     |  394 ++++++
>  drivers/rpmsg/rpmsg_core.c                    |    7 +
>  drivers/rpmsg/rpmsg_internal.h                |  136 ++
>  drivers/rpmsg/vhost_rpmsg_bus.c               | 1151 +++++++++++++++++
>  drivers/rpmsg/virtio_rpmsg_bus.c              |  184 ++-
>  drivers/vhost/Kconfig                         |    1 +
>  drivers/vhost/Makefile                        |    2 +-
>  drivers/vhost/net.c                           |   10 +-
>  drivers/vhost/scsi.c                          |   24 +-
>  drivers/vhost/test.c                          |   17 +-
>  drivers/vhost/vdpa.c                          |    2 +-
>  drivers/vhost/vhost.c                         |  730 ++++++++++-
>  drivers/vhost/vhost_cfs.c                     |  341 +++++
>  drivers/vhost/vringh.c                        |  332 +++++
>  drivers/vhost/vsock.c                         |   20 +-
>  drivers/virtio/Kconfig                        |    9 +
>  drivers/virtio/Makefile                       |    1 +
>  drivers/virtio/virtio_pci_common.c            |   25 +-
>  drivers/virtio/virtio_pci_epf.c               |  670 ++++++++++
>  include/linux/mod_devicetable.h               |    6 +
>  include/linux/rpmsg.h                         |    6 +
>  {drivers/vhost => include/linux}/vhost.h      |  132 +-
>  include/linux/virtio.h                        |    3 +
>  include/linux/virtio_config.h                 |   42 +
>  include/linux/vringh.h                        |   46 +
>  samples/rpmsg/rpmsg_client_sample.c           |   32 +-
>  tools/virtio/virtio_test.c                    |    2 +-
>  39 files changed, 7083 insertions(+), 183 deletions(-)
>  create mode 100644 drivers/ntb/ntb_vhost.c
>  create mode 100644 drivers/ntb/ntb_virtio.c
>  create mode 100644 drivers/ntb/ntb_virtio.h
>  create mode 100644 drivers/pci/endpoint/functions/pci-epf-vhost.c
>  create mode 100644 drivers/rpmsg/rpmsg_cfs.c
>  create mode 100644 drivers/rpmsg/vhost_rpmsg_bus.c
>  create mode 100644 drivers/vhost/vhost_cfs.c
>  create mode 100644 drivers/virtio/virtio_pci_epf.c
>  rename {drivers/vhost => include/linux}/vhost.h (66%)
> 
> -- 
> 2.17.1
> 


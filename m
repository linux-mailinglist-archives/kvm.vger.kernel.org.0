Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961D050C3E8
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiDVW7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiDVW64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:58:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A39012A9746
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 15:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650666213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMFVJm9dtShNkP7cwazUzGzZbdvMU804Fbi6xRxrS+w=;
        b=DvDMTDHNl1CCLyKxF+9pVEQ7WRMrwgywzmtg7psN9tqxkWfQRO98RXFvCHgyf4vWyYMZ84
        Eca8l1noKu45nJoMAk30JDlkhJjU5Y4IiXRNLUz+MwV4hCm6FoHiZs92Bz45fbX2i2b//v
        YOp4oF1h3ulYHWLn1ypBsVHSnv6r7iI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-AxCC8RTjM3Sc2t3JN1Kvwg-1; Fri, 22 Apr 2022 18:09:46 -0400
X-MC-Unique: AxCC8RTjM3Sc2t3JN1Kvwg-1
Received: by mail-io1-f71.google.com with SMTP id o9-20020a0566022e0900b00654b599b1eeso6210202iow.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 15:09:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BMFVJm9dtShNkP7cwazUzGzZbdvMU804Fbi6xRxrS+w=;
        b=HaNKxx5nFMJcaWfAzRz7q3rBnB/kYvQHt7WXwu1KgbcMu/CS3xMZEDXbEcZNUtZMXo
         90BeyMzmmMLPVVllgUVRt7QNbwlJAWk6wdfgmMttWQgbV5eM127Vzp4z6SviW+tiDIkx
         w5ebXgHhMA3gigMGXU6N7/RmNrHfoOPhbKzbKSJ1SZ5e1Y85LUvd8OaBz/A+ZTuHJJrD
         Ldp5qraDu3/aSDRa/5qB7cNlCZXUzId82kAizWIa4AZXb05yAlItVVUS412ipKwSYuQc
         BuJhq48tkqWylMf9KQBgpNTl5GvWgHc3CD4upeUYu4Rxln7zNLN4he/7+vKARF6SEw1+
         Xnmg==
X-Gm-Message-State: AOAM532NMGNzvq2NMQXoqJrKL8hO8wiggqRILIDqaMQRLVUZ1krSe9Vg
        ysHNMTGPNOB1Hw1lvDehuy6wWWLH/L/cnPNUAh+GaCWC55NRcJEV0nU5mQocxWtoC0TA4RlXTqi
        lyoZJA3MRrpWS
X-Received: by 2002:a05:6602:2095:b0:654:a64a:2d4e with SMTP id a21-20020a056602209500b00654a64a2d4emr2830634ioa.214.1650665385981;
        Fri, 22 Apr 2022 15:09:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOdEbofQIQYXeHyO6sATYR/uwesFuNph/21hLkAIusCEY3uun5JOIHUuWOXCX8kp4ftxTjBQ==
X-Received: by 2002:a05:6602:2095:b0:654:a64a:2d4e with SMTP id a21-20020a056602209500b00654a64a2d4emr2830627ioa.214.1650665385729;
        Fri, 22 Apr 2022 15:09:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y21-20020a6bc415000000b00648da092c8esm2319383ioa.14.2022.04.22.15.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 15:09:45 -0700 (PDT)
Date:   Fri, 22 Apr 2022 16:09:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     cohuck@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220422160943.6ff4f330.alex.williamson@redhat.com>
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc +libvirt folks]

On Thu, 14 Apr 2022 03:46:52 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> With the introduction of iommufd[1], the linux kernel provides a generic
> interface for userspace drivers to propagate their DMA mappings to kernel
> for assigned devices. This series does the porting of the VFIO devices
> onto the /dev/iommu uapi and let it coexist with the legacy implementation.
> Other devices like vpda, vfio mdev and etc. are not considered yet.
> 
> For vfio devices, the new interface is tied with device fd and iommufd
> as the iommufd solution is device-centric. This is different from legacy
> vfio which is group-centric. To support both interfaces in QEMU, this
> series introduces the iommu backend concept in the form of different
> container classes. The existing vfio container is named legacy container
> (equivalent with legacy iommu backend in this series), while the new
> iommufd based container is named as iommufd container (may also be mentioned
> as iommufd backend in this series). The two backend types have their own
> way to setup secure context and dma management interface. Below diagram
> shows how it looks like with both BEs.
> 
>                     VFIO                           AddressSpace/Memory
>     +-------+  +----------+  +-----+  +-----+
>     |  pci  |  | platform |  |  ap |  | ccw |
>     +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
>         |           |           |        |        |   AddressSpace       |
>         |           |           |        |        +------------+---------+
>     +---V-----------V-----------V--------V----+               /
>     |           VFIOAddressSpace              | <------------+
>     |                  |                      |  MemoryListener
>     |          VFIOContainer list             |
>     +-------+----------------------------+----+
>             |                            |
>             |                            |
>     +-------V------+            +--------V----------+
>     |   iommufd    |            |    vfio legacy    |
>     |  container   |            |     container     |
>     +-------+------+            +--------+----------+
>             |                            |
>             | /dev/iommu                 | /dev/vfio/vfio
>             | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
>  Userspace  |                            |
>  ===========+============================+================================
>  Kernel     |  device fd                 |
>             +---------------+            | group/container fd
>             | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
>             |  ATTACH_IOAS) |            | device fd
>             |               |            |
>             |       +-------V------------V-----------------+
>     iommufd |       |                vfio                  |
> (map/unmap  |       +---------+--------------------+-------+
>  ioas_copy) |                 |                    | map/unmap
>             |                 |                    |
>      +------V------+    +-----V------+      +------V--------+
>      | iommfd core |    |  device    |      |  vfio iommu   |
>      +-------------+    +------------+      +---------------+
> 
> [Secure Context setup]
> - iommufd BE: uses device fd and iommufd to setup secure context
>               (bind_iommufd, attach_ioas)
> - vfio legacy BE: uses group fd and container fd to setup secure context
>                   (set_container, set_iommu)
> [Device access]
> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
> - vfio legacy BE: device fd is retrieved from group fd ioctl
> [DMA Mapping flow]
> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
> - VFIO populates DMA map/unmap via the container BEs
>   *) iommufd BE: uses iommufd
>   *) vfio legacy BE: uses container fd
> 
> This series qomifies the VFIOContainer object which acts as a base class
> for a container. This base class is derived into the legacy VFIO container
> and the new iommufd based container. The base class implements generic code
> such as code related to memory_listener and address space management whereas
> the derived class implements callbacks that depend on the kernel user space
> being used.
> 
> The selection of the backend is made on a device basis using the new
> iommufd option (on/off/auto). By default the iommufd backend is selected
> if supported by the host and by QEMU (iommufd KConfig). This option is
> currently available only for the vfio-pci device. For other types of
> devices, it does not yet exist and the legacy BE is chosen by default.

I've discussed this a bit with Eric, but let me propose a different
command line interface.  Libvirt generally likes to pass file
descriptors to QEMU rather than grant it access to those files
directly.  This was problematic with vfio-pci because libvirt can't
easily know when QEMU will want to grab another /dev/vfio/vfio
container.  Therefore we abandoned this approach and instead libvirt
grants file permissions.

However, with iommufd there's no reason that QEMU ever needs more than
a single instance of /dev/iommufd and we're using per device vfio file
descriptors, so it seems like a good time to revisit this.

The interface I was considering would be to add an iommufd object to
QEMU, so we might have a:

-device iommufd[,fd=#][,id=foo]

For non-libivrt usage this would have the ability to open /dev/iommufd
itself if an fd is not provided.  This object could be shared with
other iommufd users in the VM and maybe we'd allow multiple instances
for more esoteric use cases.  [NB, maybe this should be a -object rather than
-device since the iommufd is not a guest visible device?]

The vfio-pci device might then become:

-device vfio-pci[,host=DDDD:BB:DD.f][,sysfsdev=/sys/path/to/device][,fd=#][,iommufd=foo]

So essentially we can specify the device via host, sysfsdev, or passing
an fd to the vfio device file.  When an iommufd object is specified,
"foo" in the example above, each of those options would use the
vfio-device access mechanism, essentially the same as iommufd=on in
your example.  With the fd passing option, an iommufd object would be
required and necessarily use device level access.

In your example, the iommufd=auto seems especially troublesome for
libvirt because QEMU is going to have different locked memory
requirements based on whether we're using type1 or iommufd, where the
latter resolves the duplicate accounting issues.  libvirt needs to know
deterministically which backed is being used, which this proposal seems
to provide, while at the same time bringing us more in line with fd
passing.  Thoughts?  Thanks,

Alex


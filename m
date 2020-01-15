Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2359913C103
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 13:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgAOMar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 07:30:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726071AbgAOMaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 07:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579091446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLpGZItDdMCDJVkbunVBCSzJoxG7ezBzmb4FobfzGx0=;
        b=e/tLpKbK+VKp5rfJfGeyaFvHkl/UVkwZknWe5Omn/Fv92mI2fXnm8X+IcqQKsliqnfvETs
        5ZmOUseVuUzZR7CXkyp2I4Hp4mMjAJCNB4RyRtPwNktkorXskQWVuk0TXd0J+MPMskv2s6
        Cu6T1SUNGA2MNHyFL0jbiSGVLG1k0qU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-Gd-Bg1RRNcStF3gOUVVkeA-1; Wed, 15 Jan 2020 07:30:44 -0500
X-MC-Unique: Gd-Bg1RRNcStF3gOUVVkeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8787B8024CE;
        Wed, 15 Jan 2020 12:30:42 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32E225C219;
        Wed, 15 Jan 2020 12:30:30 +0000 (UTC)
Date:   Wed, 15 Jan 2020 13:30:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Message-ID: <20200115133027.228452fd.cohuck@redhat.com>
In-Reply-To: <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:48 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds sample driver named vfio-mdev-pci. It is to wrap
> a PCI device as a mediated device. For a pci device, once bound
> to vfio-mdev-pci driver, user space access of this device will
> go through vfio mdev framework. The usage of the device follows
> mdev management method. e.g. user should create a mdev before
> exposing the device to user-space.
> 
> Benefit of this new driver would be acting as a sample driver
> for recent changes from "vfio/mdev: IOMMU aware mediated device"
> patchset. Also it could be a good experiment driver for future
> device specific mdev migration support. This sample driver only
> supports singleton iommu groups, for non-singleton iommu groups,
> this sample driver doesn't work. It will fail when trying to assign
> the non-singleton iommu group to VMs.
> 
> To use this driver:
> a) build and load vfio-mdev-pci.ko module
>    execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
>    then load it with following command:
>    > sudo modprobe vfio
>    > sudo modprobe vfio-pci
>    > sudo insmod samples/vfio-mdev-pci/vfio-mdev-pci.ko  
> 
> b) unbind original device driver
>    e.g. use following command to unbind its original driver
>    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind  
> 
> c) bind vfio-mdev-pci driver to the physical device
>    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id  
> 
> d) check the supported mdev instances
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/  
>      vfio-mdev-pci-type_name
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\  
>      vfio-mdev-pci-type_name/
>      available_instances  create  device_api  devices  name
> 
> e)  create mdev on this physical device (only 1 instance)
>    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \  
>      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
>      vfio-mdev-pci-type_name/create
> 
> f) passthru the mdev to guest
>    add the following line in QEMU boot command
>     -device vfio-pci,\
>      sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003
> 
> g) destroy mdev
>    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/\  
>      remove

I think much/most of those instructions should go (additionally) into
the sample driver source. Otherwise, it's not clear to the reader why
they should wrap the device in mdev instead of simply using a normal
vfio-pci device.

> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  samples/Kconfig                       |  10 +
>  samples/Makefile                      |   1 +
>  samples/vfio-mdev-pci/Makefile        |   4 +
>  samples/vfio-mdev-pci/vfio_mdev_pci.c | 397 ++++++++++++++++++++++++++++++++++
>  4 files changed, 412 insertions(+)
>  create mode 100644 samples/vfio-mdev-pci/Makefile
>  create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c
> 
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 9d236c3..50d207c 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
>  	help
>  	  Build a sample program to work with mei device.
>  
> +config SAMPLE_VFIO_MDEV_PCI
> +	tristate "Sample driver for wrapping PCI device as a mdev"
> +	select VFIO_PCI_COMMON
> +	select VFIO_PCI

Why does this still need to select VFIO_PCI? Shouldn't all needed
infrastructure rather be covered by VFIO_PCI_COMMON already?

> +	depends on VFIO_MDEV && VFIO_MDEV_DEVICE

VFIO_MDEV_DEVICE already depends on VFIO_MDEV. But maybe also make this
depend on PCI?

> +	help
> +	  Sample driver for wrapping a PCI device as a mdev. Once bound to
> +	  this driver, device passthru should through mdev path.

"A PCI device bound to this driver will be assigned through the
mediated device framework."

?

> +
> +	  If you don't know what to do here, say N.
>  
>  endif # SAMPLES


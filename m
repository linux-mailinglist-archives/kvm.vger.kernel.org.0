Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34FD3EA821
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbhHLP5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238369AbhHLP5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 11:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B1E6103A;
        Thu, 12 Aug 2021 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628783828;
        bh=8GwFBGz58jJD2VYjjtxO4poe0sIxyPAvRkwfEKB1zek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ueaY50N/lQDLfwvuIeSxqrlAMo2nbgEeliWDW71YXu3IL0Bi4BKcBrFNwszVIJhFk
         0MyvrDI3A5ozU6czjasd7iqQHgVJhBEMgj0c9BPF8oAeOaF7avM1R2hAvJP6EzeEkY
         cGtN6BbAerWtt7NAvlhGtPcc7rAWg0Ey7F1auYtzrjCjVdJGKNITmr+acM6QbzA5F+
         xQRDIb0wwoWrja362PZZA3HM2IggaqnswD7nWT26vE02n95mUF7XfC7FKuvvNN84Tx
         ml0NUcsMoi56FB7A4QfOWlKjOUbS4OtDBS3UPGjVbQS5XvVlPy+/QvzKvaiI8WTnKW
         0Ay0XRMT57FkQ==
Date:   Thu, 12 Aug 2021 10:57:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210812155707.GA2464922@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812132728.GB8367@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:

> > Do the other bus types have a flag analogous to
> > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > other bus types, it'd be nice if the approach were similar.
> 
> They could, this series doesn't attempt it. I expect the approach to
> be similar as driver_override was copied from PCI to other
> busses. When this is completed I hope to take a look at it.

I think this would make more sense as two patches:

  - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
    since nothing in PCI depends on the VFIO-ness of drivers that use
    the flag.  The only point here is that driver id_table entries
    with this flag only match when driver_override matches the driver.

  - Update file2alias.c to export the flags and the "vfio_pci:" alias.
    This seems to be the only place where VFIO comes into play, and
    putting it in a separate patch will make it much smaller and it
    will be clear how it could be extended for other buses.

> > I assume somewhere in here you need to unbind mlx5_core before binding
> > mlx5_vfio_pci?
> 
> Er, yes, I skipped some steps here where unbind/bind has to be done
>  
> > >    6) cat the matched module name to driver_override:
> > >     echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> > 
> > Don't you need something here to trigger the driver attach, i.e.,
> > should step 5 and step 6 be swapped?  What if the driver is already
> > loaded? 
> 
> The full sequence is more like:
> 
>      echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
>      echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
>      echo 0000:01:00.0 > /sys/bus/pci/drivers_probe

Thanks a lot for this!  I didn't know about drivers_probe (see
drivers_probe_store()), and it doesn't seem to be documented anywhere
except sysfs-bus-usb, where it's only incidental to USB.

Bjorn

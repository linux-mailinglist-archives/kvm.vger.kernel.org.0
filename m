Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6497B3D3632
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 10:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhGWHbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 03:31:41 -0400
Received: from verein.lst.de ([213.95.11.211]:37547 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233619AbhGWHbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 03:31:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E2D7267373; Fri, 23 Jul 2021 10:12:08 +0200 (CEST)
Date:   Fri, 23 Jul 2021 10:12:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v2 10/14] vfio/pci: Reorganize
 VFIO_DEVICE_PCI_HOT_RESET to use the device set
Message-ID: <20210723081208.GE2795@lst.de>
References: <0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com> <10-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021 at 02:42:56PM -0300, Jason Gunthorpe wrote:
> Like vfio_pci_try_bus_reset() this code wants to reset all of the devices
> in the "reset group" which is the same membership as the device set.
> 
> Instead of trying to reconstruct the device set from the PCI list go
> directly from the device set's device list to execute the reset.
> 
> The same basic structure as vfio_pci_try_bus_reset() is used. The
> 'vfio_devices' struct is replaced with the device set linked list and we
> simply sweep it multiple times under the lock.
> 
> This eliminates a memory allocation and get/put traffic and another
> improperly locked test of pci_dev_driver().

Looks fine.  But oh gad is that locking scheme awful..

Signed-off-by: Christoph Hellwig <hch@lst.de>

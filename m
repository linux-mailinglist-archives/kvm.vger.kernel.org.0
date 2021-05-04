Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE7372AD6
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 15:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhEDNVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 09:21:34 -0400
Received: from 9.mo52.mail-out.ovh.net ([87.98.180.222]:45274 "EHLO
        9.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhEDNVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 09:21:33 -0400
X-Greylist: delayed 2991 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 09:21:33 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.44])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id D5D53271E7E;
        Tue,  4 May 2021 15:20:36 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 4 May 2021
 15:20:35 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G001561d069d-41f7-46fe-a360-76441386f8a7,
                    233BADB9E061AA125F593C9F78707CF28220F307) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 4 May 2021 15:20:34 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>, <linux-api@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <qemu-devel@nongnu.org>,
        <qemu-ppc@nongnu.org>
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504152034.18e41ec3@bahia.lan>
In-Reply-To: <YJFFG1tSP0dUCxcX@kroah.com>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210504142236.76994047@bahia.lan>
        <YJFFG1tSP0dUCxcX@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 5cc3bb94-3971-431f-b7fb-ec3b378d2bfe
X-Ovh-Tracer-Id: 5342395058935667073
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvdefiedgieehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefuddtieejjeevheekieeltefgleetkeetheettdeifeffvefhffelffdtfeeljeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehqvghmuhdqphhptgesnhhonhhgnhhurdhorhhg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 May 2021 14:59:07 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, May 04, 2021 at 02:22:36PM +0200, Greg Kurz wrote:
> > On Fri, 26 Mar 2021 07:13:09 +0100
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > Hi all,
> > > 
> > > the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> > > feature without any open source component - what would normally be
> > > the normal open source userspace that we require for kernel drivers,
> > > although in this particular case user space could of course be a
> > > kernel driver in a VM.  It also happens to be a complete mess that
> > > does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> > > and also pulles in over 1000 lines of code always build into powerpc
> > > kernels that have Power NV support enabled.  Because of all these
> > > issues and the lack of breaking userspace when it is removed I think
> > > the best idea is to simply kill.
> > > 
> > > Changes since v1:
> > >  - document the removed subtypes as reserved
> > >  - add the ACK from Greg
> > > 
> > > Diffstat:
> > >  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
> > >  b/arch/powerpc/include/asm/opal.h            |    3 
> > >  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
> > >  b/arch/powerpc/include/asm/pci.h             |    7 
> > >  b/arch/powerpc/platforms/powernv/Makefile    |    2 
> > >  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
> > >  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
> > >  b/arch/powerpc/platforms/powernv/pci.c       |   11 
> > >  b/arch/powerpc/platforms/powernv/pci.h       |   17 
> > >  b/arch/powerpc/platforms/pseries/pci.c       |   23 
> > >  b/drivers/vfio/pci/Kconfig                   |    6 
> > >  b/drivers/vfio/pci/Makefile                  |    1 
> > >  b/drivers/vfio/pci/vfio_pci.c                |   18 
> > >  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
> > >  b/include/uapi/linux/vfio.h                  |   38 -
> > 
> > 
> > Hi Christoph,
> > 
> > FYI, these uapi changes break build of QEMU.
> 
> What uapi changes?
> 

All macros and structure definitions that are being removed
from include/uapi/linux/vfio.h by patch 1.

> What exactly breaks?
> 

These macros and types are used by the current QEMU code base.
Next time the QEMU source tree updates its copy of the kernel
headers, the compilation of affected code will fail.

> Why does QEMU require kernel driver stuff?
> 

Not sure to understand the question... is there a problem
with QEMU using an already published uapi ?

> thanks,
> 
> greg k-h


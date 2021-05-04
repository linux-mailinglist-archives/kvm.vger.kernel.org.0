Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED0372E82
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhEDRLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:11:31 -0400
Received: from 5.mo52.mail-out.ovh.net ([188.165.45.220]:53904 "EHLO
        5.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhEDRLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:11:30 -0400
X-Greylist: delayed 16200 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 13:11:30 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.240])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id CD06B275188;
        Tue,  4 May 2021 14:22:40 +0200 (CEST)
Received: from kaod.org (37.59.142.101) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 4 May 2021
 14:22:38 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G0043eda4e7a-de7c-4853-8406-edae349cf2a7,
                    233BADB9E061AA125F593C9F78707CF28220F307) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 4 May 2021 14:22:36 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Christoph Hellwig <hch@lst.de>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-api@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <qemu-devel@nongnu.org>, <qemu-ppc@nongnu.org>
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504142236.76994047@bahia.lan>
In-Reply-To: <20210326061311.1497642-1-hch@lst.de>
References: <20210326061311.1497642-1-hch@lst.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG5EX1.mxp5.local (172.16.2.41) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 316f1bea-914e-41ab-a4e8-46202395b6d3
X-Ovh-Tracer-Id: 4363706565853223297
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvdefiedgheefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeeftdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeetgffffffggfekgeffteekhffhueelffdvhedvgfdthfeiudetvddulefgveevteenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepqhgvmhhuqdhpphgtsehnohhnghhnuhdrohhrgh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 07:13:09 +0100
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> feature without any open source component - what would normally be
> the normal open source userspace that we require for kernel drivers,
> although in this particular case user space could of course be a
> kernel driver in a VM.  It also happens to be a complete mess that
> does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> and also pulles in over 1000 lines of code always build into powerpc
> kernels that have Power NV support enabled.  Because of all these
> issues and the lack of breaking userspace when it is removed I think
> the best idea is to simply kill.
> 
> Changes since v1:
>  - document the removed subtypes as reserved
>  - add the ACK from Greg
> 
> Diffstat:
>  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
>  b/arch/powerpc/include/asm/opal.h            |    3 
>  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
>  b/arch/powerpc/include/asm/pci.h             |    7 
>  b/arch/powerpc/platforms/powernv/Makefile    |    2 
>  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
>  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
>  b/arch/powerpc/platforms/powernv/pci.c       |   11 
>  b/arch/powerpc/platforms/powernv/pci.h       |   17 
>  b/arch/powerpc/platforms/pseries/pci.c       |   23 
>  b/drivers/vfio/pci/Kconfig                   |    6 
>  b/drivers/vfio/pci/Makefile                  |    1 
>  b/drivers/vfio/pci/vfio_pci.c                |   18 
>  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
>  b/include/uapi/linux/vfio.h                  |   38 -


Hi Christoph,

FYI, these uapi changes break build of QEMU.

I guess QEMU people should take some action before this percolates
to the QEMU source tree.

Cc'ing relevant QEMU lists to bring the discussion there.

Cheers,

--
Greg

>  drivers/vfio/pci/vfio_pci_nvlink2.c          |  490 ------------------
>  16 files changed, 12 insertions(+), 1511 deletions(-)


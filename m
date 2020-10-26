Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3816E2992AF
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786296AbgJZQls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:41:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443055AbgJZQls (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 12:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603730506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M/tqspFSmF+gPBlrTEpacgX9p5uxhN64PpX+8nMn8ZU=;
        b=Z6RbnohcKCfSDnvG5Lp2iPdB0W6GbpBxptklQ274i9gcAtVwSx06wxDtG7nQQHe1cS7R8N
        mbb3XPbU9LJ8x0NL99bcDcK4v1tzbfVolbBB/VInr6quLhGIIeo+bMW+gIgV1J2X0tAkLD
        kFWRXJmGTO6SxwB2E+XYhoJZH6cCZJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-NPH41AsyO6mWNQDHoTPKEg-1; Mon, 26 Oct 2020 12:41:41 -0400
X-MC-Unique: NPH41AsyO6mWNQDHoTPKEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 752371868427;
        Mon, 26 Oct 2020 16:41:39 +0000 (UTC)
Received: from gondolin (ovpn-113-108.ams2.redhat.com [10.36.113.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D236F5D9F3;
        Mon, 26 Oct 2020 16:41:27 +0000 (UTC)
Date:   Mon, 26 Oct 2020 17:41:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, alex.williamson@redhat.com
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/13] s390x/pci: s390-pci updates for kernel 5.10-rc1
Message-ID: <20201026174124.1a662fa3.cohuck@redhat.com>
In-Reply-To: <20201026171947.0f302dcc.cohuck@redhat.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
        <20201026171947.0f302dcc.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Oct 2020 17:19:47 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, 26 Oct 2020 11:34:28 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > Combined set of patches that exploit vfio/s390-pci features available in
> > kernel 5.10-rc1.  This patch set is a combination of 
> > 
> > [PATCH v4 0/5] s390x/pci: Accomodate vfio DMA limiting
> > 
> > and
> > 
> > [PATCH v3 00/10] Retrieve zPCI hardware information from VFIO
> > 
> > with duplicate patches removed and a single header sync.  All patches have
> > prior maintainer reviews except for:
> > 
> > - Patch 1 (update-linux-headers change to add new file)   
> 
> That one has ;)
> 
> > - Patch 2 (header sync against 5.10-rc1)  
> 
> I'm still unsure about the rdma/(q)atomic stuff -- had we reached any
> conclusion there?
> 
> > - Patch 13 - contains a functional (debug) change; I switched from using
> >   DPRINTFs to using trace events per Connie's request.

Looks good.

I think that should go through the vfio tree, in case there are
collisions with the migration stuff?

(The s390x queue is currently empty.)

> > 
> > 
> > 
> > Matthew Rosato (10):
> >   update-linux-headers: Add vfio_zdev.h
> >   linux-headers: update against 5.10-rc1
> >   s390x/pci: Move header files to include/hw/s390x
> >   vfio: Create shared routine for scanning info capabilities
> >   vfio: Find DMA available capability
> >   s390x/pci: Add routine to get the vfio dma available count
> >   s390x/pci: Honor DMA limits set by vfio
> >   s390x/pci: clean up s390 PCI groups
> >   vfio: Add routine for finding VFIO_DEVICE_GET_INFO capabilities
> >   s390x/pci: get zPCI function info from host
> > 
> > Pierre Morel (3):
> >   s390x/pci: create a header dedicated to PCI CLP
> >   s390x/pci: use a PCI Group structure
> >   s390x/pci: use a PCI Function structure
> > 
> >  MAINTAINERS                                        |   1 +
> >  hw/s390x/meson.build                               |   1 +
> >  hw/s390x/s390-pci-bus.c                            |  91 ++++++-
> >  hw/s390x/s390-pci-inst.c                           |  78 ++++--
> >  hw/s390x/s390-pci-vfio.c                           | 276 +++++++++++++++++++++
> >  hw/s390x/s390-virtio-ccw.c                         |   2 +-
> >  hw/s390x/trace-events                              |   6 +
> >  hw/vfio/common.c                                   |  62 ++++-
> >  {hw => include/hw}/s390x/s390-pci-bus.h            |  22 ++
> >  .../hw/s390x/s390-pci-clp.h                        | 123 +--------
> >  include/hw/s390x/s390-pci-inst.h                   | 119 +++++++++
> >  include/hw/s390x/s390-pci-vfio.h                   |  23 ++
> >  include/hw/vfio/vfio-common.h                      |   4 +
> >  .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h |  14 +-
> >  .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h        |   2 +-
> >  include/standard-headers/linux/ethtool.h           |   2 +
> >  include/standard-headers/linux/fuse.h              |  50 +++-
> >  include/standard-headers/linux/input-event-codes.h |   4 +
> >  include/standard-headers/linux/pci_regs.h          |   6 +-
> >  include/standard-headers/linux/virtio_fs.h         |   3 +
> >  include/standard-headers/linux/virtio_gpu.h        |  19 ++
> >  include/standard-headers/linux/virtio_mmio.h       |  11 +
> >  include/standard-headers/linux/virtio_pci.h        |  11 +-
> >  linux-headers/asm-arm64/kvm.h                      |  25 ++
> >  linux-headers/asm-arm64/mman.h                     |   1 +
> >  linux-headers/asm-generic/hugetlb_encode.h         |   1 +
> >  linux-headers/asm-generic/unistd.h                 |  18 +-
> >  linux-headers/asm-mips/unistd_n32.h                |   1 +
> >  linux-headers/asm-mips/unistd_n64.h                |   1 +
> >  linux-headers/asm-mips/unistd_o32.h                |   1 +
> >  linux-headers/asm-powerpc/unistd_32.h              |   1 +
> >  linux-headers/asm-powerpc/unistd_64.h              |   1 +
> >  linux-headers/asm-s390/unistd_32.h                 |   1 +
> >  linux-headers/asm-s390/unistd_64.h                 |   1 +
> >  linux-headers/asm-x86/kvm.h                        |  20 ++
> >  linux-headers/asm-x86/unistd_32.h                  |   1 +
> >  linux-headers/asm-x86/unistd_64.h                  |   1 +
> >  linux-headers/asm-x86/unistd_x32.h                 |   1 +
> >  linux-headers/linux/kvm.h                          |  19 ++
> >  linux-headers/linux/mman.h                         |   1 +
> >  linux-headers/linux/vfio.h                         |  29 ++-
> >  linux-headers/linux/vfio_zdev.h                    |  78 ++++++
> >  scripts/update-linux-headers.sh                    |   2 +-
> >  43 files changed, 961 insertions(+), 173 deletions(-)
> >  create mode 100644 hw/s390x/s390-pci-vfio.c
> >  rename {hw => include/hw}/s390x/s390-pci-bus.h (94%)
> >  rename hw/s390x/s390-pci-inst.h => include/hw/s390x/s390-pci-clp.h (59%)
> >  create mode 100644 include/hw/s390x/s390-pci-inst.h
> >  create mode 100644 include/hw/s390x/s390-pci-vfio.h
> >  create mode 100644 linux-headers/linux/vfio_zdev.h
> >   
> 


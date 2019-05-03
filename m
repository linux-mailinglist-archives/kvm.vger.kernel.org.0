Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B6312B21
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 11:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfECJzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 05:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfECJzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 05:55:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D009368E3;
        Fri,  3 May 2019 09:55:18 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 796115C688;
        Fri,  3 May 2019 09:55:13 +0000 (UTC)
Date:   Fri, 3 May 2019 11:55:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 00/10] s390: virtio: support protected virtualization
Message-ID: <20190503115511.17a1f6d1.cohuck@redhat.com>
In-Reply-To: <20190426183245.37939-1-pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 03 May 2019 09:55:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Apr 2019 20:32:35 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> Enhanced virtualization protection technology may require the use of
> bounce buffers for I/O. While support for this was built into the virtio
> core, virtio-ccw wasn't changed accordingly.
> 
> Some background on technology (not part of this series) and the
> terminology used.
> 
> * Protected Virtualization (PV):
> 
> Protected Virtualization guarantees, that non-shared memory of a  guest
> that operates in PV mode private to that guest. I.e. any attempts by the
> hypervisor or other guests to access it will result in an exception. If
> supported by the environment (machine, KVM, guest VM) a guest can decide
> to change into PV mode by doing the appropriate ultravisor calls. Unlike
> some other enhanced virtualization protection technology, 

I think that sentence misses its second part?

> 
> * Ultravisor:
> 
> A hardware/firmware entity that manages PV guests, and polices access to
> their memory. A PV guest prospect needs to interact with the ultravisor,
> to enter PV mode, and potentially to share pages (for I/O which should
> be encrypted by the guest). A guest interacts with the ultravisor via so
> called ultravisor calls. A hypervisor needs to interact with the
> ultravisor to facilitate interpretation, emulation and swapping. A
> hypervisor  interacts with the ultravisor via ultravisor calls and via
> the SIE state description. Generally the ultravisor sanitizes hypervisor
> inputs so that the guest can not be corrupted (except for denial of
> service.
> 
> 
> What needs to be done
> =====================
> 
> Thus what needs to be done to bring virtio-ccw up to speed with respect
> to protected virtualization is:
> * use some 'new' common virtio stuff

Doing this makes sense regardless of the protected virtualization use
case, and I think we should go ahead and merge those patches for 5.2.

> * make sure that virtio-ccw specific stuff uses shared memory when
>   talking to the hypervisor (except control/communication blocks like ORB,
>   these are handled by the ultravisor)

TBH, I'm still a bit hazy on what needs to use shared memory and what
doesn't.

> * make sure the DMA API does what is necessary to talk through shared
>   memory if we are a protected virtualization guest.
> * make sure the common IO layer plays along as well (airqs, sense).
> 
> 
> Important notes
> ================
> 
> * This patch set is based on Martins features branch
>  (git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git branch
>  'features').
> 
> * Documentation is still very sketchy. I'm committed to improving this,
>   but I'm currently hampered by some dependencies currently.  

I understand, but I think this really needs more doc; also for people
who want to understand the code in the future.

Unfortunately lack of doc also hampers others in reviewing this :/

> 
> * The existing naming in the common infrastructure (kernel internal
>   interfaces) is pretty much based on the AMD SEV terminology. Thus the
>   names aren't always perfect. There might be merit to changing these
>   names to more abstract ones. I did not put much thought into that at
>   the current stage.
> 
> * Testing: Please use iommu_platform=on for any virtio devices you are
>   going to test this code with (so virtio actually uses the DMA API).
> 
> Change log
> ==========
> 
> RFC --> v1:
> * Fixed bugs found by Connie (may_reduce and handling reduced,  warning,
>   split move -- thanks Connie!).
> * Fixed console bug found by Sebastian (thanks Sebastian!).
> * Removed the completely useless duplicate of dma-mapping.h spotted by
>   Christoph (thanks Christoph!).
> * Don't use the global DMA pool for subchannel and ccw device
>   owned memory as requested by Sebastian. Consequences:
> 	* Both subchannel and ccw devices have their dma masks
> 	now (both specifying 31 bit addressable)
> 	* We require at least 2 DMA pages per ccw device now, most of
> 	this memory is wasted though.
> 	* DMA memory allocated by virtio is also 31 bit addressable now
>         as virtio uses the parent (which is the ccw device).
> * Enabled packed ring.
> * Rebased onto Martins feature branch; using the actual uv (ultravisor)
>   interface instead of TODO comments.
> * Added some explanations to the cover letter (Connie, David).
> * Squashed a couple of patches together and fixed some text stuff. 
> 
> Looking forward to your review, or any other type of input.
> 
> Halil Pasic (10):
>   virtio/s390: use vring_create_virtqueue
>   virtio/s390: DMA support for virtio-ccw
>   virtio/s390: enable packed ring
>   s390/mm: force swiotlb for protected virtualization
>   s390/cio: introduce DMA pools to cio
>   s390/cio: add basic protected virtualization support
>   s390/airq: use DMA memory for adapter interrupts
>   virtio/s390: add indirection to indicators access
>   virtio/s390: use DMA memory for ccw I/O and classic notifiers
>   virtio/s390: make airq summary indicators DMA
> 
>  arch/s390/Kconfig                   |   5 +
>  arch/s390/include/asm/airq.h        |   2 +
>  arch/s390/include/asm/ccwdev.h      |   4 +
>  arch/s390/include/asm/cio.h         |  11 ++
>  arch/s390/include/asm/mem_encrypt.h |  18 +++
>  arch/s390/mm/init.c                 |  50 +++++++
>  drivers/s390/cio/airq.c             |  18 ++-
>  drivers/s390/cio/ccwreq.c           |   8 +-
>  drivers/s390/cio/cio.h              |   1 +
>  drivers/s390/cio/css.c              | 101 +++++++++++++
>  drivers/s390/cio/device.c           |  65 +++++++--
>  drivers/s390/cio/device_fsm.c       |  40 +++---
>  drivers/s390/cio/device_id.c        |  18 +--
>  drivers/s390/cio/device_ops.c       |  21 ++-
>  drivers/s390/cio/device_pgid.c      |  20 +--
>  drivers/s390/cio/device_status.c    |  24 ++--
>  drivers/s390/cio/io_sch.h           |  21 ++-
>  drivers/s390/virtio/virtio_ccw.c    | 275 +++++++++++++++++++-----------------
>  include/linux/virtio.h              |  17 ---
>  19 files changed, 499 insertions(+), 220 deletions(-)
>  create mode 100644 arch/s390/include/asm/mem_encrypt.h
> 


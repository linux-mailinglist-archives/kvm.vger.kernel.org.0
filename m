Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB2632E2
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfGIIiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 04:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIIiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 04:38:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5423C05681F;
        Tue,  9 Jul 2019 08:37:59 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C99819C68;
        Tue,  9 Jul 2019 08:37:49 +0000 (UTC)
Subject: Re: [RFC v1 08/18] vfio/pci: add vfio bind/unbind_gpasid
 implementation
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-9-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <cac2a42e-c152-e715-451f-7a19ca3e19ca@redhat.com>
Date:   Tue, 9 Jul 2019 10:37:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1562324511-2910-9-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 09 Jul 2019 08:37:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu,

On 7/5/19 1:01 PM, Liu Yi L wrote:
> This patch adds vfio implementation PCIPASIDOps.bind_gpasid/unbind_pasid().
> These two functions are used to propagate guest pasid bind and unbind
> requests to host via vfio container ioctl.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/vfio/pci.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index ab184ad..892b46c 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2744,9 +2744,63 @@ static int vfio_pci_device_request_pasid_free(PCIBus *bus,
>      return ret;
>  }
>  
> +static void vfio_pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
> +                                     struct gpasid_bind_data *g_bind_data)
> +{
> +    PCIDevice *pdev = bus->devices[devfn];
> +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container = vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_bind *bind;
> +    struct vfio_iommu_type1_bind_guest_pasid *bind_guest_pasid;
> +    unsigned long argsz;
> +
> +    argsz = sizeof(*bind) + sizeof(*bind_guest_pasid);
> +    bind = g_malloc0(argsz);
> +    bind->argsz = argsz;
> +    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
> +    bind_guest_pasid = (struct vfio_iommu_type1_bind_guest_pasid *) &bind->data;
> +    bind_guest_pasid->bind_data = *g_bind_data;
> +
> +    rcu_read_lock();
why do you need the rcu_read_lock?
> +    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind) != 0) {
> +        error_report("vfio_pci_device_bind_gpasid:"
> +                     " bind failed, contanier: %p", container);
container
> +    }
> +    rcu_read_unlock();
> +    g_free(bind);
> +}
> +
> +static void vfio_pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
> +                                     struct gpasid_bind_data *g_bind_data)
> +{
> +    PCIDevice *pdev = bus->devices[devfn];
> +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container = vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_bind *bind;
> +    struct vfio_iommu_type1_bind_guest_pasid *bind_guest_pasid;
> +    unsigned long argsz;
> +
> +    argsz = sizeof(*bind) + sizeof(*bind_guest_pasid);
> +    bind = g_malloc0(argsz);
> +    bind->argsz = argsz;
> +    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
> +    bind_guest_pasid = (struct vfio_iommu_type1_bind_guest_pasid *) &bind->data;
> +    bind_guest_pasid->bind_data = *g_bind_data;
> +
> +    rcu_read_lock();
> +    if (ioctl(container->fd, VFIO_IOMMU_UNBIND, bind) != 0) {
> +        error_report("vfio_pci_device_unbind_gpasid:"
> +                     " unbind failed, contanier: %p", container);
container
> +    }
> +    rcu_read_unlock();
> +    g_free(bind);
> +}
> +
>  static PCIPASIDOps vfio_pci_pasid_ops = {
>      .alloc_pasid = vfio_pci_device_request_pasid_alloc,
>      .free_pasid = vfio_pci_device_request_pasid_free,
> +    .bind_gpasid = vfio_pci_device_bind_gpasid,
> +    .unbind_gpasid = vfio_pci_device_unbind_gpasid,
>  };
>  
>  static void vfio_realize(PCIDevice *pdev, Error **errp)
> 

Thanks

Eric

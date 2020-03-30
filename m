Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57245198264
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgC3Raz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:30:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25432 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727779AbgC3Raz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 13:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585589453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IV/RlnuWDyVAq/CY6VloTUUQJCsYYqNTqzlcq2lSUms=;
        b=V8CzqCWkeBI0ZL+DFqZFw+VBlrOKWqQwpiZPDTnldWAlt3qXXmXQDfK2kjzvq1EXf+wulZ
        LfnH9CZYKF1HjhS1fbYxxw+JX+macmGYhV45xMoKdRrHs7EaNn/5V641rrv3jagNYRQwpq
        1+DMVO7B8p5FQrl+sC6mlEyDUDhs4SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-BF3CDHVkMCuqbqSNNoh2sA-1; Mon, 30 Mar 2020 13:30:49 -0400
X-MC-Unique: BF3CDHVkMCuqbqSNNoh2sA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7246A1005516;
        Mon, 30 Mar 2020 17:30:47 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6387D5D9E2;
        Mon, 30 Mar 2020 17:30:31 +0000 (UTC)
Subject: Re: [PATCH v2 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-7-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <01381db5-6f5f-8022-6891-e1a8dd7c3e65@redhat.com>
Date:   Mon, 30 Mar 2020 19:30:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-7-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,
On 3/30/20 6:24 AM, Liu Yi L wrote:
> This patch adds pci_device_set/unset_iommu_context() to set/unset
> host_iommu_context for a given device. New callback is added in
> PCIIOMMUOps. As such, vIOMMU could make use of host IOMMU capability.
> e.g setup nested translation.

I think you need to explain what this practically is supposed to do.
such as: by attaching such context to a PCI device (for example VFIO
assigned?), you tell the host that this PCIe device is protected by a FL
stage controlled by the guest or something like that - if this is
correct understanding (?) -
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/pci/pci.c         | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
>  include/hw/pci/pci.h | 10 ++++++++++
>  2 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/pci/pci.c b/hw/pci/pci.c
> index aa9025c..af3c1a1 100644
> --- a/hw/pci/pci.c
> +++ b/hw/pci/pci.c
> @@ -2638,7 +2638,8 @@ static void pci_device_class_base_init(ObjectClass *klass, void *data)
>      }
>  }
>  
> -AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
> +static void pci_device_get_iommu_bus_devfn(PCIDevice *dev,
> +                              PCIBus **pbus, uint8_t *pdevfn)
>  {
>      PCIBus *bus = pci_get_bus(dev);
>      PCIBus *iommu_bus = bus;
> @@ -2683,14 +2684,52 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
>  
>          iommu_bus = parent_bus;
>      }
> -    if (iommu_bus && iommu_bus->iommu_ops &&
> -                     iommu_bus->iommu_ops->get_address_space) {
> -        return iommu_bus->iommu_ops->get_address_space(bus,
> -                                 iommu_bus->iommu_opaque, devfn);
> +    *pbus = iommu_bus;
> +    *pdevfn = devfn;
> +}
> +
> +AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
> +{
> +    PCIBus *bus;
> +    uint8_t devfn;
> +
> +    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
> +    if (bus && bus->iommu_ops &&
> +        bus->iommu_ops->get_address_space) {
> +        return bus->iommu_ops->get_address_space(bus,
> +                                bus->iommu_opaque, devfn);
>      }
>      return &address_space_memory;
>  }
>  
> +int pci_device_set_iommu_context(PCIDevice *dev,
> +                                 HostIOMMUContext *iommu_ctx)
> +{
> +    PCIBus *bus;
> +    uint8_t devfn;
> +
> +    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
> +    if (bus && bus->iommu_ops &&
> +        bus->iommu_ops->set_iommu_context) {
> +        return bus->iommu_ops->set_iommu_context(bus,
> +                              bus->iommu_opaque, devfn, iommu_ctx);
> +    }
> +    return -ENOENT;
> +}
> +
> +void pci_device_unset_iommu_context(PCIDevice *dev)
> +{
> +    PCIBus *bus;
> +    uint8_t devfn;
> +
> +    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
> +    if (bus && bus->iommu_ops &&
> +        bus->iommu_ops->unset_iommu_context) {
> +        bus->iommu_ops->unset_iommu_context(bus,
> +                                 bus->iommu_opaque, devfn);
> +    }
> +}
> +
>  void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
>  {
>      bus->iommu_ops = ops;
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index ffe192d..0ec5680 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -9,6 +9,8 @@
>  
>  #include "hw/pci/pcie.h"
>  
> +#include "hw/iommu/host_iommu_context.h"
> +
>  extern bool pci_available;
>  
>  /* PCI bus */
> @@ -489,9 +491,17 @@ typedef struct PCIIOMMUOps PCIIOMMUOps;
>  struct PCIIOMMUOps {
>      AddressSpace * (*get_address_space)(PCIBus *bus,
>                                  void *opaque, int32_t devfn);
> +    int (*set_iommu_context)(PCIBus *bus, void *opaque,
> +                             int32_t devfn,
> +                             HostIOMMUContext *iommu_ctx);
> +    void (*unset_iommu_context)(PCIBus *bus, void *opaque,
> +                                int32_t devfn);
>  };
>  
>  AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
> +int pci_device_set_iommu_context(PCIDevice *dev,
> +                                 HostIOMMUContext *iommu_ctx);
> +void pci_device_unset_iommu_context(PCIDevice *dev);
>  void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
>  
>  static inline void
> 
Thanks

Eric


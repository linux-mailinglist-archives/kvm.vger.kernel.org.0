Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25C632E3
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfGIIiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 04:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIIiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 04:38:00 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A1493084027;
        Tue,  9 Jul 2019 08:38:00 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99D055D9E5;
        Tue,  9 Jul 2019 08:37:46 +0000 (UTC)
Subject: Re: [RFC v1 07/18] hw/pci: add pci_device_bind/unbind_gpasid
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-8-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1dbeec81-8fa6-4e5c-fc62-4a999387bd12@redhat.com>
Date:   Tue, 9 Jul 2019 10:37:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1562324511-2910-8-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Jul 2019 08:38:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu,

On 7/5/19 1:01 PM, Liu Yi L wrote:
> This patch adds two callbacks pci_device_bind/unbind_gpasid() to
> PCIPASIDOps. These two callbacks are used to propagate guest pasid
> bind/unbind to host. The implementations of the callbacks would be
> device passthru modules like vfio.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/pci/pci.c         | 30 ++++++++++++++++++++++++++++++
>  include/hw/pci/pci.h |  9 +++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/hw/pci/pci.c b/hw/pci/pci.c
> index 710f9e9..2229229 100644
> --- a/hw/pci/pci.c
> +++ b/hw/pci/pci.c
> @@ -2676,6 +2676,36 @@ int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn,
>      return -1;
>  }
>  
> +void pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
> +                                struct gpasid_bind_data *g_bind_data)
struct gpasid_bind_data is defined in linux headers so I think you would
need: #ifdef __linux__
> +{
> +    PCIDevice *dev;
> +
> +    if (!bus) {
> +        return;
> +    }
> +
> +    dev = bus->devices[devfn];
> +    if (dev && dev->pasid_ops) {
> +        dev->pasid_ops->bind_gpasid(bus, devfn, g_bind_data);
> +    }
> +}
> +
> +void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
> +                                struct gpasid_bind_data *g_bind_data)
> +{
> +    PCIDevice *dev;
> +
> +    if (!bus) {
> +        return;
> +    }
> +
> +    dev = bus->devices[devfn];
> +    if (dev && dev->pasid_ops) {
> +        dev->pasid_ops->unbind_gpasid(bus, devfn, g_bind_data);
> +    }
> +}
> +
>  static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
>  {
>      Range *range = opaque;
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index 16e5b8e..8d849e6 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -9,6 +9,7 @@
>  #include "hw/isa/isa.h"
>  
>  #include "hw/pci/pcie.h"
> +#include <linux/iommu.h>
>  
>  extern bool pci_available;
>  
> @@ -267,6 +268,10 @@ struct PCIPASIDOps {
>      int (*alloc_pasid)(PCIBus *bus, int32_t devfn,
>                           uint32_t min_pasid, uint32_t max_pasid);
>      int (*free_pasid)(PCIBus *bus, int32_t devfn, uint32_t pasid);
> +    void (*bind_gpasid)(PCIBus *bus, int32_t devfn,
> +                            struct gpasid_bind_data *g_bind_data);
> +    void (*unbind_gpasid)(PCIBus *bus, int32_t devfn,
> +                            struct gpasid_bind_data *g_bind_data);
>  };
>  
>  struct PCIDevice {
> @@ -497,6 +502,10 @@ bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn);
>  int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
>                                     uint32_t min_pasid, uint32_t max_pasid);
>  int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn, uint32_t pasid);
> +void pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
> +                            struct gpasid_bind_data *g_bind_data);
> +void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
> +                            struct gpasid_bind_data *g_bind_data);
>  
>  static inline void
>  pci_set_byte(uint8_t *config, uint8_t val)
> 
Thanks

Eric

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC863476
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGIKlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 06:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfGIKlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 06:41:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1909A80F98;
        Tue,  9 Jul 2019 10:41:16 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65B7251961;
        Tue,  9 Jul 2019 10:41:05 +0000 (UTC)
Subject: Re: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
To:     Peter Xu <zhexu@redhat.com>, Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
 <20190709021209.GA5178@xz-x1>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <32346bb7-068e-1761-7973-eb9effc22fd9@redhat.com>
Date:   Tue, 9 Jul 2019 12:41:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190709021209.GA5178@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Jul 2019 10:41:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu, Peter,

On 7/9/19 4:12 AM, Peter Xu wrote:
> On Fri, Jul 05, 2019 at 07:01:36PM +0800, Liu Yi L wrote:
>> +void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops)
>> +{
>> +    assert(ops && !dev->pasid_ops);
>> +    dev->pasid_ops = ops;
>> +}
>> +
>> +bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn)
> 
> Name should be "pci_device_is_pasid_ops_set".  Or maybe you can simply
> drop this function because as long as you check it in helper functions
> like [1] below always then it seems even unecessary.

I think we need such query to know whether the PCI device needs to be
notified. This is somehow equivalent to the flags we had before but less
precise as we cannot query whether a specific callback is implemented.

Thanks

Eric
> 
>> +{
>> +    PCIDevice *dev;
>> +
>> +    if (!bus) {
>> +        return false;
>> +    }
>> +
>> +    dev = bus->devices[devfn];
>> +    return !!(dev && dev->pasid_ops);
>> +}
>> +
>> +int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
>> +                                   uint32_t min_pasid, uint32_t max_pasid)
> 
> From VT-d spec I see that the virtual command "allocate pasid" does
> not have bdf information so it's global, but here we've got bus/devfn.
> I'm curious is that reserved for ARM or some other arch?
> 
>> +{
>> +    PCIDevice *dev;
>> +
>> +    if (!bus) {
>> +        return -1;
>> +    }
>> +
>> +    dev = bus->devices[devfn];
>> +    if (dev && dev->pasid_ops && dev->pasid_ops->alloc_pasid) {
> 
> [1]
> 
>> +        return dev->pasid_ops->alloc_pasid(bus, devfn, min_pasid, max_pasid);
>> +    }
>> +    return -1;
>> +}
>> +
>> +int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn,
>> +                                  uint32_t pasid)
>> +{
>> +    PCIDevice *dev;
>> +
>> +    if (!bus) {
>> +        return -1;
>> +    }
>> +
>> +    dev = bus->devices[devfn];
>> +    if (dev && dev->pasid_ops && dev->pasid_ops->free_pasid) {
>> +        return dev->pasid_ops->free_pasid(bus, devfn, pasid);
>> +    }
>> +    return -1;
>> +}
>> +
>>  static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
>>  {
>>      Range *range = opaque;
>> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
>> index d082707..16e5b8e 100644
>> --- a/include/hw/pci/pci.h
>> +++ b/include/hw/pci/pci.h
>> @@ -262,6 +262,13 @@ struct PCIReqIDCache {
>>  };
>>  typedef struct PCIReqIDCache PCIReqIDCache;
>>  
>> +typedef struct PCIPASIDOps PCIPASIDOps;
>> +struct PCIPASIDOps {
>> +    int (*alloc_pasid)(PCIBus *bus, int32_t devfn,
>> +                         uint32_t min_pasid, uint32_t max_pasid);
>> +    int (*free_pasid)(PCIBus *bus, int32_t devfn, uint32_t pasid);
>> +};
>> +
>>  struct PCIDevice {
>>      DeviceState qdev;
>>  
>> @@ -351,6 +358,7 @@ struct PCIDevice {
>>      MSIVectorUseNotifier msix_vector_use_notifier;
>>      MSIVectorReleaseNotifier msix_vector_release_notifier;
>>      MSIVectorPollNotifier msix_vector_poll_notifier;
>> +    PCIPASIDOps *pasid_ops;
>>  };
>>  
>>  void pci_register_bar(PCIDevice *pci_dev, int region_num,
>> @@ -484,6 +492,12 @@ typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
>>  AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
>>  void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
>>  
>> +void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops);
>> +bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn);
>> +int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
>> +                                   uint32_t min_pasid, uint32_t max_pasid);
>> +int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn, uint32_t pasid);
>> +
>>  static inline void
>>  pci_set_byte(uint8_t *config, uint8_t val)
>>  {
>> -- 
>> 2.7.4
>>
> 
> Regards,
> 

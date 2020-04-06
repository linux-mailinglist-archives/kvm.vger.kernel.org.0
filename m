Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106F519F33A
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 12:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgDFKFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 06:05:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726784AbgDFKFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 06:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586167507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyM2Qwj0zqkdORYAMKc7kgI19vQcaraJziHfoxRInoE=;
        b=dLBh7xnYWPDIgS8i0ObZiS9IXReUspAPaYpF5VD9ith5+3MO07aqLC/k8+UFft6jTNH0gB
        e5FzoWWZ0mnrXBB7eOio87eTCF7dQ7xRHTlMkatbRONCloUqBsyDK4cXRuplWAywZeUqe1
        C8juML+CD4JYb0dXAy0xprp7J94sb2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-MQ7x1trIPZO9ge6bZ_mjKQ-1; Mon, 06 Apr 2020 06:05:03 -0400
X-MC-Unique: MQ7x1trIPZO9ge6bZ_mjKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72137800D5B;
        Mon,  6 Apr 2020 10:05:01 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1099D96B7B;
        Mon,  6 Apr 2020 10:04:46 +0000 (UTC)
Subject: Re: [PATCH v2 05/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Wu, Hao" <hao.wu@intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-6-git-send-email-yi.l.liu@intel.com>
 <d7185758-701e-03f0-b804-f71587d65e65@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21EDF9@SHSMSX104.ccr.corp.intel.com>
 <532069f1-123e-1ba0-cbd0-c849c2e0c5aa@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21F191@SHSMSX104.ccr.corp.intel.com>
 <a187b5cf-3693-0aa4-5cf9-4f5761885948@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A222F32@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <888fd3dc-c30a-0dae-8bc6-8fb4cfcd81c0@redhat.com>
Date:   Mon, 6 Apr 2020 12:04:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A222F32@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 4/6/20 8:27 AM, Liu, Yi L wrote:
> Hi Eric=EF=BC=8C
>=20
>> From: Auger Eric <eric.auger@redhat.com>
>> Sent: Thursday, April 2, 2020 9:49 PM
>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>> Subject: Re: [PATCH v2 05/22] hw/pci: modify pci_setup_iommu() to set
>> PCIIOMMUOps
>>
>> Hi Yi,
>>
>> On 4/2/20 3:37 PM, Liu, Yi L wrote:
>>> Hi Eric,
>>>
>>>> From: Auger Eric < eric.auger@redhat.com >
>>>> Sent: Thursday, April 2, 2020 8:41 PM
>>>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>>>> Subject: Re: [PATCH v2 05/22] hw/pci: modify pci_setup_iommu() to se=
t
>>>> PCIIOMMUOps
>>>>
>>>> Hi Yi,
>>>>
>>>> On 4/2/20 10:52 AM, Liu, Yi L wrote:
>>>>>> From: Auger Eric < eric.auger@redhat.com>
>>>>>> Sent: Monday, March 30, 2020 7:02 PM
>>>>>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>>>>>> Subject: Re: [PATCH v2 05/22] hw/pci: modify pci_setup_iommu() to
>>>>>> set PCIIOMMUOps
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 3/30/20 6:24 AM, Liu Yi L wrote:
>>>>>>> This patch modifies pci_setup_iommu() to set PCIIOMMUOps instead
>>>>>>> of setting PCIIOMMUFunc. PCIIOMMUFunc is used to get an address
>>>>>>> space for a PCI device in vendor specific way. The PCIIOMMUOps
>>>>>>> still offers this functionality. But using PCIIOMMUOps leaves
>>>>>>> space to add more iommu related vendor specific operations.
>>>>>>>
>>>>>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>>>>>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>> Cc: Eric Auger <eric.auger@redhat.com>
>>>>>>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>>>>>>> Cc: David Gibson <david@gibson.dropbear.id.au>
>>>>>>> Cc: Michael S. Tsirkin <mst@redhat.com>
>>>>>>> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
>>>>>>> Reviewed-by: Peter Xu <peterx@redhat.com>
>>>>>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>>>>>> ---
>>>>>>>  hw/alpha/typhoon.c       |  6 +++++-
>>>>>>>  hw/arm/smmu-common.c     |  6 +++++-
>>>>>>>  hw/hppa/dino.c           |  6 +++++-
>>>>>>>  hw/i386/amd_iommu.c      |  6 +++++-
>>>>>>>  hw/i386/intel_iommu.c    |  6 +++++-
>>>>>>>  hw/pci-host/designware.c |  6 +++++-
>>>>>>>  hw/pci-host/pnv_phb3.c   |  6 +++++-
>>>>>>>  hw/pci-host/pnv_phb4.c   |  6 +++++-
>>>>>>>  hw/pci-host/ppce500.c    |  6 +++++-
>>>>>>>  hw/pci-host/prep.c       |  6 +++++-
>>>>>>>  hw/pci-host/sabre.c      |  6 +++++-
>>>>>>>  hw/pci/pci.c             | 12 +++++++-----
>>>>>>>  hw/ppc/ppc440_pcix.c     |  6 +++++-
>>>>>>>  hw/ppc/spapr_pci.c       |  6 +++++-
>>>>>>>  hw/s390x/s390-pci-bus.c  |  8 ++++++--  hw/virtio/virtio-iommu.c
>>>>>>> |
>>>>>>> 6
>>>>>>> +++++-
>>>>>>>  include/hw/pci/pci.h     |  8 ++++++--
>>>>>>>  include/hw/pci/pci_bus.h |  2 +-
>>>>>>>  18 files changed, 90 insertions(+), 24 deletions(-)
>>>>>>>
>>>>>>> diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c index
>>>>>>> 1795e2f..f271de1 100644
>>>>>>> --- a/hw/alpha/typhoon.c
>>>>>>> +++ b/hw/alpha/typhoon.c
>>>>>>> @@ -740,6 +740,10 @@ static AddressSpace
>>>>>>> *typhoon_pci_dma_iommu(PCIBus
>>>>>> *bus, void *opaque, int devfn)
>>>>>>>      return &s->pchip.iommu_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps typhoon_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D typhoon_pci_dma_iommu, };
>>>>>>> +
>>>>>>>  static void typhoon_set_irq(void *opaque, int irq, int level)  {
>>>>>>>      TyphoonState *s =3D opaque;
>>>>>>> @@ -897,7 +901,7 @@ PCIBus *typhoon_init(MemoryRegion *ram, ISABu=
s
>>>>>> **isa_bus, qemu_irq *p_rtc_irq,
>>>>>>>                               "iommu-typhoon", UINT64_MAX);
>>>>>>>      address_space_init(&s->pchip.iommu_as, MEMORY_REGION(&s-
>>>>>>> pchip.iommu),
>>>>>>>                         "pchip0-pci");
>>>>>>> -    pci_setup_iommu(b, typhoon_pci_dma_iommu, s);
>>>>>>> +    pci_setup_iommu(b, &typhoon_iommu_ops, s);
>>>>>>>
>>>>>>>      /* Pchip0 PCI special/interrupt acknowledge, 0x801.F800.0000=
, 64MB.  */
>>>>>>>      memory_region_init_io(&s->pchip.reg_iack, OBJECT(s),
>>>>>>> &alpha_pci_iack_ops, diff --git a/hw/arm/smmu-common.c
>>>>>>> b/hw/arm/smmu-common.c index e13a5f4..447146e 100644
>>>>>>> --- a/hw/arm/smmu-common.c
>>>>>>> +++ b/hw/arm/smmu-common.c
>>>>>>> @@ -343,6 +343,10 @@ static AddressSpace *smmu_find_add_as(PCIBus
>>>>>>> *bus,
>>>>>> void *opaque, int devfn)
>>>>>>>      return &sdev->as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps smmu_ops =3D {
>>>>>>> +    .get_address_space =3D smmu_find_add_as, };
>>>>>>> +
>>>>>>>  IOMMUMemoryRegion *smmu_iommu_mr(SMMUState *s, uint32_t sid)  {
>>>>>>>      uint8_t bus_n, devfn;
>>>>>>> @@ -437,7 +441,7 @@ static void smmu_base_realize(DeviceState
>>>>>>> *dev, Error
>>>>>> **errp)
>>>>>>>      s->smmu_pcibus_by_busptr =3D g_hash_table_new(NULL, NULL);
>>>>>>>
>>>>>>>      if (s->primary_bus) {
>>>>>>> -        pci_setup_iommu(s->primary_bus, smmu_find_add_as, s);
>>>>>>> +        pci_setup_iommu(s->primary_bus, &smmu_ops, s);
>>>>>>>      } else {
>>>>>>>          error_setg(errp, "SMMU is not attached to any PCI bus!")=
;
>>>>>>>      }
>>>>>>> diff --git a/hw/hppa/dino.c b/hw/hppa/dino.c index
>>>>>>> 2b1b38c..3da4f84
>>>>>>> 100644
>>>>>>> --- a/hw/hppa/dino.c
>>>>>>> +++ b/hw/hppa/dino.c
>>>>>>> @@ -459,6 +459,10 @@ static AddressSpace
>>>>>>> *dino_pcihost_set_iommu(PCIBus
>>>>>> *bus, void *opaque,
>>>>>>>      return &s->bm_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps dino_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D dino_pcihost_set_iommu, };
>>>>>>> +
>>>>>>>  /*
>>>>>>>   * Dino interrupts are connected as shown on Page 78, Table 23
>>>>>>>   * (Little-endian bit numbers)
>>>>>>> @@ -580,7 +584,7 @@ PCIBus *dino_init(MemoryRegion *addr_space,
>>>>>>>      memory_region_add_subregion(&s->bm, 0xfff00000,
>>>>>>>                                  &s->bm_cpu_alias);
>>>>>>>      address_space_init(&s->bm_as, &s->bm, "pci-bm");
>>>>>>> -    pci_setup_iommu(b, dino_pcihost_set_iommu, s);
>>>>>>> +    pci_setup_iommu(b, &dino_iommu_ops, s);
>>>>>>>
>>>>>>>      *p_rtc_irq =3D qemu_allocate_irq(dino_set_timer_irq, s, 0);
>>>>>>>      *p_ser_irq =3D qemu_allocate_irq(dino_set_serial_irq, s, 0);
>>>>>>> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c index
>>>>>>> b1175e5..5fec30e 100644
>>>>>>> --- a/hw/i386/amd_iommu.c
>>>>>>> +++ b/hw/i386/amd_iommu.c
>>>>>>> @@ -1451,6 +1451,10 @@ static AddressSpace
>>>>>> *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>>>>>>>      return &iommu_as[devfn]->as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps amdvi_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D amdvi_host_dma_iommu, };
>>>>>>> +
>>>>>>>  static const MemoryRegionOps mmio_mem_ops =3D {
>>>>>>>      .read =3D amdvi_mmio_read,
>>>>>>>      .write =3D amdvi_mmio_write,
>>>>>>> @@ -1577,7 +1581,7 @@ static void amdvi_realize(DeviceState *dev,
>>>>>>> Error **errp)
>>>>>>>
>>>>>>>      sysbus_init_mmio(SYS_BUS_DEVICE(s), &s->mmio);
>>>>>>>      sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, AMDVI_BASE_ADDR);
>>>>>>> -    pci_setup_iommu(bus, amdvi_host_dma_iommu, s);
>>>>>>> +    pci_setup_iommu(bus, &amdvi_iommu_ops, s);
>>>>>>>      s->devid =3D object_property_get_int(OBJECT(&s->pci), "addr"=
, errp);
>>>>>>>      msi_init(&s->pci.dev, 0, 1, true, false, errp);
>>>>>>>      amdvi_init(s);
>>>>>>> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c index
>>>>>>> df7ad25..4b22910 100644
>>>>>>> --- a/hw/i386/intel_iommu.c
>>>>>>> +++ b/hw/i386/intel_iommu.c
>>>>>>> @@ -3729,6 +3729,10 @@ static AddressSpace
>>>>>>> *vtd_host_dma_iommu(PCIBus
>>>>>> *bus, void *opaque, int devfn)
>>>>>>>      return &vtd_as->as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static PCIIOMMUOps vtd_iommu_ops =3D {
>>>>>> static const
>>>>>
>>>>> got it.
>>>>>
>>>>>>> +    .get_address_space =3D vtd_host_dma_iommu, };
>>>>>>> +
>>>>>>>  static bool vtd_decide_config(IntelIOMMUState *s, Error **errp) =
 {
>>>>>>>      X86IOMMUState *x86_iommu =3D X86_IOMMU_DEVICE(s); @@ -3840,7
>>>>>>> +3844,7 @@ static void vtd_realize(DeviceState *dev, Error **errp=
)
>>>>>>>                                                g_free, g_free);
>>>>>>>      vtd_init(s);
>>>>>>>      sysbus_mmio_map(SYS_BUS_DEVICE(s), 0,
>>>>>> Q35_HOST_BRIDGE_IOMMU_ADDR);
>>>>>>> -    pci_setup_iommu(bus, vtd_host_dma_iommu, dev);
>>>>>>> +    pci_setup_iommu(bus, &vtd_iommu_ops, dev);
>>>>>>>      /* Pseudo address space under root PCI bus. */
>>>>>>>      x86ms->ioapic_as =3D vtd_host_dma_iommu(bus, s,
>>>>>> Q35_PSEUDO_DEVFN_IOAPIC);
>>>>>>>
>>>>>>> qemu_add_machine_init_done_notifier(&vtd_machine_done_notify);
>>>>>>> diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
>>>>>>> index dd24551..4c6338a 100644
>>>>>>> --- a/hw/pci-host/designware.c
>>>>>>> +++ b/hw/pci-host/designware.c
>>>>>>> @@ -645,6 +645,10 @@ static AddressSpace
>>>>>> *designware_pcie_host_set_iommu(PCIBus *bus, void *opaque,
>>>>>>>      return &s->pci.address_space;  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps designware_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D designware_pcie_host_set_iommu, };
>>>>>>> +
>>>>>>>  static void designware_pcie_host_realize(DeviceState *dev, Error
>>>>>>> **errp)  {
>>>>>>>      PCIHostState *pci =3D PCI_HOST_BRIDGE(dev); @@ -686,7 +690,7=
 @@
>>>>>>> static void designware_pcie_host_realize(DeviceState *dev, Error =
**errp)
>>>>>>>      address_space_init(&s->pci.address_space,
>>>>>>>                         &s->pci.address_space_root,
>>>>>>>                         "pcie-bus-address-space");
>>>>>>> -    pci_setup_iommu(pci->bus, designware_pcie_host_set_iommu, s)=
;
>>>>>>> +    pci_setup_iommu(pci->bus, &designware_iommu_ops, s);
>>>>>>>
>>>>>>>      qdev_set_parent_bus(DEVICE(&s->root), BUS(pci->bus));
>>>>>>>      qdev_init_nofail(DEVICE(&s->root));
>>>>>>> diff --git a/hw/pci-host/pnv_phb3.c b/hw/pci-host/pnv_phb3.c inde=
x
>>>>>>> 74618fa..ecfe627 100644
>>>>>>> --- a/hw/pci-host/pnv_phb3.c
>>>>>>> +++ b/hw/pci-host/pnv_phb3.c
>>>>>>> @@ -961,6 +961,10 @@ static AddressSpace
>>>>>>> *pnv_phb3_dma_iommu(PCIBus
>>>>>> *bus, void *opaque, int devfn)
>>>>>>>      return &ds->dma_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static PCIIOMMUOps pnv_phb3_iommu_ops =3D {
>>>>>> static const
>>>>> got it. :-)
>>>>>
>>>>>>> +    .get_address_space =3D pnv_phb3_dma_iommu, };
>>>>>>> +
>>>>>>>  static void pnv_phb3_instance_init(Object *obj)  {
>>>>>>>      PnvPHB3 *phb =3D PNV_PHB3(obj); @@ -1059,7 +1063,7 @@ static
>>>>>>> void pnv_phb3_realize(DeviceState *dev, Error
>>>>>> **errp)
>>>>>>>                                       &phb->pci_mmio, &phb->pci_i=
o,
>>>>>>>                                       0, 4,
>>>>>>> TYPE_PNV_PHB3_ROOT_BUS);
>>>>>>>
>>>>>>> -    pci_setup_iommu(pci->bus, pnv_phb3_dma_iommu, phb);
>>>>>>> +    pci_setup_iommu(pci->bus, &pnv_phb3_iommu_ops, phb);
>>>>>>>
>>>>>>>      /* Add a single Root port */
>>>>>>>      qdev_prop_set_uint8(DEVICE(&phb->root), "chassis",
>>>>>>> phb->chip_id); diff --git a/hw/pci-host/pnv_phb4.c
>>>>>>> b/hw/pci-host/pnv_phb4.c index
>>>>>>> 23cf093..04e95e3 100644
>>>>>>> --- a/hw/pci-host/pnv_phb4.c
>>>>>>> +++ b/hw/pci-host/pnv_phb4.c
>>>>>>> @@ -1148,6 +1148,10 @@ static AddressSpace
>>>>>>> *pnv_phb4_dma_iommu(PCIBus
>>>>>> *bus, void *opaque, int devfn)
>>>>>>>      return &ds->dma_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static PCIIOMMUOps pnv_phb4_iommu_ops =3D {
>>>>>> idem
>>>>> will add const.
>>>>>
>>>>>>> +    .get_address_space =3D pnv_phb4_dma_iommu, };
>>>>>>> +
>>>>>>>  static void pnv_phb4_instance_init(Object *obj)  {
>>>>>>>      PnvPHB4 *phb =3D PNV_PHB4(obj); @@ -1205,7 +1209,7 @@ static
>>>>>>> void pnv_phb4_realize(DeviceState *dev, Error
>>>>>> **errp)
>>>>>>>                                       pnv_phb4_set_irq, pnv_phb4_=
map_irq, phb,
>>>>>>>                                       &phb->pci_mmio, &phb->pci_i=
o,
>>>>>>>                                       0, 4, TYPE_PNV_PHB4_ROOT_BU=
S);
>>>>>>> -    pci_setup_iommu(pci->bus, pnv_phb4_dma_iommu, phb);
>>>>>>> +    pci_setup_iommu(pci->bus, &pnv_phb4_iommu_ops, phb);
>>>>>>>
>>>>>>>      /* Add a single Root port */
>>>>>>>      qdev_prop_set_uint8(DEVICE(&phb->root), "chassis",
>>>>>>> phb->chip_id); diff --git a/hw/pci-host/ppce500.c
>>>>>>> b/hw/pci-host/ppce500.c index d710727..5baf5db 100644
>>>>>>> --- a/hw/pci-host/ppce500.c
>>>>>>> +++ b/hw/pci-host/ppce500.c
>>>>>>> @@ -439,6 +439,10 @@ static AddressSpace
>>>>>>> *e500_pcihost_set_iommu(PCIBus
>>>>>> *bus, void *opaque,
>>>>>>>      return &s->bm_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps ppce500_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D e500_pcihost_set_iommu, };
>>>>>>> +
>>>>>>>  static void e500_pcihost_realize(DeviceState *dev, Error **errp)=
  {
>>>>>>>      SysBusDevice *sbd =3D SYS_BUS_DEVICE(dev); @@ -473,7 +477,7 =
@@
>>>>>>> static void e500_pcihost_realize(DeviceState *dev, Error **errp)
>>>>>>>      memory_region_init(&s->bm, OBJECT(s), "bm-e500", UINT64_MAX)=
;
>>>>>>>      memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
>>>>>>>      address_space_init(&s->bm_as, &s->bm, "pci-bm");
>>>>>>> -    pci_setup_iommu(b, e500_pcihost_set_iommu, s);
>>>>>>> +    pci_setup_iommu(b, &ppce500_iommu_ops, s);
>>>>>>>
>>>>>>>      pci_create_simple(b, 0, "e500-host-bridge");
>>>>>>>
>>>>>>> diff --git a/hw/pci-host/prep.c b/hw/pci-host/prep.c index
>>>>>>> 1a02e9a..7c57311 100644
>>>>>>> --- a/hw/pci-host/prep.c
>>>>>>> +++ b/hw/pci-host/prep.c
>>>>>>> @@ -213,6 +213,10 @@ static AddressSpace
>>>>>>> *raven_pcihost_set_iommu(PCIBus
>>>>>> *bus, void *opaque,
>>>>>>>      return &s->bm_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps raven_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D raven_pcihost_set_iommu, };
>>>>>>> +
>>>>>>>  static void raven_change_gpio(void *opaque, int n, int level)  {
>>>>>>>      PREPPCIState *s =3D opaque;
>>>>>>> @@ -303,7 +307,7 @@ static void raven_pcihost_initfn(Object *obj)
>>>>>>>      memory_region_add_subregion(&s->bm, 0         , &s-
>>>>> bm_pci_memory_alias);
>>>>>>>      memory_region_add_subregion(&s->bm, 0x80000000, &s-
>>> bm_ram_alias);
>>>>>>>      address_space_init(&s->bm_as, &s->bm, "raven-bm");
>>>>>>> -    pci_setup_iommu(&s->pci_bus, raven_pcihost_set_iommu, s);
>>>>>>> +    pci_setup_iommu(&s->pci_bus, &raven_iommu_ops, s);
>>>>>>>
>>>>>>>      h->bus =3D &s->pci_bus;
>>>>>>>
>>>>>>> diff --git a/hw/pci-host/sabre.c b/hw/pci-host/sabre.c index
>>>>>>> 2b8503b..251549b 100644
>>>>>>> --- a/hw/pci-host/sabre.c
>>>>>>> +++ b/hw/pci-host/sabre.c
>>>>>>> @@ -112,6 +112,10 @@ static AddressSpace
>>>>>>> *sabre_pci_dma_iommu(PCIBus
>>>>>> *bus, void *opaque, int devfn)
>>>>>>>      return &is->iommu_as;
>>>>>>>  }
>>>>>>>
>>>>>>> +static const PCIIOMMUOps sabre_iommu_ops =3D {
>>>>>>> +    .get_address_space =3D sabre_pci_dma_iommu, };
>>>>>>> +
>>>>>>>  static void sabre_config_write(void *opaque, hwaddr addr,
>>>>>>>                                 uint64_t val, unsigned size)  { @=
@
>>>>>>> -402,7 +406,7 @@ static void sabre_realize(DeviceState *dev, Erro=
r **errp)
>>>>>>>      /* IOMMU */
>>>>>>>      memory_region_add_subregion_overlap(&s->sabre_config, 0x200,
>>>>>>>                      sysbus_mmio_get_region(SYS_BUS_DEVICE(s->iom=
mu), 0), 1);
>>>>>>> -    pci_setup_iommu(phb->bus, sabre_pci_dma_iommu, s->iommu);
>>>>>>> +    pci_setup_iommu(phb->bus, &sabre_iommu_ops, s->iommu);
>>>>>>>
>>>>>>>      /* APB secondary busses */
>>>>>>>      pci_dev =3D pci_create_multifunction(phb->bus, PCI_DEVFN(1, =
0),
>>>>>>> true, diff --git a/hw/pci/pci.c b/hw/pci/pci.c index
>>>>>>> e1ed667..aa9025c
>>>>>>> 100644
>>>>>>> --- a/hw/pci/pci.c
>>>>>>> +++ b/hw/pci/pci.c
>>>>>>> @@ -2644,7 +2644,7 @@ AddressSpace
>>>>>> *pci_device_iommu_address_space(PCIDevice *dev)
>>>>>>>      PCIBus *iommu_bus =3D bus;
>>>>>>>      uint8_t devfn =3D dev->devfn;
>>>>>>>
>>>>>>> -    while (iommu_bus && !iommu_bus->iommu_fn && iommu_bus-
>>>>> parent_dev)
>>>>>> {
>>>>>>> +    while (iommu_bus && !iommu_bus->iommu_ops &&
>>>>>>> + iommu_bus->parent_dev) {
>>>>>> Depending on future usage, this is not strictly identical to the
>>>>>> original code. You exit the loop as soon as a iommu_bus->iommu_ops
>>>>>> is set whatever the presence of get_address_space().
>>>>>
>>>>> To be identical with original code, may adding the
>>>>> get_address_space() presence check. Then the loop exits when the
>>>>> iommu_bus->iommu_ops is set and meanwhile iommu_bus->iommu_ops-
>>> get_address_space() is set.
>>>>> But is it possible that there is an intermediate iommu_bus which ha=
s
>>>>> iommu_ops set but the get_address_space() is clear. I guess not as
>>>>> iommu_ops is set by vIOMMU and vIOMMU won't differentiate buses?
>>>>
>>>> I don't know. That depends on how the ops are going to be used in th=
e
>>>> future. Can't you enforce the fact that get_address_space() is a man=
datory ops?
>>>
>>> No, I didn't mean that. Actually, in the patch, the get_address_space=
() presence is
>> checked.
>>> I'm not sure if your point is to add get_address_space() presence
>>> check instead of just checking the iommu_ops presence.
>> Yes that was my point. I wanted to underline the checks are not strict=
ly identical
>> and maybe during enumeration you may find a device with ops set and no
>> get_address_space().
>=20
> I see. But this happens only when there are multiple iommu_ops instance=
s
> provided by vIOMMU. right? For some buses, vIOMMU set an iommu_ops
> with get_address_space() set, but for others it sets an iommu_ops w/o
> get_address_space(). Is it possible?
I don't think it is possible at the moment.
>=20
>> Then I meant maybe you should enforce somewhere in the
>> code or in the documentation that get_address_space() is a mandatory o=
peration in
>> the ops struct and must be set as soon as the struct is passed. maybe =
in
>> pci_setup_iommu() you could check that get_address_space is set?
>=20
> How about other callbacks in iommu_ops? It would be strange that only
> check get_address_space() and ignore other callbacks.
Well in the iommu_ops, the get_address_space() is supposed to be always
implemented, right? If this is the case, then you may check it when
passing the ops. Is that the case for other ops and especially the
set_iommu_ctx? To me, if an operation is mandated this should be
documented and maybe enforced.

Thanks

Eric
>=20
> Regards,
> Yi Liu
>=20


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3F2E64B1
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 18:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfJ0RsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 13:48:05 -0400
Received: from ozlabs.org ([203.11.71.1]:54783 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfJ0RsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 13:48:05 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 471QL96FJpz9sP3; Mon, 28 Oct 2019 04:48:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1572198481;
        bh=F5bFN2N/frUUnpwcXrQS5wC9FMCSNqJuA9ZWFUZabR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FBoApF2iUPtM0EcTMfsTvfIV1A6S/MpafNBgI28zoiuMUqo+nJ/1yoHyCWOXFQgs5
         1jvPyr+UQDyvPD/+Wy9QS9AjJJVBfEbTssW60tASrDxID+g2xQIPi22yzYL2p8sz8f
         Z3CqTLettpu9ySTTo+Klm3oBRQOk6f45dr1pxISU=
Date:   Sun, 27 Oct 2019 18:43:41 +0100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com,
        eric.auger@redhat.com, tianyu.lan@intel.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Message-ID: <20191027174341.GL3552@umbus.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5VuzLDXibKSJvVYD"
Content-Disposition: inline
In-Reply-To: <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5VuzLDXibKSJvVYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2019 at 08:34:27AM -0400, Liu Yi L wrote:
> This patch modifies pci_setup_iommu() to set PCIIOMMUOps instead of only
> setting PCIIOMMUFunc. PCIIOMMUFunc is previously used to get an address
> space for a device in vendor specific way. The PCIIOMMUOps still offers
> this functionality. Use PCIIOMMUOps leaves space to add more iommu related
> vendor specific operations.
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  hw/alpha/typhoon.c       |  6 +++++-
>  hw/arm/smmu-common.c     |  6 +++++-
>  hw/hppa/dino.c           |  6 +++++-
>  hw/i386/amd_iommu.c      |  6 +++++-
>  hw/i386/intel_iommu.c    |  6 +++++-
>  hw/pci-host/designware.c |  6 +++++-
>  hw/pci-host/ppce500.c    |  6 +++++-
>  hw/pci-host/prep.c       |  6 +++++-
>  hw/pci-host/sabre.c      |  6 +++++-
>  hw/pci/pci.c             | 11 ++++++-----
>  hw/ppc/ppc440_pcix.c     |  6 +++++-
>  hw/ppc/spapr_pci.c       |  6 +++++-
>  hw/s390x/s390-pci-bus.c  |  8 ++++++--
>  include/hw/pci/pci.h     |  8 ++++++--
>  include/hw/pci/pci_bus.h |  2 +-
>  15 files changed, 74 insertions(+), 21 deletions(-)
>=20
> diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c
> index 179e1f7..b890771 100644
> --- a/hw/alpha/typhoon.c
> +++ b/hw/alpha/typhoon.c
> @@ -741,6 +741,10 @@ static AddressSpace *typhoon_pci_dma_iommu(PCIBus *b=
us, void *opaque, int devfn)
>      return &s->pchip.iommu_as;
>  }
> =20
> +static const PCIIOMMUOps typhoon_iommu_ops =3D {
> +    .get_address_space =3D typhoon_pci_dma_iommu,
> +};
> +
>  static void typhoon_set_irq(void *opaque, int irq, int level)
>  {
>      TyphoonState *s =3D opaque;
> @@ -901,7 +905,7 @@ PCIBus *typhoon_init(ram_addr_t ram_size, ISABus **is=
a_bus,
>                               "iommu-typhoon", UINT64_MAX);
>      address_space_init(&s->pchip.iommu_as, MEMORY_REGION(&s->pchip.iommu=
),
>                         "pchip0-pci");
> -    pci_setup_iommu(b, typhoon_pci_dma_iommu, s);
> +    pci_setup_iommu(b, &typhoon_iommu_ops, s);
> =20
>      /* Pchip0 PCI special/interrupt acknowledge, 0x801.F800.0000, 64MB. =
 */
>      memory_region_init_io(&s->pchip.reg_iack, OBJECT(s), &alpha_pci_iack=
_ops,
> diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
> index 245817d..d668514 100644
> --- a/hw/arm/smmu-common.c
> +++ b/hw/arm/smmu-common.c
> @@ -342,6 +342,10 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, v=
oid *opaque, int devfn)
>      return &sdev->as;
>  }
> =20
> +static const PCIIOMMUOps smmu_ops =3D {
> +    .get_address_space =3D smmu_find_add_as,
> +};
> +
>  IOMMUMemoryRegion *smmu_iommu_mr(SMMUState *s, uint32_t sid)
>  {
>      uint8_t bus_n, devfn;
> @@ -436,7 +440,7 @@ static void smmu_base_realize(DeviceState *dev, Error=
 **errp)
>      s->smmu_pcibus_by_busptr =3D g_hash_table_new(NULL, NULL);
> =20
>      if (s->primary_bus) {
> -        pci_setup_iommu(s->primary_bus, smmu_find_add_as, s);
> +        pci_setup_iommu(s->primary_bus, &smmu_ops, s);
>      } else {
>          error_setg(errp, "SMMU is not attached to any PCI bus!");
>      }
> diff --git a/hw/hppa/dino.c b/hw/hppa/dino.c
> index ab6969b..dbcff03 100644
> --- a/hw/hppa/dino.c
> +++ b/hw/hppa/dino.c
> @@ -389,6 +389,10 @@ static AddressSpace *dino_pcihost_set_iommu(PCIBus *=
bus, void *opaque,
>      return &s->bm_as;
>  }
> =20
> +static const PCIIOMMUOps dino_iommu_ops =3D {
> +    .get_address_space =3D dino_pcihost_set_iommu,
> +};
> +
>  /*
>   * Dino interrupts are connected as shown on Page 78, Table 23
>   * (Little-endian bit numbers)
> @@ -508,7 +512,7 @@ PCIBus *dino_init(MemoryRegion *addr_space,
>      memory_region_add_subregion(&s->bm, 0xfff00000,
>                                  &s->bm_cpu_alias);
>      address_space_init(&s->bm_as, &s->bm, "pci-bm");
> -    pci_setup_iommu(b, dino_pcihost_set_iommu, s);
> +    pci_setup_iommu(b, &dino_iommu_ops, s);
> =20
>      *p_rtc_irq =3D qemu_allocate_irq(dino_set_timer_irq, s, 0);
>      *p_ser_irq =3D qemu_allocate_irq(dino_set_serial_irq, s, 0);
> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
> index d372636..ba6904c 100644
> --- a/hw/i386/amd_iommu.c
> +++ b/hw/i386/amd_iommu.c
> @@ -1451,6 +1451,10 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *=
bus, void *opaque, int devfn)
>      return &iommu_as[devfn]->as;
>  }
> =20
> +static const PCIIOMMUOps amdvi_iommu_ops =3D {
> +    .get_address_space =3D amdvi_host_dma_iommu,
> +};
> +
>  static const MemoryRegionOps mmio_mem_ops =3D {
>      .read =3D amdvi_mmio_read,
>      .write =3D amdvi_mmio_write,
> @@ -1576,7 +1580,7 @@ static void amdvi_realize(DeviceState *dev, Error *=
*err)
> =20
>      sysbus_init_mmio(SYS_BUS_DEVICE(s), &s->mmio);
>      sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, AMDVI_BASE_ADDR);
> -    pci_setup_iommu(bus, amdvi_host_dma_iommu, s);
> +    pci_setup_iommu(bus, &amdvi_iommu_ops, s);
>      s->devid =3D object_property_get_int(OBJECT(&s->pci), "addr", err);
>      msi_init(&s->pci.dev, 0, 1, true, false, err);
>      amdvi_init(s);
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 4a1a07a..67a7836 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3666,6 +3666,10 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bu=
s, void *opaque, int devfn)
>      return &vtd_as->as;
>  }
> =20
> +static PCIIOMMUOps vtd_iommu_ops =3D {
> +    .get_address_space =3D vtd_host_dma_iommu,
> +};
> +
>  static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>  {
>      X86IOMMUState *x86_iommu =3D X86_IOMMU_DEVICE(s);
> @@ -3782,7 +3786,7 @@ static void vtd_realize(DeviceState *dev, Error **e=
rrp)
>                                                g_free, g_free);
>      vtd_init(s);
>      sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
> -    pci_setup_iommu(bus, vtd_host_dma_iommu, dev);
> +    pci_setup_iommu(bus, &vtd_iommu_ops, dev);
>      /* Pseudo address space under root PCI bus. */
>      pcms->ioapic_as =3D vtd_host_dma_iommu(bus, s, Q35_PSEUDO_DEVFN_IOAP=
IC);
>      qemu_add_machine_init_done_notifier(&vtd_machine_done_notify);
> diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
> index 71e9b0d..235d6af 100644
> --- a/hw/pci-host/designware.c
> +++ b/hw/pci-host/designware.c
> @@ -645,6 +645,10 @@ static AddressSpace *designware_pcie_host_set_iommu(=
PCIBus *bus, void *opaque,
>      return &s->pci.address_space;
>  }
> =20
> +static const PCIIOMMUOps designware_iommu_ops =3D {
> +    .get_address_space =3D designware_pcie_host_set_iommu,
> +};
> +
>  static void designware_pcie_host_realize(DeviceState *dev, Error **errp)
>  {
>      PCIHostState *pci =3D PCI_HOST_BRIDGE(dev);
> @@ -686,7 +690,7 @@ static void designware_pcie_host_realize(DeviceState =
*dev, Error **errp)
>      address_space_init(&s->pci.address_space,
>                         &s->pci.address_space_root,
>                         "pcie-bus-address-space");
> -    pci_setup_iommu(pci->bus, designware_pcie_host_set_iommu, s);
> +    pci_setup_iommu(pci->bus, designware_iommu_ops, s);
> =20
>      qdev_set_parent_bus(DEVICE(&s->root), BUS(pci->bus));
>      qdev_init_nofail(DEVICE(&s->root));
> diff --git a/hw/pci-host/ppce500.c b/hw/pci-host/ppce500.c
> index 8bed8e8..0f907b0 100644
> --- a/hw/pci-host/ppce500.c
> +++ b/hw/pci-host/ppce500.c
> @@ -439,6 +439,10 @@ static AddressSpace *e500_pcihost_set_iommu(PCIBus *=
bus, void *opaque,
>      return &s->bm_as;
>  }
> =20
> +static const PCIIOMMUOps ppce500_iommu_ops =3D {
> +    .get_address_space =3D e500_pcihost_set_iommu,
> +};
> +
>  static void e500_pcihost_realize(DeviceState *dev, Error **errp)
>  {
>      SysBusDevice *sbd =3D SYS_BUS_DEVICE(dev);
> @@ -473,7 +477,7 @@ static void e500_pcihost_realize(DeviceState *dev, Er=
ror **errp)
>      memory_region_init(&s->bm, OBJECT(s), "bm-e500", UINT64_MAX);
>      memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
>      address_space_init(&s->bm_as, &s->bm, "pci-bm");
> -    pci_setup_iommu(b, e500_pcihost_set_iommu, s);
> +    pci_setup_iommu(b, &ppce500_iommu_ops, s);
> =20
>      pci_create_simple(b, 0, "e500-host-bridge");
> =20
> diff --git a/hw/pci-host/prep.c b/hw/pci-host/prep.c
> index 85d7ba9..f372524 100644
> --- a/hw/pci-host/prep.c
> +++ b/hw/pci-host/prep.c
> @@ -213,6 +213,10 @@ static AddressSpace *raven_pcihost_set_iommu(PCIBus =
*bus, void *opaque,
>      return &s->bm_as;
>  }
> =20
> +static const PCIIOMMU raven_iommu_ops =3D {
> +    .get_address_space =3D raven_pcihost_set_iommu,
> +};
> +
>  static void raven_change_gpio(void *opaque, int n, int level)
>  {
>      PREPPCIState *s =3D opaque;
> @@ -303,7 +307,7 @@ static void raven_pcihost_initfn(Object *obj)
>      memory_region_add_subregion(&s->bm, 0         , &s->bm_pci_memory_al=
ias);
>      memory_region_add_subregion(&s->bm, 0x80000000, &s->bm_ram_alias);
>      address_space_init(&s->bm_as, &s->bm, "raven-bm");
> -    pci_setup_iommu(&s->pci_bus, raven_pcihost_set_iommu, s);
> +    pci_setup_iommu(&s->pci_bus, &raven_iommu_ops, s);
> =20
>      h->bus =3D &s->pci_bus;
> =20
> diff --git a/hw/pci-host/sabre.c b/hw/pci-host/sabre.c
> index fae20ee..79b7565 100644
> --- a/hw/pci-host/sabre.c
> +++ b/hw/pci-host/sabre.c
> @@ -112,6 +112,10 @@ static AddressSpace *sabre_pci_dma_iommu(PCIBus *bus=
, void *opaque, int devfn)
>      return &is->iommu_as;
>  }
> =20
> +static const PCIIOMMUOps sabre_iommu_ops =3D {
> +    .get_address_space =3D sabre_pci_dma_iommu,
> +};
> +
>  static void sabre_config_write(void *opaque, hwaddr addr,
>                                 uint64_t val, unsigned size)
>  {
> @@ -402,7 +406,7 @@ static void sabre_realize(DeviceState *dev, Error **e=
rrp)
>      /* IOMMU */
>      memory_region_add_subregion_overlap(&s->sabre_config, 0x200,
>                      sysbus_mmio_get_region(SYS_BUS_DEVICE(s->iommu), 0),=
 1);
> -    pci_setup_iommu(phb->bus, sabre_pci_dma_iommu, s->iommu);
> +    pci_setup_iommu(phb->bus, &sabre_iommu_ops, s->iommu);
> =20
>      /* APB secondary busses */
>      pci_dev =3D pci_create_multifunction(phb->bus, PCI_DEVFN(1, 0), true,
> diff --git a/hw/pci/pci.c b/hw/pci/pci.c
> index aa05c2b..b5ce9ca 100644
> --- a/hw/pci/pci.c
> +++ b/hw/pci/pci.c
> @@ -2615,18 +2615,19 @@ AddressSpace *pci_device_iommu_address_space(PCID=
evice *dev)
>      PCIBus *bus =3D pci_get_bus(dev);
>      PCIBus *iommu_bus =3D bus;
> =20
> -    while(iommu_bus && !iommu_bus->iommu_fn && iommu_bus->parent_dev) {
> +    while (iommu_bus && !iommu_bus->iommu_ops && iommu_bus->parent_dev) {
>          iommu_bus =3D pci_get_bus(iommu_bus->parent_dev);
>      }
> -    if (iommu_bus && iommu_bus->iommu_fn) {
> -        return iommu_bus->iommu_fn(bus, iommu_bus->iommu_opaque, dev->de=
vfn);
> +    if (iommu_bus && iommu_bus->iommu_ops) {
> +        return iommu_bus->iommu_ops->get_address_space(bus,
> +                           iommu_bus->iommu_opaque, dev->devfn);
>      }
>      return &address_space_memory;
>  }
> =20
> -void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque)
> +void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
>  {
> -    bus->iommu_fn =3D fn;
> +    bus->iommu_ops =3D ops;
>      bus->iommu_opaque =3D opaque;
>  }
> =20
> diff --git a/hw/ppc/ppc440_pcix.c b/hw/ppc/ppc440_pcix.c
> index 2ee2d4f..2c8579c 100644
> --- a/hw/ppc/ppc440_pcix.c
> +++ b/hw/ppc/ppc440_pcix.c
> @@ -442,6 +442,10 @@ static AddressSpace *ppc440_pcix_set_iommu(PCIBus *b=
, void *opaque, int devfn)
>      return &s->bm_as;
>  }
> =20
> +static const PCIIOMMUOps ppc440_iommu_ops =3D {
> +    .get_adress_space =3D ppc440_pcix_set_iommu,
> +};
> +
>  /* The default pci_host_data_{read,write} functions in pci/pci_host.c
>   * deny access to registers without bit 31 set but our clients want
>   * this to work so we have to override these here */
> @@ -487,7 +491,7 @@ static void ppc440_pcix_realize(DeviceState *dev, Err=
or **errp)
>      memory_region_init(&s->bm, OBJECT(s), "bm-ppc440-pcix", UINT64_MAX);
>      memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
>      address_space_init(&s->bm_as, &s->bm, "pci-bm");
> -    pci_setup_iommu(h->bus, ppc440_pcix_set_iommu, s);
> +    pci_setup_iommu(h->bus, &ppc440_iommu_ops, s);
> =20
>      memory_region_init(&s->container, OBJECT(s), "pci-container", PCI_AL=
L_SIZE);
>      memory_region_init_io(&h->conf_mem, OBJECT(s), &pci_host_conf_le_ops,
> diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
> index 01ff41d..83cd857 100644
> --- a/hw/ppc/spapr_pci.c
> +++ b/hw/ppc/spapr_pci.c
> @@ -771,6 +771,10 @@ static AddressSpace *spapr_pci_dma_iommu(PCIBus *bus=
, void *opaque, int devfn)
>      return &phb->iommu_as;
>  }
> =20
> +static const PCIIOMMUOps spapr_iommu_ops =3D {
> +    .get_address_space =3D spapr_pci_dma_iommu,
> +};
> +
>  static char *spapr_phb_vfio_get_loc_code(SpaprPhbState *sphb,  PCIDevice=
 *pdev)
>  {
>      char *path =3D NULL, *buf =3D NULL, *host =3D NULL;
> @@ -1950,7 +1954,7 @@ static void spapr_phb_realize(DeviceState *dev, Err=
or **errp)
>      memory_region_add_subregion(&sphb->iommu_root, SPAPR_PCI_MSI_WINDOW,
>                                  &sphb->msiwindow);
> =20
> -    pci_setup_iommu(bus, spapr_pci_dma_iommu, sphb);
> +    pci_setup_iommu(bus, &spapr_iommu_ops, sphb);
> =20
>      pci_bus_set_route_irq_fn(bus, spapr_route_intx_pin_to_irq);
> =20
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 2d2f4a7..14684a0 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -635,6 +635,10 @@ static AddressSpace *s390_pci_dma_iommu(PCIBus *bus,=
 void *opaque, int devfn)
>      return &iommu->as;
>  }
> =20
> +static const PCIIOMMUOps s390_iommu_ops =3D {
> +    .get_address_space =3D s390_pci_dma_iommu,
> +};
> +
>  static uint8_t set_ind_atomic(uint64_t ind_loc, uint8_t to_be_set)
>  {
>      uint8_t ind_old, ind_new;
> @@ -748,7 +752,7 @@ static void s390_pcihost_realize(DeviceState *dev, Er=
ror **errp)
>      b =3D pci_register_root_bus(dev, NULL, s390_pci_set_irq, s390_pci_ma=
p_irq,
>                                NULL, get_system_memory(), get_system_io()=
, 0,
>                                64, TYPE_PCI_BUS);
> -    pci_setup_iommu(b, s390_pci_dma_iommu, s);
> +    pci_setup_iommu(b, &s390_iommu_ops, s);
> =20
>      bus =3D BUS(b);
>      qbus_set_hotplug_handler(bus, OBJECT(dev), &local_err);
> @@ -919,7 +923,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug=
_dev, DeviceState *dev,
> =20
>          pdev =3D PCI_DEVICE(dev);
>          pci_bridge_map_irq(pb, dev->id, s390_pci_map_irq);
> -        pci_setup_iommu(&pb->sec_bus, s390_pci_dma_iommu, s);
> +        pci_setup_iommu(&pb->sec_bus, &s390_iommu_ops, s);
> =20
>          qbus_set_hotplug_handler(BUS(&pb->sec_bus), OBJECT(s), errp);
> =20
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index f3f0ffd..d9fed8d 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -480,10 +480,14 @@ void pci_bus_get_w64_range(PCIBus *bus, Range *rang=
e);
> =20
>  void pci_device_deassert_intx(PCIDevice *dev);
> =20
> -typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
> +typedef struct PCIIOMMUOps PCIIOMMUOps;
> +struct PCIIOMMUOps {
> +    AddressSpace * (*get_address_space)(PCIBus *bus,
> +                                void *opaque, int32_t devfn);
> +};
> =20
>  AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
> -void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
> +void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *op=
aque);
> =20
>  static inline void
>  pci_set_byte(uint8_t *config, uint8_t val)
> diff --git a/include/hw/pci/pci_bus.h b/include/hw/pci/pci_bus.h
> index 0714f57..c281057 100644
> --- a/include/hw/pci/pci_bus.h
> +++ b/include/hw/pci/pci_bus.h
> @@ -29,7 +29,7 @@ enum PCIBusFlags {
>  struct PCIBus {
>      BusState qbus;
>      enum PCIBusFlags flags;
> -    PCIIOMMUFunc iommu_fn;
> +    const PCIIOMMUOps *iommu_ops;
>      void *iommu_opaque;
>      uint8_t devfn_min;
>      uint32_t slot_reserved_mask;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5VuzLDXibKSJvVYD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl21100ACgkQbDjKyiDZ
s5IYHhAAzVnCJGi2fi6Djz9/LI9bRLavUN7BlYj+5lf2OST7+U2dvVvbrGQOiq1M
If4aK4nu8S0vdOa1SOTjth1sA/MkA3GcdkwjGya3m7vS5v5m8acopC6adYrfAf3Q
xhnyh9oBxJwMYOvJ3PlnbdVjYika/a6TosF1pTiS4MzRkIqMAhLFSkFA3DAqVASA
aIctrdLpnfDFZnI6rb4W++DPwZrEOeTSNiNlCcSly8r/LwzlFCdq81Hc9v6/elV4
b6J3/hNGGAzlVB2MYmHDOy3BKuYHP2O2V12WKyHx+3CxGVJgEct9BCgzxvGBEsmC
70ni1tvCYCHDU8pQzADs6VelzSbm/rUAheQij/cClc0sNT05d5teEMdOpVoB5tfB
8SBbiSUr2vrikmXVVjCMvo/UtVptE52N04the2hRnJX55vcOg37E0yuVkPb5y5yO
Yjq3RWoMvUQYBdDnu5F5inG5sSohWL9dS8EFs1ggmK4Q9uKLPsCwXyxC1e6k+lMX
tZJA34dkzhk9isJopNVRxXPh9feGZVZEgqqJe7RfsBoAn5L2XbrTpzW3c/r1hHRE
/K9NH9FEbFr6FZA6BeaTc0LRLjOJJlxN6j6oo7B+F6Ga2Nvz9rjS7jWUd+HN2fe3
yAk2SXTPZpp2Tp/0OJ57WsduqnWwhAOc7h5d6sLYriDn/ZH8a0Q=
=4t67
-----END PGP SIGNATURE-----

--5VuzLDXibKSJvVYD--

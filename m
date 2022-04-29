Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A130851429A
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 08:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354743AbiD2Grm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 02:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354571AbiD2Grc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 02:47:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97DEBB092
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 23:44:11 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KqNHt0Dqkz4xLS; Fri, 29 Apr 2022 16:44:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651214650;
        bh=jdZCCvm/D2lN2xMUkW2nwHB7qatPOiO7aW2a75bvGrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2NsG9lGuvGJiz7ritkMd12oi4uEejtMdwJOBmzGXYsCvB4ZB70mmk5Kn2eTxvNHU
         ffFHi2MhjeWUjsURe+qo8d+Gu2KxLB7R88RJjE3UDuSmaG5Wp7OESOfYtXgrg7Ei9K
         H5X9ymC4orM84aZMA660p2wP5I8HhmiAp1yQsngc=
Date:   Fri, 29 Apr 2022 16:29:19 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, thuth@redhat.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, jjherne@linux.ibm.com, jasowang@redhat.com,
        kvm@vger.kernel.org, jgg@nvidia.com, nicolinc@nvidia.com,
        eric.auger@redhat.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com
Subject: Re: [RFC 07/18] vfio: Add base object for VFIOContainer
Message-ID: <YmuFv2s5TPuw7K/u@yekko>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-8-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fJm8ENns1FerTi3R"
Content-Disposition: inline
In-Reply-To: <20220414104710.28534-8-yi.l.liu@intel.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fJm8ENns1FerTi3R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 14, 2022 at 03:46:59AM -0700, Yi Liu wrote:
> Qomify the VFIOContainer object which acts as a base class for a
> container. This base class is derived into the legacy VFIO container
> and later on, into the new iommufd based container.

You certainly need the abstraction, but I'm not sure QOM is the right
way to accomplish it in this case.  The QOM class of things is visible
to the user/config layer via QMP (and sometimes command line).  It
doesn't necessarily correspond to guest visible differences, but it
often does.

AIUI, the idea here is that the back end in use should be an
implementation detail which doesn't affect the interfaces outside the
vfio subsystem itself.  If that's the case QOM may not be a great
fit, even though you can probably make it work.

> The base class implements generic code such as code related to
> memory_listener and address space management whereas the derived
> class implements callbacks that depend on the kernel user space
> being used.
>=20
> 'as.c' only manipulates the base class object with wrapper functions
> that call the right class functions. Existing 'container.c' code is
> converted to implement the legacy container class functions.
>=20
> Existing migration code only works with the legacy container.
> Also 'spapr.c' isn't BE agnostic.
>=20
> Below is the object. It's named as VFIOContainer, old VFIOContainer
> is replaced with VFIOLegacyContainer.
>=20
> struct VFIOContainer {
>     /* private */
>     Object parent_obj;
>=20
>     VFIOAddressSpace *space;
>     MemoryListener listener;
>     Error *error;
>     bool initialized;
>     bool dirty_pages_supported;
>     uint64_t dirty_pgsizes;
>     uint64_t max_dirty_bitmap_size;
>     unsigned long pgsizes;
>     unsigned int dma_max_mappings;
>     QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>     QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
>     QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
>     QLIST_ENTRY(VFIOContainer) next;
> };
>=20
> struct VFIOLegacyContainer {
>     VFIOContainer obj;
>     int fd; /* /dev/vfio/vfio, empowered by the attached groups */
>     MemoryListener prereg_listener;
>     unsigned iommu_type;
>     QLIST_HEAD(, VFIOGroup) group_list;
> };
>=20
> Co-authored-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  hw/vfio/as.c                         |  48 +++---
>  hw/vfio/container-obj.c              | 195 +++++++++++++++++++++++
>  hw/vfio/container.c                  | 224 ++++++++++++++++-----------
>  hw/vfio/meson.build                  |   1 +
>  hw/vfio/migration.c                  |   4 +-
>  hw/vfio/pci.c                        |   4 +-
>  hw/vfio/spapr.c                      |  22 +--
>  include/hw/vfio/vfio-common.h        |  78 ++--------
>  include/hw/vfio/vfio-container-obj.h | 154 ++++++++++++++++++
>  9 files changed, 540 insertions(+), 190 deletions(-)
>  create mode 100644 hw/vfio/container-obj.c
>  create mode 100644 include/hw/vfio/vfio-container-obj.h
>=20
> diff --git a/hw/vfio/as.c b/hw/vfio/as.c
> index 4181182808..37423d2c89 100644
> --- a/hw/vfio/as.c
> +++ b/hw/vfio/as.c
> @@ -215,9 +215,9 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, I=
OMMUTLBEntry *iotlb)
>           * of vaddr will always be there, even if the memory object is
>           * destroyed and its backing memory munmap-ed.
>           */
> -        ret =3D vfio_dma_map(container, iova,
> -                           iotlb->addr_mask + 1, vaddr,
> -                           read_only);
> +        ret =3D vfio_container_dma_map(container, iova,
> +                                     iotlb->addr_mask + 1, vaddr,
> +                                     read_only);
>          if (ret) {
>              error_report("vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
>                           "0x%"HWADDR_PRIx", %p) =3D %d (%m)",
> @@ -225,7 +225,8 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, I=
OMMUTLBEntry *iotlb)
>                           iotlb->addr_mask + 1, vaddr, ret);
>          }
>      } else {
> -        ret =3D vfio_dma_unmap(container, iova, iotlb->addr_mask + 1, io=
tlb);
> +        ret =3D vfio_container_dma_unmap(container, iova,
> +                                       iotlb->addr_mask + 1, iotlb);
>          if (ret) {
>              error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>                           "0x%"HWADDR_PRIx") =3D %d (%m)",
> @@ -242,12 +243,13 @@ static void vfio_ram_discard_notify_discard(RamDisc=
ardListener *rdl,
>  {
>      VFIORamDiscardListener *vrdl =3D container_of(rdl, VFIORamDiscardLis=
tener,
>                                                  listener);
> +    VFIOContainer *container =3D vrdl->container;
>      const hwaddr size =3D int128_get64(section->size);
>      const hwaddr iova =3D section->offset_within_address_space;
>      int ret;
> =20
>      /* Unmap with a single call. */
> -    ret =3D vfio_dma_unmap(vrdl->container, iova, size , NULL);
> +    ret =3D vfio_container_dma_unmap(container, iova, size , NULL);
>      if (ret) {
>          error_report("%s: vfio_dma_unmap() failed: %s", __func__,
>                       strerror(-ret));
> @@ -259,6 +261,7 @@ static int vfio_ram_discard_notify_populate(RamDiscar=
dListener *rdl,
>  {
>      VFIORamDiscardListener *vrdl =3D container_of(rdl, VFIORamDiscardLis=
tener,
>                                                  listener);
> +    VFIOContainer *container =3D vrdl->container;
>      const hwaddr end =3D section->offset_within_region +
>                         int128_get64(section->size);
>      hwaddr start, next, iova;
> @@ -277,8 +280,8 @@ static int vfio_ram_discard_notify_populate(RamDiscar=
dListener *rdl,
>                 section->offset_within_address_space;
>          vaddr =3D memory_region_get_ram_ptr(section->mr) + start;
> =20
> -        ret =3D vfio_dma_map(vrdl->container, iova, next - start,
> -                           vaddr, section->readonly);
> +        ret =3D vfio_container_dma_map(container, iova, next - start,
> +                                     vaddr, section->readonly);
>          if (ret) {
>              /* Rollback */
>              vfio_ram_discard_notify_discard(rdl, section);
> @@ -530,8 +533,8 @@ static void vfio_listener_region_add(MemoryListener *=
listener,
>          }
>      }
> =20
> -    ret =3D vfio_dma_map(container, iova, int128_get64(llsize),
> -                       vaddr, section->readonly);
> +    ret =3D vfio_container_dma_map(container, iova, int128_get64(llsize),
> +                                 vaddr, section->readonly);
>      if (ret) {
>          error_setg(&err, "vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
>                     "0x%"HWADDR_PRIx", %p) =3D %d (%m)",
> @@ -656,7 +659,8 @@ static void vfio_listener_region_del(MemoryListener *=
listener,
>          if (int128_eq(llsize, int128_2_64())) {
>              /* The unmap ioctl doesn't accept a full 64-bit span. */
>              llsize =3D int128_rshift(llsize, 1);
> -            ret =3D vfio_dma_unmap(container, iova, int128_get64(llsize)=
, NULL);
> +            ret =3D vfio_container_dma_unmap(container, iova,
> +                                           int128_get64(llsize), NULL);
>              if (ret) {
>                  error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>                               "0x%"HWADDR_PRIx") =3D %d (%m)",
> @@ -664,7 +668,8 @@ static void vfio_listener_region_del(MemoryListener *=
listener,
>              }
>              iova +=3D int128_get64(llsize);
>          }
> -        ret =3D vfio_dma_unmap(container, iova, int128_get64(llsize), NU=
LL);
> +        ret =3D vfio_container_dma_unmap(container, iova,
> +                                       int128_get64(llsize), NULL);
>          if (ret) {
>              error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>                           "0x%"HWADDR_PRIx") =3D %d (%m)",
> @@ -681,14 +686,14 @@ static void vfio_listener_log_global_start(MemoryLi=
stener *listener)
>  {
>      VFIOContainer *container =3D container_of(listener, VFIOContainer, l=
istener);
> =20
> -    vfio_set_dirty_page_tracking(container, true);
> +    vfio_container_set_dirty_page_tracking(container, true);
>  }
> =20
>  static void vfio_listener_log_global_stop(MemoryListener *listener)
>  {
>      VFIOContainer *container =3D container_of(listener, VFIOContainer, l=
istener);
> =20
> -    vfio_set_dirty_page_tracking(container, false);
> +    vfio_container_set_dirty_page_tracking(container, false);
>  }
> =20
>  typedef struct {
> @@ -717,8 +722,9 @@ static void vfio_iommu_map_dirty_notify(IOMMUNotifier=
 *n, IOMMUTLBEntry *iotlb)
>      if (vfio_get_xlat_addr(iotlb, NULL, &translated_addr, NULL)) {
>          int ret;
> =20
> -        ret =3D vfio_get_dirty_bitmap(container, iova, iotlb->addr_mask =
+ 1,
> -                                    translated_addr);
> +        ret =3D vfio_container_get_dirty_bitmap(container, iova,
> +                                              iotlb->addr_mask + 1,
> +                                              translated_addr);
>          if (ret) {
>              error_report("vfio_iommu_map_dirty_notify(%p, 0x%"HWADDR_PRI=
x", "
>                           "0x%"HWADDR_PRIx") =3D %d (%m)",
> @@ -742,11 +748,13 @@ static int vfio_ram_discard_get_dirty_bitmap(Memory=
RegionSection *section,
>       * Sync the whole mapped region (spanning multiple individual mappin=
gs)
>       * in one go.
>       */
> -    return vfio_get_dirty_bitmap(vrdl->container, iova, size, ram_addr);
> +    return vfio_container_get_dirty_bitmap(vrdl->container, iova,
> +                                           size, ram_addr);
>  }
> =20
> -static int vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *co=
ntainer,
> -                                                   MemoryRegionSection *=
section)
> +static int
> +vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
> +                                            MemoryRegionSection *section)
>  {
>      RamDiscardManager *rdm =3D memory_region_get_ram_discard_manager(sec=
tion->mr);
>      VFIORamDiscardListener *vrdl =3D NULL;
> @@ -810,7 +818,7 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *cont=
ainer,
>      ram_addr =3D memory_region_get_ram_addr(section->mr) +
>                 section->offset_within_region;
> =20
> -    return vfio_get_dirty_bitmap(container,
> +    return vfio_container_get_dirty_bitmap(container,
>                     REAL_HOST_PAGE_ALIGN(section->offset_within_address_s=
pace),
>                     int128_get64(section->size), ram_addr);
>  }
> @@ -825,7 +833,7 @@ static void vfio_listener_log_sync(MemoryListener *li=
stener,
>          return;
>      }
> =20
> -    if (vfio_devices_all_dirty_tracking(container)) {
> +    if (vfio_container_devices_all_dirty_tracking(container)) {
>          vfio_sync_dirty_bitmap(container, section);
>      }
>  }
> diff --git a/hw/vfio/container-obj.c b/hw/vfio/container-obj.c
> new file mode 100644
> index 0000000000..40c1e2a2b5
> --- /dev/null
> +++ b/hw/vfio/container-obj.c
> @@ -0,0 +1,195 @@
> +/*
> + * VFIO CONTAINER BASE OBJECT
> + *
> + * Copyright (C) 2022 Intel Corporation.
> + * Copyright Red Hat, Inc. 2022
> + *
> + * Authors: Yi Liu <yi.l.liu@intel.com>
> + *          Eric Auger <eric.auger@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "qom/object.h"
> +#include "qapi/visitor.h"
> +#include "hw/vfio/vfio-container-obj.h"
> +
> +bool vfio_container_check_extension(VFIOContainer *container,
> +                                    VFIOContainerFeature feat)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->check_extension) {
> +        return false;
> +    }
> +
> +    return vccs->check_extension(container, feat);
> +}
> +
> +int vfio_container_dma_map(VFIOContainer *container,
> +                           hwaddr iova, ram_addr_t size,
> +                           void *vaddr, bool readonly)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->dma_map) {
> +        return -EINVAL;
> +    }
> +
> +    return vccs->dma_map(container, iova, size, vaddr, readonly);
> +}
> +
> +int vfio_container_dma_unmap(VFIOContainer *container,
> +                             hwaddr iova, ram_addr_t size,
> +                             IOMMUTLBEntry *iotlb)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->dma_unmap) {
> +        return -EINVAL;
> +    }
> +
> +    return vccs->dma_unmap(container, iova, size, iotlb);
> +}
> +
> +void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
> +                                            bool start)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->set_dirty_page_tracking) {
> +        return;
> +    }
> +
> +    vccs->set_dirty_page_tracking(container, start);
> +}
> +
> +bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->devices_all_dirty_tracking) {
> +        return false;
> +    }
> +
> +    return vccs->devices_all_dirty_tracking(container);
> +}
> +
> +int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t i=
ova,
> +                                    uint64_t size, ram_addr_t ram_addr)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->get_dirty_bitmap) {
> +        return -EINVAL;
> +    }
> +
> +    return vccs->get_dirty_bitmap(container, iova, size, ram_addr);
> +}
> +
> +int vfio_container_add_section_window(VFIOContainer *container,
> +                                      MemoryRegionSection *section,
> +                                      Error **errp)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->add_window) {
> +        return 0;
> +    }
> +
> +    return vccs->add_window(container, section, errp);
> +}
> +
> +void vfio_container_del_section_window(VFIOContainer *container,
> +                                       MemoryRegionSection *section)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_GET_CLASS(container);
> +
> +    if (!vccs->del_window) {
> +        return;
> +    }
> +
> +    return vccs->del_window(container, section);
> +}
> +
> +void vfio_container_init(void *_container, size_t instance_size,
> +                         const char *mrtypename,
> +                         VFIOAddressSpace *space)
> +{
> +    VFIOContainer *container;
> +
> +    object_initialize(_container, instance_size, mrtypename);
> +    container =3D VFIO_CONTAINER_OBJ(_container);
> +
> +    container->space =3D space;
> +    container->error =3D NULL;
> +    container->dirty_pages_supported =3D false;
> +    container->dma_max_mappings =3D 0;
> +    QLIST_INIT(&container->giommu_list);
> +    QLIST_INIT(&container->hostwin_list);
> +    QLIST_INIT(&container->vrdl_list);
> +}
> +
> +void vfio_container_destroy(VFIOContainer *container)
> +{
> +    VFIORamDiscardListener *vrdl, *vrdl_tmp;
> +    VFIOGuestIOMMU *giommu, *tmp;
> +    VFIOHostDMAWindow *hostwin, *next;
> +
> +    QLIST_SAFE_REMOVE(container, next);
> +
> +    QLIST_FOREACH_SAFE(vrdl, &container->vrdl_list, next, vrdl_tmp) {
> +        RamDiscardManager *rdm;
> +
> +        rdm =3D memory_region_get_ram_discard_manager(vrdl->mr);
> +        ram_discard_manager_unregister_listener(rdm, &vrdl->listener);
> +        QLIST_REMOVE(vrdl, next);
> +        g_free(vrdl);
> +    }
> +
> +    QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp=
) {
> +        memory_region_unregister_iommu_notifier(
> +                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> +        QLIST_REMOVE(giommu, giommu_next);
> +        g_free(giommu);
> +    }
> +
> +    QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_next,
> +                       next) {
> +        QLIST_REMOVE(hostwin, hostwin_next);
> +        g_free(hostwin);
> +    }
> +
> +    object_unref(&container->parent_obj);
> +}
> +
> +static const TypeInfo vfio_container_info =3D {
> +    .parent             =3D TYPE_OBJECT,
> +    .name               =3D TYPE_VFIO_CONTAINER_OBJ,
> +    .class_size         =3D sizeof(VFIOContainerClass),
> +    .instance_size      =3D sizeof(VFIOContainer),
> +    .abstract           =3D true,
> +};
> +
> +static void vfio_container_register_types(void)
> +{
> +    type_register_static(&vfio_container_info);
> +}
> +
> +type_init(vfio_container_register_types)
> diff --git a/hw/vfio/container.c b/hw/vfio/container.c
> index 9c665c1720..79972064d3 100644
> --- a/hw/vfio/container.c
> +++ b/hw/vfio/container.c
> @@ -50,6 +50,8 @@
>  static int vfio_kvm_device_fd =3D -1;
>  #endif
> =20
> +#define TYPE_VFIO_LEGACY_CONTAINER "qemu:vfio-legacy-container"
> +
>  VFIOGroupList vfio_group_list =3D
>      QLIST_HEAD_INITIALIZER(vfio_group_list);
> =20
> @@ -76,8 +78,10 @@ bool vfio_mig_active(void)
>      return true;
>  }
> =20
> -bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
> +static bool vfio_devices_all_dirty_tracking(VFIOContainer *bcontainer)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      VFIOGroup *group;
>      VFIODevice *vbasedev;
>      MigrationState *ms =3D migrate_get_current();
> @@ -103,7 +107,7 @@ bool vfio_devices_all_dirty_tracking(VFIOContainer *c=
ontainer)
>      return true;
>  }
> =20
> -bool vfio_devices_all_running_and_saving(VFIOContainer *container)
> +static bool vfio_devices_all_running_and_saving(VFIOLegacyContainer *con=
tainer)
>  {
>      VFIOGroup *group;
>      VFIODevice *vbasedev;
> @@ -132,10 +136,11 @@ bool vfio_devices_all_running_and_saving(VFIOContai=
ner *container)
>      return true;
>  }
> =20
> -static int vfio_dma_unmap_bitmap(VFIOContainer *container,
> +static int vfio_dma_unmap_bitmap(VFIOLegacyContainer *container,
>                                   hwaddr iova, ram_addr_t size,
>                                   IOMMUTLBEntry *iotlb)
>  {
> +    VFIOContainer *bcontainer =3D &container->obj;
>      struct vfio_iommu_type1_dma_unmap *unmap;
>      struct vfio_bitmap *bitmap;
>      uint64_t pages =3D REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_=
size;
> @@ -159,7 +164,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *conta=
iner,
>      bitmap->size =3D ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
>                     BITS_PER_BYTE;
> =20
> -    if (bitmap->size > container->max_dirty_bitmap_size) {
> +    if (bitmap->size > bcontainer->max_dirty_bitmap_size) {
>          error_report("UNMAP: Size of bitmap too big 0x%"PRIx64,
>                       (uint64_t)bitmap->size);
>          ret =3D -E2BIG;
> @@ -189,10 +194,12 @@ unmap_exit:
>  /*
>   * DMA - Mapping and unmapping for the "type1" IOMMU interface used on x=
86
>   */
> -int vfio_dma_unmap(VFIOContainer *container,
> -                   hwaddr iova, ram_addr_t size,
> -                   IOMMUTLBEntry *iotlb)
> +static int vfio_dma_unmap(VFIOContainer *bcontainer,
> +                          hwaddr iova, ram_addr_t size,
> +                          IOMMUTLBEntry *iotlb)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      struct vfio_iommu_type1_dma_unmap unmap =3D {
>          .argsz =3D sizeof(unmap),
>          .flags =3D 0,
> @@ -200,7 +207,7 @@ int vfio_dma_unmap(VFIOContainer *container,
>          .size =3D size,
>      };
> =20
> -    if (iotlb && container->dirty_pages_supported &&
> +    if (iotlb && bcontainer->dirty_pages_supported &&
>          vfio_devices_all_running_and_saving(container)) {
>          return vfio_dma_unmap_bitmap(container, iova, size, iotlb);
>      }
> @@ -221,7 +228,7 @@ int vfio_dma_unmap(VFIOContainer *container,
>          if (errno =3D=3D EINVAL && unmap.size && !(unmap.iova + unmap.si=
ze) &&
>              container->iommu_type =3D=3D VFIO_TYPE1v2_IOMMU) {
>              trace_vfio_dma_unmap_overflow_workaround();
> -            unmap.size -=3D 1ULL << ctz64(container->pgsizes);
> +            unmap.size -=3D 1ULL << ctz64(bcontainer->pgsizes);
>              continue;
>          }
>          error_report("VFIO_UNMAP_DMA failed: %s", strerror(errno));
> @@ -231,9 +238,22 @@ int vfio_dma_unmap(VFIOContainer *container,
>      return 0;
>  }
> =20
> -int vfio_dma_map(VFIOContainer *container, hwaddr iova,
> -                 ram_addr_t size, void *vaddr, bool readonly)
> +static bool vfio_legacy_container_check_extension(VFIOContainer *bcontai=
ner,
> +                                                  VFIOContainerFeature f=
eat)
>  {
> +    switch (feat) {
> +    case VFIO_FEAT_LIVE_MIGRATION:
> +        return true;
> +    default:
> +        return false;
> +    };
> +}
> +
> +static int vfio_dma_map(VFIOContainer *bcontainer, hwaddr iova,
> +                       ram_addr_t size, void *vaddr, bool readonly)
> +{
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      struct vfio_iommu_type1_dma_map map =3D {
>          .argsz =3D sizeof(map),
>          .flags =3D VFIO_DMA_MAP_FLAG_READ,
> @@ -252,7 +272,7 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iov=
a,
>       * the VGA ROM space.
>       */
>      if (ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) =3D=3D 0 ||
> -        (errno =3D=3D EBUSY && vfio_dma_unmap(container, iova, size, NUL=
L) =3D=3D 0 &&
> +        (errno =3D=3D EBUSY && vfio_dma_unmap(bcontainer, iova, size, NU=
LL) =3D=3D 0 &&
>           ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) =3D=3D 0)) {
>          return 0;
>      }
> @@ -261,8 +281,10 @@ int vfio_dma_map(VFIOContainer *container, hwaddr io=
va,
>      return -errno;
>  }
> =20
> -void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
> +static void vfio_set_dirty_page_tracking(VFIOContainer *bcontainer, bool=
 start)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      int ret;
>      struct vfio_iommu_type1_dirty_bitmap dirty =3D {
>          .argsz =3D sizeof(dirty),
> @@ -281,9 +303,11 @@ void vfio_set_dirty_page_tracking(VFIOContainer *con=
tainer, bool start)
>      }
>  }
> =20
> -int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
> -                          uint64_t size, ram_addr_t ram_addr)
> +static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iov=
a,
> +                                 uint64_t size, ram_addr_t ram_addr)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      struct vfio_iommu_type1_dirty_bitmap *dbitmap;
>      struct vfio_iommu_type1_dirty_bitmap_get *range;
>      uint64_t pages;
> @@ -333,18 +357,23 @@ err_out:
>      return ret;
>  }
> =20
> -static void vfio_listener_release(VFIOContainer *container)
> +static void vfio_listener_release(VFIOLegacyContainer *container)
>  {
> -    memory_listener_unregister(&container->listener);
> +    VFIOContainer *bcontainer =3D &container->obj;
> +
> +    memory_listener_unregister(&bcontainer->listener);
>      if (container->iommu_type =3D=3D VFIO_SPAPR_TCE_v2_IOMMU) {
>          memory_listener_unregister(&container->prereg_listener);
>      }
>  }
> =20
> -int vfio_container_add_section_window(VFIOContainer *container,
> -                                      MemoryRegionSection *section,
> -                                      Error **errp)
> +static int
> +vfio_legacy_container_add_section_window(VFIOContainer *bcontainer,
> +                                         MemoryRegionSection *section,
> +                                         Error **errp)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
>      VFIOHostDMAWindow *hostwin;
>      hwaddr pgsize =3D 0;
>      int ret;
> @@ -354,7 +383,7 @@ int vfio_container_add_section_window(VFIOContainer *=
container,
>      }
> =20
>      /* For now intersections are not allowed, we may relax this later */
> -    QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
> +    QLIST_FOREACH(hostwin, &bcontainer->hostwin_list, hostwin_next) {
>          if (ranges_overlap(hostwin->min_iova,
>                             hostwin->max_iova - hostwin->min_iova + 1,
>                             section->offset_within_address_space,
> @@ -376,7 +405,7 @@ int vfio_container_add_section_window(VFIOContainer *=
container,
>          return ret;
>      }
> =20
> -    vfio_host_win_add(container, section->offset_within_address_space,
> +    vfio_host_win_add(bcontainer, section->offset_within_address_space,
>                        section->offset_within_address_space +
>                        int128_get64(section->size) - 1, pgsize);
>  #ifdef CONFIG_KVM
> @@ -409,16 +438,20 @@ int vfio_container_add_section_window(VFIOContainer=
 *container,
>      return 0;
>  }
> =20
> -void vfio_container_del_section_window(VFIOContainer *container,
> -                                       MemoryRegionSection *section)
> +static void
> +vfio_legacy_container_del_section_window(VFIOContainer *bcontainer,
> +                                         MemoryRegionSection *section)
>  {
> +    VFIOLegacyContainer *container =3D container_of(bcontainer,
> +                                                  VFIOLegacyContainer, o=
bj);
> +
>      if (container->iommu_type !=3D VFIO_SPAPR_TCE_v2_IOMMU) {
>          return;
>      }
> =20
>      vfio_spapr_remove_window(container,
>                               section->offset_within_address_space);
> -    if (vfio_host_win_del(container,
> +    if (vfio_host_win_del(bcontainer,
>                            section->offset_within_address_space,
>                            section->offset_within_address_space +
>                            int128_get64(section->size) - 1) < 0) {
> @@ -505,7 +538,7 @@ static void vfio_kvm_device_del_group(VFIOGroup *grou=
p)
>  /*
>   * vfio_get_iommu_type - selects the richest iommu_type (v2 first)
>   */
> -static int vfio_get_iommu_type(VFIOContainer *container,
> +static int vfio_get_iommu_type(VFIOLegacyContainer *container,
>                                 Error **errp)
>  {
>      int iommu_types[] =3D { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
> @@ -521,7 +554,7 @@ static int vfio_get_iommu_type(VFIOContainer *contain=
er,
>      return -EINVAL;
>  }
> =20
> -static int vfio_init_container(VFIOContainer *container, int group_fd,
> +static int vfio_init_container(VFIOLegacyContainer *container, int group=
_fd,
>                                 Error **errp)
>  {
>      int iommu_type, ret;
> @@ -556,7 +589,7 @@ static int vfio_init_container(VFIOContainer *contain=
er, int group_fd,
>      return 0;
>  }
> =20
> -static int vfio_get_iommu_info(VFIOContainer *container,
> +static int vfio_get_iommu_info(VFIOLegacyContainer *container,
>                                 struct vfio_iommu_type1_info **info)
>  {
> =20
> @@ -600,11 +633,12 @@ vfio_get_iommu_info_cap(struct vfio_iommu_type1_inf=
o *info, uint16_t id)
>      return NULL;
>  }
> =20
> -static void vfio_get_iommu_info_migration(VFIOContainer *container,
> -                                         struct vfio_iommu_type1_info *i=
nfo)
> +static void vfio_get_iommu_info_migration(VFIOLegacyContainer *container,
> +                                          struct vfio_iommu_type1_info *=
info)
>  {
>      struct vfio_info_cap_header *hdr;
>      struct vfio_iommu_type1_info_cap_migration *cap_mig;
> +    VFIOContainer *bcontainer =3D &container->obj;
> =20
>      hdr =3D vfio_get_iommu_info_cap(info, VFIO_IOMMU_TYPE1_INFO_CAP_MIGR=
ATION);
>      if (!hdr) {
> @@ -619,13 +653,14 @@ static void vfio_get_iommu_info_migration(VFIOConta=
iner *container,
>       * qemu_real_host_page_size to mark those dirty.
>       */
>      if (cap_mig->pgsize_bitmap & qemu_real_host_page_size) {
> -        container->dirty_pages_supported =3D true;
> -        container->max_dirty_bitmap_size =3D cap_mig->max_dirty_bitmap_s=
ize;
> -        container->dirty_pgsizes =3D cap_mig->pgsize_bitmap;
> +        bcontainer->dirty_pages_supported =3D true;
> +        bcontainer->max_dirty_bitmap_size =3D cap_mig->max_dirty_bitmap_=
size;
> +        bcontainer->dirty_pgsizes =3D cap_mig->pgsize_bitmap;
>      }
>  }
> =20
> -static int vfio_ram_block_discard_disable(VFIOContainer *container, bool=
 state)
> +static int
> +vfio_ram_block_discard_disable(VFIOLegacyContainer *container, bool stat=
e)
>  {
>      switch (container->iommu_type) {
>      case VFIO_TYPE1v2_IOMMU:
> @@ -651,7 +686,8 @@ static int vfio_ram_block_discard_disable(VFIOContain=
er *container, bool state)
>  static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>                                    Error **errp)
>  {
> -    VFIOContainer *container;
> +    VFIOContainer *bcontainer;
> +    VFIOLegacyContainer *container;
>      int ret, fd;
>      VFIOAddressSpace *space;
> =20
> @@ -688,7 +724,8 @@ static int vfio_connect_container(VFIOGroup *group, A=
ddressSpace *as,
>       * details once we know which type of IOMMU we are using.
>       */
> =20
> -    QLIST_FOREACH(container, &space->containers, next) {
> +    QLIST_FOREACH(bcontainer, &space->containers, next) {
> +        container =3D container_of(bcontainer, VFIOLegacyContainer, obj);
>          if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd))=
 {
>              ret =3D vfio_ram_block_discard_disable(container, true);
>              if (ret) {
> @@ -724,14 +761,10 @@ static int vfio_connect_container(VFIOGroup *group,=
 AddressSpace *as,
>      }
> =20
>      container =3D g_malloc0(sizeof(*container));
> -    container->space =3D space;
>      container->fd =3D fd;
> -    container->error =3D NULL;
> -    container->dirty_pages_supported =3D false;
> -    container->dma_max_mappings =3D 0;
> -    QLIST_INIT(&container->giommu_list);
> -    QLIST_INIT(&container->hostwin_list);
> -    QLIST_INIT(&container->vrdl_list);
> +    bcontainer =3D &container->obj;
> +    vfio_container_init(bcontainer, sizeof(*bcontainer),
> +                        TYPE_VFIO_LEGACY_CONTAINER, space);
> =20
>      ret =3D vfio_init_container(container, group->fd, errp);
>      if (ret) {
> @@ -763,13 +796,13 @@ static int vfio_connect_container(VFIOGroup *group,=
 AddressSpace *as,
>              /* Assume 4k IOVA page size */
>              info->iova_pgsizes =3D 4096;
>          }
> -        vfio_host_win_add(container, 0, (hwaddr)-1, info->iova_pgsizes);
> -        container->pgsizes =3D info->iova_pgsizes;
> +        vfio_host_win_add(bcontainer, 0, (hwaddr)-1, info->iova_pgsizes);
> +        bcontainer->pgsizes =3D info->iova_pgsizes;
> =20
>          /* The default in the kernel ("dma_entry_limit") is 65535. */
> -        container->dma_max_mappings =3D 65535;
> +        bcontainer->dma_max_mappings =3D 65535;
>          if (!ret) {
> -            vfio_get_info_dma_avail(info, &container->dma_max_mappings);
> +            vfio_get_info_dma_avail(info, &bcontainer->dma_max_mappings);
>              vfio_get_iommu_info_migration(container, info);
>          }
>          g_free(info);
> @@ -798,10 +831,10 @@ static int vfio_connect_container(VFIOGroup *group,=
 AddressSpace *as,
> =20
>              memory_listener_register(&container->prereg_listener,
>                                       &address_space_memory);
> -            if (container->error) {
> +            if (bcontainer->error) {
>                  memory_listener_unregister(&container->prereg_listener);
>                  ret =3D -1;
> -                error_propagate_prepend(errp, container->error,
> +                error_propagate_prepend(errp, bcontainer->error,
>                      "RAM memory listener initialization failed: ");
>                  goto enable_discards_exit;
>              }
> @@ -820,7 +853,7 @@ static int vfio_connect_container(VFIOGroup *group, A=
ddressSpace *as,
>          }
> =20
>          if (v2) {
> -            container->pgsizes =3D info.ddw.pgsizes;
> +            bcontainer->pgsizes =3D info.ddw.pgsizes;
>              /*
>               * There is a default window in just created container.
>               * To make region_add/del simpler, we better remove this
> @@ -835,8 +868,8 @@ static int vfio_connect_container(VFIOGroup *group, A=
ddressSpace *as,
>              }
>          } else {
>              /* The default table uses 4K pages */
> -            container->pgsizes =3D 0x1000;
> -            vfio_host_win_add(container, info.dma32_window_start,
> +            bcontainer->pgsizes =3D 0x1000;
> +            vfio_host_win_add(bcontainer, info.dma32_window_start,
>                                info.dma32_window_start +
>                                info.dma32_window_size - 1,
>                                0x1000);
> @@ -847,28 +880,28 @@ static int vfio_connect_container(VFIOGroup *group,=
 AddressSpace *as,
>      vfio_kvm_device_add_group(group);
> =20
>      QLIST_INIT(&container->group_list);
> -    QLIST_INSERT_HEAD(&space->containers, container, next);
> +    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
> =20
>      group->container =3D container;
>      QLIST_INSERT_HEAD(&container->group_list, group, container_next);
> =20
> -    container->listener =3D vfio_memory_listener;
> +    bcontainer->listener =3D vfio_memory_listener;
> =20
> -    memory_listener_register(&container->listener, container->space->as);
> +    memory_listener_register(&bcontainer->listener, bcontainer->space->a=
s);
> =20
> -    if (container->error) {
> +    if (bcontainer->error) {
>          ret =3D -1;
> -        error_propagate_prepend(errp, container->error,
> +        error_propagate_prepend(errp, bcontainer->error,
>              "memory listener initialization failed: ");
>          goto listener_release_exit;
>      }
> =20
> -    container->initialized =3D true;
> +    bcontainer->initialized =3D true;
> =20
>      return 0;
>  listener_release_exit:
>      QLIST_REMOVE(group, container_next);
> -    QLIST_REMOVE(container, next);
> +    QLIST_REMOVE(bcontainer, next);
>      vfio_kvm_device_del_group(group);
>      vfio_listener_release(container);
> =20
> @@ -889,7 +922,8 @@ put_space_exit:
> =20
>  static void vfio_disconnect_container(VFIOGroup *group)
>  {
> -    VFIOContainer *container =3D group->container;
> +    VFIOLegacyContainer *container =3D group->container;
> +    VFIOContainer *bcontainer =3D &container->obj;
> =20
>      QLIST_REMOVE(group, container_next);
>      group->container =3D NULL;
> @@ -909,25 +943,9 @@ static void vfio_disconnect_container(VFIOGroup *gro=
up)
>      }
> =20
>      if (QLIST_EMPTY(&container->group_list)) {
> -        VFIOAddressSpace *space =3D container->space;
> -        VFIOGuestIOMMU *giommu, *tmp;
> -        VFIOHostDMAWindow *hostwin, *next;
> -
> -        QLIST_REMOVE(container, next);
> -
> -        QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next,=
 tmp) {
> -            memory_region_unregister_iommu_notifier(
> -                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> -            QLIST_REMOVE(giommu, giommu_next);
> -            g_free(giommu);
> -        }
> -
> -        QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_ne=
xt,
> -                           next) {
> -            QLIST_REMOVE(hostwin, hostwin_next);
> -            g_free(hostwin);
> -        }
> +        VFIOAddressSpace *space =3D bcontainer->space;
> =20
> +        vfio_container_destroy(bcontainer);
>          trace_vfio_disconnect_container(container->fd);
>          close(container->fd);
>          g_free(container);
> @@ -939,13 +957,15 @@ static void vfio_disconnect_container(VFIOGroup *gr=
oup)
>  VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
>  {
>      VFIOGroup *group;
> +    VFIOContainer *bcontainer;
>      char path[32];
>      struct vfio_group_status status =3D { .argsz =3D sizeof(status) };
> =20
>      QLIST_FOREACH(group, &vfio_group_list, next) {
>          if (group->groupid =3D=3D groupid) {
>              /* Found it.  Now is it already in the right context? */
> -            if (group->container->space->as =3D=3D as) {
> +            bcontainer =3D &group->container->obj;
> +            if (bcontainer->space->as =3D=3D as) {
>                  return group;
>              } else {
>                  error_setg(errp, "group %d used in multiple address spac=
es",
> @@ -1098,7 +1118,7 @@ void vfio_put_base_device(VFIODevice *vbasedev)
>  /*
>   * Interfaces for IBM EEH (Enhanced Error Handling)
>   */
> -static bool vfio_eeh_container_ok(VFIOContainer *container)
> +static bool vfio_eeh_container_ok(VFIOLegacyContainer *container)
>  {
>      /*
>       * As of 2016-03-04 (linux-4.5) the host kernel EEH/VFIO
> @@ -1126,7 +1146,7 @@ static bool vfio_eeh_container_ok(VFIOContainer *co=
ntainer)
>      return true;
>  }
> =20
> -static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
> +static int vfio_eeh_container_op(VFIOLegacyContainer *container, uint32_=
t op)
>  {
>      struct vfio_eeh_pe_op pe_op =3D {
>          .argsz =3D sizeof(pe_op),
> @@ -1149,19 +1169,21 @@ static int vfio_eeh_container_op(VFIOContainer *c=
ontainer, uint32_t op)
>      return ret;
>  }
> =20
> -static VFIOContainer *vfio_eeh_as_container(AddressSpace *as)
> +static VFIOLegacyContainer *vfio_eeh_as_container(AddressSpace *as)
>  {
>      VFIOAddressSpace *space =3D vfio_get_address_space(as);
> -    VFIOContainer *container =3D NULL;
> +    VFIOLegacyContainer *container =3D NULL;
> +    VFIOContainer *bcontainer =3D NULL;
> =20
>      if (QLIST_EMPTY(&space->containers)) {
>          /* No containers to act on */
>          goto out;
>      }
> =20
> -    container =3D QLIST_FIRST(&space->containers);
> +    bcontainer =3D QLIST_FIRST(&space->containers);
> +    container =3D container_of(bcontainer, VFIOLegacyContainer, obj);
> =20
> -    if (QLIST_NEXT(container, next)) {
> +    if (QLIST_NEXT(bcontainer, next)) {
>          /*
>           * We don't yet have logic to synchronize EEH state across
>           * multiple containers.
> @@ -1177,17 +1199,45 @@ out:
> =20
>  bool vfio_eeh_as_ok(AddressSpace *as)
>  {
> -    VFIOContainer *container =3D vfio_eeh_as_container(as);
> +    VFIOLegacyContainer *container =3D vfio_eeh_as_container(as);
> =20
>      return (container !=3D NULL) && vfio_eeh_container_ok(container);
>  }
> =20
>  int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
>  {
> -    VFIOContainer *container =3D vfio_eeh_as_container(as);
> +    VFIOLegacyContainer *container =3D vfio_eeh_as_container(as);
> =20
>      if (!container) {
>          return -ENODEV;
>      }
>      return vfio_eeh_container_op(container, op);
>  }
> +
> +static void vfio_legacy_container_class_init(ObjectClass *klass,
> +                                             void *data)
> +{
> +    VFIOContainerClass *vccs =3D VFIO_CONTAINER_OBJ_CLASS(klass);
> +
> +    vccs->dma_map =3D vfio_dma_map;
> +    vccs->dma_unmap =3D vfio_dma_unmap;
> +    vccs->devices_all_dirty_tracking =3D vfio_devices_all_dirty_tracking;
> +    vccs->set_dirty_page_tracking =3D vfio_set_dirty_page_tracking;
> +    vccs->get_dirty_bitmap =3D vfio_get_dirty_bitmap;
> +    vccs->add_window =3D vfio_legacy_container_add_section_window;
> +    vccs->del_window =3D vfio_legacy_container_del_section_window;
> +    vccs->check_extension =3D vfio_legacy_container_check_extension;
> +}
> +
> +static const TypeInfo vfio_legacy_container_info =3D {
> +    .parent =3D TYPE_VFIO_CONTAINER_OBJ,
> +    .name =3D TYPE_VFIO_LEGACY_CONTAINER,
> +    .class_init =3D vfio_legacy_container_class_init,
> +};
> +
> +static void vfio_register_types(void)
> +{
> +    type_register_static(&vfio_legacy_container_info);
> +}
> +
> +type_init(vfio_register_types)
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index e3b6d6e2cb..df4fa2b695 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -2,6 +2,7 @@ vfio_ss =3D ss.source_set()
>  vfio_ss.add(files(
>    'common.c',
>    'as.c',
> +  'container-obj.c',
>    'container.c',
>    'spapr.c',
>    'migration.c',
> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
> index ff6b45de6b..cbbde177c3 100644
> --- a/hw/vfio/migration.c
> +++ b/hw/vfio/migration.c
> @@ -856,11 +856,11 @@ int64_t vfio_mig_bytes_transferred(void)
> =20
>  int vfio_migration_probe(VFIODevice *vbasedev, Error **errp)
>  {
> -    VFIOContainer *container =3D vbasedev->group->container;
> +    VFIOLegacyContainer *container =3D vbasedev->group->container;
>      struct vfio_region_info *info =3D NULL;
>      int ret =3D -ENOTSUP;
> =20
> -    if (!vbasedev->enable_migration || !container->dirty_pages_supported=
) {
> +    if (!vbasedev->enable_migration || !container->obj.dirty_pages_suppo=
rted) {
>          goto add_blocker;
>      }
> =20
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index e707329394..a00a485e46 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -3101,7 +3101,9 @@ static void vfio_realize(PCIDevice *pdev, Error **e=
rrp)
>          }
>      }
> =20
> -    if (!pdev->failover_pair_id) {
> +    if (!pdev->failover_pair_id &&
> +        vfio_container_check_extension(&vbasedev->group->container->obj,
> +                                       VFIO_FEAT_LIVE_MIGRATION)) {
>          ret =3D vfio_migration_probe(vbasedev, errp);
>          if (ret) {
>              error_report("%s: Migration disabled", vbasedev->name);
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index 04c6e67f8f..cdcd9e05ba 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -39,8 +39,8 @@ static void *vfio_prereg_gpa_to_vaddr(MemoryRegionSecti=
on *section, hwaddr gpa)
>  static void vfio_prereg_listener_region_add(MemoryListener *listener,
>                                              MemoryRegionSection *section)
>  {
> -    VFIOContainer *container =3D container_of(listener, VFIOContainer,
> -                                            prereg_listener);
> +    VFIOLegacyContainer *container =3D container_of(listener, VFIOLegacy=
Container,
> +                                                  prereg_listener);
>      const hwaddr gpa =3D section->offset_within_address_space;
>      hwaddr end;
>      int ret;
> @@ -83,9 +83,9 @@ static void vfio_prereg_listener_region_add(MemoryListe=
ner *listener,
>           * can gracefully fail.  Runtime, there's not much we can do oth=
er
>           * than throw a hardware error.
>           */
> -        if (!container->initialized) {
> -            if (!container->error) {
> -                error_setg_errno(&container->error, -ret,
> +        if (!container->obj.initialized) {
> +            if (!container->obj.error) {
> +                error_setg_errno(&container->obj.error, -ret,
>                                   "Memory registering failed");
>              }
>          } else {
> @@ -97,8 +97,8 @@ static void vfio_prereg_listener_region_add(MemoryListe=
ner *listener,
>  static void vfio_prereg_listener_region_del(MemoryListener *listener,
>                                              MemoryRegionSection *section)
>  {
> -    VFIOContainer *container =3D container_of(listener, VFIOContainer,
> -                                            prereg_listener);
> +    VFIOLegacyContainer *container =3D container_of(listener, VFIOLegacy=
Container,
> +                                                  prereg_listener);
>      const hwaddr gpa =3D section->offset_within_address_space;
>      hwaddr end;
>      int ret;
> @@ -141,7 +141,7 @@ const MemoryListener vfio_prereg_listener =3D {
>      .region_del =3D vfio_prereg_listener_region_del,
>  };
> =20
> -int vfio_spapr_create_window(VFIOContainer *container,
> +int vfio_spapr_create_window(VFIOLegacyContainer *container,
>                               MemoryRegionSection *section,
>                               hwaddr *pgsize)
>  {
> @@ -159,13 +159,13 @@ int vfio_spapr_create_window(VFIOContainer *contain=
er,
>      if (pagesize > rampagesize) {
>          pagesize =3D rampagesize;
>      }
> -    pgmask =3D container->pgsizes & (pagesize | (pagesize - 1));
> +    pgmask =3D container->obj.pgsizes & (pagesize | (pagesize - 1));
>      pagesize =3D pgmask ? (1ULL << (63 - clz64(pgmask))) : 0;
>      if (!pagesize) {
>          error_report("Host doesn't support page size 0x%"PRIx64
>                       ", the supported mask is 0x%lx",
>                       memory_region_iommu_get_min_page_size(iommu_mr),
> -                     container->pgsizes);
> +                     container->obj.pgsizes);
>          return -EINVAL;
>      }
> =20
> @@ -233,7 +233,7 @@ int vfio_spapr_create_window(VFIOContainer *container,
>      return 0;
>  }
> =20
> -int vfio_spapr_remove_window(VFIOContainer *container,
> +int vfio_spapr_remove_window(VFIOLegacyContainer *container,
>                               hwaddr offset_within_address_space)
>  {
>      struct vfio_iommu_spapr_tce_remove remove =3D {
> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
> index 03ff7944cb..02a6f36a9e 100644
> --- a/include/hw/vfio/vfio-common.h
> +++ b/include/hw/vfio/vfio-common.h
> @@ -30,6 +30,7 @@
>  #include <linux/vfio.h>
>  #endif
>  #include "sysemu/sysemu.h"
> +#include "hw/vfio/vfio-container-obj.h"
> =20
>  #define VFIO_MSG_PREFIX "vfio %s: "
> =20
> @@ -70,58 +71,15 @@ typedef struct VFIOMigration {
>      uint64_t pending_bytes;
>  } VFIOMigration;
> =20
> -typedef struct VFIOAddressSpace {
> -    AddressSpace *as;
> -    QLIST_HEAD(, VFIOContainer) containers;
> -    QLIST_ENTRY(VFIOAddressSpace) list;
> -} VFIOAddressSpace;
> -
>  struct VFIOGroup;
> =20
> -typedef struct VFIOContainer {
> -    VFIOAddressSpace *space;
> +typedef struct VFIOLegacyContainer {
> +    VFIOContainer obj;
>      int fd; /* /dev/vfio/vfio, empowered by the attached groups */
> -    MemoryListener listener;
>      MemoryListener prereg_listener;
>      unsigned iommu_type;
> -    Error *error;
> -    bool initialized;
> -    bool dirty_pages_supported;
> -    uint64_t dirty_pgsizes;
> -    uint64_t max_dirty_bitmap_size;
> -    unsigned long pgsizes;
> -    unsigned int dma_max_mappings;
> -    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
> -    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
>      QLIST_HEAD(, VFIOGroup) group_list;
> -    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
> -    QLIST_ENTRY(VFIOContainer) next;
> -} VFIOContainer;
> -
> -typedef struct VFIOGuestIOMMU {
> -    VFIOContainer *container;
> -    IOMMUMemoryRegion *iommu_mr;
> -    hwaddr iommu_offset;
> -    IOMMUNotifier n;
> -    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
> -} VFIOGuestIOMMU;
> -
> -typedef struct VFIORamDiscardListener {
> -    VFIOContainer *container;
> -    MemoryRegion *mr;
> -    hwaddr offset_within_address_space;
> -    hwaddr size;
> -    uint64_t granularity;
> -    RamDiscardListener listener;
> -    QLIST_ENTRY(VFIORamDiscardListener) next;
> -} VFIORamDiscardListener;
> -
> -typedef struct VFIOHostDMAWindow {
> -    hwaddr min_iova;
> -    hwaddr max_iova;
> -    uint64_t iova_pgsizes;
> -    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
> -} VFIOHostDMAWindow;
> +} VFIOLegacyContainer;
> =20
>  typedef struct VFIODeviceOps VFIODeviceOps;
> =20
> @@ -159,7 +117,7 @@ struct VFIODeviceOps {
>  typedef struct VFIOGroup {
>      int fd;
>      int groupid;
> -    VFIOContainer *container;
> +    VFIOLegacyContainer *container;
>      QLIST_HEAD(, VFIODevice) device_list;
>      QLIST_ENTRY(VFIOGroup) next;
>      QLIST_ENTRY(VFIOGroup) container_next;
> @@ -192,31 +150,13 @@ typedef struct VFIODisplay {
>      } dmabuf;
>  } VFIODisplay;
> =20
> -void vfio_host_win_add(VFIOContainer *container,
> +void vfio_host_win_add(VFIOContainer *bcontainer,
>                         hwaddr min_iova, hwaddr max_iova,
>                         uint64_t iova_pgsizes);
> -int vfio_host_win_del(VFIOContainer *container, hwaddr min_iova,
> +int vfio_host_win_del(VFIOContainer *bcontainer, hwaddr min_iova,
>                        hwaddr max_iova);
>  VFIOAddressSpace *vfio_get_address_space(AddressSpace *as);
>  void vfio_put_address_space(VFIOAddressSpace *space);
> -bool vfio_devices_all_running_and_saving(VFIOContainer *container);
> -bool vfio_devices_all_dirty_tracking(VFIOContainer *container);
> -
> -/* container->fd */
> -int vfio_dma_unmap(VFIOContainer *container,
> -                   hwaddr iova, ram_addr_t size,
> -                   IOMMUTLBEntry *iotlb);
> -int vfio_dma_map(VFIOContainer *container, hwaddr iova,
> -                 ram_addr_t size, void *vaddr, bool readonly);
> -void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start);
> -int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
> -                          uint64_t size, ram_addr_t ram_addr);
> -
> -int vfio_container_add_section_window(VFIOContainer *container,
> -                                      MemoryRegionSection *section,
> -                                      Error **errp);
> -void vfio_container_del_section_window(VFIOContainer *container,
> -                                       MemoryRegionSection *section);
> =20
>  void vfio_put_base_device(VFIODevice *vbasedev);
>  void vfio_disable_irqindex(VFIODevice *vbasedev, int index);
> @@ -263,10 +203,10 @@ vfio_get_device_info_cap(struct vfio_device_info *i=
nfo, uint16_t id);
>  #endif
>  extern const MemoryListener vfio_prereg_listener;
> =20
> -int vfio_spapr_create_window(VFIOContainer *container,
> +int vfio_spapr_create_window(VFIOLegacyContainer *container,
>                               MemoryRegionSection *section,
>                               hwaddr *pgsize);
> -int vfio_spapr_remove_window(VFIOContainer *container,
> +int vfio_spapr_remove_window(VFIOLegacyContainer *container,
>                               hwaddr offset_within_address_space);
> =20
>  int vfio_migration_probe(VFIODevice *vbasedev, Error **errp);
> diff --git a/include/hw/vfio/vfio-container-obj.h b/include/hw/vfio/vfio-=
container-obj.h
> new file mode 100644
> index 0000000000..7ffbbb299f
> --- /dev/null
> +++ b/include/hw/vfio/vfio-container-obj.h
> @@ -0,0 +1,154 @@
> +/*
> + * VFIO CONTAINER BASE OBJECT
> + *
> + * Copyright (C) 2022 Intel Corporation.
> + * Copyright Red Hat, Inc. 2022
> + *
> + * Authors: Yi Liu <yi.l.liu@intel.com>
> + *          Eric Auger <eric.auger@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef HW_VFIO_VFIO_CONTAINER_OBJ_H
> +#define HW_VFIO_VFIO_CONTAINER_OBJ_H
> +
> +#include "qom/object.h"
> +#include "exec/memory.h"
> +#include "qemu/queue.h"
> +#include "qemu/thread.h"
> +#ifndef CONFIG_USER_ONLY
> +#include "exec/hwaddr.h"
> +#endif
> +
> +#define TYPE_VFIO_CONTAINER_OBJ "qemu:vfio-base-container-obj"
> +#define VFIO_CONTAINER_OBJ(obj) \
> +        OBJECT_CHECK(VFIOContainer, (obj), TYPE_VFIO_CONTAINER_OBJ)
> +#define VFIO_CONTAINER_OBJ_CLASS(klass) \
> +        OBJECT_CLASS_CHECK(VFIOContainerClass, (klass), \
> +                         TYPE_VFIO_CONTAINER_OBJ)
> +#define VFIO_CONTAINER_OBJ_GET_CLASS(obj) \
> +        OBJECT_GET_CLASS(VFIOContainerClass, (obj), \
> +                         TYPE_VFIO_CONTAINER_OBJ)
> +
> +typedef enum VFIOContainerFeature {
> +    VFIO_FEAT_LIVE_MIGRATION,
> +} VFIOContainerFeature;
> +
> +typedef struct VFIOContainer VFIOContainer;
> +
> +typedef struct VFIOAddressSpace {
> +    AddressSpace *as;
> +    QLIST_HEAD(, VFIOContainer) containers;
> +    QLIST_ENTRY(VFIOAddressSpace) list;
> +} VFIOAddressSpace;
> +
> +typedef struct VFIOGuestIOMMU {
> +    VFIOContainer *container;
> +    IOMMUMemoryRegion *iommu_mr;
> +    hwaddr iommu_offset;
> +    IOMMUNotifier n;
> +    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
> +} VFIOGuestIOMMU;
> +
> +typedef struct VFIORamDiscardListener {
> +    VFIOContainer *container;
> +    MemoryRegion *mr;
> +    hwaddr offset_within_address_space;
> +    hwaddr size;
> +    uint64_t granularity;
> +    RamDiscardListener listener;
> +    QLIST_ENTRY(VFIORamDiscardListener) next;
> +} VFIORamDiscardListener;
> +
> +typedef struct VFIOHostDMAWindow {
> +    hwaddr min_iova;
> +    hwaddr max_iova;
> +    uint64_t iova_pgsizes;
> +    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
> +} VFIOHostDMAWindow;
> +
> +/*
> + * This is the base object for vfio container backends
> + */
> +struct VFIOContainer {
> +    /* private */
> +    Object parent_obj;
> +
> +    VFIOAddressSpace *space;
> +    MemoryListener listener;
> +    Error *error;
> +    bool initialized;
> +    bool dirty_pages_supported;
> +    uint64_t dirty_pgsizes;
> +    uint64_t max_dirty_bitmap_size;
> +    unsigned long pgsizes;
> +    unsigned int dma_max_mappings;
> +    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
> +    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
> +    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
> +    QLIST_ENTRY(VFIOContainer) next;
> +};
> +
> +typedef struct VFIOContainerClass {
> +    /* private */
> +    ObjectClass parent_class;
> +
> +    /* required */
> +    bool (*check_extension)(VFIOContainer *container,
> +                            VFIOContainerFeature feat);
> +    int (*dma_map)(VFIOContainer *container,
> +                   hwaddr iova, ram_addr_t size,
> +                   void *vaddr, bool readonly);
> +    int (*dma_unmap)(VFIOContainer *container,
> +                     hwaddr iova, ram_addr_t size,
> +                     IOMMUTLBEntry *iotlb);
> +    /* migration feature */
> +    bool (*devices_all_dirty_tracking)(VFIOContainer *container);
> +    void (*set_dirty_page_tracking)(VFIOContainer *container, bool start=
);
> +    int (*get_dirty_bitmap)(VFIOContainer *container, uint64_t iova,
> +                            uint64_t size, ram_addr_t ram_addr);
> +
> +    /* SPAPR specific */
> +    int (*add_window)(VFIOContainer *container,
> +                      MemoryRegionSection *section,
> +                      Error **errp);
> +    void (*del_window)(VFIOContainer *container,
> +                       MemoryRegionSection *section);
> +} VFIOContainerClass;
> +
> +bool vfio_container_check_extension(VFIOContainer *container,
> +                                    VFIOContainerFeature feat);
> +int vfio_container_dma_map(VFIOContainer *container,
> +                           hwaddr iova, ram_addr_t size,
> +                           void *vaddr, bool readonly);
> +int vfio_container_dma_unmap(VFIOContainer *container,
> +                             hwaddr iova, ram_addr_t size,
> +                             IOMMUTLBEntry *iotlb);
> +bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
> +void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
> +                                            bool start);
> +int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t i=
ova,
> +                                    uint64_t size, ram_addr_t ram_addr);
> +int vfio_container_add_section_window(VFIOContainer *container,
> +                                      MemoryRegionSection *section,
> +                                      Error **errp);
> +void vfio_container_del_section_window(VFIOContainer *container,
> +                                       MemoryRegionSection *section);
> +
> +void vfio_container_init(void *_container, size_t instance_size,
> +                         const char *mrtypename,
> +                         VFIOAddressSpace *space);
> +void vfio_container_destroy(VFIOContainer *container);
> +#endif /* HW_VFIO_VFIO_CONTAINER_OBJ_H */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--fJm8ENns1FerTi3R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJrhbgACgkQgypY4gEw
YSLvHxAAgY7WaEnjCkafYP0lg/SxIsvUTO2tBoIYVZx+7sOF6FEcl1fndIZfQhQ7
3QYOtUKhYWUziWXcH9Q2QIzYruT2mXa6+F61bT/SgCk6SX0F96YEqFUecUi57l13
h9e8GXeflRVmUmm6QAWmJMF+zKfSXnIr1/Qfj9A/U7/xfuEFUG2TPApw+i2UGYEm
GJ45IHAhG7jSx3YYr1DVpJy0mfMkw4EBzE2EZ9JvPLRp2kNgWC7X/x5ju14c+IS7
/4DlGsIA/7m+qznZ9s70bqV4F7AaxDhJYk2Ip/9iKLSqOWNjMCmfgq73IJ6bQ6Gx
0bnTX3eUAk7//fT/s94n771vTh8c/Ba5GgvQ9+LuMn9cRAk4OLNg8A+sp5bN50LL
T7LSnYEZR32wRTNqwDaXezcD15C8WkkSbG8I7/BLK1PdCfuqrUy0bv7SWEvW0gjn
ffjZmUqm5rsLc7Y7kqyny4SQIGVogsV81kYAEByiOjoLPi1fk9Hpn+2/OO1Vnf9p
BPrZNq67BAq0eYrttKH82V9xGdCAwS1fpDc+cdUFmqR0McpEa5XoExCoCb+SMzyQ
XlBUAZJN3seQ8CPm5pXIp9Uf4tH5gthkkqSn+Qv/hiHZW5Yz7H1pWr/6OuyCuZF+
MJTmbrGD4FgOoQRQAS9tRn6qzDTdNy4v0AYCCI8bI7Ac0um4400=
=XMDB
-----END PGP SIGNATURE-----

--fJm8ENns1FerTi3R--

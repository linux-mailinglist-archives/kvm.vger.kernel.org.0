Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD48212EA3
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 23:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgGBVR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 17:17:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31587 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgGBVRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 17:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593724642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nhsfj68WtE/EyvfIEb3mG+EhoeOueYT0YuXe7zxekwU=;
        b=eaoi8ywrHp92xLhEpR+p3HXGEMFFojm/ONOVmH1hn0gJCsdH9dqzgel8MWDvEZHRwusiB1
        cwvhR9apXYiNzJAyWgAS/rR3v05AQ1kcsdK+2BFymOGFpMr2pmm+iqyS/CtX0I0aRxZzYh
        Os+ltenPJvZqFDtp6IRUgM7PaQ5TLd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-2wOEVkpsNQe8e9GXPpAiNg-1; Thu, 02 Jul 2020 17:17:14 -0400
X-MC-Unique: 2wOEVkpsNQe8e9GXPpAiNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 402718015F4;
        Thu,  2 Jul 2020 21:17:12 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 294166109F;
        Thu,  2 Jul 2020 21:17:03 +0000 (UTC)
Date:   Thu, 2 Jul 2020 15:17:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/14] vfio: Add PASID allocation/free support
Message-ID: <20200702151702.1baa65cb@x1.home>
In-Reply-To: <1592988927-48009-5-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-5-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 01:55:17 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> Shared Virtual Addressing (a.k.a Shared Virtual Memory) allows sharing
> multiple process virtual address spaces with the device for simplified
> programming model. PASID is used to tag an virtual address space in DMA
> requests and to identify the related translation structure in IOMMU. When
> a PASID-capable device is assigned to a VM, we want the same capability
> of using PASID to tag guest process virtual address spaces to achieve
> virtual SVA (vSVA).
> 
> PASID management for guest is vendor specific. Some vendors (e.g. Intel
> VT-d) requires system-wide managed PASIDs cross all devices, regardless
> of whether a device is used by host or assigned to guest. Other vendors
> (e.g. ARM SMMU) may allow PASIDs managed per-device thus could be fully
> delegated to the guest for assigned devices.
> 
> For system-wide managed PASIDs, this patch introduces a vfio module to
> handle explicit PASID alloc/free requests from guest. Allocated PASIDs
> are associated to a process (or, mm_struct) in IOASID core. A vfio_mm
> object is introduced to track mm_struct. Multiple VFIO containers within
> a process share the same vfio_mm object.
> 
> A quota mechanism is provided to prevent malicious user from exhausting
> available PASIDs. Currently the quota is a global parameter applied to
> all VFIO devices. In the future per-device quota might be supported too.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
> v1 -> v2:
> *) added in v2, split from the pasid alloc/free support of v1
> ---
>  drivers/vfio/Kconfig      |   5 ++
>  drivers/vfio/Makefile     |   1 +
>  drivers/vfio/vfio_pasid.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h      |  28 +++++++++
>  4 files changed, 185 insertions(+)
>  create mode 100644 drivers/vfio/vfio_pasid.c
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index fd17db9..3d8a108 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -19,6 +19,11 @@ config VFIO_VIRQFD
>  	depends on VFIO && EVENTFD
>  	default n
>  
> +config VFIO_PASID
> +	tristate
> +	depends on IOASID && VFIO
> +	default n
> +
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	depends on IOMMU_API
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index de67c47..bb836a3 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -3,6 +3,7 @@ vfio_virqfd-y := virqfd.o
>  
>  obj-$(CONFIG_VFIO) += vfio.o
>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> +obj-$(CONFIG_VFIO_PASID) += vfio_pasid.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> new file mode 100644
> index 0000000..dd5b6d1
> --- /dev/null
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 Intel Corporation.
> + *     Author: Liu Yi L <yi.l.liu@intel.com>
> + *
> + */
> +
> +#include <linux/vfio.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/sched/mm.h>
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
> +#define DRIVER_DESC     "PASID management for VFIO bus drivers"
> +
> +#define VFIO_DEFAULT_PASID_QUOTA	1000
> +static int pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> +module_param_named(pasid_quota, pasid_quota, uint, 0444);
> +MODULE_PARM_DESC(pasid_quota,
> +		 " Set the quota for max number of PASIDs that an application is allowed to request (default 1000)");
> +
> +struct vfio_mm_token {
> +	unsigned long long val;
> +};
> +
> +struct vfio_mm {
> +	struct kref		kref;
> +	struct vfio_mm_token	token;
> +	int			ioasid_sid;
> +	int			pasid_quota;
> +	struct list_head	next;
> +};
> +
> +static struct vfio_pasid {
> +	struct mutex		vfio_mm_lock;
> +	struct list_head	vfio_mm_list;
> +} vfio_pasid;
> +
> +/* called with vfio.vfio_mm_lock held */
> +static void vfio_mm_release(struct kref *kref)
> +{
> +	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
> +
> +	list_del(&vmm->next);
> +	mutex_unlock(&vfio_pasid.vfio_mm_lock);
> +	ioasid_free_set(vmm->ioasid_sid, true);
> +	kfree(vmm);
> +}
> +
> +void vfio_mm_put(struct vfio_mm *vmm)
> +{
> +	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_pasid.vfio_mm_lock);
> +}
> +
> +static void vfio_mm_get(struct vfio_mm *vmm)
> +{
> +	kref_get(&vmm->kref);
> +}
> +
> +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
> +{
> +	struct mm_struct *mm = get_task_mm(task);
> +	struct vfio_mm *vmm;
> +	unsigned long long val = (unsigned long long) mm;
> +	int ret;
> +
> +	mutex_lock(&vfio_pasid.vfio_mm_lock);
> +	/* Search existing vfio_mm with current mm pointer */
> +	list_for_each_entry(vmm, &vfio_pasid.vfio_mm_list, next) {
> +		if (vmm->token.val == val) {
> +			vfio_mm_get(vmm);
> +			goto out;
> +		}
> +	}
> +
> +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> +	if (!vmm)
> +		return ERR_PTR(-ENOMEM);

lock leaked, mm leaked.

> +
> +	/*
> +	 * IOASID core provides a 'IOASID set' concept to track all
> +	 * PASIDs associated with a token. Here we use mm_struct as
> +	 * the token and create a IOASID set per mm_struct. All the
> +	 * containers of the process share the same IOASID set.
> +	 */
> +	ret = ioasid_alloc_set((struct ioasid_set *) mm, pasid_quota,
> +			       &vmm->ioasid_sid);
> +	if (ret) {
> +		kfree(vmm);
> +		return ERR_PTR(ret);

lock leaked, mm leaked.

> +	}
> +
> +	kref_init(&vmm->kref);
> +	vmm->token.val = (unsigned long long) mm;

We already have it in @val.

> +	vmm->pasid_quota = pasid_quota;

This field on the structure and this assignment seems to serve no
purpose.  Thanks,

Alex

> +
> +	list_add(&vmm->next, &vfio_pasid.vfio_mm_list);
> +out:
> +	mutex_unlock(&vfio_pasid.vfio_mm_lock);
> +	mmput(mm);
> +	return vmm;
> +}
> +
> +int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> +{
> +	ioasid_t pasid;
> +
> +	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
> +
> +	return (pasid == INVALID_IOASID) ? -ENOSPC : pasid;
> +}
> +
> +void vfio_pasid_free_range(struct vfio_mm *vmm,
> +			    ioasid_t min, ioasid_t max)
> +{
> +	ioasid_t pasid = min;
> +
> +	if (min > max)
> +		return;
> +
> +	/*
> +	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
> +	 * teardown necessary structures depending on the to-be-freed
> +	 * PASID.
> +	 */
> +	for (; pasid <= max; pasid++)
> +		ioasid_free(pasid);
> +}
> +
> +static int __init vfio_pasid_init(void)
> +{
> +	mutex_init(&vfio_pasid.vfio_mm_lock);
> +	INIT_LIST_HEAD(&vfio_pasid.vfio_mm_list);
> +	return 0;
> +}
> +
> +static void __exit vfio_pasid_exit(void)
> +{
> +	WARN_ON(!list_empty(&vfio_pasid.vfio_mm_list));
> +}
> +
> +module_init(vfio_pasid_init);
> +module_exit(vfio_pasid_exit);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 38d3c6a..74e077d 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -97,6 +97,34 @@ extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
>  extern void vfio_unregister_iommu_driver(
>  				const struct vfio_iommu_driver_ops *ops);
>  
> +struct vfio_mm;
> +#if IS_ENABLED(CONFIG_VFIO_PASID)
> +extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
> +extern void vfio_mm_put(struct vfio_mm *vmm);
> +extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> +extern void vfio_pasid_free_range(struct vfio_mm *vmm,
> +					ioasid_t min, ioasid_t max);
> +#else
> +static inline struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
> +{
> +	return NULL;
> +}
> +
> +static inline void vfio_mm_put(struct vfio_mm *vmm)
> +{
> +}
> +
> +static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> +{
> +	return -ENOTTY;
> +}
> +
> +static inline void vfio_pasid_free_range(struct vfio_mm *vmm,
> +					  ioasid_t min, ioasid_t max)
> +{
> +}
> +#endif /* CONFIG_VFIO_PASID */
> +
>  /*
>   * External user API
>   */


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A561329E5
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 16:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgAGPWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 10:22:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727944AbgAGPWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 10:22:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578410526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3J7p5DhBL2FGU3FgpuvPVeELoNahRGXPDHRoZa+Vi3M=;
        b=e1trPHhFHKGfRksVDPkv7Yvy3gUEdrwFJ2o7avBetnDr1fA4y4a0+OipI3G5vLx3FjL4Xa
        EhFNx+QAzBK3JGM1z/T1hQP64Ayt4O2q4t7C2ZmQq52yY/JMcYeyCWclWHH3Mq/iqB8pHD
        xeSMqTBtdWQgegzpbLMDgw4vlRqbgaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-atq9bkPuMKidfNMfwRWhGQ-1; Tue, 07 Jan 2020 10:22:04 -0500
X-MC-Unique: atq9bkPuMKidfNMfwRWhGQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6728801E6C;
        Tue,  7 Jan 2020 15:22:03 +0000 (UTC)
Received: from x1.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38F7A7BA50;
        Tue,  7 Jan 2020 15:22:03 +0000 (UTC)
Date:   Tue, 7 Jan 2020 08:22:02 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     weiqi <weiqi4@huawei.com>
Cc:     <alexander.h.duyck@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <x86@kernel.org>
Subject: Re: [PATCH 1/2] vfio: add mmap/munmap API for page hinting
Message-ID: <20200107082202.5ee90295@x1.home>
In-Reply-To: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
References: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
        <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jan 2020 22:46:38 +0800
weiqi <weiqi4@huawei.com> wrote:

> From: wei qi <weiqi4@huawei.com>
>=20
> add mmap/munmap API for page hinting.

AIUI, this is arbitrarily chunking IOMMU mappings into 512 pages (what
happens with 1G pages?) and creating a back channel for KVM to map and
unmap ranges that the user has mapped (why's it called "mmap"?).  Can't
we do this via the existing user API rather than directed via another
module?  For example, userspace can choose to map chunks of IOVA space
in whatever granularity they choose.  Clearly they can then unmap and
re-map chunks from those previous mappings.  Why can't KVM tell
userspace how and when to do this?  I'm really not in favor of back
channel paths like this, especially to unmap what a user has told us to
map.  Thanks,

Alex

> Signed-off-by: wei qi <weiqi4@huawei.com>
> ---
>  drivers/vfio/vfio.c             | 109 ++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c | 157 ++++++++++++++++++++++++++++++++++=
+++++-
>  include/linux/vfio.h            |  17 ++++-
>  3 files changed, 280 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c848262..c7e9103 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1866,6 +1866,115 @@ int vfio_set_irqs_validate_and_prepare(struct vfi=
o_irq_set *hdr, int num_irqs,
>  }
>  EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
> =20
> +int vfio_mmap_pages(struct device *dev, unsigned long user_pfn,
> +			unsigned long page_size, int prot,
> +			unsigned long pfn)
> +{
> +	struct vfio_container *container;
> +	struct vfio_group *group;
> +	struct vfio_iommu_driver *driver;
> +	int ret;
> +
> +	if (!dev || !user_pfn || !page_size)
> +		return -EINVAL;
> +
> +	group =3D vfio_group_get_from_dev(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	ret =3D vfio_group_add_container_user(group);
> +	if (ret)
> +		goto err_pin_pages;
> +
> +	container =3D group->container;
> +	driver =3D container->iommu_driver;
> +	if (likely(driver && driver->ops->mmap_pages))
> +		ret =3D driver->ops->mmap_pages(container->iommu_data, user_pfn,
> +					page_size, prot, pfn);
> +	else
> +		ret =3D -ENOTTY;
> +
> +	vfio_group_try_dissolve_container(group);
> +
> +err_pin_pages:
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mmap_pages);
> +
> +int vfio_munmap_pages(struct device *dev, unsigned long user_pfn,
> +			unsigned long page_size)
> +{
> +	struct vfio_container *container;
> +	struct vfio_group *group;
> +	struct vfio_iommu_driver *driver;
> +	int ret;
> +
> +	if (!dev || !user_pfn || !page_size)
> +		return -EINVAL;
> +
> +	group =3D vfio_group_get_from_dev(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	ret =3D vfio_group_add_container_user(group);
> +	if (ret)
> +		goto err_pin_pages;
> +
> +	container =3D group->container;
> +	driver =3D container->iommu_driver;
> +	if (likely(driver && driver->ops->munmap_pages))
> +		ret =3D driver->ops->munmap_pages(container->iommu_data, user_pfn,
> +						page_size);
> +	else
> +		ret =3D -ENOTTY;
> +
> +	vfio_group_try_dissolve_container(group);
> +
> +err_pin_pages:
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_munmap_pages);
> +
> +int vfio_dma_find(struct device *dev, unsigned long user_pfn, int npage,
> +		unsigned long *phys_pfn)
> +{
> +	struct vfio_container *container;
> +	struct vfio_group *group;
> +	struct vfio_iommu_driver *driver;
> +	int ret;
> +
> +	if (!dev || !user_pfn || !npage || !phys_pfn)
> +		return -EINVAL;
> +
> +	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
> +		return -E2BIG;
> +
> +	group =3D vfio_group_get_from_dev(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	ret =3D vfio_group_add_container_user(group);
> +	if (ret)
> +		goto err_pin_pages;
> +
> +	container =3D group->container;
> +	driver =3D container->iommu_driver;
> +	if (driver && driver->ops->dma_find)
> +		ret =3D driver->ops->dma_find(container->iommu_data, user_pfn,
> +					npage, phys_pfn);
> +	else
> +		ret =3D -ENOTTY;
> +
> +	vfio_group_try_dissolve_container(group);
> +
> +err_pin_pages:
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL(vfio_dma_find);
> +
>  /*
>   * Pin a set of guest PFNs and return their associated host PFNs for loc=
al
>   * domain only.
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 2ada8e6..df115dc 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -414,7 +414,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dm=
a, unsigned long vaddr,
>  		goto out;
> =20
>  	/* Lock all the consecutive pages from pfn_base */
> -	for (vaddr +=3D PAGE_SIZE, iova +=3D PAGE_SIZE; pinned < npage;
> +	for (vaddr +=3D PAGE_SIZE, iova +=3D PAGE_SIZE; (pinned < npage && pinn=
ed < 512);
>  	     pinned++, vaddr +=3D PAGE_SIZE, iova +=3D PAGE_SIZE) {
>  		ret =3D vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
>  		if (ret)
> @@ -768,7 +768,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu=
, struct vfio_dma *dma,
>  		phys_addr_t phys, next;
> =20
>  		phys =3D iommu_iova_to_phys(domain->domain, iova);
> -		if (WARN_ON(!phys)) {
> +		if (!phys) {
>  			iova +=3D PAGE_SIZE;
>  			continue;
>  		}
> @@ -1154,6 +1154,156 @@ static int vfio_dma_do_map(struct vfio_iommu *iom=
mu,
>  	return ret;
>  }
> =20
> +static int vfio_iommu_type1_munmap_pages(void *iommu_data,
> +					unsigned long user_pfn,
> +					unsigned long page_size)
> +{
> +	struct vfio_iommu *iommu =3D iommu_data;
> +	struct vfio_domain *domain;
> +	struct vfio_dma *dma;
> +	dma_addr_t iova =3D user_pfn  << PAGE_SHIFT;
> +	int ret =3D 0;
> +	phys_addr_t phys;
> +	size_t unmapped;
> +	long unlocked =3D 0;
> +
> +	if (!iommu || !user_pfn || !page_size)
> +		return -EINVAL;
> +
> +	/* Supported for v2 version only */
> +	if (!iommu->v2)
> +		return -EACCES;
> +
> +	mutex_lock(&iommu->lock);
> +	dma =3D vfio_find_dma(iommu, iova, page_size);
> +	if (!dma) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	domain =3D list_first_entry(&iommu->domain_list,
> +			struct vfio_domain, next);
> +	phys =3D iommu_iova_to_phys(domain->domain, iova);
> +	if (!phys) {
> +		goto out_unlock;
> +	} else {
> +		unmapped =3D iommu_unmap(domain->domain, iova, page_size);
> +		unlocked =3D vfio_unpin_pages_remote(dma, iova,
> +					phys >> PAGE_SHIFT,
> +					unmapped >> PAGE_SHIFT, true);
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_mmap_pages(void *iommu_data,
> +				unsigned long user_pfn,
> +				unsigned long page_size, int prot,
> +				unsigned long pfn)
> +{
> +	struct vfio_iommu *iommu =3D iommu_data;
> +	struct vfio_domain *domain;
> +	struct vfio_dma *dma;
> +	dma_addr_t iova =3D user_pfn  << PAGE_SHIFT;
> +	int ret =3D 0;
> +	size_t unmapped;
> +	phys_addr_t phys;
> +	long unlocked =3D 0;
> +
> +	if (!iommu || !user_pfn || !page_size || !pfn)
> +		return -EINVAL;
> +
> +	/* Supported for v2 version only */
> +	if (!iommu->v2)
> +		return -EACCES;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret =3D -EACCES;
> +		goto out_unlock;
> +	}
> +
> +	dma =3D vfio_find_dma(iommu, iova, page_size);
> +	if (!dma) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	domain =3D list_first_entry(&iommu->domain_list,
> +		struct vfio_domain, next);
> +
> +	phys =3D iommu_iova_to_phys(domain->domain, iova);
> +	if (phys) {
> +		unmapped =3D iommu_unmap(domain->domain, iova, page_size);
> +		unlocked =3D vfio_unpin_pages_remote(dma, iova,
> +					phys >> PAGE_SHIFT,
> +					unmapped >> PAGE_SHIFT, false);
> +	}
> +
> +	ret =3D vfio_iommu_map(iommu, iova, pfn, page_size >> PAGE_SHIFT, prot);
> +	if (ret) {
> +		pr_warn("%s: gfn: %lx, pfn: %lx, npages=EF=BC=9A%lu\n", __func__,
> +			user_pfn, pfn, page_size >> PAGE_SHIFT);
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +u64 vfio_iommu_iova_to_phys(struct vfio_iommu *iommu, dma_addr_t iova)
> +{
> +	struct vfio_domain *d;
> +	u64 phys;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		phys =3D iommu_iova_to_phys(d->domain, iova);
> +		if (phys)
> +			return phys;
> +	}
> +	return 0;
> +}
> +
> +static int vfio_iommu_type1_dma_find(void *iommu_data,
> +					unsigned long user_pfn,
> +					int npage, unsigned long *phys_pfn)
> +{
> +	struct vfio_iommu *iommu =3D iommu_data;
> +	int i =3D 0;
> +	struct vfio_dma *dma;
> +	u64 phys;
> +	dma_addr_t iova;
> +
> +	if (!iommu || !user_pfn)
> +		return -EINVAL;
> +
> +	/* Supported for v2 version only */
> +	if (!iommu->v2)
> +		return -EACCES;
> +
> +	 mutex_lock(&iommu->lock);
> +
> +	iova =3D user_pfn << PAGE_SHIFT;
> +	dma =3D vfio_find_dma(iommu, iova, PAGE_SIZE);
> +	if (!dma)
> +		goto unpin_exit;
> +
> +	if (((user_pfn + npage) << PAGE_SHIFT) <=3D (dma->iova + dma->size))
> +		i =3D npage;
> +	else
> +		goto unpin_exit;
> +
> +	phys =3D vfio_iommu_iova_to_phys(iommu, iova);
> +	*phys_pfn =3D phys >> PAGE_SHIFT;
> +
> +unpin_exit:
> +	mutex_unlock(&iommu->lock);
> +	return i;
> +}
> +
>  static int vfio_bus_type(struct device *dev, void *data)
>  {
>  	struct bus_type **bus =3D data;
> @@ -2336,6 +2486,9 @@ static int vfio_iommu_type1_unregister_notifier(voi=
d *iommu_data,
>  	.detach_group		=3D vfio_iommu_type1_detach_group,
>  	.pin_pages		=3D vfio_iommu_type1_pin_pages,
>  	.unpin_pages		=3D vfio_iommu_type1_unpin_pages,
> +	.mmap_pages             =3D vfio_iommu_type1_mmap_pages,
> +	.munmap_pages           =3D vfio_iommu_type1_munmap_pages,
> +	.dma_find		=3D vfio_iommu_type1_dma_find,
>  	.register_notifier	=3D vfio_iommu_type1_register_notifier,
>  	.unregister_notifier	=3D vfio_iommu_type1_unregister_notifier,
>  };
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e42a711..d7df495 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -77,6 +77,15 @@ struct vfio_iommu_driver_ops {
>  				     unsigned long *phys_pfn);
>  	int		(*unpin_pages)(void *iommu_data,
>  				       unsigned long *user_pfn, int npage);
> +	int		(*mmap_pages)(void *iommu_data,
> +					unsigned long user_pfn,
> +					unsigned long page_size,
> +					int prot, unsigned long pfn);
> +	int		(*munmap_pages)(void *iommu_data,
> +					unsigned long user_pfn,
> +					unsigned long page_size);
> +	int		(*dma_find)(void *iommu_data, unsigned long user_pfn,
> +					int npage, unsigned long *phys_pfn);
>  	int		(*register_notifier)(void *iommu_data,
>  					     unsigned long *events,
>  					     struct notifier_block *nb);
> @@ -106,7 +115,13 @@ extern int vfio_pin_pages(struct device *dev, unsign=
ed long *user_pfn,
>  			  int npage, int prot, unsigned long *phys_pfn);
>  extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
>  			    int npage);
> -
> +extern int vfio_dma_find(struct device *dev, unsigned long user_pfn, int=
 npage,
> +			unsigned long *phys_pfn);
> +extern int vfio_mmap_pages(struct device *dev, unsigned long user_pfn,
> +			unsigned long page_size, int prot,
> +			unsigned long pfn);
> +extern int vfio_munmap_pages(struct device *dev, unsigned long user_pfn,
> +			unsigned long page_size);
>  /* each type has independent events */
>  enum vfio_notify_type {
>  	VFIO_IOMMU_NOTIFY =3D 0,


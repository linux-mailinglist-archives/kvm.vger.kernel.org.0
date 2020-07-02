Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B4212EB9
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 23:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGBVT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 17:19:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbgGBVT4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 17:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593724793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ob6hHbPxLGOyXW7RE1qqfvlUnEHzS8rOI4dsX5gDuzs=;
        b=MSSS0hmjf3PkMajkkqMCNe6ZuSUjgvf4toWIst/M7BlYLKZN04p6Ky4R28aFGcXdd4DO8U
        3S/IfQ/DEEcZItqxo8ZtWOBPYli/0WKRipDGjEAaIQ/U0i4P1BdyQzJzPJgCpPlSOCKBom
        6pz6VXmlr8ScTMVbxEjI+fFp0RRYi7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-wMaI9nodPBKaHw3go4uXyQ-1; Thu, 02 Jul 2020 17:19:50 -0400
X-MC-Unique: wMaI9nodPBKaHw3go4uXyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D54F18FE868;
        Thu,  2 Jul 2020 21:19:48 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52DF75C28E;
        Thu,  2 Jul 2020 21:19:42 +0000 (UTC)
Date:   Thu, 2 Jul 2020 15:19:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/14] vfio/type1: Support binding guest page tables
 to PASID
Message-ID: <20200702151941.2bc63f10@x1.home>
In-Reply-To: <1592988927-48009-10-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-10-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 01:55:22 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> Nesting translation allows two-levels/stages page tables, with 1st level
> for guest translations (e.g. GVA->GPA), 2nd level for host translations
> (e.g. GPA->HPA). This patch adds interface for binding guest page tables
> to a PASID. This PASID must have been allocated to user space before the
> binding request.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v2 -> v3:
> *) use __iommu_sva_unbind_gpasid() for unbind call issued by VFIO
> https://lore.kernel.org/linux-iommu/1592931837-58223-6-git-send-email-jacob.jun.pan@linux.intel.com/
> 
> v1 -> v2:
> *) rename subject from "vfio/type1: Bind guest page tables to host"
> *) remove VFIO_IOMMU_BIND, introduce VFIO_IOMMU_NESTING_OP to support bind/
>    unbind guet page table
> *) replaced vfio_iommu_for_each_dev() with a group level loop since this
>    series enforces one group per container w/ nesting type as start.
> *) rename vfio_bind/unbind_gpasid_fn() to vfio_dev_bind/unbind_gpasid_fn()
> *) vfio_dev_unbind_gpasid() always successful
> *) use vfio_mm->pasid_lock to avoid race between PASID free and page table
>    bind/unbind
> ---
>  drivers/vfio/vfio_iommu_type1.c | 169 ++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_pasid.c       |  30 +++++++
>  include/linux/vfio.h            |  20 +++++
>  include/uapi/linux/vfio.h       |  30 +++++++
>  4 files changed, 249 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d0891c5..5926533 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -148,6 +148,33 @@ struct vfio_regions {
>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>  
> +struct domain_capsule {
> +	struct vfio_group *group;
> +	struct iommu_domain *domain;
> +	void *data;
> +};
> +
> +/* iommu->lock must be held */
> +static struct vfio_group *vfio_find_nesting_group(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +	struct vfio_group *g, *group = NULL;
> +
> +	if (!iommu->nesting_info)
> +		return NULL;
> +
> +	/* only support singleton container with nesting type */
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		list_for_each_entry(g, &d->group_list, next) {
> +			if (!group) {
> +				group = g;
> +				break;
> +			}


We break out of the inner loop only to pointlessly continue in the
outer loop when we could simply return g and remove the second group
pointer altogether (use "group" instead of "g" if so).


> +		}
> +	}
> +	return group;
> +}
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> @@ -2351,6 +2378,48 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *) dc->data;
> +
> +	return iommu_sva_bind_gpasid(dc->domain, dev, (void __user *) arg);
> +}
> +
> +static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *) dc->data;
> +
> +	iommu_sva_unbind_gpasid(dc->domain, dev, (void __user *) arg);
> +	return 0;
> +}
> +
> +static int __vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *unbind_data =
> +				(struct iommu_gpasid_bind_data *) dc->data;
> +
> +	__iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
> +	return 0;
> +}
> +
> +static void vfio_group_unbind_gpasid_fn(ioasid_t pasid, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *) data;
> +	struct iommu_gpasid_bind_data unbind_data;
> +
> +	unbind_data.argsz = offsetof(struct iommu_gpasid_bind_data, vendor);
> +	unbind_data.flags = 0;
> +	unbind_data.hpasid = pasid;
> +
> +	dc->data = &unbind_data;
> +
> +	iommu_group_for_each_dev(dc->group->iommu_group,
> +				 dc, __vfio_dev_unbind_gpasid_fn);
> +}
> +
>  static void vfio_iommu_type1_detach_group(void *iommu_data,
>  					  struct iommu_group *iommu_group)
>  {
> @@ -2394,6 +2463,21 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		if (!group)
>  			continue;
>  
> +		if (iommu->nesting_info && iommu->vmm &&
> +		    (iommu->nesting_info->features &
> +					IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> +			struct domain_capsule dc = { .group = group,
> +						     .domain = domain->domain,
> +						     .data = NULL };
> +
> +			/*
> +			 * Unbind page tables bound with system wide PASIDs
> +			 * which are allocated to user space.
> +			 */
> +			vfio_mm_for_each_pasid(iommu->vmm, &dc,
> +					       vfio_group_unbind_gpasid_fn);
> +		}
> +
>  		vfio_iommu_detach_group(domain, group);
>  		update_dirty_scope = !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
> @@ -2942,6 +3026,89 @@ static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
>  	}
>  }
>  
> +static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
> +				       bool is_bind, unsigned long arg)
> +{
> +	struct iommu_nesting_info *info;
> +	struct domain_capsule dc = { .data = &arg };
> +	struct vfio_group *group;
> +	struct vfio_domain *domain;
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	info = iommu->nesting_info;
> +	if (!info || !(info->features & IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> +		ret = -ENOTSUPP;
> +		goto out_unlock_iommu;
> +	}
> +
> +	if (!iommu->vmm) {
> +		ret = -EINVAL;
> +		goto out_unlock_iommu;
> +	}
> +
> +	group = vfio_find_nesting_group(iommu);
> +	if (!group) {
> +		ret = -EINVAL;
> +		goto out_unlock_iommu;
> +	}
> +
> +	domain = list_first_entry(&iommu->domain_list,
> +				      struct vfio_domain, next);
> +	dc.group = group;
> +	dc.domain = domain->domain;
> +
> +	/* Avoid race with other containers within the same process */
> +	vfio_mm_pasid_lock(iommu->vmm);
> +
> +	if (is_bind) {
> +		ret = iommu_group_for_each_dev(group->iommu_group, &dc,
> +					       vfio_dev_bind_gpasid_fn);
> +		if (ret)
> +			iommu_group_for_each_dev(group->iommu_group, &dc,
> +						 vfio_dev_unbind_gpasid_fn);
> +	} else {
> +		iommu_group_for_each_dev(group->iommu_group,
> +					 &dc, vfio_dev_unbind_gpasid_fn);
> +		ret = 0;
> +	}
> +
> +	vfio_mm_pasid_unlock(iommu->vmm);
> +out_unlock_iommu:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
> +					unsigned long arg)
> +{
> +	struct vfio_iommu_type1_nesting_op hdr;
> +	unsigned int minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_iommu_type1_nesting_op, flags);
> +
> +	if (copy_from_user(&hdr, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (hdr.argsz < minsz || hdr.flags & ~VFIO_NESTING_OP_MASK)
> +		return -EINVAL;
> +
> +	switch (hdr.flags & VFIO_NESTING_OP_MASK) {
> +	case VFIO_IOMMU_NESTING_OP_BIND_PGTBL:
> +		ret = vfio_iommu_handle_pgtbl_op(iommu, true, arg + minsz);
> +		break;
> +	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
> +		ret = vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2960,6 +3127,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
>  	case VFIO_IOMMU_PASID_REQUEST:
>  		return vfio_iommu_type1_pasid_request(iommu, arg);
> +	case VFIO_IOMMU_NESTING_OP:
> +		return vfio_iommu_type1_nesting_op(iommu, arg);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> index 2ea9f1a..20f1e72 100644
> --- a/drivers/vfio/vfio_pasid.c
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -30,6 +30,7 @@ struct vfio_mm {
>  	struct kref		kref;
>  	struct vfio_mm_token	token;
>  	int			ioasid_sid;
> +	struct mutex		pasid_lock;


Introducing holes in the data structure again, mind the alignment.
This wastes 8 byte.  Thanks,

Alex


>  	int			pasid_quota;
>  	struct list_head	next;
>  };
> @@ -97,6 +98,7 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
>  	kref_init(&vmm->kref);
>  	vmm->token.val = (unsigned long long) mm;
>  	vmm->pasid_quota = pasid_quota;
> +	mutex_init(&vmm->pasid_lock);
>  
>  	list_add(&vmm->next, &vfio_pasid.vfio_mm_list);
>  out:
> @@ -134,12 +136,40 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
>  	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
>  	 * teardown necessary structures depending on the to-be-freed
>  	 * PASID.
> +	 * Hold pasid_lock to avoid race with PASID usages like bind/
> +	 * unbind page tables to requested PASID.
>  	 */
> +	mutex_lock(&vmm->pasid_lock);
>  	for (; pasid <= max; pasid++)
>  		ioasid_free(pasid);
> +	mutex_unlock(&vmm->pasid_lock);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
>  
> +int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
> +			   void (*fn)(ioasid_t id, void *data))
> +{
> +	int ret;
> +
> +	mutex_lock(&vmm->pasid_lock);
> +	ret = ioasid_set_for_each_ioasid(vmm->ioasid_sid, fn, data);
> +	mutex_unlock(&vmm->pasid_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_for_each_pasid);
> +
> +void vfio_mm_pasid_lock(struct vfio_mm *vmm)
> +{
> +	mutex_lock(&vmm->pasid_lock);
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_lock);
> +
> +void vfio_mm_pasid_unlock(struct vfio_mm *vmm)
> +{
> +	mutex_unlock(&vmm->pasid_lock);
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_unlock);
> +
>  static int __init vfio_pasid_init(void)
>  {
>  	mutex_init(&vfio_pasid.vfio_mm_lock);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 8e60a32..9028a09 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -105,6 +105,11 @@ int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
>  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
>  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
>  					ioasid_t min, ioasid_t max);
> +extern int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
> +				  void (*fn)(ioasid_t id, void *data));
> +extern void vfio_mm_pasid_lock(struct vfio_mm *vmm);
> +extern void vfio_mm_pasid_unlock(struct vfio_mm *vmm);
> +
>  #else
>  static inline struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
>  {
> @@ -129,6 +134,21 @@ static inline void vfio_pasid_free_range(struct vfio_mm *vmm,
>  					  ioasid_t min, ioasid_t max)
>  {
>  }
> +
> +static inline int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
> +					 void (*fn)(ioasid_t id, void *data))
> +{
> +	return -ENOTTY;
> +}
> +
> +static inline void vfio_mm_pasid_lock(struct vfio_mm *vmm)
> +{
> +}
> +
> +static inline void vfio_mm_pasid_unlock(struct vfio_mm *vmm)
> +{
> +}
> +
>  #endif /* CONFIG_VFIO_PASID */
>  
>  /*
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 657b2db..2c9def8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1198,6 +1198,36 @@ struct vfio_iommu_type1_pasid_request {
>  
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
>  
> +/**
> + * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 19,
> + *				struct vfio_iommu_type1_nesting_op)
> + *
> + * This interface allows user space to utilize the nesting IOMMU
> + * capabilities as reported through VFIO_IOMMU_GET_INFO.
> + *
> + * @data[] types defined for each op:
> + * +=================+===============================================+
> + * | NESTING OP      |                  @data[]                      |
> + * +=================+===============================================+
> + * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
> + * +-----------------+-----------------------------------------------+
> + * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
> + * +-----------------+-----------------------------------------------+
> + *
> + * returns: 0 on success, -errno on failure.
> + */
> +struct vfio_iommu_type1_nesting_op {
> +	__u32	argsz;
> +	__u32	flags;
> +#define VFIO_NESTING_OP_MASK	(0xffff) /* lower 16-bits for op */
> +	__u8	data[];
> +};
> +
> +#define VFIO_IOMMU_NESTING_OP_BIND_PGTBL	(0)
> +#define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL	(1)
> +
> +#define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*


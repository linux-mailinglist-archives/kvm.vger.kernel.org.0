Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD45224575B
	for <lists+kvm@lfdr.de>; Sun, 16 Aug 2020 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgHPLbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 07:31:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729089AbgHPL3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 07:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597577377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o5cAWUQRA5XB1MFHVWhDK++WAr/4C79VFKZZhmoXBWE=;
        b=SqB/iintMNNd3g4rgtPmRG7EueligqK3dBKVX4lmFRdp+CYHvTfNK+ULE4RD2YyTTPRTYC
        zRoZyvZuW3zYmMipjPNQhRC/eqg/kFYxWhSgXiMPtJoE+YUQtN5j0KywgzJrHSznybfp4j
        fm6hs835kZTLouDmUGFWDjFgVuxHJRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-07dPfwgYOYCOxj4sxI6T8g-1; Sun, 16 Aug 2020 07:29:35 -0400
X-MC-Unique: 07dPfwgYOYCOxj4sxI6T8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19630100558D;
        Sun, 16 Aug 2020 11:29:33 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF8E55C1DA;
        Sun, 16 Aug 2020 11:29:20 +0000 (UTC)
Subject: Re: [PATCH v6 10/15] vfio/type1: Support binding guest page tables to
 PASID
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-11-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d54e0327-70cb-d58e-e521-e647f0cc024b@redhat.com>
Date:   Sun, 16 Aug 2020 13:29:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1595917664-33276-11-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/28/20 8:27 AM, Liu Yi L wrote:
> Nesting translation allows two-levels/stages page tables, with 1st level
> for guest translations (e.g. GVA->GPA), 2nd level for host translations
> (e.g. GPA->HPA). This patch adds interface for binding guest page tables
> to a PASID. This PASID must have been allocated by the userspace before
> the binding request.
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
> v5 -> v6:
> *) dropped vfio_find_nesting_group() and add vfio_get_nesting_domain_capsule().
>    per comment from Eric.
> *) use iommu_uapi_sva_bind/unbind_gpasid() and iommu_sva_unbind_gpasid() in
>    linux/iommu.h for userspace operation and in-kernel operation.
> 
> v3 -> v4:
> *) address comments from Alex on v3
> 
> v2 -> v3:
> *) use __iommu_sva_unbind_gpasid() for unbind call issued by VFIO
>    https://lore.kernel.org/linux-iommu/1592931837-58223-6-git-send-email-jacob.jun.pan@linux.intel.com/
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
>  drivers/vfio/vfio_iommu_type1.c | 161 ++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_pasid.c       |  26 +++++++
>  include/linux/vfio.h            |  20 +++++
>  include/uapi/linux/vfio.h       |  31 ++++++++
>  4 files changed, 238 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ea89c7c..245436e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -149,6 +149,36 @@ struct vfio_regions {
>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>  
> +struct domain_capsule {
> +	struct vfio_group *group;
> +	struct iommu_domain *domain;
> +	void *data;
You may add a bool indicating whether the data is a user pointer or the
direct IOMMU UAPI struct.
> +};
> +
> +/* iommu->lock must be held */
> +static int vfio_get_nesting_domain_capsule(struct vfio_iommu *iommu,
> +					   struct domain_capsule *dc)
I would rename the function into vfio_prepare_nesting_domain_capsule
> +{
> +	struct vfio_domain *domain = NULL;
> +	struct vfio_group *group = NULL;
> +
> +	if (!iommu->nesting_info)
> +		return -EINVAL;
> +
> +	/*
> +	 * Only support singleton container with nesting type.
> +	 * If nesting_info is non-NULL, the conatiner should
s/should/is here and below
s/conatiner/container
> +	 * be non-empty. Also domain should be non-empty.
> +	 */
> +	domain = list_first_entry(&iommu->domain_list,
> +				  struct vfio_domain, next);
> +	group = list_first_entry(&domain->group_list,
> +				 struct vfio_group, next);
> +	dc->group = group;
> +	dc->domain = domain->domain;
dc->user = true;?
> +	return 0;
> +}
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> @@ -2349,6 +2379,48 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *)dc->data;
> +
> +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev, (void __user *)arg);
> +}
> +
> +static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *)dc->data;
> +
> +	iommu_uapi_sva_unbind_gpasid(dc->domain, dev, (void __user *)arg);
> +	return 0;
> +}
> +
> +static int __vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
can be removed if dc->user flag gets added
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *unbind_data =
> +				(struct iommu_gpasid_bind_data *)dc->data;
> +
> +	iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
> +	return 0;
> +}
> +
> +static void vfio_group_unbind_gpasid_fn(ioasid_t pasid, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data unbind_data;
> +
> +	unbind_data.argsz = offsetof(struct iommu_gpasid_bind_data, vendor);
I do not remember to have seen this documented anywhere, ie. on unbind,
the vendor data are not used.
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
> @@ -2392,6 +2464,21 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		if (!group)
>  			continue;
>  
> +		if (iommu->nesting_info && iommu->vmm &&
if vmm is set, doesn't it mean nesting_info is set?
> +		    (iommu->nesting_info->features &
> +					IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> +			struct domain_capsule dc = { .group = group,
> +						     .domain = domain->domain,
> +						     .data = NULL };
> +
> +			/*
> +			 * Unbind page tables bound with system wide PASIDs
> +			 * which are allocated to userspace.
> +			 */
> +			vfio_mm_for_each_pasid(iommu->vmm, &dc,
> +					       vfio_group_unbind_gpasid_fn);
> +		}
> +
>  		vfio_iommu_detach_group(domain, group);
>  		update_dirty_scope = !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
> @@ -2926,6 +3013,78 @@ static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
> +				       bool is_bind, unsigned long arg)
> +{
> +	struct domain_capsule dc = { .data = &arg };
> +	struct iommu_nesting_info *info;
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	info = iommu->nesting_info;
> +	if (!info || !(info->features & IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
> +
> +	if (!iommu->vmm) {
Is it documented anywhere, besides in this commit message that
IOMMU_NESTING_FEAT_BIND_PGTBL requires IOMMU_NESTING_FEAT_SYSWIDE_PASID
(in uapi doc)?
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret = vfio_get_nesting_domain_capsule(iommu, &dc);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* Avoid race with other containers within the same process */
> +	vfio_mm_pasid_lock(iommu->vmm);
> +
> +	ret = 0;
non needed
> +	if (is_bind)
> +		ret = iommu_group_for_each_dev(dc.group->iommu_group, &dc,
> +					       vfio_dev_bind_gpasid_fn);
> +	if (ret || !is_bind) {
> +		iommu_group_for_each_dev(dc.group->iommu_group,
> +					 &dc, vfio_dev_unbind_gpasid_fn);
> +		ret = 0;
ret is not correct in case bind previously failed. You should return the
original ret in that case.
> +	}
> +
> +	vfio_mm_pasid_unlock(iommu->vmm);
> +out_unlock:
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
Checking against VFIO_NESTING_OP_MASK is not enough precise enough (I
mean OP_MASK should only encompasses the actual supported ops). If a a
userspace tries to use a new OP in the future and if this runs on this
kernel version, you will fait to recognize the lack of support.
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
> @@ -2944,6 +3103,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
>  	case VFIO_IOMMU_PASID_REQUEST:
>  		return vfio_iommu_type1_pasid_request(iommu, arg);
> +	case VFIO_IOMMU_NESTING_OP:
> +		return vfio_iommu_type1_nesting_op(iommu, arg);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> index 8d0317f..e531d4a 100644
> --- a/drivers/vfio/vfio_pasid.c
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -221,6 +221,8 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
>  	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
>  	 * teardown necessary structures depending on the to-be-freed
>  	 * PASID.
> +	 * Hold pasid_lock also avoids race with PASID usages like bind/
> +	 * unbind page tables to requested PASID.
>  	 */
>  	mutex_lock(&vmm->pasid_lock);
>  	while ((vid = vfio_find_pasid(vmm, min, max)) != NULL)
> @@ -229,6 +231,30 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
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
>  	mutex_init(&vfio_mm_lock);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index a355d01..e835c23 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -105,6 +105,11 @@ extern int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
>  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
>  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
>  				  ioasid_t min, ioasid_t max);
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
> index 6d79557..9501cfb 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1209,6 +1209,37 @@ struct vfio_iommu_type1_pasid_request {
>  
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
>  
> +/**
> + * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 19,
> + *				struct vfio_iommu_type1_nesting_op)
> + *
> + * This interface allows userspace to utilize the nesting IOMMU
> + * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
> + * cap through VFIO_IOMMU_GET_INFO.
PASID alloc/free are handled through another IOCTL so you should be more
precise I think.
> + *
> + * @data[] types defined for each op:
> + * +=================+===============================================+
> + * | NESTING OP      |      @data[]                                  |
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
> 
Thanks

Eric


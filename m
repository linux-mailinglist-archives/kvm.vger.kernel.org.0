Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D75225A18
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 10:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGTIdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 04:33:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23241 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725815AbgGTIdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 04:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595234016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jxZwtU6jCdNzDDA32p8x0Lt0O/6ubHPtsEvyLzyrp7M=;
        b=e9e23tWOMyqd8t7wuIjXm0hLNciuJfW3wUsali6Z+Fo8lnEsGbocDbqhkCjUoKoLgj4mM1
        +SWWa+L1WKPJLDqO0G8oZis/ejNt+aPP40pPfFpz91CHFJOYAvM99JhfnLZUhR16U3JRJK
        k1JjuZ5F6Tz45nG3zHOswaF8BPVYQuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-dz-TmbyxOae8XgGzqkDTYA-1; Mon, 20 Jul 2020 04:33:28 -0400
X-MC-Unique: dz-TmbyxOae8XgGzqkDTYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFC0D1080;
        Mon, 20 Jul 2020 08:33:26 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24B435C240;
        Mon, 20 Jul 2020 08:33:15 +0000 (UTC)
Subject: Re: [PATCH v5 04/15] vfio/type1: Report iommu nesting info to
 userspace
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-5-git-send-email-yi.l.liu@intel.com>
 <2eb692fc-a399-8298-4b4b-68adb0357404@redhat.com>
 <DM5PR11MB1435AF9531C5CF29CD1D1251C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <34931d94-b63b-e366-3c7f-9fd85c8e982d@redhat.com>
Date:   Mon, 20 Jul 2020 10:33:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB1435AF9531C5CF29CD1D1251C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/20/20 9:51 AM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric <eric.auger@redhat.com>
>> Sent: Saturday, July 18, 2020 1:34 AM
>>
>> Yi,
>>
>> On 7/12/20 1:20 PM, Liu Yi L wrote:
>>> This patch exports iommu nesting capability info to user space through
>>> VFIO. User space is expected to check this info for supported uAPIs (e.g.
>> it is not only to check the supported uAPIS but rather to know which
>> callbacks it must call upon vIOMMU events and which features are
>> supported by the physical IOMMU.
> 
> yes, will refine the description per your comment.
> 
>>> PASID alloc/free, bind page table, and cache invalidation) and the vendor
>>> specific format information for first level/stage page table that will be
>>> bound to.
>>>
>>> The nesting info is available only after the nesting iommu type is set
>>> for a container.
>> to NESTED type
> 
> you mean "The nesting info is available only after container set to be NESTED type."
> 
> right?
correct
> 
>>  Current implementation imposes one limitation - one
>>> nesting container should include at most one group. The philosophy of
>>> vfio container is having all groups/devices within the container share
>>> the same IOMMU context. When vSVA is enabled, one IOMMU context could
>>> include one 2nd-level address space and multiple 1st-level address spaces.
>>> While the 2nd-level address space is reasonably sharable by multiple groups
>>> , blindly sharing 1st-level address spaces across all groups within the
>>> container might instead break the guest expectation. In the future sub/
>>> super container concept might be introduced to allow partial address space
>>> sharing within an IOMMU context. But for now let's go with this restriction
>>> by requiring singleton container for using nesting iommu features. Below
>>> link has the related discussion about this decision.
>>
>> Maybe add a note about SMMU related changes spotted by Jean.
> 
> I guess you mean the comments Jean gave in patch 3/15, right? I'll
> copy his comments and also give the below link as well.
> 
> https://lore.kernel.org/kvm/20200717090900.GC4850@myrica/
correct

Thanks

Eric
> 
>>>
>>> https://lkml.org/lkml/2020/5/15/1028
>>>
>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: Eric Auger <eric.auger@redhat.com>
>>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>> ---
>>> v4 -> v5:
>>> *) address comments from Eric Auger.
>>> *) return struct iommu_nesting_info for
>> VFIO_IOMMU_TYPE1_INFO_CAP_NESTING as
>>>    cap is much "cheap", if needs extension in future, just define another cap.
>>>    https://lore.kernel.org/kvm/20200708132947.5b7ee954@x1.home/
>>>
>>> v3 -> v4:
>>> *) address comments against v3.
>>>
>>> v1 -> v2:
>>> *) added in v2
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 102
>> +++++++++++++++++++++++++++++++++++-----
>>>  include/uapi/linux/vfio.h       |  19 ++++++++
>>>  2 files changed, 109 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 3bd70ff..ed80104 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -62,18 +62,20 @@ MODULE_PARM_DESC(dma_entry_limit,
>>>  		 "Maximum number of user DMA mappings per container (65535).");
>>>
>>>  struct vfio_iommu {
>>> -	struct list_head	domain_list;
>>> -	struct list_head	iova_list;
>>> -	struct vfio_domain	*external_domain; /* domain for external user */
>>> -	struct mutex		lock;
>>> -	struct rb_root		dma_list;
>>> -	struct blocking_notifier_head notifier;
>>> -	unsigned int		dma_avail;
>>> -	uint64_t		pgsize_bitmap;
>>> -	bool			v2;
>>> -	bool			nesting;
>>> -	bool			dirty_page_tracking;
>>> -	bool			pinned_page_dirty_scope;
>>> +	struct list_head		domain_list;
>>> +	struct list_head		iova_list;
>>> +	/* domain for external user */
>>> +	struct vfio_domain		*external_domain;
>>> +	struct mutex			lock;
>>> +	struct rb_root			dma_list;
>>> +	struct blocking_notifier_head	notifier;
>>> +	unsigned int			dma_avail;
>>> +	uint64_t			pgsize_bitmap;
>>> +	bool				v2;
>>> +	bool				nesting;
>>> +	bool				dirty_page_tracking;
>>> +	bool				pinned_page_dirty_scope;
>>> +	struct iommu_nesting_info	*nesting_info;
>>>  };
>>>
>>>  struct vfio_domain {
>>> @@ -130,6 +132,9 @@ struct vfio_regions {
>>>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>>>  					(!list_empty(&iommu->domain_list))
>>>
>>> +#define CONTAINER_HAS_DOMAIN(iommu)	(((iommu)->external_domain) || \
>>> +					 (!list_empty(&(iommu)->domain_list)))
>>> +
>>>  #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) /
>> BITS_PER_BYTE)
>>>
>>>  /*
>>> @@ -1929,6 +1934,13 @@ static void vfio_iommu_iova_insert_copy(struct
>> vfio_iommu *iommu,
>>>
>>>  	list_splice_tail(iova_copy, iova);
>>>  }
>>> +
>>> +static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
>>> +{
>>> +	kfree(iommu->nesting_info);
>>> +	iommu->nesting_info = NULL;
>>> +}
>>> +
>>>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>>>  					 struct iommu_group *iommu_group)
>>>  {
>>> @@ -1959,6 +1971,12 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>>>  		}
>>>  	}
>>>
>>> +	/* Nesting type container can include only one group */
>>> +	if (iommu->nesting && CONTAINER_HAS_DOMAIN(iommu)) {
>>> +		mutex_unlock(&iommu->lock);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>>  	group = kzalloc(sizeof(*group), GFP_KERNEL);
>>>  	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
>>>  	if (!group || !domain) {
>>> @@ -2029,6 +2047,32 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>>>  	if (ret)
>>>  		goto out_domain;
>>>
>>> +	/* Nesting cap info is available only after attaching */
>>> +	if (iommu->nesting) {
>>> +		struct iommu_nesting_info tmp = { .size = 0, };
>>> +
>>> +		/* First get the size of vendor specific nesting info */
>>> +		ret = iommu_domain_get_attr(domain->domain,
>>> +					    DOMAIN_ATTR_NESTING,
>>> +					    &tmp);
>>> +		if (ret)
>>> +			goto out_detach;
>>> +
>>> +		iommu->nesting_info = kzalloc(tmp.size, GFP_KERNEL);
>>> +		if (!iommu->nesting_info) {
>>> +			ret = -ENOMEM;
>>> +			goto out_detach;
>>> +		}
>>> +
>>> +		/* Now get the nesting info */
>>> +		iommu->nesting_info->size = tmp.size;
>>> +		ret = iommu_domain_get_attr(domain->domain,
>>> +					    DOMAIN_ATTR_NESTING,
>>> +					    iommu->nesting_info);
>>> +		if (ret)
>>> +			goto out_detach;
> 
> get nesting_info failure will result in group_attach failure.[1]
> 
>>> +	}
>>> +
>>>  	/* Get aperture info */
>>>  	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY,
>> &geo);
>>>
>>> @@ -2138,6 +2182,7 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>>>  	return 0;
>>>
>>>  out_detach:
>>> +	vfio_iommu_release_nesting_info(iommu);
>>>  	vfio_iommu_detach_group(domain, group);
>>>  out_domain:
>>>  	iommu_domain_free(domain->domain);
>>> @@ -2338,6 +2383,8 @@ static void vfio_iommu_type1_detach_group(void
>> *iommu_data,
>>>  					vfio_iommu_unmap_unpin_all(iommu);
>>>  				else
>>>
>> 	vfio_iommu_unmap_unpin_reaccount(iommu);
>>> +
>>> +				vfio_iommu_release_nesting_info(iommu);
>>>  			}
>>>  			iommu_domain_free(domain->domain);
>>>  			list_del(&domain->next);
>>> @@ -2546,6 +2593,31 @@ static int vfio_iommu_migration_build_caps(struct
>> vfio_iommu *iommu,
>>>  	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
>>>  }
>>>
>>> +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>>> +					   struct vfio_info_cap *caps)
>>> +{
>>> +	struct vfio_info_cap_header *header;
>>> +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
>>> +	size_t size;
>>> +
>>> +	size = offsetof(struct vfio_iommu_type1_info_cap_nesting, info) +
>>> +		iommu->nesting_info->size;
>>> +
>>> +	header = vfio_info_cap_add(caps, size,
>>> +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
>>> +	if (IS_ERR(header))
>>> +		return PTR_ERR(header);
>>> +
>>> +	nesting_cap = container_of(header,
>>> +				   struct vfio_iommu_type1_info_cap_nesting,
>>> +				   header);
>>> +
>>> +	memcpy(&nesting_cap->info, iommu->nesting_info,
>>> +	       iommu->nesting_info->size);
>> you must check whether nesting_info is non NULL before doing that.
> 
> it's now validated in the caller of this function. :-)
ah ok sorry I missed that.
>  
>> Besides I agree with Jean on the fact it may be better to not report the
>> capability if nested is not supported.
> 
> I see. in this patch, just few lines below [2], vfio only reports nesting
> cap when iommu->nesting_info is non-null. so even if userspace selected
> nesting type, it may fail at the VFIO_SET_IOMMU phase since group_attach
> will be failed for NESTED type container if host iommu doesn’t support
> nesting. the code is marked as [1] in this email.
OK that's already there then.

Thanks

Eric
> 
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>>>  				     unsigned long arg)
>>>  {
>>> @@ -2581,6 +2653,12 @@ static int vfio_iommu_type1_get_info(struct
>> vfio_iommu *iommu,
>>>  	if (!ret)
>>>  		ret = vfio_iommu_iova_build_caps(iommu, &caps);
>>>
>>> +	if (iommu->nesting_info) {
>>> +		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
>>> +		if (ret)
>>> +			return ret;
> 
> here checks nesting_info before reporting nesting cap. [2]
> 
>>> +	}
>>> +
>>>  	mutex_unlock(&iommu->lock);
>>>
>>>  	if (ret)
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index 9204705..46a78af 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -14,6 +14,7 @@
>>>
>>>  #include <linux/types.h>
>>>  #include <linux/ioctl.h>
>>> +#include <linux/iommu.h>
>>>
>>>  #define VFIO_API_VERSION	0
>>>
>>> @@ -1039,6 +1040,24 @@ struct vfio_iommu_type1_info_cap_migration {
>>>  	__u64	max_dirty_bitmap_size;		/* in bytes */
>>>  };
>>>
>>> +/*
>>> + * The nesting capability allows to report the related capability
>>> + * and info for nesting iommu type.
>>> + *
>>> + * The structures below define version 1 of this capability.
>>> + *
>>> + * User space selected VFIO_TYPE1_NESTING_IOMMU type should check
>>> + * this capto get supported features.
>> s/capto/capability to get
> 
> got it.
> 
> Regards,
> Yi Liu
> 
>>> + *
>>> + * @info: the nesting info provided by IOMMU driver.
>>> + */
>>> +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
>>> +
>>> +struct vfio_iommu_type1_info_cap_nesting {
>>> +	struct	vfio_info_cap_header header;
>>> +	struct iommu_nesting_info info;
>>> +};
>>> +
>>>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>>
>>>  /**
>>>
>>
>> Thanks
>>
>> Eric
> 


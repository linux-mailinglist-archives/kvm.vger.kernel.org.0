Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59D01AACD2
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410108AbgDOQC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:02:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2410089AbgDOQC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 12:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586966573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2EMmyfwDOhqKqegPiY43eoRXqZvWZppla3x2GSdLI4=;
        b=Eyq/VzVORa6EOUZEVvKinPQV8DKj6McHsB2ZXzwT0xxCs3D9yo8jpGlHxXYyLItiblS6I3
        rTRvUQ3fkC0IZvpycXGx7NDMZkcpNWd2Zq6CVZhMkVveGDyeKWaOwKJgXQHvDEutLk+TNQ
        X6LQH6RqMaghJ4yyfnLB+Bvji7oKO24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-qGT5X4sKOH6LuoScgTfedg-1; Wed, 15 Apr 2020 12:02:46 -0400
X-MC-Unique: qGT5X4sKOH6LuoScgTfedg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 921641005509;
        Wed, 15 Apr 2020 16:02:43 +0000 (UTC)
Received: from [10.36.115.53] (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B35A211D2D9;
        Wed, 15 Apr 2020 16:02:35 +0000 (UTC)
Subject: Re: [PATCH v11 01/13] iommu: Introduce attach/detach_pasid_table API
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, joro@8bytes.org,
        maz@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com,
        peter.maydell@linaro.org, zhangfei.gao@gmail.com, tn@semihalf.com,
        zhangfei.gao@foxmail.com, bbhushan2@marvell.com
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <20200414150607.28488-2-eric.auger@redhat.com>
 <20200414151548.658a0401@jacob-builder>
 <c781ce8d-7fe4-0fee-ba95-a1e493e003f5@redhat.com>
 <20200415085908.0e1803b7@jacob-builder>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e4f28607-8235-7a66-15ec-379bb559b0fd@redhat.com>
Date:   Wed, 15 Apr 2020 18:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200415085908.0e1803b7@jacob-builder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jacob,

On 4/15/20 5:59 PM, Jacob Pan wrote:
> On Wed, 15 Apr 2020 16:52:10 +0200
> Auger Eric <eric.auger@redhat.com> wrote:
> 
>> Hi Jacob,
>> On 4/15/20 12:15 AM, Jacob Pan wrote:
>>> Hi Eric,
>>>
>>> There are some discussions about how to size the uAPI data.
>>> https://lkml.org/lkml/2020/4/14/939
>>>
>>> I think the problem with the current scheme is that when uAPI data
>>> gets extended, if VFIO continue to use:
>>>
>>> minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table,
>>> config); if (copy_from_user(&spt, (void __user *)arg, minsz))
>>>
>>> It may copy more data from user than what was setup by the user.
>>>
>>> So, as suggested by Alex, we could add argsz to the IOMMU uAPI
>>> struct. So if argsz > minsz, then fail the attach_table since
>>> kernel might be old, doesn't know about the extra data.
>>> If argsz <= minsz, kernel can support the attach_table but must
>>> process the data based on flags or config.  
>>
>> So I guess we would need both an argsz _u32 + a new flag _u32 right?
>>
> Yes.
>> I am ok with that idea. Besides how will you manage for existing IOMMU
>> UAPIs?
> I plan to add argsz and flags (if not already have one)
> 
>> At some point you envisionned to have a getter at iommu api
>> level to retrieve the size of a structure for a given version, right?
>>
> This idea is shot down. There is no version-size lookup.
> So the current plan is for user to fill out argsz in each IOMMU uAPI
> struct. VFIO does the copy_from_user() based on argsz (sanitized
> against the size of current kernel struct).
> 
> IOMMU vendor driver process the data based on flags which indicates
> new capability/extensions.
OK. Sounds sensible

Thanks

Eric
> 
>> Thanks
>>
>> Eric
>>>
>>> Does it make sense to you?
>>>
>>>
>>> On Tue, 14 Apr 2020 17:05:55 +0200
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>   
>>>> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>>>
>>>> In virtualization use case, when a guest is assigned
>>>> a PCI host device, protected by a virtual IOMMU on the guest,
>>>> the physical IOMMU must be programmed to be consistent with
>>>> the guest mappings. If the physical IOMMU supports two
>>>> translation stages it makes sense to program guest mappings
>>>> onto the first stage/level (ARM/Intel terminology) while the host
>>>> owns the stage/level 2.
>>>>
>>>> In that case, it is mandated to trap on guest configuration
>>>> settings and pass those to the physical iommu driver.
>>>>
>>>> This patch adds a new API to the iommu subsystem that allows
>>>> to set/unset the pasid table information.
>>>>
>>>> A generic iommu_pasid_table_config struct is introduced in
>>>> a new iommu.h uapi header. This is going to be used by the VFIO
>>>> user API.
>>>>
>>>> Signed-off-by: Jean-Philippe Brucker
>>>> <jean-philippe.brucker@arm.com> Signed-off-by: Liu, Yi L
>>>> <yi.l.liu@linux.intel.com> Signed-off-by: Ashok Raj
>>>> <ashok.raj@intel.com> Signed-off-by: Jacob Pan
>>>> <jacob.jun.pan@linux.intel.com> Signed-off-by: Eric Auger
>>>> <eric.auger@redhat.com> Reviewed-by: Jean-Philippe Brucker
>>>> <jean-philippe.brucker@arm.com> ---
>>>>  drivers/iommu/iommu.c      | 19 ++++++++++++++
>>>>  include/linux/iommu.h      | 18 ++++++++++++++
>>>>  include/uapi/linux/iommu.h | 51
>>>> ++++++++++++++++++++++++++++++++++++++ 3 files changed, 88
>>>> insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>>>> index 2b471419e26c..b71ad56f8c99 100644
>>>> --- a/drivers/iommu/iommu.c
>>>> +++ b/drivers/iommu/iommu.c
>>>> @@ -1723,6 +1723,25 @@ int iommu_sva_unbind_gpasid(struct
>>>> iommu_domain *domain, struct device *dev, }
>>>>  EXPORT_SYMBOL_GPL(iommu_sva_unbind_gpasid);
>>>>  
>>>> +int iommu_attach_pasid_table(struct iommu_domain *domain,
>>>> +			     struct iommu_pasid_table_config *cfg)
>>>> +{
>>>> +	if (unlikely(!domain->ops->attach_pasid_table))
>>>> +		return -ENODEV;
>>>> +
>>>> +	return domain->ops->attach_pasid_table(domain, cfg);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(iommu_attach_pasid_table);
>>>> +
>>>> +void iommu_detach_pasid_table(struct iommu_domain *domain)
>>>> +{
>>>> +	if (unlikely(!domain->ops->detach_pasid_table))
>>>> +		return;
>>>> +
>>>> +	domain->ops->detach_pasid_table(domain);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
>>>> +
>>>>  static void __iommu_detach_device(struct iommu_domain *domain,
>>>>  				  struct device *dev)
>>>>  {
>>>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>>>> index 7ef8b0bda695..3e1057c3585a 100644
>>>> --- a/include/linux/iommu.h
>>>> +++ b/include/linux/iommu.h
>>>> @@ -248,6 +248,8 @@ struct iommu_iotlb_gather {
>>>>   * @cache_invalidate: invalidate translation caches
>>>>   * @sva_bind_gpasid: bind guest pasid and mm
>>>>   * @sva_unbind_gpasid: unbind guest pasid and mm
>>>> + * @attach_pasid_table: attach a pasid table
>>>> + * @detach_pasid_table: detach the pasid table
>>>>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>>>>   * @owner: Driver module providing these ops
>>>>   */
>>>> @@ -307,6 +309,9 @@ struct iommu_ops {
>>>>  				      void *drvdata);
>>>>  	void (*sva_unbind)(struct iommu_sva *handle);
>>>>  	int (*sva_get_pasid)(struct iommu_sva *handle);
>>>> +	int (*attach_pasid_table)(struct iommu_domain *domain,
>>>> +				  struct iommu_pasid_table_config
>>>> *cfg);
>>>> +	void (*detach_pasid_table)(struct iommu_domain *domain);
>>>>  
>>>>  	int (*page_response)(struct device *dev,
>>>>  			     struct iommu_fault_event *evt,
>>>> @@ -446,6 +451,9 @@ extern int iommu_sva_bind_gpasid(struct
>>>> iommu_domain *domain, struct device *dev, struct
>>>> iommu_gpasid_bind_data *data); extern int
>>>> iommu_sva_unbind_gpasid(struct iommu_domain *domain, struct device
>>>> *dev, ioasid_t pasid); +extern int iommu_attach_pasid_table(struct
>>>> iommu_domain *domain,
>>>> +				    struct
>>>> iommu_pasid_table_config *cfg); +extern void
>>>> iommu_detach_pasid_table(struct iommu_domain *domain); extern
>>>> struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>>>> extern struct iommu_domain *iommu_get_dma_domain(struct device
>>>> *dev); extern int iommu_map(struct iommu_domain *domain, unsigned
>>>> long iova, @@ -1048,6 +1056,16 @@ iommu_aux_get_pasid(struct
>>>> iommu_domain *domain, struct device *dev) return -ENODEV; }
>>>>  
>>>> +static inline
>>>> +int iommu_attach_pasid_table(struct iommu_domain *domain,
>>>> +			     struct iommu_pasid_table_config *cfg)
>>>> +{
>>>> +	return -ENODEV;
>>>> +}
>>>> +
>>>> +static inline
>>>> +void iommu_detach_pasid_table(struct iommu_domain *domain) {}
>>>> +
>>>>  static inline struct iommu_sva *
>>>>  iommu_sva_bind_device(struct device *dev, struct mm_struct *mm,
>>>> void *drvdata) {
>>>> diff --git a/include/uapi/linux/iommu.h
>>>> b/include/uapi/linux/iommu.h index 4ad3496e5c43..8d00be10dc6d
>>>> 100644 --- a/include/uapi/linux/iommu.h
>>>> +++ b/include/uapi/linux/iommu.h
>>>> @@ -321,4 +321,55 @@ struct iommu_gpasid_bind_data {
>>>>  	};
>>>>  };
>>>>  
>>>> +/**
>>>> + * struct iommu_pasid_smmuv3 - ARM SMMUv3 Stream Table Entry
>>>> stage 1 related
>>>> + *     information
>>>> + * @version: API version of this structure
>>>> + * @s1fmt: STE s1fmt (format of the CD table: single CD, linear
>>>> table
>>>> + *         or 2-level table)
>>>> + * @s1dss: STE s1dss (specifies the behavior when @pasid_bits != 0
>>>> + *         and no PASID is passed along with the incoming
>>>> transaction)
>>>> + * @padding: reserved for future use (should be zero)
>>>> + *
>>>> + * The PASID table is referred to as the Context Descriptor (CD)
>>>> table on ARM
>>>> + * SMMUv3. Please refer to the ARM SMMU 3.x spec (ARM IHI 0070A)
>>>> for full
>>>> + * details.
>>>> + */
>>>> +struct iommu_pasid_smmuv3 {
>>>> +#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
>>>> +	__u32	version;
>>>> +	__u8	s1fmt;
>>>> +	__u8	s1dss;
>>>> +	__u8	padding[2];
>>>> +};
>>>> +
>>>> +/**
>>>> + * struct iommu_pasid_table_config - PASID table data used to bind
>>>> guest PASID
>>>> + *     table to the host IOMMU
>>>> + * @version: API version to prepare for future extensions
>>>> + * @format: format of the PASID table
>>>> + * @base_ptr: guest physical address of the PASID table
>>>> + * @pasid_bits: number of PASID bits used in the PASID table
>>>> + * @config: indicates whether the guest translation stage must
>>>> + *          be translated, bypassed or aborted.
>>>> + * @padding: reserved for future use (should be zero)
>>>> + * @smmuv3: table information when @format is
>>>> %IOMMU_PASID_FORMAT_SMMUV3
>>>> + */
>>>> +struct iommu_pasid_table_config {
>>>> +#define PASID_TABLE_CFG_VERSION_1 1
>>>> +	__u32	version;
>>>> +#define IOMMU_PASID_FORMAT_SMMUV3	1
>>>> +	__u32	format;
>>>> +	__u64	base_ptr;
>>>> +	__u8	pasid_bits;
>>>> +#define IOMMU_PASID_CONFIG_TRANSLATE	1
>>>> +#define IOMMU_PASID_CONFIG_BYPASS	2
>>>> +#define IOMMU_PASID_CONFIG_ABORT	3
>>>> +	__u8	config;
>>>> +	__u8    padding[6];
>>>> +	union {
>>>> +		struct iommu_pasid_smmuv3 smmuv3;
>>>> +	};
>>>> +};
>>>> +
>>>>  #endif /* _UAPI_IOMMU_H */  
>>>
>>> [Jacob Pan]
>>>   
>>
> 
> [Jacob Pan]
> 


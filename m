Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C492157EC
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgGFNA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:00:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48290 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728989AbgGFNA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 09:00:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594040455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRvkjhIH9FwsRMYIWgTLOYV+dlULlwA+LmeNUpAMVFc=;
        b=dhUBIRrbE5iKvIf9p/ElWHMC38BiZ4GjUJ4HR6fZMMZZZH3jd/A68dLmx5f1yygTLSQEZk
        6/3wg0gpwKrBssujXszzw/lf2JFOKiSLMkx4vr1eey93CFpOkqozDzCD6/WvGd+6G7VHHC
        JDPOCOf38kQhw/CPyZAvpoGIZ5/kaUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-hsuwTLzgNc-rrRJSIiJfqQ-1; Mon, 06 Jul 2020 09:00:52 -0400
X-MC-Unique: hsuwTLzgNc-rrRJSIiJfqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF16C8015F9;
        Mon,  6 Jul 2020 13:00:49 +0000 (UTC)
Received: from [10.36.113.241] (ovpn-113-241.ams2.redhat.com [10.36.113.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B8005C1B2;
        Mon,  6 Jul 2020 13:00:46 +0000 (UTC)
Subject: Re: [PATCH v4 02/15] iommu: Report domain nesting info
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
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-3-git-send-email-yi.l.liu@intel.com>
 <b9479f61-7f9e-e0ae-5125-ab15f59b1ece@redhat.com>
 <DM5PR11MB14352CBCB1966C0B9E418C7CC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b1d361f3-b0ca-7fef-ba31-1bdcdadea96f@redhat.com>
Date:   Mon, 6 Jul 2020 15:00:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB14352CBCB1966C0B9E418C7CC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/20 2:20 PM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric <eric.auger@redhat.com>
>> Sent: Monday, July 6, 2020 5:34 PM
>>
>> On 7/4/20 1:26 PM, Liu Yi L wrote:
>>> IOMMUs that support nesting translation needs report the capability info
>> need to report
>>> to userspace, e.g. the format of first level/stage paging structures.
>>>
>>> This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
>>> nesting info after setting DOMAIN_ATTR_NESTING.
>>>
>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: Eric Auger <eric.auger@redhat.com>
>>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> ---
>>> v3 -> v4:
>>> *) split the SMMU driver changes to be a separate patch
>>> *) move the @addr_width and @pasid_bits from vendor specific
>>>    part to generic part.
>>> *) tweak the description for the @features field of struct
>>>    iommu_nesting_info.
>>> *) add description on the @data[] field of struct iommu_nesting_info
>>>
>>> v2 -> v3:
>>> *) remvoe cap/ecap_mask in iommu_nesting_info.
>>> *) reuse DOMAIN_ATTR_NESTING to get nesting info.
>>> *) return an empty iommu_nesting_info for SMMU drivers per Jean'
>>>    suggestion.
>>> ---
>>>  include/uapi/linux/iommu.h | 78
>> ++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 78 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>>> index 1afc661..1bfc032 100644
>>> --- a/include/uapi/linux/iommu.h
>>> +++ b/include/uapi/linux/iommu.h
>>> @@ -332,4 +332,82 @@ struct iommu_gpasid_bind_data {
>>>  	} vendor;
>>>  };
>>>
>>> +/*
>>> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
>>> + *				user space should check it before using
>>> + *				nesting capability.
>> alignment?
> 
> oh, yes, will do it.
> 
>>> + *
>>> + * @size:	size of the whole structure
>>> + * @format:	PASID table entry format, the same definition with
>>> + *		@format of struct iommu_gpasid_bind_data.
>> the same definition as struct iommu_gpasid_bind_data @format?
> 
> right. yours is much better.
> 
>>> + * @features:	supported nesting features.
>>> + * @flags:	currently reserved for future extension.
>>> + * @addr_width:	The output addr width of first level/stage translation
>>> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
>>> + *		support.
>>> + * @data:	vendor specific cap info. data[] structure type can be deduced
>>> + *		from @format field.
>>> + *
>>> + *
>> +===============+===================================================
>> ===+
>>> + * | feature       |  Notes                                               |
>>> + *
>> +===============+===================================================
>> ===+
>>> + * | SYSWIDE_PASID |  PASIDs are managed in system-wide, instead of per   |
>>> + * |               |  device. When a device is assigned to userspace or   |
>>> + * |               |  VM, proper uAPI (userspace driver framework uAPI,   |
>>> + * |               |  e.g. VFIO) must be used to allocate/free PASIDs for |
>>> + * |               |  the assigned device.                                |
>>> + * +---------------+------------------------------------------------------+
>>> + * | BIND_PGTBL    |  The owner of the first level/stage page table must  |
>>> + * |               |  explicitly bind the page table to associated PASID  |
>>> + * |               |  (either the one specified in bind request or the    |
>>> + * |               |  default PASID of iommu domain), through userspace   |
>>> + * |               |  driver framework uAPI (e.g. VFIO_IOMMU_NESTING_OP). |
>>> + * +---------------+------------------------------------------------------+
>>> + * | CACHE_INVLD   |  The owner of the first level/stage page table must  |
>>> + * |               |  explicitly invalidate the IOMMU cache through uAPI  |
>>> + * |               |  provided by userspace driver framework (e.g. VFIO)  |
>>> + * |               |  according to vendor-specific requirement when       |
>>> + * |               |  changing the page table.                            |
>>> + * +---------------+------------------------------------------------------+
>> Do you foresee cases where BIND_PGTBL and CACHE_INVLD shouldn't be
>> exposed as features?
> 
> sorry, I didn't quite get it. could you explain a little bit more. :-)
For SYSWIDE_PASID I understand SMMU won't advertise it. But do you
foresee any nested implementation not requesting the owner of the tables
to bind and invalidate caches. So I understand those 2 features would
always be supported?
> 
>>> + *
>>> + * @data[] types defined for @format:
>>> + *
>> +================================+==================================
>> ===+
>>> + * | @format                        | @data[]                             |
>>> + *
>> +================================+==================================
>> ===+
>>> + * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
>>> + * +--------------------------------+-------------------------------------+
>>> + *
>>> + */
>>> +struct iommu_nesting_info {
>>> +	__u32	size;
>>> +	__u32	format;
>>> +	__u32	features;
>>> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
>>> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
>>> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
>> In other structs the values seem to be defined before the field
> 
> not sure. :-) I mimics the below struct from uapi/vfio.h
Yep I noticed that afterwards. In IOMMU uapi it looks the opposite
though. So I would alignto the style in the same file but that's not a
big deal.
> 
> struct vfio_iommu_type1_dma_map {
>         __u32   argsz;
>         __u32   flags;
> #define VFIO_DMA_MAP_FLAG_READ (1 << 0)         /* readable from device */
> #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)        /* writable from device */
>         __u64   vaddr;                          /* Process virtual address */
>         __u64   iova;                           /* IO virtual address */
>         __u64   size;                           /* Size of mapping (bytes) */
> };
> 
>>> +	__u32	flags;
>>> +	__u16	addr_width;
>>> +	__u16	pasid_bits;
>>> +	__u32	padding;
>>> +	__u8	data[];
>>> +};
>>> +
>>> +/*
>>> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
>>> + *
>> spurious line
> 
> yes, will remove this line.
> 
> Regards,
> Yi Liu
> 
>>> + *
>>> + * @flags:	VT-d specific flags. Currently reserved for future
>>> + *		extension.
>>> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
>>> + *		register.
>>> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
>>> + *		extended capability register.
>>> + */
>>> +struct iommu_nesting_info_vtd {
>>> +	__u32	flags;
>>> +	__u32	padding;
>>> +	__u64	cap_reg;
>>> +	__u64	ecap_reg;
>>> +};
>>> +
>>>  #endif /* _UAPI_IOMMU_H */
>>>
>> Thanks
>>
>> Eric
> 

Thanks

Eric


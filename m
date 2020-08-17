Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4A245E39
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgHQHnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:43:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27554 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbgHQHnR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 03:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597650195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3v+4FwPwGKXph0J+J+m0T/cJhyDv7nMhjPPtvkq6qw=;
        b=b9iHBFjywSZ1g3VRu2dp3cgN3f68Rm3kdLK/ZD3pzl7+itCywoJLta3T+AURCFczFDqsDy
        BqDQ9xbcFFhpHa9+/nNZhpPG5NETgN+fZDzR03Ne7eZqoPP+hfUKJUDl6f4VnkdzeAqYHB
        amUtDmQTCQvOSou/c02bL+U/4KyGmHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-4oXVyhpmOY26mPTw7UqCgA-1; Mon, 17 Aug 2020 03:43:11 -0400
X-MC-Unique: 4oXVyhpmOY26mPTw7UqCgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1633118B9F01;
        Mon, 17 Aug 2020 07:43:09 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA9B1709E4;
        Mon, 17 Aug 2020 07:42:58 +0000 (UTC)
Subject: Re: [PATCH v6 15/15] iommu/vt-d: Support reporting nesting capability
 info
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lu, Baolu" <baolu.lu@intel.com>
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
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-16-git-send-email-yi.l.liu@intel.com>
 <7fe337fa-abbc-82be-c8e8-b9e2a6179b90@redhat.com>
 <DM5PR11MB14351B5746A8A09E2EBCBEBDC35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <83376141-8357-8100-54f5-2ccbf2e09090@redhat.com>
Date:   Mon, 17 Aug 2020 09:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB14351B5746A8A09E2EBCBEBDC35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/20 9:05 AM, Liu, Yi L wrote:
> Hi Eric,
> 
>> Auger Eric <eric.auger@redhat.com>
>> Sent: Sunday, August 16, 2020 8:01 PM
>>
>> Hi Yi,
>>
>> On 7/28/20 8:27 AM, Liu Yi L wrote:
>>> This patch reports nesting info, and only supports the case where all
>>> the physical iomms have the same CAP/ECAP MASKS.
>> s/iomms/iommus
> 
> yep.
> 
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
>>> v2 -> v3:
>>> *) remove cap/ecap_mask in iommu_nesting_info.
>>> ---
>>>  drivers/iommu/intel/iommu.c | 81
>> +++++++++++++++++++++++++++++++++++++++++++--
>>>  include/linux/intel-iommu.h | 16 +++++++++
>>>  2 files changed, 95 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>>> index 88f4647..0835804 100644
>>> --- a/drivers/iommu/intel/iommu.c
>>> +++ b/drivers/iommu/intel/iommu.c
>>> @@ -5660,12 +5660,16 @@ static inline bool iommu_pasid_support(void)
>>>  static inline bool nested_mode_support(void)
>>>  {
>>>  	struct dmar_drhd_unit *drhd;
>>> -	struct intel_iommu *iommu;
>>> +	struct intel_iommu *iommu, *prev = NULL;
>>>  	bool ret = true;
>>>
>>>  	rcu_read_lock();
>>>  	for_each_active_iommu(iommu, drhd) {
>>> -		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap)) {
>>> +		if (!prev)
>>> +			prev = iommu;
>>> +		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap) ||
>>> +		    (VTD_CAP_MASK & (iommu->cap ^ prev->cap)) ||
>>> +		    (VTD_ECAP_MASK & (iommu->ecap ^ prev->ecap))) {
>>>  			ret = false;
>>>  			break;
>> So this changes the behavior of DOMAIN_ATTR_NESTING. Shouldn't it have a
>> Fixes tag as well? And maybe add the capability getter in a separate patch?
> 
> yes, this changed the behavior. so it would be better to be a separate patch
> and upstream along? how about your idea? @Lu, Baolu :-)
> 
>>>  		}
>>> @@ -6081,6 +6085,78 @@ intel_iommu_domain_set_attr(struct iommu_domain
>> *domain,
>>>  	return ret;
>>>  }
>>>
>>> +static int intel_iommu_get_nesting_info(struct iommu_domain *domain,
>>> +					struct iommu_nesting_info *info)
>>> +{
>>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>>> +	u64 cap = VTD_CAP_MASK, ecap = VTD_ECAP_MASK;
>>> +	struct device_domain_info *domain_info;
>>> +	struct iommu_nesting_info_vtd vtd;
>>> +	unsigned long flags;
>>> +	unsigned int size;
>>> +
> 
> perhaps better to acquire the lock here. [1]
> 
>>> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED ||
>>> +	    !(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE))
>>> +		return -ENODEV;
>>> +
>>> +	if (!info)
>>> +		return -EINVAL;
>>> +
>>> +	size = sizeof(struct iommu_nesting_info) +
>>> +		sizeof(struct iommu_nesting_info_vtd);
>>> +	/*
>>> +	 * if provided buffer size is smaller than expected, should
>>> +	 * return 0 and also the expected buffer size to caller.
>>> +	 */
>>> +	if (info->argsz < size) {
>>> +		info->argsz = size;
>>> +		return 0;
>>> +	}
>>> +
>>> +	spin_lock_irqsave(&device_domain_lock, flags);
>>> +	/*
>>> +	 * arbitrary select the first domain_info as all nesting
>>> +	 * related capabilities should be consistent across iommu
>>> +	 * units.
>>> +	 */
>>> +	domain_info = list_first_entry(&dmar_domain->devices,
>>> +				       struct device_domain_info, link);
>>> +	cap &= domain_info->iommu->cap;
>>> +	ecap &= domain_info->iommu->ecap;
>>> +	spin_unlock_irqrestore(&device_domain_lock, flags);
>>> +
>>> +	info->format = IOMMU_PASID_FORMAT_INTEL_VTD;
>>> +	info->features = IOMMU_NESTING_FEAT_SYSWIDE_PASID |
>>> +			 IOMMU_NESTING_FEAT_BIND_PGTBL |
>>> +			 IOMMU_NESTING_FEAT_CACHE_INVLD;
>>> +	info->addr_width = dmar_domain->gaw;
>>> +	info->pasid_bits = ilog2(intel_pasid_max_id);
>>> +	info->padding = 0;
>>> +	vtd.flags = 0;
>>> +	vtd.padding = 0;
>>> +	vtd.cap_reg = cap;
>>> +	vtd.ecap_reg = ecap;
>>> +
>>> +	memcpy(info->data, &vtd, sizeof(vtd));
>>> +	return 0;
>>> +}
>>> +
>>> +static int intel_iommu_domain_get_attr(struct iommu_domain *domain,
>>> +				       enum iommu_attr attr, void *data)
>>> +{
>>> +	switch (attr) {
>>> +	case DOMAIN_ATTR_NESTING:
>>> +	{
>>> +		struct iommu_nesting_info *info =
>>> +				(struct iommu_nesting_info *)data;
>>
>> don't you need to hold a device_domain_lock earlier to make sure domain
>> attributes can't change behind your back (unmanaged type and nested mode)?
> 
> do you mean acquire lock at [1]?
yep either at [1] or before calling intel_iommu_get_nesting_info and
adding a comment saying intel_iommu_get_nesting_info() shall be called
with the lock held

Thanks

Eric
> 
> Regards,
> Yi Liu
> 
>>> +
>>> +		return intel_iommu_get_nesting_info(domain, info);
>>> +	}
>>> +	default:
>>> +		return -ENOENT;
>>> +	}
>>> +}
>>> +
>>>  /*
>>>   * Check that the device does not live on an external facing PCI port that is
>>>   * marked as untrusted. Such devices should not be able to apply quirks and
>>> @@ -6103,6 +6179,7 @@ const struct iommu_ops intel_iommu_ops = {
>>>  	.domain_alloc		= intel_iommu_domain_alloc,
>>>  	.domain_free		= intel_iommu_domain_free,
>>>  	.domain_set_attr	= intel_iommu_domain_set_attr,
>>> +	.domain_get_attr	= intel_iommu_domain_get_attr,
>>>  	.attach_dev		= intel_iommu_attach_device,
>>>  	.detach_dev		= intel_iommu_detach_device,
>>>  	.aux_attach_dev		= intel_iommu_aux_attach_device,
>>> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
>>> index f98146b..5acf795 100644
>>> --- a/include/linux/intel-iommu.h
>>> +++ b/include/linux/intel-iommu.h
>>> @@ -197,6 +197,22 @@
>>>  #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
>>>  #define ecap_sc_support(e)	((e >> 7) & 0x1) /* Snooping Control */
>>>
>>> +/* Nesting Support Capability Alignment */
>>> +#define VTD_CAP_FL1GP		BIT_ULL(56)
>>> +#define VTD_CAP_FL5LP		BIT_ULL(60)
>>> +#define VTD_ECAP_PRS		BIT_ULL(29)
>>> +#define VTD_ECAP_ERS		BIT_ULL(30)
>>> +#define VTD_ECAP_SRS		BIT_ULL(31)
>>> +#define VTD_ECAP_EAFS		BIT_ULL(34)
>>> +#define VTD_ECAP_PASID		BIT_ULL(40)
>>> +
>>> +/* Only capabilities marked in below MASKs are reported */
>>> +#define VTD_CAP_MASK		(VTD_CAP_FL1GP | VTD_CAP_FL5LP)
>>> +
>>> +#define VTD_ECAP_MASK		(VTD_ECAP_PRS | VTD_ECAP_ERS | \
>>> +				 VTD_ECAP_SRS | VTD_ECAP_EAFS | \
>>> +				 VTD_ECAP_PASID)
>>> +
>>>  /* Virtual command interface capability */
>>>  #define vccap_pasid(v)		(((v) & DMA_VCS_PAS)) /* PASID allocation
>> */
>>>
>>>
>> Thanks
>>
>> Eric
> 


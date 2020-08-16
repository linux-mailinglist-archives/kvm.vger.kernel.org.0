Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E59F2457A8
	for <lists+kvm@lfdr.de>; Sun, 16 Aug 2020 14:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgHPMmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 08:42:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgHPMmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 08:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597581753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W0HocnDQkztIIYn8ga3nfHi06IHWlBx2B73NXD/QwWQ=;
        b=Ms435Zg6I4GwFg6nxnkhhnvUnlKZkk8m7fJEhBG3euJYMGysPjtmZAWUZH8HuMVLgdJPF0
        1Xr4ETlIiiPoIYL314qAoTorluKVbN/dWnK8iLgRCAUzQdBDIuaiFOjU/mSS/tfElcR8Nx
        kcCJ4vZ1iGCERuIZCnTQRnwfvsgnkqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-GM2mls39OEmSR4fc2P72oQ-1; Sun, 16 Aug 2020 08:42:31 -0400
X-MC-Unique: GM2mls39OEmSR4fc2P72oQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C88AB100558D;
        Sun, 16 Aug 2020 12:42:29 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14014702FF;
        Sun, 16 Aug 2020 12:42:18 +0000 (UTC)
Subject: Re: [PATCH v6 06/15] iommu/vt-d: Support setting ioasid set to domain
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
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-7-git-send-email-yi.l.liu@intel.com>
 <ae43dda5-01aa-adb1-d21d-2525cf4f4d95@redhat.com>
 <DM5PR11MB1435CD15D0C713E7D1B7E8F8C3400@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <2e161928-b6c5-784d-8233-2505f9feb87c@redhat.com>
Date:   Sun, 16 Aug 2020 14:42:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB1435CD15D0C713E7D1B7E8F8C3400@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/14/20 10:04 AM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric <eric.auger@redhat.com>
>> Sent: Thursday, August 13, 2020 11:07 PM
>>
>> Hi Yi,
>>
>> On 7/28/20 8:27 AM, Liu Yi L wrote:
>>> From IOMMU p.o.v., PASIDs allocated and managed by external components
>>> (e.g. VFIO) will be passed in for gpasid_bind/unbind operation. IOMMU
>>> needs some knowledge to check the PASID ownership, hence add an
>>> interface for those components to tell the PASID owner.
>>>
>>> In latest kernel design, PASID ownership is managed by IOASID set
>>> where the PASID is allocated from. This patch adds support for setting
>>> ioasid set ID to the domains used for nesting/vSVA. Subsequent SVA
>>> operations will check the PASID against its IOASID set for proper ownership.
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
>>> v5 -> v6:
>>> *) address comments against v5 from Eric Auger.
>>>
>>> v4 -> v5:
>>> *) address comments from Eric Auger.
>>> ---
>>>  drivers/iommu/intel/iommu.c | 23 +++++++++++++++++++++++
>>> include/linux/intel-iommu.h |  4 ++++
>>>  include/linux/iommu.h       |  1 +
>>>  3 files changed, 28 insertions(+)
>>>
>>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>>> index ed4b71c..b2fe54e 100644
>>> --- a/drivers/iommu/intel/iommu.c
>>> +++ b/drivers/iommu/intel/iommu.c
>>> @@ -1793,6 +1793,7 @@ static struct dmar_domain *alloc_domain(int flags)
>>>  	if (first_level_by_default())
>>>  		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
>>>  	domain->has_iotlb_device = false;
>>> +	domain->ioasid_sid = INVALID_IOASID_SET;
>>>  	INIT_LIST_HEAD(&domain->devices);
>>>
>>>  	return domain;
>>> @@ -6040,6 +6041,28 @@ intel_iommu_domain_set_attr(struct iommu_domain
>> *domain,
>>>  		}
>>>  		spin_unlock_irqrestore(&device_domain_lock, flags);
>>>  		break;
>>> +	case DOMAIN_ATTR_IOASID_SID:
>>> +	{
>>> +		int sid = *(int *)data;
>>
>>> +
>>> +		spin_lock_irqsave(&device_domain_lock, flags);
>>> +		if (!(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE)) {
>>> +			ret = -ENODEV;
>>> +			spin_unlock_irqrestore(&device_domain_lock, flags);
>>> +			break;
>>> +		}
>>> +		if (dmar_domain->ioasid_sid != INVALID_IOASID_SET &&
>>> +		    dmar_domain->ioasid_sid != sid) {
>>> +			pr_warn_ratelimited("multi ioasid_set (%d:%d) setting",
>>> +					    dmar_domain->ioasid_sid, sid);
>>> +			ret = -EBUSY;
>>> +			spin_unlock_irqrestore(&device_domain_lock, flags);
>>> +			break;
>>> +		}
>>> +		dmar_domain->ioasid_sid = sid;
>>> +		spin_unlock_irqrestore(&device_domain_lock, flags);
>>> +		break;
>> nit: Adding a small helper
>> int__set_ioasid_sid(struct dmar_domain *dmar_domain, int sid_id)
>>
>> may simplify the lock handling
> 
> ok. will do.
> 
>>
>>> +	}
>>>  	default:
>>>  		ret = -EINVAL;
>>>  		break;
>>> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
>>> index 3f23c26..0d0ab32 100644
>>> --- a/include/linux/intel-iommu.h
>>> +++ b/include/linux/intel-iommu.h
>>> @@ -549,6 +549,10 @@ struct dmar_domain {
>>>  					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
>>>  	u64		max_addr;	/* maximum mapped address */
>>>
>>> +	int		ioasid_sid;	/*
>>> +					 * the ioasid set which tracks all
>> id of the ioasid set?
> 
> should be ioasid_set. however, ioasid_alloc_set() returns sid in Jacob's
> series. but, I heard from Jacob, he will remove ioasid_sid, and return
> ioasid_set. so I will modify it once his patch is sent out.
> 
> https://lore.kernel.org/linux-iommu/1585158931-1825-4-git-send-email-jacob.jun.pan@linux.intel.com/

OK

Thanks

Eric
> 
>>> +					 * PASIDs used by the domain.
>>> +					 */
>>>  	int		default_pasid;	/*
>>>  					 * The default pasid used for non-SVM
>>>  					 * traffic on mediated devices.
>>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
>>> 4a02c9e..b1ff702 100644
>>> --- a/include/linux/iommu.h
>>> +++ b/include/linux/iommu.h
>>> @@ -124,6 +124,7 @@ enum iommu_attr {
>>>  	DOMAIN_ATTR_FSL_PAMUV1,
>>>  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
>>>  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
>>> +	DOMAIN_ATTR_IOASID_SID,
>>>  	DOMAIN_ATTR_MAX,
>>>  };
>>>
>>>
>> Besides
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> thanks :-)
> 
> Regards,
> Yi Liu
> 
>>
>> Eric
> 


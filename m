Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2527576C
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 13:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIWLrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 07:47:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726513AbgIWLrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 07:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600861664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPqJZ9kUOXWQkU3z5eMOLx9N/KiGW7Zqy3WW9MTewTg=;
        b=g/RW1TW/cA10Ji/Nxih/Ul8aH75GbHWjbV+IrEOi7Hz+xxEi1XFkGr9p3IqpTp77F3XUh/
        s3u7muTv881nYsNGK/hrOTK5GfGuPBQriS8kONDDnak5l4axeX9WLrfBAcNZn2SLiwPu3r
        Z0/B8qTN9Z2+pNGcUbpq+On/vyMM+ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-iQP_rk0SPY-sEjGh61uLIQ-1; Wed, 23 Sep 2020 07:47:40 -0400
X-MC-Unique: iQP_rk0SPY-sEjGh61uLIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A0F1868425;
        Wed, 23 Sep 2020 11:47:37 +0000 (UTC)
Received: from [10.36.112.29] (ovpn-112-29.ams2.redhat.com [10.36.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 415F619C4F;
        Wed, 23 Sep 2020 11:47:22 +0000 (UTC)
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, robin.murphy@arm.com
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
Date:   Wed, 23 Sep 2020 13:47:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 9/23/20 1:27 PM, Zenghui Yu wrote:
> Hi Eric,
> 
> On 2020/3/21 0:19, Eric Auger wrote:
>> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
>>
>> This patch adds an VFIO_IOMMU_SET_PASID_TABLE ioctl
>> which aims to pass the virtual iommu guest configuration
>> to the host. This latter takes the form of the so-called
>> PASID table.
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> [...]
> 
>> diff --git a/drivers/vfio/vfio_iommu_type1.c
>> b/drivers/vfio/vfio_iommu_type1.c
>> index a177bf2c6683..bfacbd876ee1 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2172,6 +2172,43 @@ static int vfio_iommu_iova_build_caps(struct
>> vfio_iommu *iommu,
>>       return ret;
>>   }
>>   +static void
>> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
>> +{
>> +    struct vfio_domain *d;
>> +
>> +    mutex_lock(&iommu->lock);
>> +
>> +    list_for_each_entry(d, &iommu->domain_list, next) {
>> +        iommu_detach_pasid_table(d->domain);
>> +    }
>> +    mutex_unlock(&iommu->lock);
>> +}
>> +
>> +static int
>> +vfio_attach_pasid_table(struct vfio_iommu *iommu,
>> +            struct vfio_iommu_type1_set_pasid_table *ustruct)
>> +{
>> +    struct vfio_domain *d;
>> +    int ret = 0;
>> +
>> +    mutex_lock(&iommu->lock);
>> +
>> +    list_for_each_entry(d, &iommu->domain_list, next) {
>> +        ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
>> +        if (ret)
>> +            goto unwind;
>> +    }
>> +    goto unlock;
>> +unwind:
>> +    list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
>> +        iommu_detach_pasid_table(d->domain);
>> +    }
>> +unlock:
>> +    mutex_unlock(&iommu->lock);
>> +    return ret;
>> +}
>> +
>>   static long vfio_iommu_type1_ioctl(void *iommu_data,
>>                      unsigned int cmd, unsigned long arg)
>>   {
>> @@ -2276,6 +2313,25 @@ static long vfio_iommu_type1_ioctl(void
>> *iommu_data,
>>             return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>               -EFAULT : 0;
>> +    } else if (cmd == VFIO_IOMMU_SET_PASID_TABLE) {
>> +        struct vfio_iommu_type1_set_pasid_table ustruct;
>> +
>> +        minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table,
>> +                    config);
>> +
>> +        if (copy_from_user(&ustruct, (void __user *)arg, minsz))
>> +            return -EFAULT;
>> +
>> +        if (ustruct.argsz < minsz)
>> +            return -EINVAL;
>> +
>> +        if (ustruct.flags & VFIO_PASID_TABLE_FLAG_SET)
>> +            return vfio_attach_pasid_table(iommu, &ustruct);
>> +        else if (ustruct.flags & VFIO_PASID_TABLE_FLAG_UNSET) {
>> +            vfio_detach_pasid_table(iommu);
>> +            return 0;
>> +        } else
>> +            return -EINVAL;
> 
> Nit:
> 
> What if user-space blindly set both flags? Should we check that only one
> flag is allowed to be set at this stage, and return error otherwise?
Indeed I can check that.
> 
> Besides, before going through the whole series [1][2], I'd like to know
> if this is the latest version of your Nested-Stage-Setup work in case I
> had missed something.
> 
> [1] https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
> [2] https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com

yes those 2 series are the last ones. Thank you for reviewing.

FYI, I intend to respin within a week or 2 on top of Jacob's  [PATCH v10
0/7] IOMMU user API enhancement. But functionally there won't a lot of
changes.

Thanks

Eric
> 
> 
> Thanks,
> Zenghui
> 


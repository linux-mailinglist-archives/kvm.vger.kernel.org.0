Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8854E21534
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfEQISQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:18:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727386AbfEQISQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 04:18:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H8I3jt088195
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 04:18:14 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shqvpcc02-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 04:18:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 09:17:23 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 09:17:19 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4H8HIE849741984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 08:17:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9F4CAE055;
        Fri, 17 May 2019 08:17:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D004AE053;
        Fri, 17 May 2019 08:17:17 +0000 (GMT)
Received: from [9.145.153.112] (unknown [9.145.153.112])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 08:17:17 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
 <1557476555-20256-5-git-send-email-pmorel@linux.ibm.com>
 <20190516124026.415bf671@x1.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 17 May 2019 10:17:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516124026.415bf671@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051708-0028-0000-0000-0000036EA8CC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051708-0029-0000-0000-0000242E46CE
Message-Id: <29209ea1-be49-47bc-c258-6e87da055fac@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/2019 20:40, Alex Williamson wrote:
> On Fri, 10 May 2019 10:22:35 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement a capability intercafe for VFIO_IOMMU_GET_INFO and add the
>> first capability: VFIO_IOMMU_INFO_CAPABILITIES.
>>
>> When calling the ioctl, the user must specify
>> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and must check
>> in the answer if capabilities are supported.
>> Older kernel will not check nor set the VFIO_IOMMU_INFO_CAPABILITIES in
>> the flags of vfio_iommu_type1_info.
>>
>> The iommu get_attr callback will be called to retrieve the specific
>> attributes and fill the capabilities, VFIO_IOMMU_INFO_CAP_QFN for the
>> PCI query function attributes and VFIO_IOMMU_INFO_CAP_QGRP for the
>> PCI query function group.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 94 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index d0f731c..f7f8120 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1658,6 +1658,70 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>>   	return ret;
>>   }
>>   
>> +int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
>> +			  size_t size)
>> +{
>> +	struct vfio_domain *d;
>> +	struct vfio_iommu_type1_info_block *info_fn;
>> +	struct vfio_iommu_type1_info_block *info_grp;
>> +	unsigned long total_size, fn_size, grp_size;
>> +	int ret;
>> +
>> +	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
>> +	if (!d)
>> +		return -ENODEV;
>> +	/* The size of these capabilities are device dependent */
>> +	fn_size = iommu_domain_get_attr(d->domain,
>> +					DOMAIN_ATTR_ZPCI_FN_SIZE, NULL);
>> +	if (fn_size < 0)
>> +		return fn_size;
> 
> What if non-Z archs want to use this?  The function is architected
> specifically for this one use case, fail if any component is not there
> which means it requires a re-write to add further support.  If
> ZPCI_FN_SIZE isn't support, move on to the next thing.

yes, clear.

> 
>> +	fn_size +=  sizeof(struct vfio_info_cap_header);
>> +	total_size = fn_size;
> 
> Here too, total_size should be initialized to zero and each section +=
> the size they'd like to add.

thanks, clear too.

> 
>> +
>> +	grp_size = iommu_domain_get_attr(d->domain,
>> +					 DOMAIN_ATTR_ZPCI_GRP_SIZE, NULL);
>> +	if (grp_size < 0)
>> +		return grp_size;
>> +	grp_size +=  sizeof(struct vfio_info_cap_header);
>> +	total_size += grp_size;
>> +
>> +	/* Tell caller to call us with a greater buffer */
>> +	if (total_size > size) {
>> +		caps->size = total_size;
>> +		return 0;
>> +	}
>> +
>> +	info_fn = kzalloc(fn_size, GFP_KERNEL);
>> +	if (!info_fn)
>> +		return -ENOMEM;
> 
> Maybe fn_size was zero because we're not on Z.
> 
>> +	ret = iommu_domain_get_attr(d->domain,
>> +				    DOMAIN_ATTR_ZPCI_FN, &info_fn->data);
> 
> Kernel internal structures != user api.  Thanks,
> 
> Alex

Thanks a lot Alex,
I understand the concerns, I was too focussed on Z, I will rework this 
as you said:
- definition of the user API and
- take care that another architecture may want to use the interface.

Regards,
Pierre



-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany


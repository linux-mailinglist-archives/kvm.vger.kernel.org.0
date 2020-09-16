Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C993226CD68
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgIPU7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:59:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgIPQb3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 12:31:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08GCWbEs117304;
        Wed, 16 Sep 2020 08:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3ITlY2rzSr0X3crvr2mJz9ylgP54qmuygZyjBqSVzNE=;
 b=Qn4wwkmFoAH765uJ+9LkqM/GBOSbd4C9ruHyS/FFTaXuzbDRnaOPNlVz5/mm5qT2TFoG
 7F0nkpRQPMMyBk5x4H3abGZYSJbBA81/geub3egwDPLDll7+kgRU+E7q1dPQzDRaNTqF
 1kk4wdVxgaXHGH1UURLO6O2IMwD/wqYt7HzqSJKezr09g5MMsHxzNU0j9AV0kxLlJRg+
 dbLsnVLeBfG1Z0u5P35sHrT37PhEHfpmzZKxTl3dO/ArCkt3zhBJqdzTRfbak8/aLlVO
 1eq+9uuNIZ2Vv2KhiHi2pLtDc6aW8Hm8lkJVXx8BONLjaDT/zCmzbhoQhcxPdkAcCOO2 jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33kgrn4qwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 08:55:08 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08GCWkiE118271;
        Wed, 16 Sep 2020 08:55:07 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33kgrn4qvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 08:55:07 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08GClnZx002588;
        Wed, 16 Sep 2020 12:55:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 33k6he4g7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 12:55:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08GCt54R41091414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 12:55:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB9E28058;
        Wed, 16 Sep 2020 12:55:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5948628065;
        Wed, 16 Sep 2020 12:55:02 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 12:55:01 +0000 (GMT)
Subject: Re: [PATCH v3 4/5] s390x/pci: Add routine to get the vfio dma
 available count
To:     Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, david@redhat.com,
        qemu-s390x@nongnu.org, schnelle@linux.ibm.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, rth@twiddle.net
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
 <1600197283-25274-5-git-send-email-mjrosato@linux.ibm.com>
 <0b28ae63-faad-953d-85c2-04bcdefeb7bf@redhat.com>
 <20200916122720.4c7d8671.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <a2599938-d0b8-4436-2cf6-ceed9bba28f3@linux.ibm.com>
Date:   Wed, 16 Sep 2020 08:55:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200916122720.4c7d8671.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_07:2020-09-16,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=2 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/20 6:27 AM, Cornelia Huck wrote:
> On Wed, 16 Sep 2020 09:21:39 +0200
> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> 
>> On 9/15/20 9:14 PM, Matthew Rosato wrote:
>>> Create new files for separating out vfio-specific work for s390
>>> pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
>>> ioctl to collect the current dma available count.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   hw/s390x/meson.build     |  1 +
>>>   hw/s390x/s390-pci-vfio.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>   hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
>>>   3 files changed, 72 insertions(+)
>>>   create mode 100644 hw/s390x/s390-pci-vfio.c
>>>   create mode 100644 hw/s390x/s390-pci-vfio.h
>>>
> 
> (...)
> 
>>> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
>>> new file mode 100644
>>> index 0000000..75e3ac1
>>> --- /dev/null
>>> +++ b/hw/s390x/s390-pci-vfio.c
>>> @@ -0,0 +1,54 @@
>>> +/*
>>> + * s390 vfio-pci interfaces
>>> + *
>>> + * Copyright 2020 IBM Corp.
>>> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>>> + * your option) any later version. See the COPYING file in the top-level
>>> + * directory.
>>> + */
>>> +
>>> +#include <sys/ioctl.h>
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "s390-pci-vfio.h"
>>> +#include "hw/vfio/vfio-common.h"
>>> +
>>> +/*
>>> + * Get the current DMA available count from vfio.  Returns true if vfio is
>>> + * limiting DMA requests, false otherwise.  The current available count read
>>> + * from vfio is returned in avail.
>>> + */
>>> +bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
>>> +{
>>> +    g_autofree struct vfio_iommu_type1_info *info;
>>> +    uint32_t argsz;
>>> +    int ret;
>>> +
>>> +    assert(avail);
>>> +
>>> +    argsz = sizeof(struct vfio_iommu_type1_info);
>>> +    info = g_malloc0(argsz);
>>> +    info->argsz = argsz;
>>> +    /*
>>> +     * If the specified argsz is not large enough to contain all
>>> +     * capabilities it will be updated upon return.  In this case
>>> +     * use the updated value to get the entire capability chain.
>>> +     */
>>> +    ret = ioctl(fd, VFIO_IOMMU_GET_INFO, info);
>>> +    if (argsz != info->argsz) {
>>> +        argsz = info->argsz;
>>> +        info = g_realloc(info, argsz);
>>
>> Do we need to bzero [sizeof(struct vfio_iommu_type1_info)..argsz[?
> 
> If we do, I think we need to do the equivalent in
> vfio_get_region_info() as well?
> 

I agree that it would need to be in both places or neither -- I would 
expect the re-driven ioctl to overwrite the prior contents of info 
(unless we get a bad ret, but in this case we don't care what is in info)?

Perhaps the fundamental difference between this code and 
vfio_get_region_info is that the latter checks for only a growing argsz 
and retries, whereas this code checks for != so it's technically 
possible for a smaller argsz to trigger the retry here, and we wouldn't 
know for sure that all bytes from the first ioctl call were overwritten.

What if I adjust this code to look like vfio_get_region_info:

retry:
	info->argsz = argsz;

	if (ioctl(fd, VFIO_IOMMU_GET_INFO, info)) {
		// no need to g_free() bc of g_autofree
		return false;	
	}

	if (info->argsz > argsz) {
		argsz = info->argsz;
		info = g_realloc(info, argsz);
		goto retry;
	}

	/* If the capability exists, update with the current value */
	return vfio_get_info_dma_avail(info, avail);

Now we would only trigger when we are told by the host that the buffer 
must be larger.

> (Also, shouldn't we check ret before looking at info->argsz?)
> 

Yes, you are correct.  The above proposal would fix that issue too.

>>
>>> +        info->argsz = argsz;
>>> +        ret = ioctl(fd, VFIO_IOMMU_GET_INFO, info);
>>> +    }
>>> +
>>> +    if (ret) {
>>> +        return false;
>>> +    }
>>> +
>>> +    /* If the capability exists, update with the current value */
>>> +    return vfio_get_info_dma_avail(info, avail);
>>> +}
>>> +
> 
> (...)
> 
> 


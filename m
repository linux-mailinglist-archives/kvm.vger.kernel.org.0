Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F542743C6
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVOCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:02:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726507AbgIVOCn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:02:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MDhnu6018176;
        Tue, 22 Sep 2020 10:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1JU6MVfafMU5o1iLvErT4N9OypiVcthSuaXm4aj5xq8=;
 b=YBw0WmWI3XYsW66/MRgIjx6A/tSlNyLlU4X0VTOeGt5wRyo//29kt0NFToeiEXT8QYpc
 Xfp1A9Mt2PWN4jZwWHqgTIk+IOHpSa1y24wDVlpy794ZI9UuSWRKMC0f/brUuZtXV8I2
 ljGWj+xxF9L9SDHvr77vurRhXephrN7t+VUUZo0TCTDSJ7S7n8oD2im5rizLgFKXP3mL
 LDLsEu5plYJSMHUOpxuxCgk6/bInj4/oP4hg62+YQPZTghnChSJ2yWoNj2Fr0F6adPV4
 wtNv8LxRZTFzBS/1kASi1opGTGCQhBFOVF3ndJFDSQiGg7LN5N5yMFjdM0XEIX7Fs6pR 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qjdfrnay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 10:02:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08MDivlI026121;
        Tue, 22 Sep 2020 10:02:42 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qjdfrna5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 10:02:42 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08MDuqVC022921;
        Tue, 22 Sep 2020 14:02:41 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 33n9m95223-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 14:02:41 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08ME2cei62980502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 14:02:38 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5417BC6069;
        Tue, 22 Sep 2020 14:02:38 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59E33C605A;
        Tue, 22 Sep 2020 14:02:37 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Sep 2020 14:02:37 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: use a device region to retrieve zPCI
 information
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-5-git-send-email-mjrosato@linux.ibm.com>
 <20200922132239.4be1e749.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <4c339a61-8013-f380-e608-1d81ebdfc0d0@linux.ibm.com>
Date:   Tue, 22 Sep 2020 10:02:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922132239.4be1e749.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_12:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/20 7:22 AM, Cornelia Huck wrote:
> On Sat, 19 Sep 2020 11:28:38 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Define a new configuration entry VFIO_PCI_ZDEV for VFIO/PCI.
>>
>> When this s390-only feature is configured we initialize a new device
>> region, VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, to hold information provided
>> by the underlying hardware.
>>
>> This patch is based on work previously done by Pierre Morel.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/Kconfig            |  13 ++
>>   drivers/vfio/pci/Makefile           |   1 +
>>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>>   drivers/vfio/pci/vfio_pci_private.h |  10 ++
>>   drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
> 
> Maybe you want to add yourself to MAINTAINERS for the zdev-specific
> files? You're probably better suited to review changes to the
> zpci-specific code :)

Of course, will do.  Looking at how we split vfio-ap and vfio-ccw, I'll 
add an S390 VFIO-PCI DRIVER category and point to the new .h and .c file 
for now.

> 
>>   5 files changed, 274 insertions(+)
>>   create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
> 
> (...)
> 
>> +int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
>> +{
>> +	struct vfio_region_zpci_info *region;
>> +	struct zpci_dev *zdev;
>> +	size_t clp_offset;
>> +	int size;
>> +	int ret;
>> +
>> +	if (!vdev->pdev->bus)
>> +		return -ENODEV;
>> +
>> +	zdev = to_zpci(vdev->pdev);
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	/* Calculate size needed for all supported CLP features  */
>> +	size = sizeof(*region) +
>> +	       sizeof(struct vfio_region_zpci_info_qpci) +
>> +	       sizeof(struct vfio_region_zpci_info_qpcifg) +
>> +	       (sizeof(struct vfio_region_zpci_info_util) + CLP_UTIL_STR_LEN) +
>> +	       (sizeof(struct vfio_region_zpci_info_pfip) +
>> +		CLP_PFIP_NR_SEGMENTS);
>> +
>> +	region = kmalloc(size, GFP_KERNEL);
>> +	if (!region)
>> +		return -ENOMEM;
>> +
>> +	/* Fill in header */
>> +	region->argsz = size;
>> +	clp_offset = region->offset = sizeof(struct vfio_region_zpci_info);
>> +
>> +	/* Fill the supported CLP features */
>> +	clp_offset = vfio_pci_zdev_add_qpci(zdev, region, clp_offset);
>> +	clp_offset = vfio_pci_zdev_add_qpcifg(zdev, region, clp_offset);
>> +	clp_offset = vfio_pci_zdev_add_util(zdev, region, clp_offset);
>> +	clp_offset = vfio_pci_zdev_add_pfip(zdev, region, clp_offset);
> 
> So, the regions are populated once. Can any of the values in the
> hardware structures be modified by a guest? Or changed from the
> hardware side?
> 

The region is created read-only (vfio_pci_zdev_rw returns -EINVAL on 
writes), so no guest modification.  The expectation is the guest can 
read the region and take what it wants / ignore what it doesn't.

The CLPs covered by this region are not intended to change once the 
device is up.

If we end up needing either of the above for a different CLP, I would 
think an additional/different region would be appropriate.


>> +
>> +	ret = vfio_pci_register_dev_region(vdev,
>> +		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
>> +		VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, &vfio_pci_zdev_regops,
>> +		size, VFIO_REGION_INFO_FLAG_READ, region);
>> +	if (ret)
>> +		kfree(region);
>> +
>> +	return ret;
>> +}
> 


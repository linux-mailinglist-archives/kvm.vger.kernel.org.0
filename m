Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC992FEF9F
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbhAUP6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:58:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731997AbhAUP6Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:58:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LFfAFM095092;
        Thu, 21 Jan 2021 10:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aUzlW6OmzRF8L9tqsonxhEkhGROnzfr5qZ6BrdV3glw=;
 b=HC3rFdzRmk9/yAsqrTRg6wy0f0jyyWqVSnbO43s1+horYqcNPMo77ajr3G5MwdDBWnfc
 1iVyhOdfVzzYoD2Y/UF0C5Y+g/A9z+hFluhD+qjg9q8DqEwnZ51oSyfWlduQ5GSG2wYo
 cIQSOC93KEV9IeBQM5tToxDOgCtGG7TUnH2bbJDeZWSQDdopYVFV2OFyQ9GP6cmUgpyp
 z7Py7Sq3dyKnOMxpTDgZZUK4hGNF2oJUqcvK8Q8rD1fsGb/E6n9dLc6cX2Hx8jgo3PQk
 wdWwlKNeK7LOzeB5L7TF814YHyybu22IaEu8hvwzHa+TuCLj1WQUcMFcFCrvhoRqURZc JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367cfbgenx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:57:19 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LFhGMk100924;
        Thu, 21 Jan 2021 10:57:18 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367cfbgen7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:57:18 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFVXuK008493;
        Thu, 21 Jan 2021 15:57:17 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3668pc55ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:57:17 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFvFTF8192532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:57:15 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6E1E2805C;
        Thu, 21 Jan 2021 15:57:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF83328059;
        Thu, 21 Jan 2021 15:57:13 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:57:13 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
 <5d048eb9-72e5-e713-5c1a-56a1c3d957c4@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <594f94fd-d725-bc3f-31d1-2d7333234682@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:57:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5d048eb9-72e5-e713-5c1a-56a1c3d957c4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 5:01 AM, Niklas Schnelle wrote:
> 
> 
> On 1/19/21 9:02 PM, Matthew Rosato wrote:
>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
>> specific requirements in terms of alignment as well as the patterns in
>> which the data is read/written. Allowing these to proceed through the
>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
>> way that these requirements can't be guaranteed. In addition, ISM devices
>> do not support the MIO codepaths that might be triggered on vfio I/O coming
>> from userspace; we must be able to ensure that these devices use the
>> non-MIO instructions.  To facilitate this, provide a new vfio region by
>> which non-MIO instructions can be passed directly to the host kernel s390
>> PCI layer, to be reliably issued as non-MIO instructions.
>>
>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
>> and implements the ability to pass PCISTB and PCILG instructions over it,
>> as these are what is required for ISM devices.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>>   drivers/vfio/pci/vfio_pci_private.h |   6 ++
>>   drivers/vfio/pci/vfio_pci_zdev.c    | 158 ++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h           |   4 +
>>   include/uapi/linux/vfio_zdev.h      |  33 ++++++++
>>   5 files changed, 209 insertions(+)
> 
> Related to the discussion on the QEMU side, if we have a check
> to make sure this is only used for ISM, then this patch should
> make that clear in its wording and also in the paths
> (drivers/vfio/pci/vfio_pci_ism.c instead of vfio_pci_zdev.c.)
> This also has precedent with the region for IGD in
> drivers/vfio/pci/vfio_pci_igd.c.
> 

This is a fair point, but just to tie up threads here -- the QEMU 
discussion has since moved towards making the use-case less restrictive 
rather than ISM-only (though getting ISM working is still the motivating 
factor here).  So as such I think I'd prefer to keep this in 
vfio_pci_zdev.c as other hardware could use the region if they meet the 
necessary criteria.

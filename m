Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A11412A07
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhIUAnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:43:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230220AbhIUAlu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:41:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KNtE3x000426;
        Mon, 20 Sep 2021 20:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yVM7zOPRxS6nVLAci1t9AXbV5zJn1EiXzX46PrWtdIg=;
 b=FXF5d1vBArH7ggi4P/KvQ162cjaZ+4fXXE1kgVwPm/bx+7D2TrJm8AdsOgxfITUfUCyG
 kPFtVsaDwyEwFdzGN08b6m3EH/O0yCAvUxcX6MlfCTwWmDUIa9U6qbKJ3+ozamlbB5cn
 atIfSEQs8AwuJKSt1VQltNho2f3dsijVIy7/ue/uxdMuYLJZvgZ0LETyVYt/iTzNchC1
 57YABivFjrNj3FNufp80wJL/qZR0t7OYlmyHU68dRBUxa/5Go3o6KiG/66BZGVQXNyug
 BEuq9sgF3LLBmhd+kw1/s3FsD2w4EEDX8S0eqbEMC0d2Uy/b+ZKhFzbOQsDyBB2jn10u 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b70f5des6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 20:40:19 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18L0KpiC006872;
        Mon, 20 Sep 2021 20:40:18 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b70f5dery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 20:40:18 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18L0I6EF019418;
        Tue, 21 Sep 2021 00:40:17 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 3b57ra47ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 00:40:17 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18L0eGZA50921736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:40:16 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20E4F6E052;
        Tue, 21 Sep 2021 00:40:16 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6844E6E050;
        Tue, 21 Sep 2021 00:40:13 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.65.75.198])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Sep 2021 00:40:13 +0000 (GMT)
Subject: Re: [PATCH v2] vfio/ap_ops: Add missed vfio_uninit_group_dev()
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
References: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
 <20210916125130.2db0961e.alex.williamson@redhat.com>
 <ee2a0623-84d5-8c21-cc40-de5991ff94b1@linux.ibm.com>
 <20210920231945.GG327412@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <72fe03f8-dbd0-89e4-036f-e5c7ecc02263@linux.ibm.com>
Date:   Mon, 20 Sep 2021 20:40:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920231945.GG327412@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Iw-orvwK4dAGbS-zK8RldTCv6CK96AK
X-Proofpoint-ORIG-GUID: LEnd-x9llfuOhwzSC6UjUpWl89u_VsEV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/20/21 7:19 PM, Jason Gunthorpe wrote:
> On Mon, Sep 20, 2021 at 05:26:25PM -0400, Tony Krowiak wrote:
>>
>> On 9/16/21 2:51 PM, Alex Williamson wrote:
>>> On Fri, 10 Sep 2021 20:06:30 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> Without this call an xarray entry is leaked when the vfio_ap device is
>>>> unprobed. It was missed when the below patch was rebased across the
>>>> dev_set patch.
>>>>
>>>> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>> Hi Tony, Halil, Jason (H),
>>>
>>> Any acks for this one?  Thanks,
>>>
>>> Alex
>> I installed this on a test system running the latest linux
>> code from our library and ran our test suite. I got the
>> following running a simple test case that assigns some
>> adapters and domains to a mediated device then
>> starts a guest using the mdev.
> Oh, neat. There is no reason for this stuff to be in the
> matrix_dev->lock, it should be symmetrical with the error unwind in
> probe.

I moved the vfio_uninit_group_dev outside of the matrix_dev->lock
and it fixed the problem:

static void vfio_ap_mdev_remove(struct mdev_device *mdev)
         mutex_lock(&matrix_dev->lock);
         vfio_ap_mdev_reset_queues(matrix_mdev);
         list_del(&matrix_mdev->node);
         atomic_inc(&matrix_dev->available_instances);
         mutex_unlock(&matrix_dev->lock);

         vfio_uninit_group_dev(&matrix_mdev->vdev);
         kfree(matrix_mdev);
  }

>
> I'll resend it.
>
> Thanks,
> Jason


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D682CF50A
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgLDTtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:49:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730458AbgLDTtu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 14:49:50 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JiDdp195809;
        Fri, 4 Dec 2020 14:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PMP990OpSj6OZpGkdxY1+gfEYrTaoL+9oQrzuPmHBDQ=;
 b=DLY2kXAaUctpX5Ra9dviGVcz9CvXqlJ0bUMJ2QU7jehH8QgRkWC1qX1OflMCYw7BFi9Q
 qNcu+BZYoCrVxNX2ULSIaG06GDNey5w1RIHcxdqZYlIJ9adA9PLpgbdn+T+Nd3zjBL85
 aUW5Xw/EJaUTep3Fkh9CIPncqt8umzFaQtSEDciN3fLm5DsE7QkUtOIrhuv8/zCLNdVv
 qdYBzM696H3570GkiKgratoOe7IYGWvFlPmfRys8JeSmfhuHKm+KvkYgHfG1iAiWi+K5
 hhbBi8jAa+FYDsXGPAe4fs2+zOkEoKDehpq4oQ5smQFS59fyH6vc3brv5OUrsmf87Kfi KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357t9w24bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:49:09 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4Jlc8l028672;
        Fri, 4 Dec 2020 14:49:09 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357t9w24au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:49:09 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JkQiZ028045;
        Fri, 4 Dec 2020 19:49:07 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrgd815-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 19:49:07 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4JlpgW8716966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 19:47:51 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E00E28060;
        Fri,  4 Dec 2020 19:47:51 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D90032805E;
        Fri,  4 Dec 2020 19:47:50 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.205])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 19:47:50 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
 <a5a613ef-4c74-ad68-46bd-7159fbafef47@linux.ibm.com>
 <20201204175707.13f019cf.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8e3caeb1-49b1-0b00-a6e6-80e98f5d82e9@linux.ibm.com>
Date:   Fri, 4 Dec 2020 14:47:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201204175707.13f019cf.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=3 clxscore=1015 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/4/20 11:57 AM, Cornelia Huck wrote:
> On Fri, 4 Dec 2020 11:48:24 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 12/3/20 12:55 PM, Halil Pasic wrote:
>>> On Wed,  2 Dec 2020 18:41:01 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> The vfio_ap device driver registers a group notifier with VFIO when the
>>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>>>> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
>>>> and calls the kvm_get_kvm() function to increment its reference counter.
>>>> When the notifier is called to make notification that the KVM pointer has
>>>> been set to NULL, the driver should clean up any resources associated with
>>>> the KVM pointer and decrement its reference counter. The current
>>>> implementation does not take care of this clean up.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Do we need a Fixes tag? Do we need this backported? In my opinion
>>> this is necessary since the interrupt patches.
>> I'll put in a fixes tag:
>> Fixes: 258287c994de (s390: vfio-ap: implement mediated device open callback)
> The canonical format would be
>
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")

Okay.

>
>> Yes, this should probably be backported.
>>
>>>   
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>>>>    1 file changed, 13 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index e0bde8518745..eeb9c9130756 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>>>    	return NOTIFY_DONE;
>>>>    }
>>>>    
>>>> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
>>> I don't like the name. The function does more that put_kvm. Maybe
>>> something  like _disconnect_kvm()?
>> Since the vfio_ap_mdev_set_kvm() function is called by the
>> notifier when the KVM pointer is set, how about:
>>
>> vfio_ap_mdev_unset_kvm()
>>
>> for when the KVM pointer is nullified?
> Sounds good to me.
>


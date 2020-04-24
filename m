Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7276C1B7C46
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXQ6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 12:58:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgDXQ6y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 12:58:54 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OGWpHi076491;
        Fri, 24 Apr 2020 12:58:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrxp0q3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 12:58:52 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OGWpk4076487;
        Fri, 24 Apr 2020 12:58:52 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrxp0q2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 12:58:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OGoRcP007910;
        Fri, 24 Apr 2020 16:58:50 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 30fs67320c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 16:58:50 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OGwluY55574910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:58:47 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FAE13604F;
        Fri, 24 Apr 2020 16:58:47 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E411A136053;
        Fri, 24 Apr 2020 16:58:45 +0000 (GMT)
Received: from cpe-66-24-59-227.stny.res.rr.com (unknown [9.85.130.212])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 16:58:45 +0000 (GMT)
Subject: Re: [PATCH v7 04/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-5-akrowiak@linux.ibm.com>
 <20200416131845.3ef6b3b5.cohuck@redhat.com>
 <5cf7d611-e30c-226d-0d3d-d37170f117f4@linux.ibm.com>
 <20200424051315.20f17133.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6b4e59cd-8682-d0d4-7244-cf7ba7d9a2be@linux.ibm.com>
Date:   Fri, 24 Apr 2020 12:58:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200424051315.20f17133.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_08:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 suspectscore=3 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/23/20 11:13 PM, Halil Pasic wrote:
> On Thu, 16 Apr 2020 10:45:20 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>
>> On 4/16/20 7:18 AM, Cornelia Huck wrote:
>>> On Tue,  7 Apr 2020 15:20:04 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>
>>>> Let's implement the callback to indicate when an APQN
>>>> is in use by the vfio_ap device driver. The callback is
>>>> invoked whenever a change to the apmask or aqmask would
>>>> result in one or more queue devices being removed from the driver. The
>>>> vfio_ap device driver will indicate a resource is in use
>>>> if the APQN of any of the queue devices to be removed are assigned to
>>>> any of the matrix mdevs under the driver's control.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>>>>    drivers/s390/crypto/vfio_ap_ops.c     | 47 +++++++++++++++++----------
>>>>    drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>>>    3 files changed, 33 insertions(+), 17 deletions(-)
>>>> @@ -1369,3 +1371,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>>>>    	kfree(q);
>>>>    	mutex_unlock(&matrix_dev->lock);
>>>>    }
>>>> +
>>>> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>>>> +{
>>>> +	bool in_use;
>>>> +
>>>> +	mutex_lock(&matrix_dev->lock);
>>>> +	in_use = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm) ? true : false;
>>> Maybe
>>>
>>> in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
>>>
>>> ?
>> To be honest, I find the !! expression very confusing. Every time I see
>> it, I have
>> to spend time thinking about what the result of !! is going to be. I think
>> the statement should be left as-is because it more clearly expresses
>> the intent.
>>
> This is discussion is just about cosmetics, I believe. Just a piece of
> advice: try to be sensitive about the community. In this community, and
> I believe in C general !! is the idiomatic way to convert number to
> boolean. Why would one want to do that is a bit longer story. The short
> version is in logic condition context the value 0 is false and any
> other value is true. !! keeps false value (0) false, and forces a true to
> the most true true value. If you keep getting confused every time you
> run across a !! that won't help with reading other peoples C.
>
> Regards,
> Halil

The point is moot. After seeing that Conny's comment generated a
discussion, I decided to avoid wasting additional time discussing
personal preferences and am now using the !! syntax. Unfortunately,
I've been having some odd problems with my email client and my
response to Pierre's comment never made it to the list, so I apologize
that you had to waste valuable time on your tutorial.

>
>>>> +	mutex_unlock(&matrix_dev->lock);
>>>> +
>>>> +	return in_use;
>>>> +}


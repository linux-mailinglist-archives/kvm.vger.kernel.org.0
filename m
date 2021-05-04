Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3097E372CC5
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 17:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhEDPLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 11:11:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13034 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhEDPLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 11:11:51 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144F2r9R133118;
        Tue, 4 May 2021 11:10:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FV62r63UU0u17Cog/FRiEeJ1q2bcxJbuCanzevxgAIM=;
 b=e28HgJtGcUKLvIPlc8K+Cj9PShetHeRGOIrCbD9aDtuFKzcypJbJ6H8QYhOj7reR1Dya
 0WeyjbCDg5czPdLlC/KosioIhoeSn4MFDs/6eIi7JwRus5NxHtDO5LY/0YBr+3uiIWKj
 rIiZg0xsXpBM6VV0m4jzL5lPtvlY+BBcvw7sn0r1X2hprphqR742hI8NTSMYf0yfOXG/
 fvN9GYdpXLZ1pt8eQnSLbsmz5fUvcKsMAX23kjVtHIuxq/pC7P4bb//oYKADFXqqE6tp
 AElOkGm+2HYNNCg94CYdec4o8oJTXlqu/cFm++WXD7QhBbko8Eg7dcYS0gdepe8iLF9O Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38b7hwjgab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 11:10:49 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 144F4JZf143293;
        Tue, 4 May 2021 11:10:48 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38b7hwjg9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 11:10:48 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 144ErID2013873;
        Tue, 4 May 2021 15:10:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 388xm8gq3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 15:10:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 144FAhqU27263374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 May 2021 15:10:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F1B14204C;
        Tue,  4 May 2021 15:10:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B32A142041;
        Tue,  4 May 2021 15:10:42 +0000 (GMT)
Received: from oc6887364776.ibm.com (unknown [9.145.169.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 May 2021 15:10:42 +0000 (GMT)
Subject: Re: s390 common I/O layer locking
To:     Cornelia Huck <cohuck@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
 <20210428172008.GV1370958@nvidia.com>
 <20210429135855.443b7a1b.cohuck@redhat.com>
 <20210429181347.GA3414759@nvidia.com>
 <20210430143140.378904bf.cohuck@redhat.com>
 <20210430171908.GD1370958@nvidia.com>
 <20210503125440.0acd7c1f.cohuck@redhat.com>
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
Message-ID: <292442e8-3b1a-56c4-b974-05e8b358ba64@linux.ibm.com>
Date:   Tue, 4 May 2021 17:10:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210503125440.0acd7c1f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A68hUm527tQ2hObdklKVI-O3N_tbMUq4
X-Proofpoint-ORIG-GUID: PgF53yaSizNLAJlz8l6mrwyGMSvzC5KN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_08:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=557 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 12:54 PM, Cornelia Huck wrote:
> On Fri, 30 Apr 2021 14:19:08 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Fri, Apr 30, 2021 at 02:31:40PM +0200, Cornelia Huck wrote:
>>> On Thu, 29 Apr 2021 15:13:47 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>> All the checks for !private need some kind of locking. The driver core
>>>> model is that the 'struct device_driver' callbacks are all called
>>>> under the device_lock (this prevents the driver unbinding during the
>>>> callback). I didn't check if ccs does this or not..
>>> probe/remove/shutdown are basically a forward of the callbacks at the
>>> bus level.
>> These are all covered by device_lock
>>
>>> The css bus should make sure that we serialize
>>> irq/sch_event/chp_event with probe/remove.
>> Hum it doesn't look OK, like here:
>>
>> css_process_crw()
>>    css_evaluate_subchannel()
>>     sch = bus_find_device()
>>        -- So we have a refcount on the struct device
>>     css_evaluate_known_subchannel() {
>> 	if (sch->driver) {
>> 		if (sch->driver->sch_event)
>> 			ret = sch->driver->sch_event(sch, slow);
>>     }
>>
>> But the above call and touches to sch->driver (which is really just
>> sch->dev.driver) are unlocked and racy.
>>
>> I would hold the device_lock() over all touches to sch->driver outside
>> of a driver core callback.
> I think this issue did not come up much before, as most drivers on the
> css bus tend to stay put during the lifetime of the device; but yes, it
> seems we're missing some locking.
>
> For the css bus, we need locking for the event callbacks; for irq, this
> may interact with the subchannel lock and likely needs some care.
>
> I also looked at the other busses in the common I/O layer: scm looks
> good at a glance, ccwgroup and ccw have locking for online/offline; the
> other callbacks for the ccw drivers probably need to take the device
> lock as well.
>
> Common I/O layer maintainers, does that look right?
>
I just had a quick glance on the CIO layer drivers. And at first look, 
you are right.
It looks likewe need modifications in the event callbacks (referring css 
here)
Let me go thoughthis thoroughly and update.
Thank you.

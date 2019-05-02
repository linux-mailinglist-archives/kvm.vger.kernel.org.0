Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA0114A4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 09:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfEBH5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 03:57:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbfEBH5k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 03:57:40 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x427vXcB145804
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 03:57:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s7t49ddw1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 03:57:39 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 2 May 2019 08:57:35 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 May 2019 08:57:33 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x427vW5a52428928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 May 2019 07:57:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0574A4040;
        Thu,  2 May 2019 07:57:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C2FA4051;
        Thu,  2 May 2019 07:57:31 +0000 (GMT)
Received: from [9.145.190.191] (unknown [9.145.190.191])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 May 2019 07:57:31 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
 <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
 <20190430152605.3bb21f31.pasic@linux.ibm.com>
 <622a9ab0-579d-17f4-6fa1-74d73da13b19@linux.ibm.com>
Date:   Thu, 2 May 2019 09:57:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <622a9ab0-579d-17f4-6fa1-74d73da13b19@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050207-4275-0000-0000-0000033087E4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050207-4276-0000-0000-0000383FE5F4
Message-Id: <42185132-dfc4-c997-3d69-31e43d25e525@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=658 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905020061
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/2019 16:09, Pierre Morel wrote:
> On 30/04/2019 15:26, Halil Pasic wrote:
>> On Fri, 26 Apr 2019 15:01:27 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> +/**
>>> + * vfio_ap_clrirq: Disable Interruption for a APQN
>>> + *
>>> + * @dev: the device associated with the ap_queue
>>> + * @q:   the vfio_ap_queue holding AQIC parameters
>>> + *
>>> + * Issue the host side PQAP/AQIC
>>> + * On success: unpin the NIB saved in *q and unregister from GIB
>>> + * interface
>>> + *
>>> + * Return the ap_queue_status returned by the ap_aqic()
>>> + */
>>> +static struct ap_queue_status vfio_ap_clrirq(struct vfio_ap_queue *q)
>>> +{
>>> +    struct ap_qirq_ctrl aqic_gisa = {};
>>> +    struct ap_queue_status status;
>>> +    int checks = 10;
>>> +
>>> +    status = ap_aqic(q->apqn, aqic_gisa, NULL);
>>> +    if (!status.response_code) {
>>> +        while (status.irq_enabled && checks--) {
>>> +            msleep(20);
>>
>> Hm, that seems like a lot of time to me. And I suppose we are holding the
>> kvm lock: e.g. no other instruction can be interpreted by kvm in the
>> meantime.
>>
>>> +            status = ap_tapq(q->apqn, NULL);
>>> +        }
>>> +        if (checks >= 0)
>>> +            vfio_ap_free_irq_data(q);
>>
>> Actually we don't have to wait for the async part to do it's magic
>> (indicated by the status.irq_enabled --> !status.irq_enabled transition)
>> in the instruction handler. We have to wait so we can unpin the NIB but
>> that could be done async (e.g. workqueue).
>>
>> BTW do you have any measurements here? How many msleep(20) do we
>> experience for one clear on average?
> 
> No idea but it is probably linked to the queue state and usage history.
> I can use a lower sleep time and increment the retry count.
> 
>>
>> If linux is not using clear (you told so offline, and I also remember
>> something similar), we can probably get away with something like this,
>> and do it properly (from performance standpoint) later.
> 
> In the Linux AP code it is only used once, in the explicit
> ap_queue_enable_interruption() function.

My answer is not clear: ap_aqic() is used only once, during the bus 
probe, in the all code to enable interrupt and is never used to disable 
interrupt.

Interrupt disabling is only done by using ap_zapq() or ap_rapq() which 
can not be intercepted.


> 
> Yes, thanks, I will keep it as is, may be just play with msleep()time 
> and retry count.
> 
> Regards,
> Pierre
> 
>>
>> Regards,
>> Halil
>>
>>> +        else
>>> +            WARN_ONCE("%s: failed disabling IRQ", __func__);
>>> +    }
>>> +
>>> +    return status;
>>> +}
>>
> 
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA90F212
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 10:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfD3IdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 04:33:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbfD3IdB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 04:33:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3U8WIlV010605
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 04:33:00 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s6jxm80u1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 04:32:59 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 30 Apr 2019 09:32:58 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 09:32:55 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3U8WrrL53608484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 08:32:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A1511C04C;
        Tue, 30 Apr 2019 08:32:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0739C11C052;
        Tue, 30 Apr 2019 08:32:53 +0000 (GMT)
Received: from [9.152.222.31] (unknown [9.152.222.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Apr 2019 08:32:52 +0000 (GMT)
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
 <20190429185002.6041eecc.pasic@linux.ibm.com>
 <14453f04-f13f-f63c-fd8a-d9d8834182e0@linux.ibm.com>
Date:   Tue, 30 Apr 2019 10:32:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <14453f04-f13f-f63c-fd8a-d9d8834182e0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19043008-4275-0000-0000-0000032FD3BF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043008-4276-0000-0000-0000383F2B89
Message-Id: <efa8840b-35b1-2823-697f-ab56d4898854@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/2019 10:18, Pierre Morel wrote:
> On 29/04/2019 18:50, Halil Pasic wrote:
>> On Fri, 26 Apr 2019 15:01:27 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> +static struct ap_queue_status vfio_ap_setirq(struct vfio_ap_queue *q)
>>> +{
>>> +    struct ap_qirq_ctrl aqic_gisa = {};
>>> +    struct ap_queue_status status = {};
>>> +    struct kvm_s390_gisa *gisa;
>>> +    struct kvm *kvm;
>>> +    unsigned long h_nib, h_pfn;
>>> +    int ret;
>>> +
>>> +    q->a_pfn = q->a_nib >> PAGE_SHIFT;
>>> +    ret = vfio_pin_pages(mdev_dev(q->matrix_mdev->mdev), &q->a_pfn, 1,
>>> +                 IOMMU_READ | IOMMU_WRITE, &h_pfn);
>>> +    switch (ret) {
>>> +    case 1:
>>> +        break;
>>> +    case -EINVAL:
>>> +    case -E2BIG:
>>> +        status.response_code = AP_RESPONSE_INVALID_ADDRESS;
>>> +        /* Fallthrough */
>>> +    default:
>>> +        return status;
>>
>> Can we actually hit the default label? AFICT you would return an
>> all-zero status, i.e. status.response_code == 0 'Normal completion'.
> 
> hum right, the setting of AP_INVALID_ADDRESS should be in the default 
> and there is no need for the two error cases, they will match the default.
> 
> 
>>
>>> +    }
>>> +
>>> +    kvm = q->matrix_mdev->kvm;
>>> +    gisa = kvm->arch.gisa_int.origin;
>>> +
>>> +    h_nib = (h_pfn << PAGE_SHIFT) | (q->a_nib & ~PAGE_MASK);
>>> +    aqic_gisa.gisc = q->a_isc;
>>> +    aqic_gisa.isc = kvm_s390_gisc_register(kvm, q->a_isc);
>>> +    aqic_gisa.ir = 1;
>>> +    aqic_gisa.gisa = gisa->next_alert >> 4;
>>
>> Why gisa->next_alert? Isn't this supposed to get set to gisa origin
>> (without some bits on the left)?
> 
> Someone already asked this question.
> The answer is: look at the ap_qirq_ctrl structure, you will see that the 
> gisa field is 27 bits wide.
> 
>>
>>> +
>>> +    status = ap_aqic(q->apqn, aqic_gisa, (void *)h_nib);
>>> +    switch (status.response_code) {
>>> +    case AP_RESPONSE_NORMAL:
>>> +        /* See if we did clear older IRQ configuration */
>>> +        if (q->p_pfn)
>>> +            vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
>>> +                     &q->p_pfn, 1);
>>> +        if (q->p_isc != VFIO_AP_ISC_INVALID)
>>> +            kvm_s390_gisc_unregister(kvm, q->p_isc);
>>> +        q->p_pfn = q->a_pfn;
>>> +        q->p_isc = q->a_isc;
>>> +        break;
>>> +    case AP_RESPONSE_OTHERWISE_CHANGED:
>>> +        /* We could not modify IRQ setings: clear new configuration */
>>> +        vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &q->a_pfn, 1);
>>> +        kvm_s390_gisc_unregister(kvm, q->a_isc);
>>
>> Hm, see below. Wouldn't you want to set a_isc to VFIO_AP_ISC_INVALID?
> 
> grrr!!! when did I insert these 3 lines, it was OK in previous series!
> all 3 lines, vfio_unpin() / gisc_unregister / break must go away.

No it wasn't, I will correct this.

> 
>>
>>> +        break;
>>> +    default:    /* Fall Through */
>>
>> Is it 'break' or is it 'Fall Through'?
> 
> it is a fall through
> 
>>
>>> +        pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
>>> +            status.response_code);
>>> +        vfio_ap_free_irq_data(q);
>>> +        break;
>>> +    }
>>> +
>>> +    return status;
>>> +}
> 
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany


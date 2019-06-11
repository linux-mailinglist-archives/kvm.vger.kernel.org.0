Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3043CEF0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391200AbfFKOiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 10:38:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387486AbfFKOiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jun 2019 10:38:13 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BEZORR004487
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:38:12 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2br38t0h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:38:05 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Tue, 11 Jun 2019 15:38:03 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 15:38:00 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BEbuX631129990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 14:37:56 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D0D57805F;
        Tue, 11 Jun 2019 14:37:56 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 916177805E;
        Tue, 11 Jun 2019 14:37:55 +0000 (GMT)
Received: from [9.60.75.173] (unknown [9.60.75.173])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 14:37:55 +0000 (GMT)
Subject: Re: [PATCH v9 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, borntraeger@de.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
 <1558452877-27822-4-git-send-email-pmorel@linux.ibm.com>
 <2ffee52b-5e7f-f52a-069f-0a43d6418341@linux.ibm.com>
 <20190607162903.22fd959f.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Tue, 11 Jun 2019 10:37:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190607162903.22fd959f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061114-8235-0000-0000-00000EA67704
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011247; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01216465; UDB=6.00639606; IPR=6.00997564;
 MB=3.00027264; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-11 14:38:02
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061114-8236-0000-0000-000045F9F9CA
Message-Id: <6bcb9a11-0a11-45c0-f0d6-f1fc43d7ee10@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/19 10:29 AM, Halil Pasic wrote:
> On Tue, 4 Jun 2019 15:38:51 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 5/21/19 11:34 AM, Pierre Morel wrote:
>>> We register a AP PQAP instruction hook during the open
>>> of the mediated device. And unregister it on release.
> 
> [..]
> 
>>> +/**
>>> + * vfio_ap_wait_for_irqclear
>>> + * @apqn: The AP Queue number
>>> + *
>>> + * Checks the IRQ bit for the status of this APQN using ap_tapq.
>>> + * Returns if the ap_tapq function succedded and the bit is clear.
>>
>> s/succedded/succeeded/
>>
> 
> I'm gonna fix this up when picking.
> 
>>> + * Returns if ap_tapq function failed with invalid, deconfigured or
>>> + * checkstopped AP.
>>> + * Otherwise retries up to 5 times after waiting 20ms.
>>> + *
>>> + */
>>> +static void vfio_ap_wait_for_irqclear(int apqn)
>>> +{
>>> +	struct ap_queue_status status;
>>> +	int retry = 5;
>>> +
>>> +	do {
>>> +		status = ap_tapq(apqn, NULL);
>>> +		switch (status.response_code) {
>>> +		case AP_RESPONSE_NORMAL:
>>> +		case AP_RESPONSE_RESET_IN_PROGRESS:
>>> +			if (!status.irq_enabled)
>>> +				return;
>>> +			/* Fall through */
>>> +		case AP_RESPONSE_BUSY:
>>> +			msleep(20);
>>> +			break;
>>> +		case AP_RESPONSE_Q_NOT_AVAIL:
>>> +		case AP_RESPONSE_DECONFIGURED:
>>> +		case AP_RESPONSE_CHECKSTOPPED:
>>> +		default:
>>> +			WARN_ONCE(1, "%s: tapq rc %02x: %04x\n", __func__,
>>> +				  status.response_code, apqn);
>>> +			return;
>>
>> Why not just break out of the loop and just use the WARN_ONCE
>> outside of the loop?
>>
> 
> AFAIU the idea was to differentiate between got a strange response_code
> and ran out of retires.

In both cases, the response code is placed into the message, so one
should be able to discern the reason in either case. This is not
critical, just an observation.

> 
> Actually I suspect that we are fine in case of AP_RESPONSE_Q_NOT_AVAIL,
>   AP_RESPONSE_DECONFIGURED and AP_RESPONSE_CHECKSTOPPED in a sense that
> what should be the post-condition of this function is guaranteed to be
> reached. What do you think?

That would seem to be the case given those response codes indicate the
queue is not accessible.

> 
> While I think that we can do better here, I see this as something that
> should be done on top.

Are you talking about a patch on top? What do you think needs to be
addressed?

> 
>>> +		}
>>> +	} while (--retry);
>>> +
>>> +	WARN_ONCE(1, "%s: tapq rc %02x: %04x could not clear IR bit\n",
>>> +		  __func__, status.response_code, apqn);
>>> +}
>>> +
>>> +/**
>>> + * vfio_ap_free_aqic_resources
>>> + * @q: The vfio_ap_queue
>>> + *
>>> + * Unregisters the ISC in the GIB when the saved ISC not invalid.
>>> + * Unpin the guest's page holding the NIB when it exist.
>>> + * Reset the saved_pfn and saved_isc to invalid values.
>>> + * Clear the pointer to the matrix mediated device.
>>> + *
>>> + */
> 
> [..]
> 
>>> +struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>>> +{
>>> +	struct ap_qirq_ctrl aqic_gisa = {};
>>> +	struct ap_queue_status status;
>>> +	int retries = 5;
>>> +
>>> +	do {
>>> +		status = ap_aqic(q->apqn, aqic_gisa, NULL);
>>> +		switch (status.response_code) {
>>> +		case AP_RESPONSE_OTHERWISE_CHANGED:
>>> +		case AP_RESPONSE_NORMAL:
>>> +			vfio_ap_wait_for_irqclear(q->apqn);
>>> +			goto end_free;
>>> +		case AP_RESPONSE_RESET_IN_PROGRESS:
>>> +		case AP_RESPONSE_BUSY:
>>> +			msleep(20);
>>> +			break;
>>> +		case AP_RESPONSE_Q_NOT_AVAIL:
>>> +		case AP_RESPONSE_DECONFIGURED:
>>> +		case AP_RESPONSE_CHECKSTOPPED:
>>> +		case AP_RESPONSE_INVALID_ADDRESS:
>>> +		default:
>>> +			/* All cases in default means AP not operational */
>>> +			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
>>> +				  status.response_code);
>>> +			goto end_free;
>>
>> Why not just break out of the loop instead of repeating the WARN_ONCE
>> message?
>>
> 
> I suppose the reason is same as above. I'm not entirely happy with this
> code myself. E.g. why do we do retries here -- shouldn't we just fail the
> aqic by the guest?

According to my reading of the code, it looks like the retries are for
response code AP_RESPONSE_BUSY. Why wouldn't we want to wait until the
queue was not busy anymore?

> 
> [..]
> 
>>> +static int handle_pqap(struct kvm_vcpu *vcpu)
>>> +{
>>> +	uint64_t status;
>>> +	uint16_t apqn;
>>> +	struct vfio_ap_queue *q;
>>> +	struct ap_queue_status qstatus = {
>>> +			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
>>> +	struct ap_matrix_mdev *matrix_mdev;
>>> +
>>> +	/* If we do not use the AIV facility just go to userland */
>>> +	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
>>> +	mutex_lock(&matrix_dev->lock);
>>> +
>>> +	if (!vcpu->kvm->arch.crypto.pqap_hook)
>>
>> Wasn't this already checked in patch 2 prior to calling this
>> function? In fact, doesn't the hook point to this function?
>>
> 
> Let us benevolently call this defensive programming. We are actually
> in that callback AFAICT, so it sure was set a moment ago, and I guess
> the client code still holds the kvm.lock so it is guaranteed to stay
> so unless somebody is playing foul.

Defensive, but completely unnecessary; however, it doesn't negatively
affect the logic in the least.

> 
> We can address this with a patch on top.
> 
> Regards,
> Halil
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0531E7D9AB8
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbjJ0OER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346067AbjJ0OEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:04:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F61121;
        Fri, 27 Oct 2023 07:04:11 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RDl84m011431;
        Fri, 27 Oct 2023 14:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IalADPZy6OwKA855GXXZzdNew13zra2hYin9FnxFXbw=;
 b=JzgDKIQ6ukUOOef0khh/gcMIM31veZYPeCiicxxsIsxLM5Bd9M/0Mya+bRV2COJxVBUk
 tVKZb8n7GZIu4fLnzXLo2HnP5aUvQy3UQ8/v99cdyNNIXy6oAz6WWgTh+xmLGcoG2rBE
 ZCsqWgLDzDXjjhQc25KTynY34ds2xsczYOwEclWtTtEEBeautE8+aboP50D36TwdukAQ
 l4l07uEPyfoUwQoIJt61X6pVaPdg3A/1Piz3X/kczhTvpA6EGaY7HV849ID48yeFxrBQ
 e4T2m3dANJ0MY8kFd6hEvh3UBs6dn92x2LgXi7y9Rjfnfs+M8ZhSaNdSAX+xd5h9Eeax OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0ed6gqdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 14:04:10 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RDqqhw032249;
        Fri, 27 Oct 2023 14:04:03 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0ed6gpjv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 14:04:03 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RDMRfi011415;
        Fri, 27 Oct 2023 13:36:28 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqr5b2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 13:36:28 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RDaRU232506398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 13:36:27 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22C9358057;
        Fri, 27 Oct 2023 13:36:27 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 773EB58058;
        Fri, 27 Oct 2023 13:36:26 +0000 (GMT)
Received: from [9.61.149.81] (unknown [9.61.149.81])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 13:36:26 +0000 (GMT)
Message-ID: <8eb41445-1eff-4da7-830f-156f420afd5d@linux.ibm.com>
Date:   Fri, 27 Oct 2023 09:36:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-3-akrowiak@linux.ibm.com>
 <20231027125638.67a65ab9.pasic@linux.ibm.com>
Content-Language: en-US
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231027125638.67a65ab9.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zia6e2OCnLM2ntoVQEUokOnsxPZTKmXZ
X-Proofpoint-ORIG-GUID: EeR8L-j4HwpOWjkWymnCN6owk7NETxmh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_12,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/23 06:56, Halil Pasic wrote:
> On Wed, 18 Oct 2023 09:38:24 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> From: Anthony Krowiak <akrowiak@linux.ibm.com>
>>
>> The interception handler for the PQAP(AQIC) command calls the
>> kvm_s390_gisc_register function to register the guest ISC with the channel
>> subsystem. If that call fails, the status response code 08 - indicating
>> Invalid ZONE/GISA designation - is returned to the guest. This response
>> code does not make sense because the non-zero return code from the
>> kvm_s390_gisc_register function can be due one of two things: Either the
>> ISC passed as a parameter by the guest to the PQAP(AQIC) command is greater
>> than the maximum ISC value allowed, or the guest is not using a GISA.
> 
> The "ISC passed as a parameter by the guest to the PQAP(AQIC) command is
> greater than the maximum ISC value allowed" is not possible. The isc is
> 3 bits wide and all 8 values that can be represented on 3 bits are valid.
> 
> This is only possible if the hypervisor was to mess up, or if the machine
> was broken.

kvm_s390_gisc_register(struct kvm *kvm, u32 gisc)
{
	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;

	if (!gi->origin)
		return -ENODEV;
	if (gisc > MAX_ISC)
		return -ERANGE;
...

Just quoting what is in the code.
> 
>>
>> Since this scenario is very unlikely to happen and there is no status
>> response code to indicate an invalid ISC value, let's set the
>> response code to 06 indicating 'Invalid address of AP-queue notification
>> byte'. While this is not entirely accurate, it is better than indicating
>> that the ZONE/GISA designation is invalid which is something the guest
>> can do nothing about since those values are set by the hypervisor.
>>
>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> 
> 
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 9cb28978c186..25d7ce2094f8 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
>>    * Register the guest ISC to GIB interface and retrieve the
>>    * host ISC to issue the host side PQAP/AQIC
>>    *
>> - * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
>> - * vfio_pin_pages failed.
>> + * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in case the
>> + * vfio_pin_pages or kvm_s390_gisc_register failed.
>>    *
>>    * Otherwise return the ap_queue_status returned by the ap_aqic(),
>>    * all retry handling will be done by the guest.
>> @@ -458,7 +458,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>>   				 __func__, nisc, isc, q->apqn);
>>   
>>   		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>> -		status.response_code = AP_RESPONSE_INVALID_GISA;
>> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
>>   		return status;
>>   	}
>>   
> 
